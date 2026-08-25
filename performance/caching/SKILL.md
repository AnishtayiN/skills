---
name: caching
description: >-
  Implement multi-layer caching strategies with Redis, Memcached, CDN, browser cache,
  and application-level patterns including stampede protection and invalidation.
  TRIGGERS: caching, cache strategy, redis cache, memcached, cdn, browser cache, cache
  invalidation, cache warming, cache-aside, write-through, write-behind, ttl, cache stampede,
  cache hit, cache miss, distributed cache,
  کشینگ، حافظه کش، بهینه‌سازی کش، redis، cdn، حافظه پنهان، انقضای کش، کلید کش,
  缓存, 缓存策略, Redis缓存, CDN缓存, 浏览器缓存, 缓存失效, 缓存穿透, 缓存雪崩, 缓存击穿
priority: P2
dependencies: [performance-optimization]
conflicts: []
---

# Caching Strategies Skill — Redis, CDN, Browser Cache & Invalidation

## Overview

Caching is one of the most effective performance optimizations — it can reduce latency by 10-100x and database load by 90%+. This skill covers multi-layer caching (in-memory, Redis, Memcached, CDN, browser), cache-aside/write-through/write-behind patterns, cache invalidation strategies (TTL, event-driven, versioned keys), stampede protection with distributed locks, cache warming, monitoring, and production-ready implementations. Every pattern includes production code with error handling.

## When to Use This Skill

- Adding caching to reduce database load or API latency
- Choosing between Redis, Memcached, or CDN for a specific use case
- Implementing cache-aside, write-through, or write-behind patterns
- Designing cache invalidation strategies (TTL, event-driven, versioned keys)
- Preventing cache stampede (thundering herd) with distributed locks
- Warming caches before high-traffic events (Black Friday, product launches)
- Configuring browser caching with Cache-Control, ETag, and service workers
- Optimizing CDN configuration for static assets and API responses
- Monitoring cache hit rates and identifying cache inefficiency
- کشینگ (caching), حافظه کش (cache memory), انقضای کش (cache TTL)
- بهینه‌سازی کش (cache optimization), Redis, CDN
- 缓存 (caching), 缓存策略 (cache strategy), 缓存失效 (cache invalidation)
- 缓存穿透 (cache penetration/bypass), 缓存雪崩 (cache stampede/avalanche), Redis缓存 (Redis cache)

## When NOT to Use This Skill

- General performance optimization without caching focus → use **performance-optimization** skill
- Message queue or event streaming → use **queue** skill
- API design without caching concerns → use **api-design** skill
- GraphQL caching (response-level, per-field) → use **graphql** skill
- Database indexing and query optimization → use **database-design** skill
- CDN infrastructure setup (not caching logic) → use DevOps/infrastructure skills
- No performance or latency concerns → use general coding skills

---

## Workflow

### Step 1: Identify What to Cache

```
Caching Decision Framework:
├── Data is read frequently but written infrequently → Cache it
├── Data is expensive to compute (complex queries, aggregations) → Cache it
├── Data is shared across many users → Cache it
├── Data has acceptable staleness (seconds/minutes) → Cache it
├── Data is user-specific → Cache with private scope or skip
├── Data changes on every request → Don't cache
└── Data must be 100% fresh → Don't cache or use very short TTL
```

**What NOT to Cache**:
```
├── User authentication tokens (security risk)
├── Real-time financial data (staleness = incorrect decisions)
├── Write-heavy data (cache overhead exceeds benefit)
├── Frequently changing config (use feature flags instead)
└── Personal data without proper cache scope (privacy)
```

### Step 2: Select Cache Layer

```
Cache Layer Selection:
├── L1: In-Process Memory (fastest, no network)
│   └── Use for: Hot data, computed results, configuration
│   └── Limit: Single process only, lost on restart
│
├── L2: Redis / Memcached (distributed, fast)
│   └── Use for: Shared cache across instances, sessions, rate limiting
│   └── Choose Redis when: Need data structures, persistence, pub/sub
│   └── Choose Memcached when: Simple key-value, multithreaded, flat data
│
├── L3: CDN (edge, global)
│   └── Use for: Static assets, public API responses, images
│   └── Choose Cloudflare/CloudFront: Global distribution
│
├── L4: Browser Cache (client-side)
│   └── Use for: Static files, API responses, service workers
│   └── Use Cache-Control headers + ETag
│
└── L5: Database Query Cache (last resort)
    └── Use for: Repeated identical queries
    └── Note: Most databases disable query cache by default
```

### Step 3: Choose Cache Pattern

```
Cache Pattern Selection:
├── Cache-Aside (Lazy Loading) — DEFAULT CHOICE
│   ├── App checks cache first, falls back to DB
│   ├── Simple, flexible, well-understood
│   └── Use for: Most caching scenarios
│
├── Write-Through
│   ├── Sync write to cache + DB simultaneously
│   ├── Strong consistency, cache always fresh
│   └── Use for: Data that must never be stale
│
├── Write-Behind (Write-Back)
│   ├── Write to cache immediately, async write to DB
│   ├── High write throughput, eventual consistency
│   └── Use for: Write-heavy workloads (analytics, counters)
│
├── Read-Through
│   ├── Cache manages reads (transparent to app)
│   ├── Cache itself queries DB on miss
│   └── Use for: When you want cache to own the read path
│
└── Write-Around
    ├── Write directly to DB, skip cache
    ├── Cache only populated on next read
    └── Use for: Data rarely read after write
```

### Step 4: Implement Cache Invalidation

