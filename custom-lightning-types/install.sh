#!/usr/bin/env bash
# Install the Custom Lightning Types skill pack into Cursor, Claude Code, and/or Codex.
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_NAME="custom-lightning-types"
SKILLS=(sf-clt-builder agentforce-lightning-types)
RULE_NAME="agentforce-lightning-types.mdc"

DO_CURSOR=0
DO_CLAUDE=0
DO_CODEX=0
DO_PROJECT=0
PROJECT_DIR=""
SYMLINK=0
DRY_RUN=0
UNINSTALL=0
FORCE=0

usage() {
  cat <<'EOF'
Custom Lightning Types — skill installer

Installs:
  sf-clt-builder                 generate Apex-based CLT cards
  agentforce-lightning-types     debug a card that will not render
  agentforce-lightning-types.mdc Cursor rule (Cursor only)

Usage:
  ./install.sh --all
  ./install.sh --cursor --claude
  ./install.sh --symlink --all
  ./install.sh --project ~/my-sfdx-app --cursor
  ./install.sh --uninstall --all
  ./install.sh --dry-run --all

Flags:
  --all              Install into every tool detected on this machine
  --cursor           User-level Cursor  (~/.cursor/skills, ~/.cursor/rules)
  --claude           User-level Claude Code (~/.claude/skills)
  --codex            User-level Codex (~/.codex/skills)
  --project [DIR]    Project-level install (DIR defaults to the current directory)
  --symlink          Link at this clone instead of copying (git pull updates skills)
  --force            Overwrite an existing copy (default). Ignored for --symlink
  --dry-run          Print the plan, write nothing
  --uninstall        Remove what this pack installed from the selected destinations
  -h, --help         Show this help

With no tool flags, --all is implied.

After install, start a new agent session. Then ask:
  "Build a Custom Lightning Type card for the Service Rep Assistant sidebar"
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

log() {
  echo "  $*"
}

have_dir() {
  [[ -d "$1" ]]
}

tool_present_cursor() { have_dir "$HOME/.cursor"; }
tool_present_claude() { have_dir "$HOME/.claude"; }
tool_present_codex()  { have_dir "$HOME/.codex"; }

parse_args() {
  local saw_tool=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      --all)
        saw_tool=1
        DO_CURSOR=1
        DO_CLAUDE=1
        DO_CODEX=1
        shift
        ;;
      --cursor)
        saw_tool=1
        DO_CURSOR=1
        shift
        ;;
      --claude)
        saw_tool=1
        DO_CLAUDE=1
        shift
        ;;
      --codex)
        saw_tool=1
        DO_CODEX=1
        shift
        ;;
      --project)
        DO_PROJECT=1
        shift
        if [[ $# -gt 0 && "$1" != --* ]]; then
          PROJECT_DIR="$1"
          shift
        else
          PROJECT_DIR="$(pwd)"
        fi
        ;;
      --symlink)
        SYMLINK=1
        shift
        ;;
      --force)
        FORCE=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --uninstall)
        UNINSTALL=1
        shift
        ;;
      *)
        die "unknown flag: $1 (run with --help)"
        ;;
    esac
  done

  if [[ "$saw_tool" -eq 0 && "$DO_PROJECT" -eq 0 ]]; then
    DO_CURSOR=1
    DO_CLAUDE=1
    DO_CODEX=1
  fi

  if [[ "$DO_PROJECT" -eq 1 ]]; then
    PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
  fi
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "dry-run: $*"
    return 0
  fi
  "$@"
}

ensure_src_skills() {
  local skill
  for skill in "${SKILLS[@]}"; do
    [[ -f "$PACK_ROOT/$skill/SKILL.md" ]] || die "missing skill: $PACK_ROOT/$skill/SKILL.md"
  done
}

install_skill() {
  local src="$1"
  local dest_parent="$2"
  local name
  name="$(basename "$src")"
  local dest="$dest_parent/$name"

  run mkdir -p "$dest_parent"

  if [[ "$UNINSTALL" -eq 1 ]]; then
    if [[ -e "$dest" || -L "$dest" ]]; then
      log "remove $dest"
      run rm -rf "$dest"
    else
      log "skip  $dest (not installed)"
    fi
    return 0
  fi

  if [[ "$SYMLINK" -eq 1 ]]; then
    if [[ -e "$dest" || -L "$dest" ]]; then
      log "replace $dest -> $src"
      run rm -rf "$dest"
    else
      log "link  $dest -> $src"
    fi
    run ln -sfn "$src" "$dest"
    return 0
  fi

  if [[ -L "$dest" ]]; then
    log "replace symlink $dest with a copy"
    run rm "$dest"
  fi
  log "copy  $src -> $dest"
  run rm -rf "$dest"
  run mkdir -p "$dest"
  # Portable copy (macOS has no cp -a with GNU long opts).
  run cp -R "$src/." "$dest/"
}

