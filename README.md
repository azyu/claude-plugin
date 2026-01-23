# Claude Plugin Marketplace

A collection of plugins for Claude Code.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [skill-finder](./skill-finder) | Analyze projects, search for AI skills, and install them |

## Installation

### 1. Add this marketplace

```bash
/plugin marketplace add https://github.com/azyu/claude-plugin.git
```

### 2. Install a plugin

```bash
/plugin install skill-finder@claude-plugin
```

## skill-finder Usage

```
/skill-finder:search                    # Analyze project and recommend skills
/skill-finder:search React              # Search for React-related skills
/skill-finder:search UI/UX design       # Search for UI/UX design skills
/skill-finder:search test automation    # Search for testing skills
```

### Workflow

1. **Project Analysis** - Detects tech stack from config files
2. **Search** - Finds relevant skills from curated sources
3. **Recommend** - Shows top skills matching your project
4. **Install Prompt** - Asks which skill to install
5. **Scope Selection** - Choose project or user scope
6. **Install** - Downloads and installs the selected skill

### Installation Scopes

| Scope | Path | Use Case |
|-------|------|----------|
| Project | `.claude/skills/` | Project-specific skills |
| User | `~/.claude/skills/` | Global skills for all projects |

### Skill Sources

| Source | Skills | URL |
|--------|--------|-----|
| antigravity-awesome-skills | 238+ | https://github.com/sickn33/antigravity-awesome-skills |
| ui-ux-pro-max-skill | UI/UX | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| skills.sh | Community | https://skills.sh |

## License

MIT
