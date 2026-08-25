---
name: refactor
description: >-
  Refactor, rewrite, and clean up code without changing its external behavior — improving readability, structure, performance, and maintainability. Use this skill when the user asks to refactor code, بازنویسی کد, clean up this code, improve code structure, reorganize this code, make this cleaner, simplify this code, reduce complexity, extract function, DRY this code, too many lines, this is messy, refactor this module, improve readability, reduce duplication, کد تمیزتر, ساده‌سازی کد, بهبود ساختار کد, حذف کد تکراری, بازنویسی و بهینه‌سازی, make this more maintainable, extract method, simplify conditional, reduce nesting, too many parameters, god class, long method, feature envy, primitive obsession, shotgun surgery, scattered coupling, rename for clarity, apply design pattern, SOLID refactor, improve testability, decouple this, make this async, convert to functional style, reduce cyclomatic complexity, flatten nested if, eliminate code smell, 重构代码, 代码清理, 简化代码, 消除重复, 代码优化, 提高可读性.
---

# Refactor Skill

## Overview

This skill restructures existing code to improve its internal quality while preserving its external behavior. Refactoring is not rewriting from scratch — it is a series of small, safe transformations that make code easier to read, modify, and extend.

The golden rule of refactoring: behavior must not change. If the output changes, it's not a refactoring — it's a behavior change that happens to also restructure code. Behavior changes must be flagged explicitly to the user.

## When to Use This Skill

- User asks to refactor, clean up, or restructure code
- Code is hard to read or modify despite working correctly
- User mentions too much duplication, long functions, or messy code
- User wants better performance without changing behavior
- User asks to apply design patterns or SOLID principles to existing code
- User wants to improve testability of existing code
- User wants to reduce complexity or cognitive load of a module
- User asks to decouple modules, extract interfaces, or improve abstractions
- User wants to modernize code (e.g., convert callbacks to async/await)
- User mentions specific code smells: god class, long method, feature envy, etc.

## Refactoring Workflow

### Step 1: Read and Understand

1. Read all relevant files using the Read tool.
2. Identify the language, framework, and project conventions.
3. Understand what the code does before changing anything.
4. If tests exist, read them to understand expected behavior.
5. Check for callers of the code being refactored — changes may affect them.
6. Note any framework-specific patterns the codebase follows.

### Step 2: Identify Smells and Target Areas

Scan for common code smells:

- **Long methods/functions** (> 30 lines) — extract sub-functions
- **Deep nesting** (> 3 levels) — use early returns, guard clauses
- **Duplicated logic** — extract to shared function or module
- **Large classes/files** — split by responsibility
- **Magic numbers/strings** — extract to named constants
- **God objects** — separate concerns into distinct classes
- **Feature envy** — move methods closer to the data they use
- **Primitive obsession** — use value objects or types
- **Dead code** — remove unreachable or unused code
- **Complex conditionals** — replace with polymorphism, strategy, or named booleans
- **Shotgun surgery** — one change requires edits in many files (signal of poor cohesion)
- **Divergent change** — one class changed for many reasons (signal of mixed responsibilities)
- **Comments describing what** — if a comment is needed to explain what code does, the code can be clearer
- **Long parameter lists** (> 3 params) — introduce parameter object or builder
- **Inappropriate intimacy** — two classes accessing each other's private parts
- **Refused bequest** — subclass doesn't use most inherited methods

### Step 3: Plan the Refactoring

Before making any changes:

1. List the specific refactorings you will perform, in order.
2. Each refactoring should be small and independently safe.
3. Order matters: extract first, then rename, then restructure.
4. If the refactoring is large, break it into phases and confirm with the user before proceeding.
5. Estimate risk for each step and identify verification points.

### Step 4: Apply Refactorings

Apply changes using the Edit or MultiEdit tool. Follow these principles:

- **Preserve behavior** — every change must be behavior-preserving. If you need to change behavior, tell the user explicitly.
- **Small steps** — one logical change per edit when possible.
- **No new features** — do not add functionality the user didn't ask for.
- **Consistent style** — match the existing codebase conventions.
- **Update callers** — if you rename or move something, update all call sites.
- **Preserve imports** — if you move a function to a new file, update import statements.

### Step 5: Summarize Changes

## Advanced Techniques

