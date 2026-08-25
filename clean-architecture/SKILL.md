---
name: clean-architecture
description: >-
  Design software project structures following clean architecture, SOLID principles, and domain-driven design patterns. Use this skill when the user asks about clean architecture, معماری تمیز, design project structure, SOLID principles, DDD, domain-driven design, layered architecture, hexagonal architecture, onion architecture, separation of concerns, project folder structure, dependency rule, طراحی ساختار پروژه, اصول SOLID, معماری لایه‌ای, معماری هگزاگونال, معماری پیازی, دامنه محور, جداسازی دغدغه‌ها, Ports and Adapters, Screaming Architecture, Modular Monolith, dependency injection, domain events, value objects, aggregate root, repository pattern, use case pattern, migration strategy from legacy, folder structure per language, application services, anti-corruption layer.
---

# Clean Architecture Skill — Comprehensive Software Architecture Design

## Overview

This skill designs project structures based on clean architecture principles: dependency inversion, separation of concerns, and testability. It produces concrete folder structures, module boundaries, dependency rules, and DDD tactical patterns — not just theory. Covers Ports & Adapters, Screaming Architecture, Modular Monolith, domain events, value objects, aggregate roots, and legacy migration strategies.

## When to Use This Skill

- User wants to design or reorganize a project's architecture
- User asks about clean architecture, SOLID, or DDD
- User needs a folder/module structure for a new project
- User wants to understand or apply layered, hexagonal, or onion architecture
- User asks how to separate concerns in their codebase
- User wants to implement Ports & Adapters, Screaming Architecture, or Modular Monolith
- User asks about dependency injection, domain events, value objects, or aggregate roots
- User needs a migration strategy from legacy to clean architecture
- User asks for concrete folder structures for TypeScript, Python, Go, Java, or C#

---

## Part 1: Core Principles

### The Dependency Rule

Dependencies point **inward only**. Inner layers know nothing about outer layers.

```
Frameworks & Drivers (outermost)
    Interface Adapters
        Application Use Cases
            Domain Entities (innermost)
```

The inner circles are business rules. The outer circles are mechanisms. Business rules know nothing about the outside world.

### SOLID Quick Reference

| Principle | Rule | Example |
|-----------|------|---------|
| Single Responsibility | A class has one reason to change | UserService handles only user-related operations |
| Open/Closed | Open for extension, closed for modification | Use interfaces to add new implementations |
| Liskov Substitution | Subtypes must be substitutable for base types | A MySQL repository must work where a Postgres repository works |
| Interface Segregation | Many specific interfaces over one general interface | Split UserRepository and UserAuthRepository if they serve different clients |
| Dependency Inversion | Depend on abstractions, not concretions | Domain imports nothing; infrastructure implements domain interfaces |

---

## Part 2: Architecture Patterns in Depth

### Pattern 1: Clean Architecture (Robert C. Martin)

Four concentric layers:

```
┌──────────────────────────────────────────────┐
│           Frameworks & Drivers               │
│  ┌──────────────────────────────────────────┐│
│  │         Interface Adapters               ││
│  │  ┌──────────────────────────────────────┐││
│  │  │       Application Use Cases          │││
│  │  │  ┌──────────────────────────────────┐│││
│  │  │  │     Domain Entities (Core)       ││││
│  │  │  └──────────────────────────────────┘│││
│  │  └──────────────────────────────────────┘││
│  └──────────────────────────────────────────┘│
└──────────────────────────────────────────────┘
```

### Pattern 2: Ports & Adapters (Hexagonal Architecture)

The application core defines "ports" (interfaces) and "adapters" connect to the outside world:

```
        ┌─────────────────────────────────────────┐
        │              Application Core            │
        │                                         │
  REST ─┤  ┌─────────┐    ┌──────────────────┐    ├─ PostgreSQL
Adapter │  │ Primary  │    │    Domain         │    │  Adapter
        │  │ Ports    │───▶│    Logic          │    │
  gRPC ─┤  │ (Input)  │    │                   │    ├─ MongoDB
Adapter │  └─────────┘    │  ┌──────────────┐ │    │  Adapter
        │                 │  │Secondary Ports│ │    │
  CLI ──┤  ┌─────────┐    │  │ (Output)     │ │    ├─ Stripe
Adapter │  │Secondary │◀───│  └──────────────┘ │    │  Adapter
        │  │ Ports    │    └──────────────────┘    │
        │  └─────────┘                            │
        └─────────────────────────────────────────┘
```

