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

#### Session {{SESSION_NUMBER}} Technical Framework:

- **{{TECHNICAL_COMPONENT_1}}**: {{TECHNICAL_DETAILS_1}}
- **{{TECHNICAL_COMPONENT_2}}**: {{TECHNICAL_DETAILS_2}}
- **{{TECHNICAL_COMPONENT_3}}**: {{TECHNICAL_DETAILS_3}}

#### Session {{SESSION_NUMBER}} Lessons Learned:

✅ **{{LESSON_1}}**: {{LESSON_1_DESCRIPTION}}
✅ **{{LESSON_2}}**: {{LESSON_2_DESCRIPTION}}
✅ **{{LESSON_3}}**: {{LESSON_3_DESCRIPTION}}

### Session {{PREV_SESSION_1}} Achievements ({{PREV_DATE_1}})

✅ **{{PREV_ACHIEVEMENT_1}}**: {{PREV_ACHIEVEMENT_1_DESC}}
✅ **{{PREV_ACHIEVEMENT_2}}**: {{PREV_ACHIEVEMENT_2_DESC}}
✅ **{{PREV_ACHIEVEMENT_3}}**: {{PREV_ACHIEVEMENT_3_DESC}}

### Session {{PREV_SESSION_2}} Achievements ({{PREV_DATE_2}})

✅ **{{PREV2_ACHIEVEMENT_1}}**: {{PREV2_ACHIEVEMENT_1_DESC}}
✅ **{{PREV2_ACHIEVEMENT_2}}**: {{PREV2_ACHIEVEMENT_2_DESC}}
✅ **{{PREV2_ACHIEVEMENT_3}}**: {{PREV2_ACHIEVEMENT_3_DESC}}

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
│   ├── agents/                 # {{AGENT_COUNT}} specialized agent definitions
│   ├── commands/               # Session management commands
│   ├── sessions/               # Session history archive
│   └── system/                 # System documentation and continuous learning
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

**Use `/ready` command** - Automated session initialization that provides complete project context, current stage focus, and coordination setup in one command.

## Session Recap

**Use `/recap` command** - Automated session documentation with rolling window management that archives old sessions, maintains current context, and prepares seamless handoff for next session.

## System Documentation Reference

**Commands**: See `.claude/commands/ready.md` and `.claude/commands/recap.md` for automated session initialization and documentation  
**Specialist Agents**: See `.claude/agents/` for {{AGENT_COUNT}} specialist agents ({{AGENT_LIST}})  
**Session Archive**: See `.claude/sessions/session-history.md` for complete historical session records (rolling window system)

**System Framework**:

- **Agent Evolution**: `.claude/system/agent-evolution.md` - Agent standardization history and design principles
- **Workflow Coordination**: `.claude/system/workflow-principles.md` - Delegation philosophy and coordination patterns
- **Continuous Learning**: `.claude/system/continuous-learning.md` - Improvement framework and lesson capture
- **Session Management**: `.claude/system/session-management.md` - Session templates and handoff protocols

**Agent Usage Pattern**: Start each session with `/ready` command for complete initialization. When in doubt, delegate to the appropriate specialist rather than handling directly.

_Complete system documentation available in `.claude/` directory with commands, agents, sessions, and system framework._