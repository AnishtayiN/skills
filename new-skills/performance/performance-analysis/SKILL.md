---
name: performance-analysis
description: >-
  Analyze and optimize performance: profiling, bottleneck detection, caching, optimization.
  TRIGGERS: performance, slow, bottleneck, optimize, profiling, memory, cpu, latency, throughput,
  cache, inefficient, hot path, performance issue, timeout, memory leak, profiling tools,
  database optimization, lazy loading, batch processing, algorithm complexity,
  عملکرد, کندی, بهینه‌سازی, حافظه, پردازنده, تاخیر,
  性能, 优化, 内存, 瓶颈, 分析
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Performance Analysis Skill

## Purpose

Systematic performance analysis and optimization. Measure before optimizing, profile to find bottlenecks, and apply targeted optimizations with measurable improvements.

## When to Activate

- Code is slow or unresponsive
- User reports performance issues
- High memory/CPU usage
- Timeouts or latency issues
- Database queries are slow
- Application doesn't scale
- User says "optimize this" or "make it faster"

## Workflow

### Step 1: Define Metrics & Baseline

```
1. What is slow? (endpoint, function, query, operation)
2. How slow? (milliseconds, seconds, minutes)
3. What is the baseline? (current performance metrics)
4. What is the target? (desired performance)
5. What are the constraints? (budget, time, resources)
```

### Step 2: Profile & Measure

```
1. CPU profiling to find hot paths
2. Memory profiling to find leaks and allocations
3. I/O profiling to find bottlenecks
4. Database query analysis
5. Network latency measurement
6. Thread/async analysis
```

### Step 3: Analyze & Identify

```
1. Identify the primary bottleneck
2. Classify the issue type:
   - CPU-bound (computation intensive)
   - Memory-bound (excessive allocations)
   - I/O-bound (disk, network, database)
   - Algorithmic (wrong complexity class)
   - Concurrency (lock contention, context switching)
3. Quantify the impact
```

### Step 4: Optimize

```
Priority order (highest impact first):
1. Algorithm optimization (O(n²) → O(n log n))
2. Database query optimization
3. Caching (add if missing)
4. I/O optimization (batching, lazy loading)
5. Code-level optimization
6. Infrastructure scaling
```

### Step 5: Verify & Monitor

```
1. Measure after optimization
2. Compare before/after metrics
3. Check for regressions
4. Set up monitoring/alerting
5. Document changes and impact
```

## Advanced Techniques

### 1. CPU Profiling with cProfile (Python)
```python
import cProfile
import pstats
from io import StringIO

def profile_function(func, *args, **kwargs):
    """Profile a function and return stats"""
    profiler = cProfile.Profile()
    profiler.enable()
    result = func(*args, **kwargs)
    profiler.disable()
    
    stream = StringIO()
    stats = pstats.Stats(profiler, stream=stream)
    stats.sort_stats('cumulative')
    stats.print_stats(20)
    
    print(stream.getvalue())
    return result

# Usage
# python -m cProfile -s cumulative your_script.py

# Line-by-line profiling
# pip install line_profiler
# kernprof -l -v your_script.py
```

### 2. Memory Profiling (Python)
```python
# pip install memory_profiler
from memory_profiler import profile

@profile
def memory_intensive_function():
    """Profile memory usage line by line"""
    data = [i for i in range(1000000)]  # List comprehension
    processed = [x * 2 for x in data]   # Another large list
    return sum(processed)

# Usage
# python -m memory_profiler your_script.py

# Alternative: tracemalloc
import tracemalloc

tracemalloc.start()
# ... code to profile ...
snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 memory consumers ]")
for stat in top_stats[:10]:
    print(stat)
```

### 3. Performance Profiling with perf (Linux)
```bash
# Record performance data
perf record -g ./your_application

# Analyze CPU cycles
perf report

# Count hardware events
perf stat ./your_application

# Flame graph generation
perf record -F 99 -a -g -- sleep 30
perf script > out.perf
stackcollapse-perf.pl out.perf > out.folded
flamegraph.pl out.folded > flamegraph.svg
```

### 4. Browser DevTools Profiling (JavaScript)
```javascript
// Performance API for measuring
function measurePerformance() {
    performance.mark('start');
    
    // Code to measure
    for (let i = 0; i < 1000000; i++) {
        // Work
    }
    
    performance.mark('end');
    performance.measure('operation', 'start', 'end');
    
    const measures = performance.getEntriesByName('operation');
    console.log(`Duration: ${measures[0].duration}ms`);
}

// Memory profiling
console.log(performance.memory); // Chrome only
// {usedJSHeapSize: X, totalJSHeapSize: X, jsHeapSizeLimit: X}

// Chrome DevTools:
// 1. Performance tab - record timeline
// 2. Memory tab - heap snapshots, allocation timelines
// 3. Lighthouse - comprehensive performance audit
```

