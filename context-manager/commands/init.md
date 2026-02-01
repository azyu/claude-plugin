---
name: init
description: Initialize .context/ directory structure for project documentation
---

# /context-manager:init

Initialize a `.context/` directory structure in the current project for managing documentation.

## Workflow

1. **Check existing structure**
   ```bash
   ls -la .context/ 2>/dev/null || echo "No .context directory found"
   ```

2. **Ask user for project type** if no structure exists:
   - Web Application (default)
   - Platform/Service
   - Library/SDK
   - Custom

3. **Create directory structure** based on project type:

   ### Web Application (Default)
   ```bash
   mkdir -p .context/{planning,architecture,guides,operations,reference,integrations}
   ```

   ### Platform/Service
   ```bash
   mkdir -p .context/{planning,architecture,guides,operations,reference,integrations,agents,monitoring}
   ```

   ### Library/SDK
   ```bash
   mkdir -p .context/{planning,architecture,guides,reference,examples}
   ```

4. **Create README.md** in `.context/`:
   ```markdown
   # Project Context Documentation

   ## Overview

   This directory contains project documentation managed by the context-manager plugin.

   ## Directory Structure

   - `planning/` - Implementation plans, roadmaps, feature specifications
   - `architecture/` - System design, technical decisions, ADRs
   - `guides/` - Getting started guides, tutorials, user documentation
   - `operations/` - Deployment, troubleshooting, operational procedures
   - `reference/` - API docs, CLI references, technical specifications
   - `integrations/` - External service integrations, third-party setup

   ## Usage

   Use `/context-manager:search <query>` to find relevant documentation.
   Use `/context-manager:update` to update or create documentation.
   Use `/context-manager:status` to check the current state of documentation.

   ---

   *Managed by context-manager plugin*
   ```

5. **Create category README files** for each directory.

6. **Optional: Setup qmd collection** if qmd is available:
   ```bash
   if command -v qmd &> /dev/null; then
     python3 "$PLUGIN_DIR/scripts/qmd_setup.py" --context-dir .context
     echo "✓ qmd semantic search enabled"
   fi
   ```

7. **Update .gitignore** if needed (don't ignore .context):
   ```bash
   # Ensure .context is NOT in .gitignore
   if grep -q "^\.context" .gitignore 2>/dev/null; then
     echo "⚠️ Warning: .context is in .gitignore - consider removing it"
   fi
   ```

## Output

```
✅ Context directory initialized!

📁 .context/
├── README.md
├── planning/
│   └── README.md
├── architecture/
│   └── README.md
├── guides/
│   └── README.md
├── operations/
│   └── README.md
├── reference/
│   └── README.md
└── integrations/
    └── README.md

🔍 Semantic search: [Enabled/Not available - install qmd for this feature]

Next steps:
1. Start documenting your project in .context/
2. Use /context-manager:update to create documents
3. Use /context-manager:search to find relevant docs
```
