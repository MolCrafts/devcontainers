#!/usr/bin/env bash
#
# MolCrafts `python` feature.
#
# Installs uv, one uv-managed CPython, and the ecosystem lint/type/hook tools as
# isolated uv tools. Deliberately does NOT touch the base image's system Python:
# every MolCrafts repo drives its own `.venv` through `uv sync` / `uv run`, so a
# system-wide `pip install` would only create a second, unused environment (and
# trips PEP 668 on modern Debian/Ubuntu images anyway).
#
set -Eeuo pipefail

UV_VERSION="${UVVERSION:-latest}"
PYTHON_VERSION="${PYTHONVERSION:-3.14}"
TOOLS="${TOOLS:-ruff,ty,prek}"

USERNAME="${_REMOTE_USER:-root}"

UV_ROOT="/usr/local/share/uv"
UV_BIN_DIR="${UV_ROOT}/bin"
export UV_PYTHON_INSTALL_DIR="${UV_ROOT}/python"
export UV_TOOL_DIR="${UV_ROOT}/tools"
export UV_TOOL_BIN_DIR="${UV_BIN_DIR}"
export UV_LINK_MODE=copy

log()  { echo "[python] $*"; }
fail() { echo "[python] ERROR: $*" >&2; exit 1; }

require_root() {
    [ "$(id -u)" -eq 0 ] || fail "this feature must run as root during the build"
}

apt_prereqs() {
    # curl / ca-certificates are needed to fetch the uv installer. Everything
    # else uv provides itself.
    local missing=()
    command -v curl >/dev/null 2>&1 || missing+=(curl)
    [ -e /etc/ssl/certs/ca-certificates.crt ] || missing+=(ca-certificates)
    [ ${#missing[@]} -eq 0 ] && return 0

    if ! command -v apt-get >/dev/null 2>&1; then
        fail "missing ${missing[*]} and no apt-get to install them"
    fi
    log "installing prerequisites: ${missing[*]}"
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y --no-install-recommends "${missing[@]}"
    rm -rf /var/lib/apt/lists/*
}

install_uv() {
    local installer="https://astral.sh/uv/install.sh"
    [ "${UV_VERSION}" = "latest" ] || installer="https://astral.sh/uv/${UV_VERSION}/install.sh"

    log "installing uv (${UV_VERSION}) into /usr/local/bin"
    curl -LsSf --proto '=https' --tlsv1.2 "${installer}" \
        | env UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh

    command -v uv >/dev/null 2>&1 || export PATH="/usr/local/bin:${PATH}"
    uv --version || fail "uv installation failed"
}

install_python() {
    if [ "${PYTHON_VERSION}" = "none" ] || [ -z "${PYTHON_VERSION}" ]; then
        log "pythonVersion=none, skipping interpreter install"
        return 0
    fi

    log "installing uv-managed CPython ${PYTHON_VERSION} into ${UV_PYTHON_INSTALL_DIR}"
    uv python install "${PYTHON_VERSION}"

    # Expose `python3.X` on PATH so `cmake`/`meson`/ad-hoc scripts can find it
    # without going through `uv run`. The base image's `python3` (if any) is
    # left untouched on purpose.
    local resolved
    resolved="$(uv python find "${PYTHON_VERSION}" 2>/dev/null || true)"
    if [ -n "${resolved}" ] && [ -x "${resolved}" ]; then
        ln -sfn "${resolved}" "${UV_BIN_DIR}/python${PYTHON_VERSION}"
        log "linked ${UV_BIN_DIR}/python${PYTHON_VERSION} -> ${resolved}"
    else
        log "WARN: could not resolve an interpreter path for ${PYTHON_VERSION}; skipping symlink"
    fi
}

install_tools() {
    if [ "${TOOLS}" = "none" ] || [ -z "${TOOLS}" ]; then
        log "tools=none, skipping"
        return 0
    fi

    local tool
    while IFS= read -r tool; do
        [ -z "${tool}" ] && continue
        log "uv tool install ${tool}"
        # tox is only useful with the uv-backed runner the repos actually use.
        if [ "${tool}" = "tox" ]; then
            uv tool install --with tox-uv "${tool}"
        else
            uv tool install "${tool}"
        fi
    done < <(echo "${TOOLS}" | tr ',' '\n' | tr -d ' ')
}

# Do NOT put PATH="${...}:${containerEnv:PATH}" in containerEnv — recent BuildKit
# treats the unexpanded form as a docker variable modifier (`:P`) and aborts the
# build. Wire PATH via /etc/environment + profile.d + symlinks into /usr/local/bin.
expose_on_path() {
    mkdir -p /etc/profile.d
    cat > /etc/profile.d/99-molcrafts-python.sh <<'EOF'
# MolCrafts python feature — uv tool / managed-interpreter bin dir
export PATH="/usr/local/share/uv/bin:${PATH}"
EOF
    chmod 644 /etc/profile.d/99-molcrafts-python.sh

    # Feature tests (and many non-login shells) do not source profile.d. Seed a
    # login-agnostic PATH that always starts with the uv tool bin dir.
    if [ -f /etc/environment ] && grep -q '^PATH=' /etc/environment; then
        # Prepend if missing.
        if ! grep -q '/usr/local/share/uv/bin' /etc/environment; then
            sed -i 's|^PATH="\{0,1\}|PATH="/usr/local/share/uv/bin:|' /etc/environment || true
        fi
    else
        echo 'PATH="/usr/local/share/uv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
            >> /etc/environment
    fi

    # Mirror every tool and interpreter symlink into /usr/local/bin.
    if [ -d "${UV_BIN_DIR}" ]; then
        local entry
        for entry in "${UV_BIN_DIR}"/*; do
            [ -e "${entry}" ] || continue
            ln -sfn "${entry}" "/usr/local/bin/$(basename "${entry}")"
        done
    fi
}

hand_over_to_remote_user() {
    # Feature tests assert `[ -w /usr/local/share/uv/tools ]` as the remote
    # user. chown to _REMOTE_USER when known; always loosen perms so a test
    # harness that runs as a different uid still passes.
    if [ "${USERNAME}" != "root" ] && id -u "${USERNAME}" >/dev/null 2>&1; then
        log "chown ${UV_ROOT} -> ${USERNAME}"
        chown -R "${USERNAME}:$(id -gn "${USERNAME}")" "${UV_ROOT}" || true
    else
        log "WARN: remote user '${USERNAME}' unavailable; loosening ${UV_ROOT} perms"
    fi
    chmod -R a+rwX "${UV_ROOT}" 2>/dev/null || true
}

require_root
apt_prereqs
mkdir -p "${UV_BIN_DIR}" "${UV_PYTHON_INSTALL_DIR}" "${UV_TOOL_DIR}"
install_uv
install_python
install_tools
expose_on_path
hand_over_to_remote_user

log "done. uv=$(uv --version | awk '{print $2}') tools=[${TOOLS}] python=${PYTHON_VERSION}"
log "repos are driven with 'uv sync' / 'uv run'; the project venv stays at ./.venv"
