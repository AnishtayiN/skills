---
name: system-design
description: >-
  Designing scalable systems, microservices architectures, and infrastructure with clear component diagrams and data flow. Use this skill when the user wants system design, طراحی سیستم, design a scalable system, architecture diagram, microservices design, how should I architect this, design the backend, design the infrastructure, system architecture, high-level design, low-level design, HLD, LLD, component diagram, data flow diagram, service boundary, API gateway design, event-driven architecture, message queue design, load balancing strategy, caching strategy, how to scale X, design for high availability, distributed system design, design a platform, tech stack recommendation for architecture, CQRS, Event Sourcing, Saga Pattern, Circuit Breaker, database selection, Redis caching, Kafka vs RabbitMQ, load balancing algorithms, capacity planning, chat system design, social feed design, payment system design.
---

# System Design Skill — Scalable Architecture & Diagrams

## Overview

This skill produces concrete system designs: component breakdowns, data flows, technology choices, and scalability strategies. It focuses on making architecture decisions explicit, documenting trade-offs, and producing clear diagrams that a team can implement from. Covers advanced patterns like CQRS, Event Sourcing, Saga, Circuit Breaker, caching strategies, message queues, load balancing, and real-world system designs.

## When to Use This Skill

- User asks to design a system, service, or platform from scratch
- User needs microservices decomposition or service boundaries
- User wants an architecture diagram or component diagram
- User asks how to scale, handle load, or improve availability
- User needs to choose between architectural patterns (monolith, microservices, event-driven, etc.)
- User asks about CQRS, Event Sourcing, Saga Pattern, or distributed patterns
- User asks about database selection, caching, or message queue design
- User asks about capacity planning or load balancing strategies
- User mentions طراحی سیستم, معماری سیستم, or طراحی مقیاس‌پذیر

---

## Part 1: Design Workflow

### Phase 1: Gather Requirements

1. **Functional requirements** — What must the system do? List the core features/operations.
2. **Non-functional requirements** — Estimate or ask about:
   - Expected scale (users, requests/sec, data volume)
   - Latency requirements (real-time? batch?)
   - Availability target (99.9%? 99.99%?)
   - Consistency requirements (strong? eventual?)
   - Security/compliance needs
3. **Existing constraints** — Current tech stack, team expertise, budget, timeline.

### Phase 2: High-Level Architecture

Define the major components and how they connect:

1. **Entry points** — API gateway, load balancer, CDN, web app
2. **Core services** — Identify service boundaries using domain-driven design principles (bounded contexts)
3. **Data stores** — Which data goes where (relational DB, document store, cache, search index, object storage)
4. **Integration layer** — Message queues, event bus, service-to-service communication (REST, gRPC, events)
5. **External dependencies** — Third-party APIs, payment providers, email services

### Phase 3: Deep-Dive Each Component

### Phase 4: Address Cross-Cutting Concerns

### Phase 5: Scalability & Reliability Analysis

---

## Part 2: Design Patterns in Depth

### CQRS (Command Query Responsibility Segregation)

Separate read and write models:

```
                    ┌─────────────────────┐
   Commands ──────▶│   Write Model        │──────▶ Write DB
   (Create/Update) │  (Domain Logic)      │        (PostgreSQL)
                    └─────────────────────┘
                                                              ┌──────────
                    ┌─────────────────────┐                   │
   Queries ───────▶│   Read Model         │──────▶ Read DB ──┤ Sync
   (Get/List)      │  (Optimized Views)  │        (Redis/   │ (CDC or
                    └─────────────────────┘         ES)      │ Events)
                                                              └──────────
```

**When to use CQRS:**
- Read and write workloads have different scaling needs
- Read model needs to be denormalized/different shape than write model
- Complex domain logic on write side, simple queries on read side
- Need different data stores for reads vs writes

