# 🧭 Skill Router

## How Skill Routing Works

```
User Request
     ↓
┌─────────────────┐
│ Task Classifier  │  What type of task is this?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Skill Detector   │  Which skills are relevant?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Priority Sort    │  What's the priority order?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Dependency Check │  What must run first?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Conflict Check   │  Are any skills conflicting?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Load Skills      │  Load ONLY needed skills
└────────┬────────┘
         ↓
┌─────────────────┐
│ Execute          │  Run skills in order
└────────┬────────┘
         ↓
┌─────────────────┐
│ Verify           │  Check results
└────────┬────────┘
         ↓
     Response
```

## Task Classification

| Task Type | Primary Skills | Secondary Skills |
|-----------|---------------|-----------------|
| **New Feature** | project-analysis, requirement-analysis, task-planning, code-generation | code-review, testing, verification |
| **Bug Fix** | debugging, verification | testing, code-review |
| **Code Review** | code-review | security-audit, performance-analysis |
| **Refactoring** | refactoring, code-review | testing, verification |
| **Architecture** | system-design, api-design, database-design | project-analysis |
| **DevOps** | dockerization, ci-cd, deployment | testing, security-audit |
| **Security** | security-audit | code-review, debugging |
| **Performance** | performance-analysis, concurrency-debugging | debugging, profiling |
| **Documentation** | documentation | project-analysis |
| **Testing** | testing, verification | code-review |

## Routing Rules

### Rule 1: Always Start with Analysis

```
If task is unclear OR project is unfamiliar:
  → project-analysis (always first)
```

### Rule 2: Debug Before Refactor

```
If code has bugs AND needs refactoring:
  → debugging FIRST, then refactoring
```

### Rule 3: Verify After Every Change

```
After ANY code change:
  → verification (always last)
```

### Rule 4: Security by Default

```
If code handles user input OR sensitive data:
  → security-audit (include by default)
```

### Rule 5: Test Before Deploy

```
If deploying:
  → testing BEFORE deployment
```

## Priority Order

| Priority | When to Use |
|----------|------------|
| **P0** | Critical: debugging, verification, security-audit |
| **P1** | High: code-review, testing, code-generation, project-analysis |
| **P2** | Normal: refactoring, system-design, git-workflow, api-design |
| **P3** | Standard: documentation, deployment, performance-analysis |

## Dependency Resolution

```
If skill A depends on skill B:
  → Execute B first

If skill A conflicts with skill B:
  → Execute higher priority first
  → Re-evaluate after execution

If circular dependency:
  → Break the circle by removing one dependency
```

## Conflict Resolution

| Conflict | Resolution |
|----------|------------|
| debugging vs refactoring | Debug first, refactor after fix |
| code-review vs code-generation | Generate first, review after |
| security vs performance | Security first |
| minimal-fix vs refactoring | Default to minimal-fix |

## Dynamic Loading

```
NEVER load all skills at once.

1. Classify the task
2. Load ONLY relevant skills
3. Execute
4. Unload
```

This prevents:
- Token waste
- Context pollution
- Skill conflicts
- Confused behavior
