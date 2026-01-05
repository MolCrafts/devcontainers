# MolCrafts DevContainer Features

可独立使用或组合的 Feature 列表。

## Feature 一览

- **molpy** — Python + Anaconda + 可选 Jupyter。
  ```json
  { "features": { "ghcr.io/molcrafts/devcontainers/molpy:latest": { "installJupyter": true } } }
  ```

- **molrs** — Rust 工具链 + wasm-pack，依赖 molpy。
  ```json
  { "features": { "ghcr.io/molcrafts/devcontainers/molrs:latest": {} } }
  ```

- **molvis** — Node.js + Python 可视化工具，依赖 molpy。
  ```json
  { "features": { "ghcr.io/molcrafts/devcontainers/molvis:latest": {} } }
  ```

- **molexp** — 任务图框架环境（Py3.12+，可选 Jupyter）。
  ```json
  { "features": { "ghcr.io/molcrafts/devcontainers/molexp:latest": { "installJupyter": true } } }
  ```

- **molnex** — PyTorch 训练（CPU/CUDA，依赖 molpy）。
  ```json
  { "features": { "ghcr.io/molcrafts/devcontainers/molnex:latest": { "backend": "cpu" } } }
  # CUDA 需宿主 GPU 与 NVIDIA Container Toolkit
  { "features": { "ghcr.io/molcrafts/devcontainers/molnex:latest": { "backend": "cuda" } }, "runArgs": ["--gpus", "all"] }
  ```

## 依赖关系
```
molpy
├─ molrs
├─ molvis
└─ molnex
molexp（独立）
```

## 测试命令
```bash
# 全部 features
devcontainer features test .

# 单个 feature（例：molnex）
devcontainer features test . -f molnex
```

## 编写新 Feature
- 参考规范：https://containers.dev/implementors/features/
- 每个 Feature 必须包含：
  - devcontainer-feature.json
  - install.sh
  - README.md

