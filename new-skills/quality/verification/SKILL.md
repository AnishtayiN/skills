---
name: verification
description: >-
  Verify that changes work correctly. Build, test, lint, type-check, and smoke test.
  TRIGGERS: verify, check if it works, does it work, test it, run tests, build, lint,
  type check, smoke test, validate, confirm, validation,
  بررسی کن, آیا کار میکنه, تست کن, بیلد کن, بررسی خروجی, تایید کن,
  验证, 检查, 构建, 测试, 类型检查, 确认
priority: P0
dependencies: []
conflicts: []
---

# Verification Skill

## Purpose

NEVER claim something works without verification. Every significant change MUST be verified through a systematic pipeline: build verification, lint verification, type checking, test verification, manual verification, regression detection, and deployment verification.

## When to Activate

- After any code change
- After debugging (verify fix)
- After code generation
- Before claiming "done"
- User asks "does it work?"
- Before deployment
- After refactoring
- After dependency updates
- 验证 (verify), 检查 (check), 确认 (confirm)
- بررسی کن (check it), تایید کن (confirm it)

## When NOT to Activate

- Reading code (no changes made)
- Planning (no code changed)
- Discussion only

## Inputs Required

- What was changed (files, modules, features)
- Available verification methods (build system, test framework, linter)
- Verification depth (quick / standard / comprehensive)

## Preconditions

- Code changes are accessible
- Build/test tooling is configured

---

## Workflow: Verification Pipeline

### Step 1: Determine Available Verification Methods

```
Available methods (use what's applicable):
├── Build/Compile → Does it compile?
├── Lint → Does it pass linting?
├── Type Check → Do types check?
├── Unit Tests → Do unit tests pass?
├── Integration Tests → Do integration tests pass?
├── E2E Tests → Do E2E tests pass?
├── Manual Test → Can you manually verify?
├── Smoke Test → Does basic functionality work?
├── Security Scan → Any known vulnerabilities?
└── Performance Check → Any regressions?
```

### Step 2: Run Verification (Cheapest First)

```
Order (cheapest → most expensive):
1. Syntax check / compile (< 5s)
2. Lint (< 10s)
3. Type check (< 30s)
4. Unit tests (< 60s)
5. Integration tests (< 5min)
6. E2E tests (< 15min)
7. Manual verification (when automated not possible)
```

**Stop at first failure** — fix and re-run from step 1.

### Step 3: Report Results

```
## Verification Results

### Build: ✅ PASS / ❌ FAIL
[details]

### Lint: ✅ PASS / ❌ FAIL
[details]

### Type Check: ✅ PASS / ❌ FAIL
[details]

### Tests: ✅ PASS / ❌ FAIL
[details]

### Manual Verification: ✅ PASS / ❌ FAIL
[details]
```

---

## Verification Checklist (Detailed)

### After Debugging
```
- [ ] Original bug is fixed (reproduce original scenario)
- [ ] No regressions (run full test suite)
- [ ] Edge cases handled (boundary values, null inputs)
- [ ] Error messages are helpful
- [ ] Fix doesn't introduce new bugs
- [ ] Performance not degraded
```

### After Code Generation
```
- [ ] Code compiles / transpiles without errors
- [ ] No lint warnings or errors
- [ ] Type checks pass (if typed language)
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Works as expected (manual verification)
- [ ] No security issues introduced
- [ ] Documentation updated if needed
```

### After Refactoring
```
- [ ] All existing tests pass
- [ ] Behavior is unchanged (same inputs → same outputs)
- [ ] No new warnings
- [ ] Performance not degraded
- [ ] Code coverage not decreased
- [ ] Public API unchanged (or version bumped)
```

### Before Deployment
```
- [ ] All verification stages pass
- [ ] No uncommitted changes
- [ ] Version / changelog updated
- [ ] Environment variables configured
- [ ] Database migrations tested
- [ ] Rollback plan documented
```

---

## Build Verification

### What to Check
```
Build verification ensures code compiles/transpiles correctly.

Checks:
├── Compilation errors — Syntax, type, import errors
├── Linking errors — Missing dependencies, circular imports
├── Resource errors — Missing assets, templates, configs
├── Dependency errors — Version conflicts, missing packages
└── Build output — Correct artifacts generated
```

