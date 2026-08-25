---
name: code-review
description: >-
  Perform thorough code review and quality analysis on any codebase, detecting bugs, security vulnerabilities, performance issues, code smells, and maintainability problems. Use this skill when the user asks for a code review, بررسی کد, review my code, check code quality, find bugs in my code, suggest improvements, look at this code, is this code good, code smell detection, security audit of code, performance review of code, best practices check, code critique, peer review, review this PR, review this pull request, check for vulnerabilities, شناسایی باگ, پیشنهاد بهبود کد, بررسی کیفیت کد, بررسی امنیت کد, کد ریویو, نقد کد.
---

# Code Review Skill — Comprehensive Multi-Dimensional Analysis

## Overview

This skill provides systematic, multi-dimensional code review. A good review catches bugs before production, enforces consistency, and transfers knowledge. Reviews are structured by severity and category so the developer can prioritize fixes effectively.

This skill goes beyond basic syntax checking. It evaluates correctness, security, performance, maintainability, architecture, dependencies, and domain-specific concerns across all major languages and frameworks.

## When to Use This Skill

- User asks for a code review or code quality check
- User wants to know if their code follows best practices
- User asks to find bugs or suggest improvements
- User shares code and asks "is this okay?" or "can this be better?"
- User mentions reviewing a PR, branch, or commit
- User wants a security audit or performance review
- User asks about code smells or architectural concerns

---

## Review Workflow

### Step 1: Understand the Context

1. Read the file(s) the user wants reviewed using the Read tool.
2. Identify the language, framework, and project type.
3. Determine the scope: is this a single function, a module, or an entire PR?
4. If the codebase has a style guide, linting config, or CONTRIBUTING.md, read it first.
5. If the user specifies review criteria (e.g., "focus on security" or "check performance"), note those.

### Step 2: Multi-Pass Analysis

Review the code in six passes, each focusing on a different dimension:

#### Pass 1 — Correctness
- Logic errors and off-by-one mistakes
- Null/undefined/uninitialized variable access
- Incorrect conditionals or loop termination
- Wrong algorithm or data structure choice
- Missing error handling for known failure modes
- Incorrect use of APIs or library functions
- Missing edge case handling

#### Pass 2 — Security
- Input validation and sanitization
- SQL injection, XSS, command injection, SSRF risks
- Hardcoded secrets, API keys, or credentials
- Insecure default configurations
- Improper authentication or authorization checks
- Unsafe deserialization (pickle, eval, YAML load)
- Path traversal vulnerabilities
- Insecure random number generation for security purposes
- Missing rate limiting on sensitive endpoints
- Dependency vulnerabilities (known CVEs)

#### Pass 3 — Performance
- Unnecessary O(n^2) algorithms or N+1 queries
- Missing caching opportunities
- Large data structures copied unnecessarily
- Blocking operations in async contexts
- Memory leaks (unclosed resources, event listener accumulation)
- Unnecessary database queries or network calls
- Missing pagination or streaming for large datasets
- Inefficient string concatenation in loops

#### Pass 4 — Maintainability
- Naming clarity (variables, functions, classes)
- Function/method length (should a long function be split?)
- Duplicated code that should be extracted
- Dead code or unreachable branches
- Missing or misleading comments
- Consistent style with the rest of the codebase
- Proper abstraction levels (not over-abstracted, not under-abstracted)
- Clear module boundaries and responsibilities

#### Pass 5 — Architecture & Design
- Single Responsibility Principle violations
- Coupling between modules (are dependencies appropriate?)
- Cohesion within modules (do things that change together stay together?)
- Dependency direction (do high-level modules depend on low-level modules?)
- API design (is the public interface clean and stable?)
- Separation of concerns (business logic mixed with I/O, UI mixed with data access)
- Extensibility (how hard is it to add a new feature?)

#### Pass 6 — Dependencies & Supply Chain
- Are dependencies pinned to specific versions?
- Are dependencies from reputable sources?
- Are there unused or redundant dependencies?
- Are there known vulnerabilities in current dependency versions?
- Is the dependency tree deep (lots of transitive dependencies)?
- Are lock files committed and consistent?

---

## Code Smell Categories

### Coupling Smells

| Smell | Description | Example |
|-------|-------------|---------|
| **Feature Envy** | A method uses data from another class more than its own | `order.calculateShipping()` accesses `customer.address.zipCode` extensively |
| **Inappropriate Intimacy** | Two classes know too much about each other's internals | Class A calls `classB._internalData` directly |
| **Message Chains** | A chain of method calls traverses multiple objects | `order.getCustomer().getAddress().getZipCode()` |
| **Middle Man** | A class delegates all its work to another class | `class Proxy { delegate() { return real.service(); } }` |

### Cohesion Smells

