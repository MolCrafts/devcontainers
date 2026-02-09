# MolNex ML Development Environment (molnex)

ML development environment configuration for PyTorch-based machine learning projects. This feature configures the environment and VS Code extensions but **does not install PyTorch** - it must be provided by your base image.

## Usage

### CPU Development
```json
{
  "image": "nvcr.io/nvidia/pytorch:26.01-py3",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cpu"
    }
  }
}
```

### CUDA Development
Requires NVIDIA GPU on host and NVIDIA Container Toolkit:

```json
{
  "image": "nvcr.io/nvidia/pytorch:26.01-py3",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cuda"
    }
  },
  "runArgs": ["--gpus", "all"]
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `backend` | `cpu` \| `cuda` | `cpu` | PyTorch compute backend (informational only) |

## What This Feature Does

This feature:
- Configures environment variables for CUDA paths (PATH, LD_LIBRARY_PATH)
- Configures VS Code extensions for Python and Ruff
- **CPU backend**: Auto-installs PyTorch CPU if not found in base image
- **CUDA backend**: Requires PyTorch in base image (will error if not found)

This feature **does not**:
- Install CUDA Toolkit (must come from base image for CUDA backend)
- Install other ML libraries (install separately as needed)

## Requirements

### Base Image

**For CPU backend:**
- Any Python base image (e.g., `mcr.microsoft.com/devcontainers/python:3.11`)
- PyTorch will be auto-installed if not present

**For CUDA backend:**
- Must use a base image with PyTorch pre-installed
- Recommended: `nvcr.io/nvidia/pytorch:26.01-py3` or `pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime`

### Dependencies
- Depends on `ghcr.io/molcrafts/devcontainers/molpy:latest` for Python tooling

## VS Code Extensions

- `ms-python.python` - Python language support
- `charliermarsh.ruff` - Fast linting and formatting

## Verifying Installation

Check PyTorch availability:
```bash
python3 -c "import torch; print(f'PyTorch {torch.__version__}, CUDA: {torch.cuda.is_available()}')"
```

## Environment Variables

The feature configures:
- `PATH`: Includes `/usr/local/cuda/bin` for CUDA binaries
- `LD_LIBRARY_PATH`: Includes `/usr/local/cuda/lib64` for CUDA libraries

## Development Workflow

1. **Verify PyTorch**: Feature checks PyTorch is available at build time
2. **Install dependencies**: `pip install -e .`
3. **Code quality**: Use `ruff check` and `ruff format`
4. **Train models**: PyTorch from base image is ready to use

## Related Features

- **molpy**: Python development environment with Ruff
- **molvis**: Visualization tools
- **molexp**: Task graph framework

## Troubleshooting

**Error: "PyTorch not found in base image" (CUDA backend only)**
- This error only occurs with `backend: "cuda"`
- Ensure your base image includes PyTorch (e.g., nvcr.io/nvidia/pytorch:26.01-py3)
- Alternatively, use `backend: "cpu"` to auto-install CPU version

**CPU backend automatically installs PyTorch**
- If PyTorch is not found in base image, CPU version is auto-installed
- This is expected behavior for CPU backend

**CUDA not available in container**
- Verify NVIDIA driver installed on host
- Verify NVIDIA Container Toolkit installed
- Check `runArgs: ["--gpus", "all"]` is set in devcontainer.json

## License

See [LICENSE](https://github.com/MolCrafts/devcontainers/blob/main/LICENSE)
