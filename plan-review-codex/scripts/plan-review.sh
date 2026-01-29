#!/bin/bash
# Send implementation plan to Codex for comprehensive review

set -e

MODEL="gpt-5.2-codex"
REASONING="high"
PLAN_FILE=""
PLANS_DIR="$HOME/.claude/plans"

# Find the most recently modified plan file (cross-platform)
find_latest_plan() {
    if [[ -d "$PLANS_DIR" ]]; then
        # Cross-platform: try GNU stat first, then BSD stat
        if stat --version &>/dev/null; then
            # GNU stat (Linux)
            find "$PLANS_DIR" -maxdepth 1 -name "*.md" -type f -exec stat -c '%Y %n' {} \; 2>/dev/null | \
                sort -rn | head -1 | cut -d' ' -f2-
        else
            # BSD stat (macOS)
            find "$PLANS_DIR" -maxdepth 1 -name "*.md" -type f -exec stat -f '%m %N' {} \; 2>/dev/null | \
                sort -rn | head -1 | cut -d' ' -f2-
        fi
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

# Create temporary file for the prompt
TEMP_PROMPT=$(mktemp)
trap 'rm -f "$TEMP_PROMPT"' EXIT

# Write review prompt to temp file
{
    cat << 'PROMPT_HEADER'
Please provide a comprehensive review of the following implementation plan:

1. **Feasibility**: Is this technically feasible? What are the potential issues or risks?
2. **Missing Items**: Are there any missing steps or considerations?
3. **Alternatives**: Are there better approaches or improvements to suggest?

PROMPT_HEADER
    echo "Plan file: $PLAN_FILE"
    echo ""
    echo "---"
    cat "$PLAN_FILE"
    echo "---"
} > "$TEMP_PROMPT"

# Build codex command as array for safe argument handling
CODEX_ARGS=("exec" "-m" "$MODEL")
[[ -n "$REASONING" ]] && CODEX_ARGS+=("-c" "model_reasoning_effort=$REASONING")
CODEX_ARGS+=("--dangerously-bypass-approvals-and-sandbox")

# Read prompt content
PROMPT_CONTENT=$(<"$TEMP_PROMPT")

echo "Reviewing plan with Codex..."
codex "${CODEX_ARGS[@]}" "$PROMPT_CONTENT"