### Build Commands by Language
```
JavaScript/TypeScript: npm run build / yarn build
Python: python -m py_compile file.py
Go: go build ./...
Rust: cargo build
Java: mvn compile / gradle build
C#: dotnet build
```

### Common Build Failures
```
1. Missing import → Add import statement
2. Type mismatch → Fix type annotation or cast
3. Circular dependency → Restructure imports
4. Missing dependency → npm install / pip install
5. Version conflict → Update dependency versions
```

---

## Lint Verification

### What to Check
```
Lint verification ensures code follows style and quality rules.

Checks:
├── Style violations — Formatting, naming conventions
├── Code quality — Complexity, duplication, dead code
├── Best practices — Common mistakes, anti-patterns
├── Security patterns — Known vulnerability patterns
└── Import organization — Sorting, grouping, unused imports
```

### Lint Commands by Language
```
JavaScript/TypeScript: npx eslint src/ --fix
Python: flake8 / ruff check / pylint
Go: golangci-lint run
Rust: cargo clippy
Java: checkstyle / spotbugs
C#: dotnet format
```

### Lint Severity Levels
```
├── Error → Must fix (blocks merge)
├── Warning → Should fix (technical debt)
├── Info → Consider fixing (style preferences)
└── Hint → Optional improvements
```

---

## Type Check Verification

### What to Check
```
Type check verification ensures type safety.

Checks:
├── Type errors — Wrong types, missing types
├── Null safety — Nullable types handled
├── Generic constraints — Type parameters valid
├── Inheritance — Correct override signatures
└── Type inference — Compiler inference matches intent
```

### Type Check Commands
```
TypeScript: npx tsc --noEmit
Python: mypy src/ / pyright
Go: go vet ./...
Rust: cargo check
Java: N/A (compiled)
C#: dotnet build (inherently type-checked)
```

### Type Check Strictness
```
Level 1: Basic — No obvious type errors
Level 2: Strict — No implicit any, strict null checks
Level 3: Very Strict — No unchecked indexed access, exact optional properties
```

---

## Test Verification

### Test Execution Order
```
1. Unit tests (fastest, most isolated)
2. Integration tests (module interactions)
3. Contract tests (API compatibility)
4. E2E tests (user workflows)
5. Performance tests (regression detection)
```

### Test Result Interpretation
```
All pass → ✅ Continue to next verification stage
Some fail → ❌ Fix failures, re-run from step 1
Flaky test → ⚠️ Re-run individually, investigate if persistent
Timeout → 🔍 Investigate performance or deadlock
```

---

## Manual Verification

### When Manual Verification Is Needed
```
Use when:
├── Automated tests can't cover the scenario
├── UI/UX changes need human judgment
├── Performance feels wrong (subjective)
├── Edge cases only observable in real environment
└── Security-sensitive changes need human review
```

### Manual Verification Checklist
```
1. Start from clean state
2. Follow the exact user workflow
3. Verify each step visually
4. Check error messages are helpful
5. Verify responsiveness (if UI)
6. Check accessibility (if UI)
7. Document what you tested
8. Note any issues found
```

---

## Regression Detection

### What Is Regression?
A regression is when a change breaks existing functionality that was previously working.

### Regression Detection Strategies
```
├── Test suite — Run all existing tests after changes
├── Diff analysis — Review what changed vs. what might break
├── Call graph — Identify affected callers of changed functions
├── Coverage comparison — Ensure coverage doesn't decrease
└── Performance benchmarks — Compare before/after metrics
```

### Regression Prevention
```
1. Write regression tests for every bug fix
2. Maintain comprehensive test suite
3. Run tests on every PR (CI/CD)
4. Monitor production metrics
5. Use feature flags for risky changes
```

### Regression Test Pattern
```python
def test_regression_1234_login_with_special_characters():
    """Regression: Login failed when password contained @#$ characters.
    Bug #1234, fixed 2024-01-15."""
    result = login("user@example.com", "p@ss#123")
    assert result.success is True
```

---

## Deployment Verification

### Pre-Deployment Checks
```
1. All verification stages pass locally
2. CI/CD pipeline passes
3. No uncommitted changes
4. Version bumped (if applicable)
5. Changelog updated
6. Database migrations tested
7. Environment variables documented
8. Rollback plan prepared
```

### Post-Deployment Checks
```
1. Health check endpoint responds
2. Core functionality works (smoke test)
3. No error spike in logs
4. Performance metrics normal
5. Database connections healthy
6. External service connections healthy
```

