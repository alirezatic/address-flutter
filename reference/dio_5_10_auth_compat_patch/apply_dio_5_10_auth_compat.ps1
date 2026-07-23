param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

$target = ".\lib\features\auth\data\datasources\auth_remote_data_source.dart"

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

if (-not (Test-Path $target)) {
    throw "Target file was not found: $target"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = ".\reference\backups\dio-auth-compat-$stamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item $target (Join-Path $backupDir "auth_remote_data_source.dart") -Force

$content = Get-Content $target -Raw -Encoding utf8

$oldHeader = "Headers.authorizationHeader: 'Bearer `$accessToken',"
$newHeader = "'Authorization': 'Bearer `$accessToken',"

if (-not $content.Contains($oldHeader)) {
    throw "Expected Dio authorization header line was not found. No changes were made."
}

$content = $content.Replace($oldHeader, $newHeader)

$oldSwitch = @"
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => AuthFailureKind.network,
"@

$newSwitch = @"
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => AuthFailureKind.network,
"@

if (-not $content.Contains($oldSwitch)) {
    throw "Expected Dio exception switch block was not found. No changes were written."
}

$content = $content.Replace($oldSwitch, $newSwitch)

$encoding = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText(
    (Resolve-Path $target).Path,
    $content,
    $encoding
)

Write-Host "Patched: $target"
Write-Host "Backup: $backupDir"

dart format $target
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
Write-Host "DIO 5.10 AUTH COMPATIBILITY PATCH APPLIED SUCCESSFULLY"
