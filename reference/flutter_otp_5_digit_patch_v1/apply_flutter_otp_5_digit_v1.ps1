param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$files = @(
    ".\lib\features\auth\presentation\screens\otp_sheet.dart",
    ".\lib\l10n\app_fa.arb",
    ".\lib\l10n\app_en.arb",
    ".\lib\l10n\app_ar.arb",
    ".\lib\l10n\app_zh.arb",
    ".\test\features\auth\auth_models_test.dart",
    ".\test\features\auth\login_controller_test.dart",
    ".\test\features\auth\otp_controller_test.dart"
)

foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        throw "Required file was not found: $file"
    }
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = ".\reference\backups\flutter-otp5-$stamp"
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Backup-File {
    param([string]$Path)

    $relative = $Path -replace '^[.\\]+', ''
    $destination = Join-Path $backupRoot $relative
    $parent = Split-Path $destination -Parent

    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    Copy-Item $Path $destination -Force
}

function Restore-Backup {
    foreach ($file in $files) {
        $relative = $file -replace '^[.\\]+', ''
        $source = Join-Path $backupRoot $relative

        if (Test-Path $source) {
            Copy-Item $source $file -Force
        }
    }

    flutter gen-l10n | Out-Host
}

function Replace-Exact {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New,
        [int]$ExpectedCount = 1
    )

    $content = Get-Content $Path -Raw -Encoding utf8
    $actualCount = ([regex]::Matches(
        $content,
        [regex]::Escape($Old)
    )).Count

    if ($actualCount -ne $ExpectedCount) {
        throw "Expected $ExpectedCount occurrence(s), but found $actualCount in $Path.`nPattern: $Old"
    }

    $updated = $content.Replace($Old, $New)
    [System.IO.File]::WriteAllText(
        (Resolve-Path $Path).Path,
        $updated,
        $utf8
    )
}

New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

foreach ($file in $files) {
    Backup-File $file
}

try {
    $otpSheet = ".\lib\features\auth\presentation\screens\otp_sheet.dart"

    $otpSheetContent = Get-Content $otpSheet -Raw -Encoding utf8

    if ($otpSheetContent -notmatch 'static const int _otpLength = 5;') {
        Replace-Exact `
            -Path $otpSheet `
            -Old "  static const double _maximumCardWidth = 520;" `
            -New "  static const double _maximumCardWidth = 520;`r`n  static const int _otpLength = 5;"
    }

    Replace-Exact `
        -Path $otpSheet `
        -Old "developmentOtp.length != 6" `
        -New "developmentOtp.length != _otpLength"

    Replace-Exact `
        -Path $otpSheet `
        -Old "otp.length != 6" `
        -New "otp.length != _otpLength"

    Replace-Exact `
        -Path $otpSheet `
        -Old "final fieldSize = ((pinAreaWidth - 30) / 6)" `
        -New "final fieldSize = ((pinAreaWidth - 24) / _otpLength)"

    Replace-Exact `
        -Path $otpSheet `
        -Old "length: 6," `
        -New "length: _otpLength,"

    Replace-Exact `
        -Path ".\lib\l10n\app_fa.arb" `
        -Old '"enterFullOtpCode": "لطفاً کد ۶ رقمی را کامل وارد کنید"' `
        -New '"enterFullOtpCode": "لطفاً کد ۵ رقمی را کامل وارد کنید"'

    Replace-Exact `
        -Path ".\lib\l10n\app_en.arb" `
        -Old '"enterFullOtpCode": "Please enter the full 6-digit code"' `
        -New '"enterFullOtpCode": "Please enter the full 5-digit code"'

    Replace-Exact `
        -Path ".\lib\l10n\app_ar.arb" `
        -Old '"enterFullOtpCode": "يرجى إدخال الرمز الكامل المكوّن من 6 أرقام"' `
        -New '"enterFullOtpCode": "يرجى إدخال الرمز الكامل المكوّن من 5 أرقام"'

    Replace-Exact `
        -Path ".\lib\l10n\app_zh.arb" `
        -Old '"enterFullOtpCode": "请输入完整的6位验证码"' `
        -New '"enterFullOtpCode": "请输入完整的5位验证码"'

    Replace-Exact `
        -Path ".\test\features\auth\auth_models_test.dart" `
        -Old "'developmentOtp': '123456'," `
        -New "'developmentOtp': '12345',"

    Replace-Exact `
        -Path ".\test\features\auth\auth_models_test.dart" `
        -Old "expect(entity.developmentOtp, '123456');" `
        -New "expect(entity.developmentOtp, '12345');"

    Replace-Exact `
        -Path ".\test\features\auth\login_controller_test.dart" `
        -Old "developmentOtp: '123456'," `
        -New "developmentOtp: '12345',"

    Replace-Exact `
        -Path ".\test\features\auth\otp_controller_test.dart" `
        -Old "controller.verify('123456')" `
        -New "controller.verify('12345')"

    Replace-Exact `
        -Path ".\test\features\auth\otp_controller_test.dart" `
        -Old "expect(repository.verifiedOtp, '123456');" `
        -New "expect(repository.verifiedOtp, '12345');"

    Replace-Exact `
        -Path ".\test\features\auth\otp_controller_test.dart" `
        -Old "controller.verify('000000')" `
        -New "controller.verify('00000')"

    Replace-Exact `
        -Path ".\test\features\auth\otp_controller_test.dart" `
        -Old "developmentOtp: '123456'," `
        -New "developmentOtp: '12345',"

    Replace-Exact `
        -Path ".\test\features\auth\otp_controller_test.dart" `
        -Old "developmentOtp: '654321'," `
        -New "developmentOtp: '54321',"

    $remaining = Select-String `
        -Path $otpSheet `
        -Pattern "developmentOtp\.length != 6|otp\.length != 6|length:\s*6|pinAreaWidth - 30\) / 6"

    if ($remaining) {
        throw "A six-digit runtime setting still exists in otp_sheet.dart."
    }

    dart format `
        ".\lib\features\auth\presentation\screens\otp_sheet.dart" `
        ".\test\features\auth\auth_models_test.dart" `
        ".\test\features\auth\login_controller_test.dart" `
        ".\test\features\auth\otp_controller_test.dart"

    if ($LASTEXITCODE -ne 0) {
        throw "dart format failed."
    }

    flutter gen-l10n

    if ($LASTEXITCODE -ne 0) {
        throw "flutter gen-l10n failed."
    }

    flutter analyze

    if ($LASTEXITCODE -ne 0) {
        throw "flutter analyze failed."
    }

    flutter test

    if ($LASTEXITCODE -ne 0) {
        throw "flutter test failed."
    }

    $contractDirectory = ".\reference\api_contract"
    $contractPath = Join-Path $contractDirectory "platform-openapi-v0.10.0.json"

    New-Item -ItemType Directory -Path $contractDirectory -Force | Out-Null

    curl.exe `
        --fail `
        --show-error `
        --location `
        --http1.1 `
        --connect-timeout 5 `
        --max-time 30 `
        "http://127.0.0.1:3000/docs-json" `
        --output $contractPath

    if ($LASTEXITCODE -eq 0) {
        Write-Host "OpenAPI contract refreshed: $contractPath"
    } else {
        Write-Warning "Flutter patch succeeded, but OpenAPI refresh was skipped because the SSH tunnel was unavailable."
    }

    Write-Host ""
    Write-Host "FLUTTER OTP 5-DIGIT PATCH APPLIED SUCCESSFULLY"
    Write-Host "Backup: $backupRoot"
}
catch {
    Write-Warning "Patch failed. Restoring original files..."
    Restore-Backup
    throw
}
