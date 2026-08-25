---
name: clean-architecture
description: >-
  English: Clean architecture and SOLID principles, dependency rule, entities use-cases adapters frameworks layers, interface segregation principle, dependency inversion principle, repository pattern, unit of work pattern, CQRS command query responsibility segregation, domain events, hexagonal architecture ports and adapters, onion architecture, domain-driven design, bounded contexts, aggregate roots, value objects, domain services.
  Farsi: معماری تمیز و اصول SOLID، قاعده وابستگی، لایه‌های entities use-cases adapters frameworks، اصل جداسازی رابط، اصل وارونگی وابستگی، الگوی Repository، الگوی Unit of Work، CQRS جدایش مسئولیت فرمان پرسش، رویدادهای دامنه، معماری شش‌لایه ports and adapters، معماری پیازی، طراحی محور دامنه.
  Chinese: 洁净架构与SOLID原则，依赖规则，实体/用例/适配器/框架层，接口隔离原则，依赖倒置原则，仓储模式，工作单元模式，CQRS命令查询职责分离，领域事件，六边形架构端口与适配器，洋葱架构，领域驱动设计。
---

# Clean Architecture

## Overview

Clean Architecture is a software design philosophy introduced by Robert C. Martin (Uncle Bob) that organizes code into concentric layers with a strict dependency rule: source code dependencies point inward toward higher-level policies. The core principle is that business logic (entities and use cases) must never depend on external details (databases, frameworks, UI).

This skill encompasses Clean Architecture, SOLID principles, and complementary patterns like CQRS, Domain Events, Repository Pattern, and Unit of Work. It also covers related architectural styles including Hexagonal (Ports & Adapters) Architecture, Onion Architecture, and Domain-Driven Design (DDD) patterns such as Aggregates, Value Objects, and Bounded Contexts.

The goal is software that is **testable**, **maintainable**, **flexible**, and **independent of external frameworks**—systems where business logic can survive changes in database, UI, or infrastructure without modification.

## When to Use This Skill

- Building enterprise applications with complex business logic
- Projects expected to last 5+ years with evolving requirements
- Systems requiring testability without external dependencies
- Microservices with clear domain boundaries
- Applications that may switch databases, frameworks, or UI
- Teams needing clear separation of concerns and ownership
- Systems requiring audit trails, event sourcing, or CQRS
- Projects following Domain-Driven Design (DDD)
- APIs that must remain backward compatible during refactoring
- Applications with complex validation and business rules

## When NOT to Use This Skill

- Simple CRUD applications with minimal business logic
- Prototype or proof-of-concept projects
- Small scripts or utilities
- Single-developer projects with no expected evolution
- Performance-critical systems where abstraction overhead matters
- Projects with tight deadlines and simple requirements

## Workflow

### Phase 1: Domain Modeling

1. **Identify entities**: Core business objects with identity (User, Order, Product)
2. **Define value objects**: Immutable objects without identity (Money, Address, DateRange)
3. **Design aggregates**: Clusters of entities with consistency boundaries
4. **Specify domain events**: What happens in the domain (OrderPlaced, PaymentReceived)
5. **Map bounded contexts**: Define clear boundaries between subdomains

### Phase 2: Architecture Design

1. **Define layers**: Entities → Use Cases → Interface Adapters → Frameworks & Drivers
2. **Create interfaces (ports)**: Abstract boundaries between layers
3. **Design repository interfaces**: In the domain/use-case layer, implement in adapter layer
4. **Plan CQRS separation**: Read models vs. write models if complexity warrants
5. **Define anti-corruption layers**: Translate between bounded contexts

### Phase 3: Implementation

1. **Implement entities**: Pure business logic, no external dependencies
2. **Build use cases**: Orchestrate entity interactions, define input/output ports
3. **Create adapters**: Repository implementations, API controllers, UI components
4. **Wire dependencies**: Use dependency injection to connect layers
5. **Implement domain events**: Event publishing and handling

### Phase 4: Testing

1. **Unit test entities**: Pure business logic tests, no mocks needed
2. **Test use cases**: Mock only repository/external interfaces
3. **Integration test adapters**: Test real database/API implementations
4. **Contract test interfaces**: Verify adapter implementations match port contracts
5. **End-to-end test workflows**: Full flow through all layers

### Phase 5: Evolution

