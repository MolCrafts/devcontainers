#!/bin/bash

set -e

source dev-container-features-test-lib

check "python3 is available" python3 --version
check "pip3 is available" pip3 --version
check "uv is available" uv --version
check "ruff is available" ruff --version
check "node is available" node --version
check "npm is available" npm --version

reportResults
