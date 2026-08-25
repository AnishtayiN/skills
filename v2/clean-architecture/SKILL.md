---
name: clean-architecture
description: >-
  Design software project structures following clean architecture, SOLID principles, and domain-driven design patterns. Use this skill when the user asks about clean architecture, معماری تمیز, design project structure, SOLID principles, DDD, domain-driven design, layered architecture, hexagonal architecture, onion architecture, separation of concerns, project folder structure, dependency rule, طراحی ساختار پروژه, اصول SOLID, معماری لایه‌ای, معماری هگزاگونال, معماری پیازی, دامنه محور, جداسازی دغدغه‌ها, architecture advice, project organization, module structure, how should I organize this, folder structure, code organization, monolith vs microservices, service layer, repository pattern, dependency injection, inversion of control, bounded context, aggregate root, value object, domain event, application service, domain service, infrastructure layer, interface adapter, ports and adapters, software architecture, 系统架构, 项目结构, SOLID原则, 领域驱动设计, 分层架构, 六边形架构, 洋葱架构, 关注点分离.
---

# Clean Architecture Skill

## Overview

This skill designs project structures based on clean architecture principles: dependency inversion, separation of concerns, and testability. It produces concrete folder structures, module boundaries, and dependency rules — not just theory.

Architecture decisions are the hardest to change later. Getting the structure right early prevents months of accumulated technical debt. But architecture must serve the project, not the other way around — a small script does not need four layers of abstraction.

## When to Use This Skill

- User wants to design or reorganize a project's architecture
- User asks about clean architecture, SOLID, or DDD
- User needs a folder/module structure for a new project
- User wants to understand or apply layered, hexagonal, or onion architecture
- User asks how to separate concerns in their codebase
- User asks about bounded contexts, aggregates, or domain modeling
- User wants advice on monolith vs. microservices decomposition
- User asks about dependency injection or inversion of control
- User wants to improve testability through architecture
- User is starting a new project and needs an initial structure
- User asks about ports and adapters (hexagonal) architecture
- User wants to understand how to organize a growing codebase

## Core Principles

### The Dependency Rule

Dependencies point **inward only**. Inner layers know nothing about outer layers.

```
Frameworks & Drivers (outermost)
    Interface Adapters
        Application Use Cases
            Domain Entities (innermost)
```

### SOLID Quick Reference

| Principle | Rule | Violation Symptom |
|-----------|------|------------------|
| Single Responsibility | A class/module has one reason to change | Changing X requires modifying unrelated Y |
| Open/Closed | Open for extension, closed for modification | Every new feature requires editing existing code |
| Liskov Substitution | Subtypes must be substitutable for their base types | Subclass breaks caller when used in place of parent |
| Interface Segregation | Prefer many specific interfaces over one general interface | Classes implement methods they don't use (throw UnsupportedOperationException) |
| Dependency Inversion | Depend on abstractions, not concretions | High-level modules import low-level implementation details |

## Design Workflow

### Step 1: Understand the Domain

1. Ask or infer: What is the core domain? What are the main entities and business rules?
2. Identify the primary actors (users, external systems, scheduled jobs).
3. Identify the use cases — what does the system actually *do* from the user's perspective?
4. Identify bounded contexts if the domain is complex — where do terms change meaning?

### Step 2: Detect the Existing Project

If reorganizing an existing project:
1. Read the current folder structure and key files.
2. Identify which parts are domain logic vs. infrastructure vs. framework code.
3. Note the language and framework to tailor the folder structure.
4. Identify pain points: tight coupling, hard-to-test code, circular dependencies.

### Step 3: Design the Structure

Define layers and their contents:

#### Domain Layer (innermost)
- Entities, value objects, domain events
- Repository interfaces (only interfaces, no implementations)
- Domain services for complex business logic
- **No framework imports. No database types. No HTTP types.**

#### Application Layer (use cases)
- Use case classes / functions (one per user action)
- Input/output DTOs (request/response models)
- Application services that orchestrate use cases
- **Depends only on Domain. No framework imports.**

#### Interface Adapters Layer
- Controllers / route handlers
- Repository implementations (database access)
- External service clients (API calls, messaging)
- Presenters / serializers / mappers
- **Depends on Application and Domain.**

