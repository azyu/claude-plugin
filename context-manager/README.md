# Context Manager Plugin

Intelligent project context management with semantic search support for Claude Code.

## Overview

The Context Manager plugin helps you maintain project documentation in a structured `.context/` directory and provides intelligent discovery of relevant documents based on your current task.

### Key Features

- **Automatic Context Discovery**: Finds relevant documentation based on keywords, file paths, and task types
- **Semantic Search**: Uses qmd for vector-based search (optional, falls back to keyword matching)
- **Smart Updates**: Creates and updates documentation with proper categorization
- **Session Reminders**: Hooks remind you to document significant changes

## Installation

### Via Plugin Directory

```bash
# Clone the plugin repository
git clone https://github.com/azyu/claude-plugin.git

# Use the plugin
claude --plugin-dir /path/to/claude-plugin/context-manager
```

### Manual Installation

Copy the following to your Claude installation:
- `commands/` → `~/.claude/commands/context/`
- `skills/context-manager/` → `~/.claude/skills/`
- `scripts/` → `~/.claude/skills/context-manager/scripts/`

See [INSTALL.md](INSTALL.md) for detailed instructions.

## Commands

| Command | Description |
|---------|-------------|
| `/context:init` | Initialize `.context/` directory structure |
| `/context:search <query>` | Search for relevant context documents |
| `/context:update --category <cat> --file <name> --summary "<text>"` | Update or create documentation |
| `/context:status` | Show context directory status |

## Quick Start

### 1. Initialize Context

```bash
/context:init
```

This creates a `.context/` directory with standard categories:
- `planning/` - Implementation plans, roadmaps
- `architecture/` - System design, technical decisions
- `guides/` - Getting started, tutorials
- `operations/` - Deployment, troubleshooting
- `reference/` - API docs, specifications
- `integrations/` - External service setup

### 2. Search Context

```bash
# Keyword search
/context:search authentication OAuth

# Natural language (with qmd)
/context:search "how do I set up user login?"
```

### 3. Update Context

```bash
/context:update --category planning --file auth_feature.md --summary "Completed JWT authentication with refresh tokens"
```

### 4. Check Status

```bash
/context:status
```

## Semantic Search (qmd)

For enhanced search capabilities, install [qmd](https://github.com/qmd-project/qmd):

```bash
pip install qmd
```

Then set up the context collection:

```bash
python scripts/qmd_setup.py --context-dir .context
```

### How It Works

| Feature | Without qmd | With qmd |
|---------|-------------|----------|
| Search Method | Keyword matching | Vector similarity |
| Query Style | Exact keywords | Natural language |
| Results | File/category matches | Semantic relevance |
| Index | None (on-the-fly) | Pre-computed embeddings |

## Directory Structure

```
context-manager/
├── .claude-plugin/
│   └── plugin.json         # Plugin metadata
├── commands/
│   ├── init.md             # /context:init
│   ├── search.md           # /context:search
│   ├── update.md           # /context:update
│   └── status.md           # /context:status
├── skills/
│   └── context-manager/
│       └── SKILL.md        # AI agent skill definition
├── scripts/
│   ├── find_context.py     # Document search
│   ├── update_context.py   # Document updates
│   └── qmd_setup.py        # qmd collection setup
├── hooks/
│   ├── stop/
│   │   ├── context-update-reminder.sh
│   │   └── qmd-reindex.sh
│   └── README.md           # Hook installation guide
├── references/
│   └── context_patterns.md # Best practices
├── README.md
└── INSTALL.md
```

## Context Categories

| Category | Purpose | Example Files |
|----------|---------|---------------|
| `planning/` | Plans, roadmaps, status | `implementation_plan.md`, `roadmap.md` |
| `architecture/` | Design, decisions | `system_design.md`, `adr/` |
| `guides/` | Tutorials, setup | `getting_started.md`, `dev_setup.md` |
| `operations/` | Ops, troubleshooting | `deployment.md`, `known_issues.md` |
| `reference/` | API, CLI docs | `api_reference.md`, `cli_guide.md` |
| `integrations/` | External services | `github_oauth.md`, `stripe_setup.md` |

## Hooks (Optional)

The plugin includes optional hooks that can remind you to update documentation:

- **context-update-reminder**: Shows a reminder when code files are modified
- **qmd-reindex**: Automatically reindexes qmd when context files change

See [hooks/README.md](hooks/README.md) for installation instructions.

## Best Practices

### DO

- ✅ Run `/context:search` before starting major work
- ✅ Update context after completing significant features
- ✅ Use categories consistently
- ✅ Keep documents focused and concise
- ✅ Cross-reference related documents

### DON'T

- ❌ Skip context loading to save time
- ❌ Create duplicate documentation
- ❌ Use date-based filenames (git tracks history)
- ❌ Load entire `.context/` directory at once

## Requirements

- Python 3.8+
- Git (for hooks)
- qmd (optional, for semantic search)

## License

MIT
