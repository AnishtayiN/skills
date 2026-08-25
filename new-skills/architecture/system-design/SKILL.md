---
name: system-design
description: >-
  Design scalable system architecture. Services, data flow, scaling, trade-offs.
  TRIGGERS: system design, architecture, scalable, design system, high level design,
  hld, architecture diagram, service design, microservices, monolith, scaling,
  طراحی سیستم, معماری, طراحی مقیاس‌پذیر, سرویس‌ها, جریان داده,
  系统设计, 架构, 可扩展, 微服务, 单体架构
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# System Design Skill

## Purpose

Design scalable, maintainable system architecture. Make informed trade-offs using back-of-envelope calculations, bounded context extraction, FMEA-lite analysis, data partitioning strategies, consistency patterns, multi-region architecture, and CQRS patterns.

## When to Activate

- Designing a new system
- Scaling an existing system
- User asks about architecture decisions
- Choosing between monolith/microservices
- Designing distributed systems
- Capacity planning
- 系统设计 (system design), 架构 (architecture)
- طراحی سیستم (system design), معماری (architecture)

## When NOT to Activate

- Implementing a specific feature (→ code-generation)
- Debugging (→ debugging)
- Small code changes
- Code review only (→ code-review)

## Inputs Required

- Functional requirements
- Non-functional requirements (scale, latency, availability)
- Constraints (budget, team, timeline)
- Current system state (if evolving)

## Preconditions

- Requirements are understood
- Scale expectations are estimated

---

## Workflow

### Step 1: Understand Requirements

```
1. Functional requirements — What must it do?
2. Non-functional requirements — Performance, scale, reliability, security
3. Constraints — Budget, team size, timeline, compliance
4. Assumptions — What are we assuming?
5. Success metrics — How do we know it's working?
```

### Step 2: Back-of-Envelope Calculations

Before designing, estimate scale to guide decisions.

```
Key Calculations:
├── Users: Daily active users (DAU), monthly active users (MAU)
├── Traffic: Requests per second (RPS), peak RPS
├── Storage: Data per user × users × retention period
├── Bandwidth: Response size × RPS
├── Latency budget: End-to-end latency target
└── Availability: 99.9% = 8.76 hrs/year downtime
```

**Example Calculation**:
```
Scenario: Social media feed
├── 10M DAU
├── Each user views 10 feeds/day
├── 100M reads/day = ~1,160 RPS average
├── Peak (3x): ~3,500 RPS
├── Each feed = 1KB
├── Storage/day: 100M × 1KB = 100GB
├── Storage/year: 36.5TB
├── Bandwidth: 3,500 RPS × 1KB = 3.5MB/s peak
└── Database: Need partitioning at this scale
```

### Step 3: High-Level Design

```
1. Identify components
2. Define interfaces between components
3. Choose communication patterns (sync/async)
4. Design data flow
5. Identify bounded contexts
```

### Step 4: Trade-off Analysis

```
For each decision:
├── Option A: [description] — Pros/Cons
├── Option B: [description] — Pros/Cons
└── Recommendation: [chosen option] — Why
```

### Step 5: Document

```
## System Design

### Components
[Component list with responsibilities]

### Data Flow
[How data moves through the system]

### Trade-offs
[Key decisions and rationale]

### Scaling Strategy
[How to handle growth]

### Failure Modes
[What can go wrong and how to handle it]
```

---

## Bounded Context Extraction

Identify bounded contexts to determine service boundaries.

```
Process:
1. List all business capabilities
2. Group related capabilities
3. Identify context boundaries
4. Define integration points between contexts
5. Assign teams to contexts

Example — E-Commerce:
├── Product Context: catalog, search, pricing
├── Order Context: cart, checkout, order management
├── Payment Context: billing, refunds, invoicing
├── Shipping Context: tracking, delivery, logistics
├── User Context: auth, profile, preferences
└── Notification Context: email, push, SMS

Integration between contexts:
├── Product ↔ Order: Product lookup, price calculation
├── Order ↔ Payment: Charge, refund
├── Order ↔ Shipping: Create shipment, track
├── All ↔ Notification: Send notifications
```

**Bounded Context Rules**:
- Each context owns its data
- Communication between contexts via APIs or events
- No shared databases between contexts
- Each context can be deployed independently
- Each context has its own domain model

---

