---
name: update
description: Update or create context documentation
arguments:
  - name: category
    description: Document category (planning, architecture, guides, operations, reference, integrations)
    required: true
  - name: file
    description: Filename for the document
    required: true
  - name: summary
    description: Summary of the content to add/update
    required: true
---

# /context:update

Update an existing context document or create a new one.

## Usage

```
/context:update --category <category> --file <filename> --summary "<content>"
```

## Examples

```
/context:update --category planning --file auth_implementation.md --summary "Completed JWT authentication with refresh token support"

/context:update --category operations --file known_issues.md --summary "Fixed: Session timeout causing logout loop - root cause was stale Redis cache"

/context:update --category architecture --file api_design.md --summary "Added rate limiting middleware to all public endpoints"
```

## Workflow

1. **Validate category**
   ```bash
   VALID_CATEGORIES="planning architecture guides operations reference integrations agents monitoring security vision idea"
   if ! echo "$VALID_CATEGORIES" | grep -qw "$CATEGORY"; then
     echo "⚠️ Non-standard category: $CATEGORY"
     echo "Standard categories: $VALID_CATEGORIES"
     # Proceed anyway - allow custom categories
   fi
   ```

2. **Execute update**
   ```bash
   python "$PLUGIN_DIR/scripts/update_context.py" \
     --context-dir .context \
     --category "$CATEGORY" \
     --file "$FILE" \
     --summary "$SUMMARY" \
     --action update \
     --update-index
   ```

3. **Handle creation vs update**
   - If file exists: Append update with timestamp
   - If file doesn't exist: Create new document with template

4. **Display result**
   ```
   ✅ Context Updated

   📄 File: .context/planning/auth_implementation.md
   📁 Category: planning
   🕐 Updated: 2024-11-28 14:30

   Changes:
   - Added section: "Update - 2024-11-28 14:30"
   - Content: Completed JWT authentication with refresh token support

   📋 Category Index: Updated
   ```

5. **Optional: Trigger qmd reindex**
   ```bash
   if command -v qmd &> /dev/null; then
     qmd update --collection context &
     echo "🔄 Semantic index update started in background"
   fi
   ```

## Document Templates

### New Document (auto-generated)
```markdown
# [Title from filename]

**Category**: [category]
**Created**: [date]

## Overview

[summary]

## Status

- [ ] In Progress

## Related Documents

- [README](../README.md)

---

*This document is maintained as part of the project context system.*
```

### Update Format (appended)
```markdown
## Update - [timestamp]

[summary]
```

## Options

| Option | Description |
|--------|-------------|
| `--category` | Target category directory |
| `--file` | Document filename (auto-adds .md if missing) |
| `--summary` | Content to add |
| `--section` | Update specific section (optional) |
| `--prepend` | Add to beginning instead of end (optional) |
| `--update-index` | Update category README.md (default: true) |

## Best Practices

- **Prefer updating** existing documents over creating new ones
- **Use descriptive filenames**: `auth_jwt_implementation.md` > `auth.md`
- **Include context**: Why was this change made?
- **Link related docs**: Reference architecture decisions, related features
- **Use git for versioning**: Don't add dates to filenames
