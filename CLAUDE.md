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

> Smoke-test `/wrap`, `/ready`, and `/setup-multi-agent` in a real working session. Audit `scripts/update-claude-global.sh` (still references v2 paths) and decide: update for v3 layout, or drop in favor of a simpler README-documented `cp -r templates/* <new-project>/` flow.

---

## Auto-Update Instructions (for `/wrap` skill)

1. Update "Current Sprint Status" with a new session block (5-7 bullets max).
2. Archive the previous session's block to `.claude/sessions/session-history.md` (newest entries at top).
3. If `session-history.md` exceeds 10 entries, move the oldest to `.claude/sessions/session-history-archive.md`.
4. Do NOT modify `AGENTS.md` — project context lives there and is stable across sessions.
5. Keep this file under ~80 lines (sprint state + auto-update only).
