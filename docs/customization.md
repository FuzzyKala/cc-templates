# Customization Guide

## Overview

The Claude Session Management System is designed to be highly customizable. This guide covers how to adapt the system for your specific needs.

## Template Variables

### Core Variables
All templates use these standard variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Your project name | "My Awesome App" |
| `{{PROJECT_TYPE}}` | Type of project | "Web Frontend" |
| `{{TECH_STACK}}` | Technologies used | "React, TypeScript, Node.js" |
| `{{PROJECT_DESCRIPTION}}` | Brief project description | "E-commerce platform" |

### Agent-Specific Variables

| Variable | Usage | Example Values |
|----------|-------|----------------|
| `{{IMPLEMENTATION_AGENT}}` | Primary developer agent | frontend-engineer, backend-engineer |
| `{{DESIGN_AGENT}}` | Design specialist | ui-ux-designer, data-engineer |
| `{{DEPLOYMENT_AGENT}}` | Deployment specialist | deployment-engineer |

## Creating Custom Project Types

### 1. Create Project Template
```bash
cp ~/.claude-templates/project-templates/web-frontend.json ~/.claude-templates/project-templates/my-custom.json
```

### 2. Customize Configuration
```json
{
  "project_type": "My Custom Project",
  "description": "Custom project type description",
  "required_agents": [
    "main-agent-project-manager",
    "custom-engineer",
    "code-reviewer"
  ],
  "variables": {
    "PROJECT_TYPE": "Custom Project",
    "TECH_STACK": "Custom Tech Stack"
  }
}
```

### 3. Create Custom Agents
```bash
cp ~/.claude-templates/agents/frontend-engineer.md ~/.claude-templates/agents/custom-engineer.md
```

Edit the agent file to match your domain:
- Update role and responsibilities
- Modify delegation triggers
- Customize quality standards
- Adjust collaboration patterns

## Customizing Development Stages

### In CLAUDE.md Template
Modify the development stages section:

```markdown
### ✅ COMPLETED STAGES (0/6)

1. **Planning & Architecture** ⏳ - Requirements gathering and system design
2. **Core Development** ⏳ - Main feature implementation
3. **Integration** ⏳ - System integration and API connections
4. **Testing & QA** ⏳ - Quality assurance and bug fixes
5. **Performance Optimization** ⏳ - Speed and efficiency improvements
6. **Production Deployment** ⏳ - Final deployment and monitoring
```

### Custom Stage Examples

**For AI/ML Projects:**
1. Data Collection & Exploration
2. Model Development & Training
3. Model Evaluation & Validation
4. API Development
5. Testing & Quality Assurance
6. Model Deployment
7. Monitoring & Maintenance

**For Mobile Apps:**
1. Project Setup & Architecture
2. Core Navigation & Structure
3. Feature Implementation
4. Platform Integration
5. Testing & Quality Assurance
6. Performance Optimization
7. App Store Preparation
8. Production Release

## Custom Quality Standards

### In Agent Templates
Update the Quality Standards section:

```markdown
# Quality Standards
- **Performance**: {{CUSTOM_PERFORMANCE_METRICS}}
- **Security**: {{CUSTOM_SECURITY_REQUIREMENTS}}
- **Documentation**: {{CUSTOM_DOC_STANDARDS}}
- **Testing**: {{CUSTOM_TEST_COVERAGE}}
```

### Examples by Domain

**For High-Performance Applications:**
```markdown
- **Performance**: Sub-10ms response times, 99.99% uptime
- **Load Testing**: Handle 10,000+ concurrent users
- **Memory**: Optimize for minimal memory footprint
```

**For Security-Critical Applications:**
```markdown
- **Security**: OWASP compliance, penetration testing
- **Encryption**: End-to-end encryption for all data
- **Audit**: Complete audit trails and logging
```

## Command Customization

### Modifying `/ready` Command
Edit `commands/ready.md` to add project-specific scanning:

```markdown
**Project-Specific Scanning:**
- **{{PROJECT_TYPE}} Configuration**: {{CUSTOM_CONFIG_CHECK}}
- **{{TECH_STACK}} Dependencies**: {{DEPENDENCY_VALIDATION}}
- **Custom Quality Gates**: {{QUALITY_GATE_STATUS}}
```

