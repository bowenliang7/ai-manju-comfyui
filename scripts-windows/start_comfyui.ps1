# 启动 ComfyUI (Windows/PowerShell 版)
$ErrorActionPreference = "Stop"

if (-not $env:COMFYUI_DIR) { $env:COMFYUI_DIR = "$HOME\ComfyUI" }
$ComfyUIDir = $env:COMFYUI_DIR
$Port = if ($env:COMFYUI_PORT) { $env:COMFYUI_PORT } else { "8188" }

Push-Location $ComfyUIDir
python main.py --listen 0.0.0.0 --port $Port
Pop-Location
