#!/bin/bash
# 启动 ComfyUI
# 优云智算等平台一般需要监听 0.0.0.0，再通过平台提供的端口映射/内网穿透访问
set -e

COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
PORT="${COMFYUI_PORT:-8188}"

cd "$COMFYUI_DIR"
python main.py --listen 0.0.0.0 --port "$PORT"
