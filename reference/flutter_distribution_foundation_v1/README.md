# Flutter Distribution Foundation v1

این بسته مرحله زیرساخت Feature توزیع را اضافه می‌کند:

- مدل وضعیت سرویس
- مدل فهرست سفارش‌ها
- مدل جزئیات سفارش و خطوط آن
- پشتیبانی از مقادیر `false` در پاسخ Odoo
- تبدیل Many2oneهای Odoo مانند `[id, name]`
- Data Source مبتنی بر Dio و ApiClient فعلی
- Repository
- Controller فهرست و جزئیات
- تست مدل‌ها و Controllerها

## فایل‌هایی که تغییر نمی‌کنند

- Home و طراحی آن
- Router
- Auth و OTP
- Localization
- Onboarding
- Gateway و Odoo

## اجرا

فایل ZIP را در مسیر زیر Extract کنید:

```text
D:\Development\address_clean_v1\reference\flutter_distribution_foundation_v1
```

سپس:

```powershell
cd d:\development\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_distribution_foundation_v1\apply_distribution_foundation_v1.ps1
```

نتیجه مطلوب:

```text
No issues found!
All tests passed!
DISTRIBUTION FOUNDATION V1 APPLIED SUCCESSFULLY
```
