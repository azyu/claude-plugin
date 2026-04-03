# obsidian-plan-sync

Automatically saves Claude Code plans to your Obsidian vault when you exit Plan Mode.

## How It Works

- **PostToolUse** hook on `ExitPlanMode` — picks up the latest plan from `~/.claude/plans/`
- **Stop** hook fallback — catches plans that weren't saved during `ExitPlanMode`
- Extracts title from plan content and saves to `Plan/<date>_<title>.md` in Obsidian

## Installation

```bash
/plugin install obsidian-plan-sync@claude-plugin
```

## 3-Tier Save Strategy

| Priority | Method | Config |
|----------|--------|--------|
| 1 | Obsidian REST API | `OBSIDIAN_API_KEY` + `OBSIDIAN_API_URL` env vars |
| 2 | `notesmd-cli` | `brew install notesmd-cli` or `go install` |
| 3 | Direct file write | Obsidian vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault` |

## Requirements

One of the above save methods must be available.

## License

MIT
