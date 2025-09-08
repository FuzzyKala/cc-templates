# Session Management

## Overview

This document provides templates and protocols for effective session management, ensuring smooth handoffs between sessions and consistent project coordination across time.

## Session Start Protocol

### New Session Initialization
**Every New Session Should Begin With**:

1. **Role Acknowledgment**: "I am serving as the main project manager agent"
2. **Context Review**: Read current CLAUDE.md for project status and priorities
3. **System Reference**: Review relevant system documentation in `.claude/system/`
4. **Status Assessment**: Understand current stage, blockers, and next priorities
5. **Delegation Planning**: Identify likely agent coordination needs for the session

### Quick Start Checklist
- [ ] **Read CLAUDE.md** for current project status and immediate priorities
- [ ] **Check `.claude/agents/main-agent-project-manager.md`** for coordination protocols
- [ ] **Review recent session achievements** to understand project momentum
- [ ] **Identify current stage needs** (development, review, deployment, etc.)
- [ ] **Note any blockers or constraints** that might affect agent delegation

### Session Context Template
```markdown
## Session [Date] Context

### Project Status
- **Current Stage**: [Development/Review/Deployment/Optimization]
- **Immediate Priorities**: [Top 2-3 tasks for this session]
- **Recent Progress**: [Key achievements from last session]
- **Known Blockers**: [Any issues that need attention]

### Likely Agent Needs
- **Primary Specialists**: [Which agents likely needed based on priorities]
- **Quality Gates**: [Any review or validation work expected]
- **Integration Points**: [How work will connect with existing project]

### Success Criteria for Session
- [ ] [Specific outcome 1]
- [ ] [Specific outcome 2]
- [ ] [Specific outcome 3]
```

## Session End Protocol

### Session-Ending Triggers
**User Phrases That Signal Session End**:
- "I'm gonna end this session"
- "ending this session tonight"  
- "that's it for today"
- "let's wrap up"
- "I'll continue next time"

**Immediate Response Required**: Proactively begin session wrap-up process

### Session Wrap-Up
**Before Ending Each Session**:

1. **Update Project Status**: Modify CLAUDE.md with progress made
2. **Document Achievements**: Record what was accomplished  
3. **Capture Lessons**: Note what worked well and what didn't
4. **Identify Next Steps**: Clear priorities for next session
5. **Update System Knowledge**: Add any insights to system documentation

### Session End Checklist
- [ ] CLAUDE.md updated with current session achievements
- [ ] Agent delegation patterns documented (used/not used and why)
- [ ] Any blockers or issues noted for next session  
- [ ] Project status percentage updated based on completion
- [ ] Next session priorities clearly identified
- [ ] Workflow violations acknowledged and addressed

### Session Summary Template
```markdown
## Session [Date] Summary

### Achievements
- **Completed Tasks**: [What was finished]
- **Agent Coordination**: [Which agents used effectively]
- **Quality Outcomes**: [Standards met, reviews completed]
- **Integration Success**: [How work connected with project]

### Lessons Learned
- **Effective Patterns**: [Delegation/coordination that worked well]
- **Challenges Overcome**: [Problems solved and how]
- **Improvements Identified**: [Better approaches discovered]
- **Agent Performance**: [How specialists performed]

### Handoff for Next Session
- **Immediate Priorities**: [Top tasks for next session]
- **Context for Continuation**: [Important background for next work]
- **Potential Blockers**: [Issues that might arise]
- **Recommended Approach**: [Suggested next steps and agent needs]

### System Updates Made
- [ ] CLAUDE.md updated with current status
- [ ] Agent definitions modified (if any)
- [ ] Workflow protocols updated (if any)
- [ ] Lessons documented in continuous-learning.md
```

## `/recap` Command Process

### Overview
The `/recap` command automates session documentation and CLAUDE.md updates, ensuring consistent progress tracking and seamless next-session handoffs.

### Command Execution Steps

When user types `/recap`, follow these steps systematically:

**Step 1: Session Analysis**
- **Read current CLAUDE.md** to understand structure and session history
- **Detect current session number** from "Last Updated" field and session numbering pattern
- **Identify today's date** for proper session dating
- **Parse existing formatting** to maintain consistency (✅ checkmarks, section headers, indentation)

**Step 2: Progress Collection**
- **Prompt user for accomplishments**: "What were the key achievements in today's session?"
- **Gather technical details**: Ask for specific implementations, bug fixes, optimizations completed
- **Identify lessons learned**: What coordination worked well? What could improve?
- **Note any blockers resolved** or new issues discovered during the session
- **Check TodoWrite completed items** if applicable for additional context

**Step 3: Content Generation** 
- **Create new session section** following established pattern:
  ```markdown
  ### Session X Achievements (YYYY-MM-DD)
  
  ✅ **Achievement Name**: Detailed description of what was accomplished
  ✅ **Technical Implementation**: Specific technical work completed
  ✅ **Process Improvement**: Workflow or coordination enhancements
  
  #### Session X [Technical Framework/Details]: (if relevant)
  - **Component/System**: Technical specifications or framework details
  - **Configuration**: Settings or setup information
  
  #### Session X Lessons Learned:
  ✅ **Effective Pattern**: What worked well in coordination/implementation
  ✅ **Process Insight**: Improvements identified or successful approaches
  ⚠️ **Challenge Resolved**: Any issues encountered and how they were solved
  ```

**Step 4: Status Updates**
- **Update Current Session Status section**:
  - **Last Updated**: Current date (Session X)
  - **Session number**: Increment appropriately  
  - **Project Status**: Adjust completion percentage if significant progress made
  - **Recent Changes**: Update with current session's key achievements summary
  - **Next Priority**: Update based on current stage and next logical steps
  - **Blockers**: Remove resolved blockers, add any new ones discovered
  - **Ready for**: Update based on current completion state

