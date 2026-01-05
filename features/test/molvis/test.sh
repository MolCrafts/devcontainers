#!/bin/bash

# Test file for molvis feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Test Node.js and npm (from node feature dependency)
check "node is available" node --version
check "npm is available" npm --version

# Test Node.js version
check "node version check" bash -c "node --version | grep -E 'v[0-9]+\.[0-9]+'"

# Test npm functionality
check "npm help works" npm help

# Test Python (from molpy feature dependency)
check "python is available" python --version
check "python3 is available" python3 --version

# Test development tools from molpy
check "black is available" black --version
check "isort is available" isort --version

# Report result
reportResults