#### Frameworks & Drivers Layer (outermost)
- Framework setup (Express, FastAPI, Spring Boot, etc.)
- Database configuration and migrations
- Middleware, authentication providers
- **Depends on everything inner.**

### Step 4: Scale to Project Size

Not every project needs the full four-layer treatment:

| Project Size | Recommended Structure |
|-------------|----------------------|
| Script / small tool | Single file or flat module structure |
| Small app (< 10 use cases) | Two layers: domain + infrastructure |
| Medium app (10-50 use cases) | Three layers: domain + application + infrastructure |
| Large app / enterprise | Full four layers with bounded contexts |

### Step 5: Output the Structure

## Advanced Techniques

### Bounded Context Mapping
For complex domains, identify bounded contexts where terms have different meanings:
```
# E-commerce example:
# Product Context: "Product" = catalog item with description, price, images
# Inventory Context: "Product" = stock-keeping unit with warehouse location
# Shipping Context: "Product" = physical item with weight, dimensions
# Each context has its own model — they communicate via anti-corruption layers
```

### Dependency Injection Patterns
- **Constructor injection** (preferred): Dependencies passed to constructor, making them explicit and testable
- **Property injection**: For optional dependencies or framework-managed components
- **Service locator**: Anti-pattern — hides dependencies, makes testing harder. Avoid.

### Anti-Corruption Layers
When integrating with external systems or legacy code:
- Create a translation layer that converts between your domain model and the external model
- This isolates your core domain from external changes
- The ACL should be the ONLY place that knows about the external system's data format

### Event-Driven Architecture Integration
- Domain events: Published when something important happens in the domain
- Event handlers: React to domain events (notification, audit, sync)
- Events flow outward (domain → application → infrastructure)
- Keep event handlers in the application or infrastructure layer, never in domain

### CQRS (Command Query Responsibility Segregation)
- Separate read models from write models
- Commands mutate state, queries read state
- Useful when read and write patterns are very different
- Don't apply by default — only when the complexity is justified

## Common Patterns

### Pattern 1: The Repository Pattern
Domain defines the interface, infrastructure provides the implementation.
```
// Domain layer: interface only
class UserRepository {
  findById(id): User | null;
  save(user: User): void;
}

// Infrastructure layer: concrete implementation
class PostgresUserRepository implements UserRepository {
  // SQL implementation here
}
```

### Pattern 2: The Use Case Pattern
Each user action is a single class/function in the application layer.
```
class CreateUserUseCase {
  constructor(userRepo, emailService) {}
  async execute(request): Promise<UserDTO> {
    // Validate, create entity, save, notify
  }
}
```

### Pattern 3: The Adapter Pattern
Convert between external formats and internal domain models.
```
// HTTP controller (adapter) receives HTTP request, converts to DTO, calls use case
// Repository implementation (adapter) converts domain entity to database row
// Each adapter handles one external concern (HTTP, SQL, REST API, message queue)
```

### Pattern 4: The Domain Service Pattern
When business logic doesn't naturally belong to a single entity.
```
// Doesn't fit in User entity, doesn't fit in Order entity
// But is clearly business logic, not infrastructure
class PricingService {
  calculateDiscount(user: User, order: Order): Money {
    // Complex pricing rules that need data from multiple entities
  }
}
```

### Pattern 5: The Aggregate Root Pattern
Cluster entities that must be consistent together, accessed through a root.
```
// Order is the aggregate root. OrderLine items are only modified through Order.
// You never directly update an OrderLine — you go through Order.addLine() or Order.removeLine()
// This ensures invariants are always maintained
```

## Edge Cases & Pitfalls

