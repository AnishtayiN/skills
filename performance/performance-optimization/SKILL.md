---
name: performance-optimization
description: >-
  Profile, diagnose, and optimize application performance with profiling-driven optimization,
  database query tuning, N+1 fixes, memoization, and bundling strategies.
  TRIGGERS: performance, optimization, slow code, bottleneck, profiling, memory leak, high cpu,
  latency, throughput, memoization, code splitting, bundle size, database optimization,
  query optimization, n+1 problem, lazy loading, tree shaking,
  بهینه‌سازی عملکرد، کندی برنامه، اشکال‌زدایی عملکرد، بهینه‌سازی پایگاه داده، بهینه‌سازی کوئری، گلوگاه، حافظه نشت، نشت حافظه,
  性能优化, 性能分析, 慢代码, 瓶颈, 内存泄漏, 数据库优化, 查询优化, N+1问题, 懒加载, 代码分割
priority: P2
dependencies: [caching]
conflicts: []
---

# Performance Optimization Skill — Profile, Diagnose & Fix Performance Bottlenecks

## Overview

Performance optimization is not guesswork — it's measure first, optimize second. This skill provides a systematic approach to identifying and fixing performance bottlenecks across the full stack: CPU profiling, memory analysis, database query optimization (including N+1 detection and index tuning), memoization and lazy evaluation, frontend bundling and code splitting, and production monitoring. Every optimization comes with before/after measurement so you can prove it worked.

## When to Use This Skill

- User reports slow code, high CPU usage, or memory issues
- Need to optimize database queries (slow queries, missing indexes, N+1 problems)
- Reducing application latency or improving throughput
- Frontend performance issues (large bundles, slow rendering, layout shift)
- Implementing memoization, lazy loading, or code splitting
- Profiling and identifying performance bottlenecks systematically
- Load testing and benchmarking before/after optimizations
- Memory leak detection and resolution
- Asynchronous/concurrency optimization (sequential → parallel)
- بهینه‌سازی عملکرد (performance optimization), کندی برنامه (slow application)
- اشکال‌زدایی عملکرد (performance debugging), گلوگاه (bottleneck)
- نشت حافظه (memory leak), بهینه‌سازی کوئری (query optimization)
- 性能优化 (performance optimization), 慢代码 (slow code), 瓶颈 (bottleneck)
- 内存泄漏 (memory leak), 数据库优化 (database optimization), N+1问题 (N+1 problem)

## When NOT to Use This Skill

- Caching strategies (not code optimization) → use **caching** skill
- API design without performance focus → use **api-design** skill
- GraphQL-specific performance (DataLoader, complexity) → use **graphql** skill
- Microservice-level performance (inter-service latency) → use **microservices** skill
- Database schema design → use **database-design** skill
- No actual performance problem reported → general coding skills
- Infrastructure scaling (adding servers) → DevOps/infrastructure skills

---

## Workflow

### Step 1: Measure Before Optimizing

```
Golden Rule: Never optimize without measuring.
├── 1. Define the metric (latency p99, throughput, memory, CPU)
├── 2. Establish a baseline (current performance)
├── 3. Profile to find the bottleneck (not guess)
├── 4. Optimize the biggest bottleneck
├── 5. Re-measure and compare (prove improvement)
└── 6. Document before/after results
```

**Profiling Tools by Language**:

| Language | CPU Profiler | Memory Profiler | Benchmark |
|---|---|---|---|
| **Python** | `cProfile`, `py-spy` | `memory_profiler`, `tracemalloc` | `timeit`, `pytest-benchmark` |
| **JavaScript/Node** | Chrome DevTools, `--prof` | Chrome Memory Tab, `heapdump` | `console.time()`, `benchmark.js` |
| **Go** | `pprof`, `go tool trace` | `pprof` (heap profile) | `testing.B`, `benchstat` |
| **Rust** | `cargo-flamegraph` | `valgrind`, `dhat` | `criterion` |
| **Java** | VisualVM, JProfiler | JProfiler, MAT | JMH |
| **SQL** | `EXPLAIN ANALYZE` | — | `pgbench`, `sysbench` |

### Step 2: Profile and Identify Bottlenecks

```
The 80/20 Rule of Performance:
├── 80% of performance problems come from 20% of the code
├── Database queries are usually the #1 bottleneck in web apps
├── N+1 queries are the most common performance bug
├── Missing indexes cause full table scans
├── Unnecessary computation wastes CPU cycles
├── I/O operations (network, disk) block execution
├── Memory allocation creates GC pressure
└── Synchronous operations block async pipelines
```

### Step 3: Optimize the Biggest Bottleneck

```
Optimization Priority (highest impact first):
├── 1. Database: Fix N+1, add indexes, optimize queries
├── 2. Caching: Cache expensive computations and queries
├── 3. Concurrency: Parallelize independent operations
├── 4. Algorithms: Use better data structures and algorithms
├── 5. I/O: Batch requests, use connection pools
├── 6. Memory: Reduce allocations, use streaming
├── 7. Frontend: Code splitting, lazy loading, bundle optimization
└── 8. Micro-optimizations: Only after everything else
```

### Step 4: Measure and Document

```
Performance Report Format:
├── Problem: [what is slow and how slow is it]
├── Profiling Results: [CPU/memory/IO profile data]
├── Root Cause: [the specific bottleneck identified]
├── Optimization: [what was changed and why]
├── Before/After: [metrics comparison]
└── Trade-offs: [any trade-offs made]
```

---

## Advanced Techniques

### 1. Profiling-Driven Optimization

