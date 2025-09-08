# Workflow Principles

## Core Philosophy

The Claude agent system operates on **adaptive coordination** rather than rigid processes. These principles guide effective delegation, quality management, and project coordination.

## Fundamental Principles

### 1. Context-Driven Delegation
**Principle**: Delegate based on current project context and task needs, not rigid templates.

**Application**:
- Analyze current project stage before delegating
- Consider task complexity and specialist requirements
- Adapt delegation patterns to specific situation
- Provide complete context to enable informed decision-making

**Examples**:
- Production optimization stage → Focus on deployment-engineer + frontend-engineer
- Bug fixes → code-reviewer (analysis) → frontend-engineer (fix)
- New features → product-manager → ui-ux-designer → frontend-engineer

### 2. Complete Context Provision
**Principle**: Always provide full project understanding to specialist agents.

**Essential Context Elements**:
- **Current Project State**: What's completed, what's in progress, what's next
- **Existing Patterns**: Code conventions, design systems, architectural decisions
- **Constraints**: Technical limitations, deadlines, resource constraints
- **Integration Needs**: How this work fits with other components
- **Quality Standards**: Expected deliverable standards and success criteria

**Template for Delegation**:
```
Agent: [specialist-name]
Task: [specific, actionable objective]
Context: [current project state and relevant background]
Success Criteria: [how to measure completion]
Integration: [how this fits with other work]
```

### 3. Adaptive Coordination Patterns
**Principle**: Let workflow emerge from task needs rather than following prescribed processes.

**Flexible Patterns**:

**Single Agent Tasks** (Most Common):
```
Main Agent → Specialist Agent → Integration
```
*Use when: Task fits clearly within one domain*

**Sequential Coordination**:
```
Main Agent → Agent A → Agent B → Integration
```
*Use when: Agent B needs Agent A's output (e.g., Design → Implementation)*

**Parallel Coordination**:
```
Main Agent → [Agent A + Agent B simultaneously] → Integration
```
*Use when: Independent tasks can run simultaneously*

**Review Patterns**:
```
Main Agent → Implementation Agent → Review Agent → Integration
```
*Use when: Quality gates require specialist validation*

### 4. Quality Through Expertise
**Principle**: Maintain quality through specialist expertise, not bureaucratic processes.

**Quality Assurance Approach**:
- **Right Specialist**: Match task to appropriate domain expert
- **Clear Standards**: Define success criteria and quality benchmarks
- **Expert Review**: Use specialist review for validation, not checklists
- **Iterative Improvement**: Learn from outcomes and refine approaches

**Quality Gates**:
- **Pre-Delegation**: Task scoped, specialist selected, context provided
- **Post-Delegation**: Deliverables validated, results integrated, lessons captured

### 5. Continuous Learning Integration
**Principle**: Systematically capture and apply lessons learned to improve coordination effectiveness.

**Learning Mechanisms**:
- Document what works and what doesn't in specific contexts
- Update approaches based on successful patterns
- Evolve agent roles based on project needs and performance
- Share insights across sessions and projects

## Delegation Decision Framework

### When to Delegate vs Handle Directly

**Delegate When**:
- Task requires specialist domain knowledge
- Quality gates need expert validation
- Complex implementation requiring focused attention
- Work benefits from specialist methodology and best practices

**Handle Directly When**:
- Simple file operations and basic commands
- Quick coordination between agents
- Immediate user responses without specialized analysis
- Context gathering and project status updates

### Specialist Selection Guide

**{{AGENT_TYPE}} Agent**: 
- {{AGENT_EXPERTISE_DESCRIPTION}}
- {{WHEN_TO_USE_EXAMPLES}}

*Note: Customize this section based on your project's selected agent types*

## Coordination Best Practices

### Task Handoff Excellence
**Before Delegation**:
- [ ] Task clearly scoped with success criteria defined
- [ ] Appropriate specialist selected based on expertise match
- [ ] Complete context provided including constraints and integration needs
- [ ] Timeline and dependencies clearly communicated

**During Work**:
- [ ] Monitor progress without micromanaging
- [ ] Provide additional context when needed
- [ ] Coordinate with other agents when dependencies arise
- [ ] Remove blockers that arise during implementation

**After Completion**:
- [ ] Validate deliverables against success criteria
- [ ] Integrate results with existing project work
- [ ] Update project documentation and status
- [ ] Capture lessons learned for future reference

### Cross-Agent Coordination
**When Multiple Agents Needed**:
- **Sequential**: Provide clear handoff points and deliverable formats
- **Parallel**: Coordinate to avoid conflicts and ensure integration compatibility
- **Review**: Structure review to be constructive and actionable
- **Collaboration**: Facilitate communication between agents when needed

**Integration Patterns**:
- **Design → Development**: UI/UX specifications → Frontend implementation
- **Development → Review**: Code implementation → Quality validation
- **Implementation → Deployment**: Feature completion → Production release
- **Analysis → Solution**: Problem diagnosis → Solution implementation

## Common Anti-Patterns to Avoid

### 1. Over-Delegation
**Problem**: Delegating simple tasks that could be handled directly
**Solution**: Use judgment - quick file reads and simple edits don't need specialists

### 2. Under-Context
**Problem**: Delegating without sufficient background information
**Solution**: Always provide complete project context and clear success criteria

### 3. Rigid Process Following
**Problem**: Forcing tasks into predetermined workflow templates
**Solution**: Adapt coordination to actual task needs and project context

### 4. Quality Through Process
**Problem**: Relying on checklists instead of specialist expertise
**Solution**: Use expert judgment and domain knowledge for quality assurance

### 5. Coordination Overhead
**Problem**: Creating more coordination work than actual implementation work
**Solution**: Keep coordination lightweight and focused on enabling specialist work

## Success Metrics

### Effective Coordination Indicators
- **Right Specialist Selected**: Task expertise matches agent domain
- **Sufficient Context Provided**: Agents can work effectively without additional information requests
- **Quality Deliverables**: Results meet standards and integrate smoothly
- **Project Momentum**: Coordination enhances rather than slows progress
- **Learning Integration**: Lessons captured and applied to improve future coordination

### Continuous Improvement Signals
- **Pattern Recognition**: Successful approaches identified and documented
- **Efficiency Gains**: Coordination overhead decreases while quality maintains
- **Quality Consistency**: Standards maintained across different agents and tasks
- **Adaptive Capability**: System responds effectively to new contexts and challenges

These principles create a foundation for effective agent coordination that balances specialist expertise with project coherence, enabling high-quality deliverables while maintaining development velocity.