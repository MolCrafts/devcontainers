# MolRs Rust Development Environment (molrs)

Rust development environment for molecular science projects with WebAssembly support.

## Usage

```json
{
  "features": {
    "ghcr.io/molcrafts/devcontainers/molrs:latest": {}
  }
}
```

## Features

- **Rust toolchain**: Provided by official devcontainers rust feature
- **wasm-pack**: WebAssembly build tool for Rust
- **VS Code extension**: rust-analyzer for Rust language support

## What This Feature Does

This feature:
- Depends on the official Rust devcontainer feature for Rust toolchain
- Installs wasm-pack for compiling Rust to WebAssembly
- Configures rust-analyzer VS Code extension

## Dependencies

- `ghcr.io/devcontainers/features/rust:1` - Official Rust feature (provides rustc, cargo, rustup)

## WebAssembly Support

The feature includes wasm-pack, enabling you to:
- Compile Rust code to WebAssembly
- Generate JavaScript bindings automatically
- Build npm packages from Rust projects
- Target web browsers with high-performance Rust code

### Example: Building for WebAssembly

```bash
# Create a new wasm project
cargo new --lib my-wasm-project
cd my-wasm-project

# Build with wasm-pack
wasm-pack build --target web

# Output in pkg/ directory ready for web use
```

## Development Workflow

1. **Write Rust code**: Use cargo for building and testing
2. **IDE support**: rust-analyzer provides code completion, diagnostics
3. **Build WASM**: Use wasm-pack for WebAssembly compilation
4. **Test**: Run `cargo test` for unit tests

## Use Cases

- High-performance molecular calculations in web browsers
- Molecular structure parsers compiled to WebAssembly
- Scientific computing libraries for web applications
- Rust-based CLI tools for molecular science

## Verification

```bash
rustc --version
cargo --version
wasm-pack --version
```

## Related Features

- **molpy**: Python development environment
- **molvis**: Visualization tools (uses Node.js for web integration)

## License

See [LICENSE](https://github.com/MolCrafts/devcontainers/blob/main/LICENSE)