```python
import cProfile
import pstats
import io
import time
from contextlib import contextmanager
from functools import wraps
from typing import Callable, Any

# ═══════════════════════════════════════════════════════════════════
// CPU Profiling: Find exactly where time is spent
// ═══════════════════════════════════════════════════════════════════

def profile_output(func: Callable) -> Callable:
    """Decorator that profiles function execution."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        profiler = cProfile.Profile()
        profiler.enable()
        result = func(*args, **kwargs)
        profiler.disable()

        # Format results
        stream = io.StringIO()
        stats = pstats.Stats(profiler, stream=stream)
        stats.sort_stats('cumulative')
        stats.print_stats(20)  # Top 20 functions
        print(stream.getvalue())

        return result
    return wrapper

# Usage
@profile_output
def expensive_operation():
    # Your code here
    pass

# ─── Programmatic Profiling ──────────────────────────────────────
def profile_code(func: Callable, *args, **kwargs) -> dict:
    """Profile a function and return structured results."""
    profiler = cProfile.Profile()
    profiler.enable()
    start_time = time.perf_counter()
    result = func(*args, **kwargs)
    end_time = time.perf_counter()
    profiler.disable()

    stream = io.StringIO()
    stats = pstats.Stats(profiler, stream=stream)
    stats.sort_stats('cumulative')

    # Extract top functions
    top_functions = []
    for func_tuple in stats.stats:
        filename, line, name = func_tuple
        cc, nc, tt, ct, callers = stats.stats[func_tuple]
        top_functions.append({
            'function': name,
            'file': filename,
            'line': line,
            'calls': nc,
            'total_time': tt,
            'cumulative_time': ct,
        })

    top_functions.sort(key=lambda x: x['cumulative_time'], reverse=True)

    return {
        'result': result,
        'wall_time_ms': (end_time - start_time) * 1000,
        'top_functions': top_functions[:20],
    }

# ─── Line-Level Profiling (py-spy) ──────────────────────────────
# Shell command: py-spy top --pid <PID>
# Or: py-spy record -o profile.svg --pid <PID>

# ─── Memory Profiling ────────────────────────────────────────────
import tracemalloc

def profile_memory(func: Callable, *args, **kwargs) -> dict:
    """Profile memory usage of a function."""
    tracemalloc.start()

    result = func(*args, **kwargs)

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    return {
        'result': result,
        'current_memory_mb': current / 1024 / 1024,
        'peak_memory_mb': peak / 1024 / 1024,
    }

# ─── Timer Context Manager ───────────────────────────────────────
@contextmanager
def timer(label: str = "Operation"):
    """Measure execution time of a code block."""
    start = time.perf_counter()
    yield
    end = time.perf_counter()
    print(f"{label}: {(end - start)*1000:.2f}ms")

# Usage
with timer("Database query"):
    results = db.execute(query)
```

```javascript
// ═══════════════════════════════════════════════════════════════════
// Node.js Profiling
// ═══════════════════════════════════════════════════════════════════

// CPU Profile
// Run: node --prof script.js
// Process: node --prof-process isolate-*.log

// ─── Programmatic Profiling ──────────────────────────────────────
const { performance, PerformanceObserver } = require('perf_hooks');

function profileFunction(fn, label) {
  return function (...args) {
    const start = performance.now();
    const result = fn.apply(this, args);
    const duration = performance.now() - start;
    console.log(`${label}: ${duration.toFixed(2)}ms`);
    return result;
  };
}

// ─── Async Profiling ─────────────────────────────────────────────
async function profileAsync(fn, label) {
  const start = performance.now();
  const result = await fn();
  const duration = performance.now() - start;
  console.log(`${label}: ${duration.toFixed(2)}ms`);
  return result;
}

// ─── Core Web Vitals (Browser) ───────────────────────────────────
function measureCoreWebVitals() {
  // LCP - Largest Contentful Paint
  new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const lcp = entries[entries.length - 1];
    console.log('LCP:', lcp.startTime.toFixed(2), 'ms');
  }).observe({ type: 'largest-contentful-paint', buffered: true });

  // FID - First Input Delay
  new PerformanceObserver((list) => {
    const entry = list.getEntries()[0];
    console.log('FID:', (entry.processingStart - entry.startTime).toFixed(2), 'ms');
  }).observe({ type: 'first-input', buffered: true });

  // CLS - Cumulative Layout Shift
  let clsValue = 0;
  new PerformanceObserver((list) => {
    list.getEntries().forEach(entry => {
      if (!entry.hadRecentInput) clsValue += entry.value;
    });
    console.log('CLS:', clsValue.toFixed(4));
  }).observe({ type: 'layout-shift', buffered: true });
}
```

### 2. Database Query Optimization

