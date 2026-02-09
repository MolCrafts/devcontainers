# MolCrafts DevContainer Images

Pre-built container images with all MolCrafts features included. Ready-to-use development environments for molecular science projects.

## Available Images

### molcrafts-cpu

Complete development environment with CPU-only PyTorch.

**Usage:**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest"
}
```

**Includes:**
- Python development tools (Ruff)
- Rust + WebAssembly (wasm-pack)
- Node.js + visualization tools (Biome)
- Task graph framework (molexp)
- PyTorch CPU from base image
- All VS Code extensions

[Configuration →](molcrafts-cpu/devcontainer.json)

### molcrafts-cuda

Complete development environment with CUDA-enabled PyTorch.

**Requirements:**
- NVIDIA GPU on host
- NVIDIA Container Toolkit installed
- Compatible NVIDIA driver

**Usage:**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest",
  "runArgs": ["--gpus", "all"]
}
```

**Includes:**
- Everything from molcrafts-cpu
- CUDA-enabled PyTorch from base image
- CUDA environment configuration

[Configuration →](molcrafts-cuda/devcontainer.json)

## Base Image

Both images use `nvcr.io/nvidia/pytorch:26.01-py3` as the base, which includes:
- Ubuntu with Python 3
- PyTorch with CUDA support (CUDA image) or CPU-only (CPU image)
- Essential system libraries

## Included Features

All images include these MolCrafts features:

| Feature | Purpose |
|---------|---------|
| molpy | Python development with Ruff |
| molrs | Rust + WebAssembly development |
| molvis | Visualization tools |
| molexp | Task graph framework |
| molnex | ML environment configuration |

Plus official features:
- `common-utils` - Zsh shell and common utilities

## VS Code Extensions

Pre-configured extensions:
- `ms-python.python` - Python language support
- `rust-lang.rust-analyzer` - Rust language support
- `biomejs.biome` - JavaScript/TypeScript tooling
- `charliermarsh.ruff` - Python linting/formatting (via molpy)

## Development Workflow

1. **Start container**: Open folder in VS Code with devcontainer
2. **Verify environment**: Check that Python, Rust, Node.js are available
3. **Install project dependencies**:
   - Python: `pip install -e .`
   - Rust: `cargo build`
   - Node.js: `npm install`
4. **Code quality**:
   - Python: `ruff check` and `ruff format`
   - Rust: `cargo fmt` and `cargo clippy`
   - JavaScript: Biome extension in VS Code

## Building Images Locally

### CPU Image
```bash
cd molcrafts-cpu
devcontainer build --workspace-folder ../.. \
  --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:test
```

### CUDA Image
```bash
cd molcrafts-cuda
devcontainer build --workspace-folder ../.. \
  --image-name ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:test
```

## Testing Images

Quick verification:
```bash
cd molcrafts-cpu  # or molcrafts-cuda
devcontainer build --workspace-folder ../.. --image-name test:local
```

## Publishing

Images are automatically published to GitHub Container Registry when changes are pushed to `master`:

- `ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest`
- `ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:<commit-sha>`
- `ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest`
- `ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:<commit-sha>`

## Customization

Add additional features to pre-built images:

```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  }
}
```

Or use as a base for your own custom image.

## CUDA Requirements

For the CUDA image:

1. **Host requirements:**
   - NVIDIA GPU
   - NVIDIA driver installed
   - NVIDIA Container Toolkit installed

2. **Verify setup:**
   ```bash
   nvidia-smi  # Should show GPU info
   docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
   ```

3. **devcontainer.json:**
   ```json
   {
     "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest",
     "runArgs": ["--gpus", "all"]
   }
   ```

## Image Size

Images are optimized but include comprehensive tooling:
- Base PyTorch image: ~8-10 GB
- Additional features: ~1-2 GB
- Total: ~10-12 GB per image

## Troubleshooting

**PyTorch not found:**
- Images include PyTorch from base image (nvcr.io/nvidia/pytorch)
- Verify base image is pulled correctly

**CUDA not available:**
- Verify `--gpus all` in runArgs
- Check NVIDIA driver and Container Toolkit installation
- Test with `nvidia-smi` inside container

**Large image size:**
- These are development images with full toolchains
- For production, use minimal base images and install only what's needed

## License

See [LICENSE](../LICENSE) for details.
