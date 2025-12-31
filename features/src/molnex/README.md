# molnex (devcontainer feature)

A devcontainer feature for setting up molnex - unified modeling of molecular potentials and properties with physics-aware ML.

## Description

This feature installs and configures a Python development environment optimized for molnex ML development, with **flexible CPU or CUDA support** for PyTorch:

- Python 3.10+ with Anaconda
- PyTorch for deep learning (CPU or CUDA)
- NumPy for numerical computing
- molpy feature as a dependency
- VS Code extensions for Python development

## Usage

### CPU-only (Default)

For CPU-only PyTorch installation:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {}
  }
}
```

Or explicitly specify CPU:

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cpu"
    }
  }
}
```

### CUDA-enabled (GPU Support)

For CUDA-enabled PyTorch with GPU support:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cuda",
      "cudaVersion": "12.6"
    }
  },
  "runArgs": ["--gpus", "all"]
}
```

> [!IMPORTANT]
> **CUDA Prerequisites**: To use CUDA support, you must have:
> - NVIDIA GPU drivers installed on your host machine
> - NVIDIA Container Toolkit installed and configured
> - Docker configured to use the NVIDIA runtime
> 
> See the [NVIDIA Container Toolkit installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) for setup instructions.

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `backend` | string (enum) | `"cpu"` | PyTorch compute backend: `"cpu"` for CPU-only or `"cuda"` for GPU support |
| `cudaVersion` | string | `"12.6"` | CUDA version to install (only used when `backend` is `"cuda"`). Supported: `"13.0"`, `"12.8"`, `"12.6"`, `"12.1"`, `"11.8"` |

## What's Included

### Python Packages

- **pytorch** (>=2.0) - Deep learning framework
  - CPU version: Optimized for CPU-only computation
  - CUDA version: GPU-accelerated with CUDA support
- **torch-scatter** (>=2.1) - Scatter operations for PyTorch (essential for graph neural networks)
- **numpy** (>=1.21) - Numerical computing library
- **molpy** - Molecular science Python packages (via molpy feature dependency)

### System Packages (CUDA mode only)

When `backend` is set to `"cuda"`, the following system-level packages are installed:

- **CUDA Toolkit** - Complete CUDA development toolkit
  - CUDA compiler (nvcc)
  - CUDA libraries
  - CUDA runtime
- **Environment variables** automatically configured:
  - `PATH`: Includes `/usr/local/cuda/bin`
  - `LD_LIBRARY_PATH`: Includes `/usr/local/cuda/lib64`


### Development Tools

Inherited from the molpy feature:
- **black** - Python code formatter
- **isort** - Import statement organizer
- **jupyterlab** - Interactive development environment
- **ipykernel** - IPython kernel for Jupyter

### VS Code Extensions

- `ms-python.python` - Python language support
- `ms-python.black-formatter` - Black formatter integration
- `ms-python.isort` - isort integration
- `ms-toolsai.jupyter` - Jupyter notebook support

## Dependencies

This feature depends on:
- `ghcr.io/devcontainers/features/common-utils:2` - Common utilities
- `ghcr.io/devcontainers/features/anaconda:1` - Anaconda Python distribution
- `ghcr.io/molcrafts/devcontainers/molpy:latest` - Molecular science Python packages

## About molnex

molnex is a standalone ML training system with structural protocol compatibility to molexp. It provides a clean, ML-focused API for training while maintaining zero coupling with molexp through duck typing.

Key features:
- Standalone training system with complete independence from molexp
- ML-first API using training terminology (Trainer, TrainState, StepResult)
- Graph export for semantic graph representation
- Fully tested with comprehensive test suite

For more information, visit the [molnex repository](https://github.com/MolCrafts/molnex).

## Verifying Installation

### CPU Mode

After the container is built, verify CPU installation:

```bash
python3 -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}')"
```

Expected output:
```
PyTorch: 2.x.x+cpu
CUDA available: False
```

### CUDA Mode

After the container is built, verify CUDA installation:

```bash
python3 -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}')"
```

Expected output:
```
PyTorch: 2.x.x+cuXXX
CUDA available: True
CUDA version: 12.6
```

Check GPU details:
```bash
python3 -c "import torch; print(f'GPU: {torch.cuda.get_device_name(0)}')"
```

### torch-scatter

Verify torch-scatter is working:

```python
import torch
import torch_scatter

# Simple scatter test
src = torch.randn(10, 5)
index = torch.tensor([0, 0, 1, 1, 1, 2, 2, 2, 2, 2])
out = torch_scatter.scatter(src, index, dim=0, reduce="mean")
print(f"torch-scatter is working! Output shape: {out.shape}")
```

## Troubleshooting

### CUDA not available in container

If `torch.cuda.is_available()` returns `False` in CUDA mode:

1. **Check host GPU**: Run `nvidia-smi` on your host machine to verify GPU drivers
2. **Check Container Toolkit**: Verify NVIDIA Container Toolkit is installed
3. **Check runArgs**: Ensure your devcontainer.json includes `"runArgs": ["--gpus", "all"]`
4. **Check Docker runtime**: Test with `docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi`

### torch-scatter installation fails

If torch-scatter fails to install:

1. Ensure PyTorch is installed first (the feature handles this automatically)
2. Check that the PyTorch version is compatible with torch-scatter
3. For CUDA builds, ensure CUDA toolkit is properly installed

### Different CUDA version needed

To use a different CUDA version, specify it in the feature options:

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cuda",
      "cudaVersion": "11.8"
    }
  }
}
```

Supported CUDA versions depend on PyTorch compatibility. Check the [PyTorch website](https://pytorch.org/get-started/locally/) for supported versions.

