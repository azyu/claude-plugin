---
name: analyze
description: Score and evaluate a prompt's structure and quality
arguments:
  - name: prompt
    description: The prompt to analyze (or ask user to paste it)
    required: false
---

# Analyze Prompt

<command-name>prompt-engineer:analyze</command-name>

## Instructions

You are evaluating a prompt's quality across multiple dimensions.

### Step 1: Get the Prompt

If `$ARGUMENTS` contains a prompt, use it. Otherwise, ask the user to paste it:

```
Paste the prompt you want to analyze. I'll evaluate its structure, identify strengths and weaknesses, and suggest improvements.
```

### Step 2: Multi-Dimensional Scoring

Score each dimension from 1-10:

| Dimension | Score | Assessment |
|-----------|-------|------------|
| **Clarity** | /10 | Can the task be interpreted only one way? |
| **Specificity** | /10 | Are requirements concrete and measurable? |
| **Structure** | /10 | Is the prompt well-organized and scannable? |
| **Role Definition** | /10 | Is the AI persona appropriate and well-defined? |
| **Format Spec** | /10 | Is the expected output format clear? |
| **Constraints** | /10 | Are boundaries appropriate (not too few, not too many)? |
| **Overall** | /10 | Weighted average |

### Step 3: Anti-Pattern Check

Scan against `references/anti-patterns.md`:

```
## Anti-Pattern Scan

✅ No vague instructions
❌ Missing role definition — the prompt doesn't specify expertise
✅ Format is specified
⚠️ Minor: 2 constraints may conflict
```

### Step 4: Strengths and Weaknesses

```
## Strengths
- [Specific strength with evidence from the prompt]
- [Specific strength]

## Weaknesses
- [Specific weakness with explanation of impact]
- [Specific weakness]
```

### Step 5: Pattern Recommendations

Based on the task type, suggest applicable patterns from `references/prompt-patterns.md`:

```
## Recommended Patterns
- **[Pattern name]**: [Why it would help this prompt]
- **[Pattern name]**: [Why it would help this prompt]
```

### Step 6: Model Compatibility

Assess how well the prompt works across models:

```
## Model Compatibility
- **Claude**: [assessment]
- **GPT**: [assessment]
- **Gemini**: [assessment]
```

### Step 7: Improvement Suggestions

Provide 3 concrete, prioritized improvements:

```
## Top Improvements (Priority Order)

1. **[Change]** (Impact: High)
   Current: [what's there now]
   Suggested: [what to change]
   Why: [expected impact]

2. **[Change]** (Impact: Medium)
   ...

3. **[Change]** (Impact: Low)
   ...
```
