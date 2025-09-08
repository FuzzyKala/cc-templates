#!/bin/bash

# Claude Session Management System - Project Initialization Script
# This script sets up a new project with the Claude session management system

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
TEMPLATE_DIR="$HOME/.claude-templates"

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "${RED}Error: Claude templates not found at $TEMPLATE_DIR${NC}"
    echo "Please ensure the templates are installed correctly."
    exit 1
fi

echo -e "${BLUE}🤖 Claude Session Management System${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Get current directory
CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")

echo -e "${GREEN}Initializing Claude session management for project: ${YELLOW}$PROJECT_NAME${NC}"
echo -e "${GREEN}Project directory: ${YELLOW}$CURRENT_DIR${NC}"
echo ""

# Check if .claude directory already exists
if [ -d ".claude" ]; then
    echo -e "${YELLOW}Warning: .claude directory already exists in this project.${NC}"
    read -p "Do you want to continue and overwrite? (y/N): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        echo "Initialization cancelled."
        exit 0
    fi
    echo ""
fi

# Show available project types
echo -e "${BLUE}Available Project Types:${NC}"
echo "1. Web Frontend (React/Next.js, Vue, etc.)"
echo "2. Mobile App (React Native, Flutter, etc.)"
echo "3. AI/ML Project (Python, TensorFlow, PyTorch, etc.)"
echo "4. Backend API (Node.js, Python, Java, etc.)"
echo "5. Custom (manual agent selection)"
echo ""

# Get project type selection
while true; do
    read -p "Select project type (1-5): " project_type
    case $project_type in
        1)
            PROJECT_TYPE="web-frontend"
            TYPE_NAME="Web Frontend"
            break
            ;;
        2)
            PROJECT_TYPE="mobile-app"
            TYPE_NAME="Mobile App"
            break
            ;;
        3)
            PROJECT_TYPE="ai-ml"
            TYPE_NAME="AI/ML Project"
            break
            ;;
        4)
            PROJECT_TYPE="backend-api"
            TYPE_NAME="Backend API"
            break
            ;;
        5)
            PROJECT_TYPE="custom"
            TYPE_NAME="Custom"
            break
            ;;
        *)
            echo "Please select a valid option (1-5)."
            ;;
    esac
done

echo ""
echo -e "${GREEN}Selected: ${YELLOW}$TYPE_NAME${NC}"
echo ""

# Get additional project information
read -p "Enter project description (or press Enter for default): " project_description
if [ -z "$project_description" ]; then
    project_description="$TYPE_NAME application"
fi

read -p "Enter technology stack (e.g., 'React, TypeScript, Node.js'): " tech_stack
if [ -z "$tech_stack" ]; then
    case $PROJECT_TYPE in
        "web-frontend")
            tech_stack="React, TypeScript, Next.js"
            ;;
        "mobile-app")
            tech_stack="React Native, TypeScript"
            ;;
        "ai-ml")
            tech_stack="Python, TensorFlow, FastAPI"
            ;;
        "backend-api")
            tech_stack="Node.js, TypeScript, Express"
            ;;
        *)
            tech_stack="Various"
            ;;
    esac
fi

echo ""
echo -e "${BLUE}Setting up Claude session management system...${NC}"

# Create .claude directory structure
echo "📁 Creating directory structure..."
mkdir -p .claude/{agents,commands,sessions,system}

# Copy system files
echo "📋 Copying system framework..."
cp "$TEMPLATE_DIR/system/"* ".claude/system/"

# Copy commands
echo "⚡ Setting up commands..."
cp "$TEMPLATE_DIR/commands/"* ".claude/commands/"

