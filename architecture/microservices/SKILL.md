---
name: microservices
description: >-
  Design and implement microservices architecture with service boundaries, saga patterns,
  outbox pattern, service mesh, strangler fig migration, and distributed systems resilience.
  TRIGGERS: microservices, microservice architecture, service mesh, api gateway, service discovery,
  circuit breaker, saga pattern, event sourcing, cqrs, distributed transactions, service boundaries,
  strangler fig, service decomposition,
  معماری میکروسرویس، سرویس‌های کوچک، الگوهای توزیع‌شده، سرویس‌مش، دروازه API، شکست مدار، ساگا,
  微服务, 微服务架构, 服务网格, API网关, 服务发现, 断路器, 分布式事务, 事件溯源, CQRS
priority: P2
dependencies: [system-design, api-design, queue]
conflicts: []
---

# Microservices Architecture Skill — Decomposition, Communication & Distributed Patterns

## Overview

Microservices architecture decomposes a system into small, independently deployable services, each owning its data and business logic. This skill covers service boundary design via Domain-Driven Design (DDD), synchronous and asynchronous communication patterns, the Saga pattern for distributed transactions, the Outbox pattern for reliable event publishing, the Strangler Fig pattern for monolith migration, service mesh configuration, and resilience patterns (Circuit Breaker, Bulkhead, Retry). Microservices trade simplicity for scalability and team autonomy — this skill helps you make that tradeoff wisely and avoid the common pitfalls.

## When to Use This Skill

- Decomposing a monolith into independently deployable services
- Designing service boundaries using DDD bounded contexts
- Implementing Saga pattern (orchestration or choreography) for distributed transactions
- Using the Outbox pattern for reliable event publishing from services
- Migrating from a monolith using the Strangler Fig pattern
- Configuring API Gateway routing, rate limiting, and authentication
- Setting up service mesh (Istio, Linkerd) for observability and traffic management
- Implementing Circuit Breaker, Bulkhead, or Retry patterns for resilience
- Designing CQRS (Command Query Responsibility Segregation) for read/write separation
- معماری میکروسرویس (microservices architecture), الگوهای توزیع‌شده (distributed patterns)
- سرویس‌های کوچک (small services), شکست مدار (circuit breaker), ساگا (saga)
- 微服务架构 (microservices architecture), 服务网格 (service mesh)
- 分布式事务 (distributed transactions), 事件溯源 (event sourcing)

## When NOT to Use This Skill

- Building a simple application with a single team → start with a monolith
- Designing only the API layer without service decomposition → use **api-design** skill
- Working on message queue implementation only → use **queue** skill
- Performance optimization of a single service → use **performance-optimization** skill
- Database schema design only → use **database-design** skill
- No distributed systems concerns (single-process app) → use relevant language/framework skills
- Building event streaming pipelines without microservice decomposition → use **queue** skill

---

## Workflow

### Step 1: Assess Readiness for Microservices

```
Microservices Readiness Checklist:
├── 1. Do you have 3+ teams that need independent deployment?
├── 2. Does your monolith have clear bounded contexts?
├── 3. Can you tolerate network latency between services?
├── 4. Do you have CI/CD pipelines for independent deployments?
├── 5. Do you have distributed tracing infrastructure?
├── 6. Can you handle eventual consistency?
├── 7. Do you have container orchestration (Kubernetes)?
├── 8. Is your domain complex enough to justify the overhead?

IF fewer than 5 YES answers → Stay with monolith or modular monolith
```

### Step 2: Define Service Boundaries (DDD Bounded Contexts)

```yaml
# service-boundaries.yaml
domains:
  identity:
    name: Identity Service
    description: User authentication, authorization, and profile management
    owns: [User, Role, Permission, Session]
    database: identity-db (PostgreSQL)
    api: REST + JWT
    events_published: [user.created, user.updated, user.deleted]
    events_consumed: []

  catalog:
    name: Catalog Service
    description: Product catalog, categories, and inventory
    owns: [Product, Category, Inventory]
    database: catalog-db (PostgreSQL)
    api: REST + GraphQL
    events_published: [product.created, inventory.updated]
    events_consumed: [order.created]  # To reserve stock

  orders:
    name: Order Service
    description: Order lifecycle management
    owns: [Order, OrderItem, OrderStatus]
    database: orders-db (PostgreSQL)
    api: REST
    events_published: [order.created, order.completed, order.cancelled]
    events_consumed: [payment.completed, payment.failed, inventory.reserved]

  payment:
    name: Payment Service
    description: Payment processing and refunds
    owns: [Payment, Refund, Invoice]
    database: payments-db (PostgreSQL)
    api: REST (internal only)
    events_published: [payment.completed, payment.failed, payment.refunded]
    events_consumed: [order.created, order.cancelled]

  notification:
    name: Notification Service
    description: Email, SMS, and push notifications
    owns: [Notification, Template, DeliveryLog]
    database: notifications-db (PostgreSQL)
    api: REST (internal only)
    events_published: []
    events_consumed: [order.created, payment.completed, user.created]
```

### Step 3: Design Inter-Service Communication

