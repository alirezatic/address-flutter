param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
Set-Location $ProjectRoot

if (-not (Test-Path ".\pubspec.yaml")) {
    throw "Run this script from the Flutter project root."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$work = ".\reference\flutter_auth_audit_$stamp"
$output = ".\reference\flutter_auth_audit_$stamp.zip"

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
        ".\lib\core\storage",
        ".\lib\core\error",
        ".\lib\features\auth",
        ".\lib\features\onboarding",
        ".\lib\l10n\app_fa.arb",
        ".\lib\l10n\app_en.arb",
        ".\lib\l10n\app_ar.arb",
        ".\lib\l10n\app_zh.arb",
        ".\test"
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

    $openApiDirectory = ".\reference\api_contract"
    New-Item -ItemType Directory -Path $openApiDirectory -Force | Out-Null

    $openApiPath = Join-Path $openApiDirectory "platform-openapi-v0.10.0.json"
    $openApiUrl = "http://127.0.0.1:3000/docs-json"

    Write-Host "Checking Gateway health..."

    curl.exe `
      --fail `
      --show-error `
      --http1.1 `
      --retry 3 `
      --retry-delay 2 `
      --retry-all-errors `
      --connect-timeout 5 `
      --max-time 30 `
      "http://127.0.0.1:3000/api/v1/health" `
      | Out-Null

    $healthExitCode = $LASTEXITCODE

    if ($healthExitCode -ne 0) {
        Write-Warning "Gateway health check failed. Existing OpenAPI file will be checked."
    }

    $downloadSucceeded = $false

    if ($healthExitCode -eq 0) {
        Write-Host "Downloading Gateway OpenAPI..."

        curl.exe `
          --fail `
          --show-error `
          --location `
          --http1.1 `
          --retry 4 `
          --retry-delay 2 `
          --retry-all-errors `
          --connect-timeout 5 `
          --max-time 90 `
          $openApiUrl `
          --output $openApiPath

        $downloadSucceeded = (
            $LASTEXITCODE -eq 0 -and
            (Test-Path $openApiPath) -and
            (Get-Item $openApiPath).Length -gt 100
        )
    }

    if (-not $downloadSucceeded) {
        $validExistingOpenApi = (
            (Test-Path $openApiPath) -and
            (Get-Item $openApiPath).Length -gt 100
        )

        if (-not $validExistingOpenApi) {
            throw "OpenAPI download failed and no valid cached OpenAPI file exists. Restart the SSH tunnel and run again."
        }

        Write-Warning "Using existing cached OpenAPI file: $openApiPath"
    }

    $openApiText = Get-Content $openApiPath -Raw

    if (
        $openApiText -notmatch '/api/v1/auth/otp/request' -or
        $openApiText -notmatch '/api/v1/auth/otp/verify' -or
        $openApiText -notmatch '/api/v1/auth/me'
    ) {
        throw "The OpenAPI file does not contain the v0.10.0 authentication endpoints."
    }

    Copy-Item $openApiPath (Join-Path $work "platform-openapi-v0.10.0.json") -Force

    $inventory = Get-ChildItem $work -Recurse -File |
        ForEach-Object {
            $_.FullName.Substring((Resolve-Path $work).Path.Length + 1)
        } |
        Sort-Object

    $inventory |
        Set-Content (Join-Path $work "FILE_INVENTORY.txt") -Encoding utf8

    @"
Flutter Auth Audit
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Project: $ProjectRoot

Included:
- Current auth and onboarding source
- Router and app bootstrap
- Config, network, storage and error source when present
- Localization ARB files
- Tests
- pubspec files
- Gateway OpenAPI v0.10.0

Excluded:
- .env files
- secrets
- build outputs
- .dart_tool
- platform folders
- asset binaries
"@ | Set-Content (Join-Path $work "AUDIT_INFO.txt") -Encoding utf8

    Compress-Archive -Path "$work\*" -DestinationPath $output -Force

    Write-Host ""
    Write-Host "AUDIT CREATED"
    Write-Host (Resolve-Path $output).Path
}
finally {
    if (Test-Path $work) {
        Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
    }
}
