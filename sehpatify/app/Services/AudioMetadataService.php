<?php

namespace App\Services;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class AudioMetadataService
{
    /**
     * استخراج عنوان، کاور و مدت‌زمان از فایل صوتی (پشتیبانی از MP3, M4A/MP4, FLAC و getID3)
     */
    public static function extractAndStoreCover(string $fullPath, string $originalName = ''): array
    {
        $meta = [
         'title'        => null,
         'artist'       => null,
         'album'        => null,
         'duration_sec' => null,
         'duration'     => null,
         'cover_path'   => null,
     ];

     $coverData = null;
     $coverMime = 'image/jpeg';

     // ۱. اگر پکیج getID3 نصب شده باشد اولویت با آن است
     if (class_exists(\getID3::class) && is_file($fullPath)) {
         $getID3 = new \getID3();
         $info = $getID3->analyze($fullPath);
         \getid3_lib::CopyTagsToComments($info);

         $meta['title'] = $info['comments']['title'][0] ?? null;
         $meta['artist'] = $info['comments']['artist'][0] ?? null;
         $meta['album'] = $info['comments']['album'][0] ?? null;
         if (!empty($info['playtime_seconds'])) {
             $meta['duration_sec'] = (int) round($info['playtime_seconds']);
         }
         if (!empty($info['comments']['picture'][0]['data'])) {
             $coverData = $info['comments']['picture'][0]['data'];
             $coverMime = $info['comments']['picture'][0]['image_mime'] ?? 'image/jpeg';
         }
     } elseif (is_file($fullPath)) {
         // ۲. پارسر بومی بدون وابستگی برای MP3، M4A/MP4 و FLAC
         $header = file_get_contents($fullPath, false, null, 0, 16) ?: '';
         $ext = strtolower(pathinfo($originalName ?: $fullPath, PATHINFO_EXTENSION));

         if (str_starts_with($header, 'ID3') || $ext === 'mp3') {
             $parsed = self::parseId3v2($fullPath);
             $meta['title'] = $parsed['title'] ?? null;
             $meta['artist'] = $parsed['artist'] ?? null;
             $meta['album'] = $parsed['album'] ?? null;
             $coverData = $parsed['cover_data'] ?? null;
             $coverMime = $parsed['cover_mime'] ?? 'image/jpeg';
         } elseif (str_starts_with($header, 'fLaC') || $ext === 'flac') {
             $parsed = self::parseFlac($fullPath);
             $meta['title'] = $parsed['title'] ?? null;
             $meta['artist'] = $parsed['artist'] ?? null;
             $meta['album'] = $parsed['album'] ?? null;
             $meta['duration_sec'] = $parsed['duration_sec'] ?? null;
             $coverData = $parsed['cover_data'] ?? null;
             $coverMime = $parsed['cover_mime'] ?? 'image/jpeg';
         } elseif (str_contains(substr($header, 4, 8), 'ftyp') || in_array($ext, ['m4a', 'mp4', 'aac'])) {
             $parsed = self::parseMp4($fullPath);
             $meta['title'] = $parsed['title'] ?? null;
             $meta['artist'] = $parsed['artist'] ?? null;
             $meta['album'] = $parsed['album'] ?? null;
             $meta['duration_sec'] = $parsed['duration_sec'] ?? null;
             $coverData = $parsed['cover_data'] ?? null;
             $coverMime = $parsed['cover_mime'] ?? 'image/jpeg';
         }
     }

        // ذخیره کاور استخراج‌شده در public/covers
        if ($coverData && strlen($coverData) > 100) {
            $ext = self::detectImageExtension($coverData, $coverMime);
            $filename = Str::random(40) . '.' . $ext;
            Storage::disk('public')->put('covers/' . $filename, $coverData);
            $meta['cover_path'] = '/storage/covers/' . $filename;
        }

        // اگر تگ عنوان در فایل نبود، از نام خود فایل (بدون پسوند) استفاده می‌کنیم
        if (empty(trim((string) $meta['title'])) && $originalName !== '') {
            $cleanName = pathinfo($originalName, PATHINFO_FILENAME);
            $cleanName = preg_replace('/^\d+[\s._-]+/', '', $cleanName);
            $meta['title'] = trim(str_replace('_', ' ', $cleanName));
        } else {
            $meta['title'] = trim((string) $meta['title']);
        }

        if ($meta['duration_sec'] && $meta['duration_sec'] > 0) {
            $meta['duration'] = sprintf('%02d:%02d', floor($meta['duration_sec'] / 60), $meta['duration_sec'] % 60);
        }

        return $meta;
    }

