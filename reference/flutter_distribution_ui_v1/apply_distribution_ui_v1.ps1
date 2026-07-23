param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$payload = Join-Path $PSScriptRoot "payload"

if (-not (Test-Path $payload)) {
    throw "Patch payload was not found: $payload"
}

$requiredFoundation = @(
    ".\lib\core\network\api_client.dart",
    ".\lib\features\distribution\data\datasources\distribution_remote_data_source.dart",
    ".\lib\features\distribution\domain\repositories\distribution_repository.dart",
    ".\lib\features\distribution\presentation\controllers\distribution_orders_controller.dart",
    ".\lib\features\distribution\presentation\controllers\distribution_order_details_controller.dart"
)

foreach ($file in $requiredFoundation) {
    if (-not (Test-Path $file)) {
        throw "Distribution Foundation v1 is incomplete. Missing: $file"
    }
}

$expectedHashes = @{
    ".\lib\app\router.dart" = "A6702F26C7383A1D1A95B2101D223944E67C899A5D649157861D03B8421FF5DF"
    ".\lib\features\home\presentation\widgets\dashboard_content.dart" = "E85D2D5892301A6E4CBA6A0C8062282C3B7F3B2589AB1B56843B679EF11FD6E7"
    ".\lib\l10n\app_fa.arb" = "115D0E75CAFE31626D8EFA4C0D92DF1CE301CA916CDF9F94AE87FE354E5A5056"
    ".\lib\l10n\app_en.arb" = "FC5DE446AD504BC4D2C5DAA07C8BBDAF93420C847E4A86C0CAA1A05DFE192384"
    ".\lib\l10n\app_ar.arb" = "38E4A290AEEA92FEDC6D4FF1A4439EC6A18494B36737334544BA2CD57F16148E"
    ".\lib\l10n\app_zh.arb" = "6B4AAFC73AC73C70B4C466EB9821ACCB8A8BF4454FF97457FFA348AC9B19ADED"
    ".\test\widget_test.dart" = "F6E84F02E83418659AF8FEAA109CBCAC86C4C8C484F4C902A5D034CBED4C3B23"
}

foreach ($entry in $expectedHashes.GetEnumerator()) {
    if (-not (Test-Path $entry.Key)) {
        throw "Required current project file was not found: $($entry.Key)"
    }

    $actualHash = (Get-FileHash $entry.Key -Algorithm SHA256).Hash

    if ($actualHash -ne $entry.Value) {
        throw "Audit hash mismatch for $($entry.Key). No project file was changed. Create a fresh UI audit before applying this package."
    }
}

$newFiles = @(
    ".\lib\app\route_paths.dart"
    ".\lib\features\distribution\presentation\screens\distribution_order_details_screen.dart"
    ".\lib\features\distribution\presentation\screens\distribution_orders_screen.dart"
    ".\lib\features\distribution\presentation\utils\distribution_presenter.dart"
    ".\lib\features\distribution\presentation\widgets\distribution_order_card.dart"
    ".\lib\features\distribution\presentation\widgets\distribution_state_view.dart"
    ".\lib\features\distribution\presentation\widgets\distribution_status_badge.dart"
    ".\test\features\distribution\distribution_screens_test.dart"
)

foreach ($file in $newFiles) {
    if (Test-Path $file) {
        throw "A new integration file already exists: $file. No project file was changed."
    }
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = ".\reference\backups\distribution-ui-v1-$stamp"
New-Item -ItemType Directory -Path $backup -Force | Out-Null

function Copy-WithRelativePath {
    param(
        [string]$Source,
        [string]$Root,
        [string]$DestinationRoot
    )

    $rootPath = (Resolve-Path $Root).Path.TrimEnd('\')
    $sourcePath = (Resolve-Path $Source).Path
    $relative = $sourcePath.Substring($rootPath.Length + 1)
    $destination = Join-Path $DestinationRoot $relative
    $parent = Split-Path $destination -Parent

    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    Copy-Item $sourcePath $destination -Force
}

foreach ($file in $expectedHashes.Keys) {
    Copy-WithRelativePath `
        -Source $file `
        -Root $ProjectRoot `
        -DestinationRoot $backup
}

$generatedPath = ".\lib\l10n\generated"
$generatedBackup = Join-Path $backup "lib\l10n\generated"

if (Test-Path $generatedPath) {
    New-Item -ItemType Directory -Path (Split-Path $generatedBackup -Parent) -Force |
        Out-Null
    Copy-Item $generatedPath $generatedBackup -Recurse -Force
}

$payloadFiles = Get-ChildItem $payload -Recurse -File

function Restore-Project {
    foreach ($payloadFile in $payloadFiles) {
        $relative = $payloadFile.FullName.Substring(
            (Resolve-Path $payload).Path.TrimEnd('\').Length + 1
        )
        $target = Join-Path $ProjectRoot $relative

        Remove-Item $target -Force -ErrorAction SilentlyContinue
    }

    $backupFiles = Get-ChildItem $backup -Recurse -File

    foreach ($backupFile in $backupFiles) {
        $relative = $backupFile.FullName.Substring(
            (Resolve-Path $backup).Path.TrimEnd('\').Length + 1
        )
        $target = Join-Path $ProjectRoot $relative
        $parent = Split-Path $target -Parent

        if ($parent) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }

        Copy-Item $backupFile.FullName $target -Force
    }

    if (Test-Path $generatedBackup) {
        Remove-Item $generatedPath -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item $generatedBackup $generatedPath -Recurse -Force
    }
}

try {
    foreach ($payloadFile in $payloadFiles) {
        $relative = $payloadFile.FullName.Substring(
            (Resolve-Path $payload).Path.TrimEnd('\').Length + 1
        )
        $target = Join-Path $ProjectRoot $relative
        $parent = Split-Path $target -Parent

        if ($parent) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }

        Copy-Item $payloadFile.FullName $target -Force
    }

    dart format `
        ".\lib\app\router.dart" `
        ".\lib\app\route_paths.dart" `
        ".\lib\features\home\presentation\widgets\dashboard_content.dart" `
        ".\lib\features\distribution\presentation" `
        ".\test\widget_test.dart" `
        ".\test\features\distribution\distribution_screens_test.dart"

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

    Write-Host ""
    Write-Host "DISTRIBUTION UI V1 APPLIED SUCCESSFULLY"
    Write-Host "Backup: $backup"
    Write-Host ""
    Write-Host "Home geometry, side-menu animation and authentication flow were preserved."
}
catch {
    Write-Warning "Distribution UI patch failed. Restoring the project..."
    Restore-Project
    throw
}
