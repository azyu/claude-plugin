#!/bin/bash
# Hook: Context update reminder
# Matcher: * (runs on every session stop)
# Purpose: Reminds to update .context/ if significant work was done

input=$(cat)

# Check if we're in a git repo with .context directory
if [ -d ".context" ] && git rev-parse --git-dir > /dev/null 2>&1; then
  # Check if any code files were modified
  modified_files=$(git diff --name-only HEAD 2>/dev/null | grep -E '\.(ts|tsx|js|jsx|py|go|rs|java)$' | wc -l | tr -d ' ')

  if [ "$modified_files" -gt 0 ]; then
    echo "" >&2
    echo "┌────────────────────────────────────────────────────────┐" >&2
    echo "│  📝 Context Update Reminder                            │" >&2
    echo "├────────────────────────────────────────────────────────┤" >&2
    echo "│  $modified_files code file(s) modified in this session.         │" >&2
    echo "│                                                        │" >&2
    echo "│  Consider documenting significant changes:             │" >&2
    echo "│  • Architecture decisions → .context/architecture/     │" >&2
    echo "│  • Implementation status  → .context/planning/         │" >&2
    echo "│  • Known issues/fixes     → .context/operations/       │" >&2
    echo "│                                                        │" >&2
    echo "│  Use: /context:update --category <cat> --file <name>   │" >&2
    echo "│       --summary \"<description>\"                        │" >&2
    echo "└────────────────────────────────────────────────────────┘" >&2
  fi
fi

echo "$input"
