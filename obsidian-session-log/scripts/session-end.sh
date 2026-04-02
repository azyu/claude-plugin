#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────
# obsidian-session-log: SessionEnd hook
#
# Summarizes the Claude Code session and appends to:
#   {FOLDER_PREFIX}/{project_name}/history/{YYYY-MM-DD}.md
#
# Architecture:
#   Main process reads stdin, forks background worker, exits immediately.
#   Worker does AI summary + Obsidian CLI write asynchronously.
#
# Requires:
#   - obsidian CLI (https://help.obsidian.md/cli)
#   - Config file: ~/.claude/obsidian-session-log.conf
#     Must define: FOLDER_PREFIX (e.g. "20_Project")
#     Optional:    LANG_SUMMARY (ko|en, default: ko)
#                  OBSIDIAN_VAULT (vault name, default: CLI default)
# ─────────────────────────────────────────────────────

CONF_FILE="${HOME}/.claude/obsidian-session-log.conf"
LOG_DIR="/tmp/obsidian-session-log"

# ── Helper: macOS toast notification ───────────────
notify() {
  local msg="$1"
  local title="${2:-Claude Code}"
  local sound="${3:-}"
  if command -v osascript &>/dev/null; then
    local sound_clause=""
    if [[ -n "$sound" ]]; then
      sound_clause=" sound name \"${sound}\""
    fi
    osascript -e "display notification \"${msg}\" with title \"${title}\"${sound_clause}" 2>/dev/null || true
  fi
}

# ── 0. Load config (must exist) ────────────────────
if [[ ! -f "$CONF_FILE" ]]; then
  notify "Config missing: ${CONF_FILE}" "Claude Code" "Basso"
  exit 0
fi

# shellcheck source=/dev/null
source "$CONF_FILE"

if [[ -z "${FOLDER_PREFIX:-}" ]]; then
  notify "FOLDER_PREFIX not set in ${CONF_FILE}" "Claude Code" "Basso"
  exit 0
fi

# Defaults for optional settings
LANG_SUMMARY="${LANG_SUMMARY:-ko}"
OBSIDIAN_VAULT="${OBSIDIAN_VAULT:-}"

# ── 1. Read stdin (must happen in main process) ─────
INPUT=$(cat)

if ! command -v jq &>/dev/null; then
  notify "jq not found — session log skipped" "Claude Code" "Basso"
  exit 0
fi

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# ── 2. Fork background worker and exit immediately ──
mkdir -p "$LOG_DIR"

