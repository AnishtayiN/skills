---
name: testing
description: >-
  Create, run, and manage tests: unit, integration, E2E, regression, performance.
  TRIGGERS: test, testing, write tests, unit test, integration test, e2e, test coverage,
  mock, assertion, test suite, regression test, smoke test, test failure, flaky test,
  تست, تست بنویس, تست واحد, تست یکپارچه, پوشش تست, شکست تست, mock,
  写测试, 单元测试, 集成测试, 测试覆盖率, 模拟, 断言
priority: P1
dependencies: [project-analysis, code-review]
conflicts: []
---

# Testing Skill

## Purpose

Create, run, and maintain tests across all levels of the test pyramid. Ensure code correctness through automated verification using unit tests, integration tests, and end-to-end tests with proper mocking strategies, property-based testing, mutation testing, and coverage analysis.

## When to Activate

- User asks to write tests
- Test coverage is low
- After code generation (add tests)
- After bug fix (add regression test)
- Before deployment (verify test suite)
- Test is failing
- User asks about test strategy
- تست بنویس (write tests), تست واحد (unit test)
- 写测试, 单元测试

## When NOT to Activate

- User wants to write production code (→ code-generation)
- No code to test
- User explicitly says skip tests

## Inputs Required

- Code to test
- Test framework (auto-detect from project)
- Type of test needed
- Target coverage percentage (if specified)

## Preconditions

- Code exists and is testable

---

## Workflow

### Step 1: Detect Test Framework

```
Look for:
├── package.json → jest, vitest, mocha, jasmine
├── pyproject.toml → pytest
├── go.mod → testing package
├── Cargo.toml → cargo test
├── pom.xml → JUnit
├── jest.config.*, vitest.config.*
└── Auto-detect from dependencies
```

### Step 2: Determine Test Type (Test Pyramid)

```
                    ╱╲
                   ╱  ╲         E2E Tests (Few)
                  ╱    ╲        - User workflows
                 ╱──────╲       - Full system
                ╱        ╲      - Slow, expensive
               ╱          ╲
              ╱────────────╲    Integration Tests (Some)
             ╱              ╲   - Module interactions
            ╱                ╲  - API + Database
           ╱──────────────────╲ - Medium speed/cost
          ╱                    ╲
         ╱──────────────────────╲ Unit Tests (Many)
        ╱                        ╲ - Individual functions
       ╱                          ╲- Fast, cheap
      ╱────────────────────────────╲- Mock external deps
```

**Test Type Selection**:
```
What to test?
├── Single function/method → Unit test
├── Module interaction → Integration test
├── User flow / journey → E2E test
├── Bug fix → Regression test
├── Performance → Benchmark test
├── Security → Security test
├── API contract → Contract test
└── Not sure → Start with unit tests (bottom of pyramid)
```

### Step 3: Write Tests

```
For each test case:
1. Arrange — Set up test data, mocks, fixtures
2. Act — Call the function/method under test
3. Assert — Verify the result

Test cases to include:
- Happy path (normal behavior)
- Edge cases (empty, null, boundary values)
- Error cases (invalid input, exceptions)
- Integration points (external dependencies)
- State transitions (if stateful)
```

### Step 4: Run Tests

```
1. Run the full test suite
2. Check for failures
3. Check coverage report
4. Fix any issues
5. Re-run to verify fixes
```

---

## Test Patterns (5 Patterns with Code Examples)

### Pattern 1: Data-Driven / Parameterized Tests
```python
import pytest

@pytest.mark.parametrize("input,expected", [
    (0, 0),
    (1, 1),
    (5, 120),
    (-1, -1),
    (10, 3628800),
])
def test_factorial(input, expected):
    assert factorial(input) == expected
```

### Pattern 2: Factory Pattern for Test Data
```python
class UserFactory:
    _counter = 0

    @classmethod
    def create(cls, **overrides):
        cls._counter += 1
        defaults = {
            "name": f"User_{cls._counter}",
            "email": f"user_{cls._counter}@test.com",
            "role": "member",
            "active": True,
        }
        defaults.update(overrides)
        return User(**defaults)

    @classmethod
    def create_batch(cls, count, **overrides):
        return [cls.create(**overrides) for _ in range(count)]

# Usage
def test_user_registration():
    user = UserFactory.create(role="admin")
    assert user.role == "admin"

def test_batch_creation():
    users = UserFactory.create_batch(10, active=False)
    assert len(users) == 10
    assert all(not u.active for u in users)
```

