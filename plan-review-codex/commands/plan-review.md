---
name: plan-review
description: Review implementation plan with Codex Agent. Use after completing your plan to get feasibility analysis, missing items check, and alternative suggestions.
---

# Plan Review with Codex

<command-name>plan-review-codex:plan-review</command-name>

Review your implementation plan using OpenAI Codex Agent.

## User Request

"$ARGUMENTS"

## Instructions

Invoke the `plan-review-codex:codex-plan-reviewer` skill using the Skill tool to execute the plan review process. Pass the user's arguments through.

### Quick Reference

- `/plan-review-codex:plan-review` - Auto-detect latest plan from ~/.claude/plans/
- `/plan-review-codex:plan-review -f <path>` - Review specific plan file
- `/plan-review-codex:plan-review -m <model>` - Use different Codex model
