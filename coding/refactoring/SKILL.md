---
name: refactoring
description: >-
  Improve code structure without changing behavior. Extract, rename, move, simplify, optimize.
  TRIGGERS: refactor, cleanup, clean up, simplify, restructure, reorganize, extract, rename,
  move function, split file, code smell, technical debt, duplication, complexity,
  بازسازی کد, تمیز کردن, ساده‌سازی, بازآرایی, حذف تکرار, کاهش پیچیدگی,
  重构, 清理, 简化, 重组, 重命名, 代码异味, 消除重复
priority: P2
dependencies: [project-analysis, code-review, testing]
conflicts: [debugging]
---

# Refactoring Skill

## Overview

Improve code structure, readability, and maintainability WITHOUT changing behavior. Apply SOLID principles, eliminate code smells, and use proven refactoring techniques safely.

## When to Use This Skill

- Code works but is hard to maintain
- User asks to clean up or simplify code
- Code smells detected (duplication, complexity, long functions)
- After debugging (prevent future bugs)
- Technical debt needs reduction
- Code review identified structural issues

## When NOT to Use This Skill

- Code has bugs (→ debugging first)
- User wants new features (→ code-generation)
- Code is already clean
- Performance issues without profiling (→ verify first)

## Inputs Required

- Code to refactor
- What to improve (readability, performance, structure)
- Constraints (must maintain API compatibility)

## Preconditions

- Code is working (all tests pass)
- Understanding of current behavior
- Test coverage exists (or characterization tests written)

## Workflow

### Step 1: Ensure Safety Net

```
1. Are there tests for this code?
   ├── YES → Run them, ensure they pass
   └── NO → Write characterization tests FIRST
2. Document current behavior
3. Set up a way to verify nothing changed
4. Create a baseline benchmark (if performance matters)
```

### Step 2: Identify Smells

```
Common code smells:
- Long functions (> 30 lines)
- Deep nesting (> 3 levels)
- Code duplication
- Long parameter lists (> 3 params)
- God classes (doing too much)
- Feature envy (using other class's data)
- Primitive obsession (using primitives for complex concepts)
- Switch statements / long if-else chains
- Data clumps (same fields appearing together)
- Speculative generality (premature abstraction)
```

### Step 3: Apply Refactoring

```
Safe refactorings:
1. Extract Function → Break long functions
2. Extract Class → Split god classes
3. Rename → Improve naming
4. Move → Better organization
5. Inline → Remove unnecessary indirection
6. Replace with clearer alternative
7. Simplify conditionals
8. Remove duplication
```

### Step 4: Verify Behavior Unchanged

```
1. Run all tests — must pass
2. Compare before/after behavior
3. Check API compatibility
4. Verify no performance regression
```

## Advanced Techniques

### 1. Code Smell Catalog

**Bloaters:**

| Smell | Description | Refactoring |
|-------|-------------|-------------|
| Long Method | Function does too many things | Extract Function, Extract Class |
| Large Class | Class has too many responsibilities | Extract Class, Extract Interface |
| Long Parameter List | Too many parameters | Introduce Parameter Object, Preserve Whole Object |
| Data Clumps | Same 3+ fields appear together | Extract Class, Introduce Parameter Object |

**Object-Orientation Abusers:**

| Smell | Description | Refactoring |
|-------|-------------|-------------|
| Switch Statements | Type-checking with switch/if-else | Replace Conditional with Polymorphism |
| Parallel Inheritance | Two class hierarchies mirror each other | Replace Inheritance with Delegation |
| Temporary Field | Field used only in certain cases | Extract Class |
| Refused Bequest | Subclass doesn't use parent's methods | Replace Delegation |

**Change Preventers:**

| Smell | Description | Refactoring |
|-------|-------------|-------------|
| Divergent Change | One class modified for many reasons | Extract Class |
| Shotgun Surgery | One change requires edits in many places | Move Method, Move Field |
| Feature Envy | Method uses other class's data more than its own | Move Method |
| Modular Dependencies | Circular or excessive dependencies | Extract Interface, Move Method |

**Dispensables:**

| Smell | Description | Refactoring |
|-------|-------------|-------------|
| Comments | Comments explain bad code | Refactor the code, remove comments |
| Duplicate Code | Same code in multiple places | Extract Method, Pull Up Method |
| Dead Code | Code that's never executed | Delete it |
| Speculative Generality | Unused abstractions | Delete, Inline |

