#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "system uv config written" bash -c '[ -f /etc/uv/uv.toml ]'
check "backend is auto"          bash -c 'grep -q "^torch-backend = \"auto\"$" /etc/uv/uv.toml'
check "uv accepts the config"    bash -c 'uv cache dir >/dev/null'

# molnex names torch in build-system.requires; with isolation on, uv downloads
# a second full torch just to run the build backend.
check "molnex build isolation disabled" bash -c 'grep -q "no-build-isolation-package = \[\"molnex\"\]" /etc/uv/uv.toml'

# backend=auto must degrade to the CPU index on a driver-less CI runner rather
# than fail resolution — and must not drag in the nvidia-* stack there either.
# This is the behaviour that lets one image serve GPU hosts and laptops.
check "auto degrades to the +cpu wheel" bash -c '
  cd "$(mktemp -d)" &&
  uv venv -p 3.14 -q &&
  echo "torch" | uv pip compile - --python-platform linux --python-version 3.14 -q > resolved.txt 2>/dev/null &&
  grep -qE "^torch==.*\+cpu" resolved.txt &&
  ! grep -qE "^nvidia-" resolved.txt'

reportResults
