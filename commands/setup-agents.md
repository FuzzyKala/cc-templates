---
name: setup-agents
aliases: [apply-cct, bootstrap-agents]
description: Automatically set up multi-agent coordination system with intelligent project detection
---

# /setup-agents - Intelligent Agent Coordination Setup

🤖 **Smart Multi-Agent Setup**

Automatically configure agent coordination system for your current project with intelligent detection and seamless integration.

## Quick Usage

```bash
# Auto-detect and setup (most common)
/setup-agents

# Interactive mode if detection fails
/setup-agents --interactive

# Validate existing setup
/setup-agents --validate

# Force setup (skip existing directory check)
/setup-agents --force

# See what would be done without changes
/setup-agents --dry-run
```

## How It Works

### 1. **Project Detection**
Analyzes your current project to determine optimal agent configuration:

```javascript
// Next.js Project Detection
if (packageJson.dependencies?.next || packageJson.devDependencies?.next) {
  → web-frontend + Next.js optimization
  → Agents: frontend-engineer, ui-ux-designer, code-reviewer, testing-specialist
}

// React Project Detection  
if (packageJson.dependencies?.react && !hasNextJs) {
  → web-frontend + React patterns
  → Agents: frontend-engineer, ui-ux-designer, code-reviewer, testing-specialist
}

// Node.js API Detection
if (packageJson.dependencies?.express || packageJson.dependencies?.fastify) {
  → backend-api + Node.js patterns
  → Agents: backend-engineer, code-reviewer, testing-specialist, deployment-engineer
}

// Fullstack Detection
if (hasReact && hasNodejsApi) {
  → fullstack coordination
  → Agents: fullstack-engineer, ui-ux-designer, backend-engineer, code-reviewer, testing-specialist
}
```

### 2. **Agent Configuration**
Applies optimal agent templates based on detected project type:

- **Variables replaced** with project-specific values
- **Agent descriptions** customized for your tech stack
- **Delegation patterns** optimized for your development workflow
- **Quality gates** configured for your project requirements

### 3. **Validation**
Ensures setup works correctly:
- All agent files created successfully
- CLAUDE.md updated with proper context
- `/ready` command functions correctly
- Agent coordination patterns operational

## Project Detection Logic

### Web Frontend Projects
```bash
# Next.js Projects
✓ package.json contains "next"
→ Result: Next.js web frontend with SSR/SSG capabilities
→ Agents: frontend-engineer, ui-ux-designer, code-reviewer, testing-specialist
→ Focus: Component development, performance optimization, accessibility

# React Projects
✓ package.json contains "react" (without "next")
→ Result: React web frontend with modern patterns
→ Agents: frontend-engineer, ui-ux-designer, code-reviewer, testing-specialist  
→ Focus: Component architecture, state management, responsive design
```

### Backend API Projects
```bash
# Express.js APIs
✓ package.json contains "express"
→ Result: Node.js backend API
→ Agents: backend-engineer, code-reviewer, testing-specialist, deployment-engineer
→ Focus: API development, database integration, performance, security

# Fastify APIs  
✓ package.json contains "fastify"
→ Result: High-performance Node.js API
→ Agents: backend-engineer, code-reviewer, testing-specialist, deployment-engineer
→ Focus: Fast APIs, schema validation, production deployment
```

### Fullstack Projects
```bash
# Combined Frontend + Backend
✓ Has both React/Next.js AND Express/Fastify
→ Result: Fullstack web application
→ Agents: fullstack-engineer, ui-ux-designer, backend-engineer, code-reviewer, testing-specialist
→ Focus: End-to-end development, API integration, deployment coordination
```

## Execution Examples

### Example 1: Next.js Project Setup
```markdown
Current Project: my-nextjs-app/
├── package.json (has "next": "14.0.0")
├── pages/
├── components/
└── public/

Command: /setup-agents

Detection: ✅ Next.js frontend project detected
Agents Selected: main-agent-project-manager, implementation-specialist, design-specialist, quality-specialist, deployment-specialist
Configuration: Next.js optimized templates with SSR/SSG context and streamlined 5-agent coordination
Validation: ✅ All agents configured, /ready command tested
Result: "🚀 Next.js agent coordination ready - 5 core specialists configured for comprehensive development support"
```

### Example 2: Fullstack Project Setup  
```markdown
Current Project: my-fullstack-app/
├── package.json (has "next" AND "express")
├── pages/ (frontend)
├── server/ (backend API)
└── shared/

Command: /setup-agents

Detection: ✅ Fullstack project detected
Agents Selected: main-agent-project-manager, implementation-specialist, design-specialist, quality-specialist, deployment-specialist
Configuration: Fullstack coordination with comprehensive end-to-end development patterns
Validation: ✅ All 5 core agents configured for end-to-end development
Result: "🚀 Fullstack coordination ready - 5 core specialists configured for complete development lifecycle"
```