### 2. SOLID Principles Application

**S — Single Responsibility Principle:**
```python
# BEFORE: Class has multiple responsibilities
class UserManager:
    def create_user(self, data): ...
    def send_welcome_email(self, user): ...
    def log_audit(self, action, user): ...
    def generate_report(self, users): ...

# AFTER: Each class has one responsibility
class UserService:
    def create_user(self, data): ...

class EmailService:
    def send_welcome_email(self, user): ...

class AuditService:
    def log_audit(self, action, user): ...

class ReportService:
    def generate_report(self, users): ...
```

**O — Open/Closed Principle:**
```typescript
// BEFORE: Must modify class for new discount types
class DiscountCalculator {
  calculate(type: string, amount: number): number {
    if (type === 'percentage') return amount * 0.1;
    if (type === 'fixed') return amount - 10;
    if (type === 'bogo') return amount / 2;
    throw new Error(`Unknown type: ${type}`);
  }
}

// AFTER: Open for extension, closed for modification
interface DiscountStrategy {
  calculate(amount: number): number;
}

class PercentageDiscount implements DiscountStrategy {
  calculate(amount: number): number { return amount * 0.1; }
}

class FixedDiscount implements DiscountStrategy {
  calculate(amount: number): number { return amount - 10; }
}

class DiscountCalculator {
  constructor(private strategy: DiscountStrategy) {}
  calculate(amount: number): number {
    return this.strategy.calculate(amount);
  }
}
```

**L — Liskov Substitution Principle:**
```python
# BEFORE: Rectangle/Square problem
class Rectangle:
    def set_width(self, w): self.width = w
    def set_height(self, h): self.height = h
    def area(self): return self.width * self.height

class Square(Rectangle):
    def set_width(self, w):
        self.width = self.height = w  # Violates LSP!
    def set_height(self, h):
        self.width = self.height = h  # Violates LSP!

# AFTER: Use composition or separate hierarchies
class Shape:
    def area(self) -> float: ...

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height
    def area(self) -> float:
        return self.width * self.height

class Square(Shape):
    def __init__(self, side: float):
        self.side = side
    def area(self) -> float:
        return self.side ** 2
```

**I — Interface Segregation Principle:**
```typescript
// BEFORE: Fat interface forces implementers to implement unused methods
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
  attendMeeting(): void;
  writeReport(): void;
}

// AFTER: Segregated interfaces
interface Workable {
  work(): void;
}

interface Feedable {
  eat(): void;
  sleep(): void;
}

interface Manageable {
  attendMeeting(): void;
  writeReport(): void;
}

class Developer implements Workable, Feedable {
  work() { /* ... */ }
  eat() { /* ... */ }
  sleep() { /* ... */ }
}

class Robot implements Workable {
  work() { /* ... */ }
}
```

**D — Dependency Inversion Principle:**
```python
# BEFORE: High-level module depends on low-level module
class OrderProcessor:
    def __init__(self):
        self.mysql_db = MySQLDatabase()  # Concrete dependency!

# AFTER: Depend on abstractions
class OrderProcessor:
    def __init__(self, db: Database):  # Abstract dependency
        self.db = db

class Database(ABC):
    @abstractmethod
    def save(self, entity): ...

class MySQLDatabase(Database):
    def save(self, entity): ...

class PostgresDatabase(Database):
    def save(self, entity): ...
```

### 3. Extract / Inline / Move / Rename Techniques

**Extract Function:**
```python
# BEFORE
def process_order(order):
    # Validation (20 lines)
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Negative total")
    # ... 18 more lines of validation

    # Pricing (15 lines)
    subtotal = sum(item.price * item.quantity for item in order.items)
    tax = subtotal * 0.1
    total = subtotal + tax
    # ... 11 more lines of pricing logic

    # Persist (10 lines)
    db.save(order)
    cache.invalidate(f"order:{order.id}")
    # ... 8 more lines

# AFTER
def process_order(order):
    validate_order(order)
    calculate_pricing(order)
    persist_order(order)

def validate_order(order):
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Negative total")
    # ... validation logic

def calculate_pricing(order):
    subtotal = sum(item.price * item.quantity for item in order.items)
    tax = subtotal * 0.1
    order.subtotal = subtotal
    order.tax = tax
    order.total = subtotal + tax

def persist_order(order):
    db.save(order)
    cache.invalidate(f"order:{order.id}")
```

