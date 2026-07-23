# Dio 5.10 Auth Compatibility Patch

این Patch فقط فایل زیر را تغییر می‌دهد:

```text
lib/features/auth/data/datasources/auth_remote_data_source.dart
```

اصلاح‌ها:

1. جایگزینی `Headers.authorizationHeader` با `'Authorization'`
2. افزودن `DioExceptionType.transformTimeout` به خطاهای شبکه

هیچ فایل UI، Home، Onboarding یا Animation تغییر نمی‌کند.

## اجرا

```powershell
cd c:\users\htica\desktop\alireza\address_clean_v1
powershell -executionpolicy bypass -file .\reference\dio_5_10_auth_compat_patch\apply_dio_5_10_auth_compat.ps1
```
