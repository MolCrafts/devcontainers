// Detect the one failure mode that composing features makes easy to hit:
// the SAME feature reaching the resolver TWICE with DIFFERENT options.
//
// Features are deduplicated by id *and* options. Two entries that disagree are
// two installs, not one — nvm ends up holding two Node versions with a
// non-obvious default, and two `torch` instances both write /etc/uv/uv.toml
// with the last writer winning by install order. Nothing errors; you just get
// the wrong container.
//
// This walks each devcontainer.json, expands the dependsOn graph of the local
// MolCrafts features, fills in their declared defaults, and fails on any
// conflict.
//
// Usage: node check-feature-graph.mjs <devcontainer.json>...
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { parse } from 'jsonc-parser';

const FEATURES_DIR = resolve('features/src');
const NAMESPACE = 'ghcr.io/molcrafts/devcontainers/';

/** id -> { options: {name: {default}}, dependsOn: {ref: options} } */
const local = new Map();
for (const id of readdirSync(FEATURES_DIR)) {
  const manifest = join(FEATURES_DIR, id, 'devcontainer-feature.json');
  if (!existsSync(manifest)) continue;
  local.set(id, JSON.parse(readFileSync(manifest, 'utf8')));
}

/** Strip the version tag: `.../python:1` and `.../python:2` are one feature. */
const refId = (ref) => ref.replace(/:[^:/]*$/, '');

/** Fill declared defaults so `{}` and `{explicit: default}` compare equal. */
function normalize(ref, options) {
  const id = refId(ref);
  const merged = { ...(options ?? {}) };
  if (id.startsWith(NAMESPACE)) {
    const manifest = local.get(id.slice(NAMESPACE.length));
    for (const [name, spec] of Object.entries(manifest?.options ?? {})) {
      if (!(name in merged) && 'default' in spec) merged[name] = spec.default;
    }
  }
  // External features' defaults are unknown, so they are compared on what is
  // written down. That under-reports rather than over-reports.
  return JSON.stringify(Object.fromEntries(Object.entries(merged).sort()));
}

/** Expand dependsOn, recording who asked for what. */
function collect(ref, options, out, via) {
  const id = refId(ref);
  (out.get(id) ?? out.set(id, []).get(id)).push({ options: normalize(ref, options), via });

  if (!id.startsWith(NAMESPACE)) return;
  const manifest = local.get(id.slice(NAMESPACE.length));
  for (const [depRef, depOptions] of Object.entries(manifest?.dependsOn ?? {})) {
    collect(depRef, depOptions, out, `${via} → ${id.slice(NAMESPACE.length)}`);
  }
}

let failed = false;

for (const file of process.argv.slice(2)) {
  const config = parse(readFileSync(file, 'utf8'), [], { allowTrailingComma: true });
  const seen = new Map();
  for (const [ref, options] of Object.entries(config?.features ?? {})) {
    collect(ref, options, seen, 'devcontainer.json');
  }

  const conflicts = [];
  for (const [id, entries] of seen) {
    const distinct = new Set(entries.map((e) => e.options));
    if (distinct.size > 1) conflicts.push([id, entries]);
  }

  if (conflicts.length === 0) {
    console.log(`ok  ${file}  (${seen.size} features resolved)`);
    continue;
  }

  failed = true;
  for (const [id, entries] of conflicts) {
    console.log(`::error file=${file}::${id} requested with conflicting options — this installs it twice`);
    for (const e of entries) console.log(`      via ${e.via}: ${e.options}`);
  }
}

process.exit(failed ? 1 : 0);
