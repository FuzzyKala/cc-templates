---
name: ready
description: Get ready for work by scanning available resources and project context with optional setup verification
---

# /ready - Project Context Scanner & Validation

🤖 **Main Project Manager Agent Ready**

Scan project resources, present current context, and optionally validate agent setup:

## Standard Mode
1. **Scan agents directory** using Glob(.claude/agents/*)
2. **Read project status** from CLAUDE.md  
3. **Check git status** to confirm repository state
4. **Validate agent setup** if --validate flag provided

## Setup Validation Mode
Use `/ready --validate` to run comprehensive setup verification:

### Agent System Health Check
- [ ] **Directory Structure**: Verify .claude/ directory exists with proper subdirectories
- [ ] **Required Agents**: Check main-agent-project-manager.md exists and is properly configured  
- [ ] **Agent Count**: Validate appropriate number of agents for project type
- [ ] **Configuration**: Verify template variables have been replaced
- [ ] **Commands**: Check /ready and /recap commands are functional

### Project Integration Check  
- [ ] **CLAUDE.md**: Verify project documentation exists and has current session context
- [ ] **Git Integration**: Ensure setup works with repository structure
- [ ] **Agent Coordination**: Test basic delegation patterns work
- [ ] **Context Flow**: Verify project context flows properly to agents

Present concise summary:

## Available Specialist Agents
- List each agent found with brief capability description
- **main-agent-project-manager**: Project coordination, task delegation, workflow management
- **{{IMPLEMENTATION_AGENT}}**: {{IMPLEMENTATION_DESCRIPTION}}
- **{{DESIGN_AGENT}}**: {{DESIGN_DESCRIPTION}}
- **product-manager**: Requirements analysis, PRDs, stakeholder communication
- **code-reviewer**: Security, quality, performance, accessibility analysis
- **testing-specialist**: Test strategies, automation, quality assurance
- **{{DEPLOYMENT_AGENT}}**: {{DEPLOYMENT_DESCRIPTION}}

## Current Project Context
- Current Stage (from CLAUDE.md)
- Next Priority (from CLAUDE.md)
- Project Status percentage
- Recent Changes summary
- Any Blockers

## Git Repository Status
- Current branch
- Working tree state (clean/modified)

## Project Information
- **Project Type**: {{PROJECT_TYPE}}
- **Technology Stack**: {{TECH_STACK}}
- **Primary Focus**: {{PRIMARY_FOCUS}}

## Validation Results (if --validate used)
```markdown
✅ Agent Setup Validation Complete

Directory Structure: ✅ .claude/ with agents/, commands/, system/, sessions/
Agent Configuration: ✅ 4 agents configured properly
- main-agent-project-manager: ✅ Central coordination ready  
- frontend-engineer: ✅ Next.js development configured
- ui-ux-designer: ✅ Responsive design and accessibility ready
- code-reviewer: ✅ Quality gates and performance validation ready
- testing-specialist: ✅ Jest/RTL/Cypress testing strategies ready

Template Variables: ✅ All {{VARIABLES}} replaced with project-specific values
Commands: ✅ /ready and /recap operational
Project Integration: ✅ CLAUDE.md updated with agent coordination context

🚀 Agent coordination system fully operational and ready for development tasks
```

## Ready for Coordination
Confirm initialization complete and ready to coordinate {{PROJECT_TYPE}} tasks using context-driven delegation patterns.

**Usage Options:**
- `/ready` - Standard session initialization with project context
- Run at session start for {{PROJECT_TYPE}} project context and agent capability overview
# Another test change for pre-commit
