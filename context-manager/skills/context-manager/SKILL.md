---
name: context-manager
description: Automatically discovers and loads relevant project context from markdown documentation before each task. This skill should be used at the start of every task to ensure Claude has access to project plans, architecture, implementation status, and feedback. It intelligently matches context documents based on keywords, file paths, and task types, then loads relevant documentation to inform the current work.
---

# Context Manager

## Overview

Automatically manage project context documentation stored in `.context/` directories (hidden for cleaner project structure). This skill ensures Claude always has access to relevant project information by:

1. **Auto-discovering** context documents before starting work
2. **Intelligently matching** documentation to the current task
3. **Loading** relevant context into the conversation
4. **Updating** or creating documentation based on work completed

**Core Goal: Reducing Implicit Knowledge (암묵지 감소)**
The primary purpose of this skill is to capture and share knowledge that isn't explicitly visible in the code, such as design intent, background decisions, and implementation plans.

## When to Use

This skill should be activated **at the start of every task** to ensure proper context awareness. It is especially critical when:

- Starting work on any codebase with a `.context/` directory
- Implementing features or fixing bugs that may have been planned or documented
- Working on projects with established architecture or design decisions
- Contributing to teams that maintain project documentation

## Workflow

### Step 1: Check for Context Directory

First, verify if a `.context/` directory exists in the current working directory or project root:

```bash
# Check current directory
ls -la .context/ 2>/dev/null

# Check common project roots
ls -la ./.context/ ../.context/ ../../.context/ 2>/dev/null
```

**If no context directory exists:**
- Ask the user if they want to initialize a context structure
- Use `/context-manager:init` to create the structure
- Suggest common categories based on project type

**If context directory exists:**
- Proceed to Step 2

### Step 2: Discover Relevant Context

Use the search functionality to identify relevant documentation based on:

**Semantic Search (if qmd available):**
```bash
qmd query "your search terms" --collection context --top-k 5
```

**Keyword Search (fallback):**
```bash
python scripts/find_context.py \
  --context-dir ./.context \
  --keywords "monitoring agent setup" \
  --files "agent/executor.py" \
  --task-type "implementation"
```

**Task-based matching:**
- User's request keywords (e.g., "monitoring" → `.context/monitoring/`)
- Mentioned file paths (e.g., working in `agent/` code → `.context/agents/`)
- Task type inference (e.g., "add feature" → `.context/planning/`, `.context/architecture/`)

### Step 3: Load Context Documents

Read the top-ranked context documents (typically 2-5 files) and incorporate them into your understanding:

**Loading strategy:**
- Always load README.md if it exists in context/
- Load top 3-5 most relevant documents
- Prioritize recent files for ongoing work
- Read documents using the Read tool

**After loading:**
- Briefly summarize key context to the user (1-2 sentences)
- Mention which documents were loaded
- Note any conflicts or outdated information

### Step 4: Execute Task with Context

Proceed with the user's requested task, informed by the loaded context:

- Reference relevant architecture decisions
- Follow established patterns and conventions
- Check implementation status for dependencies
- Adhere to project-specific guidelines

### Step 5: Update Context After Task

After completing work, update documentation as needed:

**Update existing documents when:**
- Implementation status changes
- Architecture evolves
- Bugs are fixed (add to operations/)
- Features are completed (update planning/)

**Create new documents when:**
- Starting a new feature area
- Documenting a new integration
- Recording a significant architectural decision
- Establishing new operational procedures

**Example using /context-manager:update:**
```bash
/context-manager:update --category "monitoring" --file "agent_streaming_implementation.md" --summary "Completed agent streaming feature with WebSocket support"
```

**Update guidelines:**
- Prefer updating existing docs over creating new ones
- Use git for version control (no date-based file names needed)
- Keep updates concise and actionable
- Cross-reference related documents

## Context Categories

Common categories found in `.context/` directories:

| Category | Purpose | When to Load |
|----------|---------|--------------|
| `planning/` | Implementation plans, roadmaps, status | Feature work, project planning |
| `architecture/` | System design, technical decisions | Major changes, new features |
| `guides/` | Getting started, user guides | Setup, onboarding |
| `operations/` | Deployment, troubleshooting, ops | Bug fixes, incidents, deployment |
| `reference/` | API docs, CLI guides | Integration work, API usage |
| `integrations/` | External service setup | Third-party integrations |
| `agents/` | Agent configuration, capabilities | Agent-related work |
| `monitoring/` | Observability, metrics | Performance, debugging |

See `references/context_patterns.md` for detailed guidance.

## Context Discovery Algorithm

The skill uses a weighted scoring system:

**Keyword matching (40%):**
- Exact match in filename: +0.4
- Match in category name: +0.3
- Partial match (word boundary in filename): +0.2

**Path-based matching (30%):**
- File path overlap with context category
- Related code directories

**Task type matching (20%):**
- Implementation tasks → planning/, architecture/
- Bug fixes → operations/, troubleshooting/
- Setup tasks → guides/, reference/

**Recency (10%):**
- Recently modified files get a boost
- Prioritize active work areas

## Examples

### Example 1: Loading Context at Project Start

```
User: 모니터링 기능 개선해줘

Claude: (context-manager skill activated)

📂 Checking context directory...
✓ .context/ directory found

🔍 Searching relevant documents...
Keywords: "모니터링", "monitoring"
Task type: implementation

📄 Loaded context:
1. .context/monitoring/architecture.md (score: 0.92)
2. .context/monitoring/metrics_guide.md (score: 0.85)
3. .context/planning/monitoring_roadmap.md (score: 0.78)

📋 Summary:
- Currently using Prometheus + Grafana stack
- Metrics collection interval: 30 seconds
- Next milestone: Alert system implementation

Now starting monitoring improvement work.
```

### Example 2: No Context Directory

```
User: 새 기능 구현해줘

Claude: (context-manager skill activated)

📂 Checking context directory...
⚠️ No .context/ directory found.

Would you like to initialize context documentation?

Recommended structure:
.context/
├── planning/       # Planning, roadmaps
├── architecture/   # System design
├── guides/         # Guide documentation
└── operations/     # Operations, troubleshooting

[Y] Create / [N] Skip
```

### Example 3: Updating Context After Task Completion

```
User: (after completing feature) Done!

Claude: Feature implementation complete.

📝 Updating context...

Updated documents:
- .context/planning/implementation_status.md
  └─ "User authentication feature" status: ✅ Complete

Newly created documents:
- .context/architecture/auth_design.md
  └─ JWT-based authentication architecture documented

✓ Context update complete
```

## Troubleshooting

### No Search Results

```
Problem: No relevant context found

Solution:
1. Expand keywords to be more general
2. Check category directories directly
3. Load README.md first if available
```

### Too Many Documents Loaded

```
Problem: Too many related documents causing token waste

Solution:
1. Load only top 3-5 documents
2. Check document summaries first
3. Selectively load needed sections only
```

### Outdated Context

```
Problem: Loaded documents don't match current code

Solution:
1. Check recent changes with git log
2. Ask user if update is needed
3. Update context after task completion
```

## Best Practices

**DO:**
- Always check for context at task start
- Load relevant context before making changes
- Update context after significant work
- Keep context documents concise and actionable
- Use categories consistently

**DON'T:**
- Skip context loading to save time
- Create duplicate documentation
- Use date-based filenames (git tracks history)
- Load entire .context/ directory (be selective)
- Forget to update implementation status
