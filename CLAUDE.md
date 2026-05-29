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

### Recently resolved follow-ups

- **Global rule 7 sync — Personal Working Agreement mirrors.** Closed 2026-05-27 — `AGENTS.md` (cct dogfood) + `templates/AGENTS.md.template` now carry the "no fabrication, and keep critical thinking" rule 7 wording matching global `~/.claude/CLAUDE.md`. Synced naturally during the Gemini → Antigravity CLI migration commit.
- **Gemini CLI → Antigravity CLI migration.** Closed 2026-05-27 — Google announced Gemini CLI free-tier sunset for 2026-06-18 (announcement 2026-05-19, see <https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/>). Templates and dogfood docs updated to lead with Antigravity CLI (`agy`) as the canonical third agent; Gemini CLI remains documented as legacy for the 22-day transition window. `GEMINI.md` template still ships until sunset.

- **`/setup-multi-agent` template path discovery hardening.** Closed 2026-05-26 — added Step 0 to `SKILL.md` that resolves the skill's own base directory via `readlink -f` and ascends three levels to derive `<cct-repo>/templates/`, with explicit four-file existence check. Steps 3 and 4 now reference the resolved `${TEMPLATES_DIR}`. Fixes the wasted first `Bash` call observed in S220's fresh-terminal e2e test.
- **`.version` SemVer anomaly — auto-bump policy.** Closed 2026-05-26 — removed auto-bump policy per PR #3 (Codex). `.version` now manual.
- **`/setup-multi-agent` README documentation gap.** Closed 2026-05-26 — README "Skill installation" section added between Quick start and Architecture per PR #2 (Gemini).

---

## Auto-Update Instructions (for `/wrap` skill)

1. Update "Current Sprint Status" with a new session block (5-7 bullets max).
2. Archive the previous session's block to `.claude/sessions/session-history.md` (newest entries at top).
3. If `session-history.md` exceeds 5 entries, delete the oldest — git history is the deep archive (no `session-history-archive.md`).
4. Do NOT modify `AGENTS.md` — project context lives there and is stable across sessions.
5. Keep this file under ~80 lines (sprint state + auto-update only).
