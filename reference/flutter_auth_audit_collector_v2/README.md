# Flutter Auth Audit Collector v2

این نسخه:

- Gateway را ابتدا با `/api/v1/health` بررسی می‌کند.
- دانلود OpenAPI را با HTTP/1.1 و چند Retry انجام می‌دهد.
- در صورت قطع موقت Tunnel از فایل OpenAPI معتبر ذخیره‌شده استفاده می‌کند.
- وجود endpointهای Auth نسخه 0.10.0 را کنترل می‌کند.
- هیچ فایل Flutter را تغییر نمی‌دهد.

## اجرا

```powershell
cd c:\users\htica\desktop\alireza\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_auth_audit_collector_v2\collect_flutter_auth_audit_v2.ps1
```

خروجی:

```text
reference\flutter_auth_audit_<timestamp>.zip
```
