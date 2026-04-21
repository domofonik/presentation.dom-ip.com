#requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ReleaseDir = Join-Path $ProjectRoot 'release'
$StageDir = Join-Path $ReleaseDir 'www'
$ZipPath = Join-Path $ReleaseDir 'presentation-dom-ip.zip'

Write-Host "[INFO] Preparing release directories..."
New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

if (Test-Path $StageDir) {
    Remove-Item -Recurse -Force $StageDir
}
New-Item -ItemType Directory -Force -Path $StageDir | Out-Null

$FilesToCopy = @(
    'index.html',
    'favicon.ico',
    'og-image.png'
)

foreach ($relativePath in $FilesToCopy) {
    $source = Join-Path $ProjectRoot $relativePath
    if (-not (Test-Path $source)) {
        throw "Missing file: $relativePath"
    }
    Copy-Item -Path $source -Destination (Join-Path $StageDir $relativePath) -Force
}

$FotoSource = Join-Path $ProjectRoot 'foto'
if (Test-Path $FotoSource) {
    Copy-Item -Path $FotoSource -Destination (Join-Path $StageDir 'foto') -Recurse -Force
}

if (Test-Path $ZipPath) {
    Remove-Item -Force $ZipPath
}

Write-Host "[INFO] Building ZIP archive..."
Compress-Archive -Path (Join-Path $StageDir '*') -DestinationPath $ZipPath -CompressionLevel Optimal

Write-Host "[INFO] Done: $ZipPath"