```python
import time
from typing import List, Dict, Any

# ═══════════════════════════════════════════════════════════════════
// Database Query Optimization
// ═══════════════════════════════════════════════════════════════════

# ─── EXPLAIN ANALYZE (PostgreSQL) ────────────────────────────────
# Find slow queries and understand execution plans

EXPLAIN_ANALYZE_QUERIES = """
-- Find slow queries from pg_stat_statements
SELECT
    query,
    mean_exec_time::numeric(10,2) as avg_ms,
    calls,
    total_exec_time::numeric(10,2) as total_ms,
    rows
FROM pg_stat_statements
WHERE mean_exec_time > 100  -- Queries averaging > 100ms
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Analyze a specific query
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.*, u.name, u.email
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'pending'
ORDER BY o.created_at DESC
LIMIT 50;

-- Find missing indexes
SELECT
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats
WHERE tablename = 'orders'
  AND n_distinct > 100
  AND NOT EXISTS (
      SELECT 1 FROM pg_stat_user_indexes
      WHERE tablename = 'orders'
        AND pg_stat_user_indexes.indexrelid IN (
            SELECT indexrelid FROM pg_index
            WHERE indkey::text LIKE '%' || attnum::text || '%'
        )
  );
"""

# ─── Index Optimization ──────────────────────────────────────────
INDEX_OPTIMIZATION = """
-- Composite index for common query pattern
CREATE INDEX idx_orders_user_status_created
ON orders(user_id, status, created_at DESC);

-- Partial index (only index rows matching condition)
CREATE INDEX idx_orders_pending
ON orders(created_at)
WHERE status = 'pending';

-- Covering index (includes all columns needed by query)
CREATE INDEX idx_orders_covering
ON orders(user_id, status, total_amount_cents)
INCLUDE (created_at, shipping_address);

-- GIN index for JSONB queries
CREATE INDEX idx_products_attributes
ON products USING GIN(attributes);

-- Concurrent index creation (no lock)
CREATE INDEX CONCURRENTLY idx_orders_search
ON orders USING GIN(to_tsvector('english', order_number));
"""

# ─── Query Optimization Patterns ─────────────────────────────────
class QueryOptimizer:
    """Patterns for optimizing database queries."""

    @staticmethod
    def select_only_needed_columns(query: str, needed_columns: List[str]) -> str:
        """Don't SELECT * — only fetch what you need."""
        # ❌ BAD: SELECT * FROM orders WHERE ...
        # ✅ GOOD: SELECT id, status, total FROM orders WHERE ...
        return query.replace("SELECT *", f"SELECT {', '.join(needed_columns)}")

    @staticmethod
    def add_pagination(query: str, limit: int = 100, offset: int = 0) -> str:
        """Always paginate large result sets."""
        return f"{query} LIMIT {limit} OFFSET {offset}"

    @staticmethod
    def use_exists_not_count(subquery: str) -> str:
        """Use EXISTS instead of COUNT for existence checks."""
        # ❌ BAD: SELECT COUNT(*) FROM ... WHERE ...
        # ✅ GOOD: SELECT EXISTS(SELECT 1 FROM ... WHERE ...)
        return f"SELECT EXISTS({subquery})"

    @staticmethod
    def batch_insert(rows: List[Dict], table: str, batch_size: int = 1000) -> List[str]:
        """Batch inserts instead of individual INSERTs."""
        queries = []
        for i in range(0, len(rows), batch_size):
            batch = rows[i:i + batch_size]
            columns = list(batch[0].keys())
            values = []
            for row in batch:
                values.append(f"({', '.join(str(row[c]) for c in columns)})")
            query = f"""
                INSERT INTO {table} ({', '.join(columns)})
                VALUES {', '.join(values)}
                ON CONFLICT DO NOTHING
            """
            queries.append(query)
        return queries
```

### 3. N+1 Query Detection and Fix

```python
from typing import List, Dict, Any
from dataclasses import dataclass

# ═══════════════════════════════════════════════════════════════════
// N+1 Query Problem:
// 1 query to fetch N items, then N queries to fetch related data
// Total: N+1 queries (should be 1 or 2 queries)
// ═══════════════════════════════════════════════════════════════════

# ❌ BAD: N+1 queries
def get_orders_with_users_bad() -> List[Dict]:
    orders = db.query("SELECT * FROM orders")  # 1 query
    for order in orders:
        user = db.query(
            "SELECT * FROM users WHERE id = %s",
            (order['user_id'],)
        )  # N queries (one per order)
        order['user'] = user
    return orders
# Total: 1 + N queries (e.g., 101 queries for 100 orders)

# ✅ GOOD: Single JOIN query
def get_orders_with_users_join() -> List[Dict]:
    return db.query("""
        SELECT o.*, u.name as user_name, u.email as user_email
        FROM orders o
        JOIN users u ON o.user_id = u.id
        ORDER BY o.created_at DESC
        LIMIT 100
    """)
# Total: 1 query

# ✅ GOOD: Eager loading (SQLAlchemy)
from sqlalchemy.orm import joinedload, selectinload

def get_orders_with_users_eager() -> List:
    return session.query(Order).options(
        joinedload(Order.user),      # JOIN for many-to-one
        selectinload(Order.items),   # Separate query for one-to-many
    ).limit(100).all()
# Total: 2 queries (one for orders+users, one for items)

# ✅ GOOD: Batch loading (DataLoader pattern)
def get_orders_with_users_batch() -> List[Dict]:
    orders = db.query("SELECT * FROM orders LIMIT 100")  # 1 query

    # Collect all user IDs
    user_ids = list(set(o['user_id'] for o in orders))

    # Batch fetch all users in one query
    users = db.query(
        "SELECT * FROM users WHERE id = ANY(%s)",
        (user_ids,)
    )
    user_map = {u['id']: u for u in users}

    # Map users to orders (no additional queries)
    for order in orders:
        order['user'] = user_map.get(order['user_id'])

    return orders
# Total: 2 queries

# ─── N+1 Detection Middleware ────────────────────────────────────
import logging

class QueryCounter:
    """Detect N+1 queries by counting queries per request."""

    def __init__(self):
        self.query_count = 0
        self.queries = []

    def start(self):
        self.query_count = 0
        self.queries = []

    def record_query(self, query: str, params: tuple = None):
        self.query_count += 1
        self.queries.append({'query': query, 'params': params})

    def check(self, request_path: str):
        if self.query_count > 20:
            logging.warning(
                f"High query count ({self.query_count}) for {request_path}. "
                f"Possible N+1 query problem."
            )
            for q in self.queries:
                logging.debug(f"  Query: {q['query'][:100]}")
```

