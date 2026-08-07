#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

# The version the devcontainer.json asked for must be the one that runs — this
# is the failure mode `dependsOn` on the node feature would have introduced.
check "node major is 22" bash -c '[ "$(node -p "process.versions.node.split(\".\")[0]")" = "22" ]'
check "npm on PATH"      npm --version
check "biome on PATH"    biome --version
check "corepack enabled" bash -c "command -v corepack && corepack --version"

# molvis/molplot pin npm in package.json "packageManager"; corepack is what
# honours that pin.
check "corepack honours packageManager" bash -c '
  d=$(mktemp -d) && cd "$d" &&
  printf "{\"name\":\"probe\",\"version\":\"1.0.0\",\"packageManager\":\"npm@11.16.0\"}" > package.json &&
  npm --version'

reportResults
