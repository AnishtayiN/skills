---
name: debug
description: >-
  Diagnose and fix bugs in any programming language code, with special expertise in AI agent code, LLM pipelines, tool-calling loops, and autonomous system failures. Use this skill whenever the user mentions debugging, عیب‌یابی, fixing errors, troubleshooting code, investigating crashes, resolving exceptions, diagnosing runtime failures, fixing agent loops, or says something isn't working. Also trigger when the user pastes error messages, stack traces, or describes unexpected behavior in their code — even if they don't explicitly say "debug." Additional triggers: رفع باگ, حل مشکل کد, اشکال‌زدایی, عیب یابی برنامه, foroshande, debug kardan.
---

# Debug Skill — Universal Code & Agent Debugger

## Overview

This skill enables systematic debugging of any programming language, with deep specialization in AI/agent code. Debugging is fundamentally about forming hypotheses, testing them, and iterating — not about guessing. The instructions below guide you through a structured process that works for everything from a one-line Python syntax error to a mysterious agent infinite-loop that only manifests at 3am on Thursdays.

## When to Use This Skill

- User reports an error, exception, or crash
- Code produces wrong output or unexpected behavior
- Agent or LLM pipeline behaves incorrectly (loops, hallucinations, tool failures)
- Performance issues (slow code, memory leaks, high CPU)
- Security vulnerabilities or best-practice violations
- User asks "why isn't this working?" or "fix my code"

---

## Debugging Decision Tree

When a bug report arrives, follow this decision tree to quickly classify and select the right approach:

```
Is there an error message/stack trace?
├── YES → Parse it (Phase 1)
│   ├── Compile-time error → Syntax/Error Resolution
│   ├── Runtime exception → Runtime Error diagnosis
│   └── Partial output + error → Integration/Async diagnosis
└── NO → What is the observed behavior?
    ├── Code crashes → Runtime Error diagnosis
    ├── Code hangs/freezes → Concurrency / Infinite Loop diagnosis
    ├── Wrong output → Logic Error diagnosis
    ├── Slow output → Performance diagnosis
    └── Missing output → Integration / Silent Failure diagnosis
```

---

## Debugging Workflow

### Phase 1: Gather Information

Before proposing any fix, understand the problem completely. Most debugging failures come from fixing the wrong thing.

1. **Read the code** — Use Read tool to examine the file(s) the user mentions. If they don't mention files, ask which file contains the problematic code.

2. **Identify the language and framework** — Detect the programming language, framework, and key dependencies from file extensions, imports, and syntax. This determines which debugging strategies apply.

3. **Understand the error** — If the user provides an error message or stack trace, parse it carefully:
   - What is the exact error type?
   - Which file and line number?
   - What is the call stack telling you about the execution path?
   - Is it a compile-time error, runtime error, or logical error?

4. **Understand the intent** — What is this code *supposed* to do? If unclear, ask the user. A "bug" is only a bug relative to an expectation.

### Phase 2: Classify the Bug

Categorize the problem to select the right debugging strategy:

| Category | Signs | Common in |
|----------|-------|-----------|
| **Syntax Error** | Parser rejects the code, won't compile/run | All languages |
| **Runtime Error** | Code starts but crashes (exceptions, segfaults) | All languages |
| **Logic Error** | Code runs but produces wrong results | All languages |
| **Concurrency Bug** | Race conditions, deadlocks, non-deterministic failures | JS, Python, Go, Java, Rust |
| **Agent/Loop Bug** | Infinite loops, repeated tool calls, stuck agents | AI agent code, LLM pipelines |
| **Performance Bug** | Slow execution, high memory, timeouts | All languages, especially Python |
| **Integration Bug** | API failures, wrong data formats, auth issues | Web apps, agents calling external tools |
| **Security Bug** | Injections, exposed secrets, unsafe deserialization | All languages |
| **Embedding/Vector DB Bug** | Wrong similarity results, connection timeouts, dimension mismatches | AI/ML pipelines |
| **Token Limit Bug** | Context truncation, silent information loss, degraded output | LLM applications |

