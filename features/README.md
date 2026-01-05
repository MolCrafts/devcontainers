# MolCrafts DevContainer Features

Individual devcontainer features for molecular science development. These can be used independently or combined to create custom development environments.

## Available Features

### molpy

Python development environment for molecular science with Jupyter support.

**Includes:**
- Python 3.x with Anaconda
- Jupyter Lab (optional)
- Development tools (black, isort)
- VS Code Python extensions

**Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {
      "installJupyter": true
    }
  }
}
```

---

### molrs

Rust development environment for molecular science with WebAssembly support.

**Includes:**
- Rust toolchain (cargo, rustc, rustup)
- wasm-pack for WebAssembly
- Python and Anaconda (via dependencies)
- VS Code Rust extensions

**Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molrs:latest": {}
  }
}
```

---

### molvis

Visualization tools combining Node.js and Python for molecular visualization.

**Includes:**
- Node.js and npm
- Python environment (via molpy)
- Biome formatter
- VS Code extensions

**Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molvis:latest": {}
  }
}
```

---

### molexp

Task graph framework development environment with Python 3.12+.

**Includes:**
- Python 3.12+ with Anaconda
- molexp dependencies (Pydantic, FastAPI, Typer, Rich)
- Node.js (for UI development)
- Jupyter Lab (optional)
- Development tools

**Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molexp:latest": {
      "installJupyter": true
    }
  }
}
```

---

### molnex

ML training system with **CPU or CUDA support** for PyTorch.

**Includes:**
- PyTorch (CPU or CUDA)
- CUDA Toolkit (CUDA mode only)
- Python environment (via molpy)

**CPU Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {}
  }
}
```

**CUDA Usage:**
```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molnex:latest": {
      "backend": "cuda",
      "cudaVersion": "13.1"
    }
  },
  "runArgs": ["--gpus", "all"]
}
```

> [!IMPORTANT]
> CUDA support requires NVIDIA GPU drivers and NVIDIA Container Toolkit on the host machine.

---

## Feature Dependencies

```
molpy (base)
  ├── molrs (depends on molpy)
  ├── molvis (depends on molpy)
  ├── molexp (standalone)
  └── molnex (depends on molpy)
```

---

## Development

### Testing

```bash
# Test all features
devcontainer features test .

# Test specific feature
devcontainer features test . -f molnex
```

### Creating New Features

Follow the [Dev Container Features specification](https://containers.dev/implementors/features/) to create new features.

Each feature should contain:
- `devcontainer-feature.json`: Feature metadata
- `install.sh`: Installation script
- `README.md`: Feature documentation (auto-generated)

