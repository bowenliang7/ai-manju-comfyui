# 根据 ../custom_nodes.txt 逐个 clone 自定义节点并安装依赖 (Windows/PowerShell 版)
$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $RepoDir
if (-not $env:COMFYUI_DIR) { $env:COMFYUI_DIR = "$HOME\ComfyUI" }
$ComfyUIDir = $env:COMFYUI_DIR

$ListFile = Join-Path $RepoRoot "custom_nodes.txt"
$TargetDir = Join-Path $ComfyUIDir "custom_nodes"
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Get-Content $ListFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq "" -or $line.StartsWith("#")) { return }

    $url = $line
    $name = [System.IO.Path]::GetFileNameWithoutExtension($url)
    $dest = Join-Path $TargetDir $name

    if (Test-Path $dest) {
        Write-Host "[跳过] $name 已存在"
    } else {
        Write-Host "[安装] $name"
        git clone --depth 1 $url $dest
    }

    $reqFile = Join-Path $dest "requirements.txt"
    if (Test-Path $reqFile) {
        try {
            pip install -r $reqFile
        } catch {
            Write-Warning "$name 的依赖安装出现问题，可能需要手动处理"
        }
    }
}

Write-Host "自定义节点安装完成"
