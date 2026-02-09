# MolExp Task Graph Framework (molexp)

Development environment for molexp - a minimal, fully-typed task graph framework with compiler, execution engine, and DSL.

## Usage

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molexp:latest": {}
  }
}
```

## Features

- **Node.js**: JavaScript runtime (from node feature dependency)
- **Python**: Python development tools including uv and Ruff
- **VS Code extensions**: Python, Biome, Ruff

## What This Feature Does

This feature configures a development environment for molexp projects. It:
- Provides Node.js runtime for JavaScript/TypeScript components
- Installs Python tooling (uv and Ruff)
- Sets up VS Code extensions for both Python and JavaScript

Note: This feature does not install molexp itself - install it separately with `pip install -e .`

## About molexp

molexp is a minimal task-graph framework built on Pydantic, featuring:
- Pure functional task abstraction
- Static compiler producing deterministic graph execution order
- Runtime execution engine
- Tiny DSL for common data-flow patterns
- Full type safety through Pydantic

Learn more: [molexp repository](https://github.com/MolCrafts/molexp)

## Dependencies

- `ghcr.io/devcontainers/features/node:1` - Node.js runtime

## VS Code Extensions

- `ms-python.python` - Python language support
- `biomejs.biome` - JavaScript/TypeScript linting and formatting
- `charliermarsh.ruff` - Python linting and formatting

## Development Workflow

1. **Install molexp**: Clone repository and run `pip install -e .`
2. **Install dependencies**: `npm install` for Node.js packages
3. **Code quality**:
   - Python: `ruff check` and `ruff format`
   - JavaScript: Biome extension in VS Code
4. **Run tasks**: Use molexp CLI or API

## Use Cases

- Building complex computational workflows
- Task dependency management for scientific pipelines
- Parallel execution of computational tasks
- Data flow orchestration in molecular science projects

## Verification

```bash
node --version
python3 --version
uv --version
ruff --version
```

## Related Features

- **molpy**: Python development environment
- **molvis**: Visualization tools
- **molnex**: ML environment with PyTorch

## License

See [LICENSE](https://github.com/MolCrafts/devcontainers/blob/main/LICENSE)