**Key insight**: The core defines what it needs (ports), adapters provide the implementation. Swap a PostgreSQL adapter for MySQL without touching the core.

### Pattern 3: Screaming Architecture

Your project structure should "scream" its intent:

```
// BAD: Screams "framework"
src/
  controllers/
  models/
  services/
  utils/

// GOOD: Screams "this is an e-commerce system"
src/
  orders/
    place-order.ts
    cancel-order.ts
    order-repository.ts
  payments/
    process-payment.ts
    refund-payment.ts
    payment-gateway.ts
  inventory/
    reserve-stock.ts
    release-stock.ts
```

### Pattern 4: Modular Monolith

Before going microservices, structure your monolith with clear module boundaries:

```
src/
  modules/
    users/
      api/           # HTTP handlers
      domain/        # Entities, value objects, repository interfaces
      application/   # Use cases
      infrastructure/# Repository implementations, external services
      index.ts       # Public API (only expose what other modules can use)
    
    orders/
      api/
      domain/
      application/
      infrastructure/
      index.ts
    
  shared/
    kernel/          # Shared infrastructure (DB, cache, auth)
    events/          # Event bus
    types/           # Shared types
```

**Module rules**:
- Module A can only import from Module B's `index.ts` (public API)
- No cross-module imports to internal files (`users/domain/user.ts`)
- Communication between modules via events or explicit imports through public API
- Each module owns its own database schema/tables

---

## Part 3: DDD Tactical Patterns

### Value Objects

Immutable objects defined by their attributes, not identity:

```typescript
// Value Object: equality based on attributes
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: string
  ) {
    if (amount < 0) throw new Error('Amount cannot be negative');
    if (!currency.match(/^[A-Z]{3}$/)) throw new Error('Invalid currency code');
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies');
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  static of(amount: number, currency: string): Money {
    return new Money(amount, currency);
  }
}

// Usage
const price = Money.of(29.99, 'USD');
const tax = Money.of(2.40, 'USD');
const total = price.add(tax); // Money { amount: 32.39, currency: 'USD' }
```

Other common value objects:
- `Email` (validates format)
- `Address` (street, city, zip, country)
- `DateRange` (start, end — validates end > start)
- `PhoneNumber` (validates format)
- `Coordinate` (latitude, longitude)

### Entities

Objects defined by identity, not attributes:

```typescript
class User {
  private constructor(
    public readonly id: UserId,
    private name: string,
    private email: Email,
    private _createdAt: Date
  ) {}

  static create(name: string, email: string): User {
    return new User(
      UserId.generate(),
      name,
      Email.of(email),
      new Date()
    );
  }

  changeName(newName: string): void {
    if (!newName || newName.length < 2) {
      throw new Error('Name must be at least 2 characters');
    }
    this.name = newName;
  }

  get name(): string { return this.name; }
  get email(): Email { return this.email; }
}
```

### Aggregate Roots

A cluster of entities and value objects treated as a single unit for data changes. The aggregate root is the only entry point for modifications:

```typescript
class Order {
  private items: OrderItem[] = [];
  private _status: OrderStatus = OrderStatus.DRAFT;

  private constructor(
    public readonly id: OrderId,
    public readonly customerId: CustomerId,
  ) {}

  static create(customerId: CustomerId): Order {
    const order = new Order(OrderId.generate(), customerId);
    order.addDomainEvent(new OrderCreated(order.id, customerId));
    return order;
  }

  addItem(productId: ProductId, quantity: number, price: Money): void {
    if (this._status !== OrderStatus.DRAFT) {
      throw new Error('Can only add items to draft orders');
    }
    
    const existing = this.items.find(i => i.productId.equals(productId));
    if (existing) {
      existing.increaseQuantity(quantity);
    } else {
      this.items.push(OrderItem.create(productId, quantity, price));
    }
  }

  submit(): void {
    if (this.items.length === 0) {
      throw new Error('Cannot submit empty order');
    }
    this._status = OrderStatus.SUBMITTED;
    this.addDomainEvent(new OrderSubmitted(this.id, this.totalAmount()));
  }

  totalAmount(): Money {
    return this.items.reduce(
      (total, item) => total.add(item.subtotal()),
      Money.of(0, 'USD')
    );
  }
}
```

