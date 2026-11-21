-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2026 at 05:43 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sehpatify_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `albums`
--

CREATE TABLE `albums` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `artist_id` bigint(20) UNSIGNED DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `release_year` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `search_keywords` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `albums`
--

INSERT INTO `albums` (`id`, `title`, `artist_id`, `genre`, `release_year`, `cover`, `description`, `search_keywords`, `created_at`, `updated_at`) VALUES
(1, 'بسسمنتببمنیت', 7, 'رپ و هیپ‌هاپ', '2022', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500', NULL, NULL, '2026-10-12 11:18:37', '2026-10-12 11:18:52');

-- --------------------------------------------------------

--
-- Table structure for table `artists`
--

CREATE TABLE `artists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `listeners` varchar(255) NOT NULL DEFAULT '۰',
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `search_keywords` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `artists`
--

INSERT INTO `artists` (`id`, `name`, `slug`, `genre`, `listeners`, `verified`, `image`, `bio`, `search_keywords`, `created_at`, `updated_at`) VALUES
(6, 'blackfield', 'blackfield', NULL, '۳۸.۶m', 1, '/storage/artists/vfJCnrUlwha3bXxvAbmPphpUr6MBUeSuNAH9nc5x.jpg', NULL, NULL, '2026-10-07 15:58:52', '2026-10-07 16:33:07'),
(7, 'Queen', 'queen', NULL, '۸۱.۴m', 1, '/storage/artists/OVedR4iAwthoM5w3tBdCiiPe7ggHm9lKeR2BZob4.jpg', NULL, NULL, '2026-10-07 16:36:46', '2026-10-07 16:36:46'),
(8, 'Pink Floyd', 'pink-floyd', NULL, '۵۰۰,۰۰۰', 1, '/storage/artists/MG4w97eYAlxAbVemNMokd3NVdUC4rheXwP2aX5Xj.webp', NULL, NULL, '2026-10-08 10:33:35', '2026-10-08 10:33:35'),
(9, 'System Of A Down', 'system-of-a-down', NULL, '۵۰۰,۰۰۰', 1, '/storage/artists/uTpG7u6aq3o8xlknJM2YQbHPdPTjyDnxIrV2G1G5.jpg', NULL, NULL, '2026-10-08 10:34:39', '2026-10-08 10:34:39');

-- --------------------------------------------------------

--
-- Table structure for table `artist_genre`
--

CREATE TABLE `artist_genre` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `artist_id` bigint(20) UNSIGNED NOT NULL,
  `genre_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `artist_genre`
--

INSERT INTO `artist_genre` (`id`, `artist_id`, `genre_id`, `created_at`, `updated_at`) VALUES
(5, 6, 1, NULL, NULL),
(6, 7, 1, NULL, NULL),
(7, 7, 3, NULL, NULL),
(8, 7, 7, NULL, NULL),
(9, 8, 7, NULL, NULL),
(10, 9, 4, NULL, NULL),
(11, 9, 3, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `artist_track`
--

CREATE TABLE `artist_track` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `track_id` bigint(20) UNSIGNED NOT NULL,
  `artist_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `artist_track`
--

INSERT INTO `artist_track` (`id`, `track_id`, `artist_id`, `created_at`, `updated_at`) VALUES
(1, 7, 6, '2026-10-11 18:47:01', '2026-10-11 18:47:01'),
(2, 8, 7, '2026-10-11 20:26:12', '2026-10-11 20:26:12'),
(3, 10, 7, '2026-10-11 20:30:16', '2026-10-11 20:30:16');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('sehpatify-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:4;', 1791989170),
('sehpatify-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1791989170;', 1791989170);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `genres`
--

CREATE TABLE `genres` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `genres`
--

INSERT INTO `genres` (`id`, `name`, `cover`, `slug`, `created_at`, `updated_at`) VALUES
(1, 'پاپ مدرن', '/storage/genres/ZiCJaNZ0vkeDCaIDAh9UqX4EaI5SebN4NLmOQFPM.jpg', 'pap-mdrn', '2026-10-06 07:18:34', '2026-10-12 15:29:07'),
(3, 'تلفیقی و الکترونیک', NULL, 'electronic-fusion', '2026-10-06 07:18:34', '2026-10-06 07:18:34'),
(4, 'آلترناتیو و راک', NULL, 'rock', '2026-10-06 07:18:34', '2026-10-06 07:18:34'),
(5, 'رپ و هیپ‌هاپ', NULL, 'rap', '2026-10-06 07:18:34', '2026-10-06 07:18:34'),
(6, 'امبینت و ریلکس', NULL, 'ambient', '2026-10-06 07:18:34', '2026-10-06 07:18:34'),
(7, 'کلاسیک ایرانی', NULL, 'classical', '2026-10-06 07:18:34', '2026-10-06 07:18:34'),
(8, 'بلوز و جاز', NULL, 'jazz', '2026-10-06 07:18:34', '2026-10-06 07:18:34');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_03_130014_create_artists_table', 1),
(5, '2026_10_03_130014_create_tracks_table', 1),
(6, '2026_10_03_130018_create_playlists_table', 1),
(7, '2026_10_03_130421_create_personal_access_tokens_table', 2),
(8, '2026_10_03_164731_create_playlist_track_table', 3),
(9, '2026_10_06_104407_create_genres_and_artist_genre_tables', 4),
(10, '2026_10_06_124105_add_status_and_role_to_users_table', 5),
(11, '2026_10_08_212421_add_genre_id_to_tracks_table', 6),
(12, '2026_10_11_221617_create_artist_track_table', 7),
(13, '2026_10_11_233453_add_search_keywords_to_tracks_and_artists_tables', 8),
(14, '2026_10_12_001651_create_albums_and_update_tracks_table', 9),
(15, '2026_10_12_185032_add_cover_to_genres_table', 10),
(16, '2026_10_13_233519_add_username_and_phone_to_users_table', 11),
(17, '2026_10_14_131624_add_user_id_and_is_public_to_playlists_table', 12);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `playlists`
--

CREATE TABLE `playlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `desc` text DEFAULT NULL,
  `count` varchar(255) NOT NULL DEFAULT '۰ قطعه',
  `cover` text DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `playlists`
--

INSERT INTO `playlists` (`id`, `user_id`, `title`, `desc`, `count`, `cover`, `is_public`, `created_at`, `updated_at`) VALUES
(1, NULL, 'شب‌های بی‌خوابی', 'نواهای دلنشین برای رانندگی شبانه و آرامش پایتخت', '2 قطعه', '/storage/playlist_covers/pbR4PAFzCHWjPEmRTSyHJU3cbTk5DSXHi1L9s7Xm.webp', 1, '2026-10-03 09:33:28', '2026-10-08 10:30:22'),
(3, NULL, 'جاده‌ی خیس', 'نواهای دلنشین برای رانندگی شبانه و آرامش پایتخت', '1 قطعه', '/storage/playlist_covers/wCaqjr0GavP9bS7JrsulYlkAKn5ErJxyvmv9p5be.jpg', 1, '2026-10-08 10:30:48', '2026-10-11 18:31:06'),
(4, NULL, 'جاده‌ی خیس', 'کالکشن اختصاصی استودیو سهپاتیفای', '0 قطعه', '/storage/playlist_covers/yyQKPSdF6BdGIraaJ4GLqcXTjfGO4hFRMvfoOYMl.jpg', 1, '2026-10-08 10:31:18', '2026-10-08 10:31:18'),
(5, NULL, 'حالِ خوب', 'کالکشن اختصاصی استودیو سهپاتیفای', '0 قطعه', '/storage/playlist_covers/0Mk48nVVBc5uzTuKysDxuK8QqFu0JZkVCDyIlwYa.jpg', 1, '2026-10-08 10:31:42', '2026-10-08 10:31:42'),
(6, 4, 'تست', 'تست', '۰ قطعه', '/storage/playlists/UH7eKo7SzxxTOqH79iVig1wR7gB9T6hOeiOYqDZW.webp', 0, '2026-10-14 10:02:30', '2026-10-14 10:03:34');

-- --------------------------------------------------------

--
-- Table structure for table `playlist_track`
--

CREATE TABLE `playlist_track` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `playlist_id` bigint(20) UNSIGNED NOT NULL,
  `track_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `playlist_track`
--

INSERT INTO `playlist_track` (`id`, `playlist_id`, `track_id`, `created_at`, `updated_at`) VALUES
(3, 1, 8, NULL, NULL),
(4, 1, 7, NULL, NULL),
(5, 3, 10, NULL, NULL),
(6, 6, 10, '2026-10-14 10:02:30', '2026-10-14 10:02:30'),
(7, 6, 7, '2026-10-14 10:02:30', '2026-10-14 10:02:30');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('iVg4Cmuht7HUBAvBEO1LFqcWEB0HEZuuJGrLoagO', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36 Edg/155.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiVzl5ZGFJdVpVenBqcUF5cG1OMVhra2tSVzNyVVdlTkZtMDY1dmtiTSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvcGxheWxpc3RzLzYiO3M6NToicm91dGUiO047fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjQ7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6IjQ3ZTU4MTVmYmRkYzE5Y2I1ZTViZWVhMTc1ZmYwZmQ4ZmFhNWVhZmU3YThiOGM2MWViM2VlOTllZjVmZjQ5ZjIiO30=', 1791991819);

-- --------------------------------------------------------

--
-- Table structure for table `tracks`
--

CREATE TABLE `tracks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `artist` varchar(255) NOT NULL,
  `artist_id` bigint(20) UNSIGNED DEFAULT NULL,
  `album_id` bigint(20) UNSIGNED DEFAULT NULL,
  `album` varchar(255) DEFAULT NULL,
  `duration` varchar(255) NOT NULL DEFAULT '03:30',
  `duration_sec` int(10) UNSIGNED NOT NULL DEFAULT 210,
  `cover` text DEFAULT NULL,
  `audio_path` varchar(255) DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `search_keywords` text DEFAULT NULL,
  `mood` varchar(255) DEFAULT NULL,
  `is_lossless` tinyint(1) NOT NULL DEFAULT 1,
  `streams` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `lyrics` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`lyrics`)),
  `favorited` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `genre_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tracks`
