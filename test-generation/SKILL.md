---
name: test-generation
description: >-
  Generate unit tests, integration tests, and test suites for any codebase. Use this skill when the user asks to write tests, نوشتن تست, generate unit tests, test this code, add tests, create test cases, coverage, write test for this function, I need tests, test suite, integration tests, mocking tests, Jest tests, pytest, JUnit, mocha tests, تست نویسی, تست واحد, تست یکپارچه‌سازی, پوشش تست, نوشتن کیس تست, تست عملکردی, تست سلامت, تست ادغامی, تست بخشی, تست جامع, تست مقایسه‌ای.
---

# Test Generation Skill — Comprehensive Test Engineering

## Overview

This skill generates practical, high-quality tests that provide real value. Good tests catch regressions, document expected behavior, and give developers confidence to change code. The focus is on tests that are readable, maintainable, and that test meaningful behavior — not just achieve high coverage numbers.

This skill covers unit tests, integration tests, property-based testing, snapshot testing, contract testing, mutation testing, test data factories, and test architecture patterns across all major languages.

## When to Use This Skill

- User asks to write tests, add tests, or generate test cases
- User mentions unit tests, integration tests, or test coverage
- User shares a function/module and asks to "test this"
- User wants to verify existing code works correctly
- User needs a test suite for a new or existing project
- User asks about testing strategy or test architecture

---

## The Test Pyramid

Guide test distribution using the test pyramid:

```
        /  E2E  \          ← Few, slow, expensive (UI flows, full system)
       /----------\
      / Integration \      ← Moderate, test module interactions
     /----------------\
    /    Unit Tests     \   ← Many, fast, cheap (individual functions)
   /____________________\
```

**Recommended distribution**:
- **Unit tests**: 70-80% — Fast, isolated, test individual functions/methods
- **Integration tests**: 15-20% — Test module interactions, database queries, API calls
- **End-to-end tests**: 5-10% — Test complete user flows, full system behavior

**Why this matters**: Unit tests are cheap to write and fast to run. E2E tests are expensive and brittle. Most bugs are caught at the unit level; E2E tests verify the system works as a whole.

---

## Test Generation Workflow

### Step 1: Analyze the Code Under Test

1. Read the source file(s) using the Read tool.
2. Identify the language, framework, and existing test infrastructure.
3. Look for existing test files to match conventions (file naming, directory structure, test framework, assertion style).
4. Understand the function/module's public API — parameters, return values, side effects, error cases.
5. Identify dependencies that need mocking (databases, APIs, file system, time, randomness).

### Step 2: Detect the Testing Stack

Look for existing test configuration and dependencies:

| Language | Common Test Frameworks | Assertion Libraries |
|----------|----------------------|---------------------|
| JavaScript/TypeScript | Jest, Vitest, Mocha, Node Test Runner | expect, chai, assert |
| Python | pytest, unittest | assert, pytest.raises, Hamcrest |
| Go | testing (stdlib) | testify, gomega |
| Java | JUnit 5, TestNG | AssertJ, Hamcrest, Mockito |
| Rust | #[test] (built-in) | assert_eq!, assert!, pretty_assertions |
| C# | xUnit, NUnit, MSTest | FluentAssertions, Shouldly |
| Ruby | RSpec, Minitest | expect, assert |

If no test framework is installed, prefer the most common one for the language. Check `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, or similar for clues.

### Step 3: Design Test Cases

For each function/module, identify test cases covering:

1. **Happy path** — normal inputs produce correct outputs
2. **Edge cases** — empty inputs, zero, negative numbers, max values, boundary conditions
3. **Error cases** — invalid inputs, expected exceptions, error return values
4. **Type variations** — if the function accepts multiple types, test each
5. **Stateful behavior** — if the function modifies state, verify before/after
6. **Async behavior** — if async, test both resolve and reject paths
7. **Idempotency** — if an operation should be idempotent, call it twice and verify
8. **Concurrency** — if shared state is involved, test concurrent access

### Step 4: Write the Tests

Apply these principles when writing:

- **Descriptive names**: test names should describe the scenario and expected result
- **Arrange-Act-Assert**: structure each test with clear setup, execution, and verification
- **No test interdependence**: each test must run in isolation
- **Mock external dependencies**: use mocks/stubs for databases, APIs, file system, network
- **Keep tests focused**: one logical assertion per test; split if testing multiple behaviors
- **Avoid brittle tests**: don't test implementation details, test observable behavior
- **Test behavior, not implementation**: test what the code does, not how it does it

### Step 5: Write to File

1. Place the test file following the project's convention.
2. Include necessary imports and setup/teardown if needed.
3. Use the Write tool to create the test file.

---

## Test Patterns & Techniques

### Pattern 1: Parameterized / Table-Driven Tests

Test multiple input-output pairs with a single test structure:

```python
# Python — pytest parametrize
import pytest

