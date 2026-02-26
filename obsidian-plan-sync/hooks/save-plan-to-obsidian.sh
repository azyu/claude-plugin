#!/bin/bash
# Hook: Save plan to Obsidian vault on ExitPlanMode (PostToolUse)
# Uses shared _lib.sh for save logic, marker management, and verification

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_lib.sh"

input=$(cat)

log "==============================="
log "=== ExitPlanMode hook triggered ==="
log "PID: $$"
log "PWD: $(pwd)"
log "Input length: ${#input}"

# Find the most recently modified plan file
plan_file=$(ls -t "$PLANS_DIR"/*.md 2>/dev/null | head -1)

log "Plan file: $plan_file"

if [ -z "$plan_file" ]; then
  log "ABORT: No plan file found"
  echo "[obsidian-plan-sync] No plan file found in $PLANS_DIR" >&2
  echo "$input"
  exit 0
fi

# Check if already saved (e.g. rapid re-trigger)
if is_already_saved "$plan_file"; then
  log "SKIP: Already saved (marker exists for $(basename "$plan_file"))"
  echo "$input"
  exit 0
fi

# Detect and normalize project name
project_raw=$(basename "$(pwd)")
project=$(normalize_project_name "$project_raw")
log "Project: raw=$project_raw normalized=$project"

# Save + mark + verify
if save_to_obsidian "$plan_file" "$project"; then
  mark_as_saved "$plan_file"
  log "ExitPlanMode save complete"
else
  log "ExitPlanMode save FAILED"
fi

log "=== ExitPlanMode hook complete ==="
log ""
echo "$input"
