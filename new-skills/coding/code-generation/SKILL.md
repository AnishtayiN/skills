---
name: code-generation
description: >-
  Generate new code from requirements, specifications, or patterns. Write clean, production-ready code.
  TRIGGERS: write code, generate code, create function, implement, add feature, new file, scaffold,
  boilerplate, template, create class, create module, build, make, code this, بنویس کد, پیاده‌سازی,
  تابع بنویس, کلاس بنویس, فایل جدید, ماژول جدید, قابلیت جدید, اضافه کن, بساز,
  写代码, 生成代码, 创建函数, 实现功能, 新建文件, 脚手架, 模板, 新建类, 新建模块
priority: P1
dependencies: [project-analysis, requirement-analysis]
conflicts: []
---

# Code Generation Skill

## Overview

Write clean, production-ready code that follows project conventions and requirements. Generate type-safe, well-tested, maintainable code from specifications.

## When to Use This Skill

- User asks to create new code
- User needs a function, class, module, or file
- User wants to implement a feature
- User asks to scaffold or template
- User provides a specification or API contract

## When NOT to Use This Skill

- Modifying existing code (→ code-editing)
- Fixing bugs (→ debugging)
- Refactoring existing code (→ refactoring)

## Inputs Required

- What to create (function/class/module/file)
- Requirements or specifications
- Target location (file path)
- Language and framework
- Desired patterns or conventions

## Preconditions

- project-analysis completed (conventions known)
- requirement-analysis completed (specs clear)

## Workflow

### Step 1: Understand Conventions

```
1. Read existing code in the project
2. Match naming conventions (camelCase, snake_case, PascalCase, etc.)
3. Match import style (relative vs absolute, grouped imports)
4. Match error handling patterns
5. Match logging patterns
6. Match comment style (JSDoc, docstrings, rustdoc)
7. Match file organization patterns
8. Match dependency injection patterns
```

### Step 2: Design Before Coding

```
1. Define the interface (inputs, outputs, types)
2. Define error cases and error types
3. Consider edge cases (null, empty, boundary)
4. Plan test cases (happy path, error path, edge cases)
5. Choose appropriate data structures
6. Determine thread safety requirements
7. Plan for backward compatibility
```

### Step 3: Implement

```
1. Write the code following project conventions
2. Add appropriate error handling
3. Add necessary comments (why, not what)
4. Add type annotations (if applicable)
5. Follow SOLID principles
6. Add input validation
7. Write inline documentation for complex logic
```

### Step 4: Self-Review

```
1. Does it match the requirements?
2. Does it follow project conventions?
3. Are edge cases handled?
4. Is error handling present?
5. Is it readable?
6. Are types correct and complete?
7. Is it testable?
```

## Advanced Techniques

### 1. Language-Specific Patterns

**Python:**
```python
# Use dataclasses for data containers
from dataclasses import dataclass, field
from typing import Optional, List

@dataclass
class UserConfig:
    """Configuration for user session."""
    username: str
    timeout: int = 30
    retries: int = 3
    allowed_origins: List[str] = field(default_factory=list)

# Use context managers for resource management
class DatabaseConnection:
    def __init__(self, dsn: str):
        self.dsn = dsn
        self._conn = None

    def __enter__(self):
        self._conn = connect(self.dsn)
        return self._conn

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self._conn:
            self._conn.close()
```

**TypeScript:**
```typescript
// Use discriminated unions for state management
type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: string };

// Use branded types for type safety
type UserId = string & { __brand: 'UserId' };
type OrderId = string & { __brand: 'OrderId' };

function createUserId(id: string): UserId {
  return id as UserId;
}

// Use utility types
type CreateRequest = Omit<User, 'id' | 'createdAt'>;
type UpdateRequest = Partial<CreateRequest>;
```

**Rust:**
```rust
// Use Result for error handling
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("User not found: {0}")]
    NotFound(String),
    #[error("Permission denied")]
    Forbidden,
    #[error("Internal error: {0}")]
    Internal(#[from] std::io::Error),
}

// Use Builder pattern for complex construction
pub struct ServerBuilder {
    host: String,
    port: u16,
    max_connections: usize,
}

impl ServerBuilder {
    pub fn new(host: impl Into<String>) -> Self {
        Self {
            host: host.into(),
            port: 8080,
            max_connections: 100,
        }
    }

    pub fn port(mut self, port: u16) -> Self {
        self.port = port;
        self
    }

    pub fn build(self) -> Server { /* ... */ }
}
```