## FMEA-Lite (Failure Mode and Effects Analysis)

Analyze potential failures and their impact.

```
For each component:
├── Failure Mode: How can it fail?
├── Effect: What happens when it fails?
├── Severity: Critical / High / Medium / Low
├── Probability: High / Medium / Low
├── Detection: How do we detect the failure?
└── Mitigation: How do we prevent/recover?

Example — Payment Service:
├── Failure Mode: Payment provider timeout
├── Effect: Users can't complete purchase
├── Severity: Critical
├── Probability: Medium
├── Detection: Health check, timeout monitoring
├── Mitigation: Retry with backoff, fallback provider

Example — User Service:
├── Failure Mode: Database corruption
├── Effect: Users can't log in
├── Severity: Critical
├── Probability: Low
├── Detection: Checksum validation, replication lag
├── Mitigation: Replication, backup, point-in-time recovery
```

---

## Data Partitioning Strategies

### Horizontal Partitioning (Sharding)

```
Strategy: Split data across multiple database instances.

Approaches:
├── Hash-based: hash(user_id) % num_shards
│   ├── Pro: Even distribution
│   └── Con: Resharding is expensive
├── Range-based: user_id 1-1M → shard 1, 1M-2M → shard 2
│   ├── Pro: Easy to query ranges
│   └── Con: Hotspots if access is sequential
├── Directory-based: Lookup table maps keys to shards
│   ├── Pro: Flexible resharding
│   └── Con: Directory is single point of failure
└── Geographic: US users → US shard, EU users → EU shard
    ├── Pro: Data locality, compliance
    └── Con: Cross-region queries expensive
```

### Vertical Partitioning

```
Split tables by columns across databases.

Example — User table:
├── Database 1: user_id, name, email (frequently accessed)
├── Database 2: user_id, bio, avatar (large columns, less frequent)
└── Database 3: user_id, preferences (JSON, rarely accessed)
```

### Partitioning Decision Matrix

```
| Strategy | Best For | Trade-off |
|----------|----------|-----------|
| Hash-based | Even distribution | Resharding complexity |
| Range-based | Time-series data | Hotspot risk |
| Directory | Flexible scaling | Extra lookup latency |
| Geographic | Compliance, latency | Cross-region queries |
| Vertical | Large tables | Cross-database joins |
```

---

## Consistency Patterns

### Strong Consistency

```
All reads return the most recent write.
├── When: Financial transactions, inventory management
├── How: Distributed consensus (Raft, Paxos), 2PC
├── Cost: Higher latency, lower availability
└── Example: Bank balance always accurate
```

### Eventual Consistency

```
Reads may return stale data, but will eventually be consistent.
├── When: Social media feeds, analytics, caching
├── How: Async replication, event sourcing
├── Cost: Lower latency, higher availability
└── Example: Social media post may take seconds to appear
```

### Causal Consistency

```
Operations that are causally related are seen in order.
├── When: Collaborative editing, chat applications
├── How: Vector clocks, version vectors
├── Cost: Moderate complexity
└── Example: Reply always appears after original message
```

### Consistency Patterns

```
├── Read-your-writes: User always sees their own writes
├── Monotonic reads: Once you see a value, you never see older values
├── Consistent prefixes: If you see a write, you see all prior writes
└── Session consistency: Consistency guaranteed within a session
```

---

## Multi-Region Architecture

### Active-Active (Multi-Primary)

```
Both regions handle reads and writes.

Architecture:
├── Region A (US-East): Full stack, primary DB
├── Region B (EU-West): Full stack, primary DB
├── Replication: Async between regions
├── Routing: DNS/GeoDNS directs users to nearest region
└── Conflict Resolution: Last-write-wins or CRDTs

Pros:
├── High availability (region failure doesn't stop service)
├── Low latency for users in both regions
└── Better disaster recovery

Cons:
├── Conflict resolution complexity
├── Data inconsistency window
└── Higher operational complexity
```

### Active-Passive (Primary-Replica)

```
One region handles all writes, other is standby.

Architecture:
├── Region A (US-East): Primary (reads + writes)
├── Region B (EU-West): Replica (reads only, standby for failover)
├── Replication: Synchronous or async
├── Failover: Promote replica to primary on failure
└── Routing: All writes go to primary

Pros:
├── Simpler than active-active
├── No conflict resolution needed
└── Clear data ownership

Cons:
├── Higher latency for remote users
├── Failover takes time (minutes)
└── Primary is single point of failure
```

