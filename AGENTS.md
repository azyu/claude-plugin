# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin marketplace containing plugins:
- **skill-finder**: Analyzes projects and searches for relevant AI skills from curated sources
- **plan-review-codex**: Reviews implementation plans with OpenAI Codex Agent
- **context-manager**: Intelligent project context management with semantic search
- **update-claude**: Learn from mistakes and update CLAUDE.md with preventive rules

## Architecture

```
claude-plugin/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace manifest listing plugins
├── skill-finder/                # Plugin: AI skill search
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/skill-finder/
│   │   └── SKILL.md             # Main skill definition
│   └── CLAUDE.md
├── plan-review-codex/           # Plugin: Codex plan review
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/codex-review/
│   │   └── SKILL.md             # Codex review skill
│   ├── commands/
│   │   └── plan-review.md       # /plan-review-codex:plan-review command
│   ├── README.md
│   └── CLAUDE.md
├── context-manager/             # Plugin: Context management
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/context-manager/
│   │   └── SKILL.md             # Context management skill
│   ├── commands/
│   │   ├── init.md              # /context-manager:init
│   │   ├── search.md            # /context-manager:search
│   │   ├── update.md            # /context-manager:update
│   │   └── status.md            # /context-manager:status
│   ├── scripts/                 # Python scripts
│   ├── hooks/                   # Session hooks
│   │   ├── hooks.json           # Declarative hook config
│   │   └── stop/
│   ├── README.md
│   ├── INSTALL.md
│   └── CLAUDE.md
├── update-claude/               # Plugin: Learn from mistakes
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/update-claude/
│   │   └── SKILL.md             # Update CLAUDE.md skill
│   ├── commands/
│   │   ├── learn.md             # /update-claude:learn
│   │   ├── list.md              # /update-claude:list
│   │   ├── review.md            # /update-claude:review
│   │   └── remove.md            # /update-claude:remove
│   ├── README.md
│   └── CLAUDE.md
├── README.md
└── AGENTS.md
```

### Key Components

- **marketplace.json**: Lists available plugins for Claude Code marketplace
- **plugin.json**: Defines individual plugin metadata
- **SKILL.md**: AI agent instructions for each plugin
- **CLAUDE.md**: Plugin-specific instructions at plugin root
- **hooks.json**: Declarative hook configuration

### Skill Sources

The skill-finder plugin searches:
1. `sickn33/antigravity-awesome-skills` - 238+ skills
2. `nextlevelbuilder/ui-ux-pro-max-skill` - UI/UX specialist
3. `skills.sh` - Community marketplace

### skill-finder Workflow

1. Analyze project tech stack from config files
2. Search skill sources using WebSearch/WebFetch
3. Present recommendations
4. Ask user which skill to install (AskUserQuestion)
5. Ask installation scope (project or user)
6. Execute installation via git clone

### plan-review-codex Workflow

1. Auto-detect latest plan from `~/.claude/plans/` (or specify with `-f`)
2. Send plan to OpenAI Codex CLI
3. Receive comprehensive review:
   - Feasibility analysis
   - Missing items check
   - Alternative suggestions
4. User updates plan based on feedback

### context-manager Workflow

1. Check for `.context/` directory
2. Discover relevant context documents (semantic or keyword search)
3. Load top-ranked documents into conversation
4. Execute task with context awareness
5. Update documentation after completing work

### update-claude Workflow

1. Detect mistake or issue in conversation
2. Analyze root cause
3. Formulate preventive rule
4. Add rule to project's CLAUDE.md
5. Future sessions read and follow rules

## Plugin Development

No build step required. Pure markdown-based Claude Code plugin.

To test locally:
```bash
claude --plugin-dir /path/to/claude-plugin/plugin-name
```