### 5. Algorithm Complexity Analysis
```python
import time
import matplotlib.pyplot as plt

def measure_complexity(func, input_sizes):
    """Measure algorithm complexity by timing with different input sizes"""
    times = []
    for size in input_sizes:
        start = time.time()
        func(size)
        end = time.time()
        times.append(end - start)
    return times

# Example: Compare O(n) vs O(n²)
def linear(n):
    return sum(range(n))

def quadratic(n):
    return sum(i * j for i in range(n) for j in range(n))

sizes = [100, 1000, 10000, 100000]
linear_times = measure_complexity(linear, sizes)
quadratic_times = measure_complexity(quadratic, sizes)

# Plot to visualize complexity
plt.plot(sizes, linear_times, label='O(n)')
plt.plot(sizes, quadratic_times, label='O(n²)')
plt.xlabel('Input Size')
plt.ylabel('Time (seconds)')
plt.legend()
plt.show()
```

### 6. Database Query Optimization
```sql
-- EXPLAIN ANALYZE to understand query performance
EXPLAIN ANALYZE
SELECT u.*, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id
HAVING COUNT(o.id) > 5;

-- Common optimizations:
-- 1. Add indexes for WHERE, JOIN, ORDER BY columns
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- 2. Use covering indexes
CREATE INDEX idx_orders_covering ON orders(user_id, id);

-- 3. Avoid SELECT *
SELECT id, name, email FROM users WHERE ...;

-- 4. Use LIMIT for pagination
SELECT * FROM users ORDER BY id LIMIT 20 OFFSET 0;

-- 5. Batch inserts
INSERT INTO users (name, email) VALUES
  ('User1', 'user1@example.com'),
  ('User2', 'user2@example.com'),
  -- ... more rows
  ('User100', 'user100@example.com');
```

### 7. Caching Strategies
```python
import functools
import time
from typing import Optional, Any

class LRUCache:
    """Least Recently Used cache with TTL support"""
    def __init__(self, max_size: int = 128, ttl: int = 300):
        self.cache = {}
        self.max_size = max_size
        self.ttl = ttl
        self.access_order = []
    
    def get(self, key: str) -> Optional[Any]:
        if key in self.cache:
            entry = self.cache[key]
            if time.time() - entry['time'] < self.ttl:
                # Move to end (most recently used)
                self.access_order.remove(key)
                self.access_order.append(key)
                return entry['value']
            else:
                # Expired
                del self.cache[key]
                self.access_order.remove(key)
        return None
    
    def set(self, key: str, value: Any):
        if key in self.cache:
            self.access_order.remove(key)
        elif len(self.cache) >= self.max_size:
            # Remove least recently used
            lru_key = self.access_order.pop(0)
            del self.cache[lru_key]
        
        self.cache[key] = {'value': value, 'time': time.time()}
        self.access_order.append(key)

# Decorator-based caching
def cached(ttl: int = 300, max_size: int = 128):
    def decorator(func):
        cache = LRUCache(max_size, ttl)
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            key = str(args) + str(kwargs)
            result = cache.get(key)
            if result is not None:
                return result
            result = func(*args, **kwargs)
            cache.set(key, result)
            return result
        return wrapper
    return decorator

# Usage
@cached(ttl=60)
def get_user(user_id: int):
    return db.query(User).get(user_id)
```

### 8. Lazy Loading & Batch Processing
```python
from typing import List, Iterator
from itertools import islice

class LazyLoader:
    """Load data only when needed"""
    def __init__(self, loader_func):
        self.loader_func = loader_func
        self._data = None
    
    @property
    def data(self):
        if self._data is None:
            self._data = self.loader_func()
        return self._data

def batch_process(items: List, batch_size: int, processor):
    """Process items in batches to reduce memory usage"""
    iterator = iter(items)
    while True:
        batch = list(islice(iterator, batch_size))
        if not batch:
            break
        yield processor(batch)

# Usage
def process_large_dataset():
    # Lazy loading - data loaded only when accessed
    data = LazyLoader(lambda: load_huge_dataset())
    
    # Batch processing - process 1000 items at a time
    for batch in batch_process(data.data, 1000, process_batch):
        yield batch

# Database batch fetching
def get_users_batch(user_ids: List[int], batch_size: int = 100):
    for i in range(0, len(user_ids), batch_size):
        batch = user_ids[i:i + batch_size]
        yield User.query.filter(User.id.in_(batch)).all()
```

### 9. Memory Leak Detection
```python
import gc
import objgraph

def find_memory_leaks():
    """Find objects that are growing unboundedly"""
    gc.collect()
    
    # Show most common types
    objgraph.show_most_common_types(limit=10)
    
    # Find objects growing between snapshots
    snapshot1 = objgraph.take_snapshot()
    # ... run code ...
    gc.collect()
    snapshot2 = objgraph.take_snapshot()
    
    growth = objgraph.growth(snapshot1, snapshot2)
    print("Object growth:")
    for stat in growth[:10]:
        print(f"  {stat[0]}: +{stat[1]}")

# Weak references for detecting circular references
import weakref

class Node:
    def __init__(self, name):
        self.name = name
        self._children = []
    
    def add_child(self, child):
        self._children.append(weakref.ref(child))
```

### 10. Performance Benchmarking
```python
import timeit
import statistics

def benchmark(func, number=1000, repeat=7):
    """Benchmark a function with statistical analysis"""
    times = timeit.repeat(
        func,
        number=number,
        repeat=repeat
    )
    
    times_per_call = [t / number for t in times]
    
    return {
        'mean': statistics.mean(times_per_call),
        'median': statistics.median(times_per_call),
        'stdev': statistics.stdev(times_per_call) if len(times_per_call) > 1 else 0,
        'min': min(times_per_call),
        'max': max(times_per_call)
    }

# Usage
def my_function():
    return sum(range(1000))

stats = benchmark(my_function)
print(f"Mean: {stats['mean']*1000:.3f}ms")
print(f"Std Dev: {stats['stdev']*1000:.3f}ms")
```

## Common Patterns

### Pattern 1: Caching with Redis
```python
import redis
import json
from typing import Optional, Any

class RedisCache:
    def __init__(self, redis_client):
        self.redis = redis_client
    
    def get(self, key: str) -> Optional[Any]:
        data = self.redis.get(key)
        if data:
            return json.loads(data)
        return None
    
    def set(self, key: str, value: Any, ttl: int = 300):
        self.redis.setex(key, ttl, json.dumps(value))
    
    def invalidate(self, pattern: str):
        keys = self.redis.keys(pattern)
        if keys:
            self.redis.delete(*keys)

# Usage
cache = RedisCache(redis_client)

def get_user_cached(user_id: int):
    cache_key = f"user:{user_id}"
    result = cache.get(cache_key)
    if result:
        return result
    
    result = db.query(User).get(user_id)
    cache.set(cache_key, result.__dict__, ttl=60)
    return result
```

### Pattern 2: Connection Pooling
```python
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

# Configure connection pool
engine = create_engine(
    'postgresql://user:pass@localhost/db',
    pool_size=20,           # Maximum connections
    max_overflow=10,        # Additional connections beyond pool_size
    pool_timeout=30,        # Seconds to wait for connection
    pool_recycle=1800,      # Recycle connections after 30 minutes
    pool_pre_ping=True      # Verify connections before use
)

# For Redis
import redis
pool = redis.ConnectionPool(
    host='localhost',
    port=6379,
    db=0,
    max_connections=50,
    socket_timeout=5,
    socket_connect_timeout=5
)
r = redis.Redis(connection_pool=pool)
```

### Pattern 3: Async Processing with Celery
```python
from celery import Celery
from celery.utils.log import get_task_logger

app = Celery('tasks', broker='redis://localhost:6379/0')
logger = get_task_logger(__name__)

@app.task(bind=True, max_retries=3)
def process_data(self, data_id):
    try:
        data = db.query(Data).get(data_id)
        result = heavy_computation(data)
        return {'status': 'success', 'result': result}
    except Exception as exc:
        logger.error(f'Error processing {data_id}: {exc}')
        self.retry(exc=exc, countdown=60)

# Usage
process_data.delay(data_id=123)
```

### Pattern 4: Database Query Batching
```python
from typing import List
from sqlalchemy.orm import Session

def batch_insert(session: Session, model_class, items: List[dict], batch_size: int = 1000):
    """Insert records in batches to avoid memory issues"""
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        session.bulk_insert_mappings(model_class, batch)
        session.commit()
        print(f"Inserted batch {i // batch_size + 1}")

def batch_update(session: Session, model_class, items: List[dict], batch_size: int = 1000):
    """Update records in batches"""
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        session.bulk_update_mappings(model_class, batch)
        session.commit()
```

### Pattern 5: Lazy Loading with Generators
```python
from typing import Generator, Iterator
import csv

def lazy_read_csv(filepath: str) -> Generator[dict, None, None]:
    """Read CSV file lazily - one row at a time"""
    with open(filepath, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield row

def lazy_file_processor(filepath: str):
    """Process large files without loading entirely into memory"""
    total = 0
    for row in lazy_read_csv(filepath):
        # Process each row
        total += process_row(row)
    return total

# Usage
result = lazy_file_processor('large_data.csv')
```

## Edge Cases & Pitfalls

1. **Premature Optimization**: Optimize before measuring (measure first!)
2. **Micro-optimization**: Optimizing non-bottleneck code while ignoring big issues
3. **Cache Invalidation**: Adding cache without proper invalidation strategy
4. **N+1 Queries**: ORM lazy loading causing exponential queries
5. **Memory Leaks**: Circular references preventing garbage collection
6. **Connection Pool Exhaustion**: Too many concurrent database connections
7. **Thread Contention**: Lock serialization negating concurrency benefits
8. **Garbage Collection Pauses**: Large heap sizes causing GC pauses
9. **I/O Blocking**: Synchronous I/O in async contexts
10. **Data Structure Choice**: Wrong data structure for access patterns
11. **Index Missing**: Database queries without proper indexes
12. **Excessive Logging**: Logging in hot paths impacting performance
13. **String Concatenation**: Building strings in loops (use join or buffer)
14. **Recursion Depth**: Deep recursion causing stack overflow
15. **Network Latency**: Ignoring network round-trip costs

## Integration with Other Skills

| Skill | Integration Type | Description |
|-------|-----------------|-------------|
| project-analysis | Input | Understand system architecture and bottlenecks |
| debugging | Output | Fix performance-related bugs |
| code-review | Collaboration | Performance is part of code quality |
| database-design | Collaboration | Optimize database schema and queries |
| deployment | Output | Optimize deployment and scaling |
| ci-cd | Input | Performance testing in CI/CD pipeline |
| concurrency-debugging | Collaboration | Fix concurrency-related performance issues |
| testing | Collaboration | Performance testing and benchmarking |
| documentation | Output | Document performance optimizations |

## Output Format Templates

### Template 1: Performance Analysis Report
```markdown
# Performance Analysis Report

## Executive Summary
- **Component Analyzed**: [System/Service/Function]
- **Performance Issue**: [Description of the problem]
- **Root Cause**: [Identified bottleneck]
- **Impact**: [Users affected, latency increase, resource usage]

## Baseline Metrics
| Metric | Current Value | Target Value | Status |
|--------|---------------|--------------|--------|
| Response Time | 500ms | <100ms | ❌ |
| Throughput | 100 req/s | 1000 req/s | ❌ |
| Memory Usage | 2GB | <512MB | ❌ |
| CPU Usage | 90% | <50% | ❌ |

## Profiling Results
### CPU Profile
- **Hot Functions**: [Top CPU-consuming functions]
- **Time Distribution**: [Where time is spent]

### Memory Profile
- **Allocation Patterns**: [Where memory is allocated]
- **Leak Detection**: [Any memory leaks found]

## Optimization Recommendations
| Priority | Issue | Recommendation | Expected Impact |
|----------|-------|----------------|-----------------|
| P0 | N+1 queries | Add eager loading | 10x improvement |
| P1 | No caching | Add Redis cache | 5x improvement |
| P2 | O(n²) algorithm | Use efficient data structure | 2x improvement |

## Verification
- [ ] Benchmark before optimization
- [ ] Implement optimization
- [ ] Benchmark after optimization
- [ ] Verify no regressions
```

### Template 2: Profiling Results
```markdown
## Profiling Results

### Tool: [cProfile/perf/DevTools/etc.]

### Summary
- **Total Execution Time**: X.XXX seconds
- **Function Calls**: XX,XXX total, XX,XXX primitive
- **Memory Peak**: XXX MB

### Top 10 Time Consumers
| Rank | Function | Calls | Time (s) | Cumulative (s) |
|------|----------|-------|----------|----------------|
| 1 | function_a | 1,000 | 2.50 | 2.50 |
| 2 | function_b | 500 | 1.80 | 4.30 |
| 3 | function_c | 10,000 | 0.90 | 5.20 |

### Memory Allocation Hotspots
| Rank | Location | Allocations | Size |
|------|----------|-------------|------|
| 1 | line 42 | 1,000,000 | 50 MB |
| 2 | line 78 | 500,000 | 25 MB |
```

### Template 3: Optimization Checklist
```markdown
# Performance Optimization Checklist

## Pre-Optimization
- [ ] Define performance targets
- [ ] Establish baseline measurements
- [ ] Identify bottleneck (measure, don't guess)
- [ ] Prioritize optimizations by impact

## Algorithm Optimization
- [ ] Analyze time complexity (Big O)
- [ ] Analyze space complexity
- [ ] Choose appropriate data structures
- [ ] Eliminate redundant computations

## Database Optimization
- [ ] Add missing indexes
- [ ] Optimize slow queries (EXPLAIN ANALYZE)
- [ ] Implement connection pooling
- [ ] Add query caching
- [ ] Batch inserts/updates

## Caching
- [ ] Identify cacheable data
- [ ] Choose appropriate cache strategy
- [ ] Implement cache invalidation
- [ ] Monitor cache hit rates

## Memory Optimization
- [ ] Fix memory leaks
- [ ] Reduce object allocations
- [ ] Use generators for large datasets
- [ ] Implement data streaming

## I/O Optimization
- [ ] Use async I/O where appropriate
- [ ] Implement connection pooling
- [ ] Add request batching
- [ ] Use lazy loading

## Post-Optimization
- [ ] Verify improvements with benchmarks
- [ ] Check for regressions
- [ ] Set up monitoring
- [ ] Document changes
```

### Template 4: Performance Monitoring Setup
```markdown
# Performance Monitoring Setup

## Metrics to Collect
- [ ] Response time (p50, p95, p99)
- [ ] Throughput (requests per second)
- [ ] Error rate
- [ ] CPU usage
- [ ] Memory usage
- [ ] Disk I/O
- [ ] Network I/O
- [ ] Database query time
- [ ] Cache hit/miss ratio

## Alerting Rules
| Metric | Threshold | Severity | Action |
|--------|-----------|----------|--------|
| Response Time p99 | > 1s | Warning | Investigate |
| Response Time p99 | > 5s | Critical | Page on-call |
| Error Rate | > 1% | Warning | Investigate |
| Error Rate | > 5% | Critical | Page on-call |
| CPU Usage | > 80% | Warning | Scale up |
| Memory Usage | > 85% | Warning | Investigate |

## Dashboards
- [ ] Real-time performance overview
- [ ] Historical trends
- [ ] Service dependencies
- [ ] Database performance
- [ ] Cache performance
```

## Rules

1. **ALWAYS** measure before optimizing (baseline first)
2. **ALWAYS** profile to find the actual bottleneck
3. **NEVER** optimize code that isn't the bottleneck
4. **ALWAYS** benchmark before and after optimization
5. **ALWAYS** check for memory leaks in long-running processes
6. **ALWAYS** use appropriate data structures for access patterns
7. **ALWAYS** implement connection pooling for databases
8. **ALWAYS** add database indexes for frequently queried columns
9. **NEVER** add cache without an invalidation strategy
10. **ALWAYS** use batch operations for bulk data processing
11. **ALWAYS** implement lazy loading for large datasets
12. **ALWAYS** monitor performance in production
13. **ALWAYS** test performance under load
14. **ALWAYS** document performance optimizations
15. **NEVER** sacrifice correctness for performance

## Anti-Patterns

- ❌ Optimizing without measuring (guessing the bottleneck)
- ❌ Micro-optimizing while ignoring big issues
- ❌ Adding cache without invalidation strategy
- ❌ Optimizing code that isn't the bottleneck
- ❌ N+1 query patterns (ORM lazy loading)
- ❌ Synchronous I/O in async contexts
- ❌ Not using connection pooling
- ❌ Loading entire datasets into memory
- ❌ Ignoring database indexes
- ❌ String concatenation in loops
- ❌ Excessive logging in hot paths
- ❌ Not testing under realistic load
- ❌ Optimizing too early (premature optimization)
- ❌ Ignoring algorithm complexity (O(n²) when O(n) is possible)
- ❌ Not monitoring performance in production

## Skill Interactions

- ← project-analysis: Understand system architecture and bottlenecks
- → debugging: Fix performance-related bugs
- → code-review: Performance is part of code quality
- → database-design: Optimize database schema and queries
- → deployment: Optimize deployment and scaling
- → ci-cd: Performance testing in CI/CD pipeline
- → concurrency-debugging: Fix concurrency-related performance issues
- → testing: Performance testing and benchmarking
- → documentation: Document performance optimizations
