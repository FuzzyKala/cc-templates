#!/bin/bash

# Claude Code Templates - Global Sync Script
# Syncs templates/ directory to ~/.claude with version management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to compare semantic versions
version_compare() {
    local v1=$1
    local v2=$2

    # Remove 'v' prefix and split into parts
    local v1_clean=$(echo "$v1" | sed 's/^v//')
    local v2_clean=$(echo "$v2" | sed 's/^v//')

    # Use simple string comparison for semantic versions
    # Convert to format that sorts correctly: MAJOR.MINOR.PATCH -> MAJORMINORPATCH
    local v1_parts=(${v1_clean//./ })
    local v2_parts=(${v2_clean//./ })

    # Ensure we have at least 3 parts, defaulting missing ones to 0
    local v1_major=${v1_parts[0]:-0}
    local v1_minor=${v1_parts[1]:-0}
    local v1_patch=${v1_parts[2]:-0}

    local v2_major=${v2_parts[0]:-0}
    local v2_minor=${v2_parts[1]:-0}
    local v2_patch=${v2_parts[2]:-0}

    # Compare major.minor.patch
    if [[ $v1_major -gt $v2_major ]]; then
        return 1  # v1 > v2
    elif [[ $v1_major -lt $v2_major ]]; then
        return 2  # v1 < v2
    elif [[ $v1_minor -gt $v2_minor ]]; then
        return 1  # v1 > v2
    elif [[ $v1_minor -lt $v2_minor ]]; then
        return 2  # v1 < v2
    elif [[ $v1_patch -gt $v2_patch ]]; then
        return 1  # v1 > v2
    elif [[ $v1_patch -lt $v2_patch ]]; then
        return 2  # v1 < v2
    else
        return 0  # v1 == v2
    fi
}

# Script directory (should be run from cc-templates root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CC_TEMPLATES_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🚀 Claude Code Templates - Global Sync${NC}"
echo -e "Syncing templates/ to ~/.claude with version management..."
echo ""

# Check if we're in the cc-templates directory
if [[ ! -f "$CC_TEMPLATES_ROOT/README.md" ]] || [[ ! -d "$CC_TEMPLATES_ROOT/templates" ]]; then
    echo -e "${RED}❌ Error: Must be run from cc-templates root directory${NC}"
    echo "Current directory: $(pwd)"
    echo "Expected files: README.md, templates/, .version"
    exit 1
fi

# Check for .version file
if [[ ! -f "$CC_TEMPLATES_ROOT/.version" ]]; then
    echo -e "${RED}❌ Error: .version file not found in cc-templates root${NC}"
    echo "Please ensure .version file exists with current version (e.g., v1.0.0)"
    exit 1
fi

# Get current versions
CC_VERSION=$(cat "$CC_TEMPLATES_ROOT/.version")
CLAUDE_VERSION=$(cat ~/.claude/.version 2>/dev/null || echo "v0.0.0")

echo -e "${BLUE}📊 Version Check${NC}"
echo -e "cc-templates version: ${YELLOW}$CC_VERSION${NC}"
echo -e "~/.claude version:    ${YELLOW}$CLAUDE_VERSION${NC}"

# Simple version comparison - if they're different, update
if [[ "$CC_VERSION" == "$CLAUDE_VERSION" ]]; then
    echo -e "${GREEN}✅ Versions are equal - no update needed${NC}"
    echo -e "Both cc-templates and ~/.claude are at version $CC_VERSION"
    exit 0
else
    echo -e "${GREEN}🔄 Update available: $CLAUDE_VERSION → $CC_VERSION${NC}"
    echo -e "Proceeding with sync..."
fi

echo ""

# Create necessary directories in ~/.claude
echo -e "${YELLOW}📁 Creating ~/.claude directories...${NC}"
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/system
mkdir -p ~/.claude/hooks

# Backup existing files (optional)
if [[ -d ~/.claude/agents ]] && [[ "$(ls -A ~/.claude/agents 2>/dev/null)" ]]; then
    echo -e "${YELLOW}💾 Backing up existing files...${NC}"
    cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
fi

# Copy commands (global slash commands)
echo -e "${YELLOW}📋 Updating global commands...${NC}"
cp "$CC_TEMPLATES_ROOT/templates/commands"/*.md ~/.claude/commands/
echo -e "   ✅ Copied: ready.md, recap.md, setup-agents.md"

# Copy agent templates
echo -e "${YELLOW}🤖 Updating agent templates...${NC}"
cp "$CC_TEMPLATES_ROOT/templates/agents"/*.md ~/.claude/agents/
echo -e "   ✅ Copied: 5 core agent templates"

# Copy system framework files
echo -e "${YELLOW}⚙️  Updating system framework...${NC}"
cp "$CC_TEMPLATES_ROOT/templates/system"/*.md ~/.claude/system/
echo -e "   ✅ Copied: workflow-principles.md, session-management.md"

# Copy hooks
echo -e "${YELLOW}🎣 Updating session hooks...${NC}"
cp "$CC_TEMPLATES_ROOT/templates/hooks"/*.py ~/.claude/hooks/
echo -e "   ✅ Copied: session-start.py"

# Copy template files (CLAUDE.md template, etc.) to templates/ subdirectory
echo -e "${YELLOW}📄 Updating template files...${NC}"
mkdir -p ~/.claude/templates
cp "$CC_TEMPLATES_ROOT/templates/CLAUDE.md" ~/.claude/templates/
echo -e "   ✅ Copied: CLAUDE.md template"

# Update version file
echo -e "${YELLOW}🔢 Updating version...${NC}"
echo "$CC_VERSION" > ~/.claude/.version
echo -e "   ✅ Updated ~/.claude/.version to $CC_VERSION"

# Verify installation
echo -e "${YELLOW}Verifying installation...${NC}"

# Check commands
COMMANDS_COUNT=$(ls ~/.claude/commands/*.md 2>/dev/null | wc -l)
echo -e "  📋 Commands: $COMMANDS_COUNT files"

# Check agents
AGENTS_COUNT=$(ls ~/.claude/agents/*.md 2>/dev/null | wc -l)
echo -e "  🤖 Agent templates: $AGENTS_COUNT files"

# Check system files
SYSTEM_COUNT=$(ls ~/.claude/system/*.md 2>/dev/null | wc -l)
echo -e "  ⚙️  System files: $SYSTEM_COUNT files"

# Check hooks
HOOKS_COUNT=$(ls ~/.claude/hooks/*.py 2>/dev/null | wc -l)
echo -e "  🎣 Hook files: $HOOKS_COUNT files"

# Check templates
TEMPLATES_COUNT=$(ls ~/.claude/templates/*.md 2>/dev/null | wc -l)
echo -e "  📄 Template files: $TEMPLATES_COUNT files"

echo ""
echo -e "${GREEN}🎉 Global update complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Start Claude Code in any project directory"
echo -e "2. Run ${YELLOW}/setup-agents${NC} to configure project-specific agents"
echo -e "3. Use ${YELLOW}/ready${NC} and ${YELLOW}/recap${NC} for session management"
echo ""
echo -e "${BLUE}Available global commands:${NC}"
echo -e "• ${YELLOW}/setup-agents${NC} - Configure project agents (auto-detects project type)"
echo -e "• ${YELLOW}/ready${NC} - Initialize session with project context"  
echo -e "• ${YELLOW}/recap${NC} - Document session progress and achievements"
echo ""
echo -e "${GREEN}✨ cc-templates $CC_VERSION ready for use!${NC}"