---
name: remove
description: Remove a specific learned rule by number or keyword
arguments:
  - name: identifier
    description: Rule number or keyword to match
    required: true
---

# Remove Learned Rule

<command-name>update-claude:remove</command-name>

## Instructions

Remove a specific rule from the "Learned Rules" section in `CLAUDE.md`.

### Step 1: Parse Identifier

The `$ARGUMENTS` can be:
- A number (e.g., `3`) - refers to the rule's position in the list
- A keyword (e.g., `tests`) - matches rules containing that word

### Step 2: Find Matching Rules

1. Read `CLAUDE.md` from the project root
2. Extract the "Learned Rules" section
3. Find rules matching the identifier:
   - If number: get the rule at that position
   - If keyword: find all rules containing the keyword (case-insensitive)

### Step 3: Confirm Deletion

If **one rule** matches:
```
🗑️ Remove this rule?

#3: [2024-01-15] Always run tests after making changes

Confirm deletion? (y/n)
```

If **multiple rules** match (keyword search):
```
🗑️ Multiple rules match "tests":

1. #3: [2024-01-15] Always run tests after making changes
2. #7: [2024-02-10] Check test coverage before committing
3. #12: [2024-03-05] Write tests for new functions

Which to remove? (1/2/3/all/none)
```

If **no rules** match:
```
❌ No rules found matching "$ARGUMENTS"

Use /update-claude:list to see all rules.
```

### Step 4: Remove Rule

Once confirmed:
1. Remove the matching line(s) from the "Learned Rules" section
2. Update `CLAUDE.md`

### Step 5: Confirm Success

```
✅ Rule removed

Deleted: [2024-01-15] Always run tests after making changes

Remaining rules: 11
```

## Examples

```bash
# Remove by number
/update-claude:remove 3

# Remove by keyword
/update-claude:remove tests

# Remove multiple
/update-claude:remove async
```
