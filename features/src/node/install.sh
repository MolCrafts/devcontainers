#!/usr/bin/env bash
#
# MolCrafts `node` feature.
#
# Deliberately does NOT `dependsOn` the official node feature. MolCrafts repos
# pin different Node majors (molvis .nvmrc=22, molcrafts-index CI=24), and a
# dependsOn edge would inject a SECOND node feature instance whenever the repo
# declares its own version — nvm would then hold two versions with a
# non-obvious default. Each devcontainer.json declares
# `ghcr.io/devcontainers/features/node:1` with its own version instead; this
# feature only layers tooling on top and fails loudly if Node is missing.
#
set -Eeuo pipefail

ENABLE_COREPACK="${ENABLECOREPACK:-true}"
GLOBAL_PACKAGES="${GLOBALPACKAGES:-@biomejs/biome}"

log()  { echo "[node] $*"; }
fail() { echo "[node] ERROR: $*" >&2; exit 1; }

split_csv() { echo "$1" | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true; }

require_node() {
    if ! command -v node >/dev/null 2>&1; then
        fail "node not found. Add 'ghcr.io/devcontainers/features/node:1' to \
your devcontainer.json (pin the major your repo needs, e.g. {\"version\": \"22\"}) \
before this feature."
    fi
    log "node $(node --version), npm $(npm --version)"
}

enable_corepack() {
    if [ "${ENABLE_COREPACK}" != "true" ]; then
        log "enableCorepack=false, skipping"
        return 0
    fi
    if ! command -v corepack >/dev/null 2>&1; then
        log "corepack not shipped with this Node build; skipping"
        return 0
    fi
    log "corepack enable"
    corepack enable || log "WARN: corepack enable failed; the repo's packageManager pin will be ignored"
}

install_global_packages() {
    if [ "${GLOBAL_PACKAGES}" = "none" ] || [ -z "${GLOBAL_PACKAGES}" ]; then
        log "globalPackages=none, skipping"
        return 0
    fi
    local pkgs=()
    local p
    while IFS= read -r p; do pkgs+=("${p}"); done < <(split_csv "${GLOBAL_PACKAGES}")
    [ ${#pkgs[@]} -eq 0 ] && return 0

    log "npm install -g ${pkgs[*]}"
    npm install -g --no-fund --no-audit "${pkgs[@]}"
}

require_node
enable_corepack
install_global_packages

log "done. corepack=${ENABLE_COREPACK} global=[${GLOBAL_PACKAGES}]"
