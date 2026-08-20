#!/usr/bin/env bash
set -euo pipefail

LANG="${1:?Usage: install_ts_parser.sh <language>}"

# --- OS detection ---
case "$(uname -s)" in
  Linux*)   OS="linux" ;;
  Darwin*)  OS="mac" ;;
  MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

if [ "$OS" = "windows" ]; then
  EXT="dll"
else
  EXT="so"
fi

# --- Neovim data dir ---
if [ "$OS" = "windows" ]; then
  # Prefer LOCALAPPDATA; fall back to querying nvim itself if unset
  if [ -n "${LOCALAPPDATA:-}" ]; then
    NVIM_DATA="${LOCALAPPDATA}/nvim-data/site"
  else
    NVIM_DATA="$(nvim --headless -c 'echo stdpath("data") . "/site"' -c 'qa' 2>&1 | tail -n1)"
  fi
else
  NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"
fi

PARSER_DIR="${NVIM_DATA}/parser"
QUERY_DIR="${NVIM_DATA}/queries/${LANG}"
WORK_DIR="$(mktemp -d)"
NVIM_TS_QUERIES="https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries"

echo "==> OS detected: ${OS} (parser ext: .${EXT})"
echo "==> Neovim data dir: ${NVIM_DATA}"
echo "==> Installing tree-sitter parser for: ${LANG}"

# 1. Clone grammar
cd "$WORK_DIR"
git clone --depth 1 "https://github.com/tree-sitter/tree-sitter-${LANG}" grammar
cd grammar

# 2. Build shared library
echo "==> Building parser..."
tree-sitter build --output "${LANG}.${EXT}"

# 3. Install parser
mkdir -p "$PARSER_DIR"
cp "${LANG}.${EXT}" "$PARSER_DIR/"
echo "==> Parser installed to ${PARSER_DIR}/${LANG}.${EXT}"

# 4. Install queries — prefer repo's own, fall back to nvim-treesitter's
mkdir -p "$QUERY_DIR"
if [ -d "queries/${LANG}" ] && [ -n "$(ls -A "queries/${LANG}" 2>/dev/null)" ]; then
  cp queries/"${LANG}"/*.scm "$QUERY_DIR/"
  echo "==> Queries copied from grammar repo"
elif [ -d "queries" ] && [ -n "$(ls -A queries 2>/dev/null)" ]; then
  cp queries/*.scm "$QUERY_DIR/"
  echo "==> Queries copied from grammar repo (flat queries/)"
else
  echo "==> No queries in grammar repo, fetching from nvim-treesitter..."
  for f in highlights locals folds indents injections; do
    curl -fsSL "${NVIM_TS_QUERIES}/${LANG}/${f}.scm" -o "${QUERY_DIR}/${f}.scm" 2>/dev/null \
      && echo "    fetched ${f}.scm" \
      || rm -f "${QUERY_DIR}/${f}.scm"
  done
fi

# 5. Cleanup
cd /
rm -rf "$WORK_DIR"

echo "==> Done. Verify with:"
echo "    nvim -c \"lua print(pcall(vim.treesitter.language.add, '${LANG}'))\" -c q"