### Deployment Verification Commands
```bash
# Health check
curl -f https://app.example.com/health || exit 1

# Smoke test
curl -f https://app.example.com/api/status || exit 1

# Check logs for errors
tail -100 /var/log/app.log | grep -i error

# Check process is running
pgrep -f "my-app" || exit 1
```

---

## Common Patterns (5 Patterns with Code Examples)

### Pattern 1: Verification Pipeline Script
```bash
#!/bin/bash
# verification-pipeline.sh — Run all verification stages in order
set -e

echo "=== Stage 1: Build ==="
npm run build

echo "=== Stage 2: Lint ==="
npx eslint src/ --max-warnings 0

echo "=== Stage 3: Type Check ==="
npx tsc --noEmit

echo "=== Stage 4: Unit Tests ==="
npm run test:unit -- --coverage

echo "=== Stage 5: Integration Tests ==="
npm run test:integration

echo "=== All verification stages passed ==="
```

### Pattern 2: Verification Result Aggregator
```python
class VerificationResult:
    def __init__(self):
        self.stages = []

    def add_stage(self, name, passed, details="", duration_ms=0):
        self.stages.append({
            "name": name,
            "passed": passed,
            "details": details,
            "duration_ms": duration_ms,
        })

    @property
    def all_passed(self):
        return all(s["passed"] for s in self.stages)

    @property
    def total_duration_ms(self):
        return sum(s["duration_ms"] for s in self.stages)

    def summary(self):
        lines = [f"Verification: {'PASS' if self.all_passed else 'FAIL'}"]
        for stage in self.stages:
            icon = "✅" if stage["passed"] else "❌"
            lines.append(f"  {icon} {stage['name']} ({stage['duration_ms']}ms)")
            if stage["details"] and not stage["passed"]:
                lines.append(f"     {stage['details']}")
        lines.append(f"  Total: {self.total_duration_ms}ms")
        return "\n".join(lines)

# Usage
result = VerificationResult()
result.add_stage("build", build_succeeded, duration_ms=4200)
result.add_stage("lint", lint_passed, details=lint_output, duration_ms=1800)
result.add_stage("tests", tests_passed, details=test_output, duration_ms=12400)
print(result.summary())
```

### Pattern 3: Post-Fix Verification Checklist
```python
def verify_fix(fix_description, changed_files, test_command):
    """Systematic verification after a bug fix."""
    result = VerificationResult()

    # 1. Build check
    build_ok = run_command("npm run build")
    result.add_stage("build", build_ok)

    # 2. Lint check
    lint_ok = run_command("npx eslint " + " ".join(changed_files))
    result.add_stage("lint", lint_ok)

    # 3. Type check
    type_ok = run_command("npx tsc --noEmit")
    result.add_stage("type_check", type_ok)

    # 4. Full test suite (regression check)
    tests_ok = run_command(test_command)
    result.add_stage("full_test_suite", tests_ok)

    # 5. Specific regression test
    regression_ok = run_command(f"npm test -- --grep '{fix_description}'")
    result.add_stage("regression_test", regression_ok)

    return result
```

### Pattern 4: Deployment Verification Script
```python
import requests
import time

def verify_deployment(base_url, timeout=60):
    """Post-deployment verification checks."""
    checks = []

    # Health check
    try:
        r = requests.get(f"{base_url}/health", timeout=5)
        checks.append(("health", r.status_code == 200))
    except Exception as e:
        checks.append(("health", False))

    # Smoke test — core endpoint
    try:
        r = requests.get(f"{base_url}/api/status", timeout=5)
        checks.append(("smoke_test", r.status_code == 200))
    except Exception as e:
        checks.append(("smoke_test", False))

    # Database connectivity
    try:
        r = requests.get(f"{base_url}/health/db", timeout=5)
        checks.append(("database", r.status_code == 200))
    except Exception as e:
        checks.append(("database", False))

    all_ok = all(ok for _, ok in checks)
    return {"passed": all_ok, "checks": checks}
```

