---
name: clean-architecture
description: >-
  Clean architecture and SOLID principles for maintainable, testable software systems.
  Covers dependency rule, four layers (entities/use-cases/adapters/frameworks), interface
  segregation principle, dependency inversion principle, repository pattern, unit of work pattern,
  CQRS (command query responsibility segregation), domain events, hexagonal architecture (ports
  and adapters), onion architecture, SOLID principles with code examples, adapter pattern,
  facade pattern. معماری تمیز و اصول SOLID، قاعده وابستگی، الگوی Repository،
  CQRS، رویدادهای دامنه، معماری شش‌لایه، معماری پیازی. 清洁架构，SOLID原则，
  依赖规则，仓储模式，领域事件，六边形架构
priority: P2
dependencies: [project-analysis, refactoring]
conflicts: []
---

# Clean Architecture & SOLID Principles

## Overview

Clean Architecture is a software design philosophy that separates concerns into concentric layers, ensuring that business logic remains independent of frameworks, databases, UI, and external services. Created by Robert C. Martin (Uncle Bob), it provides a blueprint for building systems that are testable, maintainable, and resilient to change.

The core insight is simple but profound: **business rules should not depend on anything external.** The database should be replaceable. The UI should be swappable. The frameworks should be a detail. Only the business logic—the domain—is permanent.

This skill covers Clean Architecture, SOLID principles, and related patterns (Repository, Unit of Work, CQRS, Domain Events, Hexagonal/Ports-and-Adapters, Onion Architecture) with practical TypeScript and Python code examples.

**Core Philosophy:** "Architecture is about the decisions you wish you could get right early." Every architectural decision is a trade-off. The goal is not perfection but *clarity of boundaries*—so that when requirements change (and they will), the blast radius of any change is contained within a single layer.

**Key Benefits:**
- **Testability:** Business logic can be tested without databases, networks, or UIs
- **Framework Independence:** Replace Express with FastAPI without touching domain logic
- **UI Independence:** Switch from CLI to web to mobile without rearchitecting
- **Database Independence:** Swap PostgreSQL for MongoDB without changing business rules
- **External Agency Independence:** Third-party services become replaceable adapters

## When to Use This Skill

- Designing systems expected to evolve over years, not months
- Building domains with complex business rules (fintech, healthcare, e-commerce)
- Creating systems that must support multiple interfaces (API, CLI, web, mobile)
- Working with teams where multiple developers need clear boundaries
- Building systems that require high test coverage (60%+ unit tests)
- Refactoring monolithic applications into modular architectures
- Designing microservices with clear domain boundaries
- Creating plugin architectures where external code must be safely integrated
- Building event-driven systems with complex domain interactions
- Developing APIs that must remain stable while internal implementations change

## When NOT to Use This Skill

- Simple CRUD applications with minimal business logic (a simpler MVC pattern suffices)
- Prototypes and proof-of-concepts where speed of delivery matters more than structure
- Small scripts or utilities with a single responsibility
- When the team is small (1-2 developers) and communication overhead exceeds the benefit
- When the domain is stable and unlikely to change (rare in practice)
- When performance constraints demand the tightest possible coupling
- When the project has a very short lifespan (< 3 months)

## Workflow

### Phase 1: Identify the Domain Model

Before writing any architecture, understand the business domain:

```typescript
// DOMAIN MODEL: The heart of your system
// These are pure business objects with NO framework dependencies

interface Money {
  amount: number;
  currency: string;
}

interface OrderItem {
  productId: string;
  quantity: number;
  unitPrice: Money;
}

interface Order {
  id: string;
  customerId: string;
  items: OrderItem[];
  status: 'pending' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled';
  createdAt: Date;
  totalAmount(): Money;
  addItem(item: OrderItem): void;
  cancel(): void;
  canBeCancelled(): boolean;
}

// Domain Rule: An order can only be cancelled if it's pending or confirmed
class OrderImpl implements Order {
  id: string;
  customerId: string;
  items: OrderItem[] = [];
  status: 'pending' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled' = 'pending';
  createdAt: Date = new Date();

  totalAmount(): Money {
    const total = this.items.reduce((sum, item) => sum + item.unitPrice.amount * item.quantity, 0);
    return { amount: total, currency: this.items[0]?.unitPrice.currency ?? 'USD' };
  }

  addItem(item: OrderItem): void {
    if (this.status !== 'pending') {
      throw new Error('Cannot add items to a non-pending order');
    }
    this.items.push(item);
  }

  cancel(): void {
    if (!this.canBeCancelled()) {
      throw new Error(`Cannot cancel order in status: ${this.status}`);
    }
    this.status = 'cancelled';
  }

  canBeCancelled(): boolean {
    return this.status === 'pending' || this.status === 'confirmed';
  }
}
```

### Phase 2: Apply the Dependency Rule

The Dependency Rule: source code dependencies must point inward. The inner layers know nothing about the outer layers.

```
┌─────────────────────────────────────────────────────┐
│                   FRAMEWORKS                         │
│  (Express, React, PostgreSQL, Redis, etc.)           │
│                                                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │                ADAPTERS                          │ │
│  │  (Controllers, Repositories, Gateways)           │ │
│  │                                                  │ │
│  │  ┌─────────────────────────────────────────────┐ │ │
│  │  │            USE CASES                        │ │ │
│  │  │  (Application Business Rules)               │ │ │
│  │  │                                             │ │ │
│  │  │  ┌─────────────────────────────────────────┐ │ │ │
│  │  │  │           ENTITIES                      │ │ │ │
│  │  │  │  (Enterprise Business Rules)            │ │ │ │
│  │  │  │                                         │ │ │ │
│  │  │  │  ← DEPENDENCIES POINT INWARD →         │ │ │ │
│  │  │  └─────────────────────────────────────────┘ │ │ │
│  │  └─────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

```typescript
// ENTITIES (Innermost Layer) — Pure business logic
// No imports from outer layers. No framework dependencies.

// Use Cases (Application Layer) — Orchestrate business logic
// Depends on entities and repository interfaces

interface CreateOrderUseCase {
  execute(input: CreateOrderInput): Promise<CreateOrderOutput>;
}

