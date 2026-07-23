# Flutter Auth Audit Collector

این اسکریپت فقط فایل‌های لازم برای اتصال Login و OTP فعلی Flutter به Gateway نسخه 0.10.0 را جمع‌آوری می‌کند.

هیچ فایل پروژه‌ای را تغییر نمی‌دهد.

## اجرا

در PowerShell:

```powershell
cd c:\users\htica\desktop\alireza\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_auth_audit_collector\collect_flutter_auth_audit.ps1
```

خروجی:

```text
reference\flutter_auth_audit_<timestamp>.zip
```

فایل ZIP تولیدشده را در گفتگو بارگذاری کنید.
