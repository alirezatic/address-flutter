# Flutter Authenticated API v1.3

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
powershell -executionpolicy bypass -file .\reference\flutter_authenticated_api_v1_3\apply_flutter_authenticated_api_v1_3.ps1
```


## اصلاح نسخه 1.1

- سازگاری با Dio پروژه با استفاده مستقیم از کلید `Authorization`
- حذف Import بدون استفاده در تست شبکه
- حفظ Rollback خودکار در صورت هر خطا


## اصلاح نسخه 1.2

- سازگاری با lint `prefer_initializing_formals`
- هماهنگی پارامتر `onError` با امضای Dio برای lint `avoid_renaming_method_parameters`
- حفظ Rollback خودکار


## اصلاح نسخه 1.3

- constructor عمومی با پارامترهای named حفظ شد.
- مقداردهی fieldهای private به constructor خصوصیِ initializing formal منتقل شد.
- lintهای `prefer_initializing_formals` و `unnecessary_this` هم‌زمان برطرف شدند.
- Rollback خودکار همچنان فعال است.
