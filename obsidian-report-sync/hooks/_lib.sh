#!/bin/bash
# obsidian-report-sync: Shared library for report saving hooks
# Used by: save-report-to-obsidian.sh (called by Claude via Bash)

DEBUG_LOG="$HOME/.claude/obsidian-report-sync.log"
MARKER_DIR="$HOME/.claude/.report-sync-marker"
OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault"

mkdir -p "$MARKER_DIR"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG"; }

# normalize_project_name: underscore → hyphen, lowercase, match existing Obsidian folder
# When multiple folders match (e.g. lxp_services & lxp-services), prefer the hyphenated form
normalize_project_name() {
  local raw="$1"
  local normalized
  normalized=$(echo "$raw" | tr '[:upper:]' '[:lower:]' | tr '_' '-')

  # Check existing Obsidian Report/ subfolders for a match
  local report_dir="$OBSIDIAN_VAULT/Report"
  if [ -d "$report_dir" ]; then
    local exact_match=""
    local fuzzy_match=""
    for dir in "$report_dir"/*/; do
      [ -d "$dir" ] || continue
      local dirname
      dirname=$(basename "$dir")
      local dirname_normalized
      dirname_normalized=$(echo "$dirname" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
      if [ "$dirname_normalized" = "$normalized" ]; then
        if [ "$dirname" = "$normalized" ]; then
          exact_match="$dirname"
        elif [ -z "$fuzzy_match" ]; then
          fuzzy_match="$dirname"
        fi
      fi
    done
    if [ -n "$exact_match" ]; then
      echo "$exact_match"
      return 0
    elif [ -n "$fuzzy_match" ]; then
      echo "$fuzzy_match"
      return 0
    fi
  fi

  echo "$normalized"
}

# sanitize_title: clean up report title for filename use
sanitize_title() {
  local title="$1"

  # Remove "Report:" / "Report -" / "Report " prefix
  title=$(echo "$title" | sed -E 's/^Report[[:space:]]*[:：-][[:space:]]*//')

  # Remove dots (e.g. ".claudelaunch" → "claudelaunch")
  title=$(echo "$title" | sed 's/\.//g')

  # Make filename-safe: spaces→hyphens, remove special chars, trim length
  title=$(echo "$title" | sed 's/[[:space:]]/-/g' | sed 's/[\/\\:*?"<>|#]//g' | cut -c1-50 | sed 's/-*$//')

  echo "$title"
}

# extract_title: get title from report markdown content
extract_title() {
  local content="$1"
  local title

  title=$(echo "$content" | grep -m1 '^#' | sed -E 's/^#+[[:space:]]*//')

  # If title is generic, use first meaningful line
  if echo "$title" | grep -qiE '^(Context|Report|Summary|Overview|Introduction|Background|Task)$'; then
    title=$(echo "$content" | grep -v '^#' | grep -v '^[[:space:]]*$' | grep -v '^---' | head -1 | sed 's/^[[:space:]]*//')
  fi

  if [ -z "$title" ]; then
    title="Untitled-Report"
  fi

  sanitize_title "$title"
}

# save_to_obsidian: 3-tier save strategy (REST API → notesmd-cli → direct file write)
# Args: $1=report_file path, $2=project name (already normalized)
# Returns: 0 on success, 1 on failure
save_to_obsidian() {
  local report_file="$1"
  local project="$2"
  local report_content
  report_content=$(cat "$report_file")

  local title
  title=$(extract_title "$report_content")

  local date_prefix
  date_prefix=$(date +%Y%m%d)
  local filename="${date_prefix}_${title}.md"
  local note_path="Report/${project}/${filename}"

  log "SAVE: title=$title project=$project path=$note_path"

  # --- Strategy 1: REST API ---
  if [ -n "$OBSIDIAN_API_KEY" ] && [ -n "$OBSIDIAN_API_URL" ]; then
    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" \
      --connect-timeout 2 \
      -X PUT "${OBSIDIAN_API_URL}/vault/${note_path}" \
      -H "Authorization: Bearer ${OBSIDIAN_API_KEY}" \
      -H "Content-Type: text/plain" \
      --data-binary "@${report_file}" 2>/dev/null)

    if [ "$http_code" = "200" ] || [ "$http_code" = "204" ]; then
      log "SUCCESS (REST API): $note_path"
      echo "[obsidian-report-sync] Saved to Obsidian (REST API): ${note_path}" >&2
      verify_save "$note_path"
      return 0
    else
      log "FAIL (REST API): HTTP $http_code"
    fi
  fi

  # --- Strategy 2: notesmd-cli ---
  if command -v notesmd-cli &>/dev/null; then
    if notesmd-cli create "Report/${project}/${date_prefix}_${title}" --file "$report_file" --overwrite 2>/dev/null; then
      log "SUCCESS (notesmd-cli): $note_path"
      echo "[obsidian-report-sync] Saved to Obsidian (notesmd-cli): ${note_path}" >&2
      verify_save "$note_path"
      return 0
    else
      log "FAIL (notesmd-cli)"
    fi
  fi

  # --- Strategy 3: Direct file write ---
  local target_dir="$OBSIDIAN_VAULT/Report/${project}"
  local target_file="$target_dir/${filename}"
  if [ -d "$OBSIDIAN_VAULT" ]; then
    mkdir -p "$target_dir"
    if cp "$report_file" "$target_file" 2>/dev/null; then
      log "SUCCESS (direct write): $target_file"
      echo "[obsidian-report-sync] Saved to Obsidian (direct write): ${note_path}" >&2
      verify_save "$note_path"
      return 0
    else
      log "FAIL (direct write): could not write to $target_file"
    fi
  else
    log "FAIL (direct write): vault not found at $OBSIDIAN_VAULT"
  fi

  log "FAIL: All save strategies exhausted"
  echo "[obsidian-report-sync] Failed to save report (all methods failed)" >&2
  return 1
}

# verify_save: check file exists and is non-empty in vault
verify_save() {
  local note_path="$1"
  local full_path="$OBSIDIAN_VAULT/$note_path"
  if [ -f "$full_path" ] && [ -s "$full_path" ]; then
    log "VERIFY OK: $full_path ($(wc -c < "$full_path") bytes)"
  else
    log "VERIFY WARN: $full_path missing or empty"
  fi
}

# mark_as_saved / is_already_saved: marker file management (session-based)
mark_as_saved() {
  local session_id="$1"
  touch "$MARKER_DIR/$session_id"
  log "MARKER: created $session_id"
}

is_already_saved() {
  local session_id="$1"
  [ -f "$MARKER_DIR/$session_id" ]
}

# cleanup_old_markers: remove markers older than 7 days
cleanup_old_markers() {
  find "$MARKER_DIR" -type f -mtime +7 -delete 2>/dev/null
}
