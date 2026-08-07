#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "uv on PATH"                 uv --version
check "ruff on PATH"               ruff --version
check "pinned interpreter is 3.12" bash -c "uv python list --only-installed | grep -q '3\.12'"
check "python3.12 symlinked"       bash -c "command -v python3.12"

# tools=ruff must mean ONLY ruff — a leaking default would silently re-add ty
# and prek and make the option meaningless.
check "ty was not installed"       bash -c "! uv tool list | grep -q '^ty '"
check "prek was not installed"     bash -c "! uv tool list | grep -q '^prek '"

reportResults
