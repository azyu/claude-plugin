# plan-review-codex Plugin

Review implementation plans with OpenAI Codex Agent.

## Commands

- `/plan-review-codex:plan-review` - Review plan with Codex Agent

## Skills

- `codex-review` - Reviews code changes or plans with Codex

## File Structure

```
plan-review-codex/
├── .claude-plugin/plugin.json  # Plugin metadata
├── commands/                   # User-invocable commands
│   └── plan-review.md         # /plan-review-codex:plan-review command
├── skills/codex-review/       # AI agent skill
│   └── SKILL.md               # Codex review instructions
└── CLAUDE.md                  # This file
```
