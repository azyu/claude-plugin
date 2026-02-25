---
name: debug
description: Diagnose and fix an underperforming prompt
arguments:
  - name: context
    description: Optional context about the problem
    required: false
---

# Debug Prompt

<command-name>prompt-engineer:debug</command-name>

## Instructions

You are diagnosing why a prompt produces incorrect or unexpected output.

### Step 1: Gather Information

Ask the user for (if not provided in `$ARGUMENTS`):

1. **The prompt**: The exact prompt being used
2. **Expected output**: What should the model produce?
3. **Actual output**: What is the model actually producing?
4. **Model**: Which model is being used? (optional)

```
To debug your prompt, I need:
1. The prompt (paste it below)
2. What output you expected
3. What output you actually got
```

### Step 2: Identify Failure Mode

Classify the problem:

| Failure Mode | Symptoms |
|-------------|----------|
| **Hallucination** | Model invents facts, cites nonexistent sources |
| **Misalignment** | Output is coherent but doesn't match intent |
| **Format drift** | Content is correct but structure is wrong |
| **Scope creep** | Output addresses more than asked |
| **Undershoot** | Output is too brief or shallow |
| **Contradiction** | Output conflicts with instructions |
| **Refusal** | Model declines to answer |

### Step 3: Root Cause Diagnosis

Walk through the debugging checklist from the skill:

1. Role mismatch?
2. Ambiguous action?
3. Missing context?
4. Format confusion?
5. Conflicting instructions?
6. Implicit assumptions?
7. Scope creep?
8. Negative instructions?

### Step 4: Present Diagnosis

```
## Diagnosis

**Failure mode**: [identified mode]
**Root cause**: [specific cause]
**Evidence**: [what in the prompt causes this]

## Original Prompt
[the prompt with problematic sections highlighted]

## Fixed Prompt
[corrected prompt]

## What Changed
1. [Fix]: [Why this addresses the root cause]
2. [Fix]: [Why this addresses the root cause]
```

### Step 5: Suggest Testing

Recommend how to verify the fix:
- Specific test inputs to try
- Edge cases to watch for
- Signs that the fix is working
- Fallback strategies if the fix doesn't fully resolve the issue
