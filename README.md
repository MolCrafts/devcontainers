# MolCrafts DevContainers

Development container features and pre-built images for molecular science projects. Provides ready-to-use development environments with Python, Rust, visualization tools, and machine learning frameworks.

## Quick Start

### Pre-built Images

Use complete pre-configured environments:

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

### Individual Features

Compose your own environment by selecting specific features:

```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/anaconda:1": {},
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {},
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cpu"
    }
  }
}
```

**Important**: MolCrafts features configure development environments but do not install base runtimes (Python, Node.js, Rust). Use appropriate base images or official devcontainer features first.

## Repository Structure

```
.
├── features/              # Individual feature definitions
│   ├── src/
│   │   ├── molpy/        # Python development with Ruff
│   │   ├── molrs/        # Rust + WebAssembly
│   │   ├── molvis/       # Visualization tools
│   │   ├── molexp/       # Task graph framework
│   │   └── molnex/       # ML environment (requires PyTorch in base image)
│   └── test/             # Feature tests
├── images/               # Pre-built complete environments
│   ├── molcrafts-cpu/    # All features, CPU-only
│   └── molcrafts-cuda/   # All features, CUDA-enabled
└── .github/workflows/    # CI/CD pipelines
```

## Available Features

Individual features for custom environments. See [features/README.md](features/README.md) for details.

| Feature | Description | Base Requirements |
|---------|-------------|-------------------|
| **molpy** | Python development with Ruff | Python base image or anaconda feature |
| **molrs** | Rust + wasm-pack | rust feature |
| **molvis** | Visualization tools | Python + Node.js |
| **molexp** | Task graph framework | Node.js |
| **molnex** | ML environment config | PyTorch base image (e.g., nvcr.io/nvidia/pytorch) |

### Feature Dependencies

```
molpy (Python + Ruff)
├─ molnex (ML environment)
└─ molvis (Visualization)

molexp (Task graphs, independent)

molrs (Rust + WASM, independent)
```

## Pre-built Images

Complete environments ready to use. See [images/README.md](images/README.md) for details.

- **molcrafts-cpu**: All features with CPU-only PyTorch
- **molcrafts-cuda**: All features with CUDA-enabled PyTorch (requires GPU)

## Development Philosophy

This repository follows a clear separation of concerns:

- **Base images provide runtimes**: Python, PyTorch, Node.js, Rust
- **Features provide development tooling**: Linters, formatters, VS Code extensions
- **Features configure environments**: Environment variables, paths, settings

Features do **not** install major runtime packages. This approach:
- Avoids version conflicts between base image and feature installations
- Reduces build time and image size
- Simplifies maintenance
- Follows devcontainer best practices

## Development

### Testing Features

```bash
# Test all features
devcontainer features test ./features

# Test specific feature
devcontainer features test ./features -f molnex
```

### Testing Images

```bash
cd images/molcrafts-cpu
devcontainer build --workspace-folder ../.. --image-name test:local
```

### Publishing

Components are automatically published to GitHub Container Registry when changes are pushed to `master`:

- **Features**: `ghcr.io/molcrafts/devcontainers/<feature-name>:latest`
- **Images**: `ghcr.io/molcrafts/devcontainers/images/<image-name>:latest`

## CI/CD Workflows

Automated testing and publishing:

1. **feature-test.yaml**: Tests all features
2. **feature-validate.yml**: Validates feature schemas
3. **feature-release.yaml**: Publishes features to ghcr.io
4. **image-test.yaml**: Tests image builds
5. **image-validate.yml**: Validates image configurations
6. **image-release.yaml**: Builds and publishes images to ghcr.io

## Code Quality Standards

All MolCrafts features use **Ruff** as the standard Python linting and formatting tool:

- Faster than traditional tools (black, isort, flake8)
- Single tool for linting and formatting
- Modern Python best practices
- Configured via `pyproject.toml` or `ruff.toml`

Usage:
```bash
ruff check .      # Lint code
ruff format .     # Format code
```

## Documentation

- [Dev Containers Specification](https://containers.dev/)
- [Features Development Guide](https://containers.dev/implementors/features/)
- [Testing Features](https://github.com/devcontainers/cli/blob/main/docs/features/test.md)

## License

See [LICENSE](LICENSE) file for details.
