---
name: refactor
description: >-
  Refactor, rewrite, and clean up code without changing its external behavior — improving readability, structure, performance, and maintainability. Use this skill when the user asks to refactor code, بازنویسی کد, clean up this code, improve code structure, reorganize this code, make this cleaner, simplify this code, reduce complexity, extract function, DRY this code, too many lines, this is messy, refactor this module, improve readability, reduce duplication, کد تمیزتر, ساده‌سازی کد, بهبود ساختار کد, حذف کد تکراری, بازنویسی و بهینه‌سازی, بهینه‌سازی کد, اصلاح ساختار, اصلاح کد.
---

# Refactor Skill — Comprehensive Code Improvement

## Overview

This skill restructures existing code to improve its internal quality while preserving its external behavior. Refactoring is not rewriting from scratch — it is a series of small, safe transformations that make code easier to read, modify, and extend.

This skill covers the full catalog of refactoring patterns (based on Martin Fowler's Refactoring and modern practice), safety procedures, performance refactoring, and incremental strategy for large codebases.

## When to Use This Skill

- User asks to refactor, clean up, or restructure code
- Code is hard to read or modify despite working correctly
- User mentions too much duplication, long functions, or messy code
- User wants better performance without changing behavior
- User asks to apply design patterns or SOLID principles to existing code
- User wants to reduce technical debt

---

## Refactoring Safety Checklist

Before refactoring, verify these safety conditions:

```
□ Source control: Is the code in a version-controlled repo? (Can we revert?)
□ Tests exist: Are there tests that verify current behavior? If not, consider writing characterization tests first.
□ CI/CD: Is there a test suite that runs on changes? If yes, run it before starting.
□ Understanding: Do you understand what the code does? (Not just what it should do.)
□ Scope: Is the refactoring bounded? (Know when to stop.)
□ Communication: Are you telling the user what you plan to change?
```

**If no tests exist**: Write characterization tests first — tests that capture the current behavior, even if that behavior seems wrong. This prevents accidental behavior changes during refactoring.

---

## Refactoring Workflow

### Step 1: Read and Understand

1. Read all relevant files using the Read tool.
2. Identify the language, framework, and project conventions.
3. Understand what the code does before changing anything.
4. If tests exist, read them to understand expected behavior.
5. Map the dependency graph: what calls this code, and what does this code call?

### Step 2: Identify Smells and Target Areas

Scan for common code smells (prioritized by impact):

| Priority | Smell | Impact | Action |
|----------|-------|--------|--------|
| 1 | **Duplicated logic** | High — bugs multiply | Extract to shared function/module |
| 2 | **Long methods** (>30 lines) | High — hard to understand | Extract sub-functions |
| 3 | **Deep nesting** (>3 levels) | High — hard to follow | Early returns, guard clauses |
| 4 | **God objects** | High — violates SRP | Split into focused classes |
| 5 | **Magic numbers/strings** | Medium — unclear intent | Extract to named constants |
| 6 | **Long parameter lists** | Medium — hard to call | Introduce parameter object |
| 7 | **Complex conditionals** | Medium — hard to test | Replace with polymorphism |
| 8 | **Primitive obsession** | Medium — lost type safety | Introduce value objects |
| 9 | **Feature envy** | Medium — wrong location | Move method closer to data |
| 10 | **Dead code** | Low — confusion | Remove unreachable code |

### Step 3: Plan the Refactoring

Before making any changes:

1. List the specific refactorings you will perform, in order.
2. Each refactoring should be small and independently safe.
3. Order matters: extract first, then rename, then restructure.
4. If the refactoring is large, break it into phases and confirm with the user before proceeding.

### Step 4: Apply Refactorings

Apply changes using the Edit tool. Follow these principles:

- **Preserve behavior** — every change must be behavior-preserving. If you need to change behavior, tell the user explicitly.
- **Small steps** — one logical change per edit when possible.
- **No new features** — do not add functionality the user didn't ask for.
- **Consistent style** — match the existing codebase conventions.
- **Run tests after each step** — if tests exist, verify they still pass.

### Step 5: Summarize Changes

---

## Complete Refactoring Pattern Catalog

### 1. Extract Function / Method

**When**: A code block does one distinct thing and has a descriptive name.

```python
# BEFORE
def process_order(order):
    # Validate order
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Negative total")
    # Apply discount
    if order.customer.is_premium:
        order.total *= 0.9
    # Apply tax
    order.total *= 1.08
    # Log
    print(f"Order {order.id} processed: ${order.total}")
    return order

# AFTER
def validate_order(order):
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Negative total")

def apply_discount(order):
    if order.customer.is_premium:
        order.total *= 0.9

def apply_tax(order):
    order.total *= 1.08

def process_order(order):
    validate_order(order)
    apply_discount(order)
    apply_tax(order)
    print(f"Order {order.id} processed: ${order.total}")
    return order
```

### 2. Extract Class

**When**: A class has two or more distinct responsibilities.

```python
# BEFORE
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def calculate_pay(self):
        return self.salary / 12

    def save_to_database(self):
        db.execute("INSERT INTO employees ...", self.name, self.salary)

    def generate_payslip(self):
        return f"Payslip for {self.name}: ${self.calculate_pay()}"

# AFTER
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def calculate_pay(self):
        return self.salary / 12

class EmployeeRepository:
    def save(self, employee):
        db.execute("INSERT INTO employees ...", employee.name, employee.salary)

class PayslipGenerator:
    def generate(self, employee):
        return f"Payslip for {employee.name}: ${employee.calculate_pay()}"
```

### 3. Replace Conditional with Polymorphism

**When**: A switch/if-elif chain selects behavior based on type.

```python
# BEFORE
class Bird:
    def move(self):
        if self.type == "eagle":
            return self.fly()
        elif self.type == "penguin":
            return self.walk()
        elif self.type == "parrot":
            return self.fly()  # Same as eagle

# AFTER
class Bird:
    def move(self):
        raise NotImplementedError

class Eagle(Bird):
    def move(self):
        return self.fly()

class Penguin(Bird):
    def move(self):
        return self.walk()

class Parrot(Bird):
    def move(self):
        return self.fly()
```

### 4. Introduce Parameter Object

**When**: Multiple methods pass the same group of parameters.

```python
# BEFORE
def create_event(title, start_date, end_date, location, organizer):
    ...

def validate_event(title, start_date, end_date, location, organizer):
    ...

# AFTER
from dataclasses import dataclass
from datetime import datetime

@dataclass
class EventDetails:
    title: str
    start_date: datetime
    end_date: datetime
    location: str
    organizer: str

def create_event(details: EventDetails):
    ...

def validate_event(details: EventDetails):
    ...
```

### 5. Move Method

**When**: A method uses more data from another class than its own.

```python
# BEFORE
class Order:
    def __init__(self, items, customer):
        self.items = items
        self.customer = customer

    def calculate_shipping(self):
        # Uses customer data more than order data
        weight = sum(item.weight for item in self.items)
        zone = self.customer.address.zone
        rate = ShippingRate.get_rate(zone, weight)
        return rate

# AFTER
class Order:
    def __init__(self, items, customer):
        self.items = items
        self.customer = customer

    def calculate_shipping(self):
        return self.customer.calculate_shipping_for(self.items)

class Customer:
    def calculate_shipping_for(self, items):
        weight = sum(item.weight for item in items)
        zone = self.address.zone
        return ShippingRate.get_rate(zone, weight)
```

### 6. Decompose Conditional

**When**: Complex conditionals obscure the logic.

```python
# BEFORE
if (date < SUMMER_START or date > SUMMER_END) and not customer.is_premium:
    charge = base_rate * winter_multiplier
else:
    charge = base_rate * summer_multiplier

# AFTER
def is_winter(date):
    return date < SUMMER_START or date > SUMMER_END

def get_seasonal_rate(date, customer):
    if is_winter(date) and not customer.is_premium:
        return base_rate * winter_multiplier
    return base_rate * summer_multiplier

charge = get_seasonal_rate(date, customer)
```

### 7. Replace Temp with Query

**When**: A local variable obscures the meaning of a value.

```python
# BEFORE
base_price = self.quantity * self.item_price
if base_price > 1000:
    discount = base_price * 0.05
else:
    discount = 0

# AFTER
def base_price(self):
    return self.quantity * self.item_price

def discount(self):
    if self.base_price() > 1000:
        return self.base_price() * 0.05
    return 0
```

### 8. Consolidate Duplicate Conditional Fragments

**When**: The same code appears in multiple branches of a conditional.

```python
# BEFORE
def calculate_total(order):
    if order.is_premium:
        total = sum(item.price for item in order.items)
        total *= 0.9  # Premium discount
        log("Premium discount applied")
    else:
        total = sum(item.price for item in order.items)
        log("Standard pricing")
    return total

# AFTER
def calculate_total(order):
    total = sum(item.price for item in order.items)
    if order.is_premium:
        total *= 0.9
        log("Premium discount applied")
    else:
        log("Standard pricing")
    return total
```

### 9. Replace Nested Conditionals with Guard Clauses

**When**: Deep nesting makes the main logic hard to see.

```python
# BEFORE
def get_shipping_cost(order):
    if order is not None:
        if order.items:
            if not order.is_cancelled:
                if order.weight <= 5:
                    return 10.0
                else:
                    return 20.0
            else:
                raise ValueError("Order is cancelled")
        else:
            raise ValueError("Empty order")
    else:
        raise ValueError("No order provided")

# AFTER
def get_shipping_cost(order):
    if order is None:
        raise ValueError("No order provided")
    if not order.items:
        raise ValueError("Empty order")
    if order.is_cancelled:
        raise ValueError("Order is cancelled")
    if order.weight <= 5:
        return 10.0
    return 20.0
```

### 10. Replace Magic Numbers with Named Constants

```python
# BEFORE
if len(password) < 8:
    raise ValueError("Too short")
if len(password) > 128:
    raise ValueError("Too long")

# AFTER
MIN_PASSWORD_LENGTH = 8
MAX_PASSWORD_LENGTH = 128

if len(password) < MIN_PASSWORD_LENGTH:
    raise ValueError("Too short")
if len(password) > MAX_PASSWORD_LENGTH:
    raise ValueError("Too long")
```

---

## Performance Refactoring Patterns

### 1. Cache Expensive Computations

```python
# BEFORE
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)  # O(2^n)

# AFTER
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)  # O(n)
```

### 2. Eliminate N+1 Queries

```python
# BEFORE
orders = Order.objects.all()  # 1 query
for order in orders:
    customer = Customer.objects.get(id=order.customer_id)  # N queries

# AFTER
orders = Order.objects.select_related('customer').all()  # 1 query with JOIN
for order in orders:
    customer = order.customer  # No additional query
```

### 3. Use Generators for Large Datasets

```python
# BEFORE — loads entire file into memory
def read_large_file(path):
    with open(path) as f:
        return [process(line) for line in f.readlines()]

# AFTER — processes line by line
def read_large_file(path):
    with open(path) as f:
        for line in f:
            yield process(line)
```

### 4. Optimize Data Structures

```python
# BEFORE — O(n) lookup
if item in large_list:  # List lookup
    ...

# AFTER — O(1) lookup
large_set = set(large_list)
if item in large_set:
    ...
```

---

## Incremental Refactoring Strategy

For large codebases, use an incremental approach:

### Phase 1: Low-Risk Quick Wins (1-2 hours)
- Rename confusing variables/functions
- Extract magic numbers to constants
- Remove dead code
- Add missing type hints (Python) or type annotations

### Phase 2: Structural Improvements (Half day)
- Extract long methods
- Introduce guard clauses to reduce nesting
- Consolidate duplicate code
- Split large files into modules

### Phase 3: Design Improvements (Multiple sessions)
- Extract classes from god objects
- Replace conditionals with polymorphism
- Introduce interfaces/abstractions
- Restructure module dependencies

### Phase 4: Architecture Improvements (With team approval)
- Split monolith modules
- Introduce event-driven patterns
- Restructure API boundaries
- Refactor database access layer

**Each phase should be independently committable and testable.**

---

## Refactoring Debt Assessment

For teams managing technical debt, provide a debt assessment:

```
## Technical Debt Assessment

**File(s):** [files analyzed]
**Overall Debt Level:** Low / Medium / High / Critical

### Debt Items
1. [Smell name] — [location] — [impact] — [effort to fix]
   - Severity: [Critical/High/Medium/Low]
   - Risk if not addressed: [what happens]
   - Estimated effort: [hours/points]

### Recommended Payoff Order
1. [Highest impact, lowest effort first]
2. ...
3. ...

### Debt Trend
- [Is the code getting better or worse over time?]
```

---

## Output Format

```
## Refactoring Summary

**File(s):** [files modified]
**Refactorings Applied:**
1. [Refactoring name] — [brief description of what changed and why]
2. ...

### Before (key example)
```lang
// original problematic code
```

### After (key example)
```lang
// refactored code
```

### Impact
- Lines changed: [approximate count]
- Behavior preserved: Yes/No (with explanation if No)
- Risk level: Low/Medium/High
```

## Rules

- Never change behavior unless the user explicitly asks for it. If a refactoring incidentally fixes a bug, point it out separately.
- Do not add new tests (that's the test-generation skill). If existing tests need updating to match renamed symbols, update them.
- Do not add new dependencies or libraries.
- If the code is already clean, say so. Don't invent refactorings.
- If you're unsure whether a change is safe, present it as a suggestion rather than applying it.
- Present the summary in the user's language; keep code and technical terms in English.
- Always explain *why* a refactoring is beneficial, not just *what* changed.
