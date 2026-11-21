<?php

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// بررسی حالت تعمیر و نگهداری
if (file_exists($maintenance = __DIR__.'/../sehpatify/storage/framework/maintenance.php')) {
    require $maintenance;
}

// بارگذاری اتولودر کامپوزر از پوشه اصلی پروژه
require __DIR__.'/../sehpatify/vendor/autoload.php';

// راه‌اندازی لاراول
/** @var Application $app */
$app = require_once __DIR__.'/../sehpatify/bootstrap/app.php';

// معرفی پوشه public_html به عنوان مسیر عمومی
$app->usePublicPath(__DIR__);

$app->handleRequest(Request::capture());