# Update commands with project-specific variables
if [ "$PROJECT_TYPE" != "custom" ]; then
    # Read project template configuration
    if [ -f "$TEMPLATE_DIR/project-templates/$PROJECT_TYPE.json" ]; then
        echo "🔧 Applying project template configuration..."
        
        # Extract variables from JSON (basic implementation)
        implementation_agent=$(grep -o '"IMPLEMENTATION_AGENT": "[^"]*"' "$TEMPLATE_DIR/project-templates/$PROJECT_TYPE.json" | cut -d'"' -f4)
        design_agent=$(grep -o '"DESIGN_AGENT": "[^"]*"' "$TEMPLATE_DIR/project-templates/$PROJECT_TYPE.json" | cut -d'"' -f4)
        deployment_agent=$(grep -o '"DEPLOYMENT_AGENT": "[^"]*"' "$TEMPLATE_DIR/project-templates/$PROJECT_TYPE.json" | cut -d'"' -f4)
        
        # Update command files with project-specific variables
        sed -i.bak "s/{{PROJECT_TYPE}}/$TYPE_NAME/g" .claude/commands/*.md
        sed -i.bak "s/{{TECH_STACK}}/$tech_stack/g" .claude/commands/*.md
        sed -i.bak "s/{{IMPLEMENTATION_AGENT}}/$implementation_agent/g" .claude/commands/*.md
        sed -i.bak "s/{{DESIGN_AGENT}}/$design_agent/g" .claude/commands/*.md
        sed -i.bak "s/{{DEPLOYMENT_AGENT}}/$deployment_agent/g" .claude/commands/*.md
        
        # Remove backup files
        rm -f .claude/commands/*.bak
    fi
fi

# Copy and setup agents based on project type
echo "🤖 Setting up agents..."

if [ "$PROJECT_TYPE" = "custom" ]; then
    echo "📝 Custom setup - you'll need to manually select agents from $TEMPLATE_DIR/agents/"
    echo "Available agents:"
    ls "$TEMPLATE_DIR/agents/" | grep "\.md$" | sed 's/.md$//' | sed 's/^/  - /'
    echo ""
    echo "Copy the agents you need:"
    echo "  cp $TEMPLATE_DIR/agents/AGENT_NAME.md .claude/agents/"
else
    # Copy agents based on project template
    case $PROJECT_TYPE in
        "web-frontend")
            agents=("main-agent-project-manager" "frontend-engineer" "ui-ux-designer" "code-reviewer" "testing-specialist" "deployment-engineer")
            ;;
        "mobile-app") 
            agents=("main-agent-project-manager" "mobile-engineer" "ui-ux-designer" "code-reviewer" "testing-specialist" "deployment-engineer")
            ;;
        "ai-ml")
            agents=("main-agent-project-manager" "ai-engineer" "data-engineer" "code-reviewer" "testing-specialist" "deployment-engineer")
            ;;
        "backend-api")
            agents=("main-agent-project-manager" "backend-engineer" "code-reviewer" "testing-specialist" "deployment-engineer")
            ;;
    esac
    
    for agent in "${agents[@]}"; do
        if [ -f "$TEMPLATE_DIR/agents/$agent.md" ]; then
            cp "$TEMPLATE_DIR/agents/$agent.md" ".claude/agents/"
            echo "  ✓ Added $agent"
        else
            echo "  ⚠️  Warning: $agent template not found"
        fi
    done
    
    # Copy workflow protocols
    cp "$TEMPLATE_DIR/agents/team-workflow-protocols.md" ".claude/agents/"
fi

# Create CLAUDE.md from template
echo "📄 Creating CLAUDE.md..."
cp "$TEMPLATE_DIR/CLAUDE.md" "./CLAUDE.md"

# Replace variables in CLAUDE.md
current_date=$(date +%Y-%m-%d)
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" CLAUDE.md
sed -i.bak "s/{{PROJECT_TYPE}}/$TYPE_NAME/g" CLAUDE.md  
sed -i.bak "s/{{TECH_STACK}}/$tech_stack/g" CLAUDE.md
sed -i.bak "s/{{PROJECT_DESCRIPTION}}/$project_description/g" CLAUDE.md
sed -i.bak "s/{{CURRENT_DATE}}/$current_date/g" CLAUDE.md
sed -i.bak "s/{{SESSION_NUMBER}}/1/g" CLAUDE.md
sed -i.bak "s/{{COMPLETION_PERCENTAGE}}/5/g" CLAUDE.md
sed -i.bak "s/{{COMPLETED_STAGES}}/0/g" CLAUDE.md
sed -i.bak "s/{{TOTAL_STAGES}}/6/g" CLAUDE.md

# Remove backup file
rm -f CLAUDE.md.bak

# Create initial session entry
cat >> CLAUDE.md << EOF

### Session 1 Achievements ($current_date)

✅ **System Initialization**: Set up Claude session management system with $TYPE_NAME configuration
✅ **Agent Configuration**: Configured specialist agents for project coordination
✅ **Documentation Framework**: Established rolling window documentation system

#### Session 1 Technical Framework:

- **Project Type**: $TYPE_NAME
- **Technology Stack**: $tech_stack
- **Session Management**: Rolling window system with automated archiving

#### Session 1 Lessons Learned:

✅ **Template Selection**: Successfully applied $TYPE_NAME project template
✅ **Agent Coordination**: Specialist agents configured and ready for delegation
✅ **Documentation System**: Rolling window architecture prevents document bloat while preserving history
EOF

echo ""
echo -e "${GREEN}✅ Claude session management system initialized successfully!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Review and customize .claude/agents/ files for your specific needs"
echo "2. Update CLAUDE.md with your current project status and priorities"
echo "3. Try the session commands:"
echo -e "   ${YELLOW}/ready${NC}  - Initialize session with full context scan"
echo -e "   ${YELLOW}/recap${NC}  - Document session progress and manage rolling window"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "- Setup Guide: $TEMPLATE_DIR/setup-guide.md"
echo "- System Overview: .claude/system/ files"
echo "- Available Agents: .claude/agents/ directory"
echo ""
echo -e "${GREEN}Happy coding with Claude! 🚀${NC}"