### Pattern 3: Mock Strategies
```python
# Strategy 1: Function mocking (monkeypatch)
def test_external_api(monkeypatch):
    def mock_response(*args, **kwargs):
        return {"status": 200, "data": {"id": 1}}
    monkeypatch.setattr("requests.get", mock_response)
    result = fetch_user(1)
    assert result["id"] == 1

# Strategy 2: Class mocking
from unittest.mock import MagicMock, patch

@patch("services.payment.StripeClient")
def test_charge_card(mock_stripe):
    mock_stripe.return_value.charges.create.return_value = {"id": "ch_123"}
    result = charge_card({"amount": 100})
    mock_stripe.return_value.charges.create.assert_called_once()

# Strategy 3: Mock external filesystem
def test_file_processing(tmp_path):
    test_file = tmp_path / "input.txt"
    test_file.write_text("test data")
    result = process_file(str(test_file))
    assert result == "processed"
```

### Pattern 4: Snapshot Testing
```python
# JavaScript (Jest/Vitest)
test("component renders correctly", () => {
  const tree = render(<UserProfile user={mockUser} />);
  expect(tree).toMatchSnapshot();
});

# Python (syrupy)
def test_api_response_snapshot(snapshot):
    response = get_user(1)
    snapshot.assert_match(response.json(), "user_response")
```

### Pattern 5: Property-Based Testing
```python
from hypothesis import given, strategies as st

# Test that reversal is an involution
@given(st.lists(st.integers()))
def test_reverse_twice_is_identity(lst):
    assert reverse(reverse(lst)) == lst

# Test that sort produces sorted output
@given(st.lists(st.integers()))
def test_sort_is_sorted(lst):
    result = my_sort(lst)
    assert result == sorted(result)

# Test that length of reversed list equals original
@given(st.lists(st.integers()))
def test_reverse_preserves_length(lst):
    assert len(reverse(lst)) == len(lst)
```

---

## Mocking Strategies (Detailed)

### When to Mock vs. When to Use Real Dependencies

```
Decision Matrix:
├── Unit Test → Mock everything external (DB, network, filesystem)
├── Integration Test → Use real DB (testcontainers), mock network
├── Contract Test → Mock provider, verify consumer expectations
├── E2E Test → Use real everything (test environment)
└── Performance Test → Use production-like real dependencies

What to Mock:
├── ✅ Network calls (HTTP, gRPC)
├── ✅ Filesystem operations
├── ✅ Time-dependent functions (Date.now())
├── ✅ Random number generators
├── ✅ Email/SMS services
├── ✅ Payment gateways
└── ✅ Third-party APIs

What NOT to Mock:
├── ❌ Value objects / pure functions
├── ❌ Data access in integration tests
├── ❌ Your own modules (test the real thing)
└── ❌ Simple DTOs / models
```

---

## Property-Based Testing (Deep Dive)

Property-based testing generates random inputs and verifies invariants hold for all of them.

```
Key Properties to Test:
├── Round-trip: encode(decode(x)) == x
├── Idempotence: f(f(x)) == f(x)
├── Commutativity: f(a, b) == f(b, a)
├── Associativity: f(f(a, b), c) == f(a, f(b, c))
├── Inverse: f(inverse(f(x))) == x
├── Preservation: f(x) preserves some invariant
└── Shrinking: Failures are minimized for debugging
```

**When to use property-based testing**:
- Parsing / serialization
- Sorting algorithms
- Encryption / decryption
- Data transformations
- Mathematical operations
- Any pure function with clear invariants

---

## Snapshot Testing (Deep Dive)

### When Snapshot Testing Is Appropriate
- UI component output (HTML, React components)
- API response structures
- Configuration file output
- Generated code or reports

### When to Avoid Snapshot Testing
- Tests that change frequently (flaky snapshots)
- Tests where diff is hard to interpret
- Logic-heavy tests (use assertion-based instead)

---

## Mutation Testing (Deep Dive)

Mutation testing verifies test quality by introducing small code changes (mutants) and checking if tests catch them.

```
Mutation Types:
├── Condition boundary: < → <=, > → >=
├── Return value: return True → return False
├── Arithmetic: + → -, * → /
├── Negation: !condition → condition
└── Deletion: Remove a statement

Mutation Score = Killed Mutants / Total Mutants
├── > 80%: Excellent test suite
├── 60-80%: Good, room for improvement
├── 40-60%: Weak, needs more tests
└── < 40%: Poor, tests miss many defects
```

