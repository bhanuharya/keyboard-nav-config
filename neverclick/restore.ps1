<#
.SYNOPSIS
    Restores NeverClick's settings from this folder.

.DESCRIPTION
    Quit NeverClick first (tray icon > Quit). The current files are kept as
    *.bak, this PC's instanceId is preserved, and NeverClick is started again.
    On a fresh install, start NeverClick once before running this.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\neverclick\restore.ps1
#>
param(
    [string]$ConfigDir = (Join-Path $env:APPDATA 'Neverclick\configs'),
    [string]$FromDir = $PSScriptRoot,
    # Skip the running check and the restart, e.g. when restoring into another folder.
    [switch]$NoStart
)
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

if (-not $NoStart -and (Get-Process neverclick -ErrorAction SilentlyContinue)) {
    throw 'NeverClick is running. Quit it from the tray icon, then run this again.'
}
New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null

$appPath = Join-Path $ConfigDir 'app-config.json'
$hotkeyPath = Join-Path $ConfigDir 'hotkey-config.json.gz'
foreach ($p in $appPath, $hotkeyPath) {
    if (Test-Path $p) { Copy-Item $p "$p.bak" -Force }
}

# Keep this PC's instanceId (export.ps1 leaves it out of the repo).
$app = [IO.File]::ReadAllText((Join-Path $FromDir 'app-config.json'), $utf8)
if (Test-Path $appPath) {
    $m = [regex]::Match([IO.File]::ReadAllText($appPath, $utf8), '"instanceId":\s*"([^"]*)"')
    if ($m.Success) {
        $app = ([regex]'\{').Replace($app, "{`n     `"instanceId`": `"$($m.Groups[1].Value)`",", 1)
    }
}
[IO.File]::WriteAllText($appPath, $app, $utf8)

$bytes = [IO.File]::ReadAllBytes((Join-Path $FromDir 'hotkey-config.json'))
$out = [IO.File]::Create($hotkeyPath)
try {
    $gz = New-Object IO.Compression.GZipStream($out, [IO.Compression.CompressionMode]::Compress)
    $gz.Write($bytes, 0, $bytes.Length)
    $gz.Dispose()
} finally {
    $out.Dispose()
}

Write-Host "Restored NeverClick settings to $ConfigDir (previous files saved as *.bak)"
if (-not $NoStart) {
    Start-Process (Join-Path $env:ProgramFiles 'Neverclick\neverclick.exe')
}