**Go:**
```go
// Use functional options pattern
type Server struct {
    host         string
    port         int
    readTimeout  time.Duration
    writeTimeout time.Duration
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) { s.port = port }
}

func WithTimeout(d time.Duration) Option {
    return func(s *Server) {
        s.readTimeout = d
        s.writeTimeout = d
    }
}

func NewServer(host string, opts ...Option) *Server {
    s := &Server{host: host, port: 8080}
    for _, opt := range opts {
        opt(s)
    }
    return s
}
```

### 2. Framework Conventions

**React Component Generation:**
```typescript
// Functional component with hooks
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  disabled = false,
  onClick,
  children,
}) => {
  const className = useMemo(
    () => cn('btn', `btn-${variant}`, `btn-${size}`),
    [variant, size]
  );

  return (
    <button
      className={className}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

**Express/Fastify Route Generation:**
```typescript
// Type-safe route handler
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  role: z.enum(['admin', 'user', 'viewer']),
});

type CreateUserInput = z.infer<typeof CreateUserSchema>;

router.post('/users', async (req: Request, res: Response) => {
  const result = CreateUserSchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({
      error: 'Validation failed',
      details: result.error.issues,
    });
  }

  const user = await userService.create(result.data);
  return res.status(201).json(user);
});
```

**Django REST View Generation:**
```python
from rest_framework import viewsets, serializers, permissions

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'name', 'email', 'created_at']
        read_only_fields = ['id', 'created_at']

class UserViewSet(viewsets.ModelViewSet):
    """CRUD operations for User model."""
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return User.objects.filter(
            organization=self.request.user.organization
        )
```

### 3. Scaffolding Techniques

**Project Scaffolding:**
```
1. Generate directory structure
2. Create configuration files
3. Set up build system
4. Add dependency manifests
5. Create boilerplate files
6. Set up CI/CD templates
7. Add linting/formatting config
8. Create README templates
```

**Module Scaffolding:**
```
1. Create module entry point
2. Define public API (exports)
3. Create internal structure
4. Add type definitions
5. Set up tests
6. Add documentation
7. Configure build pipeline
```

### 4. Type-Safe Code Generation

```typescript
// Generate type-safe API client
interface ApiEndpoint {
  '/users': {
    GET: { response: User[]; query: { page: number; limit: number } };
    POST: { response: User; body: CreateUserInput };
  };
  '/users/:id': {
    GET: { response: User; params: { id: string } };
    PUT: { response: User; params: { id: string }; body: UpdateUserInput };
    DELETE: { response: void; params: { id: string } };
  };
}

async function apiCall<
  Path extends keyof ApiEndpoint,
  Method extends keyof ApiEndpoint[Path],
>(
  path: Path,
  method: Method,
  options?: ApiEndpoint[Path][Method]
): Promise<any> {
  // Type-safe implementation
}
```

### 5. Error Handling Patterns

```typescript
// Result pattern for type-safe error handling
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function divide(
  a: number,
  b: number
): Promise<Result<number, { code: 'DIVISION_BY_ZERO'; message: string }>> {
  if (b === 0) {
    return {
      success: false,
      error: { code: 'DIVISION_BY_ZERO', message: 'Cannot divide by zero' },
    };
  }
  return { success: true, data: a / b };
}

// Usage with exhaustive handling
const result = await divide(10, 0);
if (result.success) {
  console.log(result.data); // TypeScript knows this is number
} else {
  console.error(result.error.code); // TypeScript knows the error type
}
```

### 6. Testing While Generating

```typescript
// Generate code with testability in mind
// Dependency injection for testability
interface UserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<void>;
}

class UserService {
  constructor(private readonly repo: UserRepository) {}

  async getUser(id: string): Promise<User> {
    const user = await this.repo.findById(id);
    if (!user) throw new NotFoundError(`User ${id} not found`);
    return user;
  }
}

// Corresponding test
describe('UserService', () => {
  const mockRepo: UserRepository = {
    findById: jest.fn(),
    save: jest.fn(),
  };

  const service = new UserService(mockRepo);

  it('should return user when found', async () => {
    const user = { id: '1', name: 'Test' };
    mockRepo.findById.mockResolvedValue(user);

    const result = await service.getUser('1');
    expect(result).toEqual(user);
  });

  it('should throw when user not found', async () => {
    mockRepo.findById.mockResolvedValue(null);
    await expect(service.getUser('999')).rejects.toThrow(NotFoundError);
  });
});
```

### 7. Concurrent and Async Code Generation

```python
# Async code generation with proper error handling
import asyncio
from typing import List

async def process_items(items: List[str]) -> List[Result]:
    """Process items concurrently with bounded parallelism."""
    semaphore = asyncio.Semaphore(10)  # Limit concurrency

    async def process_one(item: str) -> Result:
        async with semaphore:
            try:
                return await _process_single(item)
            except Exception as e:
                return Result.error(item=item, reason=str(e))

    return await asyncio.gather(*[process_one(item) for item in items])