```
Communication Pattern Selection:
├── Synchronous (REST/gRPC):
│   ├── Use when: Client needs immediate response
│   ├── Use when: Simple request-reply pattern
│   ├── Latency budget: < 200ms total
│   └── Risk: Tight coupling, cascade failures
│
├── Asynchronous (Message Queue):
│   ├── Use when: Result not needed immediately
│   ├── Use when: Cross-service data synchronization
│   ├── Use when: Event-driven side effects (notifications, analytics)
│   └── Risk: Eventual consistency, message ordering
│
└── Hybrid (Recommended):
    ├── CRUD operations → Synchronous (REST/gRPC)
    ├── State changes → Asynchronous (events via queue)
    └── Sagas → Choreography or Orchestration
```

### Step 4: Implement Resilience Patterns

```
Resilience Checklist:
├── 1. Circuit Breaker on every outbound HTTP call
├── 2. Retry with exponential backoff + jitter
├── 3. Timeout on every external call (never block forever)
├── 4. Bulkhead isolation for critical vs. non-critical paths
├── 5. Fallback responses when downstream is unavailable
├── 6. Health checks for all services (liveness + readiness)
├── 7. Graceful degradation (return partial results)
└── 8. Dead letter queues for failed async processing
```

### Step 5: Configure Observability

```
Observability Stack:
├── Distributed Tracing: Jaeger / Zipkin / AWS X-Ray
├── Metrics: Prometheus + Grafana
├── Logging: ELK Stack / Loki
├── Alerting: PagerDuty / OpsGenie
├── Service Mesh Telemetry: Istio / Linkerd
└── Logs → Traces correlation via trace ID in all logs
```

---

## Advanced Techniques

### 1. Saga Pattern — Choreography vs. Orchestration

```typescript
// ═══════════════════════════════════════════════════════════════════
// CHOREOGRAPHY-BASED SAGA (Event-Driven)
// Each service reacts to events and publishes new events
// ═══════════════════════════════════════════════════════════════════

class OrderSagaChoreography {
  // Flow:
  // order.created → inventory.reserve → inventory.reserved →
  // payment.process → payment.completed → order.confirm
  //
  // Compensation chain:
  // payment.failed → inventory.release
  // inventory.failed → order.cancel

  steps = [
    { event: 'order.created', handler: 'reserveInventory', service: 'inventory' },
    { event: 'inventory.reserved', handler: 'processPayment', service: 'payment' },
    { event: 'payment.completed', handler: 'confirmOrder', service: 'orders' },
    { event: 'payment.failed', handler: 'releaseInventory', service: 'inventory' },
    { event: 'inventory.failed', handler: 'cancelOrder', service: 'orders' },
  ];
}

// ─── Inventory Service (Choreography Participant) ────────────────
class InventoryService {
  constructor(private mq: MessageQueue) {}

  async start() {
    // React to order.created
    await this.mq.subscribe('order.created', async (event) => {
      try {
        await this.reserveStock(event.items);
        await this.mq.publish('inventory.reserved', {
          orderId: event.orderId,
          items: event.items,
        });
      } catch (error) {
        await this.mq.publish('inventory.failed', {
          orderId: event.orderId,
          reason: error.message,
        });
      }
    });

    // React to order.cancelled (compensation)
    await this.mq.subscribe('order.cancelled', async (event) => {
      await this.releaseStock(event.orderId);
    });
  }

  private async reserveStock(items: OrderItem[]) {
    for (const item of items) {
      const available = await this.db.inventory.findOne({
        where: { productId: item.productId },
      });
      if (!available || available.quantity < item.quantity) {
        throw new Error(`Insufficient stock for product ${item.productId}`);
      }
      await this.db.inventory.update(
        { productId: item.productId },
        { quantity: available.quantity - item.quantity }
      );
    }
  }

  private async releaseStock(orderId: string) {
    const reservation = await this.db.reservations.findOne({ where: { orderId } });
    if (reservation) {
      for (const item of reservation.items) {
        await this.db.inventory.increment('quantity', {
          by: item.quantity,
          where: { productId: item.productId },
        });
      }
      await this.db.reservations.update({ orderId }, { status: 'released' });
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// ORCHESTRATION-BASED SAGA (Central Coordinator)
// One service controls the entire saga flow
// ═══════════════════════════════════════════════════════════════════

class OrderSagaOrchestrator {
  private steps: SagaStep[] = [
    {
      name: 'reserve_inventory',
      execute: (ctx) => this.inventoryService.reserve(ctx.order.items),
      compensate: (ctx) => this.inventoryService.release(ctx.order.id),
    },
    {
      name: 'process_payment',
      execute: (ctx) => this.paymentService.charge(ctx.order.userId, ctx.order.totalAmountCents),
      compensate: (ctx) => this.paymentService.refund(ctx.order.userId, ctx.order.totalAmountCents),
    },
    {
      name: 'confirm_order',
      execute: (ctx) => this.orderService.confirm(ctx.order.id),
      compensate: null, // No compensation needed for final step
    },
  ];

  async execute(order: Order): Promise<SagaResult> {
    const ctx: SagaContext = { order, completedSteps: [] };

    for (const step of this.steps) {
      try {
        await step.execute(ctx);
        ctx.completedSteps.push(step.name);

        // Persist saga progress (for recovery after crash)
        await this.sagaLog.save({
          sagaId: order.id,
          step: step.name,
          status: 'completed',
          timestamp: new Date(),
        });
      } catch (error) {
        // Compensate in reverse order
        await this.compensate(ctx, error);
        return { success: false, error: error.message };
      }
    }

    return { success: true };
  }

  private async compensate(ctx: SagaContext, originalError: Error) {
    const stepsToCompensate = [...ctx.completedSteps].reverse();

    for (const stepName of stepsToCompensate) {
      const step = this.steps.find((s) => s.name === stepName);
      if (step?.compensate) {
        try {
          await step.compensate(ctx);
          await this.sagaLog.save({
            sagaId: ctx.order.id,
            step: `compensate_${stepName}`,
            status: 'completed',
          });
        } catch (compensationError) {
          // Compensation failure — manual intervention required
          await this.alertService.critical(
            `Saga compensation failed: ${stepName} for order ${ctx.order.id}`,
            { originalError: originalError.message, compensationError: compensationError.message }
          );
        }
      }
    }
  }
}
```

