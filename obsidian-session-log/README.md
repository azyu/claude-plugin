# obsidian-session-log

Automatically summarizes each Claude Code session and logs it to Obsidian on session end.

## How It Works

1. Session ends → **SessionEnd** hook runs `session-end.sh`
2. Main process reads stdin, forks background worker, exits immediately
3. Worker generates AI summary (claude CLI with sonnet) or falls back to jq extraction
4. Appends to `{FOLDER_PREFIX}/{project}/history/{YYYY-MM-DD}.md` via `obsidian` CLI
5. macOS toast notification shows result

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/azyu/claude-plugin/main/install_obsidian-session-log.sh | bash
```

Or manually:

```bash
/plugin install obsidian-session-log@claude-plugin
```

Then create the config file `~/.claude/obsidian-session-log.conf`.

## Configuration

`~/.claude/obsidian-session-log.conf`:

```bash
FOLDER_PREFIX="20_Project"    # Required — Obsidian vault folder prefix
LANG_SUMMARY="ko"             # Optional: ko | en (default: ko)
OBSIDIAN_VAULT=""              # Optional: vault name (default: CLI default)
```

- `FOLDER_PREFIX` is required. The script exits with a toast error if not set.
- `LANG_SUMMARY` controls AI summary and fallback template language.
- `OBSIDIAN_VAULT` specifies target vault in multi-vault setups.

## Requirements

| Dependency | Required | Notes |
|------------|----------|-------|
| `obsidian` CLI | Yes | [Obsidian CLI](https://help.obsidian.md/cli) |
| `jq` | Yes | JSON parsing + fallback summary |
| `claude` CLI | No | AI summary; falls back to jq if missing |
| Obsidian.app | Yes | Auto-launched if not running |

## License

MIT
