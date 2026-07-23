# Flutter Authenticated API v1

این بسته:

- Access Token را خودکار روی درخواست‌های محافظت‌شده می‌فرستد.
- درخواست‌های OTP، Refresh و Logout را از Interceptor مستثنی می‌کند.
- پس از پاسخ `401` فقط یک Refresh انجام می‌دهد.
- درخواست ناموفق را یک بار با Token جدید تکرار می‌کند.
- Refreshهای هم‌زمان را به یک درخواست واحد تبدیل می‌کند.
- در صورت نامعتبرشدن Refresh Token، از رفتار موجود `AuthSessionController` برای پاک‌کردن Session و بازگشت Router به Onboarding استفاده می‌کند.
- UI، Router، Home، Distribution، Localization و OTP را تغییر نمی‌دهد.

## نصب

ZIP را داخل پوشه `reference` پروژه Extract کنید و سپس:

```powershell
cd d:\development\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_authenticated_api_v1\apply_flutter_authenticated_api_v1.ps1
```
