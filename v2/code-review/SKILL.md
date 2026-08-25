---
name: code-review
description: >-
  Perform thorough code review and quality analysis on any codebase, detecting bugs, security vulnerabilities, performance issues, code smells, and maintainability problems. Use this skill when the user asks for a code review, بررسی کد, review my code, check code quality, find bugs in my code, suggest improvements, look at this code, is this code good, code smell detection, security audit of code, performance review of code, best practices check, code critique, peer review, review this PR, review this pull request, check for vulnerabilities, شناسایی باگ, پیشنهاد بهبود کد, بررسی کیفیت کد, can you review this, does this look right, any issues with this, what do you think of this code, is there anything wrong here, catch bugs, spot vulnerabilities, security review, performance check, code quality, maintainability review, readable code, clean code check, PR review, diff review, review my commit, review these changes, LGTM check, ready to merge, ship it check, code health, technical debt assessment, improvement suggestions, best practice compliance, anti-pattern detection, code smells, 是否有问题, 审查代码, 代码审查, 检查代码质量, 找bug, 代码优化建议.
---

# Code Review Skill

## Overview

This skill provides systematic, multi-dimensional code review. A good review catches bugs before production, enforces consistency, and transfers knowledge. Reviews are structured by severity and category so the developer can prioritize fixes effectively.

Code review is not about showing how smart you are. It's about helping the developer ship better code. Be specific, be constructive, and be proportionate — a missing semicolon doesn't get the same treatment as an SQL injection vulnerability.

## When to Use This Skill

- User asks for a code review or code quality check
- User wants to know if their code follows best practices
- User asks to find bugs or suggest improvements
- User shares code and asks "is this okay?" or "can this be better?"
- User mentions reviewing a PR, branch, or commit
- User wants a second opinion before merging or deploying
- User asks about code health, technical debt, or maintainability
- User wants security-focused review of specific code
- User asks for a performance assessment of hot paths
- User wants to check if their code follows framework-specific conventions
- User asks "is this ready to merge?" or "does this look right?"

## Review Workflow

### Step 1: Understand the Context

1. Read the file(s) the user wants reviewed using the Read tool.
2. Identify the language, framework, and project type.
3. Determine the scope: is this a single function, a module, or an entire PR?
4. If the user specifies review criteria (e.g., "focus on security" or "check performance"), note those.
5. Read any existing style guide, linting config, or contribution guidelines.
6. If reviewing a diff/PR, use `git diff` to see exactly what changed.
7. Check for existing tests to understand expected behavior and coverage.

### Step 2: Multi-Pass Analysis

Review the code in five passes, each focusing on a different dimension:

#### Pass 1 — Correctness
- Logic errors and off-by-one mistakes
- Null/undefined/uninitialized variable access
- Incorrect conditionals or loop termination
- Wrong algorithm or data structure choice
- Missing error handling for known failure modes
- Incorrect string comparison (case, whitespace, encoding)
- Integer overflow or floating-point precision issues
- Race conditions in concurrent code
- Unreachable code or dead branches

#### Pass 2 — Security
- Input validation and sanitization
- SQL injection, XSS, command injection risks
- Hardcoded secrets, API keys, or credentials
- Insecure default configurations
- Improper authentication or authorization checks
- Unsafe deserialization (pickle, eval, JSON with __proto__)
- Path traversal vulnerabilities
- CSRF token missing or incorrect
- Insecure direct object references (IDOR)
- Overly permissive CORS configuration
- Sensitive data in logs or error messages
- Insecure random number generation for security purposes

#### Pass 3 — Performance
- Unnecessary O(n^2) algorithms or N+1 queries
- Missing caching opportunities
- Large data structures copied unnecessarily
- Blocking operations in async contexts
- Memory leaks (unclosed resources, event listener accumulation)
- Unbounded collections or caches with no eviction
- Synchronous I/O in request handlers
- Redundant database queries (same data fetched multiple times)
- Missing database indexes for query filters
- Unnecessary serialization/deserialization

#### Pass 4 — Maintainability
- Naming clarity (variables, functions, classes)
- Function/method length (should a long function be split?)
- Duplicated code that should be extracted
- Dead code or unreachable branches
- Missing or misleading comments
- Consistent style with the rest of the codebase
- Magic numbers/strings without named constants
- Deep nesting (more than 3 levels)
- God classes or functions with too many responsibilities
- Missing type annotations where the language supports them
- Inconsistent error handling strategies

