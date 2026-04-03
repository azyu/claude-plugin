#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────
# obsidian-session-log installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/azyu/claude-plugin/main/install_obsidian-session-log.sh | bash
#
# What it does:
#   1. Checks prerequisites (jq, obsidian CLI)
#   2. Downloads plugin files to ~/.claude/plugins/obsidian-session-log/
#   3. Creates ~/.claude/obsidian-session-log.conf (interactive)
#   4. Prints next steps
# ─────────────────────────────────────────────────────

PLUGIN_NAME="obsidian-session-log"
INSTALL_DIR="${HOME}/.claude/plugins/${PLUGIN_NAME}"
CONF_FILE="${HOME}/.claude/obsidian-session-log.conf"
REPO_BASE="https://raw.githubusercontent.com/azyu/claude-plugin/main/obsidian-session-log"

# ── Colors ────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()  { printf "${CYAN}▶${NC} %s\n" "$1"; }
ok()    { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
fail()  { printf "${RED}✗${NC} %s\n" "$1"; exit 1; }

# ── 1. Prerequisites ─────────────────────────────────
printf "\n${BOLD}obsidian-session-log installer${NC}\n\n"

info "Checking prerequisites..."

if ! command -v jq &>/dev/null; then
  fail "jq is required but not found. Install it: brew install jq"
fi
ok "jq found"

if ! command -v obsidian &>/dev/null; then
  fail "obsidian CLI is required but not found. See: https://help.obsidian.md/cli"
fi
ok "obsidian CLI found"

if command -v claude &>/dev/null; then
  ok "claude CLI found (AI summaries enabled)"
else
  warn "claude CLI not found — will use jq fallback for summaries"
fi

# ── 2. Download plugin files ─────────────────────────
printf "\n"
info "Installing plugin to ${INSTALL_DIR}..."

mkdir -p "${INSTALL_DIR}/.claude-plugin"
mkdir -p "${INSTALL_DIR}/hooks"
mkdir -p "${INSTALL_DIR}/scripts"

download() {
  local src="$1"
  local dst="$2"
  if command -v curl &>/dev/null; then
    curl -fsSL "${REPO_BASE}/${src}" -o "$dst"
  elif command -v wget &>/dev/null; then
    wget -qO "$dst" "${REPO_BASE}/${src}"
  else
    fail "Neither curl nor wget found"
  fi
}

download ".claude-plugin/plugin.json" "${INSTALL_DIR}/.claude-plugin/plugin.json"
download "hooks/hooks.json"           "${INSTALL_DIR}/hooks/hooks.json"
download "scripts/session-end.sh"     "${INSTALL_DIR}/scripts/session-end.sh"
download "CLAUDE.md"                  "${INSTALL_DIR}/CLAUDE.md"

chmod +x "${INSTALL_DIR}/scripts/session-end.sh"

ok "Plugin files installed"

# ── 3. Configuration ─────────────────────────────────
printf "\n"

if [[ -f "$CONF_FILE" ]]; then
  warn "Config already exists: ${CONF_FILE}"
  info "Skipping configuration (edit manually if needed)"
else
  info "Creating configuration: ${CONF_FILE}"

  # stdin is a pipe when running via curl|bash, so read from /dev/tty
  read_input() {
    local prompt="$1"
    local default="$2"
    local result
    if [[ -n "$default" ]]; then
      printf "  ${prompt} [${default}]: " >/dev/tty
    else
      printf "  ${prompt}: " >/dev/tty
    fi
    read -r result </dev/tty || true
    echo "${result:-$default}"
  }

  printf "\n"
  FOLDER_PREFIX=$(read_input "FOLDER_PREFIX (Obsidian vault folder prefix, e.g. 20_Project)" "")
  while [[ -z "$FOLDER_PREFIX" ]]; do
    warn "FOLDER_PREFIX is required"
    FOLDER_PREFIX=$(read_input "FOLDER_PREFIX" "")
  done

  LANG_SUMMARY=$(read_input "LANG_SUMMARY (ko or en)" "ko")
  OBSIDIAN_VAULT=$(read_input "OBSIDIAN_VAULT (vault name, leave empty for default)" "")

  mkdir -p "$(dirname "$CONF_FILE")"
  cat > "$CONF_FILE" <<EOF
# obsidian-session-log configuration
# Created: $(date +%Y-%m-%d)

FOLDER_PREFIX="${FOLDER_PREFIX}"
LANG_SUMMARY="${LANG_SUMMARY}"
OBSIDIAN_VAULT="${OBSIDIAN_VAULT}"
EOF

  ok "Config saved to ${CONF_FILE}"
fi

# ── 4. Done ───────────────────────────────────────────
printf "\n${GREEN}${BOLD}Installation complete!${NC}\n\n"
printf "Next step — register the plugin with Claude Code:\n\n"
printf "  ${BOLD}claude plugin add ${INSTALL_DIR}${NC}\n\n"
printf "Sessions will be logged to:\n"
printf "  {vault}/${FOLDER_PREFIX}/{project}/history/{YYYY-MM-DD}.md\n\n"
