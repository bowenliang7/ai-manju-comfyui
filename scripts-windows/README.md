# Windows GPU 实例部署说明

如果你的GPU实例是纯 Windows 系统（没有装 WSL/Git Bash），用这个目录里的 `.ps1` 脚本，用法和Linux版的 `.sh` 脚本完全对应。

## 前提

实例上需要预先装好（大部分带CUDA的Windows GPU镜像会自带）：
- Git for Windows
- Python 3.10+（并且 `pip` 命令可用）
- NVIDIA 驱动 + CUDA（一般镜像自带）

## 使用步骤

1. 打开 PowerShell（管理员权限更保险），clone 仓库：
   ```powershell
   git clone https://github.com/bowenliang7/ai-manju-comfyui.git
   cd ai-manju-comfyui
   ```

2. 如果提示"无法加载脚本，因为在此系统上禁止运行脚本"，先执行一次（只需一次）：
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   ```

3. 一键部署：
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts-windows\setup.ps1
   ```

4. 启动：
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts-windows\start_comfyui.ps1
   ```
   默认监听 `0.0.0.0:8188`，去实例控制台做端口映射，或用本地 `ssh -L 8188:127.0.0.1:8188 user@实例IP` 转发访问。

## 和 Linux 版的对应关系

| Linux (`scripts/`) | Windows (`scripts-windows/`) |
|---|---|
| `setup.sh` | `setup.ps1` |
| `install_custom_nodes.sh` | `install_custom_nodes.ps1` |
| `download_models.sh` | `download_models.ps1` |
| `start_comfyui.sh` | `start_comfyui.ps1` |

两套脚本共用同一份 `custom_nodes.txt`、`models.txt`、`workflows/`，改一份清单，Linux和Windows实例都能同步用，不用维护两份配置。

## 常见问题

- **`curl.exe` 不存在**：Windows 10 1803 之后系统自带，如果是很老的镜像没有，去 https://curl.se/windows/ 下载后把 `curl.exe` 放进 PATH。
- **pip装不上某些包（编译报错）**：Windows下部分Python包需要 Visual C++ Build Tools，报错信息里通常会提示去哪下载。
- **模型下载慢**：同 Linux 版说明，可以把下载链接换成国内镜像（hf-mirror.com / modelscope）。