    private static function detectImageExtension(string $bytes, string $mime): string
    {
        if (str_starts_with($bytes, "\x89PNG")) return 'png';
        if (str_starts_with($bytes, "RIFF") && substr($bytes, 8, 4) === 'WEBP') return 'webp';
        if (str_contains(strtolower($mime), 'png')) return 'png';
        if (str_contains(strtolower($mime), 'webp')) return 'webp';
        return 'jpg';
    }

    private static function decodeId3Text(int $encoding, string $raw): string
    {
        if ($encoding === 0) {
            $text = @mb_convert_encoding($raw, 'UTF-8', 'ISO-8859-1');
        } elseif ($encoding === 1) {
            if (str_starts_with($raw, "\xFF\xFE")) {
                $text = @mb_convert_encoding(substr($raw, 2), 'UTF-8', 'UTF-16LE');
            } elseif (str_starts_with($raw, "\xFE\xFF")) {
                $text = @mb_convert_encoding(substr($raw, 2), 'UTF-8', 'UTF-16BE');
            } else {
                $text = @mb_convert_encoding($raw, 'UTF-8', 'UTF-16');
            }
        } elseif ($encoding === 2) {
            $text = @mb_convert_encoding($raw, 'UTF-8', 'UTF-16BE');
        } else {
            $text = $raw;
        }
        return trim(str_replace("\0", '', (string) $text));
    }

    private static function parseId3v2(string $filePath): array
    {
        $res = [];
        $fp = fopen($filePath, 'rb');
        if (!$fp) return $res;

        $head = fread($fp, 10);
        if (strlen($head) < 10 || substr($head, 0, 3) !== 'ID3') {
            fclose($fp);
            return $res;
        }

        $version = ord($head[3]);
        $tagSize = ((ord($head[6]) & 0x7F) << 21)
                 | ((ord($head[7]) & 0x7F) << 14)
                 | ((ord($head[8]) & 0x7F) << 7)
                 | (ord($head[9]) & 0x7F);

        $tagData = fread($fp, min($tagSize, 12 * 1024 * 1024));
        fclose($fp);

        $pos = 0;
        $len = strlen($tagData);
        $headerLen = ($version === 2) ? 6 : 10;

        while ($pos + $headerLen <= $len) {
            if ($tagData[$pos] === "\0") break;

            if ($version === 2) {
                $frameId = substr($tagData, $pos, 3);
                $frameSize = (ord($tagData[$pos + 3]) << 16) | (ord($tagData[$pos + 4]) << 8) | ord($tagData[$pos + 5]);
            } else {
                $frameId = substr($tagData, $pos, 4);
                if ($version === 4) {
                    $frameSize = ((ord($tagData[$pos + 4]) & 0x7F) << 21)
                               | ((ord($tagData[$pos + 5]) & 0x7F) << 14)
                               | ((ord($tagData[$pos + 6]) & 0x7F) << 7)
                               | (ord($tagData[$pos + 7]) & 0x7F);
                } else {
                    $frameSize = unpack('N', substr($tagData, $pos + 4, 4))[1];
                }
            }

            if ($frameSize <= 0 || $pos + $headerLen + $frameSize > $len) break;
            $body = substr($tagData, $pos + $headerLen, $frameSize);
            $pos += $headerLen + $frameSize;

            if (in_array($frameId, ['TIT2', 'TT2'])) {
                $res['title'] = self::decodeId3Text(ord($body[0]), substr($body, 1));
            } elseif (in_array($frameId, ['TALB', 'TAL'])) {
                $res['album'] = self::decodeId3Text(ord($body[0]), substr($body, 1));
            } elseif ($frameId === 'APIC' && empty($res['cover_data'])) {
                $enc = ord($body[0]);
                $mimeEnd = strpos($body, "\0", 1);
                if ($mimeEnd !== false) {
                    $mime = substr($body, 1, $mimeEnd - 1);
                    $cursor = $mimeEnd + 2; // رد کردن null و نوع تصویر
                    if ($enc === 1 || $enc === 2) {
                        $descEnd = strpos($body, "\0\0", $cursor);
                        $imgStart = ($descEnd !== false) ? $descEnd + 2 : $cursor;
                        if (isset($body[$imgStart]) && $body[$imgStart] === "\0") $imgStart++;
                    } else {
                        $descEnd = strpos($body, "\0", $cursor);
                        $imgStart = ($descEnd !== false) ? $descEnd + 1 : $cursor;
                    }
                    $res['cover_mime'] = $mime ?: 'image/jpeg';
                    $res['cover_data'] = substr($body, $imgStart);
                }
            } elseif (in_array($frameId, ['TPE1', 'TP1'])) {
                $res['artist'] = self::decodeId3Text(ord($body[0]), substr($body, 1));
            } elseif ($frameId === 'PIC' && empty($res['cover_data'])) {
                $enc = ord($body[0]);
                $fmt = strtolower(substr($body, 1, 3));
                $cursor = 5;
                $descEnd = ($enc === 1 || $enc === 2) ? strpos($body, "\0\0", $cursor) : strpos($body, "\0", $cursor);
                $imgStart = ($descEnd !== false) ? $descEnd + (($enc === 1 || $enc === 2) ? 2 : 1) : $cursor;
                $res['cover_mime'] = ($fmt === 'png') ? 'image/png' : 'image/jpeg';
                $res['cover_data'] = substr($body, $imgStart);
            }
        }

        return $res;
    }

