# Flutter OTP 5-Digit Patch v1

این Patch برنامه Flutter را با Gateway پنج‌رقمی هماهنگ می‌کند.

## تغییرات

- تعداد خانه‌های OTP: 5
- اعتبارسنجی محلی: دقیقاً 5 رقم
- Auto-fill کد Development: فقط کد 5 رقمی
- متن خطا در فارسی، انگلیسی، عربی و چینی
- نمونه‌های تست Auth: پنج‌رقمی
- به‌روزرسانی اختیاری OpenAPI از Tunnel محلی

## مواردی که تغییر نمی‌کنند

- طراحی کلی صفحه
- انیمیشن‌ها
- Login
- Onboarding
- Home
- Router
- Session و Token Storage
- Gateway و Odoo

## اجرا

```powershell
cd c:\users\htica\desktop\alireza\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_otp_5_digit_patch_v1\apply_flutter_otp_5_digit_v1.ps1
```

اسکریپت Backup می‌گیرد و سپس این موارد را اجرا می‌کند:

```text
dart format
flutter gen-l10n
flutter analyze
flutter test
```

در صورت خطا، فایل‌های اصلی به‌صورت خودکار بازگردانده می‌شوند.
