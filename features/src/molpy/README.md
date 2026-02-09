# MolPy Development Environment (molpy)

Python development environment feature for molecular science projects. This feature configures VS Code extensions for Python development with modern tooling.

## Features

- **Ruff**: Fast Python linter and formatter (replaces black, isort, flake8)
- **uv**: Fast Python package and environment manager
- **Autodocstring**: Automatic docstring generation

## Usage

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molpy:latest": {}
  }
}
```

## What This Feature Does

This feature installs Python tooling (`uv`, `ruff`) and configures VS Code extensions for Python development. It does **not** install your project dependencies - install those separately.

### VS Code Extensions Included

- `charliermarsh.ruff` - Python linting and formatting
- `ms-python.python` - Python language support
- `njpwerner.autodocstring` - Docstring generation

## Development Workflow

After installing this feature:

1. **Install dependencies**: `uv pip install -e .` or `pip install -e .`
2. **Lint code**: `ruff check .`
3. **Format code**: `ruff format .`
4. **Configure Ruff**: Add settings to `pyproject.toml` or `ruff.toml`

## Ruff Configuration Example

Add to your `pyproject.toml`:

```toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I"]  # pycodestyle, pyflakes, isort
```

## Requirements

- Base image with Python installed (e.g., `mcr.microsoft.com/devcontainers/python:3.11`)
- Or use with anaconda feature: `ghcr.io/devcontainers/features/anaconda:1`

## Related Features

- **molnex**: Machine learning environment with PyTorch
- **molvis**: Visualization tools with Node.js
- **molexp**: Task graph framework

## License

See [LICENSE](https://github.com/MolCrafts/devcontainers/blob/main/LICENSE)
