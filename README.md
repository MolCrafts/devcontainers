# MolCrafts DevContainers

A collection of devcontainer features and pre-built images for molecular science development, providing ready-to-use development environments for Python, Rust, visualization, and machine learning workflows.

## Quick Start

### Using Pre-built Images

The easiest way to get started is using our pre-built images:

**CPU Image:**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:latest"
}
```

**CUDA Image (requires NVIDIA GPU):**
```json
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:latest",
  "runArgs": ["--gpus", "all"]
}
```

### Using Individual Features

Compose your own environment by selecting specific features:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {
      "installJupyter": true
    },
    "ghcr.io/molcrafts/devcontainers/molrs:latest": {}
  }
}
```

## Repository Structure

```
.
├── features/
│   ├── src/              # Feature definitions
│   │   ├── molpy/        # Python + Anaconda + Jupyter
│   │   ├── molrs/        # Rust toolchain + wasm-pack
│   │   ├── molvis/       # Node.js + visualization tools
│   │   ├── molexp/       # Task graph framework
│   │   └── molnex/       # PyTorch (CPU/CUDA)
│   └── test/             # Feature tests
├── images/
│   ├── molcrafts-cpu/    # Complete CPU environment
│   └── molcrafts-cuda/   # Complete CUDA environment
└── .github/workflows/    # CI/CD pipelines
```

## Available Components

### Features

Individual features that can be combined. See [features/README.md](features/README.md) for details:

- **molpy**: Python development with Anaconda and Jupyter
- **molrs**: Rust development with WebAssembly support
- **molvis**: Visualization tools (Node.js + Python)
- **molexp**: Task graph framework (Python 3.12+)
- **molnex**: ML training with PyTorch (CPU or CUDA)

### Images

Pre-built complete environments. See [images/README.md](images/README.md) for details:

- **molcrafts-cpu**: All features with CPU-only PyTorch
- **molcrafts-cuda**: All features with CUDA-enabled PyTorch

## Development

### Testing Features

```bash
# Test all features
devcontainer features test ./features

# Test specific feature
devcontainer features test --features molnex ./features
```

### Testing Images

```bash
# Test image builds
cd images/molcrafts-cpu
devcontainer build --workspace-folder ../.. --image-name test:local
```

### Publishing

All components are automatically published to GitHub Container Registry when changes are pushed to the `master` branch:

- **Features**: `ghcr.io/molcrafts/devcontainers/<feature-name>:latest`
- **Images**: `ghcr.io/molcrafts/devcontainers/images/<image-name>:latest`

## GitHub Actions Workflows

This repository uses 6 separate CI/CD workflows:

1. **feature-test.yaml**: Tests all features
2. **feature-validate.yml**: Validates feature schemas
3. **feature-release.yaml**: Publishes features to ghcr.io
4. **image-test.yaml**: Tests image builds
5. **image-validate.yml**: Validates image configurations
6. **image-release.yaml**: Builds and publishes images to ghcr.io

## Documentation

- [Dev Containers Specification](https://containers.dev/)
- [Features Development Guide](https://containers.dev/implementors/features/)
- [Testing Features](https://github.com/devcontainers/cli/blob/main/docs/features/test.md)

## License

See [LICENSE](LICENSE) file for details.
