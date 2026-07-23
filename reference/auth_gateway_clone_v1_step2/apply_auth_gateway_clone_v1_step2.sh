#!/usr/bin/env sh
set -eu

PLATFORM_ROOT="/opt/platform"
GATEWAY_ROOT="$PLATFORM_ROOT/platform-api-gateway"
COMPOSE_FILE="$PLATFORM_ROOT/docker-compose.yml"
PUBLIC_ENV="$PLATFORM_ROOT/.env"
ODOO_ENV="$PLATFORM_ROOT/secrets/odoo_clone_api.env"
AUTH_ENV="$PLATFORM_ROOT/secrets/auth_clone.env"
TEMP_CONTAINER="platform-api-gateway-auth-smoke"
TEMP_PORT="3100"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$PLATFORM_ROOT/backups/auth-source-v1-$STAMP"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

cleanup() {
  docker rm -f "$TEMP_CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

[ "$(id -u)" -eq 0 ] || fail "Run this script as root."
[ -d "$GATEWAY_ROOT/src" ] || fail "Gateway source not found: $GATEWAY_ROOT"
[ -f "$COMPOSE_FILE" ] || fail "Compose file not found: $COMPOSE_FILE"
[ -f "$PUBLIC_ENV" ] || fail "Platform .env not found: $PUBLIC_ENV"
[ -f "$ODOO_ENV" ] || fail "Odoo clone env not found: $ODOO_ENV"
[ -f "$AUTH_ENV" ] || fail "Auth clone env not found: $AUTH_ENV"

if ! grep -Eq '^[[:space:]]*PLATFORM_ENV=clone[[:space:]]*$' "$PUBLIC_ENV"; then
  fail "Safety check failed: PLATFORM_ENV=clone was not found."
fi

if ! grep -Eq '^[[:space:]]*AUTH_ENABLED=true[[:space:]]*$' "$AUTH_ENV"; then
  fail "Safety check failed: AUTH_ENABLED=true was not found."
fi

echo "===== 1. BACKUP ====="
umask 077
mkdir -p "$BACKUP_DIR"
cp -a "$GATEWAY_ROOT" "$BACKUP_DIR/"
cp -a "$COMPOSE_FILE" "$BACKUP_DIR/"
cp -a "$PUBLIC_ENV" "$BACKUP_DIR/platform.env"
cp -a "$AUTH_ENV" "$BACKUP_DIR/auth_clone.env"
echo "BACKUP_DIR=$BACKUP_DIR"

echo "===== 2. PACKAGE.JSON ====="
cat > "$GATEWAY_ROOT/package.json" <<'EOF'
{
  "name": "platform-api-gateway",
  "version": "0.10.0",
  "private": true,
  "scripts": {
    "build": "nest build",
    "start:prod": "node dist/main.js"
  },
  "dependencies": {
    "@nestjs/common": "^11.0.0",
    "@nestjs/core": "^11.0.0",
    "@nestjs/jwt": "11.0.2",
    "@nestjs/platform-express": "^11.0.0",
    "@nestjs/swagger": "^11.0.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.1",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^11.0.0",
    "@nestjs/schematics": "^11.0.0",
    "@nestjs/testing": "^11.0.0",
    "@types/node": "^22.0.0",
    "typescript": "^5.7.0"
  }
}
EOF

echo "===== 3. AUTH DTO FILES ====="
mkdir -p "$GATEWAY_ROOT/src/auth/dto"

cat > "$GATEWAY_ROOT/src/auth/dto/request-otp.dto.ts" <<'EOF'
import { ApiProperty } from '@nestjs/swagger';
import { IsString, Matches } from 'class-validator';

export class RequestOtpDto {
  @ApiProperty({
    example: '+989121234567',
    description: 'Phone number in E.164 format',
  })
  @IsString()
  @Matches(/^\+[1-9]\d{7,14}$/, {
    message: 'phone must be a valid E.164 number',
  })
  phone!: string;
}
EOF

cat > "$GATEWAY_ROOT/src/auth/dto/verify-otp.dto.ts" <<'EOF'
import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsUUID, Matches } from 'class-validator';

