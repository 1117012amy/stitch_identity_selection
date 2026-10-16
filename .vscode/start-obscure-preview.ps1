$ErrorActionPreference = 'Stop'

$workspaceRoot = Split-Path -Parent $PSScriptRoot
$appRoot = Join-Path $workspaceRoot 'flutter_app'
$buildWeb = Join-Path $appRoot 'build\web'
$indexHtml = Join-Path $buildWeb 'index.html'
$flutter = Join-Path $workspaceRoot 'flutter_sdk\flutter\bin\flutter.bat'
$preferredPort = 8082
$fallbackPort = 8086
$port = $preferredPort
$url = "http://127.0.0.1:$port/"

function Test-PreviewReady {
    param([string]$PreviewUrl)

    try {
        Invoke-WebRequest -UseBasicParsing $PreviewUrl -TimeoutSec 2 | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Test-NoCachePreview {
    param([string]$PreviewUrl)

    try {
        $response = Invoke-WebRequest -UseBasicParsing $PreviewUrl -TimeoutSec 2
        $cacheControl = [string]$response.Headers['Cache-Control']
        return $cacheControl.Contains('no-store')
    } catch {
        return $false
    }
}

function Build-LocalWebPreview {
    Push-Location $appRoot
    try {
        & $flutter build web --debug --pwa-strategy=none
    } finally {
        Pop-Location
    }
}

$needsBuild = -not (Test-Path -LiteralPath $indexHtml)
if (-not $needsBuild) {
    $baseHref = Select-String -Path $indexHtml -Pattern '<base href="/obscure-app/">' -Quiet
    $needsBuild = [bool]$baseHref
}

if ($needsBuild) {
    Write-Host 'Building local web preview...'
    Build-LocalWebPreview
}

if ((Test-PreviewReady $url) -and -not (Test-NoCachePreview $url)) {
    $port = $fallbackPort
    $url = "http://127.0.0.1:$port/"
}

if (-not (Test-PreviewReady $url)) {
    $bundledPython = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
    $python = if (Test-Path -LiteralPath $bundledPython) { $bundledPython } else { 'python' }
    $serverScript = Join-Path $PSScriptRoot 'no-cache-server.py'

    Start-Process `
        -WindowStyle Hidden `
        -FilePath $python `
        -ArgumentList @($serverScript, '--port', "$port", '--bind', '127.0.0.1', '--directory', $buildWeb) `
        -WorkingDirectory $appRoot

    Start-Sleep -Seconds 2
}

Start-Process $url
Write-Host "OBSCURE preview is running at $url"
