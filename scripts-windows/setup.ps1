# ============================================================
# AI漫剧 ComfyUI 一键部署脚本 (Windows / PowerShell 版)
# 用法: 在 Windows GPU 实例上，打开 PowerShell，clone 本仓库后执行
#   powershell -ExecutionPolicy Bypass -File setup.ps1
# ============================================================

$ErrorActionPreference = "Stop"

# ---------- 可按需修改的变量 ----------
if (-not $env:COMFYUI_DIR) { $env:COMFYUI_DIR = "$HOME\ComfyUI" }
$ComfyUIDir = $env:COMFYUI_DIR
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "===> 1. 检查/安装 ComfyUI 本体"
if (-not (Test-Path $ComfyUIDir)) {
    git clone https://github.com/comfyanonymous/ComfyUI.git $ComfyUIDir
} else {
    Write-Host "ComfyUI 已存在，尝试更新..."
    Push-Location $ComfyUIDir
    git pull
    Pop-Location
}

Write-Host "===> 2. 安装 ComfyUI 依赖"
Push-Location $ComfyUIDir
pip install -r requirements.txt
Pop-Location

Write-Host "===> 3. 安装 ComfyUI-Manager"
$ManagerDir = Join-Path $ComfyUIDir "custom_nodes\ComfyUI-Manager"
if (-not (Test-Path $ManagerDir)) {
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git $ManagerDir
}

Write-Host "===> 4. 安装自定义节点（custom_nodes.txt）"
& "$RepoDir\install_custom_nodes.ps1"

Write-Host "===> 5. 下载模型（models.txt）"
& "$RepoDir\download_models.ps1"

Write-Host "===> 6. 同步 workflow 文件"
$WfTarget = Join-Path $ComfyUIDir "user\default\workflows"
New-Item -ItemType Directory -Force -Path $WfTarget | Out-Null
$WfSource = Join-Path (Split-Path -Parent $RepoDir) "workflows"
if (Test-Path $WfSource) {
    Get-ChildItem "$WfSource\*.json" -ErrorAction SilentlyContinue | Copy-Item -Destination $WfTarget -Force
}

Write-Host "===> 部署完成！"
Write-Host "启动方式： powershell -ExecutionPolicy Bypass -File $RepoDir\start_comfyui.ps1"
