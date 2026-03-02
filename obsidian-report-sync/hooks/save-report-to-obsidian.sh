#!/bin/bash
# Save work report to Obsidian vault
# Called by Claude via Bash: save-report-to-obsidian.sh <<'EOF' ... EOF
# Reads report markdown from stdin, saves to Report/<project>/<date>_<title>.md

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_lib.sh"

log "==============================="
log "=== save-report-to-obsidian triggered ==="
log "PID: $$"
log "PWD: $(pwd)"

# Read report content from stdin
report_content=$(cat)

if [ -z "$report_content" ]; then
  log "ABORT: No report content received"
  echo "[obsidian-report-sync] Error: No report content provided" >&2
  exit 1
fi

log "Report content length: ${#report_content}"

# Session ID for dedup (use CLAUDE_SESSION_ID if available, fallback to date+PWD hash)
# Sanitize to filesystem-safe characters (alphanumeric + hyphen + underscore only)
raw_session_id="${CLAUDE_SESSION_ID:-$(echo "$(date +%Y%m%d)-$(pwd)" | md5 -q 2>/dev/null || echo "$(date +%Y%m%d)-$(pwd)" | md5sum 2>/dev/null | cut -d' ' -f1 || echo "fallback-$(date +%Y%m%d%H%M%S)-$$")}"
session_id=$(echo "$raw_session_id" | tr -cd '[:alnum:]-_')
log "Session ID: $session_id"

# Check if already saved this session
if is_already_saved "$session_id"; then
  log "SKIP: Already saved report for this session"
  echo "[obsidian-report-sync] Report already saved for this session" >&2
  exit 0
fi

# Clean up old markers
cleanup_old_markers

# Detect and normalize project name from PWD
project_raw=$(basename "$(pwd)")
project=$(normalize_project_name "$project_raw")
log "Project: raw=$project_raw normalized=$project"

# Write to temp file for save_to_obsidian
tmp_file=$(mktemp)
echo "$report_content" > "$tmp_file"

# Save + mark
if save_to_obsidian "$tmp_file" "$project"; then
  mark_as_saved "$session_id"
  log "Report save complete"
else
  log "Report save FAILED"
  echo "ERROR: Failed to save report to Obsidian. All save methods failed."
  rm -f "$tmp_file"
  exit 1
fi

# Clean up temp file
rm -f "$tmp_file"

log "=== save-report-to-obsidian complete ==="
log ""
