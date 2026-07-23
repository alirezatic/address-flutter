# Distribution UI Audit Collector v1

این ابزار فقط فایل‌های لازم برای ساخت UI بخش Distribution را جمع‌آوری می‌کند و هیچ فایل پروژه‌ای را تغییر نمی‌دهد.

## اجرا

```powershell
cd d:\development\address_clean_v1
powershell -executionpolicy bypass -file .\reference\distribution_ui_audit_collector_v1\collect_distribution_ui_audit_v1.ps1
```

خروجی:

```text
reference\distribution_ui_audit_<timestamp>.zip
```

همان ZIP خروجی را در گفتگو بارگذاری کنید.