```
Invalidation Strategy:
├── TTL (Time-To-Live) — Simplest, use by default
│   ├── Set expiration on every cached value
│   └── Stale data possible until TTL expires
│
├── Event-Driven — Invalidate on data change
│   ├── Listen to write events, delete affected cache keys
│   └── Strong consistency, but more complex
│
├── Versioned Keys — Append version to cache key
│   ├── Bump version to invalidate all caches for that key
│   └── Simple, works with any cache layer
│
├── Tag-Based — Group related keys by tags
│   ├── Invalidate all keys with a tag
│   └── Good for: Product catalog (tag: category_id)
│
└── Write-Through — Sync invalidation on write
    ├── Update cache when DB is updated
    └── Cache never stale, but write latency increases
```

### Step 5: Configure Stampede Protection

```
Stampede Prevention:
├── Distributed Lock — Only one process rebuilds cache
│   └── Other processes wait and read the rebuilt cache
├── Probabilistic Early Expiration (XFetch)
│   └── Randomly refresh cache before TTL expires
├── Request Coalescing — Deduplicate concurrent requests
│   └── One request fetches, others wait for result
└── Stale-While-Revalidate — Serve stale, refresh in background
    └── User gets immediate response, cache refreshes async
```

---

## Advanced Techniques

### 1. Multi-Layer Cache Implementation

```python
import redis
import json
import hashlib
import time
from functools import wraps
from typing import Any, Optional, Callable

# ═══════════════════════════════════════════════════════════════════
// Multi-Layer Cache: L1 (in-process) + L2 (Redis)
// Fastest possible reads with L1, shared state via L2
// ═══════════════════════════════════════════════════════════════════

class MultiLayerCache:
    def __init__(self, redis_url: str = 'redis://localhost:6379'):
        self.redis = redis.Redis.from_url(redis_url, decode_responses=True)
        self.local_cache = {}  # L1: In-process memory
        self.local_ttl = {}    # L1 TTL tracking
        self.l1_default_ttl = 5  # L1: 5 seconds (very short)

    def get(self, key: str) -> Optional[Any]:
        # L1: Check in-process memory
        if key in self.local_ttl:
            if time.time() < self.local_ttl[key]:
                return self.local_cache.get(key)
            else:
                # L1 expired, clean up
                del self.local_cache[key]
                del self.local_ttl[key]
        elif key in self.local_cache:
            # No TTL set, use default
            return self.local_cache[key]

        # L2: Check Redis
        cached = self.redis.get(f"cache:{key}")
        if cached:
            data = json.loads(cached)
            # Populate L1
            self.local_cache[key] = data
            self.local_ttl[key] = time.time() + self.l1_default_ttl
            return data

        return None

    def set(self, key: str, value: Any, ttl: int = 3600, l1_ttl: int = 5):
        serialized = json.dumps(value)

        # Write to L2 (Redis)
        self.redis.setex(f"cache:{key}", ttl, serialized)

        # Write to L1 (in-process)
        self.local_cache[key] = value
        self.local_ttl[key] = time.time() + l1_ttl

    def delete(self, key: str):
        # Remove from both layers
        self.local_cache.pop(key, None)
        self.local_ttl.pop(key, None)
        self.redis.delete(f"cache:{key}")

    def delete_pattern(self, pattern: str):
        """Delete all keys matching a pattern."""
        # L1: Scan and delete
        keys_to_delete = [k for k in self.local_cache if pattern.replace('*', '') in k]
        for k in keys_to_delete:
            del self.local_cache[k]
            self.local_ttl.pop(k, None)

        # L2: Redis SCAN + DELETE
        cursor = 0
        while True:
            cursor, keys = self.redis.scan(cursor, match=f"cache:{pattern}", count=100)
            if keys:
                self.redis.delete(*keys)
            if cursor == 0:
                break

# ─── Cache-Aside Pattern with Multi-Layer ────────────────────────
cache = MultiLayerCache()

def get_user(user_id: str) -> dict:
    """Cache-aside: Check cache, fall back to DB, populate cache."""
    # Check multi-layer cache
    cached = cache.get(f"user:{user_id}")
    if cached is not None:
        return cached

    # Cache miss: query database
    user = db.query("SELECT * FROM users WHERE id = %s", (user_id,))
    if user is None:
        # Cache negative result briefly to prevent cache penetration
        cache.set(f"user:{user_id}", None, ttl=60, l1_ttl=5)
        return None

    # Populate cache
    cache.set(f"user:{user_id}", user, ttl=3600, l1_ttl=5)
    return user

def update_user(user_id: str, data: dict):
    """Update DB and invalidate cache."""
    db.execute("UPDATE users SET ... WHERE id = %s", (user_id,))
    cache.delete(f"user:{user_id}")
    # Also invalidate related caches
    cache.delete_pattern(f"user:{user_id}:*")
```

### 2. Redis Connection Pool and Cluster

