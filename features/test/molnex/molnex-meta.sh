#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "uv"           uv --version
check "ruff"         ruff --version
check "ninja"        ninja --version
check "c++ compiler" c++ --version
# build-system.requires says cmake>=4.
check "cmake major >= 4" bash -c '[ "$(cmake --version | head -1 | awk "{print \$3}" | cut -d. -f1)" -ge 4 ]'

# The two settings that make `uv sync` in molnex work at all.
check "torch backend configured"  bash -c 'grep -q "^torch-backend = " /etc/uv/uv.toml'
check "molnex build isolation off" bash -c 'grep -q "no-build-isolation-package = \[\"molnex\"\]" /etc/uv/uv.toml'
check "cmake-prefix helper"        bash -c '[ -x /usr/local/bin/molcrafts-torch-cmake-prefix ]'

reportResults
