---
name: code-review
description: >-
  Multi-dimensional code review: correctness, security, performance, maintainability, architecture.
  TRIGGERS: code review, review code, check code quality, PR review, pull request, review PR,
  code quality, code smell, best practices, code critique, peer review, review this,
  بررسی کد, کیفیت کد, بررسی PR, بررسی کد, نقد کد, بهترین شیوه‌ها
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Code Review Skill

## Purpose

Systematic multi-dimensional code review. Catch issues before they reach production.

## When to Activate

- User asks for code review
- Before merging a PR
- After code generation
- User asks "is this code good?"
- Before deployment

## When NOT to Activate

- User wants to write new code (→ code-generation)
- User wants to fix bugs (→ debugging)
- No code to review

## Inputs Required

- Code to review (files, diff, PR)
- Review focus (if specified: security, performance, etc.)

## Preconditions

- Code is accessible

## Workflow

### Pass 1: Correctness

```
- Logic errors
- Off-by-one errors
- Null/undefined access
- Wrong algorithm choice
- Missing error handling
- Incorrect API usage
- Edge cases not handled
```

### Pass 2: Security

```
- Hardcoded secrets
- SQL injection
- XSS vulnerabilities
- Command injection
- Path traversal
- Insecure deserialization
- Missing authentication/authorization
- Unsafe subprocess calls
```

### Pass 3: Performance

```
- N+1 queries
- Unnecessary loops
- Missing indexes
- Memory leaks
- Blocking operations
- Missing caching opportunities
- Inefficient algorithms
```

### Pass 4: Maintainability

```
- Code readability
- Naming quality
- Function length
- Complexity (cyclomatic)
- Duplication
- Comments quality
- Documentation
```

### Pass 5: Architecture

```
- Module boundaries
- Coupling/cohesion
- SOLID principles
- Design patterns
- Separation of concerns
```

### Pass 6: Testing

```
- Test coverage
- Test quality
- Edge cases tested
- Mocking strategy
```

## Decision Tree

```
What is the review scope?
├── Single file → Focus on local quality
├── Module → Check module boundaries
├── PR/Diff → Review all changes
└── Full codebase → Architecture review
```

## Output Format

```
## Code Review

### Summary
[Overall assessment]

### Critical Issues (Must Fix)
1. [Issue] — [file:line] — [fix suggestion]

### Major Issues (Should Fix)
1. [Issue] — [file:line] — [fix suggestion]

### Minor Issues (Consider Fixing)
1. [Issue] — [file:line] — [fix suggestion]

### Security Issues
1. [Issue] — [severity] — [fix]

### Positive Notes
- [What's done well]
```

## Execution Rules

- Be specific — cite file and line
- Provide fix suggestions, not just complaints
- Prioritize by severity
- Be constructive, not just critical
- Check security by default

## Verification

- [ ] All dimensions reviewed
- [ ] Issues prioritized
- [ ] Fix suggestions provided
- [ ] Positive notes included

## Anti-Patterns

- ❌ Reviewing without reading all code
- ❌ Only pointing out problems, not solutions
- ❌ Ignoring security
- ❌ Nitpicking style while missing logic bugs
- ❌ Approving without thorough review

## Skill Interactions

- ← project-analysis: Context for review
- → debugging: Issues found may need debugging
- → refactoring: Issues found may need refactoring
- → testing: Missing tests identified
