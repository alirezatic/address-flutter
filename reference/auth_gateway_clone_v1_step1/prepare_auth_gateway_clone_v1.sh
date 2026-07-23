#!/usr/bin/env sh
set -eu

PLATFORM_ROOT="/opt/platform"
GATEWAY_ROOT="$PLATFORM_ROOT/platform-api-gateway"
COMPOSE_FILE="$PLATFORM_ROOT/docker-compose.yml"
PUBLIC_ENV="$PLATFORM_ROOT/.env"
AUTH_ENV="$PLATFORM_ROOT/secrets/auth_clone.env"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$PLATFORM_ROOT/backups/auth-preparation-$STAMP"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

[ "$(id -u)" -eq 0 ] || fail "Run this script as root."
[ -d "$GATEWAY_ROOT" ] || fail "Gateway directory not found: $GATEWAY_ROOT"
[ -f "$COMPOSE_FILE" ] || fail "Compose file not found: $COMPOSE_FILE"
[ -f "$PUBLIC_ENV" ] || fail "Platform .env not found: $PUBLIC_ENV"

if ! grep -Eq '^[[:space:]]*PLATFORM_ENV=clone[[:space:]]*$' "$PUBLIC_ENV"; then
  fail "Safety check failed: PLATFORM_ENV=clone was not found."
fi

echo "===== BACKUP ====="
umask 077
mkdir -p "$BACKUP_DIR"
cp -a "$GATEWAY_ROOT" "$BACKUP_DIR/"
cp -a "$COMPOSE_FILE" "$BACKUP_DIR/"
cp -a "$PUBLIC_ENV" "$BACKUP_DIR/platform.env"

if [ -d "$PLATFORM_ROOT/secrets" ]; then
  cp -a "$PLATFORM_ROOT/secrets" "$BACKUP_DIR/"
fi

echo "BACKUP_DIR=$BACKUP_DIR"

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 48
  else
    od -An -N48 -tx1 /dev/urandom | tr -d ' \n'
  fi
}

echo "===== AUTH ENV ====="
mkdir -p "$PLATFORM_ROOT/secrets"

if [ ! -f "$AUTH_ENV" ]; then
  ACCESS_SECRET="$(generate_secret)"
  REFRESH_SECRET="$(generate_secret)"
  OTP_SECRET="$(generate_secret)"

  cat > "$AUTH_ENV" <<EOF
AUTH_ENABLED=true
AUTH_ACCESS_TOKEN_SECRET=$ACCESS_SECRET
AUTH_REFRESH_TOKEN_SECRET=$REFRESH_SECRET
AUTH_OTP_HASH_SECRET=$OTP_SECRET
AUTH_ACCESS_TOKEN_TTL_SECONDS=900
AUTH_REFRESH_TOKEN_TTL_SECONDS=2592000
AUTH_OTP_TTL_SECONDS=300
AUTH_OTP_MAX_ATTEMPTS=5
AUTH_OTP_RESEND_COOLDOWN_SECONDS=60
AUTH_EXPOSE_OTP=true
AUTH_TOKEN_ISSUER=platform-api-gateway
AUTH_TOKEN_AUDIENCE=address-flutter
EOF

  echo "Created: $AUTH_ENV"
else
  echo "Kept existing: $AUTH_ENV"
fi

chmod 600 "$AUTH_ENV"

echo "===== COMPOSE UPDATE ====="
if ! grep -Fq './secrets/auth_clone.env' "$COMPOSE_FILE"; then
  awk '
    { print }
    $0 ~ /^[[:space:]]*-[[:space:]]*\.\/secrets\/odoo_clone_api\.env[[:space:]]*$/ {
      print "      - ./secrets/auth_clone.env"
    }
  ' "$COMPOSE_FILE" > "$COMPOSE_FILE.tmp"

  mv "$COMPOSE_FILE.tmp" "$COMPOSE_FILE"
  echo "Added auth_clone.env to docker-compose.yml"
else
  echo "docker-compose.yml already references auth_clone.env"
fi

echo "===== VALIDATION ====="
cd "$PLATFORM_ROOT"
docker compose config >/dev/null
echo "COMPOSE CONFIG: OK"

echo
echo "===== SAFE AUTH ENV ====="
sed -E 's/(SECRET)=.*/\1=***REDACTED***/' "$AUTH_ENV"

echo
echo "===== GATEWAY COMPOSE SECTION ====="
sed -n '/platform-api-gateway:/,/^[^[:space:]]/p' "$COMPOSE_FILE"

echo
echo "STEP 1 SUCCESSFUL"
echo "No container was rebuilt or restarted."
echo "Backup: $BACKUP_DIR"
