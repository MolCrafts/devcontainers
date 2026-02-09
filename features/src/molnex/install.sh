#!/usr/bin/env bash

# molnex Feature Install Script
# This feature configures the environment for PyTorch-based machine learning development
# - CPU backend: Installs PyTorch CPU if not found in base image
# - CUDA backend: Requires PyTorch in base image (e.g., nvcr.io/nvidia/pytorch:26.01-py3)

set -Eeuo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
echo_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $*"; }

BACKEND="${BACKEND:-cpu}"
PIP="python3 -m pip"

echo_info "molnex feature: Configuring ML development environment (backend=${BACKEND})"

# Install common Python tooling.
echo_info "Installing Python tooling: uv and ruff"
$PIP install --no-cache-dir --upgrade uv ruff

# Check if PyTorch is available
if ! python3 -c "import torch" >/dev/null 2>&1; then
  if [ "$BACKEND" = "cpu" ]; then
    # CPU backend: Auto-install PyTorch CPU if not found
    echo_warn "PyTorch not found in base image"
    echo_info "Installing PyTorch CPU version..."
    $PIP install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    echo_info "PyTorch CPU installed successfully"
  else
    # CUDA backend: Require PyTorch in base image
    echo_error "PyTorch not found in base image!"
    echo_error "For CUDA backend, molnex requires a base image with PyTorch pre-installed."
    echo_error "Recommended base images:"
    echo_error "  - nvcr.io/nvidia/pytorch:26.01-py3"
    echo_error "  - pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime"
    echo_error ""
    echo_error "Alternatively, use backend=cpu to auto-install CPU version."
    exit 1
  fi
fi

# Display PyTorch info
echo_info "PyTorch configuration:"
python3 - <<'PY' || true
import torch
print(f"  PyTorch version: {torch.__version__}")
print(f"  CUDA available: {torch.cuda.is_available()}")
if torch.version.cuda:
    print(f"  CUDA version: {torch.version.cuda}")
PY

echo_info ""
echo_info "molnex feature installation complete!"
echo_info "Environment configured for ${BACKEND} backend"
echo_info ""
echo_info "Next steps:"
echo_info "  - Install your project: pip install -e ."
echo_info "  - Use 'ruff check' and 'ruff format' for code quality"
