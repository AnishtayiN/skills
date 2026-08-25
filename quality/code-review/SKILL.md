---
name: code-review
description: >-
  Multi-dimensional code review: correctness, security, performance, maintainability, architecture.
  TRIGGERS: code review, review code, check code quality, PR review, pull request, review PR,
  code quality, code smell, best practices, code critique, peer review, review this,
  بررسی کد, کیفیت کد, بررسی PR, بررسی کد, نقد کد, بهترین شیوه‌ها,
  审查代码, 代码审查, 代码质量, 拉取请求
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Code Review Skill

## Overview

Systematic multi-dimensional code review using a structured 5-pass methodology. Catch issues before they reach production through correctness analysis, security auditing (STRIDE threat modeling), performance profiling, maintainability scoring, and architectural evaluation.

## When to Use This Skill

- User asks for code review
- Before merging a PR / Pull Request
- After code generation
- User asks "is this code good?"
- Before deployment
- After a security audit request
- During architecture review sessions
- بررسی کد (review code), نقد کد (code critique)
- 审查代码, 代码审查

## When NOT to Use This Skill

- User wants to write new code (→ code-generation)
- User wants to fix bugs (→ debugging)
- No code to review
- User only wants formatting (→ use formatter)

## Inputs Required

- Code to review (files, diff, PR)
- Review focus (if specified: security, performance, etc.)
- Review depth (quick / standard / deep)

## Preconditions

- Code is accessible
- Review scope is defined

---

## Workflow: 5-Pass Review Methodology

### Pass 1: Correctness Review

Analyze logic correctness systematically.

```
Checks:
├── Logic errors — off-by-one, wrong condition, inverted logic
├── Null/undefined access — missing guards, unsafe property access
├── Wrong algorithm — O(n²) where O(n) is possible
├── Missing error handling — uncaught exceptions, silent failures
├── Incorrect API usage — wrong parameters, wrong order
├── Edge cases — empty arrays, zero values, max integers
├── Concurrency — race conditions, deadlocks, lost updates
├── State management — stale state, mutation side effects
└── Return values — missing returns, wrong return types
```

**Technique — Data Flow Tracing**: For each function, trace the data from input to output. Verify that every transformation is correct and every branch terminates.

```
Input → Validation → Transformation → Output
  │          │              │             │
  ▼          ▼              ▼             ▼
Is null?  Valid shape?  Correct math?  Matches contract?
```

**Complexity Metrics**: When reviewing, calculate cyclomatic complexity:
- CC = (number of decision points) + 1
- CC 1-10: Simple, low risk
- CC 11-20: Moderate, needs attention
- CC 21-50: Complex, high risk — refactor
- CC 50+: Unmaintainable — rewrite required

### Pass 2: Security Review (STRIDE Threat Modeling)

Apply the STRIDE model systematically to each component.

```
STRIDE Threat Model:
├── Spoofing — Can an attacker impersonate a user/service?
│   └── Check: Auth tokens, session handling, API keys
├── Tampering — Can data be modified in transit or at rest?
│   └── Check: Input validation, integrity checks, encryption
├── Repudiation — Can actions be denied?
│   └── Check: Audit logging, non-repudiation mechanisms
├── Information Disclosure — Can sensitive data leak?
│   └── Check: Error messages, logging, data exposure
├── Denial of Service — Can the system be overwhelmed?
│   └── Check: Rate limiting, resource limits, timeouts
└── Elevation of Privilege — Can users gain unauthorized access?
    └── Check: Authorization checks, role validation, RBAC
```

**Security-Focused Review Template**:

```
## Security Review: [Component/Module]

### Authentication
- [ ] No hardcoded secrets or credentials
- [ ] Token validation on every protected endpoint
- [ ] Session timeout configured
- [ ] Password hashing uses bcrypt/argon2 (not MD5/SHA1)

### Authorization
- [ ] RBAC checks on every endpoint
- [ ] Users can only access their own resources
- [ ] Admin endpoints are isolated
- [ ] No IDOR (Insecure Direct Object Reference) vulnerabilities

### Input Validation
- [ ] All user inputs sanitized
- [ ] SQL parameterized queries (no string concatenation)
- [ ] XSS prevention (output encoding)
- [ ] File upload validation (type, size, content)
- [ ] Command injection prevention (no shell with user input)

### Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] HTTPS enforced in transit
- [ ] PII not logged in plain text
- [ ] Secrets in environment variables, not code

### Infrastructure
- [ ] Dependencies scanned for known CVEs
- [ ] CORS properly configured
- [ ] Security headers set (CSP, HSTS, X-Frame-Options)
- [ ] Rate limiting on auth endpoints
```

### Pass 3: Performance Review