```python
import redis
from redis.cluster import RedisCluster
from redis.sentinel import Sentinel

# ═══════════════════════════════════════════════════════════════════
// Redis Production Setup: Connection pooling, Sentinel, Cluster
// ═══════════════════════════════════════════════════════════════════

# ─── Connection Pool (Single Instance) ───────────────────────────
pool = redis.ConnectionPool(
    host='localhost',
    port=6379,
    db=0,
    max_connections=20,
    decode_responses=True,
    socket_timeout=5,
    socket_connect_timeout=5,
    retry_on_timeout=True,
)
r = redis.Redis(connection_pool=pool)

# ─── Sentinel (High Availability) ────────────────────────────────
sentinel = Sentinel(
    [('sentinel-1', 26379), ('sentinel-2', 26379), ('sentinel-3', 26379)],
    socket_timeout=5,
)
master = sentinel.master_for('mymaster', socket_timeout=5)
slave = sentinel.slave_for('mymaster', socket_timeout=5)

# Read from slave, write to master
def cache_read(key):
    return slave.get(key)

def cache_write(key, value, ttl):
    master.setex(key, ttl, value)

# ─── Redis Cluster (Horizontal Scaling) ──────────────────────────
cluster = RedisCluster(
    startup_nodes=[
        {"host": "redis-1", "port": 6379},
        {"host": "redis-2", "port": 6379},
        {"host": "redis-3", "port": 6379},
    ],
    decode_responses=True,
    max_connections_per_node=10,
)

# Use cluster just like a normal Redis client
cluster.setex("key", 3600, "value")
cluster.get("key")
```

### 3. Cache Stampede Protection

```python
import redis
import json
import time
import threading
import random
from typing import Callable, Any

# ═══════════════════════════════════════════════════════════════════
// Cache Stampede (Thundering Herd):
// When a popular cache key expires, many concurrent requests
// all try to rebuild it simultaneously, overwhelming the database
// ═══════════════════════════════════════════════════════════════════

class StampedeProtectedCache:
    def __init__(self, redis_url: str = 'redis://localhost:6379'):
        self.redis = redis.Redis.from_url(redis_url, decode_responses=True)

    def get_or_set(
        self,
        key: str,
        fetch_fn: Callable[[], Any],
        ttl: int = 3600,
        lock_ttl: int = 60,
        stale_ttl: int = 300,
    ) -> Any:
        """
        Get value from cache, or fetch and cache it.

        Args:
            key: Cache key
            fetch_fn: Function to fetch data on cache miss
            ttl: Cache TTL in seconds
            lock_ttl: Distributed lock TTL (how long one process holds the lock)
            stale_ttl: How long to keep stale value (for stale-while-revalidate)
        """
        # 1. Check cache
        cached = self.redis.get(f"cache:{key}")
        if cached is not None:
            data = json.loads(cached)

            # Check if stale (for stale-while-revalidate)
            meta_key = f"cache:meta:{key}"
            meta = self.redis.hgetall(meta_key)
            if meta and time.time() - float(meta.get('created_at', 0)) > ttl - stale_ttl:
                # Serve stale immediately, refresh in background
                threading.Thread(
                    target=self._refresh_cache,
                    args=(key, fetch_fn, ttl),
                    daemon=True,
                ).start()

            return data

        # 2. Cache miss: Acquire distributed lock
        lock_key = f"lock:{key}"
        acquired = self.redis.set(lock_key, "1", nx=True, ex=lock_ttl)

        if acquired:
            # We won the lock: fetch and cache
            try:
                data = fetch_fn()
                self._set_with_meta(key, data, ttl)
                return data
            finally:
                self.redis.delete(lock_key)
        else:
            # Another process is fetching: wait and retry
            for attempt in range(10):
                time.sleep(0.05 * (attempt + 1))  # Exponential backoff
                cached = self.redis.get(f"cache:{key}")
                if cached is not None:
                    return json.loads(cached)

            # Fallback: fetch ourselves if lock holder failed
            self.redis.delete(lock_key)
            data = fetch_fn()
            self._set_with_meta(key, data, ttl)
            return data

    def _set_with_meta(self, key: str, data: Any, ttl: int):
        """Set value with metadata for stale-while-revalidate."""
        pipe = self.redis.pipeline()
        pipe.setex(f"cache:{key}", ttl, json.dumps(data))
        pipe.hset(f"cache:meta:{key}", mapping={
            'created_at': str(time.time()),
            'ttl': str(ttl),
        })
        pipe.expire(f"cache:meta:{key}", ttl)
        pipe.execute()

    def _refresh_cache(self, key: str, fetch_fn: Callable, ttl: int):
        """Background cache refresh."""
        lock_key = f"lock:{key}:refresh"
        acquired = self.redis.set(lock_key, "1", nx=True, ex=30)
        if not acquired:
            return  # Another refresh in progress

        try:
            data = fetch_fn()
            self._set_with_meta(key, data, ttl)
        finally:
            self.redis.delete(lock_key)


# ─── Probabilistic Early Expiration (XFetch) ─────────────────────
class XFetchCache:
    """
    Probabilistic early expiration: Before TTL expires,
    randomly refresh the cache to prevent stampede.
    Based on the paper "XFetch: Provably Efficient, Amortized-Optimal
    Caching for Frequently Repeated Lookups"
    """

    def get_or_set(
        self,
        key: str,
        fetch_fn: Callable[[], Any],
        ttl: int = 3600,
        beta: float = 1.0,  # Higher = more aggressive early refresh
    ) -> Any:
        cached = self.redis.hgetall(f"cache:{key}")

        if cached:
            value = json.loads(cached['value'])
            created_at = float(cached['created_at'])
            delta = time.time() - created_at

            # Probabilistic early expiration
            if delta > 0:
                probability = beta * delta / ttl
                if random.random() < probability:
                    # Early refresh (probabilistic)
                    threading.Thread(
                        target=self._background_refresh,
                        args=(key, fetch_fn, ttl),
                        daemon=True,
                    ).start()

            return value

        # Cache miss: fetch and cache
        data = fetch_fn()
        self.redis.hset(f"cache:{key}", mapping={
            'value': json.dumps(data),
            'created_at': str(time.time()),
        })
        self.redis.expire(f"cache:{key}", ttl)
        return data

    def _background_refresh(self, key: str, fetch_fn: Callable, ttl: int):
        lock_key = f"xfetch:lock:{key}"
        if not self.redis.set(lock_key, "1", nx=True, ex=30):
            return
        try:
            data = fetch_fn()
            self.redis.hset(f"cache:{key}", mapping={
                'value': json.dumps(data),
                'created_at': str(time.time()),
            })
            self.redis.expire(f"cache:{key}", ttl)
        finally:
            self.redis.delete(lock_key)
```