**Implementation:**
```typescript
// Write side: Command handler
class PlaceOrderCommandHandler {
  async handle(command: PlaceOrderCommand): Promise<void> {
    const order = Order.create(command.customerId, command.items);
    await this.orderRepo.save(order);
    
    // Publish event for read model sync
    await this.eventBus.publish(new OrderPlaced(order.id, order.data));
  }
}

// Read side: Query handler (denormalized)
class GetOrderSummaryQueryHandler {
  async handle(query: GetOrderSummaryQuery): Promise<OrderSummaryDTO> {
    // Reads from denormalized read store — fast, no joins
    return this.readStore.get(`order_summary:${query.orderId}`);
  }
}

// Sync: Event handler updates read model
class SyncOrderReadModel {
  async on(event: OrderPlaced): Promise<void> {
    await this.readStore.set(`order_summary:${event.orderId}`, {
      id: event.orderId,
      customerName: await this.getCustomerName(event.customerId),
      totalAmount: event.totalAmount,
      itemCount: event.items.length,
      status: 'placed',
      placedAt: event.occurredAt,
    });
  }
}
```

### Event Sourcing

Store all state changes as a sequence of events instead of current state:

```
Traditional:     orders table → { id: 1, status: "shipped", total: 99.99 }
Event Sourced:   events table → [
                   { type: "OrderCreated",    data: { items: [...] } },
                   { type: "PaymentReceived", data: { amount: 99.99 } },
                   { type: "OrderShipped",    data: { trackingId: "123" } }
                 ]
```

**Benefits:**
- Complete audit trail — you know everything that happened
- Temporal queries — "what was the state at time T?"
- Replay and rebuild — reconstruct state from events
- Natural fit for event-driven architectures

**Implementation:**
```typescript
class OrderAggregate {
  private events: DomainEvent[] = [];

  // Apply events to build current state
  apply(event: DomainEvent): void {
    this.events.push(event);
    this.when(event);
  }

  private when(event: DomainEvent): void {
    switch (event.eventType) {
      case 'OrderCreated':
        this.status = 'created';
        this.items = event.data.items;
        break;
      case 'OrderShipped':
        this.status = 'shipped';
        this.trackingId = event.data.trackingId;
        break;
    }
  }

  // Rebuild from event stream
  static fromEvents(events: DomainEvent[]): OrderAggregate {
    const order = new OrderAggregate();
    events.forEach(e => order.apply(e));
    return order;
  }
}
```

### Saga Pattern (Choreography vs Orchestration)

Manage distributed transactions across multiple services:

**Choreography (Event-Driven):**
```
Order Service ──▶ OrderCreated ──▶ Payment Service
                   ◀── PaymentProcessed ◀──
                       ──▶ OrderConfirmed ──▶ Inventory Service
                           ◀── StockReserved ◀──
```

**Orchestration (Central Coordinator):**
```
                    ┌──────────────────┐
                    │   Order Saga     │
                    │   Orchestrator   │
                    └────────┬─────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        Order Service   Payment Service  Inventory Service
```

**Implementation (Orchestration):**
```typescript
class OrderSaga {
  async execute(command: CreateOrderCommand): Promise<void> {
    const sagaId = generateId();
    
    try {
      // Step 1: Create order
      const order = await this.orderService.create(command);
      
      // Step 2: Process payment
      try {
        await this.paymentService.charge(order.id, order.totalAmount);
      } catch (error) {
        // Compensation: cancel order
        await this.orderService.cancel(order.id);
        throw new PaymentFailedError();
      }
      
      // Step 3: Reserve inventory
      try {
        await this.inventoryService.reserve(order.items);
      } catch (error) {
        // Compensation: refund payment, cancel order
        await this.paymentService.refund(order.id);
        await this.orderService.cancel(order.id);
        throw new InventoryError();
      }
      
      // Step 4: Confirm order
      await this.orderService.confirm(order.id);
      
    } catch (error) {
      // Log saga failure for monitoring
      await this.sagaLog.recordFailure(sagaId, error);
      throw error;
    }
  }
}
```

