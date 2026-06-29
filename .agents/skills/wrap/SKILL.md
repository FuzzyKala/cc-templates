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

### Step 0: Pre-flight & Prep

- Record baseline commit: `git rev-parse HEAD`. If anything goes wrong, `git reset --hard <baseline>` fully undoes the wrap.
- If `scripts/wrap-prep.sh` exists, execute it to initialize the JSON context data bus:
  ```bash
  npm run wrap:prep
  ```
- Run the deterministic detection script:
  ```bash
  N=$(bash ~/.agents/skills/wrap/scripts/wrap.sh pre-flight)
  ```
  (Claude Code: also `N=$(bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh pre-flight)`)
- The script validates git availability, remote origin, sprint-status markers, detects last session N, checks idempotency, and initializes the context bus (path from `$WRAP_CONTEXT_PATH`, default `/tmp/wrap-context.json`). Prints the next session number to stdout.
- If the script exits non-zero, halt and read the error message.
- Store N for use in Steps 1 and 3.

### Step 1: Distill session + codify memory (LLM work)

- `mkdir -p .agent-memory/` — ensure the memory directory exists.
- Write the 3-label sprint-status update into the context bus file (`$WRAP_CONTEXT_PATH`, default `/tmp/wrap-context.json`) under the `sprint_status_update` field:
  ```json
  {
    "sprint_status_update": {
      "last_shipped": "<one-line summary of what shipped this session>",
      "next": "<single D-N slug or task for next session>",
      "carry_forwards": ["<slug-1>", "<slug-2>"]
    }
  }
  ```
- Identify memory candidates. For each, write `.agent-memory/<slug>.md` with frontmatter + body.
- Read `.agent-memory/INDEX.md` first, then append new memory entries at the end of the file in bullet list format:
  `- **<slug>** (reference/feedback/project/user): <summary>`
- Run the D-N auto-archive script to move completed D-Ns to the archive:
  ```bash
  npx tsx scripts/archive-resolved-dns.ts --apply
  ```
- If memory or archive was written: `git add .agent-memory/ _bmad-output/implementation-artifacts/` and `git commit -m "chore(memory): codify N entries and archive D-Ns from Session N"`. Do NOT push yet.
- If no memory candidates, skip. If `.agent-memory/INDEX.md` exceeds 200 lines, archive oldest 50% to `.agent-memory/ARCHIVE.md` first.

### Step 2: Update AGENTS.md + commit

Run the deterministic script:

```bash
bash ~/.agents/skills/wrap/scripts/wrap.sh update-agents-md <session-N> [--dry-run]
```

(Claude Code: also `bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh update-agents-md <session-N> [--dry-run]`)

The script reads the context bus file (`$WRAP_CONTEXT_PATH`, default `/tmp/wrap-context.json`) from Step 0 and 1, parses the `sprint_status_update` payload, performs awk sed-replace on `AGENTS.md`, no-op detection, 3-tier size guard, marker sanity check, then `git add` + `git commit` AGENTS.md. The commit message is auto-generated from the `last_shipped` field of the payload.

### Step 3: Push

Run the deterministic script:

```bash
bash ~/.agents/skills/wrap/scripts/wrap.sh commit-push [--dry-run]
```

(Claude Code: also `bash ${CLAUDE_SKILL_DIR}/scripts/wrap.sh commit-push [--dry-run]`)

The script handles git push with retry (max 3, jitter, permanent error classification) and recovery instructions. AGENTS.md is already committed — this step only pushes.

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
