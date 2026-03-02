# obsidian-report-sync

Saves session work reports to Obsidian vault automatically when meaningful implementation work is completed.

## How It Works

A prompt-based Stop hook evaluates whether the session involved reportable work (code changes, bug fixes, refactoring, etc.). If so, it blocks the session exit and instructs Claude to generate a structured report and save it via `save-report-to-obsidian.sh`.

## Report Flow

1. Claude attempts to end session → Stop hook fires
2. Hook LLM evaluates: "Was meaningful work done?"
   - No → approve (session ends)
   - Yes → block with instructions to generate report
3. Claude generates markdown report → runs `save-report-to-obsidian.sh`
4. Script saves to `Report/<project>/<YYYYMMDD>_<title>.md` in Obsidian vault
5. Claude outputs `[REPORT_SAVED]` → Stop hook re-fires → approves → session ends

## Important Rules

- After saving a report, ALWAYS include `[REPORT_SAVED]` in your response text
- The report is saved to `Report/<project-name>/` in Obsidian vault
- Use the save script: `${CLAUDE_PLUGIN_ROOT}/hooks/save-report-to-obsidian.sh <<'REPORT_EOF' ... REPORT_EOF`
- Do NOT generate reports for exploration-only or question-only sessions
- If the save script outputs "Report already saved for this session", still include `[REPORT_SAVED]` in your response and end the session

## Requirements (one of)

- Obsidian vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault`
- `notesmd-cli` installed
- Obsidian REST API with `OBSIDIAN_API_KEY` and `OBSIDIAN_API_URL` env vars