### Circuit Breaker Pattern

Prevent cascading failures:

```
States:
CLOSED ──(failures >= threshold)──▶ OPEN ──(timeout)──▶ HALF_OPEN
  ▲                                                       │
  └──────────(success)─────────────────────────────────────┘
                                                         │
                                           (failure) ────┘
```

```typescript
class CircuitBreaker {
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  private failureCount = 0;
  private lastFailureTime = 0;
  private successCount = 0;

  constructor(
    private failureThreshold = 5,
    private resetTimeoutMs = 30000,
    private halfOpenMaxAttempts = 3,
  ) {}

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.resetTimeoutMs) {
        this.state = 'HALF_OPEN';
        this.successCount = 0;
      } else {
        throw new CircuitOpenError();
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess() {
    if (this.state === 'HALF_OPEN') {
      this.successCount++;
      if (this.successCount >= this.halfOpenMaxAttempts) {
        this.state = 'CLOSED';
        this.failureCount = 0;
      }
    } else {
      this.failureCount = 0;
    }
  }

  private onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    if (this.state === 'HALF_OPEN' || this.failureCount >= this.failureThreshold) {
      this.state = 'OPEN';
    }
  }
}
```

---

## Part 3: Database Selection Criteria

| Database | Best For | Cons | Examples |
|----------|----------|------|----------|
| **PostgreSQL** | Complex queries, transactions, relational data | Vertical scaling limit, complex replication | User data, orders, financial records |
| **MySQL** | High-read workloads, simple schemas | Limited JSON support (improving), no full ACID in MyISAM | Content management, e-commerce catalogs |
| **MongoDB** | Document-oriented, flexible schema, rapid prototyping | No joins (aggregation pipeline is complex), eventual consistency | Product catalogs, user profiles, content |
| **Redis** | Caching, sessions, real-time leaderboards, pub/sub | Limited memory, not for persistent storage | Session store, cache layer, rate limiting |
| **DynamoDB** | Serverless, auto-scaling, key-value access patterns | Query pattern must be known upfront, expensive at scale | IoT data, gaming leaderboards, session data |
| **Elasticsearch** | Full-text search, log analytics, complex aggregations | Expensive to run, not a primary data store | Search, log aggregation, analytics |
| **Cassandra** | Write-heavy workloads, time-series data | No ad-hoc queries, eventual consistency, operational complexity | Event logs, IoT sensor data, metrics |
| **ClickHouse** | Analytics, columnar storage, aggregate queries | No updates/deletes (MergeTree), not for OLTP | Analytics dashboards, reporting |

### Decision Matrix

```
Is data relational with complex joins?
  YES → PostgreSQL (or MySQL for simpler schemas)
  NO ↓

Is it time-series or write-heavy?
  YES → Cassandra or TimescaleDB (PostgreSQL extension)
  NO ↓

Is it document-oriented with flexible schema?
  YES → MongoDB
  NO ↓

Is it key-value with simple access patterns?
  YES → Redis (if small) or DynamoDB (if large/serverless)
  NO ↓

Is it search/analytics?
  YES → Elasticsearch or ClickHouse
```

---

## Part 4: Caching Strategies

### Cache Patterns

**Cache-Aside (Lazy Loading):**
```typescript
async function getUser(id: string): Promise<User> {
  // 1. Check cache
  let user = await redis.get(`user:${id}`);
  if (user) return JSON.parse(user);

  // 2. Cache miss — fetch from DB
  user = await db.users.findById(id);
  
  // 3. Populate cache with TTL
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user));
  
  return user;
}
```

**Write-Through:**
```typescript
async function updateUser(id: string, data: Partial<User>): Promise<User> {
  const user = await db.users.update(id, data);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user)); // Write to cache too
  return user;
}
```