### Pattern 5: Verification Caching (Only Verify What Changed)
```python
import hashlib
import os

class VerificationCache:
    def __init__(self, cache_file=".verification-cache.json"):
        self.cache_file = cache_file
        self.cache = self._load()

    def _file_hash(self, filepath):
        with open(filepath, "rb") as f:
            return hashlib.md5(f.read()).hexdigest()

    def needs_verification(self, filepath):
        current_hash = self._file_hash(filepath)
        cached_hash = self.cache.get(filepath)
        return current_hash != cached_hash

    def mark_verified(self, filepath):
        self.cache[filepath] = self._file_hash(filepath)
        self._save()

    def get_changed_files(self, file_list):
        return [f for f in file_list if self.needs_verification(f)]

# Usage — only verify changed files
cache = VerificationCache()
changed = cache.get_changed_files(all_source_files)
if not changed:
    print("No changes detected — skipping verification")
else:
    print(f"Verifying {len(changed)} changed files...")
    # Run verification on changed files
    for f in changed:
        verify_file(f)
        cache.mark_verified(f)
```

---

## Advanced Techniques (7 Techniques)

### 1. Progressive Verification
Start with the cheapest checks and escalate only when cheaper checks pass. This saves time by catching obvious issues early.

### 2. Parallel Verification
Run independent verification stages concurrently. Lint, type-check, and unit tests can often run in parallel.

### 3. Verification Caching
Cache verification results for unchanged files. Tools like `nx affected`, `turborepo`, or `vitest --changed` only verify what changed.

### 4. Snapshot Verification
For generated outputs (build artifacts, API responses), use snapshot testing to detect unexpected changes.

### 5. Contract Verification
Verify API contracts between services without running the full system. Use consumer-driven contracts.

### 6. Visual Verification
For UI changes, use visual regression testing (screenshot comparison) to detect unintended visual changes.

### 7. Canary Verification
After deployment, gradually route traffic to the new version while monitoring for errors. Roll back automatically if error rate exceeds threshold.

---

## Edge Cases & Pitfalls (15 Items)

1. **"It works on my machine"**: Local environment differs from CI/CD. Always verify in a clean environment.
2. **Environment-dependent tests**: Tests that pass locally but fail in CI due to different env vars, paths, or permissions.
3. **Test order dependency**: Tests that pass individually but fail when run together due to shared state.
4. **Timing-dependent verification**: Flaky tests due to race conditions or timeout assumptions.
5. **Stale verification**: Verification passing because tests are outdated and don't test current behavior.
6. **Verification debt**: Skipping verification "just this once" — builds up into untested code.
7. **False positive**: Verification passing but bug still exists (inadequate tests).
8. **False negative**: Verification failing but no actual bug (flaky test, environment issue).
9. **Incomplete verification**: Verifying only changed files without checking affected callers.
10. **Verification fatigue**: Too many slow or flaky tests cause developers to skip verification.
11. **Missing rollback verification**: Deploying without verifying rollback works.
12. **Database migration not verified**: Schema changes work on fresh DB but not on production data.
13. **Dependency update not verified**: New dependency versions introduce subtle behavior changes.
14. **Cross-platform verification**: Code works on Linux but fails on macOS/Windows.
15. **Verification of verification**: Not verifying that the verification tools themselves are working correctly.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **debugging** | ← Feeds into | Verify fixes work |
| **code-generation** | ← Feeds into | Verify new code works |
| **refactoring** | ← Feeds into | Verify behavior unchanged |
| **testing** | ← Depends on | Tests are the core of verification |
| **code-review** | ← Feeds into | Verification is part of review |
| **deployment** | → Feeds into | Verify before and after deployment |
| **performance** | → Feeds into | Performance verification |

---

## Output Format Templates

### Template 1: Standard Verification Report
```
## Verification Report — [Feature/Branch]

### Pipeline Results
| Stage | Status | Duration | Details |
|-------|--------|----------|---------|
| Build | ✅ PASS | 4.2s | No errors |
| Lint | ✅ PASS | 1.8s | 0 errors, 2 warnings |
| Type Check | ✅ PASS | 3.1s | No errors |
| Unit Tests | ✅ PASS | 12.4s | 42/42 passed |
| Integration | ✅ PASS | 45.2s | 8/8 passed |
| E2E | ⚠️ SKIP | - | Not configured |

### Coverage
- Statements: 85% (↑2%)
- Branches: 78% (↑1%)

### Summary
✅ All applicable verification stages passed.
```

