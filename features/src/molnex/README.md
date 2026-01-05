# molnex (devcontainer feature)

为 molnex ML 开发准备的 PyTorch 环境，支持 CPU 或 CUDA（自动探测基础镜像 CUDA 版本，无法探测则回退 CPU）。

## 使用方式

CPU（默认）
```json
{ "features": { "ghcr.io/molcrafts/devcontainers/molnex:latest": {} } }
```

CUDA（需宿主 GPU 与 NVIDIA Container Toolkit）
```json
{ "features": { "ghcr.io/molcrafts/devcontainers/molnex:latest": { "backend": "cuda" } }, "runArgs": ["--gpus", "all"] }
```

## 选项

| 选项 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- |
| `backend` | enum: `cpu` \| `cuda` | `cpu` | 计算后端；`cuda` 时按基础镜像检测 CUDA 版本，未检测到则自动回退 CPU |

## 安装内容
- PyTorch + torchvision + torchaudio（按 backend 选择 CPU/CUDA 轮子）
- NumPy
- 继承 molpy 的 Python 环境与开发工具（black / isort / jupyter 扩展等）

## 依赖
- `ghcr.io/devcontainers/features/common-utils:2`
- `ghcr.io/devcontainers/features/anaconda:1`
- `ghcr.io/molcrafts/devcontainers/molpy:latest`

## 验证
```bash
python3 - <<'PY'
import torch
print('PyTorch:', torch.__version__)
print('torch.version.cuda:', torch.version.cuda)
print('cuda.is_available:', torch.cuda.is_available())
PY
```

## 说明
- 不安装 CUDA Toolkit 本身；若基础镜像包含 CUDA，会安装匹配的 CUDA PyTorch 轮子。
- 若未检测到 CUDA 版本，则自动回退 CPU 轮子以避免安装失败。
