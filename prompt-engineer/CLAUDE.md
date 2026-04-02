# prompt-engineer Plugin

Create, optimize, debug, and analyze prompts with proven patterns and frameworks.

## Commands

- `/prompt-engineer:create` — Create a new prompt using CRAFT framework
- `/prompt-engineer:optimize` — Optimize an existing prompt
- `/prompt-engineer:debug` — Debug a prompt that isn't working as expected
- `/prompt-engineer:analyze` — Analyze a prompt's structure and effectiveness

## Skills

- `prompt-engineer` — CRAFT framework expertise (Context, Role, Action, Format, Tone)

## File Structure

```
prompt-engineer/
├── .claude-plugin/plugin.json      # Plugin metadata
├── commands/
│   ├── create.md                   # /prompt-engineer:create
│   ├── optimize.md                 # /prompt-engineer:optimize
│   ├── debug.md                    # /prompt-engineer:debug
│   └── analyze.md                  # /prompt-engineer:analyze
├── skills/prompt-engineer/
│   └── SKILL.md                    # CRAFT framework instructions
├── references/
│   ├── prompt-patterns.md          # Proven pattern catalog
│   └── anti-patterns.md            # Common mistakes and fixes
├── README.md
└── CLAUDE.md                       # This file
```
