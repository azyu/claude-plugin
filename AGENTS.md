# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin marketplace containing the **skill-finder** plugin that analyzes projects and searches for relevant AI skills from curated sources.

## Architecture

```
claude-plugin/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace manifest listing plugins
├── skill-finder/                # Plugin directory
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/
│   │   └── search-skill/
│   │       └── SKILL.md         # Main skill definition
│   └── commands/
│       └── search.md            # /skill-finder:search command
├── README.md
└── AGENTS.md
```

### Key Components

- **marketplace.json**: Lists available plugins for Claude Code marketplace
- **plugin.json**: Defines individual plugin metadata
- **SKILL.md**: AI agent instructions for project analysis and skill installation
- **search.md**: User-facing command triggered with `$ARGUMENTS`

### Skill Sources

The skill-finder plugin searches:
1. `sickn33/antigravity-awesome-skills` - 238+ skills
2. `nextlevelbuilder/ui-ux-pro-max-skill` - UI/UX specialist
3. `skills.sh` - Community marketplace

### Workflow

1. Analyze project tech stack from config files
2. Search skill sources using WebSearch/WebFetch
3. Present recommendations
4. Ask user which skill to install (AskUserQuestion)
5. Ask installation scope (project or user)
6. Execute installation via git clone

## Plugin Development

No build step required. Pure markdown-based Claude Code plugin.

To test locally:
```bash
claude --plugin-dir /path/to/claude-plugin
```
