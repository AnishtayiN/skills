---
name: code-generation
description: >-
  Generate new code from requirements, specifications, or patterns. Write clean, production-ready code.
  TRIGGERS: write code, generate code, create function, implement, add feature, new file, scaffold,
  boilerplate, template, create class, create module, build, make, code this, بنویس کد, پیاده‌سازی,
  تابع بنویس, کلاس بنویس, فایل جدید, ماژول جدید, قابلیت جدید, اضافه کن, بساز
priority: P1
dependencies: [project-analysis, requirement-analysis]
conflicts: []
---

# Code Generation Skill

## Purpose

Write clean, production-ready code that follows project conventions and requirements.

## When to Activate

- User asks to create new code
- User needs a function, class, module, or file
- User wants to implement a feature
- User asks to scaffold or template

## When NOT to Activate

- Modifying existing code (→ code-editing)
- Fixing bugs (→ debugging)
- Refactoring existing code (→ refactoring)

## Inputs Required

- What to create (function/class/module/file)
- Requirements or specifications
- Target location (file path)
- Language and framework

## Preconditions

- project-analysis completed (conventions known)
- requirement-analysis completed (specs clear)

## Workflow

### Step 1: Understand Conventions

```
1. Read existing code in the project
2. Match naming conventions (camelCase, snake_case, etc.)
3. Match import style
4. Match error handling patterns
5. Match logging patterns
6. Match comment style
```

### Step 2: Design Before Coding

```
1. Define the interface (inputs, outputs, types)
2. Define error cases
3. Consider edge cases
4. Plan test cases
```

### Step 3: Implement

```
1. Write the code following project conventions
2. Add appropriate error handling
3. Add必要的 comments (why, not what)
4. Add type annotations (if applicable)
5. Follow SOLID principles
```

### Step 4: Self-Review

```
1. Does it match the requirements?
2. Does it follow project conventions?
3. Are edge cases handled?
4. Is error handling present?
5. Is it readable?
```

## Decision Tree

```
What type of code to generate?
├── Function → Define signature, implement body
├── Class → Define interface, implement methods
├── Module → Define public API, implement internals
├── File → Follow project file templates
└── API Endpoint → Define route, handler, response
```

## Execution Rules

- ALWAYS follow project conventions
- ALWAYS handle errors explicitly
- ALWAYS consider edge cases
- NEVER generate code you don't understand
- NEVER use deprecated APIs
- NEVER hardcode values that should be configurable

## Verification

- [ ] Code compiles/interprets without errors
- [ ] Follows project conventions
- [ ] Error handling present
- [ ] Types annotated (if applicable)
- [ ] No hardcoded values

## Failure Handling

- If unclear how to implement → Research or ask user
- If conventions conflict → Follow most common pattern
- If dependencies missing → Document what's needed

## Safety Constraints

- Do NOT generate code with known vulnerabilities
- Do NOT use unsafe functions (eval, exec without sanitization)
- Do NOT hardcode secrets or credentials
- Do NOT generate code that bypasses security

## Output Format

```
## Generated Code

### File: [path]

[Code]

### Design Decisions
- [Decision 1 and why]
- [Decision 2 and why]

### Edge Cases Handled
- [Case 1]
- [Case 2]

### Testing
[Suggested test cases]
```

## Anti-Patterns

- ❌ Copying code without understanding it
- ❌ Ignoring project conventions
- ❌ Generating code without error handling
- ❌ Hardcoding configuration values
- ❌ Skipping type annotations
- ❌ Writing code that works but is unreadable

## Skill Interactions

- ← project-analysis: Conventions and structure
- ← requirement-analysis: What to build
- → code-review: Review generated code
- → testing: Test generated code
- → verification: Verify it works
