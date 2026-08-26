# AI漫剧 ComfyUI 部署仓库

这个仓库不放 ComfyUI 本体（太大、更新麻烦），只放「配置清单 + 一键部署脚本」：
- `custom_nodes.txt`：需要装的自定义节点列表
- `models.txt`：需要下载的模型地址列表
- `workflows/`：你导出的 ComfyUI 工作流 json 文件
- `setup.sh`：在GPU实例上跑一次，自动把上面这些都装/下好

## 目录结构

```
ai-manju-comfyui/
├── setup.sh                     # 一键部署入口
├── custom_nodes.txt             # 自定义节点清单
├── models.txt                   # 模型下载清单
├── workflows/                   # 你的 workflow json 文件放这里
│   └── README.md
└── scripts/
    ├── install_custom_nodes.sh
    ├── download_models.sh
    └── start_comfyui.sh
```

## 使用方法（优云智算 GPU 实例上）

1. 先把这个仓库 push 到你的 GitHub（见下方「推送到GitHub」）。
2. 在优云智算控制台创建/开机一个 GPU 实例（选带 SSH 或 JupyterLab 终端访问的镜像，Ubuntu + CUDA 即可，PyTorch 预装的镜像更省事）。
3. 进入实例终端，clone 你的仓库：
   ```bash
   git clone https://github.com/<你的用户名>/ai-manju-comfyui.git
   cd ai-manju-comfyui
   ```
4. 跑一键部署：
   ```bash
   bash setup.sh
   ```
   首次运行会：clone 官方 ComfyUI → 装依赖 → 装 ComfyUI-Manager → 按 `custom_nodes.txt` 装节点 → 按 `models.txt` 下模型 → 把 `workflows/` 里的 json 同步进 ComfyUI。
5. 启动：
   ```bash
   bash scripts/start_comfyui.sh
   ```
   默认监听 `0.0.0.0:8188`，然后去优云智算控制台找「自定义服务/端口映射」把 8188 端口映射出来，用返回的公网地址打开网页。
   （具体端口映射方式优云智算和 AutoDL 类似，去实例详情页找"端口映射"或"应用"入口，没有的话可以用 SSH 端口转发：`ssh -L 8188:127.0.0.1:8188 root@<实例IP> -p <端口>`，然后本地浏览器打开 `http://127.0.0.1:8188`）

## 日常使用流程

- **你本地/网页里做好一个新workflow** → 导出 json → 放进 `workflows/` 目录 → git commit & push
- **GPU实例上** → `git pull` → 重新跑一次 `bash setup.sh`（脚本是幂等的，已装好的不会重复装）→ 网页里就能看到新workflow
- **想加新的自定义节点** → 在 `custom_nodes.txt` 里加一行 git 地址 → push → 实例上 `git pull && bash setup.sh`
- **想加新模型** → 在 `models.txt` 里加一行「下载地址 + 目标路径」→ push → 实例上 `git pull && bash setup.sh`

这样每次开新的GPU实例（比如按量付费用完关机、下次再开一台新的），只需要 `git clone` 你这个仓库再跑 `setup.sh`，几分钟就能恢复到和上次一样的环境，不用每次手动重新配置。

## 推送到 GitHub

在你**本地电脑**（不是GPU实例）操作：

```bash
cd ai-manju-comfyui
git init
git add .
git commit -m "init: ai漫剧 comfyui 部署配置"
git branch -M main
git remote add origin https://github.com/<你的用户名>/ai-manju-comfyui.git
git push -u origin main
```

如果还没在GitHub建仓库，先去 github.com 点 New repository 建一个空仓库（不要勾选自动生成README，避免冲突），拿到上面命令里的地址。

## 关于模型体积和网络

- 模型文件（几个G很正常）**不要**放进git仓库，`.gitignore` 里已经排除了常见模型后缀，只在 `models.txt` 登记下载链接，由GPU实例直接下载，速度比走git快很多。
- 国内实例访问 HuggingFace 可能慢/不稳，`models.txt` 里有提示可以换成 `hf-mirror.com` 或魔搭(modelscope)的地址。

## 关于「AI漫剧」常用的节点组合（`custom_nodes.txt` 里已预置）

做AI漫剧一般涉及：角色/分镜出图 → （可选）图生视频让分镜动起来 → 配音/字幕合成。已经帮你预置了几类常用节点（视频生成、ControlNet姿态控制、IPAdapter/换脸保持角色一致、TTS配音等），可以先跑通再按实际workflow精简，不需要的删掉即可，减少不必要的安装时间。
