---
name: create
description: Generate an optimized prompt using the CRAFT framework
arguments:
  - name: task
    description: Description of what the prompt should accomplish
    required: true
---

# Create Prompt

<command-name>prompt-engineer:create</command-name>

## Instructions

You are generating an optimized prompt for the user's task. Use the CRAFT framework and reference the prompt-engineer skill.

### Step 1: Analyze the Task

Parse `$ARGUMENTS` to understand:
- **Domain**: What field does this operate in? (code, writing, analysis, data, etc.)
- **Complexity**: Single-step or multi-step? How many decision points?
- **Target model**: Is a specific model mentioned? Default to Claude.
- **Output type**: What should the prompt produce? (text, code, data, analysis)

### Step 2: Apply CRAFT Framework

Build the prompt with each element:

1. **Context**: What background info does the model need?
2. **Role**: What expert persona should the model adopt?
3. **Action**: What specific steps should the model take?
4. **Format**: What output structure is needed?
5. **Tone**: What style is appropriate for the audience?

### Step 3: Select Structure

Choose based on complexity:
- **Plain text**: Simple single-task prompts
- **Markdown**: Moderate complexity with sections
- **XML**: Complex multi-section prompts with nested logic

### Step 4: Apply Patterns

Check `references/prompt-patterns.md` for applicable patterns:
- Does the task need Chain-of-Thought? (reasoning, analysis)
- Would Few-Shot examples help? (classification, formatting)
- Is Self-Evaluation useful? (quality-critical output)

### Step 5: Output

Present the generated prompt in a code block, followed by:

```
## Design Rationale

- **Role chosen**: [role] — [why]
- **Structure**: [format] — [why]
- **Patterns applied**: [patterns] — [why]
- **Key constraints**: [constraints] — [why they matter]
```

### Step 6: Offer Refinement

Ask if the user wants to:
- Adjust the tone or formality
- Add/remove constraints
- Target a different model
- Add few-shot examples

## Example

**Input:** `/prompt-engineer:create "Code review prompt for security issues"`

**Output:** A structured prompt with security reviewer role, OWASP-based checklist, severity rating format, and fix suggestions.
