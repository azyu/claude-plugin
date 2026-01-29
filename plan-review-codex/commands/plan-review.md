---
name: plan-review
description: Review implementation plan with Codex Agent. Use after completing your plan to get feasibility analysis, missing items check, and alternative suggestions.
---

# Plan Review with Codex

Review your implementation plan using OpenAI Codex Agent.

## User Request

"$ARGUMENTS"

## Instructions

Use the `codex-review` skill to execute the plan review process.

### Quick Reference

- `/plan-review` - Auto-detect latest plan from ~/.claude/plans/
- `/plan-review -f <path>` - Review specific plan file
- `/plan-review -m <model>` - Use different Codex model

### Execution

Run the review script:

```bash
<plugin-dir>/scripts/plan-review.sh $ARGUMENTS
```

Report the results organized by Feasibility, Missing Items, and Alternatives.