**Write-Behind (Write-Back):**
```typescript
async function updateUser(id: string, data: Partial<User>): Promise<User> {
  // Write to cache immediately
  await redis.setex(`user:${id}`, 3600, JSON.stringify({ ...cachedUser, ...data }));
  
  // Write to DB asynchronously (eventual consistency)
  queue.add('db-sync', { type: 'UPDATE_USER', id, data });
  
  return { ...cachedUser, ...data };
}
```

**Refresh-Ahead:**
```typescript
// Proactively refresh cache before it expires
async function getUserWithRefreshAhead(id: string): Promise<User> {
  const cached = await redis.get(`user:${id}`);
  const ttl = await redis.ttl(`user:${id}`);
  
  if (cached && ttl > 300) {
    // Still fresh — return immediately
    return JSON.parse(cached);
  }
  
  if (cached && ttl <= 300) {
    // Stale but usable — return cached, refresh in background
    queue.add('cache-refresh', { key: `user:${id}` });
    return JSON.parse(cached);
  }
  
  // No cache — fetch from DB
  const user = await db.users.findById(id);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user));
  return user;
}
```

### Cache Invalidation Patterns

**TTL-based:** Simple, automatic expiration. Set appropriate TTL per data type.
**Event-based:** Invalidate cache when source data changes via domain events.
**Versioned keys:** Use version in cache key (`user:v3:123`). Bump version on schema change.
**Tag-based invalidation:** Group related keys with tags. Invalidate all tags at once.

### Redis Patterns

**Rate Limiting (Sorted Set):**
```typescript
async function isRateLimited(userId: string, limit: number, windowMs: number): Promise<boolean> {
  const now = Date.now();
  const key = `ratelimit:${userId}`;
  
  const pipe = redis.pipeline();
  pipe.zremrangebyscore(key, 0, now - windowMs); // Remove old entries
  pipe.zadd(key, now, `${now}`); // Add current request
  pipe.zcard(key); // Count requests in window
  pipe.expire(key, windowMs / 1000); // Set TTL
  
  const results = await pipe.exec();
  const requestCount = results[2][1] as number;
  
  return requestCount > limit;
}
```

**Distributed Lock:**
```typescript
async function acquireLock(lockKey: string, ttlMs: number): Promise<string | null> {
  const token = crypto.randomUUID();
  const acquired = await redis.set(`lock:${lockKey}`, token, 'PX', ttlMs, 'NX');
  return acquired ? token : null;
}

async function releaseLock(lockKey: string, token: string): Promise<void> {
  // Lua script for atomic check-and-delete
  const script = `
    if redis.call("get", KEYS[1]) == ARGV[1] then
      return redis.call("del", KEYS[1])
    end
    return 0
  `;
  await redis.eval(script, 1, `lock:${lockKey}`, token);
}
```

**Session Store:**
```typescript
// Store sessions with automatic expiry
await redis.setex(`session:${sessionId}`, 1800, JSON.stringify({
  userId,
  role,
  permissions,
  lastAccess: Date.now(),
}));
```

---

## Part 5: Message Queue Patterns

### Kafka vs RabbitMQ vs SQS

| Feature | Kafka | RabbitMQ | SQS |
|---------|-------|----------|-----|
| **Model** | Distributed log | Message broker | Managed queue |
| **Ordering** | Per partition | Per queue | Per message group (FIFO) |
| **Retention** | Configurable (days/forever) | Until consumed | 14 days max |
| **Replay** | Yes (seek to offset) | No (consumed = gone) | No |
| **Throughput** | Very high (GB/s) | High (100K msg/s) | High (3K msg/s standard) |
| **Use case** | Event streaming, audit trail, real-time data | Task queues, RPC, routing | Simple async processing |
| **Ops overhead** | High (ZooKeeper/KRaft) | Medium | Zero (managed) |
| **Cost** | Self-hosted or Confluent | Self-hosted or CloudAMQP | Pay-per-request |