### Phase 3: Diagnose Root Cause

For each bug category, apply targeted analysis:

#### For Syntax Errors
- Check for mismatched brackets, parentheses, quotes
- Verify indentation (Python) or semicolons (JS/C/Java)
- Look for typos in keywords, function names, variable names
- Check import statements and module paths
- Check for encoding issues (non-ASCII characters in source files)

#### For Runtime Errors
- Trace the execution path that leads to the crash
- Check variable types and values at the point of failure
- Look for null/undefined access, division by zero, index out of bounds
- Verify that all required resources (files, connections, handles) exist
- Check for type coercion issues (especially JS `==` vs `===`)

#### For Logic Errors
- Add mental print statements: what are the variable values at each step?
- Check boundary conditions (empty inputs, zero, negative numbers, very large values)
- Verify control flow: are if/else conditions correct? Are loops terminating?
- Compare the algorithm against the intended behavior step by step
- Check for off-by-one errors in loop bounds and array indexing

#### For Agent/Loop Bugs (AI-Specific)
- **Infinite tool-call loops**: Check if the agent has a termination condition. Does it know when to stop calling tools? Is the prompt clear about completion criteria?
- **Repeated failures**: Look at error handling — is the agent retrying without backoff or without changing its approach?
- **Context window overflow**: Is the agent accumulating too much context? Check if conversation history is being truncated or summarized.
- **Tool call format errors**: Verify the tool call schema matches what the tool expects. Check parameter names, types, and required fields.
- **Hallucinated tool names**: Ensure the agent can only call tools that actually exist. Check the tool list in the system prompt.
- **Stuck in planning**: If the agent keeps planning but never acts, check if the prompt gives it permission to use tools and take actions.

#### For Embedding/Vector DB Failures
- **Dimension mismatch**: Ensure the embedding model output dimension matches the vector DB index schema
- **Silent truncation**: Check if text is being truncated before embedding (token limits)
- **Connection pooling exhaustion**: Verify connection pool size vs concurrent request count
- **Wrong distance metric**: Ensure similarity search uses the same metric as index creation (cosine vs euclidean vs dot product)
- **Metadata filter errors**: Check filter syntax against the vector DB API documentation

#### For Token Limit Issues
- **Silent truncation**: LLMs may silently truncate input; check if critical information is near the end of the context window
- **Token counting mismatch**: Different tokenizers (tiktoken vs HuggingFace) count differently; verify which tokenizer your pipeline uses
- **System prompt bloat**: Long system prompts consume context; measure and optimize
- **History accumulation**: Conversation history grows without bound; implement summarization or sliding window

#### For Performance Bugs
- Identify the hot path: which function/loop consumes the most time?
- Look for O(n^2) or worse algorithms where O(n) or O(n log n) would work
- Check for unnecessary re-computation (caching opportunities)
- Look for N+1 query patterns (especially in database code)
- Check for large data structures being copied unnecessarily
- In Python: look for global interpreter lock issues, missing async/await
- In JS: look for blocking operations in the event loop, missing promise handling

#### For Concurrency Bugs
- Check shared mutable state without proper synchronization
- Look for race conditions in async code (missing await, fire-and-forget)
- Verify deadlock potential (circular lock dependencies)
- Check for resource leaks (unclosed connections, file handles)

#### For Distributed System Bugs
- **Network partition**: Check if services can communicate; look for timeout vs connection-refused errors
- **Clock skew**: Distributed timestamps may be unreliable; verify using logical clocks or sequence numbers
- **Partial failure**: One service succeeds while another fails; check for compensation/rollback logic
- **Message ordering**: Verify message queue ordering guarantees (FIFO vs unordered)
- **Idempotency**: Ensure retry-safe operations use idempotency keys

---

## Advanced Debugging Techniques