**Inline Function:**
```python
# BEFORE: Unnecessary indirection
def get_user_name(user):
    return f"{user.first_name} {user.last_name}"

def greet_user(user):
    name = get_user_name(user)
    return f"Hello, {name}!"

# AFTER: Inline if the function is trivial and only used once
def greet_user(user):
    name = f"{user.first_name} {user.last_name}"
    return f"Hello, {name}!"
```

**Move Method/Field:**
```python
# BEFORE: Method belongs in another class
class Order:
    def calculate_tax(self):
        return self.subtotal * self.tax_rate

# AFTER: Move to a more appropriate class
class TaxCalculator:
    def calculate(self, order):
        return order.subtotal * order.tax_rate

class Order:
    @property
    def tax(self):
        return TaxCalculator().calculate(self)
```

**Rename:**
```python
# BEFORE: Poor naming
def proc(d):
    r = []
    for x in d:
        if x.s == 'a':
            r.append(x)
    return r

# AFTER: Clear naming
def filter_active_users(users):
    return [user for user in users if user.status == 'active']
```

### 4. Refactoring Safety Net with Tests

```
SAFETY NET PROTOCOL:

1. BEFORE refactoring:
   a. Run all existing tests — record baseline (must all pass)
   b. If no tests exist, write characterization tests:
      - Capture current behavior as tests
      - Include edge cases and error paths
      - Run to confirm they pass
   c. Commit current state (clean git history)

2. DURING refactoring:
   a. Make ONE small change at a time
   b. Run tests after EACH change
   c. If tests fail, REVERT immediately
   d. Commit after each successful refactoring step

3. AFTER refactoring:
   a. Run full test suite
   b. Compare behavior with baseline
   c. Verify no new code smells introduced
   d. Check API compatibility
   e. Review for performance regression
```

### 5. Performance-Aware Refactoring

```python
# BEFORE: O(n²) nested loop
def find_duplicates(items):
    duplicates = []
    for i, item in enumerate(items):
        for j, other in enumerate(items):
            if i != j and item == other:
                duplicates.append(item)
    return duplicates

# AFTER: O(n) using set
def find_duplicates(items):
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        seen.add(item)
    return list(duplicates)
```

**Performance refactoring guidelines:**
- ALWAYS profile before optimizing
- NEVER optimize without measuring
- Focus on hot paths (the 20% of code that runs 80% of the time)
- Consider algorithmic improvement over micro-optimization
- Cache expensive computations
- Avoid premature optimization — clarity first

### 6. Conditional Simplification

```typescript
// BEFORE: Complex nested conditions
function getDiscount(user: User, order: Order): number {
  if (user.isPremium) {
    if (order.total > 100) {
      if (order.items.length > 5) {
        return 0.25;
      } else {
        return 0.15;
      }
    } else {
      if (order.items.length > 5) {
        return 0.10;
      } else {
        return 0.05;
      }
    }
  } else {
    if (order.total > 100) {
      return 0.10;
    } else {
      return 0;
    }
  }
}

// AFTER: Table-driven or guard clauses
function getDiscount(user: User, order: Order): number {
  if (!user.isPremium && order.total <= 100) return 0;

  const premiumDiscount = user.isPremium ? 0.10 : 0;
  const bulkDiscount = order.items.length > 5 ? 0.05 : 0;
  const highValueDiscount = order.total > 100 ? 0.10 : 0;

  return Math.min(premiumDiscount + bulkDiscount + highValueDiscount, 0.25);
}
```

### 7. Replace Temp with Query

```python
# BEFORE: Temporary variable obscures logic
def calculate_price(order):
    base_price = order.quantity * order.item_price
    if base_price > 1000:
        discount = base_price * 0.05
    else:
        discount = 0
    return base_price - discount

# AFTER: Extract to method for clarity
def calculate_price(order):
    return self._base_price(order) - self._discount(order)

def _base_price(self, order):
    return order.quantity * order.item_price

def _discount(self, order):
    if self._base_price(order) > 1000:
        return self._base_price(order) * 0.05
    return 0
```