export class VerifyOtpDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('4')
  challengeId!: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @Matches(/^\d{6}$/, {
    message: 'otp must contain exactly 6 digits',
  })
  otp!: string;
}
EOF

cat > "$GATEWAY_ROOT/src/auth/dto/refresh-token.dto.ts" <<'EOF'
import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class RefreshTokenDto {
  @ApiProperty({
    description: 'Refresh JWT returned by OTP verification',
  })
  @IsString()
  @MinLength(20)
  refreshToken!: string;
}
EOF

echo "===== 4. AUTH TYPES AND OPENAPI ====="
cat > "$GATEWAY_ROOT/src/auth/auth.types.ts" <<'EOF'
export interface AccessTokenPayload {
  sub: string;
  phone: string;
  type: 'access';
  iat?: number;
  exp?: number;
  iss?: string;
  aud?: string | string[];
}

export interface RefreshTokenPayload {
  sub: string;
  phone: string;
  type: 'refresh';
  jti: string;
  iat?: number;
  exp?: number;
  iss?: string;
  aud?: string | string[];
}

export interface AuthenticatedRequest {
  headers: Record<string, string | string[] | undefined>;
  user?: AccessTokenPayload;
}
EOF

cat > "$GATEWAY_ROOT/src/auth/auth.openapi.ts" <<'EOF'
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AuthUserDto {
  @ApiProperty()
  id!: string;

  @ApiProperty({ example: '+989121234567' })
  phone!: string;
}

export class OtpRequestResponseDto {
  @ApiProperty({ format: 'uuid' })
  challengeId!: string;

  @ApiProperty()
  expiresInSeconds!: number;

  @ApiProperty()
  retryAfterSeconds!: number;

  @ApiProperty({ enum: ['clone-development'] })
  delivery!: string;

  @ApiPropertyOptional({
    example: '123456',
    description:
      'Only returned in clone when AUTH_EXPOSE_OTP=true',
  })
  developmentOtp?: string;

  @ApiProperty({ format: 'date-time' })
  timestamp!: string;
}

export class AuthTokensResponseDto {
  @ApiProperty({ example: 'Bearer' })
  tokenType!: string;

  @ApiProperty()
  accessToken!: string;

  @ApiProperty()
  accessTokenExpiresInSeconds!: number;

  @ApiProperty()
  refreshToken!: string;

  @ApiProperty()
  refreshTokenExpiresInSeconds!: number;

  @ApiProperty({ type: AuthUserDto })
  user!: AuthUserDto;

  @ApiProperty({ format: 'date-time' })
  timestamp!: string;
}

export class AuthMeResponseDto {
  @ApiProperty({ type: AuthUserDto })
  user!: AuthUserDto;

  @ApiProperty({ enum: ['clone-only'] })
  scope!: string;

  @ApiProperty({ format: 'date-time' })
  timestamp!: string;
}

export class AuthLogoutResponseDto {
  @ApiProperty()
  revoked!: boolean;

  @ApiProperty({ format: 'date-time' })
  timestamp!: string;
}
EOF

