---
name: documentation
description: >-
  Create and maintain documentation: README, API docs, code comments, architecture docs.
  TRIGGERS: documentation, docs, readme, write docs, document this, api documentation,
  code comments, architecture documentation, technical writing, tutorial,
  مستندات, داکیومنت, ریدمی, نوشتن مستندات, توضیحات کد
priority: P3
dependencies: [project-analysis]
conflicts: []
---

# Documentation Skill

## Purpose

Create clear, useful documentation. Write for the reader, not the writer.

## When to Activate

- User asks to write documentation
- New project needs README
- API needs documentation
- Code needs comments

## Workflow

### Step 1: Determine Type

```
What documentation?
├── README → Project overview, setup, usage
├── API Docs → Endpoints, schemas, examples
├── Code Comments → Why, not what
├── Architecture → Design decisions, trade-offs
└── Tutorial → Step-by-step guide
```

### Step 2: Write

```
Rules:
1. Start with WHY (purpose)
2. Then WHAT (features/capabilities)
3. Then HOW (setup/usage)
4. Keep it concise
5. Use examples
6. Keep it updated
```

### Step 3: Review

```
1. Is it accurate?
2. Is it clear?
3. Is it complete?
4. Are examples working?
```

## Anti-Patterns

- ❌ Documentation that lies (outdated)
- ❌ Documentation without examples
- ❌ Writing what the code does (instead of why)
- ❌ Overly verbose documentation
- ❌ No documentation at all

## Skill Interactions

- ← project-analysis: Understand what to document
- → verification: Verify docs are accurate