**Tools**: mutmut (Python), Stryker (JS/TS), pi-test (Java)

---

## Test Coverage Analysis

### Coverage Levels
```
├── Statement Coverage — Which lines executed?
├── Branch Coverage — Which branches taken?
├── Function Coverage — Which functions called?
├── Line Coverage — Which lines executed?
└── Condition Coverage — Which conditions evaluated?

Coverage Targets:
├── Critical code (payments, auth): 95%+ branch coverage
├── Business logic: 80%+ branch coverage
├── Utility functions: 90%+ statement coverage
└── Overall project: 75%+ line coverage
```

### Coverage Report Interpretation
```
File              Stmts   Miss   Branch   BrMiss
─────────────────────────────────────────────────
services/auth.py    100     12     85%       8
api/routes.py        80      5     90%       3
utils/helpers.py     45      0    100%       0
─────────────────────────────────────────────────
TOTAL               225     17     88%      11

Focus on: auth.py (12 missed statements = potential bugs)
```

---

## Fixture Management

### pytest Fixtures
```python
@pytest.fixture
def database():
    db = create_test_database()
    yield db
    db.teardown()

@pytest.fixture
def sample_user(database):
    user = User(name="Test", email="test@example.com")
    database.add(user)
    return user

@pytest.fixture(autouse=True)
def reset_state():
    """Runs before every test automatically."""
    yield
    clear_global_state()
```

### Jest/Vitest Fixtures
```javascript
beforeEach(() => {
  jest.clearAllMocks();
  resetDatabase();
});

afterAll(async () => {
  await cleanupTestDatabase();
});
```

---

## Test Data Factories

```python
# Factory Boy (Python)
import factory

class UserFactory(factory.Factory):
    class Meta:
        model = User

    name = factory.Faker("name")
    email = factory.Faker("email")
    role = factory.LazyAttribute(lambda o: "admin" if o.is_admin else "member")
    created_at = factory.LazyFunction(datetime.now)

# Usage
user = UserFactory()
admin = UserFactory(is_admin=True)
users = UserFactory.create_batch(10)
```

---

## Common Patterns (5 Patterns with Code Examples)

### Pattern 1: Given-When-Then (BDD Style)
```python
def test_user_login_success():
    # Given — preconditions
    user = UserFactory.create(email="alice@example.com", password="hashed_secret")
    login_request = {"email": "alice@example.com", "password": "secret"}

    # When — action under test
    result = auth_service.login(login_request)

    # Then — expected outcome
    assert result.success is True
    assert result.token is not None
    assert result.user_id == user.id

def test_user_login_wrong_password():
    # Given
    UserFactory.create(email="alice@example.com", password="hashed_secret")
    login_request = {"email": "alice@example.com", "password": "wrong"}

    # When
    result = auth_service.login(login_request)

    # Then
    assert result.success is False
    assert result.error == "Invalid credentials"
```

### Pattern 2: Test Doubles Hierarchy
```python
# Dummy — passed around, never used
class DummyUser:
    pass

# Stub — returns hardcoded values
class StubUserRepository:
    def find(self, id):
        return User(id=id, name="Stub User")

# Spy — records calls for later verification
class SpyUserRepository:
    def __init__(self):
        self.calls = []
    def find(self, id):
        self.calls.append(("find", id))
        return User(id=id, name="Spy User")

# Mock — pre-programmed with expectations
class MockEmailService:
    def __init__(self):
        self.sent = []
    def send(self, to, subject, body):
        self.sent.append({"to": to, "subject": subject})

# Fake — working implementation (simplified)
class InMemoryUserRepository:
    def __init__(self):
        self.users = {}
    def save(self, user):
        self.users[user.id] = user
    def find(self, id):
        return self.users.get(id)
```

### Pattern 3: Test Organization (File/Directory Structure)
```
tests/
├── unit/
│   ├── services/
│   │   ├── test_auth_service.py
│   │   └── test_payment_service.py
│   └── utils/
│       └── test_helpers.py
├── integration/
│   ├── test_user_api.py
│   └── test_database_operations.py
├── e2e/
│   ├── test_checkout_flow.py
│   └── test_user_registration.py
├── fixtures/
│   ├── users.json
│   └── orders.json
├── factories/
│   ├── user_factory.py
│   └── order_factory.py
└── conftest.py  # Shared pytest fixtures
```

