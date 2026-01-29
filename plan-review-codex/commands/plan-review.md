---
name: plan-review
description: Review implementation plan with Codex Agent. Use after completing your plan to get feasibility analysis, missing items check, and alternative suggestions.
---

# Plan Review with Codex

Request a comprehensive review of your implementation plan from Codex Agent.

## Review Perspectives

1. **Feasibility** - Is it technically achievable? Any potential issues?
2. **Missing Items** - Are there any missing steps or considerations?
3. **Alternatives** - Are there better approaches or improvements?

## Usage

Run the script:
```bash
<plugin-dir>/scripts/plan-review.sh <arguments>
```

### Options

- (no args): Auto-detect latest file from ~/.claude/plans/
- `-f <file>` or `--file <file>`: Specify plan file path
- `-m <model>`: Specify Codex model (default: gpt-5.2-codex)

### Examples

```bash
/plan-review                                # Auto-detect
/plan-review -f ~/.claude/plans/my-plan.md  # Specify file
/plan-review -m o3                          # Use different model
```

## Workflow

1. Complete plan in Plan mode
2. Run `/plan-review` to request Codex review
3. Update plan based on feedback
4. Request user approval with ExitPlanMode
