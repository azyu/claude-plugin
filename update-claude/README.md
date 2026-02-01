# update-claude

A Claude Code plugin that enables continuous learning from mistakes by capturing rules in your project's `CLAUDE.md` file.

## Overview

When Claude makes mistakes during a session, this plugin helps capture those learnings as persistent rules. These rules are stored in your project's `CLAUDE.md` file and automatically loaded in future sessions, helping Claude avoid repeating the same mistakes.

## Installation

```bash
npx add-skill update-claude https://github.com/anthropics/claude-plugin/tree/main/update-claude
```

Or manually:

1. Clone this repository
2. Copy the `update-claude` folder to `~/.claude/plugins/`
3. Restart Claude Code

## Commands

### `/update-claude:learn [description]`

Analyze a mistake from the conversation and create a preventive rule.

```bash
# Let Claude analyze the conversation for mistakes
/update-claude:learn

# Specify the mistake explicitly
/update-claude:learn "Modified file without reading it first"
```

### `/update-claude:list`

Display all learned rules from the current project.

```bash
/update-claude:list
```

Output:
```
📋 Learned Rules (3 total)

1. [2024-01-15] Always read a file before modifying it
2. [2024-01-16] Run tests after making changes
3. [2024-01-17] Check for existing implementations before creating new ones
```

### `/update-claude:review`

Review rules for duplicates, conflicts, or obsolete entries.

```bash
/update-claude:review
```

This command:
- Identifies duplicate rules
- Finds conflicting rules
- Flags old rules for review
- Suggests consolidation opportunities

### `/update-claude:remove <identifier>`

Remove a specific rule by number or keyword.

```bash
# Remove by position
/update-claude:remove 3

# Remove by keyword (finds matching rules)
/update-claude:remove tests
```

## How It Works

1. **Mistake Detection**: When something goes wrong, use `/update-claude:learn` to capture the lesson
2. **Rule Formulation**: Claude analyzes what happened and creates a concise, actionable rule
3. **Confirmation**: You approve the rule before it's added
4. **Persistence**: The rule is saved to `CLAUDE.md` in your project
5. **Future Sessions**: Claude reads `CLAUDE.md` at the start of each session, applying learned rules

## Rule Format

Rules are stored in `CLAUDE.md` under a "Learned Rules" section:

```markdown
## Learned Rules

<!-- Rules learned from past mistakes. Each rule prevents a specific type of error. -->

- [2024-01-15] Always read file contents before modifying to preserve existing code
- [2024-01-16] Never commit files containing console.log statements
- [2024-01-17] Check for existing implementations before creating new utilities
```

## Best Practices

1. **Be Specific**: Rules should clearly state what to do or avoid
2. **Use Imperative Form**: Start with action verbs (Always, Never, Check, Verify)
3. **Review Periodically**: Use `/update-claude:review` to keep rules clean
4. **Project-Specific**: Each project can have its own set of rules

## Examples

### Learning from a File Modification Mistake

```
User: You just overwrote my file without checking its contents!

/update-claude:learn

📝 Proposed Rule:
Always read a file's current contents before making any modifications to preserve existing code.

Based on: Modified file without reading it first, losing existing code.

Add this rule to CLAUDE.md? (y/n)
```

### Learning from a Testing Mistake

```
User: The tests are failing because you didn't run them before committing

/update-claude:learn "Didn't run tests before committing"

📝 Proposed Rule:
Run the full test suite and verify all tests pass before creating any commits.

Add this rule to CLAUDE.md? (y/n)
```

## License

MIT