### Pattern 4: Test Naming Convention
```python
# Pattern: test_<unit>_<scenario>_<expected_result>

# ✅ Good names
def test_calculate_discount_vip_customer_returns_20_percent():
    pass

def test_calculate_discount_regular_customer_returns_5_percent():
    pass

def test_calculate_discount_expired_coupon_raises_error():
    pass

def test_fetch_user_with_valid_id_returns_user():
    pass

def test_fetch_user_with_nonexistent_id_raises_not_found():
    pass

# ❌ Bad names
def test_discount():
    pass

def test_it_works():
    pass

def test_1():
    pass
```

### Pattern 5: Test Configuration and Environment
```python
# conftest.py — Shared pytest configuration
import pytest
from app import create_app
from database import Database

@pytest.fixture(scope="session")
def app():
    """Create application for entire test session."""
    app = create_app(config="testing")
    yield app

@pytest.fixture(scope="function")
def db(app):
    """Create fresh database for each test."""
    db = Database(app.config["DATABASE_URL"])
    db.create_tables()
    yield db
    db.drop_tables()

@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()

@pytest.fixture
def auth_headers(client):
    """Create authenticated request headers."""
    response = client.post("/auth/login", json={
        "email": "test@example.com",
        "password": "password"
    })
    token = response.json["token"]
    return {"Authorization": f"Bearer {token}"}
```

---

## Advanced Techniques (7 Techniques)

### 1. Test Isolation
Every test must be independent. No test should depend on another test's execution or state. Use fresh fixtures, clean database state, and isolated file systems.

### 2. Deterministic Test Data
Avoid time-dependent, random, or externally-dependent data. Use fixed seeds for random generators, mock time functions, and use factories for consistent data.

### 3. Fast Feedback Loops
Organize tests by speed. Unit tests run on every save. Integration tests run on commit. E2E tests run on PR. This gives developers fast feedback while still comprehensive coverage.

### 4. Test-Driven Development (TDD)
Red → Green → Refactor cycle:
1. Write a failing test (Red)
2. Write minimum code to pass (Green)
3. Refactor while keeping tests green

### 5. Contract Testing
For microservices, verify API contracts between services without running the full system. Consumer-driven contracts ensure API compatibility.

### 6. Chaos Testing
Inject failures intentionally. Kill processes, corrupt data, introduce latency. Verify the system degrades gracefully.

### 7. Regression Test Mining
When a bug is found, extract the minimal reproduction case and add it as a regression test. This ensures the exact same bug cannot recur.

---

## Edge Cases & Pitfalls (15 Items)

1. **Flaky tests**: Tests that pass/fail non-deterministically. Usually caused by timing, shared state, or external dependencies.
2. **Test pollution**: One test's state leaking into another via global variables, database, or filesystem.
3. **Over-mocking**: Mocking everything makes tests fragile and disconnected from reality.
4. **Testing implementation**: Tests that break when internal implementation changes but behavior is the same.
5. **Missing negative tests**: Only testing happy path, never testing error conditions.
6. **Assertion-free tests**: Tests that run code but never assert anything — always pass even when broken.
7. **Slow test suites**: >5 min test suites discourage frequent testing. Optimize by parallelizing and categorizing.
8. **Hard-coded test data**: URLs, emails, UUIDs hardcoded instead of using factories or generators.
9. **Test coupling**: Tests that must run in specific order — indicates shared mutable state.
10. **Ignoring test failures**: Skipping or xfail-ing tests without investigation creates technical debt.
11. **Not cleaning up**: Database records, temp files, or connections not cleaned up after tests.
12. **Wrong assertion method**: Using `assertEqual` where `assertIn` is appropriate, or vice versa.
13. **Missing edge cases**: Testing 0, 1, but not MAX_INT, empty string, unicode.
14. **Not testing error messages**: Error handling exists but the error message content is never verified.
15. **Coverage gaming**: Writing trivial tests to inflate coverage numbers without testing real behavior.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **code-review** | ← Depends on | Review identifies testing gaps |
| **verification** | → Feeds into | Tests verify correctness |
| **debugging** | → Feeds into | Test failures guide debugging |
| **refactoring** | ← Depends on | Refactoring needs test safety net |
| **code-generation** | ← Feeds into | Generated code needs tests |
| **performance** | → Feeds into | Performance tests / benchmarks |
| **documentation** | → Feeds into | Test results become documentation |

---

## Output Format Templates