### 1. Binary Search Debugging

When the bug is reproducible but the cause is unclear, halve the search space:

1. Find a reproducible test case
2. Identify the range of code that could cause the issue
3. Comment out / disable the second half of the range
4. If the bug persists, the cause is in the first half; otherwise, it's in the second half
5. Repeat until you narrow down to the exact line

**When to use**: Large codebases, complex initialization sequences, multi-step pipelines.

```
# Example: Binary search for the line that causes a crash
# Step 1: Lines 1-100 → bug present
# Step 2: Lines 1-50 → bug absent
# Step 3: Lines 26-50 → bug present
# Step 4: Lines 26-38 → bug absent
# Step 5: Lines 39-50 → bug present
# → Bug is between lines 39-50
```

### 2. Rubber Duck Debugging

Explain the code line-by-line to an imaginary listener (or to the AI). The act of verbalizing forces you to confront assumptions. Ask yourself:
- What does this line *actually* do, not what I *think* it does?
- What are the preconditions for this function call?
- What invariants should hold at this point?

### 3. Printf / Logging Debugging Patterns

Strategic insertion of debug output:

```python
# Python
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
logger.debug(f"Variable state: {variable!r}")
logger.debug(f"Stack trace: {__import__('traceback').format_stack()}")
```

```javascript
// JavaScript — structured logging
console.debug(JSON.stringify({ variable, timestamp: Date.now() }));
// Use console.table for arrays/objects
console.table(arrayOfObjects);
```

```rust
// Rust
eprintln!("DEBUG: variable = {:?}", variable);
// Or with tracing crate
tracing::debug!(?variable, "checkpoint reached");
```

```go
// Go
log.Printf("DEBUG: variable=%+v", variable)
// Or with zerolog/slog for structured logging
slog.Debug("checkpoint", "variable", variable)
```

### 4. Git Bisect (Automated Binary Search Through Commits)

When a bug appeared recently but you don't know which commit introduced it:

```bash
git bisect start
git bisect bad          # current commit has the bug
git bisect good <commit> # this older commit was known to work
# Git will checkout middle commits; test each one:
git bisect good  # if this commit works
git bisect bad   # if this commit has the bug
# Repeat until git identifies the exact commit
git bisect reset
```

### 5. Conditional Breakpoints and Watchpoints

- **Conditional breakpoint**: Only break when a specific condition is true (e.g., `i === 42` or `user.id === null`)
- **Watchpoint**: Break when a specific variable changes value
- **Logpoints**: Like breakpoints but only log a message without pausing execution

---

## Language-Specific Debugging Patterns

### Python

```python
# Common issues and fixes

# 1. Mutable default argument
def bad_append(item, lst=[]):  # BUG: shared default
    lst.append(item)
    return lst

def good_append(item, lst=None):  # FIX
    if lst is None:
        lst = []
    lst.append(item)
    return lst

# 2. Late binding closure
funcs = [lambda x: x * i for i in range(5)]  # All return 15
funcs = [lambda x, i=i: x * i for i in range(5)]  # Correct

# 3. Generator not consumed
def gen():
    yield 1; yield 2; yield 3
g = gen()       # Generator created but not consumed
list(g)         # NOW it runs
# Check: "RuntimeError: generator already executed"

# 4. Asyncio blocking the event loop
import asyncio
import time
async def bad():
    time.sleep(5)  # BLOCKS the entire event loop
async def good():
    await asyncio.sleep(5)  # Yields control to event loop

# 5. Pandas SettingWithCopyWarning
df = data[['col1', 'col2']]  # This might be a view
df['col1'] = 0                # WARNING
df = data[['col1', 'col2']].copy()  # FIX: explicit copy

# 6. Module-level code execution on import
# If import side effects cause issues, use if __name__ == "__main__"
```

### JavaScript / TypeScript

