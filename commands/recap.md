---
name: recap
description: Generate session summary and update project progress documentation
---

# /recap - Session Summary & Progress Update

🔄 **Session Documentation & Progress Update**

**Automated session recap and CLAUDE.md update** - Analyzing current session progress and updating project documentation...

## Process Overview - Rolling Window + Archive System

**Step 1: Session Analysis**
- Reading current CLAUDE.md to detect session number and structure
- Identifying today's date for proper session documentation
- Parsing existing sessions to identify which need archival

**Step 2: Content Generation**  
- Creating new session section with full detail (achievements + frameworks + lessons)
- Generating summary based on session work completed

**Step 3: Archive Management**
- Moving sessions 3+ positions old to `.claude/sessions/session-history.md`
- Converting previous session from full detail to compact format
- Maintaining last 2 completed sessions in CLAUDE.md for context

**Step 4: Status Updates**
- Updating Current Session Status section
- Incrementing session number and date
- Adjusting project completion percentage if significant progress made
- Refreshing priorities and recent changes

**Step 5: File Operations**
- Creating `.claude/sessions/` directory if needed
- Creating/updating `session-history.md` with archived sessions
- Updating CLAUDE.md with new session and cleaned structure

**Step 6: Preview & Confirmation**
- Showing what will be added to CLAUDE.md (new session + compact format)
- Showing what will be archived to session-history.md
- Confirming changes before applying

**Step 7: Apply Updates**
- Executing all file operations to implement rolling window system
- Preserving all content while optimizing CLAUDE.md for current context

## Implementation Details

**Session Detection**: Automatically identifies next session number from "Last Updated" field in Current Session Status

**Rolling Window Logic**:
- **CLAUDE.md keeps**: Current session (full detail) + Last 2 sessions (compact format)
- **Archive receives**: Sessions 3+ positions old (full detail preserved)
- **Auto-conversion**: Previous full-detail session becomes compact format

**Content Patterns**:

*Full Detail Format (current session):*
```markdown
### Session X Achievements (YYYY-MM-DD)

✅ **Achievement Name**: Detailed description of work completed
✅ **Technical Implementation**: Specific technical work done
✅ **{{PROJECT_TYPE}} Enhancement**: Project-specific improvements

#### Session X Technical Framework: (when relevant)
- **Component/System**: Technical specifications or setup details
- **{{TECH_STACK}} Configuration**: Technology-specific settings

#### Session X Lessons Learned:
✅ **Effective Pattern**: What worked well in coordination/implementation
✅ **{{PROJECT_TYPE}} Insight**: Project-specific lessons learned
⚠️ **Challenge Resolved**: Any issues encountered and solutions applied
```

*Compact Format (last 2 sessions):*
```markdown
### Session X Achievements (YYYY-MM-DD)

✅ **Achievement Name**: Brief description of work completed
✅ **Technical Implementation**: Core technical work summary
✅ **Process Improvement**: Key workflow enhancements
```

**Archive Structure**: `.claude/sessions/session-history.md` maintains chronological full-detail records

**File Management**: 
- Creates session directory automatically if needed
- Preserves all historical content in archive
- Maintains CLAUDE.md as focused, current-context document (~150-180 lines)

## Rolling Window Benefits

**CLAUDE.md Optimization**:
- Stays focused on current context (~150-180 lines vs 300+ lines)
- Last 2 sessions provide immediate historical context
- Current session gets full detail for ongoing work

**Complete History Preservation**:
- Full session details archived in `.claude/sessions/session-history.md`
- Nothing is lost - just better organized
- Easy to reference past work when needed

**Automatic Management**:
- No manual archiving required
- Consistent formatting maintained
- Session transitions handled seamlessly

## Project-Specific Adaptations

**For {{PROJECT_TYPE}} Projects**:
- Achievement categories adapted to {{PROJECT_DOMAIN}} work
- Technical frameworks section includes {{TECH_STACK}} specifics
- Lessons learned focus on {{PROJECT_TYPE}} development patterns

**Quality Assurance for {{PROJECT_TYPE}}**:
- Session summaries include {{PROJECT_TYPE}} specific metrics
- Technical details relevant to {{TECH_STACK}} implementation
- Next priorities aligned with {{PROJECT_TYPE}} development lifecycle

---

**Usage:** Run `/recap` at end of session to automatically:
- Document current session progress with full detail
- Convert previous session to compact format in CLAUDE.md  
- Archive old sessions (3+ back) to preserve complete history
- Keep CLAUDE.md focused on immediate context for next session

The rolling window system maintains both immediate relevance and complete historical records without manual maintenance, adapted for {{PROJECT_TYPE}} development workflows.