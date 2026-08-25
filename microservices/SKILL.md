---
name: microservices
description: >-
  Design, implement, and manage microservices architecture including service decomposition,
  inter-service communication, data management, and distributed systems patterns.
  Use this skill when the user mentions microservices, microservice architecture, service mesh,
  API gateway, service discovery, circuit breaker, saga pattern, event sourcing,
  CQRS, distributed transactions, or says معماری میکروسرویس، سرویس‌های کوچک، الگوهای توزیع‌شده.
---

# Microservices Architecture Skill — Service Design, Communication & Patterns

## Overview

This skill covers microservices architecture: how to decompose a monolith, design service boundaries, implement inter-service communication, manage distributed data, and apply patterns like Circuit Breaker, Saga, CQRS, and Event Sourcing. Microservices trade simplicity for scalability and team autonomy — this skill helps you make that tradeoff wisely.

## When to Use This Skill

- User wants to decompose a monolith into microservices
- User needs inter-service communication patterns
- User asks about API Gateway, Service Mesh, or Service Discovery
- User mentions Circuit Breaker, Saga, or Event Sourcing
- User wants to manage distributed transactions
- User mentions معماری میکروسرویس or الگوهای توزیع‌شده

---

## Part 1: Service Decomposition

### Decomposition Strategies

| Strategy | When to Use | Example |
|----------|------------|---------|
| **By Business Capability** | Services align with business functions | User Service, Order Service, Payment Service |
| **By Subdomain (DDD)** | Bounded contexts define boundaries | Identity, Catalog, Fulfillment |
| **By Data Ownership** | Each service owns its data | Users DB, Orders DB, Products DB |
| **By Team** | Conway's Law: system = org structure | Team A owns Service A |

### Bounded Context Map

```
┌─────────────────────────────────────────────────────┐
│                  E-Commerce System                    │
├─────────────┬─────────────┬─────────────┬───────────┤
│   Identity  │   Catalog   │   Order     │  Payment  │
│   Context   │   Context   │   Context   │  Context  │
├─────────────┼─────────────┼─────────────┼───────────┤
│ - User      │ - Product   │ - Order     │ - Charge  │
│ - Auth      │ - Category  │ - Cart      │ - Refund  │
│ - Profile   │ - Inventory │ - Shipping   │ - Invoice │
└─────────────┴─────────────┴─────────────┴───────────┘
```

### Service Interface Template

```yaml
# service.yaml
name: order-service
version: 1.2.0
port: 3001
database: orders-db

dependencies:
  - user-service
  - payment-service
  - notification-service

endpoints:
  - path: /api/orders
    methods: [GET, POST]
    auth: required
    
  - path: /api/orders/:id
    methods: [GET, PUT, DELETE]
    auth: required

events:
  publishes:
    - order.created
    - order.completed
    - order.cancelled
  subscribes:
    - payment.completed
    - payment.failed
```

---

## Part 2: Communication Patterns

### Synchronous Communication (REST/gRPC)

```typescript
// REST Client with Circuit Breaker
class UserServiceClient {
  private circuitBreaker: CircuitBreaker;
  
  constructor(private baseUrl: string) {
    this.circuitBreaker = new CircuitBreaker({
      failureThreshold: 5,
      resetTimeout: 30000,
    });
  }
  
  async getUser(id: string): Promise<User> {
    return this.circuitBreaker.execute(async () => {
      const response = await fetch(`${this.baseUrl}/api/users/${id}`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    });
  }
}
```

### Asynchronous Communication (Message Queue)

```typescript
// Event Publisher
class OrderEventPublisher {
  constructor(private mq: MessageQueue) {}
  
  async publishOrderCreated(order: Order) {
    await this.mq.publish('order.created', {
      orderId: order.id,
      userId: order.userId,
      total: order.total,
      items: order.items,
      timestamp: new Date().toISOString(),
    });
  }
}

// Event Consumer
class PaymentService {
  constructor(private mq: MessageQueue) {}
  
  async start() {
    await this.mq.subscribe('order.created', async (event) => {
      try {
        await this.processPayment(event);
        await this.mq.publish('payment.completed', { orderId: event.orderId });
      } catch (error) {
        await this.mq.publish('payment.failed', { orderId: event.orderId, error: error.message });
      }
    });
  }
}
```

### Communication Comparison

| Pattern | Latency | Coupling | Reliability | Use Case |
|---------|---------|----------|-------------|----------|
| **REST** | Low | High | Medium | Simple CRUD |
| **gRPC** | Very Low | High | Medium | Internal, performance-critical |
| **Message Queue** | Medium | Low | High | Async operations, events |
| **Event Streaming** | Medium | Very Low | Very High | Audit trail, replay |

---

## Part 3: Resilience Patterns

### Circuit Breaker

```typescript
class CircuitBreaker {
  private failures = 0;
  private lastFailureTime = 0;
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  
  constructor(private options: { failureThreshold: number; resetTimeout: number }) {}
  
  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.options.resetTimeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new Error('Circuit breaker is OPEN');
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
    this.failures = 0;
    this.state = 'CLOSED';
  }
  
  private onFailure() {
    this.failures++;
    this.lastFailureTime = Date.now();
    if (this.failures >= this.options.failureThreshold) {
      this.state = 'OPEN';
    }
  }
}
```