echo "===== 5. AUTH SERVICE ====="
cat > "$GATEWAY_ROOT/src/auth/auth.service.ts" <<'EOF'
import {
  HttpException,
  HttpStatus,
  Injectable,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import {
  createHash,
  createHmac,
  randomInt,
  randomUUID,
  timingSafeEqual,
} from 'node:crypto';
import {
  AccessTokenPayload,
  RefreshTokenPayload,
} from './auth.types';

interface OtpChallenge {
  phone: string;
  otpHash: string;
  expiresAt: number;
  attempts: number;
  used: boolean;
}

interface RefreshSession {
  userId: string;
  phone: string;
  expiresAt: number;
}

@Injectable()
export class AuthService {
  private readonly otpChallenges = new Map<string, OtpChallenge>();
  private readonly phoneCooldowns = new Map<string, number>();
  private readonly refreshSessions =
    new Map<string, RefreshSession>();

  constructor(private readonly jwtService: JwtService) {}

  requestOtp(phone: string) {
    this.assertCloneAuthEnabled();

    const now = Date.now();
    this.cleanup(now);

    const cooldownUntil = this.phoneCooldowns.get(phone) ?? 0;

    if (cooldownUntil > now) {
      const retryAfterSeconds = Math.ceil(
        (cooldownUntil - now) / 1000,
      );

      throw new HttpException(
        {
          statusCode: HttpStatus.TOO_MANY_REQUESTS,
          message: 'OTP was requested too recently',
          retryAfterSeconds,
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const challengeId = randomUUID();
    const otp = randomInt(100000, 1000000).toString();
    const ttlSeconds = this.numberEnv(
      'AUTH_OTP_TTL_SECONDS',
      300,
    );
    const cooldownSeconds = this.numberEnv(
      'AUTH_OTP_RESEND_COOLDOWN_SECONDS',
      60,
    );

    this.otpChallenges.set(challengeId, {
      phone,
      otpHash: this.hashOtp(challengeId, otp),
      expiresAt: now + ttlSeconds * 1000,
      attempts: 0,
      used: false,
    });

    this.phoneCooldowns.set(
      phone,
      now + cooldownSeconds * 1000,
    );

    return {
      challengeId,
      expiresInSeconds: ttlSeconds,
      retryAfterSeconds: cooldownSeconds,
      delivery: 'clone-development',
      developmentOtp:
        process.env.AUTH_EXPOSE_OTP === 'true'
          ? otp
          : undefined,
      timestamp: new Date().toISOString(),
    };
  }

  async verifyOtp(challengeId: string, otp: string) {
    this.assertCloneAuthEnabled();

    const now = Date.now();
    this.cleanup(now);

    const challenge = this.otpChallenges.get(challengeId);

    if (!challenge || challenge.used || challenge.expiresAt <= now) {
      throw new UnauthorizedException(
        'OTP challenge is invalid or expired',
      );
    }

    const maxAttempts = this.numberEnv(
      'AUTH_OTP_MAX_ATTEMPTS',
      5,
    );

    if (challenge.attempts >= maxAttempts) {
      this.otpChallenges.delete(challengeId);

      throw new UnauthorizedException(
        'OTP attempt limit exceeded',
      );
    }

    challenge.attempts += 1;

    if (
      !this.safeEqual(
        challenge.otpHash,
        this.hashOtp(challengeId, otp),
      )
    ) {
      if (challenge.attempts >= maxAttempts) {
        this.otpChallenges.delete(challengeId);
      }

      throw new UnauthorizedException('OTP is invalid');
    }

    challenge.used = true;
    this.otpChallenges.delete(challengeId);

    return this.issueTokenPair(challenge.phone);
  }

  async refresh(refreshToken: string) {
    this.assertCloneAuthEnabled();

    const payload = await this.verifyRefreshToken(refreshToken);
    const sessionKey = this.hashValue(payload.jti);
    const session = this.refreshSessions.get(sessionKey);
    const now = Date.now();

    if (
      !session ||
      session.expiresAt <= now ||
      session.userId !== payload.sub ||
      session.phone !== payload.phone
    ) {
      this.refreshSessions.delete(sessionKey);

      throw new UnauthorizedException(
        'Refresh token is revoked or expired',
      );
    }

    this.refreshSessions.delete(sessionKey);

    return this.issueTokenPair(payload.phone);
  }

  async logout(refreshToken: string) {
    this.assertCloneAuthEnabled();

    const payload = await this.verifyRefreshToken(refreshToken);
    this.refreshSessions.delete(this.hashValue(payload.jti));

    return {
      revoked: true,
      timestamp: new Date().toISOString(),
    };
  }

  async verifyAccessToken(
    token: string,
  ): Promise<AccessTokenPayload> {
    this.assertCloneAuthEnabled();

    try {
      const payload =
        await this.jwtService.verifyAsync<AccessTokenPayload>(
          token,
          {
            secret: this.requiredEnv(
              'AUTH_ACCESS_TOKEN_SECRET',
            ),
            issuer: this.tokenIssuer,
            audience: this.tokenAudience,
          },
        );

      if (
        payload.type !== 'access' ||
        !payload.sub ||
        !payload.phone
      ) {
        throw new UnauthorizedException(
          'Access token payload is invalid',
        );
      }

      return payload;
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }

      throw new UnauthorizedException(
        'Access token is invalid or expired',
      );
    }
  }

  me(payload: AccessTokenPayload) {
    return {
      user: {
        id: payload.sub,
        phone: payload.phone,
      },
      scope: 'clone-only',
      timestamp: new Date().toISOString(),
    };
  }

  private async issueTokenPair(phone: string) {
    const userId = createHmac(
      'sha256',
      this.requiredEnv('AUTH_OTP_HASH_SECRET'),
    )
      .update(`user:${phone}`)
      .digest('hex')
      .slice(0, 32);

    const refreshJti = randomUUID();
    const accessTtlSeconds = this.numberEnv(
      'AUTH_ACCESS_TOKEN_TTL_SECONDS',
      900,
    );
    const refreshTtlSeconds = this.numberEnv(
      'AUTH_REFRESH_TOKEN_TTL_SECONDS',
      2592000,
    );

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: userId,
          phone,
          type: 'access',
        } satisfies AccessTokenPayload,
        {
          secret: this.requiredEnv(
            'AUTH_ACCESS_TOKEN_SECRET',
          ),
          expiresIn: accessTtlSeconds,
          issuer: this.tokenIssuer,
          audience: this.tokenAudience,
        },
      ),
      this.jwtService.signAsync(
        {
          sub: userId,
          phone,
          type: 'refresh',
          jti: refreshJti,
        } satisfies RefreshTokenPayload,
        {
          secret: this.requiredEnv(
            'AUTH_REFRESH_TOKEN_SECRET',
          ),
          expiresIn: refreshTtlSeconds,
          issuer: this.tokenIssuer,
          audience: this.tokenAudience,
        },
      ),
    ]);

    this.refreshSessions.set(this.hashValue(refreshJti), {
      userId,
      phone,
      expiresAt: Date.now() + refreshTtlSeconds * 1000,
    });

    return {
      tokenType: 'Bearer',
      accessToken,
      accessTokenExpiresInSeconds: accessTtlSeconds,
      refreshToken,
      refreshTokenExpiresInSeconds: refreshTtlSeconds,
      user: {
        id: userId,
        phone,
      },
      timestamp: new Date().toISOString(),
    };
  }

  private async verifyRefreshToken(
    token: string,
  ): Promise<RefreshTokenPayload> {
    try {
      const payload =
        await this.jwtService.verifyAsync<RefreshTokenPayload>(
          token,
          {
            secret: this.requiredEnv(
              'AUTH_REFRESH_TOKEN_SECRET',
            ),
            issuer: this.tokenIssuer,
            audience: this.tokenAudience,
          },
        );

      if (
        payload.type !== 'refresh' ||
        !payload.jti ||
        !payload.sub ||
        !payload.phone
      ) {
        throw new UnauthorizedException(
          'Refresh token payload is invalid',
        );
      }

      return payload;
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }

      throw new UnauthorizedException(
        'Refresh token is invalid or expired',
      );
    }
  }

  private cleanup(now: number) {
    for (const [challengeId, challenge] of this.otpChallenges) {
      if (challenge.expiresAt <= now || challenge.used) {
        this.otpChallenges.delete(challengeId);
      }
    }

    for (const [phone, cooldownUntil] of this.phoneCooldowns) {
      if (cooldownUntil <= now) {
        this.phoneCooldowns.delete(phone);
      }
    }

    for (const [sessionKey, session] of this.refreshSessions) {
      if (session.expiresAt <= now) {
        this.refreshSessions.delete(sessionKey);
      }
    }
  }

  private hashOtp(challengeId: string, otp: string): string {
    return createHmac(
      'sha256',
      this.requiredEnv('AUTH_OTP_HASH_SECRET'),
    )
      .update(`${challengeId}:${otp}`)
      .digest('hex');
  }

  private hashValue(value: string): string {
    return createHash('sha256').update(value).digest('hex');
  }

  private safeEqual(left: string, right: string): boolean {
    const leftBuffer = Buffer.from(left, 'hex');
    const rightBuffer = Buffer.from(right, 'hex');

    return (
      leftBuffer.length === rightBuffer.length &&
      timingSafeEqual(leftBuffer, rightBuffer)
    );
  }

  private numberEnv(name: string, fallback: number): number {
    const parsed = Number(process.env[name] ?? fallback);

    if (!Number.isFinite(parsed) || parsed <= 0) {
      return fallback;
    }

    return Math.floor(parsed);
  }

  private requiredEnv(name: string): string {
    const value = process.env[name]?.trim();

    if (!value) {
      throw new ServiceUnavailableException(
        `Required auth configuration is missing: ${name}`,
      );
    }

    return value;
  }

  private assertCloneAuthEnabled() {
    if (
      process.env.PLATFORM_ENV !== 'clone' ||
      process.env.AUTH_ENABLED !== 'true'
    ) {
      throw new ServiceUnavailableException(
        'Clone authentication service is disabled',
      );
    }
  }

  private get tokenIssuer(): string {
    return (
      process.env.AUTH_TOKEN_ISSUER ||
      'platform-api-gateway'
    );
  }

  private get tokenAudience(): string {
    return (
      process.env.AUTH_TOKEN_AUDIENCE ||
      'address-flutter'
    );
  }
}
EOF

