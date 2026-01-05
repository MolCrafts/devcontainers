# molvis (devcontainer feature)

Node.js + Python 可视化开发环境（依赖 molpy 提供 Python）。

## 使用
```json
{ "features": { "ghcr.io/molcrafts/devcontainers/molvis:latest": {} } }
```

## 包含内容
- Node.js + npm（来自依赖的 node feature）
- Python 环境与工具（来自 molpy）
- Biome 代码格式化
- VS Code 扩展：biomejs.biome

## 验证
```bash
node --version
npm --version
python3 --version
biome --version || true
```

## 依赖
- `ghcr.io/molcrafts/devcontainers/molpy:latest`
- `ghcr.io/devcontainers/features/node:1`
