# codex-research Plugin

Research any topic using OpenAI Codex CLI.

## Commands

- `/codex-research:research <topic>` — Research a topic with Codex

## Skills

- `codex-researcher` — Executes Codex CLI for topic research

## File Structure

```
codex-research/
├── .claude-plugin/plugin.json      # Plugin metadata
├── commands/
│   └── research.md                 # /codex-research:research command
├── skills/codex-researcher/
│   └── SKILL.md                    # Codex research instructions
└── CLAUDE.md                       # This file
```