## Common Patterns

### Pattern 1: Replace Conditional with Polymorphism
```typescript
// BEFORE: Switch on type
class Notification {
  send(user: User): void {
    switch (this.type) {
      case 'email':
        this.sendEmail(user);
        break;
      case 'sms':
        this.sendSMS(user);
        break;
      case 'push':
        this.sendPush(user);
        break;
    }
  }
}

// AFTER: Polymorphic dispatch
interface NotificationStrategy {
  send(user: User): void;
}

class EmailNotification implements NotificationStrategy {
  send(user: User): void { /* email logic */ }
}

class SMSNotification implements NotificationStrategy {
  send(user: User): void { /* SMS logic */ }
}

class PushNotification implements NotificationStrategy {
  send(user: User): void { /* push logic */ }
}
```

### Pattern 2: Introduce Parameter Object
```python
# BEFORE
def create_event(title, start, end, location, description, organizer):
    ...

# AFTER
@dataclass
class EventParams:
    title: str
    start: datetime
    end: datetime
    location: str = ''
    description: str = ''
    organizer: str = ''

def create_event(params: EventParams):
    ...
```

### Pattern 3: Replace Magic Numbers with Named Constants
```python
# BEFORE
if len(password) < 8:
    raise ValueError("Password too short")
if user.age >= 18:
    allow_access()

# AFTER
MIN_PASSWORD_LENGTH = 8
LEGAL_AGE = 18

if len(password) < MIN_PASSWORD_LENGTH:
    raise ValueError(f"Password must be at least {MIN_PASSWORD_LENGTH} characters")
if user.age >= LEGAL_AGE:
    allow_access()
```

### Pattern 4: Decompose Conditional
```python
# BEFORE
if date.before(summer_start) or date.after(summer_end):
    charge = quantity * winter_rate + winter_service_charge
else:
    charge = quantity * summer_rate

# AFTER
if is_winter(date):
    charge = winter_charge(quantity)
else:
    charge = summer_charge(quantity)

def is_winter(date):
    return date.before(summer_start) or date.after(summer_end)

def winter_charge(quantity):
    return quantity * winter_rate + winter_service_charge

def summer_charge(quantity):
    return quantity * summer_rate
```

### Pattern 5: Replace Nested Conditionals with Guard Clauses
```python
# BEFORE
def get_adjusted_salary(employee):
    if employee.is_active:
        if not employee.on_leave:
            if employee.years_of_service > 1:
                return employee.base_salary * 1.1
            else:
                return employee.base_salary
        else:
            return 0
    else:
        return 0

# AFTER
def get_adjusted_salary(employee):
    if not employee.is_active:
        return 0
    if employee.on_leave:
        return 0
    if employee.years_of_service <= 1:
        return employee.base_salary
    return employee.base_salary * 1.1
```

## Edge Cases & Pitfalls

1. **No test coverage**: Refactoring without tests is flying blind
2. **Behavioral change**: Ensure refactoring doesn't alter observable behavior
3. **API compatibility**: Public APIs must remain backward compatible
4. **Performance regression**: Structural changes may affect performance
5. **Partial refactoring**: Leaving code in an inconsistent state
6. **Over-abstraction**: Creating abstractions for single-use cases
7. **Premature optimization**: Optimizing before profiling
8. **Rename cascading**: Renaming requires updating all references
9. **Merge conflicts**: Refactoring + concurrent changes cause conflicts
10. **Documentation drift**: Docs become outdated after refactoring
11. **Test breakage**: Tests may need updating after structural changes
12. **Circular dependencies**: Moving code can create import cycles
13. **Type system breakage**: Changing types breaks downstream code
14. **State management**: Moving state between classes requires careful handling
15. **Third-party integration**: Refactoring internals while maintaining external contracts

## Integration with Other Skills

| Skill | Direction | Description |
|-------|-----------|-------------|
| project-analysis | ← Input | Understand codebase structure |
| code-review | ← Input | Identifies what to refactor |
| testing | ← Input | Provides safety net for refactoring |
| code-explanation | ← Input | Understanding code before refactoring |
| code-editing | ↔ Bidirectional | Small refactors during editing vs dedicated refactoring |
| debugging | ↔ Bidirectional | Refactoring may reveal bugs; debugging may lead to refactoring |
| code-generation | → Output | Generate refactored code |
| verification | → Output | Verify behavior unchanged |
| documentation | → Output | Update docs after refactoring |

