# Home UI Cleanup v1

## مشکلات تشخیص‌داده‌شده

1. `BackdropFilter` در هر آیتم PageView در هر فریم دوباره رندر می‌شد.
2. هر `ServiceBannerCard` یک AnimationController دائمی داشت؛ حتی کارت‌های کناری.
3. تغییر اسلاید با `setState` کل Dashboard و Grid را بازسازی می‌کرد.
4. نوار پایین با `Positioned` روی Grid قرار می‌گرفت.
5. Transform سه‌بعدی منو روی Web هزینه GPU زیادی داشت.
6. فونت Vazirmatn در Theme ثبت نشده بود.
7. اندازه فونت و تصاویر برای Desktop سقف مناسب نداشت.

## اصلاحات

- حذف Blur و Transform سه‌بعدی از اسلایدر
- حذف انیمیشن دائمی داخل کارت‌ها
- جداسازی Indicator و Navigation با ValueNotifier
- Precache تصاویر Home
- توقف AutoPlay هنگام تعامل کاربر
- انتقال نوار پایین از Overlay به بخش مستقل Layout
- ساده‌سازی انیمیشن منو به Translate + Scale
- افزودن Responsive Metrics مرکزی
- ثبت Vazirmatn به‌عنوان فونت Theme
- افزودن تست برای عرض موبایل، تبلت و دسکتاپ

## اجرا

```powershell
powershell -executionpolicy bypass -file .\reference\home_ui_cleanup_v1\apply_home_ui_cleanup.ps1
```
