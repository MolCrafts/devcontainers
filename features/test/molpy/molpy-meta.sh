#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

# The meta-feature's only job is that the composed graph resolves. If the
# dependsOn edge breaks, these are the first things to disappear.
check "uv"   uv --version
check "ruff" ruff --version
check "ty"   ty --version
check "prek" prek --version
check "CPython 3.14" bash -c "uv python list --only-installed | grep -q '3\.14'"

reportResults
