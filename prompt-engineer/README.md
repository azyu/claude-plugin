# prompt-engineer

Create, optimize, debug, and analyze prompts with proven patterns and the CRAFT framework.

## Installation

```bash
/plugin install prompt-engineer@claude-plugin
```

## Usage

```bash
/prompt-engineer:create "Write a code review prompt"   # Generate new prompt
/prompt-engineer:create "Customer support chatbot"      # Generate with CRAFT framework
/prompt-engineer:optimize                                # Optimize existing prompt
/prompt-engineer:debug                                   # Debug underperforming prompt
/prompt-engineer:analyze                                 # Analyze prompt structure
```

## CRAFT Framework

Every prompt is built using the CRAFT framework:

| Element | Description |
|---------|-------------|
| **C**ontext | Background information and constraints |
| **R**ole | AI persona and expertise level |
| **A**ction | Specific task to perform |
| **F**ormat | Output structure and format |
| **T**one | Style, voice, and communication approach |

## Commands

### `/prompt-engineer:create <task>`

Generate an optimized prompt from a task description:
1. Analyze task domain and complexity
2. Apply CRAFT framework
3. Select appropriate structure (XML/JSON/Markdown)
4. Output prompt with design rationale

### `/prompt-engineer:optimize`

Improve an existing prompt:
1. Paste your current prompt
2. Receive structural analysis
3. Get optimized version with before/after comparison
4. Each change explained

### `/prompt-engineer:debug`

Fix a prompt that produces wrong outputs:
1. Provide prompt + problematic output
2. Failure mode identification (hallucination, misalignment, format issues)
3. Root cause diagnosis
4. Corrected prompt + testing suggestions

### `/prompt-engineer:analyze`

Score and evaluate any prompt:
1. Multi-dimensional scoring (Clarity, Specificity, Structure, Role, Format, Constraints)
2. Anti-pattern detection
3. Strengths and weaknesses
4. Model compatibility assessment

## Reference Library

The plugin includes a curated knowledge base:
- **Prompt Patterns**: Chain-of-Thought, Few-Shot, Role-Based, Structured Output, and more
- **Anti-Patterns**: Common mistakes with explanations and fixes

## License

MIT
