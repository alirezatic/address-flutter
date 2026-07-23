# Restore Original Menu Geometry

این بسته فقط سه فایل منو را اصلاح می‌کند و به Dashboard، اسلایدر، کارت‌ها و فونت‌ها دست نمی‌زند.

مقادیر دقیق برگرفته از کد اصلی:

- عرض SideMenu: 288
- جابه‌جایی Dashboard: 265
- Scale نهایی Dashboard: 0.9
- چرخش Dashboard: 30 درجه
- جابه‌جایی دکمه: 216
- اندازه دکمه: 50
- ارتفاع آیتم منو: 58
- عرض Highlight انتخاب‌شده: 256
- پشتیبانی آینه‌ای RTL/LTR

## اجرا

```powershell
powershell -executionpolicy bypass -file .\reference\restore_original_menu_geometry\apply_original_menu_geometry.ps1
```
