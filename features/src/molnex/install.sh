#!/usr/bin/env bash
# molnex Feature Install Script
# - Installs build tools + Python deps via pip
# - Does NOT install CUDA. If CUDA is present in the image, we install CUDA PyTorch wheels.
#
# Control:
#   BACKEND=cuda | cpu   (default: cpu)
# Behavior:
#   - If BACKEND=cuda but CUDA version can't be detected -> fallback to CPU wheels.
#   - If torch already installed:
#       * matches requested mode (cpu/cuda + version) -> skip
#       * otherwise -> reinstall

set -Eeuo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
echo_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $*"; }

PIP="python3 -m pip"
BACKEND="${BACKEND:-cpu}"   # cpu | cuda

echo_info "molnex feature install (BACKEND=${BACKEND})"

# Build tools (for compiling Python extensions)
echo_info "Installing build tools..."
apt-get update
apt-get install -y --no-install-recommends build-essential
apt-get clean -y
rm -rf /var/lib/apt/lists/*

# --- Detect system CUDA version (only if BACKEND=cuda) ---
CUDA_VERSION=""
if [[ "$BACKEND" == "cuda" ]]; then
  # Try nvcc first, then version.json as a fallback
  if command -v nvcc >/dev/null 2>&1; then
    CUDA_VERSION="$(nvcc --version 2>/dev/null | sed -n 's/.*release \([0-9]\+\.[0-9]\+\).*/\1/p' | head -n1 || true)"
  fi
  if [[ -z "$CUDA_VERSION" && -r /usr/local/cuda/version.json ]]; then
    CUDA_VERSION="$(python3 -c 'import json; p="/usr/local/cuda/version.json"; print(json.load(open(p)).get("cuda",{}).get("version",""))' 2>/dev/null | sed -n 's/^\([0-9]\+\.[0-9]\+\).*/\1/p' | head -n1 || true)"
  fi
  if [[ -z "$CUDA_VERSION" && -r /usr/local/cuda/version.txt ]]; then
    CUDA_VERSION="$(sed -n 's/.*CUDA Version \([0-9]\+\.[0-9]\+\).*/\1/p' /usr/local/cuda/version.txt | head -n1 || true)"
  fi

  if [[ -z "$CUDA_VERSION" ]]; then
    echo_warn "BACKEND=cuda but CUDA version not detected in image. Falling back to CPU PyTorch wheels."
    BACKEND="cpu"
  else
    echo_info "Detected CUDA version: ${CUDA_VERSION}"
  fi
fi

# --- Decide whether we need to install/reinstall torch ---
INSTALL_TORCH=1

if python3 -c "import torch" >/dev/null 2>&1; then
  installed_cuda="$(python3 -c 'import torch; print(torch.version.cuda or "")')"

  if [[ "$BACKEND" == "cuda" ]]; then
    if [[ -n "$installed_cuda" && "$installed_cuda" == "$CUDA_VERSION" ]]; then
      echo_info "PyTorch already installed and CUDA matches (${installed_cuda})."
      INSTALL_TORCH=0
    else
      echo_warn "PyTorch installed but CUDA mismatch/CPU build: torch.version.cuda='${installed_cuda:-<empty>}' expected='${CUDA_VERSION}'. Will reinstall."
      $PIP uninstall -y torch torchvision torchaudio >/dev/null 2>&1 || true
      INSTALL_TORCH=1
    fi
  else
    if [[ -z "$installed_cuda" ]]; then
      echo_info "PyTorch already installed (CPU build)."
      INSTALL_TORCH=0
    else
      echo_warn "PyTorch installed with CUDA (${installed_cuda}) but CPU backend requested. Will reinstall CPU wheels."
      $PIP uninstall -y torch torchvision torchaudio >/dev/null 2>&1 || true
      INSTALL_TORCH=1
    fi
  fi
else
  echo_info "PyTorch not found. Will install."
fi

# --- Install torch if needed ---
if [[ "$INSTALL_TORCH" == "1" ]]; then
  if [[ "$BACKEND" == "cuda" ]]; then
    cu_tag="cu${CUDA_VERSION/./}"                 # 12.8 -> cu128
    idx_url="https://download.pytorch.org/whl/${cu_tag}"

    # Explicit allowlist to avoid 404 surprises
    case "$cu_tag" in
      cu118|cu121|cu124|cu125|cu126|cu128|cu130)
        echo_info "Installing CUDA PyTorch wheels from ${idx_url}"
        $PIP install -U torch torchvision torchaudio --index-url "$idx_url"
        ;;
      *)
        echo_warn "Detected CUDA_VERSION=${CUDA_VERSION} -> tag ${cu_tag} not supported on PyTorch wheel index; falling back to CPU wheels."
        BACKEND="cpu"
        $PIP install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
        ;;
    esac
  else
    echo_info "Installing CPU-only PyTorch wheels"
    $PIP install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
  fi
fi

# --- Other deps ---
echo_info "Installing NumPy..."
$PIP install -U numpy

# --- Verify (GPU may be unavailable during build) ---
echo_info "Verifying installation..."
python3 - <<'PY' || true
import torch, numpy as np
print("PyTorch:", torch.__version__)
print("torch.version.cuda:", torch.version.cuda)
print("cuda.is_available:", torch.cuda.is_available())
print("NumPy:", np.__version__)
PY

echo_info ""
echo_info "molnex feature installation complete!"
echo_info "Compute backend: ${BACKEND}"
if [[ "$BACKEND" == "cuda" ]]; then
  echo_info "CUDA version: ${CUDA_VERSION}"
  echo_warn "Note: GPU access requires compatible NVIDIA driver on the host and GPU-enabled container runtime."
fi
echo_info ""
echo_info "Next steps:"
echo_info "  ${PIP} install -e ."
