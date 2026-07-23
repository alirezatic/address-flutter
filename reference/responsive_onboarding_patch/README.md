# Responsive Onboarding Patch

این بسته چهار بخش را بدون تغییر هویت بصری اصلاح می‌کند:

- اندازه ثابت و کنترل‌شده دکمه شروع
- عرض حداکثری 520 پیکسل برای فرم Login
- عرض حداکثری 520 پیکسل برای فرم OTP
- محدودکردن خانه‌های OTP به ناحیه 250 تا 320 پیکسل
- تناسب لوگو و پس‌زمینه در موبایل و دسکتاپ
- حفظ انیمیشن‌ها، رنگ‌ها، لوگو و Rive

## اجرا

فایل ZIP را در مسیر زیر Extract کنید:

`reference\responsive_onboarding_patch`

سپس از ریشه پروژه اجرا کنید:

```powershell
powershell -executionpolicy bypass -file .\reference\responsive_onboarding_patch\apply_responsive_onboarding.ps1
```
