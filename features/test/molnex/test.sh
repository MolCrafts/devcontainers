#!/bin/bash

# Test file for molnex feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic tool availability tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "conda is available" conda --version

# Test Python version (molnex requires Python 3.10+)
check "python version is 3.10 or higher" bash -c "python3 --version | grep -E 'Python 3\.(1[0-9]|[2-9][0-9])'"

# Test PyTorch installation
check "pytorch is importable" python3 -c "import torch; print(torch.__version__)"

# Detect compute backend
CUDA_AVAILABLE=$(python3 -c "import torch; print(torch.cuda.is_available())" 2>/dev/null || echo "False")

if [ "$CUDA_AVAILABLE" = "True" ]; then
    echo "Detected CUDA backend - running CUDA-specific tests"
    
    # CUDA-specific tests
    check "cuda is available" python3 -c "import torch; assert torch.cuda.is_available(), 'CUDA not available'"
    check "cuda version check" python3 -c "import torch; print(f'CUDA version: {torch.version.cuda}')"
    check "nvcc is available" nvcc --version
else
    echo "Detected CPU backend - running CPU-specific tests"
    
    # CPU-specific tests
    check "cpu-only pytorch" python3 -c "import torch; assert not torch.cuda.is_available(), 'CUDA should not be available in CPU mode'"
fi

# Test numpy installation
check "numpy is importable" python3 -c "import numpy; print(numpy.__version__)"

# Test build tools
check "gcc is available" gcc --version
check "g++ is available" g++ --version

# Test that molpy dependencies are available (inherited from molpy feature)
check "black is available" black --version
check "isort is available" isort --version

# Report result
reportResults
