---
name: learn
description: Analyze a mistake from the conversation and create a rule to prevent it
arguments:
  - name: mistake
    description: Optional description of the mistake to learn from
    required: false
---

# Learn from Mistake

<command-name>update-claude:learn</command-name>

## Instructions

You are learning from a mistake made in this conversation. Follow these steps:

### Step 1: Identify the Mistake

If `$ARGUMENTS` is provided, use it as the mistake description. Otherwise, analyze the recent conversation to find:
- What went wrong?
- What was the incorrect action or output?
- What should have been done instead?

If no clear mistake is found, ask the user to describe what went wrong.

### Step 2: Formulate the Rule

Create a concise, actionable rule that would prevent this mistake in the future:
- Use imperative form (e.g., "Always...", "Never...", "Check... before...")
- Be specific enough to be actionable
- Be general enough to apply to similar situations
- Keep it under 2 sentences

### Step 3: Confirm with User

Present the rule to the user:

```
📝 Proposed Rule:
[Your formulated rule]

Based on: [Brief description of the mistake]

Add this rule to CLAUDE.md? (y/n)
```

Wait for user confirmation before proceeding.

### Step 4: Add to CLAUDE.md

Once confirmed, add the rule to the project's `CLAUDE.md` file:

1. Check if `CLAUDE.md` exists in the project root
2. If not, create it with the basic structure
3. Find or create the `## Learned Rules` section
4. Add the new rule with a timestamp

**Format for new rules:**
```markdown
## Learned Rules

<!-- Rules learned from past mistakes. Each rule prevents a specific type of error. -->

- [YYYY-MM-DD] [Rule text]
```

### Step 5: Confirm Success

After adding the rule, confirm:

```
✅ Rule added to CLAUDE.md

The rule will be applied in future sessions to prevent similar mistakes.
```

## Example

**Mistake:** Claude modified a file without reading it first, causing loss of existing code.

**Rule:** Always read a file's current contents before making any modifications to preserve existing code.

**CLAUDE.md entry:**
```markdown
- [2024-01-15] Always read a file's current contents before making any modifications to preserve existing code.
```