### Retry with Exponential Backoff

```typescript
async function retryWithBackoff<T>(fn: () => Promise<T>, options = {}): Promise<T> {
  const { maxRetries = 3, baseDelay = 1000, maxDelay = 10000 } = options;
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      const delay = Math.min(baseDelay * Math.pow(2, attempt), maxDelay);
      const jitter = delay * 0.1 * Math.random();
      await new Promise(resolve => setTimeout(resolve, delay + jitter));
    }
  }
  
  throw new Error('Max retries exceeded');
}
```

### Bulkhead Pattern

```typescript
// Isolate failures to prevent cascade
class Bulkhead {
  private semaphore: Semaphore;
  
  constructor(private maxConcurrent: number) {
    this.semaphore = new Semaphore(maxConcurrent);
  }
  
  async execute<T>(fn: () => Promise<T>): Promise<T> {
    await this.semaphore.acquire();
    try {
      return await fn();
    } finally {
      this.semaphore.release();
    }
  }
}
```

---

## Part 4: Data Management

### Database per Service

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ User Service │    │Order Service │    │Product Service│
│  ┌────────┐  │    │  ┌────────┐  │    │  ┌────────┐  │
│  │Users DB│  │    │  │Orders  │  │    │  │Products│  │
│  │(Postgres)│  │    │  │  DB   │  │    │  │  DB   │  │
│  └────────┘  │    │  │(Mongo) │  │    │  │(Redis) │  │
└──────────────┘    │  └────────┘  │    │  └────────┘  │
                    └──────────────┘    └──────────────┘
```

### Saga Pattern (Distributed Transactions)

```typescript
// Choreography-based Saga
class OrderSaga {
  steps = [
    { event: 'order.created', handler: 'reserveInventory' },
    { event: 'inventory.reserved', handler: 'processPayment' },
    { event: 'payment.completed', handler: 'confirmOrder' },
    { event: 'payment.failed', handler: 'releaseInventory' },
    { event: 'inventory.failed', handler: 'cancelOrder' },
  ];
  
  // Compensation (rollback) actions
  compensations = {
    reserveInventory: 'releaseInventory',
    processPayment: 'refundPayment',
  };
}

// Orchestration-based Saga
class OrderOrchestrator {
  async execute(order: Order) {
    try {
      await this.inventoryService.reserve(order.items);
      await this.paymentService.charge(order.userId, order.total);
      await this.notificationService.sendOrderConfirmed(order);
    } catch (error) {
      // Compensate: undo completed steps
      await this.paymentService.refund(order.userId, order.total);
      await this.inventoryService.release(order.items);
      throw error;
    }
  }
}
```

---

## Part 5: CQRS (Command Query Responsibility Segregation)

```typescript
// Command Side (write model)
class OrderCommandHandler {
  async createOrder(command: CreateOrderCommand) {
    const order = Order.create(command);
    await this.orderRepository.save(order);
    await this.eventStore.append('OrderCreated', order.toEvents());
  }
}

// Query Side (read model)
class OrderQueryService {
  async getOrder(id: string): Promise<OrderView> {
    return this.readModel.findById(id);
  }
  
  async getUserOrders(userId: string): Promise<OrderView[]> {
    return this.readModel.findByUserId(userId);
  }
}

// Event Handler (project events to read model)
class OrderEventHandler {
  async onOrderCreated(event: OrderCreatedEvent) {
    await this.readModel.upsert({
      id: event.orderId,
      userId: event.userId,
      total: event.total,
      status: 'created',
      createdAt: event.timestamp,
    });
  }
}
```

---

## Part 6: API Gateway

```typescript
// Kong / AWS API Gateway configuration
const gatewayConfig = {
  routes: [
    {
      path: '/api/users/**',
      service: 'user-service',
      stripPrefix: '/api/users',
      rateLimit: { requests: 100, per: 'minute' },
    },
    {
      path: '/api/orders/**',
      service: 'order-service',
      stripPrefix: '/api/orders',
      rateLimit: { requests: 50, per: 'minute' },
    },
  ],
  plugins: [
    { name: 'jwt', config: { secret: process.env.JWT_SECRET } },
    { name: 'cors', config: { origins: ['https://app.example.com'] } },
    { name: 'request-transformer', config: { add: { headers: ['X-Request-ID:$(uuid)'] } } },
  ],
};
```

---

## Output Format

```
## Microservices Architecture

### Service Inventory
| Service | Port | Database | Dependencies |
|---------|------|----------|--------------|
| [name] | [port] | [db] | [deps] |

### Communication Patterns
[How services communicate]

### Data Strategy
[How data is managed across services]

### Resilience Patterns
[Circuit breaker, retry, bulkhead configurations]
```

## Rules

- **Start with a monolith** — Don't split until you need to
- **Own your data** — Each service has its own database
- **Design for failure** — Everything can and will fail
- **Use async communication** — Prefer events over direct calls
- **Implement circuit breakers** — Prevent cascade failures
- **Distributed tracing is mandatory** — You need to see across services
- **Automate everything** — CI/CD, monitoring, deployment
