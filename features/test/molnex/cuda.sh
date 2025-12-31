#!/bin/bash

# Scenario test for molnex CUDA mode

set -e

source dev-container-features-test-lib

# Verify CUDA mode - check that CUDA toolkit IS installed
check "nvcc installed" nvcc --version
check "cuda path set" bash -c "echo \$PATH | grep cuda"
check "cuda lib path set" bash -c "echo \$LD_LIBRARY_PATH | grep cuda"
check "build tools available" gcc --version

reportResults
