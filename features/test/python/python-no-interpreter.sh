#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

# pythonVersion=none / tools=none is the "I only want uv" path, used when the
# base image already carries the interpreter. Both opt-outs must actually
# opt out — a leaking default would quietly add ~60 MB and a second CPython.
check "uv on PATH"        uv --version
check "ruff absent"       bash -c "! command -v ruff"
check "ty absent"         bash -c "! command -v ty"
check "prek absent"       bash -c "! command -v prek"
check "no interpreter downloaded" bash -c "[ -z \"\$(ls -A /usr/local/share/uv/python 2>/dev/null)\" ]"
check "no tool installed"         bash -c "[ -z \"\$(ls -A /usr/local/share/uv/tools 2>/dev/null)\" ]"

reportResults
