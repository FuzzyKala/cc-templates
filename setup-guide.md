# Claude Session Management System - Setup Guide

## Overview

This is a generalized version of a proven session management system that has evolved through practical use. It provides:
- **Agent-based coordination** with specialized AI agents
- **Rolling window documentation** that prevents document bloat
- **Automated session management** with `/ready` and `/recap` commands
- **Cross-project learning** and continuous improvement

## Quick Start

### 1. Choose Your Project Type

Available project templates in `~/.claude-templates/project-templates/`:
- **web-frontend.json**: Modern web applications (React/Next.js, Vue, etc.)
- **mobile-app.json**: Mobile applications (React Native, Flutter, etc.)
- **ai-ml.json**: AI/ML projects (Python, TensorFlow, PyTorch, etc.)
- **backend-api.json**: Server-side APIs (Node.js, Python, Java, etc.)

### 2. Initialize Your Project

```bash
# Navigate to your project directory
cd /path/to/your/project

# Copy the template system
cp -r ~/.claude-templates/.claude ./

# Copy base CLAUDE.md template
cp ~/.claude-templates/CLAUDE.md ./

# Initialize with your chosen project type (see Project Initialization section)
```

### 3. Customize for Your Project

1. **Choose Project Type**: Select a template from `project-templates/`
2. **Update Variables**: Replace template variables in agents and CLAUDE.md
3. **Select Agents**: Copy only the agents you need for your project type
4. **Test Commands**: Try `/ready` and `/recap` commands

## Detailed Setup Instructions

### Project Initialization

#### Option 1: Manual Setup

1. **Copy Core System**:
   ```bash
   cp -r ~/.claude-templates/.claude ./
   cp ~/.claude-templates/CLAUDE.md ./
   ```

2. **Choose Project Template**: 
   - Review templates in `~/.claude-templates/project-templates/`
   - Choose the one that best matches your project

3. **Update CLAUDE.md**:
   - Replace `{{PROJECT_NAME}}` with your project name
   - Replace `{{PROJECT_TYPE}}` with your project type
   - Update `{{TECH_STACK}}` with your technology stack
   - Fill in current status information

4. **Select Agents**:
   ```bash
   # Copy only agents you need based on project template
   cp ~/.claude-templates/agents/main-agent-project-manager.md ./.claude/agents/
   cp ~/.claude-templates/agents/frontend-engineer.md ./.claude/agents/
   # ... copy other needed agents
   ```

5. **Customize Agents**:
   - Replace template variables in each agent file
   - Update agent descriptions to match your project
   - Modify delegation triggers for your specific use case

#### Option 2: Template-Based Setup

1. **Web Frontend Project**:
   ```bash
   # Copy template and customize for web development
   cp -r ~/.claude-templates/.claude ./
   cp ~/.claude-templates/CLAUDE.md ./
   
   # Copy web-specific agents
   cp ~/.claude-templates/agents/{main-agent-project-manager,frontend-engineer,ui-ux-designer,code-reviewer,testing-specialist,deployment-engineer}.md ./.claude/agents/
   
   # Update variables based on web-frontend.json template
   ```

2. **Mobile App Project**:
   ```bash
   # Copy template and customize for mobile development
   cp -r ~/.claude-templates/.claude ./
   cp ~/.claude-templates/CLAUDE.md ./
   
   # Copy mobile-specific agents
   cp ~/.claude-templates/agents/{main-agent-project-manager,mobile-engineer,ui-ux-designer,code-reviewer,testing-specialist,deployment-engineer}.md ./.claude/agents/
   ```

3. **AI/ML Project**:
   ```bash
   # Copy template and customize for AI/ML development
   cp -r ~/.claude-templates/.claude ./
   cp ~/.claude-templates/CLAUDE.md ./
   
   # Copy AI-specific agents
   cp ~/.claude-templates/agents/{main-agent-project-manager,ai-engineer,data-engineer,code-reviewer,testing-specialist,deployment-engineer}.md ./.claude/agents/
   ```

