# obsidian-report-sync

Automatically saves structured work reports to Obsidian when meaningful implementation work is completed.

## How It Works

1. Session ends → prompt-based **Stop** hook fires
2. Hook LLM evaluates DoD: "Was meaningful work done?"
   - **No** (exploration/questions only) → session ends normally
   - **Yes** (code written/modified/deleted) → blocks exit, instructs report generation
3. Claude generates a structured markdown report → saves via `save-report-to-obsidian.sh`
4. Report saved to `Report/<project-name>/<YYYYMMDD>_<title>.md` in Obsidian
5. `[REPORT_SAVED]` marker output → Stop hook re-fires → approves → session ends

## Installation

```bash
/plugin install obsidian-report-sync@claude-plugin
```

## Report Template

```markdown
# <Title>

## Task Summary
## Changed Files
## Key Decisions
## Test Results
## Remaining Issues
```

## Requirements

One of the following save methods:

| Method | Config |
|--------|--------|
| Obsidian REST API | `OBSIDIAN_API_KEY` + `OBSIDIAN_API_URL` env vars |
| `notesmd-cli` | `brew install notesmd-cli` |
| Direct file write | Obsidian vault at default iCloud path |

## License

MIT
