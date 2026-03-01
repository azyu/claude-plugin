---
name: plan-review
description: Review implementation plan with Codex Agent. Use after completing your plan to get feasibility analysis, missing items check, and alternative suggestions.
---

# Plan Review with Codex

Review your implementation plan using OpenAI Codex Agent.

## User Request

"$ARGUMENTS"

## Instructions

Use the `codex-plan-reviewer` skill to execute the plan review process.

### Quick Reference

- `/plan-review-codex:plan-review` - Auto-detect latest plan from ~/.claude/plans/
- `/plan-review-codex:plan-review -f <path>` - Review specific plan file
- `/plan-review-codex:plan-review -m <model>` - Use different Codex model
