#!/bin/bash

# Claude Code Multi-Agent Setup Script  
# Simple installation for agent coordination system

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
TEMPLATE_DIR="$HOME/.claude-templates"
PROJECT_DIR="$(pwd)"

# Version detection function
detect_version() {
    if [ ! -d ".claude" ]; then
        echo "none"         # Fresh install
    elif [ -f ".claude/agents/implementation-specialist.md" ]; then
        echo "v2"           # Already v2 (5 core agents)
    elif [ -f ".claude/agents/fullstack-engineer.md" ]; then
        echo "v1"           # Old v1 (19+ agents)
    else
        echo "unknown"      # Custom/broken setup
    fi
}

print_header() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────────────────────╮"
    echo "│               Claude Code Multi-Agent Setup                │"
    echo "│                     Simple Setup                           │" 
    echo "╰─────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in a valid project directory
check_project_directory() {
    print_step "Checking project directory..."
    
    if [[ ! -f "package.json" && ! -f "requirements.txt" && ! -f "pubspec.yaml" && ! -f "Cargo.toml" && ! -f "go.mod" ]]; then
        print_warning "No project files detected. This will set up a generic configuration."
        print_warning "For better results, run this in a project directory with package.json, requirements.txt, etc."
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Setup cancelled."
            exit 1
        fi
    fi
    
    print_success "Project directory validated"
}

