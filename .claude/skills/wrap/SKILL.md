---
name: wrap
description: Session-end full recap — analyze current session, archive previous sprint state, update CLAUDE.md Current Sprint Status, maintain 10-session rolling window with overflow to archive. Run at end of a working session before closing the terminal. Distinct from Claude Code's built-in `/recap` (which is a one-line synopsis triggered after terminal idle).
---

# /wrap — Session-end full recap

You are wrapping up a working session. Produce a structured summary, archive the previous sprint state, and update `CLAUDE.md` so the next session can resume cleanly.

## Steps

### 1. Detect current session number and date

- Read `CLAUDE.md` at repo root.
- Locate the `## Current Sprint Status` section. The session number lives in the `**Last Updated:**` line (format: `**Last Updated:** YYYY-MM-DD (Session N — title)`).
- Today's date comes from the shell (`date +%Y-%m-%d`). Do NOT trust dates in the user's prompt.
- The new session number is `N + 1`.

### 2. Distill the session

From the current conversation, write 5-7 bullets covering:

- Key changes shipped (files, features, decisions).
- Lessons learned or surprises worth remembering.
- Tasks completed.
- Follow-ups deferred to next session.

Keep each bullet ≤ 2 lines. No filler. If the session was short and only one thing happened, 3 bullets is fine.

### 3. Archive the previous session

- Ensure `.claude/sessions/session-history.md` exists (create with header `# Session History` if missing).
- Take the previous `## Current Sprint Status` block from `CLAUDE.md` (everything between `## Current Sprint Status` and the next top-level `## ` heading or the `## Auto-Update Instructions` section).
- Convert that block into a new entry at the **top** of `session-history.md` using format:

  ```
  ## Session N (YYYY-MM-DD) — <title>

  <5-7 bullets from that previous session>

  ---
  ```

- Newest entries first; older entries below.

### 4. Update `CLAUDE.md` Current Sprint Status

Replace the previous Current Sprint Status section with the new one:

```markdown
## Current Sprint Status

**Last Updated:** YYYY-MM-DD (Session N+1 — <one-line title>)
**Active Work:** <one-line description>

### Session N+1 highlights

- <bullet 1>
- <bullet 2>
- ...

### Next session start

> <one or two sentences telling future-you what to do next. Be specific: filenames, commands, decisions to make.>
```

**Do NOT modify `AGENTS.md`.** Project context lives there and is stable across sessions; sprint state lives only in `CLAUDE.md`.

### 5. 10-session rolling window

After step 3, count the `## Session ` headings in `.claude/sessions/session-history.md` (each entry starts with `## Session N `).

- If count ≤ 10: nothing to do.
- If count > 10: move the OLDEST entry (the bottom-most `## Session ` block) into `.claude/sessions/session-history-archive.md`. Create the archive file with header `# Session History Archive (append-only)` if it does not exist. Append the moved entry to the **bottom** of the archive (archive is chronological, oldest-first; active history is reverse-chronological, newest-first).

Why the rolling window: keeps the auto-loaded active history small (fast grep, low context), while the archive preserves the full audit trail without bloating any agent's loaded context.

### 6. Commit and push

Stage `CLAUDE.md`, `.claude/sessions/session-history.md`, and `.claude/sessions/session-history-archive.md` (if it changed). Commit with:

```
chore: wrap Session N — <one-line summary>
```

Then `git push origin <current-branch>`.

If the commit message body would help future readers, add one short paragraph after the subject. Do not include a Claude attribution line unless the project's prior commit history shows one.

## Acceptance check the agent should self-verify

- `CLAUDE.md` now opens with the new session block. The previous block is gone from `CLAUDE.md`.
- `.claude/sessions/session-history.md` has the previous session as its top entry.
- If `session-history.md` had > 10 entries before this run, the oldest is now in `session-history-archive.md` and removed from active history.
- `AGENTS.md` is byte-identical to before.
- `git log -1` shows the new wrap commit; `git status` is clean.
