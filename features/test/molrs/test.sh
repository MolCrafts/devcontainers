#!/bin/bash

# Test file for molrs feature

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Basic Rust toolchain tests
check "cargo is available" cargo --version
check "rustc is available" rustc --version
check "rustup is available" rustup --version

# Test Rust version
check "rust version check" bash -c "rustc --version | grep -E 'rustc [0-9]+\.[0-9]+'"

# Test cargo functionality
check "cargo help works" cargo help

# Test wasm-pack installation
check "wasm-pack is available" wasm-pack --version

# Test that we can create a simple Rust project
check "cargo new works" bash -c "cd /tmp && cargo new test_project --quiet && rm -rf test_project"

# Report result
reportResults