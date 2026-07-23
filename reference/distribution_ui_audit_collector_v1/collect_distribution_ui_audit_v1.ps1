param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$work = ".\reference\distribution_ui_audit_$stamp"
$output = ".\reference\distribution_ui_audit_$stamp.zip"

New-Item -ItemType Directory -Path $work -Force | Out-Null

try {
    $paths = @(
        ".\pubspec.yaml",
        ".\pubspec.lock",
        ".\analysis_options.yaml",
        ".\l10n.yaml",
        ".\lib\main.dart",
        ".\lib\app",
        ".\lib\core\config",
        ".\lib\core\network",
        ".\lib\core\localization",
        ".\lib\core\extensions",
        ".\lib\design_system",
        ".\lib\features\home",
        ".\lib\features\distribution",
        ".\lib\l10n\app_fa.arb",
        ".\lib\l10n\app_en.arb",
        ".\lib\l10n\app_ar.arb",
        ".\lib\l10n\app_zh.arb",
        ".\test\features\distribution",
        ".\test\widget_test.dart",
        ".\reference\api_contract\platform-openapi-v0.10.0.json"
    )

    foreach ($path in $paths) {
        if (-not (Test-Path $path)) {
            continue
        }

        $relative = $path -replace '^[.\\]+', ''
        $destination = Join-Path $work $relative
        $parent = Split-Path $destination -Parent

        if ($parent) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }

        if ((Get-Item $path).PSIsContainer) {
            Copy-Item $path $destination -Recurse -Force
        } else {
            Copy-Item $path $destination -Force
        }
    }

    $inventory = Get-ChildItem $work -Recurse -File |
        ForEach-Object {
            $_.FullName.Substring((Resolve-Path $work).Path.Length + 1)
        } |
        Sort-Object

    $inventory |
        Set-Content (Join-Path $work "FILE_INVENTORY.txt") -Encoding utf8

    @"
Distribution UI Audit
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Project: $ProjectRoot

Purpose:
- Build responsive distribution order list
- Add order details navigation
- Preserve current Home, side menu, animations and localization

Included:
- Current Home screen and widgets
- Router and app bootstrap
- Design system and responsive utilities
- Distribution foundation
- Localization ARB files
- API config and OpenAPI contract
- Distribution tests

Excluded:
- Auth tokens and secure storage contents
- .env files
- secrets
- build outputs
- .dart_tool
- Android SDK / Gradle / Pub caches
- generated binaries
"@ | Set-Content (Join-Path $work "AUDIT_INFO.txt") -Encoding utf8

    Compress-Archive -Path "$work\*" -DestinationPath $output -Force

    Write-Host ""
    Write-Host "DISTRIBUTION UI AUDIT CREATED"
    Write-Host (Resolve-Path $output).Path
}
finally {
    if (Test-Path $work) {
        Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
    }
}
