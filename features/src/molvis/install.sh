#!/usr/bin/env bash

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
# Function to install packages with pip
install_pip_packages() {
    local packages="$1"
    if [ -n "$packages" ]; then
        echo_info "Installing pip packages: $packages"
        pip install --no-cache-dir $packages
    fi
}

install_pip_packages "isort black"