@pytest.mark.parametrize("input_val, expected", [
    ("hello", "HELLO"),
    ("", ""),
    ("Hello World", "HELLO WORLD"),
    ("123abc", "123ABC"),
    ("already.upper", "ALREADY.UPPER"),
])
def test_to_uppercase(input_val, expected):
    assert to_uppercase(input_val) == expected
```

```javascript
// JavaScript — Jest
describe('toUppercase', () => {
  test.each([
    ['hello', 'HELLO'],
    ['', ''],
    ['Hello World', 'HELLO WORLD'],
    ['123abc', '123ABC'],
  ])('converts %s to %s', (input, expected) => {
    expect(toUppercase(input)).toBe(expected);
  });
});
```

```go
// Go — table-driven tests
func TestToUppercase(t *testing.T) {
    tests := []struct {
        input    string
        expected string
    }{
        {"hello", "HELLO"},
        {"", ""},
        {"Hello World", "HELLO WORLD"},
        {"123abc", "123ABC"},
    }
    for _, tt := range tests {
        t.Run(tt.input, func(t *testing.T) {
            result := ToUppercase(tt.input)
            if result != tt.expected {
                t.Errorf("ToUppercase(%q) = %q, want %q", tt.input, result, tt.expected)
            }
        })
    }
}
```

### Pattern 2: Arrange-Act-Assert (AAA) with Setup/Teardown

```python
import pytest

@pytest.fixture
def sample_user():
    """Fixture that creates a test user."""
    user = User(name="Alice", email="alice@test.com")
    yield user
    # Teardown: clean up
    user.delete()

def test_user_greeting(sample_user):
    # Arrange
    expected = "Hello, Alice!"

    # Act
    result = sample_user.greet()

    # Assert
    assert result == expected
```

### Pattern 3: Mocking Patterns

#### Python — unittest.mock

```python
from unittest.mock import Mock, patch, MagicMock

# Mock a function
@patch('my_module.external_api_call')
def test_with_mocked_api(mock_api):
    mock_api.return_value = {"status": "ok"}
    result = my_function()
    assert result.success is True
    mock_api.assert_called_once()

# Mock a class method
@patch.object(Database, 'connect')
def test_database_failure(mock_connect):
    mock_connect.side_effect = ConnectionError("DB down")
    with pytest.raises(ServiceUnavailable):
        process_request()
```

#### JavaScript — Jest mocking

```javascript
// Mock entire module
jest.mock('./database', () => ({
  query: jest.fn(),
}));

// Mock specific function
const mockFetch = jest.fn();
jest.mock('node-fetch', () => mockFetch);

describe('fetchUserData', () => {
  beforeEach(() => {
    mockFetch.mockClear();
  });

  test('returns user data on success', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ name: 'Alice' }),
    });

    const user = await fetchUserData(123);
    expect(user.name).toBe('Alice');
    expect(mockFetch).toHaveBeenCalledWith('/api/users/123');
  });

  test('throws on network error', async () => {
    mockFetch.mockRejectedValue(new Error('Network error'));
    await expect(fetchUserData(123)).rejects.toThrow('Network error');
  });
});
```

#### Rust — Mockall / Manual mocking

```rust
// Using trait-based mocking
trait Database {
    fn query(&self, sql: &str) -> Result<Vec<Row>, Error>;
}

struct MockDatabase {
    results: Vec<Row>,
}

impl Database for MockDatabase {
    fn query(&self, _sql: &str) -> Result<Vec<Row>, Error> {
        Ok(self.results.clone())
    }
}

#[test]
fn test_with_mock_database() {
    let db = MockDatabase { results: vec![Row::new("test")] };
    let service = UserService::new(Box::new(db));
    let user = service.find_user(1).unwrap();
    assert_eq!(user.name, "test");
}
```

#### Go — Interface-based mocking

```go
// Define interface
type UserRepository interface {
    FindByID(id int) (*User, error)
}

// Mock implementation
type MockUserRepository struct {
    Users map[int]*User
    Err   error
}

func (m *MockUserRepository) FindByID(id int) (*User, error) {
    if m.Err != nil {
        return nil, m.Err
    }
    return m.Users[id], nil
}

func TestGetUser(t *testing.T) {
    mock := &MockUserRepository{
        Users: map[int]*User{1: {Name: "Alice"}},
    }
    service := UserService{Repo: mock}
    user, err := service.GetUser(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", user.Name)
}
```

### Pattern 4: Property-Based Testing

Test that properties hold for ALL inputs, not just specific examples:

```python
# Python — Hypothesis
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_sort_preserves_length(lst):
    assert len(sorted(lst)) == len(lst)

@given(st.lists(st.integers()))
def test_sort_is_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)

