#!/usr/bin/env bash
# scripts/wrap.sh — Mechanical steps for the /wrap skill.
# Usage:
#   bash scripts/wrap.sh update-agents-md [--dry-run]
#   bash scripts/wrap.sh commit-push <session-N> [--dry-run]
#
# update-agents-md: Reads /tmp/wrap-payload.txt, replaces sprint-status block
#   in AGENTS.md. Validates: no-op, 3-tier size guard, marker sanity.
# commit-push: git add + commit + push with retry.

set -euo pipefail

PAYLOAD_FILE="${WRAP_PAYLOAD_FILE:-/tmp/wrap-payload.txt}"
AGENTS="AGENTS.md"

usage() {
  echo "Usage: $0 {update-agents-md|commit-push} [--dry-run]" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
SUB=$1
DRY_RUN=0
shift
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
  esac
done

do_update_agents_md() {
  [[ -f "$AGENTS" ]] || { echo "Error: $AGENTS not found" >&2; exit 1; }
  grep -q "sprint-status:start" "$AGENTS" \
    || { echo "Error: <!-- sprint-status:start --> marker not found" >&2; exit 1; }
  grep -q "sprint-status:end" "$AGENTS" \
    || { echo "Error: <!-- sprint-status:end --> marker not found" >&2; exit 1; }

  [[ -f "$PAYLOAD_FILE" ]] || { echo "Error: payload file $PAYLOAD_FILE not found" >&2; exit 1; }
  SPRINT=$(cat "$PAYLOAD_FILE")
  [[ -n "$SPRINT" ]] || { echo "Error: empty payload" >&2; exit 1; }

  TMP=$(mktemp /tmp/wrap-agents-XXXXXX) || { echo "Error: mktemp failed" >&2; exit 1; }
  trap 'rm -f "$TMP"' EXIT

  awk -v sprint="$SPRINT" '
    /<!-- sprint-status:start -->/{print; print sprint; in_block=1; next}
    /<!-- sprint-status:end -->/{in_block=0; print; next}
    !in_block{print}
  ' "$AGENTS" > "$TMP"

  [[ -s "$TMP" ]] || { echo "Error: awk produced empty output — check markers" >&2; exit 1; }

  # Check markers on temp file BEFORE mv
  grep -q "sprint-status:start" "$TMP" || { echo "Error: sprint-status:start lost in awk output" >&2; exit 1; }
  grep -q "sprint-status:end" "$TMP" || { echo "Error: sprint-status:end lost in awk output" >&2; exit 1; }

  # No-op detection
  if cmp -s "$AGENTS" "$TMP" 2>/dev/null || diff -q "$AGENTS" "$TMP" >/dev/null 2>&1; then
    echo "No-op wrap — payload identical to current Sprint Status. Use --dry-run to test intentionally."
    exit 0
  fi

  # Size guard
  SIZE=$(wc -c < "$TMP")
  if [[ "$SIZE" -ge 32768 ]]; then
    echo "Error: AGENTS.md would be ${SIZE}B (>= 32K Codex cap). Trim payload." >&2
    exit 1
  fi
  if [[ "$SIZE" -ge 30720 ]]; then
    if [[ "${AGENTS_MD_CAP_OVERRIDE:-0}" != "1" ]]; then
      echo "Error: AGENTS.md would be ${SIZE}B (>= 30K). Set AGENTS_MD_CAP_OVERRIDE=1 to force." >&2
      exit 1
    fi
    echo "Warning: AGENTS.md would be ${SIZE}B (approaching 32K cap)" >&2
  elif [[ "$SIZE" -ge 28672 ]]; then
    echo "Info: AGENTS.md would be ${SIZE}B (>= 28K info threshold)" >&2
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] Would write AGENTS.md ($SIZE bytes):"
    diff "$AGENTS" "$TMP" || true
    exit 0
  fi

  mv "$TMP" "$AGENTS"
  echo "AGENTS.md updated ($SIZE bytes)"
}

do_commit_push() {
  local N="${1:-}"
  local SUMMARY="${2:-wrap update}"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] Would commit and push:"
    echo "  git add AGENTS.md"
    echo "  git commit -m \"chore: wrap Session ${N} — ${SUMMARY}\""
    echo "  git push"
    exit 0
  fi

  git diff-index --quiet HEAD \
    || { echo "Error: working tree has unstaged changes — commit or stash first" >&2; exit 2; }

  git add AGENTS.md
  git commit -m "chore: wrap Session ${N} — ${SUMMARY}" || { echo "Error: commit failed" >&2; exit 2; }

  BRANCH=$(git symbolic-ref --short HEAD)
  MAX=3 BASE=2 attempt=0
  while true; do
    if git push origin "$BRANCH" 2>&1; then
      echo "Push succeeded"
      break
    fi
    attempt=$((attempt+1))
    if [[ $attempt -gt $MAX ]]; then
      echo "Push failed after $MAX retries. Recovery:"
      echo "  (1) rebase: git fetch origin && git rebase origin/$BRANCH && git push"
      echo "  (2) auth: check git remote -v and credentials"
      echo "  (3) PR fallback: gh pr create --fill"
      echo "  (4) undo: git reset --hard HEAD~1"
      exit 2
    fi
    LAST_ERR=$(git push origin "$BRANCH" 2>&1 | tail -1)
    echo "$LAST_ERR" | grep -qE "non-fast-forward|403|401|protected|pre-receive" && {
      echo "Permanent push failure: $LAST_ERR" >&2
      exit 2
    }
    trap '' INT
    sleep $((RANDOM % (BASE * 2**attempt < 30 ? BASE * 2**attempt : 30)))
    trap - INT
  done

  git log -1 && git status
}

case "$SUB" in
  update-agents-md)
    do_update_agents_md
    ;;
  commit-push)
    shift
    do_commit_push "$@"
    ;;
  *)
    usage
    ;;
esac
