#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

# The non-optional core survives every opt-out.
check "cmake on PATH"    cmake --version
check "ninja on PATH"    ninja --version
check "c++ compiler"     c++ --version
check "cmake major >= 4" bash -c '[ "$(cmake --version | head -1 | awk "{print \$3}" | cut -d. -f1)" -ge 4 ]'

# The opt-outs must actually save the space they claim to.
check "no clangd"  bash -c "! command -v clangd"
check "no doxygen" bash -c "! command -v doxygen"
check "no ccache"  bash -c "! command -v ccache"

reportResults