```javascript
// 1. Implicit type coercion
"5" + 3     // "53" (string)
"5" - 3     // 2 (number)
[] + {}     // "[object Object]"
{} + []     // 0 (in some contexts)
// Fix: Use === and explicit type conversions

// 2. Promise not awaited
async function process() {
  fetchData();          // BUG: fire-and-forget, errors swallowed
  await fetchData();    // FIX: properly await
}

// 3. Event listener leak
element.addEventListener('click', handler);
// Missing: element.removeEventListener('click', handler);
// Fix: Store handler reference, remove on cleanup

// 4. this binding lost in callbacks
class Component {
  handleClick() {
    this.setState({}); // BUG: 'this' is window/undefined
  }
  // Fix options:
  // 1. Arrow function: handleClick = () => {}
  // 2. Bind in constructor: this.handleClick = this.handleClick.bind(this)
  // 3. Use arrow in JSX: onClick={() => this.handleClick()}
}

// 5. Microtask vs Macrotask confusion
setTimeout(() => console.log('macro'), 0);
Promise.resolve().then(() => console.log('micro'));
// Output: micro, macro (Promises resolve before setTimeout)
```

### Rust

```rust
// 1. Borrow checker errors
let mut data = vec![1, 2, 3];
let r1 = &data;      // Immutable borrow
let r2 = &data;      // Another immutable borrow — OK
// let r3 = &mut data; // BUG: can't mutably borrow while immutably borrowed
drop(r1); drop(r2);  // FIX: drop immutable borrows first
let r3 = &mut data;   // Now OK

// 2. Iterator invalidation
let mut v = vec![1, 2, 3];
for item in &v {
    if *item == 2 {
        v.push(4);  // BUG: can't modify while iterating
    }
}
// FIX: Collect indices or items to modify, then apply after iteration

// 3. Panic unwrap in production
let value = config.get("key").unwrap();  // PANICS if key missing
// FIX: Use .unwrap_or_default() or .ok_or() with proper error handling

// 4. Deadlock with std::sync::Mutex
let a = Mutex::new(1);
let b = Mutex::new(2);
// Thread 1: let _ = a.lock(); let _ = b.lock();   // Holds A, waits for B
// Thread 2: let _ = b.lock(); let _ = a.lock();   // Holds B, waits for A → DEADLOCK
// FIX: Always acquire locks in the same order
```

### Go

```go
// 1. Goroutine leak
func search(query string) <-chan Result {
    ch := make(chan Result)
    go func() {
        ch <- expensiveSearch(query)
        // BUG: If nobody reads from ch, goroutine blocks forever
    }()
    return ch
}
// FIX: Use buffered channels or context cancellation

// 2. Nil pointer dereference
var ptr *MyStruct = nil
ptr.Method()  // PANIC
// FIX: Always check for nil before dereferencing

// 3. Race condition
var counter int
for i := 0; i < 1000; i++ {
    go func() { counter++ }()  // DATA RACE
}
// FIX: Use sync/atomic or sync.Mutex

// 4. Deferred file close in loop
for _, file := range files {
    f, _ := os.Open(file)
    defer f.Close()  // BUG: files not closed until function returns
}
// FIX: Use an anonymous function to close immediately
// or call f.Close() at end of loop body

// 5. Error swallowed
result, _ := doSomething()  // Error silently ignored
// FIX: Always check errors
result, err := doSomething()
if err != nil {
    return fmt.Errorf("doing something: %w", err)
}
```

---

## Performance Profiling Patterns

### CPU Profiling

```python
# Python
import cProfile
cProfile.run('my_function()', 'output.prof')
# Analyze with: python -m pstats output.prof
# Or visualize with: snakeviz output.prof
```

```go
// Go
import "runtime/pprof"
f, _ := os.Create("cpu.prof")
pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()
// Analyze: go tool pprof cpu.prof
```

```javascript
// Node.js
node --prof app.js
node --prof-process isolate-*.log > processed.txt
// Or use clinic.js for visual flame graphs
```

### Memory Profiling

