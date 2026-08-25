---
name: debugging
description: >-
  Systematically find and fix bugs. Evidence → Hypothesis → Experiment → Root Cause → Minimal Fix → Verify.
  TRIGGERS: debug, debugging, bug, error, exception, crash, stack trace, traceback, fails, broken,
  not working, wrong output, timeout, infinite loop, race condition, deadlock, memory leak,
  connection error, build failure, compilation error, syntax error, runtime error, type error,
  reference error, segfault, panic, assertion error, agent loop, tool call failure,
  context overflow, token limit, hallucinated tool, invalid arguments,
  عیب‌یابی, رفع باگ, خطا, ایراد, مشکل کد, کار نمیکنه, ارور میده, کرش میکنه,
  هنگ کرده, بی‌نهایت لوپ, تایم‌اوت, اتصال قطع شده, بیلد ناموفق,
  调试, 修复bug, 错误, 异常, 崩溃, 堆栈跟踪, 超时, 死循环, 竞态条件
priority: P0
dependencies: [project-analysis]
conflicts: [refactoring]
---

# Debugging Skill

## Overview

Find and fix bugs systematically. NO GUESSING. Evidence → Hypothesis → Experiment → Root Cause → Minimal Fix → Verify.

## When to Use This Skill

- Any error, exception, or crash
- Wrong output or unexpected behavior
- Timeout, hang, or infinite loop
- Build or compilation failure
- Agent loop or tool call failure
- User says "it's broken" or "fix this"

## When NOT to Use This Skill

- Writing new code (→ code-generation)
- User wants code review (→ code-review)
- No actual bug present

## Inputs Required

- Error message, stack trace, or description of wrong behavior
- File(s) involved
- Expected vs actual behavior

## Preconditions

- Error information available (or can be reproduced)

## Workflow

### Phase 1: Gather Evidence (NEVER skip)

```
1. READ the error message carefully
   - What is the EXACT error type?
   - Which file and line?
   - What is the call stack?

2. READ the relevant code
   - Understand what the code is SUPPOSED to do
   - Identify the failure point

3. REPRODUCE the bug
   - Can you make it happen consistently?
   - What are the exact steps?
```

### Phase 2: Form Hypotheses

```
List ALL possible causes:
1. [Most likely cause]
2. [Second possibility]
3. [Less likely but possible]

For each hypothesis:
- What EVIDENCE supports it?
- What EVIDENCE contradicts it?
- How can I TEST it?
```

### Phase 3: Test Hypotheses

```
For each hypothesis (in order of likelihood):
1. Design a minimal experiment
2. Run the experiment
3. Record the result
4. Accept or reject the hypothesis
```

### Phase 4: Identify Root Cause

```
Ask "WHY?" repeatedly:
- Why did this happen? → [cause]
- Why did [cause] happen? → [deeper cause]
- Why did [deeper cause] happen? → [root cause]

Stop when you reach a cause you can fix.
```

### Phase 5: Apply Minimal Fix

```
1. What is the SMALLEST change that fixes the root cause?
2. Does this fix break anything else?
3. Does this fix introduce new issues?
4. Is there a simpler fix?
```

### Phase 6: Verify Fix

```
1. Does the original bug still occur?
2. Do existing tests still pass?
3. Does the fix handle edge cases?
4. Is there a regression?
```

## Advanced Techniques

### 1. Binary Search Debugging

Narrow down the location of a bug by systematically halving the search space:

```
TECHNIQUE: Binary Search for Bug Location

When: You know the bug exists but not where
How:
1. Find the midpoint of the suspected code range
2. Add a checkpoint (print/assert) at the midpoint
3. Run the program
4. If the bug occurs BEFORE the midpoint → search first half
5. If the bug occurs AFTER the midpoint → search second half
6. Repeat until you find the exact line

Example:
Code lines 1-100, bug is somewhere here
→ Check line 50: bug occurs after → search 51-100
→ Check line 75: bug occurs before → search 51-75
→ Check line 63: bug occurs after → search 64-75
→ Check line 69: bug occurs before → search 64-69
→ Found: bug is at line 66

Efficiency: O(log n) checks instead of O(n)
```

