---
name: update-claude
description: Continuous learning system that captures mistakes as rules in CLAUDE.md
---

# Update Claude Skill

This skill enables Claude to learn from mistakes during conversations and persist those learnings as rules in the project's `CLAUDE.md` file.

## Core Concept

When Claude makes a mistake (wrong approach, missed requirement, incorrect assumption), this skill:
1. Analyzes what went wrong
2. Formulates a preventive rule
3. Adds it to `CLAUDE.md` for future sessions

## When to Use

Invoke this skill when:
- The user points out a mistake you made
- You realize you took a wrong approach
- A correction was needed for your output
- The user says phrases like "don't do that", "that's wrong", "you should have..."

## Rule Format

Rules should be:
- **Imperative**: Start with action verbs (Always, Never, Check, Verify)
- **Specific**: Clear about what to do or avoid
- **Contextual**: Include when the rule applies
- **Concise**: One to two sentences maximum

### Good Examples

```
- Always read file contents before modifying to preserve existing code
- Never commit files containing console.log statements
- Check for existing implementations before creating new utilities
- Verify test coverage meets 80% threshold before marking task complete
```

### Bad Examples

```
- Be careful (too vague)
- Remember to do things properly (not actionable)
- The file should be read first and then modifications should be made carefully considering all existing code and making sure nothing is lost (too long)
```

## CLAUDE.md Structure

The skill maintains this structure in `CLAUDE.md`:

```markdown
# Project Guidelines

[Existing project-specific content...]

## Learned Rules

<!-- Rules learned from past mistakes. Each rule prevents a specific type of error. -->

- [2024-01-15] Always read a file's contents before making modifications
- [2024-01-16] Run tests after any code changes to catch regressions
- [2024-01-17] Check for type definitions before creating new interfaces
```

## Available Commands

- `/update-claude:learn` - Analyze mistake and add rule
- `/update-claude:list` - Show all learned rules
- `/update-claude:review` - Clean up and organize rules
- `/update-claude:remove <id>` - Delete a specific rule

## Automatic Learning

When this skill is active, Claude should:
1. Recognize when a mistake has been made
2. Proactively suggest creating a rule
3. Only add rules after user confirmation

## Integration with Project

Rules in `CLAUDE.md` are:
- Loaded at the start of each session
- Project-specific (different projects have different rules)
- Cumulative (build up over time)
- Reviewable (can be cleaned up with `/update-claude:review`)
