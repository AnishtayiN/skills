---
name: performance-optimization
description: >-
  Profile, diagnose, and optimize application performance including CPU, memory, I/O,
  database queries, and network latency. Use this skill when the user mentions performance,
  optimization, slow code, bottleneck, profiling, memory leak, high CPU, latency, throughput,
  caching, lazy loading, code splitting, bundle size, database optimization, query optimization,
  N+1 problem, or says بهینه‌سازی عملکرد, کندی برنامه, اشکال‌زدایی عملکرد,
  بهینه‌سازی پایگاه داده, بهینه‌سازی کوئری.
---

# Performance Optimization Skill — Profile, Diagnose & Fix Performance Issues

## Overview

This skill provides a systematic approach to identifying and fixing performance bottlenecks. Performance optimization is not guesswork — it's measure first, optimize second. This skill covers CPU profiling, memory analysis, database query optimization, I/O bottleneck detection, caching strategies, frontend performance, and production monitoring. Every optimization comes with before/after metrics so you can prove it worked.

## When to Use This Skill

- User reports slow code, high CPU, or memory issues
- User wants to optimize database queries
- User needs to reduce application latency
- User asks about caching strategies
- User mentions profiling, bottleneck, or optimization
- User says the app is "slow" or "not scaling"
- User mentions بهینه‌سازی عملکرد, کندی برنامه, or اشکال‌زدایی عملکرد

---

## Phase 1: Measure Before Optimizing

**Golden Rule:** Never optimize without measuring. Guesswork wastes time.

### Profiling Tools by Language

| Language | CPU Profiler | Memory Profiler | Benchmark |
|----------|-------------|-----------------|-----------|
| **Python** | `cProfile`, `py-spy` | `memory_profiler`, `tracemalloc` | `timeit`, `pytest-benchmark` |
| **JavaScript/Node** | Chrome DevTools, `--prof` | Chrome Memory Tab, `heapdump` | `console.time()`, `benchmark.js` |
| **Go** | `pprof`, `go tool trace` | `pprof` (heap profile) | `testing.B`, `benchstat` |
| **Rust** | `cargo-flamegraph` | `valgrind`, `dhat` | `criterion` |
| **Java** | VisualVM, JProfiler | JProfiler, MAT | JMH |
| **SQL** | `EXPLAIN ANALYZE` | - | `pgbench`, `sysbench` |

### Quick Profile Commands

```bash
# Python CPU profile
python -m cProfile -s cumulative script.py

# Python memory profile
python -m memory_profiler script.py

# Node.js CPU profile
node --prof script.js
node --prof-process isolate-*.log

# Go CPU profile
go test -cpuprofile=cpu.out -bench=.
go tool pprof cpu.out

# Rust flamegraph
cargo flamegraph
```

### Frontend Performance

```javascript
// Core Web Vitals measurement
function measurePerformance() {
  // LCP - Largest Contentful Paint
  new PerformanceObserver((list) => {
    const entries = list.getEntries();
    console.log('LCP:', entries[entries.length - 1].startTime);
  }).observe({ type: 'largest-contentful-paint', buffered: true });

  // FID - First Input Delay
  new PerformanceObserver((list) => {
    console.log('FID:', list.getEntries()[0].processingStart - list.getEntries()[0].startTime);
  }).observe({ type: 'first-input', buffered: true });

  // CLS - Cumulative Layout Shift
  let clsValue = 0;
  new PerformanceObserver((list) => {
    list.getEntries().forEach(entry => {
      if (!entry.hadRecentInput) clsValue += entry.value;
    });
    console.log('CLS:', clsValue);
  }).observe({ type: 'layout-shift', buffered: true });
}
```

---

## Phase 2: Identify Bottlenecks

### The 80/20 Rule

80% of performance problems come from 20% of the code. Focus on:
1. **Database queries** — Usually the #1 bottleneck in web apps
2. **N+1 queries** — Loading related data one-by-one instead of in batch
3. **Missing indexes** — Full table scans on large tables
4. **Unnecessary computation** — Calculations that could be cached or eliminated
5. **I/O operations** — Network calls, file reads, API calls in hot paths
6. **Memory allocation** — Excessive object creation, large data structures

### Bottleneck Detection Checklist

