param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$ExpectedHashes = @{
    ".\\lib\\app\\router.dart" = "7cd98c77203bfe925a0c621ed0047609b4d53206c5fedac44ac6406b2c715e25"
    ".\\lib\\features\\auth\\application\\auth_session_controller.dart" = "708f5eeedbd5f20fa7f93187e6667b65aa8f47a5a362e625ab67f2cc41c982a4"
    ".\\lib\\features\\auth\\presentation\\controllers\\login_controller.dart" = "e333f75303f162c9df06133c2c1c7287ed20d00c13362006cd4f22d5e3cb3ce2"
    ".\\lib\\features\\auth\\presentation\\screens\\login_sheet.dart" = "9d308cdbafb52175e11622240f72b942f90706e6fb706ab4804c57b29124e96d"
    ".\\lib\\features\\auth\\presentation\\screens\\otp_sheet.dart" = "d3f7646fb2e1c73d32cb1b8fc66ddcb2003d4ed4bd0dcf6f6011cf00d7333fbf"
    ".\\lib\\features\\onboarding\\presentation\\screens\\onboarding_screen.dart" = "4ce4978f7334747818c91e142d271bcabf788e44c0e6698dcf0e79cb15a62e92"
    ".\\lib\\l10n\\app_fa.arb" = "9825b5fa3c2a97a252ac404a148465432b011808dc27cd52b9672b7750432211"
    ".\\lib\\l10n\\app_en.arb" = "a254f6eb7fffe4659d5dc8a7bfb2e7faa45dc3a85f172c110fe570d9a3318830"
    ".\\lib\\l10n\\app_ar.arb" = "57eedd92ba0fc926cbe249f46033473409c2c2de961a0daf4f3155f4c7f88921"
    ".\\lib\\l10n\\app_zh.arb" = "f8a2fc4dac69af9ab17de8900fb1917775fe002a0c2174e1950cec56055df43c"
}

foreach ($entry in $ExpectedHashes.GetEnumerator()) {
    if (-not (Test-Path $entry.Key)) {
        throw "Required source file not found: $($entry.Key)"
    }

    $actualHash = (Get-FileHash -Path $entry.Key -Algorithm SHA256).Hash.ToLowerInvariant()

    if ($actualHash -ne $entry.Value) {
        throw "Source mismatch: $($entry.Key). The project changed after the audit, so no files were modified."
    }
}

$BundleRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = ".\reference\backups\flutter-auth-gateway-v1-$Stamp"
$BackupProjectRoot = Join-Path $BackupRoot "project"
$GeneratedPath = ".\lib\l10n\generated"
$GeneratedBackup = Join-Path $BackupRoot "generated"

New-Item -ItemType Directory -Path $BackupProjectRoot -Force | Out-Null

$SourceFiles = @(
    Get-ChildItem (Join-Path $BundleRoot "lib") -Recurse -File
    Get-ChildItem (Join-Path $BundleRoot "test") -Recurse -File
)

$RelativePaths = @()

foreach ($source in $SourceFiles) {
    $relative = $source.FullName.Substring($BundleRoot.Length + 1)
    $RelativePaths += $relative
    $destination = Join-Path $ProjectRoot $relative

    if (Test-Path $destination) {
        $backupDestination = Join-Path $BackupProjectRoot $relative
        $backupParent = Split-Path $backupDestination -Parent
        New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
        Copy-Item $destination $backupDestination -Force
    }
}

if (Test-Path $GeneratedPath) {
    Copy-Item $GeneratedPath $GeneratedBackup -Recurse -Force
}

function Restore-Project {
    Write-Host "Restoring pre-installation files..."

    foreach ($relative in $RelativePaths) {
        $destination = Join-Path $ProjectRoot $relative
        Remove-Item $destination -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $BackupProjectRoot) {
        Get-ChildItem $BackupProjectRoot -Recurse -File | ForEach-Object {
            $relative = $_.FullName.Substring($BackupProjectRoot.Length + 1)
            $destination = Join-Path $ProjectRoot $relative
            $parent = Split-Path $destination -Parent
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
            Copy-Item $_.FullName $destination -Force
        }
    }

    Remove-Item $GeneratedPath -Recurse -Force -ErrorAction SilentlyContinue

    if (Test-Path $GeneratedBackup) {
        $generatedParent = Split-Path $GeneratedPath -Parent
        New-Item -ItemType Directory -Path $generatedParent -Force | Out-Null
        Copy-Item $GeneratedBackup $GeneratedPath -Recurse -Force
    }
}

try {
    foreach ($source in $SourceFiles) {
        $relative = $source.FullName.Substring($BundleRoot.Length + 1)
        $destination = Join-Path $ProjectRoot $relative
        $parent = Split-Path $destination -Parent

        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Copy-Item $source.FullName $destination -Force
        Write-Host "Applied: $relative"
    }

    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        throw "flutter pub get failed."
    }

    flutter gen-l10n
    if ($LASTEXITCODE -ne 0) {
        throw "flutter gen-l10n failed."
    }

    $DartTargets = $RelativePaths |
        Where-Object { $_.EndsWith(".dart") } |
        ForEach-Object { Join-Path $ProjectRoot $_ }

    & dart format @DartTargets
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
    Write-Host "FLUTTER AUTH GATEWAY V1 APPLIED SUCCESSFULLY"
    Write-Host "Backup: $BackupRoot"
}
catch {
    Restore-Project
    Write-Host ""
    Write-Host "INSTALLATION FAILED AND WAS ROLLED BACK"
    Write-Host "Backup: $BackupRoot"
    throw
}