### Composed Method
Transform a long function into a series of well-named sub-function calls that read like a story:
```
// Before: 50-line function with comments separating sections
// After: 5-line function calling 5 well-named methods
processOrder() {
    validateOrder();
    calculateTotals();
    applyDiscounts();
    reserveInventory();
    sendConfirmation();
}
```

### Replace Conditional with Polymorphism
When a type-switch or if-else chain dispatches on an object's type, use polymorphism:
```
// Before: if (type === 'email') ... else if (type === 'sms') ... else if (type === 'push') ...
// After: notification.send() where EmailNotification, SmsNotification, PushNotification each implement send()
```

### Introduce Parameter Object
When multiple functions share the same group of parameters, bundle them:
```
// Before: function createUser(name, email, age, address, phone, preferences)
// After:  function createUser(CreateUserRequest request)
```

### Replace Loop with Pipeline
Transform imperative loops into functional pipelines for clarity:
```
// Before: for loop with manual filtering, mapping, accumulating
// After: data.filter(...).map(...).reduce(...)
```

### Extract Strategy
When an algorithm has interchangeable parts, extract the varying part into a strategy:
```
// Before: sorting logic with different comparison functions embedded
// After: sorter.sort(data, new PriceComparator())
```

### Preserve Object Immutability
Convert mutable operations to immutable ones to reduce side-effect bugs:
```
// Before: items.push(newItem); return items;
// After: return [...items, newItem];
```

### Flatten Deep Nesting
Use guard clauses and early returns to reduce indentation:
```
// Before: if (user) { if (user.isActive) { if (user.hasPermission) { ... } } }
// After:
if (!user) return;
if (!user.isActive) return;
if (!user.hasPermission) return;
...
```

## Common Patterns

### Pattern 1: The 80-Line Function
A function that tries to do everything — validate, process, format, and persist.
```
// Symptom: function with 5+ comment headers marking sections
// Refactor: extract each section into its own function with a descriptive name
```

### Pattern 2: The Copy-Paste Class
Two or more classes with nearly identical methods, differing only in details.
```
// Symptom: making a change requires editing both files identically
// Refactor: extract shared logic to a base class or composition, parameterize the differences
```

### Pattern 3: The Configuration Object Sprawl
A function takes 8+ parameters, half of which are optional with defaults.
```
// Symptom: function(a, b, c, d, e, f, g, h) where most callers pass the same values
// Refactor: introduce an options/config object with sensible defaults
```

### Pattern 4: The Switch Statement That Grows
A switch/if-else chain that gets a new case every feature cycle.
```
// Symptom: PR adds another case to an already 10-case switch
// Refactor: use a registry/map pattern or polymorphism so new cases don't require modifying this code
```

### Pattern 5: The Tangled Helper
Utility functions scattered across files, inconsistently named, some duplicated.
```
// Symptom: similar functions in 3 different files with slightly different names
// Refactor: consolidate into a shared utils module with consistent naming
```

## Edge Cases & Pitfalls

1. **Changing behavior accidentally** — Even "obviously safe" renames can change behavior in dynamic languages (e.g., Python's `__getattr__`, Ruby's `method_missing`). Verify after each step.
2. **Refactoring without tests** — If no tests exist, behavior preservation cannot be verified. Flag this risk to the user. Suggest writing tests first.
3. **Over-refactoring** — Not every piece of code needs to be a pattern showcase. Simple code is good code. Stop refactoring when the code is clear.
4. **Breaking the build** — If you rename a public symbol, all callers must be updated. Search the codebase before and after.
5. **Framework-specific constraints** — Some frameworks require specific patterns (e.g., React component naming, Spring bean annotations). Don't refactor away framework requirements.
6. **Premature abstraction** — Don't extract a function that's only called once unless it significantly improves readability. "Rule of three" — abstract after the third duplication.
7. **Ignoring performance implications** — Some refactorings improve readability but hurt performance (e.g., creating many small objects). Note trade-offs.
8. **Changing the public API** — If the code is a library or shared module, renaming parameters or changing types is a breaking change. Flag this.
9. **Large-bang refactoring** — Rewriting an entire module at once is risky. Do it incrementally, verifying at each step.
10. **Refactoring to impress** — Don't add design patterns just to use them. The goal is clarity, not showing off patterns knowledge.
11. **Not updating comments and docs** — Refactored code often has stale comments referring to old structure. Update or remove them.
12. **Ignoring error handling during extraction** — When extracting functions, ensure error handling follows the extracted logic, not the original location.

