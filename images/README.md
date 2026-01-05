# MolCrafts DevContainer Images

Pre-built devcontainer images that combine all MolCrafts features into ready-to-use development environments.

## Available Images

### molcrafts-cpu

Complete development environment with all features using CPU-only PyTorch.

**Includes:**
- Python development environment (molpy)
- Rust development environment (molrs)
- Visualization tools (molvis)
- Task graph framework (molexp)
- ML training system (molnex) with CPU backend

**Usage:**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest"
}
```

**Configuration:** [devcontainer.json](molcrafts-cpu/devcontainer.json)

---

### molcrafts-cuda

Complete development environment with all features using CUDA-enabled PyTorch.

**Includes:**
- Python development environment (molpy)
- Rust development environment (molrs)
- Visualization tools (molvis)
- Task graph framework (molexp)
- ML training system (molnex) with CUDA 13.1 backend

**Usage:**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest",
  "runArgs": ["--gpus", "all"]
}
```

**Configuration:** [devcontainer.json](molcrafts-cuda/devcontainer.json)

> [!IMPORTANT]
> CUDA support requires:
> - NVIDIA GPU with CUDA 13.1 support
> - NVIDIA GPU drivers on host machine
> - NVIDIA Container Toolkit installed

---

## Development

### Building Locally

```bash
# Build CPU image
cd molcrafts-cpu
devcontainer build --workspace-folder ../.. --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:test

# Build CUDA image
cd molcrafts-cuda
devcontainer build --workspace-folder ../.. --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:test
```

### Testing

```bash
# Test image build
devcontainer build --workspace-folder ../.. --image-name test:local
```

### Publishing

Images are automatically built and published when:
- Changes are pushed to the `images/` directory
- Features are successfully published (via workflow dependency)

Images are published to:
- `ghcr.io/molcrafts/devcontainers/images/<image-name>:latest`
- `ghcr.io/molcrafts/devcontainers/images/<image-name>:<commit-sha>`

---

## Customization

If you need a customized environment, you can:

1. **Use individual features**: Compose your own environment
2. **Extend existing images**: Use our images as base and add more features
3. **Fork and modify**: Create your own images based on our configurations

Example of extending with additional features:

```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  }
}
```

