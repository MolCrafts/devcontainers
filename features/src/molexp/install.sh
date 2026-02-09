#!/usr/bin/env bash

# molexp Feature Install Script
# Configures development environment for molexp task graph framework.
# Note: This feature does not install molexp itself - install it via pip.

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if ! command -v python3 >/dev/null 2>&1; then
    echo_error "python3 is required but not found in the base image."
    exit 1
fi

PIP="python3 -m pip"

echo_info "molexp feature: Task graph framework development environment"
echo_info "Installing Python tooling: uv and ruff"
$PIP install --no-cache-dir --upgrade uv ruff

echo_info ""
echo_info "molexp feature installation complete!"
echo_info ""
echo_info "Next steps:"
echo_info "  - Install molexp: pip install -e ."
echo_info "  - Or use uv: uv pip install -e ."
echo_info "  - Install Node.js dependencies: npm install"
echo_info "  - Python code quality: ruff check / ruff format"
echo_info "  - JavaScript: Use Biome extension in VS Code"