echo "===== 6. ACCESS GUARD ====="
cat > "$GATEWAY_ROOT/src/auth/access-token.guard.ts" <<'EOF'
import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthenticatedRequest } from './auth.types';

@Injectable()
export class AccessTokenGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  async canActivate(
    context: ExecutionContext,
  ): Promise<boolean> {
    const request = context
      .switchToHttp()
      .getRequest<AuthenticatedRequest>();

    const authorization = request.headers.authorization;
    const header = Array.isArray(authorization)
      ? authorization[0]
      : authorization;

    if (!header?.startsWith('Bearer ')) {
      throw new UnauthorizedException(
        'Bearer access token is required',
      );
    }

    const token = header.slice('Bearer '.length).trim();

    if (!token) {
      throw new UnauthorizedException(
        'Bearer access token is required',
      );
    }

    request.user =
      await this.authService.verifyAccessToken(token);

    return true;
  }
}
EOF

echo "===== 7. AUTH CONTROLLER AND MODULE ====="
cat > "$GATEWAY_ROOT/src/auth/auth.controller.ts" <<'EOF'
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from './access-token.guard';
import {
  AuthLogoutResponseDto,
  AuthMeResponseDto,
  AuthTokensResponseDto,
  OtpRequestResponseDto,
} from './auth.openapi';
import { AuthService } from './auth.service';
import { AuthenticatedRequest } from './auth.types';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';