1. **Refactor within layers**: Change implementations without affecting other layers
2. **Add new features**: Extend entities and use cases without modifying existing code
3. **Swap adapters**: Change database, API, or framework by swapping adapter implementations
4. **Extract bounded contexts**: Split into microservices when boundaries are clear
5. **Monitor and optimize**: Profile and optimize without violating architectural boundaries

## Advanced Techniques

### 1. Entity Design with Domain Logic

```typescript
// Value Object (immutable, no identity)
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: string
  ) {
    if (amount < 0) throw new Error('Amount cannot be negative');
    if (!currency || currency.length !== 3) {
      throw new Error('Invalid currency code');
    }
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies');
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  multiply(factor: number): Money {
    return new Money(this.amount * factor, this.currency);
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }

  static zero(currency: string): Money {
    return new Money(0, currency);
  }
}

// Entity (has identity, mutable state)
class Order {
  private _items: OrderItem[] = [];
  private _status: OrderStatus = OrderStatus.Draft;
  private _events: DomainEvent[] = [];

  constructor(
    public readonly id: OrderId,
    public readonly customerId: CustomerId,
    private _createdAt: Date = new Date()
  ) {}

  get items(): ReadonlyArray<OrderItem> {
    return [...this._items];
  }

  get status(): OrderStatus {
    return this._status;
  }

  get total(): Money {
    return this._items.reduce(
      (total, item) => total.add(item.subtotal),
      Money.zero('USD')
    );
  }

  addItem(productId: ProductId, quantity: number, price: Money): void {
    if (this._status !== OrderStatus.Draft) {
      throw new Error('Cannot add items to non-draft order');
    }
    if (quantity <= 0) {
      throw new Error('Quantity must be positive');
    }

    const existingItem = this._items.find(
      item => item.productId === productId
    );

    if (existingItem) {
      existingItem.increaseQuantity(quantity);
    } else {
      this._items.push(new OrderItem(productId, quantity, price));
    }

    this.addEvent(new ItemAddedToOrder(this.id, productId, quantity));
  }

  submit(): void {
    if (this._status !== OrderStatus.Draft) {
      throw new Error('Only draft orders can be submitted');
    }
    if (this._items.length === 0) {
      throw new Error('Cannot submit empty order');
    }

    this._status = OrderStatus.Submitted;
    this.addEvent(new OrderSubmitted(this.id, this.total));
  }

  cancel(reason: string): void {
    if (this._status === OrderStatus.Cancelled) {
      throw new Error('Order is already cancelled');
    }
    if (this._status === OrderStatus.Delivered) {
      throw new Error('Cannot cancel delivered order');
    }

    this._status = OrderStatus.Cancelled;
    this.addEvent(new OrderCancelled(this.id, reason));
  }

  private addEvent(event: DomainEvent): void {
    this._events.push(event);
  }

  pullEvents(): DomainEvent[] {
    const events = [...this._events];
    this._events = [];
    return events;
  }
}
```

### 2. Repository Pattern with Interface Segregation

```typescript
// Domain Layer: Repository Interface (Port)
interface OrderRepository {
  findById(id: OrderId): Promise<Order | null>;
  findByCustomerId(customerId: CustomerId): Promise<Order[]>;
  save(order: Order): Promise<void>;
  delete(id: OrderId): Promise<void>;
}

// Specific read model interface (Interface Segregation)
interface OrderReadModel {
  findById(id: string): Promise<OrderDTO | null>;
  findByStatus(status: OrderStatus): Promise<OrderSummaryDTO[]>;
  getOrdersByDateRange(start: Date, end: Date): Promise<OrderDTO[]>;
}

// Infrastructure Layer: Repository Implementation (Adapter)
class PostgresOrderRepository implements OrderRepository {
  constructor(private db: DatabaseConnection) {}

  async findById(id: OrderId): Promise<Order | null> {
    const row = await this.db.query(
      'SELECT * FROM orders WHERE id = $1',
      [id.value]
    );
    if (!row) return null;
    return this.toDomain(row);
  }

  async findByCustomerId(customerId: CustomerId): Promise<Order[]> {
    const rows = await this.db.query(
      'SELECT * FROM orders WHERE customer_id = $1',
      [customerId.value]
    );
    return rows.map(row => this.toDomain(row));
  }

  async save(order: Order): Promise<void> {
    const data = this.toPersistence(order);
    await this.db.query(
      `INSERT INTO orders (id, customer_id, status, total, created_at)
       VALUES ($1, $2, $3, $4, $5)
       ON CONFLICT (id) DO UPDATE SET
         status = $3, total = $4`,
      [data.id, data.customerId, data.status, data.total, data.createdAt]
    );
  }

  async delete(id: OrderId): Promise<void> {
    await this.db.query('DELETE FROM orders WHERE id = $1', [id.value]);
  }

  private toDomain(row: any): Order {
    // Map database row to domain entity
    const order = new Order(
      new OrderId(row.id),
      new CustomerId(row.customer_id),
      row.created_at
    );
    // Reconstitute items...
    return order;
  }

  private toPersistence(order: Order): any {
    // Map domain entity to database row
    return {
      id: order.id.value,
      customerId: order.customerId.value,
      status: order.status,
      total: order.total.amount,
      createdAt: order.createdAt,
    };
  }
}

// In-Memory Implementation for Testing
class InMemoryOrderRepository implements OrderRepository {
  private orders = new Map<string, Order>();

  async findById(id: OrderId): Promise<Order | null> {
    return this.orders.get(id.value) || null;
  }

  async findByCustomerId(customerId: CustomerId): Promise<Order[]> {
    return Array.from(this.orders.values()).filter(
      order => order.customerId === customerId
    );
  }

  async save(order: Order): Promise<void> {
    this.orders.set(order.id.value, order);
  }

  async delete(id: OrderId): Promise<void> {
    this.orders.delete(id.value);
  }
}
```

