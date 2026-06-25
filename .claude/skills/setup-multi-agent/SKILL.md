---
name: setup-multi-agent
description: Bootstrap a new project with multi-CLI agent config — drops AGENTS.md + CLAUDE.md from the cc-templates templates/ directory into a target project, patches its .gitignore, and prints verification commands. The "multi-agent" here means multi-CLI (Claude Code + Codex CLI + Antigravity CLI), not multiple internal sub-agents.
---

# /setup-multi-agent — Bootstrap a new project

Drop the AGENTS.md + CLAUDE.md pair into a target project so all three coding CLIs (Claude Code, Codex CLI, Antigravity CLI) load the same canonical project context. AGENTS.md is the canonical source; CLAUDE.md is a 1-line `@AGENTS.md` import so Claude Code (which doesn't yet natively read AGENTS.md) gets the same content.

## Prerequisites

The cc-templates repo must be available locally. The skill reads three files from its `templates/` directory:

- `templates/AGENTS.md.template`
- `templates/CLAUDE.md.template`
- `templates/gitignore-additions.txt`

Step 0 below locates that directory. If any of the three files is missing after resolution, fail loudly and stop.

## Steps

### 0. Locate the templates directory

This skill is usually invoked from a symlinked install at `~/.claude/skills/setup-multi-agent/` that points back into the cct repo, so `templates/` is NOT a sibling of `SKILL.md`. Resolve the real cct repo root by following the skill's own symlink and walking up three levels.

The harness reports the skill's base directory at invocation (e.g., `Base directory for this skill: /home/<user>/.claude/skills/setup-multi-agent`). Pass that path through `readlink -f` and ascend three directories — the skill lives at `<cct-repo>/.claude/skills/setup-multi-agent/`, so up-three lands at `<cct-repo>`:

```bash
# Replace <skill-base-dir> with the path the harness reported at invocation.
SKILL_DIR_RESOLVED="$(readlink -f "<skill-base-dir>")"
CCT_ROOT="$(readlink -f "${SKILL_DIR_RESOLVED}/../../..")"
TEMPLATES_DIR="${CCT_ROOT}/templates"

# Verify the three template files exist; fail loudly if any are missing.
missing=0
for f in AGENTS.md.template CLAUDE.md.template gitignore-additions.txt; do
  if [ ! -r "${TEMPLATES_DIR}/${f}" ]; then
    echo "ERROR: Missing template at ${TEMPLATES_DIR}/${f}" >&2
    missing=1
  fi
done
[ "${missing}" -eq 0 ] || exit 1

echo "Templates dir resolved: ${TEMPLATES_DIR}"
```

Use the resolved `${TEMPLATES_DIR}` (or the absolute path the snippet prints) in all subsequent steps. This works whether the skill is invoked from a symlinked install or directly from inside the cct repo; the `readlink -f` step is what lets symlinked installs resolve to the real cct repo root instead of `~/.claude/skills/`.

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
- If `<target>/AGENTS.md` or `<target>/CLAUDE.md` already exists, list which ones and ask: overwrite, skip, or abort.

### 3. Materialise the files

For each template, read from `${TEMPLATES_DIR}/` (resolved in Step 0), substitute placeholders, and write to `<target>/`:

- `${TEMPLATES_DIR}/AGENTS.md.template` → `<target>/AGENTS.md`
  - Replace: `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{TARGET_MARKET}}`, `{{TECH_STACK_SUMMARY}}`, `{{KEY_CONSTRAINTS}}`, and `{{TODAY}}` (inside the sprint-status block's `**Last Updated:**` line; use `date +%Y-%m-%d` output).
- `${TEMPLATES_DIR}/CLAUDE.md.template` → `<target>/CLAUDE.md`
  - No placeholders (single `@AGENTS.md` line).

### 4. Patch `.gitignore`

- If `<target>/.gitignore` does not exist, create it with the contents of `${TEMPLATES_DIR}/gitignore-additions.txt`.
- If it exists, append `${TEMPLATES_DIR}/gitignore-additions.txt` to it — but first grep for `.gemini/` to avoid double-appending if the user runs the skill twice.

### 5. Print verification commands

Print these so the user can run them in a fresh terminal:

```bash
cd <target>

# Claude Code loads AGENTS.md via the @AGENTS.md import in CLAUDE.md:
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Antigravity CLI (agy) reads AGENTS.md natively (no wrapper needed):
agy 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Codex CLI reads AGENTS.md natively (no wrapper needed). NOTE: Codex is an
# agent loop and will read files unless explicitly told not to. The prompt
# below asks for a verbatim quote from loaded context; if Codex answers
# without running shell commands, native auto-load is confirmed. If it ran
# `sed`/`cat`/`grep` on AGENTS.md first, that only confirms AGENTS.md exists
# and Codex can find it — NOT that it was auto-loaded into context:
codex exec 'Without running any shell commands or reading any files, answer purely from your loaded AGENTS.md context: does it contain a section titled "Tool Preference: CLI over MCP"? If yes quote the first sentence.'
```

If any of the three CLIs is not installed, mention which and link the user to:
- Claude Code: <https://docs.claude.com/en/docs/claude-code>
- Codex CLI: <https://developers.openai.com/codex>
- Antigravity CLI: <https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/>

### 6. Final summary

Print a concise summary:

```
✓ Bootstrapped <project-name> at <target>
  - AGENTS.md (canonical project context + sprint-status block, Session 1)
  - CLAUDE.md (thin @AGENTS.md wrapper)
  - .gitignore patched (+ .agents/, + .gemini/, + .antigravitycli/, + .claude/*)

Next steps:
  1. Edit AGENTS.md to fill in any details the placeholders missed.
  2. Run the 3 verification commands above (fresh terminal each, in <target>).
  3. Commit: cd <target>; git add AGENTS.md CLAUDE.md .gitignore; git commit -m 'feat: bootstrap multi-CLI agent config via cc-templates'
```

## What NOT to do

- Do not install v2's 5 specialist agents. That pattern is gone in v3.
- Do not copy the `.claude/skills/` directory into the new project. Skills are repo-local to cc-templates; if the new project wants `/wrap` etc, the user clones or symlinks separately. (Future work: a `skills-bundle` template.)
- Do not run the verification commands yourself in this same session — the user runs them in a fresh terminal so context-load is honest.
