# ComfyUI + H3 一键安装器（Windows）

> 由 **三猫云 SanMaoCloud** 打包维护

一条命令装好 **ComfyUI + MiniMax H3（Hailuo 3）全套模型**，并自动配置好
**Codex ↔ ComfyUI 的 MCP 控制接口**——装完直接让 Codex 用自然语言帮你画图、生成视频。

One-click installer for **ComfyUI + the full MiniMax H3 model set** on Windows,
with automatic **Codex MCP integration** so your AI agent can drive ComfyUI for you.

## 快速开始

1. 点击页面右上角 **Code → Download ZIP** 下载
   （或 `git clone https://github.com/arronfan23/comfyui-h3-installer.git`）
2. **右键下载的 ZIP →「全部解压缩」**（不要在压缩包窗口里直接双击！）
3. 打开解压后的文件夹，双击 **`一键安装.bat`**
   - 若出现"Windows 已保护你的电脑"：点「更多信息」→「仍要运行」
4. 等待完成（视网速 1~3 小时，共下载约 70GB，模型支持断点续传）

完成后会自动启动 ComfyUI 并打开 http://127.0.0.1:8188 。

## 它会自动做什么

| 步骤 | 内容 |
| --- | --- |
| 主程序 | 下载 ComfyUI（固定提交 `34744cd`，含 H3 支持的官方 master） |
| 自定义节点 | ComfyUI-Manager + 界面中文翻译 |
| Python | 没有 Python 3.12 则自动静默安装（当前用户，无需管理员） |
| 依赖 | venv + PyTorch 2.11 (cu130) + 全部锁定版本依赖 |
| 模型 | 从 HuggingFace 官方仓库下载 H3 全套（64GB，断点续传；国内自动走 ModelScope 高速源） |
| MCP | 内置 comfyui-mcp + Node.js 便携版，自动写入 Codex `config.toml` |

## 系统要求

- Windows 10 / 11 64 位
- NVIDIA 显卡（RTX 20 系或更新），显存建议 **16GB+**
- 磁盘剩余 **75GB+**
- 全程联网（国内网络无需配置，HuggingFace 不通会自动切换 ModelScope / hf-mirror 国内源）

## 日常使用

1. 双击安装目录里的 **`启动ComfyUI.bat`**
2. 打开 Codex，直接说"帮我画一张……" / "生成一段……的视频"即可

## 高级选项

```powershell
# 自定义安装目录
powershell -ExecutionPolicy Bypass -File installer\install.ps1 -InstallDir "E:\AI\ComfyUI"

# 国内用户强制走镜像下载模型
powershell -ExecutionPolicy Bypass -File installer\install.ps1 -UseMirror

# 只装环境不下模型（之后可重跑补齐）
powershell -ExecutionPolicy Bypass -File installer\install.ps1 -SkipModels
```

中断后重跑同一命令即可：已完成步骤自动跳过，模型自动断点续传。

## 模型清单与来源

安装时从 HuggingFace 官方仓库直接下载（本仓库不转存模型文件；国内网络自动改走
ModelScope 上的 Comfy-Org 官方镜像仓库，内容一致）：

| 文件 | 大小 | 来源 |
| --- | --- | --- |
| `diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors` | 19.5 GB | [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) |
| `diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors` | 19.5 GB | 同上 |
| `text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | 14.6 GB | 同上 |
| `text_encoders/qwen3vl_4b_fp8_scaled.safetensors` | 4.9 GB | [Comfy-Org/Qwen3-VL](https://huggingface.co/Comfy-Org/Qwen3-VL) |
| `vae/minimax_h3_video_vae_fp16.safetensors` | 4.9 GB | Comfy-Org/MiniMax-H3 |
| `vae/minimax_h3_audio_vae_fp32.safetensors` | 0.6 GB | 同上 |

模型的使用许可以 HuggingFace 上对应仓库的说明为准。

## English

1. Download this repo (**Code → Download ZIP**) and extract it anywhere.
2. Double-click `一键安装.bat` (that's the one-click installer).
3. Wait. It downloads ComfyUI (pinned commit), Python 3.12, PyTorch cu130,
   the full H3 model set (~64 GB, resumable, automatic mirror fallback),
   a portable Node.js, and wires up the bundled `comfyui-mcp` server into
   your Codex `config.toml`.
4. Afterwards, start ComfyUI with the generated `启动ComfyUI.bat` and ask
   Codex to create images/videos in natural language.

Requirements: Windows 10/11 x64, NVIDIA GPU (16 GB+ VRAM recommended),
75 GB free disk space, internet connection.

## 免责声明

本项目仅为安装脚本，不包含也不分发任何模型权重；模型均于安装时从上述
官方仓库下载，其使用权与限制以各仓库许可证为准。ComfyUI 遵循其
[GPL-3.0 许可证](https://github.com/comfyanonymous/ComfyUI/blob/master/LICENSE)。
