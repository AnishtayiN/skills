---
name: concurrency-debugging
description: >-
  Debug concurrency issues: race conditions, deadlocks, async bugs, thread safety.
  TRIGGERS: race condition, deadlock, thread, async, concurrent, parallel, synchronization,
  mutex, lock, atomics, data race, thread safe, async bug, await issue,
  شرط مسابقه, بن‌بست, همزمانی, آسنکرون, قفل, ایمنی رشته
priority: P0
dependencies: [debugging]
conflicts: []
---

# Concurrency Debugging Skill

## Purpose

Find and fix race conditions, deadlocks, and async issues.

## When to Activate

- Non-deterministic failures
- Deadlock detected
- Async code behaving unexpectedly
- Thread safety issues

## Workflow

### Step 1: Identify Concurrency Pattern

```
1. What concurrency model? (threads, async, goroutines, actors)
2. What shared state exists?
3. What synchronization is used?
4. What is the execution order?
```

### Step 2: Find the Bug

```
Common patterns:
- Race condition: Two operations on shared state without sync
- Deadlock: Two locks acquired in different order
- Async bug: Missing await, wrong async flow
- Starvation: One thread blocks others
```

### Step 3: Fix

```
1. Add proper synchronization
2. Use atomic operations
3. Fix lock ordering
4. Add proper async/await
5. Minimize shared state
```

## Anti-Patterns

- ❌ Using sleep to "fix" race conditions
- ❌ Adding more locks without understanding the issue
- ❌ Ignoring non-deterministic test failures

## Skill Interactions

- ← debugging: General debugging principles
- → verification: Test under load