### 4. Memoization and Lazy Evaluation

```python
import functools
import time
from typing import Callable, Any, Optional
from collections import OrderedDict

# ═══════════════════════════════════════════════════════════════════
// Memoization: Cache function results to avoid recomputation
// ═══════════════════════════════════════════════════════════════════

# ─── Simple Memoization (LRU Cache) ──────────────────────────────
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n: int) -> int:
    """Cached recursive fibonacci."""
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# Check cache stats
print(fibonacci.cache_info())

# ─── TTL-Based Memoization ───────────────────────────────────────
def ttl_cache(seconds: int = 300, maxsize: int = 128):
    """Memoization with TTL expiration."""
    def decorator(func: Callable) -> Callable:
        cache = OrderedDict()
        timestamps = {}

        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            key = (args, tuple(sorted(kwargs.items())))
            now = time.time()

            # Check if cached and not expired
            if key in cache and now - timestamps[key] < seconds:
                return cache[key]

            # Compute and cache
            result = func(*args, **kwargs)
            cache[key] = result
            timestamps[key] = now

            # Evict oldest if over capacity
            if len(cache) > maxsize:
                oldest_key = next(iter(cache))
                del cache[oldest_key]
                del timestamps[oldest_key]

            return result

        wrapper.cache_clear = lambda: (cache.clear(), timestamps.clear())
        return wrapper
    return decorator

@ttl_cache(seconds=60, maxsize=256)
def get_product_stats(product_id: str) -> dict:
    """Expensive aggregation that's cached for 60 seconds."""
    return db.query("""
        SELECT
            AVG(rating) as avg_rating,
            COUNT(*) as review_count,
            SUM(CASE WHEN rating >= 4 THEN 1 ELSE 0 END) as positive_count
        FROM reviews WHERE product_id = %s
    """, (product_id,))

# ─── Adaptive Memoization (Size-Based Eviction) ──────────────────
class AdaptiveCache:
    """Cache that adapts to available memory."""

    def __init__(self, max_size_mb: float = 100):
        self.max_size_bytes = int(max_size_mb * 1024 * 1024)
        self.cache = {}
        self.access_times = {}
        self.current_size = 0

    def get(self, key: str) -> Optional[Any]:
        if key in self.cache:
            self.access_times[key] = time.time()
            return self.cache[key]
        return None

    def set(self, key: str, value: Any, estimated_size: int = 0):
        """Set with automatic eviction when memory is full."""
        if estimated_size == 0:
            estimated_size = len(str(value).encode())  # Rough estimate

        # Evict LRU entries if over capacity
        while self.current_size + estimated_size > self.max_size_bytes and self.cache:
            # Find least recently used
            lru_key = min(self.access_times, key=self.access_times.get)
            removed_size = len(str(self.cache[lru_key]).encode())
            del self.cache[lru_key]
            del self.access_times[lru_key]
            self.current_size -= removed_size

        self.cache[key] = value
        self.access_times[key] = time.time()
        self.current_size += estimated_size

# ─── Lazy Evaluation (Generator Pattern) ─────────────────────────
# ❌ BAD: Eager evaluation loads everything into memory
def process_all_items_bad(items: list) -> list:
    return [process_item(item) for item in items]  # All in memory

# ✅ GOOD: Lazy evaluation processes one at a time
def process_all_items_good(items: list):
    for item in items:
        yield process_item(item)  # One at a time, generator

# ─── Lazy Property (Computed Once) ───────────────────────────────
class ExpensiveObject:
    @property
    @functools.lru_cache(maxsize=1)
    def expensive_computation(self) -> dict:
        """Computed once, cached forever."""
        result = {}
        for i in range(1000000):
            result[i] = i ** 2
        return result

# ─── Lazy Module Loading ─────────────────────────────────────────
# Don't import heavy modules at startup
def get_heavy_module():
    """Import only when needed."""
    import numpy as np  # Only imported when function is called
    return np.array([1, 2, 3])
```

### 5. Concurrency Optimization (Sequential → Parallel)

```python
import asyncio
import aiohttp
import time
from typing import List

# ═══════════════════════════════════════════════════════════════════
// Concurrency: Run independent operations in parallel
// ═══════════════════════════════════════════════════════════════════

# ─── Python: Sequential vs Parallel ──────────────────────────────
# ❌ BAD: Sequential (total = sum of all latencies)
async def fetch_all_sequential(urls: List[str]) -> List[dict]:
    results = []
    async with aiohttp.ClientSession() as session:
        for url in urls:
            async with session.get(url) as response:
                results.append(await response.json())
    return results
# 10 URLs × 100ms each = 1000ms total

# ✅ GOOD: Concurrent (total = max of all latencies)
async def fetch_all_concurrent(urls: List[str]) -> List[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [session.get(url) for url in urls]
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        return [await r.json() for r in responses if not isinstance(r, Exception)]
# 10 URLs × 100ms each = ~100ms total

# ─── Python: Batch Database Queries ──────────────────────────────
# ❌ BAD: Sequential queries
async def get_users_sequential(user_ids: List[str]) -> List[dict]:
    results = []
    for uid in user_ids:
        user = await db.users.findById(uid)  # One query per user
        results.append(user)
    return results

# ✅ GOOD: Parallel with asyncio.gather
async def get_users_parallel(user_ids: List[str]) -> List[dict]:
    tasks = [db.users.findById(uid) for uid in user_ids]
    return await asyncio.gather(*tasks)

# ✅ BETTER: Batch query (single query)
async def get_users_batch(user_ids: List[str]) -> List[dict]:
    return await db.query(
        "SELECT * FROM users WHERE id = ANY($1)",
        user_ids
    )
```