Analyze performance characteristics and resource usage.

```
Checks:
├── Algorithmic complexity — Big O analysis
├── N+1 query detection — database calls in loops
├── Memory leaks — unclosed resources, event listener leaks
├── Blocking operations — sync I/O in async context
├── Missing caching — repeated expensive computations
├── Bundle size — unused imports, large dependencies
├── Database efficiency — missing indexes, full table scans
├── Network efficiency — chatty APIs, missing batching
└── Concurrency — thread pool exhaustion, connection limits
```

**Performance Template**:

```
## Performance Review: [Component/Module]

### Critical (P0) — Immediate Impact
| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|
| N+1 query | user.js:45 | O(n) DB calls → O(1) | Use JOIN or batch |

### Major (P1) — Should Fix
| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|
| Missing cache | utils.js:12 | Repeated computation | Add LRU cache |

### Minor (P2) — Consider
| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|
| Large bundle | index.js:1 | +150KB | Tree-shake lodash |

### Benchmarks
- Current: [baseline metrics]
- Projected: [expected improvement]
```

### Pass 4: Maintainability Review

Evaluate code quality and long-term sustainability.

```
Checks:
├── Naming — Clear, consistent, intention-revealing names
├── Function length — <50 lines preferred
├── File length — <500 lines preferred
├── Cyclomatic complexity — CC < 10 per function
├── DRY violations — duplicated logic
├── Comment quality — WHY not WHAT
├── Error messages — Helpful, actionable
├── Dead code — Unused variables, unreachable branches
├── Magic numbers — Named constants instead
└── Consistency — Follows project conventions
```

**Complexity Metrics to Report**:

```
File: src/services/payment.js
├── Cyclomatic Complexity: 18 (⚠️ High)
├── Cognitive Complexity: 24 (⚠️ Very High)
├── Lines of Code: 420
├── Functions: 12
├── Avg Function Length: 35 lines
├── Max Function Length: 89 lines (processRefund)
├── DRY Score: 0.7 (some duplication)
└── Maintainability Index: 62/100
```

### Pass 5: Architecture Review

Evaluate design decisions and structural integrity.

```
Checks:
├── Module boundaries — Clear separation of concerns
├── Coupling — Loose coupling between components
├── Cohesion — Related functionality grouped together
├── SOLID principles — Single responsibility, open/closed, etc.
├── Dependency direction — Dependencies point inward
├── Abstraction layers — Proper layering (presentation → business → data)
├── Interface contracts — Clear API boundaries
├── Extensibility — Can new features be added easily?
└── Testability — Can components be tested independently?
```

---

## Data Flow Tracing

For critical paths, trace data through the entire system:

```
[User Input]
    │
    ▼
[API Gateway] ── Rate limit check, auth validation
    │
    ▼
[Controller] ── Input parsing, validation
    │
    ▼
[Service Layer] ── Business logic, authorization
    │
    ├──[Cache] ── Hit? Return cached. Miss? Continue.
    │
    ▼
[Repository] ── Data access, query building
    │
    ▼
[Database] ── Execute query, return results
    │
    ▼
[Response] ── Serialize, sanitize, return
```

**At each step, verify**:
- Is input validated?
- Is output sanitized?
- Are errors handled?
- Is logging appropriate?
- Are timeouts configured?

---

## Advanced Techniques (7 Techniques)

### 1. Incremental Diff Review
Review code changes incrementally rather than all at once. Start with the smallest change and build up. This catches issues that a big-bang review misses.

### 2. Semantic Diff Analysis
Go beyond line-by-line diffing. Understand the semantic meaning of changes — what functions were modified, what contracts changed, what callers are affected.

### 3. Static Analysis Integration
Combine manual review with static analysis tools. Use ESLint, SonarQube, Semgrep, or CodeQL to find patterns that humans miss. Report tool findings alongside manual findings.

### 4. Threat Modeling Walkthroughs
For security-critical code, perform a structured STRIDE walkthrough. Enumerate trust boundaries, entry points, and data stores. Map each to potential threats.

### 5. Performance Profiling Review
When reviewing performance-sensitive code, use profiling data to guide the review. Focus on hot paths identified by profilers rather than guessing.

### 6. Call Graph Analysis
Map the call graph for changed functions. Identify all callers and callees. Verify that changes don't break downstream consumers or violate upstream contracts.

### 7. Regression Impact Assessment
For each change, identify what existing behavior might be affected. Cross-reference with test coverage to determine if regression tests exist for affected paths.

---

## Common Patterns (5 Patterns with Code Examples)