### Domain Events

Record something meaningful happened in the domain. Used for cross-aggregate communication and side effects:

```typescript
// Event definition
interface DomainEvent {
  readonly eventId: string;
  readonly occurredAt: Date;
  readonly eventType: string;
}

class OrderCreated implements DomainEvent {
  readonly eventId = generateId();
  readonly occurredAt = new Date();
  readonly eventType = 'order.created';

  constructor(
    public readonly orderId: OrderId,
    public readonly customerId: CustomerId
  ) {}
}

// Event handler (application layer)
class OnOrderCreated {
  constructor(
    private inventoryService: InventoryService,
    private notificationService: NotificationService,
  ) {}

  async handle(event: OrderCreated): Promise<void> {
    await this.inventoryService.reserveStock(event.orderId);
    await this.notificationService.notifyOrderReceived(event.orderId);
  }
}

// Event dispatcher (infrastructure)
class InMemoryEventBus {
  private handlers: Map<string, Function[]> = new Map();

  register(eventType: string, handler: Function): void {
    const existing = this.handlers.get(eventType) || [];
    existing.push(handler);
    this.handlers.set(eventType, existing);
  }

  async publish(event: DomainEvent): Promise<void> {
    const handlers = this.handlers.get(event.eventType) || [];
    await Promise.all(handlers.map(h => h(event)));
  }
}
```

### Repository Pattern

Abstracts data access behind interfaces defined in the domain layer:

```typescript
// Domain layer: interface only
interface OrderRepository {
  findById(id: OrderId): Promise<Order | null>;
  save(order: Order): Promise<void>;
  findByCustomerId(customerId: CustomerId): Promise<Order[]>;
}

// Infrastructure layer: implementation
class PostgresOrderRepository implements OrderRepository {
  constructor(private db: DatabasePool) {}

  async findById(id: OrderId): Promise<Order | null> {
    const row = await this.db.query('SELECT * FROM orders WHERE id = $1', [id.value]);
    return row ? this.toDomain(row) : null;
  }

  async save(order: Order): Promise<void> {
    await this.db.query(
      'INSERT INTO orders (id, customer_id, status, created_at) VALUES ($1, $2, $3, $4) ON CONFLICT (id) DO UPDATE SET status = $3',
      [order.id.value, order.customerId.value, order.status, order.createdAt]
    );
  }

  private toDomain(row: any): Order {
    // Map database row to domain entity
  }
}
```

### Dependency Injection

Wire everything together at the composition root:

```typescript
// composition-root.ts (entry point)
function bootstrap() {
  // Infrastructure
  const db = new PostgresPool(config.database);
  const eventBus = new InMemoryEventBus();
  const emailClient = new SendGridEmailClient(config.sendgridKey);

  // Repositories
  const orderRepo = new PostgresOrderRepository(db);
  const userRepo = new PostgresUserRepository(db);

  // Services
  const inventoryService = new InventoryService(orderRepo);
  const notificationService = new NotificationService(emailClient);
  const orderService = new OrderService(orderRepo, inventoryService);

  // Event handlers
  eventBus.register('order.created', new OnOrderCreated(inventoryService, notificationService));

  // Application
  const app = express();
  app.use('/orders', createOrderRouter(orderService));
  
  return app;
}
```

### Anti-Corruption Layer

Protects your domain from external system models:

```typescript
// External system model (what Stripe returns)
interface StripeCharge {
  id: string;
  amount: number;
  currency: string;
  status: string;
  // ...Stripe-specific fields
}

// Anti-corruption layer
class StripePaymentAdapter implements PaymentGateway {
  async charge(amount: Money, source: PaymentSource): Promise<PaymentResult> {
    const stripeCharge = await stripe.charges.create({
      amount: amount.amountInCents,
      currency: amount.currency.toLowerCase(),
      source: source.token,
    });

    // Map external model to domain model
    return {
      paymentId: PaymentId.of(stripeCharge.id),
      status: this.mapStatus(stripeCharge.status),
      amount: Money.of(stripeCharge.amount / 100, stripeCharge.currency.toUpperCase()),
    };
  }

  private mapStatus(stripeStatus: string): PaymentStatus {
    switch (stripeStatus) {
      case 'succeeded': return PaymentStatus.COMPLETED;
      case 'pending': return PaymentStatus.PENDING;
      case 'failed': return PaymentStatus.FAILED;
      default: return PaymentStatus.UNKNOWN;
    }
  }
}
```