#### Pass 5 — Architecture & Design
- Are responsibilities properly separated?
- Are abstractions at the right level?
- Is the code coupled to things it shouldn't know about?
- Are there circular dependencies?
- Would a design pattern make this cleaner?
- Is the module's public API minimal and well-defined?
- Are domain concepts properly modeled?

### Step 3: Categorize Findings

Classify each finding by severity:

| Severity | Label | Meaning | Action Required |
|----------|-------|---------|-----------------|
| Critical | BUG | Will cause incorrect behavior or crashes | Must fix before merge |
| High | SECURITY | Vulnerability that could be exploited | Must fix before merge |
| High | PERF | Significant performance problem | Should fix before merge |
| Medium | SMELL | Code smell that hurts maintainability | Should fix, can defer |
| Low | STYLE | Naming, formatting, minor style issues | Nice to have |
| Info | NIT | Suggestion, not a problem per se | Optional |

### Step 4: Present the Review

## Advanced Techniques

### Threat Modeling for Security Pass
Walk through STRIDE categories:
- **S**poofing: Can an attacker impersonate a user or system?
- **T**ampering: Can data be modified in transit or at rest?
- **R**epudiation: Can an action be denied? Is there an audit trail?
- **I**nformation Disclosure: Can sensitive data be exposed?
- **D**enial of Service: Can the system be made unavailable?
- **E**levation of Privilege: Can a user gain higher access?

### Complexity Metrics
Assess cyclomatic complexity mentally:
- 1-10: Simple, low risk
- 11-20: Moderate, needs attention
- 21-50: Complex, hard to test, error-prone
- 50+: Untestable, must refactor

### Data Flow Tracing
For security and correctness, trace data from input to output:
1. Where does the data enter? (user input, API, file, database)
2. What validations are applied?
3. How is it transformed?
4. Where does it exit? (response, database write, log, external API)
5. Is sensitive data exposed at any point?

### Dependency Analysis
- Are all dependencies necessary?
- Are any dependencies unmaintained or have known vulnerabilities?
- Are there opportunities to replace heavy dependencies with stdlib?
- Are version constraints too loose or too tight?

## Common Patterns

### Pattern 1: The Unvalidated Input
Code that trusts user input without validation, leading to crashes, injections, or data corruption.
```
// Bug: user_id from request directly used in query
// Fix: validate type, range, and format before use
```

### Pattern 2: The Leaking Resource
Connections, file handles, or subscriptions opened but never closed, leading to resource exhaustion.
```
// Bug: file opened but not closed in error path
// Fix: use try-with-resources / with statement / defer
```

### Pattern 3: The Silent Failure
Errors caught and swallowed, making debugging impossible and hiding real problems.
```
// Bug: catch(Exception e) { return null; }
// Fix: log the error, propagate or wrap in domain exception
```

### Pattern 4: The Tightly Coupled Module
A module that directly depends on concrete implementations instead of interfaces, making it hard to test and change.
```
// Bug: UserService directly instantiates PostgreSQLRepository
// Fix: inject repository interface via constructor
```

### Pattern 5: The Over-Permissive Access Control
Authorization checks that are missing, incomplete, or bypassed.
```
// Bug: endpoint checks if user is authenticated but not if they own the resource
// Fix: add resource-level authorization check
```

## Edge Cases & Pitfalls

1. **Reviewing style over substance** — A perfectly formatted function with a logic error is worse than an ugly function that works. Prioritize correctness.
2. **Being too pedantic** — Don't flag every minor style issue. Focus on things that affect correctness, security, or maintainability.
3. **Missing the big picture** — A function might be correct in isolation but wrong in the context of the larger system. Always consider the system context.
4. **Not reading related code** — A function's correctness often depends on how it's called. Read the callers to verify assumptions.
5. **Reviewing without understanding the domain** — Business logic bugs require domain understanding. Ask questions if the domain is unclear.
6. **Ignoring the test coverage** — Code without tests is unverified code. Note missing tests as a finding.
7. **Being vague** — "This could be better" is useless. "Line 42: this loop is O(n²), use a Set for O(n) lookup" is actionable.
8. **Rewriting instead of reviewing** — Don't present a full rewrite. Flag specific issues and suggest targeted fixes.
9. **Not considering the change's context** — A quick hack in an emergency hotfix is different from new feature code. Adjust standards accordingly.
10. **Missing concurrency issues** — Code that works in single-threaded testing may fail under concurrent load. Flag shared mutable state.
11. **Not checking error handling consistency** — Some functions throw, some return error codes, some return null. Inconsistency confuses callers.
12. **Ignoring log quality** — Logs that don't include context (who, what, when, correlation ID) are nearly useless for debugging production issues.
13. **Forgetting backward compatibility** — Changes to public APIs or database schemas need migration paths.
14. **Not checking for existing patterns** — The codebase may already have a utility function or pattern for what the new code does from scratch.