# Set up the .claude directory with 5 core agents
setup_claude_directory() {
    print_step "Setting up .claude directory..."
    
    # Detect current version
    local current_version=$(detect_version)
    
    case $current_version in
        "none")
            print_success "Fresh installation - setting up v2 with 5 core agents"
            ;;
        "v1")
            print_warning "v1 installation detected!"
            echo ""
            echo "This will upgrade to v2 (5 core agents replace 19+ agents):"
            echo "  • fullstack-engineer → implementation-specialist"
            echo "  • ui-ux-designer → design-specialist"  
            echo "  • code-reviewer → quality-specialist"
            echo "  • deployment-engineer → deployment-specialist"
            echo ""
            echo "Consider backing up first: cp -r .claude .claude-v1-backup"
            echo ""
            read -p "Continue with v1 → v2 upgrade? (y/N): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Upgrade cancelled. Your v1 setup is unchanged."
                exit 0
            fi
            print_step "Upgrading v1 → v2..."
            ;;
        "v2")
            print_info "v2 already installed"
            echo ""
            echo "This will refresh your v2 setup with latest agent definitions."
            echo ""
            read -p "Continue with v2 refresh? (Y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "Refresh cancelled. Your v2 setup is unchanged."
                exit 0
            fi
            print_step "Refreshing v2 setup..."
            ;;
        "unknown")
            print_warning "Custom/unknown setup detected!"
            echo ""
            echo "This will replace your custom setup with standard v2 (5 core agents)."
            echo "Consider backing up first: cp -r .claude .claude-backup"
            echo ""
            read -p "Continue and replace with standard v2? (y/N): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Setup cancelled. Your custom setup is unchanged."
                exit 0
            fi
            print_step "Installing standard v2..."
            ;;
    esac
    
    # Create directory structure
    mkdir -p .claude/{agents,commands,sessions}
    
    # Copy 5 core agents
    if [ -d "$TEMPLATE_DIR/agents" ]; then
        cp "$TEMPLATE_DIR/agents"/*.md .claude/agents/
        print_success "5 core agents configured"
    else
        print_error "Agents not found in $TEMPLATE_DIR/agents"
        print_error "Please ensure cc-templates are installed correctly"
        exit 1
    fi
    
    # Copy commands
    if [ -f "$TEMPLATE_DIR/commands/ready.md" ]; then
        cp "$TEMPLATE_DIR/commands/ready.md" .claude/commands/
        print_success "/ready command configured"
    fi
    
    if [ -f "$TEMPLATE_DIR/commands/recap.md" ]; then
        cp "$TEMPLATE_DIR/commands/recap.md" .claude/commands/
        print_success "/recap command configured" 
    fi
    
    # Create session history file
    touch .claude/sessions/session-history.md
    print_success "Session management configured"
}

# Create or update CLAUDE.md
setup_claude_md() {
    print_step "Setting up CLAUDE.md..."
    
    # Try to detect project info
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    CURRENT_DATE=$(date +"%Y-%m-%d")
    
    # Basic project type detection
    PROJECT_TYPE="Unknown"
    TECH_STACK="To be determined"
    
    if [ -f "package.json" ]; then
        if grep -q '"next"' package.json; then
            PROJECT_TYPE="Next.js Web Frontend"
            TECH_STACK="Next.js, React, TypeScript"
        elif grep -q '"react"' package.json; then
            PROJECT_TYPE="React Web Frontend" 
            TECH_STACK="React, JavaScript/TypeScript"
        elif grep -q '"express"' package.json || grep -q '"fastify"' package.json; then
            PROJECT_TYPE="Node.js Backend API"
            TECH_STACK="Node.js, Express/Fastify"
        fi
    elif [ -f "requirements.txt" ]; then
        if grep -q -E "(fastapi|django|flask)" requirements.txt; then
            PROJECT_TYPE="Python Backend API"
            TECH_STACK="Python, FastAPI/Django/Flask"
        elif grep -q -E "(tensorflow|pytorch|scikit-learn)" requirements.txt; then
            PROJECT_TYPE="Python AI/ML"
            TECH_STACK="Python, TensorFlow/PyTorch"
        fi
    elif [ -f "pubspec.yaml" ]; then
        PROJECT_TYPE="Flutter Mobile App"
        TECH_STACK="Flutter, Dart"
    fi
    
    # Create CLAUDE.md
    cat > CLAUDE.md << EOF
# $PROJECT_NAME - Project Status

## Current Session Status

- **Last Updated**: $CURRENT_DATE (Session 1)
- **Project Status**: 5% - Agent coordination system established
- **Current Stage**: Setup and Planning
- **Next Priority**: Begin development with agent coordination
- **Recent Changes**: Streamlined 5-agent coordination system configured
- **Blockers**: None
- **Ready for**: Development with systematic agent coordination

### Session 1 Achievements ($CURRENT_DATE)

✅ **Agent System**: Configured 5 core specialists (main-agent-project-manager, implementation-specialist, design-specialist, quality-specialist, deployment-specialist)
✅ **Commands**: Set up /ready for session initialization and /recap for progress documentation
✅ **Workflow**: Established adaptive coordination patterns and context-driven delegation

## Project Overview

$PROJECT_TYPE project with streamlined multi-agent coordination. Features systematic task delegation to specialized agents and comprehensive quality gates.

## Tech Stack

- **Project Type**: $PROJECT_TYPE
- **Technology**: $TECH_STACK
- **Coordination**: 5-agent system with adaptive delegation patterns

## Agent Coordination System

### Available Specialist Agents
- **main-agent-project-manager**: Project coordination, task delegation, workflow management
- **implementation-specialist**: Code development, technical architecture, feature building
- **design-specialist**: UI/UX design, system architecture, user experience optimization
- **quality-specialist**: Code review, testing strategies, security analysis, quality assurance
- **deployment-specialist**: Production deployment, CI/CD, infrastructure management, monitoring

### Delegation Patterns
- **Development Tasks**: Implementation Specialist handles all coding and technical architecture
- **Design Decisions**: Design Specialist manages UI/UX and system design
- **Quality Gates**: Quality Specialist reviews code, tests, and security before production
- **Deployment**: Deployment Specialist manages all production and infrastructure concerns

## Commands
- \`/ready\` - Initialize session with project context and agent availability
- \`/recap\` - Document session progress and update project status

## Development Status

### ✅ COMPLETED (1/7 stages)
1. **Agent Coordination Setup** ✅ - 5-agent system configured and operational

### ⏳ PENDING (6/7 stages)
2. **Project Foundation** ⏳ - Core project setup and initial architecture
3. **Feature Development** ⏳ - Primary feature implementation
4. **Quality Assurance** ⏳ - Testing and code review processes
5. **Performance Optimization** ⏳ - Performance tuning and optimization
6. **Production Preparation** ⏳ - Deployment and infrastructure setup
7. **Launch & Monitoring** ⏳ - Production deployment and monitoring

## Quick Start
1. Run \`/ready\` to initialize session with complete context
2. Begin development with agent coordination - delegate complex tasks to appropriate specialists
3. Use \`/recap\` at session end to document progress and maintain context

Your 5-agent coordination system is ready for systematic, high-quality development!
EOF
    
    print_success "CLAUDE.md created with project context"
}

# Run basic validation
validate_setup() {
    print_step "Validating setup..."
    
    # Check directory structure
    if [ -d ".claude/agents" ] && [ -d ".claude/commands" ] && [ -d ".claude/sessions" ]; then
        print_success "Directory structure validated"
    else
        print_error "Directory structure incomplete"
        return 1
    fi
    
    # Check agents
    agent_count=$(find .claude/agents -name "*.md" | wc -l)
    if [ "$agent_count" -eq 5 ]; then
        print_success "5 core agents configured"
    else
        print_error "Expected 5 agents, found $agent_count"
        return 1
    fi
    
    # Check commands
    if [ -f ".claude/commands/ready.md" ] && [ -f ".claude/commands/recap.md" ]; then
        print_success "Commands configured"
    else
        print_error "Commands missing"
        return 1
    fi
    
    # Check CLAUDE.md
    if [ -f "CLAUDE.md" ]; then
        print_success "CLAUDE.md configured"
    else
        print_error "CLAUDE.md missing"
        return 1
    fi
    
    return 0
}

# Print success message and next steps
print_success_message() {
    echo ""
    echo -e "${GREEN}╭─────────────────────────────────────────────────────────────╮"
    echo -e "│                    ✅ Setup Complete!                       │"
    echo -e "╰─────────────────────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "${BLUE}🤖 Your 5-Agent Coordination System is Ready!${NC}"
    echo ""
    echo -e "Available Agents:"
    echo -e "  • ${GREEN}main-agent-project-manager${NC} - Central coordination"
    echo -e "  • ${GREEN}implementation-specialist${NC} - Code development & architecture"
    echo -e "  • ${GREEN}design-specialist${NC} - UI/UX & system design"  
    echo -e "  • ${GREEN}quality-specialist${NC} - Code review & testing"
    echo -e "  • ${GREEN}deployment-specialist${NC} - Production & DevOps"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e "  1. Run ${YELLOW}/ready${NC} to initialize your first session"
    echo -e "  2. Begin development with systematic agent coordination"
    echo -e "  3. Use ${YELLOW}/recap${NC} at session end to document progress"
    echo ""
    echo -e "${BLUE}Key Features:${NC}"
    echo -e "  • Intelligent task delegation to appropriate specialists"
    echo -e "  • Quality gates ensure consistent, high-quality deliverables"
    echo -e "  • Session management preserves context between sessions"
    echo -e "  • Adaptive coordination patterns optimize for your project type"
    echo ""
}

# Main installation process
main() {
    print_header
    
    print_step "Starting streamlined Claude Code multi-agent setup..."
    echo ""
    
    # Run setup steps
    check_project_directory
    setup_claude_directory
    setup_claude_md
    
    # Validate
    if validate_setup; then
        print_success_message
        exit 0
    else
        print_error "Setup validation failed"
        exit 1
    fi
}

# Check if templates are available
if [ ! -d "$TEMPLATE_DIR" ]; then
    print_error "Templates not found at $TEMPLATE_DIR"
    echo ""
    echo "Please install the templates first:"
    echo "git clone https://github.com/YOUR_USERNAME/claude-session-management-templates.git ~/.claude-templates"
    echo ""
    exit 1
fi

# Run main installation if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi