#!/usr/bin/env bash
#
# MolCrafts `torch` feature.
#
# This feature installs NO torch. Baking a ~2.5 GB torch into the image would
# put it in a different environment from the project's `.venv`, and molnex
# links against torch at BUILD time (`find_package(Torch)` in
# src/molix/op/CMakeLists.txt) — two torches on one machine is an ABI mismatch
# waiting to happen. Instead it configures resolution so the project's own
# `uv sync` pulls the correct wheel variant, and exposes the CMake prefix of
# whichever torch ends up active.
#
set -Eeuo pipefail

BACKEND="${BACKEND:-auto}"
BUILD_ISOLATION="${BUILDISOLATION:-true}"

UV_CONFIG_DIR="/etc/uv"
UV_CONFIG="${UV_CONFIG_DIR}/uv.toml"
PROFILE_SNIPPET="/etc/profile.d/50-molcrafts-torch.sh"
HELPER="/usr/local/bin/molcrafts-torch-cmake-prefix"

log()  { echo "[torch] $*"; }
fail() { echo "[torch] ERROR: $*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || fail "this feature must run as root during the build"

write_uv_config() {
    mkdir -p "${UV_CONFIG_DIR}"
    if [ -f "${UV_CONFIG}" ]; then
        log "WARN: ${UV_CONFIG} already exists; rewriting it"
    fi

    {
        echo "# Written by the MolCrafts 'torch' devcontainer feature."
        echo "# System-level uv config: a project's own uv.toml / [tool.uv] still wins."
        echo "torch-backend = \"${BACKEND}\""
        if [ "${BUILD_ISOLATION}" != "true" ]; then
            echo ""
            echo "# molnex names torch in build-system.requires; with isolation on, uv"
            echo "# downloads a whole second torch just to run the build backend."
            echo "no-build-isolation-package = [\"molnex\"]"
        fi
    } > "${UV_CONFIG}"

    chmod 0644 "${UV_CONFIG}"
    log "wrote ${UV_CONFIG} (torch-backend=${BACKEND}, buildIsolation=${BUILD_ISOLATION})"
}

write_cmake_prefix_helper() {
    # Mirrors what molnex CI does verbatim:
    #   export CMAKE_PREFIX_PATH="$(python -c 'import torch; print(torch.utils.cmake_prefix_path)')"
    cat > "${HELPER}" <<'EOF'
#!/usr/bin/env sh
# Print the CMake prefix of the torch visible to the active interpreter.
# Usage: export CMAKE_PREFIX_PATH="$(molcrafts-torch-cmake-prefix)"
set -eu
py="${PYTHON:-python3}"
command -v python >/dev/null 2>&1 && py=python
exec "$py" -c 'import torch, sys; sys.stdout.write(torch.utils.cmake_prefix_path)'
EOF
    chmod 0755 "${HELPER}"
    log "installed ${HELPER}"
}

write_profile_snippet() {
    cat > "${PROFILE_SNIPPET}" <<'EOF'
# MolCrafts 'torch' feature: make find_package(Torch) work in interactive
# shells without every developer re-deriving the prefix by hand. Silent and
# free when no torch is importable (i.e. before the first `uv sync`).
if command -v python >/dev/null 2>&1; then
    __molcrafts_torch_prefix="$(python -c 'import torch, sys; sys.stdout.write(torch.utils.cmake_prefix_path)' 2>/dev/null || true)"
    if [ -n "${__molcrafts_torch_prefix}" ]; then
        case ":${CMAKE_PREFIX_PATH-}:" in
            *":${__molcrafts_torch_prefix}:"*) : ;;
            *) CMAKE_PREFIX_PATH="${__molcrafts_torch_prefix}${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}"; export CMAKE_PREFIX_PATH ;;
        esac
    fi
    unset __molcrafts_torch_prefix
fi
EOF
    chmod 0644 "${PROFILE_SNIPPET}"
    log "installed ${PROFILE_SNIPPET}"
}

write_uv_config
write_cmake_prefix_helper
write_profile_snippet

log "done. No torch installed by design — run 'uv sync' in the project."
