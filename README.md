# Claude Plugin Marketplace

A collection of plugins for Claude Code.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [skill-finder](./skill-finder) | Analyze projects, search for AI skills, and install them |
| [context-manager](./context-manager) | Intelligent project context management with semantic search |
| [update-claude](./update-claude) | Learn from mistakes and update CLAUDE.md with preventive rules |
| [prompt-engineer](./prompt-engineer) | Create, optimize, debug, and analyze prompts with proven patterns and frameworks |
| [obsidian-plan-sync](./obsidian-plan-sync) | Automatically save plans to Obsidian vault on Plan Mode exit |
| [obsidian-report-sync](./obsidian-report-sync) | Automatically save session work reports to Obsidian vault |
| [obsidian-session-log](./obsidian-session-log) | Automatically log session summaries to Obsidian vault on session end |

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

### Installing Skills

After skill-finder recommends skills, install them with `npx add-skill`:

```bash
# Project scope
npx add-skill <owner/repo> --skill <skill-name>

# User scope (global)
npx add-skill <owner/repo> --skill <skill-name> -g
```

**Example:**
```bash
npx add-skill sickn33/antigravity-awesome-skills --skill code-quality
```

### Skill Sources

| Source | Skills | URL |
|--------|--------|-----|
| antigravity-awesome-skills | 238+ | https://github.com/sickn33/antigravity-awesome-skills |
| ui-ux-pro-max-skill | UI/UX | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| skills.sh | Community | https://skills.sh |

### Example & Screenshots

<img width="1000" height="460" alt="2026-01-23" src="https://github.com/user-attachments/assets/41783008-4d9d-44fd-95d0-e8a58fb7166d" />

## context-manager Usage

```bash
/context-manager:init      # Initialize .context/ directory structure
/context-manager:search    # Find relevant context documents for current task
/context-manager:update    # Update documentation from recent changes
/context-manager:status    # Show context coverage status
```

### Features

- **Auto-discovery**: Finds relevant docs based on keywords, file paths, task types
- **Semantic search**: Optional qmd integration for vector-based search
- **Documentation reminders**: Optional hooks to remind about undocumented changes

### Directory Structure

```
.context/
├── README.md           # Project overview
├── planning/           # Implementation plans, status
├── architecture/       # Design decisions, tech stack
├── feedback/           # User feedback, issues
└── reference/          # Guidelines, patterns
```

## update-claude Usage

```bash
/update-claude:learn              # Analyze conversation for mistakes
/update-claude:learn "description" # Learn from specific mistake
/update-claude:list               # Show all learned rules
/update-claude:review             # Clean up duplicates/conflicts
/update-claude:remove 3           # Remove rule by number
/update-claude:remove tests       # Remove rules matching keyword
```

### How It Works

1. **Mistake Detection**: Use `/update-claude:learn` when something goes wrong
2. **Rule Formulation**: Claude creates a concise, actionable rule
3. **Confirmation**: Approve before adding to CLAUDE.md
4. **Persistence**: Rules saved to project's CLAUDE.md
5. **Future Sessions**: Claude reads rules at session start

### Rule Format

```markdown
## Learned Rules

- [2024-01-15] Always read file contents before modifying
- [2024-01-16] Run tests after any code changes
- [2024-01-17] Check for existing implementations before creating new ones
```

## prompt-engineer Usage

```bash
/prompt-engineer:create "Write a code review prompt"   # Generate new prompt
/prompt-engineer:create "Customer support chatbot"      # Generate with CRAFT framework
/prompt-engineer:optimize                                # Optimize existing prompt
/prompt-engineer:debug                                   # Debug underperforming prompt
/prompt-engineer:analyze                                 # Analyze prompt structure
```

### CRAFT Framework

Every prompt is built using the CRAFT framework:

| Element | Description |
|---------|-------------|
| **C**ontext | Background information and constraints |
| **R**ole | AI persona and expertise level |
| **A**ction | Specific task to perform |
| **F**ormat | Output structure and format |
| **T**one | Style, voice, and communication approach |

### Workflow

1. **Analyze** - Understand task domain, complexity, and target model
2. **Design** - Apply CRAFT framework with proven patterns
3. **Generate** - Output optimized prompt with design rationale
4. **Refine** - Iterate based on feedback

## obsidian-plan-sync Usage

Automatically saves plans to your Obsidian vault when you exit Plan Mode.

### How It Works

- **PostToolUse** hook on `ExitPlanMode` — picks up the latest plan from `~/.claude/plans/`
- **Stop** hook fallback — catches plans that weren't saved during `ExitPlanMode`
- Extracts title from plan content and saves to `Plan/<date>_<title>.md` in Obsidian

### 3-Tier Save Strategy

| Priority | Method | Config |
|----------|--------|--------|
| 1 | Obsidian REST API | `OBSIDIAN_API_KEY` + `OBSIDIAN_API_URL` env vars |
| 2 | `notesmd-cli` | `brew install notesmd-cli` or `go install` |
| 3 | Direct file write | Obsidian vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault` |

### Requirements

One of the above save methods must be available.

## obsidian-report-sync Usage

Automatically saves structured work reports to Obsidian when meaningful implementation work is completed.

### How It Works

1. Session ends → prompt-based **Stop** hook fires
2. Hook LLM evaluates DoD: "Was meaningful work done?"
   - **No** (exploration/questions only) → session ends normally
   - **Yes** (code written/modified/deleted) → blocks exit, instructs report generation
3. Claude generates a structured markdown report → saves via `save-report-to-obsidian.sh`
4. Report saved to `Report/<project-name>/<YYYYMMDD>_<title>.md` in Obsidian
5. `[REPORT_SAVED]` marker output → Stop hook re-fires → approves → session ends

### Report Template

```markdown
# <Title>

## Task Summary
## Changed Files
## Key Decisions
## Test Results
## Remaining Issues
```

### Requirements

One of the following save methods:

| Method | Config |
|--------|--------|
| Obsidian REST API | `OBSIDIAN_API_KEY` + `OBSIDIAN_API_URL` env vars |
| `notesmd-cli` | `brew install notesmd-cli` |
| Direct file write | Obsidian vault at default iCloud path |

## obsidian-session-log

Automatically summarizes each Claude Code session and logs it to Obsidian on session end.

### How It Works

1. Session ends → **SessionEnd** hook runs `session-end.sh`
2. Main process reads stdin, forks background worker, exits immediately
3. Worker generates AI summary (claude CLI with sonnet) or falls back to jq extraction
4. Appends to `{FOLDER_PREFIX}/{project}/history/{YYYY-MM-DD}.md` via `obsidian` CLI
5. macOS toast notification shows result

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/azyu/claude-plugin/main/install_obsidian-session-log.sh | bash
```

### Configuration

`~/.claude/obsidian-session-log.conf`:

```bash
FOLDER_PREFIX="20_Project"    # Required — Obsidian vault folder prefix
LANG_SUMMARY="ko"             # Optional: ko | en (default: ko)
OBSIDIAN_VAULT=""              # Optional: vault name (default: CLI default)
```

### Requirements

| Dependency | Required | Notes |
|------------|----------|-------|
| `obsidian` CLI | Yes | [Obsidian CLI](https://help.obsidian.md/cli) |
| `jq` | Yes | JSON parsing + fallback summary |
| `claude` CLI | No | AI summary; falls back to jq if missing |
| Obsidian.app | Yes | Auto-launched if not running |

## License

MIT
