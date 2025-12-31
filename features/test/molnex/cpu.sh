#!/bin/bash

# Scenario test for molnex CPU mode

set -e

source dev-container-features-test-lib

# Verify CPU mode - just check that CUDA toolkit is NOT installed
check "nvcc not installed in cpu mode" bash -c "! command -v nvcc"
check "build tools available" gcc --version

reportResults
