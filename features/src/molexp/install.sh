#!/usr/bin/env bash
#
# molexp is a meta-feature: all of its content is the `dependsOn` graph in
# devcontainer-feature.json. Nothing to install here.
#
set -Eeuo pipefail

echo "[molexp] meta-feature — provided by: devcontainers/node@22 + molcrafts/devcontainers/{node,python}"
echo "[molexp] next: uv sync --extra dev && npm install"
