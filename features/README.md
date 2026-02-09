# MolCrafts DevContainer Features

Individual features that can be used independently or combined to create custom development environments for molecular science projects.

## Feature Overview

| Feature | Version | Description | Dependencies |
|---------|---------|-------------|--------------|
| **molpy** | 0.0.5 | Python development with Ruff | Python base image or anaconda feature |
| **molrs** | 0.0.3 | Rust + WebAssembly | rust feature |
| **molvis** | 0.0.3 | Visualization tools (Python + Node.js) | molpy + node feature |
| **molexp** | 0.0.3 | Task graph framework | node feature |
| **molnex** | 0.0.4 | ML environment configuration | molpy + PyTorch base image |

## Usage Examples

### Python Development
```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {}
  }
}
```

### Rust Development
```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/rust:1": {},
    "ghcr.io/molcrafts/devcontainers/molrs:latest": {}
  }
}
```

### Visualization Development
```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {},
    "ghcr.io/molcrafts/devcontainers/molvis:latest": {}
  }
}
```

### ML Development (CPU)
```json
{
  "image": "nvcr.io/nvidia/pytorch:26.01-py3",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {},
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cpu"
    }
  }
}
```

### ML Development (CUDA)
```json
{
  "image": "nvcr.io/nvidia/pytorch:26.01-py3",
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {},
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cuda"
    }
  },
  "runArgs": ["--gpus", "all"]
}
```

## Feature Details

### molpy - Python Development

Configures Python development environment with modern tooling.

**What it provides:**
- Ruff for linting and formatting (replaces black, isort, flake8)
- uv for Python package/environment management
- Autodocstring generation

**What it does NOT provide:**
- Python runtime (use Python base image)
- Python packages (install via pip)

[Full documentation →](src/molpy/README.md)

### molrs - Rust Development

Rust development with WebAssembly compilation support.

**What it provides:**
- wasm-pack for WebAssembly builds
- rust-analyzer VS Code extension

**What it does NOT provide:**
- Rust toolchain (use rust feature)

[Full documentation →](src/molrs/README.md)

### molvis - Visualization Development

Dual Python/Node.js environment for building molecular visualizations.

**What it provides:**
- Combined Python and Node.js tooling
- Biome for JavaScript/TypeScript

**What it does NOT provide:**
- Python or Node.js runtimes (use appropriate base image and features)

[Full documentation →](src/molvis/README.md)

### molexp - Task Graph Framework

Development environment for molexp task graph projects.

**What it provides:**
- Node.js + Python development tools
- uv and Ruff for Python tooling
- Biome and Ruff for code quality

**What it does NOT provide:**
- molexp library (install via pip)
- Base runtimes (use appropriate features)

[Full documentation →](src/molexp/README.md)

### molnex - ML Environment

ML development environment configuration (does NOT install PyTorch).

**What it provides:**
- CUDA environment variable configuration
- VS Code extensions for Python and Ruff
- Verification that PyTorch exists in base image

**What it does NOT provide:**
- PyTorch (must be in base image like nvcr.io/nvidia/pytorch)
- Other ML libraries (install via pip)

**Important**: This feature requires a base image with PyTorch pre-installed.

[Full documentation →](src/molnex/README.md)

## Dependency Graph

```
molpy (base Python development)
├── molnex (depends on molpy)
└── molvis (depends on molpy + node)

molexp (depends on node)

molrs (depends on rust feature)
```

## Testing Features

Test all features:
```bash
devcontainer features test ./features
```

Test specific feature:
```bash
devcontainer features test ./features -f molnex
```

## Creating New Features

Reference the [Features Development Guide](https://containers.dev/implementors/features/) for details.

Each feature must include:
- `devcontainer-feature.json` - Metadata and configuration
- `install.sh` - Installation script
- `README.md` - Documentation

## Code Quality

All Python-based features use **Ruff** for linting and formatting:

```bash
ruff check .      # Lint
ruff format .     # Format
```

Configure Ruff in `pyproject.toml`:
```toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I"]  # pycodestyle, pyflakes, isort
```

## License

See [LICENSE](../LICENSE) for details.