### 3. CQRS Implementation

```typescript
// Command Side
interface Command {
  readonly type: string;
}

interface CommandHandler<TCommand extends Command, TResult = void> {
  execute(command: TCommand): Promise<TResult>;
}

class PlaceOrderCommand implements Command {
  readonly type = 'PlaceOrder';
  constructor(
    public readonly customerId: string,
    public readonly items: Array<{
      productId: string;
      quantity: number;
      price: number;
    }>
  ) {}
}

class PlaceOrderHandler implements CommandHandler<PlaceOrderCommand, string> {
  constructor(
    private orderRepository: OrderRepository,
    private eventPublisher: EventPublisher
  ) {}

  async execute(command: PlaceOrderCommand): Promise<string> {
    const orderId = new OrderId(generateId());
    const customerId = new CustomerId(command.customerId);

    const order = new Order(orderId, customerId);

    for (const item of command.items) {
      order.addItem(
        new ProductId(item.productId),
        item.quantity,
        new Money(item.price, 'USD')
      );
    }

    order.submit();

    await this.orderRepository.save(order);

    // Publish domain events
    const events = order.pullEvents();
    for (const event of events) {
      await this.eventPublisher.publish(event);
    }

    return orderId.value;
  }
}

// Query Side
interface OrderQueryService {
  getOrderById(id: string): Promise<OrderView | null>;
  getOrdersByCustomer(customerId: string): Promise<OrderView[]>;
  getOrdersByStatus(status: string): Promise<OrderView[]>;
}

class PostgresOrderQueryService implements OrderQueryService {
  constructor(private db: DatabaseConnection) {}

  async getOrderById(id: string): Promise<OrderView | null> {
    const result = await this.db.query(
      `SELECT o.*, c.name as customer_name, c.email as customer_email
       FROM orders o
       JOIN customers c ON o.customer_id = c.id
       WHERE o.id = $1`,
      [id]
    );
    return result ? this.toView(result) : null;
  }

  async getOrdersByCustomer(customerId: string): Promise<OrderView[]> {
    const results = await this.db.query(
      `SELECT o.*, c.name as customer_name
       FROM orders o
       JOIN customers c ON o.customer_id = c.id
       WHERE o.customer_id = $1
       ORDER BY o.created_at DESC`,
      [customerId]
    );
    return results.map(r => this.toView(r));
  }

  async getOrdersByStatus(status: string): Promise<OrderView[]> {
    const results = await this.db.query(
      `SELECT o.*, c.name as customer_name
       FROM orders o
       JOIN customers c ON o.customer_id = c.id
       WHERE o.status = $1
       ORDER BY o.created_at DESC`,
      [status]
    );
    return results.map(r => this.toView(r));
  }

  private toView(row: any): OrderView {
    return {
      id: row.id,
      customerName: row.customer_name,
      customerEmail: row.customer_email,
      status: row.status,
      total: row.total,
      itemCount: row.item_count,
      createdAt: row.created_at,
    };
  }
}

// API Layer uses appropriate side
class OrderController {
  constructor(
    private commandHandler: PlaceOrderHandler,
    private queryService: OrderQueryService
  ) {}

  async placeOrder(req: Request, res: Response): Promise<void> {
    const command = new PlaceOrderCommand(
      req.body.customerId,
      req.body.items
    );
    const orderId = await this.commandHandler.execute(command);
    res.status(201).json({ orderId });
  }

  async getOrder(req: Request, res: Response): Promise<void> {
    const order = await this.queryService.getOrderById(req.params.id);
    if (!order) {
      res.status(404).json({ error: 'Order not found' });
      return;
    }
    res.json(order);
  }
}
```

