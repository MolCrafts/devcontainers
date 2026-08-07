#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "cargo on PATH"      cargo --version
check "rustfmt still there" cargo fmt --version
check "clippy still there"  cargo clippy --version

# targets/tools = none must genuinely skip the expensive parts.
check "no wasm32 target"  bash -c "! rustup target list --installed | grep -qx wasm32-unknown-unknown"
check "no wasm-pack"      bash -c "! command -v wasm-pack"
check "no maturin"        bash -c "! command -v maturin"
# cargo-binstall is installed regardless — it is the mechanism, not a tool.
check "cargo-binstall"    cargo-binstall -V

reportResults
