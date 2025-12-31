# MolPy Development Environment (molpy)

A comprehensive development container feature for Python-based molecular science and computational chemistry projects. This feature sets up a complete Python environment with popular scientific computing packages and molecular science tools.

## Example Usage

```json
"features": {
    "ghcr.io/molcrafts/devcontainers/features/molpy:latest": {
        "pythonVersion": "3.11",
        "installRdkit": true,
        "installJupyter": true
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| pythonVersion | Python version to install | string | 3.11 |
| installNumpy | Install NumPy for numerical computing | boolean | true |
| installScipy | Install SciPy for scientific computing | boolean | true |
| installPandas | Install Pandas for data manipulation | boolean | true |
| installMatplotlib | Install Matplotlib for plotting | boolean | true |
| installSeaborn | Install Seaborn for statistical data visualization | boolean | false |
| installJupyter | Install Jupyter Lab and related packages | boolean | true |
| installRdkit | Install RDKit for cheminformatics | boolean | false |
| installOpenmm | Install OpenMM for molecular simulation | boolean | false |
| installMdanalysis | Install MDAnalysis for molecular dynamics analysis | boolean | false |
| installPymol | Install PyMOL for molecular visualization (open-source version) | boolean | false |
| installBiopython | Install Biopython for bioinformatics | boolean | false |
| additionalPackages | Additional conda/pip packages to install (space-separated) | string | "" |

## Features

### Core Scientific Computing
- **NumPy**: Fundamental package for scientific computing with Python
- **SciPy**: Ecosystem of open-source software for mathematics, science, and engineering
- **Pandas**: Data manipulation and analysis library
- **Matplotlib**: Comprehensive library for creating static, animated, and interactive visualizations
- **Seaborn**: Statistical data visualization based on matplotlib

### Development Environment
- **Jupyter Lab**: Interactive development environment for notebooks, code, and data
- **IPython**: Enhanced interactive Python shell
- **Code formatting tools**: Black, isort, flake8 for maintaining code quality
- **Testing framework**: pytest for writing and running tests

### Molecular Science Packages
- **RDKit**: Open-source cheminformatics toolkit
- **OpenMM**: High-performance molecular simulation toolkit
- **MDAnalysis**: Python library for analyzing molecular dynamics trajectories
- **PyMOL**: Molecular visualization system (open-source version)
- **Biopython**: Tools for biological computation

### VS Code Extensions
This feature automatically installs useful VS Code extensions:
- Python language support and debugging
- Code formatting (Black, isort)
- Linting (flake8, pylint)
- Jupyter notebook support
- Enhanced notebook features (cell tags, slideshow)

## Dependencies

This feature depends on:
- `ghcr.io/molcrafts/devcontainers/features/utils:latest` - Common utilities and shell setup
- `ghcr.io/molcrafts/devcontainers/features/miniforge:latest` - Conda/Mamba package manager

## Usage Examples

### Basic Scientific Computing Setup
```json
"features": {
    "ghcr.io/molcrafts/devcontainers/features/molpy:latest": {
        "pythonVersion": "3.11",
        "installNumpy": true,
        "installScipy": true,
        "installPandas": true,
        "installMatplotlib": true,
        "installJupyter": true
    }
}
```

### Cheminformatics Workbench
```json
"features": {
    "ghcr.io/molcrafts/devcontainers/features/molpy:latest": {
        "pythonVersion": "3.11",
        "installRdkit": true,
        "installPymol": true,
        "installBiopython": true,
        "installJupyter": true,
        "additionalPackages": "chembl_webresource_client pubchempy"
    }
}
```

### Molecular Dynamics Analysis
```json
"features": {
    "ghcr.io/molcrafts/devcontainers/features/molpy:latest": {
        "pythonVersion": "3.11",
        "installOpenmm": true,
        "installMdanalysis": true,
        "installNumpy": true,
        "installScipy": true,
        "installMatplotlib": true,
        "additionalPackages": "nglview MDAnalysisTests"
    }
}
```

## Post-Installation

After installation, you can:

1. **Check installation status**: Run `molpy-info` to see installed packages and versions
2. **Start Jupyter Lab**: Use `jupyter lab --ip=0.0.0.0 --no-browser` for web-based development
3. **Create new environments**: Use `conda create -n myproject python=3.11` for project isolation
4. **Install additional packages**: Use `conda install package_name` or `pip install package_name`

## Environment Variables

The feature sets up the following environment variables:
- Python and conda are available in the system PATH
- Conda base environment is auto-activated for new shells
- Jupyter Lab is configured for development container use

## Supported Platforms

- `linux/amd64` and `linux/arm64`
- Debian and Ubuntu-based containers

## Package Management

This feature uses Mamba (if available) or Conda for package management, which provides:
- Fast dependency resolution
- Access to conda-forge channel with pre-compiled binaries
- Better performance compared to pip for scientific packages
- Consistent environment management

## Development Tools

The feature includes several development tools out of the box:
- **Black**: Uncompromising Python code formatter
- **isort**: Import sorting utility
- **flake8**: Style guide enforcement
- **pytest**: Testing framework
- **Jupyter Lab extensions**: Git integration, LSP support

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/MolCrafts/devcontainers/blob/main/features/src/molrs/devcontainer-feature.json). Add additional notes to a `NOTES.md`._