### 2. Outbox Pattern (Reliable Event Publishing)

```typescript
// ═══════════════════════════════════════════════════════════════════
//Transactional Outbox Pattern
// Ensures database write + event publish are atomic
// Without this, you risk: DB committed but event not published,
// or event published but DB not committed
// ═══════════════════════════════════════════════════════════════════

class OrderService {
  constructor(
    private db: Database,
    private outboxStore: OutboxStore,
    private eventPublisher: EventPublisher,
  ) {}

  async createOrder(command: CreateOrderCommand): Promise<Order> {
    // 1. Write business data + outbox event in SAME transaction
    const order = await this.db.transaction(async (tx) => {
      const order = await tx.orders.create({
        userId: command.userId,
        items: command.items,
        status: 'PENDING',
        totalAmountCents: command.totalAmountCents,
      });

      // Write event to outbox table (same transaction)
      await tx.outbox.create({
        aggregateType: 'Order',
        aggregateId: order.id,
        eventType: 'OrderCreated',
        payload: JSON.stringify({
          orderId: order.id,
          userId: order.userId,
          items: order.items,
          totalAmountCents: order.totalAmountCents,
        }),
        createdAt: new Date(),
      });

      return order;
    });

    // 2. Poll outbox and publish events (separate process)
    // This is done by the OutboxPoller (see below)
    return order;
  }
}

// ─── Outbox Poller (Separate Process) ───────────────────────────
class OutboxPoller {
  private running = false;

  constructor(
    private db: Database,
    private publisher: EventPublisher,
    private options: { pollIntervalMs: number; batchSize: number } = {
      pollIntervalMs: 1000,
      batchSize: 100,
    }
  ) {}

  async start() {
    this.running = true;
    while (this.running) {
      await this.poll();
      await sleep(this.options.pollIntervalMs);
    }
  }

  private async poll() {
    const events = await this.db.outbox.findMany({
      where: { published: false },
      orderBy: { createdAt: 'asc' },
      take: this.options.batchSize,
    });

    for (const event of events) {
      try {
        await this.publisher.publish(
          `${event.aggregateType.toLowerCase()}.${event.eventType.toLowerCase()}`,
          {
            id: event.id,
            aggregateType: event.aggregateType,
            aggregateId: event.aggregateId,
            type: event.eventType,
            payload: JSON.parse(event.payload),
            timestamp: event.createdAt.toISOString(),
          }
        );

        // Mark as published
        await this.db.outbox.update({
          where: { id: event.id },
          data: { published: true, publishedAt: new Date() },
        });
      } catch (error) {
        console.error(`Failed to publish event ${event.id}:`, error);
        // Event stays unpublished, will be retried on next poll
      }
    }
  }

  stop() {
    this.running = false;
  }
}

// ─── Outbox Table Schema (PostgreSQL) ───────────────────────────
const outboxSchema = `
  CREATE TABLE outbox_events (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregate_type  VARCHAR(255) NOT NULL,
    aggregate_id    UUID NOT NULL,
    event_type      VARCHAR(255) NOT NULL,
    payload         JSONB NOT NULL,
    published       BOOLEAN DEFAULT FALSE,
    published_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    INDEX idx_outbox_unpublished (published, created_at)
  );
`;
```

### 3. Strangler Fig Pattern (Monolith Migration)

```typescript
// ═══════════════════════════════════════════════════════════════════
// Strangler Fig: Gradually replace monolith functionality
// with microservices, routing traffic through a proxy
// ═══════════════════════════════════════════════════════════════════

// ─── API Gateway / Proxy Configuration ───────────────────────────
const gatewayRoutes = [
  // Phase 1: Route to new microservice
  {
    path: '/api/users/**',
    target: 'http://user-service:3001',
    stripPrefix: '/api/users',
    migrated: true,
  },
  // Phase 2: Route to new microservice
  {
    path: '/api/orders/**',
    target: 'http://order-service:3002',
    stripPrefix: '/api/orders',
    migrated: true,
  },
  // Phase 3: Still on monolith (not yet migrated)
  {
    path: '/api/reports/**',
    target: 'http://monolith:8080',
    stripPrefix: '/api/reports',
    migrated: false,
  },
  // Default: monolith (catch-all for unmigrated routes)
  {
    path: '/api/**',
    target: 'http://monolith:8080',
    stripPrefix: '/api',
    migrated: false,
  },
];

// ─── Feature Flag for Gradual Rollout ───────────────────────────
class MigrationRouter {
  async route(req: Request): Promise<Response> {
    const featureFlag = await this.featureFlags.get('use-new-order-service');

    if (featureFlag.enabled) {
      // New service handles the request
      return this.proxyToService(req, 'order-service');
    } else {
      // Monolith handles the request
      return this.proxyToService(req, 'monolith');
    }
  }

  // Shadow mode: Send to both, compare results
  async shadowRoute(req: Request): Promise<Response> {
    const [monolithResult, newServiceResult] = await Promise.allSettled([
      this.proxyToService(req, 'monolith'),
      this.proxyToService(req, 'order-service'),
    ]);

    // Compare results
    if (monolithResult.status === 'fulfilled' && newServiceResult.status === 'fulfilled') {
      const diff = this.compareResponses(monolithResult.value, newServiceResult.value);
      if (diff.hasDifferences) {
        this.metrics.recordDiscrepancy(req.path, diff);
      }
    }

    // Return monolith result during migration
    if (monolithResult.status === 'fulfilled') return monolithResult.value;
    throw new Error('Both monolith and new service failed');
  }
}
```

