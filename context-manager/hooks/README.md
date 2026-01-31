# Hooks Installation Guide

This directory contains hook scripts for the context-manager plugin. Due to security restrictions, hooks cannot be automatically installed and must be manually configured.

## Available Hooks

### 1. context-update-reminder.sh

**Purpose**: Reminds you to update `.context/` documentation when code files are modified during a session.

**When it runs**: At the end of every Claude Code session (stop hook)

**What it does**:
- Checks if `.context/` directory exists
- Counts modified code files (ts, tsx, js, jsx, py, go, rs, java)
- Shows a reminder to document significant changes

### 2. qmd-reindex.sh

**Purpose**: Automatically reindexes the qmd semantic search collection when context files change.

**When it runs**: At the end of every Claude Code session (stop hook)

**What it does**:
- Checks if qmd is installed and `.context/` exists
- Detects modified `.context/*.md` files
- Triggers background reindex of qmd collection

## Installation

### Step 1: Copy Hook Scripts

Copy the hook scripts to your Claude hooks directory:

```bash
# Create hooks directory if it doesn't exist
mkdir -p ~/.claude/hooks/stop

# Copy hook scripts
cp hooks/stop/context-update-reminder.sh ~/.claude/hooks/stop/
cp hooks/stop/qmd-reindex.sh ~/.claude/hooks/stop/

# Make executable
chmod +x ~/.claude/hooks/stop/*.sh
```

### Step 2: Configure settings.json

Add the hooks to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/stop/context-update-reminder.sh"
          }
        ]
      },
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/stop/qmd-reindex.sh"
          }
        ]
      }
    ]
  }
}
```

### Step 3: Verify Installation

Test that hooks are working:

```bash
# Test context-update-reminder
cd /path/to/project/with/.context
echo "test" | ~/.claude/hooks/stop/context-update-reminder.sh

# Test qmd-reindex (requires qmd installed)
echo "test" | ~/.claude/hooks/stop/qmd-reindex.sh
```

## Hook Configuration Options

### Selective Activation

If you only want hooks to run in certain projects, modify the matcher:

```json
{
  "matcher": "/path/to/project/*",
  "hooks": [...]
}
```

### Disable Temporarily

To disable a hook temporarily, comment it out in settings.json or rename the script:

```bash
mv ~/.claude/hooks/stop/context-update-reminder.sh ~/.claude/hooks/stop/context-update-reminder.sh.disabled
```

## Troubleshooting

### Hook Not Running

1. Check if the hook is properly configured in `~/.claude/settings.json`
2. Verify the script is executable: `chmod +x ~/.claude/hooks/stop/*.sh`
3. Test the script manually: `echo "test" | ~/.claude/hooks/stop/script.sh`

### Permission Denied

```bash
chmod +x ~/.claude/hooks/stop/context-update-reminder.sh
chmod +x ~/.claude/hooks/stop/qmd-reindex.sh
```

### qmd Reindex Not Working

1. Verify qmd is installed: `which qmd`
2. Check if collection exists: `qmd list`
3. Create collection if needed: `python scripts/qmd_setup.py --context-dir .context`

## Security Notes

- Hooks run with your user permissions
- Scripts only read git status and run qmd commands
- No network access or file modifications outside of qmd operations
- Review scripts before installing if you have security concerns
