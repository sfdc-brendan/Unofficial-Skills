#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Custom Lightning Types — skill installer
#
# One-line install (copy/paste into Terminal):
#
# curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
#
# Or with wget:
#
# wget -qO- https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
#
# Installs only this pack (sf-clt-builder + agentforce-lightning-types).
# Auto-detects Cursor, Claude Code, Windsurf, and Codex.
# No git clone required.
# ============================================================

REPO="sfdc-brendan/Unofficial-Skills"
BRANCH="main"
PACK_PATH="custom-lightning-types"
ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

SKILL_NAMES=(
  "sf-clt-builder"
  "agentforce-lightning-types"
)
RULE_NAME="agentforce-lightning-types.mdc"

# -----------------------------------------------------------
# Detect IDE skills directories (same pattern as Demo-Lab)
# -----------------------------------------------------------
TARGETS=()
CURSOR_RULES=""

if [ -d "$HOME/.cursor" ]; then
  TARGETS+=("$HOME/.cursor/skills")
  CURSOR_RULES="$HOME/.cursor/rules"
fi

if [ -d "$HOME/.claude" ]; then
  TARGETS+=("$HOME/.claude/skills")
fi

if [ -d "$HOME/.windsurf" ]; then
  TARGETS+=("$HOME/.windsurf/skills")
fi

if [ -d "$HOME/.codex" ]; then
  TARGETS+=("$HOME/.codex/skills")
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS+=("$HOME/.cursor/skills")
  CURSOR_RULES="$HOME/.cursor/rules"
fi

# -----------------------------------------------------------
# Download helper
# -----------------------------------------------------------
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

# -----------------------------------------------------------
# Local clone vs remote (curl | bash)
# -----------------------------------------------------------
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
  if [ -f "$REAL_PATH/sf-clt-builder/SKILL.md" ]; then
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
  PACK_ROOT="$(find "$TMP_DIR" -type d -name "$PACK_PATH" | head -n 1)"
  if [ -z "$PACK_ROOT" ] || [ ! -f "$PACK_ROOT/sf-clt-builder/SKILL.md" ]; then
    echo " ERROR: archive did not contain $PACK_PATH/sf-clt-builder"
    exit 1
  fi
fi

# -----------------------------------------------------------
# Install
# -----------------------------------------------------------
echo ""
echo "==========================================="
echo " Custom Lightning Types installer"
echo " ${#SKILL_NAMES[@]} skills for Apex-based CLT cards"
echo "==========================================="
echo ""
echo " Source: $( [ "$MODE" = "local" ] && echo "local ($PACK_ROOT)" || echo "github.com/$REPO" )"
echo " Target: ${TARGETS[*]}"
echo ""

installed=0
skipped=0
total=${#SKILL_NAMES[@]}

copy_tree() {
  local src="$1"
  local dest="$2"
  mkdir -p "$dest"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
}

for skill in "${SKILL_NAMES[@]}"; do
  src="$PACK_ROOT/$skill"
  if [ ! -f "$src/SKILL.md" ]; then
    echo " WARN $skill — SKILL.md not found, skipping"
    skipped=$((skipped + 1))
    continue
  fi
  if ! head -5 "$src/SKILL.md" | grep -q "^name:"; then
    echo " WARN $skill — missing 'name:' in frontmatter, skipping"
    skipped=$((skipped + 1))
    continue
  fi

  for target_dir in "${TARGETS[@]}"; do
    mkdir -p "$target_dir"
    copy_tree "$src" "$target_dir/$skill"
  done

  echo " OK $skill"
  installed=$((installed + 1))
done

if [ -n "$CURSOR_RULES" ] && [ -f "$PACK_ROOT/rules/$RULE_NAME" ]; then
  mkdir -p "$CURSOR_RULES"
  cp "$PACK_ROOT/rules/$RULE_NAME" "$CURSOR_RULES/$RULE_NAME"
  echo " OK $RULE_NAME (Cursor rule)"
fi

echo ""
echo "-------------------------------------------"
echo " Installed: $installed / $total skills"
if [ "$skipped" -gt 0 ]; then
  echo " Skipped: $skipped"
fi
echo ""
echo " Installed to:"
for target_dir in "${TARGETS[@]}"; do
  echo "  $target_dir"
done
if [ -n "$CURSOR_RULES" ]; then
  echo "  $CURSOR_RULES"
fi
echo "-------------------------------------------"
echo ""

if [ "$installed" -gt 0 ]; then
  echo "Skills installed:"
  for skill in "${SKILL_NAMES[@]}"; do
    echo " - $skill"
  done
  echo ""
  echo "Restart your IDE to activate the new skills."
  echo ""
  echo "Then try: Build a Custom Lightning Type card for the Service Rep Assistant sidebar"
fi