### 4. Cache Invalidation Patterns

```python
import redis
import json
import time
from typing import Set

# ═══════════════════════════════════════════════════════════════════
// Invalidation Strategies
// ═══════════════════════════════════════════════════════════════════

class CacheInvalidator:
    def __init__(self, redis_url: str = 'redis://localhost:6379'):
        self.redis = redis.Redis.from_url(redis_url, decode_responses=True)

    # ─── Strategy 1: TTL-Based ────────────────────────────────────
    def cache_with_ttl(self, key: str, value: Any, data_type: str):
        """Different TTLs for different data types."""
        TTL_CONFIG = {
            'user_profile': 3600,       # 1 hour
            'product_catalog': 300,     # 5 minutes
            'search_results': 60,       # 1 minute
            'config': 86400,            # 24 hours
            'session': 1800,            # 30 minutes
            'analytics': 30,            # 30 seconds
        }
        ttl = TTL_CONFIG.get(data_type, 300)
        self.redis.setex(f"cache:{key}", ttl, json.dumps(value))

    # ─── Strategy 2: Event-Driven Invalidation ────────────────────
    def on_user_updated(self, user_id: str):
        """Invalidate all caches related to a user."""
        # Delete specific keys
        self.redis.delete(
            f"cache:user:{user_id}",
            f"cache:user:{user_id}:profile",
            f"cache:user:{user_id}:settings",
        )

        # Delete pattern-matched keys
        cursor = 0
        while True:
            cursor, keys = self.redis.scan(
                cursor, match=f"cache:user:{user_id}:*", count=100
            )
            if keys:
                self.redis.delete(*keys)
            if cursor == 0:
                break

        # Publish invalidation event (for multi-instance invalidation)
        self.redis.publish("cache:invalidate", json.dumps({
            "type": "user",
            "id": user_id,
            "timestamp": time.time(),
        }))

    # ─── Strategy 3: Versioned Keys ───────────────────────────────
    def get_versioned_key(self, base_key: str) -> str:
        """Get cache key with version for cache busting."""
        version = self.redis.get(f"version:{base_key}") or "1"
        return f"{base_key}:v{version}"

    def bump_version(self, base_key: str):
        """Increment version to invalidate all caches for this key."""
        self.redis.incr(f"version:{base_key}")
        # Also set a long TTL for the version key
        self.redis.expire(f"version:{base_key}", 86400 * 30)  # 30 days

    def cache_with_version(self, base_key: str, value: Any, ttl: int = 3600):
        """Cache with versioned key."""
        versioned_key = self.get_versioned_key(base_key)
        self.redis.setex(f"cache:{versioned_key}", ttl, json.dumps(value))

    # ─── Strategy 4: Tag-Based Invalidation ───────────────────────
    def cache_with_tags(self, key: str, value: Any, tags: Set[str], ttl: int = 3600):
        """Cache value with associated tags for group invalidation."""
        pipe = self.redis.pipeline()

        # Store the value
        pipe.setex(f"cache:{key}", ttl, json.dumps(value))

        # Track which keys belong to each tag
        for tag in tags:
            pipe.sadd(f"tag:{tag}", key)
            pipe.expire(f"tag:{tag}", ttl + 60)  # Tag set lives slightly longer

        pipe.execute()

    def invalidate_tag(self, tag: str):
        """Invalidate all cache keys associated with a tag."""
        keys = self.redis.smembers(f"tag:{tag}")
        if keys:
            pipe = self.redis.pipeline()
            for key in keys:
                pipe.delete(f"cache:{key}")
            pipe.delete(f"tag:{tag}")
            pipe.execute()

    # ─── Strategy 5: Multi-Instance Invalidation via Pub/Sub ──────
    def start_invalidation_listener(self):
        """Listen for invalidation events from other instances."""
        pubsub = self.redis.pubsub()
        pubsub.subscribe("cache:invalidate")

        for message in pubsub.listen():
            if message['type'] == 'message':
                event = json.loads(message['data'])
                self._handle_invalidation(event)

    def _handle_invalidation(self, event: dict):
        """Process invalidation event from another instance."""
        cache_type = event.get('type')
        entity_id = event.get('id')

        if cache_type == 'user':
            self.redis.delete(f"cache:user:{entity_id}")
            # Also delete related keys
            cursor = 0
            while True:
                cursor, keys = self.redis.scan(
                    cursor, match=f"cache:user:{entity_id}:*", count=100
                )
                if keys:
                    self.redis.delete(*keys)
                if cursor == 0:
                    break
```

### 5. CDN Configuration