@ApiTags('auth')
@Controller('/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/otp/request')
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({
    summary:
      'Create an OTP challenge in the clone environment',
  })
  @ApiAcceptedResponse({ type: OtpRequestResponseDto })
  requestOtp(@Body() dto: RequestOtpDto) {
    return this.authService.requestOtp(dto.phone);
  }

  @Post('/otp/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Verify OTP and issue access/refresh tokens',
  })
  @ApiOkResponse({ type: AuthTokensResponseDto })
  verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(
      dto.challengeId,
      dto.otp,
    );
  }

  @Post('/refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Rotate refresh token and issue a new token pair',
  })
  @ApiOkResponse({ type: AuthTokensResponseDto })
  refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refresh(dto.refreshToken);
  }

  @Post('/logout')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Revoke a refresh token' })
  @ApiOkResponse({ type: AuthLogoutResponseDto })
  logout(@Body() dto: RefreshTokenDto) {
    return this.authService.logout(dto.refreshToken);
  }

  @Get('/me')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth('access-token')
  @ApiOperation({
    summary: 'Return the authenticated clone user',
  })
  @ApiOkResponse({ type: AuthMeResponseDto })
  me(@Request() request: AuthenticatedRequest) {
    if (!request.user) {
      throw new Error(
        'Authenticated user was not attached to the request',
      );
    }

    return this.authService.me(request.user);
  }
}
EOF