### 2. Delta Debugging (Minimization)

Reduce a failing test case to the minimal reproduction:

```
TECHNIQUE: Delta Debugging

When: You have a large reproduction case and need the minimal one
How:
1. Start with the full failing input
2. Remove half the input
3. If it still fails → keep removing from the same half
4. If it passes → restore and remove from the other half
5. Repeat with smaller and smaller chunks

Example:
Input: "The quick brown fox jumps over the lazy dog"
→ Remove "jumps over the lazy dog" → still fails → keep removed
→ Remove "The quick brown fox " → passes → restore
→ Remove "quick brown fox" → still fails → keep removed
→ Remove "The " → still fails → keep removed
→ Minimal input: "fox"
```

### 3. Hypothesis-Driven Debugging

Formalize the debugging process with structured hypotheses:

```
TECHNIQUE: Hypothesis-Driven Debugging

1. OBSERVE: Document the exact symptoms
   - Error message: "TypeError: undefined is not a function"
   - Location: app.js:42
   - Frequency: 100% reproducible

2. HYPOTHESIZE: Generate ranked hypotheses
   H1 (80%): Variable `processPayment` is undefined at call site
   H2 (15%): Variable exists but is null due to async timing
   H3 (5%): Module not loaded due to circular dependency

3. PREDICT: What would each hypothesis predict?
   H1 predicts: typeof processPayment === 'undefined'
   H2 predicts: processPayment is null, not undefined
   H3 predicts: module.exports is {} or circular ref

4. TEST: Design experiments
   Test 1: Add `console.log(typeof processPayment)` before line 42
   Result: 'undefined' → Supports H1

5. CONCLUDE: Accept or reject hypotheses
   H1 ACCEPTED: processPayment is indeed undefined

6. FIX: Address root cause
   Add missing import: `const { processPayment } = require('./payments');`
```

### 4. Rubber Duck Debugging

Explain the code line by line to find the bug:

```
TECHNIQUE: Rubber Duck Debugging

When stuck, explain the code as if teaching someone:

"Okay, so line 1 creates a new user object...
 Line 2 sets the name from the input...
 Line 3 validates the email... wait, we're checking
 `user.email` but we never SET user.email!
 We set `userData.email` in line 1 but the validator
 checks `user.email` — that's the bug!"

The act of verbalizing forces you to process each step carefully.
```

### 5. Print/Log Debugging (Strategic)

Place strategic logging to trace execution:

```python
# STRATEGIC: Log at decision points
import logging
logger = logging.getLogger(__name__)

def process_order(order):
    logger.debug(f"Processing order: {order.id}")
    logger.debug(f"Order items: {len(order.items)}")

    if not order.is_valid():
        logger.warning(f"Order {order.id} validation failed")
        return None

    for item in order.items:
        logger.debug(f"  Item: {item.sku}, qty: {item.quantity}")
        if item.quantity > item.stock:
            logger.error(f"  Insufficient stock for {item.sku}")
            return None

    logger.info(f"Order {order.id} processed successfully")
    return order.complete()
```

### 6. Assertions as Debugging Aids

```typescript
// Use assertions to catch impossible states
function divide(a: number, b: number): number {
  assert(b !== 0, 'Division by zero should be caught earlier');
  assert(Number.isFinite(a), 'Dividend must be finite');
  assert(Number.isFinite(b), 'Divisor must be finite');
  return a / b;
}

// Use type guards to narrow types
function process(value: string | number) {
  assert(typeof value === 'string' || typeof value === 'number');
  if (typeof value === 'string') {
    // TypeScript knows value is string here
    return value.toUpperCase();
  }
  // TypeScript knows value is number here
  return value.toFixed(2);
}
```

## Language-Specific Debugging Patterns

### Python Debugging

