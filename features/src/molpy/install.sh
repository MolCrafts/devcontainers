#!/usr/bin/env bash
#
# molpy is a meta-feature: all of its content is the `dependsOn` graph in
# devcontainer-feature.json. Nothing to install here.
#
set -Eeuo pipefail

echo "[molpy] meta-feature — provided by: molcrafts/devcontainers/python"
echo "[molpy] next: uv sync --extra dev && prek install"