cat > "$GATEWAY_ROOT/src/auth/auth.module.ts" <<'EOF'
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AccessTokenGuard } from './access-token.guard';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  imports: [JwtModule.register({})],
  controllers: [AuthController],
  providers: [AuthService, AccessTokenGuard],
  exports: [AuthService],
})
export class AuthModule {}
EOF

echo "===== 8. APP MODULE ====="
cat > "$GATEWAY_ROOT/src/app.module.ts" <<'EOF'
import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { DistributionController } from './distribution.controller';
import { HealthController } from './health.controller';
import { PlatformController } from './platform.controller';

@Module({
  imports: [AuthModule],
  controllers: [
    HealthController,
    PlatformController,
    DistributionController,
  ],
  providers: [],
})
export class AppModule {}
EOF

echo "===== 9. MAIN.TS ====="
cat > "$GATEWAY_ROOT/src/main.ts" <<'EOF'
import 'reflect-metadata';
import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import {
  DocumentBuilder,
  SwaggerModule,
} from '@nestjs/swagger';
import { AppModule } from './app.module';

function isAllowedOrigin(
  origin: string | undefined,
): boolean {
  if (!origin) {
    return true;
  }

  const allowedOrigins = (
    process.env.CORS_ALLOWED_ORIGINS || ''
  )
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean);

  if (allowedOrigins.includes(origin)) {
    return true;
  }

  if (process.env.CORS_ALLOW_LOCALHOST === 'true') {
    try {
      const url = new URL(origin);

      return ['localhost', '127.0.0.1'].includes(
        url.hostname,
      );
    } catch {
      return false;
    }
  }

  return false;
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: (
      origin: string | undefined,
      callback: (
        error: Error | null,
        allow?: boolean,
      ) => void,
    ) => {
      if (isAllowedOrigin(origin)) {
        callback(null, true);
      } else {
        callback(
          new Error(`CORS blocked origin: ${origin}`),
          false,
        );
      }
    },
    credentials: true,
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: [
      'Content-Type',
      'Authorization',
    ],
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.setGlobalPrefix('api/v1');

  const config = new DocumentBuilder()
    .setTitle('Super App Platform API')
    .setDescription(
      'Platform API Gateway for Distribution-first Super App',
    )
    .setVersion('0.10.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
      'access-token',
    )
    .addTag('platform')
    .addTag('auth')
    .addTag('distribution')
    .build();

  const document =
    SwaggerModule.createDocument(app, config);

  SwaggerModule.setup('docs', app, document);

  const port = Number(
    process.env.PLATFORM_PORT || 3000,
  );

  await app.listen(port, '0.0.0.0');
}

void bootstrap();
EOF

