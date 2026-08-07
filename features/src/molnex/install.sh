#!/usr/bin/env bash
#
# molnex is a meta-feature: all of its content is the `dependsOn` graph in
# devcontainer-feature.json. Nothing to install here.
#
# GPU access is a devcontainer.json concern, not a feature concern — add
# `"hostRequirements": {"gpu": "optional"}` and the nvidia-cuda feature there
# when you need nvcc.
#
set -Eeuo pipefail

echo "[molnex] meta-feature — provided by: molcrafts/devcontainers/{python,native,torch}"
echo "[molnex] next: uv sync --extra dev   (builds src/molix/op against the resolved torch)"