```

## Common Patterns

### Pattern 1: Factory Pattern
```typescript
interface Logger {
  log(message: string): void;
  error(message: string): void;
}

function createLogger(type: 'console' | 'file' | 'remote'): Logger {
  switch (type) {
    case 'console':
      return new ConsoleLogger();
    case 'file':
      return new FileLogger(config.logPath);
    case 'remote':
      return new RemoteLogger(config.logEndpoint);
    default:
      throw new Error(`Unknown logger type: ${type}`);
  }
}
```

### Pattern 2: Builder Pattern
```typescript
class QueryBuilder {
  private table: string = '';
  private conditions: string[] = [];
  private orderBy: string = '';
  private limitCount: number = 0;

  from(table: string): this {
    this.table = table;
    return this;
  }

  where(condition: string): this {
    this.conditions.push(condition);
    return this;
  }

  order(column: string, dir: 'ASC' | 'DESC' = 'ASC'): this {
    this.orderBy = `${column} ${dir}`;
    return this;
  }

  limit(n: number): this {
    this.limitCount = n;
    return this;
  }

  build(): string {
    let sql = `SELECT * FROM ${this.table}`;
    if (this.conditions.length) {
      sql += ` WHERE ${this.conditions.join(' AND ')}`;
    }
    if (this.orderBy) sql += ` ORDER BY ${this.orderBy}`;
    if (this.limitCount) sql += ` LIMIT ${this.limitCount}`;
    return sql;
  }
}
```

### Pattern 3: Strategy Pattern
```typescript
interface SortStrategy<T> {
  sort(items: T[]): T[];
}

class QuickSort<T> implements SortStrategy<T> {
  sort(items: T[]): T[] { /* ... */ }
}

class MergeSort<T> implements SortStrategy<T> {
  sort(items: T[]): T[] { /* ... */ }
}

class Sorter<T> {
  constructor(private strategy: SortStrategy<T>) {}

  setStrategy(strategy: SortStrategy<T>): void {
    this.strategy = strategy;
  }

  sort(items: T[]): T[] {
    return this.strategy.sort(items);
  }
}
```

### Pattern 4: Observer Pattern
```typescript
type EventHandler<T> = (data: T) => void;

class EventEmitter<Events extends Record<string, any>> {
  private handlers = new Map<string, Set<EventHandler<any>>>();

  on<K extends keyof Events>(
    event: K,
    handler: EventHandler<Events[K]>
  ): () => void {
    if (!this.handlers.has(event as string)) {
      this.handlers.set(event as string, new Set());
    }
    this.handlers.get(event as string)!.add(handler);

    // Return unsubscribe function
    return () => {
      this.handlers.get(event as string)?.delete(handler);
    };
  }

  emit<K extends keyof Events>(event: K, data: Events[K]): void {
    this.handlers.get(event as string)?.forEach((h) => h(data));
  }
}
```

### Pattern 5: Middleware Pattern
```typescript
type Middleware<TContext> = (
  context: TContext,
  next: () => Promise<void>
) => Promise<void>;

class Pipeline<TContext> {
  private middlewares: Middleware<TContext>[] = [];

  use(middleware: Middleware<TContext>): this {
    this.middlewares.push(middleware);
    return this;
  }

  async execute(context: TContext): Promise<void> {
    let index = 0;

    const next = async (): Promise<void> => {
      if (index < this.middlewares.length) {
        const middleware = this.middlewares[index++];
        await middleware(context, next);
      }
    };

    await next();
  }
}
```

## Edge Cases & Pitfalls

1. **Null/undefined inputs**: Always validate inputs before generating code that uses them
2. **Empty collections**: Handle empty arrays, maps, and strings gracefully
3. **Boundary values**: Handle zero, negative, max integer, empty string explicitly
4. **Unicode/encoding**: Handle UTF-8, BOM, line endings (CRLF vs LF)
5. **Circular dependencies**: Detect and break circular imports before they cause issues
6. **Platform differences**: Account for OS-specific paths, line endings, and APIs
7. **Version compatibility**: Ensure generated code works with declared dependency versions
8. **Thread safety**: Add proper locking for shared mutable state
9. **Memory leaks**: Ensure event listeners, timers, and subscriptions are cleaned up
10. **Error propagation**: Don't silently swallow errors — propagate or log them
11. **Async race conditions**: Handle promise ordering and concurrent mutations
12. **Type narrowing**: Don't assume types without runtime validation
13. **Infinite recursion**: Add guards for recursive functions (depth limits, memoization)
14. **Floating point**: Avoid equality comparisons on floats; use tolerance-based comparison
15. **Hardcoded paths**: Never hardcode filesystem paths; use config or environment variables

## Integration with Other Skills

| Skill | Direction | Description |
|-------|-----------|-------------|
| project-analysis | ← Input | Conventions, structure, existing patterns |
| requirement-analysis | ← Input | Specifications, acceptance criteria |
| code-editing | → Output | Generated code may be edited later |
| code-review | → Output | Review generated code for quality |
| testing | → Output | Generate tests alongside code |
| code-explanation | ↔ Bidirectional | Explain existing patterns before generating similar |
| debugging | → Output | Debug generated code if issues arise |
| refactoring | → Output | Refactor generated code for improvement |
| documentation | → Output | Generate docs alongside code |

## Output Format Templates

### Standard Template
```
## Generated Code

