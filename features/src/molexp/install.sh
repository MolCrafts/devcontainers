#!/usr/bin/env bash

# molexp Feature Install Script
# This script only installs system dependencies for molexp
# Python packages should be installed via pip/conda in the project

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

echo_info "Setting up molexp development environment..."

# molexp doesn't need any additional system packages beyond what's provided by:
# - common-utils (git, etc.)
# - anaconda (Python, conda, pip)
# - node (Node.js, npm)

echo_info ""
echo_info "molexp feature installation complete!"
echo_info ""
echo_info "Next steps:"
echo_info "Install molexp dependencies: pip install -e ."
