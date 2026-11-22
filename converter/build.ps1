# Build the standalone offline converter.
# Usage: powershell -ExecutionPolicy Bypass -File converter/build.ps1
param(
    [switch]$SkipPubGet
)
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$appRoot = $root.Path
$converter = $PSScriptRoot
Set-Location $converter

$dart = (Get-Command dart -ErrorAction SilentlyContinue).Source
if (-not $dart -and $env:FLUTTER_ROOT) {
    $candidate = Join-Path $env:FLUTTER_ROOT 'bin\dart.bat'
    if (Test-Path $candidate) { $dart = $candidate }
}
if (-not $dart) { throw 'Dart SDK not found. Add Flutter/Dart to PATH or set FLUTTER_ROOT.' }

if (-not $SkipPubGet) {
    Write-Host '== dart pub get ==' -ForegroundColor Cyan
    & $dart pub get
    if ($LASTEXITCODE -ne 0) { throw 'pub get failed' }
}

$build = Join-Path $converter 'build'
if (Test-Path $build) { Remove-Item $build -Recurse -Force }
New-Item -ItemType Directory -Path $build -Force | Out-Null

Write-Host '== dart compile js ==' -ForegroundColor Cyan
& $dart compile js web\main.dart -O2 -o build\app.js --no-source-maps
if ($LASTEXITCODE -ne 0) { throw 'dart compile js failed' }
foreach ($debug in @('app.js.map', 'app.js.deps')) {
    $p = Join-Path $build $debug
    if (Test-Path $p) { Remove-Item $p -Force }
}
if (Test-Path (Join-Path $build 'app.js')) {
    $js = [System.IO.File]::ReadAllText((Resolve-Path (Join-Path $build 'app.js')), [System.Text.Encoding]::UTF8)
    $js = [regex]::Replace($js, '(?m)^\s*//# sourceMappingURL=.*$', '')
    [System.IO.File]::WriteAllText((Resolve-Path (Join-Path $build 'app.js')), $js, (New-Object System.Text.UTF8Encoding($false)))
}

foreach ($name in @('index.html', 'styles.css', 'manifest.json', 'service_worker.js', 'offline.html', '_headers', 'icon-192.png', 'icon-512.png', 'icon-180.png', 'README.txt')) {
    $source = Join-Path $converter "web\$name"
    if ($name -eq 'README.txt') { $source = Join-Path $converter 'README.txt' }
    if (-not (Test-Path $source)) { throw "Missing $source" }
    Copy-Item $source (Join-Path $build $name) -Force
}

$version = '1.2.1-mobile'
$out = Join-Path $appRoot 'dist\converter'
if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Path $out -Force | Out-Null
$site = Join-Path $out "FishTextAdventure-Converter-$version"
New-Item -ItemType Directory -Path $site -Force | Out-Null
Copy-Item (Join-Path $build '*') $site -Recurse -Force
$examples = Join-Path $converter 'examples'
if (Test-Path $examples) { Copy-Item $examples (Join-Path $site 'examples') -Recurse -Force }

$zip = Join-Path $out "FishTextAdventure-Converter-$version.zip"
$zipHelper = Join-Path $appRoot 'tool\web\zip-static.ps1'
& $zipHelper -Source $site -Destination $zip
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $zip)) { throw 'ZIP packaging failed' }
$hash = (Get-FileHash $zip -Algorithm SHA256).Hash
Set-Content -Path "$zip.sha256" -Value "$hash  $(Split-Path $zip -Leaf)" -Encoding ascii
$pagesZip = Join-Path $out "FishTextAdventure-Converter-$version-cloudflare-pages.zip"
Copy-Item $zip $pagesZip -Force
Set-Content -Path "$pagesZip.sha256" -Value "$hash  $(Split-Path $pagesZip -Leaf)" -Encoding ascii

Write-Host ''
Write-Host "Site: $site" -ForegroundColor Green
Write-Host "ZIP:  $zip" -ForegroundColor Green
Write-Host "Pages ZIP: $pagesZip" -ForegroundColor Green
Write-Host "SHA:  $hash" -ForegroundColor Green
Write-Host 'Upload the Pages ZIP to Cloudflare Pages, or double-click index.html on desktop/Android for local use.' -ForegroundColor Yellow