### Multi-Region Decision Matrix

```
| Pattern | Availability | Latency | Complexity | Use Case |
|---------|-------------|---------|------------|----------|
| Active-Active | Very High | Low | High | Global apps |
| Active-Passive | High | Medium | Medium | Most apps |
| Read Replica | High | Low (reads) | Low | Read-heavy apps |
| Edge Computing | Very High | Very Low | High | CDN-like apps |
```

---

## CQRS (Command Query Responsibility Segregation)

### Pattern Overview

```
Separate read and write models.

Write Side (Commands):
├── Handles create, update, delete
├── Normalized database (3NF)
├── Optimized for writes
├── Strong consistency
└── Example: Order service writes to orders table

Read Side (Queries):
├── Handles reads, searches, reports
├── Denormalized database (read-optimized)
├── Optimized for reads
├── Eventual consistency
└── Example: Order summary view for dashboards
```

### CQRS Implementation

```
Architecture:
├── Command Handler → Write Database → Event Store
├── Event Store → Event Bus → Projection Handler
├── Projection Handler → Read Database
└── Query Handler → Read Database

Flow:
1. User places order (command)
2. Command handler validates and writes to write DB
3. Event emitted: "OrderPlaced"
4. Projection handler updates read database
5. User queries order summary (query)
6. Query handler reads from read DB (fast, denormalized)
```

### When to Use CQRS

```
Use CQRS when:
├── Read and write patterns are very different
├── Read performance is critical
├── Complex queries on write data
├── Multiple read models needed
├── Audit logging required
└── Event sourcing is beneficial

Don't use CQRS when:
├── Simple CRUD application
├── Small team (operational overhead)
├── Strong consistency required for all operations
└── Low read/write ratio
```

---

## Advanced Techniques (7 Techniques)

### 1. Capacity Planning
Use back-of-envelope calculations to estimate infrastructure needs. Calculate RPS, storage, bandwidth, and connection pools. Plan for 2-3x peak load.

### 2. Circuit Breaker Pattern
Prevent cascading failures by wrapping external calls in circuit breakers. When failures exceed threshold, stop calling the service and return fallback.

### 3. Event Sourcing
Store all changes as immutable events instead of current state. Enables temporal queries, audit trails, and event replay for debugging.

### 4. Saga Pattern
Manage distributed transactions across services using compensating transactions. Each step has an undo action that triggers on failure.

### 5. Strangler Fig Migration
Gradually replace a monolith by routing new features to microservices while keeping old features in the monolith. Risk-free migration.

### 6. Chaos Engineering
Intentionally inject failures (network latency, service crashes) to verify system resilience. Use tools like Chaos Monkey or Litmus.

### 7. Architecture Decision Records (ADR)
Document every significant architectural decision with context, options, and rationale. Future developers can understand WHY decisions were made.

---

## Common Patterns (5 Patterns with Code Examples)

### Pattern 1: API Gateway
```yaml
# API Gateway Configuration
routes:
  - path: /api/users/*
    service: user-service
    rate_limit: 100/min
    auth: required
  - path: /api/orders/*
    service: order-service
    rate_limit: 50/min
    auth: required
  - path: /api/products/*
    service: product-service
    rate_limit: 200/min
    auth: optional

cross_cutting:
  - rate_limiting
  - authentication
  - logging
  - cors
  - ssl_termination
```

### Pattern 2: Event-Driven Architecture
```python
# Event Bus Implementation
class EventBus:
    def __init__(self):
        self.subscribers = defaultdict(list)

    def subscribe(self, event_type, handler):
        self.subscribers[event_type].append(handler)

    def publish(self, event):
        for handler in self.subscribers[type(event)]:
            handler(event)

# Usage
bus = EventBus()
bus.subscribe("OrderPlaced", send_confirmation_email)
bus.subscribe("OrderPlaced", update_inventory)
bus.subscribe("OrderPlaced", notify_warehouse)

bus.publish(OrderPlaced(order_id=123, user_id=456))
```