```nginx
# ═══════════════════════════════════════════════════════════════════
// Nginx CDN Configuration
// ═══════════════════════════════════════════════════════════════════

# Static assets with hash in filename (immutable)
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2|woff|ttf|eot)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header Vary "Accept-Encoding";
    add_header X-Content-Type-Options "nosniff";

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
    gzip_min_length 256;
}

# API responses (short cache)
location /api/ {
    add_header Cache-Control "public, max-age=60, stale-while-revalidate=300";
    add_header X-Cache-Status $upstream_cache_status;

    proxy_pass http://backend;
    proxy_cache api_cache;
    proxy_cache_valid 200 1m;
    proxy_cache_valid 404 10s;
    proxy_cache_use_stale error timeout updating http_500 http_502 http_503;
}

# No caching for authenticated routes
location /api/user/ {
    add_header Cache-Control "no-store, no-cache, must-revalidate";
    add_header Pragma "no-cache";

    proxy_pass http://backend;
}

# HTML pages (revalidate with ETag)
location ~* \.html$ {
    add_header Cache-Control "no-cache";
    add_header ETag "";
}
```

```python
# ═══════════════════════════════════════════════════════════════════
// Cloudflare Purge API
// ═══════════════════════════════════════════════════════════════════
import requests

class CloudflareCDN:
    def __init__(self, zone_id: str, api_token: str):
        self.zone_id = zone_id
        self.api_token = api_token
        self.base_url = f"https://api.cloudflare.com/client/v4/zones/{zone_id}"

    def purge_url(self, url: str):
        """Purge a single URL from cache."""
        response = requests.post(
            f"{self.base_url}/purge_cache",
            headers={"Authorization": f"Bearer {self.api_token}"},
            json={"files": [url]},
        )
        return response.json()

    def purge_urls(self, urls: list):
        """Purge multiple URLs from cache."""
        response = requests.post(
            f"{self.base_url}/purge_cache",
            headers={"Authorization": f"Bearer {self.api_token}"},
            json={"files": urls},
        )
        return response.json()

    def purge_all(self):
        """Purge everything from cache (use sparingly)."""
        response = requests.post(
            f"{self.base_url}/purge_cache",
            headers={"Authorization": f"Bearer {self.api_token}"},
            json={"purge_everything": True},
        )
        return response.json()

    def purge_by_tag(self, tags: list):
        """Purge cache by cache-tag (Enterprise only)."""
        response = requests.post(
            f"{self.base_url}/purge_cache",
            headers={"Authorization": f"Bearer {self.api_token}"},
            json={"tags": tags},
        )
        return response.json()
```

```python
# ═══════════════════════════════════════════════════════════════════
// AWS CloudFront Invalidation
// ═══════════════════════════════════════════════════════════════════
import boto3

class CloudFrontCDN:
    def __init__(self, distribution_id: str):
        self.client = boto3.client('cloudfront')
        self.distribution_id = distribution_id

    def invalidate_paths(self, paths: list):
        """Invalidate specific paths."""
        response = self.client.create_invalidation(
            DistributionId=self.distribution_id,
            InvalidationBatch={
                'Paths': {
                    'Quantity': len(paths),
                    'Items': paths,
                },
                'CallerReference': str(time.time()),
            },
        )
        return response['Invalidation']['Id']

    def invalidate_all(self):
        """Invalidate everything (use sparingly, costs money)."""
        return self.invalidate_paths(['/*'])
```

### 6. Cache Warming Strategy

```python
import redis
import json
import asyncio
from typing import List, Dict

# ═══════════════════════════════════════════════════════════════════
// Cache Warming: Pre-populate cache before high-traffic events
// ═══════════════════════════════════════════════════════════════════

class CacheWarmer:
    def __init__(self, redis_client: redis.Redis):
        self.redis = redis_client

    async def warm_product_catalog(self, category_ids: List[str]):
        """Pre-cache top products in each category."""
        for category_id in category_ids:
            # Fetch top products from database
            products = await db.products.find({
                where: { categoryId: category_id },
                orderBy: { salesCount: 'desc' },
                take: 50,
            })

            # Cache the results
            cache_key = f"category:{category_id}:products"
            self.redis.setex(
                f"cache:{cache_key}",
                3600,
                json.dumps(products),
            )

            # Also cache individual products
            for product in products:
                self.redis.setex(
                    f"cache:product:{product['id']}",
                    3600,
                    json.dumps(product),
                )

    async def warm_user_sessions(self, user_ids: List[str]):
        """Pre-cache user profiles for active users."""
        for user_id in user_ids:
            user = await db.users.findById(user_id)
            if user:
                self.redis.setex(
                    f"cache:user:{user_id}",
                    1800,
                    json.dumps(user),
                )

    async def warm_search_results(self, popular_queries: List[str]):
        """Pre-cache popular search results."""
        for query in popular_queries:
            results = await searchService.search(query)
            self.redis.setex(
                f"cache:search:{query.lower().strip()}",
                300,
                json.dumps(results),
            )

# ─── Scheduled Warming ───────────────────────────────────────────
async def scheduled_warming():
    """Run cache warming periodically."""
    warmer = CacheWarmer(redis_client)

    while True:
        # Warm every 30 minutes
        category_ids = await db.categories.findAllIds()
        await warmer.warm_product_catalog(category_ids)

        # Warm active users
        active_users = await db.sessions.findActiveUserIds(limit=1000)
        await warmer.warm_user_sessions(active_users)

        await asyncio.sleep(1800)  # 30 minutes
```

### 7. Cache Monitoring and Metrics

