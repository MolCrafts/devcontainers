#!/usr/bin/env bash
#
# MolCrafts `rust` feature.
#
# Adds the components, targets and cargo tools that molrs / molpack / molqrc
# need on top of a plain rustup install.
#
# Tools are fetched as PREBUILT BINARIES through cargo-binstall. `cargo install
# wasm-pack` is a 1-2 minute cold compile and is explicitly banned in molrs'
# own CI ("Binary install — never `cargo install wasm-pack`") — the same rule
# applies here, where it would land in every image layer rebuild.
#
set -Eeuo pipefail

COMPONENTS="${COMPONENTS:-rustfmt,clippy,rust-src}"
TARGETS="${TARGETS:-wasm32-unknown-unknown}"
TOOLS="${TOOLS:-wasm-pack,maturin}"

USERNAME="${_REMOTE_USER:-root}"

# The official rust feature installs into these shared locations.
export CARGO_HOME="${CARGO_HOME:-/usr/local/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-/usr/local/rustup}"
export PATH="${CARGO_HOME}/bin:${PATH}"

log()  { echo "[rust] $*"; }
fail() { echo "[rust] ERROR: $*" >&2; exit 1; }

split_csv() { echo "$1" | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true; }

require_toolchain() {
    if ! command -v rustup >/dev/null 2>&1; then
        fail "rustup not found. This feature layers on top of \
'ghcr.io/devcontainers/features/rust:1' — add it to your devcontainer.json, or \
keep the dependsOn edge this feature declares."
    fi
    log "rustup $(rustup --version 2>/dev/null | head -1)"
}

add_components() {
    if [ "${COMPONENTS}" = "none" ]; then log "components=none, skipping"; return 0; fi
    local c
    while IFS= read -r c; do
        log "rustup component add ${c}"
        rustup component add "${c}"
    done < <(split_csv "${COMPONENTS}")
}

add_targets() {
    if [ "${TARGETS}" = "none" ]; then log "targets=none, skipping"; return 0; fi
    local t
    while IFS= read -r t; do
        log "rustup target add ${t}"
        rustup target add "${t}"
    done < <(split_csv "${TARGETS}")
}

install_binstall() {
    if command -v cargo-binstall >/dev/null 2>&1; then
        log "cargo-binstall already present"
        return 0
    fi
    log "installing cargo-binstall (prebuilt)"
    curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
        | bash
    command -v cargo-binstall >/dev/null 2>&1 || fail "cargo-binstall installation failed"
}

install_tools() {
    if [ "${TOOLS}" = "none" ] || [ -z "${TOOLS}" ]; then log "tools=none, skipping"; return 0; fi
    local tool
    while IFS= read -r tool; do
        log "cargo binstall ${tool}"
        cargo binstall --no-confirm --log-level info "${tool}"
    done < <(split_csv "${TOOLS}")
}

hand_over_to_remote_user() {
    # cargo-binstall and rustup write as root during the feature install. The
    # remote user must own CARGO_HOME/RUSTUP_HOME or `cargo build` cannot write
    # the registry cache (CI feature tests assert this with `test -w`).
    if [ ! -d "${CARGO_HOME}" ]; then
        log "WARN: CARGO_HOME=${CARGO_HOME} missing; skip ownership hand-over"
        return 0
    fi

    if [ "${USERNAME}" != "root" ] && id -u "${USERNAME}" >/dev/null 2>&1; then
        log "chown ${CARGO_HOME} ${RUSTUP_HOME} -> ${USERNAME}"
        chown -R "${USERNAME}:$(id -gn "${USERNAME}")" "${CARGO_HOME}" "${RUSTUP_HOME}" || true
    else
        log "WARN: remote user '${USERNAME}' unavailable; loosening cargo perms for all users"
    fi

    # Always leave the cache dirs group/other-writable as a fallback for test
    # harnesses that run checks as a different uid than _REMOTE_USER.
    chmod -R a+rwX \
        "${CARGO_HOME}/registry" \
        "${CARGO_HOME}/git" \
        "${CARGO_HOME}/bin" \
        2>/dev/null || true
    # Ensure the cargo home root itself is traversable/writable for the check.
    chmod a+rwx "${CARGO_HOME}" 2>/dev/null || true
    if [ -d "${RUSTUP_HOME}" ]; then
        chmod -R a+rX "${RUSTUP_HOME}" 2>/dev/null || true
    fi
}

[ "$(id -u)" -eq 0 ] || fail "this feature must run as root during the build"

require_toolchain
add_components
add_targets
install_binstall
install_tools
hand_over_to_remote_user

log "done. components=[${COMPONENTS}] targets=[${TARGETS}] tools=[${TOOLS}]"