### 4. Circuit Breaker Implementation

```typescript
enum CircuitState {
  CLOSED = 'CLOSED',       // Normal operation
  OPEN = 'OPEN',           // Failing, reject requests
  HALF_OPEN = 'HALF_OPEN', // Testing recovery
}

class CircuitBreaker {
  private state = CircuitState.CLOSED;
  private failureCount = 0;
  private successCount = 0;
  private lastFailureTime = 0;
  private halfOpenMaxAttempts = 3;

  constructor(
    private options: {
      failureThreshold: number;    // Failures before opening (default: 5)
      resetTimeoutMs: number;      // Time before half-open (default: 30s)
      successThreshold: number;    // Successes before closing (default: 3)
      halfOpenMaxAttempts: number; // Max attempts in half-open (default: 3)
    } = {
      failureThreshold: 5,
      resetTimeoutMs: 30000,
      successThreshold: 3,
      halfOpenMaxAttempts: 3,
    }
  ) {}

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      if (Date.now() - this.lastFailureTime > this.options.resetTimeoutMs) {
        this.state = CircuitState.HALF_OPEN;
        this.successCount = 0;
        console.log('Circuit breaker: OPEN → HALF_OPEN');
      } else {
        throw new CircuitOpenError(
          `Circuit breaker is OPEN. Retry after ${this.options.resetTimeoutMs}ms`
        );
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
    this.failureCount = 0;

    if (this.state === CircuitState.HALF_OPEN) {
      this.successCount++;
      if (this.successCount >= this.options.successThreshold) {
        this.state = CircuitState.CLOSED;
        console.log('Circuit breaker: HALF_OPEN → CLOSED');
      }
    }
  }

  private onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();

    if (this.state === CircuitState.HALF_OPEN) {
      this.state = CircuitState.OPEN;
      console.log('Circuit breaker: HALF_OPEN → OPEN');
    } else if (this.failureCount >= this.options.failureThreshold) {
      this.state = CircuitState.OPEN;
      console.log(`Circuit breaker: CLOSED → OPEN (failures: ${this.failureCount})`);
    }
  }

  getState(): CircuitState { return this.state; }
  getFailureCount(): number { return this.failureCount; }
}

class CircuitOpenError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'CircuitOpenError';
  }
}

// ─── Usage with Service Client ──────────────────────────────────
class UserServiceClient {
  private circuit: CircuitBreaker;
  private retryOptions = { maxRetries: 3, baseDelay: 1000, maxDelay: 10000 };

  constructor(private baseUrl: string) {
    this.circuit = new CircuitBreaker({
      failureThreshold: 5,
      resetTimeoutMs: 30000,
    });
  }

  async getUser(id: string): Promise<User> {
    return this.circuit.execute(async () => {
      return this.retryWithBackoff(async () => {
        const response = await fetch(`${this.baseUrl}/api/users/${id}`, {
          signal: AbortSignal.timeout(5000), // 5s timeout
        });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        return response.json();
      });
    });
  }

  private async retryWithBackoff<T>(fn: () => Promise<T>): Promise<T> {
    const { maxRetries, baseDelay, maxDelay } = this.retryOptions;

    for (let attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await fn();
      } catch (error) {
        if (attempt === maxRetries) throw error;

        // Don't retry on 4xx client errors (except 429)
        if (error instanceof Response && error.status >= 400 && error.status < 500 && error.status !== 429) {
          throw error;
        }

        const delay = Math.min(baseDelay * Math.pow(2, attempt), maxDelay);
        const jitter = delay * 0.1 * Math.random(); // ±10% jitter
        await new Promise((resolve) => setTimeout(resolve, delay + jitter));
      }
    }
    throw new Error('Max retries exceeded');
  }
}
```

### 5. Bulkhead Pattern (Resource Isolation)

