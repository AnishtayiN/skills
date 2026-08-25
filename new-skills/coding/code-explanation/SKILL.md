---
name: code-explanation
description: >-
  Explain code clearly at multiple levels of detail. From high-level overview to line-by-line analysis.
  TRIGGERS: explain, what does this code do, how does this work, describe this code, walkthrough,
  code walkthrough, what is happening, explain this function, explain this class,
  توضیح بده, این کد چیکار میکنه, این تابع چیه, توضیح بده چطور کار میکنه, وارد کد شو
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Code Explanation Skill

## Purpose

Explain code at the right level of detail for the audience. From 30,000-foot view to line-by-line.

## When to Activate

- User asks "what does this code do?"
- User asks to explain a function/class/module
- User is unfamiliar with a codebase
- Onboarding to new project

## When NOT to Activate

- User wants to modify code (→ code-editing)
- User wants to fix bugs (→ debugging)
- User wants review (→ code-review)

## Inputs Required

- Code to explain (file, function, class, or snippet)
- Desired level of detail (overview / detailed / line-by-line)

## Preconditions

- Code is accessible

## Workflow

### Step 1: Determine Scope

```
What level of explanation?
├── Overview → High-level purpose and flow
├── Detailed → How each part works
└── Line-by-line → Every line explained
```

### Step 2: Identify Key Elements

```
1. What is the PURPOSE of this code?
2. What are the INPUTS and OUTPUTS?
3. What is the CONTROL FLOW?
4. What DATA STRUCTURES are used?
5. What EXTERNAL DEPENDENCIES exist?
6. What ERROR CASES are handled?
```

### Step 3: Structure Explanation

```
1. Start with PURPOSE (why this code exists)
2. Explain the INTERFACE (what it takes and returns)
3. Walk through the LOGIC (step by step)
4. Highlight KEY DECISIONS (why this approach)
5. Note EDGE CASES and error handling
6. Mention CONNECTIONS to other parts
```

### Step 4: Adapt to Audience

```
If audience is:
├── Beginner → More context, simpler terms
├── Intermediate → Focus on patterns and decisions
└── Expert → Focus on edge cases and trade-offs
```

## Execution Rules

- Start with the big picture
- Use analogies when helpful
- Highlight non-obvious decisions
- Point out potential issues or gotchas
- Connect to project context

## Verification

- [ ] Purpose clearly stated
- [ ] Flow explained logically
- [ ] Key decisions highlighted
- [ ] Edge cases mentioned

## Anti-Patterns

- ❌ Explaining what (reading code aloud) instead of why
- ❌ Too much detail for overview request
- ❌ Too little detail for line-by-line request
- ❌ Not connecting to project context
- ❌ Missing edge cases

## Skill Interactions

- ← project-analysis: Context for explanation
- → debugging: Understanding aids debugging
- → code-review: Understanding aids review
