#!/usr/bin/env bash
#
# MolCrafts `native` feature.
#
# CMake comes from Kitware's official binary tarball rather than apt: Ubuntu
# 24.04 ships CMake 3.28, and molnex declares `cmake>=4` in
# build-system.requires, so the distro package cannot build it. The tarball is
# distro-independent and needs no third-party apt repo.
#
set -Eeuo pipefail

CMAKE_VERSION="${CMAKEVERSION:-latest}"
INSTALL_CLANG_TOOLS="${INSTALLCLANGTOOLS:-true}"
INSTALL_DOXYGEN="${INSTALLDOXYGEN:-true}"
INSTALL_CCACHE="${INSTALLCCACHE:-true}"

CMAKE_PREFIX="/usr/local/share/cmake-molcrafts"

log()  { echo "[native] $*"; }
fail() { echo "[native] ERROR: $*" >&2; exit 1; }

apt_install() {
    export DEBIAN_FRONTEND=noninteractive
    log "apt-get install: $*"
    apt-get install -y --no-install-recommends "$@"
}

install_apt_packages() {
    command -v apt-get >/dev/null 2>&1 || fail "this feature targets Debian/Ubuntu bases (apt-get not found)"

    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y

    local pkgs=(build-essential ninja-build pkg-config ca-certificates curl tar)
    [ "${INSTALL_CLANG_TOOLS}" = "true" ] && pkgs+=(clang clangd clang-format clang-tidy lld)
    [ "${INSTALL_DOXYGEN}" = "true" ]     && pkgs+=(doxygen graphviz)
    [ "${INSTALL_CCACHE}" = "true" ]      && pkgs+=(ccache)

    apt_install "${pkgs[@]}"
    rm -rf /var/lib/apt/lists/*
}

resolve_cmake_version() {
    if [ "${CMAKE_VERSION}" != "latest" ]; then
        echo "${CMAKE_VERSION}"
        return 0
    fi
    # Follow the /releases/latest redirect instead of hitting api.github.com —
    # the API is rate-limited per-IP and feature builds carry no token.
    local url tag
    url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
        --retry 3 --retry-delay 2 \
        https://github.com/Kitware/CMake/releases/latest)"
    tag="${url##*/tag/}"
    tag="${tag#v}"
    [ -n "${tag}" ] && [ "${tag}" != "${url}" ] || fail "could not resolve the latest CMake release from ${url}"
    echo "${tag}"
}

install_cmake() {
    local version arch asset_arch tarball
    version="$(resolve_cmake_version)"

    arch="$(uname -m)"
    case "${arch}" in
        x86_64|amd64)   asset_arch="x86_64" ;;
        aarch64|arm64)  asset_arch="aarch64" ;;
        *) fail "unsupported architecture for the CMake tarball: ${arch}" ;;
    esac

    tarball="cmake-${version}-linux-${asset_arch}.tar.gz"
    log "installing CMake ${version} (${asset_arch}) into ${CMAKE_PREFIX}"

    rm -rf "${CMAKE_PREFIX}"
    mkdir -p "${CMAKE_PREFIX}"
    curl -fsSL --retry 3 --retry-delay 2 \
        "https://github.com/Kitware/CMake/releases/download/v${version}/${tarball}" \
        | tar -xz --strip-components=1 -C "${CMAKE_PREFIX}"

    # Symlink rather than prepend to PATH: containerEnv PATH edits stack up
    # badly when several features do it, and /usr/local/bin is already first.
    local bin
    for bin in cmake ctest cpack; do
        [ -x "${CMAKE_PREFIX}/bin/${bin}" ] && ln -sfn "${CMAKE_PREFIX}/bin/${bin}" "/usr/local/bin/${bin}"
    done

    cmake --version | head -1
}

[ "$(id -u)" -eq 0 ] || fail "this feature must run as root during the build"

install_apt_packages
install_cmake

log "done. cmake=$(cmake --version | head -1 | awk '{print $3}') ninja=$(ninja --version)"
