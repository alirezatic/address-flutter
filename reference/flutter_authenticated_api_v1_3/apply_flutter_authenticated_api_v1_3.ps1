param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$RequiredFiles = @(
    ".\lib\main.dart",
    ".\lib\core\network\api_client.dart",
    ".\lib\features\auth\application\auth_session_controller.dart"
)

foreach ($file in $RequiredFiles) {
    if (-not (Test-Path $file)) {
        throw "Required project file was not found: $file"
    }
}

$mainContent = Get-Content ".\lib\main.dart" -Raw -Encoding utf8
$apiClientContent = Get-Content ".\lib\core\network\api_client.dart" -Raw -Encoding utf8
$authControllerContent = Get-Content ".\lib\features\auth\application\auth_session_controller.dart" -Raw -Encoding utf8

if ($mainContent -notmatch "AuthSessionController\.instance\.load\(\)") {
    throw "main.dart does not match the expected authenticated project structure. No files were modified."
}

if ($apiClientContent -notmatch "class ApiClient" -or
    $apiClientContent -notmatch "final Dio dio") {
    throw "api_client.dart does not match the expected project structure. No files were modified."
}

if ($authControllerContent -notmatch "String\? get accessToken" -or
    $authControllerContent -notmatch "Future<bool> refreshSession\(\)") {
    throw "AuthSessionController does not expose the required access token and refresh functions. No files were modified."
}

$BundleRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = ".\reference\backups\flutter-authenticated-api-v1-3-$Stamp"
$BackupProjectRoot = Join-Path $BackupRoot "project"

$RelativePaths = @(
    "lib\main.dart",
    "lib\core\network\api_client.dart",
    "lib\core\network\authenticated_api_interceptor.dart",
    "test\core\network\authenticated_api_interceptor_test.dart"
)

New-Item -ItemType Directory -Path $BackupProjectRoot -Force | Out-Null

foreach ($relative in $RelativePaths) {
    $destination = Join-Path $ProjectRoot $relative

    if (Test-Path $destination) {
        $backupDestination = Join-Path $BackupProjectRoot $relative
        $backupParent = Split-Path $backupDestination -Parent
        New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
        Copy-Item $destination $backupDestination -Force
    }
}

function Restore-Project {
    Write-Host "Restoring pre-installation files..."

    foreach ($relative in $RelativePaths) {
        $destination = Join-Path $ProjectRoot $relative
        Remove-Item $destination -Force -ErrorAction SilentlyContinue

        $backupSource = Join-Path $BackupProjectRoot $relative

        if (Test-Path $backupSource) {
            $parent = Split-Path $destination -Parent
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
            Copy-Item $backupSource $destination -Force
        }
    }
}

try {
    foreach ($relative in $RelativePaths) {
        $source = Join-Path $BundleRoot $relative
        $destination = Join-Path $ProjectRoot $relative

        if (-not (Test-Path $source)) {
            throw "Bundle file was not found: $source"
        }

        $parent = Split-Path $destination -Parent
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Copy-Item $source $destination -Force
        Write-Host "Applied: $relative"
    }

    dart format `
        ".\lib\main.dart" `
        ".\lib\core\network\api_client.dart" `
        ".\lib\core\network\authenticated_api_interceptor.dart" `
        ".\test\core\network\authenticated_api_interceptor_test.dart"

    if ($LASTEXITCODE -ne 0) {
        throw "dart format failed."
    }

    flutter analyze

    if ($LASTEXITCODE -ne 0) {
        throw "flutter analyze failed."
    }

    flutter test

    if ($LASTEXITCODE -ne 0) {
        throw "flutter test failed."
    }

    Write-Host ""
    Write-Host "FLUTTER AUTHENTICATED API V1.3 APPLIED SUCCESSFULLY"
    Write-Host "Backup: $BackupRoot"
    Write-Host ""
    Write-Host "Home, Router, Distribution UI, localization and OTP were not changed."
}
catch {
    Restore-Project
    Write-Host ""
    Write-Host "INSTALLATION FAILED AND WAS ROLLED BACK"
    Write-Host "Backup: $BackupRoot"
    throw
}