### Pattern 1: Guard Clause (Early Return)
```python
# BEFORE: Deeply nested logic
def process_order(order):
    if order is not None:
        if order.is_valid():
            if order.has_stock():
                if order.payment_valid():
                    return complete_order(order)
    return None

# AFTER: Guard clauses
def process_order(order):
    if order is None:
        return None
    if not order.is_valid():
        return None
    if not order.has_stock():
        return None
    if not order.payment_valid():
        return None
    return complete_order(order)
```

### Pattern 2: Strategy Pattern for Configurable Behavior
```python
# BEFORE: Long if-elif chain
def calculate_discount(customer, amount):
    if customer.type == 'regular':
        return amount * 0.05
    elif customer.type == 'premium':
        return amount * 0.10
    elif customer.type == 'vip':
        return amount * 0.20
    else:
        return 0

# AFTER: Strategy pattern
DISCOUNT_STRATEGIES = {
    'regular': lambda amt: amt * 0.05,
    'premium': lambda amt: amt * 0.10,
    'vip': lambda amt: amt * 0.20,
}

def calculate_discount(customer, amount):
    strategy = DISCOUNT_STRATEGIES.get(customer.type, lambda amt: 0)
    return strategy(amount)
```

### Pattern 3: Result Object (Instead of Exceptions for Flow Control)
```python
# BEFORE: Exception-driven flow
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# AFTER: Result object
class Result:
    def __init__(self, value=None, error=None):
        self.value = value
        self.error = error

    @property
    def ok(self):
        return self.error is None

def divide(a, b):
    if b == 0:
        return Result(error="Cannot divide by zero")
    return Result(value=a / b)

result = divide(10, 0)
if result.ok:
    print(result.value)
else:
    print(result.error)
```

### Pattern 4: Configuration Validation at Startup
```python
# BEFORE: Late failure
def get_db_connection():
    return psycopg2.connect(os.environ['DATABASE_URL'])  # Fails at runtime!

# AFTER: Fail-fast configuration
REQUIRED_ENV = ['DATABASE_URL', 'API_KEY', 'SECRET_KEY']

def validate_config():
    missing = [var for var in REQUIRED_ENV if not os.environ.get(var)]
    if missing:
        raise RuntimeError(f"Missing required env vars: {missing}")

# Call at startup
validate_config()
```

### Pattern 5: Immutable Data Structures
```python
# BEFORE: Mutable state prone to side effects
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

user = User("Alice", "alice@example.com")
user.name = "Bob"  # Side effect!

# AFTER: Immutable dataclass
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    name: str
    email: str

user = User("Alice", "alice@example.com")
# user.name = "Bob"  # Raises FrozenInstanceError
new_user = User("Bob", user.email)  # Create new instead
```

---

## Edge Cases & Pitfalls (15 Items)

1. **Off-by-one in loops**: Review `range(len(arr))` — should it be `range(len(arr)-1)`?
2. **Null coalescing misuse**: `value || default` fails when value is `0` or `""` in JS.
3. **Race condition in shared state**: Two requests modifying the same resource simultaneously.
4. **Floating point comparison**: `0.1 + 0.2 !== 0.3` — use epsilon comparison.
5. **Integer overflow**: Large IDs or timestamps exceeding 32-bit int limits.
6. **Encoding issues**: UTF-8 vs ASCII — special characters may break comparisons.
7. **Timezone handling**: Naive datetimes compared across timezones cause silent bugs.
8. **String comparison vs reference**: Comparing objects by reference instead of value.
9. **Cache invalidation**: Stale cache after database updates — what's the TTL strategy?
10. **Error swallowing**: Empty catch blocks that silently hide failures.
11. **Resource leaks**: Unclosed database connections, file handles, or sockets.
12. **N+1 in ORM**: Deferred loading causing unexpected query explosion.
13. **Hardcoded limits**: Magic numbers for pagination, timeouts, or size limits.
14. **Missing rollback**: Database transactions without proper rollback on error.
15. **Silent type coercion**: JavaScript `==` vs `===` causing unexpected truthy/falsy.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **testing** | → Depends on | Identify missing test coverage during review |
| **debugging** | → Feeds into | Issues found may need debugging |
| **refactoring** | → Feeds into | Code smells identified need refactoring |
| **verification** | → Depends on | Verify fixes suggested in review |
| **project-analysis** | ← Provides | Context about codebase structure |
| **documentation** | → Feeds into | Missing docs identified in review |
| **security-audit** | → Feeds into | Security issues escalate to audit |
| **performance-review** | → Feeds into | Performance issues escalate to profiling |

---

## Output Format Templates

