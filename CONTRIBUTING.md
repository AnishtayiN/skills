# 📝 Contributing Guide

## How to Add a New Skill

### Step 1: Check if Needed

Before creating a new skill:
1. Does an existing skill cover this?
2. Can it be merged with an existing skill?
3. Is it relevant for a coding agent?

### Step 2: Follow the Standard

Every skill MUST have:

```yaml
---
name: skill-name
description: >-
  Trigger phrases in English and Farsi.
  When to activate this skill.
priority: P0/P1/P2/P3
dependencies: [other-skills]
conflicts: [conflicting-skills]
---
```

### Step 3: Required Sections

Every skill MUST include:

1. **Purpose** — Why this skill exists
2. **When to Activate** — Specific trigger conditions
3. **When NOT to Activate** — When to skip this skill
4. **Inputs Required** — What information is needed
5. **Preconditions** — What must be true before starting
6. **Workflow** — Step-by-step instructions
7. **Decision Tree** — How to choose between approaches
8. **Execution Rules** — Hard rules to follow
9. **Verification** — How to verify success
10. **Failure Handling** — What to do when things go wrong
11. **Safety Constraints** — What NOT to do
12. **Output Format** — How to present results
13. **Anti-Patterns** — Common mistakes to avoid
14. **Skill Interactions** — How this skill relates to others

### Step 4: Quality Standards

- [ ] Triggers are specific (not too broad)
- [ ] Workflow is actionable (not vague)
- [ ] Verification is defined
- [ ] Anti-patterns are listed
- [ ] Dependencies are correct
- [ ] No duplicate with existing skills
- [ ] Token-efficient (not bloated)

### Step 5: Test

1. Does the skill activate correctly?
2. Does the workflow work?
3. Does the verification catch issues?
4. Is it token-efficient?

## Naming Conventions

- Use kebab-case: `my-skill-name`
- Use lowercase: `debugging`, not `Debugging`
- Be descriptive: `code-review`, not `review`

## Priority Guidelines

| Priority | Use When |
|----------|----------|
| P0 | Critical for correctness/security |
| P1 | Important for most tasks |
| P2 | Normal development tasks |
| P3 | Nice to have |

## File Structure

```
skill-name/
├── SKILL.md          # Main skill file
└── references/       # Optional reference files
    └── patterns.md
```
