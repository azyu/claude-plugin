---
name: codex-researcher
description: Execute OpenAI Codex CLI to research a topic and produce a structured report. This is a direct CLI execution skill — do NOT delegate to Agent tool or any subagent.
arguments:
  - name: topic
    description: The topic or question to research
    required: true
---

# Codex Research Agent

You are executing the OpenAI Codex CLI to research a topic. Follow the steps below directly — do NOT use the Agent tool or delegate to any subagent.

## Execution Steps

### Step 1: Parse Arguments

Check `$ARGUMENTS` for options:
- `-m <model>` or `--model <model>`: Use different Codex model (default: gpt-5.3-codex)
- `-d` or `--deep`: Enable deep research mode (more thorough, slower)
- Everything else: Treat as the research topic

```bash
MODEL="gpt-5.3-codex"
DEEP_MODE=false
TOPIC=""

# Parse arguments
ARGS=($ARGUMENTS)
i=0
while [[ $i -lt ${#ARGS[@]} ]]; do
  case "${ARGS[$i]}" in
    -m|--model)
      MODEL="${ARGS[$((i+1))]}"
      i=$((i+2))
      ;;
    -d|--deep)
      DEEP_MODE=true
      i=$((i+1))
      ;;
    *)
      if [[ -n "$TOPIC" ]]; then
        TOPIC="$TOPIC ${ARGS[$i]}"
      else
        TOPIC="${ARGS[$i]}"
      fi
      i=$((i+1))
      ;;
  esac
done
```

### Step 2: Validate Topic

```bash
[[ -n "$TOPIC" ]] || { echo "Error: No research topic provided. Usage: /codex-research:research <topic>"; exit 1; }
echo "Researching: $TOPIC"
```

### Step 3: Verify Prerequisites

```bash
command -v codex &>/dev/null || { echo "Error: OpenAI Codex CLI not installed. To install: npm install -g @openai/codex && codex auth"; exit 1; }
```

### Step 4: Execute Codex Research

```bash
REASONING_FLAG=""
[[ "$MODEL" == "gpt-5.4" ]] && REASONING_FLAG="-c model_reasoning_effort=high"

if [[ "$DEEP_MODE" == true ]]; then
  DEPTH_INSTRUCTION="Perform an exhaustive deep-dive analysis. Cover history, current state, future trends, key players, trade-offs, and lesser-known insights. Be thorough and comprehensive."
else
  DEPTH_INSTRUCTION="Provide a focused, practical overview covering the most important aspects."
fi

PROMPT="You are a research analyst. Investigate the following topic and produce a structured research report in markdown format.

## Research Topic
$TOPIC

## Instructions
$DEPTH_INSTRUCTION

## Required Report Structure

### Summary
A concise 2-3 sentence executive summary.

### Key Findings
Numbered list of the most important discoveries and insights.

### Analysis
Detailed analysis organized by relevant subtopics. Include:
- Current state and landscape
- Pros and cons / trade-offs where applicable
- Notable examples or case studies

### Recommendations
Actionable recommendations based on the findings.

### Sources & References
List credible sources, documentation links, or references used."

codex exec -m "$MODEL" $REASONING_FLAG "$PROMPT"
```

### Step 5: Present Results

Display the Codex output directly. The report follows this structure:

1. **Summary** — Executive overview
2. **Key Findings** — Top insights
3. **Analysis** — Detailed breakdown
4. **Recommendations** — Actionable next steps
5. **Sources** — References

### Step 6: Offer Follow-up

After presenting the report, ask the user if they want to:
- Deep dive into a specific section
- Compare with alternative topics
- Save the report to a file
