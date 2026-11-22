# Web/PWA release packager (Windows PowerShell)
# Usage: powershell -ExecutionPolicy Bypass -File tool/web/build_web.ps1
# Optional: -SkipPubGet, -OutDir dist\web
#
# Produces:
#   dist\web\FishTextAdventure-<version>-web\                 static site
#   dist\web\FishTextAdventure-<version>-cloudflare-pages.zip upload for Pages
#   dist\web\FishTextAdventure-<version>-cloudflare-pages.zip.sha256
param(
    [switch]$SkipPubGet,
    [string]$OutDir = "dist\web"
)

$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $root

$flutter = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if (-not $flutter -and $env:FLUTTER_ROOT) {
    $candidate = Join-Path $env:FLUTTER_ROOT 'bin\flutter.bat'
    if (Test-Path $candidate) { $flutter = $candidate }
}
if (-not $flutter -or -not (Test-Path $flutter)) {
    throw 'Flutter SDK not found. Add flutter to PATH or set FLUTTER_ROOT.'
}

$version = (Select-String -Path pubspec.yaml -Pattern '^version:\s*([0-9.]+)' `
    | Select-Object -First 1).Matches[0].Groups[1].Value
if (-not $version) { $version = '0.5.8' }

if (-not $SkipPubGet) {
    Write-Host '== flutter pub get ==' -ForegroundColor Cyan
    & $flutter pub get
    if ($LASTEXITCODE -ne 0) { throw 'pub get failed' }
}

Write-Host '== flutter build web --release ==' -ForegroundColor Cyan
# Bundle CanvasKit locally so the service worker can cache a complete offline
# shell (no runtime dependency on gstatic.com).
& $flutter build web --release --no-web-resources-cdn
if ($LASTEXITCODE -ne 0) { throw 'Web build failed' }

# --- Remove debug-only artefacts that must never be published -------------
# CanvasKit .symbols files and skwasm/wimp variants are for debugging or the
# WASM build; this app is a dart2js/CanvasKit build.
$debugFiles = @('flutter.js.map', '.last_build_id', 'flutter_service_worker.js')
foreach ($file in $debugFiles) {
    $path = Join-Path 'build\web' $file
    if (Test-Path $path) { Remove-Item $path -Force }
}
Get-ChildItem 'build\web\canvaskit' -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like '*.symbols' -or $_.Name -like 'skwasm*' -or $_.Name -like 'wimp*' } |
    Remove-Item -Force
# webparagraph is a CanvasKit variant only selected by an explicit build flag;
# this app does not enable it.
$webParagraph = 'build\web\canvaskit\webparagraph'
if (Test-Path $webParagraph) { Remove-Item $webParagraph -Recurse -Force }

# Remove the now-dangling source-map comment from the Flutter JS loader files.
foreach ($jsName in @('flutter.js', 'flutter_bootstrap.js')) {
    $jsPath = Join-Path 'build\web' $jsName
    if (-not (Test-Path $jsPath)) { continue }
    $js = [System.IO.File]::ReadAllText((Resolve-Path $jsPath), [System.Text.Encoding]::UTF8)
    $js = [regex]::Replace($js, '(?m)^\s*//# sourceMappingURL=.*$', '')
    [System.IO.File]::WriteAllText((Resolve-Path $jsPath), $js, (New-Object System.Text.UTF8Encoding($false)))
}

# Flutter copies custom web/ files; make sure the host header rules are there.
if (-not (Test-Path 'build\web\_headers')) {
    Copy-Item 'web\_headers' 'build\web\_headers'
}

$required = @(
    'index.html',
    'diagnostics.html',
    'legacy.html',
    'manifest.json',
    'main.dart.js',
    'flutter_bootstrap.js',
    'service_worker.js',
    'sqlite3.wasm',
    'drift_worker.js',
    '_headers',
    'canvaskit\canvaskit.wasm',
    'icons\Icon-192.png',
    'icons\Icon-512.png',
    'icons\Icon-180.png'
)
foreach ($file in $required) {
    if (-not (Test-Path (Join-Path 'build\web' $file))) {
        throw "Build output is missing $file"
    }
}

$target = Join-Path $OutDir "FishTextAdventure-$version-web"
if (Test-Path $target) { Remove-Item $target -Recurse -Force }
New-Item -ItemType Directory -Path $target -Force | Out-Null

# Give every build a unique service-worker cache name so a new deployment does
# not keep serving the previous build's assets.
$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
$swPath = Join-Path 'build\web' 'service_worker.js'
$sw = [System.IO.File]::ReadAllText((Resolve-Path $swPath), [System.Text.Encoding]::UTF8)
$sw = [regex]::Replace($sw, "const CACHE_VERSION = '[^']+';", "const CACHE_VERSION = 'fish-v$version-$stamp';")
[System.IO.File]::WriteAllText((Resolve-Path $swPath), $sw, (New-Object System.Text.UTF8Encoding($false)))

Copy-Item 'build\web\*' $target -Recurse -Force

# --- Cloudflare Pages direct-upload zip -----------------------------------
# Entries must be at the archive root (index.html first), not inside a folder.
# Use the helper because Windows ZipFile writes backslash entry names, which
# Cloudflare treats as literal characters instead of directories.
$zip = Join-Path $OutDir "FishTextAdventure-$version-cloudflare-pages.zip"
foreach ($old in @(
    $zip,
    (Join-Path $OutDir "FishTextAdventure-$version-web.zip"),
    "$zip.sha256"
)) {
    if (Test-Path $old) { Remove-Item $old -Force }
}
& (Join-Path $PSScriptRoot 'zip-static.ps1') -Source $target -Destination $zip
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $zip)) { throw 'ZIP packaging failed' }

$hash = (Get-FileHash $zip -Algorithm SHA256).Hash
$zipName = Split-Path $zip -Leaf
Set-Content -Path "$zip.sha256" -Value "$hash  $zipName" -Encoding ascii

$python = $env:PYTHON
if (-not $python) {
    $candidate = (Get-Command python -ErrorAction SilentlyContinue).Source
    # Skip the Microsoft Store execution-alias stub, which exits 9009.
    if ($candidate -and $candidate -notlike '*WindowsApps*') { $python = $candidate }
}
if ($python -and (Test-Path $python)) {
    Write-Host '== release bundle audit ==' -ForegroundColor Cyan
    & $python 'tool\web\check_release_bundle.py' --zip $zip
    if ($LASTEXITCODE -ne 0) { throw 'Release bundle audit failed' }
} else {
    Write-Warning 'Python not found; run tool/web/check_release_bundle.py --zip <zip> manually.'
}

Write-Host ''
Write-Host "Static site:    $target" -ForegroundColor Green
Write-Host "Pages ZIP:      $zip" -ForegroundColor Green
Write-Host "SHA-256:        $hash" -ForegroundColor Green
Write-Host 'Upload the ZIP to Cloudflare Pages, or host the folder on any HTTPS static host.' -ForegroundColor Yellow
