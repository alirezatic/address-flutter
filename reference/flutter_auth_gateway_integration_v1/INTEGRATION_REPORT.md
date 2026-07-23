# Flutter Auth Gateway Integration v1

این بسته بر اساس Audit واقعی پروژه و قرارداد OpenAPI نسخه `0.10.0` ساخته شده است.

## تغییرات

- اتصال فرم شماره موبایل به:
  - `POST /api/v1/auth/otp/request`
- اتصال فرم OTP به:
  - `POST /api/v1/auth/otp/verify`
- ذخیره امن Access Token و Refresh Token با `flutter_secure_storage`
- حذف کلید قدیمی `mock_authenticated_session`
- اتصال Logout فعلی Home به:
  - `POST /api/v1/auth/logout`
- آماده‌سازی Refresh Token و `/auth/me` برای مراحل بعد
- تبدیل OTP از ۵ رقم به قرارداد واقعی ۶ رقمی Gateway
- Resend واقعی و استفاده از زمان cooldown سرور
- Auto-fill کد توسعه فقط در محیط Development و فقط وقتی Gateway مقدار `developmentOtp` برگرداند
- افزودن پیام خطای OTP برای فارسی، انگلیسی، عربی و چینی
- افزودن تست‌های Controller و Model

## مواردی که تغییر نمی‌کنند

- طراحی Login Sheet
- طراحی OTP Sheet
- انیمیشن باز و بسته‌شدن Login و OTP
- Onboarding Rive
- Home و منوی آن
- رنگ‌ها، حاشیه‌ها و کارت‌های موجود
- مسیر ارتباطی Flutter → Gateway → Odoo Clone

## ایمنی نصب

اسکریپت قبل از تغییر، Hash فایل‌های Audit را بررسی می‌کند. اگر پروژه بعد از Audit تغییر کرده باشد، بدون تغییر فایل‌ها متوقف می‌شود.

پس از اعمال، این دستورات خودکار اجرا می‌شوند:

```text
flutter pub get
flutter gen-l10n
dart format <changed files>
flutter analyze
flutter test
```

در صورت خطا، فایل‌های تغییرکرده به‌طور خودکار Rollback می‌شوند.

## اجرای Web

تونل SSH باید فعال بماند:

```powershell
ssh -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -N -L 3000:127.0.0.1:3000 root@65.109.216.87
```

اجرای Flutter:

```powershell
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8091
```

## نکته Clone

Gateway در محیط Clone کد توسعه را در پاسخ `otp/request` برمی‌گرداند. برنامه فقط در `APP_ENV=development` آن را داخل ۶ خانه OTP قرار می‌دهد؛ تأیید همچنان با دکمه موجود انجام می‌شود.

## اجرای Android Emulator

برای دسترسی Emulator به تونل میزبان:

```powershell
adb reverse tcp:3000 tcp:3000
flutter run
```
