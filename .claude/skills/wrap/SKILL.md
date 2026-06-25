---
name: wrap
description: Session-end full recap — distill the session, codify lessons as persistent memory, then replace the AGENTS.md sprint-status block (between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`) with the new session's content. Older sessions live in git history; no rolling-window archive file is maintained. Run at end of a working session before closing the terminal. Distinct from Claude Code's built-in `/recap` (one-line synopsis triggered after terminal idle).
---

# /wrap — Session-end full recap

You are wrapping up a working session. Distill what happened, codify session lessons as persistent memory so future sessions inherit them automatically, then update the `AGENTS.md` sprint-status block so the next session can resume cleanly.

**Assumed file layout** — this skill targets the AGENTS.md SSOT pattern that is now the cross-tool standard (Linux Foundation Agentic AI Foundation, 2025-12; 60k+ repos):

- `AGENTS.md` at repo root contains the sprint-status block between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` markers. Project rules / agent roles / tooling notes live in the same file above the markers.
- `CLAUDE.md` is a thin pointer that `@AGENTS.md`-imports (Claude Code does not yet natively support AGENTS.md). It is byte-stable across sessions — wrap never touches it.
- No `.claude/sessions/session-history.md` rolling window — git history is the deep archive (`git log --grep="wrap Session" -- AGENTS.md`).

If a project does not follow this layout (no `<!-- sprint-status:start -->` marker in `AGENTS.md`), stop and ask the user how to handle it rather than guessing.

## Steps

### 1. Detect current session number and date

- Read `AGENTS.md` at repo root.
- Locate the sprint-status block between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`. The session number lives in the `**Last Updated:**` line (format: `**Last Updated:** YYYY-MM-DD (Session N — title)`).
- Today's date comes from the shell (`date +%Y-%m-%d`). Do NOT trust dates in the user's prompt.
- The new session number is `N + 1`.

### 2. Distill the session

From the current conversation, write a distillation that scales with session content. Cover:

- Key changes shipped (files, features, decisions).
- Lessons learned or surprises worth remembering.
- Tasks completed.
- Follow-ups deferred to next session.

**Length scales with session complexity, not template.** A trivial fix gets 3-5 bullets; a deep multi-round review may need 30+ bullets. Don't pad mechanical sessions to hit a quota; don't compress complex sessions to fit one. If a session shipped 1 LoC and 4 commits of housekeeping, 30 lines is plenty.

Keep each bullet ≤ 2 lines. No filler.

### 3. Codify session memory

Turn this session's lessons into persistent memory entries so future sessions inherit them automatically.

Identify candidates per `~/.claude/CLAUDE.md` "Types of memory" (feedback / project / user / reference). Drop anything in "What NOT to save" (code patterns, file paths, ephemeral state, things already documented in CLAUDE.md / AGENTS.md).

Show the user a one-line list of candidates with type labels and ask for confirmation / drops / edits BEFORE writing. (Empirically most candidates earn their slot, but the gate prevents low-value entries from inflating MEMORY.md.)

For each confirmed candidate:

1. Write a new memory file under the project's memory dir at `~/.claude/projects/<path-encoded-as-dashes>/memory/`. Use the frontmatter format from `~/.claude/CLAUDE.md` "How to save memories": `name` (kebab-case slug), `description` (one-line hook used to decide relevance in future conversations), `metadata.type`. For feedback / project types, structure the body as: rule/fact, then `**Why:**` and `**How to apply:**` lines.
2. Add a one-line index pointer to `MEMORY.md` in the same dir: `- [Title](file.md) — one-line hook`. Keep `MEMORY.md` under ~200 lines (it auto-loads into every conversation).
3. Link related memories with `[[name]]` in the body.

**Commit shape**: when memory candidates exist, codify them as a separate `chore(memory): codify N entries from Session N` commit BEFORE the Step 5 wrap commit. Do NOT push from the memory commit — the wrap commit's subsequent push carries both. This keeps memory and wrap independently revertable but ships them together. If the project uses a separate wrap script (e.g. Anchor's `scripts/wrap-session.sh`), let that script handle the wrap commit + push in Step 5 instead.

Skip this step if no candidates are worth codifying. Expected outcome for trivial / mechanical sessions (doc tweaks, small renames, status checks).

### 4. Update the AGENTS.md sprint-status block

Replace the contents between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` in `AGENTS.md` with the new session's content. Block format:

- Header lines: `**Last Updated:** YYYY-MM-DD (Session N — <title>)`, `**Active Work:** <one-line description>`, `**Previous Milestone:** ✅ <prior session>`.
- `### Session N (YYYY-MM-DD) highlights` — bullets covering what shipped this session (≤ 2 lines each).
- `### Next session start` — trigger list for what to pick up next. Specific filenames / commands / decisions.
- Optional operational footer.

Keep the whole block under ~80 lines — highlights + next-session triggers only; project context lives in the rest of `AGENTS.md`.

**Only touch the sprint-status block.** Do NOT modify other sections of `AGENTS.md` (project rules, agent role descriptions, tooling preferences, etc.) in the wrap commit — those are stable across sessions. If a stable rule changed this session, make a SEPARATE commit before or after the wrap.

**Do NOT modify `CLAUDE.md`.** It is a thin pointer that `@AGENTS.md`-imports; sprint state never lives there.

Older sessions remain recoverable from git history — `git log --grep="wrap Session" -- AGENTS.md` lists past wrap commits, then `git show <sha> -- AGENTS.md` shows that session's snapshot.

### 5. Commit and push

Stage `AGENTS.md`. Commit with:

```
chore: wrap Session N — <one-line summary>
```

Then `git push origin <current-branch>` — this push also carries the Step 3 memory commit if one was made.

If the project uses a separate wrap script (e.g. Anchor's `scripts/wrap-session.sh`), let that script handle the wrap commit + push instead of running them manually here.

If the commit message body would help future readers, add one short paragraph after the subject. Do not include a Claude attribution line unless the project's prior commit history shows one.

## Acceptance check the agent should self-verify

- For each confirmed memory candidate: a new file exists under `~/.claude/projects/<slug>/memory/` AND a matching pointer line exists in that dir's `MEMORY.md`. If a separate `chore(memory)` commit was used, it sits behind the wrap commit on the same branch.
- `AGENTS.md` sprint-status block now opens with the new session block; the previous session's highlights / next-session triggers are gone from `AGENTS.md`.
- Other sections of `AGENTS.md` (project context, agent roles, etc. above the sprint-status markers) are byte-identical to before.
- `CLAUDE.md` is byte-identical to before.
- `git log -1` shows the new wrap commit; `git status` is clean.
- `git log origin/<branch>..HEAD` is empty after push — both memory commit (if any) and wrap commit are on remote.