### 4. Domain Events System

```typescript
// Domain Event Base
interface DomainEvent {
  readonly type: string;
  readonly occurredAt: Date;
  readonly aggregateId: string;
}

// Event Publisher Interface (Port)
interface EventPublisher {
  publish(event: DomainEvent): Promise<void>;
}

// Event Handler Interface
interface EventHandler<TEvent extends DomainEvent> {
  handle(event: TEvent): Promise<void>;
}

// Concrete Events
class OrderSubmitted implements DomainEvent {
  readonly type = 'OrderSubmitted';
  readonly occurredAt = new Date();

  constructor(
    public readonly aggregateId: string,
    public readonly total: Money
  ) {}
}

class PaymentReceived implements DomainEvent {
  readonly type = 'PaymentReceived';
  readonly occurredAt = new Date();

  constructor(
    public readonly aggregateId: string,
    public readonly amount: Money,
    public readonly paymentMethod: string
  ) {}
}

// Event Bus Implementation
class InMemoryEventBus implements EventPublisher {
  private handlers = new Map<string, EventHandler<any>[]>();

  subscribe<TEvent extends DomainEvent>(
    eventType: string,
    handler: EventHandler<TEvent>
  ): void {
    const existing = this.handlers.get(eventType) || [];
    this.handlers.set(eventType, [...existing, handler]);
  }

  async publish(event: DomainEvent): Promise<void> {
    const handlers = this.handlers.get(event.type) || [];
    await Promise.all(handlers.map(handler => handler.handle(event)));
  }
}

// Event Handlers
class SendOrderConfirmationHandler
  implements EventHandler<OrderSubmitted>
{
  constructor(private emailService: EmailService) {}

  async handle(event: OrderSubmitted): Promise<void> {
    await this.emailService.send({
      to: event.customerEmail,
      subject: `Order ${event.aggregateId} Confirmed`,
      body: `Your order of ${event.total} has been received.`,
    });
  }
}

class UpdateInventoryHandler implements EventHandler<OrderSubmitted> {
  constructor(private inventoryService: InventoryService) {}

  async handle(event: OrderSubmitted): Promise<void> {
    for (const item of event.items) {
      await this.inventoryService.reserve(
        item.productId,
        item.quantity
      );
    }
  }
}

// Wire up in composition root
const eventBus = new InMemoryEventBus();
eventBus.subscribe('OrderSubmitted', new SendOrderConfirmationHandler(emailService));
eventBus.subscribe('OrderSubmitted', new UpdateInventoryHandler(inventoryService));
```

### 5. Unit of Work Pattern

```typescript
// Unit of Work Interface
interface UnitOfWork {
  getRepository<T>(entityClass: new (...args: any[]) => T): Repository<T>;
  commit(): Promise<void>;
  rollback(): Promise<void>;
  begin(): Promise<void>;
}

interface Repository<T> {
  add(entity: T): void;
  update(entity: T): void;
  remove(entity: T): void;
  findById(id: string): Promise<T | null>;
}

// Implementation
class TypeORMUnitOfWork implements UnitOfWork {
  private repositories = new Map<string, Repository<any>>();
  private queryRunner: QueryRunner;

  constructor(private dataSource: DataSource) {
    this.queryRunner = dataSource.createQueryRunner();
  }

  async begin(): Promise<void> {
    await this.queryRunner.startTransaction();
  }

  getRepository<T>(entityClass: new (...args: any[]) => T): Repository<T> {
    const entityName = entityClass.name;
    if (!this.repositories.has(entityName)) {
      const repo = this.queryRunner.manager.getRepository(entityClass);
      this.repositories.set(entityName, new TypeORMRepositoryAdapter(repo));
    }
    return this.repositories.get(entityName)!;
  }

  async commit(): Promise<void> {
    try {
      await this.queryRunner.commitTransaction();
    } catch (error) {
      await this.queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await this.queryRunner.release();
    }
  }

  async rollback(): Promise<void> {
    await this.queryRunner.rollbackTransaction();
    await this.queryRunner.release();
  }
}

// Use Case using Unit of Work
class TransferMoneyUseCase {
  constructor(private unitOfWorkFactory: () => UnitOfWork) {}

  async execute(
    fromAccountId: string,
    toAccountId: string,
    amount: Money
  ): Promise<void> {
    const uow = this.unitOfWorkFactory();
    await uow.begin();

    try {
      const accountRepo = uow.getRepository(Account);
      const fromAccount = await accountRepo.findById(fromAccountId);
      const toAccount = await accountRepo.findById(toAccountId);

      if (!fromAccount || !toAccount) {
        throw new Error('Account not found');
      }

      fromAccount.debit(amount);
      toAccount.credit(amount);

      accountRepo.update(fromAccount);
      accountRepo.update(toAccount);

      await uow.commit();
    } catch (error) {
      await uow.rollback();
      throw error;
    }
  }
}
```

