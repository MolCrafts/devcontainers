#!/bin/bash

set -e

source dev-container-features-test-lib

check "cargo is available" cargo --version
check "rustc is available" rustc --version
check "rustup is available" rustup --version
check "rust version check" bash -c "rustc --version | grep -E 'rustc [0-9]+\\.[0-9]+'"
check "cargo help works" cargo help
check "wasm-pack is available" wasm-pack --version
check "cargo new works" bash -c "cd /tmp && cargo new test_project --quiet && rm -rf test_project"

reportResults
