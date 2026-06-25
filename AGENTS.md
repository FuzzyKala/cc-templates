# Repository Guidelines

> AGENTS.md is the canonical project context for cc-templates. It is loaded natively by Codex CLI and Antigravity CLI (`agy`), by Claude Code via `@AGENTS.md` import in `CLAUDE.md`, and by Gemini CLI (legacy, sunsets 2026-06-18) via `@./AGENTS.md` import in `GEMINI.md`. AGENTS.md is governed by the Linux Foundation Agentic AI Foundation. See <https://agents.md/>.

## Personal Working Agreement

Rules that apply to every agent (Claude / Codex / Antigravity / Gemini) working in this repo. These mirror the user's global `~/.claude/CLAUDE.md` so all CLIs share the same expectations.

1. **Plain language, no jargon.** Explain like you would to a smart non-specialist. If a technical term is unavoidable, define it inline the first time. No corporate-report tone, no unexplained acronyms, no walls of bullet points when a sentence will do.

2. **English in artifacts, Chinese in chat.** Documents, specs, memory entries, agent prompts, commit messages, code comments → English. Conversation with the user, LINE drafts, client-facing copy → 繁體中文. Files already in a mixed pattern (e.g. `CLAUDE.md`, session logs) keep that pattern.

3. **Commit to a recommendation when listing options.** For any operational decision, do not just lay out 2-4 options and stop. Pick one, mark it as the recommendation, give the one-line reason, and invite the user to override. Bare option lists feel like dumping the decision back on the user.

4. **Concrete examples over abstract framing.** Give URLs to react to, code snippets to compare, screenshots, or specific filenames — not category trees, abstract taxonomies, or "it depends" framings. If abstraction is unavoidable, ground it with at least one concrete instance.

5. **Research first when work is non-trivial.** Complex, multi-step, cross-file, or outside-obvious-domain tasks → research with available tools (Explore, WebSearch, context7, Playwright, CLI utilities) BEFORE proposing a plan, spec, or brainstorm. Find out what current best practice is — do not rely on training-data memory for library behavior, API shapes, or "what's idiomatic now." Trivial work (typo, read-only lookup, single-file fix with clear scope) — just do it.

6. **Ask when uncertain.** Ambiguous requirement, multiple reasonable paths, touching shared state, unclear blast radius → ask first. Do not start work until intent is clear. Trivial single-file changes with obvious intent do not need ceremony.

7. **No fabrication, and keep critical thinking.** If not certain about a file path, function signature, library version, library behavior, or current state of the repo → verify (Read / grep / WebSearch / context7 / chrome-devtools) before stating it. "I don't know, let me check" beats confident-sounding speculation. Memory recall is not ground truth — verify before acting on a recalled fact. Beyond fact-level honesty: actively hunt for issues, gaps, and wrong framings — don't just confirm the user's direction. Push back when you see a problem, even if inconvenient. Verification not validation, especially when reviewing your own or another agent's work.

## cc-templates Project Context

### Project Overview

cc-templates is a multi-CLI project bootstrap toolkit. It ships:

- An `AGENTS.md` canonical-config template, plus thin `CLAUDE.md` / `GEMINI.md` wrappers that `@import` from `AGENTS.md`.
- A `/setup-multi-agent` skill that drops the trio into a new project and patches `.gitignore`.
- A `/wrap` skill that does session-end full recap by replacing the AGENTS.md sprint-status block. No rolling-window archive file — git history is the deep archive.
- A `/ready` skill that does a read-only project context scan at session start.

The repo is also the first user of its own templates — its own root has `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` per the v3 pattern (this is the Phase 5 "dogfood" of `docs/v3-multi-agent-rewrite-spec.md`).

### Target Audience

Solo developers and small teams who use more than one coding CLI (e.g., Claude Code + Codex CLI, Claude Code + Antigravity CLI, or any combination of three CLIs) and want consistent project context loaded across all of them without maintaining duplicate config files.

### Goals (v3.0.0)

