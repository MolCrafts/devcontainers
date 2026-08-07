#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "cargo on PATH"   cargo --version
check "rustfmt"         cargo fmt --version
check "clippy"          cargo clippy --version
check "rust-src"        bash -c "rustup component list --installed | grep -q rust-src"

# molrs builds wasm through wasm-pack; molpack/molrs-python through maturin.
check "wasm32 target"   bash -c "rustup target list --installed | grep -qx wasm32-unknown-unknown"
check "wasm-pack"       wasm-pack --version
check "maturin"         maturin --version
check "cargo-binstall"  cargo-binstall -V

# molrs' edition-2024 / rust-version 1.91 floor.
check "rustc >= 1.91"   bash -c 'v=$(rustc --version | awk "{print \$2}" | cut -d- -f1); [ "$(printf "%s\n1.91.0\n" "$v" | sort -V | head -1)" = "1.91.0" ]'

# The remote user has to own CARGO_HOME or `cargo build` cannot write the
# registry cache.
check "cargo home writable" bash -c '[ -w "${CARGO_HOME:-/usr/local/cargo}" ]'

# End-to-end: the target must actually link, not just appear in the list.
check "wasm32 build works" bash -c '
  d=$(mktemp -d) && cd "$d" &&
  cargo init --lib --name wasmprobe -q &&
  cargo build --target wasm32-unknown-unknown -q &&
  [ -f target/wasm32-unknown-unknown/debug/libwasmprobe.rlib ]'

reportResults
