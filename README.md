# cc-templates

> Multi-CLI (Claude Code + Codex CLI + Antigravity CLI) project bootstrap with shared `AGENTS.md` config, CLI-first tool preference, and session-wrap skill.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v4-blue.svg)](https://github.com/FuzzyKala/cc-templates/releases)
[![AGENTS.md](https://img.shields.io/badge/AGENTS.md-AAIF-orange.svg)](https://agents.md/)

## What this is

Most coding agents (Claude Code, OpenAI Codex CLI, Google Antigravity CLI) load a markdown config file from your repo root on every session. Each tool's default filename and import syntax differ:

- **Codex CLI** reads `AGENTS.md` natively.
- **Antigravity CLI** (`agy`) reads `AGENTS.md` natively.
- **Claude Code** reads `CLAUDE.md` and supports `@AGENTS.md` inline imports.

If you use more than one of these tools, you end up with multiple near-duplicate config files that drift apart. `cc-templates` solves that: **`AGENTS.md` is the single canonical file**, with a 1-line `CLAUDE.md` thin wrapper that imports from it. Edit `AGENTS.md` → all CLIs see the change.

The repo also ships skills under `.agents/skills/`:

- `/wrap` — session-end recap. Distills the session and updates the `AGENTS.md` sprint-status block (between `<!-- sprint-status:start -->` / `<!-- sprint-status:end -->` markers). Git history is the deep archive — no separate session-history file.
- `/setup-multi-agent` — bootstrap a new project with the AGENTS.md + CLAUDE.md pair.

`AGENTS.md` is governed by the Linux Foundation Agentic AI Foundation (formed 2025-12-09; founding members include Anthropic, OpenAI, Google, AWS, Microsoft, Cloudflare, Bloomberg). Spec: <https://agents.md/>. 60k+ open-source projects use it.

## Quick start

Bootstrap an existing project (manual; one minute):

```bash
cd /path/to/your-project
git clone https://github.com/FuzzyKala/cc-templates.git /tmp/cc-templates

# Copy templates
cp /tmp/cc-templates/templates/AGENTS.md.template AGENTS.md
cp /tmp/cc-templates/templates/CLAUDE.md.template CLAUDE.md
cat /tmp/cc-templates/templates/gitignore-additions.txt >> .gitignore

# Substitute today's date into the sprint-status block in AGENTS.md, then fill placeholders
sed -i "s/{{TODAY}}/$(date +%Y-%m-%d)/" AGENTS.md
# Now open AGENTS.md and fill in {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, etc.
```

Or, inside Claude Code, run the skill — it walks you through the prompts:

```
/setup-multi-agent
```

Verify (run each in a fresh terminal inside `/path/to/your-project`):

```bash
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# Antigravity CLI (agy) reads AGENTS.md natively, no extra config:
agy 'What is this repo about?'

# Codex CLI reads AGENTS.md natively:
codex exec 'What is this repo about?'
```

All three should reference your filled-in `AGENTS.md`.

## Skill installation

The cct repo ships two skills under `.agents/skills/` (the Agent Skills standard path, symlinked to `.claude/skills/` for Claude Code):

- `/wrap` — session-end recap that updates the AGENTS.md sprint-status block
- `/setup-multi-agent` — bootstrap a new project with multi-CLI config files

By default these are only invocable from inside the cct repo. To make them available from any project (Claude Code, OpenCode, Codex CLI, and Antigravity CLI):

```bash
# Install to the cross-agent standard path
mkdir -p ~/.agents/skills
for s in wrap setup-multi-agent; do
  ln -s "$(pwd)/.agents/skills/$s" ~/.agents/skills/$s
done

# Symlink Claude Code path for backward compatibility
mkdir -p ~/.claude/skills
for s in wrap setup-multi-agent; do
  ln -s ~/.agents/skills/$s ~/.claude/skills/$s
done
```

(Run from the cct repo root so `$(pwd)` resolves correctly.)

Claude Code follows symlinks during skill discovery. All agents read from `~/.agents/skills/` — updates to the cct repo are picked up automatically via the symlink chain, no re-install needed.

## Architecture

```
your-project/
├── AGENTS.md         ← canonical project context + sprint-status block at bottom
├── CLAUDE.md         ← @AGENTS.md (one line)
└── .gitignore        ← includes .claude/*, .gemini/, .antigravitycli/
```

`AGENTS.md` holds everything — stable project context (working agreement, tech stack, conventions, tool preferences) above the sprint-status markers, and per-session state (Current Sprint Status block) below. `CLAUDE.md` is a 1-line `@AGENTS.md` import — byte-stable across sessions because Claude Code does not yet natively support AGENTS.md, so this thin wrapper bridges the gap.

User-level rules (a personal "Working Agreement" that applies to every project) propagate the same way:

- `~/.claude/CLAUDE.md` — Claude native.
- `~/.codex/AGENTS.md` → symlink → `~/.claude/CLAUDE.md` (Codex follows symlinks).
- Antigravity CLI (`agy`) reads `AGENTS.md` at the repo root natively — no user-level wrapper file needed.

The `templates/AGENTS.md.template` shipped here mirrors that user-level Working Agreement into each project, so the rules apply consistently whether the user-level config is loaded or not.

## Skills included

Drop these in your project's `.agents/skills/` (or `.claude/skills/` for Claude Code) to make them available as slash commands. (cc-templates' own root has them installed for dogfooding — clone the repo and copy `.agents/skills/*` into your project if you want them.)

### `/wrap`

Session-end recap. Distills the current session into highlight bullets + a "next session start" trigger list, then replaces the `AGENTS.md` sprint-status block (between `<!-- sprint-status:start -->` and `<!-- sprint-status:end -->`) with the new content. No rolling-window file — git history is the deep archive (`git log --grep="wrap Session" -- AGENTS.md` lists past wraps; `git show <sha> -- AGENTS.md` recovers any session's snapshot).

**Distinct from Claude Code's built-in `/recap`** (v2.1.108+), which is a one-line synopsis triggered after terminal idle. `/wrap` is the explicit, full session-end version.



### `/setup-multi-agent`

Bootstraps a new project with `AGENTS.md` + `CLAUDE.md` from `templates/`, patches `.gitignore`, and prints verification commands.

## Tool preference: CLI over MCP

The `AGENTS.md` template includes a section ranking CLI tools over MCP servers for the same service. Reasons:

- **Token efficiency.** Benchmarks (Firecrawl, Arize, 2025) show roughly 17× fewer tokens per task for CLI vs MCP at 10k ops/month — 1.3-8.7k tokens (CLI) vs 32-82k tokens (MCP).
- **Cross-agent auth.** CLI auth lives in `~/.config/<tool>/` and is shared across Claude / Codex / Antigravity. MCP OAuth is per-agent.
- **Reliability.** CLI = one process call. MCP = an extra server hop.

| Service | Preferred CLI |
|---|---|
| GitHub | `gh` |
| Google Workspace (Gmail / Calendar / Drive) | `gws` |
| Google Drive bulk ops | `rclone` |
| Notion | `ntn` |
| Browser scripted flows | Playwright CLI |
| JIRA | `acli` |

Stay on MCP where no viable CLI exists: Canva, chrome-devtools, context7.

## Manual setup (no skill needed)

The Quick start section above covers the manual bootstrap steps. For BMad-style projects with deferred-work backlogs and spec corpora, copy the optional templates from `templates/extras/` after bootstrapping.

## Migrating from v2 / v3

Previous architectures are preserved on archive branches / pre-v4 commits:

- **v2** — "Claude Code Multi-Agent Coordination System" with 5 internal specialist agents and `/recap` / `/ready` / `/setup-agents` slash commands — on [`v2-archive`](https://github.com/FuzzyKala/cc-templates/tree/v2-archive). v3 was a full rewrite (not backwards-compatible) into a multi-CLI bootstrap. The `/recap` command was renamed to `/wrap` because Claude Code v2.1.108 shipped a built-in `/recap` that cannot be overridden.
- **v3** — initial multi-CLI bootstrap with sprint state in `CLAUDE.md`, a `.claude/sessions/session-history.md` rolling-window file, and `GEMINI.md` thin wrapper for Gemini CLI. Recoverable from git tags / pre-v4 commits.

For migration: there is no automatic migration path. v2 users run `/setup-multi-agent` to drop new files alongside the old ones, then manually remove the v2 directories. v3 users hand-migrate per CHANGELOG.md v4.0.0 "Migration" section (move sprint-status to AGENTS.md, reduce CLAUDE.md to `@AGENTS.md`, drop `GEMINI.md` since Gemini CLI sunset 2026-06-18).

## References

- AGENTS.md spec: <https://agents.md/>
- Claude Code memory imports (`@AGENTS.md`): <https://code.claude.com/docs/en/memory>
- Claude Code skills format: <https://code.claude.com/docs/en/skills>
- Antigravity CLI transition (Google announcement 2026-05-19): <https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/>
- Codex CLI agents.md: <https://developers.openai.com/codex/guides/agents-md>

## License

MIT. See [LICENSE](LICENSE).
