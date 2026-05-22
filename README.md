# cc-templates

> Multi-CLI (Claude Code + Codex CLI + Gemini CLI) project bootstrap with shared `AGENTS.md` config, CLI-first tool preference, and session-wrap skill.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v3-blue.svg)](https://github.com/FuzzyKala/cc-templates/releases)
[![AGENTS.md](https://img.shields.io/badge/AGENTS.md-AAIF-orange.svg)](https://agents.md/)

## What this is

Most coding agents (Claude Code, OpenAI Codex CLI, Google Gemini CLI) load a markdown config file from your repo root on every session. Each tool's default filename and import syntax differ:

- **Codex CLI** reads `AGENTS.md` natively.
- **Claude Code** reads `CLAUDE.md` and supports `@AGENTS.md` inline imports.
- **Gemini CLI** reads `GEMINI.md` and supports `@./AGENTS.md` imports.

If you use more than one of these tools, you end up with three near-duplicate config files that drift apart. `cc-templates` solves that: **`AGENTS.md` is the single canonical file**, and `CLAUDE.md` + `GEMINI.md` are thin one-line wrappers that import from it. Edit `AGENTS.md` → all three CLIs see the change.

The repo also ships three skills that work inside Claude Code's `.claude/skills/` directory:

- `/wrap` — session-end full recap with 10-session rolling window.
- `/ready` — read-only project context scanner.
- `/setup-multi-agent` — bootstrap a new project with the AGENTS.md / CLAUDE.md / GEMINI.md trio.

`AGENTS.md` is governed by the Linux Foundation Agentic AI Foundation (formed 2025-12-09; founding members include Anthropic, OpenAI, Google, AWS, Microsoft, Cloudflare, Bloomberg). Spec: <https://agents.md/>. 60k+ open-source projects use it.

## Quick start

Bootstrap an existing project (manual; one minute):

```bash
cd /path/to/your-project
git clone https://github.com/FuzzyKala/cc-templates.git /tmp/cc-templates

# Copy templates
cp /tmp/cc-templates/templates/AGENTS.md.template AGENTS.md
cp /tmp/cc-templates/templates/CLAUDE.md.template CLAUDE.md
cp /tmp/cc-templates/templates/GEMINI.md.template GEMINI.md
cat /tmp/cc-templates/templates/gitignore-additions.txt >> .gitignore

# Edit placeholders in AGENTS.md and CLAUDE.md, then verify
sed -i "s/{{TODAY}}/$(date +%Y-%m-%d)/" CLAUDE.md
# Now open AGENTS.md and fill in {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, etc.
```

Or, inside Claude Code, run the skill — it walks you through the prompts:

```
/setup-multi-agent
```

Verify (run each in a fresh terminal inside `/path/to/your-project`):

```bash
claude --print 'Without using any tools, just from your loaded context: does it contain a section called "Tool Preference: CLI over MCP"? If yes quote the first sentence.'

# GEMINI_CLI_TRUST_WORKSPACE=true is required for Gemini CLI headless mode (-p flag):
GEMINI_CLI_TRUST_WORKSPACE=true gemini -p 'Without using any tools, just from your loaded context: does the project context exist? Answer yes or no.'

codex exec 'What is this repo about?'
```

All three should reference your filled-in `AGENTS.md`.

## Architecture

```
your-project/
├── AGENTS.md         ← canonical project context (single source of truth)
├── CLAUDE.md         ← @AGENTS.md + Current Sprint Status (per-session)
├── GEMINI.md         ← @./AGENTS.md  (one line)
└── .gitignore        ← includes .claude/*, .gemini/, .agents/
```

`CLAUDE.md` is the only file that changes session-to-session — it holds the rolling "Current Sprint Status." `AGENTS.md` holds the stable project context (working agreement, tech stack, conventions, tool preferences). `GEMINI.md` is one line that points at `AGENTS.md`.

User-level rules (a personal "Working Agreement" that applies to every project) propagate the same way:

- `~/.claude/CLAUDE.md` — Claude native.
- `~/.codex/AGENTS.md` → symlink → `~/.claude/CLAUDE.md` (Codex follows symlinks).
- `~/.gemini/GEMINI.md` contains `@/home/<user>/.claude/CLAUDE.md` (absolute path; Gemini does NOT follow symlinks per [issue #11547](https://github.com/google-gemini/gemini-cli/issues/11547)).

The `templates/AGENTS.md.template` shipped here mirrors that user-level Working Agreement into each project, so the rules apply consistently whether the user-level config is loaded or not.

## Skills included

Drop these in your project's `.claude/skills/` to make them available as slash commands. (cc-templates' own root has them installed for dogfooding — clone the repo and copy `.claude/skills/*` into your project if you want them.)

### `/wrap`

Session-end full recap. Distills the current session into 5-7 bullets, archives the previous session block from `CLAUDE.md` to `.claude/sessions/session-history.md`, and maintains a 10-session rolling window — when active history hits 11, the oldest moves to `.claude/sessions/session-history-archive.md`.

**Distinct from Claude Code's built-in `/recap`** (v2.1.108+), which is a one-line synopsis triggered after terminal idle. `/wrap` is the explicit, full session-end version.

### `/ready`

Read-only project context scanner. Prints a ~30-line snapshot: project name, current sprint state, git status, installed skills, CLI tool availability matrix (`gh`, `gws`, `rclone`, `ntn`, `acli`, `playwright`). Run at session start to confirm the toolchain is loaded.

### `/setup-multi-agent`

Bootstraps a new project with `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` from `templates/`, patches `.gitignore`, and prints verification commands.

## Tool preference: CLI over MCP

The `AGENTS.md` template includes a section ranking CLI tools over MCP servers for the same service. Reasons:

- **Token efficiency.** Benchmarks (Firecrawl, Arize, 2025) show roughly 17× fewer tokens per task for CLI vs MCP at 10k ops/month — 1.3-8.7k tokens (CLI) vs 32-82k tokens (MCP).
- **Cross-agent auth.** CLI auth lives in `~/.config/<tool>/` and is shared across Claude / Codex / Gemini. MCP OAuth is per-agent.
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

See [`templates/setup-instructions.md`](templates/setup-instructions.md) for the 5-step human checklist.

## v2 users

The previous architecture — "Claude Code Multi-Agent Coordination System" with 5 internal specialist agents and `/recap` / `/ready` / `/setup-agents` slash commands — is preserved on the [`v2-archive`](https://github.com/FuzzyKala/cc-templates/tree/v2-archive) branch. v3 is a full rewrite, not a backwards-compatible upgrade. The `/recap` command was renamed to `/wrap` because Claude Code v2.1.108 shipped a built-in `/recap` that cannot be overridden.

For migration: there is no automatic migration path. Run `/setup-multi-agent` in any project that previously used cc-templates v2 — it will drop the new files alongside the old ones. You can then manually remove `.claude/agents/`, `.claude/commands/`, `.claude/system/` from that project.

## References

- AGENTS.md spec: <https://agents.md/>
- Claude Code memory imports (`@AGENTS.md`): <https://code.claude.com/docs/en/memory>
- Claude Code skills format: <https://code.claude.com/docs/en/skills>
- Gemini CLI memport: <https://github.com/google-gemini/gemini-cli/blob/main/docs/reference/memport.md>
- Codex CLI agents.md: <https://developers.openai.com/codex/guides/agents-md>

## License

MIT. See [LICENSE](LICENSE).
