# MolCrafts DevContainers

Devcontainer features 与预构建镜像合集，覆盖 Python、Rust、可视化与 ML（CPU/CUDA）。

## 快速上手

**直接用镜像（推荐）**
- CPU: `ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest`
- CUDA: `ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest`（需宿主 NVIDIA GPU，`--gpus all`）

**按需拼装 Feature**
```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": { "installJupyter": true },
    "ghcr.io/molcrafts/devcontainers/molrs:latest": {}
  }
}
```

## 组件概览

- Features（详见 [features/README.md](features/README.md)）
  - molpy: Python + Anaconda + Jupyter
  - molrs: Rust + wasm-pack
  - molvis: Node.js 可视化工具
  - molexp: 任务图框架（Python 3.12+）
  - molnex: PyTorch（CPU/CUDA）

- Images（详见 [images/README.md](images/README.md)）
  - molcrafts-cpu: 全量特性 + CPU PyTorch
  - molcrafts-cuda: 全量特性 + CUDA PyTorch

## 仓库结构
```
features/  # Feature 定义与测试
images/    # 预构建镜像配置
.github/   # CI/CD
```

## 常用命令

```bash
# 测试全部 features
devcontainer features test ./features

# 测试单个 feature（例：molnex）
devcontainer features test ./features -f molnex

# 构建 CPU 镜像（本地）
cd images/molcrafts-cpu && devcontainer build --workspace-folder ../.. --image-name test:local
```

## 发布
- 推送到 master 后自动发布到 GHCR：
  - Features: ghcr.io/molcrafts/devcontainers/<feature>:latest
  - Images:   ghcr.io/molcrafts/devcontainers/images/<image>:latest

## 文档
- [Dev Containers Spec](https://containers.dev/)
- [Features Guide](https://containers.dev/implementors/features/)
- [Testing Features](https://github.com/devcontainers/cli/blob/main/docs/features/test.md)
