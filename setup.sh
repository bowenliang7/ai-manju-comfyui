#!/bin/bash
# ============================================================
# AI漫剧 ComfyUI 一键部署脚本
# 用法: 在GPU实例上 clone 本仓库后执行
#   bash setup.sh
# ============================================================
set -e

# ---------- 可按需修改的变量 ----------
# ComfyUI 安装位置（优云智算数据盘目录请根据实际路径调整）
COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
# 本仓库自身的路径（脚本所在目录）
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "===> 1. 检查/安装 ComfyUI 本体"
if [ ! -d "$COMFYUI_DIR" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
else
    echo "ComfyUI 已存在，尝试更新..."
    cd "$COMFYUI_DIR" && git pull
fi

echo "===> 2. 安装 ComfyUI 依赖"
cd "$COMFYUI_DIR"
pip install -r requirements.txt

echo "===> 3. 安装 ComfyUI-Manager（方便后续在网页里装/管理节点）"
if [ ! -d "$COMFYUI_DIR/custom_nodes/ComfyUI-Manager" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git "$COMFYUI_DIR/custom_nodes/ComfyUI-Manager"
fi

echo "===> 4. 安装自定义节点（custom_nodes.txt 里列出的）"
bash "$REPO_DIR/scripts/install_custom_nodes.sh"

echo "===> 5. 下载模型（models.txt 里列出的）"
bash "$REPO_DIR/scripts/download_models.sh"

echo "===> 6. 链接 workflow 文件到 ComfyUI 的 user/default/workflows 目录"
WF_TARGET="$COMFYUI_DIR/user/default/workflows"
mkdir -p "$WF_TARGET"
cp -f "$REPO_DIR"/workflows/*.json "$WF_TARGET"/ 2>/dev/null || echo "（暂无 workflow json，先跳过，之后放进 workflows/ 目录再跑一次即可）"

echo "===> 部署完成！"
echo "启动方式： bash $REPO_DIR/scripts/start_comfyui.sh"
