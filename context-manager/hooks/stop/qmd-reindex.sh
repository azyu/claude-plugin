#!/bin/bash
# Hook: Auto-reindex qmd when .context files changed
# Matcher: * (runs on every session stop)
# Purpose: Keeps qmd search index up-to-date with .context changes

input=$(cat)

# Check if .context directory exists and qmd is available
if [ -d ".context" ] && command -v qmd &> /dev/null; then
  # Check if any .context/*.md files were modified
  context_changes=$(git status --porcelain 2>/dev/null | grep -E '\.context/.*\.md$' | wc -l | tr -d ' ')

  if [ "$context_changes" -gt 0 ]; then
    echo "[Hook] 🔄 Reindexing qmd ($context_changes context file(s) changed)..." >&2

    # Run qmd update and embed in background
    (qmd update --collection context 2>/dev/null && qmd embed --collection context 2>/dev/null) &

    echo "[Hook] ✓ qmd reindex started in background" >&2
  fi
fi

echo "$input"
