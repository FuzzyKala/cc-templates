---
name: setup-multi-agent
description: Bootstrap a new project with multi-CLI agent config — drops AGENTS.md / CLAUDE.md / GEMINI.md from the cc-templates templates/ directory into a target project, patches its .gitignore, and prints verification commands. The "multi-agent" here means multi-CLI (Claude Code + Codex CLI + Gemini CLI), not multiple internal sub-agents.
---

# /setup-multi-agent — Bootstrap a new project

Drop the AGENTS.md / CLAUDE.md / GEMINI.md trio into a target project so all three coding CLIs (Claude Code, Codex CLI, Gemini CLI) load the same canonical project context.

## Prerequisites

The cc-templates repo must be available locally (you are likely running this skill from within that repo). The skill reads from `templates/`:

- `templates/AGENTS.md.template`
- `templates/CLAUDE.md.template`
- `templates/GEMINI.md.template`
- `templates/gitignore-additions.txt`

If any of those is missing, fail loudly and stop.

## Steps

### 1. Collect inputs

Ask the user (one batched question with AskUserQuestion if available, else sequentially):

- **Project name** (e.g., `my-landing-page`). Used to replace `{{PROJECT_NAME}}` in the template.
- **One-line project description** (replaces `{{PROJECT_DESCRIPTION}}`).
- **Target market or audience** (replaces `{{TARGET_MARKET}}`). If unsure, accept "TBD" and let the user fill in later.
- **Tech stack summary** (replaces `{{TECH_STACK_SUMMARY}}`). Single line. E.g., "Next.js 15 + TypeScript + Tailwind + Vercel".
- **Key constraints** (replaces `{{KEY_CONSTRAINTS}}`). E.g., "Solo dev, ship by Q3, no backend".
- **Target directory** (absolute path). Must be an existing directory or one the user wants the skill to `mkdir -p`.

### 2. Sanity-check the target

- If target does not exist, ask before creating it.
- If target is not a git repo (`git -C <target> rev-parse --is-inside-work-tree`), warn and ask whether to `git init` it.
- If `<target>/AGENTS.md`, `<target>/CLAUDE.md`, or `<target>/GEMINI.md` already exists, list which ones and ask: overwrite, skip, or abort.

### 3. Materialise the files

For each template, read from `templates/`, substitute placeholders, and write to `<target>/`:

- `templates/AGENTS.md.template` → `<target>/AGENTS.md`
  - Replace: `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{TARGET_MARKET}}`, `{{TECH_STACK_SUMMARY}}`, `{{KEY_CONSTRAINTS}}`.
- `templates/CLAUDE.md.template` → `<target>/CLAUDE.md`
  - Replace: `{{TODAY}}` with `date +%Y-%m-%d` output.
- `templates/GEMINI.md.template` → `<target>/GEMINI.md`
  - No placeholders typically (single `@./AGENTS.md` line).

### 4. Patch `.gitignore`

- If `<target>/.gitignore` does not exist, create it with the contents of `templates/gitignore-additions.txt`.
- If it exists, append `templates/gitignore-additions.txt` to it — but first grep for `.gemini/` to avoid double-appending if the user runs the skill twice.

### 5. Print verification commands

Print these so the user can run them in a fresh terminal:

```bash
cd <target>

# Claude Code loads AGENTS.md via the @AGENTS.md import in CLAUDE.md:
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Gemini CLI loads AGENTS.md via the @./AGENTS.md import in GEMINI.md:
gemini -p 'Without using any tools, just from your loaded context: does the project context exist? Answer yes or no.'

# Codex CLI reads AGENTS.md natively (no wrapper needed):
codex --print 'What is this repo about?'
```

If any of the three CLIs is not installed, mention which and link the user to:
- Claude Code: <https://docs.claude.com/en/docs/claude-code>
- Codex CLI: <https://developers.openai.com/codex>
- Gemini CLI: <https://github.com/google-gemini/gemini-cli>

### 6. Final summary

Print a concise summary:

```
✓ Bootstrapped <project-name> at <target>
  - AGENTS.md (canonical project context)
  - CLAUDE.md (thin @AGENTS.md wrapper + Current Sprint Status, Session 1)
  - GEMINI.md (thin @./AGENTS.md wrapper)
  - .gitignore patched (+ .gemini/, +.agents/, +.claude/*)

Next steps:
  1. Edit AGENTS.md to fill in any details the placeholders missed.
  2. Run the 3 verification commands above (fresh terminal each, in <target>).
  3. Commit: cd <target>; git add AGENTS.md CLAUDE.md GEMINI.md .gitignore; git commit -m 'feat: bootstrap multi-CLI agent config via cc-templates'
```

## What NOT to do

- Do not install v2's 5 specialist agents. That pattern is gone in v3.
- Do not copy the `.claude/skills/` directory into the new project. Skills are repo-local to cc-templates; if the new project wants `/wrap` etc, the user clones or symlinks separately. (Future work: a `skills-bundle` template.)
- Do not run the verification commands yourself in this same session — the user runs them in a fresh terminal so context-load is honest.