interface CreateOrderInput {
  customerId: string;
  items: Array<{ productId: string; quantity: number }>;
}

interface CreateOrderOutput {
  orderId: string;
  totalAmount: Money;
  status: string;
}

class CreateOrder implements CreateOrderUseCase {
  constructor(
    private orderRepository: OrderRepository,  // Interface (inner layer)
    private productCatalog: ProductCatalog,     // Interface (inner layer)
    private eventBus: DomainEventBus,           // Interface (inner layer)
  ) {}

  async execute(input: CreateOrderInput): Promise<CreateOrderOutput> {
    // 1. Validate business rules
    const customer = await this.orderRepository.findCustomerById(input.customerId);
    if (!customer) throw new Error('Customer not found');

    // 2. Create domain entity
    const order = new OrderImpl();
    order.customerId = input.customerId;

    for (const item of input.items) {
      const product = await this.productCatalog.getProduct(item.productId);
      if (!product) throw new Error(`Product not found: ${item.productId}`);
      order.addItem({
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: product.price,
      });
    }

    // 3. Persist via repository interface (implemented in adapter layer)
    await this.orderRepository.save(order);

    // 4. Emit domain event
    await this.eventBus.publish({
      type: 'ORDER_CREATED',
      orderId: order.id,
      customerId: order.customerId,
      totalAmount: order.totalAmount(),
      timestamp: new Date(),
    });

    return {
      orderId: order.id,
      totalAmount: order.totalAmount(),
      status: order.status,
    };
  }
}
```

### Phase 3: Repository Pattern

```typescript
// REPOSITORY INTERFACE (defined in domain/use-case layer)
// The implementation lives in the adapter layer

interface OrderRepository {
  findById(id: string): Promise<Order | null>;
  findCustomerById(id: string): Promise<Customer | null>;
  save(order: Order): Promise<void>;
  findByCustomerId(customerId: string): Promise<Order[]>;
}

// ADAPTER LAYER: PostgreSQL Implementation
class PostgresOrderRepository implements OrderRepository {
  constructor(private db: DatabaseConnection) {}

  async findById(id: string): Promise<Order | null> {
    const row = await this.db.query('SELECT * FROM orders WHERE id = $1', [id]);
    if (!row) return null;
    return this.toDomain(row);
  }

  async save(order: Order): Promise<void> {
    await this.db.query(
      'INSERT INTO orders (id, customer_id, status, created_at) VALUES ($1, $2, $3, $4) ON CONFLICT (id) DO UPDATE SET status = $3',
      [order.id, order.customerId, order.status, order.createdAt]
    );
  }

  private toDomain(row: any): Order {
    const order = new OrderImpl();
    order.id = row.id;
    order.customerId = row.customer_id;
    order.status = row.status;
    order.createdAt = row.created_at;
    return order;
  }
}

// ADAPTER LAYER: In-Memory Implementation (for testing)
class InMemoryOrderRepository implements OrderRepository {
  private orders = new Map<string, Order>();

  async findById(id: string): Promise<Order | null> {
    return this.orders.get(id) ?? null;
  }

  async save(order: Order): Promise<void> {
    this.orders.set(order.id, order);
  }

  async findCustomerById(id: string): Promise<Customer | null> {
    return null; // Simplified for example
  }

  async findByCustomerId(customerId: string): Promise<Order[]> {
    return Array.from(this.orders.values()).filter(o => o.customerId === customerId);
  }
}
```

### Phase 4: Unit of Work Pattern

```typescript
// UNIT OF WORK: Ensures multiple repository operations succeed or fail together

interface UnitOfWork {
  begin(): Promise<void>;
  commit(): Promise<void>;
  rollback(): Promise<void>;
  getOrders(): OrderRepository;
  getProducts(): ProductRepository;
  getInventory(): InventoryRepository;
}

class PostgresUnitOfWork implements UnitOfWork {
  private transaction: Transaction | null = null;
  private orders: OrderRepository;
  private products: ProductRepository;
  private inventory: InventoryRepository;

  constructor(private db: DatabaseConnection) {
    this.orders = new PostgresOrderRepository(db);
    this.products = new PostgresProductRepository(db);
    this.inventory = new PostgresInventoryRepository(db);
  }

  async begin(): Promise<void> {
    this.transaction = await this.db.beginTransaction();
  }

  async commit(): Promise<void> {
    if (this.transaction) await this.transaction.commit();
  }

  async rollback(): Promise<void> {
    if (this.transaction) await this.transaction.rollback();
  }

  getOrders(): OrderRepository { return this.orders; }
  getProducts(): ProductRepository { return this.products; }
  getInventory(): InventoryRepository { return this.inventory; }
}

// Usage in a use case
class PlaceOrder {
  constructor(private unitOfWork: UnitOfWork) {}

  async execute(input: PlaceOrderInput): Promise<void> {
    await this.unitOfWork.begin();
    try {
      // Multiple repository operations in a single transaction
      const order = await this.unitOfWork.getOrders().findById(input.orderId);
      if (!order) throw new Error('Order not found');

      // Check inventory
      for (const item of order.items) {
        const stock = await this.unitOfWork.getInventory().getStock(item.productId);
        if (stock < item.quantity) throw new Error(`Insufficient stock for ${item.productId}`);
      }

      // Deduct inventory
      for (const item of order.items) {
        await this.unitOfWork.getInventory().deduct(item.productId, item.quantity);
      }

      // Confirm order
      order.status = 'confirmed';
      await this.unitOfWork.getOrders().save(order);

      await this.unitOfWork.commit();
    } catch (error) {
      await this.unitOfWork.rollback();
      throw error;
    }
  }
}
```

### Phase 5: CQRS (Command Query Responsibility Segregation)

```typescript
// CQRS: Separate read and write models

// COMMAND SIDE
interface Command {
  type: string;
  timestamp: Date;
}

interface CreateOrderCommand extends Command {
  type: 'CREATE_ORDER';
  customerId: string;
  items: Array<{ productId: string; quantity: number }>;
}

interface CommandHandler<T extends Command> {
  handle(command: T): Promise<void>;
}

