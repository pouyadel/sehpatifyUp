<?php

namespace App\Http\Controllers;

use App\Models\Album;
use App\Models\Artist;
use App\Models\Genre;
use App\Models\Playlist;
use App\Models\Track;
use App\Models\User;
use App\Services\AudioMetadataService;
use App\Services\SpreadsheetReader;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class TrackController extends Controller
{
    private function formatTrack(Track $track): Track
    {
        $track->stream_url = $track->audio_path ? url("/api/tracks/{$track->id}/stream") : null;
        $track->is_published = (bool) ($track->audio_path && ($track->is_published ?? true));

        $artists = $track->artists;
        if ($artists->isNotEmpty()) {
            $track->artist = $artists->pluck('name')->join(' & ');
            $track->artist_ids = $artists->pluck('id')->toArray();

            $artistKeywords = $artists->pluck('search_keywords')->filter()->join(' ');
            $track->search_keywords = trim(($track->search_keywords ?? '') . ' ' . $artistKeywords);
        } else {
            $track->artist_ids = $track->artist_id ? [$track->artist_id] : [];
        }

        return $track;
    }

    // ۱. لیست آهنگ‌های منتشرشده برای پلیر عمومی سایت (پیش‌نویس‌ها نمایش داده نمی‌شوند)
    public function index()
    {
        $tracks = Track::published()
            ->with('artists')
            ->latest()
            ->get()
            ->map(fn($track) => $this->formatTrack($track));

        return response()->json($tracks);
    }

    // ۲. لیست تمام آهنگ‌ها (منتشرشده + پیش‌نویس‌های اکسل) مخصوص پنل ادمین
    public function adminIndex()
    {
        $tracks = Track::with('artists')
            ->latest()
            ->get()
            ->map(fn($track) => $this->formatTrack($track));

        return response()->json($tracks);
    }

    // ۳. دانلود فایل نمونه اکسل (.xlsx)
    public function downloadTemplate()
    {
        $tmpPath = SpreadsheetReader::createTemplateXlsx();
        return response()->download($tmpPath, 'sehpatify_tracks_template.xlsx', [
            'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ])->deleteFileAfterSend(true);
    }

    // ۴. ایمپورت دسته‌ای اطلاعات آهنگ‌ها از فایل اکسل (.xlsx یا .csv) در حالت پیش‌نویس
    public function bulkImport(Request $request)
    {
        $request->validate([
            'excel_file' => 'required|file|max:10240',
        ], [
            'excel_file.required' => 'لطفاً فایل اکسل یا CSV را انتخاب کنید.',
        ]);

        $file = $request->file('excel_file');
        $ext = strtolower($file->getClientOriginalExtension());
        if (!in_array($ext, ['xlsx', 'csv', 'txt'], true)) {
            return response()->json([
                'message' => 'فرمت فایل باید .xlsx یا .csv باشد.'
            ], 422);
        }

        try {
            $rows = SpreadsheetReader::parse($file->getRealPath(), $ext);
        } catch (\Throwable $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        if (empty($rows)) {
            return response()->json([
                'message' => 'هیچ ردیف معتبری داخل فایل پیدا نشد. مطمئن شوید سطر اول شامل نام ستون‌ها است.'
            ], 422);
        }

        $createdCount = 0;
        $skippedCount = 0;
        $hasIsPublished = Track::hasIsPublishedColumn();

        foreach ($rows as $rowIdx => $row) {
            $pick = function (array $keys) use ($row): string {
                foreach ($keys as $k) {
                    if (isset($row[$k]) && trim($row[$k]) !== '') {
                        return trim($row[$k]);
                    }
                }
                return '';
            };

            $artistRaw = $pick(['artists', 'artist', 'خواننده', 'خوانندگان', 'هنرمند']);
            $titleRaw  = $pick(['title', 'name', 'عنوان', 'نام آهنگ', 'نام ترانه']);
            $albumRaw  = $pick(['album', 'آلبوم', 'نام آلبوم']);
            $genreRaw  = $pick(['genre', 'سبک', 'ژانر']) ?: 'پاپ مدرن';
            $kwRaw     = $pick(['search_keywords', 'keywords', 'کلمات کلیدی']);
            $coverRaw  = $pick(['cover_url', 'cover', 'کاور']);
            $losslessRaw = mb_strtolower($pick(['is_lossless', 'lossless', 'quality', 'کیفیت']), 'UTF-8');
            $lyricsRaw = $pick(['lyrics', 'لیریکس', 'متن']);

            if ($artistRaw === '' && $titleRaw === '') {
                $skippedCount++;
                continue;
            }

            // تفکیک چند خواننده (فیت) با , یا & یا ،
            $artistNames = array_values(array_filter(array_map('trim', preg_split('/[,&،]+/u', $artistRaw ?: 'نامشخص'))));
            $artistModels = collect();

            foreach ($artistNames as $aName) {
                $existing = Artist::whereRaw('LOWER(name) = ?', [mb_strtolower($aName, 'UTF-8')])->first();
                if (!$existing) {
                    $existing = Artist::create([
                        'name'      => $aName,
                        'slug'      => Str::slug($aName) ?: ('artist-' . Str::random(6)),
                        'listeners' => '۰',
                        'verified'  => false,
                    ]);
                }
                $artistModels->push($existing);
            }

            $primaryArtist = $artistModels->first();
            $genreModel = Genre::where('name', $genreRaw)->first();
            $albumModel = $albumRaw !== '' ? Album::whereRaw('LOWER(title) = ?', [mb_strtolower($albumRaw, 'UTF-8')])->first() : null;

            $isLossless = in_array($losslessRaw, ['1', 'true', 'yes', 'flac', 'بله', 'lossless'], true);

            // پردازش لیریکس (JSON یا متن LRC)
            $lyricsArr = [];
            if ($lyricsRaw !== '') {
                $decoded = json_decode($lyricsRaw, true);
                if (is_array($decoded)) {
                    $lyricsArr = $decoded;
                } else {
                    foreach (preg_split('/\r\n|\r|\n/', $lyricsRaw) as $line) {
                        if (preg_match('/\[(\d+):(\d+(?:\.\d+)?)\](.*)/', $line, $m)) {
                            $lyricsArr[] = [
                                'time' => ((int) $m[1]) * 60 + (float) $m[2],
                                'fa'   => trim($m[3]),
                                'en'   => null,
                            ];
                        }
                    }
                }
            }

            $payload = [
                'title'           => $titleRaw !== '' ? $titleRaw : ('در انتظار فایل صوتی #' . ($rowIdx + 1)),
                'artist'          => $artistModels->pluck('name')->join(' & '),
                'artist_id'       => $primaryArtist?->id,
                'album_id'        => $albumModel?->id,
                'album'           => $albumRaw !== '' ? $albumRaw : null,
                'genre'           => $genreRaw,
                'genre_id'        => $genreModel?->id,
                'duration'        => '00:00',
                'duration_sec'    => 0,
                'search_keywords' => $kwRaw !== '' ? $kwRaw : null,
                'cover'           => $coverRaw !== '' ? $coverRaw : null,
                'audio_path'      => null, // تا زمان آپلود فایل صوتی خالی می‌ماند
                'is_lossless'     => $isLossless,
                'streams'         => 0,
                'lyrics'          => $lyricsArr,
                'favorited'       => false,
            ];

            if ($hasIsPublished) {
                $payload['is_published'] = false; // در سایت نمایش داده نشود
            }

            $track = Track::create($payload);

            $syncData = [];
            foreach ($artistModels as $a) {
                $syncData[$a->id] = ['created_at' => now(), 'updated_at' => now()];
            }
            $track->artists()->sync($syncData);

            $createdCount++;
        }

        return response()->json([
            'message'       => "{$createdCount} آهنگ در حالت پیش‌نویس ثبت شد. حالا کافیست فایل صوتی هرکدام را آپلود کنید تا با کاور و عنوان خودکار در سایت منتشر شوند.",
            'created_count' => $createdCount,
            'skipped_count' => $skippedCount,
        ], 201);
    }

    // ۵. آپلود فایل صوتی برای آهنگ پیش‌نویس، استخراج خودکار عنوان و کاور و انتشار فوری در سایت
    public function publishAudio(Request $request, $id)
    {
        $track = Track::with('artists')->findOrFail($id);

        $request->validate([
            'audio_file' => 'required|file|max:102400',
            'duration'   => 'nullable|string',
            'duration_sec' => 'nullable|numeric',
        ], [
            'audio_file.required' => 'فایل صوتی انتخاب نشده است.',
        ]);

        if ($track->audio_path && Storage::disk('public')->exists($track->audio_path)) {
            Storage::disk('public')->delete($track->audio_path);
        }

        $uploadedFile = $request->file('audio_file');
        $audioPath = $uploadedFile->store('tracks', 'public');
        $fullPath = Storage::disk('public')->path($audioPath);

        // استخراج عنوان، کاور و مدت‌زمان از داخل خود فایل صوتی
        $meta = AudioMetadataService::extractAndStoreCover($fullPath, $uploadedFile->getClientOriginalName());

        $track->audio_path = $audioPath;

        if (!empty($meta['title'])) {
            $track->title = $meta['title'];
        }
        if (empty($track->album)) {
            $track->album = !empty($meta['album']) ? $meta['album'] : $track->title;
        }
        if (!empty($meta['cover_path'])) {
            $track->cover = $meta['cover_path'];
        } elseif (empty($track->cover)) {
            $track->cover = '/logo.png';
        }

        $durSec = (int) ($request->input('duration_sec') ?: ($meta['duration_sec'] ?? 0));
        if ($durSec > 0) {
            $track->duration_sec = $durSec;
            $track->duration = $request->input('duration') ?: sprintf('%02d:%02d', floor($durSec / 60), $durSec % 60);
        }

        if (Track::hasIsPublishedColumn()) {
            $track->is_published = true; // انتشار فوری در سایت
        }

        $track->save();

        return response()->json([
            'message' => "آهنگ «{$track->title}» با موفقیت آپلود و در سایت منتشر شد.",
            'track'   => $this->formatTrack($track->fresh('artists')),
        ]);
    }

    // ۶. ایجاد آهنگ تکی جدید (با استخراج خودکار عنوان و کاور از فایل صوتی)
    public function store(Request $request)
    {
        $request->validate([
            'title'           => 'nullable|string|max:255',
            'artist_id'       => 'nullable',
            'artist_ids'      => 'nullable|array',
            'album'           => 'nullable|string|max:255',
            'genre'           => 'nullable|string|max:100',
            'duration'        => 'nullable|string',
            'duration_sec'    => 'nullable|numeric',
            'search_keywords' => 'nullable|string',
            'audio_file'      => 'required|file|max:102400',
            'cover_file'      => 'nullable|image|max:10240',
            'cover_url'       => 'nullable|string',
            'is_lossless'     => 'nullable',
        ], [
            'audio_file.required' => 'فایل صوتی ترانه را انتخاب نکرده‌اید.',
        ]);

        $uploadedAudio = $request->file('audio_file');
        $audioPath = $uploadedAudio->store('tracks', 'public');
        $fullAudioPath = Storage::disk('public')->path($audioPath);

        // استخراج خودکار متادیتا (عنوان، خواننده، آلبوم، کاور و مدت‌زمان) از فایل صوتی
        $autoExtract = filter_var($request->input('auto_extract_meta', true), FILTER_VALIDATE_BOOLEAN);
        $meta = $autoExtract
            ? AudioMetadataService::extractAndStoreCover($fullAudioPath, $uploadedAudio->getClientOriginalName())
            : ['title' => null, 'artist' => null, 'album' => null, 'cover_path' => null, 'duration_sec' => null, 'duration' => null];

        // ۱. بررسی خوانندگان انتخاب‌شده از فرم
        $artistIds = array_filter((array) $request->input('artist_ids', []));
        if (empty($artistIds) && $request->filled('artist_id')) {
            $artistIds = [$request->input('artist_id')];
        }

        $artists = !empty($artistIds) ? Artist::whereIn('id', $artistIds)->get() : collect();

        // ۲. اگر خواننده از فرم انتخاب نشده بود، از تگ فایل صوتی استخراج و متصل کن
        if ($artists->isEmpty() && !empty($meta['artist'])) {
            $artistNames = array_values(array_filter(array_map('trim', preg_split('/[,&،;\/]+/u', $meta['artist']))));
            foreach ($artistNames as $aName) {
                $existing = Artist::whereRaw('LOWER(name) = ?', [mb_strtolower($aName, 'UTF-8')])->first();
                if (!$existing) {
                    $existing = Artist::create([
                        'name'      => $aName,
                        'slug'      => Str::slug($aName) ?: ('artist-' . Str::random(6)),
                        'listeners' => '۰',
                        'verified'  => false,
                    ]);
                }
                $artists->push($existing);
            }
        }

        $manualTitle = trim((string) $request->input('title', ''));
        $finalTitle = $manualTitle !== ''
            ? $manualTitle
            : ($meta['title'] ?: pathinfo($uploadedAudio->getClientOriginalName(), PATHINFO_FILENAME));

        $coverPath = null;
        if ($request->hasFile('cover_file')) {
            $coverPath = '/storage/' . $request->file('cover_file')->store('covers', 'public');
        } elseif (!empty($meta['cover_path'])) {
            $coverPath = $meta['cover_path'];
        } elseif ($request->filled('cover_url')) {
            $coverPath = $request->input('cover_url');
        }

        $durationSec = (int) ($request->input('duration_sec') ?: ($meta['duration_sec'] ?? 210));
        $duration = $request->input('duration') ?: ($meta['duration'] ?: sprintf('%02d:%02d', floor($durationSec / 60), $durationSec % 60));

        $genreName = $request->input('genre') ?: 'پاپ مدرن';
        $genreModel = Genre::where('name', $genreName)->first();

        $payload = [
            'title'           => $finalTitle,
            'artist'          => $artists->isNotEmpty() ? $artists->pluck('name')->join(' & ') : 'نامشخص',
            'artist_id'       => $artists->first()?->id,
            'album'           => $request->input('album') ?: ($meta['album'] ?: $finalTitle),
            'genre'           => $genreName,
            'genre_id'        => $genreModel?->id,
            'duration'        => $duration,
            'duration_sec'    => $durationSec,
            'search_keywords' => $request->input('search_keywords'),
            'cover'           => $coverPath ?: '/logo.png',
            'audio_path'      => $audioPath,
            'is_lossless'     => filter_var($request->input('is_lossless'), FILTER_VALIDATE_BOOLEAN),
            'streams'         => 0,
            'lyrics'          => [],
            'favorited'       => false,
        ];
        if (Track::hasIsPublishedColumn()) {
            $payload['is_published'] = true;
        }

        $track = Track::create($payload);

        if ($artists->isNotEmpty()) {
            $syncData = [];
            foreach ($artists as $a) {
                $syncData[$a->id] = ['created_at' => now(), 'updated_at' => now()];
            }
            $track->artists()->sync($syncData);
        }

        return response()->json($this->formatTrack($track->fresh('artists')), 201);
    }

    // ۷. ویرایش آهنگ موجود
    public function update(Request $request, $id)
    {
        $track = Track::findOrFail($id);

        $request->validate([
            'title'           => 'nullable|string|max:255',
            'artist_id'       => 'nullable',
            'artist_ids'      => 'nullable|array',
            'album'           => 'nullable|string|max:255',
            'genre'           => 'nullable|string|max:100',
            'duration'        => 'nullable|string',
            'duration_sec'    => 'nullable|numeric',
            'search_keywords' => 'nullable|string',
            'audio_file'      => 'nullable|file|max:102400',
            'cover_file'      => 'nullable|image|max:10240',
            'cover_url'       => 'nullable|string',
            'is_lossless'     => 'nullable',
        ]);

        $meta = [];
        if ($request->hasFile('audio_file')) {
            if ($track->audio_path && Storage::disk('public')->exists($track->audio_path)) {
                Storage::disk('public')->delete($track->audio_path);
            }
            $uploadedAudio = $request->file('audio_file');
            $track->audio_path = $uploadedAudio->store('tracks', 'public');
            $fullAudioPath = Storage::disk('public')->path($track->audio_path);
            $meta = AudioMetadataService::extractAndStoreCover($fullAudioPath, $uploadedAudio->getClientOriginalName());

            if (Track::hasIsPublishedColumn()) {
                $track->is_published = true;
            }
        }

        if ($request->hasFile('cover_file')) {
            $track->cover = '/storage/' . $request->file('cover_file')->store('covers', 'public');
        } elseif (!empty($meta['cover_path'])) {
            $track->cover = $meta['cover_path'];
        } elseif ($request->filled('cover_url')) {
            $track->cover = $request->input('cover_url');
        }

        $artistIds = $request->input('artist_ids', []);
        if (empty($artistIds) && $request->filled('artist_id')) {
            $artistIds = [$request->input('artist_id')];
        }
        if (!empty($artistIds)) {
            $artists = Artist::whereIn('id', $artistIds)->get();
            if ($artists->isNotEmpty()) {
                $track->artist_id = $artists->first()->id;
                $track->artist = $artists->pluck('name')->join(' & ');
                $syncData = [];
                foreach ($artists as $a) {
                    $syncData[$a->id] = ['created_at' => now(), 'updated_at' => now()];
                }
                $track->artists()->sync($syncData);
            }
        }

        $manualTitle = trim((string) $request->input('title', ''));
        if ($manualTitle !== '') {
            $track->title = $manualTitle;
        } elseif (!empty($meta['title'])) {
            $track->title = $meta['title'];
        }

        $track->album = $request->input('album') ?: ($track->album ?: $track->title);
        $track->genre = $request->input('genre') ?: $track->genre;
        $track->search_keywords = $request->input('search_keywords');

        if ($request->filled('duration')) $track->duration = $request->input('duration');
        elseif (!empty($meta['duration'])) $track->duration = $meta['duration'];

        if ($request->filled('duration_sec')) $track->duration_sec = (int) $request->input('duration_sec');
        elseif (!empty($meta['duration_sec'])) $track->duration_sec = (int) $meta['duration_sec'];

        if ($request->has('is_lossless')) {
            $track->is_lossless = filter_var($request->input('is_lossless'), FILTER_VALIDATE_BOOLEAN);
        }

        $track->save();
        return response()->json($this->formatTrack($track->fresh('artists')));
    }

    // ۸. استریم فایل صوتی با پشتیبانی از Seek
    public function stream($id)
    {
        $track = Track::findOrFail($id);

        if (empty($track->audio_path)) {
            return response()->json(['message' => 'فایل صوتی برای این قطعه آپلود نشده است.'], 404);
        }

        $cleanPath = ltrim(str_replace('/storage/', '', $track->audio_path), '/');
        $fullPath = Storage::disk('public')->path($cleanPath);

        if (!is_file($fullPath) || !file_exists($fullPath)) {
            $fallbackPath = storage_path('app/public/' . $cleanPath);
            if (is_file($fallbackPath) && file_exists($fallbackPath)) {
                $fullPath = $fallbackPath;
            } else {
                return response()->json(['message' => 'فایل فیزیکی روی سرور یافت نشد.'], 404);
            }
        }

        $track->increment('streams');

        return response()->file($fullPath, [
            'Content-Type'  => mime_content_type($fullPath) ?: 'audio/mpeg',
            'Accept-Ranges' => 'bytes',
        ]);
    }

    public function saveLyrics(Request $request, $id)
    {
        $request->validate(['lyrics' => 'present|array']);
        $track = Track::findOrFail($id);
        $track->lyrics = $request->lyrics;
        $track->save();

        return response()->json([
            'message' => 'متن ترانه با موفقیت در دیتابیس ذخیره شد',
            'track'   => $track
        ]);
    }

    public function toggleFavorite($id)
    {
        $track = Track::findOrFail($id);
        $track->favorited = !$track->favorited;
        $track->save();

        return response()->json(['favorited' => $track->favorited]);
    }

    public function destroy($id)
    {
        $track = Track::findOrFail($id);

        if ($track->audio_path && Storage::disk('public')->exists($track->audio_path)) {
            Storage::disk('public')->delete($track->audio_path);
        }

        $track->artists()->detach();
        $track->delete();

        return response()->json(['message' => 'قطعه صوتی با موفقیت حذف شد']);
    }

    public function dashboardStats()
    {
        $totalTracks = Track::published()->count();
        $draftTracks = Track::drafts()->count();

        $syncedLyrics = Track::published()
            ->whereNotNull('lyrics')
            ->where('lyrics', '!=', '[]')
            ->where('lyrics', '!=', '')
            ->count();

        $totalStreams = (int) Track::sum('streams');
        $totalArtists = Artist::count();
        $totalPlaylists = Playlist::count();
        $totalUsers = User::count();

        $lyricsCoverage = $totalTracks > 0 ? round(($syncedLyrics / $totalTracks) * 100) : 0;

        $liveTracks = Track::published()
            ->orderBy('streams', 'desc')
            ->take(4)
            ->get(['id', 'title', 'artist', 'cover', 'genre', 'streams', 'is_lossless']);

        return response()->json([
            'total_tracks'    => $totalTracks,
            'draft_tracks'    => $draftTracks,
            'synced_lyrics'   => $syncedLyrics,
            'lyrics_coverage' => $lyricsCoverage,
            'total_streams'   => $totalStreams,
            'total_artists'   => $totalArtists,
            'total_playlists' => $totalPlaylists,
            'total_users'     => $totalUsers > 0 ? $totalUsers : 4,
            'live_tracks'     => $liveTracks,
        ]);
    }
}