```python
import time
import psutil
import logging

def profile_function(func):
    """Decorator to profile function execution."""
    def wrapper(*args, **kwargs):
        # Memory before
        process = psutil.Process()
        mem_before = process.memory_info().rss / 1024 / 1024  # MB
        
        # CPU before
        cpu_before = process.cpu_percent()
        
        # Time
        start = time.perf_counter()
        result = func(*args, **kwargs)
        end = time.perf_counter()
        
        # Memory after
        mem_after = process.memory_info().rss / 1024 / 1024
        cpu_after = process.cpu_percent()
        
        logging.info(f"{func.__name__}:")
        logging.info(f"  Time: {(end - start)*1000:.2f}ms")
        logging.info(f"  Memory: {mem_before:.1f}MB → {mem_after:.1f}MB (+{mem_after-mem_before:.1f}MB)")
        logging.info(f"  CPU: {cpu_before}% → {cpu_after}%")
        
        return result
    return wrapper
```

---

## Phase 3: Database Optimization

### Query Analysis

```sql
-- PostgreSQL: Find slow queries
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- MySQL: Find slow queries
SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;

-- Analyze a specific query
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123;
```

### Index Optimization

```sql
-- Find missing indexes (PostgreSQL)
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE tablename = 'orders' AND n_distinct > 100;

-- Create composite index for common query pattern
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Partial index (only index rows matching condition)
CREATE INDEX idx_orders_pending ON orders(created_at) WHERE status = 'pending';

-- Covering index (includes all columns needed by query)
CREATE INDEX idx_orders_covering ON orders(user_id, status, total) INCLUDE (created_at);
```

### N+1 Query Fix

```python
# ❌ BAD: N+1 queries (1 + N queries)
orders = db.query("SELECT * FROM orders")  # 1 query
for order in orders:
    user = db.query(f"SELECT * FROM users WHERE id = {order.user_id}")  # N queries
    order.user = user

# ✅ GOOD: Single JOIN query
orders = db.query("""
    SELECT o.*, u.name, u.email
    FROM orders o
    JOIN users u ON o.user_id = u.id
""")

# ✅ GOOD: Eager loading (SQLAlchemy)
from sqlalchemy.orm import joinedload
orders = session.query(Order).options(joinedload(Order.user)).all()

# ✅ GOOD: Batch loading
order_ids = [o.id for o in orders]
users = db.query("SELECT * FROM users WHERE id IN %s", (tuple(order_ids),))
```

---

## Phase 4: Caching Strategies

### Cache Levels

| Level | Location | Speed | Use Case |
|-------|----------|-------|----------|
| **L1: In-Memory** | Application process | ⚡⚡⚡⚡⚡ | Hot data, computed results |
| **L2: Distributed** | Redis/Memcached | ⚡⚡⚡⚡ | Shared cache across instances |
| **L3: CDN** | Edge servers | ⚡⚡⚡ | Static assets, API responses |
| **L4: Database** | Query cache | ⚡⚡ | Repeated identical queries |
| **L5: Browser** | Client cache | ⚡⚡⚡⚡⚡ | Static files, API responses |

### Redis Caching Patterns

```python
import redis
import json
import hashlib

r = redis.Redis()

def cache_get_or_set(key, func, ttl=3600):
    """Cache-aside pattern."""
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    
    result = func()
    r.setex(key, ttl, json.dumps(result))
    return result

# Usage
user = cache_get_or_set(
    f"user:{user_id}",
    lambda: db.get_user(user_id),
    ttl=300  # 5 minutes
)

# Cache key generation
def make_cache_key(prefix, **kwargs):
    """Generate consistent cache key."""
    content = json.dumps(kwargs, sort_keys=True)
    hash_val = hashlib.md5(content.encode()).hexdigest()
    return f"{prefix}:{hash_val}"
```

### Cache Invalidation

```python
# Write-through: Update cache when data changes
def update_user(user_id, data):
    db.update_user(user_id, data)
    r.delete(f"user:{user_id}")  # Invalidate cache

# Event-driven: Invalidate on events
def on_user_update(event):
    r.delete(f"user:{event.user_id}")
    r.delete(f"user:{event.user_id}:profile")

# TTL-based: Auto-expire after time
r.setex("popular_products", 300, json.dumps(products))  # 5 min TTL
```

---

## Phase 5: Frontend Performance

### Code Splitting

```javascript
// React lazy loading
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

// Dynamic imports
async function loadFeature(feature) {
  const module = await import(`./features/${feature}`);
  return module;
}

// Route-based splitting
const Dashboard = React.lazy(() => import('./pages/Dashboard'));
const Settings = React.lazy(() => import('./pages/Settings'));
```

### Bundle Optimization

```bash
# Analyze bundle size
npx webpack-bundle-analyzer stats.json

# Tree shaking (remove unused code)
import { specificFunction } from 'library';  # ✅ Good
import * as library from 'library';  # ❌ Bad - imports everything

# Compression
npm install compression-webpack-plugin
```

