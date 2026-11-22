param(
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination
)

# Build a Cloudflare Pages ZIP with forward-slash entry names.
#
# System.IO.Compression.ZipFile.CreateFromDirectory on Windows writes
# backslashes into the ZIP entry names. Cloudflare Pages treats those as
# literal backslashes, so canvaskit/, assets/ and icons/ become unreachable
# at their real URLs. This helper writes portable "/" entry names.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$sourceFull = [System.IO.Path]::GetFullPath($Source)
$destFull = [System.IO.Path]::GetFullPath($Destination)
if (-not (Test-Path -LiteralPath $sourceFull -PathType Container)) {
    throw "Source directory not found: $sourceFull"
}
$destDir = Split-Path -Parent $destFull
if (-not (Test-Path -LiteralPath $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}
if (Test-Path -LiteralPath $destFull) {
    Remove-Item -LiteralPath $destFull -Force
}

$prefix = $sourceFull.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
$files = Get-ChildItem -LiteralPath $sourceFull -Recurse -File -Force | Sort-Object FullName
if ($files.Count -eq 0) {
    throw "Source directory is empty: $sourceFull"
}

$stream = [System.IO.File]::Open($destFull, [System.IO.FileMode]::CreateNew)
try {
    $archive = New-Object System.IO.Compression.ZipArchive(
        $stream,
        [System.IO.Compression.ZipArchiveMode]::Create,
        $true
    )
    try {
        foreach ($file in $files) {
            $relative = $file.FullName.Substring($prefix.Length).Replace('\', '/')
            if ($relative.StartsWith('/')) { $relative = $relative.TrimStart('/') }
            $entry = $archive.CreateEntry(
                $relative,
                [System.IO.Compression.CompressionLevel]::Optimal
            )
            $entry.LastWriteTime = $file.LastWriteTime
            $entryStream = $entry.Open()
            $fileStream = [System.IO.File]::OpenRead($file.FullName)
            try {
                $fileStream.CopyTo($entryStream)
            } finally {
                $fileStream.Dispose()
                $entryStream.Dispose()
            }
        }
    } finally {
        $archive.Dispose()
    }
} finally {
    $stream.Dispose()
}

Write-Host "ZIP entries normalized: $destFull" -ForegroundColor Green
