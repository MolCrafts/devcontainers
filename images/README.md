# MolCrafts prebuilt images

Every toolchain feature, preinstalled. Use these when you want one image for the whole ecosystem instead of composing features per repo.

| Image | Platforms | Adds over the other |
|---|---|---|
| `ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu` | `linux/amd64`, `linux/arm64` | — |
| `ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda` | `linux/amd64` | `nvidia-cuda` (nvcc, cuDNN, NVTX) |

```jsonc
{ "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:1" }
```

```jsonc
{
  "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cuda:1",
  "hostRequirements": { "gpu": "optional" }
}
```

Tags: `latest`, the [`VERSION`](VERSION) file, and the commit SHA.

## What is in them

`mcr.microsoft.com/devcontainers/base:ubuntu-24.04` plus:

- `common-utils` (zsh as default shell), `git`, `github-cli`
- `node:1` at major **22**
- `python` — uv, CPython 3.14, ruff, ty, prek
- `rust` — rustfmt, clippy, rust-src, wasm32-unknown-unknown, wasm-pack, maturin
- `node` — corepack, biome
- `native` — CMake ≥ 4, Ninja, clang tooling, ccache, Doxygen
- `torch` — uv `torch-backend` resolution (`cpu` in the CPU image, `auto` in the CUDA image)

## PyTorch is not preinstalled

This is deliberate, and it is the biggest change from the old images.

The previous images were built on `nvcr.io/nvidia/pytorch`, which cost ~10 GB before a single MolCrafts tool was installed and pinned Python to whatever NGC shipped — behind the 3.14 the ecosystem targets. Worse, a torch in the base image is a *different* environment from the project's `.venv`, and molnex links against torch at build time via `find_package(Torch)`. Two torches on one machine is an ABI mismatch waiting to happen.

Instead, resolution is preconfigured and the project's own lockfile owns the version:

```bash
uv sync --extra dev     # pulls the right wheel variant, no flags needed
```

The images mount a named volume at `~/.cache/uv`, so that download happens once and survives rebuilds. Same for the cargo registry and the npm cache.

## GPU access

`molcrafts-cuda` declares `"hostRequirements": {"gpu": "optional"}` rather than hardcoding `runArgs: ["--gpus", "all"]`. The CLI passes the GPU through when the host has one and still opens the container when it does not — the old config made the image unopenable on any machine without the NVIDIA runtime.

Verify inside the container:

```bash
nvidia-smi
nvcc --version
uv run python -c "import torch; print(torch.cuda.is_available())"   # after uv sync
```

## Building locally

```bash
devcontainer build --workspace-folder images/molcrafts-cpu --image-name molcrafts-cpu:local
```

This pulls the MolCrafts features from ghcr, so local edits under `features/src/` are **not** picked up. To test a feature change, use `devcontainer features test ./features -f <id>` instead.

## Releasing

`.github/workflows/release.yml` on a push to `master`: publish features → verify meta-features against the fresh publish → build and push both images. Bump [`VERSION`](VERSION) to cut a new tag.
