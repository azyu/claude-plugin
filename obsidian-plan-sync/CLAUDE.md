# obsidian-plan-sync

Saves Claude Code plans to Obsidian vault automatically when exiting Plan Mode.

## How It Works

PostToolUse hook on `ExitPlanMode` picks up the most recent plan from `~/.claude/plans/`, extracts a title, and saves it to `Plan/<date>_<title>.md` in Obsidian.

## Requirements (one of)

- `notesmd-cli` installed (`brew install notesmd-cli` or `go install`)
- Obsidian REST API with `OBSIDIAN_API_KEY` and `OBSIDIAN_API_URL` env vars
