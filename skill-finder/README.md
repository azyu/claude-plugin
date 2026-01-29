# skill-finder

Analyze projects and find relevant AI skills from GitHub and skills.sh.

## Installation

```bash
/plugin install skill-finder@claude-plugin
```

## Usage

```bash
/skill-finder:search                    # Analyze project and recommend skills
/skill-finder:search React              # Search for React-related skills
/skill-finder:search UI/UX design       # Search for UI/UX design skills
/skill-finder:search test automation    # Search for testing skills
```

## Installing Skills with npx add-skill

After skill-finder recommends skills, install them using `npx add-skill`:

### Project Scope (default)

Installs to `.claude/skills/` - available only in this project:

```bash
npx add-skill <owner/repo> --skill <skill-name>
```

**Example:**
```bash
npx add-skill sickn33/antigravity-awesome-skills --skill code-quality
```

### User Scope (global)

Installs to `~/.claude/skills/` - available in all projects:

```bash
npx add-skill <owner/repo> --skill <skill-name> -g
```

**Example:**
```bash
npx add-skill nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux -g
```

## Manual Installation Fallback

If `npx add-skill` fails (TTY error, network issue, etc.):

```bash
# 1. Clone the repository
git clone --depth 1 https://github.com/<owner>/<repo>.git /tmp/<repo>

# 2. Find the skill directory
find /tmp/<repo> -name "SKILL.md" 2>/dev/null

# 3. Copy to target location
# Project scope:
mkdir -p .claude/skills/<skill-name>
cp -r <found-path>/* .claude/skills/<skill-name>/

# User scope:
mkdir -p ~/.claude/skills/<skill-name>
cp -r <found-path>/* ~/.claude/skills/<skill-name>/

# 4. Cleanup
rm -rf /tmp/<repo>
```

## Skill Sources

| Source | Description | URL |
|--------|-------------|-----|
| antigravity-awesome-skills | 238+ skills (code-quality, debugging, testing, etc.) | https://github.com/sickn33/antigravity-awesome-skills |
| ui-ux-pro-max-skill | UI/UX specialist (67 styles, 96 palettes, 56 fonts) | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| skills.sh | Community skill marketplace | https://skills.sh |

## Workflow

1. **Project Analysis** - Detects tech stack from config files
2. **Search** - Finds relevant skills from curated sources
3. **Recommend** - Shows top skills matching your project
4. **Install Prompt** - Asks which skill to install
5. **Scope Selection** - Choose project or user scope
6. **Install** - Downloads and installs via `npx add-skill`

## License

MIT