class CreateOrderCommandHandler implements CommandHandler<CreateOrderCommand> {
  constructor(
    private orderRepository: OrderRepository,
    private eventBus: DomainEventBus,
  ) {}

  async handle(command: CreateOrderCommand): Promise<void> {
    const order = new OrderImpl();
    order.customerId = command.customerId;

    for (const item of command.items) {
      order.addItem({
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: { amount: 0, currency: 'USD' }, // Would fetch from catalog
      });
    }

    await this.orderRepository.save(order);

    await this.eventBus.publish({
      type: 'ORDER_CREATED',
      orderId: order.id,
      customerId: order.customerId,
      totalAmount: order.totalAmount(),
      timestamp: new Date(),
    });
  }
}

// QUERY SIDE: Optimized read model
interface OrderReadModel {
  orderId: string;
  customerName: string;
  itemCount: number;
  totalAmount: number;
  status: string;
  createdAt: Date;
}

class OrderQueryService {
  constructor(private readDb: ReadDatabase) {}

  async getOrderSummary(orderId: string): Promise<OrderReadModel | null> {
    // Query optimized for reading (may use denormalized view)
    return this.readDb.query(
      'SELECT order_id, customer_name, item_count, total_amount, status, created_at FROM order_summary WHERE order_id = $1',
      [orderId]
    );
  }

  async getCustomerOrders(customerId: string): Promise<OrderReadModel[]> {
    return this.readDb.query(
      'SELECT * FROM order_summary WHERE customer_id = $1 ORDER BY created_at DESC',
      [customerId]
    );
  }
}
```

### Phase 6: Domain Events

```typescript
// DOMAIN EVENTS: Decouple business logic from side effects

interface DomainEvent {
  type: string;
  timestamp: Date;
  [key: string]: unknown;
}

interface DomainEventBus {
  publish(event: DomainEvent): Promise<void>;
  subscribe(eventType: string, handler: (event: DomainEvent) => Promise<void>): void;
}

// In-Memory event bus for simple applications
class InMemoryDomainEventBus implements DomainEventBus {
  private handlers = new Map<string, Array<(event: DomainEvent) => Promise<void>>>();

  async publish(event: DomainEvent): Promise<void> {
    const handlers = this.handlers.get(event.type) ?? [];
    for (const handler of handlers) {
      await handler(event);
    }
  }

  subscribe(eventType: string, handler: (event: DomainEvent) => Promise<void>): void {
    const existing = this.handlers.get(eventType) ?? [];
    existing.push(handler);
    this.handlers.set(eventType, existing);
  }
}

// Event handlers (in adapter layer, subscribing to domain events)
class SendOrderConfirmationEmail {
  constructor(private emailService: EmailService) {}

  async handle(event: DomainEvent): Promise<void> {
    if (event.type === 'ORDER_CREATED') {
      await this.emailService.send({
        to: event.customerId,
        subject: 'Order Confirmation',
        body: `Your order ${event.orderId} has been confirmed.`,
      });
    }
  }
}

class UpdateInventoryCounter {
  constructor(private inventoryService: InventoryService) {}

  async handle(event: DomainEvent): Promise<void> {
    if (event.type === 'ORDER_CREATED') {
      for (const item of (event.items as any[]) ?? []) {
        await this.inventoryService.decrementStock(item.productId, item.quantity);
      }
    }
  }
}

// Wire up
const eventBus = new InMemoryDomainEventBus();
eventBus.subscribe('ORDER_CREATED', emailHandler.handle.bind(emailHandler));
eventBus.subscribe('ORDER_CREATED', inventoryHandler.handle.bind(inventoryHandler));
```

### Phase 7: Hexagonal Architecture (Ports and Adapters)

```typescript
// PORTS: Interfaces that define how the outside world interacts with the domain
// ADAPTERS: Implementations of those interfaces

// PRIMARY PORTS (Driving adapters: UI, CLI, API)
interface OrderManagementPort {
  createOrder(input: CreateOrderInput): Promise<CreateOrderOutput>;
  cancelOrder(orderId: string): Promise<void>;
  getOrderStatus(orderId: string): Promise<OrderStatusOutput>;
}

// SECONDARY PORTS (Driven adapters: Database, Email, Payment)
interface OrderPersistencePort {
  save(order: Order): Promise<void>;
  findById(id: string): Promise<Order | null>;
}

interface PaymentPort {
  charge(customerId: string, amount: Money): Promise<PaymentResult>;
  refund(transactionId: string): Promise<void>;
}

interface NotificationPort {
  sendOrderConfirmation(order: Order): Promise<void>;
  sendCancellationNotice(order: Order): Promise<void>;
}

// APPLICATION SERVICE: Implements primary port, uses secondary ports
class OrderManagementService implements OrderManagementPort {
  constructor(
    private persistence: OrderPersistencePort,
    private payment: PaymentPort,
    private notification: NotificationPort,
  ) {}

  async createOrder(input: CreateOrderInput): Promise<CreateOrderOutput> {
    const order = new OrderImpl();
    order.customerId = input.customerId;
    // ... add items ...

    const paymentResult = await this.payment.charge(input.customerId, order.totalAmount());
    if (!paymentResult.success) throw new Error('Payment failed');

    await this.persistence.save(order);
    await this.notification.sendOrderConfirmation(order);

    return { orderId: order.id, totalAmount: order.totalAmount(), status: order.status };
  }
}

// ADAPTER: Express.js HTTP adapter (driving)
class ExpressOrderController {
  constructor(private orderService: OrderManagementPort) {}

  async createOrder(req: Request, res: Response): Promise<void> {
    try {
      const result = await this.orderService.createOrder(req.body);
      res.status(201).json(result);
    } catch (error) {
      res.status(400).json({ error: (error as Error).message });
    }
  }
}

// ADAPTER: CLI adapter (driving)
class CLIOrderHandler {
  constructor(private orderService: OrderManagementPort) {}

  async handleCreateOrder(args: string[]): Promise<void> {
    const result = await this.orderService.createOrder({
      customerId: args[0],
      items: JSON.parse(args[1]),
    });
    console.log(`Order created: ${result.orderId}`);
  }
}
```

### Phase 8: SOLID Principles in Practice

```typescript
// ===================== S: Single Responsibility =====================
// BAD: One class does everything
class BadUserService {
  createUser(data: any) { /* creates user */ }
  sendEmail(to: string, subject: string) { /* sends email */ }
  generateReport() { /* generates report */ }
  logActivity(activity: string) { /* logs */ }
}

