# plan-review-codex

Review implementation plans with OpenAI Codex Agent.

## Installation

### Using plugin-dir (Recommended)

```bash
# Clone the repository
git clone https://github.com/azyu/claude-plugin.git ~/claude-plugins

# Use with --plugin-dir flag
claude --plugin-dir ~/claude-plugins/plan-review-codex
```

### Using npx add-skill

```bash
npx add-skill codex-review https://github.com/azyu/claude-plugin/tree/main/plan-review-codex
```

## Requirements

- OpenAI Codex CLI installed and authenticated

```bash
npm install -g @openai/codex
codex auth
```

## Commands

### `/plan-review-codex:plan-review`

Review the latest plan file with Codex.

```bash
# Review latest plan
/plan-review-codex:plan-review

# Review specific file
/plan-review-codex:plan-review -f ~/.claude/plans/my-plan.md

# Use different Codex model
/plan-review-codex:plan-review -m gpt-5.4
```

## Review Perspectives

Codex reviews plans from three perspectives:

1. **Feasibility** - Technical viability and potential risks
2. **Missing Items** - Gaps or missing steps in the plan
3. **Alternatives** - Better approaches or improvements

## License

MIT
