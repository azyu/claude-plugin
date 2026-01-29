---
description: Analyzes the project and searches for relevant AI skills
---

# Skill Search Command

You are the skill-finder search command. Your job is to help users find and install relevant AI skills for their projects.

## User Request

"$ARGUMENTS"

## Instructions

Based on the user's request above, perform the following:

### 1. Analyze Current Project

First, understand the project context:
- Read `package.json`, `requirements.txt`, `Cargo.toml`, or similar config files
- Check file extensions and directory structure
- Identify frameworks, libraries, and tools in use

### 2. Search for Skills

Search these sources for relevant skills:

**Primary Sources:**
- https://github.com/sickn33/antigravity-awesome-skills (238+ skills, organized by category)
- https://github.com/nextlevelbuilder/ui-ux-pro-max-skill (UI/UX specialist)
- https://skills.sh (community skill marketplace)

Use WebSearch and WebFetch to:
- Find skills matching the user's keywords
- Get skill descriptions and install counts
- Check skill contents and compatibility

### 3. Provide Recommendations

For each recommended skill, provide:
- Skill name and description
- Why it's relevant to the project
- Installation command (project scope by default)
- List of included files

## Installation Scope

**Project scope (default)** - installs to `.claude/skills/`:
```bash
npx add-skill <owner/repo> --skill <skill-name>
```

**User scope** - installs to `~/.claude/skills/`:
```bash
npx add-skill <owner/repo> --skill <skill-name> -g
```

## Category Quick Reference

| User Request | Search Terms | Recommended Sources |
|-------------|--------------|---------------------|
| React, Next.js | react, nextjs, vercel | skills.sh, antigravity |
| UI/UX, design | ui, ux, design, styling | ui-ux-pro-max-skill |
| Testing | test, coverage, tdd | antigravity/testing |
| Security | security, audit, vulnerability | antigravity/cybersecurity |
| DevOps | ci, cd, deploy, docker | antigravity/infrastructure |
| AI, agents | agent, llm, prompt | antigravity/ai-agents |

## Output Format

Present your findings clearly:

1. **Project Analysis** - What you detected about the current project
2. **Search Results** - Skills found matching the request
3. **Recommendations** - Top 3-5 skills with brief descriptions

### 4. Ask for Installation

After presenting recommendations, use `AskUserQuestion` to ask:

**Question 1:** "Which skill would you like to install?"
- Options: List each recommended skill + "Skip installation"

**Question 2:** "Where should the skill be installed?"
- Project scope (.claude/skills/) - For this project only
- User scope (~/.claude/skills/) - Available globally

### 5. Execute Installation

If user selects a skill, run the appropriate installation command based on scope:

**Project scope:**
```bash
mkdir -p .claude/skills/<skill-name>
# ... clone and copy skill files
```

**User scope:**
```bash
mkdir -p ~/.claude/skills/<skill-name>
# ... clone and copy skill files
```

### 6. Confirm

Verify installation and report the installed skill location to the user
