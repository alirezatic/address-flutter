param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$required = @(
    ".\lib\core\network\api_client.dart",
    ".\lib\core\config\app_config.dart"
)

foreach ($file in $required) {
    if (-not (Test-Path $file)) {
        throw "Required project file was not found: $file"
    }
}

$bundleRoot = Split-Path $PSScriptRoot -Parent
$payload = Join-Path $PSScriptRoot "payload"

if (-not (Test-Path $payload)) {
    throw "Patch payload was not found: $payload"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = ".\reference\backups\distribution-foundation-v1-$stamp"
$libTarget = ".\lib\features\distribution"
$testTarget = ".\test\features\distribution"

New-Item -ItemType Directory -Path $backup -Force | Out-Null

if (Test-Path $libTarget) {
    Copy-Item $libTarget (Join-Path $backup "lib") -Recurse -Force
}

if (Test-Path $testTarget) {
    Copy-Item $testTarget (Join-Path $backup "test") -Recurse -Force
}

function Restore-PreviousState {
    Remove-Item $libTarget -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $testTarget -Recurse -Force -ErrorAction SilentlyContinue

    $backupLib = Join-Path $backup "lib"
    $backupTest = Join-Path $backup "test"

    if (Test-Path $backupLib) {
        New-Item -ItemType Directory -Path (Split-Path $libTarget -Parent) -Force |
            Out-Null
        Copy-Item $backupLib $libTarget -Recurse -Force
    }

    if (Test-Path $backupTest) {
        New-Item -ItemType Directory -Path (Split-Path $testTarget -Parent) -Force |
            Out-Null
        Copy-Item $backupTest $testTarget -Recurse -Force
    }
}

try {
    New-Item -ItemType Directory -Path $libTarget -Force | Out-Null
    New-Item -ItemType Directory -Path $testTarget -Force | Out-Null

    robocopy `
        (Join-Path $payload "lib\features\distribution") `
        $libTarget `
        /E /R:1 /W:1 | Out-Host

    if ($LASTEXITCODE -gt 7) {
        throw "Copying distribution library files failed."
    }

    robocopy `
        (Join-Path $payload "test\features\distribution") `
        $testTarget `
        /E /R:1 /W:1 | Out-Host

    if ($LASTEXITCODE -gt 7) {
        throw "Copying distribution test files failed."
    }

    dart format $libTarget $testTarget

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
    Write-Host "DISTRIBUTION FOUNDATION V1 APPLIED SUCCESSFULLY"
    Write-Host "Backup: $backup"
    Write-Host ""
    Write-Host "No Router, Home UI, localization or authentication file was changed."
}
catch {
    Write-Warning "Patch failed. Restoring the previous distribution files..."
    Restore-PreviousState
    throw
}
