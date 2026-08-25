---
name: task-planning
description: >-
  Plan work by breaking complex tasks into ordered, verifiable steps with clear dependencies.
  TRIGGERS: plan, how to approach, break down, steps, roadmap, task list, work plan, what order,
  decomposition, implementation plan, development plan, parallel tasks, sequential tasks,
  برنامه, چطور شروع کنم, قدم‌ها, مراحل, لیست کارها, شکستن کار, ترتیب اجرا
priority: P1
dependencies: [project-analysis, requirement-analysis]
conflicts: []
---

# Task Planning Skill

## Purpose

Break complex tasks into ordered, verifiable, dependency-aware steps. Preventsrandom coding and ensures systematic progress.

## When to Activate

- Task has multiple steps
- User asks "how should I approach this?"
- Task affects multiple files
- Before starting any non-trivial implementation
- When unsure about implementation order

## When NOT to Activate

- Single-line fix
- User provides exact implementation
- Trivial tasks

## Inputs Required

- Requirements (from requirement-analysis)
- Project context (from project-analysis)
- Current project state

## Preconditions

- requirement-analysis completed

## Workflow

### Step 1: Decompose

```
1. Identify the END STATE (what "done" looks like)
2. Work BACKWARDS from end state
3. Break into atomic steps (each verifiable independently)
4. Identify dependencies between steps
```

### Step 2: Order

```
1. Steps with no dependencies → can run in parallel
2. Steps with dependencies → must run sequentially
3. Critical path → longest dependency chain
4. Quick wins → do first for momentum
```

### Step 3: Estimate Risk

```
For each step:
- Risk: LOW / MEDIUM / HIGH
- Can it be tested independently?
- What could go wrong?
- What's the rollback plan?
```

### Step 4: Create Plan

```
## Implementation Plan

### Step 1: [name] (Risk: LOW)
- Action: [what to do]
- Files: [which files]
- Verify: [how to verify]
- Dependencies: none

### Step 2: [name] (Risk: MEDIUM)
- Action: [what to do]
- Files: [which files]
- Verify: [how to verify]
- Dependencies: Step 1
```

## Decision Tree

```
Is the task simple (< 3 steps)?
├── YES → Skip planning, execute directly
├── NO → Is it complex (> 10 steps)?
│   ├── YES → Break into phases, plan each phase
│   └── NO → Full planning
```

## Execution Rules

- Each step must be independently verifiable
- Never skip verification steps
- If a step fails, stop and reassess
- Document decisions and rationale
- Re-plan if requirements change

## Verification

- [ ] All steps identified
- [ ] Dependencies mapped
- [ ] Verification defined for each step
- [ ] Risk assessed
- [ ] User approved plan (if complex)

## Failure Handling

- If plan is too complex → Break into smaller plans
- If dependencies create circular loop → Restructure
- If step fails → Reassess remaining plan

## Safety Constraints

- Do NOT skip steps to "save time"
- Do NOT change plan without documenting why
- Do NOT proceed if plan is unclear

## Output Format

```
## Implementation Plan

### Goal
[What we're building]

### Steps
| # | Step | Risk | Deps | Verify |
|---|------|------|------|--------|
| 1 | [step] | LOW | - | [method] |
| 2 | [step] | MED | 1 | [method] |

### Critical Path
[Steps that cannot be skipped]

### Rollback Plan
[What to do if something goes wrong]
```

## Anti-Patterns

- ❌ Jumping straight to coding without a plan
- ❌ Creating too many tiny steps (over-planning)
- ❌ Ignoring dependencies between steps
- ❌ Not defining how to verify each step
- ❌ Changing plan mid-implementation without documenting

## Skill Interactions

- ← requirement-analysis: Provides what to build
- ← project-analysis: Provides context for planning
- → code-generation: Plan guides implementation
- → verification: Plan defines verification points
