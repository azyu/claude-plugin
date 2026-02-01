---
name: review
description: Review learned rules for duplicates, conflicts, or obsolete entries
arguments: []
---

# Review Learned Rules

<command-name>update-claude:review</command-name>

## Instructions

Review all learned rules in the project's `CLAUDE.md` and suggest improvements.

### Step 1: Load Rules

1. Read `CLAUDE.md` from the project root
2. Extract the "Learned Rules" section
3. Parse each rule with its date and text

If no rules exist, inform the user and exit.

### Step 2: Analyze Rules

Check for:

**Duplicates:**
- Rules with identical or nearly identical meaning
- Rules that cover the same scenario

**Conflicts:**
- Rules that contradict each other
- Rules with incompatible instructions

**Obsolete:**
- Rules older than 6 months (may need review)
- Rules that reference deprecated patterns or tools

**Consolidation opportunities:**
- Multiple rules that could be combined into one
- Rules that are too specific and could be generalized

### Step 3: Present Findings

Format the output:

```
🔍 Rule Review Results

## Duplicates Found (2 sets)

Set 1:
  - #3: [2024-01-10] Always run tests after changes
  - #7: [2024-02-15] Run the test suite after any modification
  → Suggest keeping: #7 (more recent, clearer)

Set 2:
  - #2: [2024-01-05] Check file exists before reading
  - #5: [2024-01-20] Verify files exist before operations
  → Suggest merging into: "Verify files exist before any file operations"

## Potential Conflicts (1)

  - #4: [2024-01-12] Always use async/await
  - #8: [2024-02-20] Prefer synchronous operations for simplicity
  → Review needed: These may apply to different contexts

## Aging Rules (3)

  - #1: [2023-06-15] Use var instead of let (180+ days old)
  → Consider: Remove or update for current best practices

## Consolidation Suggestions (1)

Rules #6, #9, #11 all relate to error handling:
  → Consider: Create a single comprehensive error handling rule

---
Apply suggestions? (all/selective/none)
```

### Step 4: Apply Changes

If user agrees to changes:

1. **all**: Apply all suggested changes automatically
2. **selective**: Present each change for individual approval
3. **none**: Exit without changes

For each applied change:
- Remove duplicate rules (keep suggested one)
- Merge similar rules
- Delete obsolete rules (with confirmation)
- Update the "Learned Rules" section

### Step 5: Confirm

After changes:

```
✅ Review complete

- Removed: 3 duplicate rules
- Merged: 2 rules into 1
- Deleted: 1 obsolete rule

Total rules: 8 → 5
```
