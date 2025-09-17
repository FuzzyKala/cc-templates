# {{PROJECT_NAME}} - Project Status

## Current Session Status

- **Last Updated**: {{CURRENT_DATE}} (Session {{SESSION_NUMBER}})
- **Project Status**: {{COMPLETION_PERCENTAGE}}% Complete ({{COMPLETED_STAGES}}/{{TOTAL_STAGES}} stages done)
- **Active Stage**: {{CURRENT_STAGE}} - {{STAGE_DESCRIPTION}}
- **Next Priority**: {{NEXT_PRIORITY}}
- **Recent Changes**: {{RECENT_CHANGES}}
- **Blockers**: {{CURRENT_BLOCKERS}}
- **Ready for**: {{READY_FOR}}

### Session {{SESSION_NUMBER}} Achievements ({{CURRENT_DATE}})

✅ **{{ACHIEVEMENT_1}}**: {{ACHIEVEMENT_1_DESCRIPTION}}
✅ **{{ACHIEVEMENT_2}}**: {{ACHIEVEMENT_2_DESCRIPTION}}
✅ **{{ACHIEVEMENT_3}}**: {{ACHIEVEMENT_3_DESCRIPTION}}

## Project Overview

{{PROJECT_DESCRIPTION}} built with {{TECH_STACK}}. Features {{KEY_FEATURES}} and {{ARCHITECTURE_DESCRIPTION}}.

## Tech Stack

- **Framework**: {{MAIN_FRAMEWORK}}
- **Language**: {{PROGRAMMING_LANGUAGE}}
- **Styling**: {{STYLING_APPROACH}}
- **{{ADDITIONAL_TECH_1}}**: {{ADDITIONAL_TECH_1_DESC}}
- **{{ADDITIONAL_TECH_2}}**: {{ADDITIONAL_TECH_2_DESC}}
- **Tools**: {{DEVELOPMENT_TOOLS}}

## Development Status

### ✅ COMPLETED STAGES ({{COMPLETED_STAGES}}/{{TOTAL_STAGES}})

{{#COMPLETED_STAGE_LIST}}
{{STAGE_NUMBER}}. **{{STAGE_NAME}}** ✅ - {{STAGE_DESCRIPTION}}
{{/COMPLETED_STAGE_LIST}}

### 🔄 IN PROGRESS ({{IN_PROGRESS_STAGES}}/{{TOTAL_STAGES}})

{{#IN_PROGRESS_STAGE_LIST}}
{{STAGE_NUMBER}}. **{{STAGE_NAME}}** 🔄 - {{STAGE_DESCRIPTION}}
{{/IN_PROGRESS_STAGE_LIST}}

### ⏳ PENDING ({{PENDING_STAGES}}/{{TOTAL_STAGES}})

{{#PENDING_STAGE_LIST}}
{{STAGE_NUMBER}}. **{{STAGE_NAME}}** ⏳ - {{STAGE_DESCRIPTION}}
{{/PENDING_STAGE_LIST}}

## File Structure

```
{{PROJECT_NAME}}/
├── .claude/
│   ├── agents/                 # 5 core agent definitions
│   ├── sessions/               # Session history archive
│   └── system/                 # System coordination and session management
{{#FILE_STRUCTURE}}
├── {{FOLDER_NAME}}/           # {{FOLDER_DESCRIPTION}}
{{/FILE_STRUCTURE}}
├── {{CONFIG_FILE}}            # {{CONFIG_DESCRIPTION}}
└── package.json              # Dependencies and scripts
```

## Current Tasks & Priorities

### Immediate Tasks ({{CURRENT_STAGE}} - {{STAGE_DESCRIPTION}})

{{#IMMEDIATE_TASKS}}
- [ ] **{{TASK_NAME}}**: {{TASK_DESCRIPTION}}
{{/IMMEDIATE_TASKS}}

### Upcoming Tasks ({{NEXT_STAGE}} - {{NEXT_STAGE_DESCRIPTION}})

{{#UPCOMING_TASKS}}
- [ ] {{TASK_DESCRIPTION}}
{{/UPCOMING_TASKS}}

### Known Configurations

{{#CONFIGURATIONS}}
- **{{CONFIG_NAME}}**: {{CONFIG_DESCRIPTION}}
{{/CONFIGURATIONS}}

## Development Commands

```bash
{{#DEV_COMMANDS}}
{{COMMAND}}      # {{COMMAND_DESCRIPTION}}
{{/DEV_COMMANDS}}
```

## Session Initialization

**Use `/ready` command** - Global command from `~/.claude/commands/ready.md` for automated session initialization.

## Session Recap

**Use `/recap` command** - Global command from `~/.claude/commands/recap.md` for automated session documentation.

## System Documentation Reference

**Commands**: Global commands in `~/.claude/commands/` (ready, recap)  
**Specialist Agents**: See `.claude/agents/` for 5 core specialist agents (main-agent-project-manager, implementation-specialist, design-specialist, quality-specialist, deployment-specialist)  
**Session Archive**: See `.claude/sessions/session-history.md` for complete historical session records (rolling window system)

**System Framework**:

- **Workflow Coordination**: `.claude/system/workflow-principles.md` - Delegation philosophy and coordination patterns
- **Session Management**: `.claude/system/session-management.md` - Session templates and handoff protocols

**Agent Usage Pattern**: Start each session with `/ready` command for complete initialization. When in doubt, delegate to the appropriate specialist rather than handling directly.

_Complete system documentation available in `.claude/` directory with commands, agents, sessions, and system framework._