4. **Backend API Project**:
   ```bash
   # Copy template and customize for backend development
   cp -r ~/.claude-templates/.claude ./
   cp ~/.claude-templates/CLAUDE.md ./
   
   # Copy backend-specific agents
   cp ~/.claude-templates/agents/{main-agent-project-manager,backend-engineer,code-reviewer,testing-specialist,deployment-engineer}.md ./.claude/agents/
   ```

### Variable Replacement Guide

#### Common Variables in CLAUDE.md

Replace these variables with your project-specific information:

```markdown
{{PROJECT_NAME}} → "My Awesome Project"
{{PROJECT_TYPE}} → "Web Frontend" / "Mobile App" / "AI/ML Project" / "Backend API"
{{TECH_STACK}} → "React, TypeScript, Node.js"
{{PROJECT_DESCRIPTION}} → Brief description of what your project does
{{COMPLETION_PERCENTAGE}} → Current completion percentage (e.g., "25")
{{CURRENT_STAGE}} → Current development stage
{{SESSION_NUMBER}} → Current session number (start with 1)
```

#### Agent-Specific Variables

Each agent template contains variables that need replacement:

```markdown
{{PROJECT_TYPE}} → Your project type
{{TECH_STACK}} → Your technology stack
{{IMPLEMENTATION_AGENT}} → "frontend-engineer" / "mobile-engineer" / etc.
{{DESIGN_AGENT}} → "ui-ux-designer" / "data-engineer" / etc.
{{DEPLOYMENT_AGENT}} → "deployment-engineer"
```

### Agent Selection by Project Type

#### Web Frontend Projects
**Required Agents:**
- main-agent-project-manager
- frontend-engineer  
- ui-ux-designer
- code-reviewer
- testing-specialist
- deployment-engineer

**Optional Agents:**
- product-manager (for complex features)

#### Mobile App Projects  
**Required Agents:**
- main-agent-project-manager
- mobile-engineer
- ui-ux-designer
- code-reviewer
- testing-specialist
- deployment-engineer

**Optional Agents:**
- product-manager (for complex apps)

#### AI/ML Projects
**Required Agents:**
- main-agent-project-manager
- ai-engineer
- data-engineer
- code-reviewer
- testing-specialist
- deployment-engineer

**Optional Agents:**
- product-manager (for product-focused AI)
- frontend-engineer (for AI web interfaces)

#### Backend API Projects
**Required Agents:**
- main-agent-project-manager
- backend-engineer
- code-reviewer
- testing-specialist
- deployment-engineer

**Optional Agents:**
- product-manager (for complex APIs)
- security-specialist (for sensitive data)

## System Components Explained

### Core Components

#### `.claude/system/` - Framework Files
- **workflow-principles.md**: Delegation philosophy and coordination patterns
- **session-management.md**: Session start/end protocols and templates
- **agent-evolution.md**: Design principles and improvement framework
- **continuous-learning.md**: Learning capture and system evolution

#### `.claude/agents/` - Specialist Agents
- **main-agent-project-manager.md**: Central coordination hub
- **Specialist agents**: Domain experts for implementation, design, testing, etc.
- **team-workflow-protocols.md**: Simplified coordination guidelines

#### `.claude/commands/` - Session Management
- **ready.md**: Session initialization command (`/ready`)
- **recap.md**: Session documentation command (`/recap`)

#### `.claude/sessions/` - Historical Archive
- **session-history.md**: Archived session details (rolling window system)

### How the System Works

#### Rolling Window Documentation
- **CLAUDE.md maintains**: Current session + last 2 sessions (150-180 lines)
- **Archive preserves**: Complete session details in session-history.md
- **Automatic management**: `/recap` command handles archiving and formatting

#### Agent Coordination
1. **Session Start**: Use `/ready` command to scan resources and context
2. **Task Delegation**: Main agent delegates to appropriate specialists
3. **Quality Gates**: Code-reviewer and testing-specialist validate work
4. **Session End**: Use `/recap` command to document progress