### File: [path]

[Code with full implementation]

### Design Decisions
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]

### Edge Cases Handled
- [Case 1]: [How handled]
- [Case 2]: [How handled]

### Dependencies Added
- [package@version]: [Why needed]

### Testing
[Suggested test cases with code]
```

### Quick Template
```
## Quick Generation

### Code
[Minimal but complete code]

### Notes
- [Key assumption 1]
- [Key assumption 2]
```

### Deep Template
```
## Comprehensive Generation

### Context Analysis
[Analysis of existing codebase patterns]

### Architecture
[Design decisions and rationale]

### Implementation
[Full code with detailed comments]

### Error Handling
[All error scenarios addressed]

### Performance Considerations
[Time/space complexity, optimization notes]

### Security Considerations
[Input validation, injection prevention]

### Testing Strategy
[Unit tests, integration tests, edge cases]

### Migration Notes
[Steps to integrate with existing code]

### Future Improvements
[Possible enhancements]
```

### Agent-Specific Template
```
## Agent Code Generation

### Task
[What was requested]

### Generated
[Code output]

### Verification Steps
1. [Step to verify correctness]
2. [Step to verify integration]

### Follow-up Actions
- [ ] [Action 1]
- [ ] [Action 2]
```

## Rules

1. **ALWAYS** follow project conventions — read existing code first
2. **ALWAYS** handle errors explicitly — no silent failures
3. **ALWAYS** consider edge cases — null, empty, boundary values
4. **ALWAYS** add type annotations where the language supports them
5. **ALWAYS** validate inputs at public API boundaries
6. **ALWAYS** write code that is testable (dependency injection, pure functions)
7. **NEVER** generate code you don't understand
8. **NEVER** use deprecated APIs without explicit user approval
9. **NEVER** hardcode values that should be configurable
10. **NEVER** generate code with known vulnerabilities (SQL injection, XSS, etc.)
11. **NEVER** skip error handling for async operations
12. **NEVER** use global mutable state
13. **ONE** responsibility per function/class — follow SRP
14. **PREFER** composition over inheritance
15. **PREFER** explicit over implicit — clarity over cleverness

## Verification

- [ ] Code compiles/interprets without errors
- [ ] Follows project conventions
- [ ] Error handling present for all failure paths
- [ ] Types annotated (if applicable)
- [ ] No hardcoded values
- [ ] Edge cases considered and handled
- [ ] Code is testable
- [ ] No security vulnerabilities introduced
- [ ] Dependencies are necessary and versioned
- [ ] Documentation/comments explain "why" not "what"

## Failure Handling

- If unclear how to implement → Research or ask user
- If conventions conflict → Follow most common pattern
- If dependencies missing → Document what's needed
- If requirements ambiguous → Generate with sensible defaults and document assumptions
- If complex logic needed → Break into smaller, testable functions

## Safety Constraints

- Do NOT generate code with known vulnerabilities
- Do NOT use unsafe functions (eval, exec without sanitization)
- Do NOT hardcode secrets or credentials
- Do NOT generate code that bypasses security controls
- Do NOT generate code that violates privacy regulations
- Do NOT use `any` type excessively in TypeScript
- Do NOT use `unsafe` blocks in Rust without justification

## Anti-Patterns

- ❌ Copying code without understanding it
- ❌ Ignoring project conventions
- ❌ Generating code without error handling
- ❌ Hardcoding configuration values
- ❌ Skipping type annotations
- ❌ Writing code that works but is unreadable
- ❌ Generating overly complex one-liners instead of clear multi-line code
- ❌ Creating god functions that do everything
- ❌ Ignoring existing similar code in the project
- ❌ Generating code without considering testability

## Skill Interactions

- ← project-analysis: Conventions and structure
- ← requirement-analysis: What to build
- → code-review: Review generated code
- → testing: Test generated code
- → verification: Verify it works
- ↔ code-explanation: Understand patterns before generating
- → documentation: Document generated code