```go
// ═══════════════════════════════════════════════════════════════════
// Go: Concurrency with Goroutines
// ═══════════════════════════════════════════════════════════════════

// ❌ BAD: Sequential
func fetchAllSequential(urls []string) []Result {
    var results []Result
    for _, url := range urls {
        result := fetch(url)  // Blocking
        results = append(results, result)
    }
    return results
}

// ✅ GOOD: Concurrent with goroutines + WaitGroup
func fetchAllConcurrent(urls []string) []Result {
    results := make(chan Result, len(urls))
    var wg sync.WaitGroup

    for _, url := range urls {
        wg.Add(1)
        go func(u string) {
            defer wg.Done()
            results <- fetch(u)
        }(url)
    }

    go func() {
        wg.Wait()
        close(results)
    }()

    var out []Result
    for r := range results {
        out = append(out, r)
    }
    return out
}

// ✅ BETTER: With worker pool (limit concurrency)
func fetchAllWithPool(urls []string, maxWorkers int) []Result {
    results := make(chan Result, len(urls))
    sem := make(chan struct{}, maxWorkers)
    var wg sync.WaitGroup

    for _, url := range urls {
        wg.Add(1)
        sem <- struct{}{} // Acquire semaphore
        go func(u string) {
            defer func() {
                <-sem // Release semaphore
                wg.Done()
            }()
            results <- fetch(u)
        }(url)
    }

    go func() {
        wg.Wait()
        close(results)
    }()

    var out []Result
    for r := range results {
        out = append(out, r)
    }
    return out
}
```

### 6. Frontend Performance (Bundling, Code Splitting, Lazy Loading)

```javascript
// ═══════════════════════════════════════════════════════════════════
// Frontend Performance Optimization
// ═══════════════════════════════════════════════════════════════════

// ─── React Code Splitting (Route-Based) ─────────────────────────
import React, { Suspense, lazy } from 'react';

// Lazy load route components
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));
const Analytics = lazy(() => import('./pages/Analytics'));

function App() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/settings" element={<Settings />} />
        <Route path="/analytics" element={<Analytics />} />
      </Routes>
    </Suspense>
  );
}

// ─── React Component Lazy Loading ────────────────────────────────
const HeavyChart = lazy(() => import('./components/HeavyChart'));

function ProductPage({ productId }) {
  const [showChart, setShowChart] = useState(false);

  return (
    <div>
      <h1>Product {productId}</h1>
      <button onClick={() => setShowChart(true)}>Show Analytics</button>
      {showChart && (
        <Suspense fallback={<ChartSkeleton />}>
          <HeavyChart productId={productId} />
        </Suspense>
      )}
    </div>
  );
}

// ─── Dynamic Import (Non-React) ─────────────────────────────────
async function loadFeature(featureName) {
  const module = await import(`./features/${featureName}`);
  return module;
}

// ─── Bundle Analysis ─────────────────────────────────────────────
// Webpack: npx webpack-bundle-analyzer stats.json
// Vite: npx vite-bundle-visualizer

// ─── Tree Shaking (Import Specific Functions) ───────────────────
// ❌ BAD: Imports everything
import _ from 'lodash';
const result = _.debounce(fn, 300);

// ✅ GOOD: Import only what you need
import debounce from 'lodash/debounce';
const result = debounce(fn, 300);

// ✅ BEST: Use ES modules (tree-shakeable)
import { debounce } from 'lodash-es';

// ─── Image Optimization ─────────────────────────────────────────
// Lazy loading
<img src="photo.jpg" loading="lazy" alt="Photo" />

// Responsive images
<img
  srcset="small.jpg 480w, medium.jpg 800w, large.jpg 1200w"
  sizes="(max-width: 600px) 480px, (max-width: 1000px) 800px, 1200px"
  src="medium.jpg"
  alt="Photo"
/>

// WebP with fallback
<picture>
  <source srcset="photo.webp" type="image/webp" />
  <source srcset="photo.jpg" type="image/jpeg" />
  <img src="photo.jpg" alt="Photo" />
</picture>
```

### 7. Memory Optimization