```python
# 1. Interactive debugging with pdb
import pdb; pdb.set_trace()  # or: breakpoint() in Python 3.7+

# 2. Decorator for tracing
def trace(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}({args}, {kwargs})")
        result = func(*args, **kwargs)
        print(f"  → {result}")
        return result
    return wrapper

# 3. Common Python bugs
# - Mutable default argument: def f(x=[]): ...
# - Late binding closure: [lambda: i for i in range(5)]
# - Import side effects
# - GIL-related race conditions

# 4. Python-specific debugging tools
# - py-spy: sampling profiler
# - memory_profiler: memory leak detection
# - tracemalloc: memory allocation tracking
```

### JavaScript/TypeScript Debugging

```javascript
// 1. Chrome DevTools / Node.js debugger
debugger; // breakpoints in code

// 2. Common JS bugs
// - typeof null === 'object'
// - == vs === coercion
// - this binding in callbacks
// - Async/promise handling
// - Event listener leaks

// 3. TypeScript-specific
// - Strict null checks catch undefined access
// - Type narrowing issues
// - Generic type inference failures

// 4. Node.js specific debugging
// --inspect flag for remote debugging
// node --inspect app.js
// chrome://inspect in Chrome

// 5. Memory leak detection
process.on('warning', (warning) => {
  if (warning.name === 'MaxListenersExceededWarning') {
    console.error('Possible memory leak:', warning);
  }
});
```

### Rust Debugging

```rust
// 1. println! debugging
println!("DEBUG: value = {:?}", value);

// 2. dbg! macro (Rust 1.32+)
let x = dbg!(2 + 2); // prints: [src/main.rs:2] 2 + 2 = 4

// 3. Common Rust bugs
// - Borrow checker violations (compile-time, not runtime!)
// - Unwrap panics on None/Err
// - Integer overflow in debug mode
// - Lifetime issues

// 4. Rust debugging tools
// - cargo clippy: lint warnings
// - cargo miri: UB detection
// - cargo audit: security vulnerabilities
// - rust-gdb / rust-lldb: interactive debugging

// 5. Handle unwraps in production
fn find_user(id: &str) -> Result<User, AppError> {
    let user = repo.find(id)
        .map_err(|e| AppError::NotFound(format!("{}: {}", id, e)))?;
    Ok(user)
}
```

### Go Debugging

```go
// 1. Print debugging
fmt.Printf("DEBUG: value=%v type=%T\n", value, value)

// 2. Delve debugger
// dlv debug main.go
// (dlv) break main.main
// (dlv) run

// 3. Common Go bugs
// - Goroutine leaks (no cancellation)
// - Nil pointer dereference
// - Map concurrent access panic
// - Slice append aliasing
// - Defer in loops

// 4. Race detection
// go run -race main.go

// 5. pprof profiling
import _ "net/http/pprof"
// go tool pprof http://localhost:6060/debug/pprof/profile
```

## Common Patterns

### Pattern 1: Add Diagnostic Logging
```typescript
// Add structured logging at key points
function processPayment(order: Order): Result {
  console.log('[PAYMENT] Starting payment processing', {
    orderId: order.id,
    amount: order.total,
    timestamp: Date.now(),
  });

  const validation = validatePayment(order);
  if (!validation.ok) {
    console.error('[PAYMENT] Validation failed', validation.error);
    return Result.fail(validation.error);
  }

  // ... processing ...

  console.log('[PAYMENT] Payment completed', { orderId: order.id });
  return Result.ok(receipt);
}
```

### Pattern 2: Write a Failing Test
```python
def test_process_order_handles_empty_cart():
    """This test should FAIL before the fix, PASS after."""
    order = Order(items=[])
    result = process_order(order)
    assert result.status == 'rejected'
    assert result.reason == 'empty_cart'
```

### Pattern 3: Binary Search in Code
```python
def find_bug_range(items, bug_condition):
    """Binary search for where a bug first appears."""
    low, high = 0, len(items) - 1
    while low < high:
        mid = (low + high) // 2
        if bug_condition(items[mid]):
            high = mid
        else:
            low = mid + 1
    return low
```