### Pattern 3: Caching Strategy
```python
# Multi-level caching
class CacheManager:
    def __init__(self):
        self.l1_cache = {}  # In-memory (fast, small)
        self.l2_cache = Redis()  # Distributed (medium)
        self.db = Database()  # Source of truth (slow)

    def get(self, key):
        # L1: In-memory
        if key in self.l1_cache:
            return self.l1_cache[key]

        # L2: Redis
        value = self.l2_cache.get(key)
        if value:
            self.l1_cache[key] = value
            return value

        # Database
        value = self.db.query(key)
        if value:
            self.l2_cache.set(key, value, ttl=300)
            self.l1_cache[key] = value
        return value
```

### Pattern 4: Circuit Breaker
```python
import time

class CircuitBreaker:
    def __init__(self, failure_threshold=5, timeout=60):
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.timeout = timeout
        self.state = "closed"  # closed, open, half-open
        self.last_failure_time = None

    def call(self, func, *args, **kwargs):
        if self.state == "open":
            if time.time() - self.last_failure_time > self.timeout:
                self.state = "half-open"
            else:
                raise CircuitOpenError("Circuit is open")

        try:
            result = func(*args, **kwargs)
            if self.state == "half-open":
                self.state = "closed"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = "open"
            raise
```

### Pattern 5: Health Check Endpoint
```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/health")
def health_check():
    checks = {
        "database": check_database(),
        "redis": check_redis(),
        "external_api": check_external_api(),
    }
    all_healthy = all(checks.values())
    status_code = 200 if all_healthy else 503

    return jsonify({
        "status": "healthy" if all_healthy else "degraded",
        "checks": checks,
        "timestamp": datetime.utcnow().isoformat(),
    }), status_code
```

---

## Edge Cases & Pitfalls (15 Items)

1. **Single point of failure**: Every component that can fail will fail. Design for redundancy at every layer.
2. **Thundering herd**: When a cached value expires, many requests hit the database simultaneously. Use locks or staggered expiration.
3. **Data inconsistency in distributed systems**: Network partitions mean you must choose between consistency and availability (CAP theorem).
4. **Cascading failures**: One service failure triggers failures in dependent services. Use circuit breakers and bulkheads.
5. **Clock skew**: Distributed systems have different clocks. Use logical clocks (Lamport timestamps) for ordering.
6. **Split brain**: Network partition causes two leaders. Use consensus algorithms (Raft) or fencing tokens.
7. **Hotspot sharding**: One shard receives disproportionate traffic. Use consistent hashing or virtual nodes.
8. **Memory leaks in long-running services**: Gradual memory increase over time. Monitor and restart periodically.
9. **Database connection pool exhaustion**: Too many concurrent connections. Use connection pooling with limits.
10. **Schema migration in distributed systems**: Rolling deployments with schema changes require backward-compatible migrations.
11. **Idempotency in retries**: Retried requests may be processed twice. Use idempotency keys.
12. **DNS caching**: DNS changes may not propagate immediately. Use service discovery instead of DNS for critical paths.
13. **File descriptor exhaustion**: Too many open connections or files. Monitor and set ulimits.
14. **Garbage collection pauses**: JVM GC pauses can cause latency spikes. Tune GC or use low-latency collectors.
15. **Race conditions in auto-scaling**: Multiple instances starting simultaneously. Use leader election or pre-warming.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **api-design** | → Feeds into | Design APIs as part of system design |
| **database-design** | → Feeds into | Design data layer |
| **deployment** | → Feeds into | Plan deployment strategy |
| **monitoring** | → Feeds into | Design observability |
| **security** | → Feeds into | Design security architecture |
| **performance** | → Feeds into | Design for performance requirements |
| **project-analysis** | ← Provides | Understand current system |

---

## Output Format Templates

### Template 1: Standard System Design
```
## System Design — [System Name]

### Requirements
├── Functional: [list]
├── Non-functional: [list]
└── Constraints: [list]

### Back-of-Envelope Calculations
├── Users: [DAU/MAU]
├── Traffic: [RPS avg/peak]
├── Storage: [total/retention]
└── Bandwidth: [peak]

### Components
| Component | Responsibility | Technology |
|-----------|---------------|------------|
| [name] | [what it does] | [tech stack] |

### Data Flow
[Diagram or description]

### Trade-offs
| Decision | Option A | Option B | Chosen | Rationale |
|----------|----------|----------|--------|-----------|

### Scaling Strategy
[How to handle growth]

### Failure Modes (FMEA)
| Component | Failure | Impact | Mitigation |
|-----------|---------|--------|------------|
```