@given(st.lists(st.integers()))
def test_sort_preserves_elements(lst):
    from collections import Counter
    assert Counter(sorted(lst)) == Counter(lst)
```

```javascript
// JavaScript — fast-check
const fc = require('fast-check');

describe('sort', () => {
  test('preserves length', () => {
    fc.assert(
      fc.property(fc.array(fc.integer()), (arr) => {
        expect([...arr].sort((a, b) => a - b)).toHaveLength(arr.length);
      })
    );
  });

  test('result is ordered', () => {
    fc.assert(
      fc.property(fc.array(fc.integer()), (arr) => {
        const sorted = [...arr].sort((a, b) => a - b);
        for (let i = 1; i < sorted.length; i++) {
          expect(sorted[i]).toBeGreaterThanOrEqual(sorted[i - 1]);
        }
      })
    );
  });
});
```

### Pattern 5: Snapshot Testing

Capture output and compare against a baseline:

```javascript
// JavaScript — Jest
test('renders correctly', () => {
  const tree = renderer.create(<Button label="Submit" />).toJSON();
  expect(tree).toMatchSnapshot();
});

test('renders with custom props', () => {
  const tree = renderer.create(
    <Button label="Cancel" variant="danger" disabled />
  ).toJSON();
  expect(tree).toMatchSnapshot();
});
```

### Pattern 6: Contract Testing

Verify that implementations satisfy a shared interface:

```python
# Contract: defines what a storage backend must do
class StorageContract:
    """Mixin that tests any storage implementation."""

    def create_storage(self):
        raise NotImplementedError

    def test_set_and_get(self):
        storage = self.create_storage()
        storage.set("key1", "value1")
        assert storage.get("key1") == "value1"

    def test_get_nonexistent_returns_none(self):
        storage = self.create_storage()
        assert storage.get("nonexistent") is None

    def test_delete_removes_key(self):
        storage = self.create_storage()
        storage.set("key1", "value1")
        storage.delete("key1")
        assert storage.get("key1") is None

# Concrete test for Redis backend
class TestRedisStorage(StorageContract, unittest.TestCase):
    def create_storage(self):
        return RedisStorage(host="localhost")
```

### Pattern 7: Test Data Factories

Generate realistic test data instead of hardcoded values:

```python
# Python — factory_boy style
import factory
from myapp.models import User, Order

class UserFactory(factory.Factory):
    class Meta:
        model = User

    name = factory.Faker('name')
    email = factory.Faker('email')
    is_active = True

class OrderFactory(factory.Factory):
    class Meta:
        model = Order

    user = factory.SubFactory(UserFactory)
    total = factory.Faker('pydecimal', left_digits=4, right_digits=2, positive=True)
    items = factory.LazyFunction(lambda: [ItemFactory() for _ in range(3)])

# Usage in tests
def test_order_total():
    order = OrderFactory(total=100.00)
    assert order.calculate_tax() == 8.00
```

```javascript
// JavaScript — simple factory
const UserFactory = {
  build: (overrides = {}) => ({
    id: Math.random().toString(36).substr(2, 9),
    name: 'Test User',
    email: 'test@example.com',
    createdAt: new Date(),
    ...overrides,
  }),

  create: (overrides = {}) => {
    const user = UserFactory.build(overrides);
    database.users.push(user);
    return user;
  },
};

// Usage
test('user greeting', () => {
  const user = UserFactory.build({ name: 'Alice' });
  expect(user.greet()).toBe('Hello, Alice!');
});
```

---

## Test Coverage Analysis Patterns

### What to Measure

```
Line coverage:    % of source code lines executed by tests
Branch coverage:  % of if/else/switch branches taken
Function coverage: % of functions/methods called by tests
Mutation coverage: % of code mutations that tests catch
```

### Coverage Strategy

```
100% coverage ≠ bug-free code. Focus on:
  □ Critical business logic: 100% branch coverage
  □ Error handling paths: test every catch/except block
  □ Edge cases: empty, null, boundary values
  □ Integration points: test API contracts
  □ Skip: auto-generated code, trivial getters/setters, config files
```

### Coverage Report Interpretation

```python
# Python — pytest-cov
# Run: pytest --cov=myapp --cov-report=html
# Look at HTML report for:
# - Uncovered lines in critical functions → write tests for these
# - Well-covered functions with no tests → may need fewer tests
# - Branches never taken → write tests for the missing path
```

---

## Integration Test Patterns

### Database Integration Tests

```python
# Python — pytest with database
@pytest.fixture
def db_session():
    """Create a test database session that rolls back after each test."""
    engine = create_engine("sqlite:///:memory:")
    Session = sessionmaker(bind=engine)
    session = Session()
    Base.metadata.create_all(engine)
    yield session
    session.rollback()
    session.close()