// GOOD: Each class has one reason to change
class UserService {
  constructor(private userRepository: UserRepository) {}
  async createUser(data: CreateUserInput): Promise<User> { /* ... */ }
}

class EmailService {
  async send(to: string, subject: string, body: string): Promise<void> { /* ... */ }
}

class ReportGenerator {
  async generate(userId: string): Promise<Report> { /* ... */ }
}

class ActivityLogger {
  async log(activity: string): Promise<void> { /* ... */ }
}

// ===================== O: Open/Closed Principle =====================
// BAD: Must modify class to add new payment methods
class BadPaymentProcessor {
  process(method: string, amount: number) {
    if (method === 'credit_card') { /* credit card logic */ }
    else if (method === 'paypal') { /* paypal logic */ }
    else if (method === 'crypto') { /* crypto logic */ }
  }
}

// GOOD: Open for extension, closed for modification
interface PaymentMethod {
  charge(amount: Money): Promise<PaymentResult>;
  refund(transactionId: string): Promise<void>;
}

class CreditCardPayment implements PaymentMethod {
  async charge(amount: Money): Promise<PaymentResult> { /* ... */ }
  async refund(transactionId: string): Promise<void> { /* ... */ }
}

class PayPalPayment implements PaymentMethod {
  async charge(amount: Money): Promise<PaymentResult> { /* ... */ }
  async refund(transactionId: string): Promise<void> { /* ... */ }
}

// Adding CryptoPayment requires NO changes to existing code
class CryptoPayment implements PaymentMethod {
  async charge(amount: Money): Promise<PaymentResult> { /* ... */ }
  async refund(transactionId: string): Promise<void> { /* ... */ }
}

// ===================== L: Liskov Substitution =====================
// All implementations must be substitutable without breaking the contract

interface Shape {
  area(): number;
  describe(): string;
}

class Circle implements Shape {
  constructor(private radius: number) {}
  area(): number { return Math.PI * this.radius ** 2; }
  describe(): string { return `Circle with radius ${this.radius}`; }
}

class Rectangle implements Shape {
  constructor(private width: number, private height: number) {}
  area(): number { return this.width * this.height; }
  describe(): string { return `Rectangle ${this.width}×${this.height}`; }
}

// Both can be used interchangeably
function printShapeInfo(shape: Shape): void {
  console.log(shape.describe());
  console.log(`Area: ${shape.area()}`);
}

// ===================== I: Interface Segregation =====================
// BAD: One fat interface forces implementations to depend on methods they don't use
interface BadWorker {
  work(): void;
  eat(): void;
  sleep(): void;
  manage(): void;
  code(): void;
}

// GOOD: Small, focused interfaces
interface Workable {
  work(): void;
}

interface Feedable {
  eat(): void;
}

interface Sleepable {
  sleep(): void;
}

interface Manageable {
  manage(): void;
}

interface Codeable {
  code(): void;
}

class HumanDeveloper implements Workable, Feedable, Sleepable, Codeable {
  work(): void { /* ... */ }
  eat(): void { /* ... */ }
  sleep(): void { /* ... */ }
  code(): void { /* ... */ }
}

class Robot implements Workable, Codeable {
  work(): void { /* ... */ }
  code(): void { /* ... */ }
  // Robot doesn't need eat() or sleep()
}

// ===================== D: Dependency Inversion =====================
// BAD: High-level module depends on low-level module
class BadOrderService {
  private mysqlRepo = new MySQLOrderRepository(); // Concrete dependency!
  async createOrder(data: any) { /* ... */ }
}

// GOOD: Both depend on abstractions
interface OrderRepository {
  save(order: Order): Promise<void>;
  findById(id: string): Promise<Order | null>;
}

class GoodOrderService {
  constructor(private orderRepo: OrderRepository) {} // Depends on abstraction
  async createOrder(data: CreateOrderInput): Promise<void> { /* ... */ }
}

// Can be wired with any implementation
const service = new GoodOrderService(new PostgresOrderRepository(db));
// Or in tests:
const testService = new GoodOrderService(new InMemoryOrderRepository());
```

## Advanced Techniques

### Technique 1: Facade Pattern for Complex Subsystems

```typescript
// FACADE: Simplify access to complex subsystems

class PaymentFacade {
  constructor(
    private stripe: StripeService,
    private paypal: PayPalService,
    private fraud: FraudDetectionService,
    private ledger: AccountingService,
  ) {}

  async processPayment(order: Order, method: 'stripe' | 'paypal'): Promise<PaymentResult> {
    // 1. Fraud check
    const risk = await this.fraud.assessRisk(order);
    if (risk.score > 0.8) {
      return { success: false, reason: 'Fraud detected' };
    }

    // 2. Process payment
    let result: PaymentResult;
    if (method === 'stripe') {
      result = await this.stripe.charge(order.customerId, order.totalAmount());
    } else {
      result = await this.paypal.charge(order.customerId, order.totalAmount());
    }

    // 3. Record in ledger
    if (result.success) {
      await this.ledger.recordPayment({
        orderId: order.id,
        amount: order.totalAmount(),
        method,
        transactionId: result.transactionId,
      });
    }

    return result;
  }
}
```

### Technique 2: Specification Pattern for Complex Business Rules

```typescript
interface Specification<T> {
  isSatisfiedBy(candidate: T): boolean;
  and(other: Specification<T>): Specification<T>;
  or(other: Specification<T>): Specification<T>;
  not(): Specification<T>;
}

class CompositeSpecification<T> implements Specification<T> {
  constructor(protected condition: (candidate: T) => boolean) {}

  isSatisfiedBy(candidate: T): boolean {
    return this.condition(candidate);
  }

  and(other: Specification<T>): Specification<T> {
    return new CompositeSpecification<T>(
      (c) => this.isSatisfiedBy(c) && other.isSatisfiedBy(c)
    );
  }

