# Original Onboarding Restore

این بسته UI اصلی Onboarding را بر اساس فایل‌های مرجع پروژه قدیمی بازسازی می‌کند.

## اجرا

1. فایل ZIP را داخل پروژه استخراج کنید، مثلاً:
   `C:\Users\htica\Desktop\Alireza\address_clean_v1\reference\original_onboarding_restore`

2. از ریشه پروژه اجرا کنید:

```powershell
powershell -ExecutionPolicy Bypass -File .\reference\original_onboarding_restore\apply_original_onboarding.ps1
```

اسکریپت قبل از تغییر فایل‌های اصلی Backup می‌سازد و در پایان `flutter analyze` و `flutter test` را اجرا می‌کند.
