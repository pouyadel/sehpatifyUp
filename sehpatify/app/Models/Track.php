<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Schema;

class Track extends Model
{
    use HasFactory;
    protected $guarded = [];

    protected $casts = [
        'is_lossless'  => 'boolean',
        'favorited'    => 'boolean',
        'is_published' => 'boolean',
        'lyrics'       => 'array',
        'duration_sec' => 'integer',
        'streams'      => 'integer',
    ];

    protected static ?bool $hasPublishedColumn = null;

    public static function hasIsPublishedColumn(): bool
    {
        if (self::$hasPublishedColumn === null) {
            self::$hasPublishedColumn = Schema::hasColumn('tracks', 'is_published');
        }
        return self::$hasPublishedColumn;
    }

    // فقط آهنگ‌های منتشرشده و دارای فایل صوتی (برای نمایش عمومی در سایت)
    public function scopePublished($query)
    {
        $query->whereNotNull('audio_path')
              ->where('audio_path', '!=', '');

        if (self::hasIsPublishedColumn()) {
            $query->where('is_published', true);
        }

        return $query;
    }

    // آهنگ‌های پیش‌نویس (ایمپورت‌شده از اکسل و در انتظار آپلود فایل صوتی)
    public function scopeDrafts($query)
    {
        return $query->where(function ($q) {
            $q->whereNull('audio_path')
              ->orWhere('audio_path', '');
            if (self::hasIsPublishedColumn()) {
                $q->orWhere('is_published', false);
            }
        });
    }

    // اضافه شدن خودکار آدرس استریم به خروجی JSON
    protected $appends = ['stream_url'];

    public function getStreamUrlAttribute()
    {
        return $this->audio_path ? url("/api/tracks/{$this->id}/stream") : null;
    }

    public function playlists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_track');
    }

    public function artistRef()
    {
        return $this->belongsTo(Artist::class, 'artist_id');
    }

    public function artists()
    {
        return $this->belongsToMany(Artist::class, 'artist_track')->withTimestamps();
    }

    // خواننده اصلی (برای سازگاری با کدهای قبلی)
    public function artist()
    {
        return $this->belongsTo(Artist::class, 'artist_id');
    }
}