```python
import redis
import time
from typing import Dict

# ═══════════════════════════════════════════════════════════════════
// Cache Monitoring: Track hit rate, memory, key distribution
// ═══════════════════════════════════════════════════════════════════

class CacheMonitor:
    def __init__(self, redis_client: redis.Redis):
        self.redis = redis_client

    def get_stats(self) -> Dict:
        """Get comprehensive cache statistics."""
        info = self.redis.info("stats")
        memory = self.redis.info("memory")
        keyspace = self.redis.info("keyspace")

        hits = info.get("keyspace_hits", 0)
        misses = info.get("keyspace_misses", 0)
        total = hits + misses
        hit_rate = (hits / total * 100) if total > 0 else 0

        return {
            "hits": hits,
            "misses": misses,
            "hit_rate": f"{hit_rate:.1f}%",
            "hit_rate_numeric": hit_rate,
            "total_commands": info.get("total_commands_processed", 0),
            "memory_used": memory.get("used_memory_human"),
            "memory_peak": memory.get("used_memory_peak_human"),
            "connected_clients": info.get("connected_clients", 0),
            "keyspace": {
                db: {
                    "keys": db_info.get("keys", 0),
                    "expires": db_info.get("expires", 0),
                    "avg_ttl": db_info.get("avg_ttl", 0),
                }
                for db, db_info in keyspace.items()
            },
        }

    def get_key_distribution(self) -> Dict[str, int]:
        """Analyze key distribution by prefix."""
        distribution = {}
        cursor = 0

        while True:
            cursor, keys = self.redis.scan(cursor, match="cache:*", count=1000)
            for key in keys:
                # Extract prefix (e.g., "user", "product", "search")
                parts = key.replace("cache:", "").split(":")
                prefix = parts[0] if len(parts) > 1 else "other"
                distribution[prefix] = distribution.get(prefix, 0) + 1
            if cursor == 0:
                break

        return dict(sorted(distribution.items(), key=lambda x: x[1], reverse=True))

    def get_slow_keys(self, top_n: int = 10) -> list:
        """Find keys with highest access time (using SLOWLOG)."""
        slowlog = self.redis.slowlog_get(top_n)
        return [
            {
                "command": entry.get("command"),
                "duration_ms": entry.get("duration") / 1000,
                "timestamp": entry.get("start_time"),
            }
            for entry in slowlog
        ]

# ─── Decorator for Tracking Cache Performance ─────────────────────
def track_cache_performance(func):
    """Decorator to track cache hit/miss rates."""
    stats = {"hits": 0, "misses": 0, "total_time": 0}

    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - start

        stats["total_time"] += duration
        if result is not None:
            stats["hits"] += 1
        else:
            stats["misses"] += 1

        total = stats["hits"] + stats["misses"]
        hit_rate = stats["hits"] / total * 100 if total > 0 else 0

        if total % 100 == 0:  # Log every 100 requests
            print(f"Cache: {stats['hits']}/{total} hits ({hit_rate:.1f}%), "
                  f"avg {stats['total_time']/total*1000:.2f}ms")

        return result
    return wrapper
```

### 8. Cache Aside with Negative Caching

```python
# ═══════════════════════════════════════════════════════════════════
// Negative Caching: Cache "not found" results briefly
// to prevent cache penetration (repeated lookups for non-existent data)
// ═══════════════════════════════════════════════════════════════════

NOT_FOUND_SENTINEL = "__NOT_FOUND__"

class NegativeCache:
    def __init__(self, redis_client: redis.Redis):
        self.redis = redis_client

    def get_or_set(
        self,
        key: str,
        fetch_fn: Callable,
        positive_ttl: int = 3600,
        negative_ttl: int = 60,
    ) -> Optional[Any]:
        """
        Cache-aside with negative caching.
        - Found data: cached for positive_ttl
        - Not found: cached for negative_ttl (shorter)
        """
        cached = self.redis.get(f"cache:{key}")

        if cached == NOT_FOUND_SENTINEL:
            return None  # Cached negative result
        if cached is not None:
            return json.loads(cached)

        # Cache miss
        result = fetch_fn()

        if result is None:
            # Cache negative result briefly
            self.redis.setex(f"cache:{key}", negative_ttl, NOT_FOUND_SENTINEL)
        else:
            # Cache positive result
            self.redis.setex(f"cache:{key}", positive_ttl, json.dumps(result))

        return result
```

---

## Common Patterns

### Pattern 1: Cache-Aside (Lazy Loading)

```python
import redis
import json

r = redis.Redis()

def get_user(user_id: str) -> dict | None:
    # 1. Check cache
    cached = r.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)

    # 2. Cache miss: load from DB
    user = db.query("SELECT * FROM users WHERE id = %s", (user_id,))
    if user is None:
        return None

    # 3. Populate cache with TTL
    r.setex(f"user:{user_id}", 3600, json.dumps(user))
    return user

def update_user(user_id: str, data: dict):
    # 1. Update database
    db.execute("UPDATE users SET ... WHERE id = %s", (user_id,))
    # 2. Invalidate cache
    r.delete(f"user:{user_id}")
```

### Pattern 2: Write-Through

```python
def create_order(order_data: dict) -> str:
    order_id = generate_id()

    # 1. Write to cache
    r.setex(f"order:{order_id}", 3600, json.dumps({
        **order_data,
        "id": order_id,
        "status": "PENDING",
    }))

    # 2. Write to database (synchronous)
    db.execute("INSERT INTO orders ...", {**order_data, "id": order_id})

    return order_id

def update_order_status(order_id: str, status: str):
    # 1. Update database
    db.execute("UPDATE orders SET status = %s WHERE id = %s", (status, order_id))
    # 2. Update cache (write-through)
    cached = r.get(f"order:{order_id}")
    if cached:
        order = json.loads(cached)
        order["status"] = status
        r.setex(f"order:{order_id}", 3600, json.dumps(order))
```

