#!/usr/bin/env bash
set -e
source dev-container-features-test-lib

check "cargo"       cargo --version
check "clippy"      cargo clippy --version
check "wasm32"      bash -c "rustup target list --installed | grep -qx wasm32-unknown-unknown"
check "wasm-pack"   wasm-pack --version
check "maturin"     maturin --version
# molrs-cxxapi bridges through cxx, which needs a C++ compiler and cmake.
check "c++ compiler" c++ --version
check "cmake"        cmake --version
# maturin builds molrs-python against a uv-managed interpreter.
check "uv"           uv --version
# Doxygen is opted out for molrs — only Atomiverse needs it.
check "no doxygen"   bash -c "! command -v doxygen"

reportResults
