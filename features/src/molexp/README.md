# molexp (devcontainer feature)

A devcontainer feature for setting up molexp - a minimal task graph framework with compiler, engine, and DSL.

## Description

This feature installs and configures a Python development environment optimized for molexp development, including:

- Python 3.12+ with Anaconda
- molexp core dependencies (Pydantic, PyYAML, Typer, Rich, psutil, FastAPI, uvicorn)
- Python development tools (Black, isort)
- Optional Jupyter Lab support
- VS Code extensions for Python development

## Usage

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/molcrafts/devcontainers/features/molexp:latest": {
      "installJupyter": true
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installJupyter` | boolean | `true` | Install Jupyter Lab and related packages |

## What's Included

### Python Packages

- **pydantic** (>=2.5) - Data validation using Python type annotations
- **pyyaml** (>=6.0) - YAML parser and emitter
- **typer** (>=0.9.0) - CLI framework
- **rich** (>=13.0.0) - Rich text and beautiful formatting
- **psutil** (>=5.9.0) - Process and system utilities
- **fastapi** (>=0.100.0) - Modern web framework
- **uvicorn** (>=0.23.0) - ASGI server

### Development Tools

- **black** - Python code formatter
- **isort** - Import statement organizer
- **jupyterlab** (optional) - Interactive development environment
- **ipykernel** (optional) - IPython kernel for Jupyter

### VS Code Extensions

- `ms-python.python` - Python language support
- `ms-python.black-formatter` - Black formatter integration
- `ms-python.isort` - isort integration
- `ms-toolsai.jupyter` - Jupyter notebook support

## About molexp

molexp is a tiny yet fully-typed task-graph framework built on top of Pydantic. It contains a pure functional task abstraction, a static compiler that produces deterministic graph orders, a runtime engine, and a tiny DSL for common data-flow patterns.

For more information, visit the [molexp repository](https://github.com/MolCrafts/molexp).
