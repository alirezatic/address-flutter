# Auth Gateway Clone v1 — Step 1

این مرحله فقط کارهای زیر را انجام می‌دهد:

- کنترل می‌کند محیط `clone` باشد.
- از Gateway، Compose، `.env` و پوشه Secrets نسخه پشتیبان می‌گیرد.
- فایل `secrets/auth_clone.env` را با Secretهای تصادفی ایجاد می‌کند.
- فایل Auth را به `docker-compose.yml` اضافه می‌کند.
- صحت Compose را بررسی می‌کند.
- هیچ کانتینری را Build، Restart یا Recreate نمی‌کند.

## انتقال از Windows PowerShell

از پوشه پروژه Flutter:

```powershell
scp .\reference\auth_gateway_clone_v1_step1\prepare_auth_gateway_clone_v1.sh root@65.109.216.87:/root/
```

## اجرا روی سرور

```bash
chmod 700 /root/prepare_auth_gateway_clone_v1.sh
/root/prepare_auth_gateway_clone_v1.sh
```

خروجی نهایی مطلوب:

```text
COMPOSE CONFIG: OK
STEP 1 SUCCESSFUL
No container was rebuilt or restarted.
```
