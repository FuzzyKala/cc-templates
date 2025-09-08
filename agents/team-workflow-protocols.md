# Team Workflow Protocols

## Main Agent as Project Manager

The main Claude agent coordinates and delegates tasks to specialized agents. This document defines simple, effective workflow protocols for agent coordination without over-engineering.

## Agent Specializations

- **{{IMPLEMENTATION_AGENT}}**: {{IMPLEMENTATION_DESCRIPTION}}
- **{{DESIGN_AGENT}}**: {{DESIGN_DESCRIPTION}}
- **Product Manager**: Requirements analysis, PRDs, stakeholder communication
- **Code Reviewer**: Security, quality, performance, and accessibility analysis
- **Testing Specialist**: Test strategy, automation, quality assurance
- **{{DEPLOYMENT_AGENT}}**: {{DEPLOYMENT_DESCRIPTION}}

## Delegation Philosophy

### When to Delegate vs. Handle Directly

**Delegate to Specialized Agents When:**
- Task matches agent's core expertise and requires specialized knowledge
- Need comprehensive deliverables with domain-specific best practices
- Complex work that benefits from focused specialist attention
- Quality gates require specialist review (security, performance, accessibility)

**Handle Directly When:**
- Simple file operations (read, edit, basic commands)
- Quick coordination between agents
- Immediate user responses that don't require specialized analysis
- Context gathering and project status updates

### Context-Driven Delegation

Instead of rigid workflows, delegate based on **current project context**:

**For {{PROJECT_TYPE}} Development:**
- **Implementation Tasks** → {{IMPLEMENTATION_AGENT}}
- **Design Decisions** → {{DESIGN_AGENT}}
- **Quality Assurance** → Code Reviewer + Testing Specialist
- **Deployment** → {{DEPLOYMENT_AGENT}} (+ Code Reviewer for review)

**For Feature Development:**
- **Requirements** → Product Manager → {{DESIGN_AGENT}} → {{IMPLEMENTATION_AGENT}}
- **Bug Fixes** → Code Reviewer (analysis) → {{IMPLEMENTATION_AGENT}} (fix)
- **Performance Issues** → {{IMPLEMENTATION_AGENT}} + {{DEPLOYMENT_AGENT}}

## Coordination Patterns

### Adaptive Workflows

**Single Agent Tasks:**
```
Main Agent → Specialist Agent → Integration
```
Most tasks need only one specialist with proper context.

**Sequential Coordination:**
```
Main Agent → Agent A → Agent B → Integration
```
When Agent B needs Agent A's output (e.g., Design → Implementation).

**Parallel Coordination:**
```
Main Agent → [Agent A + Agent B simultaneously] → Integration
```
For independent tasks that can run simultaneously.

**Review Patterns:**
```
Main Agent → Implementation Agent → Review Agent → Integration
```
For quality-critical work requiring validation.

## Task Handoff Protocol

### Essential Information for Delegation

When delegating, always provide:
- **Complete Context**: Current project state, existing patterns, constraints
- **Specific Task**: Clear, actionable objective with success criteria
- **Integration Needs**: How this fits with other work and project goals
- **Quality Standards**: Expected deliverable standards and requirements

### Result Integration

When receiving agent results:
- **Validate**: Ensure deliverables match requirements and integrate properly
- **Document**: Update project status and maintain decision history
- **Coordinate**: Share relevant results with other agents if needed
- **Plan Next Steps**: Determine follow-up actions based on deliverables

## Quality Gates

### Pre-Delegation Checklist
- [ ] Task clearly scoped with appropriate specialist selected
- [ ] Complete context and constraints provided
- [ ] Success criteria and deliverables defined
- [ ] Dependencies and integration needs identified

### Post-Delegation Validation
- [ ] Deliverables meet requirements and quality standards
- [ ] Results properly integrated with existing work
- [ ] Project documentation updated with progress and decisions
- [ ] Next steps planned and prioritized

### Cross-Agent Review Triggers
- **Code Implementation** → Code Reviewer validation
- **Security-Critical Changes** → Code Reviewer + {{DEPLOYMENT_AGENT}} review
- **User Experience Changes** → {{DESIGN_AGENT}} + {{IMPLEMENTATION_AGENT}} coordination
- **Production Deployments** → Code Reviewer + Testing Specialist validation

## Problem Resolution

### Blocking Issues
1. **Assess Criticality**: Is this blocking project progress?
2. **Alternative Approach**: Can main agent handle directly or use different specialist?
3. **Scope Adjustment**: Can requirements be modified to unblock progress?
4. **Resource Coordination**: Can multiple agents collaborate to resolve?

### Quality Issues
1. **Root Cause Analysis**: Understand why deliverables didn't meet standards
2. **Context Improvement**: Provide clearer requirements and context for re-work
3. **Protocol Update**: Document lessons learned to prevent recurrence

## Core Principles

- **Context-Driven**: Delegate based on current situation, not rigid templates
- **Complete Context**: Always provide full project understanding to specialists
- **Quality Focus**: Maintain high standards while preserving development velocity
- **Adaptive Coordination**: Let workflow emerge from task needs and project context
- **Continuous Learning**: Update approaches based on what works effectively

## Success Indicators

- **Effective Delegation**: Right specialist selected with appropriate context provided
- **Quality Deliverables**: Specialist outputs meet standards and integrate smoothly
- **Project Momentum**: Coordination enhances rather than slows progress
- **Team Learning**: Protocols improve based on experience and lessons learned

Focus on **adaptive coordination** that responds to project context rather than prescriptive processes that constrain effectiveness. The goal is to leverage specialist expertise efficiently while maintaining project coherence and quality standards for {{PROJECT_TYPE}} development.