### Kafka Patterns

**Event Streaming:**
```typescript
// Producer
await producer.send({
  topic: 'orders',
  messages: [
    {
      key: orderId, // Ensures ordering per order
      value: JSON.stringify({ type: 'OrderCreated', data: orderData }),
      headers: { 'correlation-id': correlationId },
    },
  ],
});

// Consumer Group (parallel processing)
const consumer = kafka.consumer({ groupId: 'order-processor' });
await consumer.subscribe({ topic: 'orders', fromBeginning: false });

await consumer.run({
  eachMessage: async ({ topic, partition, message }) => {
    const event = JSON.parse(message.value.toString());
    await processOrderEvent(event);
  },
});
```

### RabbitMQ Patterns

**Work Queue (Task Distribution):**
```typescript
// Producer: publish tasks
channel.sendToQueue('task_queue', Buffer.from(JSON.stringify(task)), {
  persistent: true, // Survive broker restart
});

// Consumer: competing consumers
channel.consume('task_queue', async (msg) => {
  const task = JSON.parse(msg.content.toString());
  await processTask(task);
  channel.ack(msg); // Acknowledge completion
}, { noAck: false });
```

**Topic Routing:**
```typescript
// Route messages based on pattern
channel.bindQueue('email_queue', 'events', 'user.*');      // All user events
channel.bindQueue('billing_queue', 'events', 'order.paid'); // Only order.paid
channel.bindQueue('audit_queue', 'events', '#');             // All events
```

---

## Part 6: Load Balancing Algorithms

| Algorithm | How It Works | Best For |
|-----------|-------------|----------|
| **Round Robin** | Distribute requests sequentially | Servers with equal capacity |
| **Weighted Round Robin** | Distribute based on server weight | Servers with different capacities |
| **Least Connections** | Send to server with fewest active connections | Long-lived connections, variable request times |
| **IP Hash** | Hash client IP to determine server | Session affinity needed |
| **Random** | Randomly select a server | Simple, surprisingly effective |
| **Least Response Time** | Send to server with lowest avg response time | Latency-sensitive workloads |
| **Consistent Hashing** | Hash request attributes to server ring | Caching, minimizing redistribution on scaling |

**Health Checks:**
- Active: Load balancer periodically pings `/health` endpoint
- Passive: Monitor actual request failures, mark server down after threshold

---

## Part 7: Real-World System Designs

### Chat System (WhatsApp/Telegram-like)

```
┌─────────┐     ┌──────────┐     ┌──────────────┐
│  Client  │────▶│   CDN    │     │  WebSocket   │
│  (App)   │     │ (Media)  │     │  Gateway     │
└────┬─────┘     └──────────┘     └──────┬───────┘
     │                                    │
     │  HTTP (REST)                 WebSocket connections
     │                                    │
┌────▼─────┐                        ┌────▼───────┐
│  API     │                        │   Chat     │
│  Gateway │                        │   Service  │
└────┬─────┘                        └────┬───────┘
     │                                   │
┌────▼─────┐    ┌──────────┐    ┌───────▼────────┐
│  User    │    │ Message  │    │  Presence      │
│  Service │    │ Service  │    │  Service       │
└────┬─────┘    └────┬─────┘    └───────┬────────┘
     │               │                  │
     │         ┌─────▼─────┐     ┌──────▼──────┐
     │         │  Kafka    │     │   Redis     │
     │         │ (Events)  │     │ (Presence)  │
     │         └─────┬─────┘     └─────────────┘
     │               │
┌────▼───────────────▼────┐     ┌─────────────┐
│     Cassandra/ScyllaDB  │     │  PostgreSQL  │
│   (Message Storage)     │     │ (User Data)  │
└─────────────────────────┘     └─────────────┘
```

