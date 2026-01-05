# MolCrafts DevContainer Images

预构建镜像，包含全部 MolCrafts features。

## 镜像列表

- **molcrafts-cpu** — 全量功能，PyTorch CPU
  ```json
  { "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest" }
  ```
  配置：[devcontainer.json](molcrafts-cpu/devcontainer.json)

- **molcrafts-cuda** — 全量功能，PyTorch CUDA（需宿主 GPU，`--gpus all`）
  ```json
  { "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest", "runArgs": ["--gpus", "all"] }
  ```
  配置：[devcontainer.json](molcrafts-cuda/devcontainer.json)

> CUDA 需宿主安装 NVIDIA 驱动 + NVIDIA Container Toolkit。

## 开发/构建

```bash
# 构建 CPU 镜像
cd molcrafts-cpu && devcontainer build --workspace-folder ../.. --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:test

# 构建 CUDA 镜像
cd molcrafts-cuda && devcontainer build --workspace-folder ../.. --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:test

# 快速本地验证
devcontainer build --workspace-folder ../.. --image-name test:local
```

## 发布
- 推送 images/ 相关改动或上游 features 发布成功后自动构建发布：
  - `ghcr.io/molcrafts/devcontainers/images/<image>:latest`
  - `ghcr.io/molcrafts/devcontainers/images/<image>:<commit-sha>`

## 自定义
- 直接组合 features，或在镜像上追加其他 features：
  ```json
  { "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest", "features": { "ghcr.io/devcontainers/features/docker-in-docker:2": {} } }
  ```

