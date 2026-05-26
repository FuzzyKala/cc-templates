@AGENTS.md

---

## Current Sprint Status

**Last Updated:** 2026-05-22 (Session 1 — v3 launch)
**Active Work:** v3 rewrite complete; cc-templates now dogfoods its own templates.

### Session 1 highlights

- v3 rewrite of cc-templates per `docs/v3-multi-agent-rewrite-spec.md` (phases 0-5).
- Replaced v2's "Claude Code Multi-Agent Coordination System" framing with multi-CLI (Claude Code + Codex CLI + Gemini CLI) bootstrap pattern.
- Migrated v2 `commands/*.md` to v3 `.claude/skills/*/SKILL.md`: `/wrap`, `/ready`, `/setup-multi-agent`.
- Added 5 template files under `templates/` for `setup-multi-agent` to consume.
- Removed v2 directories (`agents/`, `commands/`, `project-templates/`, `system/`, legacy `templates/{agents,commands,hooks,system,CLAUDE.md}`) from `main`; all preserved on `v2-archive`.
- Bumped `.version` to v3.0.0 and added `CHANGELOG.md`.
- Dogfooded: cc-templates' own root now has `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` per the v3 pattern.

### Next session start

> Smoke-test `/wrap` and `/ready` in a real working session. (`scripts/` audit is done — both scripts removed as v2-obsolete; preserved on `v2-archive`.) Consider whether `/setup-multi-agent` should auto-detect tech stack as an enhancement, salvaging detection patterns from `v2-archive:scripts/project-detection.sh`.

**Carried follow-ups from S220 jsdesign cross-project e2e test (2026-05-22):**

1. **`/setup-multi-agent` skill — template path discovery hardening.** During S220 fresh-terminal e2e test, the skill's first `Bash` call assumed `templates/` lived at `/home/kala/.claude/skills/setup-multi-agent/templates/` (next to the skill file itself) — that path does not exist; templates live in the cc-templates repo at `templates/`. The skill recovered via a second Bash call to the correct path, so the e2e succeeded, but the first call wasted a tool turn + exit code 2 noise. Fix: in `.claude/skills/setup-multi-agent/SKILL.md` step 2 ("Sanity-check / locate templates"), resolve the skill's own SKILL.md location, follow symlinks if present (via `readlink -f` or shell equivalent), then derive the cct repo root as `<resolved>/../../..` and look for `templates/` there. This makes the skill robust whether invoked from a symlinked install (`~/.claude/skills/setup-multi-agent` → `<cct-repo>/.claude/skills/setup-multi-agent/`) or directly inside cct. Empirical verification on 2026-05-22: Claude Code DOES follow symlinks for skill discovery (confirmed S220 test), so the readlink-resolve-then-up-three-dirs pattern works.

2. **Acceptable drift — global rule 7 vs cct mirrors.** Global `~/.claude/CLAUDE.md` rule 7 was updated 2026-05-22 to add a "keep critical thinking" clause. The Personal Working Agreement mirror in `AGENTS.md` (cct dogfood) + `templates/AGENTS.md.template` still has the old rule 7 wording. Sync next time you naturally touch either file; do not make a separate commit just for this.

### Recently resolved follow-ups

- **`.version` SemVer anomaly — auto-bump policy.** Closed 2026-05-26 — removed auto-bump policy per PR #3 (Codex). `.version` now manual.
- **`/setup-multi-agent` README documentation gap.** Closed 2026-05-26 — README "Skill installation" section added between Quick start and Architecture per PR #2 (Gemini).

---

## Auto-Update Instructions (for `/wrap` skill)

1. Update "Current Sprint Status" with a new session block (5-7 bullets max).
2. Archive the previous session's block to `.claude/sessions/session-history.md` (newest entries at top).
3. If `session-history.md` exceeds 10 entries, move the oldest to `.claude/sessions/session-history-archive.md`.
4. Do NOT modify `AGENTS.md` — project context lives there and is stable across sessions.
5. Keep this file under ~80 lines (sprint state + auto-update only).
