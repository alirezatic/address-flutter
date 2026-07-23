# Auth Gateway Clone v1 — Step 2

این مرحله:

- یک Backup جدید از سورس و تنظیمات می‌گیرد.
- نسخه Gateway را به `0.10.0` ارتقا می‌دهد.
- ماژول OTP/JWT را اضافه می‌کند.
- `ValidationPipe` و Bearer Auth را به Swagger اضافه می‌کند.
- Image جدید را Build می‌کند.
- Image جدید را روی کانتینر موقت و پورت `3100` اجرا می‌کند.
- OTP request/verify، `/me`، Refresh rotation و Logout revocation را آزمایش می‌کند.
- کانتینر اصلی `platform-api-gateway` را Restart یا Recreate نمی‌کند.

## انتقال از Windows PowerShell

```powershell
scp .\reference\auth_gateway_clone_v1_step2\apply_auth_gateway_clone_v1_step2.sh root@65.109.216.87:/root/
```

## اجرا روی سرور

```bash
chmod 700 /root/apply_auth_gateway_clone_v1_step2.sh
/root/apply_auth_gateway_clone_v1_step2.sh
```

## نتیجه مطلوب

```text
STEP 2 SUCCESSFUL
Source, build, OpenAPI and complete auth smoke test passed.
The active gateway container was NOT restarted or replaced.
```

## محدودیت این نسخه

Challengeهای OTP و نشست‌های Refresh در حافظه همان کانتینر نگهداری می‌شوند. این طراحی فقط برای محیط Clone و اتصال اولیه Flutter است. Restart کانتینر نشست‌های Refresh را باطل می‌کند. برای Production باید ذخیره‌سازی پایدار و سرویس پیامک واقعی اضافه شود.
