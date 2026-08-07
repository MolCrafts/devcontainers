// Parse every devcontainer.json in the repo the way the devcontainer CLI does.
//
// These files are JSONC — comments and trailing commas are legal — so `jq`
// cannot read them, and stripping comments with a regex mangles any `//`
// inside a string (every "ghcr.io/..." reference, for one).
//
// Usage: node validate-devcontainer-json.mjs <file>...
import { readFileSync } from 'node:fs';
import { parse, printParseErrorCode } from 'jsonc-parser';

const files = process.argv.slice(2);
if (files.length === 0) {
  console.error('no files given — the caller\'s glob matched nothing');
  process.exit(1);
}

let failed = false;

for (const file of files) {
  const errors = [];
  let value;
  try {
    value = parse(readFileSync(file, 'utf8'), errors, { allowTrailingComma: true });
  } catch (err) {
    failed = true;
    console.log(`::error file=${file}::could not read: ${err.message}`);
    continue;
  }

  if (errors.length > 0) {
    failed = true;
    for (const e of errors) {
      console.log(`::error file=${file}::${printParseErrorCode(e.error)} at offset ${e.offset}`);
    }
    continue;
  }

  if (value === undefined || value === null || typeof value !== 'object' || Array.isArray(value)) {
    failed = true;
    console.log(`::error file=${file}::did not parse to a JSON object`);
    continue;
  }

  // An image config with neither `image` nor `build` nor `dockerComposeFile`
  // parses fine and then fails at build time with a far less obvious message.
  if (!('image' in value) && !('build' in value) && !('dockerComposeFile' in value)) {
    failed = true;
    console.log(`::error file=${file}::no image / build / dockerComposeFile`);
    continue;
  }

  console.log(`ok  ${file}`);
}

process.exit(failed ? 1 : 0);