    private static function parseMp4(string $filePath): array
    {
        $res = [];
        $size = filesize($filePath);
        if (!$size) return $res;

        $fp = fopen($filePath, 'rb');
        if (!$fp) return $res;

        self::scanMp4Atoms($fp, 0, $size, $res);
        fclose($fp);
        return $res;
    }

    private static function scanMp4Atoms($fp, int $start, int $end, array &$res): void
    {
        $containers = ['moov', 'udta', 'meta', 'ilst'];
        $pos = $start;

        while ($pos + 8 <= $end) {
            fseek($fp, $pos);
            $hdr = fread($fp, 8);
            if (strlen($hdr) < 8) break;

            $atomSize = unpack('N', substr($hdr, 0, 4))[1];
            $atomType = substr($hdr, 4, 4);
            $headerLen = 8;

            if ($atomSize === 1 && $pos + 16 <= $end) {
                $ext = fread($fp, 8);
                $parts = unpack('N2', $ext);
                $atomSize = ($parts[1] << 32) | $parts[2];
                $headerLen = 16;
            } elseif ($atomSize === 0) {
                $atomSize = $end - $pos;
            }

            if ($atomSize < $headerLen || $pos + $atomSize > $end) break;

            if (in_array($atomType, $containers, true)) {
                $childStart = $pos + $headerLen + ($atomType === 'meta' ? 4 : 0);
                self::scanMp4Atoms($fp, $childStart, $pos + $atomSize, $res);
            } elseif ($atomType === 'mvhd' && empty($res['duration_sec'])) {
                fseek($fp, $pos + $headerLen);
                $buf = fread($fp, min(36, $atomSize - $headerLen));
                if (strlen($buf) >= 20) {
                    $ver = ord($buf[0]);
                    if ($ver === 0 && strlen($buf) >= 20) {
                        $timescale = unpack('N', substr($buf, 12, 4))[1];
                        $duration = unpack('N', substr($buf, 16, 4))[1];
                        if ($timescale > 0) $res['duration_sec'] = (int) round($duration / $timescale);
                    }
                }
            } elseif (in_array($atomType, ["\xA9nam", "\xA9alb", "\xA9ART", 'covr'], true)) {
                $dataPayload = self::readMp4DataAtom($fp, $pos + $headerLen, $pos + $atomSize);
                if ($dataPayload !== null) {
                    if ($atomType === "\xA9nam") $res['title'] = trim($dataPayload);
                    elseif ($atomType === "\xA9alb") $res['album'] = trim($dataPayload);
                    elseif ($atomType === "\xA9ART") $res['artist'] = trim($dataPayload);
                    elseif ($atomType === 'covr' && empty($res['cover_data'])) {
                        $res['cover_data'] = $dataPayload;
                        $res['cover_mime'] = str_starts_with($dataPayload, "\x89PNG") ? 'image/png' : 'image/jpeg';
                    }
                }
            }

            $pos += $atomSize;
        }
    }