  or(other: Specification<T>): Specification<T> {
    return new CompositeSpecification<T>(
      (c) => this.isSatisfiedBy(c) || other.isSatisfiedBy(c)
    );
  }

  not(): Specification<T> {
    return new CompositeSpecification<T>(
      (c) => !this.isSatisfiedBy(c)
    );
  }
}

// Usage: Complex business rules as composable specifications
const orderMustHaveItems = new CompositeSpecification<Order>(
  (order) => order.items.length > 0
);

const orderTotalMustBePositive = new CompositeSpecification<Order>(
  (order) => order.totalAmount().amount > 0
);

const customerMustBeActive = new CompositeSpecification<Customer>(
  (customer) => customer.status === 'active'
);

// Compose: Order can be placed if it has items AND positive total AND customer is active
const canPlaceOrder = orderMustHaveItems
  .and(orderTotalMustBePositive);

// For a specific use case, extend with customer check
const fullValidation = canPlaceOrder; // Additional specs can be composed dynamically
```

### Technique 3: Domain Events with Outbox Pattern

```typescript
// OUTBOX PATTERN: Guarantee event delivery without distributed transactions

interface OutboxMessage {
  id: string;
  aggregateType: string;
  aggregateId: string;
  eventType: string;
  payload: string; // JSON serialized
  createdAt: Date;
  processed: boolean;
}

class OutboxRepository {
  constructor(private db: DatabaseConnection) {}

  async save(message: OutboxMessage): Promise<void> {
    await this.db.query(
      'INSERT INTO outbox (id, aggregate_type, aggregate_id, event_type, payload, created_at, processed) VALUES ($1, $2, $3, $4, $5, $6, $7)',
      [message.id, message.aggregateType, message.aggregateId, message.eventType, message.payload, message.createdAt, message.processed]
    );
  }

  async getUnprocessed(limit: number = 100): Promise<OutboxMessage[]> {
    return this.db.query(
      'SELECT * FROM outbox WHERE processed = false ORDER BY created_at ASC LIMIT $1',
      [limit]
    );
  }

  async markProcessed(id: string): Promise<void> {
    await this.db.query('UPDATE outbox SET processed = true WHERE id = $1', [id]);
  }
}

// Background processor: polls outbox and publishes events
class OutboxProcessor {
  constructor(
    private outbox: OutboxRepository,
    private eventBus: DomainEventBus,
  ) {}

  async processBatch(): Promise<void> {
    const messages = await this.outbox.getUnprocessed();
    for (const msg of messages) {
      try {
        const event: DomainEvent = {
          type: msg.eventType,
          timestamp: msg.createdAt,
          ...JSON.parse(msg.payload),
        };
        await this.eventBus.publish(event);
        await this.outbox.markProcessed(msg.id);
      } catch (error) {
        console.error(`Failed to process outbox message ${msg.id}:`, error);
      }
    }
  }
}
```

### Technique 4: Anti-Corruption Layer

```typescript
// ANTI-CORRUPTION LAYER: Translate between your domain and external systems

interface ExternalPaymentGateway {
  // External system uses different naming, structure, error codes
  makePayment(cust_id: string, amt: number, curr_code: string): Promise<{
    status: string;
    txn_ref: string;
    err_code?: number;
    err_msg?: string;
  }>;
}

// Anti-corruption layer translates external model to domain model
class PaymentGatewayAdapter implements PaymentPort {
  constructor(private external: ExternalPaymentGateway) {}

  async charge(customerId: string, amount: Money): Promise<PaymentResult> {
    try {
      const externalResult = await this.external.makePayment(
        customerId,
        amount.amount,
        amount.currency,
      );

      // Translate external result to domain result
      if (externalResult.status === 'SUCCESS') {
        return {
          success: true,
          transactionId: externalResult.txn_ref,
        };
      } else {
        return {
          success: false,
          reason: `External error ${externalResult.err_code}: ${externalResult.err_msg}`,
        };
      }
    } catch (error) {
      // Translate external exceptions to domain exceptions
      throw new PaymentException(
        `Payment gateway communication failed: ${(error as Error).message}`
      );
    }
  }
}
```

### Technique 5: Plugin Architecture with Clean Architecture

```typescript
// PLUGIN SYSTEM: Load external functionality while maintaining clean boundaries

interface Plugin {
  name: string;
  version: string;
  initialize(context: PluginContext): Promise<void>;
  shutdown(): Promise<void>;
}

interface PluginContext {
  registerCommandHandler(type: string, handler: CommandHandler<Command>): void;
  registerEventHandler(type: string, handler: (event: DomainEvent) => Promise<void>): void;
  registerQueryHandler(type: string, handler: (query: any) => Promise<any>): void;
  getService<T>(token: string): T;
}

class PluginManager {
  private plugins = new Map<string, Plugin>();

  async loadPlugin(plugin: Plugin, context: PluginContext): Promise<void> {
    await plugin.initialize(context);
    this.plugins.set(plugin.name, plugin);
    console.log(`Plugin loaded: ${plugin.name} v${plugin.version}`);
  }

  async unloadPlugin(name: string): Promise<void> {
    const plugin = this.plugins.get(name);
    if (plugin) {
      await plugin.shutdown();
      this.plugins.delete(name);
    }
  }
}
```

### Technique 6: Value Objects

```typescript
// VALUE OBJECTS: Immutable, self-validating domain primitives

class Email {
  private constructor(private readonly value: string) {}

  static create(email: string): Email {
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      throw new Error(`Invalid email: ${email}`);
    }
    return new Email(email.toLowerCase().trim());
  }

  toString(): string { return this.value; }
  equals(other: Email): boolean { return this.value === other.value; }
}

class Money {
  private constructor(
    private readonly amount: number,
    private readonly currency: string,
  ) {}

  static create(amount: number, currency: string): Money {
    if (amount < 0) throw new Error('Money amount cannot be negative');
    if (!/^[A-Z]{3}$/.test(currency)) throw new Error(`Invalid currency: ${currency}`);
    return new Money(Math.round(amount * 100) / 100, currency);
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies');
    }
    return Money.create(this.amount + other.amount, this.currency);
  }

  multiply(factor: number): Money {
    return Money.create(this.amount * factor, this.currency);
  }

  toString(): string { return `${this.currency} ${this.amount.toFixed(2)}`; }
  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }
}

