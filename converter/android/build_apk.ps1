# Build, sign and package the standalone Android converter (V1.2).
# Usage:
#   powershell -ExecutionPolicy Bypass -File converter/android/build_apk.ps1 -SkipWebBuild
param(
    [switch]$SkipWebBuild
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$converter = (Resolve-Path (Join-Path $root 'converter')).Path
$android = (Resolve-Path $PSScriptRoot).Path
$webBuild = Join-Path $root 'dist\converter\FishTextAdventure-Converter-1.2.1-mobile'
$androidHome = if ($env:ANDROID_HOME) { $env:ANDROID_HOME } else { Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
$buildTools = Join-Path $androidHome 'build-tools\36.0.0'
$javaHome = if ($env:JAVA_HOME) { $env:JAVA_HOME } else { 'C:\Program Files\Android\Android Studio\jbr' }
$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $androidHome

if (-not (Test-Path (Join-Path $buildTools 'apksigner.bat'))) {
    throw "Android build-tools 36.0.0 not found at $buildTools"
}

if (-not $SkipWebBuild) {
    & powershell -ExecutionPolicy Bypass -File (Join-Path $converter 'build.ps1') -SkipPubGet
}
if (-not (Test-Path (Join-Path $webBuild 'index.html'))) {
    throw "Web build not found: $webBuild"
}

$assets = Join-Path $android 'app\src\main\assets\converter'
if (Test-Path $assets) { Remove-Item $assets -Recurse -Force }
New-Item -ItemType Directory -Path $assets -Force | Out-Null
foreach ($name in @('index.html', 'app.js', 'styles.css', 'manifest.json', 'service_worker.js', 'offline.html', '_headers', 'icon-192.png', 'icon-512.png', 'icon-180.png')) {
    Copy-Item (Join-Path $webBuild $name) (Join-Path $assets $name) -Force
}

$signing = Join-Path $converter 'signing'
$propsFile = Join-Path $signing 'keystore.properties'
if (-not (Test-Path $propsFile)) {
    throw "Release signing properties not found: $propsFile. Keep the original keystore safe; do not use debug signing."
}
$props = @{}
Get-Content $propsFile | ForEach-Object {
    $pair = $_.Split('=', 2)
    if ($pair.Count -eq 2) { $props[$pair[0]] = $pair[1] }
}

Write-Host '== Gradle assembleRelease ==' -ForegroundColor Cyan
& (Join-Path $android 'gradlew.bat') -p $android assembleRelease --no-daemon --offline
$unsigned = Join-Path $android 'app\build\outputs\apk\release\app-release-unsigned.apk'
if (-not (Test-Path $unsigned)) { throw 'Unsigned release APK was not produced.' }

$aligned = Join-Path $android 'app\build\outputs\apk\release\app-release-aligned.apk'
& (Join-Path $buildTools 'zipalign.exe') -p -f 4 $unsigned $aligned
if ($LASTEXITCODE -ne 0) { throw 'zipalign failed' }

$outDir = Join-Path $root 'dist\android'
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$apkName = 'converter-v1.2.1-release.apk'
$apk = Join-Path $outDir $apkName
# apksigner on this JDK cannot canonicalize the non-ASCII destination path.
# Sign to an ASCII temp file, verify, then move it into the release name.
$tempApk = Join-Path $outDir '.converter-release-signed.apk'
if (Test-Path $tempApk) { Remove-Item $tempApk -Force }
& (Join-Path $buildTools 'apksigner.bat') sign `
    --ks $props['storeFile'] `
    --ks-key-alias $props['keyAlias'] `
    --ks-pass "pass:$($props['storePassword'])" `
    --key-pass "pass:$($props['keyPassword'])" `
    --out $tempApk $aligned
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $tempApk)) { throw 'apksigner failed' }
& (Join-Path $buildTools 'apksigner.bat') verify $tempApk
if ($LASTEXITCODE -ne 0) { throw 'APK signature verification failed' }
# PowerShell's Move-Item rejects the non-ASCII destination on this host; the
# .NET API handles the release filename correctly.
if (Test-Path $apk) { Remove-Item $apk -Force }
[System.IO.File]::Move($tempApk, $apk)

$permissions = (& (Join-Path $buildTools 'aapt2.exe') dump permissions $apk 2>&1 | Out-String)
if ($permissions -match 'android.permission.(INTERNET|READ_EXTERNAL_STORAGE|WRITE_EXTERNAL_STORAGE|MANAGE_EXTERNAL_STORAGE)') {
    throw "Forbidden permission found in APK: $permissions"
}
$badging = (& (Join-Path $buildTools 'aapt2.exe') dump badging $apk 2>&1 | Out-String)
if ($badging -notmatch "package: name='com.yuzhe.converter'") { throw 'Unexpected package id.' }
if ($badging -notmatch "versionName='1.2.1'") { throw 'Unexpected version name.' }

$hash = (Get-FileHash $apk -Algorithm SHA256).Hash
[System.IO.File]::WriteAllText("$apk.sha256", "$hash  $apkName`n", (New-Object System.Text.UTF8Encoding($false)))

Write-Host '== Quark publish package ==' -ForegroundColor Cyan
$publish = Join-Path $outDir 'quark-publish'
if (Test-Path $publish) { Remove-Item $publish -Recurse -Force }
New-Item -ItemType Directory -Path $publish -Force | Out-Null
Copy-Item $apk (Join-Path $publish $apkName) -Force
[System.IO.File]::WriteAllText((Join-Path $publish 'SHA256.txt'), "$hash  $apkName`n", (New-Object System.Text.UTF8Encoding($false)))
Copy-Item (Join-Path $android 'INSTALL_AND_USE.txt') $publish -Force
Copy-Item (Join-Path $android 'REAL_PHONE_CHECKLIST.txt') $publish -Force
Copy-Item (Join-Path $android 'TEST_REPORT.txt') $publish -Force
Copy-Item (Join-Path $android 'QUARK_PUBLISH.txt') $publish -Force

Add-Type -AssemblyName System.IO.Compression.FileSystem
$quarkZip = Join-Path $outDir 'converter-v1.2.1-quark-publish.zip'
if (Test-Path $quarkZip) { Remove-Item $quarkZip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($publish, $quarkZip, [System.IO.Compression.CompressionLevel]::Optimal, $false)
$quarkHash = (Get-FileHash $quarkZip -Algorithm SHA256).Hash
[System.IO.File]::WriteAllText("$quarkZip.sha256", "$quarkHash  $(Split-Path $quarkZip -Leaf)`n", (New-Object System.Text.UTF8Encoding($false)))

Write-Host ''
Write-Host "APK:        $apk" -ForegroundColor Green
Write-Host "APK SHA256: $hash" -ForegroundColor Green
Write-Host "Quark ZIP:  $quarkZip" -ForegroundColor Green
Write-Host "Quark SHA:  $quarkHash" -ForegroundColor Green
Write-Host 'Upload the Quark ZIP to your own Quark account; this script does not log in or upload.' -ForegroundColor Yellow

exit 0