### 6. Dependency Injection Container

```typescript
// Simple DI Container
class Container {
  private services = new Map<string, any>();
  private factories = new Map<string, () => any>();

  register<T>(name: string, instance: T): void {
    this.services.set(name, instance);
  }

  registerFactory<T>(name: string, factory: () => T): void {
    this.factories.set(name, factory);
  }

  resolve<T>(name: string): T {
    if (this.services.has(name)) {
      return this.services.get(name) as T;
    }
    if (this.factories.has(name)) {
      const instance = this.factories.get(name)!();
      this.services.set(name, instance);
      return instance as T;
    }
    throw new Error(`Service '${name}' not registered`);
  }
}

// Composition Root
function createContainer(): Container {
  const container = new Container();

  // Infrastructure
  const db = new PostgresDatabase(process.env.DATABASE_URL!);
  container.register('Database', db);

  // Repositories
  container.registerFactory('OrderRepository', () =>
    new PostgresOrderRepository(container.resolve('Database'))
  );
  container.registerFactory('CustomerRepository', () =>
    new PostgresCustomerRepository(container.resolve('Database'))
  );

  // Services
  container.registerFactory('EmailService', () =>
    new SMTPEmailService({
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT || '587'),
    })
  );

  // Event Bus
  const eventBus = new InMemoryEventBus();
  container.register('EventBus', eventBus);

  // Use Cases
  container.registerFactory('PlaceOrderUseCase', () =>
    new PlaceOrderUseCase(
      container.resolve('OrderRepository'),
      container.resolve('EventBus')
    )
  );

  // Controllers
  container.registerFactory('OrderController', () =>
    new OrderController(
      container.resolve('PlaceOrderUseCase'),
      container.resolve('OrderRepository')
    )
  );

  return container;
}
```

### 7. Anti-Corruption Layer

```typescript
// External system interface (legacy)
interface LegacyOrderSystem {
  createOrder(data: any): Promise<any>;
  getOrder(id: number): Promise<any>;
  updateOrder(id: number, data: any): Promise<void>;
}

// Anti-Corruption Layer
class LegacyOrderAdapter implements OrderRepository {
  constructor(private legacySystem: LegacyOrderSystem) {}

  async findById(id: OrderId): Promise<Order | null> {
    const legacyOrder = await this.legacySystem.getOrder(
      parseInt(id.value)
    );
    if (!legacyOrder) return null;
    return this.toDomain(legacyOrder);
  }

  async save(order: Order): Promise<void> {
    const legacyData = this.toLegacy(order);
    if (order.isNew) {
      await this.legacySystem.createOrder(legacyData);
    } else {
      await this.legacySystem.updateOrder(
        parseInt(order.id.value),
        legacyData
      );
    }
  }

  private toDomain(legacyOrder: any): Order {
    // Translate legacy format to domain model
    return new Order(
      new OrderId(String(legacyOrder.ord_id)),
      new CustomerId(String(legacyOrder.cust_no)),
      new Date(legacyOrder.ord_date)
    );
  }

  private toLegacy(order: Order): any {
    // Translate domain model to legacy format
    return {
      ord_id: parseInt(order.id.value),
      cust_no: parseInt(order.customerId.value),
      ord_date: order.createdAt.toISOString(),
      status: this.mapStatus(order.status),
    };
  }

  private mapStatus(status: OrderStatus): string {
    const statusMap: Record<OrderStatus, string> = {
      [OrderStatus.Draft]: 'NEW',
      [OrderStatus.Submitted]: 'SUB',
      [OrderStatus.Paid]: 'PAID',
      [OrderStatus.Delivered]: 'DEL',
      [OrderStatus.Cancelled]: 'CAN',
    };
    return statusMap[status];
  }
}
```