install_rule() {
  local src="$PACK_ROOT/rules/$RULE_NAME"
  local dest_parent="$1"
  local dest="$dest_parent/$RULE_NAME"

  [[ -f "$src" ]] || die "missing Cursor rule: $src"
  run mkdir -p "$dest_parent"

  if [[ "$UNINSTALL" -eq 1 ]]; then
    if [[ -e "$dest" || -L "$dest" ]]; then
      log "remove $dest"
      run rm -f "$dest"
    else
      log "skip  $dest (not installed)"
    fi
    return 0
  fi

  if [[ "$SYMLINK" -eq 1 ]]; then
    log "link  $dest -> $src"
    run rm -f "$dest"
    run ln -sfn "$src" "$dest"
    return 0
  fi

  log "copy  $src -> $dest"
  run mkdir -p "$dest_parent"
  run cp "$src" "$dest"
}

maybe_skip_missing_home() {
  local tool="$1"
  local home="$2"
  if [[ "$DO_PROJECT" -eq 1 ]]; then
    return 1
  fi
  if have_dir "$home"; then
    return 1
  fi
  echo "skip $tool: $home not found (tool does not appear to be installed)"
  return 0
}

install_cursor() {
  local skills_dir rules_dir
  if [[ "$DO_PROJECT" -eq 1 ]]; then
    skills_dir="$PROJECT_DIR/.cursor/skills"
    rules_dir="$PROJECT_DIR/.cursor/rules"
  else
    if maybe_skip_missing_home "Cursor" "$HOME/.cursor"; then
      return 0
    fi
    skills_dir="$HOME/.cursor/skills"
    rules_dir="$HOME/.cursor/rules"
  fi

  echo "Cursor  $skills_dir"
  local skill
  for skill in "${SKILLS[@]}"; do
    install_skill "$PACK_ROOT/$skill" "$skills_dir"
  done
  echo "Cursor  $rules_dir"
  install_rule "$rules_dir"
}

install_claude() {
  local skills_dir
  if [[ "$DO_PROJECT" -eq 1 ]]; then
    skills_dir="$PROJECT_DIR/.claude/skills"
  else
    if maybe_skip_missing_home "Claude Code" "$HOME/.claude"; then
      return 0
    fi
    skills_dir="$HOME/.claude/skills"
  fi

  echo "Claude  $skills_dir"
  local skill
  for skill in "${SKILLS[@]}"; do
    install_skill "$PACK_ROOT/$skill" "$skills_dir"
  done
}

install_codex() {
  if [[ "$DO_PROJECT" -eq 1 ]]; then
    echo "skip Codex: no project-level path (Codex reads ~/.codex/skills)"
    return 0
  fi
  if maybe_skip_missing_home "Codex" "$HOME/.codex"; then
    return 0
  fi

  local skills_dir="$HOME/.codex/skills"
  echo "Codex   $skills_dir"
  local skill
  for skill in "${SKILLS[@]}"; do
    install_skill "$PACK_ROOT/$skill" "$skills_dir"
  done
}

print_next_steps() {
  if [[ "$UNINSTALL" -eq 1 ]]; then
    echo
    echo "Removed $PACK_NAME from the selected destinations."
    echo "Start a new agent session so the tools drop the skills."
    return 0
  fi
  cat <<'EOF'

Installed. Start a new agent session, then try:

  Build a Custom Lightning Type card for the Service Rep Assistant sidebar
  that lets a rep pick an appointment window.

How the pieces fit together: docs/HOW-IT-WORKS.md
EOF
}

parse_args "$@"
ensure_src_skills

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run: no files will be written"
fi
if [[ "$SYMLINK" -eq 1 && "$UNINSTALL" -eq 0 ]]; then
  echo "mode: symlink to $PACK_ROOT"
  echo "keep this clone; deleting it breaks the installed skills."
fi

[[ "$DO_CURSOR" -eq 1 ]] && install_cursor
[[ "$DO_CLAUDE" -eq 1 ]] && install_claude
[[ "$DO_CODEX" -eq 1 ]] && install_codex

print_next_steps
