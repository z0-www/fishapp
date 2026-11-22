[CmdletBinding(DefaultParameterSetName = 'Initialize')]
param(
    [Parameter(Mandatory, ParameterSetName = 'Initialize')][switch]$Initialize,
    [Parameter(Mandatory, ParameterSetName = 'Sign')][string]$Apk,
    [string]$Keystore = (Join-Path $env:LOCALAPPDATA 'FishTextAdventure\signing\yuzhe-release.p12'),
    [string]$CertificateFile,
    [ValidatePattern('^[a-zA-Z0-9_.-]+$')][string]$Alias = 'yuzhe-release',
    [string]$BuildTools = (Join-Path $env:LOCALAPPDATA 'Android\Sdk\build-tools\36.0.0')
)

$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -lt 7) { throw 'Open PowerShell 7 (pwsh) for local signing.' }
if ([Console]::IsInputRedirected) { throw 'Use an interactive local terminal for the password prompt.' }
$project = Split-Path -Parent $PSScriptRoot
$Keystore = [IO.Path]::GetFullPath($Keystore)
if (!$CertificateFile) { $CertificateFile = [IO.Path]::ChangeExtension($Keystore, '.cer') }
$CertificateFile = [IO.Path]::GetFullPath($CertificateFile)
if ($Keystore -eq $CertificateFile) { throw 'Use a separate path for the public certificate.' }
if ($Keystore.StartsWith($project + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Choose a private keystore location outside the Flutter project.'
}

$javaBefore = $env:JAVA_HOME
$studioJava = Join-Path $env:ProgramFiles 'Android\Android Studio\jbr'
if (!$env:JAVA_HOME -and (Test-Path -LiteralPath $studioJava)) { $env:JAVA_HOME = $studioJava }

function Invoke-WithLocalPassword(
    [string]$Program,
    [string[]]$Arguments,
    [string]$Prompt,
    [int]$Count = 1
) {
    $secret = Read-Host $Prompt -AsSecureString
    $pointer = [IntPtr]::Zero
    $process = [Diagnostics.Process]::new()
    try {
        $info = $process.StartInfo
        $info.FileName = $Program
        $info.UseShellExecute = $false
        $info.RedirectStandardInput = $true
        foreach ($argument in $Arguments) { $info.ArgumentList.Add($argument) }
        $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
        if (!$process.Start()) { throw 'Could not open the signing tool.' }
        try {
            for ($entry = 0; $entry -lt $Count; $entry++) {
                for ($letter = 0; $letter -lt $secret.Length; $letter++) {
                    $codeUnit = [Runtime.InteropServices.Marshal]::ReadInt16($pointer, $letter * 2) -band 0xffff
                    $process.StandardInput.Write([char]$codeUnit)
                }
                $process.StandardInput.WriteLine()
            }
        } finally {
            $process.StandardInput.Close()
        }
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) { throw 'The signing tool did not complete successfully.' }
    } finally {
        if ($pointer -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
        }
        $secret.Dispose()
        $process.Dispose()
    }
}

try {
    if ($Initialize) {
        if (!$env:JAVA_HOME) { throw 'Configure a local JDK with JAVA_HOME first.' }
        $keytool = Join-Path $env:JAVA_HOME 'bin\keytool.exe'
        if (!(Test-Path -LiteralPath $Keytool -PathType Leaf)) { throw 'JDK keytool was not found.' }
        if (!(Test-Path -LiteralPath $Keystore)) {
            if (Test-Path -LiteralPath $CertificateFile) {
                throw 'A release certificate already exists. Restore its matching keystore instead of replacing the signing identity.'
            }
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Keystore) | Out-Null
            Invoke-WithLocalPassword $keytool @(
                '-genkeypair', '-keystore', $Keystore, '-storetype', 'PKCS12',
                '-alias', $Alias, '-keyalg', 'RSA', '-keysize', '3072',
                '-validity', '10000', '-dname', 'CN=z0-www, O=FishTextAdventure'
            ) '创建长期签名库的密码' 2
        }
        if (!(Test-Path -LiteralPath $CertificateFile)) {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $CertificateFile) | Out-Null
            Invoke-WithLocalPassword $keytool @(
                '-exportcert', '-keystore', $Keystore, '-alias', $Alias,
                '-file', $CertificateFile
            ) '导出公开证书，请输入签名库密码'
        }
        [pscustomobject]@{
            Keystore = $Keystore
            PublicCertificate = $CertificateFile
            CertificateSha256 = (Get-FileHash -LiteralPath $CertificateFile -Algorithm SHA256).Hash
        }
        return
    }

    foreach ($path in @($Keystore, $CertificateFile, $Apk)) {
        if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw 'Provide the APK, owner keystore and matching public certificate.' }
    }
    $Apk = (Resolve-Path -LiteralPath $Apk).Path
    $expected = (Get-FileHash -LiteralPath $CertificateFile -Algorithm SHA256).Hash
    $version = Select-String -LiteralPath (Join-Path $project 'pubspec.yaml') -Pattern '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$' | Select-Object -First 1
    if (!$version) { throw 'Cannot read the APK version from pubspec.yaml.' }
    $name = $version.Matches[0].Groups[1].Value
    $code = [int]$version.Matches[0].Groups[2].Value
    $verifier = Join-Path $PSScriptRoot 'Verify-AndroidRelease.ps1'
    $signer = Join-Path $BuildTools 'apksigner.bat'
    $staging = Join-Path $project 'build\owner-signed'
    New-Item -ItemType Directory -Force -Path $staging | Out-Null
    $temporary = Join-Path $staging ('signing-' + [guid]::NewGuid().ToString('N') + '.apk')
    try {
        & $signer verify $Apk *> $null
        if ($LASTEXITCODE -eq 0) {
            Copy-Item -LiteralPath $Apk -Destination $temporary
        } else {
            $signerJar = Join-Path $BuildTools 'lib\apksigner.jar'
            $java = Join-Path $env:JAVA_HOME 'bin\java.exe'
            Invoke-WithLocalPassword $java @(
                '-jar', $signerJar, 'sign', '--ks', $Keystore, '--ks-key-alias',
                $Alias, '--ks-pass', 'stdin', '--out', $temporary, $Apk
            ) '签名 APK，请输入签名库密码'
        }
        $proof = & $verifier -Apk $temporary -BuildTools $BuildTools -ExpectedCertificateSha256 $expected -VersionCode $code -VersionName $name
        $final = Join-Path $staging ('FishTextAdventure-' + $name + '+' + $code + '-OwnerSigned-' + $proof.ApkSha256.Substring(0, 12) + '.apk')
        if (!(Test-Path -LiteralPath $final)) { [IO.File]::Move($temporary, $final) }
        if ((Get-FileHash -LiteralPath $final -Algorithm SHA256).Hash -ne $proof.ApkSha256) {
            throw 'A different APK already exists at the candidate path.'
        }
        $proof | Add-Member -NotePropertyName CandidateApk -NotePropertyValue $final -PassThru
    } finally {
        if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
    }
} finally {
    $env:JAVA_HOME = $javaBefore
}
