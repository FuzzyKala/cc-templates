# Manual setup (without the `/setup-multi-agent` skill)

If you cannot or do not want to run the `/setup-multi-agent` skill, you can drop the templates into a new project by hand. The skill just automates the 4 steps below.

## Prerequisites

- A target project directory (existing or new), ideally already initialised as a git repo.
- The cc-templates repo cloned locally (you are reading this file from inside it).

## Steps

```bash
# 1. AGENTS.md — canonical project context + sprint-status block at bottom.
#    Loaded by Codex and Antigravity (agy) natively; by Claude via @import in CLAUDE.md.
cp templates/AGENTS.md.template <your-project>/AGENTS.md

# 2. CLAUDE.md — thin wrapper: @AGENTS.md only. Sprint state lives in
#    AGENTS.md sprint-status block, not here.
cp templates/CLAUDE.md.template <your-project>/CLAUDE.md

# 3. Patch .gitignore so .agents/ + .gemini/ (used by Antigravity CLI) +
#    .antigravitycli/ stay out of git.
cat templates/gitignore-additions.txt >> <your-project>/.gitignore

# 4. Fill in the placeholders in <your-project>/AGENTS.md:
#    {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{TARGET_MARKET}},
#    {{TECH_STACK_SUMMARY}}, {{KEY_CONSTRAINTS}}, {{TODAY}}
#    ({{TODAY}} is inside the sprint-status block at the bottom — use
#     today's date in YYYY-MM-DD format)
# CLAUDE.md has no placeholders.
```

## Verification (run in a fresh terminal so context is loaded honestly)

```bash
cd <your-project>

# Claude Code: @AGENTS.md import from CLAUDE.md should load the canonical context.
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Antigravity CLI (agy): reads AGENTS.md natively, no @import needed.
agy 'Without using any tools, just from your loaded context: (a) does the project context exist? (b) does the Tool Preference section exist? Answer yes/no each.'

# Codex CLI reads AGENTS.md natively — no import needed.
codex exec 'What is this repo about?'
```

Expected: all three CLIs reference content from your filled-in `AGENTS.md`.

## Commit

```bash
cd <your-project>
git add AGENTS.md CLAUDE.md .gitignore
git commit -m "feat: bootstrap multi-CLI agent config via cc-templates"
```

## Why a CLAUDE.md wrapper for one canonical AGENTS.md?

Each CLI's default config filename and import syntax differ:

- **Codex CLI** defaults to `AGENTS.md`. No wrapper needed.
- **Antigravity CLI** (`agy`) defaults to `AGENTS.md`. No wrapper needed (replaced Gemini CLI per [2026-05-19 Google announcement](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/)).
- **Claude Code** defaults to `CLAUDE.md`. Supports `@AGENTS.md` inline import (per <https://code.claude.com/docs/en/memory>). Our `CLAUDE.md` is the thin wrapper that bridges Claude Code into AGENTS.md until native support lands.

One canonical source (`AGENTS.md`) — Codex and Antigravity read it natively, Claude uses a thin wrapper. Edit AGENTS.md → all CLIs see the change.

## Optional: BMad-style backlog & spec docs

If your project uses BMad workflows (spec-driven dev with deferred backlog), also copy these progressive-disclosure scaffolds:

- `templates/deferred-work.md.template` → `<project>/_bmad-output/implementation-artifacts/deferred-work.md`
- `templates/deferred-work-archive.md.template` → same dir, as `deferred-work-archive.md`
- `templates/SPEC-INDEX.md.template` → same dir, as `SPEC-INDEX.md` (populate from your spec frontmatter)

These provide the Dashboard / Index structure for backlogs and spec corpora that grow past ~30 entries. The progressive-disclosure convention is codified in `templates/AGENTS.md.template` under `## Document Conventions`. See <https://github.com/FuzzyKala/anchor/pull/27> and <https://github.com/FuzzyKala/anchor/pull/28> for the live examples that produced this pattern.
