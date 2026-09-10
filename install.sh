#!/usr/bin/env bash
# Install every skill pack in this repo, or one named pack.
#
#   ./install.sh --all
#   ./install.sh custom-lightning-types --cursor --claude
#   ./install.sh --list
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Unofficial Skills installer

Usage:
  ./install.sh --all [--cursor] [--claude] [--codex] [--symlink] [--project [DIR]]
  ./install.sh <pack-name> [same flags as the pack installer]
  ./install.sh --list

With no pack name, every pack that has an install.sh is installed.
Pack-specific flags are forwarded unchanged. Run a pack installer with -h
for the full flag list.

Examples:
  ./install.sh --all
  ./install.sh custom-lightning-types --cursor --symlink
  ./install.sh custom-lightning-types --project ~/my-sfdx-app
EOF
}

list_packs() {
  local found=0
  for installer in "$ROOT"/*/install.sh; do
    [[ -e "$installer" ]] || continue
    found=1
    basename "$(dirname "$installer")"
  done
  if [[ "$found" -eq 0 ]]; then
    echo "No skill packs found under $ROOT" >&2
    return 1
  fi
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--list" ]]; then
  list_packs
  exit 0
fi

PACK=""
if [[ $# -gt 0 && "$1" != --* ]]; then
  PACK="$1"
  shift
fi

if [[ -n "$PACK" ]]; then
  INSTALLER="$ROOT/$PACK/install.sh"
  if [[ ! -x "$INSTALLER" && -f "$INSTALLER" ]]; then
    chmod +x "$INSTALLER"
  fi
  if [[ ! -f "$INSTALLER" ]]; then
    echo "Unknown pack: $PACK" >&2
    echo "Available packs:" >&2
    list_packs >&2 || true
    exit 1
  fi
  exec "$INSTALLER" "$@"
fi

# No pack name: install every pack with the same flags.
PACKS=()
for installer in "$ROOT"/*/install.sh; do
  [[ -e "$installer" ]] || continue
  PACKS+=("$(dirname "$installer")")
done

if [[ "${#PACKS[@]}" -eq 0 ]]; then
  echo "No skill packs found under $ROOT" >&2
  exit 1
fi

status=0
for pack_dir in "${PACKS[@]}"; do
  echo "==> $(basename "$pack_dir")"
  if ! "$pack_dir/install.sh" "$@"; then
    status=1
  fi
  echo
done
exit "$status"