echo "===== 10. PLATFORM VERSION ====="
cat > "$GATEWAY_ROOT/src/platform.controller.ts" <<'EOF'
import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('platform')
@Controller('/platform')
export class PlatformController {
  @Get('/info')
  info() {
    return {
      name: 'Super App Platform API Gateway',
      version: '0.10.0',
      mode: process.env.PLATFORM_ENV || 'unknown',
      odooBaseUrl:
        process.env.ODOO_BASE_URL || null,
      odooDb: process.env.ODOO_DB || null,
      scope: 'clone-only',
    };
  }
}
EOF

echo "===== 11. COMPOSE VALIDATION ====="
cd "$PLATFORM_ROOT"
docker compose config >/dev/null
echo "COMPOSE CONFIG: OK"

echo "===== 12. BUILD IMAGE ONLY ====="
docker compose build platform-api-gateway
echo "IMAGE BUILD: OK"

IMAGE_ID="$(docker compose images -q platform-api-gateway)"
[ -n "$IMAGE_ID" ] || fail "Built image ID was not found."
echo "BUILT_IMAGE_ID=$IMAGE_ID"

echo "===== 13. COMPILED AUTH FILES ====="
docker run --rm \
  --entrypoint sh \
  "$IMAGE_ID" \
  -lc '
    test -f /app/dist/main.js
    test -f /app/dist/auth/auth.controller.js
    test -f /app/dist/auth/auth.service.js
    test -f /app/dist/auth/access-token.guard.js
    echo "COMPILED FILES: OK"
  '

echo "===== 14. TEMPORARY CONTAINER ====="
cleanup

docker run -d \
  --name "$TEMP_CONTAINER" \
  --env-file "$PUBLIC_ENV" \
  --env-file "$ODOO_ENV" \
  --env-file "$AUTH_ENV" \
  --network distribution_default \
  -p "127.0.0.1:$TEMP_PORT:3000" \
  "$IMAGE_ID" >/dev/null

READY="false"
attempt=1

while [ "$attempt" -le 30 ]; do
  if curl -fsS \
    "http://127.0.0.1:$TEMP_PORT/api/v1/health" \
    >/dev/null 2>&1; then
    READY="true"
    break
  fi

  sleep 1
  attempt=$((attempt + 1))
done

if [ "$READY" != "true" ]; then
  docker logs "$TEMP_CONTAINER" || true
  fail "Temporary gateway did not become ready."
fi

echo "TEMP GATEWAY HEALTH: OK"

echo "===== 15. OPENAPI CHECK ====="
OPENAPI_JSON="$(curl -fsS \
  "http://127.0.0.1:$TEMP_PORT/docs-json")"

printf '%s' "$OPENAPI_JSON" |
  grep -Fq '"/api/v1/auth/otp/request"'

printf '%s' "$OPENAPI_JSON" |
  grep -Fq '"/api/v1/auth/otp/verify"'

printf '%s' "$OPENAPI_JSON" |
  grep -Fq '"/api/v1/auth/refresh"'

printf '%s' "$OPENAPI_JSON" |
  grep -Fq '"/api/v1/auth/logout"'

printf '%s' "$OPENAPI_JSON" |
  grep -Fq '"/api/v1/auth/me"'

echo "OPENAPI AUTH PATHS: OK"

echo "===== 16. OTP REQUEST ====="
OTP_RESPONSE="$(curl -fsS \
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"phone":"+989121234567"}' \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/otp/request")"

CHALLENGE_ID="$(printf '%s' "$OTP_RESPONSE" |
  sed -n 's/.*"challengeId":"\([^"]*\)".*/\1/p')"

OTP_CODE="$(printf '%s' "$OTP_RESPONSE" |
  sed -n 's/.*"developmentOtp":"\([^"]*\)".*/\1/p')"

[ -n "$CHALLENGE_ID" ] ||
  fail "challengeId was not returned."

[ -n "$OTP_CODE" ] ||
  fail "developmentOtp was not returned."