| Smell | Description | Example |
|-------|-------------|---------|
| **God Class** | A class does too many things, has too many responsibilities | A 2000-line `Manager` class handling users, orders, payments, and emails |
| **Data Clumps** | Same groups of parameters appear in multiple methods | `createUser(name, email, phone, address, city, zip)` appears 5 times |
| **Refused Bequest** | A subclass doesn't use most of its parent's methods | `ElectricCar` inherits `drive()` but overrides it completely |

### Package/Module Smells

| Smell | Description | Example |
|-------|-------------|---------|
| **Parallel Inheritance** | Every subclass of A requires a subclass of B | `SpecialUser` always needs `SpecialUserHandler` |
| **Shotgun Surgery** | A single change requires modifications in many different places | Adding a field requires changes in 8 files |
| **Divergent Change** | One module is commonly changed for many different reasons | `utils.py` modified for both auth changes and payment changes |

### General Code Smells

| Smell | Description | Example |
|-------|-------------|---------|
| **Long Method** | A method does too much, is hard to understand | A 100-line function with 15 local variables |
| **Long Parameter List** | Too many parameters make the method hard to call | `function(a, b, c, d, e, f, g, h)` |
| **Primitive Obsession** | Using primitives instead of small objects for simple tasks | `string phone` instead of `PhoneNumber` type |
| **Switch Statement** | Long switch/if-elif chains that should be polymorphism | `if type == "A" ... elif type == "B" ... elif type == "C" ...` |
| **Speculative Generality** | Code designed for future requirements that may never come | Abstract factory pattern for a feature that only has one implementation |

---

## Language-Specific Review Checklists

### Python

```markdown
□ Type hints present on public function signatures?
□ f-strings used instead of .format() or % formatting?
□ Context managers (with) used for resource management?
□ Contextlib suppress or try/except used appropriately?
□ No mutable default arguments in function signatures?
□ No bare except clauses (catch specific exceptions)?
□ Logging uses lazy formatting: logger.info("msg %s", var)?
□ No `import *` in production code?
□ f-strings not used in logging (use %s for performance)?
□ list/dict comprehensions used where appropriate?
□ `pathlib.Path` used instead of `os.path` for new code?
□ Dataclasses or NamedTuples used instead of plain dicts for structured data?
□ No global mutable state?
□ Async/await used correctly (no blocking in async functions)?
```

### JavaScript / TypeScript

```markdown
□ TypeScript strict mode enabled?
□ `===` used instead of `==`?
□ async/await used instead of raw Promises where possible?
□ No memory leaks from unremoved event listeners?
□ No race conditions in async code (stale closures)?
□ Error boundaries or try/catch in async functions?
□ No `var` declarations (use const/let)?
□ Destructuring used for clarity where appropriate?
□ Optional chaining (`?.`) used instead of manual null checks?
□ No floating promises (Promises that aren't awaited or .catch-ed)?
□ No `console.log` in production code?
□ Dependencies don't have known CVEs (run npm audit)?
□ ESLint/prettier config present and passing?
```

### Rust

```markdown
□ No unnecessary .clone() calls? (check perf cost)
□ Error handling uses Result<T, E> instead of .unwrap() in production?
□ Lifetimes are explicit and minimal?
□ Public API has doc comments (///) on all items?
□ No unsafe blocks without // SAFETY: comments?
□ Tests use #[cfg(test)] module?
□ Traits used for abstraction instead of concrete types in public API?
□ No unnecessary heap allocations (Vec where array would do)?
□ Serde derives present on data structures that need serialization?
□ No panic in library code (return Result instead)?
```

### Go

```markdown
□ Errors are checked and not silently ignored (_, err := ...)?
□ Error messages are lowercase and don't end with punctuation?
□ Errors are wrapped with fmt.Errorf("context: %w", err)?
□ No goroutine leaks (context cancellation propagated)?
□ No data races (go vet or race detector passes)?
□ Interface satisfaction checked at compile time (var _ Interface = (*Impl)(nil))?
□ No exported functions/types that don't need to be exported?
□ Resource cleanup via defer where appropriate?
□ Table-driven tests used for multiple test cases?
□ No bare panic() in library code?
```

### Java

```markdown
□ Records used instead of boilerplate POJOs where appropriate?
□ Optional used instead of returning null for optional values?
□ Streams used judiciously (not over-abstracting simple loops)?
□ No raw types (use parameterized types)?
□ equals() and hashCode() overridden together?
□ No == comparison on Strings (use .equals())?
□ try-with-resources used for AutoCloseable resources?
□ SLF4J/Logback used for logging (not System.out)?
□ No checked exceptions that should be unchecked?
□ Immutability preferred (final fields, unmodifiable collections)?
```

---

## Severity Levels with Real Examples

### Critical (BUG) — Will cause crashes or incorrect behavior

```python
# BUG: SQL Injection
def get_user(username):
    query = f"SELECT * FROM users WHERE name = '{username}'"
    return db.execute(query)
# FIX: Use parameterized queries
def get_user(username):
    return db.execute("SELECT * FROM users WHERE name = %s", (username,))
```