```python
import sys
import tracemalloc
import gc
from typing import Generator, Iterator

# ═══════════════════════════════════════════════════════════════════
// Memory Optimization: Reduce allocation, detect leaks
// ═══════════════════════════════════════════════════════════════════

# ─── Generators for Large Datasets ───────────────────────────────
# ❌ BAD: List comprehension (all in memory)
def get_all_users_bad() -> list:
    return [process_user(u) for u in db.users.all()]  # 1M users = huge list

# ✅ GOOD: Generator (one at a time)
def get_all_users_good() -> Generator:
    for user in db.users.all():
        yield process_user(user)  # One at a time, ~0 memory

# ─── Streaming File Processing ───────────────────────────────────
# ❌ BAD: Read entire file into memory
def process_file_bad(path: str) -> list:
    with open(path) as f:
        content = f.read()  # Entire file in memory
    return [process_line(line) for line in content.split('\n')]

# ✅ GOOD: Stream line by line
def process_file_good(path: str) -> Generator:
    with open(path) as f:
        for line in f:  # One line at a time
            yield process_line(line.strip())

# ─── __slots__ for Memory-Efficient Classes ──────────────────────
# ❌ BAD: Regular class (dict-based, ~200 bytes per instance)
class PointBad:
    def __init__(self, x, y):
        self.x = x
        self.y = y

# ✅ GOOD: __slots__ class (~50 bytes per instance)
class PointGood:
    __slots__ = ['x', 'y']
    def __init__(self, x, y):
        self.x = x
        self.y = y

# ─── Memory Leak Detection ───────────────────────────────────────
def detect_memory_leaks():
    """Find objects that are growing unbounded."""
    tracemalloc.start()

    # Take first snapshot
    snapshot1 = tracemalloc.take_snapshot()

    # Run your code
    for _ in range(100):
        do_work()

    # Take second snapshot
    snapshot2 = tracemalloc.take_snapshot()

    # Compare snapshots
    top_stats = snapshot2.compare_to(snapshot1, 'lineno')

    print("[ Top 10 memory differences ]")
    for stat in top_stats[:10]:
        print(stat)

# ─── Object Pooling (Reuse Expensive Objects) ────────────────────
from queue import Queue

class ObjectPool:
    """Pool of reusable objects to avoid repeated allocation."""

    def __init__(self, factory, max_size: int = 20):
        self.factory = factory
        self.pool = Queue(maxsize=max_size)

    def get(self):
        if self.pool.empty():
            return self.factory()
        return self.pool.get()

    def put(self, obj):
        try:
            self.pool.put_nowait(obj)
        except:
            pass  # Pool is full, let GC handle it

# Usage: Reuse database connections
connection_pool = ObjectPool(
    factory=lambda: create_db_connection(),
    max_size=20,
)

conn = connection_pool.get()
try:
    result = conn.execute(query)
finally:
    connection_pool.put(conn)
```

```javascript
// ═══════════════════════════════════════════════════════════════════
// JavaScript Memory Optimization
// ═══════════════════════════════════════════════════════════════════

// ─── WeakMap/WeakRef for Memory-Sensitive Caches ─────────────────
const cache = new WeakMap();

function processObject(obj) {
  if (cache.has(obj)) {
    return cache.get(obj);
  }
  const result = expensiveComputation(obj);
  cache.set(obj, result); // Will be GC'd when obj is no longer referenced
  return result;
}

// ─── Event Listener Cleanup ──────────────────────────────────────
class Component {
  constructor() {
    this.handler = this.handleClick.bind(this);
    document.addEventListener('click', this.handler);
  }

  destroy() {
    // Always clean up listeners!
    document.removeEventListener('click', this.handler);
  }
}

// ─── Avoid Memory Leaks with Timers ─────────────────────────────
class Poller {
  constructor() {
    this.intervalId = null;
  }

  start() {
    this.intervalId = setInterval(() => {
      this.fetchData();
    }, 5000);
  }

  stop() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }
}
```

### 8. Load Testing and Benchmarking

```python
import time
import statistics
from typing import Callable, List
from concurrent.futures import ThreadPoolExecutor, as_completed

# ═══════════════════════════════════════════════════════════════════
// Benchmarking: Measure before/after to prove optimization worked
// ═══════════════════════════════════════════════════════════════════

def benchmark(func: Callable, iterations: int = 1000, warmup: int = 100) -> dict:
    """Run a function multiple times and report statistics."""
    # Warmup (let JIT compile, cache populate, etc.)
    for _ in range(warmup):
        func()

    # Actual benchmark
    times = []
    for _ in range(iterations):
        start = time.perf_counter()
        func()
        elapsed = time.perf_counter() - start
        times.append(elapsed)

    times_ms = [t * 1000 for t in times]
    times_ms_sorted = sorted(times_ms)

    return {
        'iterations': iterations,
        'mean_ms': statistics.mean(times_ms),
        'median_ms': statistics.median(times_ms),
        'stdev_ms': statistics.stdev(times_ms) if len(times_ms) > 1 else 0,
        'p95_ms': times_ms_sorted[int(len(times_ms_sorted) * 0.95)],
        'p99_ms': times_ms_sorted[int(len(times_ms_sorted) * 0.99)],
        'min_ms': min(times_ms),
        'max_ms': max(times_ms),
    }

def compare_benchmarks(before: dict, after: dict) -> dict:
    """Compare two benchmark results."""
    speedup = before['mean_ms'] / after['mean_ms']
    return {
        'before': before,
        'after': after,
        'speedup': f"{speedup:.2f}x",
        'improvement_pct': f"{(1 - after['mean_ms'] / before['mean_ms']) * 100:.1f}%",
    }

# ─── Concurrency Benchmark ───────────────────────────────────────
def concurrent_benchmark(
    func: Callable,
    args_list: list,
    max_workers: int = 10,
) -> dict:
    """Benchmark a function under concurrent load."""
    start = time.perf_counter()

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(func, *args) for args in args_list]
        results = []
        for future in as_completed(futures):
            try:
                results.append(future.result())
            except Exception as e:
                results.append(None)

    elapsed = time.perf_counter() - start
    return {
        'total_time_ms': elapsed * 1000,
        'concurrent_requests': len(args_list),
        'requests_per_second': len(args_list) / elapsed,
        'avg_latency_ms': (elapsed * 1000) / len(args_list),
        'success_rate': sum(1 for r in results if r is not None) / len(results) * 100,
    }
```

```bash
# ═══════════════════════════════════════════════════════════════════
// Load Testing Tools
// ═══════════════════════════════════════════════════════════════════

# Python - Locust
locust -f locustfile.py --host=https://example.com --users=100 --spawn-rate=10

# Node.js - autocannon
autocannon -c 100 -d 30 http://localhost:3000/api/endpoint

# Go - hey
hey -n 10000 -c 100 http://localhost:8080/api/endpoint

# Apache Bench
ab -n 10000 -c 100 http://localhost:3000/api/endpoint

# wrk (high performance)
wrk -t12 -c400 -d30s http://localhost:3000/api/endpoint
```

