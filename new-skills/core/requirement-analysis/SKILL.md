---
name: requirement-analysis
description: >-
  Analyze and clarify user requirements before implementing. Distinguish what user wants from what they need.
  TRIGGERS: requirement, what do you need, clarify requirements, user story, acceptance criteria,
  what exactly do you want, define scope, functional requirement, non-functional requirement,
  نیازمندی, چی میخوای, دقیقاً چه کاری, محدوده کار, شرایط پذیرش
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Requirement Analysis Skill

## Purpose

Transform vague user requests into clear, actionable, verifiable requirements before writing any code.

## When to Activate

- User request is ambiguous or open-ended
- Task involves multiple possible approaches
- Task affects multiple files or modules
- User says "add a feature" without specifics
- Before any significant code change

## When NOT to Activate

- User provides exact code to write
- Simple typo fixes
- Clear single-file changes

## Inputs Required

- User's request (exact words)
- Project context (from project-analysis)
- Any existing requirements or docs

## Preconditions

- project-analysis completed (or project context known)

## Workflow

### Step 1: Extract Intent

```
1. What is the user's GOAL? (not their proposed solution)
2. What is the expected OUTCOME?
3. What are the CONSTRAINTS? (time, compatibility, performance)
4. What is OUT OF SCOPE?
```

### Step 2: Identify Gaps

```
Questions to ask (if not answered):
- Which files/modules are affected?
- What existing behavior should NOT change?
- Are there edge cases to handle?
- What is the testing strategy?
- Any backwards compatibility requirements?
```

### Step 3: Define Acceptance Criteria

```
For each requirement:
- Given [context]
- When [action]
- Then [expected result]
```

### Step 4: Validate with User

```
Present summary:
1. "I understand you want [X]"
2. "This means [Y] will change"
3. "I will NOT touch [Z]"
4. "Correct?"
```

## Decision Tree

```
Is the request clear and specific?
├── YES → Document requirements, proceed
├── PARTIAL → Ask clarifying questions
└── NO → Ask user to rephrase or provide examples
```

## Execution Rules

- NEVER assume requirements — always verify
- Separate WANT from NEED
- Document assumptions explicitly
- If requirement is complex, break into sub-requirements
- Get user confirmation before implementing

## Verification

- [ ] User goal understood
- [ ] Acceptance criteria defined
- [ ] Scope boundaries clear
- [ ] User confirmed understanding

## Failure Handling

- If user cannot clarify → Make reasonable assumptions, document them
- If requirements conflict → Present conflict, ask user to prioritize

## Safety Constraints

- Do NOT implement without clear requirements
- Do NOT expand scope beyond what user confirmed
- Do NOT make breaking changes without explicit approval

## Output Format

```
## Requirements

### Goal
[What user wants to achieve]

### Acceptance Criteria
1. [Criterion 1]
2. [Criterion 2]

### Out of Scope
- [What will NOT be done]

### Assumptions
- [Assumption 1]

### Files Affected
- [file1]
- [file2]
```

## Anti-Patterns

- ❌ Implementing without understanding the goal
- ❌ Expanding scope silently
- ❌ Assuming edge cases without documenting
- ❌ Skipping user confirmation on ambiguous requests

## Skill Interactions

- ← project-analysis: Provides context
- → task-planning: Requirements become tasks
- → code-generation: Requirements guide implementation
- → verification: Acceptance criteria used for verification
