#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "node major is 22" bash -c '[ "$(node -p "process.versions.node.split(\".\")[0]")" = "22" ]'
check "biome"            biome --version
check "uv"               uv --version
check "ruff"             ruff --version
check "ty"               ty --version
check "CPython 3.14"     bash -c "uv python list --only-installed | grep -q '3\.14'"

reportResults
