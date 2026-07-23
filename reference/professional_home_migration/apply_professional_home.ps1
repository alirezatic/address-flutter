param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $Parent = Split-Path $Path -Parent

    if ($Parent) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }

    $Encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}

$RequiredAssets = @(
    ".\assets\rive\menu_button.riv",
    ".\assets\images\logo\address.png",
    ".\assets\images\address\image1.png",
    ".\assets\images\address\image2.png",
    ".\assets\images\address\image3.png",
    ".\assets\images\address\images4.png",
    ".\assets\images\vehicles\Eco.png",
    ".\assets\images\vehicles\Bike.png",
    ".\assets\images\vehicles\Airport.png",
    ".\assets\images\vehicles\Carseat.png",
    ".\assets\images\vehicles\Lux.png",
    ".\assets\images\vehicles\Pet.png"
)

foreach ($Asset in $RequiredAssets) {
    if (-not (Test-Path $Asset)) {
        throw "Required asset was not found: $Asset"
    }
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = ".\reference\backups\professional-home-$Timestamp"
New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

$Targets = @(
    ".\lib\features\home\presentation\screens\home_screen.dart",
    ".\lib\features\home\data\models\service_model.dart",
    ".\lib\features\home\presentation\widgets\animated_menu_button.dart",
    ".\lib\features\home\presentation\widgets\dashboard_content.dart",
    ".\lib\features\home\presentation\widgets\service_banner_card.dart",
    ".\lib\features\home\presentation\widgets\service_section_card.dart",
    ".\lib\features\home\presentation\widgets\side_menu.dart",
    ".\lib\l10n\app_fa.arb",
    ".\lib\l10n\app_en.arb",
    ".\lib\l10n\app_ar.arb",
    ".\lib\l10n\app_zh.arb"
)

foreach ($Target in $Targets) {
    if (Test-Path $Target) {
        $BackupName = ($Target -replace '^[.\\]+', '') -replace '[\\/:*?"<>|]', '_'
        Copy-Item $Target (Join-Path $BackupRoot $BackupName) -Force
    }
}

$BundleRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$SourceRoot = Join-Path $BundleRoot "lib"

foreach ($SourceFile in Get-ChildItem $SourceRoot -Recurse -File) {
    $RelativePath = $SourceFile.FullName.Substring($BundleRoot.Length + 1)
    $Destination = Join-Path $ProjectRoot $RelativePath
    $Content = Get-Content $SourceFile.FullName -Raw -Encoding utf8
    Write-Utf8NoBom -Path $Destination -Content $Content
    Write-Host "Written: $RelativePath"
}

$FragmentRoot = Join-Path $BundleRoot "l10n"

foreach ($Locale in @("fa", "en", "ar", "zh")) {
    $CurrentPath = ".\lib\l10n\app_$Locale.arb"
    $FragmentPath = Join-Path $FragmentRoot "app_$Locale.arb"

    if (-not (Test-Path $CurrentPath)) {
        throw "Current localization file was not found: $CurrentPath"
    }

    $Current = Get-Content $CurrentPath -Raw -Encoding utf8 | ConvertFrom-Json
    $Fragment = Get-Content $FragmentPath -Raw -Encoding utf8 | ConvertFrom-Json

    foreach ($Property in $Fragment.PSObject.Properties) {
        if ($Property.Name -eq "@@locale") {
            continue
        }

        $Current | Add-Member `
            -NotePropertyName $Property.Name `
            -NotePropertyValue $Property.Value `
            -Force
    }

    $Json = $Current | ConvertTo-Json -Depth 40
    Write-Utf8NoBom -Path $CurrentPath -Content $Json
    Write-Host "Localization merged: $CurrentPath"
}

flutter gen-l10n
if ($LASTEXITCODE -ne 0) {
    throw "flutter gen-l10n failed."
}

dart format .\lib .\test
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
Write-Host "Professional Home migration applied successfully."
Write-Host "Backup: $BackupRoot"
Write-Host "Web: flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8091"
Write-Host "Android: flutter run -d emulator-5554"