---

## Part 4: Folder Structures by Language

### TypeScript / Node.js

```
project-root/
├── src/
│   ├── modules/
│   │   ├── users/
│   │   │   ├── domain/
│   │   │   │   ├── user.ts              # Entity
│   │   │   │   ├── email.ts             # Value Object
│   │   │   │   ├── user-repository.ts   # Port (interface)
│   │   │   │   └── user-events.ts       # Domain Events
│   │   │   ├── application/
│   │   │   │   ├── create-user.ts       # Use Case
│   │   │   │   ├── update-user.ts       # Use Case
│   │   │   │   └── dtos.ts              # Input/Output DTOs
│   │   │   ├── infrastructure/
│   │   │   │   ├── postgres-user-repo.ts # Adapter
│   │   │   │   └── sendgrid-email.ts     # Adapter
│   │   │   ├── api/
│   │   │   │   ├── user-router.ts        # Express router
│   │   │   │   └── user-controller.ts    # Request/Response mapping
│   │   │   └── index.ts                  # Public API
│   │   └── orders/
│   │       └── ... (same structure)
│   ├── shared/
│   │   ├── kernel/
│   │   │   ├── database.ts
│   │   │   ├── event-bus.ts
│   │   │   └── config.ts
│   │   └── types.ts
│   └── composition-root.ts               # DI wiring
├── tests/
│   ├── unit/
│   ├── integration/
│   └── fixtures/
├── package.json
└── tsconfig.json
```

### Python

```
project-root/
├── src/
│   ├── modules/
│   │   ├── users/
│   │   │   ├── domain/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── user.py
│   │   │   │   ├── email.py
│   │   │   │   └── user_repository.py
│   │   │   ├── application/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── create_user.py
│   │   │   │   └── dtos.py
│   │   │   ├── infrastructure/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── sqlalchemy_user_repo.py
│   │   │   │   └── sendgrid_email.py
│   │   │   ├── api/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── routes.py
│   │   │   │   └── schemas.py
│   │   │   └── __init__.py
│   │   └── orders/
│   │       └── ...
│   ├── shared/
│   │   ├── kernel/
│   │   │   ├── database.py
│   │   │   └── events.py
│   │   └── types.py
│   └── main.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── conftest.py
├── pyproject.toml
└── alembic/              # Migrations
```

### Go

```
project-root/
├── internal/
│   ├── modules/
│   │   ├── users/
│   │   │   ├── domain/
│   │   │   │   ├── user.go
│   │   │   │   ├── email.go
│   │   │   │   └── repository.go
│   │   │   ├── application/
│   │   │   │   ├── create_user.go
│   │   │   │   └── service.go
│   │   │   ├── infrastructure/
│   │   │   │   ├── postgres_repo.go
│   │   │   │   └── smtp_email.go
│   │   │   └── api/
│   │   │       ├── handler.go
│   │   │       └── routes.go
│   │   └── orders/
│   │       └── ...
│   └── shared/
│       ├── kernel/
│       │   ├── database.go
│       │   └── events.go
│       └── types.go
├── cmd/
│   └── server/
│       └── main.go
├── tests/
├── go.mod
└── go.sum
```

### Java / Kotlin (Spring Boot)

```
project-root/
├── src/main/java/com/example/
│   ├── modules/
│   │   ├── users/
│   │   │   ├── domain/
│   │   │   │   ├── User.java
│   │   │   │   ├── Email.java
│   │   │   │   └── UserRepository.java
│   │   │   ├── application/
│   │   │   │   ├── CreateUserUseCase.java
│   │   │   │   └── UserService.java
│   │   │   ├── infrastructure/
│   │   │   │   ├── JpaUserRepository.java
│   │   │   │   └── SmtpEmailService.java
│   │   │   └── api/
│   │   │       ├── UserController.java
│   │   │       └── UserDto.java
│   │   └── orders/
│   │       └── ...
│   └── shared/
│       ├── kernel/
│       │   ├── DatabaseConfig.java
│       │   └── EventBus.java
│       └── types/
├── src/test/
├── pom.xml
└── build.gradle
```

