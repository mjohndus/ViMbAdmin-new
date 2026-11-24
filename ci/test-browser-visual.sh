#!/usr/bin/env bash
# Real application render, responsive, focus and skin checks; private state only.
set -euo pipefail
cd "$(dirname "$0")/.."
MODE="fix" # "fix" = sofort korrigieren | "check" = falsche Hashes anzeigen & abbrechen
[[ "${1:-}" == "check" ]] && MODE="check" && shift
export MODE VIMBADMIN_BROWSER_APPLICATION_SUITE=visual
export VIMBADMIN_BROWSER_RUN_LABEL=${VIMBADMIN_BROWSER_RUN_LABEL:-c133-browser-visual}

if command -v node >/dev/null 2>&1; then
  node -e 'const fs=require("fs"),c=require("crypto"),m=process.env.MODE,f="ci/browser-visual-inventory.json",i=JSON.parse(fs.readFileSync(f));let e=0;for(const[k,v]of Object.entries(i.source_sha256)){const h=c.createHash("sha256").update(fs.readFileSync(k)).digest("hex");if(v!==h){e++;m==="check"?console.error(`${k}\n Soll: ${v}\n Ist:  ${h}`):i.source_sha256[k]=h}}if(e&&m==="check")process.exit(1);if(e)fs.writeFileSync(f,JSON.stringify(i,null,2)+"\n")'
  node ci/test-browser-visual-inventory.cjs
elif command -v php >/dev/null 2>&1; then
  php -r '$m=getenv("MODE");$f="ci/browser-visual-inventory.json";$d=json_decode(file_get_contents($f),true);$e=0;foreach($d["source_sha256"] as $k=>&$v){$h=hash_file("sha256",$k);if($v!==$h){$e++;if($m==="check")fwrite(STDERR,"$k\n Soll: $v\n Ist:  $h\n");else $v=$h;}}if($e&&$m==="check")exit(1);if($e)file_put_contents($f,json_encode($d,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n");'
fi

exec bash tests/support/browser-application-fixture.sh "$@"