### Template 2: Quick Verification
```
## Quick Verification

**Build**: ✅ | **Lint**: ✅ | **Tests**: ✅ (42 passed, 0 failed)
**Time**: 18.5s

All checks passed. Ready for review.
```

### Template 3: Deep Verification
```
## Deep Verification — [Feature]

### Build Verification
- TypeScript compilation: ✅ 0 errors
- Bundle size: 245KB (↓5KB from previous)

### Lint Verification
- ESLint: ✅ 0 errors, 2 warnings
- Prettier: ✅ All files formatted

### Type Check
- Strict mode: ✅ 0 errors
- Null safety: ✅ All nullable types handled

### Test Verification
- Unit: ✅ 42/42 (12.4s)
- Integration: ✅ 8/8 (45.2s)
- E2E: ✅ 5/5 (2m 15s)

### Regression Detection
- Changed files: 12
- Affected tests: 15
- New tests needed: 0
- Coverage delta: +2%

### Performance Verification
- Build time: 4.2s (no regression)
- Test suite: 3m 12s (no regression)
- Bundle size: 245KB (↓5KB improvement)
```

### Template 4: Agent-Specific (Structured for Automation)
```json
{
  "verification_summary": "PASS",
  "stages": {
    "build": {"status": "PASS", "duration_ms": 4200},
    "lint": {"status": "PASS", "duration_ms": 1800, "errors": 0, "warnings": 2},
    "type_check": {"status": "PASS", "duration_ms": 3100},
    "unit_tests": {"status": "PASS", "duration_ms": 12400, "total": 42, "passed": 42},
    "integration_tests": {"status": "PASS", "duration_ms": 45200, "total": 8, "passed": 8},
    "e2e_tests": {"status": "SKIP"}
  },
  "coverage": {"statements": 85, "branches": 78, "functions": 90, "lines": 83},
  "regression": {"changed_files": 12, "affected_tests": 15, "new_failures": 0},
  "ready_for_review": true
}
```

---

## Rules (12 Rules)

1. **NEVER claim success without verification** — "I think it works" is not verification.
2. **ALWAYS run the cheapest checks first** — Compile before testing, lint before running full suite.
3. **ALWAYS re-verify after fixing failures** — Fix one thing, re-run the entire pipeline.
4. **STOP at first failure** — Don't continue checking other stages when one fails.
5. **Verify in clean environment** — Don't rely on local state; use CI/CD or clean containers.
6. **Verify affected code, not just changed code** — Check callers and dependents of changed functions.
7. **Never skip verification to save time** — Technical debt from skipped verification compounds.
8. **Document verification results** — Record what was verified, when, and the outcome.
9. **Verify before AND after deployment** — Pre-deploy checks and post-deploy health checks.
10. **Automate what you can** — Manual verification is a last resort, not a default.
11. **Verify edge cases** — Don't just test the happy path; verify error conditions too.
12. **Track verification metrics** — Monitor pass rates, flakiness, and coverage trends over time.

---

## Decision Tree

```
What was changed?
├── Single function → Build + Lint + Unit tests
├── Module → Build + Lint + Type check + Unit + Integration tests
├── API endpoint → Build + Lint + Type check + Unit + Integration + Contract tests
├── UI component → Build + Lint + Type check + Unit + Visual regression
├── Database migration → Build + Migration test + Integration tests
├── Full feature → All stages + E2E tests + Manual verification
└── Dependency update → Build + Full test suite + Performance check

Verification depth?
├── Quick (< 1 min) → Build + Lint
├── Standard (< 5 min) → Build + Lint + Type check + Unit tests
├── Comprehensive (< 30 min) → All stages
└── Pre-deployment → All stages + Manual verification + Performance check
```

---

## Verification

- [ ] All applicable verification stages completed
- [ ] No failures in any stage
- [ ] Coverage meets minimum threshold
- [ ] No regressions detected
- [ ] Results documented

## Anti-Patterns

- ❌ "I think it works" (without testing)
- ❌ "It should work" (without verification)
- ❌ Skipping verification to save time
- ❌ Ignoring test failures
- ❌ Only checking one thing
- ❌ Verifying only in local environment
- ❌ Not re-verifying after fixes
- ❌ Claiming "done" without running tests
- ❌ Running only unit tests for critical changes
- ❌ Not verifying error handling paths
- ❌ Skipping deployment verification
- ❌ Not monitoring after deployment
