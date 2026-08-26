# 根据 ../models.txt 下载模型到 ComfyUI 对应目录 (Windows/PowerShell 版)
# 依赖 Windows 自带的 curl.exe（Win10 1803+ 都有），支持断点续传
$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $RepoDir
if (-not $env:COMFYUI_DIR) { $env:COMFYUI_DIR = "$HOME\ComfyUI" }
$ComfyUIDir = $env:COMFYUI_DIR

$ListFile = Join-Path $RepoRoot "models.txt"
$ModelsDir = Join-Path $ComfyUIDir "models"

if (-not (Test-Path $ListFile)) {
    Write-Host "未找到 models.txt，跳过模型下载"
    exit 0
}

Get-Content $ListFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq "" -or $line.StartsWith("#")) { return }

    $parts = $line -split '\s+'
    if ($parts.Count -lt 2) {
        Write-Host "[跳过] 格式不对的行: $line"
        return
    }
    $url = $parts[0]
    $relPath = $parts[1]

    $dest = Join-Path $ModelsDir $relPath
    $destDir = Split-Path -Parent $dest
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null

    if (Test-Path $dest) {
        Write-Host "[跳过] 已存在: $relPath"
    } else {
        Write-Host "[下载] $relPath"
        # -C - 断点续传；-L 跟随重定向
        curl.exe -L -C - -o $dest $url
    }
}

Write-Host "模型下载完成"
