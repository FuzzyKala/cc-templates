# Manual setup (without the `/setup-multi-agent` skill)

If you cannot or do not want to run the `/setup-multi-agent` skill, you can drop the templates into a new project by hand. The skill just automates the 5 steps below.

## Prerequisites

- A target project directory (existing or new), ideally already initialised as a git repo.
- The cc-templates repo cloned locally (you are reading this file from inside it).

## Steps

```bash
# 1. AGENTS.md — canonical project context. Loaded by Codex natively;
#    by Claude / Gemini via @import from their wrappers.
cp templates/AGENTS.md.template <your-project>/AGENTS.md

# 2. CLAUDE.md — thin wrapper: @AGENTS.md + Current Sprint Status.
cp templates/CLAUDE.md.template <your-project>/CLAUDE.md

# 3. GEMINI.md — thin wrapper: @./AGENTS.md
cp templates/GEMINI.md.template <your-project>/GEMINI.md

# 4. Patch .gitignore so .gemini/ and .agents/ stay out of git.
cat templates/gitignore-additions.txt >> <your-project>/.gitignore

# 5. Fill in the placeholders in <your-project>/AGENTS.md:
#    {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{TARGET_MARKET}},
#    {{TECH_STACK_SUMMARY}}, {{KEY_CONSTRAINTS}}
# And in <your-project>/CLAUDE.md:
#    {{TODAY}}  (use today's date in YYYY-MM-DD)
```

## Verification (run in a fresh terminal so context is loaded honestly)

```bash
cd <your-project>

# Claude Code: @AGENTS.md import from CLAUDE.md should load the canonical context.
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Gemini CLI: @./AGENTS.md import from GEMINI.md should load the same context.
# GEMINI_CLI_TRUST_WORKSPACE=true is required for Gemini CLI headless mode (-p flag):
GEMINI_CLI_TRUST_WORKSPACE=true gemini -p 'Without using any tools, just from your loaded context: (a) does the project context exist? (b) does the Tool Preference section exist? Answer yes/no each.'

# Codex CLI reads AGENTS.md natively — no import needed.
codex --print 'What is this repo about?'
```

Expected: all three CLIs reference content from your filled-in `AGENTS.md`.

## Commit

```bash
cd <your-project>
git add AGENTS.md CLAUDE.md GEMINI.md .gitignore
git commit -m "feat: bootstrap multi-CLI agent config via cc-templates"
```

## Why three files for one config?

Because each CLI's default config filename and import syntax differ:

- **Codex CLI** defaults to `AGENTS.md`. No wrapper needed.
- **Claude Code** defaults to `CLAUDE.md`. Supports `@AGENTS.md` inline import (per <https://code.claude.com/docs/en/memory>). Our `CLAUDE.md` is a thin wrapper.
- **Gemini CLI** defaults to `GEMINI.md`. Supports `@./AGENTS.md` import. Our `GEMINI.md` is one line.

This means one canonical source (`AGENTS.md`) with two tiny adapters. Edit AGENTS.md → all three CLIs see the change.
