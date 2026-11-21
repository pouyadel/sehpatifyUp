<?php
/**
 * اسکریپت موقت ریست پسورد ادمین سهپاتیفای (فقط برای محیط لوکال)
 * مسیر قرارگیری: public_html/reset_admin_password.php
 * پس از تغییر رمز، حتماً این فایل را حذف کنید.
 */

// محدودیت امنیتی: فقط روی لوکال اجرا شود
$allowedHosts = ['127.0.0.1', '::1', 'localhost'];
$remoteAddr = $_SERVER['REMOTE_ADDR'] ?? '';
if (!in_array($remoteAddr, $allowedHosts, true)) {
    http_response_code(403);
    exit('دسترسی غیرمجاز: این فایل فقط در محیط لوکال قابل اجرا است.');
}

// بارگذاری هسته لاراول از پوشه sehpatify
$autoloadPath = __DIR__ . '/../sehpatify/vendor/autoload.php';
$appPath = __DIR__ . '/../sehpatify/bootstrap/app.php';

if (!file_exists($autoloadPath) || !file_exists($appPath)) {
    http_response_code(500);
    exit('فایل‌های هسته لاراول در مسیر ../sehpatify پیدا نشدند. مطمئن شوید این فایل داخل پوشه public_html قرار دارد.');
}

require $autoloadPath;
$app = require_once $appPath;
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

$message = null;
$error = null;

// حذف خودکار فایل در صورت کلیک روی دکمه حذف
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_self'])) {
    if (@unlink(__FILE__)) {
        echo '<!DOCTYPE html><html lang="fa" dir="rtl"><head><meta charset="UTF-8"><title>فایل حذف شد</title></head><body style="background:#0A0A0F;color:#10B954;font-family:Tahoma,sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;"><h2>فایل با موفقیت حذف شد. حالا می‌توانید وارد پنل شوید.</h2></body></html>';
        exit;
    } else {
        $error = 'امکان حذف خودکار وجود نداشت؛ لطفاً فایل را به‌صورت دستی از پوشه public_html پاک کنید.';
    }
}

// دریافت لیست کاربران برای نمایش در فرم (با اولویت مدیرها)
try {
    $users = DB::table('users')
        ->select('id', 'name', 'username', 'email', 'role')
        ->orderByRaw("CASE WHEN role = 'مدیر' THEN 0 ELSE 1 END")
        ->orderBy('id')
        ->get();
} catch (Throwable $e) {
    $users = collect();
    $error = 'خطا در اتصال به دیتابیس: ' . $e->getMessage();
}

// پردازش فرم تغییر پسورد
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['user_id'], $_POST['new_password'])) {
    $userId = (int) $_POST['user_id'];
    $newPassword = trim((string) $_POST['new_password']);

    if ($userId <= 0) {
        $error = 'لطفاً یک کاربر معتبر انتخاب کنید.';
    } elseif (strlen($newPassword) < 4) {
        $error = 'رمز عبور جدید باید حداقل ۴ کاراکتر باشد.';
    } else {
        try {
            $updated = DB::table('users')
                ->where('id', $userId)
                ->update([
                    'password'   => Hash::make($newPassword),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);

            if ($updated) {
                $targetUser = DB::table('users')->where('id', $userId)->first();
                $message = sprintf(
                    'رمز عبور کاربر «%s» (%s) با موفقیت تغییر یافت. اکنون می‌توانید با رمز جدید وارد شوید.',
                    htmlspecialchars($targetUser->username ?? $targetUser->name, ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($targetUser->email, ENT_QUOTES, 'UTF-8')
                );
            } else {
                $error = 'کاربر مورد نظر پیدا نشد یا تغییری اعمال نشد.';
            }
        } catch (Throwable $e) {
            $error = 'خطا هنگام ذخیره رمز عبور: ' . $e->getMessage();
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ریست پسورد ادمین | سهپاتیفای</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle at top, #12261c 0%, #0A0A0F 60%);
            color: #f4f4f5;
            font-family: Vazirmatn, Tahoma, sans-serif;
            padding: 20px;
        }
        .card {
            width: 100%;
            max-width: 440px;
            background: rgba(24, 24, 27, 0.78);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
        }
        h1 {
            margin: 0 0 8px;
            font-size: 20px;
            color: #fff;
        }
        p.sub {
            margin: 0 0 22px;
            font-size: 13px;
            color: #a1a1aa;
            line-height: 1.7;
        }
        label {
            display: block;
            font-size: 13px;
            margin-bottom: 6px;
            color: #d4d4d8;
        }
        select, input[type="text"], input[type="password"] {
            width: 100%;
            padding: 11px 14px;
            margin-bottom: 16px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.14);
            background: rgba(9, 9, 11, 0.7);
            color: #fff;
            font-size: 14px;
            font-family: inherit;
            outline: none;
        }
        select:focus, input:focus {
            border-color: #10B954;
        }
        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: bold;
            font-family: inherit;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        button:hover { opacity: 0.9; }
        .btn-primary {
            background: #10B954;
            color: #04130a;
        }
        .btn-danger {
            margin-top: 10px;
            background: rgba(239, 68, 68, 0.15);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.35);
        }
        .alert {
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 13px;
            line-height: 1.7;
            margin-bottom: 18px;
        }
        .alert-success {
            background: rgba(16, 185, 84, 0.15);
            border: 1px solid rgba(16, 185, 84, 0.4);
            color: #86efac;
        }
        .alert-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: #fca5a5;
        }
        .warn {
            margin-top: 16px;
            font-size: 12px;
            color: #fbbf24;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>ریست پسورد ادمین (لوکال)</h1>
        <p class="sub">کاربر مورد نظر را انتخاب کنید و رمز عبور جدید را وارد نمایید. رمز جدید با استاندارد Bcrypt لاراول هش و ذخیره می‌شود.</p>

        <?php if ($message): ?>
            <div class="alert alert-success"><?= $message ?></div>
        <?php endif; ?>

        <?php if ($error): ?>
            <div class="alert alert-error"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></div>
        <?php endif; ?>

        <form method="POST">
            <label for="user_id">انتخاب حساب کاربری</label>
            <select name="user_id" id="user_id" required>
                <?php foreach ($users as $u): ?>
                    <option value="<?= (int)$u->id ?>">
                        <?= htmlspecialchars(($u->username ?: $u->name) . ' — ' . $u->email . ' (' . $u->role . ')', ENT_QUOTES, 'UTF-8') ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="new_password">رمز عبور جدید</label>
            <input type="text" name="new_password" id="new_password" placeholder="مثلاً: 12345678" required minlength="4">

            <button type="submit" class="btn-primary">ذخیره رمز عبور جدید</button>
        </form>

        <form method="POST" onsubmit="return confirm('این فایل از پوشه public_html حذف شود؟');">
            <button type="submit" name="delete_self" value="1" class="btn-danger">حذف خودکار این فایل پس از اتمام کار</button>
        </form>

        <div class="warn">نکته امنیتی: این فایل را هیچ‌وقت روی هاست اصلی آپلود نکنید.</div>
    </div>
</body>
</html>
