---
name: list
description: Display all learned rules from the current project's CLAUDE.md
arguments: []
---

# List Learned Rules

<command-name>update-claude:list</command-name>

## Instructions

Display all rules from the "Learned Rules" section in the project's `CLAUDE.md` file.

### Step 1: Find CLAUDE.md

Look for `CLAUDE.md` in the project root directory.

### Step 2: Extract Rules

If `CLAUDE.md` exists:
1. Find the `## Learned Rules` section
2. Extract all rules (lines starting with `- [`)
3. Parse each rule to extract:
   - Date (from `[YYYY-MM-DD]`)
   - Rule text

If no `CLAUDE.md` or no "Learned Rules" section exists, inform the user.

### Step 3: Display Rules

Format the output:

```
📋 Learned Rules (N total)

1. [2024-01-15] Always read a file before modifying it
2. [2024-01-16] Run tests after making changes
3. [2024-01-17] Check for existing implementations before creating new ones

Use /update-claude:remove <number> to delete a rule.
Use /update-claude:review to clean up and organize rules.
```

If no rules exist:
```
📋 No learned rules yet.

Use /update-claude:learn to add rules from mistakes.
```

## Notes

- Rules are displayed in the order they appear in CLAUDE.md
- The number corresponds to the rule's position, useful for /update-claude:remove
