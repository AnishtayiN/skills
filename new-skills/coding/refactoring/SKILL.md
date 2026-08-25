---
name: refactoring
description: >-
  Improve code structure without changing behavior. Extract, rename, move, simplify, optimize.
  TRIGGERS: refactor, cleanup, clean up, simplify, restructure, reorganize, extract, rename,
  move function, split file, code smell, technical debt, duplication, complexity,
  بازسازی کد, تمیز کردن, ساده‌سازی, بازآرایی, حذف تکرار, کاهش پیچیدگی
priority: P2
dependencies: [project-analysis, code-review, testing]
conflicts: [debugging]
---

# Refactoring Skill

## Purpose

Improve code structure, readability, and maintainability WITHOUT changing behavior.

## When to Activate

- Code works but is hard to maintain
- User asks to clean up or simplify code
- Code smells detected (duplication, complexity, long functions)
- After debugging (prevent future bugs)

## When NOT to Activate

- Code has bugs (→ debugging first)
- User wants new features (→ code-generation)
- Code is already clean

## Inputs Required

- Code to refactor
- What to improve (readability, performance, structure)
- Constraints (must maintain API compatibility)

## Preconditions

- Code is working (all tests pass)
- Understanding of current behavior

## Workflow

### Step 1: Ensure Safety Net

```
1. Are there tests for this code?
   ├── YES → Run them, ensure they pass
   └── NO → Write characterization tests FIRST
2. Document current behavior
3. Set up a way to verify nothing changed
```

### Step 2: Identify Smells

```
Common code smells:
- Long functions (> 30 lines)
- Deep nesting (> 3 levels)
- Code duplication
- Long parameter lists (> 3 params)
- God classes (doing too much)
- Feature envy (using other class's data)
- Primitive obsession (using primitives for complex concepts)
```

### Step 3: Apply Refactoring

```
Safe refactorings:
1. Extract Function → Break long functions
2. Extract Class → Split god classes
3. Rename → Improve naming
4. Move → Better organization
5. Inline → Remove unnecessary indirection
6. Replace with clearer alternative
7. Simplify conditionals
8. Remove duplication
```

### Step 4: Verify Behavior Unchanged

```
1. Run all tests — must pass
2. Compare before/after behavior
3. Check API compatibility
4. Verify no performance regression
```

## Decision Tree

```
What kind of refactoring?
├── Readability → Extract functions, rename, simplify
├── Structure → Extract classes, move, reorganize
├── Duplication → Extract shared code
├── Performance → Optimize hot paths (only if measured)
└── Maintainability → Reduce complexity, add docs
```

## Execution Rules

- ALWAYS have tests before refactoring
- ALWAYS verify behavior unchanged
- ALWAYS make small incremental changes
- NEVER refactor and add features simultaneously
- NEVER refactor code you don't understand
- NEVER skip verification

## Verification

- [ ] All tests pass before AND after
- [ ] Behavior is identical
- [ ] Code is more readable
- [ ] No new code smells introduced
- [ ] API compatibility maintained

## Safety Constraints

- Do NOT refactor without tests
- Do NOT change public API without approval
- Do NOT refactor and fix bugs in same change
- Do NOT refactor code you don't understand

## Anti-Patterns

- ❌ Refactoring without tests
- ❌ Refactoring and adding features together
- ❌ Changing more than necessary
- ❌ "Improving" code that works fine
- ❌ Refactoring for the sake of refactoring

## Skill Interactions

- ← code-review: Identifies what to refactor
- ← testing: Provides safety net
- → verification: Verify behavior unchanged
- → code-review: Review refactored code
