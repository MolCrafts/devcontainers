#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "uv on PATH"        uv --version
check "ruff on PATH"      ruff --version
check "ty on PATH"        ty --version
check "prek on PATH"      prek --version

check "uv-managed CPython 3.14 present" bash -c "uv python list --only-installed | grep -q '3\.14'"
check "python3.14 symlinked"            bash -c "command -v python3.14"

check "shared tool dir is exported"     bash -c '[ "${UV_TOOL_DIR}" = "/usr/local/share/uv/tools" ]'
check "tool bin dir is on PATH"         bash -c 'echo "${PATH}" | tr ":" "\n" | grep -qx "/usr/local/share/uv/bin"'

# The whole point of UV_LINK_MODE=copy: uv hardlinks across the overlayfs
# boundary otherwise and warns on every single install.
check "link mode is copy"               bash -c '[ "${UV_LINK_MODE}" = "copy" ]'

# A real project flow, not just --version smoke: uv must be able to build a
# venv from the shared interpreter dir as the remote (non-root) user.
check "uv venv from shared interpreter" bash -c 'cd "$(mktemp -d)" && uv venv --python 3.14 && ./.venv/bin/python -c "import sys; print(sys.version)"'

# The remote user must be able to add tools without sudo — otherwise every
# postCreateCommand that wants one more tool needs a password prompt.
check "tool dir writable by remote user" bash -c '[ -w /usr/local/share/uv/tools ] && [ -w /usr/local/share/uv/bin ]'

reportResults
