#!/bin/bash

# Project Detection Logic for cc-template Agent Setup
# Analyzes current project to determine optimal agent configuration

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m' 
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Default values
PROJECT_TYPE=""
TECH_STACK=""
DETECTED_PATTERNS=()
CONFIDENCE_LEVEL=""

# Detection functions
detect_nextjs() {
    if [ -f "package.json" ]; then
        if grep -q '"next"' package.json; then
            PROJECT_TYPE="web-frontend"
            TECH_STACK="Next.js, React, TypeScript"
            DETECTED_PATTERNS+=("Next.js framework")
            CONFIDENCE_LEVEL="high"
            return 0
        fi
    fi
    return 1
}

detect_react() {
    if [ -f "package.json" ]; then
        if grep -q '"react"' package.json && ! grep -q '"next"' package.json; then
            PROJECT_TYPE="web-frontend"  
            TECH_STACK="React, JavaScript/TypeScript"
            DETECTED_PATTERNS+=("React library")
            CONFIDENCE_LEVEL="high"
            return 0
        fi
    fi
    return 1
}

detect_nodejs_api() {
    if [ -f "package.json" ]; then
        if grep -q -E '"(express|fastify|koa)"' package.json; then
            # Check if it's fullstack or backend-only
            if grep -q -E '"(react|next)"' package.json; then
                PROJECT_TYPE="fullstack"
                TECH_STACK="Node.js, Express/Fastify, React/Next.js"
                DETECTED_PATTERNS+=("Fullstack Node.js + React")
                CONFIDENCE_LEVEL="high"
            else
                PROJECT_TYPE="backend-api"
                TECH_STACK="Node.js, Express/Fastify"
                DETECTED_PATTERNS+=("Node.js API framework")
                CONFIDENCE_LEVEL="high"
            fi
            return 0
        fi
    fi
    return 1
}

detect_react_native() {
    if [ -f "package.json" ]; then
        if grep -q '"react-native"' package.json; then
            PROJECT_TYPE="mobile-app"
            TECH_STACK="React Native, JavaScript/TypeScript" 
            DETECTED_PATTERNS+=("React Native framework")
            CONFIDENCE_LEVEL="high"
            return 0
        fi
    fi
    return 1
}

detect_flutter() {
    if [ -f "pubspec.yaml" ]; then
        PROJECT_TYPE="mobile-app"
        TECH_STACK="Flutter, Dart"
        DETECTED_PATTERNS+=("Flutter framework")
        CONFIDENCE_LEVEL="high"
        return 0
    fi
    return 1
}

detect_python_ml() {
    if [ -f "requirements.txt" ]; then
        if grep -q -E "(tensorflow|pytorch|scikit-learn|numpy|pandas)" requirements.txt; then
            PROJECT_TYPE="ai-ml"
            TECH_STACK="Python, TensorFlow/PyTorch"
            DETECTED_PATTERNS+=("Python ML libraries")
            CONFIDENCE_LEVEL="medium"
            return 0
        fi
    fi
    return 1
}

detect_python_api() {
    if [ -f "requirements.txt" ]; then
        if grep -q -E "(fastapi|django|flask)" requirements.txt; then
            PROJECT_TYPE="backend-api"
            TECH_STACK="Python, FastAPI/Django/Flask"
            DETECTED_PATTERNS+=("Python web framework")
            CONFIDENCE_LEVEL="high"
            return 0
        fi
    fi
    return 1
}

# Additional pattern detection
detect_additional_patterns() {
    local patterns=()
    
    # TypeScript detection
    if [ -f "tsconfig.json" ] || grep -q '"typescript"' package.json 2>/dev/null; then
        patterns+=("TypeScript")
    fi
    
    # Testing frameworks
    if grep -q -E '"(jest|vitest|cypress|playwright)"' package.json 2>/dev/null; then
        patterns+=("Testing framework")
    fi
    
    # CSS frameworks  
    if grep -q -E '"(tailwindcss|styled-components|emotion)"' package.json 2>/dev/null; then
        patterns+=("CSS framework")
    fi
    
    # Database indicators
    if grep -q -E '"(mongodb|mongoose|postgresql|mysql)"' package.json 2>/dev/null; then
        patterns+=("Database integration")
    fi
    
    # Add to detected patterns if any found
    if [ ${#patterns[@]} -gt 0 ]; then
        DETECTED_PATTERNS+=("${patterns[@]}")
    fi
}

# Get agent recommendations based on project type
get_recommended_agents() {
    # All project types use the same 5 core agents - they adapt based on project context
    echo "main-agent-project-manager implementation-specialist design-specialist quality-specialist deployment-specialist"
}

# Get project template JSON file
get_template_file() {
    case $PROJECT_TYPE in
        "web-frontend")
            echo "web-frontend.json"
            ;;
        "backend-api")
            echo "backend-api.json"
            ;;
        "fullstack")
            echo "web-frontend.json"  # Use web-frontend as base, enhance with backend
            ;;
        "mobile-app")  
            echo "mobile-app.json"
            ;;
        "ai-ml")
            echo "ai-ml.json"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Main detection function