#### Session Management
1. **Initialization**: `/ready` provides complete project context
2. **Work Session**: Main agent coordinates specialists based on tasks
3. **Documentation**: `/recap` archives old sessions and updates current status
4. **Handoff**: Next session starts with clean, current context

## Commands Usage

### `/ready` Command
**Purpose**: Initialize new session with complete context

**What it does**:
- Scans available specialist agents
- Reviews current project status from CLAUDE.md
- Identifies coordination patterns and workflows
- Confirms git status and project health

**When to use**: Start of every new session

### `/recap` Command
**Purpose**: Document session progress and manage rolling window

**What it does**:
- Creates new session documentation in CLAUDE.md
- Archives old sessions to session-history.md
- Updates project status and completion percentage
- Maintains rolling window of current + 2 recent sessions

**When to use**: End of every session

## Customization Guide

### Adding New Agent Types

1. **Create Agent Definition**:
   ```bash
   cp ~/.claude-templates/agents/frontend-engineer.md ./.claude/agents/my-custom-agent.md
   ```

2. **Customize Agent**:
   - Update role and responsibilities
   - Define delegation triggers
   - Set quality standards
   - Update collaboration patterns

3. **Update Main Agent**:
   - Add to delegation decision matrix
   - Include in coordination protocols

### Modifying Project Stages

Update development stages in CLAUDE.md based on your project needs:

```markdown
### ✅ COMPLETED STAGES
1. **Project Setup** ✅ - Initial configuration and architecture
2. **Core Development** ✅ - Main feature implementation

### 🔄 IN PROGRESS  
3. **Testing & QA** 🔄 - Quality assurance and bug fixes

### ⏳ PENDING
4. **Production Deployment** ⏳ - Final deployment and monitoring
```

### Customizing Quality Standards

Update quality gates in main-agent-project-manager.md:

```markdown
**Quality Gates:**
- All code changes reviewed before integration
- Test coverage >80% for critical components
- Performance meets project benchmarks
- Security vulnerabilities addressed
- Documentation updated with changes
```

## Best Practices

### Session Management
- **Start every session** with `/ready` command
- **End every session** with `/recap` command  
- **Keep sessions focused** on 2-3 major objectives
- **Delegate complex work** to appropriate specialists

### Documentation
- **Update CLAUDE.md regularly** during sessions
- **Be specific in achievements** - include technical details
- **Capture lessons learned** - what worked, what didn't
- **Maintain project momentum** through clear next steps

### Agent Coordination
- **Provide complete context** when delegating
- **Set clear success criteria** for specialist work
- **Use quality gates** - have code-reviewer validate important work
- **Learn from patterns** - document what coordination works well

### System Evolution
- **Review agent effectiveness** monthly
- **Update templates** based on successful patterns
- **Share improvements** across projects
- **Adapt to new technologies** by updating agent definitions

## Troubleshooting

### Common Issues

#### "Agent doesn't understand project context"
- **Solution**: Ensure CLAUDE.md is up-to-date with current project state
- **Prevention**: Use `/ready` command at session start

#### "Documentation getting too long"
- **Solution**: Use `/recap` command to implement rolling window
- **Prevention**: Regular session documentation

#### "Quality issues with specialist work"
- **Solution**: Update agent definitions with clearer success criteria
- **Prevention**: Always provide complete context when delegating

#### "Losing project history"
- **Solution**: Check `.claude/sessions/session-history.md` for archived content
- **Note**: Nothing is lost, just organized differently

### System Maintenance

#### Monthly Review
- Evaluate agent effectiveness
- Update quality standards based on outcomes
- Refine delegation patterns
- Archive learning insights

#### Quarterly Updates
- Update agent definitions for new technologies
- Refine coordination protocols
- Share successful patterns
- Plan system improvements

This system has proven effective through real-world use and continues to evolve based on practical experience. Start simple, use the commands, and let the system adapt to your project needs.