1. **Over-architecting a simple project** — Four layers for a to-do app is waste. Scale architecture to the problem.
2. **Premature abstraction** — Don't create interfaces for things that have only one implementation and are unlikely to have another.
3. **Anemic domain models** — Entities with only getters/setters and no behavior. The domain layer becomes just data structures.
4. **Leaking infrastructure into domain** — If domain entities import database types, ORM annotations, or HTTP types, the dependency rule is violated.
5. **Ignoring framework constraints** — Some frameworks strongly encourage specific patterns. Work with the framework, not against it.
6. **Too many small layers** — Each layer adds indirection. If a layer has only one class in it, consider merging.
7. **Circular dependencies between contexts** — Bounded contexts should not depend on each other directly. Use events or anti-corruption layers.
8. **DTO proliferation** — Creating a DTO for every single data transfer creates maintenance burden. Group related transfers.
9. **Ignoring the database** — Domain models should be designed for the domain, but must also be persistable. Don't design entities that can't be stored.
10. **Not considering team structure** — Architecture should reflect team boundaries (Conway's Law). Each team should own clear boundaries.
11. **Testability as afterthought** — If the architecture makes testing hard, it will be tested poorly. Design for testability from the start.
12. **One-size-fits-all** — Different parts of the system may need different architectural styles. A reporting module may use a simpler structure than the core domain.

## Integration with Other Skills

- **refactor**: When reorganizing an existing codebase to follow clean architecture, refactor skill handles the incremental code changes.
- **code-review**: Use code-review to verify that new code follows the architectural rules (dependency direction, layer placement).
- **test-generation**: Use cases in the application layer are the natural unit for testing. Each use case should have corresponding tests.
- **api-design**: API endpoints are interface adapters. Their design should follow the api-design skill, then route to application use cases.
- **database-schema**: Schema design should serve the domain model. Use database-schema when the persistence layer needs design work.
- **debug**: Architectural violations (wrong dependency direction) can cause subtle bugs. Debug can help trace these.
- **explain-code**: Use explain-code to help the team understand the architectural decisions and how modules interact.
- **dockerization**: Container architecture should mirror the logical architecture (one container per bounded context or service).

## Output Format

### Full Architecture Design Template

```
## Project Architecture

**Language/Framework:** [detected stack]
**Architecture Style:** [Clean / Hexagonal / Onion]
**Project Size:** [Small / Medium / Large]

### Folder Structure
project-root/
├── src/
│   ├── domain/          # Entities, value objects, repository interfaces
│   │   ├── entities/
│   │   ├── value-objects/
│   │   ├── repositories/
│   │   ├── events/
│   │   └── services/
│   ├── application/     # Use cases, DTOs, ports
│   │   ├── usecases/
│   │   ├── dtos/
│   │   └── ports/
│   ├── infrastructure/  # DB, external APIs, framework adapters
│   │   ├── persistence/
│   │   ├── http/
│   │   ├── messaging/
│   │   └── config/
│   └── main.ts          # Entry point / composition root
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
└── docs/

### Dependency Flow
domain ← application ← infrastructure ← main

### Key Decisions
- [Decision 1]: [Why]
- [Decision 2]: [Why]

### Bounded Contexts
| Context | Core Entities | Communication |
|---------|--------------|---------------|
| [Name] | [entities] | [events/API/shared kernel] |
```

### Architecture Review Template

```
## Architecture Review

**Project:** [name]
**Current Structure:** [brief description]

### Issues Found
| # | Issue | Location | Recommendation |
|---|-------|----------|---------------|
| 1 | [e.g., Domain imports HTTP types] | [file] | [Move to adapter layer] |

### Proposed Structure
[New folder structure or module organization]

### Migration Plan
1. [Step 1 — low risk]
2. [Step 2 — medium risk]
3. [Step 3 — higher risk, needs testing]
```

### Quick Structure Suggestion Template

```
**For a [language/framework] [project type]:**
```
[folder tree]
```
**Key principle:** [one-line architectural guideline]
```

## Rules

- Tailor the structure to the project size. A small script does not need four layers.
- If the project already has a structure, propose incremental changes, not a full rewrite.
- Provide concrete file/module names, not just abstract layer names.
- Present the response in the user's language; keep code and technical terms in English.
- Do not generate actual code files unless the user asks — provide the structure and let the user decide.
- If the user's framework has a well-established project structure (e.g., Rails, Next.js, Spring Boot), prefer the framework convention unless the user explicitly wants to deviate.
- Always explain *why* a structural decision was made, not just what the structure is.