```typescript
// ═══════════════════════════════════════════════════════════════════
// Bulkhead: Isolate critical and non-critical paths
// Prevents a failing non-critical service from exhausting resources
// needed by critical services
// ═══════════════════════════════════════════════════════════════════

class Bulkhead {
  private semaphore: { permits: number; queue: Array<() => void> };

  constructor(
    private name: string,
    private maxConcurrent: number,
    private maxQueue: number = 100,
    private timeoutMs: number = 5000
  ) {
    this.semaphore = { permits: maxConcurrent, queue: [] };
  }

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.semaphore.permits <= 0) {
      if (this.semaphore.queue.length >= this.maxQueue) {
        throw new BulkheadFullError(
          `Bulkhead '${this.name}' is full (${this.maxQueue} queued)`
        );
      }

      // Wait for a permit
      await new Promise<void>((resolve, reject) => {
        const timer = setTimeout(() => {
          reject(new BulkheadTimeoutError(
            `Bulkhead '${this.name}' timed out after ${this.timeoutMs}ms`
          ));
        }, this.timeoutMs);

        this.semaphore.queue.push(() => {
          clearTimeout(timer);
          resolve();
        });
      });
    }

    this.semaphore.permits--;
    try {
      return await fn();
    } finally {
      this.semaphore.permits++;
      const next = this.semaphore.queue.shift();
      if (next) next();
    }
  }

  getAvailable(): number { return this.semaphore.permits; }
  getQueued(): number { return this.semaphore.queue.length; }
}

// ─── Bulkhead Configuration per Service ──────────────────────────
const bulkheads = {
  critical: new Bulkhead('critical', 20, 50, 5000),  // Payment, orders
  standard: new Bulkhead('standard', 15, 100, 10000), // User, catalog
  background: new Bulkhead('background', 5, 200, 30000), // Notifications, analytics
};

// ─── Usage ───────────────────────────────────────────────────────
async function handlePaymentRequest(req: Request) {
  return bulkheads.critical.execute(async () => {
    const client = new PaymentServiceClient();
    return client.processPayment(req.body);
  });
}

async function sendNotification(req: Request) {
  return bulkheads.background.execute(async () => {
    const client = new NotificationServiceClient();
    return client.send(req.body);
  });
}
```

### 6. CQRS (Command Query Responsibility Segregation)

```typescript
// ═══════════════════════════════════════════════════════════════════
// CQRS: Separate read and write models
// Write side: normalized, optimized for transactions
// Read side: denormalized, optimized for queries
// ═══════════════════════════════════════════════════════════════════

// ─── Command Side (Write Model) ─────────────────────────────────
class OrderCommandHandler {
  constructor(
    private orderRepo: OrderRepository,
    private eventStore: EventStore,
    private outbox: OutboxStore,
  ) {}

  async createOrder(cmd: CreateOrderCommand): Promise<string> {
    // 1. Create domain entity
    const order = Order.create({
      userId: cmd.userId,
      items: cmd.items,
      totalAmountCents: cmd.totalAmountCents,
    });

    // 2. Persist to write database
    await this.orderRepo.save(order);

    // 3. Store events in event store
    for (const event of order.domainEvents) {
      await this.eventStore.append({
        aggregateType: 'Order',
        aggregateId: order.id,
        type: event.type,
        payload: event.payload,
        version: event.version,
      });
    }

    // 4. Write to outbox for reliable publishing
    for (const event of order.domainEvents) {
      await this.outbox.write({
        aggregateType: 'Order',
        aggregateId: order.id,
        eventType: event.type,
        payload: JSON.stringify(event.payload),
      });
    }

    return order.id;
  }

  async cancelOrder(cmd: CancelOrderCommand): Promise<void> {
    const order = await this.orderRepo.findById(cmd.orderId);
    if (!order) throw new NotFoundError('Order', cmd.orderId);

    order.cancel(cmd.reason);

    await this.orderRepo.save(order);
    for (const event of order.domainEvents) {
      await this.eventStore.append({
        aggregateType: 'Order',
        aggregateId: order.id,
        type: event.type,
        payload: event.payload,
        version: event.version,
      });
    }
  }
}

// ─── Query Side (Read Model) ────────────────────────────────────
class OrderQueryService {
  constructor(private readDb: ReadDatabase) {}

  async getOrder(id: string): Promise<OrderView | null> {
    return this.readDb.orders.findById(id);
  }

  async getUserOrders(userId: string, filters: OrderFilters): Promise<OrderView[]> {
    return this.readDb.orders.find({
      where: { userId, ...filters },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getOrderStats(userId: string): Promise<OrderStats> {
    return this.readDb.orders.aggregate({
      where: { userId },
      select: {
        totalOrders: 'COUNT(*)',
        totalSpent: 'SUM(total_amount_cents)',
        averageOrderValue: 'AVG(total_amount_cents)',
      },
    });
  }
}

// ─── Event Handler (Projects events to read model) ───────────────
class OrderProjectionHandler {
  constructor(private readDb: ReadDatabase) {}

  async onOrderCreated(event: OrderCreatedEvent) {
    await this.readDb.orderViews.upsert({
      id: event.orderId,
      userId: event.userId,
      orderNumber: event.orderNumber,
      totalAmountCents: event.totalAmountCents,
      status: 'PENDING',
      itemCount: event.items.length,
      createdAt: event.timestamp,
    });
  }

  async onOrderCompleted(event: OrderCompletedEvent) {
    await this.readDb.orderViews.update(
      { id: event.orderId },
      { status: 'COMPLETED', completedAt: event.timestamp }
    );
  }

  async onOrderCancelled(event: OrderCancelledEvent) {
    await this.readDb.orderViews.update(
      { id: event.orderId },
      { status: 'CANCELLED', cancelReason: event.reason, cancelledAt: event.timestamp }
    );
  }
}
```

### 7. Service Mesh Configuration (Istio)