**Step 5: Preview and Confirmation**
- **Show formatted preview** of:
  - New session section to be added
  - Current Session Status updates  
  - Any other modified sections
- **Confirm with user**: "Does this session summary look accurate?"
- **Allow edits** if user wants modifications to achievements or lessons

**Step 6: Apply Updates**
- **Insert new session section** in chronological order with other session achievements
- **Update Current Session Status** with new information
- **Preserve all existing content** - only add new section and update status fields
- **Maintain exact formatting** consistency with existing sessions

### Quality Assurance Checks

**Before Finalizing**:
- [ ] Session number incremented correctly
- [ ] Date format matches existing pattern (YYYY-MM-DD)  
- [ ] Achievement descriptions are clear and specific
- [ ] Lessons learned provide actionable insights
- [ ] Next priorities align with current project stage
- [ ] All existing content preserved and formatting consistent

### Success Indicators

**Command completed successfully when**:
- New session documentation follows established pattern exactly
- Current Session Status accurately reflects today's progress
- Next session has clear context for continuation
- No formatting inconsistencies or content loss
- User confirms session summary is accurate

This systematic approach ensures no progress is lost and maintains consistent documentation quality across all sessions.

## Handoff Management

### Information Continuity
**Essential Information to Maintain**:
- **Project Status**: Current completion state and priorities
- **Technical Context**: Architecture decisions, dependencies, constraints
- **Quality State**: Test coverage, performance metrics, security status
- **Deployment Status**: Production readiness, configuration needs
- **Stakeholder Context**: Requirements, feedback, expectations

### Context Preservation
**Key Documentation Points**:
- **Decision History**: Why certain approaches were chosen
- **Agent Insights**: Which specialists proved effective for different tasks
- **Pattern Recognition**: Successful coordination approaches used
- **Integration Knowledge**: How components connect and depend on each other

### Session-to-Session Consistency
**Maintain Consistency Through**:
- **Role Definition**: Always start as main project manager agent
- **System Reference**: Use established agent coordination protocols
- **Quality Standards**: Apply consistent quality gates and review processes
- **Documentation Patterns**: Follow established templates and formats

## Common Session Scenarios

### Development-Focused Sessions
**Typical Pattern**:
1. **Context Review**: Understand current development state
2. **Requirements Clarification**: Use product-manager if needs unclear
3. **Implementation Coordination**: Delegate to {{IMPLEMENTATION_AGENT}}
4. **Quality Assurance**: Review with code-reviewer or testing-specialist
5. **Integration**: Ensure work connects properly with existing project

**Agent Coordination Focus**:
- {{IMPLEMENTATION_AGENT}} for implementation work
- Code-reviewer for quality validation
- Testing-specialist if test coverage needed
- {{DESIGN_AGENT}} if design decisions required

### Review-Focused Sessions
**Typical Pattern**:
1. **Work Assessment**: Evaluate current implementation state
2. **Quality Review**: Comprehensive code-reviewer analysis
3. **Testing Validation**: Testing-specialist for coverage and scenarios
4. **Performance Check**: {{PERFORMANCE_AGENT}} coordination
5. **Integration Verification**: Ensure all components work together

**Agent Coordination Focus**:
- Code-reviewer for comprehensive analysis
- Testing-specialist for quality assurance
- {{DEPLOYMENT_AGENT}} for production readiness
- Multiple agents for cross-validation

### Deployment-Focused Sessions
**Typical Pattern**:
1. **Readiness Assessment**: Review completion and quality state
2. **Production Preparation**: {{DEPLOYMENT_AGENT}} for optimization
3. **Final Quality Gates**: Code-reviewer + testing-specialist validation
4. **Deployment Execution**: {{DEPLOYMENT_AGENT}} with monitoring
5. **Post-Deployment Validation**: Confirm successful deployment

**Agent Coordination Focus**:
- {{DEPLOYMENT_AGENT}} as primary specialist
- Code-reviewer for pre-deployment validation
- Testing-specialist for quality confirmation
- {{IMPLEMENTATION_AGENT}} for any optimization needs

### Problem-Resolution Sessions
**Typical Pattern**:
1. **Issue Analysis**: Code-reviewer for root cause analysis
2. **Solution Design**: Appropriate specialist based on problem domain
3. **Implementation**: {{IMPLEMENTATION_AGENT}} or relevant specialist
4. **Validation**: Testing-specialist + code-reviewer
5. **Prevention Planning**: Update processes to prevent recurrence

**Agent Coordination Focus**:
- Code-reviewer for analysis and validation
- Domain specialist for solution implementation
- Testing-specialist for regression prevention
- Process improvements based on lessons learned

## Session Effectiveness Metrics

### Productivity Indicators
- **Goal Achievement**: Percentage of session objectives completed
- **Agent Utilization**: Effective use of specialist expertise
- **Quality Maintenance**: Standards upheld throughout session
- **Progress Momentum**: Consistent advancement toward project goals

### Coordination Success Measures
- **Delegation Accuracy**: Right specialists selected for tasks
- **Context Sufficiency**: Minimal additional information requests
- **Integration Success**: Smooth incorporation of agent work
- **Handoff Quality**: Clear continuation for next session

### Continuous Improvement Tracking
- **Pattern Recognition**: Successful approaches identified and repeated
- **Problem Resolution**: Issues resolved efficiently with lasting solutions
- **System Evolution**: Improvements to agent coordination based on experience
- **Knowledge Building**: Accumulated expertise for future sessions

This session management framework ensures consistent, effective coordination across sessions while building institutional knowledge and maintaining project momentum through structured handoffs and systematic improvement.