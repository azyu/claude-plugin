#!/bin/bash
# Send implementation plan to Codex for comprehensive review

set -e

MODEL="gpt-5.2-codex"
REASONING="high"
PLAN_FILE=""
PLANS_DIR="$HOME/.claude/plans"

# Find the most recently modified plan file
find_latest_plan() {
    if [[ -d "$PLANS_DIR" ]]; then
        ls -t "$PLANS_DIR"/*.md 2>/dev/null | head -1
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            PLAN_FILE="$2"
            shift 2
            ;;
        -m|--model)
            MODEL="$2"
            REASONING=""
            shift 2
            ;;
        *)
            # Treat first positional argument as file path
            if [[ -z "$PLAN_FILE" ]]; then
                PLAN_FILE="$1"
            fi
            shift
            ;;
    esac
done

# Auto-detect plan file if not specified
if [[ -z "$PLAN_FILE" ]]; then
    PLAN_FILE=$(find_latest_plan)
    if [[ -n "$PLAN_FILE" ]]; then
        echo "Auto-detected plan: $PLAN_FILE"
    fi
fi

# Check if Codex CLI is installed
if ! command -v codex &> /dev/null; then
    echo "Error: OpenAI Codex CLI is not installed."
    echo "To install: npm install -g @openai/codex && codex auth"
    exit 1
fi

# Verify plan file exists
if [[ -z "$PLAN_FILE" ]] || [[ ! -f "$PLAN_FILE" ]]; then
    echo "Error: Plan file not found."
    echo "Usage: plan-review.sh [plan-file] [-f file] [-m model]"
    echo "       If no file specified, auto-detects from ~/.claude/plans/"
    exit 1
fi

# Read plan content
PLAN_CONTENT=$(cat "$PLAN_FILE")

# Review prompt
REVIEW_PROMPT="Please provide a comprehensive review of the following implementation plan:

1. **Feasibility**: Is this technically feasible? What are the potential issues or risks?
2. **Missing Items**: Are there any missing steps or considerations?
3. **Alternatives**: Are there better approaches or improvements to suggest?

Plan file: $PLAN_FILE

---
$PLAN_CONTENT
---"

# Execute Codex
MODEL_OPTS="-m $MODEL"
[[ -n "$REASONING" ]] && MODEL_OPTS="$MODEL_OPTS -c model_reasoning_effort=\"$REASONING\""

echo "Reviewing plan with Codex..."
eval "codex exec $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox \"$REVIEW_PROMPT\""