### Example 3: Interactive Mode
```markdown
Current Project: my-custom-project/
├── custom-config.js
└── src/

Command: /setup-agents
Detection: ❓ Unable to auto-detect project type

Interactive Mode Activated:
1. Web Frontend (React/Next.js, Vue, etc.)
2. Backend API (Node.js, Python, etc.)  
3. Mobile App (React Native, Flutter, etc.)
4. AI/ML Project (Python, TensorFlow, etc.)
5. Custom Setup

User selects: 1 (Web Frontend)
Result: Web frontend agents configured with manual customization needed
```

## Command Options

### Basic Options
```bash
/setup-agents                    # Auto-detect and setup
/setup-agents --interactive      # Force interactive mode
/setup-agents --validate        # Check existing setup
/setup-agents --dry-run         # Show what would be done
```

### Advanced Options  
```bash
/setup-agents --type=web-frontend     # Force specific project type
/setup-agents --include=product-manager  # Add optional agents
/setup-agents --no-validation          # Skip validation checks
/setup-agents --backup-first          # Backup existing .claude/ directory
```

## Validation Checks

### Setup Validation
After configuration, the system validates:

- [ ] **Directory Structure**: `.claude/` with proper subdirectories created
- [ ] **Agent Files**: All required agent.md files copied and customized  
- [ ] **Command Integration**: `/ready` and `/recap` commands work correctly
- [ ] **CLAUDE.md**: Project documentation created or updated appropriately
- [ ] **Variable Replacement**: Template variables replaced with project-specific values
- [ ] **Git Compatibility**: Setup works with existing repository structure

### Health Check Results
```markdown
✅ Setup Validation Complete

Project Type: Next.js Web Frontend
Agents Configured: 4/4 successfully
- ✅ frontend-engineer: Ready for Next.js component development
- ✅ ui-ux-designer: Configured for responsive design and accessibility  
- ✅ code-reviewer: Set up for performance and security validation
- ✅ testing-specialist: Ready for Jest/RTL/Cypress testing strategies

Commands Available:
- ✅ /ready: Project context scanning operational
- ✅ /recap: Session documentation system active

Next Steps:
1. Run /ready to initialize your first coordination session
2. Begin development with specialist agent support
3. Use agents for complex tasks requiring domain expertise
```

## Error Handling

### Common Issues & Solutions

**Project Detection Failed**:
```bash
Problem: Unable to determine project type automatically
Solution: Use /setup-agents --interactive for manual selection
Alternative: Use /setup-agents --type=PROJECT_TYPE to force specific type
```

**Existing Setup Conflicts**:
```bash
Problem: .claude/ directory already exists
Solution: Use /setup-agents --backup-first to preserve existing setup
Alternative: Use /setup-agents --validate to check current setup first
```

**Template Variable Errors**:
```bash
Problem: Some template variables not replaced properly
Solution: Re-run /setup-agents to fix variable replacement
Alternative: Manual edit of affected agent files in .claude/agents/
```

**Validation Failures**:
```bash
Problem: /ready command doesn't work after setup
Solution: Check .claude/commands/ directory exists and has proper files
Alternative: Re-run /setup-agents --validate for detailed diagnostic
```

## Integration Benefits

### Immediate Value
- **5-minute setup** from project detection to working coordination
- **No manual configuration** for common project types
- **Intelligent agent selection** based on actual project needs
- **Built-in validation** ensures setup works correctly

### Long-term Benefits  
- **Effective task delegation** to appropriate domain specialists
- **Consistent quality standards** through systematic specialist review
- **Improved development velocity** via structured coordination
- **Knowledge preservation** across sessions and team members

### Workflow Integration
```bash
# Typical workflow after setup
/ready                    # Start session with project context
# Work with agent coordination for complex tasks
# Agent handles implementation while you coordinate
/recap                    # Document progress and achievements
```

## Next Steps After Setup

1. **Initialize First Session**: Run `/ready` to test agent coordination
2. **Review Agent Configurations**: Check `.claude/agents/` files for any needed customizations  
3. **Update CLAUDE.md**: Add project-specific priorities and current status
4. **Begin Coordinated Development**: Use agents for domain-specific tasks
5. **Establish Session Rhythm**: Regular `/ready` starts and `/recap` ends

**Success Indicator**: When you can delegate complex tasks to appropriate specialists and get quality results that integrate seamlessly with your project.

Transform your development process from manual coordination to intelligent, systematic agent collaboration in under 5 minutes.