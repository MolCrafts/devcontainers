#!/bin/bash

# Test file for molnex feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic tool availability tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version

# Test Python version (molnex requires Python 3.10+)
check "python version is 3.10 or higher" bash -c "python3 --version | grep -E 'Python 3\.(1[0-9]|[2-9][0-9])'"

# Test PyTorch installation
check "pytorch is importable" python3 -c "import torch; print(torch.__version__)"

# Detect build type via torch.version.cuda (hardware availability may be false in CI)
TORCH_CUDA=$(python3 -c "import torch; print(torch.version.cuda or '')" 2>/dev/null || echo "")
CUDA_AVAILABLE=$(python3 -c "import torch; print(torch.cuda.is_available())" 2>/dev/null || echo "False")

if [ -n "$TORCH_CUDA" ]; then
    echo "Detected CUDA wheel (torch.version.cuda=$TORCH_CUDA)"
    check "cuda wheel reports version" python3 -c "import torch; assert torch.version.cuda, 'Expected CUDA build'; print(torch.version.cuda)"
    check "nvcc is available" nvcc --version
    check "cuda path set" bash -c "echo \$PATH | grep cuda"
    check "cuda lib path set" bash -c "echo \$LD_LIBRARY_PATH | grep cuda"
    # Only assert availability when runtime GPU is present; otherwise just print.
    if [ "$CUDA_AVAILABLE" = "True" ]; then
        check "cuda is available" python3 -c "import torch; assert torch.cuda.is_available(), 'CUDA not available'"
    else
        echo "CUDA wheel present but torch.cuda.is_available() is False (likely no GPU runtime)."
    fi
else
    echo "Detected CPU wheel"
    check "cpu-only pytorch" python3 -c "import torch; assert not torch.version.cuda, 'Expected CPU build'; assert not torch.cuda.is_available(), 'CUDA should not be available in CPU mode'"
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
