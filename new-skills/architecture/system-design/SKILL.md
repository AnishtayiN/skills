---
name: system-design
description: >-
  Design scalable system architecture. Services, data flow, scaling, trade-offs.
  TRIGGERS: system design, architecture, scalable, design system, high level design,
  hld, architecture diagram, service design, microservices, monolith, scaling,
  طراحی سیستم, معماری, طراحی مقیاس‌پذیر, سرویس‌ها, جریان داده
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# System Design Skill

## Purpose

Design scalable, maintainable system architecture. Make informed trade-offs.

## When to Activate

- Designing a new system
- Scaling an existing system
- User asks about architecture decisions
- Choosing between monolith/microservices

## When NOT to Activate

- Implementing a specific feature (→ code-generation)
- Debugging (→ debugging)
- Small code changes

## Workflow

### Step 1: Understand Requirements

```
1. Functional requirements — What must it do?
2. Non-functional requirements — Performance, scale, reliability
3. Constraints — Budget, team size, timeline
4. Assumptions — What are we assuming?
```

### Step 2: High-Level Design

```
1. Identify components
2. Define interfaces between components
3. Choose communication patterns (sync/async)
4. Design data flow
```

### Step 3: Trade-off Analysis

```
For each decision:
├── Option A: [description] — Pros/Cons
├── Option B: [description] — Pros/Cons
└── Recommendation: [chosen option] — Why
```

### Step 4: Document

```
## System Design

### Components
[Component list with responsibilities]

### Data Flow
[How data moves through the system]

### Trade-offs
[Key decisions and rationale]

### Scaling Strategy
[How to handle growth]

### Failure Modes
[What can go wrong and how to handle it]
```

## Execution Rules

- Start with requirements, not solutions
- Consider failure modes
- Document trade-offs
- Keep it simple — don't over-engineer

## Anti-Patterns

- ❌ Over-engineering from day one
- ❌ Ignoring non-functional requirements
- ❌ Not considering failure modes
- ❌ Choosing technology before understanding requirements

## Skill Interactions

- ← project-analysis: Understand current system
- → api-design: Design APIs
- → database-design: Design data layer
- → deployment: Plan deployment