### Modifying `/recap` Command
Customize session documentation patterns:

```markdown
*Full Detail Format (current session):*
```markdown
### Session X Achievements (YYYY-MM-DD)

✅ **{{CUSTOM_ACHIEVEMENT_CATEGORY}}**: {{ACHIEVEMENT_DESCRIPTION}}
✅ **{{PROJECT_SPECIFIC_WORK}}**: {{TECHNICAL_IMPLEMENTATION}}

#### Session X {{CUSTOM_FRAMEWORK_NAME}}:
- **{{CUSTOM_COMPONENT}}**: {{TECHNICAL_DETAILS}}
```

## Agent Coordination Patterns

### Custom Delegation Patterns
Add project-specific patterns to `agents/team-workflow-protocols.md`:

```markdown
**For {{PROJECT_TYPE}} Development:**
- **{{CUSTOM_TASK_TYPE}}** → {{CUSTOM_AGENT}} + {{SUPPORTING_AGENT}}
- **{{SPECIFIC_WORKFLOW}}** → {{AGENT_SEQUENCE}}
- **{{QUALITY_GATE}}** → {{REVIEW_PATTERN}}
```

### Example Custom Patterns

**For DevOps-Heavy Projects:**
```markdown
- **Infrastructure Changes** → deployment-engineer + security-specialist
- **Performance Issues** → backend-engineer + deployment-engineer
- **Security Reviews** → security-specialist + code-reviewer
```

**For Data-Intensive Projects:**
```markdown
- **Data Pipeline Issues** → data-engineer + ai-engineer
- **Model Performance** → ai-engineer + deployment-engineer
- **Data Quality Problems** → data-engineer + testing-specialist
```

## Environment-Specific Customizations

### Development vs Production
Create environment-specific configurations:

```bash
# Development environment
CLAUDE_ENV=development ~/.claude-templates/scripts/install.sh

# Production environment  
CLAUDE_ENV=production ~/.claude-templates/scripts/install.sh
```

### Team vs Individual
Adapt for team collaboration:

```markdown
# Team Coordination
- **Standup Integration**: Daily progress sync with team
- **PR Reviews**: Code-reviewer coordination with team members
- **Sprint Planning**: Product-manager alignment with team goals
```

## Advanced Customizations

### Custom Session Workflows
Create project-specific session types:

```bash
# Feature development session
claude-init --session-type=feature

# Bug fixing session
claude-init --session-type=bugfix

# Performance optimization session
claude-init --session-type=performance
```

### Integration with External Tools
Add tool-specific configurations:

```markdown
**Tool Integration:**
- **Jira**: Issue tracking and sprint management
- **Slack**: Team communication and notifications
- **Jenkins**: CI/CD pipeline coordination
- **Grafana**: Performance monitoring and alerts
```

### Custom Learning Patterns
Extend the continuous learning framework:

```markdown
## Custom Learning Triggers
- **{{PROJECT_SPECIFIC_PATTERN}}**: Track and learn from recurring issues
- **{{TECHNOLOGY_EVOLUTION}}**: Adapt to new framework versions
- **{{TEAM_DYNAMICS}}**: Learn from team collaboration patterns
```

## Best Practices for Customization

### 1. Start Small
- Begin with existing templates
- Make incremental changes
- Test thoroughly before deploying

### 2. Document Changes
- Keep customization notes
- Version control your changes
- Share insights with team

### 3. Maintain Compatibility
- Preserve core system structure
- Keep rolling window functionality
- Maintain command interfaces

### 4. Test Across Projects
- Validate on multiple project types
- Ensure cross-project learning works
- Verify agent coordination effectiveness

## Sharing Customizations

### Contributing Back
If your customizations could benefit others:

1. Fork the repository
2. Create feature branch
3. Add your customizations
4. Submit pull request with documentation

### Internal Team Sharing
For organization-specific customizations:

1. Create internal fork
2. Add team-specific templates
3. Document internal patterns
4. Train team on customizations

This customization framework ensures the system adapts to your specific needs while maintaining the proven core architecture.