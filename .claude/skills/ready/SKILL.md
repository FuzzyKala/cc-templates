---
name: ready
description: Project context scanner — read AGENTS.md (canonical) and CLAUDE.md (sprint state), report git status, list installed skills, and check availability of the preferred CLI tools (gh / gws / ntn / rclone / Playwright / acli). Run at session start to confirm config is loaded and the toolchain is ready.
---

# /ready — Project context scanner

Produce a concise (under ~30 lines) status report so the user can see, at a glance, what's loaded and what's available. Do NOT propose work, plan, or refactor — this is a read-only inspection.

## Steps

### 1. Identify the project

- Read `AGENTS.md` at repo root. This is the canonical project context.
- If `AGENTS.md` is missing, say so and stop — the rest of the report depends on it.
- Extract: project name (from the first `# ` heading or the `## <Name> Project Context` section), one-line description, tech stack summary.

### 2. Read current sprint state

- Read `CLAUDE.md`. Extract the `## Current Sprint Status` section.
- Pull: Last Updated line, Active Work line, the most recent session's bullet list.
- If `CLAUDE.md` does not exist or has no Current Sprint Status section, note that.

### 3. Git state

Run in parallel:
- `git status --short`
- `git log --oneline -3 origin/main` (or the project's main branch — check `git symbolic-ref refs/remotes/origin/HEAD` if unsure)
- `git branch --show-current`

### 4. Installed skills

List `.claude/skills/*/SKILL.md`. For each, extract the `name:` and one-line `description:` from frontmatter.

### 5. CLI tool availability

For each tool below, run `which <tool>`. Report installed (with absolute path) vs missing. The matrix lives in AGENTS.md's `## Tool Preference: CLI over MCP` section — if that section lists additional tools, include them too.

Default matrix:

| Tool | Service |
|---|---|
| `gh` | GitHub |
| `gws` | Google Workspace |
| `rclone` | Google Drive bulk ops |
| `ntn` | Notion |
| `acli` | JIRA / Atlassian |
| `playwright` | Browser scripted flows |

### 6. Print the report

Use this exact shape. Keep it under 30 lines total.

```
## /ready report — <project name>

<one-line description>

**Sprint:** Session N — <title> (last updated YYYY-MM-DD)
**Active:** <active work line>

**Branch:** <current> | <git status one-liner: "clean" or "N modified, M staged">
**Recent commits:**
  <sha> <subject>
  <sha> <subject>
  <sha> <subject>

**Skills installed (<count>):**
  /wrap — <desc>
  /ready — <desc>
  /<name> — <desc>

**Preferred CLIs:**
  gh ✓  gws ✓  rclone ✓  ntn ✗  acli ✗  playwright ✓

**Next:** <one line from CLAUDE.md's "Next session start" block>
```

If a section has no data (e.g., no installed skills), write `(none)` instead of omitting the line.

## What NOT to do

- Do not run setup, install, or fix anything. `/ready` is read-only.
- Do not count "specialist agents" or validate any v2-era 5-agent topology.
- Do not load or modify `session-history.md` or `session-history-archive.md` — those are for `/wrap`, not `/ready`.
- Do not exceed ~30 lines of output. The user wants a snapshot, not a deep-dive.
