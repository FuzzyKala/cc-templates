#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
WRAP_SCRIPT="$ROOT/.agents/skills/wrap/scripts/wrap.sh"
TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

new_repo() {
  local name="$1"
  local repo="$TMP_ROOT/$name"
  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config user.name "Wrap Test"
  git -C "$repo" config user.email "wrap-test@example.invalid"
  git -C "$repo" remote add origin https://example.invalid/repo.git
  printf '%s\n' "$repo"
}

run_update() {
  local repo="$1"
  WRAP_CONTEXT_PATH="$repo/missing-context.json" \
    WRAP_PAYLOAD_FILE="$repo/payload.txt" \
    bash "$WRAP_SCRIPT" update-agents-md 2
}

expect_update_failure() {
  local repo="$1"
  local expected="$2"
  local output

  if output=$(cd "$repo" && run_update "$repo" 2>&1); then
    echo "Expected update-agents-md to fail for $repo" >&2
    exit 1
  fi
  if [[ "$output" != *"$expected"* ]]; then
    echo "Expected failure containing: $expected" >&2
    echo "Actual output: $output" >&2
    exit 1
  fi
}

test_inline_mentions_are_preserved() {
  local repo
  repo=$(new_repo inline-mentions)

  cat > "$repo/AGENTS.md" <<'EOF'
# Repository Guidelines

This prose mentions `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` without defining the block.

Keep this section byte-identical.

<!-- sprint-status:start -->
old status
<!-- sprint-status:end -->

Keep this tail byte-identical.
EOF
  cat > "$repo/payload.txt" <<'EOF'
**Last shipped**: exact markers
**Next**: review
**Carry-forwards**: none
EOF
  git -C "$repo" add AGENTS.md
  git -C "$repo" commit -qm "initial"

  (cd "$repo" && run_update "$repo" >/dev/null)

  cat > "$repo/expected.md" <<'EOF'
# Repository Guidelines

This prose mentions `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->` without defining the block.

Keep this section byte-identical.

<!-- sprint-status:start -->
**Last shipped**: exact markers
**Next**: review
**Carry-forwards**: none
<!-- sprint-status:end -->

Keep this tail byte-identical.
EOF
  cmp "$repo/expected.md" "$repo/AGENTS.md"
}

test_prose_only_is_rejected() {
  local repo
  repo=$(new_repo prose-only)
  cat > "$repo/AGENTS.md" <<'EOF'
This prose mentions `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`, but neither is a marker line.
EOF
  expect_update_failure "$repo" "expected exactly one exact <!-- sprint-status:start --> marker line"
}

test_duplicate_markers_are_rejected() {
  local repo
  repo=$(new_repo duplicate-markers)
  cat > "$repo/AGENTS.md" <<'EOF'
<!-- sprint-status:start -->
first
<!-- sprint-status:end -->
<!-- sprint-status:start -->
second
<!-- sprint-status:end -->
EOF
  expect_update_failure "$repo" "marker line in AGENTS.md (found 2)"
}

test_reversed_markers_are_rejected() {
  local repo
  repo=$(new_repo reversed-markers)
  cat > "$repo/AGENTS.md" <<'EOF'
<!-- sprint-status:end -->
old status
<!-- sprint-status:start -->
EOF
  expect_update_failure "$repo" "must appear before"
}

test_inline_mentions_are_preserved
test_prose_only_is_rejected
test_duplicate_markers_are_rejected
test_reversed_markers_are_rejected

echo "wrap marker matching tests: PASS"
