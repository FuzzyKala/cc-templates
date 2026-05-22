# CC-Templates v3 Multi-Agent Rewrite Spec

## Status & Meta

- **Status:** draft (approved 2026-05-22)
- **Author:** Kala + Claude Opus 4.7 (jsdesign-landing-page session 220)
- **Target completion:** ~4-8 hours work, spread across 1-3 sessions
- **Source context:** This spec was authored from a prior conversation where the user verified — via 4 parallel research agents and several rounds of empirical Bash/file checks — that (a) AGENTS.md is governed by the Linux Foundation Agentic AI Foundation (AAIF, Dec 2025), (b) `/recap` is a Claude Code built-in feature (v2.1.108+) and **cannot** be overridden, (c) `.claude/commands/*.md` are not deprecated but skills are recommended for new authoring, (d) building a custom multi-provider CLI is not worth it for a solo developer's profile. The same session refactored `jsdesign-landing-page` to the AGENTS.md canonical pattern (commits `5abadd5` + `06c8471` in that repo) — this spec brings the same architecture to cc-templates.

## Preamble: Operating Context (read this first)

You — the agent reading this spec to execute it — are operating in a **fresh session** in `/home/kala/Documents/GitHub/cc-templates/`. Several things you should know upfront:

1. **This spec is self-contained.** You do NOT need conversation history from the prior session. All research findings, decisions, and rationale are encoded below.
2. **Your `~/.claude/projects/<cc-templates>/memory/` is empty** (or close to empty). The prior session ran in `jsdesign-landing-page` and accumulated ~107 memory files there; none of those carry to this repo. Memory references like `[[feedback_parallel_codex_live_filesystem_race]]` will not resolve for you — when this spec uses such references, it means "the prior session learned X; the lesson encoded inline below applies to your work here."
3. **You will not see the prior conversation.** Treat this spec as your only source of truth for what was decided and why.
4. **Do NOT install BMad in this repo.** Run `npx bmad-method install` ONLY if you want to (you almost certainly don't). cc-templates is a meta-tool / template repo — adding BMad's `_bmad/` + `_bmad-output/` + 65 skills here would complicate the dogfooding without value. Plain Markdown + git is enough.
5. **Verification commands are provided per phase.** Run them before declaring a phase done. If a verify fails, see the rollback guidance.
6. **Your project context auto-loads after Phase 5.** Before Phase 5 (dogfood), cc-templates has the old v2 CLAUDE.md as your loaded project context. After Phase 5, it has the new v3 AGENTS.md + thin CLAUDE.md wrapper. This is intentional — Phase 5 is also a self-test.

## Background: Why v3?

### The architecture mismatch

cc-templates v2 was authored 2025-09 → 2025-12 around the framing **"Claude Code Multi-Agent Coordination System"** where "multi-agent" meant `Claude internal sub-agents` (5 specialist agent roles, slash-command delegated). In 2026, the dominant developer pattern shifted to **multi-CLI** orchestration: Claude Code + OpenAI Codex CLI + Google Gemini CLI used together, with a shared `AGENTS.md` as cross-tool config canonical (governed by Linux Foundation AAIF since 2025-12-09). The v2 framing no longer matches what a 2026 user wants when they see "AI agent coordination templates."

### Research findings (carry these into your work)

The prior session ran 4 parallel research agents. Key findings:

**(a) AGENTS.md adoption status (2026-05):**
- Governance: Linux Foundation Agentic AI Foundation (AAIF), formed 2025-12-09, with Anthropic / OpenAI / Google / AWS / Microsoft / Cloudflare / Bloomberg as founding/platinum members.
- Spec home: <https://agents.md/> — 60k+ open-source projects using it.
- CLI auto-load is **asymmetric** in 2026:
  - **OpenAI Codex CLI:** natively defaults to `AGENTS.md`
  - **Claude Code:** natively defaults to `CLAUDE.md`; supports `@AGENTS.md` inline import per <https://code.claude.com/docs/en/memory>
  - **Gemini CLI:** natively defaults to `GEMINI.md`; supports `@./AGENTS.md` and `@/absolute/path` inline import per <https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/memport.md>
  - **Gemini does NOT follow symlinks** at the GEMINI.md path (issue #11547, closed `not_planned` 2025-11-21)
- GitHub issue `anthropics/claude-code#34235` requests Claude Code native AGENTS.md auto-load — open, marked duplicate, no ship commitment.

**(b) `/recap` is Claude Code built-in** (verified at <https://code.claude.com/docs/en/interactive-mode> + CHANGELOG):
- Added in v2.1.108. Auto-triggers after 3 min of terminal idle + unfocused. Manual via `/recap`. Configurable via `/config` or `CLAUDE_CODE_ENABLE_AWAY_SUMMARY=0`.
- Produces a **one-line** session synopsis. NOT a full session-end recap.
- **Implication for v3:** We cannot override `/recap`. The session-end full recap functionality (the cc-templates v2 `commands/recap.md` was trying to provide) needs a **different name**. We use `/wrap` in v3.

**(c) Commands vs Skills** (verified at <https://code.claude.com/docs/en/skills>):
- Quote: "Custom commands have been merged into skills. A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way. Your existing `.claude/commands/` files keep working. Skills add optional features… Skills are recommended since they support additional features like supporting files."
- Skills support: supporting-file directory, YAML frontmatter (`disable-model-invocation`, `user-invocable`, `paths` glob for auto-load), `context: fork` subagent execution.
- Precedence: if a skill and a command share the same name, **skill wins**.
- **Implication for v3:** Author new slash-invocable behavior as skills under `.claude/skills/<name>/SKILL.md`. Migrate v2's `commands/*.md` to skills format.

**(d) CLI > MCP rule:**
- Simon Willison (2025-11): *"I don't use MCP at all any more when working with coding agents — I find CLI utilities and libraries like Playwright Python to be a more effective way."*
- Anthropic engineering post (2025-11): "Code execution with MCP" pattern to avoid token bloat.
- Benchmark cited by Firecrawl/Arize: CLI ~100% reliability + 1.3-8.7K tokens/task vs MCP ~72% + 32-82K tokens/task (~17x at 10K ops/month).
- Cross-agent benefit: CLI auth lives in `~/.config/<tool>/` and is shared across Claude / Codex / Gemini. MCP OAuth is per-agent (Claude's auth ≠ Codex's auth ≠ Gemini's auth).
- **Implication for v3:** AGENTS.md template includes a "Tool Preference: CLI over MCP" section with per-service preferred-CLI matrix.

### Why NOT rename the repo

The prior session evaluated renaming. Empirical GitHub search showed the `agents-md-*` namespace is crowded in 2026 (`agents-md-template` taken 3x, `agents-md-kit` taken 2x, `agents-md-bootstrap` taken 1x as `cline-agents-md-bootstrap`). Renaming would not improve discoverability; would fragment 8 months of git history; and the "cc" prefix can be reinterpreted as "Coding CLI" (covers Claude Code / Codex CLI / Gemini CLI). **Keep `cc-templates`.** Focus discoverability work on README rewrite + GitHub description + topics.

### Why NOT BMad in cc-templates

cc-templates is a meta-tool. Installing BMad here would add 65+ skills, an `_bmad/` directory, and an `_bmad-output/` directory — all of which would confuse anyone using cc-templates as a template source for their own project. Keep cc-templates as plain Markdown + git. Skills live in `.claude/skills/` (Claude Code's native convention), not in `_bmad/`.

## Current State Inventory

Snapshot of v2 at `cc-templates` main HEAD `af4ad7a` (also preserved on `v2-archive` branch as of 2026-05-22):

| Path | v2 state | v3 disposition | Notes |
|---|---|---|---|
| `README.md` (18.7KB) | Frames "Claude Code Multi-Agent Coordination System" with 5 internal specialists + `/setup-agents` / `/ready` / `/recap` | **Full rewrite** | New framing: "Multi-CLI (Claude + Codex + Gemini) project bootstrap with shared AGENTS.md, CLI-first tool preference, session wrap skill" |
| `CLAUDE.md` (7.1KB) | v2 sprint-state file with "97% Complete" Session 3 status | **Rewrite as thin wrapper** | New: `@AGENTS.md` import + Current Sprint Status section + Auto-Update Instructions section. ~50 lines. |
| `AGENTS.md` | absent | **Create** | Canonical project context. Mirrors jsdesign's pattern: Personal Working Agreement (mirrored from `~/.claude/CLAUDE.md`) + cc-templates project context + Documentation Navigation + Tool Preference section + Codex/Gemini Role sections + project structure / build / test / commit conventions. |
| `GEMINI.md` | absent | **Create** | One line: `@./AGENTS.md` |
| `.gitignore` | basic | **Patch** | Add `.gemini/` (mirrors `.claude/*` and `.agents/` patterns) |
| `commands/recap.md` (1.5KB) | Session-end full recap + 10-session rolling. Name collides with Claude Code built-in `/recap`. | **Convert + rename** | Migrate logic to `.claude/skills/wrap/SKILL.md`. Includes 10-session rolling + archive overflow to `session-history-archive.md`. Skill name `/wrap` avoids collision. |
| `commands/ready.md` (3.6KB) | "Project context scanner" — scans .claude/agents, reads CLAUDE.md, git status | **Convert + update** | Migrate to `.claude/skills/ready/SKILL.md`. Update to scan AGENTS.md (not just CLAUDE.md). Drop "agent count validation" (v2-era 5-specialist concept). |
| `commands/setup-agents.md` (10KB) | v2 setup-agents = installs 5 specialists | **Convert + rewrite** | Migrate to `.claude/skills/setup-multi-agent/SKILL.md`. Rewrite to drop AGENTS.md / CLAUDE.md / GEMINI.md / .gitignore-additions templates into a new project + run verification. |
| `agents/` dir (5 specialist files) | v2 main-agent-project-manager + 4 specialists | **Remove from main** | Already on `v2-archive` branch. Drop from main in Phase 4 cleanup. |
| `system/` dir (workflow-principles + session-management) | v2 system docs | **Audit then partial keep** | Read both files; salvage 10-session pruning logic into the `wrap` skill; drop the rest into `v2-archive`. |
| `scripts/update-claude-global.sh` | Syncs `templates/*` to `~/.claude` | **Rewrite or keep with edits** | If keeping the sync-to-global pattern, update path mappings for new template layout (AGENTS.md / GEMINI.md / etc.). If dropping, document a simpler `cp -r templates/* <new-project>/` flow in README. |
| `templates/` dir | v2 template content for distribution to other projects | **Restructure** | New layout: `templates/AGENTS.md.template` + `templates/CLAUDE.md.template` + `templates/GEMINI.md.template` + `templates/gitignore-additions.txt` + `templates/setup-instructions.md` |
| `project-templates/` dir | v2 per-project-type templates | **Audit then drop or merge** | Likely redundant with new `templates/`. Read first; merge useful pieces. |
| `LICENSE` | MIT | **Keep** | No change |
| `.version` | source-of-truth version file | **Bump to v3.0.0** | Phase 4 cleanup |
| `CHANGELOG.md` | absent | **Create** | Add v3.0.0 entry summarizing rewrite |
| `docs/` | absent | **Create (this file is the first entry)** | Future architecture docs and migration guides go here |

## Target Architecture (post-v3 tree)

```
cc-templates/
├── AGENTS.md                                    ← canonical project context (new)
├── CLAUDE.md                                    ← thin wrapper: @AGENTS.md + sprint state (rewritten)
├── GEMINI.md                                    ← thin wrapper: @./AGENTS.md (new)
├── README.md                                    ← rewritten for multi-CLI framing
├── CHANGELOG.md                                 ← new
├── LICENSE                                      ← unchanged
├── .gitignore                                   ← + .gemini/
├── .version                                     ← v3.0.0
├── .claude/
│   └── skills/
│       ├── wrap/SKILL.md                        ← new (session-end full recap + 10-session rolling)
│       ├── ready/SKILL.md                       ← migrated from commands/ready.md
│       └── setup-multi-agent/SKILL.md           ← migrated from commands/setup-agents.md
├── docs/
│   └── v3-multi-agent-rewrite-spec.md           ← this file
├── templates/
│   ├── AGENTS.md.template                       ← new (with {{PROJECT_NAME}} etc placeholders)
│   ├── CLAUDE.md.template                       ← new (@AGENTS.md + empty sprint state)
│   ├── GEMINI.md.template                       ← new (@./AGENTS.md)
│   ├── gitignore-additions.txt                  ← new (.gemini/ + .agents/ lines)
│   └── setup-instructions.md                    ← new (5-step human checklist)
└── scripts/
    └── update-claude-global.sh                  ← updated if kept, else removed
```

Removed in Phase 4 (preserved on `v2-archive` branch):
- `agents/` (5 specialist files)
- `commands/` (replaced by `.claude/skills/`)
- `system/` (selected logic salvaged to skills, rest dropped)
- `project-templates/` (merged into `templates/` if useful)

## Phase Dependencies Graph

```
Phase 0 (Pre-work)
        │
        ↓
Phase 1 (Skills migration) ←──── must complete before Phase 5 dogfood
        │
        ↓
Phase 2 (Template files) ←────── parallel-safe with Phase 3
        │       │
        ↓       ↓
Phase 3 (README + GitHub meta) ── parallel-safe with Phase 2
        │
        ↓
Phase 4 (Cleanup obsolete)
        │
        ↓
Phase 5 (Dogfood — cc-templates self-applies v3)
```

Phases 2 and 3 are parallel-safe (one is template content, other is README/metadata). All other phases are sequential. Phase 5 is a self-test — must run last.

## Phase 0: Pre-work

**Status: COMPLETED in prior session.**

- ✅ `v2-archive` branch created at `af4ad7a` and pushed to `origin` (via `gh api`, since `git push` was blocked by GitHub email-privacy on existing commits with non-noreply author email).
- ✅ `/home/kala/tmp/claude-session-management-templates` deleted (was a stale clone of the same repo before its rename — not a separate project).
- ✅ Verified: `FuzzyKala/claude-session-management-templates` is a GitHub **redirect alias** for `cc-templates` (the repo was renamed Sept → Dec 2025), not a separate dead repo. No separate archive action needed.

**Outstanding from Pre-work (do BEFORE Phase 1):**

- ❗ **Fix local git committer email on cc-templates** to bypass GitHub email-privacy block on future pushes:
  ```bash
  cd ~/Documents/GitHub/cc-templates
  git config user.email "40585857+FuzzyKala@users.noreply.github.com"
  ```
  Without this, every `git push` will fail with `GH007: Your push would publish a private email address`.

**Acceptance:** `git config user.email` in cc-templates returns the no-reply form.
**Time estimate:** 1 minute.
**Rollback:** N/A (config change).

## Phase 1: Skills Migration

**Goal:** Convert v2's `commands/*.md` to v3's `.claude/skills/<name>/SKILL.md` format. Three skills: `wrap`, `ready`, `setup-multi-agent`.

### Phase 1.1: `wrap` skill (replaces v2 `commands/recap.md`)

**Why new name:** `/recap` is a Claude Code built-in (v2.1.108+) that produces a one-line synopsis. We cannot override it. We need a different name for the session-end full recap. `/wrap` is chosen — short, action-verb, distinguishes "wrap up the session" from `/recap` "give me a quick reminder."

**Skill file:** `.claude/skills/wrap/SKILL.md`

**Frontmatter:**
```yaml
---
name: wrap
description: Session-end full recap — analyze current session, archive previous session to history, update CLAUDE.md Current Sprint Status, maintain 10-session rolling window with overflow to archive.
---
```

**Skill body should specify:**

1. **Analyze current session** — distill 5-7 bullet points: key changes, decisions, lessons learned, tasks completed, follow-ups created.
2. **Read CLAUDE.md** to detect current session number from "Last Updated" field.
3. **Archive previous session content** from CLAUDE.md "Current Sprint Status" → `.claude/sessions/session-history.md` (append to top, so latest is first).
4. **Update CLAUDE.md** with new session entry (5-7 bullets format + Next session start checklist).
5. **10-session rolling window:** after step 3, if `session-history.md` now contains >10 session entries, move the OLDEST (bottom-most) entry into `.claude/sessions/session-history-archive.md` (append-only, never auto-loaded).
6. **Do NOT touch AGENTS.md** — project context lives there and is stable; sprint state is CLAUDE.md only.
7. **Commit:** use message format `chore: wrap Session N — <one-line summary>` and push to `origin/main`.

**Acceptance:**
- Skill discoverable via Claude Code slash picker (try typing `/wr` — should show `/wrap`).
- Test invocation: in any session, type `/wrap` — produces correct CLAUDE.md update + archive behavior on a test fixture.
- 10-session overflow logic correctly moves oldest entry to `session-history-archive.md` when active history hits 11 entries.

**Time estimate:** 1.5 hours (skill format + 10-session logic + manual test).

**Rollback:** Delete `.claude/skills/wrap/` directory; v2's `commands/recap.md` is on `v2-archive` branch if you need to reference the original logic.

### Phase 1.2: `ready` skill (migrated from `commands/ready.md`)

**Skill file:** `.claude/skills/ready/SKILL.md`

**Frontmatter:**
```yaml
---
name: ready
description: Project context scanner — show currently loaded AGENTS.md / CLAUDE.md / GEMINI.md state, git status, installed skills, and CLI tool availability (gh / gws / ntn / etc.).
---
```

**Skill body should specify:**

1. **Read AGENTS.md** (canonical project context — not CLAUDE.md primarily).
2. **Read CLAUDE.md** Current Sprint Status section for active state.
3. **Run `git status` + `git log -3 origin/main`** to confirm repo state.
4. **List installed skills** under `.claude/skills/*/SKILL.md`.
5. **Check CLI tool availability** — for each tool in AGENTS.md's "Tool Preference" matrix (`gh`, `gws`, `ntn`, `rclone`, Playwright CLI, `acli`), run `which <tool>` and report installed vs missing.
6. **Drop v2's "agent count validation"** — that was tied to the 5-specialist v2 model which no longer applies.

**Acceptance:**
- `/ready` produces concise summary (under 30 lines): project name, sprint status snippet, skill count, CLI tool install status, git branch + last 3 commits.

**Time estimate:** 1 hour.

**Rollback:** Delete `.claude/skills/ready/`. v2's `commands/ready.md` on `v2-archive`.

### Phase 1.3: `setup-multi-agent` skill (replaces `commands/setup-agents.md`)

**Skill file:** `.claude/skills/setup-multi-agent/SKILL.md`

**Frontmatter:**
```yaml
---
name: setup-multi-agent
description: Bootstrap a new project with multi-CLI agent config — drops AGENTS.md / CLAUDE.md / GEMINI.md templates from cc-templates/templates/, patches .gitignore, runs verification.
---
```

**Skill body should specify:**

1. Prompt user for: project name, project type (if multiple template variants exist later), target directory.
2. Confirm target directory is a clean git repo (no existing AGENTS.md / CLAUDE.md / GEMINI.md, or prompt to overwrite).
3. Copy `templates/AGENTS.md.template` → `<target>/AGENTS.md`, replacing placeholders.
4. Copy `templates/CLAUDE.md.template` → `<target>/CLAUDE.md` (no placeholders typically — thin wrapper).
5. Copy `templates/GEMINI.md.template` → `<target>/GEMINI.md`.
6. Append `templates/gitignore-additions.txt` content to `<target>/.gitignore` (create if missing).
7. Print verification commands the user should run in a fresh terminal (`claude --print '...'` + `gemini -p '...'`).
8. Drop v2's "5-specialist agent install" — no longer applicable.

**Acceptance:**
- Run on a temp empty git dir; produces working AGENTS.md / CLAUDE.md / GEMINI.md / patched .gitignore.
- Verification commands print and are runnable.

**Time estimate:** 1.5 hours.

**Rollback:** Delete `.claude/skills/setup-multi-agent/`. v2's `commands/setup-agents.md` on `v2-archive`.

## Phase 2: Template Files (parallel-safe with Phase 3)

**Goal:** Authorable template files under `templates/` for `setup-multi-agent` skill to consume.

**Files to create:**

### `templates/AGENTS.md.template`

Skeleton with `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{TARGET_MARKET}}`, `{{TECH_STACK_SUMMARY}}`, `{{KEY_CONSTRAINTS}}` placeholders. Sections (mirroring jsdesign's working AGENTS.md):

```
# Repository Guidelines

## Personal Working Agreement
[7 rules: Plain language / English-in-artifacts-Chinese-in-chat / Commit to recommendation / Concrete examples / Research first / Ask when uncertain / No fabrication]

## {{PROJECT_NAME}} Project Context
### Client / Project Overview
### Goals / MVP Requirements
### Design Decisions
### Tech Stack
### Project Constraints

## Documentation Navigation
### Core References
### AI Agent Rules
### Current Sprint State (-> CLAUDE.md)
### Legacy

## AI Agent Workflow
### Codex CLI Role
### Gemini CLI Role

## Tool Preference: CLI over MCP
[Per-service matrix — gh / gws / ntn / rclone / Playwright / acli]
[Stay-on-MCP list with rationale]

## Project Structure & Module Organization
## Build, Test, and Development Commands
## Coding Style & Naming Conventions
## Testing Guidelines
## Commit & Pull Request Guidelines
## Security & Configuration Tips
```

### `templates/CLAUDE.md.template`

```
@AGENTS.md

---

## Current Sprint Status

**Last Updated:** {{TODAY}} (Session 1 — initial setup)
**Active Work:** Project bootstrapped via cc-templates v3.

### Next session start

> Set up project-specific details: client info, MVP scope, tech stack constraints. Run `/ready` to verify config loaded.

---

## Auto-Update Instructions (For `/wrap` skill)

1. Update "Current Sprint Status" with new session (5-7 bullets max)
2. Compress previous session and move to `.claude/sessions/session-history.md`
3. If `session-history.md` exceeds 10 entries, move oldest to `.claude/sessions/session-history-archive.md`
4. Do NOT modify content in `AGENTS.md` — project context lives there
5. Keep this file under 80 lines (sprint state + auto-update only)
```

### `templates/GEMINI.md.template`

```
@./AGENTS.md
```

### `templates/gitignore-additions.txt`

```
# Claude AI settings and sessions (user-specific)
.claude/*
!.claude/settings.json

# Codex / Gemini IDE skill files (auto-generated by BMad installer if used)
.agents/

# Gemini CLI settings and sessions (user-specific, mirrors .claude/* pattern)
.gemini/
```

### `templates/setup-instructions.md`

Human-readable 5-step checklist for using the templates manually (without the `setup-multi-agent` skill):

```
1. cp templates/AGENTS.md.template <your-project>/AGENTS.md
   then edit placeholders ({{PROJECT_NAME}} etc.)
2. cp templates/CLAUDE.md.template <your-project>/CLAUDE.md
3. cp templates/GEMINI.md.template <your-project>/GEMINI.md
4. cat templates/gitignore-additions.txt >> <your-project>/.gitignore
5. Verify in fresh terminal:
   cd <your-project>
   claude --print 'Quote the first sentence of the Personal Working Agreement.'
   gemini -p 'Quote the first sentence of the Personal Working Agreement.'
```

**Acceptance:**
- All 5 template files exist with correct content.
- `setup-multi-agent` skill (Phase 1.3) can consume them.
- Manual setup via `setup-instructions.md` produces a working multi-agent project bootstrap.

**Time estimate:** 1 hour.

**Rollback:** Delete `templates/*.template` and `templates/*.txt` / `*.md` added in this phase.

## Phase 3: README + GitHub Meta (parallel-safe with Phase 2)

**Goal:** Update repo presentation to match v3 architecture.

### `README.md` full rewrite

Target ~150-300 lines. Sections:

```
# cc-templates

> Multi-CLI (Claude Code + Codex CLI + Gemini CLI) project bootstrap with shared AGENTS.md config, CLI-first tool preference, and session-wrap skill.

## What This Is
[2-3 paragraphs: problem (config sync drift across multiple CLI tools), solution (AGENTS.md canonical + @import wrappers), origin (cc-templates v3 evolved from v2 single-CLI-multi-specialist model)]

## Quick Start
[Copy command to bootstrap a new project]

## Architecture
[Diagram or short text explaining: AGENTS.md is canonical; CLAUDE.md and GEMINI.md are thin @import wrappers; user-level rules in ~/.claude/CLAUDE.md propagate to Codex via symlink and Gemini via @-import]

## Skills Included
- `/wrap` — session-end full recap (10-session rolling)
- `/ready` — project context scanner
- `/setup-multi-agent` — bootstrap a new project

## Tool Preference: CLI over MCP
[Brief — point to AGENTS.md template for full matrix]

## Verification
[Show the `claude --print '...'` and `gemini -p '...'` commands to verify @import works]

## Manual Setup (without the skill)
[Point to templates/setup-instructions.md]

## v2 Users
[Pointer to v2-archive branch for the old "Claude Code Multi-Agent Coordination System" framing]

## License
MIT
```

### GitHub repo metadata (via `gh repo edit`)

```bash
gh repo edit FuzzyKala/cc-templates \
  --description "Multi-CLI (Claude Code + Codex + Gemini) project bootstrap with shared AGENTS.md, /wrap session skill, and CLI-first tool preference." \
  --add-topic agents-md \
  --add-topic claude-code \
  --add-topic codex-cli \
  --add-topic gemini-cli \
  --add-topic multi-agent \
  --add-topic bootstrap \
  --add-topic template
```

**Acceptance:**
- README does NOT mention "5 specialist agents" / "Claude Code Multi-Agent Coordination System" / "v2" framing in main text (v2 reference only in "v2 Users" pointer section).
- GitHub description + topics match v3 framing.
- Pin to user profile if not already pinned.

**Time estimate:** 1.5 hours (README rewrite is the bulk).

**Rollback:** Restore README from `v2-archive` branch; revert GitHub edits via `gh repo edit` with old description.

## Phase 4: Cleanup Obsolete

**Goal:** Remove v2-only files from main (preserved on `v2-archive`).

```bash
cd ~/Documents/GitHub/cc-templates

# Confirm v2-archive has the to-be-deleted content
git fetch origin v2-archive
git diff --stat v2-archive main -- agents/ commands/ project-templates/ system/

# Delete v2-only paths
git rm -r agents/
git rm -r commands/
git rm -r project-templates/   # only if Phase 2 confirmed nothing useful to merge
git rm -r system/              # only if Phase 1.1 salvaged what was needed (10-session pruning logic)
# Keep scripts/ for now; audit + decide separately

# Bump version
echo "v3.0.0" > .version

# Create CHANGELOG
cat > CHANGELOG.md <<'EOF'
# Changelog

## v3.0.0 — 2026-05-XX

### Breaking changes
- Rewrote from v2's "Claude Code Multi-Agent Coordination System" (5 internal specialists + slash commands) to v3's multi-CLI (Claude + Codex + Gemini) project bootstrap pattern.
- `/recap` command removed — conflicts with Claude Code built-in `/recap` (v2.1.108+). Replaced with `/wrap` skill.
- `agents/`, `commands/`, `project-templates/`, `system/` directories removed from main (preserved on `v2-archive` branch).

### Added
- `AGENTS.md` canonical project context file (Linux Foundation AAIF spec aligned).
- `CLAUDE.md` thin wrapper (`@AGENTS.md` + sprint state).
- `GEMINI.md` thin wrapper (`@./AGENTS.md`).
- `.claude/skills/wrap/` — session-end full recap with 10-session rolling window.
- `.claude/skills/ready/` — project context scanner.
- `.claude/skills/setup-multi-agent/` — multi-CLI project bootstrap.
- `templates/` — `AGENTS.md.template`, `CLAUDE.md.template`, `GEMINI.md.template`, `gitignore-additions.txt`, `setup-instructions.md`.
- `docs/v3-multi-agent-rewrite-spec.md` — this rewrite's source spec.
- "Tool Preference: CLI over MCP" section in AGENTS.md template (per-service preferred-CLI matrix).
- `Gemini CLI Role` section in AGENTS.md template.

### Migration
- v2 users: see `v2-archive` branch for the previous architecture.
EOF
```

**Acceptance:**
- `git ls-files` returns no `agents/`, `commands/`, `project-templates/`, `system/` entries (subject to Phase 2 / 1.1 salvage decisions).
- `.version` = `v3.0.0`.
- `CHANGELOG.md` exists with v3.0.0 entry.

**Time estimate:** 30 minutes.

**Rollback:** `git checkout v2-archive -- <path>` for any directory that needs to come back.

## Phase 5: Dogfood — cc-templates self-applies v3

**Goal:** cc-templates' OWN root has AGENTS.md / CLAUDE.md / GEMINI.md per v3 pattern. This is proof-of-concept that the templates work, since the first user of v3 templates is cc-templates itself.

### Tasks

1. Use `setup-multi-agent` skill (Phase 1.3) on cc-templates' own root, OR manually copy templates and edit. Either way, end state is:
   - `AGENTS.md` at root — canonical content describing cc-templates itself (its purpose, structure, conventions, skill list, tool preferences for working on cc-templates).
   - `CLAUDE.md` at root — `@AGENTS.md` + Current Sprint Status (start with Session 1 = "v3 launch").
   - `GEMINI.md` at root — `@./AGENTS.md`.

2. Note: cc-templates' OLD `CLAUDE.md` had Session 3 status with "97% complete" — replace fully. v3 launches a fresh session count for cc-templates as a project.

### Verification (CRITICAL — this is also the self-test)

In a fresh terminal:

```bash
cd ~/Documents/GitHub/cc-templates

# Test Claude Code's @AGENTS.md import:
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'
# Expected: yes + quote

# Test Gemini CLI's @./AGENTS.md import:
gemini -p 'Without using any tools, just from your loaded context: (a) does the cc-templates project context exist? (b) does Tool Preference: CLI over MCP exist? Answer yes/no each.'
# Expected: yes + yes

# Test Codex picks up AGENTS.md natively (no @import needed):
codex --print 'What is this repo about?'
# Expected: response references multi-CLI bootstrap content from AGENTS.md
```

**Acceptance:**
- All 3 verification commands pass.
- cc-templates is its own first v3 user — the template is provably working.

**Time estimate:** 30 minutes.

**Rollback:** Remove the new AGENTS.md / CLAUDE.md / GEMINI.md at root. Restore v2 CLAUDE.md from `v2-archive`.

## Verification & Rollback Strategy

Per-phase verify commands are listed in each phase. General principles:

- **Each phase commits separately** (use commit format `feat(v3): phase N — <summary>`) so phase-level rollback is `git revert <sha>`.
- **`v2-archive` branch is your safety net.** If v3 needs to be abandoned wholesale: `git checkout v2-archive`; `git branch -D main`; `git checkout -b main v2-archive`; `git push -f origin main` (only do this if truly abandoning v3 — destructive).
- **No phase should break the previous phase's verify commands.** If Phase 3 README changes break Phase 1 skill tests, something is wrong.

## Reference: Carried Knowledge

### Slash command precedence (Claude Code)

- `/recap` is built-in (cannot override).
- `.claude/commands/<name>.md` works.
- `.claude/skills/<name>/SKILL.md` works.
- If both a command and a skill share the same name: **skill wins**.
- Source: <https://code.claude.com/docs/en/skills>

### @import syntax (per primary docs)

- **Claude Code:** `@AGENTS.md` inside `CLAUDE.md`. Source: <https://code.claude.com/docs/en/memory>
- **Gemini CLI:** `@./AGENTS.md` (relative) or `@/absolute/path/file.md`. Max depth 5, circular detection. Only `.md` files. Source: <https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/memport.md>
- **Gemini does NOT follow symlinks** at the GEMINI.md path (issue #11547, closed `not_planned`).
- **Codex CLI:** reads `AGENTS.md` natively. No `@import` needed. Source: <https://developers.openai.com/codex/guides/agents-md>

### Cross-agent auth pattern

- User-level rules in `~/.claude/CLAUDE.md` (Claude native).
- `~/.codex/AGENTS.md` → symlink → `~/.claude/CLAUDE.md` (Codex follows symlinks).
- `~/.gemini/GEMINI.md` contains `@/home/<user>/.claude/CLAUDE.md` (absolute path @import; Gemini does NOT follow symlinks).

### Tool Preference matrix (carry into AGENTS.md template)

| Service | Preferred CLI | Status (as of 2026-05-22) |
|---|---|---|
| GitHub | `gh` | ✓ widely installed |
| Google Workspace (Gmail / Calendar / Drive) | `gws` | ⏳ official Google CLI launched 2026-03, pre-1.0 |
| Google Drive bulk ops | `rclone` | ✓ mature alternative |
| Notion | `ntn` | ⏳ official, young |
| Browser scripted flows | Playwright CLI | ✓ mature |
| JIRA | `acli` | ✓ Atlassian official, GA 2026 |

Stay on MCP (no viable CLI):
- Canva (no design content management CLI)
- chrome-devtools (interactive debug)
- context7 (docs lookup)

### Session-history archive pattern

```
.claude/sessions/
├── session-history.md            # active rolling window (max 10 entries)
└── session-history-archive.md    # append-only overflow (never auto-loaded)
```

`/wrap` skill maintains this. Active history stays small (Claude/grep-friendly); archive preserves audit trail without bloating context.

## Done Criteria

- All 6 phases (0-5) completed.
- All phase acceptance commands pass.
- v2-archive branch preserved on origin (already done).
- README accurately describes v3 state — no v2 framing in main text.
- GitHub topics + description updated.
- cc-templates dogfood verified — its own root has working AGENTS.md / CLAUDE.md / GEMINI.md, all 3 @import verifications pass.
- One new project (any test directory) can be bootstrapped end-to-end via `/setup-multi-agent` and verified.
- `.version` = v3.0.0, CHANGELOG.md has v3.0.0 entry.
- This spec file (`docs/v3-multi-agent-rewrite-spec.md`) updated with completion status in the Status & Meta section.

## What This Spec Deliberately Does NOT Cover

- **MVP vs nice-to-have split.** All 6 phases are treated as required for v3.0.0 launch.
- **Risk register.** Solo developer project; risks are inherent and acceptable.
- **v3 → v4 roadmap.** Future direction TBD; do not pre-plan here.
- **CONTRIBUTING.md / external contribution guidelines.** Solo project; can add later if usage grows.
- **Migration guide for external v2 users.** Audience is solo — the CHANGELOG entry is sufficient pointer.
- **Promotion / sharing strategy.** Out of scope for engineering spec. After ship, separately consider whether to write a blog post / share on HN / etc.
