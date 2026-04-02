# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin marketplace containing plugins:
- **skill-finder**: Analyzes projects and searches for relevant AI skills from curated sources
- **plan-review-codex**: Reviews implementation plans with OpenAI Codex Agent
- **context-manager**: Intelligent project context management with semantic search
- **update-claude**: Learn from mistakes and update CLAUDE.md with preventive rules
- **prompt-engineer**: Create, optimize, debug, and analyze prompts with proven patterns and frameworks
- **obsidian-plan-sync**: Automatically saves plans to Obsidian vault on Plan Mode exit
- **obsidian-report-sync**: Automatically saves session work reports to Obsidian vault
- **obsidian-session-log**: Automatically logs session summaries to Obsidian vault on session end
- **codex-research**: Research any topic using OpenAI Codex CLI

## Architecture

```
claude-plugin/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace manifest listing plugins
├── skill-finder/                # Plugin: AI skill search
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/search-skill/
│   │   └── SKILL.md             # Main skill definition
│   └── CLAUDE.md
├── plan-review-codex/           # Plugin: Codex plan review
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/codex-plan-reviewer/
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
├── prompt-engineer/             # Plugin: Prompt engineering
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── skills/prompt-engineer/
│   │   └── SKILL.md             # CRAFT framework expertise
│   ├── commands/
│   │   ├── create.md            # /prompt-engineer:create
│   │   ├── optimize.md          # /prompt-engineer:optimize
│   │   ├── debug.md             # /prompt-engineer:debug
│   │   └── analyze.md           # /prompt-engineer:analyze
│   ├── references/
│   │   ├── prompt-patterns.md   # Proven pattern catalog
│   │   └── anti-patterns.md     # Common mistakes and fixes
│   ├── README.md
│   └── CLAUDE.md
├── obsidian-plan-sync/            # Plugin: Plan → Obsidian sync
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── hooks/
│   │   ├── hooks.json             # PostToolUse(ExitPlanMode) + Stop fallback
│   │   ├── _lib.sh                # Shared save utilities
│   │   ├── save-plan-to-obsidian.sh
│   │   └── stop-save-plan-to-obsidian.sh
│   └── CLAUDE.md
├── obsidian-report-sync/          # Plugin: Report → Obsidian sync
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── hooks/
│   │   ├── hooks.json             # Prompt-based Stop hook (DoD evaluation)
│   │   ├── _lib.sh                # Shared save utilities
│   │   └── save-report-to-obsidian.sh
│   └── CLAUDE.md
├── obsidian-session-log/          # Plugin: Session → Obsidian log
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── hooks/
│   │   └── hooks.json             # SessionEnd hook
│   ├── scripts/
│   │   └── session-end.sh         # Background worker: AI summary + obsidian CLI
│   └── CLAUDE.md
├── codex-research/                # Plugin: Codex topic research
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/
│   │   └── research.md            # /codex-research:research
│   ├── skills/codex-researcher/
│   │   └── SKILL.md               # Codex research instructions
│   └── CLAUDE.md
├── README.md
├── CLAUDE.md → AGENTS.md          # Symlink
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

### prompt-engineer Workflow

1. Receive task description or existing prompt
2. Analyze domain, complexity, and target model
3. Apply CRAFT framework (Context, Role, Action, Format, Tone)
4. Select appropriate structure (XML/Markdown/plain text)
5. Apply proven patterns (CoT, Few-Shot, Role-Based, etc.)
6. Output optimized prompt with design rationale

### obsidian-plan-sync Workflow

1. User exits Plan Mode → PostToolUse hook fires on `ExitPlanMode`
2. Script finds latest plan in `~/.claude/plans/`
3. Extracts title, formats as `Plan/<date>_<title>.md`
4. Saves to Obsidian via REST API / notesmd-cli / direct file write
5. Stop hook acts as fallback for plans missed during ExitPlanMode

### obsidian-report-sync Workflow

1. Session ends → prompt-based Stop hook fires
2. Hook LLM evaluates DoD (meaningful code changes?)
3. If reportable: blocks exit, instructs Claude to generate report
4. Claude generates structured report → runs `save-report-to-obsidian.sh`
5. Report saved to `Report/<project>/<YYYYMMDD>_<title>.md`
6. `[REPORT_SAVED]` marker → Stop hook re-fires → approves → session ends

### obsidian-session-log Workflow

1. Claude Code 세션 종료 → SessionEnd 훅 실행
2. stdin에서 session_id, transcript_path, cwd 수신
3. Background worker fork 후 main process 즉시 exit
4. Worker가 claude CLI(sonnet)로 AI 요약 생성 (실패 시 jq fallback)
5. obsidian CLI로 `{FOLDER_PREFIX}/{project}/history/{YYYY-MM-DD}.md`에 append/create
6. macOS toast 알림으로 결과 표시

### codex-research Workflow

1. `/codex-research:research <topic>` 명령 실행
2. OpenAI Codex CLI에 리서치 요청 전달
3. Codex가 토픽에 대한 종합 리서치 수행
4. 구조화된 리서치 리포트 반환

## Multi-Agent Coordination

Before starting any task:

1. Read `.context/TASKS.md` — check what needs to be done and what's already claimed
2. Read `.context/STEERING.md` — understand current priorities, constraints, and execution mode
3. Update `.context/TASKS.md` — mark your task as `[~]` in progress with your agent name
4. On completion — mark task as `[x]` and commit

### File Purposes

| File | Purpose |
|------|---------|
| `.context/TASKS.md` | Shared task tracker — who does what |
| `.context/STEERING.md` | Project direction, priorities, and execution mode |

### Storage Mode

`.context/` is a symlink into the Obsidian vault (`20_Project/claude-plugin/.context/`). It is NOT tracked by git.

### Execution Mode

File-based coordination. Sequential work with 1-2 agents, async collaboration via `.context/` files.

## Plugin Development

No build step required. Pure markdown-based Claude Code plugin.

To test locally:
```bash
claude --plugin-dir /path/to/claude-plugin/plugin-name
```
