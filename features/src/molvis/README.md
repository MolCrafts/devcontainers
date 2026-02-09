# MolVis Visualization Environment (molvis)

Visualization development environment for molecular science projects. Combines Python and Node.js tooling for building interactive molecular visualizations.

## Usage

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molvis:latest": {}
  }
}
```

## Features

- **Node.js + npm**: JavaScript runtime and package manager (from node feature dependency)
- **Python environment**: Python tooling and Ruff (from molpy dependency)
- **Biome**: Fast JavaScript/TypeScript linter and formatter
- **VS Code extension**: biomejs.biome for code quality

## What This Feature Does

This feature configures a dual Python/Node.js environment for visualization development. It:
- Provides Node.js through the official devcontainers node feature
- Provides Python tooling through molpy feature
- Configures Biome for JavaScript/TypeScript code quality

## Dependencies

- `ghcr.io/molcrafts/devcontainers/molpy:latest` - Python development environment
- `ghcr.io/devcontainers/features/node:1` - Node.js runtime

## Verification

Check that both runtimes are available:
```bash
node --version
npm --version
python3 --version
```

## Use Cases

- Building interactive 3D molecular visualizations (Three.js, Babylon.js)
- Creating web-based molecular viewers
- Developing visualization dashboards with Python backends
- Scientific data visualization with D3.js + Python

## Development Workflow

1. **Install dependencies**:
   - Python: `pip install -e .`
   - Node.js: `npm install`

2. **Code quality**:
   - Python: `ruff check` and `ruff format`
   - JavaScript: Biome extension provides linting/formatting in VS Code

3. **Build visualizations**: Use your preferred frameworks (React, Vue, vanilla JS)

## Related Features

- **molpy**: Python development environment (included as dependency)
- **molnex**: ML environment with PyTorch
- **molexp**: Task graph framework

## License

See [LICENSE](https://github.com/MolCrafts/devcontainers/blob/main/LICENSE)
