#!/usr/bin/env bash
#
# molvis is a meta-feature: all of its content is the `dependsOn` graph in
# devcontainer-feature.json. Nothing to install here.
#
# The Node major is pinned to 22 to match molvis/.nvmrc. If you need a
# different major, skip this meta-feature and declare the toolchain features
# directly so there is exactly one node feature instance in the graph.
#
set -Eeuo pipefail

echo "[molvis] meta-feature — provided by: devcontainers/node@22 + molcrafts/devcontainers/{node,python}"
echo "[molvis] next: npm install && npm run dev:page"
