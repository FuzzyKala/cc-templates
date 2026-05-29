---
name: wrap
description: Session-end full recap — analyze current session, archive previous sprint state, update CLAUDE.md Current Sprint Status, maintain a 5-session rolling window (oldest entry dropped to git history; no archive file). Run at end of a working session before closing the terminal. Distinct from Claude Code's built-in `/recap` (which is a one-line synopsis triggered after terminal idle).
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

### 5. 5-session rolling window

After step 3, count the `## Session ` headings in `.claude/sessions/session-history.md` (each entry starts with `## Session N `).

- If count ≤ 5: nothing to do.
- If count > 5: DELETE the oldest entries (the bottom-most `## Session ` blocks) one at a time until exactly 5 remain — delete as many as needed, not just one. Do NOT move them to an archive file and do NOT create `session-history-archive.md` — git history is the deep archive. Every wrap commit preserves the full prior state, so any dropped session is recoverable with `git show <sha>:.claude/sessions/session-history.md`. (Deleting until 5 remain means a history that is over the cap — e.g. right after the window size is reduced — self-heals on the next wrap instead of hovering above 5 forever.)

Why the rolling window: keeps the auto-loaded active history small (fast grep, low context). Older sessions live in git history — which Claude can read on demand — so no separate archive file is needed.

### 6. Commit and push

Stage `CLAUDE.md` and `.claude/sessions/session-history.md`. Commit with:

```
chore: wrap Session N — <one-line summary>
```

Then `git push origin <current-branch>`.

If the commit message body would help future readers, add one short paragraph after the subject. Do not include a Claude attribution line unless the project's prior commit history shows one.

## Acceptance check the agent should self-verify

- `CLAUDE.md` now opens with the new session block. The previous block is gone from `CLAUDE.md`.
- `.claude/sessions/session-history.md` has the previous session as its top entry.
- If `session-history.md` had > 5 entries before this run, the oldest entries have been deleted until exactly 5 remain (preserved in git history, not in an archive file).
- `AGENTS.md` is byte-identical to before.
- `git log -1` shows the new wrap commit; `git status` is clean.
