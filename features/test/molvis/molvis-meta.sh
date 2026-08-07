#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

# Pinned to match molvis/.nvmrc.
check "node major is 22" bash -c '[ "$(node -p "process.versions.node.split(\".\")[0]")" = "22" ]'
check "biome"            biome --version
check "corepack"         corepack --version
# molvis/python/ is a real package, not an afterthought.
check "uv"               uv --version
check "ruff"             ruff --version

reportResults
