#!/usr/bin/env bash
set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail

SCRIPT_DIR=$(dirname -- "${BASH_SOURCE[0]}")
cd -- "$SCRIPT_DIR/.." # Switch to project root

# Guard dependencies
>/dev/null type mktemp
>/dev/null type grep
>/dev/null type cp
>/dev/null type rm
if command -v bat >/dev/null 2>&1; then
  BAT=bat
elif command -v batcat >/dev/null 2>&1; then
  BAT=batcat
else
  >&2 printf '%s\n' 'bat or batcat is required for this test.'
  exit 1
fi

TMP_DIR=$(mktemp -d)
cleanup() { rm -rvf -- "$TMP_DIR"; }
trap cleanup EXIT HUP INT TERM
mkdir -vp -- "$TMP_DIR/syntaxes"
cp -v -- './Confetti.sublime-syntax' "$TMP_DIR/syntaxes/"

export BAT_CONFIG_DIR="$TMP_DIR"
export BAT_CACHE_PATH="$TMP_DIR/cache"

(
  set -o xtrace
  "$BAT" cache --build
  "$BAT" --list-languages | grep -iq confetti
  "$BAT" \
    --language confetti \
    --color always \
    --style plain \
    --paging never \
    './examples/core.confetti' > "$TMP_DIR/output"
)

(set -o xtrace; grep -Fq -- 'project' "$TMP_DIR/output")

# Verify that there is terminal coloring in the output
ESCAPE_CHAR=$(printf '\033')
(set -o xtrace; grep -q -- "$ESCAPE_CHAR" "$TMP_DIR/output")

echo 'Confetti syntax was loaded and produced highlighted output.'
