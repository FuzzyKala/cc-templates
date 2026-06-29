---
name: wrap
description: 'Session-end full recap — distill, codify memory to .agent-memory/, update AGENTS.md sprint-status block, commit+push. Automatic steps with safety guards delegated to scripts/wrap.sh. Works on Claude Code, OpenCode, and Codex CLI.'
compatibility: 'claude-code, opencode, codex'
---

# /wrap — Session-end full recap

Wrap up a working session: distill what happened, codify learnings as persistent memory, update the AGENTS.md sprint-status block, then commit and push. Mechanical steps are handled by `scripts/wrap.sh` — deterministic bash with `set -euo pipefail`.

**Assumed layout:**
- `AGENTS.md` at repo root with `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` markers. Sprint-status is 3-label: **Last shipped** / **Next** / **Carry-forwards**.
- `CLAUDE.md` is a 1-line `@AGENTS.md` pointer. Never touch CLAUDE.md.
- Memory persists at `.agent-memory/<slug>.md` with `.agent-memory/INDEX.md` as cross-reference. For Claude Code auto-load: `ln -s .agent-memory ~/.claude/projects/<slug>/memory`.

**What NOT to do:** (1) Do NOT propose new work, plan, or refactor — this is a session-end procedure. (2) Do NOT apply v2 rolling-window pattern — session history is in git log, not a separate file. (3) Do NOT touch CLAUDE.md — it stays a 1-line pointer. (4) Keep sprint-status block under 80 lines — Pre-ship and Deferred duplicate git log content.

## Steps

### Step 0: Pre-flight

- Record baseline commit: `git rev-parse HEAD`. If anything goes wrong, `git reset --hard <baseline>` fully undoes the wrap.
- Run the deterministic detection script:
  ```bash
  N=$(bash ~/.agents/skills/wrap/scripts/wrap.sh pre-flight)
  ```
  (Claude Code: also `N=$(bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh pre-flight)`)
- The script validates git availability, remote origin, sprint-status markers, detects last session N, and checks idempotency. Prints the next session number to stdout.
- If the script exits non-zero, halt and read the error message.
- Store N for use in Steps 1 and 3.

### Step 1: Distill session + codify memory (LLM work)

- `mkdir -p .agent-memory/` — ensure the memory directory exists.
- Write 3-label sprint-status payload to `/tmp/wrap-payload.txt`:
  ```
  **Last shipped**: <one-line summary of what shipped this session>
  **Next**: <single D-N slug or task for next session>
  **Carry-forwards**: <key deferred D-Ns, 1 line each>
  ```
- Identify memory candidates. For each, write `.agent-memory/<slug>.md` with frontmatter + body. Append to `.agent-memory/INDEX.md`.
- If memory was written: `git add .agent-memory/` and `git commit -m "chore(memory): codify N entries from Session N"`. Do NOT push yet.
- If no memory candidates, skip. If `.agent-memory/INDEX.md` exceeds 200 lines, archive oldest 50% to `.agent-memory/ARCHIVE.md` first.

### Step 2: Update AGENTS.md

Run the deterministic script:

```bash
bash ~/.agents/skills/wrap/scripts/wrap.sh update-agents-md [--dry-run]
```

(Claude Code: also `bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh update-agents-md [--dry-run]`)

The script reads `/tmp/wrap-payload.txt` from Step 1, performs awk sed-replace, no-op detection, 3-tier size guard, and marker sanity check.

### Step 3: Commit + push

Run the deterministic script:

```bash
bash ~/.agents/skills/wrap/scripts/wrap.sh commit-push [--dry-run]
```

(Claude Code: also `bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh commit-push [--dry-run]`)

The script handles git add, commit, and push with retry (max 3, jitter, permanent error classification) and recovery instructions.

- If `scripts/wrap-hooks.sh` exists at repo root and is executable, invoke it post-push (Anchor-specific housekeeping):
  ```bash
  bash scripts/wrap-hooks.sh post --session <N> [--dry-run]
  ```
  Failure is non-fatal (warn only).

### Error recovery

- **Blocked** (pre-commit hook, lint failure): fix, `git commit --amend`, re-run push.
- **Stale push** (remote advanced): `git fetch origin && git rebase origin/$BRANCH && git push`.
- **Undo everything**: `git reset --hard <baseline>`. Remove orphan memory files if needed: `rm -rf .agent-memory/`.

## Acceptance check

- AGENTS.md sprint-status block opens with new session. All other sections byte-identical.
- CLAUDE.md byte-identical.
- `.agent-memory/<slug>.md` + `INDEX.md` exist if memory was codified.
- `git log -1` shows `chore: wrap Session N — ...`. `git status` clean.
