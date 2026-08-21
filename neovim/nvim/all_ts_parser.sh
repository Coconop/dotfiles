#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="${SCRIPT_DIR}/install_ts_parser.sh"

if [ ! -x "$INSTALL_SCRIPT" ]; then
  echo "Error: ${INSTALL_SCRIPT} not found or not executable" >&2
  exit 1
fi

GRAMMARS=(
  python
  bash
  rust
  go
  json
  yaml
  toml
  lua
  markdown
  c
  cpp
  html
  java
  javascript
  regex
)
# -------------------------------------

FAILED=()

for lang in "${GRAMMARS[@]}"; do
  echo ""
  echo "########################################"
  echo "## Installing: ${lang}"
  echo "########################################"
  if ! "$INSTALL_SCRIPT" "$lang"; then
    echo "!! Failed to install: ${lang}" >&2
    FAILED+=("$lang")
  fi
done

echo ""
echo "==> Done."
if [ "${#FAILED[@]}" -gt 0 ]; then
  echo "==> Failed grammars: ${FAILED[*]}" >&2
  exit 1
else
  echo "==> All grammars installed successfully."
fi