```yaml
# ─── Istio VirtualService (Traffic Routing) ──────────────────────
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: order-service
spec:
  hosts:
    - order-service
  http:
    - route:
        - destination:
            host: order-service
            subset: v1
          weight: 90
        - destination:
            host: order-service
            subset: v2
          weight: 10  # Canary: 10% traffic to v2
      timeout: 5s
      retries:
        attempts: 3
        perTryTimeout: 2s
        retryOn: 5xx,reset,connect-failure
      fault:
        delay:
          percentage:
            value: 0.1
          fixedDelay: 5s  # Chaos testing

---
# ─── Istio DestinationRule (Circuit Breaker + Load Balancing) ─────
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: order-service
spec:
  host: order-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        h2UpgradePolicy: DEFAULT
        http1MaxPendingRequests: 100
        http2MaxRequests: 1000
        maxRequestsPerConnection: 100
        maxRetries: 3
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
    loadBalancer:
      simple: LEAST_REQUEST
  subsets:
    - name: v1
      labels:
        version: v1
    - name: v2
      labels:
        version: v2

---
# ─── Istio PeerAuthentication (mTLS) ────────────────────────────
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: production
spec:
  mtls:
    mode: STRICT
```

### 8. API Gateway Pattern

```typescript
// ─── API Gateway Configuration ───────────────────────────────────
class ApiGateway {
  private routes: RouteConfig[];
  private circuitBreakers: Map<string, CircuitBreaker>;

  constructor() {
    this.routes = [
      {
        path: '/api/v1/users',
        service: 'user-service',
        stripPrefix: '/api/v1/users',
        rateLimit: { requests: 100, per: 'minute' },
        auth: 'jwt',
        timeout: 5000,
      },
      {
        path: '/api/v1/orders',
        service: 'order-service',
        stripPrefix: '/api/v1/orders',
        rateLimit: { requests: 50, per: 'minute' },
        auth: 'jwt',
        timeout: 10000,
      },
      {
        path: '/api/v1/products',
        service: 'catalog-service',
        stripPrefix: '/api/v1/products',
        rateLimit: { requests: 200, per: 'minute' },
        auth: 'optional',
        cache: { ttl: 60, scope: 'public' },
        timeout: 3000,
      },
    ];

    this.circuitBreakers = new Map();
  }

  async handleRequest(req: Request): Promise<Response> {
    const route = this.matchRoute(req.url);
    if (!route) return new Response('Not Found', { status: 404 });

    // 1. Authentication
    if (route.auth === 'jwt') {
      const user = await this.authenticate(req);
      if (!user) return new Response('Unauthorized', { status: 401 });
      req.headers.set('X-User-Id', user.id);
      req.headers.set('X-User-Role', user.role);
    }

    // 2. Rate limiting
    const rateLimitKey = `${route.service}:${req.headers.get('X-User-Id') || req.ip}`;
    if (!this.checkRateLimit(rateLimitKey, route.rateLimit)) {
      return new Response('Too Many Requests', {
        status: 429,
        headers: { 'Retry-After': '60' },
      });
    }

    // 3. Circuit breaker
    let cb = this.circuitBreakers.get(route.service);
    if (!cb) {
      cb = new CircuitBreaker({ failureThreshold: 5, resetTimeoutMs: 30000 });
      this.circuitBreakers.set(route.service, cb);
    }

    // 4. Proxy with circuit breaker
    try {
      return await cb.execute(() => this.proxyRequest(req, route));
    } catch (error) {
      if (error instanceof CircuitOpenError) {
        return new Response('Service Unavailable', {
          status: 503,
          headers: { 'Retry-After': '30' },
        });
      }
      throw error;
    }
  }
}
```

---

## Common Patterns

### Pattern 1: Service Health Check

```typescript
import express from 'express';

const app = express();

// Liveness probe: Is the process alive?
app.get('/health/live', (req, res) => {
  res.status(200).json({ status: 'alive' });
});

// Readiness probe: Can the service handle requests?
app.get('/health/ready', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    rabbitmq: await checkRabbitMQ(),
  };

  const allHealthy = Object.values(checks).every((c) => c.status === 'ok');

  res.status(allHealthy ? 200 : 503).json({
    status: allHealthy ? 'ready' : 'not_ready',
    checks,
  });
});

async function checkDatabase() {
  try {
    await db.query('SELECT 1');
    return { status: 'ok', latencyMs: 0 };
  } catch (error) {
    return { status: 'error', message: error.message };
  }
}
```

### Pattern 2: Distributed Tracing Integration

```typescript
import { trace, context, SpanStatusCode } from '@opentelemetry/api';

const tracer = trace.getTracer('order-service');

class OrderService {
  async createOrder(command: CreateOrderCommand): Promise<Order> {
    return tracer.startActiveSpan('createOrder', async (span) => {
      try {
        span.setAttribute('order.userId', command.userId);
        span.setAttribute('order.itemCount', command.items.length);

        const order = await this.db.transaction(async (tx) => {
          // Each sub-operation creates child spans
          return tracer.startActiveSpan('db.insert', async (dbSpan) => {
            try {
              const order = await tx.orders.create(command);
              dbSpan.setStatus({ code: SpanStatusCode.OK });
              return order;
            } catch (error) {
              dbSpan.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
              throw error;
            } finally {
              dbSpan.end();
            }
          });
        });

        span.setStatus({ code: SpanStatusCode.OK });
        return order;
      } catch (error) {
        span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
        throw error;
      } finally {
        span.end();
      }
    });
  }
}
```

### Pattern 3: Event Schema Registry

