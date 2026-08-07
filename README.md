# MolCrafts DevContainers

Dev Container [Features](https://containers.dev/implementors/features/) and prebuilt images for the MolCrafts ecosystem.

Features are split by **toolchain**, not by repository. `molpy`, `molcfg`, `mollog`, `molq`, `molmcp`, `molhub` and `molrec` all need the same Python setup; splitting by repo meant maintaining five copies of it. Repository names survive as thin **meta-features** that do nothing but compose the toolchain ones.

```
                      toolchain features                  meta-features
  ┌──────────────────────────────────────────┐    ┌────────────────────────────┐
  │ python   uv · CPython 3.14 · ruff · ty   │◄───┤ molpy    python            │
  │          · prek                          │◄───┤ molrs    rust+native+python│
  │ rust     rustfmt · clippy · wasm32       │◄───┤ molvis   node+python       │
  │          · wasm-pack · maturin           │◄───┤ molexp   node+python       │
  │ node     corepack · biome                │◄───┤ molnex   python+native     │
  │ native   cmake≥4 · ninja · clang · ccache│    │          +torch            │
  │ torch    uv torch-backend · CMake prefix │    └────────────────────────────┘
  └──────────────────────────────────────────┘
```

## Quick start

**Workspace layout:** the multi-repo checkout at `molcrafts/` owns [`.devcontainer/`](../.devcontainer/README.md) by **development type**. Open the workspace root and pick a config — not per-project folders.

| Type | Ships with | Projects |
|---|---|---|
| `python` | python **+ rust** | molpy, molcfg, mollog, molq, molmcp, molhub, molrec, … |
| `rust` | `…/molrs:1` (rust + native + python) | molrs, molpack, molqrc, Atomiverse |
| `web` | node + biome + **wrangler** + **python** | molvis, molplot, molexp, molcrafts-edge, … |
| `torch-cpu` / `torch-cuda` | molnex toolchain (± CUDA) | molnex |
| `atv-cpu` / `atv-cuda` | prebuilt kitchen-sink images | Atomiverse / full ecosystem |

This features repo keeps its own [`.devcontainer/`](.devcontainer/devcontainer.json) for authoring (DiD + shellcheck).

```jsonc
{
  "name": "python",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/molcrafts/devcontainers/python:1": {},
    "ghcr.io/molcrafts/devcontainers/rust:1": {}
  }
}
```

Or a prebuilt image:

```jsonc
{ "image": "ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu:1" }
```

## Toolchain features

All refs are `ghcr.io/molcrafts/devcontainers/<id>:1`.

### `python`

uv, one uv-managed CPython, and the lint/type/hook tools as isolated uv tools.

| Option | Default | |
|---|---|---|
| `uvVersion` | `latest` | uv release |
| `pythonVersion` | `3.14` | uv-managed CPython; `none` to skip |
| `tools` | `ruff,ty,prek` | comma-separated; `none` to skip |

It does **not** touch the base image's system Python. Every MolCrafts repo drives its own `.venv` through `uv sync` / `uv run`, so a system-wide `pip install` would just create a second, unused environment — and trips PEP 668 on modern Debian/Ubuntu images. Interpreters and tools live in `/usr/local/share/uv`, owned by the remote user so `uv tool install` needs no sudo.

### `rust`

`dependsOn` the official rust feature and adds what the crates actually need.

| Option | Default |
|---|---|
| `components` | `rustfmt,clippy,rust-src` |
| `targets` | `wasm32-unknown-unknown` |
| `tools` | `wasm-pack,maturin` |

Tools come from **cargo-binstall as prebuilt binaries**. `cargo install wasm-pack` is a 1–2 minute cold compile and is banned in molrs' own CI for exactly that reason.

### `node`

| Option | Default |
|---|---|
| `enableCorepack` | `true` |
| `globalPackages` | `@biomejs/biome` |

This feature does **not** `dependsOn` the official node feature — declare that yourself with the major your repo needs:

```jsonc
"ghcr.io/devcontainers/features/node:1": { "version": "22" },
"ghcr.io/molcrafts/devcontainers/node:1": {}
```

MolCrafts repos pin different majors (molvis `.nvmrc` says 22, molcrafts-index CI uses 24). A `dependsOn` edge would inject a *second* node feature instance whenever a repo declares its own version, leaving nvm with two versions and a non-obvious default. One explicit instance is worth the extra line.

### `native`

| Option | Default |
|---|---|
| `cmakeVersion` | `latest` |
| `installClangTools` | `true` |
| `installDoxygen` | `true` |
| `installCcache` | `true` |

CMake comes from Kitware's official tarball, not apt: Ubuntu 24.04 ships 3.28 and molnex declares `cmake>=4` in `build-system.requires`. Sets `CMAKE_GENERATOR=Ninja` and `CMAKE_EXPORT_COMPILE_COMMANDS=ON` so clangd works without per-repo configuration.

### `torch`

| Option | Default |
|---|---|
| `backend` | `auto` — one of `auto`/`cpu`/`cu126`/`cu128`/`cu129`/`cu130` |
| `buildIsolation` | `true` |

**This feature installs no torch.** It writes `/etc/uv/uv.toml` so every `uv sync` in the container resolves torch against the right wheel index, and installs `molcrafts-torch-cmake-prefix` plus a `/etc/profile.d` snippet that exports the `CMAKE_PREFIX_PATH` molnex's `find_package(Torch)` needs.

Baking torch into the image would put it in a *different* environment from the project's `.venv` while molnex links against torch at build time — two torches on one machine is an ABI mismatch waiting to happen. The project's lockfile owns the version; the prebuilt images mount a named volume for uv's cache so the download survives rebuilds.

Set `buildIsolation: false` for molnex: it names torch in `build-system.requires`, and with isolation on uv downloads a second full torch just to run the build backend.

## Prebuilt images

`ghcr.io/molcrafts/devcontainers/images/molcrafts-cpu` · `…/molcrafts-cuda`

- **cpu** — `mcr.microsoft.com/devcontainers/base:ubuntu-24.04` + every toolchain feature  
- **cuda** — official `nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04` + the same toolchains (no `devcontainers/features/nvidia-cuda` package install). Declares `hostRequirements.gpu: "optional"` so it still opens without a GPU host.

`molcrafts-cpu` is published for `linux/amd64` and `linux/arm64`; `molcrafts-cuda` for `linux/amd64` only.

See [images/README.md](images/README.md).

## Layout

```
features/src/<id>/          devcontainer-feature.json + install.sh   (flat — the
                            publisher derives the OCI tag from the directory name,
                            so meta-features cannot live in a meta/ subdirectory)
features/test/<id>/         scenarios.json + one <scenario-name>.sh per scenario
images/<name>/.devcontainer/devcontainer.json
.github/workflows/ci.yml    lint + schema validation + toolchain feature tests
.github/workflows/release.yml  publish features → verify meta-features → push images
```

Per-feature `README.md` files are generated by `devcontainers/action` at publish time — don't hand-write them, they get overwritten.

## Development

```bash
devcontainer features test ./features -f python --skip-autogenerated   # one feature
shellcheck --severity=warning --shell=bash features/src/*/install.sh   # what CI gates on
devcontainer build --workspace-folder images/molcrafts-cpu --image-name molcrafts-cpu:local
```

Meta-features resolve their `dependsOn` graph from ghcr, so they can only be tested against **published** versions — `release.yml` runs their tests immediately after the publish step, which is the earliest point the test means anything.

## Registry paths

One namespace, derived from the repo: `ghcr.io/molcrafts/devcontainers/…`.

Anything referencing `ghcr.io/molcrafts/features/…` is broken — that path was never published to.

## Breaking changes in 1.0.0

- Features are versioned `1.0.0`. `molpy`/`molrs`/`molvis`/`molexp`/`molnex` still exist but are now composition-only.
- New: `python`, `rust`, `node`, `native`, `torch`.
- `molnex`'s `backend` option is gone; the `torch` feature's `backend` replaces it. The old `molvis` feature never had `computeBackend`/`cudaVersion` options despite being called with them.
- The images no longer derive from `nvcr.io/nvidia/pytorch` and no longer ship PyTorch. Run `uv sync` in the project; resolution is preconfigured.
- Image configs moved from `images/<name>/.devcontainer.json` to `images/<name>/.devcontainer/devcontainer.json`.

## License

[BSD-3-Clause](LICENSE).