## Common Patterns

### Pattern 1: Use Case with Input/Output Ports

```typescript
// Input Port
interface CreateOrderInput {
  customerId: string;
  items: Array<{
    productId: string;
    quantity: number;
    price: number;
  }>;
}

// Output Port
interface CreateOrderOutput {
  orderId: string;
  total: number;
  status: string;
}

// Use Case Implementation
class CreateOrderUseCase {
  constructor(
    private orderRepository: OrderRepository,
    private customerRepository: CustomerRepository,
    private eventPublisher: EventPublisher
  ) {}

  async execute(input: CreateOrderInput): Promise<CreateOrderOutput> {
    // Validate customer exists
    const customer = await this.customerRepository.findById(
      new CustomerId(input.customerId)
    );
    if (!customer) {
      throw new ValidationError('Customer not found');
    }

    // Create order entity
    const order = new Order(
      new OrderId(generateId()),
      new CustomerId(input.customerId)
    );

    // Add items
    for (const item of input.items) {
      order.addItem(
        new ProductId(item.productId),
        item.quantity,
        new Money(item.price, 'USD')
      );
    }

    // Submit order
    order.submit();

    // Persist
    await this.orderRepository.save(order);

    // Publish events
    const events = order.pullEvents();
    for (const event of events) {
      await this.eventPublisher.publish(event);
    }

    // Return output
    return {
      orderId: order.id.value,
      total: order.total.amount,
      status: order.status,
    };
  }
}
```

### Pattern 2: Domain Service for Cross-Entity Logic

```typescript
// Domain Service (logic that doesn't belong to a single entity)
class PricingService {
  calculateDiscount(
    customer: Customer,
    items: OrderItem[],
    currentDate: Date
  ): Money {
    let totalDiscount = Money.zero('USD');

    // Loyalty discount
    if (customer.yearsOfMembership > 5) {
      const loyaltyDiscount = items.reduce(
        (sum, item) => sum.add(item.subtotal.multiply(0.1)),
        Money.zero('USD')
      );
      totalDiscount = totalDiscount.add(loyaltyDiscount);
    }

    // Seasonal discount
    if (currentDate.getMonth() === 11) { // December
      const seasonalDiscount = items.reduce(
        (sum, item) => sum.add(item.subtotal.multiply(0.05)),
        Money.zero('USD')
      );
      totalDiscount = totalDiscount.add(seasonalDiscount);
    }

    // Maximum discount cap
    const maxDiscount = items.reduce(
      (sum, item) => sum.add(item.subtotal),
      Money.zero('USD')
    ).multiply(0.25);

    if (totalDiscount.amount > maxDiscount.amount) {
      totalDiscount = maxDiscount;
    }

    return totalDiscount;
  }
}
```

### Pattern 3: Specification Pattern

```typescript
// Specification Interface
interface Specification<T> {
  isSatisfiedBy(candidate: T): boolean;
  and(other: Specification<T>): Specification<T>;
  or(other: Specification<T>): Specification<T>;
  not(): Specification<T>;
}

// Base Implementation
class CompositeSpecification<T> implements Specification<T> {
  isSatisfiedBy(candidate: T): boolean {
    throw new Error('Must be implemented by subclass');
  }

  and(other: Specification<T>): Specification<T> {
    return new AndSpecification(this, other);
  }

  or(other: Specification<T>): Specification<T> {
    return new OrSpecification(this, other);
  }

  not(): Specification<T> {
    return new NotSpecification(this);
  }
}

// Concrete Specifications
class MinimumAgeSpecification extends CompositeSpecification<User> {
  constructor(private minimumAge: number) {
    super();
  }

  isSatisfiedBy(user: User): boolean {
    return user.age >= this.minimumAge;
  }
}

class ActiveSubscriptionSpecification extends CompositeSpecification<User> {
  isSatisfiedBy(user: User): boolean {
    return user.subscription?.status === 'active';
  }
}

// Usage
const canAccessPremium = new MinimumAgeSpecification(18)
  .and(new ActiveSubscriptionSpecification());

if (canAccessPremium.isSatisfiedBy(user)) {
  // Grant access
}
```

### Pattern 4: Factory Pattern for Complex Object Creation

