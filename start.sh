#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_DIR="$(pwd)"
PORT="${PORT:-3000}"
export PORT
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$PROJECT_DIR/dist"
/usr/bin/time -p test -f "$PROJECT_DIR/index.html"
if [ -f "$PROJECT_DIR/package.json" ]; then
  /usr/bin/time -p npm install --no-audit --no-fund
  if node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
fi
/usr/bin/time -p cp -f "$PROJECT_DIR/index.html" "$PROJECT_DIR/dist/index.html"
/usr/bin/time -p test -f "$PROJECT_DIR/dist/index.html"
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p /usr/bin/printf '%s' "{\"project\":\"$PROJECT_DIR\",\"directory\":\"$PROJECT_DIR/dist\"}" > "$WEB_DIR/deployment-output.json"
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p python3 --version
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$PROJECT_DIR/dist"
