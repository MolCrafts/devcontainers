#!/usr/bin/env bash
#
# molrs is a meta-feature: all of its content is the `dependsOn` graph in
# devcontainer-feature.json. Nothing to install here.
#
# Note for whoever edits this: do NOT add `cargo install wasm-pack`. The rust
# feature fetches it as a prebuilt binary via cargo-binstall, matching molrs'
# own CI rule ("never `cargo install wasm-pack`" — cold compile ~1-2 min).
#
set -Eeuo pipefail

echo "[molrs] meta-feature — provided by: molcrafts/devcontainers/{rust,native,python}"
echo "[molrs] next: cargo build && wasm-pack build --target bundler --scope molcrafts"