### Pattern 3: Write-Behind (Write-Back)

```python
import threading
from queue import Queue
import json

write_queue = Queue()

def write_worker():
    """Background worker that flushes cache to DB."""
    while True:
        key, data = write_queue.get()
        try:
            db.execute("INSERT INTO analytics ...", data)
        except Exception as e:
            print(f"Failed to write {key}: {e}")
            # Re-queue for retry
            write_queue.put((key, data))
        write_queue.task_done()

# Start worker thread
threading.Thread(target=write_worker, daemon=True).start()

def record_page_view(page: str, user_id: str):
    # 1. Write to cache immediately (fast)
    counter_key = f"pageviews:{page}"
    r.incr(counter_key)
    r.expire(counter_key, 300)

    # 2. Queue DB write (async)
    write_queue.put(("pageview", {
        "page": page,
        "user_id": user_id,
        "timestamp": time.time(),
    }))
```

### Pattern 4: Stale-While-Revalidate

```python
def get_with_swr(key: str, fetch_fn: Callable, ttl: int = 300, stale_ttl: int = 600):
    """
    Serve stale data immediately, refresh in background.
    Users get fast responses; cache refreshes asynchronously.
    """
    cached = r.hgetall(f"swr:{key}")

    if cached:
        value = json.loads(cached["value"])
        created_at = float(cached["created_at"])
        age = time.time() - created_at

        if age < ttl:
            # Fresh: return directly
            return value
        elif age < ttl + stale_ttl:
            # Stale but within window: serve stale, refresh in background
            threading.Thread(
                target=_background_refresh,
                args=(key, fetch_fn, ttl),
                daemon=True,
            ).start()
            return value
        else:
            # Too old: synchronous refresh
            pass

    # Cache miss or expired: fetch synchronously
    data = fetch_fn()
    r.hset(f"swr:{key}", mapping={
        "value": json.dumps(data),
        "created_at": str(time.time()),
    })
    r.expire(f"swr:{key}", ttl + stale_ttl)
    return data

def _background_refresh(key: str, fetch_fn: Callable, ttl: int):
    lock = f"swr:lock:{key}"
    if not r.set(lock, "1", nx=True, ex=30):
        return  # Another refresh in progress
    try:
        data = fetch_fn()
        r.hset(f"swr:{key}", mapping={
            "value": json.dumps(data),
            "created_at": str(time.time()),
        })
    finally:
        r.delete(lock)
```

### Pattern 5: Cache Key Builder

```python
import hashlib
import json

class CacheKeyBuilder:
    """Generate consistent, namespaced cache keys."""

    @staticmethod
    def build(prefix: str, **kwargs) -> str:
        """Build a deterministic cache key from parameters."""
        sorted_params = json.dumps(kwargs, sort_keys=True)
        hash_val = hashlib.sha256(sorted_params.encode()).hexdigest()[:16]
        return f"{prefix}:{hash_val}"

    @staticmethod
    def user_profile(user_id: str) -> str:
        return f"user:{user_id}:profile"

    @staticmethod
    def user_orders(user_id: str, page: int, status: str = None) -> str:
        params = {"page": page, "status": status}
        sorted_params = json.dumps(params, sort_keys=True)
        hash_val = hashlib.sha256(sorted_params.encode()).hexdigest()[:16]
        return f"user:{user_id}:orders:{hash_val}"

    @staticmethod
    def product_list(category: str, sort: str, page: int) -> str:
        params = {"category": category, "sort": sort, "page": page}
        sorted_params = json.dumps(params, sort_keys=True)
        hash_val = hashlib.sha256(sorted_params.encode()).hexdigest()[:16]
        return f"products:{hash_val}"

    @staticmethod
    def search(query: str, filters: dict = None) -> str:
        params = {"query": query.lower().strip(), "filters": filters or {}}
        sorted_params = json.dumps(params, sort_keys=True)
        hash_val = hashlib.sha256(sorted_params.encode()).hexdigest()[:16]
        return f"search:{hash_val}"

# Usage
key = CacheKeyBuilder.user_profile("user_123")
cached = r.get(f"cache:{key}")
```

---

## Edge Cases & Pitfalls

### 1. Cache Penetration (Bypass)
Repeated lookups for non-existent data bypass the cache entirely. Solution: Cache negative results briefly (negative caching).

### 2. Cache Avalanche (Stampede)
Multiple cache keys expire simultaneously, causing a thundering herd of DB queries. Solution: Add jitter to TTLs, use distributed locks, stale-while-revalidate.

### 3. Cache Penetration (Hot Key)
One cache key is accessed thousands of times per second, overwhelming a single Redis node. Solution: Local L1 cache, key replication, or sharding.

### 4. Stale Data After Write
Cache-aside pattern returns stale data after a DB write if cache isn't invalidated. Solution: Invalidate on every write, use write-through.

### 5. Cache Key Collision
Two different datasets share the same cache key, returning wrong data. Solution: Namespace keys, include version in key.

### 6. Memory Exhaustion
Cache grows unbounded, exhausting Redis memory. Solution: Set maxmemory policy (allkeys-lru), monitor memory usage.

### 7. Thundering Herd on Cold Start
After a deployment or cache restart, all requests hit the DB simultaneously. Solution: Cache warming on startup.

