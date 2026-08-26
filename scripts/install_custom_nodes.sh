#!/bin/bash
# 根据 custom_nodes.txt 逐个 clone 自定义节点并安装其依赖
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
LIST_FILE="$REPO_DIR/custom_nodes.txt"
TARGET_DIR="$COMFYUI_DIR/custom_nodes"

mkdir -p "$TARGET_DIR"

while IFS= read -r line; do
    # 跳过空行和注释行
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    url="$line"
    name=$(basename "$url" .git)
    dest="$TARGET_DIR/$name"

    if [ -d "$dest" ]; then
        echo "[跳过] $name 已存在"
    else
        echo "[安装] $name"
        git clone --depth 1 "$url" "$dest"
    fi

    if [ -f "$dest/requirements.txt" ]; then
        pip install -r "$dest/requirements.txt" || echo "[警告] $name 的依赖安装出现问题，可能需要手动处理"
    fi
done < "$LIST_FILE"

echo "自定义节点安装完成"
