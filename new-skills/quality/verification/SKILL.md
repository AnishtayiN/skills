---
name: verification
description: >-
  Verify that changes work correctly. Build, test, lint, type-check, and smoke test.
  TRIGGERS: verify, check if it works, does it work, test it, run tests, build, lint,
  type check, smoke test, validate, confirm, validation,
  بررسی کن, آیا کار میکنه, تست کن, بیلد کن, بررسی خروجی, تایید کن
priority: P0
dependencies: []
conflicts: []
---

# Verification Skill

## Purpose

NEVER claim something works without verification. Every significant change MUST be verified.

## When to Activate

- After any code change
- After debugging (verify fix)
- After code generation
- Before claiming "done"
- User asks "does it work?"

## When NOT to Activate

- Reading code (no changes made)
- Planning (no code changed)

## Inputs Required

- What was changed
- Available verification methods

## Workflow

### Step 1: Determine Verification Methods

```
Available methods (use what's applicable):
├── Build/Compile → Does it compile?
├── Lint → Does it pass linting?
├── Type Check → Do types check?
├── Unit Tests → Do unit tests pass?
├── Integration Tests → Do integration tests pass?
├── E2E Tests → Do E2E tests pass?
├── Manual Test → Can you manually verify?
└── Smoke Test → Does basic functionality work?
```

### Step 2: Run Verification

```
1. Start with cheapest/fastest checks
2. Progress to more comprehensive checks
3. Stop at first failure
4. Fix the failure
5. Re-run from step 1
```

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

## Verification Checklist

```
After debugging:
- [ ] Original bug is fixed
- [ ] No regressions
- [ ] Edge cases handled

After code generation:
- [ ] Code compiles
- [ ] No lint errors
- [ ] Tests pass
- [ ] Works as expected

After refactoring:
- [ ] All tests pass
- [ ] Behavior unchanged
- [ ] No new warnings
```

## Execution Rules

- NEVER claim success without verification
- ALWAYS run the cheapest checks first
- ALWAYS re-verify after fixing failures
- STOP at first failure — don't continue

## Safety Constraints

- Do NOT claim "it should work" — VERIFY it works
- Do NOT skip verification to save time
- Do NOT ignore test failures

## Anti-Patterns

- ❌ "I think it works" (without testing)
- ❌ "It should work" (without verification)
- ❌ Skipping verification to save time
- ❌ Ignoring test failures
- ❌ Only checking one thing

## Skill Interactions

- ← debugging: Verify fix works
- ← code-generation: Verify new code works
- ← refactoring: Verify behavior unchanged
- → All skills: Verification is the final step