```python
# Python — find memory leaks
import tracemalloc
tracemalloc.start()
# ... run code ...
snapshot = tracemalloc.take_snapshot()
for stat in snapshot.statistics('lineno')[:10]:
    print(stat)
```

```go
// Go — heap profiling
import "runtime/pprof"
pprof.WriteHeapProfile(f)
// Analyze: go tool pprof --inuse_space heap.prof
```

### Flame Graph Analysis

A flame graph visualizes where time is spent:
- X-axis: percentage of total time (wider = more time)
- Y-axis: call stack depth (deeper = more nested calls)
- Look for wide "plateaus" — those are the hot spots
- Click to zoom into a specific function

---

## Memory Leak Detection Patterns

### Python
```python
# Common memory leaks
import gc

# 1. Circular references with __del__
class Node:
    def __del__(self):
        print("deleted")  # Prevents GC from collecting cycles
# FIX: Use weakref or avoid __del__

# 2. Growing caches without eviction
from functools import lru_cache
@lru_cache(maxsize=1000)  # FIX: bounded cache

# 3. Circular imports holding references
# FIX: Restructure imports, use TYPE_CHECKING

# Detect: Call gc.collect() and check gc.get_objects() for unusual counts
```

### JavaScript
```javascript
// Common memory leaks
// 1. Forgotten event listeners
// 2. Closures holding references to large objects
// 3. Detached DOM nodes
// 4. Uncleared timers/intervals

// Detection: Use Chrome DevTools Memory tab
// Take heap snapshots before and after operations
// Compare "Objects allocated between snapshots"

// Programmatic detection:
setInterval(() => {
  if (performance.memory.usedJSHeapSize > 100 * 1024 * 1024) {
    console.warn('High memory usage detected');
  }
}, 5000);
```

### Rust
```rust
// Rust rarely leaks but it can happen with:
// 1. Rc cycles (use Weak<T> to break)
// 2. std::mem::forget (deliberate leak)
// 3. Large allocations in arena allocators

// Detection: Use valgrind, or the dhat profiler
// cargo install dh-tracer
```

---

## Distributed System Debugging

### Common Patterns

1. **Request tracing**: Add correlation IDs to all requests across services
2. **Structured logging**: Log with timestamps, service name, correlation ID
3. **Circuit breakers**: Detect cascading failures early
4. **Chaos testing**: Intentionally inject failures to test resilience

### Debugging Checklist for Distributed Systems

```
□ Can you reproduce the issue locally?
□ Check service health endpoints (/health, /ready)
□ Check network connectivity between services
□ Check DNS resolution
□ Verify TLS certificates haven't expired
□ Check connection pool exhaustion
□ Verify message queue consumer lag
□ Check for clock skew between services
□ Review recent deployments / config changes
□ Check for resource limits (CPU, memory, disk, file descriptors)
```

---

## Phase 4: Propose and Apply Fix

Based on the user's preference (from Phase 1), operate in one of two modes:

#### Mode A: Analysis Only (default)

Present the diagnosis in this structure:

```
## Debug Report

**Problem:** [one-line summary of what's wrong]
**Root Cause:** [why it happens — the underlying reason, not just the symptom]
**Location:** [file:line or function name]

### Explanation
[2-4 sentences explaining the mechanics of the bug — why this specific
combination of code + inputs produces this failure]

### Suggested Fix
[Code diff or rewritten code block showing the fix]

### Why This Fix Works
[1-2 sentences connecting the fix back to the root cause]
```

#### Mode B: Auto-Fix (when user explicitly requests it)

1. Apply the fix directly to the file using the Edit tool
2. Explain what was changed and why
3. If multiple fixes are possible, pick the minimal change that resolves the issue
4. If the fix is risky or could have side effects, flag this to the user

**Important**: Always start in Analysis Mode unless the user says something like "fix it for me," "apply the fix," or "go ahead and change it."

### Phase 5: Verify and Prevent

