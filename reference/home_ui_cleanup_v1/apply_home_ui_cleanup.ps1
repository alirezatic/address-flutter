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

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = ".\reference\backups\home-ui-cleanup-$Timestamp"
New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

$Targets = @(
    ".\lib\features\home\presentation\screens\home_screen.dart",
    ".\lib\features\home\presentation\widgets\dashboard_content.dart",
    ".\lib\features\home\presentation\widgets\service_banner_card.dart",
    ".\lib\features\home\presentation\widgets\service_section_card.dart",
    ".\lib\features\home\presentation\layout\home_layout_metrics.dart",
    ".\lib\design_system\theme\app_theme.dart",
    ".\test\features\home\home_layout_metrics_test.dart"
)

foreach ($Target in $Targets) {
    if (Test-Path $Target) {
        $BackupName = ($Target -replace '^[.\\]+', '') -replace '[\\/:*?"<>|]', '_'
        Copy-Item $Target (Join-Path $BackupRoot $BackupName) -Force
    }
}

$BundleRoot = Split-Path $MyInvocation.MyCommand.Path -Parent

foreach ($FolderName in @("lib", "test")) {
    $SourceRoot = Join-Path $BundleRoot $FolderName

    foreach ($SourceFile in Get-ChildItem $SourceRoot -Recurse -File) {
        $RelativePath = $SourceFile.FullName.Substring($BundleRoot.Length + 1)
        $Destination = Join-Path $ProjectRoot $RelativePath
        $Content = Get-Content $SourceFile.FullName -Raw -Encoding utf8
        Write-Utf8NoBom -Path $Destination -Content $Content
        Write-Host "Written: $RelativePath"
    }
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
Write-Host "Home UI cleanup applied successfully."
Write-Host "Backup: $BackupRoot"
Write-Host "Web: flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8091"
Write-Host "Android: flutter run -d emulator-5554"
