# Changelog

All notable changes to cc-templates. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows [SemVer](https://semver.org/spec/v2.0.0.html).

## [v3.3.0] — 2026-05-22

### Added

- `templates/AGENTS.md.template` — append "Dispatch pattern" paragraph to the Multi-CLI Parallel Workflow section. Claude writes delegation briefs to a file (suggested `<briefs-dir>/<cli>-current.md`); user dispatches with one-line reference and reports agent-done with branch name only. Reduces per-round copy-paste between Claude / Codex / Gemini terminals from ~250 lines to ~4 sentences.

### Rationale

Follow-up from v3.2.0 multi-CLI workflow additions. Downstream Anchor S67 trial highlighted that brief content and agent-output content are both reproducible from git (PR body, diffs, logs) — pasting them into chat is wasted human attention. The brief-in-file + branch-name-signal pattern eliminates that waste without adding tooling.

## [v3.2.0] — 2026-05-22

### Added

- `templates/AGENTS.md.template` — expanded **Codex CLI Role** + **Gemini CLI Role** with shared **Branch & Push Rules** subsection (PR flow, no self-merge, `<cli>/<task-slug>` naming, `Co-Authored-By` trailer per vendor, no branch-deploys).
- `templates/AGENTS.md.template` — new **Multi-CLI Parallel Workflow** section: `git worktree add ../<project>-codex` / `../<project>-gemini` pattern for running 2+ CLIs concurrently on the same repo without shared-state branch-switch conflicts. Includes orchestration brief rule (Claude omits deploy command from delegated briefs).

### Rationale

Downstream Anchor project trial (2026-05-22, S67) ran Codex + Gemini in parallel for the first time and surfaced two reproducible failure modes worth codifying upstream:

1. **Shared worktree panic** — Codex and Gemini launched in the same directory; Gemini's branch checkout under Codex caused "stale `M file`" mid-session and stalled Codex at the spec-approval checkpoint.
2. **Branch-deploy desync** — Claude's delegation brief included a "same session must deploy" instruction; Codex followed it literally and shipped from its feature branch, putting prod ahead of `main` until the PR merged.

Both are pure workflow/process learnings, generalizable to any multi-CLI project. No Anchor-specific behavior in the template additions.

## [v3.0.0] — 2026-05-22

A full rewrite. v3 reframes cc-templates from a single-CLI multi-specialist coordination system (v2) into a multi-CLI (Claude Code + Codex CLI + Gemini CLI) project bootstrap with a shared `AGENTS.md` canonical config.

### Breaking changes

- **Architecture rewrite.** v2's "Claude Code Multi-Agent Coordination System" (5 internal specialist agents + slash commands) is gone. v3 is about coordinating multiple coding CLIs (Claude / Codex / Gemini) via a shared `AGENTS.md`, not multiple sub-agents inside a single CLI.
- **`/recap` removed.** Claude Code v2.1.108+ ships a built-in `/recap` (one-line synopsis triggered after terminal idle) that cannot be overridden. The session-end full recap is renamed to `/wrap`.
- **Directory removals.** `agents/`, `commands/`, `project-templates/`, `system/`, and the legacy `templates/{agents,commands,hooks,system,CLAUDE.md}` are removed from `main`. All preserved on the [`v2-archive`](https://github.com/FuzzyKala/cc-templates/tree/v2-archive) branch.

### Added

- `AGENTS.md.template` — canonical project context skeleton, aligned with the [Linux Foundation AAIF spec](https://agents.md/) (formed 2025-12-09; founding members include Anthropic, OpenAI, Google, AWS, Microsoft, Cloudflare, Bloomberg). Sections: Personal Working Agreement (7 rules), Project Context, Documentation Navigation, AI Agent Workflow (Codex + Gemini role notes), Tool Preference: CLI over MCP, Project Structure, Build / Test / Style / Commit conventions, Security tips.
- `CLAUDE.md.template` — thin `@AGENTS.md` wrapper + Current Sprint Status section with `{{TODAY}}` placeholder + auto-update instructions for the `/wrap` skill.
- `GEMINI.md.template` — single `@./AGENTS.md` line. (Gemini CLI does not follow symlinks at the `GEMINI.md` path; this is a real file, not a symlink.)
- `templates/gitignore-additions.txt` — `.claude/*` (preserving `settings.json` and `skills/`), `.agents/`, `.gemini/`.
- `templates/setup-instructions.md` — 5-step human checklist for manual bootstrap.
- `.claude/skills/wrap/SKILL.md` — session-end full recap with 10-session rolling window; overflow moves to `.claude/sessions/session-history-archive.md`.
- `.claude/skills/ready/SKILL.md` — read-only project context scanner (AGENTS.md + CLAUDE.md + git status + installed skills + CLI tool matrix). Drops v2's 5-specialist agent-count validation.
- `.claude/skills/setup-multi-agent/SKILL.md` — bootstraps a new project from `templates/` with placeholder substitution and `.gitignore` patching.
- `docs/v3-multi-agent-rewrite-spec.md` — the source spec for this rewrite (includes background research findings on AGENTS.md governance, Claude Code `/recap` behavior, commands→skills migration, and the CLI > MCP rule).
- README rewrite explaining the multi-CLI framing, with verification commands using `claude --print`, `gemini -p`, `codex --print`.
- GitHub repo description + topics updated for v3: `agents-md`, `claude-code`, `codex-cli`, `gemini-cli`, `multi-agent`, `bootstrap`, `template`.

### Migration

There is no automatic migration path. If you previously used cc-templates v2:

1. Run `/setup-multi-agent` (or the manual 5-step process in `templates/setup-instructions.md`) inside your v2-equipped project — it drops `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` alongside your existing v2 files.
2. Manually remove `.claude/agents/`, `.claude/commands/`, `.claude/system/` from your project once you have confirmed the new config loads.

The v2 architecture lives on the [`v2-archive`](https://github.com/FuzzyKala/cc-templates/tree/v2-archive) branch indefinitely.

### Carried over

- `LICENSE` (MIT), `.gitignore` baseline.
- `scripts/update-claude-global.sh` is kept for now but references v2 layout; audit + decide in a future session.

## v2.x and earlier

See the [`v2-archive`](https://github.com/FuzzyKala/cc-templates/tree/v2-archive) branch and its git log for the v2 history.
