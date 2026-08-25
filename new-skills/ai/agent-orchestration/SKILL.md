---
name: agent-orchestration
description: >-
  Orchestrate multi-agent systems, task delegation, and agent coordination.
  TRIGGERS: agent orchestration, multi-agent, agent coordination, task delegation,
  agent workflow, agent pipeline, agent system, subagent, agent loop,
  هماهنگی اجنت, سیستم چنداجنتی, توزیع کار, اجرای اجنت
priority: P2
dependencies: [task-planning]
conflicts: []
---

# Agent Orchestration Skill

## Purpose

Coordinate multiple agents effectively. Prevent loops, manage state, ensure completion.

## When to Activate

- Task requires multiple agents
- User asks for agent coordination
- Complex multi-step workflows

## Workflow

### Step 1: Plan Delegation

```
1. What tasks can be parallelized?
2. What tasks are sequential?
3. What are the dependencies?
4. What state needs to be shared?
```

### Step 2: Execute

```
1. Start independent tasks in parallel
2. Wait for dependencies before starting dependent tasks
3. Collect results
4. Handle failures
```

### Step 3: Verify

```
1. All tasks completed?
2. Results are correct?
3. No agent loops?
4. State is consistent?
```

## Execution Rules

- Prevent infinite agent loops
- Set maximum retry limits
- Verify agent outputs
- Handle agent failures gracefully

## Anti-Patterns

- ❌ Infinite agent loops
- ❌ Not verifying agent outputs
- ❌ Sending conflicting instructions
- ❌ Not handling agent failures

## Skill Interactions

- ← task-planning: Plan the orchestration
- → verification: Verify results