```javascript
// BUG: Prototype pollution
function merge(target, source) {
  for (let key in source) {
    if (typeof source[key] === 'object') {
      target[key] = merge(target[key] || {}, source[key]);
    } else {
      target[key] = source[key];
    }
  }
  return target;
}
// Attacker sends: {"__proto__": {"isAdmin": true}}
// FIX: Use Object.create(null) or check hasOwnProperty
```

### High (SECURITY) — Vulnerability that could be exploited

```python
# SECURITY: Hardcoded secret
API_KEY = "sk-abc123secretkey456"
# FIX: Use environment variables or a secrets manager
import os
API_KEY = os.environ["API_KEY"]
```

```go
// SECURITY: Insecure TLS configuration
client := &http.Client{
    Transport: &http.Transport{
        TLSClientConfig: &tls.Config{
            InsecureSkipVerify: true, // Skips certificate verification
        },
    },
}
// FIX: Remove InsecureSkipVerify or set to false
```

### High (PERF) — Significant performance problem

```javascript
// PERF: O(n^2) where O(n) would work
function findDuplicates(arr) {
  const dupes = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) dupes.push(arr[i]);
    }
  }
  return dupes;
}
// FIX: Use Set for O(n)
function findDuplicates(arr) {
  const seen = new Set();
  return arr.filter(x => {
    if (seen.has(x)) return true;
    seen.add(x);
    return false;
  });
}
```

### Medium (SMELL) — Code smell that hurts maintainability

```java
// SMELL: God Class — this class handles too many concerns
public class UserManager {
    public void createUser() { /* ... */ }
    public void sendWelcomeEmail() { /* ... */ }
    public void processPayment() { /* ... */ }
    public void generateReport() { /* ... */ }
    public void logActivity() { /* ... */ }
}
// FIX: Split into UserService, EmailService, PaymentService, ReportService, AuditService
```

### Low (STYLE) — Naming, formatting, minor style issues

```python
# STYLE: Inconsistent naming
def getUserData():      # camelCase
    user_information = {}  # snake_case
    FIRST_NAME = "John"    # SCREAMING_SNAKE (not a constant)
# FIX: Use snake_case for functions and variables per PEP 8
```

### Info (NIT) — Suggestion, not a problem per se

```rust
// NIT: Could use method chaining for readability
let mut v = Vec::new();
v.push(1);
v.push(2);
v.push(3);
// Nit: let v: Vec<i32> = vec![1, 2, 3];
```

---

## Review Automation Patterns

### CI/CD Integration Checklist

```
□ Static analysis (linters) pass
□ Type checking passes (mypy, tsc --strict, etc.)
□ No known security vulnerabilities (npm audit, safety, cargo audit)
□ Test coverage meets minimum threshold
□ No banned patterns (no eval, no exec, no require(dynamic))
□ Code formatting is consistent (prettier, black, rustfmt)
□ Commit messages follow conventional format
```

### Review Checklist by File Type

```
Source Code (.py, .js, .ts, .rs, .go, .java):
  → Full 6-pass review above

Configuration (.env, .yaml, .toml, .json):
  → Check for hardcoded secrets
  → Verify no debug/development settings in production configs
  → Check file permissions (should be restrictive)
  → Verify dependency versions are pinned

SQL (.sql):
  → Check for injection risks
  → Verify indexes exist for frequently queried columns
  → Check for missing LIMIT on potentially large result sets
  → Verify migrations are reversible

Dockerfile / docker-compose:
  → Check for running as root (use non-root user)
  → Verify base image versions are pinned
  → Check for secrets in build args or environment
  → Verify multi-stage builds for smaller images
```

---

## Output Format

```
## Code Review

**File(s):** [list of files reviewed]
**Language/Framework:** [detected stack]

### Critical
- **[location]** [description of the issue]
  ```lang
  // problematic code snippet
  ```
  **Fix:** [suggested fix or approach]

### High
- **[location]** [description]
  ...

### Medium
- **[location]** [description]
  ...

### Low / Nits
- [minor suggestions]

### Architecture Notes
- [high-level design observations, if applicable]

### Summary
- [1-2 sentence overall assessment]
- [Top 3 priorities to address]
```

## Rules

- Be specific. Always reference file, function name, or line number.
- Show the problematic code, then show or describe the fix.
- Never rewrite the entire file — only flag the specific issues.
- If the code is mostly good, say so. Don't invent problems.
- Prioritize correctness over style. A bug matters more than a naming issue.
- If the codebase has a style guide or linting config, read it first and review against it.
- Present the review in the user's language; keep code and technical terms in English.
- Don't just criticize — explain *why* something is a problem and *how* to fix it.
- Consider the trade-off: is this improvement worth the effort?
