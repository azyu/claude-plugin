---
name: research
description: Research any topic using OpenAI Codex CLI. Produces a structured report with findings, analysis, and recommendations.
arguments:
  - name: topic
    description: The topic or question to research (supports -m model, -d for deep mode)
    required: true
---

# Codex Research

<command-name>codex-research:research</command-name>

Research a topic using OpenAI Codex Agent.

## User Request

"$ARGUMENTS"

## Instructions

**IMPORTANT: Do NOT use the Agent tool. Do NOT invoke any subagent.**

Directly invoke the `codex-research:codex-researcher` skill using the Skill tool NOW. Pass the user's arguments through. This skill handles everything — no agent delegation needed.

### Quick Reference

- `/codex-research:research <topic>` — Research any topic
- `/codex-research:research -d <topic>` — Deep research mode
- `/codex-research:research -m <model> <topic>` — Use specific Codex model
