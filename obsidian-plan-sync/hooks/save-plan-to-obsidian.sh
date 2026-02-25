#!/bin/bash
# Hook: Save plan to Obsidian vault on ExitPlanMode
# Strategy: REST API (env vars) → notesmd-cli fallback

input=$(cat)

# Debug logging
DEBUG_LOG="$HOME/.claude/obsidian-plan-sync.log"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG"; }
log "==============================="
log "=== Hook triggered ==="
log "PID: $$"
log "PWD: $(pwd)"
log "Input length: ${#input}"
log "Input first 200 chars: ${input:0:200}"
log "OBSIDIAN_API_KEY set: $([ -n "$OBSIDIAN_API_KEY" ] && echo 'yes' || echo 'no')"
log "OBSIDIAN_API_URL set: $([ -n "$OBSIDIAN_API_URL" ] && echo 'yes' || echo 'no')"
log "OBSIDIAN_API_URL value: ${OBSIDIAN_API_URL:-<unset>}"
log "notesmd-cli available: $(command -v notesmd-cli &>/dev/null && echo 'yes' || echo 'no')"

# Find the most recently modified plan file
PLANS_DIR="$HOME/.claude/plans"
plan_file=$(ls -t "$PLANS_DIR"/*.md 2>/dev/null | head -1)

log "Plans dir exists: $([ -d "$PLANS_DIR" ] && echo 'yes' || echo 'no')"
log "Plans dir contents: $(ls -la "$PLANS_DIR"/*.md 2>&1 | head -5)"
log "Plan file: $plan_file"

if [ -z "$plan_file" ]; then
  log "ABORT: No plan file found"
  echo "[obsidian-plan-sync] No plan file found in $PLANS_DIR" >&2
  echo "$input"
  exit 0
fi

plan_content=$(cat "$plan_file")
log "Plan content length: ${#plan_content}"
log "Plan first line: $(echo "$plan_content" | head -1)"

# Extract title from first heading (use -E for extended regex on macOS)
title=$(echo "$plan_content" | grep -m1 '^#' | sed -E 's/^#+[[:space:]]*//')

# If title is generic, use first meaningful line instead
if echo "$title" | grep -qiE '^(Context|Plan|Summary|Overview|Introduction|Background)$'; then
  title=$(echo "$plan_content" | grep -v '^#' | grep -v '^[[:space:]]*$' | grep -v '^---' | head -1 | sed 's/^[[:space:]]*//')
fi

if [ -z "$title" ]; then
  title="Untitled-Plan"
fi

# Make title filename-safe
title=$(echo "$title" | sed 's/[[:space:]]/-/g' | sed 's/[\/\\:*?"<>|#]//g' | cut -c1-50 | sed 's/-*$//')

# Detect project name from working directory
project=$(basename "$(pwd)")

date_prefix=$(date +%Y%m%d)
filename="${date_prefix}_${title}.md"
note_path="Plan/${project}/${filename}"
saved=false
log "Title: $title | Project: $project | Path: $note_path"

# --- Strategy 1: REST API ---
if [ -n "$OBSIDIAN_API_KEY" ] && [ -n "$OBSIDIAN_API_URL" ]; then
  http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 2 \
    -X PUT "${OBSIDIAN_API_URL}/vault/${note_path}" \
    -H "Authorization: Bearer ${OBSIDIAN_API_KEY}" \
    -H "Content-Type: text/plain" \
    --data-binary "@${plan_file}" 2>/dev/null)

  if [ "$http_code" = "200" ] || [ "$http_code" = "204" ]; then
    log "SUCCESS (REST API): $note_path"
    echo "[obsidian-plan-sync] Saved to Obsidian (REST API): ${note_path}" >&2
    saved=true
  else
    log "FAIL (REST API): HTTP $http_code"
    echo "[obsidian-plan-sync] REST API failed (HTTP ${http_code}), trying notesmd-cli..." >&2
  fi
fi

# --- Strategy 2: notesmd-cli ---
if [ "$saved" = false ] && command -v notesmd-cli &>/dev/null; then
  if notesmd-cli create "Plan/${project}/${date_prefix}_${title}" --content "$plan_content" --overwrite 2>/dev/null; then
    log "SUCCESS (notesmd-cli): $note_path"
    echo "[obsidian-plan-sync] Saved to Obsidian (notesmd-cli): ${note_path}" >&2
    saved=true
  else
    log "FAIL (notesmd-cli)"
    echo "[obsidian-plan-sync] notesmd-cli failed to save plan" >&2
  fi
fi

if [ "$saved" = false ]; then
  log "FAIL: No method available"
  echo "[obsidian-plan-sync] No method available (set OBSIDIAN_API_KEY/URL or install notesmd-cli)" >&2
fi

log "saved: $saved"
log "=== Hook complete ==="
log ""
echo "$input"