--

INSERT INTO `tracks` (`id`, `title`, `artist`, `artist_id`, `album_id`, `album`, `duration`, `duration_sec`, `cover`, `audio_path`, `genre`, `search_keywords`, `mood`, `is_lossless`, `streams`, `lyrics`, `favorited`, `created_at`, `updated_at`, `genre_id`) VALUES
(7, 'Pain', 'blackfield', 6, NULL, 'Pain', '03:48', 228, '/storage/covers/0Fu4GRn7adSFfdKYCfxvwpEELHPTDyIaTbyO8oO5.jpg', 'tracks/3a4rqx3Kctwbi9qZaxPlebXcetq19O24neYCJnK6.m4a', 'پاپ مدرن', NULL, NULL, 0, 53, '[{\"time\":0,\"fa\":null,\"en\":null},{\"time\":12.81,\"fa\":\"Here I\'m standing on the sea shore\",\"en\":\"\\u0627\\u06cc\\u0646\\u062c\\u0627 \\u0631\\u0648\\u06cc \\u0633\\u0627\\u062d\\u0644 \\u062f\\u0631\\u06cc\\u0627 \\u0627\\u06cc\\u0633\\u062a\\u0627\\u062f\\u0647\\u200c\\u0627\\u0645\"},{\"time\":16.9,\"fa\":\"She is gone\",\"en\":\"\\u0627\\u0648 \\u0631\\u0641\\u062a\\u0647 \\u0627\\u0633\\u062a\"},{\"time\":19.9,\"fa\":\"Now she\'s gone\",\"en\":\"\\u062d\\u0627\\u0644\\u0627 \\u062f\\u06cc\\u06af\\u0631 \\u0631\\u0641\\u062a\\u0647 \\u0627\\u0633\\u062a\"},{\"time\":25.06,\"fa\":\"All the angels praying for me\",\"en\":\"\\u0647\\u0645\\u0647\\u0654 \\u0641\\u0631\\u0634\\u062a\\u06af\\u0627\\u0646 \\u0628\\u0631\\u0627\\u06cc \\u0645\\u0646 \\u062f\\u0639\\u0627 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0646\\u062f.\"},{\"time\":29.34,\"fa\":\"As I fall\",\"en\":\"\\u0647\\u0646\\u06af\\u0627\\u0645\\u06cc \\u06a9\\u0647 \\u0633\\u0642\\u0648\\u0637 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0645.\"},{\"time\":32.18,\"fa\":\"As I fall\",\"en\":\"\\u0647\\u0646\\u06af\\u0627\\u0645\\u06cc \\u06a9\\u0647 \\u0633\\u0642\\u0648\\u0637 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0645.\"},{\"time\":34.41,\"fa\":null,\"en\":null},{\"time\":37.08,\"fa\":\"While I\'m meltin\' in the rain\",\"en\":\"\\u062f\\u0631 \\u062d\\u0627\\u0644\\u06cc \\u06a9\\u0647 \\u0632\\u06cc\\u0631 \\u0628\\u0627\\u0631\\u0627\\u0646 \\u0622\\u0628 \\u0645\\u06cc\\u200c\\u0634\\u0648\\u0645.\"},{\"time\":41.18,\"fa\":\"Deep in pain\",\"en\":\"\\u063a\\u0631\\u0642 \\u062f\\u0631 \\u062f\\u0631\\u062f \\u0648 \\u0631\\u0646\\u062c.\"},{\"time\":44.2,\"fa\":\"She is so far\",\"en\":\"\\u0627\\u0648 \\u0628\\u0633\\u06cc\\u0627\\u0631 \\u062f\\u0648\\u0631 \\u0627\\u0633\\u062a.\"},{\"time\":48.95,\"fa\":\"?Will we ever meet again\",\"en\":\"\\u0622\\u06cc\\u0627 \\u0645\\u0627 \\u0647\\u0631\\u06af\\u0632 \\u062f\\u0648\\u0628\\u0627\\u0631\\u0647 \\u0647\\u0645\\u062f\\u06cc\\u06af\\u0631 \\u0631\\u0627 \\u062e\\u0648\\u0627\\u0647\\u06cc\\u0645 \\u062f\\u06cc\\u062f\\u061f\"},{\"time\":53.71,\"fa\":\"As friends after so long\",\"en\":\"\\u0628\\u0647\\u200c\\u0639\\u0646\\u0648\\u0627\\u0646 \\u062f\\u0648\\u0633\\u062a\\u060c \\u067e\\u0633 \\u0627\\u0632 \\u0627\\u06cc\\u0646 \\u0647\\u0645\\u0647 \\u0645\\u062f\\u062a.\"},{\"time\":59.07,\"fa\":null,\"en\":null},{\"time\":61.06,\"fa\":\"To my nightmare with the Devil\",\"en\":\"\\u0628\\u0647 \\u0633\\u0648\\u06cc \\u06a9\\u0627\\u0628\\u0648\\u0633\\u0645 \\u0647\\u0645\\u0631\\u0627\\u0647 \\u0628\\u0627 \\u0634\\u06cc\\u0637\\u0627\\u0646.\"},{\"time\":65.21,\"fa\":\"I\'ll go strong\",\"en\":\"\\u0628\\u0627 \\u0642\\u062f\\u0631\\u062a \\u0627\\u062f\\u0627\\u0645\\u0647 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u062f\\u0627\\u062f.\"},{\"time\":67.97,\"fa\":\"I\'ll go strong\",\"en\":\"\\u0628\\u0627 \\u0642\\u062f\\u0631\\u062a \\u0627\\u062f\\u0627\\u0645\\u0647 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u062f\\u0627\\u062f.\"},{\"time\":72.31,\"fa\":\"All my friends now try to save me\",\"en\":\"\\u062d\\u0627\\u0644\\u0627 \\u0647\\u0645\\u0647\\u0654 \\u062f\\u0648\\u0633\\u062a\\u0627\\u0646\\u0645 \\u0633\\u0639\\u06cc \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0646\\u062f \\u0645\\u0631\\u0627 \\u0646\\u062c\\u0627\\u062a \\u062f\\u0647\\u0646\\u062f.\"},{\"time\":77.22,\"fa\":\"What a joke\",\"en\":\"\\u0686\\u0647 \\u0634\\u0648\\u062e\\u06cc \\u062a\\u0644\\u062e\\u06cc.\"},{\"time\":80.16,\"fa\":\"What a joke\",\"en\":\"\\u0686\\u0647 \\u0634\\u0648\\u062e\\u06cc \\u062a\\u0644\\u062e\\u06cc.\"},{\"time\":83.15,\"fa\":null,\"en\":null},{\"time\":85.02,\"fa\":\"While I\'m meltin\' in the rain\",\"en\":\"\\u062f\\u0631 \\u062d\\u0627\\u0644\\u06cc \\u06a9\\u0647 \\u0632\\u06cc\\u0631 \\u0628\\u0627\\u0631\\u0627\\u0646 \\u0622\\u0628 \\u0645\\u06cc\\u200c\\u0634\\u0648\\u0645.\"},{\"time\":89.55,\"fa\":\"Deep in pain\",\"en\":\"\\u063a\\u0631\\u0642 \\u062f\\u0631 \\u062f\\u0631\\u062f \\u0648 \\u0631\\u0646\\u062c.\"},{\"time\":92.55,\"fa\":\"She is so far\",\"en\":\"\\u0627\\u0648 \\u0628\\u0633\\u06cc\\u0627\\u0631 \\u062f\\u0648\\u0631 \\u0627\\u0633\\u062a.\"},{\"time\":97.52000000000001,\"fa\":\"?Will we ever meet again\",\"en\":\"\\u0622\\u06cc\\u0627 \\u0645\\u0627 \\u0647\\u0631\\u06af\\u0632 \\u062f\\u0648\\u0628\\u0627\\u0631\\u0647 \\u0647\\u0645\\u062f\\u06cc\\u06af\\u0631 \\u0631\\u0627 \\u062e\\u0648\\u0627\\u0647\\u06cc\\u0645 \\u062f\\u06cc\\u062f\\u061f\"},{\"time\":102.03,\"fa\":\"As friends after so long\",\"en\":\"\\u0628\\u0647\\u200c\\u0639\\u0646\\u0648\\u0627\\u0646 \\u062f\\u0648\\u0633\\u062a\\u060c \\u067e\\u0633 \\u0627\\u0632 \\u0627\\u06cc\\u0646 \\u0647\\u0645\\u0647 \\u0645\\u062f\\u062a.\"},{\"time\":107.39,\"fa\":null,\"en\":null},{\"time\":109.12,\"fa\":\"While I\'m meltin\' in the rain\",\"en\":\"\\u062f\\u0631 \\u062d\\u0627\\u0644\\u06cc \\u06a9\\u0647 \\u0632\\u06cc\\u0631 \\u0628\\u0627\\u0631\\u0627\\u0646 \\u0622\\u0628 \\u0645\\u06cc\\u200c\\u0634\\u0648\\u0645.\"},{\"time\":113.72999999999999,\"fa\":\"Deep in pain\",\"en\":\"\\u063a\\u0631\\u0642 \\u062f\\u0631 \\u062f\\u0631\\u062f \\u0648 \\u0631\\u0646\\u062c.\"},{\"time\":116.6,\"fa\":\"She is so far\",\"en\":\"\\u0627\\u0648 \\u0628\\u0633\\u06cc\\u0627\\u0631 \\u062f\\u0648\\u0631 \\u0627\\u0633\\u062a.\"},{\"time\":121.47,\"fa\":\"?Will we ever meet again\",\"en\":\"\\u0622\\u06cc\\u0627 \\u0645\\u0627 \\u0647\\u0631\\u06af\\u0632 \\u062f\\u0648\\u0628\\u0627\\u0631\\u0647 \\u0647\\u0645\\u062f\\u06cc\\u06af\\u0631 \\u0631\\u0627 \\u062e\\u0648\\u0627\\u0647\\u06cc\\u0645 \\u062f\\u06cc\\u062f\\u061f\"},{\"time\":125.76,\"fa\":\"As friends after so long\",\"en\":\"\\u0628\\u0647\\u200c\\u0639\\u0646\\u0648\\u0627\\u0646 \\u062f\\u0648\\u0633\\u062a\\u060c \\u067e\\u0633 \\u0627\\u0632 \\u0627\\u06cc\\u0646 \\u0647\\u0645\\u0647 \\u0645\\u062f\\u062a.\"},{\"time\":131.53,\"fa\":null,\"en\":null},{\"time\":157.7,\"fa\":\"While I\'m meltin\' in the rain\",\"en\":\"\\u062f\\u0631 \\u062d\\u0627\\u0644\\u06cc \\u06a9\\u0647 \\u0632\\u06cc\\u0631 \\u0628\\u0627\\u0631\\u0627\\u0646 \\u0622\\u0628 \\u0645\\u06cc\\u200c\\u0634\\u0648\\u0645.\"},{\"time\":161.86,\"fa\":\"Deep in pain\",\"en\":\"\\u063a\\u0631\\u0642 \\u062f\\u0631 \\u062f\\u0631\\u062f \\u0648 \\u0631\\u0646\\u062c.\"},{\"time\":164.66,\"fa\":\"She is so far\",\"en\":\"\\u0627\\u0648 \\u0628\\u0633\\u06cc\\u0627\\u0631 \\u062f\\u0648\\u0631 \\u0627\\u0633\\u062a.\"},{\"time\":169.93,\"fa\":\"?Will we ever meet again\",\"en\":\"\\u0622\\u06cc\\u0627 \\u0645\\u0627 \\u0647\\u0631\\u06af\\u0632 \\u062f\\u0648\\u0628\\u0627\\u0631\\u0647 \\u0647\\u0645\\u062f\\u06cc\\u06af\\u0631 \\u0631\\u0627 \\u062e\\u0648\\u0627\\u0647\\u06cc\\u0645 \\u062f\\u06cc\\u062f\\u061f\"},{\"time\":174.31,\"fa\":\"As friends after so long\",\"en\":\"\\u0628\\u0647\\u200c\\u0639\\u0646\\u0648\\u0627\\u0646 \\u062f\\u0648\\u0633\\u062a\\u060c \\u067e\\u0633 \\u0627\\u0632 \\u0627\\u06cc\\u0646 \\u0647\\u0645\\u0647 \\u0645\\u062f\\u062a.\"},{\"time\":181.33,\"fa\":null,\"en\":null}]', 1, '2026-10-07 15:52:01', '2026-10-14 10:01:08', NULL),
(8, 'The Show Must Go On', 'Queen', 7, 1, 'بسسمنتببمنیت', '04:37', 277, '/storage/covers/CskRjuu6Nv4vnxTI9P635W87Xsa3IlIrqJsJ6NFs.jpg', 'tracks/IDLjEwXJFHxSWLNeJ8SqsDlTK0TWYG2ooyNvIhTC.m4a', 'پاپ مدرن', NULL, NULL, 1, 69, '[{\"time\":0,\"fa\":null,\"en\":null},{\"time\":19.15,\"fa\":\"Empty spaces\",\"en\":\"\\u0641\\u0636\\u0627\\u0647\\u0627\\u06cc \\u062e\\u0627\\u0644\\u06cc\"},{\"time\":21.88,\"fa\":\"?What are we living for\",\"en\":\"\\u0645\\u0627 \\u0628\\u0631\\u0627\\u06cc \\u0686\\u0647 \\u0632\\u0646\\u062f\\u06af\\u06cc \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u06cc\\u0645\\u061f\"},{\"time\":24.92,\"fa\":\"Abandoned places\",\"en\":\"\\u0645\\u06a9\\u0627\\u0646\\u200c\\u0647\\u0627\\u06cc \\u0631\\u0647\\u0627\\u0634\\u062f\\u0647\"},{\"time\":27.72,\"fa\":\"I guess we know the score\",\"en\":\"\\u0641\\u06a9\\u0631 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0645 \\u062e\\u0648\\u062f\\u0645\\u0627\\u0646 \\u0645\\u06cc\\u200c\\u062f\\u0627\\u0646\\u06cc\\u0645 \\u0627\\u0648\\u0636\\u0627\\u0639 \\u0627\\u0632 \\u0686\\u0647 \\u0642\\u0631\\u0627\\u0631 \\u0627\\u0633\\u062a.\"},{\"time\":31.23,\"fa\":\"On and on\",\"en\":\"...\\u0647\\u0645\\u06cc\\u0646\\u200c\\u0637\\u0648\\u0631 \\u0627\\u062f\\u0627\\u0645\\u0647 \\u062f\\u0627\\u0631\\u062f\"},{\"time\":33.88,\"fa\":\"?Does anybody know what we are looking for\",\"en\":\"\\u0622\\u06cc\\u0627 \\u06a9\\u0633\\u06cc \\u0645\\u06cc\\u200c\\u062f\\u0627\\u0646\\u062f \\u0645\\u0627 \\u0628\\u0647 \\u062f\\u0646\\u0628\\u0627\\u0644 \\u0686\\u0647 \\u0647\\u0633\\u062a\\u06cc\\u0645\\u061f\"},{\"time\":39.23,\"fa\":\"Another hero\",\"en\":\"\\u06cc\\u06a9 \\u0642\\u0647\\u0631\\u0645\\u0627\\u0646 \\u062f\\u06cc\\u06af\\u0631\"},{\"time\":41.9,\"fa\":\"Another mindless crime\",\"en\":\"\\u06cc\\u06a9 \\u062c\\u0646\\u0627\\u06cc\\u062a \\u0628\\u06cc\\u200c\\u0645\\u0639\\u0646\\u0627\\u06cc \\u062f\\u06cc\\u06af\\u0631\"},{\"time\":44.82,\"fa\":\"Behind the curtain\",\"en\":\"\\u067e\\u0634\\u062a \\u067e\\u0631\\u062f\\u0647\"},{\"time\":47.83,\"fa\":\"In the pantomime\",\"en\":\"\\u062f\\u0631 \\u0627\\u06cc\\u0646 \\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0633\\u0627\\u062e\\u062a\\u06af\\u06cc\"},{\"time\":51.38,\"fa\":\"Hold the line\",\"en\":\"\\u0645\\u0642\\u0627\\u0648\\u0645\\u062a \\u06a9\\u0646 \\/ \\u062f\\u0648\\u0627\\u0645 \\u0628\\u06cc\\u0627\\u0648\\u0631\"},{\"time\":54.17,\"fa\":\"?Does anybody want to take it anymore\",\"en\":\"\\u0622\\u06cc\\u0627 \\u06a9\\u0633\\u06cc \\u062f\\u06cc\\u06af\\u0631 \\u0645\\u06cc\\u200c\\u062e\\u0648\\u0627\\u0647\\u062f \\u0627\\u06cc\\u0646 \\u0634\\u0631\\u0627\\u06cc\\u0637 \\u0631\\u0627 \\u062a\\u062d\\u0645\\u0644 \\u06a9\\u0646\\u062f\\u061f\"},{\"time\":58.75,\"fa\":\"The show must go on\",\"en\":\".\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f\"},{\"time\":64.39,\"fa\":\"The show must go on, yeah\",\"en\":\".\\u0622\\u0631\\u06cc\\u060c \\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f\"},{\"time\":70.94,\"fa\":\"Inside my heart is breaking\",\"en\":\"\\u062f\\u0631 \\u062f\\u0631\\u0648\\u0646\\u0645\\u060c \\u0642\\u0644\\u0628\\u0645 \\u062f\\u0627\\u0631\\u062f \\u0645\\u06cc\\u200c\\u0634\\u06a9\\u0646\\u062f.\"},{\"time\":74.17,\"fa\":\"My make-up may be flaking\",\"en\":\"\\u0634\\u0627\\u06cc\\u062f \\u06af\\u0631\\u06cc\\u0645 \\u0635\\u0648\\u0631\\u062a\\u0645 \\u062f\\u0627\\u0631\\u062f \\u0645\\u06cc\\u200c\\u0631\\u06cc\\u0632\\u062f.\"},{\"time\":76.46000000000001,\"fa\":\"But my smile, still, stays on\",\"en\":\"\\u0627\\u0645\\u0627 \\u0644\\u0628\\u062e\\u0646\\u062f\\u0645 \\u0647\\u0646\\u0648\\u0632 \\u0628\\u0631 \\u0644\\u0628\\u0645 \\u0628\\u0627\\u0642\\u06cc \\u0645\\u06cc\\u200c\\u0645\\u0627\\u0646\\u062f.\"},{\"time\":84.75,\"fa\":\"Whatever happens\",\"en\":\"\\u0647\\u0631 \\u0627\\u062a\\u0641\\u0627\\u0642\\u06cc \\u06a9\\u0647 \\u0628\\u06cc\\u0641\\u062a\\u062f\\u060c\"},{\"time\":87.13,\"fa\":\"I\'ll leave it all to chance\",\"en\":\"\\u0647\\u0645\\u0647\\u200c\\u0686\\u06cc\\u0632 \\u0631\\u0627 \\u0628\\u0647 \\u0634\\u0627\\u0646\\u0633 \\u0648\\u0627\\u06af\\u0630\\u0627\\u0631 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0645.\"},{\"time\":90.65,\"fa\":\"Another heartache\",\"en\":\"\\u06cc\\u06a9 \\u062f\\u0644\\u200c\\u0634\\u06a9\\u0633\\u062a\\u06af\\u06cc \\u062f\\u06cc\\u06af\\u0631\"},{\"time\":93.34,\"fa\":\"Another failed romance\",\"en\":\"\\u06cc\\u06a9 \\u0631\\u0627\\u0628\\u0637\\u0647 \\u0639\\u0627\\u0634\\u0642\\u0627\\u0646\\u0647 \\u0646\\u0627\\u0645\\u0648\\u0641\\u0642 \\u062f\\u06cc\\u06af\\u0631\"},{\"time\":96.9,\"fa\":\"On and on\",\"en\":\"...\\u0647\\u0645\\u06cc\\u0646\\u200c\\u0637\\u0648\\u0631 \\u0627\\u062f\\u0627\\u0645\\u0647 \\u062f\\u0627\\u0631\\u062f\"},{\"time\":99.75999999999999,\"fa\":\"?Does anybody know what we are living for\",\"en\":\"\\u0622\\u06cc\\u0627 \\u06a9\\u0633\\u06cc \\u0645\\u06cc\\u200c\\u062f\\u0627\\u0646\\u062f \\u0645\\u0627 \\u0628\\u0631\\u0627\\u06cc \\u0686\\u0647 \\u0632\\u0646\\u062f\\u06af\\u06cc \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u06cc\\u0645\\u061f\"},{\"time\":104.67,\"fa\":\"I guess I\'m learning\",\"en\":\"\\u0641\\u06a9\\u0631 \\u0645\\u06cc\\u200c\\u06a9\\u0646\\u0645 \\u062f\\u0627\\u0631\\u0645 \\u06cc\\u0627\\u062f \\u0645\\u06cc\\u200c\\u06af\\u06cc\\u0631\\u0645.\"},{\"time\":107.41,\"fa\":\"I must be warmer now\",\"en\":\"\\u062d\\u0627\\u0644\\u0627 \\u0628\\u0627\\u06cc\\u062f \\u06af\\u0631\\u0645\\u200c\\u062a\\u0631 \\u0648 \\u0645\\u0647\\u0631\\u0628\\u0627\\u0646\\u200c\\u062a\\u0631 \\u0628\\u0627\\u0634\\u0645.\"},{\"time\":110.38,\"fa\":\"I\'ll soon be turning\",\"en\":\"\\u0628\\u0647\\u200c\\u0632\\u0648\\u062f\\u06cc \\u062e\\u0648\\u0627\\u0647\\u0645 \\u067e\\u06cc\\u0686\\u06cc\\u062f.\"},{\"time\":113.45,\"fa\":\"\'Round the corner now\",\"en\":\"\\u0647\\u0645\\u06cc\\u0646 \\u062d\\u0627\\u0644\\u0627\\u060c \\u062f\\u0648\\u0631\\u0650 \\u0622\\u0646 \\u067e\\u06cc\\u0686.\"},{\"time\":116.61,\"fa\":\"Outside the dawn is breaking\",\"en\":\"\\u0628\\u06cc\\u0631\\u0648\\u0646\\u060c \\u0633\\u067e\\u06cc\\u062f\\u0647 \\u062f\\u0631 \\u062d\\u0627\\u0644 \\u062f\\u0645\\u06cc\\u062f\\u0646 \\u0627\\u0633\\u062a.\"},{\"time\":119.83,\"fa\":\"But inside in the dark I\'m aching to be free\",\"en\":\"\\u0627\\u0645\\u0627 \\u062f\\u0631 \\u062f\\u0631\\u0648\\u0646\\u0645\\u060c \\u062f\\u0631 \\u062a\\u0627\\u0631\\u06cc\\u06a9\\u06cc\\u060c \\u0627\\u0632 \\u062f\\u0631\\u062f \\u0622\\u0631\\u0632\\u0648\\u06cc \\u0622\\u0632\\u0627\\u062f\\u06cc \\u062f\\u0627\\u0631\\u0645.\"},{\"time\":127.31,\"fa\":\"The show must go on\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f.\"},{\"time\":132.88,\"fa\":\"The show must go on, yeah, yeah\",\"en\":\"\\u0622\\u0631\\u06cc\\u060c \\u0622\\u0631\\u06cc\\u060c \\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f.\"},{\"time\":139,\"fa\":\"Ooh, inside my heart is breaking\",\"en\":\"\\u0622\\u0647\\u060c \\u062f\\u0631 \\u062f\\u0631\\u0648\\u0646\\u0645 \\u0642\\u0644\\u0628\\u0645 \\u062f\\u0627\\u0631\\u062f \\u0645\\u06cc\\u200c\\u0634\\u06a9\\u0646\\u062f.\"},{\"time\":142.69,\"fa\":\"My make-up may be flaking\",\"en\":\"\\u0634\\u0627\\u06cc\\u062f \\u06af\\u0631\\u06cc\\u0645 \\u0635\\u0648\\u0631\\u062a\\u0645 \\u062f\\u0627\\u0631\\u062f \\u0645\\u06cc\\u200c\\u0631\\u06cc\\u0632\\u062f.\"},{\"time\":144.99,\"fa\":\"But my smile, still, stays on\",\"en\":\"\\u0627\\u0645\\u0627 \\u0644\\u0628\\u062e\\u0646\\u062f\\u0645 \\u0647\\u0646\\u0648\\u0632 \\u0628\\u0631 \\u0644\\u0628\\u0645 \\u0628\\u0627\\u0642\\u06cc \\u0645\\u06cc\\u200c\\u0645\\u0627\\u0646\\u062f.\"},{\"time\":168.62,\"fa\":\"My soul is painted like the wings of butterflies\",\"en\":\"\\u0631\\u0648\\u062d \\u0645\\u0646 \\u0647\\u0645\\u0686\\u0648\\u0646 \\u0628\\u0627\\u0644\\u200c\\u0647\\u0627\\u06cc \\u067e\\u0631\\u0648\\u0627\\u0646\\u0647\\u200c\\u0647\\u0627 \\u0631\\u0646\\u06af\\u200c\\u0622\\u0645\\u06cc\\u0632\\u06cc \\u0634\\u062f\\u0647 \\u0627\\u0633\\u062a.\"},{\"time\":174.03,\"fa\":\"Fairy tales of yesterday, will grow but never die\",\"en\":\"\\u0627\\u0641\\u0633\\u0627\\u0646\\u0647\\u200c\\u0647\\u0627\\u06cc \\u062f\\u06cc\\u0631\\u0648\\u0632 \\u0631\\u0634\\u062f \\u062e\\u0648\\u0627\\u0647\\u0646\\u062f \\u06a9\\u0631\\u062f\\u060c \\u0627\\u0645\\u0627 \\u0647\\u0631\\u06af\\u0632 \\u0646\\u062e\\u0648\\u0627\\u0647\\u0646\\u062f \\u0645\\u0631\\u062f.\"},{\"time\":179.88,\"fa\":\"I can fly, my friends\",\"en\":\"\\u062f\\u0648\\u0633\\u062a\\u0627\\u0646 \\u0645\\u0646\\u060c \\u0645\\u0646 \\u0645\\u06cc\\u200c\\u062a\\u0648\\u0627\\u0646\\u0645 \\u067e\\u0631\\u0648\\u0627\\u0632 \\u06a9\\u0646\\u0645.\"},{\"time\":184.45,\"fa\":\"The show must go on, yeah\",\"en\":\"\\u0622\\u0631\\u06cc\\u060c \\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f.\"},{\"time\":190.14,\"fa\":\"The show must go on\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f.\"},{\"time\":196.5,\"fa\":\"I\'ll face it with a grin\",\"en\":\"\\u0628\\u0627 \\u0644\\u0628\\u062e\\u0646\\u062f\\u06cc \\u0628\\u0631 \\u0644\\u0628 \\u0628\\u0627 \\u0622\\u0646 \\u0631\\u0648\\u0628\\u0647\\u200c\\u0631\\u0648 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u0634\\u062f.\"},{\"time\":199.59,\"fa\":\"I\'m never giving in\",\"en\":\"\\u0647\\u0631\\u06af\\u0632 \\u062a\\u0633\\u0644\\u06cc\\u0645 \\u0646\\u062e\\u0648\\u0627\\u0647\\u0645 \\u0634\\u062f.\"},{\"time\":201.72,\"fa\":\"On with the show\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0631\\u0627 \\u0627\\u062f\\u0627\\u0645\\u0647 \\u0628\\u062f\\u0647.\"},{\"time\":216.68,\"fa\":\"I\'ll top the bill\",\"en\":\"\\u0645\\u0646 \\u062f\\u0631 \\u0635\\u062f\\u0631 \\u0628\\u0631\\u0646\\u0627\\u0645\\u0647 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u0628\\u0648\\u062f.\"},{\"time\":218.15,\"fa\":\"I\'ll overkill\",\"en\":\"\\u062a\\u0627 \\u0622\\u062e\\u0631\\u06cc\\u0646 \\u062d\\u062f \\u062a\\u0648\\u0627\\u0646\\u0645 \\u067e\\u06cc\\u0634 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u0631\\u0641\\u062a \\/ \\u0628\\u06cc\\u0634 \\u0627\\u0632 \\u062d\\u062f \\u0644\\u0627\\u0632\\u0645 \\u062a\\u0644\\u0627\\u0634 \\u062e\\u0648\\u0627\\u0647\\u0645 \\u06a9\\u0631\\u062f.\"},{\"time\":219.82,\"fa\":\"I have to find the will to carry on\",\"en\":\"\\u0628\\u0627\\u06cc\\u062f \\u0627\\u0631\\u0627\\u062f\\u0647\\u200c\\u0627\\u06cc \\u0628\\u0631\\u0627\\u06cc \\u0627\\u062f\\u0627\\u0645\\u0647 \\u062f\\u0627\\u062f\\u0646 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u0645.\"},{\"time\":224.01,\"fa\":\"On with the show\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0631\\u0627 \\u0627\\u062f\\u0627\\u0645\\u0647 \\u0628\\u062f\\u0647.\"},{\"time\":226.82,\"fa\":\"On with the show\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0631\\u0627 \\u0627\\u062f\\u0627\\u0645\\u0647 \\u0628\\u062f\\u0647.\"},{\"time\":231.39,\"fa\":\"The show must go on\",\"en\":\"\\u0646\\u0645\\u0627\\u06cc\\u0634 \\u0628\\u0627\\u06cc\\u062f \\u0627\\u062f\\u0627\\u0645\\u0647 \\u067e\\u06cc\\u062f\\u0627 \\u06a9\\u0646\\u062f.\"}]', 1, '2026-10-07 16:40:20', '2026-10-14 10:01:07', NULL),
(10, 'Bohemain', 'Queen', 7, 1, 'بسسمنتببمنیت', '05:59', 359, '/storage/covers/S67VojUGXQVVYWxLyFv4WpEYneCHO0TSOV5ZBnit.jpg', 'tracks/eTv2Wm0bMjLgfBp9iRBZUTHhdh78rbPELda4VWrj.m4a', 'پاپ مدرن', 'سلام', NULL, 1, 62, '[{\"time\":0.38,\"fa\":\"Is this the real life? Is this just fantasy?\",\"en\":null},{\"time\":6.96,\"fa\":\"Caught in a landslide, no escape from reality\",\"en\":null},{\"time\":14.31,\"fa\":\"Open your eyes, look up to the skies and see\",\"en\":null},{\"time\":24.67,\"fa\":\"I\'m just a poor boy, I need no sympathy\",\"en\":null},{\"time\":30.68,\"fa\":\"Because I\'m easy come, easy go, little high, little low\",\"en\":null},{\"time\":38.12,\"fa\":\"Any way the wind blows doesn\'t really matter to me, to me\",\"en\":null},{\"time\":55.12,\"fa\":\"Mama, just killed a man\",\"en\":null},{\"time\":61.49,\"fa\":\"Put a gun against his head, pulled my trigger, now he\'s dead\",\"en\":null},{\"time\":68.66,\"fa\":\"Mama, life had just begun\",\"en\":null},{\"time\":75.03999999999999,\"fa\":\"But now I\'ve gone and thrown it all away\",\"en\":null},{\"time\":82.22,\"fa\":\"Mama, ooh, didn\'t mean to make you cry\",\"en\":null},{\"time\":92.59,\"fa\":\"If I\'m not back again this time tomorrow\",\"en\":null},{\"time\":97.00999999999999,\"fa\":\"Carry on, carry on as if nothing really matters\",\"en\":null},{\"time\":114.53999999999999,\"fa\":\"Too late, my time has come\",\"en\":null},{\"time\":120.91,\"fa\":\"Sends shivers down my spine, body\'s aching all the time\",\"en\":null},{\"time\":128.09,\"fa\":\"Goodbye, everybody, I\'ve got to go\",\"en\":null},{\"time\":134.46,\"fa\":\"Gotta leave you all behind and face the truth\",\"en\":null},{\"time\":141.63,\"fa\":\"Mama, ooh (Any way the wind blows)\",\"en\":null},{\"time\":148.54,\"fa\":\"I don\'t wanna die\",\"en\":null},{\"time\":151.73,\"fa\":\"I sometimes wish I\'d never been born at all\",\"en\":null},{\"time\":185.73,\"fa\":\"I see a little silhouetto of a man\",\"en\":null},{\"time\":188.65,\"fa\":\"Scaramouche, Scaramouche, will you do the Fandango?\",\"en\":null},{\"time\":192.1,\"fa\":\"Thunderbolt and lightning, very, very frightening me\",\"en\":null},{\"time\":195.82,\"fa\":\"(Galileo) Galileo, (Galileo) Galileo, Galileo Figaro magnifico\",\"en\":null},{\"time\":202.2,\"fa\":\"But I\'m just a poor boy, nobody loves me\",\"en\":null},{\"time\":205.65,\"fa\":\"He\'s just a poor boy from a poor family\",\"en\":null},{\"time\":208.84,\"fa\":\"Spare him his life from this monstrosity\",\"en\":null},{\"time\":213.62,\"fa\":\"Easy come, easy go, will you let me go?\",\"en\":null},{\"time\":216.28,\"fa\":\"Bismillah! No, we will not let you go\",\"en\":null},{\"time\":219.46,\"fa\":\"(Let him go) Bismillah! We will not let you go\",\"en\":null},{\"time\":222.39,\"fa\":\"(Let him go) Bismillah! We will not let you go\",\"en\":null},{\"time\":225.57,\"fa\":\"(Let me go) Will not let you go\",\"en\":null},{\"time\":227.17000000000002,\"fa\":\"(Let me go) Will not let you go\",\"en\":null},{\"time\":227.84,\"fa\":\"(Never, never, never, never let me go) Ah\",\"en\":null},{\"time\":231.2,\"fa\":\"No, no, no, no, no, no, no\",\"en\":null},{\"time\":233.59,\"fa\":\"(Oh, mamma mia, mamma mia) Mamma mia, let me go\",\"en\":null},{\"time\":237.04,\"fa\":\"Beelzebub has a devil put aside for me, for me, for me!\",\"en\":null},{\"time\":254.57,\"fa\":\"So you think you can stone me and spit in my eye?\",\"en\":null},{\"time\":260.68,\"fa\":\"So you think you can love me and leave me to die?\",\"en\":null},{\"time\":265.73,\"fa\":\"Oh, baby, can\'t do this to me, baby!\",\"en\":null},{\"time\":272.64,\"fa\":\"Just gotta get out, just gotta get right outta here\",\"en\":null},{\"time\":294.85,\"fa\":\"(Ooh)\",\"en\":null},{\"time\":299.55,\"fa\":\"(Ooh, yeah, ooh, yeah)\",\"en\":null},{\"time\":311.51,\"fa\":\"Nothing really matters, anyone can see\",\"en\":null},{\"time\":318.41,\"fa\":\"Nothing really matters\",\"en\":null},{\"time\":322.4,\"fa\":\"Nothing really matters to me\",\"en\":null},{\"time\":342.58,\"fa\":\"Any way the wind blows\",\"en\":null}]', 0, '2026-10-11 18:30:51', '2026-10-14 10:39:11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'کاربر',
  `plan` varchar(255) NOT NULL DEFAULT 'رایگان',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `phone`, `role`, `plan`, `is_active`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(4, 'pouyadel', 'pouyadel', 'pouyadel6@gmail.com', '09015854985', 'مدیر', 'رایگان', 1, NULL, '$2y$12$BhjaNHUib0BRZne2DnAumuR0oyZQWFTpifYviUPV7pBeTP4TNcqRq', 'KQBP0EyMnKG7q2E7Sqqn6UbCvcoczxJlwj1BlyfS4eit9Jv8z6L3MsCqVUWT', '2026-10-13 20:10:19', '2026-10-14 11:12:10'),
(5, 'pouyadell', 'pouyadell', 'pouyel6@gmail.com', '09999385926', 'کاربر عادی', 'رایگان', 1, NULL, '$2y$12$c/tWOGtuRtcjNw4Jizh/XObA0NaZO8Cx5em5uDrZpbqTiMrziQTWS', 'G35s9eddnx4ez9qfhAs9GoPjw2KpjASIaK0j07NMIcIaxBJV1eWRR8ETiSD5', '2026-10-14 11:15:19', '2026-10-14 11:15:19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`id`),
  ADD KEY `albums_artist_id_foreign` (`artist_id`);

--
-- Indexes for table `artists`
--
ALTER TABLE `artists`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `artist_genre`
--
ALTER TABLE `artist_genre`
  ADD PRIMARY KEY (`id`),
  ADD KEY `artist_genre_artist_id_foreign` (`artist_id`),
  ADD KEY `artist_genre_genre_id_foreign` (`genre_id`);

--
-- Indexes for table `artist_track`
--
ALTER TABLE `artist_track`
  ADD PRIMARY KEY (`id`),
  ADD KEY `artist_track_track_id_foreign` (`track_id`),
  ADD KEY `artist_track_artist_id_foreign` (`artist_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `genres_name_unique` (`name`),
  ADD UNIQUE KEY `genres_slug_unique` (`slug`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `playlists`
--
ALTER TABLE `playlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `playlists_user_id_foreign` (`user_id`);

--
-- Indexes for table `playlist_track`
--
ALTER TABLE `playlist_track`
  ADD PRIMARY KEY (`id`),
  ADD KEY `playlist_track_playlist_id_foreign` (`playlist_id`),
  ADD KEY `playlist_track_track_id_foreign` (`track_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `tracks`
--
ALTER TABLE `tracks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tracks_artist_id_foreign` (`artist_id`),
  ADD KEY `tracks_genre_id_foreign` (`genre_id`),
  ADD KEY `tracks_album_id_foreign` (`album_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_phone_unique` (`phone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `albums`
--
ALTER TABLE `albums`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `artists`
--
ALTER TABLE `artists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `artist_genre`
--
ALTER TABLE `artist_genre`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `artist_track`
--
ALTER TABLE `artist_track`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `genres`
--
ALTER TABLE `genres`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `playlists`
--
ALTER TABLE `playlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `playlist_track`
--
ALTER TABLE `playlist_track`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tracks`
--
ALTER TABLE `tracks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `albums`
--
ALTER TABLE `albums`
  ADD CONSTRAINT `albums_artist_id_foreign` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `artist_genre`
--
ALTER TABLE `artist_genre`
  ADD CONSTRAINT `artist_genre_artist_id_foreign` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `artist_genre_genre_id_foreign` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `artist_track`
--
ALTER TABLE `artist_track`
  ADD CONSTRAINT `artist_track_artist_id_foreign` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `artist_track_track_id_foreign` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `playlists`
--
ALTER TABLE `playlists`
  ADD CONSTRAINT `playlists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `playlist_track`
--
ALTER TABLE `playlist_track`
  ADD CONSTRAINT `playlist_track_playlist_id_foreign` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `playlist_track_track_id_foreign` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tracks`
--
ALTER TABLE `tracks`
  ADD CONSTRAINT `tracks_album_id_foreign` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tracks_artist_id_foreign` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tracks_genre_id_foreign` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
