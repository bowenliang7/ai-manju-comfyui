#!/bin/bash
# 根据 models.txt 下载模型到 ComfyUI 对应目录
# models.txt 每行格式: <下载URL>  <相对models/的目标子路径，包含文件名>
# 例如:
# https://huggingface.co/xxx/resolve/main/xxx.safetensors  checkpoints/xxx.safetensors
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
LIST_FILE="$REPO_DIR/models.txt"
MODELS_DIR="$COMFYUI_DIR/models"

if [ ! -f "$LIST_FILE" ]; then
    echo "未找到 models.txt，跳过模型下载"
    exit 0
fi

while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    url=$(echo "$line" | awk '{print $1}')
    rel_path=$(echo "$line" | awk '{print $2}')

    if [ -z "$url" ] || [ -z "$rel_path" ]; then
        echo "[跳过] 格式不对的行: $line"
        continue
    fi

    dest="$MODELS_DIR/$rel_path"
    mkdir -p "$(dirname "$dest")"

    if [ -f "$dest" ]; then
        echo "[跳过] 已存在: $rel_path"
    else
        echo "[下载] $rel_path"
        # 用 wget 断点续传，网速慢的话可以中断后重新跑脚本继续下
        wget -c -O "$dest" "$url"
    fi
done < "$LIST_FILE"

echo "模型下载完成"