### Pattern 4: Reproduction Script
```python
#!/usr/bin/env python3
"""Minimal reproduction of the bug."""
import sys
sys.path.insert(0, '.')

from myapp import process_order
from myapp.models import Order

def reproduce():
    order = Order(
        items=[{"sku": "TEST", "quantity": 1}],
        user_id="user_123",
    )
    try:
        result = process_order(order)
        print(f"Result: {result}")
    except Exception as e:
        print(f"Error: {type(e).__name__}: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    reproduce()
```

### Pattern 5: Staged Fix Application
```
Step 1: Add a test that reproduces the bug (FAILS)
Step 2: Apply the minimal fix (TEST PASSES)
Step 3: Add edge case tests (ALL PASS)
Step 4: Run full test suite (NO REGRESSIONS)
Step 5: Remove temporary debug code
```

## Agent-Specific Debugging

### Agent Loop Detection
```
SIGNS OF AGENT LOOP:
- Same tool called repeatedly with same arguments
- Output cycling through same patterns
- Context size growing without progress
- Repeated failed attempts at same approach

DIAGNOSIS:
1. Check tool call history for duplicates
2. Monitor context window usage
3. Look for circular reasoning patterns
4. Check if the agent has hit a knowledge boundary

FIX:
1. Break the loop with a different approach
2. Summarize and reset context
3. Ask user for clarification
4. Switch to a different skill (e.g., debugging instead of code-generation)
```

### Tool Failure Debugging
```
COMMON TOOL FAILURES:
1. File not found → Check path, check working directory
2. Permission denied → Check file permissions, sandbox mode
3. Timeout → Check if operation is too large
4. Invalid arguments → Validate input format
5. Tool unavailable → Check tool registration

DIAGNOSIS:
1. Check the exact error message
2. Verify file exists and is accessible
3. Check argument types and formats
4. Test with minimal arguments
5. Check tool-specific documentation
```

### Context Overflow Debugging
```
SIGNS:
- Responses becoming incoherent
- Token limit errors
- Performance degradation
- Missing context from earlier in conversation

MANAGEMENT:
1. Summarize long sections of context
2. Remove completed task details
3. Keep only active task information
4. Use file-based persistence for important context
5. Periodically checkpoint progress to files
```

## Edge Cases & Pitfalls

1. **Heisenbugs**: Bug disappears when you add debugging (timing-dependent)
2. **Bohrbugs**: Deterministic, reproducible bugs (the easy ones)
3. **Mandelbugs**: Chaos-theory influenced bugs (seem random)
4. **Schrödinbugs**: Code that shouldn't work but does (until you touch it)
5. **Off-by-one**: Loop bounds, array indexing, range functions
6. **Null/undefined propagation**: Cascading failures from missing values
7. **Async race conditions**: Non-deterministic ordering of async operations
8. **Resource leaks**: File handles, connections, subscriptions not cleaned up
9. **Platform differences**: OS, browser, runtime version differences
10. **Environment variables**: Missing or wrong env vars cause silent failures
11. **Timezone issues**: Date/time bugs across timezones
12. **Encoding bugs**: UTF-8 vs ASCII vs Latin-1 mismatches
13. **Floating point**: Precision errors in calculations
14. **Caching bugs**: Stale data, cache invalidation failures
15. **Dependency bugs**: Third-party library issues, version conflicts

## Integration with Other Skills

| Skill | Direction | Description |
|-------|-----------|-------------|
| project-analysis | ← Input | Understand codebase context |
| code-explanation | ← Input | Understanding code before debugging |
| code-editing | → Output | Apply the fix |
| code-generation | → Output | Generate fix code |
| refactoring | ↔ Bidirectional | Debugging may lead to refactoring; refactoring may introduce bugs |
| testing | → Output | Create regression test |
| verification | → Output | Verify fix works |
| code-review | → Output | Review the fix |

## Output Format Templates

