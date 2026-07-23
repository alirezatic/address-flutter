param(
    [string]$projectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

function write-utf8-no-bom {
    param(
        [string]$path,
        [string]$content
    )

    $parent = Split-Path $path -Parent

    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $content, $encoding)
}

Set-Location $projectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "این اسکریپت باید از ریشه پروژه Flutter اجرا شود."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = ".\reference\backups\onboarding-$timestamp"

New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

$filesToBackup = @(
    ".\lib\main.dart",
    ".\lib\app\app.dart",
    ".\lib\app\router.dart",
    ".\lib\features\onboarding\presentation\screens\onboarding_screen.dart",
    ".\lib\features\onboarding\presentation\widgets\onboarding_rive_background.dart"
)

foreach ($file in $filesToBackup) {
    if (Test-Path $file) {
        $destination = Join-Path $backupRoot ($file -replace '^[.\\]+', '' -replace '[\\/:*?"<>|]', '_')
        Copy-Item $file $destination -Force
    }
}

Write-Host "Backup created at: $backupRoot"

flutter pub add country_picker pin_code_fields

$bundleRoot = Split-Path $MyInvocation.MyCommand.Path -Parent

$sourceFiles = Get-ChildItem -Path (Join-Path $bundleRoot "lib") -Recurse -File

foreach ($sourceFile in $sourceFiles) {
    $relativePath = $sourceFile.FullName.Substring($bundleRoot.Length + 1)
    $destination = Join-Path $projectRoot $relativePath
    $content = Get-Content $sourceFile.FullName -Raw -Encoding utf8
    write-utf8-no-bom -path $destination -content $content
    Write-Host "Written: $relativePath"
}

$dependenciesZip = ".\reference\onboarding_dependencies.zip"

if (-not (Test-Path $dependenciesZip)) {
    throw "فایل $dependenciesZip پیدا نشد."
}

$tempDirectory = Join-Path $env:TEMP "address-onboarding-l10n-$timestamp"

New-Item -ItemType Directory -Path $tempDirectory -Force | Out-Null
Expand-Archive -Path $dependenciesZip -DestinationPath $tempDirectory -Force

$requiredKeys = @(
    "login",
    "welcome",
    "enteryourmobilenumber",
    "mobileNumber",
    "enterMobileError",
    "notDigits",
    "invalidPrefix",
    "enterMobileErrorWithZero",
    "enterMobileErrorWithoutZero",
    "tooShort",
    "networkError",
    "enterOtpCode",
    "didNotReceiveCode",
    "resendCode",
    "changeNumber",
    "or",
    "email",
    "enterFullOtpCode"
)

foreach ($locale in @("fa", "en", "ar", "zh")) {
    $oldArbPath = Join-Path $tempDirectory "app_$locale.arb"
    $currentArbPath = ".\lib\l10n\app_$locale.arb"

    if (-not (Test-Path $oldArbPath)) {
        throw "فایل ترجمه مرجع پیدا نشد: $oldArbPath"
    }

    if (-not (Test-Path $currentArbPath)) {
        throw "فایل ترجمه پروژه پیدا نشد: $currentArbPath"
    }

    $oldArb = Get-Content $oldArbPath -Raw -Encoding utf8 | ConvertFrom-Json
    $currentArb = Get-Content $currentArbPath -Raw -Encoding utf8 | ConvertFrom-Json

    foreach ($key in $requiredKeys) {
        $valueProperty = $oldArb.PSObject.Properties[$key]

        if ($null -eq $valueProperty) {
            throw "کلید $key در $oldArbPath پیدا نشد."
        }

        $currentArb | Add-Member -NotePropertyName $key -NotePropertyValue $valueProperty.Value -Force

        $metadataKey = "@$key"
        $metadataProperty = $oldArb.PSObject.Properties[$metadataKey]

        if ($null -ne $metadataProperty) {
            $currentArb | Add-Member -NotePropertyName $metadataKey -NotePropertyValue $metadataProperty.Value -Force
        }
    }

    $json = $currentArb | ConvertTo-Json -Depth 30
    write-utf8-no-bom -path $currentArbPath -content $json
    Write-Host "Localization merged: $currentArbPath"
}

Remove-Item $tempDirectory -Recurse -Force -ErrorAction SilentlyContinue

flutter gen-l10n
dart format .\lib .\test
flutter analyze
flutter test

Write-Host ""
Write-Host "Original onboarding UI restored successfully."
Write-Host "Run with: flutter run -d emulator-5554"