### Template 1: Standard Review
```
## Code Review — [PR/Commit/Branch]

**Reviewer**: [name] | **Date**: [date] | **Scope**: [files changed]

### Summary
[1-2 sentence overall assessment]

### Critical Issues (Must Fix Before Merge)
1. **[Issue title]** — `file.py:123`
   - Problem: [description]
   - Fix: [specific fix suggestion]
   - Risk: [what happens if not fixed]

### Major Issues (Should Fix)
1. **[Issue title]** — `file.py:456`
   - Problem: [description]
   - Suggestion: [improvement]

### Minor Issues (Consider Fixing)
1. [Issue] — `file.py:789` — [suggestion]

### Security Issues
1. **[Severity: HIGH]** — [issue] — `file.py:10`
   - STRIDE category: [Spoofing/Tampering/etc.]
   - Fix: [specific remediation]

### Positive Notes
- [What's done well]
- [Good patterns observed]

### Decision: ✅ APPROVE / ⚠️ REQUEST CHANGES / ❌ BLOCK
```

### Template 2: Quick Review (1-5 files)
```
## Quick Review — [files]

| File | Issues | Severity |
|------|--------|----------|
| file.py | 2 | ⚠️ Medium |
| test.py | 0 | ✅ Clean |

### Key Findings
1. [Most important issue]
2. [Second most important]

### Verdict: [APPROVE/CHANGES NEEDED]
```

### Template 3: Deep Security Review
```
## Deep Security Review — [Component]

### STRIDE Analysis
| Threat | Present? | Mitigation | Residual Risk |
|--------|----------|------------|---------------|
| Spoofing | ✅ Yes | JWT validation | Low |
| Tampering | ⚠️ Partial | Input sanitization | Medium |

### Vulnerability Scan Results
| CVE/Issue | Severity | Location | Status |
|-----------|----------|----------|--------|
| SQL Injection | HIGH | api/users.py:42 | Open |

### Recommendations
[Prioritized list of security improvements]
```

### Template 4: Agent-Specific (Structured for Automation)
```json
{
  "review_summary": "Overall assessment text",
  "pass_results": {
    "correctness": {"score": 8, "issues": []},
    "security": {"score": 9, "issues": []},
    "performance": {"score": 7, "issues": []},
    "maintainability": {"score": 8, "issues": []},
    "architecture": {"score": 9, "issues": []}
  },
  "critical_issues": [],
  "major_issues": [],
  "minor_issues": [],
  "security_issues": [],
  "verdict": "APPROVE",
  "complexity_metrics": {
    "avg_cyclomatic": 5,
    "max_cyclomatic": 12,
    "maintainability_index": 75
  }
}
```

---

## Rules (12 Rules)

1. **Always read all code before reviewing** — Never review from memory or assumptions.
2. **Cite file and line number** — Every issue must have a specific location.
3. **Provide fix suggestions** — Don't just complain; suggest solutions.
4. **Prioritize by severity** — Critical > Major > Minor > Nitpick.
5. **Check security by default** — Every review includes a security pass.
6. **Verify correctness first** — Logic bugs trump style issues.
7. **Be constructive** — Frame feedback as improvements, not attacks.
8. **Acknowledge good work** — Include positive notes in every review.
9. **Check for tests** — Missing tests are a major issue.
10. **Review for edge cases** — Null, empty, boundary, concurrent access.
11. **Verify error handling** — Every failure path must be handled.
12. **Never approve without thorough review** — Partial reviews are worse than no review.

---

## Decision Tree

```
What is the review scope?
├── Single file → Focus on local quality, correctness, edge cases
├── Module → Check module boundaries, interfaces, coupling
├── PR/Diff → Review all changes, test coverage, security implications
├── Full codebase → Architecture review, systemic issues
└── Security-critical → Full STRIDE analysis + security template

What review depth?
├── Quick (<100 LOC) → Template 2: Quick Review
├── Standard (100-500 LOC) → Template 1: Standard Review
├── Deep (500+ LOC or security-critical) → Template 3: Deep Review
└── Automated pipeline → Template 4: Agent-Specific
```

---

## Verification

- [ ] All 5 passes completed (correctness, security, performance, maintainability, architecture)
- [ ] All issues have file:line references
- [ ] All issues have fix suggestions
- [ ] Security review completed (STRIDE)
- [ ] Complexity metrics calculated
- [ ] Positive notes included
- [ ] Review template matches scope

## Anti-Patterns

- ❌ Reviewing without reading all code
- ❌ Only pointing out problems, not solutions
- ❌ Ignoring security ("it's an internal tool")
- ❌ Nitpicking style while missing logic bugs
- ❌ Approving without thorough review
- ❌ Reviewing too many files at once (context overload)
- ❌ Rubber-stamping LGTM without analysis
- ❌ Reviewing in a single pass without understanding context
- ❌ Ignoring test coverage gaps
- ❌ Not considering downstream impact of changes