// Usage
const price = Money.create(29.99, 'USD');
const tax = price.multiply(0.08);
const total = price.add(tax);
// Total: USD 32.39
```

### Technique 7: Dependency Injection Containers

```typescript
// SIMPLE DI CONTAINER: Wire up dependencies at the composition root

interface Container {
  register<T>(token: string, factory: (container: Container) => T): void;
  resolve<T>(token: string): T;
}

class SimpleContainer implements Container {
  private factories = new Map<string, (container: Container) => any>();
  private singletons = new Map<string, any>();

  register<T>(token: string, factory: (container: Container) => T): void {
    this.factories.set(token, factory);
  }

  resolve<T>(token: string): T {
    if (this.singletons.has(token)) {
      return this.singletons.get(token);
    }
    const factory = this.factories.get(token);
    if (!factory) throw new Error(`No registration for: ${token}`);
    const instance = factory(this);
    this.singletons.set(token, instance);
    return instance;
  }
}

// COMPOSITION ROOT: Where all dependencies are wired
const container = new SimpleContainer();

// Register implementations
container.register('Database', () => new PostgresDatabase(config.dbUrl));
container.register('OrderRepository', (c) => new PostgresOrderRepository(c.resolve('Database')));
container.register('EventBus', () => new InMemoryDomainEventBus());
container.register('OrderService', (c) => new OrderManagementService(
  c.resolve('OrderRepository'),
  c.resolve('EventBus'),
));
container.register('OrderController', (c) => new ExpressOrderController(
  c.resolve('OrderService'),
));

// Application startup
const controller = container.resolve<ExpressOrderController>('OrderController');
```

## Common Patterns

### Pattern 1: The Clean Architecture File Structure

```
src/
├── domain/                    # ENTITIES (innermost)
│   ├── models/
│   │   ├── order.ts
│   │   ├── customer.ts
│   │   └── money.ts
│   ├── events/
│   │   ├── order-created.ts
│   │   └── order-cancelled.ts
│   ├── repositories/          # Repository interfaces
│   │   └── order-repository.ts
│   └── services/              # Domain services
│       └── pricing-service.ts
├── application/               # USE CASES
│   ├── commands/
│   │   ├── create-order.ts
│   │   └── cancel-order.ts
│   ├── queries/
│   │   ├── get-order.ts
│   │   └── list-customer-orders.ts
│   └── ports/                 # Port interfaces
│       ├── payment-port.ts
│       └── notification-port.ts
├── adapters/                  # ADAPTERS (outer)
│   ├── persistence/
│   │   ├── postgres-order-repository.ts
│   │   └── in-memory-order-repository.ts
│   ├── http/
│   │   ├── express-order-controller.ts
│   │   └── express-router.ts
│   ├── messaging/
│   │   └── rabbitmq-event-bus.ts
│   └── payment/
│       └── stripe-payment-adapter.ts
├── infrastructure/            # FRAMEWORKS
│   ├── database.ts
│   ├── config.ts
│   └── logger.ts
├── composition-root.ts        # DI WIRING
└── main.ts                    # ENTRY POINT
```

### Pattern 2: Repository Pattern Template

```typescript
// Generic repository pattern with common operations
interface Repository<T, ID> {
  findById(id: ID): Promise<T | null>;
  findAll(): Promise<T[]>;
  save(entity: T): Promise<void>;
  delete(id: ID): Promise<void>;
  exists(id: ID): Promise<boolean>;
}

// Specific repository extends generic with domain-specific methods
interface OrderRepository extends Repository<Order, string> {
  findByCustomerId(customerId: string): Promise<Order[]>;
  findByStatus(status: Order['status']): Promise<Order[]>;
  countByStatus(status: Order['status']): Promise<number>;
}
```

### Pattern 3: Use Case Template

```typescript
// Template for a complete use case with input/output validation

interface UseCase<I, O> {
  execute(input: I): Promise<O>;
}

interface CreateOrderInput {
  customerId: string;
  items: Array<{ productId: string; quantity: number }>;
}

interface CreateOrderOutput {
  orderId: string;
  totalAmount: Money;
  status: string;
}

class CreateOrderUseCase implements UseCase<CreateOrderInput, CreateOrderOutput> {
  constructor(
    private orderRepo: OrderRepository,
    private productRepo: ProductRepository,
    private eventBus: DomainEventBus,
  ) {}

  async execute(input: CreateOrderInput): Promise<CreateOrderOutput> {
    // 1. Validate input
    this.validate(input);

    // 2. Execute business logic
    const order = new OrderImpl();
    order.customerId = input.customerId;

    for (const item of input.items) {
      const product = await this.productRepo.findById(item.productId);
      if (!product) throw new Error(`Product not found: ${item.productId}`);
      order.addItem({
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: product.price,
      });
    }

    // 3. Persist
    await this.orderRepo.save(order);

    // 4. Emit events
    await this.eventBus.publish({
      type: 'ORDER_CREATED',
      orderId: order.id,
      customerId: order.customerId,
      totalAmount: order.totalAmount(),
      timestamp: new Date(),
    });

    // 5. Return output
    return {
      orderId: order.id,
      totalAmount: order.totalAmount(),
      status: order.status,
    };
  }

  private validate(input: CreateOrderInput): void {
    if (!input.customerId) throw new Error('Customer ID is required');
    if (!input.items.length) throw new Error('Order must have at least one item');
    for (const item of input.items) {
      if (item.quantity <= 0) throw new Error(`Invalid quantity for ${item.productId}`);
    }
  }
}
```

### Pattern 4: Event Sourcing with Clean Architecture

```typescript
// EVENT SOURCING: Store events, not state

interface EventSourcedAggregate {
  id: string;
  getUncommittedEvents(): DomainEvent[];
  markEventsAsCommitted(): void;
  loadFromHistory(events: DomainEvent[]): void;
}

class EventSourcedOrder implements EventSourcedAggregate {
  id: string = '';
  private uncommittedEvents: DomainEvent[] = [];
  private status: string = 'pending';
  private items: OrderItem[] = [];

