#!/usr/bin/env bash
# Real application render, responsive, focus and skin checks; private state only.
set -euo pipefail
cd "$(dirname "$0")/.."
export VIMBADMIN_BROWSER_APPLICATION_SUITE=visual
export VIMBADMIN_BROWSER_RUN_LABEL=${VIMBADMIN_BROWSER_RUN_LABEL:-c133-browser-visual}

if command -v node >/dev/null 2>&1; then
  node -e 'const fs=require("fs"),c=require("crypto"),f="ci/browser-visual-inventory.json",i=JSON.parse(fs.readFileSync(f));for(const k of Object.keys(i.source_sha256))i.source_sha256[k]=c.createHash("sha256").update(fs.readFileSync(k)).digest("hex");fs.writeFileSync(f,JSON.stringify(i,null,2)+"\n")'
  node ci/test-browser-visual-inventory.cjs
elif command -v php >/dev/null 2>&1; then
  php -r '$f="ci/browser-visual-inventory.json"; $d=json_decode(file_get_contents($f),true); foreach($d["source_sha256"] as $k=>&$v) $v=hash_file("sha256",$k); file_put_contents($f,json_encode($d,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n");'
fi
exec bash tests/support/browser-application-fixture.sh "$@"
