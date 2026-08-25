---
name: performance-analysis
description: >-
  Analyze and optimize performance: profiling, bottleneck detection, caching, optimization.
  TRIGGERS: performance, slow, bottleneck, optimize, profiling, memory, cpu, latency, throughput,
  cache, inefficient, hot path, performance issue, timeout,
  عملکرد, کندی, بهینه‌سازی, حافظه, پردازنده, تاخیر
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Performance Analysis Skill

## Purpose

Find and fix performance bottlenecks. Measure before optimizing.

## When to Activate

- Code is slow
- User reports performance issues
- High memory/CPU usage
- Timeouts

## Workflow

### Step 1: Measure

```
1. What is slow? (endpoint, function, query)
2. How slow? (milliseconds, seconds)
3. What is the baseline? (before optimization)
```

### Step 2: Profile

```
1. Identify hot paths
2. Find bottlenecks
3. Check N+1 queries
4. Check memory allocations
5. Check I/O operations
```

### Step 3: Optimize

```
Priority order:
1. Database queries (biggest impact)
2. Caching (add if missing)
3. Algorithm optimization
4. Code-level optimization
```

### Step 4: Verify

```
1. Measure after optimization
2. Compare before/after
3. Check no regressions
```

## Anti-Patterns

- ❌ Optimizing without measuring
- ❌ Micro-optimizing while ignoring big issues
- ❌ Adding cache without invalidation strategy
- ❌ Optimizing code that isn't the bottleneck

## Skill Interactions

- ← project-analysis: Understand system
- → verification: Verify improvement