- Single canonical `AGENTS.md`. Edit once, all three CLIs see the change.
- Skills are first-class. Slash commands work because Claude Code auto-discovers `.claude/skills/*/SKILL.md`. Other CLIs use them indirectly (via the AGENTS.md they share).
- CLI-first tool preference encoded in the template, with a per-service matrix.
- Plain Markdown + git. No npm dependencies, no build step.

### Design Decisions (locked in v3)

- **No automatic v2 → v3 migration.** v2 is preserved on `v2-archive` branch; users adopt v3 by re-bootstrapping.
- **Skills, not commands.** New slash-invocable behavior is authored as `.claude/skills/<name>/SKILL.md` per <https://code.claude.com/docs/en/skills>. v2's `commands/*.md` were migrated.
- **`/wrap`, not `/recap`.** Claude Code v2.1.108+ ships a built-in `/recap` (one-line synopsis) that cannot be overridden. The session-end full-recap behavior gets a different name.
- **GEMINI.md is a real file, not a symlink.** Gemini CLI does NOT follow symlinks at the `GEMINI.md` path (issue #11547, closed `not_planned` 2025-11-21).
- **Keep `cc-templates` repo name.** The `agents-md-*` namespace is crowded on GitHub as of 2026-05. The "cc" prefix can be read as "Coding CLI" (covers Claude Code / Codex CLI / Antigravity CLI / Gemini CLI).

### Tech Stack

Plain Markdown + git + Bash. `.version` is managed manually in dedicated commits, separate from template edits. No npm, no node, no Python deps at runtime.

### Project Constraints

- Solo maintainer; no CI/CD beyond GitHub's default checks.
- Templates must work standalone — a user with no internet access (after cloning) should be able to bootstrap a project using only this repo's contents.
- `v2-archive` branch is preserved indefinitely.
- The repo dogfoods its own templates: its root has `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` per the v3 pattern.

## Documentation Navigation

### Core References

- `AGENTS.md` (this file) — canonical project context, conventions, tooling preferences, and the sprint-status block at the bottom (between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`).
- `CLAUDE.md` — thin `@AGENTS.md` wrapper. Byte-stable across sessions; sprint state lives in this file, not in `CLAUDE.md`.
- `GEMINI.md` — thin `@./AGENTS.md` wrapper for Gemini CLI (legacy, sunsets 2026-06-18).
- `README.md` — user-facing readme; multi-CLI framing and quick start.
- `CHANGELOG.md` — release history (Keep a Changelog format).

### AI Agent Rules

The "Personal Working Agreement" section above governs every agent. Project-specific rules live in this section.

### Current Sprint State

For active sprint context (current session, what was just shipped, next-session priorities) → sprint-status block at the bottom of this file (between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`). That block is updated per session via the `/wrap` skill. All other sections of this file are bootstrap-only and should be edited in a SEPARATE commit when project rules / structure change.

### Source Spec

- `docs/v3-multi-agent-rewrite-spec.md` — the source spec for the v2 → v3 rewrite. Useful background reading: AGENTS.md governance, Claude Code `/recap` behavior, commands→skills migration, CLI > MCP rationale, phase-by-phase verification commands.

### Legacy

The v2 architecture ("Claude Code Multi-Agent Coordination System" with 5 internal specialists + `/setup-agents` / `/ready` / `/recap` slash commands) is preserved on the `v2-archive` branch.

## AI Agent Workflow

### Codex CLI Role

Codex CLI loads this file natively. Use Codex for: precise diff-style edits to skills or templates, deterministic Markdown reformatting, token-budget-sensitive work.

### Antigravity CLI Role

Antigravity CLI (`agy`) loads this file natively (no `@import` needed, same as Codex). Use Antigravity for: long-context reads (e.g., scanning the whole `v2-archive` for a buried convention), multimodal review of screenshots in spec drafts, well-specified sub-tasks where ~5 prompt constraints fully define the work.

### Gemini CLI Role (legacy — sunsets 2026-06-18)

Gemini CLI loads this file via `@./AGENTS.md` import in `GEMINI.md`. Free tier deprecates 2026-06-18 per [Google announcement](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/) — migrate to Antigravity CLI before deadline. Until then, same role-fit as Antigravity.

## Tool Preference: CLI over MCP

When a service offers both a CLI and an MCP server, prefer the CLI. Reasons:

- **Token efficiency.** Benchmarks (Firecrawl / Arize, 2025) show ~17x fewer tokens per task for CLI vs MCP at 10k ops/month — 1.3-8.7k tokens (CLI) vs 32-82k tokens (MCP).
- **Cross-agent auth.** CLI auth lives in `~/.config/<tool>/` and is shared across Claude / Codex / Antigravity / Gemini. MCP OAuth is per-agent.
- **Reliability.** CLI flow is one process call; MCP adds a server hop.

### Preferred CLIs

| Service | Preferred CLI | Notes |
|---|---|---|
| GitHub | `gh` | Widely installed, mature. |
| Google Workspace (Gmail / Calendar / Drive) | `gws` | Official Google CLI, pre-1.0 as of 2026-05. |
| Google Drive bulk ops | `rclone` | Mature alternative to `gws` for large transfers. |
| Notion | `ntn` | Official, young. |
| Browser scripted flows | Playwright CLI | Mature; use Playwright Python for headless automation. |
| JIRA | `acli` | Atlassian official, GA 2026. |

### Stay on MCP (no viable CLI)

- **Canva** — no design content management CLI.
- **chrome-devtools** — interactive debug; CLI surface too thin.
- **context7** — library docs lookup; MCP is the primary interface.

## Project Structure & Module Organization

```
cc-templates/
├── AGENTS.md              ← this file (canonical context)
├── CLAUDE.md              ← thin @AGENTS.md + Current Sprint Status
├── GEMINI.md              ← thin @./AGENTS.md
├── README.md              ← user-facing readme
├── CHANGELOG.md           ← release history
├── LICENSE                ← MIT
├── .version               ← source-of-truth version (v3.0.0)
├── .gitignore             ← includes .claude/*, .gemini/, .agents/
├── .claude/
│   └── skills/
│       ├── wrap/SKILL.md
│       ├── ready/SKILL.md
│       └── setup-multi-agent/SKILL.md
├── docs/
│   └── v3-multi-agent-rewrite-spec.md
└── templates/
    ├── AGENTS.md.template
    ├── CLAUDE.md.template
    ├── GEMINI.md.template
    ├── gitignore-additions.txt
    └── setup-instructions.md
```

## Build, Test, and Development Commands

There is no build step. To test changes:

- `cat templates/AGENTS.md.template` — verify placeholders are intact.
- For a smoke test of the bootstrap flow, copy `templates/*` into a scratch directory and run the verification commands from `templates/setup-instructions.md`.

## Coding Style & Naming Conventions

- Markdown: ATX headings (`# ` not `===`). No trailing whitespace. UTF-8.
- Skill files: `.claude/skills/<kebab-name>/SKILL.md`. Frontmatter requires `name:` and `description:`.
- Templates use `{{PLACEHOLDER}}` for substitution sites. Names are SCREAMING_SNAKE_CASE.
- Bash scripts: `#!/bin/bash` shebang, `set -e`, no `set -u` (the v2 hook relies on optional vars).

## Testing Guidelines

Manual until automated tests are added. The acceptance criteria per phase live in `docs/v3-multi-agent-rewrite-spec.md`. Before merging changes to skills or templates, run a fresh-terminal verification of `claude --print`, `codex exec`, `agy` (Antigravity CLI), and `GEMINI_CLI_TRUST_WORKSPACE=true gemini -p` (legacy, until 2026-06-18) per the README and `templates/setup-instructions.md`.

## Commit & Pull Request Guidelines

- Commit subjects use conventional prefixes: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`.
- For v3-era spec-driven commits, the v3 phases use `feat(v3): phase N — <summary>`.
- Subject line ≤ 72 chars. Body wraps at ~80 cols.
- `.version` is bumped manually in a dedicated commit that touches only `.version` and `CHANGELOG.md` (no `templates/` edits in the same commit). Use SemVer: breaking change → major, new feature → minor, fix → patch.

## Security & Configuration Tips

- No secrets in this repo. `.env` patterns are still in `.gitignore` defensively.
- Existing clones that still have the old local hook can remove it with `rm .git/hooks/pre-commit`.
- `.claude/*` is gitignored except `settings.json` and `skills/` — keeps personal session data (history.jsonl, ide/, etc.) out of git while still letting `skills/` be shipped.

<!-- sprint-status:start -->

## Current Sprint Status

**Last Updated:** 2026-06-25 (Session 2 — v4 SSOT migration: sprint state moved from CLAUDE.md to AGENTS.md)
**Active Work:** cc-templates v4 shipped. Bootstrap layout migrated — new projects get sprint-status block in AGENTS.md; `CLAUDE.md` is now a 1-line `@AGENTS.md` pointer. Aligns with cross-tool AGENTS.md standard (Linux Foundation Agentic AI Foundation, 2025-12; 60k+ repos).
**Previous Milestone:** ✅ v3.9.1 (2026-05-29) — rolling-window enforcement fix.

### Session 2 (2026-06-25) highlights

- **Sprint state moved CLAUDE.md → AGENTS.md** (sprint-status block between `<!-- sprint-status:start -->` / `<!-- sprint-status:end -->` markers). Matches the pattern downstream consumers (Anchor, jsdesign-landing-page) were already running ad-hoc.
- **`.claude/skills/wrap/SKILL.md` rewritten.** Hardcoded AGENTS-SSOT target; archive step + rolling-window step removed (7 steps → 5). 119 lines → 89 lines.
- **`templates/CLAUDE.md.template` reduced 28 lines → 1 line** (just `@AGENTS.md`). Sprint-status block + auto-update instructions removed — moved into `templates/AGENTS.md.template`.
- **`templates/AGENTS.md.template` gains sprint-status block** at bottom with Session 1 placeholder + Sprint Wrap Procedure section.
- **`.claude/skills/ready/SKILL.md`** + **`.claude/skills/setup-multi-agent/SKILL.md`** + **`templates/setup-instructions.md`** updated for new pattern (`{{TODAY}}` now in AGENTS.md, not CLAUDE.md).
- **`.claude/sessions/session-history.md` removed** (stale 2024-12-17 pre-v3 entries; git history is the v4 archive).
- **cc-templates dogfooded** — own AGENTS.md / CLAUDE.md migrated to match the template output.

### Next session start

> Smoke-test the v4 bootstrap end-to-end: run `/setup-multi-agent` against a scratch directory and verify the produced AGENTS.md has the sprint-status block + CLAUDE.md is one line. Existing v3.x projects (Anchor, jsdesign-landing-page) already AGENTS-SSOT in practice — no downstream migration needed.
>
> Open items: Gemini CLI sunset has passed (2026-06-18, 7 days ago) — decide whether to drop `templates/GEMINI.md.template` + own `GEMINI.md` in a follow-up commit, or leave one more grace cycle for any straggler users.

---

### Sprint Wrap Procedure

Note: Claude Code's built-in `/recap` is a one-line synopsis (auto-fires after terminal idle); it does NOT do this full wrap. For a real session wrap, invoke the `/wrap` skill.

1. Update "Last Updated" / "Active Work" / "Previous Milestone" header lines with the new session.
2. Replace "Session N highlights" + "Next session start" blocks with the new session's content. Older sessions live in git history — retrieve via `git log --grep="wrap Session" -- AGENTS.md` then `git show <hash> -- AGENTS.md`.
3. Keep this sprint-status block under ~80 lines (highlights + next-session triggers only; project context lives in the rest of this file).
4. Commit subject: `chore: wrap Session N — <one-line summary>`. Wrap commits should only touch this sprint-status block — if other sections of AGENTS.md need an update (project rules, sub-agent roles, etc.), make a SEPARATE commit before/after the wrap.

<!-- sprint-status:end -->
