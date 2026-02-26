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

# 3. Find plan files modified during this session
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  plan_file=$(find "$PLANS_DIR" -name "*.md" -newer "$transcript_path" -type f 2>/dev/null | sort -t/ -k1 | tail -1)
else
  # Fallback: most recently modified plan (within last 2 hours)
  plan_file=$(find "$PLANS_DIR" -name "*.md" -type f -mmin -120 2>/dev/null | xargs ls -t 2>/dev/null | head -1)
  log "STOP: No transcript_path, using recency fallback"
fi

log "STOP: plan_file=$plan_file"

if [ -z "$plan_file" ]; then
  log "STOP: No plan file found for this session, skipping"
  echo "$input"
  exit 0
fi

# 4. Check if already saved (marker exists)
if is_already_saved "$plan_file"; then
  log "STOP: Already saved (marker exists for $(basename "$plan_file")), skipping"
  echo "$input"
  exit 0
fi

# 5. Determine project name
project_raw=""
if [ -n "$cwd" ]; then
  project_raw=$(basename "$cwd")
else
  project_raw=$(basename "$(pwd)")
fi
project=$(normalize_project_name "$project_raw")
log "STOP: project_raw=$project_raw project=$project"

# 6. Save + mark
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
