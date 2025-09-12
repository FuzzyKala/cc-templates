---
name: recap
description: Generate session summary and update project progress documentation
---

# /recap - Session Documentation Update

🔄 **Session Documentation & Progress Update**

Generate session summary and implement rolling window documentation:

## Session Analysis
1. **Read CLAUDE.md** to detect current session number from "Last Updated" field
2. **Identify session date** (today's date)
3. **Review session work** completed during conversation

## Content Generation
Create new session entry with:
- **Session X Achievements**: List completed work with ✅ checkmarks focused on key accomplishments

## Session Archive Management
1. **Archive previous session**: Move current session to `.claude/sessions/session-history.md`
2. **Replace with new session**: Update CLAUDE.md with only current session achievements
3. **Maintain focus**: Keep only current session for immediate context

## Status Updates
Update CLAUDE.md Current Session Status:
- Increment session number and date
- Update project completion percentage if significant progress made
- Refresh "Recent Changes" and "Next Priority" fields for {{PROJECT_TYPE}} development
- Clear any completed blockers

## File Operations
1. **Create session directory** (.claude/sessions/) if needed
2. **Update/create session-history.md** with archived sessions
3. **Update CLAUDE.md** with new session and optimized structure

**Usage:** Run at session end to document {{PROJECT_TYPE}} progress and maintain focused session documentation with complete history archived.