echo "OTP REQUEST: OK"

echo "===== 17. OTP VERIFY ====="
VERIFY_RESPONSE="$(curl -fsS \
  -X POST \
  -H 'Content-Type: application/json' \
  -d "{\"challengeId\":\"$CHALLENGE_ID\",\"otp\":\"$OTP_CODE\"}" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/otp/verify")"

ACCESS_TOKEN="$(printf '%s' "$VERIFY_RESPONSE" |
  sed -n 's/.*"accessToken":"\([^"]*\)".*/\1/p')"

REFRESH_TOKEN="$(printf '%s' "$VERIFY_RESPONSE" |
  sed -n 's/.*"refreshToken":"\([^"]*\)".*/\1/p')"

[ -n "$ACCESS_TOKEN" ] ||
  fail "accessToken was not returned."

[ -n "$REFRESH_TOKEN" ] ||
  fail "refreshToken was not returned."

echo "OTP VERIFY: OK"

echo "===== 18. AUTH ME ====="
ME_RESPONSE="$(curl -fsS \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/me")"

printf '%s' "$ME_RESPONSE" |
  grep -Fq '"phone":"+989121234567"'

echo "AUTH ME: OK"

echo "===== 19. REFRESH ROTATION ====="
REFRESH_RESPONSE="$(curl -fsS \
  -X POST \
  -H 'Content-Type: application/json' \
  -d "{\"refreshToken\":\"$REFRESH_TOKEN\"}" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/refresh")"

NEW_REFRESH_TOKEN="$(printf '%s' "$REFRESH_RESPONSE" |
  sed -n 's/.*"refreshToken":"\([^"]*\)".*/\1/p')"

[ -n "$NEW_REFRESH_TOKEN" ] ||
  fail "Rotated refreshToken was not returned."

OLD_REFRESH_STATUS="$(curl -sS \
  -o /tmp/auth-old-refresh-response.json \
  -w '%{http_code}' \
  -X POST \
  -H 'Content-Type: application/json' \
  -d "{\"refreshToken\":\"$REFRESH_TOKEN\"}" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/refresh")"

[ "$OLD_REFRESH_STATUS" = "401" ] ||
  fail "Old refresh token was not revoked after rotation."

echo "REFRESH ROTATION: OK"

echo "===== 20. LOGOUT ====="
curl -fsS \
  -X POST \
  -H 'Content-Type: application/json' \
  -d "{\"refreshToken\":\"$NEW_REFRESH_TOKEN\"}" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/logout" \
  >/dev/null

LOGGED_OUT_STATUS="$(curl -sS \
  -o /tmp/auth-logged-out-response.json \
  -w '%{http_code}' \
  -X POST \
  -H 'Content-Type: application/json' \
  -d "{\"refreshToken\":\"$NEW_REFRESH_TOKEN\"}" \
  "http://127.0.0.1:$TEMP_PORT/api/v1/auth/refresh")"

[ "$LOGGED_OUT_STATUS" = "401" ] ||
  fail "Logged-out refresh token was still accepted."

echo "LOGOUT REVOCATION: OK"

echo "===== 21. ACTIVE CONTAINER CHECK ====="
ACTIVE_CONTAINER_ID="$(docker inspect \
  -f '{{.Id}}' platform-api-gateway)"

ACTIVE_STARTED_AT="$(docker inspect \
  -f '{{.State.StartedAt}}' platform-api-gateway)"

echo "ACTIVE_CONTAINER_ID=$ACTIVE_CONTAINER_ID"
echo "ACTIVE_STARTED_AT=$ACTIVE_STARTED_AT"
echo "Active container was not replaced."

echo
echo "STEP 2 SUCCESSFUL"
echo "Source, build, OpenAPI and complete auth smoke test passed."
echo "The active gateway container was NOT restarted or replaced."
echo "Backup: $BACKUP_DIR"
echo "Built image: $IMAGE_ID"