### 8. Inconsistent Cache Across Instances
Instance A invalidates cache, but Instance B still has stale data. Solution: Use Redis Pub/Sub for cross-instance invalidation.

### 9. Cache Stampede on Popular Items
A highly popular item (flash sale) causes stampede when cache expires. Solution: Lock-based rebuild with short lock TTL.

### 10. Serialization/Deserialization Overhead
Complex objects serialized to JSON can be slow to parse. Solution: Use Protocol Buffers, MessagePack, or keep objects simple.

### 11. Connection Pool Exhaustion
Too many Redis connections from application instances. Solution: Use connection pooling, limit max connections per instance.

### 12. Cache Invalidation is Hard
Phil Karlton said: "There are only two hard things in Computer Science: cache invalidation and naming things." Design invalidation strategy upfront.

### 13. TTL Not Set
Forgotten TTL means cache grows forever. Always set TTL on every cached value.

### 14. Cache warming fails silently
Cache warming job fails but no one notices until traffic spikes. Monitor warming job success rates.

### 15. Browser Cache Serving Stale Content
Users see old versions after deployment. Use content hashing in filenames and `Cache-Control: no-cache` for HTML.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **performance-optimization** | ← Depends on | Caching is a core performance optimization technique |
| **api-design** | → Feeds into | API response caching, ETag, Cache-Control headers |
| **graphql** | → Feeds into | Response caching, per-field @cacheControl, DataLoader caching |
| **microservices** | → Feeds into | Distributed caching across services, cache invalidation events |
| **queue** | → Feeds into | Cache warming jobs, event-driven cache invalidation |
| **database-design** | → Feeds into | Query result caching, materialized view caching |
| **security** | → Feeds into | Cache security (never cache auth tokens), cache scope |

---

## Output Format Templates

### Template 1: Caching Strategy Document

```
## Caching Strategy — [Service/System]

### Cache Layers
| Layer | Technology | TTL | Use Case | Scope |
|-------|-----------|-----|----------|-------|
| L1: In-process | dict/TTLMap | 5s | Hot data | Single instance |
| L2: Distributed | Redis | 3600s | Shared state | All instances |
| L3: CDN | CloudFront | 86400s | Static assets | Global |
| L4: Browser | Cache-Control | Varies | API responses | Client |

### Invalidation Strategy
| Data Type | Pattern | TTL | Invalidation Trigger |
|-----------|---------|-----|---------------------|
| user profiles | cache-aside | 1h | On user update |
| product catalog | tag-based | 5m | On product update |
| search results | TTL only | 1m | Auto-expire |

### Stampede Protection
- Strategy: [distributed lock / SWR / XFetch]
- Lock TTL: [seconds]
- Stale window: [seconds]

### Monitoring
- Hit rate threshold: > 80%
- Memory threshold: < 80% of max
- Alert: [PagerDuty/Slack]
```

### Template 2: Cache Key Schema

```
## Cache Key Schema — [Service]

| Pattern | Example | TTL | Description |
|---------|---------|-----|-------------|
| user:{id}:profile | user:123:profile | 1h | User profile |
| user:{id}:orders:{hash} | user:123:orders:abc | 5m | User orders (paginated) |
| product:{id} | product:456 | 1h | Product details |
| category:{id}:products | category:789:products | 5m | Category product list |
| search:{hash} | search:def456 | 1m | Search results |
```

### Template 3: Invalidation Runbook

```
## Cache Invalidation Runbook

### Automatic Invalidation
[When and how cache is invalidated automatically]

### Manual Invalidation
1. Identify affected cache keys
2. Run invalidation command: [command]
3. Verify cache is repopulated: [check command]
4. Monitor hit rate for recovery

### Emergency Full Purge
1. Execute: [purge command]
2. Monitor DB load (will spike)
3. Verify cache warming completes
4. Confirm hit rate recovery
```

### Template 4: Cache Monitoring Dashboard

```
## Cache Monitoring Metrics

### Key Metrics
| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Hit rate | > 80% | < 70% |
| Memory usage | < 80% | > 90% |
| Eviction rate | < 1% | > 5% |
| Latency (p99) | < 5ms | > 20ms |
| Connection count | < 100 | > 150 |

### Dashboard Panels
- Hit rate over time (per cache layer)
- Memory usage and eviction count
- Top 10 keys by access count
- Cache miss rate by key prefix
- Redis latency percentiles
```

---

## Rules

1. **Always set TTL** — No cached value should live forever. Even "permanent" data should have a long TTL (24h+).
2. **Invalidate on every write** — Stale data is worse than no cache. Delete or update cache when the source data changes.
3. **Cache-aside is the default** — Use cache-aside unless you have a specific reason for write-through or write-behind.
4. **Monitor hit rate** — Below 80% hit rate means your cache isn't effective. Investigate key design and TTLs.
5. **Protect against stampede** — Use distributed locks, stale-while-revalidate, or probabilistic early expiration.
6. **Use connection pools** — Don't create new Redis connections per request. Use a connection pool.
7. **Compress large values** — Cache values > 1KB should be compressed to reduce memory usage.
8. **Plan for failure** — Cache should degrade gracefully. If Redis is down, fall back to DB (not crash).
9. **Namespace your keys** — Use `service:entity:id` format to prevent key collisions.
10. **Cache negative results briefly** — Prevent cache penetration by caching "not found" for 30-60 seconds.
11. **Add jitter to TTLs** — Prevent cache avalanche by adding ±10% random variation to TTL values.
12. **Warm cache before traffic spikes** — Pre-populate cache for high-traffic events (product launches, sales).