## Output Format Templates

### Standard Template
```
## Refactoring Summary

### Code Smells Identified
1. [Smell]: [Location] — [Description]
2. [Smell]: [Location] — [Description]

### Refactoring Applied
1. [Technique]: [What changed and why]

### Before
[Original code]

### After
[Refactored code]

### Behavior Verification
- [ ] All tests pass
- [ ] Behavior identical
- [ ] No performance regression
- [ ] API compatible

### Files Changed
- [file1]: [what changed]
- [file2]: [what changed]
```

### Quick Template
```
## Quick Refactoring

**Smell**: [What was wrong]
**Fix**: [What was done]
**Verified**: [ ] Tests pass
```

### Deep Template
```
## Comprehensive Refactoring Report

### Analysis
[Code smells identified with metrics]

### Refactoring Plan
[Step-by-step plan with incremental commits]

### SOLID Compliance
[How the refactoring improves SOLID adherence]

### Before/After Metrics
- Lines of code: [before] → [after]
- Cyclomatic complexity: [before] → [after]
- Test coverage: [before] → [after]

### Detailed Changes
[File-by-file diff with explanation]

### Risk Assessment
- Backward compatibility: [low/medium/high risk]
- Performance impact: [none/minor/significant]
- Test impact: [tests added/modified]

### Follow-up Recommendations
- [ ] [Additional refactoring opportunity]
- [ ] [Technical debt to address]
```

### Agent-Specific Template
```
## Agent Refactoring Report

### Task
[What was requested]

### Smells Found
1. [Smell] at [location]

### Changes Made
1. [Technique] on [location]: [what changed]

### Status
[ ] All tests pass
[ ] Behavior verified
[ ] No regressions

### Notes
[Any assumptions or follow-up items]
```

## Rules

1. **ALWAYS** have tests before refactoring
2. **ALWAYS** verify behavior unchanged after refactoring
3. **ALWAYS** make small incremental changes
4. **ALWAYS** commit after each successful step
5. **ALWAYS** run tests after each change
6. **NEVER** refactor and add features simultaneously
7. **NEVER** refactor code you don't understand
8. **NEVER** skip verification
9. **NEVER** refactor without a safety net (tests or characterization tests)
10. **NEVER** change public API without approval
11. **ONE** refactoring technique per step
12. **REVERT** immediately if tests fail
13. **PREFER** simple refactorings over complex ones
14. **AVOID** speculative generality — don't abstract prematurely
15. **PROFILE** before optimizing performance

## Verification

- [ ] All tests pass before AND after
- [ ] Behavior is identical
- [ ] Code is more readable
- [ ] No new code smells introduced
- [ ] API compatibility maintained
- [ ] No performance regression
- [ ] Documentation updated
- [ ] No circular dependencies introduced

## Failure Handling

- If tests fail after refactoring → Revert immediately, reassess approach
- If no tests exist → Write characterization tests first
- If refactoring is too complex → Break into smaller steps
- If API compatibility at risk → Document changes, notify users
- If performance regresses → Profile, identify bottleneck, optimize or revert

## Safety Constraints

- Do NOT refactor without tests
- Do NOT change public API without approval
- Do NOT refactor and fix bugs in same change
- Do NOT refactor code you don't understand
- Do NOT make large refactoring changes in one commit
- Do NOT refactor code you can't test
- Do NOT skip git commits between refactoring steps

## Anti-Patterns

- ❌ Refactoring without tests
- ❌ Refactoring and adding features together
- ❌ Changing more than necessary
- ❌ "Improving" code that works fine
- ❌ Refactoring for the sake of refactoring
- ❌ Over-abstracting single-use patterns
- ❌ Premature optimization without profiling
- ❌ Large-scale refactoring in one commit
- ❌ Ignoring API compatibility
- ❌ Refactoring without version control backup

## Skill Interactions

- ← code-review: Identifies what to refactor
- ← testing: Provides safety net
- ← code-explanation: Understanding code before refactoring
- → verification: Verify behavior unchanged
- → code-review: Review refactored code
- → documentation: Update docs after refactoring
- ↔ debugging: Refactoring may reveal bugs; debugging may lead to refactoring