```typescript
// Factory Interface
interface OrderFactory {
  createFromCart(cart: Cart): Order;
  createFromDirectOrder(input: DirectOrderInput): Order;
}

// Implementation
class StandardOrderFactory implements OrderFactory {
  createFromCart(cart: Cart): Order {
    const order = new Order(
      new OrderId(generateId()),
      cart.customerId
    );

    for (const item of cart.items) {
      order.addItem(item.productId, item.quantity, item.price);
    }

    return order;
  }

  createFromDirectOrder(input: DirectOrderInput): Order {
    const order = new Order(
      new OrderId(generateId()),
      new CustomerId(input.customerId)
    );

    for (const item of input.items) {
      order.addItem(
        new ProductId(item.productId),
        item.quantity,
        new Money(item.price, 'USD')
      );
    }

    return order;
  }
}
```

### Pattern 5: Pipeline Pattern for Request Processing

```typescript
// Middleware/Pipeline Interface
interface Middleware<TContext> {
  handle(
    context: TContext,
    next: () => Promise<void>
  ): Promise<void>;
}

// Pipeline Builder
class Pipeline<TContext> {
  private middlewares: Middleware<TContext>[] = [];

  use(middleware: Middleware<TContext>): this {
    this.middlewares.push(middleware);
    return this;
  }

  async execute(
    context: TContext,
    handler: (ctx: TContext) => Promise<void>
  ): Promise<void> {
    let index = -1;

    const dispatch = async (): Promise<void> => {
      index++;
      if (index < this.middlewares.length) {
        await this.middlewares[index].handle(context, dispatch);
      } else {
        await handler(context);
      }
    };

    await dispatch();
  }
}

// Concrete Middlewares
class ValidationMiddleware implements Middleware<RequestContext> {
  async handle(
    context: RequestContext,
    next: () => Promise<void>
  ): Promise<void> {
    const errors = context.validator.validate(context.body);
    if (errors.length > 0) {
      throw new ValidationError(errors);
    }
    await next();
  }
}

class AuthenticationMiddleware implements Middleware<RequestContext> {
  async handle(
    context: RequestContext,
    next: () => Promise<void>
  ): Promise<void> {
    const token = context.request.headers.authorization;
    if (!token) {
      throw new UnauthorizedError('No token provided');
    }
    context.user = await this.authService.verify(token);
    await next();
  }
}

// Usage
const pipeline = new Pipeline<RequestContext>();
pipeline
  .use(new ValidationMiddleware())
  .use(new AuthenticationMiddleware())
  .use(new AuthorizationMiddleware());

await pipeline.execute(context, async (ctx) => {
  // Handle request
});
```

## Edge Cases & Pitfalls

| # | Edge Case | Problem | Solution |
|---|-----------|---------|----------|
| 1 | **Anemic domain model** | Entities are just data containers; logic in services | Move business logic into entities; services only orchestrate |
| 2 | **Leaky abstractions** | Domain layer knows about database/framework | Enforce dependency rule; use interfaces at boundaries |
| 3 | **Over-engineering** | Simple CRUD wrapped in complex architecture | Match architecture complexity to problem complexity |
| 4 | **Circular dependencies** | Layers depend on each other | Enforce inward-only dependency direction |
| 5 | **Transaction management** | Multi-aggregate consistency | Use eventual consistency; sagas for cross-aggregate |
| 6 | **Performance overhead** | Too many abstractions slow the system | Profile before optimizing; measure actual impact |
| 7 | **Team adoption** | Developers resist new patterns | Start with smaller modules; demonstrate benefits |
| 8 | **Testing complexity** | Too many mocks needed | Ensure clean boundaries; use in-memory implementations |
| 9 | **Migration path** | Existing monolith hard to refactor | Strangler fig pattern; incrementally extract modules |
| 10 | **Eventual consistency** | CQRS read model out of date | Accept delay; use polling or signals for real-time needs |
| 11 | **Value object identity** | Comparing value objects by reference | Implement proper equality methods |
| 12 | **Aggregate boundaries** | Too large/small aggregates | Follow rule: small as possible, large as needed |
| 13 | **Cross-cutting concerns** | Logging, auth scattered across layers | Use decorators, middleware, or AOP |
| 14 | **DTO proliferation** | Too many mapping classes | Consider GraphQL or auto-mapping libraries |
| 15 | **Premature abstraction** | Abstracting before patterns emerge | Wait for 3+ occurrences before extracting |

