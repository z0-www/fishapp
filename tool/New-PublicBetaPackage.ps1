[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Apk,
    [string]$BuildTools = (Join-Path $env:LOCALAPPDATA 'Android\Sdk\build-tools\36.0.0')
)

$ErrorActionPreference = 'Stop'
$project = Split-Path -Parent $PSScriptRoot
$materials = Join-Path $project 'docs\public-beta-v058'
$record = Get-Content -Raw -LiteralPath (Join-Path $materials '验收记录.json') | ConvertFrom-Json
$live = $record.androidLiveApi
function Test-PositiveInteger($value) {
    return (($value -is [int] -or $value -is [long]) -and $value -gt 0)
}
if ($record.status -cne 'Public Beta Ready' -or
    $record.apkSha256 -notmatch '^[0-9A-Fa-f]{64}$' -or
    $record.certificateSha256 -notmatch '^[0-9A-Fa-f]{64}$' -or
    [string]::IsNullOrWhiteSpace($record.byokReviewReference) -or
    [string]::IsNullOrWhiteSpace($record.mainlandReviewReference) -or
    [string]::IsNullOrWhiteSpace($record.backupRestoreReference) -or
    [string]::IsNullOrWhiteSpace($live.evidenceReference) -or
    $live.apkSha256 -ne $record.apkSha256 -or
    $live.model -notmatch '^deepseek-[A-Za-z0-9._-]{1,80}$' -or
    !(Test-PositiveInteger $live.httpStatus) -or $live.httpStatus -ne 200 -or
    $live.realReplyConfirmed -isnot [bool] -or !$live.realReplyConfirmed -or
    !(Test-PositiveInteger $live.inputTokens) -or !(Test-PositiveInteger $live.outputTokens)) {
    throw 'BLOCKED: signed APK, real Android reply/usage, backup restore and channel reviews must be recorded before packaging.'
}

$versionLine = Select-String -LiteralPath (Join-Path $project 'pubspec.yaml') -Pattern '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$' | Select-Object -First 1
if (!$versionLine) { throw 'Cannot read the APK version from pubspec.yaml.' }
$versionName = $versionLine.Matches[0].Groups[1].Value
$versionCode = [int]$versionLine.Matches[0].Groups[2].Value
if ($versionName -ne '0.5.8') { throw 'Prepare the materials and evidence for the current version before packaging.' }

$dist = Join-Path $project 'dist'
$release = Join-Path $dist "FishTextAdventure-V$versionName-PublicBeta"
if ((Test-Path -LiteralPath $release) -and @(Get-ChildItem -LiteralPath $release -Force).Count -gt 0) {
    throw 'The release directory is already populated. Leave the existing distribution intact.'
}
$stage = Join-Path $dist ('.beta-' + [guid]::NewGuid().ToString('N'))
$apkName = "鱼者文游-V$versionName-Android-Release.apk"
New-Item -ItemType Directory -Path $stage -Force | Out-Null
try {
    $candidate = Join-Path $stage $apkName
    Copy-Item -LiteralPath (Resolve-Path -LiteralPath $Apk).Path -Destination $candidate
    $proof = & (Join-Path $PSScriptRoot 'Verify-AndroidRelease.ps1') -Apk $candidate -BuildTools $BuildTools -ExpectedCertificateSha256 $record.certificateSha256 -VersionCode $versionCode -VersionName $versionName -RequireAndroidByok
    if ($proof.ApkSha256 -ne $record.apkSha256) { throw 'The APK differs from the one in the acceptance record.' }
    foreach ($file in @(
        '安装使用说明.txt', 'DeepSeek API Key 获取教程.txt', '旧版升级及故事备份教程.txt',
        '隐私政策与用户须知.html', '更新日志.txt'
    )) {
        Copy-Item -LiteralPath (Join-Path $materials $file) -Destination $stage
    }
    [IO.File]::WriteAllText((Join-Path $stage 'SHA256.txt'), "$($proof.ApkSha256)  $apkName" + [Environment]::NewLine)
    if (Test-Path -LiteralPath $release) { [IO.Directory]::Delete($release, $false) }
    [IO.Directory]::Move($stage, $release)
    Get-ChildItem -LiteralPath $release | Select-Object Name, Length
} finally {
    if (Test-Path -LiteralPath $stage) {
        # Only the newly created staging directory and its own files are removed.
        Get-ChildItem -LiteralPath $stage -File | ForEach-Object { Remove-Item -LiteralPath $_.FullName }
        [IO.Directory]::Delete($stage, $false)
    }
}
