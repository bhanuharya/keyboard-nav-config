<#
.SYNOPSIS
    Copies NeverClick's settings from this PC into this folder.

.DESCRIPTION
    Writes app-config.json (without the per-install instanceId) and
    hotkey-config.json (decompressed from hotkey-config.json.gz).
    Run it after changing settings in NeverClick, then commit the result.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\neverclick\export.ps1
#>
param(
    [string]$ConfigDir = (Join-Path $env:APPDATA 'Neverclick\configs'),
    [string]$OutDir = $PSScriptRoot
)
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

# instanceId identifies this install, so it stays out of the repo.
$app = [IO.File]::ReadAllText((Join-Path $ConfigDir 'app-config.json'), $utf8)
$app = $app -replace '(?m)^[ \t]*"instanceId":[ \t]*"[^"]*",\r?\n', ''
[IO.File]::WriteAllText((Join-Path $OutDir 'app-config.json'), $app, $utf8)

$in = [IO.File]::OpenRead((Join-Path $ConfigDir 'hotkey-config.json.gz'))
try {
    $gz = New-Object IO.Compression.GZipStream($in, [IO.Compression.CompressionMode]::Decompress)
    $hotkeys = (New-Object IO.StreamReader($gz, $utf8)).ReadToEnd()
} finally {
    $in.Dispose()
}
[IO.File]::WriteAllText((Join-Path $OutDir 'hotkey-config.json'), $hotkeys, $utf8)

Write-Host "Exported NeverClick settings to $OutDir"