  getUncommittedEvents(): DomainEvent[] { return this.uncommittedEvents; }
  markEventsAsCommitted(): void { this.uncommittedEvents = []; }

  loadFromHistory(events: DomainEvent[]): void {
    for (const event of events) {
      this.apply(event, false);
    }
  }

  // Commands
  createOrder(customerId: string): void {
    this.apply({
      type: 'ORDER_CREATED',
      orderId: crypto.randomUUID(),
      customerId,
      timestamp: new Date(),
    }, true);
  }

  addItem(productId: string, quantity: number, price: Money): void {
    this.apply({
      type: 'ITEM_ADDED',
      orderId: this.id,
      productId,
      quantity,
      price,
      timestamp: new Date(),
    }, true);
  }

  // Event application (state transition)
  private apply(event: DomainEvent, isNew: boolean): void {
    switch (event.type) {
      case 'ORDER_CREATED':
        this.id = (event as any).orderId;
        this.status = 'pending';
        break;
      case 'ITEM_ADDED':
        this.items.push({
          productId: (event as any).productId,
          quantity: (event as any).quantity,
          unitPrice: (event as any).price,
        });
        break;
    }
    if (isNew) this.uncommittedEvents.push(event);
  }
}
```

### Pattern 5: Layered Exception Handling

```typescript
// DOMAIN EXCEPTIONS: Business rule violations
class OrderCannotBeCancelledException extends Error {
  constructor(orderId: string, currentStatus: string) {
    super(`Order ${orderId} cannot be cancelled in status: ${currentStatus}`);
    this.name = 'OrderCannotBeCancelledException';
  }
}

class InsufficientStockException extends Error {
  constructor(productId: string, requested: number, available: number) {
    super(`Insufficient stock for ${productId}: requested ${requested}, available ${available}`);
    this.name = 'InsufficientStockException';
  }
}

// APPLICATION EXCEPTIONS: Use case failures
class OrderNotFoundError extends Error {
  constructor(orderId: string) {
    super(`Order not found: ${orderId}`);
    this.name = 'OrderNotFoundError';
  }
}

// INFRASTRUCTURE EXCEPTIONS: Technical failures
class DatabaseConnectionError extends Error {
  constructor(message: string) {
    super(`Database connection failed: ${message}`);
    this.name = 'DatabaseConnectionError';
  }
}