### Template 1: Standard Test Report
```
## Test Report — [Module/Feature]

### Test Summary
| Metric | Value |
|--------|-------|
| Total Tests | 42 |
| Passed | 40 |
| Failed | 1 |
| Skipped | 1 |
| Duration | 3.2s |

### Coverage Report
| Metric | Coverage |
|--------|----------|
| Statements | 87% |
| Branches | 82% |
| Functions | 91% |
| Lines | 85% |

### Tests Created
| Test Name | Type | Status |
|-----------|------|--------|
| test_user_creation | unit | ✅ |
| test_user_validation | unit | ✅ |
| test_api_endpoint | integration | ✅ |

### Run Command
`pytest tests/ --cov=src --cov-report=html`
```

### Template 2: Quick Test Result
```
## Quick Test Result

**Suite**: unit tests | **Result**: ✅ PASS
**Tests**: 15 passed | **Time**: 0.8s
**Coverage**: 82% (statement)

Command: `npm test`
```

### Template 3: Deep Test Analysis
```
## Deep Test Analysis — [Module]

### Test Quality Assessment
| Dimension | Score | Notes |
|-----------|-------|-------|
| Coverage | 85% | Good, target 90% |
| Mutation Score | 72% | Acceptable |
| Test Speed | 2.1s | Good |
| Flaky Tests | 0 | Excellent |
| Edge Cases | ⚠️ | Missing null handling |

### Missing Test Scenarios
1. Null input handling
2. Concurrent access
3. Large dataset (10k+ items)
4. Network timeout behavior

### Recommendations
1. Add property-based tests for parser
2. Add integration test for DB operations
3. Increase branch coverage for auth module
```

### Template 4: Agent-Specific (Structured for Automation)
```json
{
  "test_summary": {
    "total": 42,
    "passed": 40,
    "failed": 1,
    "skipped": 1,
    "duration_ms": 3200
  },
  "coverage": {
    "statements": 87,
    "branches": 82,
    "functions": 91,
    "lines": 85
  },
  "failed_tests": [
    {"name": "test_payment", "error": "AssertionError", "file": "test_pay.py:42"}
  ],
  "mutation_score": 72,
  "recommendations": ["add edge case tests", "improve branch coverage"]
}
```

---

## Rules (12 Rules)

1. **Test behavior, not implementation** — Tests should survive refactoring.
2. **Each test tests ONE thing** — One assertion concept per test method.
3. **Tests must be independent** — No test depends on another test's state.
4. **Tests must be deterministic** — Same input always produces same result.
5. **Mock external dependencies** — Network, DB, filesystem should be mocked in unit tests.
6. **Test edge cases and errors** — Null, empty, boundary, max, min, error conditions.
7. **Clean up after tests** — Remove temp files, reset DB, clear global state.
8. **Name tests descriptively** — `test_user_with_empty_email_raises_validation_error` not `test1`.
9. **Follow the test pyramid** — Many unit tests, some integration tests, few E2E tests.
10. **Use factories for test data** — Don't hard-code test data; use factories for flexibility.
11. **Review test quality** — Run mutation testing to verify tests catch real bugs.
12. **Keep tests fast** — Slow tests are skipped; aim for <5 minutes full suite.

---

## Decision Tree

```
What test type?
├── Pure logic → Unit test
├── Database/API → Integration test
├── User journey → E2E test
├── Bug fix → Regression test
├── API contract → Contract test
├── Performance → Benchmark test
├── Not sure → Start with unit tests

What mocking strategy?
├── Unit test → Mock all external deps
├── Integration test → Use real DB (testcontainers), mock network
├── E2E test → Use real everything
└── Contract test → Mock provider

What assertion style?
├── Exact match → assertEqual / toEqual
├── Contains → assertIn / toContain
├── Exception → assertRaises / toThrow
├── Snapshot → toMatchSnapshot
└── Property → hypothesis / fast-check
```

---

## Verification

- [ ] All tests pass
- [ ] Coverage meets target
- [ ] Tests are independent
- [ ] Edge cases covered
- [ ] Mocks are appropriate (not over-mocked)
- [ ] Tests are fast enough
- [ ] No flaky tests

## Anti-Patterns

- ❌ Testing implementation details
- ❌ Tests that depend on each other
- ❌ Tests that are non-deterministic
- ❌ Mocking everything (integration tests need real deps)
- ❌ Ignoring flaky tests
- ❌ Writing tests after deployment
- ❌ Assertion-free tests
- ❌ Testing trivial code while ignoring complex code
- ❌ Not cleaning up test state
- ❌ Using production data in tests
- ❌ Skipping tests to "save time"
- ❌ Writing tests that are harder to understand than the code itself
