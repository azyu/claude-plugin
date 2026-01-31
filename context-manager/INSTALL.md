# Installation Guide

This guide covers how to install and configure the Context Manager plugin for Claude Code.

## Quick Install

### Option 1: Plugin Directory (Recommended)

Use the plugin directly without copying files:

```bash
# Clone the repository
git clone https://github.com/azyu/claude-plugin.git ~/claude-plugins

# Use with --plugin-dir flag
claude --plugin-dir ~/claude-plugins/context-manager
```

### Option 2: Manual Installation

Copy files to your Claude configuration:

```bash
# Commands
mkdir -p ~/.claude/commands/context
cp commands/*.md ~/.claude/commands/context/

# Skills
mkdir -p ~/.claude/skills/context-manager
cp -r skills/context-manager/* ~/.claude/skills/context-manager/
cp -r scripts ~/.claude/skills/context-manager/

# References
cp -r references ~/.claude/skills/context-manager/
```

## Post-Installation Setup

### 1. Verify Installation

Start Claude Code and test the commands:

```bash
# Check if commands are available
/context:status
```

You should see either a status output or a message about no `.context/` directory.

### 2. Initialize a Project

In your project directory:

```bash
/context:init
```

This creates the `.context/` structure with standard categories.

### 3. Setup Semantic Search (Optional)

For enhanced search with natural language queries:

```bash
# Install qmd
pip install qmd

# Setup collection for your project
cd /path/to/your/project
python ~/.claude/skills/context-manager/scripts/qmd_setup.py --context-dir .context
```

Verify setup:

```bash
qmd list  # Should show 'context' collection
qmd query "test query" --collection context
```

### 4. Install Hooks (Optional)

Hooks require manual configuration due to security restrictions.

#### Copy Hook Scripts

```bash
mkdir -p ~/.claude/hooks/stop
cp hooks/stop/*.sh ~/.claude/hooks/stop/
chmod +x ~/.claude/hooks/stop/*.sh
```

#### Configure settings.json

Edit `~/.claude/settings.json` and add:

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
          },
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

#### Verify Hooks

```bash
# Test context-update-reminder
echo "test" | ~/.claude/hooks/stop/context-update-reminder.sh

# Test qmd-reindex (requires qmd)
echo "test" | ~/.claude/hooks/stop/qmd-reindex.sh
```

## Configuration Options

### Custom Categories

To add custom categories when initializing:

```bash
/context:init
# Select "Custom" when prompted
# Enter your categories: planning,architecture,api,testing
```

### qmd Collection Settings

You can customize the qmd collection name:

```bash
python scripts/qmd_setup.py --context-dir .context --collection my-project-context
```

Then update search commands to use the custom collection name.

## Troubleshooting

### Commands Not Found

```
Error: Unknown command /context:init
```

**Solution**: Ensure commands are in the correct location:
- Plugin mode: Check `--plugin-dir` path
- Manual: Check `~/.claude/commands/context/`

### Scripts Not Executable

```
Permission denied: scripts/find_context.py
```

**Solution**:
```bash
chmod +x ~/.claude/skills/context-manager/scripts/*.py
```

### qmd Not Working

```
qmd: command not found
```

**Solution**:
```bash
pip install qmd
# Or
pip install --user qmd
# Then ensure ~/.local/bin is in PATH
```

### Collection Not Found

```
Collection 'context' not found
```

**Solution**:
```bash
python scripts/qmd_setup.py --context-dir .context --force
```

### Hook Not Running

1. Check settings.json syntax is valid JSON
2. Verify hook script path is correct
3. Test hook manually: `echo "test" | ~/.claude/hooks/stop/script.sh`

## Uninstallation

### Plugin Mode

Simply stop using the `--plugin-dir` flag.

### Manual Installation

```bash
# Remove commands
rm -rf ~/.claude/commands/context/

# Remove skills
rm -rf ~/.claude/skills/context-manager/

# Remove hooks (if installed)
rm ~/.claude/hooks/stop/context-update-reminder.sh
rm ~/.claude/hooks/stop/qmd-reindex.sh

# Remove hook configuration from settings.json
# Edit ~/.claude/settings.json and remove the hook entries
```

### Remove qmd Collection

```bash
qmd delete --collection context
```

## Updating

### Plugin Mode

```bash
cd ~/claude-plugins
git pull
```

### Manual Installation

Re-run the installation steps to overwrite existing files.

## Support

- Report issues: https://github.com/azyu/claude-plugin/issues
- Documentation: https://github.com/azyu/claude-plugin/wiki
