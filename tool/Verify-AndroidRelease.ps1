[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Apk,
    [Parameter(Mandatory)][string]$BuildTools,
    [Parameter(Mandatory)][string]$ExpectedCertificateSha256,
    [Parameter(Mandatory)][int]$VersionCode,
    [string]$VersionName,
    [string]$LlvmReadelf,
    [switch]$RequireAndroidByok
)

$ErrorActionPreference = 'Stop'
$apkPath = (Resolve-Path -LiteralPath $Apk).Path
$expected = $ExpectedCertificateSha256.Replace(':', '').Trim()
if ($expected -notmatch '^[A-Fa-f0-9]{64}$') { throw 'Provide the reviewed certificate SHA-256.' }

$aapt = Join-Path $BuildTools 'aapt2.exe'
$zipalign = Join-Path $BuildTools 'zipalign.exe'
$signer = Join-Path $BuildTools 'apksigner.bat'
$badging = (& $aapt dump badging $apkPath) -join [char]10
if ($LASTEXITCODE -ne 0 -or $badging -notmatch "(?m)^package: name='com\.yuzhe\.fishtextadventure' versionCode='$VersionCode'") {
    throw 'Package name or version code did not match.'
}
if ($badging -match '(?m)^application-debuggable') { throw 'The APK is debuggable.' }
if ($VersionName -and $badging -notmatch "(?m)^package:[^\r\n]+ versionName='$([regex]::Escape($VersionName))'") {
    throw 'Version name did not match.'
}
$manifest = (& $aapt dump xmltree --file AndroidManifest.xml $apkPath) -join [char]10
if ($LASTEXITCODE -ne 0 -or $manifest -notmatch '(?m)android:usesCleartextTraffic[^\r\n]+=(?:false|\(type 0x12\)0x0)[ \t\r]*$') {
    throw 'The manifest does not explicitly deny cleartext traffic.'
}
if ($RequireAndroidByok -and $manifest -notmatch '(?m)android:name[^\r\n]*="com\.yuzhe\.fishtextadventure\.RELEASE_BYOK"[^\r\n]*\r?\n[ \t]+A: [^\r\n]*android:value[^\r\n]*=(?:true|\(type 0x12\)0xffffffff)(?:[ \t]+\(Raw: "true"\))?[ \t\r]*$') {
    throw 'Android Release BYOK was not enabled in this APK.'
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead($apkPath)
try {
    $entries = $zip.Entries.FullName
    if (!($entries | Where-Object { $_ -match '^lib/[^/]+/libapp\.so$' })) {
        throw 'Flutter release AOT library is missing.'
    }
    if ($entries | Where-Object { $_ -match '(?i)(?:^|/)(?:kernel_blob\.bin|debug\.keystore|key\.properties|\.env(?:\..*)?)$|\.(?:jks|keystore|p12|pfx|key)$' }) {
        throw 'Debug kernel or private configuration found in the APK.'
    }
} finally {
    $zip.Dispose()
}

& $zipalign -c -P 16 4 $apkPath | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'APK archive alignment check failed.' }
$signature = (& $signer verify --verbose --print-certs $apkPath 2>&1) -join [char]10
if ($LASTEXITCODE -ne 0) { throw 'APK has no verifiable Android application signature.' }
if ($signature -match '(?i)CN\s*=\s*Android Debug\b') { throw 'Android Debug certificate is for internal tests.' }
if ($signature -notmatch '(?m)^Signer #1 certificate SHA-256 digest:\s*([0-9a-fA-F]{64})\s*$') {
    throw 'Could not read the signing certificate fingerprint.'
}
if ($Matches[1] -ne $expected) { throw 'Signing certificate differs from the reviewed distribution certificate.' }
$actualCertificate = $Matches[1].ToUpperInvariant()
if ([regex]::Matches($signature, '(?m)^Signer #\d+ certificate SHA-256 digest:').Count -ne 1) {
    throw 'This distribution expects exactly one signing certificate.'
}

# ZIP offsets alone do not check the alignment declared by each ELF library.
if (!$LlvmReadelf) {
    $sdk = Split-Path -Parent (Split-Path -Parent $BuildTools)
    $ndk = Get-ChildItem -LiteralPath (Join-Path $sdk 'ndk') -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1
    if ($ndk) {
        $LlvmReadelf = Join-Path $ndk.FullName 'toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-readelf.exe'
    }
}
if (!$LlvmReadelf -or !(Test-Path -LiteralPath $LlvmReadelf -PathType Leaf)) {
    throw 'Android NDK llvm-readelf is required for 16 KB native library verification.'
}
$verifiedLibraries = 0
$temporary = Join-Path ([IO.Path]::GetTempPath()) ('fish-release-' + [Guid]::NewGuid().ToString('N') + '.so')
$zip = [IO.Compression.ZipFile]::OpenRead($apkPath)
try {
    foreach ($entry in $zip.Entries) {
        if ($entry.FullName -notmatch '^lib/(arm64-v8a|x86_64)/[^/]+\.so$') { continue }
        [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $temporary, $true)
        $lines = & $LlvmReadelf --program-headers --wide $temporary
        if ($LASTEXITCODE -ne 0) { throw "Cannot inspect $($entry.FullName)." }
        $loads = @($lines | ForEach-Object {
            if ($_ -match '^\s*LOAD\s+.*\s+0x([A-Fa-f0-9]+)\s*$') {
                [Convert]::ToInt64($Matches[1], 16)
            }
        })
        if (!$loads.Count -or ($loads | Where-Object { $_ -lt 16384 })) {
            throw "Native library is not aligned to 16 KB: $($entry.FullName)."
        }
        $verifiedLibraries++
    }
    if (!$verifiedLibraries) { throw 'No supported 64-bit native libraries were found.' }
} finally {
    $zip.Dispose()
    if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
}
[pscustomobject]@{
    Package = 'com.yuzhe.fishtextadventure'
    VersionCode = $VersionCode
    CertificateSha256 = $actualCertificate
    ApkSha256 = (Get-FileHash -LiteralPath $apkPath -Algorithm SHA256).Hash
    Bytes = (Get-Item -LiteralPath $apkPath).Length
    NativeLibrariesWith16KbAlignment = $verifiedLibraries
}