```typescript
// Use a schema registry to enforce event format contracts
interface DomainEvent {
  id: string;
  type: string;
  aggregateType: string;
  aggregateId: string;
  version: number;
  timestamp: string;
  payload: Record<string, unknown>;
}

// Schema validation before publishing
class EventValidator {
  private schemas: Map<string, Schema>;

  constructor() {
    this.schemas = new Map([
      ['OrderCreated', {
        required: ['orderId', 'userId', 'items', 'totalAmountCents'],
        properties: {
          orderId: { type: 'string' },
          userId: { type: 'string' },
          items: { type: 'array', items: { type: 'object' } },
          totalAmountCents: { type: 'number', minimum: 0 },
        },
      }],
    ]);
  }

  validate(eventType: string, payload: Record<string, unknown>): void {
    const schema = this.schemas.get(eventType);
    if (!schema) throw new Error(`No schema for event type: ${eventType}`);
    // Validate payload against schema using ajv or zod
  }
}
```

### Pattern 4: Service Decomposition Decision Matrix

```typescript
// Decision framework for splitting a monolith
interface DecompositionCandidate {
  feature: string;
  businessCapability: string;
  dataOwnership: string[];
  teamOwnership: string;
  changeFrequency: string;
  deploymentIndependence: boolean;
}

function evaluateDecomposition(candidate: DecompositionCandidate): {
  score: number;
  recommendation: string;
} {
  let score = 0;

  // High change frequency → separate service
  if (candidate.changeFrequency === 'high') score += 3;
  else if (candidate.changeFrequency === 'medium') score += 1;

  // Different team ownership → separate service
  if (candidate.teamOwnership) score += 2;

  // Data isolation possible → separate service
  if (candidate.dataOwnership.length <= 3) score += 2;

  // Deployment independence desired → separate service
  if (candidate.deploymentIndependence) score += 3;

  const recommendation =
    score >= 7 ? 'EXTRACT: Strong candidate for separate service' :
    score >= 4 ? 'CONSIDER: May benefit from extraction' :
    'KEEP: Better as part of existing service';

  return { score, recommendation };
}
```

### Pattern 5: Saga State Machine

```typescript
// Saga with explicit state machine for recovery
enum SagaState {
  STARTED = 'STARTED',
  INVENTORY_RESERVED = 'INVENTORY_RESERVED',
  PAYMENT_PROCESSED = 'PAYMENT_PROCESSED',
  ORDER_CONFIRMED = 'ORDER_CONFIRMED',
  COMPENSATING = 'COMPENSATING',
  COMPENSATED = 'COMPENSATED',
  FAILED = 'FAILED',
}

const stateTransitions: Record<SagaState, SagaState[]> = {
  [SagaState.STARTED]: [SagaState.INVENTORY_RESERVED, SagaState.COMPENSATING],
  [SagaState.INVENTORY_RESERVED]: [SagaState.PAYMENT_PROCESSED, SagaState.COMPENSATING],
  [SagaState.PAYMENT_PROCESSED]: [SagaState.ORDER_CONFIRMED, SagaState.COMPENSATING],
  [SagaState.ORDER_CONFIRMED]: [],
  [SagaState.COMPENSATING]: [SagaState.COMPENSATED, SagaState.FAILED],
  [SagaState.COMPENSATED]: [],
  [SagaState.FAILED]: [],
};

class SagaStateMachine {
  private state: SagaState;
  private history: { state: SagaState; timestamp: Date; data: any }[];

  constructor(
    private sagaId: string,
    initialState: SagaState = SagaState.STARTED
  ) {
    this.state = initialState;
    this.history = [{ state: initialState, timestamp: new Date(), data: null }];
  }

  transition(newState: SagaState, data?: any): void {
    const allowed = stateTransitions[this.state];
    if (!allowed.includes(newState)) {
      throw new Error(`Invalid transition: ${this.state} → ${newState}`);
    }
    this.state = newState;
    this.history.push({ state: newState, timestamp: new Date(), data });
  }

  canTransition(newState: SagaState): boolean {
    return stateTransitions[this.state]?.includes(newState) ?? false;
  }

  getState(): SagaState { return this.state; }
  getHistory() { return [...this.history]; }
}
```

---

## Edge Cases & Pitfalls

### 1. Distributed Transactions Without Saga
Using 2PC (two-phase commit) across services is fragile and slow. Use Saga pattern with compensating transactions instead.

### 2. Circular Dependencies Between Services
Service A calls Service B which calls Service A. This creates tight coupling and deadlocks. Break cycles with events or shared data.

### 3. Data Inconsistency in CQRS Read Models
Read models can be stale. Design for eventual consistency and communicate update timing to clients (e.g., "data may be up to 5 seconds stale").

### 4. Service Discovery Failures
Hardcoded service URLs break when services move. Use DNS-based discovery (Kubernetes services) or a service registry (Consul).

### 5. Cascading Failures Without Circuit Breakers
One slow service can take down the entire system. Circuit breakers with fallbacks are mandatory.

### 6. Event Schema Evolution Breaking Consumers
Adding required fields to events breaks existing consumers. Use additive-only changes and optional fields.

### 7. Outbox Table Growth
The outbox table grows unbounded. Implement a cleanup job that deletes published events older than N days.

### 8. Orphaned Saga Compensations
A compensation might fail due to downstream unavailability. Implement a retry queue for failed compensations with alerting.

### 9. Strangler Fig Route Splitting Errors
Routing rules can send requests to the wrong service. Implement shadow mode testing before cutting over.

