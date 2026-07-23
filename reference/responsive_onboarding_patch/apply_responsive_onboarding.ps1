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
$BackupRoot = ".\reference\backups\responsive-onboarding-$Timestamp"
New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

$Targets = @(
    ".\lib\features\onboarding\presentation\widgets\animated_start_button.dart",
    ".\lib\features\onboarding\presentation\screens\onboarding_screen.dart",
    ".\lib\features\auth\presentation\screens\login_sheet.dart",
    ".\lib\features\auth\presentation\screens\otp_sheet.dart"
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
Write-Host "Responsive onboarding patch applied successfully."
Write-Host "Backup: $BackupRoot"
Write-Host "Run web: flutter run -d chrome"
Write-Host "Run Android: flutter run -d emulator-5554"
