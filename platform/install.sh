#!/usr/bin/env bash
set -euo pipefail

# Installs the Salesforce role subagents (DSE, SE, SA, BA, and more).
# Usage: bash install.sh [--both|--cursor|--claude]
# Default: --both

REPO="sfdc-brendan/Unofficial-Skills"
BRANCH="main"
PACK_PATH="platform/subagents"
ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

if [ "$#" -eq 0 ]; then
  ARGS=("--both")
else
  ARGS=("$@")
fi

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
  if [ -f "$REAL_PATH/subagents/install-all.sh" ]; then
    MODE="local"
    PACK_ROOT="$REAL_PATH/subagents"
  fi
fi

if [ "$MODE" = "remote" ]; then
  TMP_DIR="$(mktemp -d)"
  echo " Downloading $REPO ($BRANCH)…"
  download "$ARCHIVE_URL" "$TMP_DIR/pack.tar.gz"
  tar -xzf "$TMP_DIR/pack.tar.gz" -C "$TMP_DIR"
  ARCHIVE_ROOT="$(find "$TMP_DIR" -maxdepth 1 -mindepth 1 -type d | head -n 1)"
  PACK_ROOT="${ARCHIVE_ROOT}/${PACK_PATH}"
fi

exec bash "$PACK_ROOT/install-all.sh" "${ARGS[@]}"
