#!/usr/bin/env python3
import json
import sys
import os

# Function to detect if we're in cc-templates project
def is_cc_templates_project():
    # Multiple verification methods
    cwd = os.getcwd()

    # Check 1: Directory name contains "cc-templates"
    if "cc-templates" in os.path.basename(cwd).lower():
        return True

    # Check 2: Presence of templates/ folder
    if os.path.exists("templates") and os.path.isdir("templates"):
        return True

    # Check 3: Check README.md contains "cc-templates"
    if os.path.exists("README.md"):
        try:
            with open("README.md", "r") as f:
                if "cc-templates" in f.read().lower():
                    return True
        except:
            pass

    # Check 4: Presence of scripts/sync-to-global.sh or update-claude-global.sh
    if (os.path.exists("scripts/sync-to-global.sh") or
        os.path.exists("scripts/update-claude-global.sh")):
        return True

    return False

# CC-Templates development mode message
cc_templates_message = """🚀 **CC-TEMPLATES DEVELOPMENT MODE DETECTED**

You're currently in the cc-templates project directory. This project manages the template resources and coordination system for Claude Code users.

**Project Status:**
- ✅ Template resources are maintained in `templates/` directory
- ✅ Version management system active (see `.version` file)
- ✅ Pre-commit hook configured for automatic version increments

**Available Resources:**
- 📁 `templates/agents/` - 5 core agent specialists
- 📁 `templates/commands/` - 3 commands (ready, recap, setup-agents)
- 📁 `templates/system/` - 2 system files (workflow-principles, session-management)
- 📁 `templates/hooks/` - Session start hook for other projects
- 📄 `templates/CLAUDE.md` - Project template for other projects

**Development Workflow:**
1. Make changes to template resources
2. Commit changes (version auto-increments via pre-commit hook)
3. Run `./scripts/sync-to-global.sh` to update global ~/.claude resources
4. Other projects will detect new version and offer to update

**Current Focus:** Template management and version control system. Normal project setup skipped for cc-templates development mode.

Ready for cc-templates development and maintenance tasks."""

# Normal project session initialization message with version checking
session_start_message = """🚀 **SESSION START PROCEDURES**

Claude, please perform the following project validation and session initialization with version checking:

📋 **CC-TEMPLATES RESOURCE VERSION CHECK**

1. **Check Global Resources**: Use Read tool to check if ~/.claude/.version exists
   - If missing: Show error that cc-templates resources not installed in ~/.claude
   - If exists: Read version from ~/.claude/.version

2. **Check Project Resources**: Use Read tool to check if project .claude/.version exists
   - If missing: Treat as v0.0.0 (needs update)
   - If exists: Read version from project .claude/.version

3. **Version Comparison**: Compare ~/.claude version vs project version
   - If ~/.claude version > project version: Ask user for confirmation to update
   - If versions equal: Proceed with normal setup
   - If ~/.claude missing: Show installation instructions

**Version Update Confirmation (if needed):**
```
🔄 **CC-TEMPLATES UPDATE AVAILABLE**

Current project version: [PROJECT_VERSION]
Available version: [CLAUDE_VERSION]

cc-templates resources can be updated with latest:
- agents/ (5 core specialists)
- commands/ (ready, recap, setup-agents)
- system/ (workflow-principles, session-management)

Would you like to update to the latest version? (y/N):
```

**Update Actions (if user confirms):**
- Copy ~/.claude/agents/ → project .claude/agents/
- Copy ~/.claude/commands/ → project .claude/commands/
- Copy ~/.claude/system/ → project .claude/system/
- Update project .claude/.version with new version
- Show update summary

**Session Initialization (after version handling):**
4. **Execute /ready functionality**: If .claude/commands/ready.md exists
   - Use Glob tool to scan actual .claude/agents/* directory
   - Use Read tool to load actual CLAUDE.md project status
   - Use Bash tool to check actual git status and current branch
   - Use Read tool to scan actual .claude/system/ files

5. **Present real project context**:
   - Show actual agent specialists found
   - Display current project status from CLAUDE.md
   - Report actual git repository state
   - List actual system files available
   - Acknowledge role as main project manager agent

**Error Handling:**
- If ~/.claude/.version missing: "❌ Error: cc-templates resources not found in ~/.claude. Please run sync-to-global.sh in cc-templates project."
- If update fails: "❌ Update failed. Please check permissions and try again."
- Always show current version info when available

Perform these steps automatically with version-aware resource management."""

# Determine which message to use based on project detection
if is_cc_templates_project():
    output_message = cc_templates_message
else:
    output_message = session_start_message

# Output the required JSON format for SessionStart hook
output = {
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": output_message
    }
}

print(json.dumps(output, indent=2))
sys.exit(0)