---

## Common Patterns

### Pattern 1: Performance Profiling Report

```python
class PerformanceReport:
    """Generate a structured performance analysis report."""

    def __init__(self, name: str):
        self.name = name
        self.sections = []

    def add_profiling(self, label: str, results: dict):
        self.sections.append({
            'type': 'profiling',
            'label': label,
            'results': results,
        })

    def add_before_after(self, label: str, before: dict, after: dict):
        comparison = compare_benchmarks(before, after)
        self.sections.append({
            'type': 'comparison',
            'label': label,
            'comparison': comparison,
        })

    def generate_markdown(self) -> str:
        lines = [f"# Performance Report: {self.name}", ""]
        for section in self.sections:
            if section['type'] == 'profiling':
                lines.append(f"## {section['label']}")
                lines.append(f"- Mean: {section['results']['mean_ms']:.2f}ms")
                lines.append(f"- P95: {section['results']['p95_ms']:.2f}ms")
                lines.append(f"- P99: {section['results']['p99_ms']:.2f}ms")
                lines.append("")
            elif section['type'] == 'comparison':
                c = section['comparison']
                lines.append(f"## {section['label']}")
                lines.append(f"- Before: {c['before']['mean_ms']:.2f}ms")
                lines.append(f"- After: {c['after']['mean_ms']:.2f}ms")
                lines.append(f"- Speedup: {c['speedup']}")
                lines.append(f"- Improvement: {c['improvement_pct']}")
                lines.append("")
        return "\n".join(lines)
```

### Pattern 2: Database Query Performance Monitor

```python
import time
import logging
from functools import wraps

def monitor_queries(func):
    """Decorator to monitor database query performance."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        duration = (time.perf_counter() - start) * 1000

        if duration > 100:  # Log slow queries (>100ms)
            logging.warning(
                f"Slow query ({duration:.2f}ms): {func.__name__}"
            )
        if duration > 1000:  # Alert on very slow queries (>1s)
            logging.error(
                f"VERY SLOW query ({duration:.2f}ms): {func.__name__}"
            )

        return result
    return wrapper
```

### Pattern 3: Function Timing Decorator

```python
import time
from functools import wraps
from collections import defaultdict

class TimingCollector:
    """Collect timing statistics across function calls."""
    _stats = defaultdict(list)

    @classmethod
    def report(cls):
        for func_name, times in cls._stats.items():
            times_ms = [t * 1000 for t in times]
            print(f"{func_name}:")
            print(f"  Calls: {len(times_ms)}")
            print(f"  Mean: {sum(times_ms)/len(times_ms):.2f}ms")
            print(f"  Min: {min(times_ms):.2f}ms")
            print(f"  Max: {max(times_ms):.2f}ms")

def timed(func):
    """Decorator that collects timing statistics."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        TimingCollector._stats[func.__name__].append(elapsed)
        return result
    return wrapper

# Usage
@timed
def slow_function():
    time.sleep(0.1)

# After several calls:
TimingCollector.report()
```

### Pattern 4: Connection Pool Manager

```python
import threading
from queue import Queue, Empty
from typing import Any, Callable

class ConnectionPool:
    """Generic connection pool for any resource."""

    def __init__(
        self,
        factory: Callable,
        max_size: int = 20,
        min_size: int = 5,
        timeout: float = 5.0,
    ):
        self.factory = factory
        self.max_size = max_size
        self.timeout = timeout
        self.pool = Queue(maxsize=max_size)
        self.size = 0
        self.lock = threading.Lock()

        # Pre-create minimum connections
        for _ in range(min_size):
            conn = self.factory()
            self.pool.put(conn)
            self.size += 1

    def get(self) -> Any:
        try:
            return self.pool.get(timeout=self.timeout)
        except Empty:
            with self.lock:
                if self.size < self.max_size:
                    self.size += 1
                    return self.factory()
            raise TimeoutError("Connection pool exhausted")

    def put(self, conn: Any):
        try:
            self.pool.put_nowait(conn)
        except:
            # Pool is full, close the connection
            if hasattr(conn, 'close'):
                conn.close()
            with self.lock:
                self.size -= 1
```

### Pattern 5: Batch Processing Optimizer

```python
from typing import List, Callable, Any

class BatchProcessor:
    """Optimize operations by batching them."""

    def __init__(self, batch_size: int = 100, flush_interval_ms: int = 5000):
        self.batch_size = batch_size
        self.flush_interval_ms = flush_interval_ms
        self.buffer: List[Any] = []

    def add(self, item: Any, processor: Callable):
        self.buffer.append(item)
        if len(self.buffer) >= self.batch_size:
            self.flush(processor)

    def flush(self, processor: Callable):
        if not self.buffer:
            return
        batch = self.buffer.copy()
        self.buffer.clear()
        processor(batch)

# Usage: Batch database inserts
batch = BatchProcessor(batch_size=500)
for user in large_user_list:
    batch.add(user, lambda users: db.users.bulk_create(users))
batch.flush(lambda users: db.users.bulk_create(users))  # Final flush
```

---

## Edge Cases & Pitfalls

### 1. Premature Optimizing
Optimizing code that isn't a bottleneck wastes time. Always profile first — the bottleneck is rarely where you think.