## Integration with Other Skills

- **debug**: If the review finds bugs that need formal diagnosis and fixing, switch to the debug skill for targeted analysis.
- **refactor**: If the review identifies structural issues, use refactor to propose and apply improvements.
- **test-generation**: If the review finds missing test coverage, use test-generation to create tests for the identified gaps.
- **security-audit**: If the review uncovers security concerns beyond simple issues, escalate to a full security audit.
- **explain-code**: If the reviewer needs to understand unfamiliar code before reviewing it, use explain-code first.
- **clean-architecture**: If the review reveals architectural problems, use clean-architecture for restructuring guidance.
- **api-design**: If reviewing API endpoint code, use api-design to verify the endpoint follows REST/GraphQL conventions.
- **documentation**: If the review finds missing or outdated documentation, suggest using the documentation skill.

## Output Format

### Standard Code Review Template

```
## Code Review

**File(s):** [list of files reviewed]
**Language/Framework:** [detected stack]
**Scope:** [function / module / PR / full file]

### Critical
- **[file:function / line]** [description of the issue]
  ```lang
  // problematic code snippet
  ```
  **Fix:** [suggested fix or approach]
  **Impact:** [what happens if not fixed]

### High
- **[file:function / line]** [description]
  ```lang
  // problematic code snippet
  ```
  **Fix:** [suggested fix or approach]

### Medium
- **[file:function / line]** [description]
  **Fix:** [suggested fix or approach]

### Low / Nits
- [minor suggestions]

### Summary
| Category | Count |
|----------|-------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |
- **Overall Assessment:** [1-2 sentence summary]
- **Top 3 Priorities:**
  1. [Most important fix]
  2. [Second most important]
  3. [Third most important]
- **Ready to Merge:** Yes / No / With conditions
```

### Security-Focused Review Template

```
## Security Code Review

**File(s):** [files reviewed]
**Threat Model:** [key threats considered]

### Findings
| # | Severity | Type | Location | Description | Remediation |
|---|----------|------|----------|-------------|-------------|
| 1 | Critical | Injection | file:line | ... | ... |
| 2 | High | IDOR | file:line | ... | ... |

### Data Flow Analysis
[Input → Validation → Processing → Output with security notes]

### Recommendations
- [Immediate actions]
- [Long-term improvements]
```

### Performance-Focused Review Template

```
## Performance Code Review

**Hot Path:** [identified performance-critical path]

### Findings
| # | Severity | Type | Location | Current Complexity | Suggested | Est. Improvement |
|---|----------|------|----------|-------------------|-----------|-----------------|
| 1 | High | N+1 Query | file:line | O(n) queries | Batch query | ~100x fewer queries |

### Recommendations
- **Quick wins:** [simple changes with immediate impact]
- **Structural:** [larger changes for fundamental improvement]
```

### Quick Review Template (for small snippets)

```
**Verdict:** [Looks good / Needs changes / Has bugs]
**Issues:** [count, or "None"]
- [If issues, list them concisely]
- [If clean, say what's done well]
```

## Rules

- Be specific. Always reference file, function name, or line number.
- Show the problematic code, then show or describe the fix.
- Never rewrite the entire file — only flag the specific issues.
- If the code is mostly good, say so. Don't invent problems.
- Prioritize correctness over style. A bug matters more than a naming issue.
- If the codebase has a style guide or linting config, read it first and review against it.
- Present the review in the user's language; keep code and technical terms in English.
- Always provide the fix alongside the finding. A finding without a fix is a complaint.
- Be respectful. Frame suggestions as improvements, not corrections. "Consider using X" not "You should have used X."
- If the code is from a PR, note only the changed lines unless there are pre-existing critical issues worth mentioning.
- If you're unsure whether something is a real issue, mark it as a question rather than a finding.
