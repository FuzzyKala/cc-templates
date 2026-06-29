---
name: wrap
description: 'Session-end full recap — distill, codify memory to .agent-memory/, update AGENTS.md sprint-status block, commit+push. Automatic 4-step flow with safety guards (no-op, size, marker sanity, baseline undo). Works on Claude Code and OpenCode.'
compatibility: 'claude-code, opencode'
---

# /wrap — Session-end full recap

Wrap up a working session: distill what happened, codify learnings as persistent memory, update the AGENTS.md sprint-status block, then commit and push. Fully automatic — no human review gates. Preview via `--dry-run`.

**Assumed layout:**
- `AGENTS.md` at repo root with `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` markers. Sprint-status is 3-label: **Last shipped** / **Next** / **Carry-forwards**.
- `CLAUDE.md` is a 1-line `@AGENTS.md` pointer. Never touch CLAUDE.md.
- Memory persists at `.agent-memory/<slug>.md` with `.agent-memory/INDEX.md` as cross-reference. For Claude Code auto-load: `ln -s .agent-memory ~/.claude/projects/<slug>/memory`.

**What NOT to do:** (1) Do NOT propose new work, plan, or refactor — this is a session-end procedure. (2) Do NOT apply v2 rolling-window pattern — session history is in git log, not a separate file. (3) Do NOT touch CLAUDE.md — it stays a 1-line pointer. (4) Keep sprint-status block under 80 lines — Pre-ship and Deferred duplicate git log content.

## Steps

### Step 0: Pre-flight

- Record baseline commit: `git rev-parse HEAD`. If anything goes wrong, `git reset --hard <baseline>` fully undoes the wrap.
- Check sprint-status markers exist in AGENTS.md: `grep -q "sprint-status:start" AGENTS.md`. If missing, halt: "AGENTS.md missing sprint-status markers. Run setup-multi-agent or add markers manually." Do NOT proceed until markers exist.
- Detect session N via `git log --format=%s --grep="^chore: wrap Session [0-9]+ —" -1 | grep -oE "[0-9]+"`. If empty, fallback to AGENTS.md `**Last Updated:**` line and parse `(Session N —`. If both empty, default to Session 1.
- Validate: new N = last N + 1. If git log already has `wrap Session N`, bail (idempotency guard).
- Check `command -v git` — if missing, halt. Check `git remote get-url origin` — if missing, halt with setup instructions.
- Run `git diff AGENTS.md` — if there are unstaged changes, warn before overwriting.

### Step 1: Distill session + codify memory

- `mkdir -p .agent-memory/` — ensure the memory directory exists.
- Write 3-label sprint-status payload from conversation:
  ```
  **Last shipped**: <one-line summary of what shipped this session>
  **Next**: <single D-N slug or task for next session>
  **Carry-forwards**: <key deferred D-Ns, 1 line each>
  ```
- Identify memory candidates. For each, write `.agent-memory/<slug>.md` with frontmatter (`name`, `description`, `metadata.type`) + body (rule/fact → Why → How to apply). Append `- [Title](<slug>.md) — <hook>` to `.agent-memory/INDEX.md`.
- If memory was written: `git add .agent-memory/` and `git commit -m "chore(memory): codify N entries from Session N"`. Do NOT push yet. If pre-commit hooks block, fix and `git commit --amend`.
- If no memory candidates, skip. If `.agent-memory/INDEX.md` will exceed 200 lines after append, archive oldest 50% to `.agent-memory/ARCHIVE.md` first.

### Step 2: Update AGENTS.md

- Compose payload: replace content between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` in AGENTS.md. Create temp file via awk:
  ```bash
  awk -v sprint="$PAYLOAD" '/<!-- sprint-status:start -->/{print; print sprint; in_block=1; next} /<!-- sprint-status:end -->/{in_block=0; print; next} !in_block{print}' AGENTS.md > tmp
  ```
- Verify tmp file exists: `[ -f tmp ]`. If missing, halt: "awk failed to create temp file — check awk availability and AGENTS.md sprint-status markers."
- **No-op detection**: `cmp -s AGENTS.md tmp || diff -q AGENTS.md tmp >/dev/null`. If identical, bail: "No-op wrap — payload unchanged."
- **Size guard**: `wc -c < tmp`. `≥32768` HARD BLOCK (Codex 32 KB cap, no override). `≥30720` WARN + refuse (override via `AGENTS_MD_CAP_OVERRIDE=1`). `≥28672` INFO banner.
- **If `--dry-run`**: show AGENTS.md diff, memory candidates, commit message, post-edit size, symlink status — then stop. Write nothing, commit nothing, push nothing.
- Write: `mv tmp AGENTS.md`.
- **Marker sanity**: `grep -q "sprint-status:start" AGENTS.md && grep -q "sprint-status:end" AGENTS.md`. If either missing, halt: "Markers corrupted — run `git checkout AGENTS.md` to recover."
- **Symlink check** (non-blocking): If `~/.claude/projects/` exists but no symlink to `.agent-memory/`, warn: "Claude Code auto-load: run `ln -s .agent-memory ~/.claude/projects/<project-slug>/memory`."

### Step 3: Commit + push

- Commit: `git add AGENTS.md && git commit -m "chore: wrap Session N — <summary>"`. Write a narrative body.
- Push with retry:

  ```bash
  BRANCH=$(git symbolic-ref --short HEAD)
  MAX=3 BASE=2 attempt=0
  while [ $attempt -le $MAX ]; do
    if git push origin "$BRANCH" 2>&1; then break; fi
    attempt=$((attempt+1))
    if [ $attempt -gt $MAX ]; then
      echo "Push failed. Recovery:"
      echo "  (1) rebase: git fetch origin && git rebase origin/$BRANCH && git push"
      echo "  (2) auth: check git remote -v and credentials"
      echo "  (3) PR fallback: gh pr create --fill"
      echo "  (4) undo: git reset --hard <baseline>"
      exit 2
    fi
    last_err=$(git push origin "$BRANCH" 2>&1 | tail -1)
    echo "$last_err" | grep -qE "non-fast-forward|403|401|protected|pre-receive" && exit 2
    sleep $((RANDOM % (BASE * 2**attempt < 30 ? BASE * 2**attempt : 30)))
  done
  git log -1 && git status
  ```

- **Post-hook** (project-specific, optional): If `scripts/wrap-hooks.sh` exists and is executable, invoke it:
  ```bash
  bash scripts/wrap-hooks.sh post --session <N>
  ```
  Failure is non-fatal (warn only). Pass `--dry-run` if in preview mode.

### Error recovery

- **Amendment** (wrong payload committed): `git commit --amend -m "chore: wrap Session N — <corrected>"` then `git push --force-with-lease`.
- **Blocked** (pre-commit hook, lint failure): fix, `git commit --amend`, re-run push.
- **Stale push** (remote advanced): `git fetch origin && git rebase origin/$BRANCH && git push`.
- **Undo everything**: `git reset --hard <baseline>`. Remove orphan memory files if needed: `rm -rf .agent-memory/`.

## Acceptance check

- AGENTS.md sprint-status block opens with new session. All other sections byte-identical.
- CLAUDE.md byte-identical.
- `.agent-memory/<slug>.md` + `INDEX.md` exist if memory was codified.
- `git log -1` shows `chore: wrap Session N — ...`. `git status` clean.
- `git log origin/$BRANCH..HEAD` empty after push.