### C# (.NET)

```
project-root/
├── src/
│   ├── Modules/
│   │   ├── Users/
│   │   │   ├── Domain/
│   │   │   │   ├── User.cs
│   │   │   │   ├── Email.cs
│   │   │   │   └── IUserRepository.cs
│   │   │   ├── Application/
│   │   │   │   ├── CreateUserUseCase.cs
│   │   │   │   └── UserService.cs
│   │   │   ├── Infrastructure/
│   │   │   │   ├── EfUserRepository.cs
│   │   │   │   └── SendGridEmailService.cs
│   │   │   └── Api/
│   │   │       ├── UsersController.cs
│   │   │       └── UserDto.cs
│   │   └── Orders/
│   │       └── ...
│   └── Shared/
│       ├── Kernel/
│       └── Types/
├── tests/
└── Solution.sln
```

---

## Part 5: Migration Strategy from Legacy

### Phase 1: Assessment (Strangler Fig Pattern)

1. **Map the existing system** — Identify all modules, dependencies, and data flows
2. **Identify the boundary** — Where can you draw a line between "legacy" and "new"?
3. **Place a facade** — Route traffic through a gateway that can send to old or new

```
                    ┌──────────────────────┐
  Client ────────▶ │   API Gateway/Facade  │
                    └──────┬───────┬───────┘
                           │       │
                    ┌──────▼──┐ ┌──▼──────────┐
                    │ Legacy  │ │  New Module  │
                    │ System  │ │  (Clean Arch)│
                    └─────────┘ └─────────────┘
```

### Phase 2: Extract Module by Module

```
Step 1: Pick one bounded context (e.g., "Users")
Step 2: Create the new module with clean architecture
Step 3: Write an anti-corruption layer to bridge old ↔ new
Step 4: Migrate data (dual-write or migration script)
Step 5: Switch traffic to new module
Step 6: Remove old code after validation
Step 7: Repeat for next module
```

### Phase 3: Data Migration

- **Dual-write**: Write to both old and new databases during transition
- **Change Data Capture (CDC)**: Use tools like Debezium to sync data
- **Backfill**: Run migration scripts to copy historical data
- **Validate**: Compare data between old and new systems

### Migration Don'ts
- Don't rewrite everything at once — it will fail
- Don't skip tests — the old system's behavior is your specification
- Don't change business logic during migration — separate concerns
- Don't migrate the database schema and code simultaneously — do one at a time

---

## Part 6: When NOT to Use Clean Architecture

- **Small scripts and CLI tools** — Four layers for a 200-line script is over-engineering
- **Prototypes and MVPs** — Speed of development matters more than structure
- **CRUD-heavy apps with no business logic** — A simple MVC pattern suffices
- **Tiny teams** — The overhead of clean architecture pays off at scale

**Rule of thumb**: Start simple. Add layers when the codebase becomes hard to maintain, not before.

---

## Output Format

```
## Project Architecture

**Language/Framework:** [detected stack]
**Architecture Style:** [Clean / Hexagonal / Onion / Modular Monolith]
**Project Size:** [small/medium/large — determines complexity]

### Folder Structure
[detailed tree with annotations]

### Dependency Flow
[visual dependency diagram]

### DDD Patterns
- **Aggregate Roots:** [list aggregates and their boundaries]
- **Value Objects:** [list key value objects]
- **Domain Events:** [list domain events]
- **Repository Interfaces:** [list ports]

### Module Boundaries
[what each module exposes, how modules communicate]

### Key Decisions
- [Decision 1]: [Why]
- [Decision 2]: [Why]

### Migration Plan (if applicable)
- [Phase 1]: [What to extract first]
- [Phase 2]: [Data migration approach]
```

## Rules

- Tailor the structure to the project size. A small script does not need four layers.
- If the project already has a structure, propose incremental changes, not a full rewrite.
- Provide concrete file/module names, not just abstract layer names.
- Present the response in the user's language; keep code and technical terms in English.
- Do not generate actual code files unless the user asks — provide the structure and let the user decide.
- When suggesting folder structures, include the rationale for each directory.
- For legacy migrations, always use the Strangler Fig pattern — never a big bang rewrite.
- Recommend Modular Monolith before microservices unless there's a clear scaling reason.
- Every domain entity should have at least one value object and one repository interface.