detect_project_type() {
    echo -e "${BLUE}🔍 Analyzing project structure...${NC}"
    
    # Run detection functions in priority order
    if detect_nextjs; then
        echo -e "${GREEN}✅ Next.js project detected${NC}"
    elif detect_react; then
        echo -e "${GREEN}✅ React project detected${NC}"
    elif detect_nodejs_api; then
        echo -e "${GREEN}✅ Node.js API project detected${NC}"
    elif detect_react_native; then
        echo -e "${GREEN}✅ React Native project detected${NC}"
    elif detect_flutter; then
        echo -e "${GREEN}✅ Flutter project detected${NC}"
    elif detect_python_ml; then
        echo -e "${GREEN}✅ Python ML project detected${NC}"
    elif detect_python_api; then
        echo -e "${GREEN}✅ Python API project detected${NC}"
    else
        echo -e "${YELLOW}❓ Unable to auto-detect project type${NC}"
        PROJECT_TYPE="unknown"
        TECH_STACK="Unknown"
        CONFIDENCE_LEVEL="none"
    fi
    
    # Detect additional patterns
    detect_additional_patterns
    
    return 0
}

# Output detection results
output_results() {
    local format=${1:-"human"}
    
    if [ "$format" = "json" ]; then
        # JSON output for programmatic use
        cat << EOF
{
  "project_type": "$PROJECT_TYPE",
  "tech_stack": "$TECH_STACK",
  "confidence": "$CONFIDENCE_LEVEL",
  "detected_patterns": [$(printf '"%s",' "${DETECTED_PATTERNS[@]}" | sed 's/,$//')],
  "recommended_agents": [$(printf '"%s",' $(get_recommended_agents) | sed 's/,$//')],
  "template_file": "$(get_template_file)"
}
EOF
    else
        # Human-readable output
        echo ""
        echo -e "${BLUE}📊 Detection Results:${NC}"
        echo -e "Project Type: ${GREEN}$PROJECT_TYPE${NC}"
        echo -e "Tech Stack: ${GREEN}$TECH_STACK${NC}"  
        echo -e "Confidence: ${GREEN}$CONFIDENCE_LEVEL${NC}"
        
        if [ ${#DETECTED_PATTERNS[@]} -gt 0 ]; then
            echo -e "Patterns Found: ${YELLOW}${DETECTED_PATTERNS[*]}${NC}"
        fi
        
        echo ""
        echo -e "${BLUE}🤖 Recommended Agents:${NC}"
        for agent in $(get_recommended_agents); do
            echo -e "  - ${GREEN}$agent${NC}"
        done
        
        local template=$(get_template_file)
        if [ -n "$template" ]; then
            echo ""
            echo -e "${BLUE}📋 Template: ${GREEN}$template${NC}"
        fi
    fi
}

# Interactive mode for manual selection
interactive_selection() {
    echo -e "${BLUE}🔧 Interactive Project Type Selection${NC}"
    echo ""
    echo "Available project types:"
    echo "1. Web Frontend (React/Next.js, Vue, etc.)"
    echo "2. Backend API (Node.js, Python, Java, etc.)"
    echo "3. Mobile App (React Native, Flutter, etc.)"  
    echo "4. AI/ML Project (Python, TensorFlow, PyTorch, etc.)"
    echo "5. Fullstack (Frontend + Backend)"
    echo "6. Custom (manual agent selection)"
    echo ""
    
    while true; do
        read -p "Select project type (1-6): " choice
        case $choice in
            1)
                PROJECT_TYPE="web-frontend"
                TECH_STACK="Web Frontend Framework"
                CONFIDENCE_LEVEL="user-selected"
                DETECTED_PATTERNS+=("User selected: Web Frontend")
                break
                ;;
            2)
                PROJECT_TYPE="backend-api"
                TECH_STACK="Backend API Framework"
                CONFIDENCE_LEVEL="user-selected" 
                DETECTED_PATTERNS+=("User selected: Backend API")
                break
                ;;
            3)
                PROJECT_TYPE="mobile-app"
                TECH_STACK="Mobile Development Framework"
                CONFIDENCE_LEVEL="user-selected"
                DETECTED_PATTERNS+=("User selected: Mobile App")
                break
                ;;
            4)
                PROJECT_TYPE="ai-ml"
                TECH_STACK="AI/ML Framework"
                CONFIDENCE_LEVEL="user-selected"
                DETECTED_PATTERNS+=("User selected: AI/ML")
                break
                ;;
            5)
                PROJECT_TYPE="fullstack"
                TECH_STACK="Fullstack Framework"
                CONFIDENCE_LEVEL="user-selected"
                DETECTED_PATTERNS+=("User selected: Fullstack")
                break
                ;;
            6)
                PROJECT_TYPE="custom"
                TECH_STACK="Custom Configuration"
                CONFIDENCE_LEVEL="user-selected"
                DETECTED_PATTERNS+=("User selected: Custom")
                break
                ;;
            *)
                echo "Please select a valid option (1-6)."
                ;;
        esac
    done
}

# Main execution
main() {
    local mode=${1:-"detect"}
    local output_format=${2:-"human"}
    
    case $mode in
        "detect")
            detect_project_type
            output_results "$output_format"
            ;;
        "interactive")
            interactive_selection
            output_results "$output_format"
            ;;
        "validate")
            if [ -d ".claude" ]; then
                echo -e "${GREEN}✅ Agent setup detected${NC}"
                if [ -f ".claude/agents/main-agent-project-manager.md" ]; then
                    echo -e "${GREEN}✅ Main project manager configured${NC}"
                else
                    echo -e "${RED}❌ Main project manager missing${NC}"
                fi
            else
                echo -e "${YELLOW}❓ No agent setup found${NC}"
            fi
            ;;
        *)
            echo "Usage: $0 [detect|interactive|validate] [human|json]"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi