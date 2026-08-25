---
name: caching
description: >-
  Implement caching strategies using Redis, Memcached, CDN, browser cache, and application-level caching.
  Use this skill when the user mentions caching, cache strategy, Redis cache, Memcached, CDN,
  browser cache, cache invalidation, cache warming, cache-aside, write-through, write-behind,
  TTL, cache stampede, or says کشینگ، حافظه کش، بهینه‌سازی کش، Redis، CDN.
---

# Caching Skill — Redis, CDN, Browser Cache & Invalidation Strategies

## Overview

This skill covers comprehensive caching strategies: in-memory caching, Redis/Memcached, CDN configuration, browser caching, and cache invalidation patterns. Caching is one of the most effective performance optimizations — it can reduce latency by 10-100x and database load by 90%+. This skill provides practical patterns for implementing and managing caches.

## When to Use This Skill

- User wants to add caching to their application
- User asks about Redis, Memcached, or CDN
- User needs cache invalidation strategies
- User mentions cache-aside, write-through, or TTL
- User wants to optimize application performance via caching
- User mentions کشینگ or حافظه کش

---

## Part 1: Cache Patterns

### Pattern Comparison

| Pattern | Description | Consistency | Complexity | Use Case |
|---------|-------------|-------------|------------|----------|
| **Cache-Aside** | App manages cache | Eventual | Low | Most common |
| **Read-Through** | Cache manages reads | Eventual | Medium | Transparent caching |
| **Write-Through** | Sync write to cache+DB | Strong | Medium | Data consistency |
| **Write-Behind** | Async write to DB | Eventual | High | High write throughput |
| **Write-Around** | Write to DB only | Strong | Low | Rarely-read data |

### Cache-Aside (Lazy Loading)

```python
import redis
import json

r = redis.Redis()

def get_user(user_id):
    # 1. Check cache
    cached = r.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)
    
    # 2. Cache miss: load from DB
    user = db.query("SELECT * FROM users WHERE id = %s", (user_id,))
    
    # 3. Populate cache with TTL
    r.setex(f"user:{user_id}", 3600, json.dumps(user))  # 1 hour TTL
    
    return user

def update_user(user_id, data):
    # 1. Update database
    db.execute("UPDATE users SET ... WHERE id = %s", (user_id,))
    
    # 2. Invalidate cache
    r.delete(f"user:{user_id}")
```

### Write-Through

```python
def create_order(order_data):
    # 1. Write to cache
    order_id = generate_id()
    r.setex(f"order:{order_id}", 3600, json.dumps(order_data))
    
    # 2. Write to database (synchronous)
    db.execute("INSERT INTO orders ...", order_data)
    
    return order_id
```

### Write-Behind (Write-Back)

```python
import threading
from queue import Queue

write_queue = Queue()

def write_worker():
    while True:
        key, data = write_queue.get()
        db.execute("INSERT INTO ...", data)
        write_queue.task_done()

# Start worker thread
threading.Thread(target=write_worker, daemon=True).start()

def create_order(order_data):
    # 1. Write to cache immediately
    order_id = generate_id()
    r.setex(f"order:{order_id}", 3600, json.dumps(order_data))
    
    # 2. Queue database write (async)
    write_queue.put((f"order:{order_id}", order_data))
    
    return order_id
```

---

## Part 2: Redis Caching

### Connection Pool

```python
import redis

# Connection pool for efficiency
pool = redis.ConnectionPool(
    host='localhost',
    port=6379,
    db=0,
    max_connections=20,
    decode_responses=True
)

r = redis.Redis(connection_pool=pool)
```

### Common Operations

```python
# String (simple cache)
r.setex("key", 3600, "value")  # With TTL
r.get("key")

# Hash (object storage)
r.hset("user:123", mapping={"name": "John", "email": "john@example.com"})
r.hgetall("user:123")

# List (queue)
r.lpush("tasks", json.dumps(task))
task = json.loads(r.rpop("tasks"))

# Sorted Set (leaderboard)
r.zadd("leaderboard", {"player1": 100, "player2": 200})
top_players = r.zrevrange("leaderboard", 0, 9, withscores=True)

# Set (unique items)
r.sadd("online_users", "user1", "user2", "user3")
r.scard("online_users")  # Count

# Stream (event log)
r.xadd("events", {"type": "order", "id": "123"})
```

### Cache Stampede Prevention

```python
import threading

def get_with_lock(key, fetch_fn, ttl=3600, lock_ttl=60):
    """Prevent cache stampede with distributed lock."""
    # Try cache first
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    
    # Acquire lock
    lock_key = f"lock:{key}"
    acquired = r.set(lock_key, "1", nx=True, ex=lock_ttl)
    
    if acquired:
        try:
            # Fetch and cache
            data = fetch_fn()
            r.setex(key, ttl, json.dumps(data))
            return data
        finally:
            r.delete(lock_key)
    else:
        # Another process is caching, wait and retry
        import time
        time.sleep(0.1)
        return get_with_lock(key, fetch_fn, ttl, lock_ttl)
```

---

## Part 3: CDN Caching

### Cache Headers

```nginx
# Nginx CDN configuration
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header Vary "Accept-Encoding";
}

location /api/ {
    # No API caching by default
    add_header Cache-Control "no-store, no-cache, must-revalidate";
}
```

### Cloudflare Page Rules

```
# Cache everything for static assets
*example.com/static/*
Cache Level: Cache Everything
Edge Cache TTL: 1 month

# Cache API responses
*example.com/api/products/*
Cache Level: Cache Everything
Edge Cache TTL: 10 minutes

# Bypass cache for authenticated routes
*example.com/api/user/*
Cache Level: Bypass
```

### CDN Cache Invalidation

```python
# Cloudflare purge
import requests

def purge_cf_cache(zone_id, api_token, urls):
    """Purge specific URLs from Cloudflare cache."""
    requests.post(
        f"https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache",
        headers={"Authorization": f"Bearer {api_token}"},
        json={"files": urls}
    )

# AWS CloudFront invalidation
import boto3

cf = boto3.client('cloudfront')
cf.create_invalidation(
    DistributionId='E1234567890',
    InvalidationBatch={
        'Paths': {'Quantity': 2, 'Items': ['/api/products/*', '/static/*']},
        'CallerReference': str(time.time())
    }
)
```

---

## Part 4: Browser Caching

### HTTP Cache Headers

```http
# Strong cache (use hash in filenames)
Cache-Control: public, max-age=31536000, immutable

# Revalidation cache
Cache-Control: public, max-age=3600
ETag: "abc123"

# No cache
Cache-Control: no-store

# Private cache (user-specific)
Cache-Control: private, max-age=3600
```

### Service Worker Cache

```javascript
// Cache API responses
self.addEventListener('fetch', (event) => {
  if (event.request.url.includes('/api/')) {
    event.respondWith(
      caches.match(event.request).then((cached) => {
        const fetchPromise = fetch(event.request).then((response) => {
          // Update cache
          caches.open('api-cache').then((cache) => {
            cache.put(event.request, response.clone());
          });
          return response;
        });
        
        return cached || fetchPromise;
      })
    );
  }
});
```

---

## Part 5: Cache Invalidation

### Invalidation Strategies

| Strategy | Description | Consistency | Complexity |
|----------|-------------|-------------|------------|
| **TTL** | Auto-expire after time | Eventual | Low |
| **Event-driven** | Invalidate on data change | Strong | Medium |
| **Versioned keys** | Append version to key | Strong | Low |
| **Tag-based** | Group related keys | Strong | High |
| **Write-through** | Sync invalidation | Strong | Medium |

### TTL Strategy

```python
# Different TTLs for different data types
TTL_CONFIG = {
    "user_profile": 3600,      # 1 hour
    "product_catalog": 300,    # 5 minutes
    "session": 1800,           # 30 minutes
    "config": 86400,           # 24 hours
    "search_results": 60,      # 1 minute
}

def cache_with_type(key, data, data_type):
    ttl = TTL_CONFIG.get(data_type, 300)
    r.setex(key, ttl, json.dumps(data))
```

### Event-Driven Invalidation

```python
# Invalidate on data change
def on_user_update(user_id):
    r.delete(f"user:{user_id}")
    r.delete(f"user:{user_id}:profile")
    r.delete(f"user:{user_id}:settings")
    
    # Publish invalidation event
    r.publish("cache:invalidate", json.dumps({
        "type": "user",
        "id": user_id,
        "timestamp": time.time()
    }))
```

### Versioned Keys

```python
def get_versioned_key(base_key):
    """Get key with version for cache busting."""
    version = r.get(f"version:{base_key}") or "1"
    return f"{base_key}:v{version}"

def bump_version(base_key):
    """Increment version to invalidate all caches."""
    r.incr(f"version:{base_key}")
```

---

## Part 6: Monitoring

### Cache Metrics

```python
import time

def get_cache_stats():
    """Get cache hit/miss statistics."""
    info = r.info("stats")
    
    hits = info.get("keyspace_hits", 0)
    misses = info.get("keyspace_misses", 0)
    hit_rate = hits / (hits + misses) * 100 if (hits + misses) > 0 else 0
    
    return {
        "hits": hits,
        "misses": misses,
        "hit_rate": f"{hit_rate:.1f}%",
        "memory_used": r.info("memory").get("used_memory_human"),
    }

# Monitor cache performance
def monitor_cache(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        duration = time.time() - start
        
        # Track cache hit/miss
        cache_key = kwargs.get("cache_key")
        if r.exists(cache_key):
            record_metric("cache_hit", duration)
        else:
            record_metric("cache_miss", duration)
        
        return result
    return wrapper
```

---

## Output Format

```
## Caching Strategy

### Cache Layers
| Layer | Technology | TTL | Use Case |
|-------|-----------|-----|----------|
| [layer] | [tech] | [ttl] | [use case] |

### Invalidation Strategy
[How cache is invalidated]

### Monitoring
[Cache hit rate, memory usage]

### Cost Analysis
[Storage and compute costs]
```

## Rules

- **Cache-aside is the default** — Use it unless you have a specific reason not to
- **Always set TTL** — Don't let cache grow forever
- **Invalidate on write** — Stale data is worse than no cache
- **Monitor hit rate** — < 80% hit rate means cache isn't effective
- **Handle cache stampede** — Use locks or probabilistic early expiration
- **Use connection pools** — Don't create new connections per request
- **Compress large values** — Reduce memory usage
- **Plan for failure** — Cache should degrade gracefully, not break the app
