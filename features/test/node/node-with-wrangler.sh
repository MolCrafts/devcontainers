#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "node major is 24" bash -c '[ "$(node -p "process.versions.node.split(\".\")[0]")" = "24" ]'
check "biome on PATH"    biome --version
# molcrafts-edge deploys its Workers router with wrangler.
check "wrangler on PATH" wrangler --version

reportResults
