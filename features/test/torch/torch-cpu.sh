#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "system uv config written" bash -c '[ -f /etc/uv/uv.toml ]'
check "backend recorded"         bash -c 'grep -q "^torch-backend = \"cpu\"$" /etc/uv/uv.toml'

# uv rejects unknown keys outright, so this also proves the key spelling is
# valid for the installed uv — the check that would have caught a silently
# ignored config.
check "uv accepts the config"    bash -c 'uv cache dir >/dev/null'

check "cmake-prefix helper"      bash -c '[ -x /usr/local/bin/molcrafts-torch-cmake-prefix ]'
check "profile snippet"          bash -c '[ -f /etc/profile.d/50-molcrafts-torch.sh ]'
# It must be a no-op before the first `uv sync`, not an error on every login.
check "profile snippet is quiet without torch" bash -c '. /etc/profile.d/50-molcrafts-torch.sh'

check "isolation left at uv default" bash -c '! grep -q "no-build-isolation" /etc/uv/uv.toml'

# The real contract: any `uv sync` in the container resolves torch against the
# CPU wheel index without the project repeating the flag.
#
# Asserted on the resolution itself, not on an emitted index URL — uv reports
# `--index-url https://pypi.org/simple` either way, so grepping the header
# would pass even with the config silently ignored. The observable difference
# is the pin (`+cpu`) and the absence of the ~2 GB nvidia-* stack.
check "resolves the +cpu wheel" bash -c '
  cd "$(mktemp -d)" &&
  uv venv -p 3.14 -q &&
  echo "torch" | uv pip compile - --python-platform linux --python-version 3.14 -q > resolved.txt 2>/dev/null &&
  grep -qE "^torch==.*\+cpu" resolved.txt'

check "pulls no nvidia-* wheels" bash -c '
  cd "$(mktemp -d)" &&
  uv venv -p 3.14 -q &&
  echo "torch" | uv pip compile - --python-platform linux --python-version 3.14 -q > resolved.txt 2>/dev/null &&
  ! grep -qE "^nvidia-" resolved.txt'

# No torch is baked in — that is the design, and a regression here means the
# image quietly grew by ~2.5 GB.
check "no torch preinstalled" bash -c '! /usr/local/share/uv/bin/python3.14 -c "import torch" 2>/dev/null'

reportResults