(
  exec &>"${LOG_DIR}/worker-$(date +%Y%m%d-%H%M%S).log"

  PROJECT_NAME=$(basename "${CWD:-unknown}")
  TODAY=$(date +%Y-%m-%d)
  NOW_TIME=$(date +%H:%M)
  SESSION_SHORT="${SESSION_ID:0:8}"
  NOTE_REL_PATH="${FOLDER_PREFIX}/${PROJECT_NAME}/history/${TODAY}.md"

  echo "[$(date)] Starting session log for ${PROJECT_NAME} (${SESSION_SHORT})"

  # ── Preflight: obsidian CLI ─────────────────────
  OBSIDIAN_BIN=""
  if command -v obsidian &>/dev/null; then
    OBSIDIAN_BIN=$(command -v obsidian)
  fi

  if [[ -z "$OBSIDIAN_BIN" ]]; then
    notify "obsidian CLI not found — session log skipped" "Claude Code" "Basso"
    echo "[$(date)] ABORT: obsidian CLI not found"
    exit 0
  fi

  if ! pgrep -xq "Obsidian" 2>/dev/null; then
    notify "Obsidian not running — session log skipped" "Claude Code" "Basso"
    echo "[$(date)] ABORT: Obsidian not running"
    exit 0
  fi

  notify "Summarizing session for ${PROJECT_NAME}..." "Claude Code"

  # ── Build vault parameter ───────────────────────
  VAULT_PARAM=""
  if [[ -n "$OBSIDIAN_VAULT" ]]; then
    VAULT_PARAM="vault=\"${OBSIDIAN_VAULT}\""
  fi

  # ── Generate summary ─────────────────────────────
  get_prompt_ko() {
    cat <<'PROMPT'
아래는 Claude Code 세션의 transcript (JSONL)입니다.
이 세션에서 수행한 작업을 한국어로 간결하게 요약해주세요.

형식:
### 요약
- 핵심 작업 내용 (2-5줄)

### 변경된 파일
- 수정/생성된 파일 경로 목록 (Edit, Write 도구 사용 기준)

### 주요 명령어
- 실행된 주요 Bash 명령어 (빌드, 테스트, git 등)

주의:
- tool_result, tool_output 내용은 요약에 포함하지 마세요
- 사용자 요청과 실제 수행한 작업 중심으로 작성
- 파일 경로는 프로젝트 루트 기준 상대 경로로
PROMPT
  }

  get_prompt_en() {
    cat <<'PROMPT'
Below is a Claude Code session transcript (JSONL).
Summarize what was done in this session concisely in English.

Format:
### Summary
- Key tasks performed (2-5 lines)

### Changed Files
- List of modified/created file paths (based on Edit, Write tool usage)

### Key Commands
- Notable Bash commands executed (build, test, git, etc.)

Notes:
- Do not include tool_result or tool_output content in the summary
- Focus on user requests and actual work performed
- Use project-root-relative paths for files
PROMPT
  }

  generate_ai_summary() {
    local transcript_file="$1"
    local truncated
    truncated=$(head -c 100000 "$transcript_file")

    local prompt
    if [[ "$LANG_SUMMARY" == "en" ]]; then
      prompt=$(get_prompt_en)
    else
      prompt=$(get_prompt_ko)
    fi

    local claude_bin
    if ! claude_bin=$(command -v claude); then
      return 1
    fi

    echo "$truncated" | "$claude_bin" -p \
      --model sonnet \
      --no-session-persistence \
      --setting-sources "" \
      "$prompt" 2>/dev/null
  }

  generate_fallback_summary() {
    local transcript_file="$1"

    local user_msgs
    user_msgs=$(jq -r 'select(.type == "user") | .content' "$transcript_file" 2>/dev/null \
      | head -c 2000 \
      | sed 's/^/- /' \
      || echo "- (transcript parsing failed)")

    local files
    files=$(jq -r 'select(.type == "tool_use" and (.tool_name == "edit" or .tool_name == "write")) | .tool_input.file_path // .tool_input.filePath // empty' "$transcript_file" 2>/dev/null \
      | sort -u \
      | sed 's/^/- /' \
      || echo "")

    local cmds
    cmds=$(jq -r 'select(.type == "tool_use" and .tool_name == "bash") | .tool_input.command // empty' "$transcript_file" 2>/dev/null \
      | head -20 \
      | sed 's/^/- `/' \
      | sed 's/$/`/' \
      || echo "")

    local summary_header="### 요약"
    local files_header="### 변경된 파일"
    local cmds_header="### 주요 명령어"
    local none_label="없음"

    if [[ "$LANG_SUMMARY" == "en" ]]; then
      summary_header="### Summary"
      files_header="### Changed Files"
      cmds_header="### Key Commands"
      none_label="None"
    fi

    printf '%s\n' \
      "${summary_header}" \
      "${user_msgs}" \
      "" \
      "${files_header}" \
      "${files:-${none_label}}" \
      "" \
      "${cmds_header}" \
      "${cmds:-${none_label}}"
  }

  SUMMARY=""
  if [[ -n "$TRANSCRIPT_PATH" ]] && [[ -f "$TRANSCRIPT_PATH" ]]; then
    echo "[$(date)] Generating AI summary..."
    SUMMARY=$(generate_ai_summary "$TRANSCRIPT_PATH" 2>/dev/null || true)

    if [[ -z "$SUMMARY" ]]; then
      echo "[$(date)] AI summary failed, using fallback extraction"
      SUMMARY=$(generate_fallback_summary "$TRANSCRIPT_PATH" 2>/dev/null || true)
    else
      echo "[$(date)] AI summary generated successfully"
    fi
  fi

  if [[ -z "$SUMMARY" ]]; then
    local no_transcript_msg="- (transcript 없음 — 메타데이터만 기록)"
    if [[ "$LANG_SUMMARY" == "en" ]]; then
      no_transcript_msg="- (no transcript — metadata only)"
    fi
    local header="### 요약"
    if [[ "$LANG_SUMMARY" == "en" ]]; then
      header="### Summary"
    fi
    SUMMARY=$(printf '%s\n' "${header}" "${no_transcript_msg}")
  fi

  # ── Build content blocks ─────────────────────────
  build_session_block() {
    local project_label="**프로젝트**"
    if [[ "$LANG_SUMMARY" == "en" ]]; then
      project_label="**Project**"
    fi

    printf '%s\n' \
      "" \
      "## ${NOW_TIME} — ${SESSION_SHORT}" \
      "" \
      "${project_label}: \`${CWD:-unknown}\`" \
      "" \
      "${SUMMARY}" \
      "" \
      "---"
  }

  build_new_note() {
    printf '%s\n' \
      "---" \
      "date: ${TODAY}" \
      "project: ${PROJECT_NAME}" \
      "tags:" \
      "  - claude-code" \
      "  - session-log" \
      "---"
    build_session_block
  }

  # ── Escape content for obsidian CLI ─────────────
  # obsidian CLI uses \n for newlines, \t for tabs
  escape_for_obsidian() {
    local input="$1"
    printf '%s' "$input" | awk '{
      if (NR > 1) printf "\\n"
      gsub(/\t/, "\\t")
      printf "%s", $0
    }'
  }

  # ── Write to Obsidian via CLI ───────────────────
  SESSION_BLOCK=$(build_session_block)
  write_method=""

  # Try append first (file may already exist)
  escaped_block=$(escape_for_obsidian "$SESSION_BLOCK")

  if [[ -n "$VAULT_PARAM" ]]; then
    cli_out=$("$OBSIDIAN_BIN" append path="$NOTE_REL_PATH" content="$escaped_block" ${VAULT_PARAM} silent 2>&1)
  else
    cli_out=$("$OBSIDIAN_BIN" append path="$NOTE_REL_PATH" content="$escaped_block" silent 2>&1)
  fi

  if [[ "$cli_out" != *"Error:"* ]]; then
    write_method="obsidian append"
    echo "[$(date)] Written via obsidian append"
  else
    echo "[$(date)] Append failed (${cli_out}), trying create..."

    # File doesn't exist yet — create with frontmatter
    NEW_CONTENT=$(build_new_note)
    escaped_new=$(escape_for_obsidian "$NEW_CONTENT")

    if [[ -n "$VAULT_PARAM" ]]; then
      cli_out=$("$OBSIDIAN_BIN" create path="$NOTE_REL_PATH" content="$escaped_new" ${VAULT_PARAM} silent 2>&1)
    else
      cli_out=$("$OBSIDIAN_BIN" create path="$NOTE_REL_PATH" content="$escaped_new" silent 2>&1)
    fi

    if [[ "$cli_out" != *"Error:"* ]]; then
      write_method="obsidian create"
      echo "[$(date)] Written via obsidian create"
    else
      echo "[$(date)] Create also failed: ${cli_out}"
    fi
  fi

  # ── Result notification ─────────────────────────
  if [[ -n "$write_method" ]]; then
    notify "Session logged (${write_method}) → ${NOTE_REL_PATH}" "Claude Code" "Glass"
  else
    notify "Failed to write session log — check /tmp/obsidian-session-log/" "Claude Code" "Basso"
  fi

  echo "[$(date)] Done. method=${write_method:-FAILED}"

) &

disown

# ── 3. Exit immediately ─────────────────────────────
exit 0