### Template 2: Quick Architecture Overview
```
## Architecture Overview — [System]

### Components
- [Component 1]: [responsibility]
- [Component 2]: [responsibility]

### Key Decisions
1. [Decision] — [rationale]
2. [Decision] — [rationale]

### Scale
- [key metric]: [value]
```

### Template 3: Deep Architecture Review
```
## Deep Architecture Review — [System]

### Current State Analysis
├── Components: [count and list]
├── Data stores: [count and types]
├── Dependencies: [internal and external]
└── Pain points: [known issues]

### Bounded Contexts
| Context | Domain | Team | Database |
|---------|--------|------|----------|

### FMEA Analysis
[Full FMEA table]

### Data Partitioning
[Strategy and rationale]

### Consistency Model
[Pattern used and why]

### Multi-Region Strategy
[Active-active/active-passive and rationale]

### CQRS Analysis
[Read/write model separation]

### Recommendations
[Prioritized list of improvements]
```

### Template 4: Agent-Specific (Structured for Automation)
```json
{
  "system_name": "name",
  "requirements": {
    "functional": [],
    "non_functional": {"availability": "99.9%", "latency_p99": "200ms"},
    "constraints": []
  },
  "calculations": {
    "daily_active_users": 1000000,
    "requests_per_second": {"avg": 1000, "peak": 3000},
    "storage_tb": 5.0,
    "bandwidth_mbps": 10.0
  },
  "components": [
    {"name": "api-gateway", "type": "gateway", "technology": "nginx"}
  ],
  "trade_offs": [
    {"decision": "database", "chosen": "PostgreSQL", "rationale": "..."}
  ],
  "failure_modes": [
    {"component": "db", "failure": "crash", "impact": "high", "mitigation": "replication"}
  ]
}
```

---

## Rules (12 Rules)

1. **Start with requirements, not solutions** — Understand the problem before designing.
2. **Consider failure modes** — Every component can and will fail. Design for it.
3. **Document trade-offs** — Every decision has pros and cons. Record them.
4. **Keep it simple** — Don't over-engineer. Start simple, evolve as needed.
5. **Calculate before designing** — Back-of-envelope math guides architecture decisions.
6. **Design for scale, but don't premature optimize** — Build for 10x, not 1000x.
7. **Use bounded contexts for service boundaries** — Business capabilities, not technical layers.
8. **Choose consistency model intentionally** — Strong vs. eventual vs. causal.
9. **Plan for multi-region from day one** — Data locality, replication, routing.
10. **Separate read and write models when needed** — CQRS for complex systems.
11. **Record architecture decisions** — ADRs help future developers understand WHY.
12. **Test failure scenarios** — Chaos engineering validates resilience assumptions.

---

## Decision Tree

```
Scale?
├── < 1K RPS → Monolith + single DB
├── 1K-10K RPS → Monolith + read replicas + caching
├── 10K-100K RPS → Service decomposition + sharding
├── 100K+ RPS → Microservices + multi-region + CQRS
└── Not sure → Start simple, design for evolution

Consistency needs?
├── Financial / Inventory → Strong consistency
├── Social / Analytics → Eventual consistency
├── Collaborative → Causal consistency
└── Mixed → Per-operation consistency model

Data partitioning?
├── Uniform access → Hash-based sharding
├── Range queries → Range-based sharding
├── Compliance (GDPR) → Geographic partitioning
├── Large tables → Vertical partitioning
└── Complex queries → CQRS with separate read store
```

---

## Verification

- [ ] Requirements fully understood
- [ ] Back-of-envelope calculations done
- [ ] Bounded contexts identified
- [ ] FMEA-lite analysis completed
- [ ] Data partitioning strategy chosen
- [ ] Consistency model selected
- [ ] Trade-offs documented
- [ ] Failure modes identified and mitigated

## Anti-Patterns

- ❌ Over-engineering from day one
- ❌ Ignoring non-functional requirements
- ❌ Not considering failure modes
- ❌ Choosing technology before understanding requirements
- ❌ Single database for everything at scale
- ❌ Ignoring data partitioning until it's too late
- ❌ No monitoring or observability
- ❌ Shared databases between services
- ❌ Synchronous calls for everything (chatty architecture)
- ❌ Not planning for disaster recovery
- ❌ Ignoring security architecture
- ❌ No architecture decision records