### Standard Template
```
## Debug Report

### Problem
[What is wrong — clear, concise description]

### Evidence
[Error messages, stack traces, observations]

### Hypotheses
1. [Likelihood%]: [hypothesis] — [evidence for/against]
2. [Likelihood%]: [hypothesis] — [evidence for/against]
3. [Likelihood%]: [hypothesis] — [evidence for/against]

### Root Cause
[The actual cause, with evidence]

### Fix
[What was changed and why]

### Files Changed
- [file1]: [what changed]
- [file2]: [what changed]

### Verification
- [ ] Original bug fixed
- [ ] Tests pass
- [ ] No regressions
- [ ] Edge cases handled

### Remaining Issues
[Anything else that needs attention]
```

### Quick Template
```
## Quick Fix

**Bug**: [One-line description]
**Cause**: [Root cause]
**Fix**: [What changed]
**Verified**: [ ] Yes
```

### Deep Template
```
## Comprehensive Debug Analysis

### Environment
[OS, runtime version, dependencies]

### Reproduction Steps
1. [Step 1]
2. [Step 2]

### Evidence Collection
[All error messages, logs, observations]

### Hypothesis Testing
[Detailed experiment results for each hypothesis]

### Root Cause Analysis
[5 Whys analysis]

### Fix Implementation
[Detailed diff with explanation]

### Testing
[Regression tests added]

### Prevention
[How to prevent this class of bug in the future]

### Related Issues
[Similar bugs, systemic problems]
```

### Agent-Specific Template
```
## Agent Debug Report

### Issue
[What went wrong with the agent]

### Diagnosis
- Tool calls made: [count]
- Context usage: [tokens used/total]
- Loop detected: [yes/no]
- Root cause: [agent-level cause]

### Resolution
[What was done to fix]

### Prevention
[How to avoid in future agent runs]
```

## Rules

1. **NEVER** guess — always verify with evidence
2. **NEVER** fix without understanding root cause
3. **ALWAYS** apply minimal fix
4. **ALWAYS** verify fix works
5. **ALWAYS** check for regressions
6. **ALWAYS** reproduce the bug before fixing
7. **ALWAYS** write a regression test
8. **ALWAYS** remove debug code after fixing
9. **STOP** if fix is too complex — reassess
10. **DOCUMENT** the bug and fix for future reference
11. **ONE** fix at a time — don't apply multiple fixes simultaneously
12. **PREFER** explanation over quick patches
13. **CHECK** edge cases after applying fix
14. **CONSIDER** if the bug indicates a systemic issue
15. **COMMUNICATE** the root cause clearly to the user

## Verification

- [ ] Root cause identified with evidence
- [ ] Fix is minimal and targeted
- [ ] Original bug is fixed
- [ ] No regressions introduced
- [ ] Edge cases handled
- [ ] Regression test added
- [ ] Debug code removed
- [ ] Documentation updated if needed

## Failure Handling

- If root cause unclear → Add more logging, reproduce again
- If fix is complex → Consider if this is actually a refactor task
- If can't reproduce → Document conditions, ask user for more info
- If multiple bugs found → Fix them one at a time
- If third-party bug → Document, find workaround, file issue

## Safety Constraints

- Do NOT guess root cause
- Do NOT apply multiple fixes at once
- Do NOT change code you don't understand
- Do NOT claim fix works without verification
- Do NOT skip regression checking
- Do NOT leave debug code in production
- Do NOT suppress errors to "fix" them

## Anti-Patterns

- ❌ Guessing root cause without evidence
- ❌ Applying multiple fixes at once
- ❌ Changing code you don't understand
- ❌ Claiming fix works without verification
- ❌ Skipping regression check
- ❌ "It should work now" without testing
- ❌ Fixing symptoms instead of root cause
- ❌ Deleting error handling to "fix" errors
- ❌ Adding try/catch without handling the error
- ❌ Using `// @ts-ignore` or `# type: ignore` to silence type errors

## Skill Interactions

- ← project-analysis: Understand codebase context
- ← code-explanation: Understanding aids debugging
- → verification: Verify fix works
- → testing: Create regression test
- → code-review: Review the fix
- → code-editing: Apply the minimal fix
- ↔ refactoring: Sometimes debugging reveals refactoring needs