## Integration with Other Skills

- **test-generation**: Before refactoring, generate tests to lock in current behavior. After refactoring, run tests to verify no regressions.
- **code-review**: After refactoring, a code review can verify the new structure is clean and no issues were introduced.
- **debug**: If a refactoring introduces unexpected behavior changes, use the debug skill to diagnose.
- **explain-code**: If the refactored code is complex, use explain-code to document how the new structure works.
- **clean-architecture**: If refactoring involves restructuring modules or layers, use clean-architecture for guidance on proper dependency direction.
- **api-design**: If refactoring API endpoints, ensure the refactored code maintains the same API contract.
- **documentation**: After significant refactoring, documentation may need updating to reflect the new structure.

## Output Format

### Standard Refactoring Summary Template

```
## Refactoring Summary

**File(s):** [files modified]
**Refactorings Applied:**
1. [Refactoring name] — [brief description of what changed and why]
2. ...

### Before (key example)
```lang
// original problematic code
```

### After (key example)
```lang
// refactored code
```

### Impact
- Lines changed: [approximate count]
- Behavior preserved: Yes/No (with explanation if No)
- Risk level: Low/Medium/High
- Files affected: [list all files that were modified]
```

### Large Refactoring Plan Template

```
## Refactoring Plan

**Scope:** [what will be refactored]
**Estimated phases:** [number]
**Tests:** [existing coverage status]

### Phase 1: [Name]
- **Goal:** [what this phase achieves]
- **Changes:** [specific refactorings]
- **Risk:** [Low/Medium/High]
- **Verification:** [how to verify behavior is preserved]

### Phase 2: [Name]
...

### Overall Impact
- [What the codebase will look like after all phases]
- [Potential risks and mitigations]
```

### Quick Refactor Template (for simple cases)

```
**Refactoring:** [name]
**File:** [path]
**Change:** [one-line description]
```diff
- [before]
+ [after]
```
```

## Refactoring Catalog

### Structural Refactorings
| Refactoring | When to Apply | Risk |
|-------------|--------------|------|
| Extract Method | Long function with a cohesive block of code | Low |
| Extract Class | Part of a class has its own responsibility | Low |
| Inline Method | Method body is no more complex than the name | Low |
| Move Method/Field | Feature envy — method uses another class's data more | Medium |
| Rename | Name doesn't reveal intent | Low |
| Replace Magic Number | Unexplained literal value | Low |

### Composing Methods
| Refactoring | When to Apply | Risk |
|-------------|--------------|------|
| Decompose Conditional | Complex if/else with nested conditions | Low |
| Replace Conditional with Polymorphism | Type-based dispatch on an object | Medium |
| Introduce Null Object | Repeated null checks scattered through code | Low |
| Replace Loop with Collection Pipeline | Imperative loop doing filter/map/reduce | Low |

### Organizing Data
| Refactoring | When to Apply | Risk |
|-------------|--------------|------|
| Encapsulate Field | Public field that should be protected | Low |
| Replace Type Code with Class/Enum | Magic string/integer representing a type | Low |
| Replace Array with Object | Array where elements have different meanings | Medium |
| Change Value to Reference | Duplicate data that should be a single object | Medium |

## Rules

- Never change behavior unless the user explicitly asks for it. If a refactoring incidentally fixes a bug, point it out separately.
- Do not add new tests (that's the test-generation skill). If existing tests need updating to match renamed symbols, update them.
- Do not add new dependencies or libraries.
- If the code is already clean, say so. Don't invent refactorings.
- If you're unsure whether a change is safe, present it as a suggestion rather than applying it.
- Present the summary in the user's language; keep code and technical terms in English.
- Always update all call sites when renaming or moving functions/classes.
- Prefer many small, safe refactorings over one large risky one.
- If the project has no tests, warn the user and suggest creating tests first via the test-generation skill.
- Maintain backward compatibility unless the user explicitly authorizes breaking changes.
- When in doubt, show the user the before/after and let them decide. Don't assume your refactoring preference is universal.
- Document the refactoring rationale briefly in a commit message or comment so future maintainers understand the structural change.
