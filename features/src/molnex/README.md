
# molnex (molnex)

A feature for setting up molnex - unified modeling of molecular potentials and properties with physics-aware ML

## Example Usage

```json
"features": {
    "ghcr.io/MolCrafts/devcontainers/molnex:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| backend | PyTorch compute backend: 'cpu' for CPU-only or 'cuda' for GPU support | string | cpu |
| cudaVersion | CUDA version to install (only used when backend is 'cuda'). Supported: '13.0', '12.8', '12.6', '12.1', '11.8' | string | 12.6 |

## Customizations

### VS Code Extensions

- `ms-python.python`
- `ms-python.black-formatter`
- `ms-python.isort`
- `ms-toolsai.jupyter`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/MolCrafts/devcontainers/blob/main/features/src/molnex/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