// ADAPTER LAYER: Translate domain exceptions to HTTP responses
class OrderController {
  async cancelOrder(req: Request, res: Response): Promise<void> {
    try {
      await this.orderService.cancelOrder(req.params.id);
      res.status(200).json({ message: 'Order cancelled' });
    } catch (error) {
      if (error instanceof OrderCannotBeCancelledException) {
        res.status(409).json({ error: error.message });
      } else if (error instanceof OrderNotFoundError) {
        res.status(404).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Internal server error' });
      }
    }
  }
}
```

## Edge Cases & Pitfalls

1. **Over-Engineering Small Projects:** Clean Architecture adds complexity. For a simple CRUD app with 3 endpoints, the overhead of repositories, use cases, and adapters is not justified. Start simple and add structure as complexity demands.

2. **Anemic Domain Model:** Putting all business logic in use cases while entities are just data containers. Entities should contain business rules (validation, state transitions, invariants), not just fields.

3. **Leaking Infrastructure into Domain:** Importing database types, HTTP request objects, or framework-specific code into domain models. The domain layer must be a pure business logic layer with zero external dependencies.

4. **Repository as God Interface:** Creating repositories with dozens of methods for every possible query. Keep repositories focused on aggregate-level operations. Complex queries belong in read models (CQRS query side).

5. **Event Soup:** Publishing domain events for every trivial state change. Events should represent meaningful business occurrences, not every database write. Too many events create noise and make systems harder to reason about.

6. **Circular Dependencies Between Layers:** Use case layer importing from adapter layer, or entities importing from application layer. Dependencies must always point inward. If you need to call outward, use dependency inversion (interfaces).

7. **Premature Abstraction:** Creating abstractions for things that only have one implementation. Don't create an interface for a service that will never have an alternative implementation unless you need it for testing.

8. **Transaction Boundary Confusion:** Unit of Work should span a single use case execution. Opening a transaction in the controller and closing it in the repository creates inconsistency. Manage transactions at the use case boundary.

9. **Read Model vs Write Model Confusion:** Trying to use the same model for reads and writes when CQRS is appropriate. Write models are optimized for consistency and business rules. Read models are optimized for query performance.

10. **Validation in Wrong Layer:** Business rule validation belongs in entities/use cases. Input format validation belongs in adapters/controllers. Schema validation belongs in the API layer. Mixing these creates confusion about where to look when validation fails.

11. **Repository Per Table vs Per Aggregate:** One repository per table defeats the purpose of aggregates. Repositories should persist and retrieve entire aggregates (root entity + contained entities), not individual rows.

12. **Ignoring Idempotency in Commands:** If a command handler can be called twice (network retry, message redelivery), it must be idempotent. Use idempotency keys or check for existing state before processing.

13. **Domain Events Without Subscribers:** Publishing events that nobody listens to is dead code. Every published event should have at least one subscriber. If not, question whether the event is necessary.

14. **Fat Interfaces in Ports:** Defining ports with too many methods violates Interface Segregation. Split ports by capability: `ReadPort`, `WritePort`, `NotificationPort` instead of one monolithic `ServicePort`.

15. **Ignoring the Composition Root:** Hardcoding dependency wiring throughout the application. All dependency creation should happen in a single composition root (or DI container configuration). This makes swapping implementations trivial.

## Integration with Other Skills

| Skill | Integration Point | How |
|-------|-------------------|-----|
| `system-design` | Architecture decisions | Clean Architecture provides the patterns; system design provides the context |
| `database-design` | Repository implementation | Database schema design is an adapter-layer concern; domain models are separate |
| `api-design` | Adapter layer | API contracts map to driving adapters; endpoints orchestrate use cases |
| `testing` | Testability | Clean Architecture's dependency inversion enables testing with mocks at every layer |
| `debugging` | Layer isolation | When a bug occurs, the layer boundaries tell you exactly where to look |
| `refactoring` | Architecture improvement | Refactoring to clean architecture follows the layer boundaries progressively |
| `code-review` | Architecture compliance | Code reviews can check dependency direction and layer violations |
| `documentation` | Architecture docs | Architecture Decision Records (ADRs) document why specific patterns were chosen |
| `devops` | Deployment | Infrastructure changes should only affect the outermost (frameworks) layer |
| `data-cleaning` | Data pipeline architecture | Data pipelines benefit from clean architecture: domain logic independent of ETL tools |

## Output Format Templates

### Standard Template (Architecture Decision Record)

```markdown
# ADR: [Decision Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context
[What is the issue that we're seeing that motivates this decision?]

## Decision
[What is the change that we're proposing and/or doing?]

## Consequences
### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Risks
- [Risk 1 and mitigation]

## Alternatives Considered
- [Alternative 1]: [Why it was rejected]
- [Alternative 2]: [Why it was rejected]
```

### Quick Template (Layer Violation Report)

```markdown
# Architecture Violation Report

## Violations Found
| Layer | File | Violation | Severity |
|-------|------|-----------|----------|
| Domain → Adapter | `order.ts` | Imports `DatabaseConnection` | 🔴 Critical |
| Use Case → Framework | `create-order.ts` | Imports `express.Request` | 🔴 Critical |

## Recommended Fixes
1. [Fix 1 with file reference]
2. [Fix 2 with file reference]
```

### Deep Template (Architecture Review)

```markdown
# Architecture Review: [System Name]

## Overview
[High-level description of the current architecture]

## Layer Analysis
### Entities
- **Health:** [Good/Fair/Poor]
- **Issues:** [List of domain model issues]

### Use Cases
- **Health:** [Good/Fair/Poor]
- **Issues:** [List of use case issues]

### Adapters
- **Health:** [Good/Fair/Poor]
- **Issues:** [List of adapter issues]

### Frameworks
- **Health:** [Good/Fair/Poor]
- **Issues:** [List of framework issues]

## Dependency Analysis
- **Dependency violations:** [Count and list]
- **Coupling score:** [Metric]
- **Testability score:** [% of domain with unit tests]

## Recommendations
1. [High priority fix]
2. [Medium priority fix]
3. [Low priority improvement]

## Migration Plan
| Phase | Scope | Effort | Risk |
|-------|-------|--------|------|
| Phase 1 | [What to change] | [Time] | [Risk level] |
| Phase 2 | [What to change] | [Time] | [Risk level] |
```

### Agent Template (Architecture Generation)

```markdown
# Architecture Generation Instructions

## Domain
- **Name:** [Domain name]
- **Key entities:** [List of core entities]
- **Business rules:** [Key invariants and constraints]
- **External integrations:** [Systems this will connect to]

## Requirements
- **Layers:** [entities/use-cases/adapters/frameworks]
- **Patterns:** [repository, unit-of-work, cqrs, domain-events, etc.]
- **Language:** [TypeScript | Python]
- **Database:** [PostgreSQL | MongoDB | etc.]
- **Framework:** [Express | FastAPI | etc.]

## Constraints
- **Max entity complexity:** [Simple/Medium/Complex]
- **Event sourcing required:** [Yes/No]
- **CQRS required:** [Yes/No]
- **Multi-tenancy:** [Yes/No]

## Output
- [ ] Entity models with business rules
- [ ] Repository interfaces
- [ ] Use case implementations
- [ ] Adapter implementations
- [ ] Composition root / DI wiring
- [ ] Unit tests for domain logic
```

## Rules

1. **The Dependency Rule is absolute.** Source code dependencies must always point inward. The domain layer knows nothing about the use case layer. The use case layer knows nothing about the adapter layer. Violations accumulate as architectural debt.

2. **Business logic lives in entities, not use cases.** Use cases orchestrate; entities decide. If you find business rules in your controllers or use cases, move them to the entity where they belong.

3. **Interfaces belong to the consumer, not the provider.** Repository interfaces are defined in the domain layer (where they're used), not in the adapter layer (where they're implemented). This is dependency inversion in practice.

4. **The composition root is the only place that knows all concrete types.** Every other layer depends on abstractions. Only the composition root (or DI container) knows which implementation to wire up.

5. **Test at the boundary.** Unit tests for domain logic should have zero external dependencies. Integration tests verify adapters. End-to-end tests verify the full stack. Don't mock what you don't own.

6. **One aggregate, one repository.** Repositories persist and retrieve aggregates (the root entity plus its contained entities), not individual database tables. The aggregate boundary is the transaction boundary.

7. **Domain events represent business facts, not system events.** `ORDER_CREATED` is a business event. `DATABASE_WRITTEN` is a system event. Only business events belong in the domain layer.

8. **Value objects are immutable and self-validating.** If a value can be invalid, it should be impossible to create an invalid instance. Use factory methods that throw on invalid input.

9. **Keep adapters thin.** Adapter code should translate between formats, not contain business logic. If you find business rules in an adapter, it belongs in the domain.

10. **CQRS is optional but powerful.** When read and write patterns diverge significantly, separate them. When they're similar, a single model is simpler. Don't adopt CQRS because it's fashionable—adopt it because it solves a real problem.

11. **Anti-corruption layers are insurance.** When integrating with external systems whose models may change, protect your domain with an adapter that translates between models. The cost is paid once; the benefit compounds.

12. **Event sourcing is a storage strategy, not an architecture.** You can use event sourcing for specific aggregates without making it the foundation of your entire system. Start with CRUD; add event sourcing where the audit trail or temporal queries justify the complexity.

13. **Value objects over primitives.** Use `Money` instead of `number`, `Email` instead of `string`, `OrderId` instead of `string`. Primitive obsession hides business meaning and makes validation inconsistent.

14. **Errors should be domain-specific.** `OrderCannotBeCancelledException` tells you more than `BadRequestError`. Create error types that encode the business rule that was violated.

15. **Refactor incrementally.** Don't rewrite a working system to adopt clean architecture. Move one bounded context at a time. Start with the most complex domain logic. Leave simple CRUD alone.