**Key decisions:**
- WebSocket for real-time messaging (persistent connections)
- Cassandra for message storage (write-heavy, time-series, partition by chat_id)
- Redis for presence (who's online, last seen)
- Kafka for event streaming between services
- CDN for media/image delivery
- End-to-end encryption keys stored client-side

**Data flow — Sending a message:**
1. Client sends message via WebSocket to Chat Gateway
2. Chat Gateway routes to Chat Service based on chat_id
3. Chat Service persists message to Cassandra (partition by chat_id, clustering by timestamp)
4. Chat Service publishes MessageSent event to Kafka
5. Delivery Service consumes event, pushes to recipient's WebSocket connection
6. Notification Service consumes event, sends push notification if recipient is offline

### Social Media Feed (Twitter/Instagram-like)

```
┌──────────┐     ┌──────────┐     ┌──────────────┐
│  Client   │────▶│   CDN    │     │  API Gateway │
└──────────┘     └──────────┘     └──────┬───────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    ▼                    ▼                    ▼
             ┌──────────┐        ┌──────────┐        ┌──────────┐
             │  Feed    │        │  Post    │        │  User    │
             │  Service │        │  Service │        │  Service │
             └────┬─────┘        └────┬─────┘        └────┬─────┘
                  │                   │                   │
             ┌────▼─────┐       ┌─────▼──────┐     ┌─────▼──────┐
             │  Redis   │       │ PostgreSQL │     │  Redis     │
             │ (Feed    │       │ (Posts,    │     │ (User      │
             │  Cache)  │       │  Comments) │     │  Cache)    │
             └──────────┘       └────────────┘     └────────────┘
```

**Feed generation strategies:**

1. **Pull model (Fan-out on read):** When user opens feed, query all followed users' posts. Simple but slow for users following many accounts.

2. **Push model (Fan-out on write):** When a user posts, write to all followers' feed caches. Fast reads, expensive writes. Good for users with few followers.

3. **Hybrid model (recommended):** Push for regular users (< 10K followers), pull for celebrity accounts (> 10K followers). Merge at read time.

```typescript
async function generateFeed(userId: string): Promise<Post[]> {
  // Get pre-computed feed from cache (fan-out on write)
  const cachedFeed = await redis.zrevrange(`feed:${userId}`, 0, 49);
  
  // Get celebrity posts (fan-out on read)
  const celebrityPosts = await getCelebrityPosts(userId);
  
  // Merge and sort by timestamp
  return mergeAndSort(cachedFeed, celebrityPosts).slice(0, 50);
}
```

### Payment System (Stripe-like)

```
┌──────────┐     ┌──────────┐     ┌────────────────┐
│  Merchant │────▶│  API     │────▶│  Payment       │
│  App      │     │  Gateway │     │  Service       │
└──────────┘     └──────────┘     └───────┬────────┘
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    ▼                     ▼                     ▼
             ┌──────────┐         ┌──────────┐         ┌──────────┐
             │  Fraud   │         │  Ledger  │         │  Bank    │
             │  Detection│        │  Service │         │  Adapter │
             └────┬─────┘         └────┬─────┘         └────┬─────┘
                  │                    │                    │
             ┌────▼─────┐        ┌─────▼──────┐     ┌─────▼──────┐
             │ ML Model │        │ PostgreSQL │     │  External  │
             │ (Real-   │        │ (Double-   │     │  Banking   │
             │  time)   │        │  entry     │     │  APIs      │
             └──────────┘        │  ledger)   │     └────────────┘
                                 └────────────┘
```

**Key design decisions:**
- **Idempotency keys** on all payment operations (retry safety)
- **Double-entry ledger** for financial records (every debit has a matching credit)
- **Event sourcing** for payment state transitions (audit trail is critical)
- **Two-phase commit** or **Saga pattern** for distributed transactions
- **Circuit breaker** on bank adapter calls (external dependencies fail)
- **Encryption at rest** for card data (PCI DSS compliance)
- **Webhook delivery** with retry for merchant notifications

---

## Part 8: Capacity Planning Formulas

### Back-of-Envelope Calculations

```
Storage:
  Daily data = requests/day × average payload size
  Annual storage = Daily data × 365 × replication factor × compression ratio
  
  Example: 1M users × 10 requests/day × 10KB = 100GB/day = 36.5TB/year
  With 3x replication and 0.5 compression: 36.5 × 3 × 0.5 = 54.75TB/year

Bandwidth:
  Peak QPS = Daily requests / 86400 × peak multiplier (typically 3-5x)
  
  Example: 100M requests/day / 86400 × 4 = ~4,630 QPS peak

Memory (Cache):
  Cache working set = hot data × avg object size
  Cache hit ratio target: 95%+ for hot data
  
  Example: 10K active users × 5KB profile = 50MB (fits in Redis easily)

CPU:
  Rule of thumb: 1 core per 1000-2000 simple requests/second
  For complex queries: 1 core per 100-500 requests/second
```

### Scaling Numbers

| Metric | Value | Implication |
|--------|-------|-------------|
| Single PostgreSQL | ~10K QPS reads, ~1K QPS writes | Add read replicas beyond this |
| Single Redis | ~100K QPS | Add Redis Cluster beyond this |
| Single Kafka broker | ~100K msgs/sec | Add partitions and brokers |
| WebSocket server | ~10K connections per core | Horizontal scale with sticky sessions |

---

## Part 9: Cross-Cutting Concerns

### Observability Stack
```
Logs:      ELK (Elasticsearch + Logstash + Kibana) or Loki + Grafana
Metrics:   Prometheus + Grafana (RED metrics: Rate, Errors, Duration)
Tracing:   Jaeger or Zipkin (distributed tracing with OpenTelemetry)
Alerting:  PagerDuty or OpsGenie (alert on SLO violations)
```

### Security Checklist
- Authentication at the edge (API Gateway)
- mTLS between internal services
- Secrets in Vault or cloud secrets manager
- Input validation at every boundary
- Rate limiting per client/IP
- DDoS protection (CDN + WAF)
- Encryption at rest and in transit
- Audit logging for all state changes

---

## Output Format

```markdown
## System Design: [System Name]

### Requirements
- **Functional:** [list]
- **Scale:** [numbers]
- **NFRs:** [latency, availability, consistency]

### Architecture Overview
[Mermaid or ASCII diagram showing components and data flow]

### Component Details

#### [Component Name]
- **Role:** [what it does]
- **Tech:** [specific technology]
- **APIs:** [key endpoints]
- **Data:** [what it stores]
- **Scaling:** [strategy]

### Data Flow
[Step-by-step walkthrough of a primary request path]

### Design Patterns Used
| Pattern | Where Applied | Why |
|---------|---------------|-----|

### Cross-Cutting Concerns
| Concern | Decision | Rationale |
|---------|----------|-----------|

### Capacity Planning
- **Storage:** [calculations]
- **Bandwidth:** [calculations]
- **Compute:** [calculations]

### Scalability Analysis
- **Bottlenecks:** [identified weak points]
- **Scaling path:** [how to grow]
- **Failure modes:** [what can break and how to handle it]
```

## Rules

- **Be technology-specific** — "PostgreSQL with read replicas" not "a database"
- **Justify every choice** — Don't just list technologies; explain why they're chosen over alternatives
- **Design for the stated scale** — Don't over-engineer a side project with Kubernetes if SQLite would work
- **Show trade-offs explicitly** — Every architectural decision has a cost; state it
- **Make the diagram the centerpiece** — A good diagram communicates more than paragraphs of text
- **Consider the data model early** — Architecture without data is just boxes and arrows
- **Apply patterns where they solve real problems** — Don't use CQRS/Event Sourcing unless the complexity is justified
- **Include capacity planning numbers** — "Can handle X QPS" is more useful than "scales well"
- **Present the response in the user's language; keep code and technical terms in English**
