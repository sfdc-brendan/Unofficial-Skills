#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Agentforce Vision — skill installer
#
# One-line install:
#
# curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/vision/install.sh | bash
#
# wget -qO- https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/vision/install.sh | bash
#
# Optional: --target=auto|cursor|claude|windsurf|codex|all
# Auto-detects Cursor, Claude Code, Windsurf, and Codex.
# No git clone required.
# ============================================================

REPO="sfdc-brendan/Unofficial-Skills"
BRANCH="main"
PACK_PATH="agentforce/vision"
ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
DEPTH="2"

TARGET="auto"
for arg in "$@"; do
  case "$arg" in
    --target=*) TARGET="${arg#--target=}" ;;
    --help|-h)
      sed -n '2,18p' "$0" 2>/dev/null || true
      exit 0
      ;;
  esac
done

TARGETS=()
CURSOR_RULES=""

add_cursor() {
  TARGETS+=("$HOME/.cursor/skills")
  CURSOR_RULES="$HOME/.cursor/rules"
}
add_claude() { TARGETS+=("$HOME/.claude/skills"); }
add_windsurf() { TARGETS+=("$HOME/.windsurf/skills"); }
add_codex() { TARGETS+=("$HOME/.codex/skills"); }

case "$TARGET" in
  cursor) add_cursor ;;
  claude) add_claude ;;
  windsurf) add_windsurf ;;
  codex) add_codex ;;
  all)
    add_cursor
    add_claude
    add_windsurf
    add_codex
    ;;
  auto)
    [ -d "$HOME/.cursor" ] && add_cursor
    [ -d "$HOME/.claude" ] && add_claude
    [ -d "$HOME/.windsurf" ] && add_windsurf
    [ -d "$HOME/.codex" ] && add_codex
    if [ ${#TARGETS[@]} -eq 0 ]; then
      add_cursor
    fi
    ;;
  *)
    echo " ERROR: unknown --target=$TARGET (expected auto|cursor|claude|windsurf|codex|all)"
    exit 1
    ;;
esac

download() {
  local url="$1"
  local dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    echo " ERROR: Neither curl nor wget found. Install one and try again."
    exit 1
  fi
}

MODE="remote"
PACK_ROOT=""
TMP_DIR=""

cleanup() {
  if [ -n "${TMP_DIR:-}" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  REAL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if find "$REAL_PATH" -maxdepth "$DEPTH" -mindepth 1 -type f -name "SKILL.md" -print -quit | grep -q .; then
    MODE="local"
    PACK_ROOT="$REAL_PATH"
  fi
fi

if [ "$MODE" = "remote" ]; then
  TMP_DIR="$(mktemp -d)"
  echo " Downloading $REPO ($BRANCH)…"
  if ! download "$ARCHIVE_URL" "$TMP_DIR/pack.tar.gz"; then
    echo " ERROR: could not download $ARCHIVE_URL"
    exit 1
  fi
  tar -xzf "$TMP_DIR/pack.tar.gz" -C "$TMP_DIR"
  ARCHIVE_ROOT="$(find "$TMP_DIR" -maxdepth 1 -mindepth 1 -type d | head -n 1)"
  PACK_ROOT="${ARCHIVE_ROOT}/${PACK_PATH}"
  if [ ! -d "$PACK_ROOT" ]; then
    echo " ERROR: archive did not contain $PACK_PATH"
    exit 1
  fi
fi

echo ""
echo "==========================================="
echo " Agentforce Vision installer"
echo " Give an Agentforce agent the ability to see"
echo "==========================================="
echo ""
echo " Source: $( [ "$MODE" = "local" ] && echo "local ($PACK_ROOT)" || echo "github.com/$REPO" )"
echo " Target: ${TARGETS[*]}"
echo ""

copy_tree() {
  local src="$1"
  local dest="$2"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
}

installed=0
skipped=0

while IFS= read -r skill_md; do
  [ -z "$skill_md" ] && continue
  src="$(dirname "$skill_md")"
  skill="$(basename "$src")"

  if ! head -5 "$skill_md" | grep -q "^name:"; then
    echo " WARN $skill — missing 'name:' in frontmatter, skipping"
    skipped=$((skipped + 1))
    continue
  fi

  dest_name="$skill"
  name_line="$(grep -m 1 '^name:' "$skill_md" || true)"
  if [ -n "$name_line" ]; then
    parsed="${name_line#name:}"
    parsed="$(echo "$parsed" | tr -d '[:space:]')"
    if [ -n "$parsed" ]; then
      dest_name="$parsed"
    fi
  fi

  for target_dir in "${TARGETS[@]}"; do
    mkdir -p "$target_dir"
    copy_tree "$src" "$target_dir/$dest_name"
  done

  echo " OK $dest_name"
  installed=$((installed + 1))
done < <(find "$PACK_ROOT" -maxdepth "$DEPTH" -mindepth 1 -type f -name "SKILL.md" | sort)

echo ""
echo "-------------------------------------------"
echo " Installed: $installed skills"
if [ "$skipped" -gt 0 ]; then
  echo " Skipped: $skipped"
fi
echo ""
echo " Installed to:"
for target_dir in "${TARGETS[@]}"; do
  echo "  $target_dir"
done
echo "-------------------------------------------"
echo ""

if [ "$installed" -gt 0 ]; then
  echo "Restart your IDE to activate the new skills."
  echo ""
  echo "Then try: Add photo analysis to my Agentforce agent so it can diagnose a broken device from a customer photo."
fi
