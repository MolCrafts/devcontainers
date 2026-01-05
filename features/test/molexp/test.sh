#!/bin/bash

# Test file for molexp feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic tool availability tests
check "python3 is available" python3 --version
check "pip3 is available" pip3 --version

# Test Python version (molexp requires Python 3.12+)
check "python version is 3.12 or higher" bash -c "python3 --version | grep -E 'Python 3\.(1[2-9]|[2-9][0-9])'"

# Test development tools (inherited from molpy)
check "black is available" black --version
check "isort is available" isort --version

# Test Node.js (from node feature)
check "node is available" node --version
check "npm is available" npm --version

# Report result
reportResults
