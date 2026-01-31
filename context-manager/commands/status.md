---
name: status
description: Check the current state of project context documentation
---

# /context:status

Display the status of the project's context documentation.

## Usage

```
/context:status
```

## Workflow

1. **Check for .context directory**
   ```bash
   if [ ! -d ".context" ]; then
     echo "❌ No .context directory found"
     echo ""
     echo "Run /context:init to initialize context documentation."
     exit 1
   fi
   ```

2. **Gather statistics**
   ```bash
   # Count documents per category
   for dir in .context/*/; do
     category=$(basename "$dir")
     count=$(find "$dir" -name "*.md" -type f | wc -l | tr -d ' ')
     echo "$category: $count documents"
   done
   ```

3. **Check semantic search status**
   ```bash
   if command -v qmd &> /dev/null; then
     if qmd list 2>/dev/null | grep -q "context"; then
       echo "🔍 Semantic search: Enabled (qmd collection: context)"
       qmd status --collection context 2>/dev/null
     else
       echo "🔍 Semantic search: qmd installed but collection not configured"
       echo "   Run: python scripts/qmd_setup.py --context-dir .context"
     fi
   else
     echo "🔍 Semantic search: Not available (install qmd for this feature)"
   fi
   ```

4. **Check for recent updates**
   ```bash
   echo ""
   echo "📅 Recently Modified (last 7 days):"
   find .context -name "*.md" -type f -mtime -7 -exec ls -la {} \; 2>/dev/null | head -10
   ```

5. **Check git status of .context**
   ```bash
   if git rev-parse --git-dir > /dev/null 2>&1; then
     echo ""
     echo "📊 Git Status:"
     git status --porcelain .context/ 2>/dev/null | head -10
   fi
   ```

## Output Example

```
📁 Context Status

Directory: .context/
Total Documents: 24

📂 Categories:
  planning/      5 documents
  architecture/  4 documents
  guides/        3 documents
  operations/    6 documents
  reference/     4 documents
  integrations/  2 documents

🔍 Semantic Search: Enabled
   Collection: context
   Documents indexed: 24
   Last updated: 2024-11-28 10:30

📅 Recently Modified (last 7 days):
  .context/planning/auth_implementation.md (2024-11-27)
  .context/operations/known_issues.md (2024-11-26)
  .context/architecture/api_design.md (2024-11-25)

📊 Git Status:
  M .context/planning/auth_implementation.md
  ?? .context/operations/new_procedures.md

💡 Tips:
  • Run /context:update to document recent changes
  • Run /context:search <query> to find relevant docs
  • Commit modified context files to preserve documentation
```

## Health Checks

The status command also performs health checks:

| Check | Status | Description |
|-------|--------|-------------|
| README exists | ✅/❌ | .context/README.md present |
| Category indexes | ✅/❌ | README.md in each category |
| No stale docs | ⚠️ | Documents >90 days old without updates |
| qmd indexed | ✅/❌ | Semantic search collection configured |
| Git tracked | ✅/❌ | .context not in .gitignore |

## Integration with Hooks

If the context-update-reminder hook is installed, you'll see:
```
🔔 Hook Status: context-update-reminder installed
   Reminder will appear when session ends with modified code files
```