## Integration with Other Skills

| Skill | Integration Points |
|-------|-------------------|
| **API Design** | Controllers as adapters; input/output ports as API contracts |
| **Database Design** | Repository pattern; ORM as adapter; migration management |
| **Testing** | Use cases testable without infrastructure; in-memory adapters |
| **Security** | Authentication as middleware; authorization in use cases |
| **Caching** | Cache as decorator around repositories |
| **Messaging** | Domain events as message bus integration |
| **Microservices** | Bounded contexts as service boundaries; anti-corruption layers |
| **DevOps** | Dependency injection; composition root per environment |
| **Monitoring** | Domain events for audit; metrics at adapter boundaries |
| **Documentation** | Use cases as documentation; architecture decision records |

## Output Format Templates

### Standard Template

```markdown
# Clean Architecture: [Feature]

## Domain Model
### Entities
| Entity | Identity | Key Properties |
|--------|----------|----------------|
| Order | OrderId | status, items, total |

### Value Objects
| Value Object | Properties | Validation |
|--------------|------------|------------|
| Money | amount, currency | amount >= 0 |

## Use Cases
| Use Case | Input | Output | Business Rules |
|----------|-------|--------|----------------|
| PlaceOrder | CreateOrderInput | CreateOrderOutput | Must have items |

## Interfaces (Ports)
| Port | Method | Purpose |
|------|--------|---------|
| OrderRepository | findById | Retrieve order |

## Implementation
[adapter implementations]

## Tests
[unit/integration test strategy]
```

### Quick Template

```markdown
# Quick Architecture: [Feature]

## Layers
1. Entities: [list core entities]
2. Use Cases: [list operations]
3. Adapters: [list implementations]
4. Frameworks: [list dependencies]

## Key Interfaces
- [Interface 1]
- [Interface 2]

## Dependencies
- [External service 1]
- [Database]
```

### Deep Template

```markdown
# Comprehensive Architecture Guide: [Feature]

## Domain Analysis
[DDD diagrams, bounded contexts]

## Architecture Diagram
[dependency diagram showing layers]

## Entity Design
[detailed entity specifications]

## Use Case Catalog
[complete use case documentation]

## Port Definitions
[all interfaces/contracts]

## Adapter Implementations
[detailed implementation guides]

## Event Design
[domain event catalog and flows]

## Migration Strategy
[how to evolve the architecture]

## Performance Considerations
[optimization strategies]
```

### Agent Template

```markdown
# Architecture Agent Instructions

## Task
Design and implement [feature] following Clean Architecture.

## Requirements
- [ ] Domain model with entities and value objects
- [ ] Use cases with input/output ports
- [ ] Repository interfaces in domain layer
- [ ] Implementations in adapter layer
- [ ] Dependency injection wiring
- [ ] Unit tests for use cases
- [ ] Integration tests for adapters

## Architecture Rules
1. Dependencies point inward only
2. Domain layer has no external dependencies
3. Use cases orchestrate, not implement business logic
4. Adapters implement port interfaces
5. Composition root wires everything

## Testing Strategy
- Entities: Pure unit tests
- Use Cases: Mock repositories
- Adapters: Integration tests with real implementations
- E2E: Full stack through composition root

## Documentation
- Update architecture docs
- Add ADRs for decisions
- Document bounded contexts
```

## Rules

1. **Dependency Rule**: Source code dependencies must point only inward toward higher-level policies
2. **Entities are pure**: No database, framework, or external service dependencies in entities
3. **Use cases orchestrate**: They coordinate entities and repositories, not implement business logic
4. **Interfaces at boundaries**: Always use interfaces (ports) when crossing layer boundaries
5. **Dependency injection**: Never instantiate dependencies directly; inject them
6. **Test without infrastructure**: Use cases must be testable with in-memory implementations
7. **Value objects are immutable**: No setters; create new instances for changes
8. **Aggregate consistency boundaries**: Modify only one aggregate per transaction
9. **Domain events for cross-aggregate**: Use events for eventual consistency between aggregates
10. **Keep frameworks at the edge**: UI, database, and frameworks are details; isolate them
11. **Single responsibility**: Each class/module should have one reason to change
12. **Interface segregation**: Don't force clients to depend on methods they don't use
13. **Composition over inheritance**: Favor composition for code reuse
14. **Explicit over implicit**: Make business rules visible in the domain model
15. **Continuous refactoring**: Architecture evolves; don't try to get it perfect upfront