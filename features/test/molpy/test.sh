#!/bin/bash

# Test file for molpy feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic tool availability tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "conda is available" conda --version

# Test Python version
check "python version check" bash -c "python3 --version | grep -E 'Python 3\.([0-9]|1[0-9])'"

# Test conda environment
check "conda info works" conda info
check "conda list works" conda list

# Test Jupyter installation
check "jupyter is available" jupyter --version
check "jupyter lab is available" jupyter lab --version
check "ipykernel is available" python3 -c "import ipykernel; print(ipykernel.__version__)"

# Test development tools
check "black is available" black --version
check "isort is available" isort --version

# Test that packages can be imported
check "black is importable" python3 -c "import black; print(black.__version__)"
check "isort is importable" python3 -c "import isort; print(isort.__version__)"

# Test Jupyter packages can be imported
check "jupyterlab is importable" python3 -c "import jupyterlab; print(jupyterlab.__version__)"

# Report result
reportResults