### Image Optimization

```html
<!-- Lazy loading -->
<img src="photo.jpg" loading="lazy" alt="Photo" />

<!-- Responsive images -->
<img srcset="small.jpg 480w, medium.jpg 800w, large.jpg 1200w"
     sizes="(max-width: 600px) 480px, (max-width: 1000px) 800px, 1200px"
     src="medium.jpg" alt="Photo" />

<!-- WebP format -->
<picture>
  <source srcset="photo.webp" type="image/webp">
  <img src="photo.jpg" alt="Photo">
</picture>
```

---

## Phase 6: Async & Concurrency

### Python Async Optimization

```python
import asyncio
import aiohttp

# ❌ BAD: Sequential requests
async def fetch_all(urls):
    results = []
    for url in urls:
        async with session.get(url) as resp:
            results.append(await resp.json())
    return results

# ✅ GOOD: Concurrent requests
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [session.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [await r.json() for r in responses]
```

### Go Concurrency

```go
// ❌ BAD: Sequential
func fetchAll(urls []string) []Result {
    var results []Result
    for _, url := range urls {
        result := fetch(url)
        results = append(results, result)
    }
    return results
}

// ✅ GOOD: Concurrent with goroutines
func fetchAll(urls []string) []Result {
    results := make(chan Result, len(urls))
    for _, url := range urls {
        go func(u string) {
            results <- fetch(u)
        }(url)
    }
    var out []Result
    for range urls {
        out = append(out, <-results)
    }
    return out
}
```

---

## Phase 7: Memory Optimization

### Python Memory Patterns

```python
# ❌ BAD: Large list in memory
data = [process(item) for item in huge_dataset]  # Loads everything into memory

# ✅ GOOD: Generator (lazy evaluation)
def process_items(dataset):
    for item in dataset:
        yield process(item)

# ✅ GOOD: Streaming for large files
def read_large_file(path):
    with open(path) as f:
        for line in f:  # Memory-efficient iteration
            yield line.strip()

# Track memory usage
import tracemalloc
tracemalloc.start()

# ... your code ...

current, peak = tracemalloc.get_traced_memory()
print(f"Current: {current / 1024 / 1024:.1f}MB, Peak: {peak / 1024 / 1024:.1f}MB")
```

### Object Pooling

```python
from objectpool import ObjectPool

# Reuse expensive objects
connection_pool = ObjectPool(
    factory=lambda: create_db_connection(),
    max_size=20
)

with connection_pool.get() as conn:
    conn.execute(query)
```

---

## Phase 8: Benchmarking & Validation

### Before/After Measurement

```python
import time
from contextlib import contextmanager

@contextmanager
def timer(label):
    start = time.perf_counter()
    yield
    end = time.perf_counter()
    print(f"{label}: {(end - start)*1000:.2f}ms")

# Usage
with timer("Database query"):
    results = db.execute(query)

# Benchmark
def benchmark(func, iterations=1000):
    times = []
    for _ in range(iterations):
        start = time.perf_counter()
        func()
        times.append(time.perf_counter() - start)
    
    print(f"Mean: {sum(times)/len(times)*1000:.2f}ms")
    print(f"Median: {sorted(times)[len(times)//2]*1000:.2f}ms")
    print(f"P95: {sorted(times)[int(len(times)*0.95)]*1000:.2f}ms")
    print(f"P99: {sorted(times)[int(len(times)*0.99)]*1000:.2f}ms")
```

### Load Testing

```bash
# Python - locust
locust -f locustfile.py --host=https://example.com

# Node.js - autocannon
autocannon -c 100 -d 30 http://localhost:3000

# Go - hey
hey -n 10000 -c 100 http://localhost:8080
```

---

## Output Format

```
## Performance Analysis Report

### Problem
[What is slow and how slow is it]

### Profiling Results
[CPU/memory/IO profile data]

### Root Cause
[The specific bottleneck identified]

### Optimization Applied
1. [What was changed and why]
2. [...]

### Before/After Metrics
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Latency (p50) | Xms | Yms | Z% faster |
| Memory usage | XMB | YMB | Z% less |

### Trade-offs
[Any trade-offs made for the performance gain]
```

## Rules

- **Measure first, optimize second** — Never guess about performance
- **Focus on the biggest bottleneck** — Optimizing code that takes 1% of time is waste
- **Document before/after** — Every optimization needs proof it worked
- **Don't sacrifice readability for micro-optimizations** — Only optimize what matters
- **Consider the trade-off** — Faster code might use more memory, or be harder to maintain
- **Test in production-like conditions** — Dev environments don't reflect real load
