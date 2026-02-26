#!/bin/bash
# Hook: Stop fallback — save unsaved plan to Obsidian when session ends
# This catches plans missed by ExitPlanMode (plan approved → execution → exit)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_lib.sh"

input=$(cat)

log "==============================="
log "=== STOP hook triggered ==="

# 1. Extract transcript_path and cwd from stdin JSON
transcript_path=""
cwd=""
if command -v jq &>/dev/null; then
  transcript_path=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
  cwd=$(echo "$input" | jq -r '.cwd // empty' 2>/dev/null)
elif command -v python3 &>/dev/null; then
  transcript_path=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('transcript_path',''))" 2>/dev/null)
  cwd=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null)
fi

log "STOP: transcript_path=$transcript_path"
log "STOP: cwd=$cwd"

# 2. Clean up old markers
cleanup_old_markers

# 3. Find unsaved plan files from this session
# Use transcript birth time (session start) as baseline, not mtime (constantly updated)
session_start=""
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # macOS: birth time via stat -f %B (epoch seconds)
  session_start=$(stat -f %B "$transcript_path" 2>/dev/null)
fi

if [ -n "$session_start" ]; then
  # Find plan files modified after session start (birth time of transcript)
  # Create a temp reference file with the session start timestamp
  ref_file=$(mktemp)
  touch -t "$(date -r "$session_start" +%Y%m%d%H%M.%S)" "$ref_file"
  plan_file=$(find "$PLANS_DIR" -name "*.md" -newer "$ref_file" -type f 2>/dev/null | xargs ls -t 2>/dev/null | head -1)
  rm -f "$ref_file"
  log "STOP: Using transcript birth time ($session_start) as session start"
else
  # Fallback: most recently modified plan (within last 2 hours)
  plan_file=$(find "$PLANS_DIR" -name "*.md" -type f -mmin -120 2>/dev/null | xargs ls -t 2>/dev/null | head -1)
  log "STOP: No transcript birth time, using recency fallback"
fi

log "STOP: session plan_file=$plan_file"

# 4. If no session-scoped plan found, fallback: find most recent unsaved plan (within 2h)
if [ -z "$plan_file" ]; then
  log "STOP: No session-scoped plan, trying unsaved-recent fallback"
  for candidate in $(find "$PLANS_DIR" -name "*.md" -type f -mmin -120 2>/dev/null | xargs ls -t 2>/dev/null); do
    if ! is_already_saved "$candidate"; then
      plan_file="$candidate"
      log "STOP: Found unsaved recent plan: $(basename "$candidate")"
      break
    fi
  done
fi

if [ -z "$plan_file" ]; then
  log "STOP: No unsaved plan file found, skipping"
  echo "$input"
  exit 0
fi

# 5. Check if already saved (marker exists) — for session-scoped hits
if is_already_saved "$plan_file"; then
  log "STOP: Already saved (marker exists for $(basename "$plan_file")), skipping"
  echo "$input"
  exit 0
fi

# 6. Determine project name
project_raw=""
if [ -n "$cwd" ]; then
  project_raw=$(basename "$cwd")
else
  project_raw=$(basename "$(pwd)")
fi
project=$(normalize_project_name "$project_raw")
log "STOP: project_raw=$project_raw project=$project"

# 7. Save + mark
log "STOP: Saving fallback plan..."
if save_to_obsidian "$plan_file" "$project"; then
  mark_as_saved "$plan_file"
  log "STOP: Fallback save complete"
else
  log "STOP: Fallback save FAILED"
fi

log "=== STOP hook complete ==="
log ""
echo "$input"