### 2. Micro-Optimizing the Wrong Thing
Optimizing a function that takes 1% of total time yields negligible improvement. Focus on the 80/20 — the functions that dominate execution time.

### 3. Ignoring Database Queries
Most web application performance bottlenecks are in database queries. Profile your queries before optimizing application code.

### 4. N+1 Query Pattern
Fetching related data one-by-one in a loop instead of in a batch. This is the most common performance bug in ORMs.

### 5. Missing Database Indexes
Full table scans on large tables. Use EXPLAIN ANALYZE to find missing indexes.

### 6. Synchronous I/O in Async Context
Using blocking I/O (file reads, network calls) in async code. Use async I/O (aiohttp, aiofiles).

### 7. Excessive Memory Allocation
Creating large objects in hot paths. Use object pooling, generators, and `__slots__`.

### 8. Not Measuring After Optimization
Making a change without verifying it actually improved performance. Always measure before and after.

### 9. Trading Readability for Speed
Making code unreadable for a 2% performance gain. Maintainability matters more than micro-optimizations.

### 10. Ignoring Frontend Performance
Backend optimization is meaningless if the frontend takes 5 seconds to load. Consider the full user experience.

### 11. Caching Without Invalidation
Adding a cache without a plan for invalidating stale data. Cache invalidation is harder than caching itself.

### 12. Not Load Testing
Optimizing for average load but not testing under peak load. Use load testing tools to simulate real traffic.

### 13. Connection Pool Exhaustion
Creating too many database connections. Use connection pooling with appropriate limits.

### 14. Ignoring Cold Start Performance
Application startup time matters for serverless and autoscaling. Lazy-load heavy modules.

### 15. Assuming Complexity = Slowness
O(n) isn't always faster than O(n²) for small inputs. Profile real data sizes, not theoretical complexity.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **caching** | ← Depends on | Caching is a core performance optimization technique |
| **api-design** | → Feeds into | API response times, pagination, rate limiting |
| **graphql** | → Feeds into | Query complexity, DataLoader, N+1 prevention |
| **microservices** | → Feeds into | Inter-service latency, circuit breaker, bulkhead |
| **database-design** | → Feeds into | Index design, query optimization, schema design |
| **queue** | → Feeds into | Async processing for performance (offload slow operations) |
| **monitoring** | → Feeds into | APM setup, metrics collection, alerting |

---

## Output Format Templates

### Template 1: Performance Analysis Report

```
## Performance Analysis — [Feature/Service]

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
| Latency (p99) | Xms | Yms | Z% faster |
| Throughput | X req/s | Y req/s | Z% more |
| Memory usage | XMB | YMB | Z% less |
| DB queries | X | Y | Z% fewer |

### Trade-offs
[Any trade-offs made for the performance gain]
```

### Template 2: Optimization Checklist

```
## Performance Optimization Checklist

- [ ] Profiled the code (not guessing)
- [ ] Identified the actual bottleneck
- [ ] Measured baseline performance
- [ ] Applied optimization
- [ ] Re-measured and confirmed improvement
- [ ] Checked for regressions (other features)
- [ ] Documented before/after metrics
- [ ] Load tested under expected traffic
- [ ] No significant readability regression
- [ ] No correctness regression
```

### Template 3: Database Optimization Report

```
## Database Optimization — [Query/Table]

### Current Performance
- Query: [SQL]
- Execution time: [Xms]
- Execution plan: [EXPLAIN output]
- Rows examined: [N]
- Rows returned: [N]

### Issues Found
- [ ] Missing index on column X
- [ ] N+1 query pattern detected
- [ ] Full table scan on large table
- [ ] Unnecessary JOIN

### Optimization
[Changes made: indexes added, query rewritten, etc.]

### After Performance
- Execution time: [Xms]
- Improvement: [X%]
```

### Template 4: Frontend Performance Report

```
## Frontend Performance — [Page/Feature]

### Core Web Vitals
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| LCP | Xms | < 2.5s | [✅/❌] |
| FID | Xms | < 100ms | [✅/❌] |
| CLS | X | < 0.1 | [✅/❌] |

### Bundle Analysis
| Bundle | Size | Gzipped |
|--------|------|---------|
| main.js | XKB | XKB |
| vendor.js | XKB | XKB |

### Optimizations
- [ ] Code splitting by route
- [ ] Lazy loading heavy components
- [ ] Image optimization (WebP, lazy loading)
- [ ] Tree shaking unused code
- [ ] Compression (gzip/brotli)
```

---

## Rules

1. **Measure first, optimize second** — Never guess about performance. Profile to find the actual bottleneck.
2. **Focus on the biggest bottleneck** — Optimizing code that takes 1% of time is waste. Attack the 80% first.
3. **Document before/after** — Every optimization needs proof it worked. Benchmark before and after.
4. **Don't sacrifice readability for micro-optimizations** — Only optimize what matters. Readable code is maintainable code.
5. **Consider the trade-off** — Faster code might use more memory, or be harder to maintain. Weigh the costs.
6. **Test in production-like conditions** — Dev environments don't reflect real load. Use load testing tools.
7. **Fix database queries first** — Most web app bottlenecks are in the database, not application code.
8. **Detect N+1 queries proactively** — Use query counting middleware or profiling to find N+1 patterns.
9. **Use connection pools** — Don't create new database connections per request. Pool and reuse.
10. **Lazy load expensive operations** — Don't compute what you might not need. Use generators, lazy imports.
11. **Parallelize independent operations** — If operations don't depend on each other, run them concurrently.
12. **Profile memory, not just CPU** — Memory leaks and excessive allocation cause performance degradation over time.
