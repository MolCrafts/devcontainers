#!/usr/bin/env bash

# molpy Feature Install Script
# This script sets up Python development environment for molecular science.

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

echo_info "Installing Python tooling: uv and ruff"
$PIP install --no-cache-dir --upgrade uv ruff

echo_info "molpy feature: Python development environment configured"
echo_info "uv and ruff are installed and available in PATH"
echo_info "VS Code Python and Ruff extensions are configured"
echo_info ""
echo_info "Next steps:"
echo_info "  - Install your project dependencies: pip install -e ."
echo_info "  - Use 'uv pip install -e .' or 'pip install -e .'"
echo_info "  - Use 'ruff check' for linting"
echo_info "  - Use 'ruff format' for code formatting"
