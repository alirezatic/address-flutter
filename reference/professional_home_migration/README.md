# Professional Home Migration

این بسته صفحه Home حرفه‌ای پروژه قدیمی را به معماری تمیز فعلی منتقل می‌کند.

## موارد منتقل‌شده

- منوی کناری سه‌بعدی
- دکمه متحرک Rive با State Machine اصلی
- اسلایدر خودکار خدمات
- کارت‌های خدمات
- نوار پایین شناور
- انتخاب زبان
- خروج واقعی از حساب و انتقال خودکار به Onboarding
- چیدمان ریسپانسیو موبایل، تبلت و وب

فایل‌های `home_module.dart` و `home_navigator.dart` عمداً منتقل نشده‌اند، چون متعلق به معماری قدیمی و ناقص هستند.

## اجرا

ZIP را داخل مسیر زیر Extract کنید:

`reference\professional_home_migration`

سپس از ریشه پروژه اجرا کنید:

```powershell
powershell -executionpolicy bypass -file .\reference\professional_home_migration\apply_professional_home.ps1
```
