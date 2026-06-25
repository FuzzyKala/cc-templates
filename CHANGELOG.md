# Changelog

All notable changes to cc-templates. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows [SemVer](https://semver.org/spec/v2.0.0.html).

## [v4.1.0] — 2026-06-25

Two cleanups: drop the `Sprint Wrap Procedure` section from `AGENTS.md` (the `/wrap` skill is the single source of truth — no need to duplicate procedural docs in every project's `AGENTS.md`), and retire Gemini CLI infrastructure (Gemini CLI free tier sunset 2026-06-18; Antigravity CLI `agy` is the active Google CLI). Also fixes the v4.0.0 oversight that left `README.md` in v3 framing.

### Breaking changes

- **`GEMINI.md.template` removed.** `/setup-multi-agent` no longer creates a `GEMINI.md` in bootstrapped projects. Existing v3.x projects that still ship a `GEMINI.md` can leave it — nothing in v4.1.0 requires its removal — but new projects only get `AGENTS.md` + `CLAUDE.md`. Existing `GEMINI.md` files become inert (Gemini CLI is sunset).
- **`Sprint Wrap Procedure` section removed from `AGENTS.md` (own dogfood + template).** The `/wrap` skill encodes the same steps. Projects bootstrapped from v4.0.0 templates carry the now-deleted section; `/wrap` still works regardless (the skill no longer cross-references the section), but you can manually delete the section from your `AGENTS.md` to match the new template.

### Changed

- **`templates/AGENTS.md.template`** — Sprint Wrap Procedure section removed; all Gemini-related sections / mentions removed (Gemini CLI Role section, `GEMINI.md` Documentation Navigation entry, "Claude / Codex / Antigravity / Gemini" → "Claude / Codex / Antigravity", commit-trailer Gemini noreply, sub-agent prompt warning, `GEMINI.md` in Session 1 placeholder).
- **`templates/setup-instructions.md`** — `5 steps → 4 steps` (dropped GEMINI.md cp step). Gemini verification command removed. `git add` line dropped `GEMINI.md`. "Why multiple files" section simplified to "Why a CLAUDE.md wrapper".
- **`templates/gitignore-additions.txt`** — `.gemini/` retained (Antigravity CLI uses `~/.gemini/antigravity-cli/`) but comments rewritten to reflect Antigravity-only ownership; v3 header bumped to v4.
- **`.claude/skills/wrap/SKILL.md`** — Step 4 inlines the sprint-status block format description (header lines / `### Session N highlights` / `### Next session start` / optional footer; ~80-line cap) instead of cross-referencing the deleted "Sprint Wrap Procedure" section.
- **`.claude/skills/setup-multi-agent/SKILL.md`** — drops Gemini from the trio framing (now "AGENTS.md + CLAUDE.md pair"), removes Gemini template from Prerequisites / Step 0 file-check loop / Step 3 substitution rules, replaces Gemini verification command in Step 5 with Antigravity (`agy`), drops Gemini CLI install URL.
- **`README.md`** — modernized for v4 SSOT (the bits missed in v4.0.0). `/wrap` description no longer mentions rolling window or CLAUDE.md as the wrap target. Architecture tree shows `AGENTS.md` + `CLAUDE.md` (no `GEMINI.md`). "CLAUDE.md is the only file that changes session-to-session" sentence replaced with "AGENTS.md holds everything — stable context above markers, sprint-status below". Version badge v3 → v4. Drops all Gemini bullets from "What this is" / verification commands / architecture / user-level rules / "Skills included" / cross-agent auth / References.
- **cc-templates dogfooding** — own `AGENTS.md` mirrors all template changes: Sprint Wrap Procedure section removed, Gemini sections removed, Documentation Navigation cleaned, Testing Guidelines no longer mentions `gemini -p`.

### Removed

- **`GEMINI.md`** (own dogfood) and **`templates/GEMINI.md.template`** — Gemini CLI free tier sunset 2026-06-18, 7 days before this release. v4.0.0's own sprint-status block already flagged this as an open item ("decide whether to drop … or leave one more grace cycle for any straggler users"); 7 days later, no straggler use case justifies maintaining the templates.

### Migration

For existing v3.x or v4.0.0 projects:

- **If you still use Gemini CLI somehow** (e.g. paid tier): keep your existing `GEMINI.md`; v4.1.0 just stops shipping the template. Nothing in your project breaks.
- **Optional cleanup of `Sprint Wrap Procedure` section in your `AGENTS.md`** (only matters if you bootstrapped from v4.0.0 template, or used the jsdesign / Anchor pattern that ships the same section): in your `AGENTS.md`, delete the block between `---` and `<!-- sprint-status:end -->` that begins with `### Sprint Wrap Procedure`. The `/wrap` skill works either way.

### Rationale

The Sprint Wrap Procedure section was added in v4.0.0 on the assumption that `AGENTS.md` should be self-documenting about its own update procedure. Two sessions of actual usage (downstream Anchor + jsdesign) confirmed it's pure duplication — the procedure lives in `/wrap` SKILL.md, and the `AGENTS.md` copy never gets read because users invoke `/wrap` instead of reading the procedure. Token cost (auto-loaded into every conversation) + drift risk outweigh the self-documentation argument.

The README modernization was a v4.0.0 oversight — only the templates / skills / dogfood AGENTS got migrated; the user-facing README still framed `CLAUDE.md` as the session-state holder. Riding with v4.1.0 closes the gap.

### Notes

- `docs/v3-multi-agent-rewrite-spec.md` still references `gemini -p` verification commands and `GEMINI.md` — intentionally left unchanged as historical record of the v3 rewrite.
- `.version` bumped to v4.1.0 in a separate dedicated commit per project policy (.version + CHANGELOG.md only).

## [v4.0.0] — 2026-06-25

Sprint state migrates from `CLAUDE.md` (under a `## Current Sprint Status` section) to a `<!-- sprint-status:start -->` / `<!-- sprint-status:end -->` block at the bottom of `AGENTS.md`. `CLAUDE.md` becomes a 1-line `@AGENTS.md` pointer. Aligns with the AGENTS.md SSOT convention that became cross-tool standard in 2025-12 (Linux Foundation Agentic AI Foundation; 60k+ repos read AGENTS.md natively).

### Breaking changes

- **Sprint state location.** Projects bootstrapped from v4 templates have sprint state in `AGENTS.md`, not `CLAUDE.md`. Existing v3.x projects need manual migration (see Migration below).
- **`/wrap` skill no longer reads CLAUDE.md sprint-status.** The skill now targets the AGENTS.md sprint-status block. If invoked on a project whose `AGENTS.md` has no `<!-- sprint-status:start -->` marker, it stops and asks the user how to handle it rather than guessing.
- **No more `.claude/sessions/session-history.md` rolling-window file.** Git history is the deep archive — `git log --grep="wrap Session" -- AGENTS.md` lists past wraps, `git show <sha> -- AGENTS.md` recovers any session's snapshot. The Step 4 (Archive) and Step 6 (5-session rolling window) sub-steps from `/wrap` v3 are removed entirely.

### Changed

- **`templates/AGENTS.md.template`** — gains `<!-- sprint-status:start -->` / `<!-- sprint-status:end -->` block at the bottom with Session 1 placeholder + Sprint Wrap Procedure section. `{{TODAY}}` placeholder moves here from `templates/CLAUDE.md.template`. Documentation Navigation "Current Sprint State" section repoints to the in-file block.
- **`templates/CLAUDE.md.template`** — reduced from 28 lines to 1 line (`@AGENTS.md`). Sprint state + auto-update instructions removed (sprint state moved to AGENTS.md template; auto-update instructions superseded by the in-template "Sprint Wrap Procedure" + the `/wrap` skill's own steps).
- **`templates/setup-instructions.md`** — Step 2 + Step 5 updated for the new placeholder location and CLAUDE.md role.
- **`.claude/skills/wrap/SKILL.md`** — rewritten (119 → 89 lines). 7 steps → 5; Step 1 detects via AGENTS.md sprint-status block; Step 4 (was 5) replaces the block; archive + rolling-window steps deleted. Frontmatter description + intro updated. Includes an "Assumed file layout" preamble that hard-fails (asks user) if the project does not have the expected SSOT layout.
- **`.claude/skills/ready/SKILL.md`** — description + Step 2 + report template + "What NOT to do" updated to read sprint state from AGENTS.md.
- **`.claude/skills/setup-multi-agent/SKILL.md`** — Step 3 substitution rules + Step 6 summary updated. `{{TODAY}}` now substituted in AGENTS.md (was CLAUDE.md).
- **cc-templates dogfooding** — own `AGENTS.md` migrated to v4 pattern (sprint-status block at bottom, Session 2 entry); own `CLAUDE.md` reduced to 1 line.

### Removed

- **`.claude/sessions/session-history.md`** — stale 2024-12-17 pre-v3 entries. Under v4, git history is the archive (no rolling-window file).

### Migration

There is no auto-migration. For existing v3.x projects, either re-bootstrap via `/setup-multi-agent` and copy your sprint state into the new AGENTS.md block, or hand-migrate:

```bash
# In your v3.x project:
# 1. Open AGENTS.md and append at the bottom:
#      <!-- sprint-status:start -->
#      [paste the ## Current Sprint Status section from CLAUDE.md here]
#      <!-- sprint-status:end -->
# 2. Replace CLAUDE.md with the pointer (preserve any handful of imports you added):
#      echo '@AGENTS.md' > CLAUDE.md
# 3. (Optional) Remove the stale archive:
#      git rm .claude/sessions/session-history.md  # git history retains it
# 4. Commit: feat: migrate to cc-templates v4 SSOT pattern
```

### Rationale

Downstream projects (Anchor + jsdesign-landing-page) had already adopted the AGENTS.md SSOT pattern ad-hoc — both keep sprint state in AGENTS.md, both have CLAUDE.md as `@AGENTS.md`. The `/wrap` skill kept pointing at CLAUDE.md, requiring manual workaround each session. v4 codifies what was already working downstream.

The AGENTS.md SSOT standard reached critical mass in 2025-12 when Linux Foundation accepted it under the Agentic AI Foundation (alongside MCP). 60k+ repos use it; native support across Codex, Cursor, GitHub Copilot Coding Agent, Gemini CLI, Aider, Windsurf, Zed, and 14+ other coding CLIs. Claude Code does not yet natively support AGENTS.md, so the `CLAUDE.md` → `@AGENTS.md` import workaround stays — but as a thin pointer only, never as a sprint-state location.

### Notes

- `GEMINI.md.template` retained for now; Gemini CLI sunset was 2026-06-18, 7 days before this release. A separate follow-up (v4.1.0 or v5.0.0) may drop it.
- `docs/v3-multi-agent-rewrite-spec.md` intentionally left unchanged — it is the historical record of the v3 rewrite, not current policy.
- `.version` bumped to v4.0.0 in a separate dedicated commit per project policy (.version + CHANGELOG.md only, no templates/ edits in the version-bump commit).

## [v3.9.1] — 2026-05-29

### Fixed

- **`/wrap` rolling-window enforcement now trims down to the cap, not just one entry.** Step 5 previously deleted only the single oldest entry when over the window, so a history that was already over the cap — e.g. right after the window was reduced 10→5 in v3.9.0 — would hover above 5 forever (each wrap adds one and removes one). It now deletes the oldest entries until exactly 5 remain, so an over-cap history self-heals on the next wrap.

### Removed

- **Local pre-commit auto-bump hook deleted.** The `.git/hooks/pre-commit` script that auto-bumped `.version` (flagged as a doc-vs-hook gap in the v3.7.0 notes) has been removed from the working clone. It was never tracked — per-clone only, see session 243 — so this is a local cleanup; `.version` is now genuinely manual, matching the policy documented since PR #3. This commit was therefore made without `--no-verify`.

## [v3.9.0] — 2026-05-29

### Changed

- **`/wrap` session-archive policy: stop maintaining a `session-history-archive.md`.** When the active history overflows the rolling window, the oldest entry is now deleted from `session-history.md` instead of being appended to an archive file — git history is the deep archive (every wrap commit preserves the prior state; recover with `git show <sha>:.claude/sessions/session-history.md`). Rationale: across all projects dogfooding this skill the archive feature triggered exactly once and produced 561 KB of never-read content that duplicated git history and the distilled memory store, while costing tokens to read+rewrite on each wrap. Updated `.claude/skills/wrap/SKILL.md` (description + steps 5-6 + acceptance check), `.claude/skills/ready/SKILL.md`, `CLAUDE.md` + `templates/CLAUDE.md.template` (Auto-Update Instructions), `AGENTS.md`, and `README.md`.
- **Rolling-window default tightened from 10 sessions to 5.** Keeps the auto-loaded active history leaner; a project can widen it via a note in its own `session-history.md` header.

### Notes

- `docs/v3-multi-agent-rewrite-spec.md` is intentionally left unchanged — it is the historical record of the v3 rewrite, not current policy.
- `.version` set manually to v3.9.0 and this commit made with `--no-verify` to bypass the still-installed pre-commit auto-bump hook (the doc-says-manual / hook-still-fires gap noted in the v3.7.0 entry remains open separate work).

## [v3.8.0] — 2026-05-29

### Added

- **`templates/deferred-work.md.template`** — new optional template. Active-backlog scaffold with a Dashboard index table at the top (D-N / Severity / Module / Title) plus the chronological body convention. For BMad-style spec-driven projects.
- **`templates/deferred-work-archive.md.template`** — new optional template. Sibling archive for shipped / resolved entries cut from `deferred-work.md` at ship time. HTML anchors preserve cross-reference IDs.
- **`templates/SPEC-INDEX.md.template`** — new optional template. Directory index for spec corpora, populated from spec `status:` + `title:` frontmatter. Non-done specs sorted first.
- **`templates/AGENTS.md.template` `## Document Conventions` section** — codifies the progressive-disclosure rule (Dashboard at top, body unchanged, archive split at ship time). Sourced from Anchor PR #27 + PR #28 (2026-05-28 / 2026-05-29).
- **`templates/setup-instructions.md` optional section** — instructions for copying the 3 new templates into BMad-style projects post-bootstrap.

### Notes

- Patterns originate from Anchor session work after the active `deferred-work.md` grew to 1638 lines / 102 D-N entries. The Dashboard index reduces per-query token cost by ~70% versus reading the full body, while keeping body structure intact.
- These templates are **optional** — the core bootstrap (AGENTS.md / CLAUDE.md / GEMINI.md / .gitignore) is unchanged.
- No auto-propagation to existing cct-bootstrapped projects. Each project copies the new templates manually if desired.

## [v3.7.0] — 2026-05-27

### Added

- **`templates/gitignore-additions.txt`:** add `.antigravitycli/` entry. This is the per-project state directory Antigravity CLI (`agy`) actually creates (verified in anchor S73, see anchor memory `reference-antigravity-cli-install`); defensive `.agy/` + `.antigravity/` entries from v3.6.0 also retained.

### Notes

- This is a v3.6.0 follow-up — the gitignore-additions safety net was incomplete in the migration commit. No template or template-text behavior change.
- The pre-commit hook that v3.5.0 announced as removed is still firing locally and auto-bumped this commit (v3.6.0 → v3.7.0). The policy gap (doc says manual, hook still automated) is real cct internal hygiene work and will be addressed in a separate session.

## [v3.6.0] — 2026-05-27

### Changed

- **Gemini CLI → Antigravity CLI migration across templates + dogfood docs.** Google announced 2026-05-19 that Gemini CLI free tier sunsets 2026-06-18, replaced by Antigravity CLI (`agy`). Reposition Antigravity as the canonical third agent across `README.md`, `AGENTS.md` (dogfood), `templates/AGENTS.md.template`, `templates/setup-instructions.md`, and `templates/gitignore-additions.txt`.
- **`### Gemini CLI Role`** template section renamed to **`### Antigravity CLI Role`** with a new **`### Gemini CLI Role (legacy — sunsets 2026-06-18)`** section retained for the transition window.
- **Branch examples** updated from `gemini/<task-slug>` to `agy/<task-slug>` across the Multi-CLI Parallel Workflow section.
- **Personal Working Agreement rule 7** synced to the current global `~/.claude/CLAUDE.md` wording ("no fabrication, and keep critical thinking; verification not validation"). Closes the carried follow-up tracked in `CLAUDE.md` since 2026-05-22.
- **`templates/gitignore-additions.txt`:** updated the `.gemini/` comment to note legacy + retention rationale (agy uses `~/.gemini/antigravity-cli/`). Added defensive `.agy/` + `.antigravity/` entries. (`.antigravitycli/` added separately in v3.7.0 follow-up.)

### Added

- **Anti-pattern guard for delegated CLIs** in the Multi-CLI Parallel Workflow section of `templates/AGENTS.md.template`: do NOT remove a worktree you were assigned to, do NOT switch the main worktree's branch, and do NOT skip opening a PR. Surface blockers back to Claude / user instead of self-recovering destructively. Sourced from anchor session 77 / 2026-05-27 incident (anchor memory `gemini-destructive-worktree-manipulation`).
- **Antigravity CLI transition link** added to the `### References` section of `README.md` ([Google announcement 2026-05-19](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/)).

### Rationale

Downstream projects (anchor + jsdesign-landing-page) ran agy through a 2/N trial: PR #11 host-header-redirect security fix (anchor S73) + PR #12 Callout component creation (anchor S77). Two distinct task shapes, zero incidents, free-tier quota survived two ships across 6 days. anchor session 78 (2026-05-27) committed to full migration; cct templates land the cross-project pattern so new bootstraps inherit the new arrangement automatically.

### Not changed

`GEMINI.md.template` is retained for the 22-day transition window — projects still on Gemini through 6/18 can continue bootstrapping via `cc-templates` without breaking. Full removal of `GEMINI.md.template` will follow Gemini's sunset.

## [v3.5.0] — 2026-05-26

### Changed

- **Policy change:** removed auto-bump of `.version` via pre-commit hook. `.version` is now bumped manually in dedicated commits.

### Rationale

Hook heuristic misclassified at least 3 times (see commits `9a16643`, `85766f5`, `4cdef5d`). Existing clones can remove the local hook with `rm .git/hooks/pre-commit`.

## [v3.4.0] — 2026-05-23

### Changed

- `templates/AGENTS.md.template` Multi-CLI Parallel Workflow section — worktree directory naming convention switched from model-based (`<project>-codex` / `<project>-gemini`) to function-based (`<project>-<function-slug>`). Branch name still encodes the CLI (`<cli>/<task-slug>`), so the worktree dir shows *what* is being worked on while the branch tells *who*. Examples expanded to cover the multi-instance case (e.g. 2 Geminis on different tasks). Added explicit cleanup guidance (`git worktree remove ../<project>-<function-slug>` post-merge).

### Rationale

Downstream jsdesign trial (S224, 2026-05-23) needed to plan a Phase A delegation involving potentially multiple Gemini instances (Codex quota constraint pushed user toward multi-Gemini parallel work). Model-based naming `<project>-gemini` can't host 2 Geminis concurrently — second instance would conflict on directory name. Function-based naming generalizes to any multi-instance case (multi-Codex, multi-Gemini, mixed) without ambiguity.

No breaking change: downstream consumers who already created `<project>-codex` / `<project>-gemini` worktrees can keep them; only new worktrees follow the function-based convention. Branch & Push Rules unaffected.

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