### 10. API Gateway as Single Point of Failure
Deploy the API gateway in a cluster with load balancing. A gateway outage means all services are unreachable.

### 11. Timeout Cascades
Service A has a 30s timeout, calls Service B (30s timeout), which calls Service C (30s timeout). Total latency can be 90s. Set aggressive per-hop timeouts.

### 12. Idempotency in Message Processing
Messages can be delivered multiple times. Every consumer must be idempotent — use message IDs or deduplication keys.

### 13. Service Mesh Complexity Overhead
Istio/Linkerd add latency (~2-5ms per hop) and operational complexity. Evaluate if the benefits justify the overhead for your scale.

### 14. Database per Service — Cross-Service Queries
You can't JOIN across service databases. Use API composition, materialized views, or event-driven denormalization.

### 15. Observability Blind Spots
Without distributed tracing, debugging cross-service failures is impossible. Instrument every service from day one.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **api-design** | ← Depends on | Each microservice needs API contracts; this skill defines inter-service APIs |
| **queue** | ← Depends on | Asynchronous communication between microservices via message queues |
| **caching** | → Feeds into | Distributed caching across services (Redis, CDN) |
| **graphql** | → Feeds into | Federation is the GraphQL layer for microservice composition |
| **performance-optimization** | → Feeds into | Latency budgeting, connection pooling, load testing |
| **database-design** | → Feeds into | Database-per-service pattern, CQRS read model design |
| **monitoring** | → Feeds into | Distributed tracing, metrics aggregation, alerting |
| **security** | → Feeds into | mTLS, JWT propagation, service-to-service auth |

---

## Output Format Templates

### Template 1: Microservices Architecture Document

```
## Microservices Architecture — [System Name]

### Service Inventory
| Service | Owner | Port | Database | Dependencies | Events |
|---------|-------|------|----------|--------------|--------|
| [name] | [team] | [port] | [db] | [deps] | [events] |

### Service Boundaries
[DDD bounded context map]

### Communication Patterns
| From | To | Pattern | Protocol | Purpose |
|------|-----|---------|----------|---------|

### Data Strategy
- Database per service: [yes/no]
- CQRS: [where applied]
- Event sourcing: [where applied]

### Resilience Configuration
| Service | Circuit Breaker | Timeout | Retry | Bulkhead |
|---------|----------------|---------|-------|----------|

### Deployment
- Container orchestration: [Kubernetes/ECS]
- CI/CD: [pipeline]
- Service mesh: [Istio/Linkerd/none]
```

### Template 2: Saga Design Document

```
## Saga Pattern — [Transaction Name]

### Saga Type: [Orchestration / Choreography]
### Participants: [list of services]
### Trigger: [event or command]

### Happy Path
1. [step] → [service] → [event]
2. [step] → [service] → [event]
3. [step] → [service] → [event]

### Compensation Path
1. [step] ← [compensate] ← [reason]
2. [step] ← [compensate] ← [reason]

### State Machine
[Diagram or state table]

### Failure Handling
- Retry strategy: [exponential backoff, max retries]
- DLQ: [queue name for failed compensations]
- Alerting: [who to notify on failure]
```

### Template 3: Migration Checklist (Strangler Fig)

```
## Monolith → Microservices Migration

### Phase N: [Feature Name]
- [ ] Identify bounded context
- [ ] Define service interface (API + events)
- [ ] Create new service repository
- [ ] Implement service with shadow mode
- [ ] Deploy with feature flag (0% traffic)
- [ ] Gradual rollout: 10% → 50% → 100%
- [ ] Remove old monolith code
- [ ] Update documentation
```

### Template 4: Service Interface Contract

```
## Service Contract — [Service Name]

### REST API
| Method | Path | Description | Auth | Rate Limit |
|--------|------|-------------|------|------------|
| GET | /api/[resource] | List | JWT | 100/min |
| POST | /api/[resource] | Create | JWT | 10/min |

### Events Published
| Event | Schema | Trigger |
|-------|--------|---------|
| [event.type] | [JSON schema] | [condition] |

### Events Consumed
| Event | Source | Handler |
|-------|--------|---------|
| [event.type] | [service] | [method] |

### Database Schema
[Tables owned by this service]

### SLA
- Availability: 99.9%
- Latency (p99): 200ms
- Error rate: < 0.1%
```

---

## Rules

1. **Start with a monolith** — Don't split until you have a clear reason (team autonomy, deployment independence, scaling needs).
2. **Own your data** — Each service has its own database. No shared databases between services.
3. **Design for failure** — Everything fails. Every outbound call needs timeout + retry + circuit breaker.
4. **Prefer async communication** — Events over direct calls. Direct calls create coupling.
5. **Implement the Outbox pattern** — Never publish events directly from business logic. Use transactional outbox.
6. **Make consumers idempotent** — Messages can be delivered twice. Every consumer must handle duplicates.
7. **Use the Saga pattern for distributed transactions** — Not 2PC. Sagas with compensating transactions.
8. **Distributed tracing is mandatory** — You can't debug cross-service issues without it.
9. **API Gateway for all external traffic** — Clients should never call services directly.
10. **Health checks on every service** — Liveness and readiness probes for container orchestration.
11. **Schema evolution is additive only** — Never remove event fields; deprecate and ignore.
12. **Monitor everything** — Metrics, logs, traces, alerts. If you can't see it, you can't fix it.
13. **Automate deployments** — Each service must be independently deployable via CI/CD.