After proposing or applying a fix:

1. **Sanity check**: Does the fix actually address the root cause, or just mask the symptom?
2. **Regression check**: Could this fix break something else? Scan for side effects.
3. **Prevention**: Suggest how to prevent similar bugs in the future:
   - Add type hints or assertions
   - Add input validation
   - Add error handling for edge cases
   - Suggest a test case that would have caught this bug

---

## Real-World Debugging Examples

### Example 1: Python — Silent Data Corruption

```python
# Symptom: CSV file has wrong data after processing
# Code:
def process_rows(rows):
    result = []
    for row in rows:
        row['price'] = row['price'] * 1.1  # Add 10% tax
        result.append(row)
    return result

# Bug: Modifies original data! After processing, input rows are corrupted
# because dicts are mutable references.

# Fix:
def process_rows(rows):
    result = []
    for row in rows:
        new_row = row.copy()  # Don't mutate original
        new_row['price'] = new_row['price'] * 1.1
        result.append(new_row)
    return result
```

### Example 2: JavaScript — Race Condition in API Call

```javascript
// Symptom: UI shows stale data after rapid tab switching
async function loadProfile(userId) {
  const data = await fetch(`/api/users/${userId}`);
  setProfile(await data.json());
}
// Bug: If user switches tabs quickly, an old response can overwrite a new one
// (Response A arrives after Response B, showing stale data)

// Fix: Use AbortController or a "latest request" counter
let latestRequestId = 0;
async function loadProfile(userId) {
  const requestId = ++latestRequestId;
  const data = await fetch(`/api/users/${userId}`);
  if (requestId !== latestRequestId) return; // Stale response, discard
  setProfile(await data.json());
}
```

### Example 3: Rust — Unintended Cloning in Hot Loop

```rust
// Symptom: 10x slower than expected
fn process(items: &[String]) -> Vec<String> {
    let mut result = Vec::new();
    for item in items {
        let cloned = item.clone();  // Unnecessary clone
        result.push(format!("processed: {}", cloned));
    }
    result
}
// Fix: Use &str reference or cow::Cow
fn process(items: &[String]) -> Vec<String> {
    items.iter()
        .map(|item| format!("processed: {}", item))
        .collect()
}
```

### Example 4: Go — Goroutine Leak in HTTP Handler

```go
// Symptom: Memory grows unbounded under load
func handleRequest(w http.ResponseWriter, r *http.Request) {
    ch := make(chan Result, 1)
    go func() {
        result := expensiveComputation(r.Context())
        ch <- result  // May block if channel is full and nobody reads
    }()
    select {
    case res := <-ch:
        json.NewEncoder(w).Encode(res)
    case <-r.Context().Done():
        return  // Request cancelled, but goroutine is still running!
    }
}
// Fix: Use context in the goroutine to detect cancellation
go func() {
    select {
    case ch <- expensiveComputation(r.Context()):
    case <-r.Context().Done():
    }
}()
```

---

## Output Format

Present findings in the user's language. Keep explanations technical but accessible. Use code blocks with language tags. If the user's language is not English, write the report in their language but keep code and technical terms in English.

## Common Pitfalls to Avoid

- **Don't fix the symptom instead of the cause.** A null check hides a null; find out *why* it's null.
- **Don't rewrite large chunks of code.** Make the minimal change that fixes the bug. Big rewrites introduce new bugs.
- **Don't assume.** Verify your hypothesis before proposing a fix. Read the actual code, don't reason from memory.
- **Don't ignore the user's context.** They may have constraints you can't see (old framework version, production restrictions, etc.).
- **Don't over-explain.** State the problem, the cause, and the fix. Move on.
- **Don't skip the root cause.** "It's null" is a symptom, not a root cause. Why is it null?
- **Don't ignore reproduction.** A bug you can't reproduce is a bug you can't confirm fixing.
- **Don't apply multiple unrelated fixes at once.** Fix one thing at a time so you can verify each change.
