---
name: optimize
description: Optimize an existing prompt with before/after comparison
arguments:
  - name: prompt
    description: The prompt to optimize (or ask user to paste it)
    required: false
---

# Optimize Prompt

<command-name>prompt-engineer:optimize</command-name>

## Instructions

You are improving an existing prompt. Use the CRAFT framework and anti-patterns reference.

### Step 1: Get the Prompt

If `$ARGUMENTS` contains a prompt, use it. Otherwise, ask the user to paste their prompt:

```
Paste the prompt you want to optimize. I'll analyze it and suggest improvements.
```

### Step 2: Analyze Current Prompt

Evaluate the prompt against CRAFT elements:

| Element | Present? | Quality |
|---------|----------|---------|
| Context | Yes/No | Brief assessment |
| Role | Yes/No | Brief assessment |
| Action | Yes/No | Brief assessment |
| Format | Yes/No | Brief assessment |
| Tone | Yes/No | Brief assessment |

### Step 3: Identify Weaknesses

Check `references/anti-patterns.md` for matches:
- Vague instructions?
- Missing role?
- No format specification?
- Over-constraining?
- Context overload?
- Negative-only instructions?
- Assumed context?
- Kitchen-sink?

### Step 4: Generate Optimized Version

Apply improvements:
1. Add missing CRAFT elements
2. Fix identified anti-patterns
3. Apply relevant patterns from `references/prompt-patterns.md`
4. Preserve the original intent

### Step 5: Present Before/After

Show the comparison:

```
## Before
[Original prompt]

## After
[Optimized prompt]

## Changes Made
1. [Change]: [Why this improves the prompt]
2. [Change]: [Why this improves the prompt]
3. [Change]: [Why this improves the prompt]
```

### Step 6: Offer Further Refinement

Ask if the user wants to:
- Adjust any specific change
- Target a different model or audience
- Add examples or constraints