    private static function readMp4DataAtom($fp, int $start, int $end): ?string
    {
        $pos = $start;
        while ($pos + 8 <= $end) {
            fseek($fp, $pos);
            $hdr = fread($fp, 8);
            if (strlen($hdr) < 8) break;
            $sz = unpack('N', substr($hdr, 0, 4))[1];
            $tp = substr($hdr, 4, 4);
            if ($sz < 8 || $pos + $sz > $end) break;
            if ($tp === 'data' && $sz > 16) {
                fseek($fp, $pos + 16);
                return fread($fp, min($sz - 16, 10 * 1024 * 1024)) ?: null;
            }
            $pos += $sz;
        }
        return null;
    }

    private static function parseFlac(string $filePath): array
    {
        $res = [];
        $fp = fopen($filePath, 'rb');
        if (!$fp) return $res;

        if (fread($fp, 4) !== 'fLaC') {
            fclose($fp);
            return $res;
        }

        while (!feof($fp)) {
            $hdr = fread($fp, 4);
            if (strlen($hdr) < 4) break;
            $b0 = ord($hdr[0]);
            $isLast = ($b0 & 0x80) !== 0;
            $type = $b0 & 0x7F;
            $length = (ord($hdr[1]) << 16) | (ord($hdr[2]) << 8) | ord($hdr[3]);
            $data = ($length > 0 && $length <= 12 * 1024 * 1024) ? fread($fp, $length) : '';

            if ($type === 0 && strlen($data) >= 18) { // STREAMINFO
                $sampleRate = (ord($data[10]) << 12) | (ord($data[11]) << 4) | (ord($data[12]) >> 4);
                $totalSamples = ((ord($data[13]) & 0x0F) << 32) | unpack('N', substr($data, 14, 4))[1];
                if ($sampleRate > 0) $res['duration_sec'] = (int) round($totalSamples / $sampleRate);
            } elseif ($type === 4 && strlen($data) > 8) { // VORBIS_COMMENT
                $vendorLen = unpack('V', substr($data, 0, 4))[1];
                $pos = 4 + $vendorLen;
                if ($pos + 4 <= strlen($data)) {
                    $count = unpack('V', substr($data, $pos, 4))[1];
                    $pos += 4;
                    for ($i = 0; $i < $count && $pos + 4 <= strlen($data); $i++) {
                        $cLen = unpack('V', substr($data, $pos, 4))[1];
                        $pos += 4;
                        $entry = substr($data, $pos, $cLen);
                        $pos += $cLen;
                        if (stripos($entry, 'TITLE=') === 0) $res['title'] = trim(substr($entry, 6));
                        if (stripos($entry, 'ALBUM=') === 0) $res['album'] = trim(substr($entry, 6));
                        if (stripos($entry, 'ARTIST=') === 0) $res['artist'] = trim(substr($entry, 7));
                    }
                }
            } elseif ($type === 6 && empty($res['cover_data']) && strlen($data) > 32) { // PICTURE
                $pos = 4;
                $mimeLen = unpack('N', substr($data, $pos, 4))[1];
                $pos += 4;
                $mime = substr($data, $pos, $mimeLen);
                $pos += $mimeLen;
                $descLen = unpack('N', substr($data, $pos, 4))[1];
                $pos += 4 + $descLen + 16; // width, height, depth, colors
                if ($pos + 4 <= strlen($data)) {
                    $imgLen = unpack('N', substr($data, $pos, 4))[1];
                    $pos += 4;
                    $res['cover_mime'] = $mime ?: 'image/jpeg';
                    $res['cover_data'] = substr($data, $pos, $imgLen);
                }
            }

            if ($isLast) break;
        }

        fclose($fp);
        return $res;
    }
}