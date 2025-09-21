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

Claude, please perform the following version check first:

📋 **CC-TEMPLATES RESOURCE VERSION CHECK**

1. **Check Global Resources**: Use Read tool to check if ~/.claude/.version exists
   - If missing: Show error that cc-templates resources not installed in ~/.claude
   - If exists: Read version from ~/.claude/.version

2. **Check Project Resources**: Use Read tool to check if project .claude/.version exists
   - If missing: Treat as v0.0.0 (needs update)
   - If exists: Read version from project .claude/.version

3. **Version Comparison**: Compare ~/.claude version vs project version
   - If ~/.claude version > project version: Show update prompt and WAIT for user response
   - If versions equal: Continue with session initialization
   - If ~/.claude missing: Show installation instructions

**IMPORTANT**: If an update is available, show this prompt and STOP to wait for user input:

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

**Do NOT proceed with session initialization until user responds to the update prompt.**

**Error Handling:**
- If ~/.claude/.version missing: "❌ Error: cc-templates resources not found in ~/.claude. Please run update-claude-global.sh in cc-templates project."
- Always show current version info when available

Only perform version checking - wait for user input if update is available.

**After user responds:**
- If user says "yes" or "y": Update resources and then run session initialization
- If user says "no" or "n": Skip update and run session initialization
- User can also use /ready command for manual initialization

**Complete Session Initialization (when ready to proceed):**

4. **Execute /ready functionality**: If .claude/commands/ready.md exists
   - Use Glob tool to scan actual .claude/agents/* directory
   - Use Read tool to load actual CLAUDE.md project status
   - Use Bash tool to check actual git status and current branch
   - Use Glob tool to scan actual .claude/system/* files

5. **Present real project context**:
   - Show actual agent specialists found with their roles
   - Display current project status from CLAUDE.md (stage, completion %, priorities)
   - Report actual git repository state (branch, working tree status)
   - List actual system files available (workflow-principles, session-management)
   - Acknowledge role as main project manager agent

6. **Project Context Summary**:
   ```
   📋 SESSION INITIALIZATION COMPLETE

   ✅ Project Resources Status:
   - Current project version: [VERSION]
   - Available resources version: [CLAUDE_VERSION]
   - Project agents and system files validated

   🎯 Project Context:
   - Project: [PROJECT_NAME]
   - Status: [COMPLETION]% Complete ([STAGES] stages done)
   - Active Stage: [CURRENT_STAGE]
   - Next Priority: [NEXT_PRIORITY]
   - Git Branch: [BRANCH] ([STATUS])

   🤖 Available Specialists:
   [List of actual agents found]

   📋 System Framework:
   [List of actual system files found]

   🚀 Ready for [NEXT_STAGE]:
   [Next priorities from CLAUDE.md]

   I'm ready as your main project manager agent. What would you like to work on today?
   ```

**Update Actions (if user confirms update):**
- **Clean existing directories**: Remove old .claude/agents/, .claude/commands/, .claude/system/ to avoid conflicts
- **Copy fresh resources**: Copy ~/.claude/agents/ → project .claude/agents/
- **Copy commands**: Copy ~/.claude/commands/ → project .claude/commands/
- **Copy system files**: Copy ~/.claude/system/ → project .claude/system/
- **Update version**: Update project .claude/.version with new version
- **Show update summary**: List what was removed and what was added

**Cleanup Commands:**
```bash
# Remove old directories completely
rm -rf .claude/agents/
rm -rf .claude/commands/
rm -rf .claude/system/

# Copy fresh resources from global
cp -r ~/.claude/agents/ .claude/
cp -r ~/.claude/commands/ .claude/
cp -r ~/.claude/system/ .claude/
cp ~/.claude/.version .claude/.version
```

This ensures no old files like 'fullstack-engineer.md' remain when updating to new agent structure."""

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