def test_user_creation(db_session):
    user = User(name="Alice", email="alice@test.com")
    db_session.add(user)
    db_session.commit()

    result = db_session.query(User).filter_by(name="Alice").first()
    assert result is not None
    assert result.email == "alice@test.com"
```

### API Integration Tests

```javascript
// JavaScript — Supertest with Express
const request = require('supertest');
const app = require('../app');

describe('POST /api/users', () => {
  test('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Alice', email: 'alice@test.com' })
      .expect(201);

    expect(response.body).toMatchObject({
      name: 'Alice',
      email: 'alice@test.com',
      id: expect.any(String),
    });
  });

  test('returns 400 for invalid email', async () => {
    await request(app)
      .post('/api/users')
      .send({ name: 'Alice', email: 'not-an-email' })
      .expect(400);
  });
});
```

### Message Queue Integration Tests

```go
// Go — testing with message broker
func TestPublishAndConsume(t *testing.T) {
    broker := NewTestBroker(t) // Uses testcontainers
    defer broker.Cleanup()

    publisher := NewEventPublisher(broker)
    consumer := NewEventHandler(broker)

    // Publish event
    err := publisher.Publish(UserCreated{UserID: 123})
    require.NoError(t, err)

    // Consume and verify
    event, err := consumer.Receive(ctx, 5*time.Second)
    require.NoError(t, err)
    assert.Equal(t, 123, event.UserID)
}
```

---

## Language-Specific Test Examples

### Rust

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_valid_input() {
        let result = parse("hello,42");
        assert!(result.is_ok());
        assert_eq!(result.unwrap(), Parsed { name: "hello", value: 42 });
    }

    #[test]
    fn test_parse_empty_string() {
        let result = parse("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), ParseError::EmptyInput);
    }

    #[test]
    #[should_panic(expected = "division by zero")]
    fn test_divide_by_zero_panics() {
        divide(10, 0);
    }

    // Property-based with proptest
    proptest! {
        #[test]
        fn test_parse_roundtrip(name in "[a-z]+", value in 0i32..1000) {
            let input = format!("{},{}", name, value);
            let parsed = parse(&input).unwrap();
            assert_eq!(parsed.name, name);
            assert_eq!(parsed.value, value);
        }
    }
}
```

### Go

```go
func TestCalculateDiscount(t *testing.T) {
    tests := []struct {
        name     string
        total    float64
        isVIP    bool
        expected float64
    }{
        {"no discount under threshold", 50.0, false, 50.0},
        {"10% discount for regular over threshold", 150.0, false, 135.0},
        {"20% discount for VIP", 150.0, true, 120.0},
        {"zero total", 0.0, false, 0.0},
        {"negative total returns zero", -10.0, false, 0.0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := CalculateDiscount(tt.total, tt.isVIP)
            if result != tt.expected {
                t.Errorf("got %v, want %v", result, tt.expected)
            }
        })
    }
}
```

### Java

```java
@DisplayName("Calculator Tests")
class CalculatorTest {

    @Test
    @DisplayName("should add two positive numbers")
    void shouldAddTwoPositiveNumbers() {
        Calculator calc = new Calculator();
        assertEquals(5, calc.add(2, 3));
    }

    @Test
    @DisplayName("should throw exception for division by zero")
    void shouldThrowForDivisionByZero() {
        Calculator calc = new Calculator();
        assertThrows(ArithmeticException.class, () -> calc.divide(10, 0));
    }

    @ParameterizedTest
    @CsvSource({"1,1,2", "0,0,0", "-1,1,0", "100,200,300"})
    @DisplayName("should add various number pairs")
    void shouldAddVariousPairs(int a, int b, int expected) {
        assertEquals(expected, new Calculator().add(a, b));
    }
}
```

---

## Output Format

```
## Test Generation Summary

**Source file(s):** [files tested]
**Test file created:** [path to new test file]
**Framework:** [detected or chosen framework]
**Test cases generated:** [count]

### Test Coverage Map
- [Function A]: 3 test cases (happy path, edge case, error case)
- [Function B]: 2 test cases (...)
- [Property-based]: 2 properties tested with automatic input generation

### Test Design Decisions
- [Why certain frameworks/libraries were chosen]
- [What was mocked and why]
- [What edge cases were prioritized]

### Notes
- [Any assumptions made, external dependencies that need mocking, etc.]
```

## Rules

- Read the source code before writing any tests. Never guess at function signatures.
- Match the project's existing test style and conventions.
- Do not install packages or modify configuration files unless the user asks.
- If a function is trivially simple (e.g., a getter), skip it and focus on non-trivial logic.
- If the user specifies a framework, use it. Otherwise, detect from the project.
- Generate meaningful test data, not random strings or magic numbers without context.
- Present the summary in the user's language; keep code and technical terms in English.
- Tests should be readable by a developer unfamiliar with the test framework.
- Prefer testing behavior over implementation details to reduce brittleness.
