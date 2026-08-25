---
name: testing
description: >-
  Create, run, and manage tests: unit, integration, E2E, regression, performance.
  TRIGGERS: test, testing, write tests, unit test, integration test, e2e, test coverage,
  mock, assertion, test suite, regression test, smoke test, test failure, flaky test,
  تست, تست بنویس, تست واحد, تست یکپارچه, پوشش تست, شکست تست, mock
priority: P1
dependencies: [project-analysis, code-review]
conflicts: []
---

# Testing Skill

## Purpose

Create, run, and maintain tests. Ensure code correctness through automated verification.

## When to Activate

- User asks to write tests
- Test coverage is low
- After code generation (add tests)
- After bug fix (add regression test)
- Before deployment (verify test suite)
- Test is failing

## When NOT to Activate

- User wants to write production code (→ code-generation)
- No code to test
- User explicitly says skip tests

## Inputs Required

- Code to test
- Test framework (auto-detect from project)
- Type of test needed

## Preconditions

- Code exists and is testable

## Workflow

### Step 1: Detect Test Framework

```
Look for:
- package.json → jest, vitest, mocha
- pyproject.toml → pytest
- go.mod → testing package
- Cargo.toml → cargo test
- pom.xml → JUnit
- jest.config.*, vitest.config.*
```

### Step 2: Determine Test Type

```
What to test?
├── Single function → Unit test
├── Module interaction → Integration test
├── User flow → E2E test
├── Bug fix → Regression test
├── Performance → Benchmark test
└── Security → Security test
```

### Step 3: Write Tests

```
For each test case:
1. Arrange — Set up test data and mocks
2. Act — Call the function/method
3. Assert — Verify the result

Test cases to include:
- Happy path (normal behavior)
- Edge cases (empty, null, boundary values)
- Error cases (invalid input, exceptions)
- Integration points (external dependencies)
```

### Step 4: Run Tests

```
1. Run the test suite
2. Check for failures
3. Check coverage
4. Fix any issues
```

## Test Patterns

### Unit Test
```python
def test_calculate_total():
    # Arrange
    items = [{"price": 10}, {"price": 20}]
    
    # Act
    total = calculate_total(items)
    
    # Assert
    assert total == 30
```

### Edge Cases
```python
def test_calculate_total_empty():
    assert calculate_total([]) == 0

def test_calculate_total_single():
    assert calculate_total([{"price": 5}]) == 5
```

### Error Cases
```python
def test_calculate_total_invalid():
    with pytest.raises(ValueError):
        calculate_total([{"price": -1}])
```

### Mock External Dependencies
```python
def test_fetch_data(monkeypatch):
    monkeypatch.setattr("requests.get", mock_get)
    result = fetch_data()
    assert result is not None
```

## Decision Tree

```
What test type?
├── Pure logic → Unit test
├── Database/API → Integration test
├── User journey → E2E test
├── Bug fix → Regression test
└── Not sure → Start with unit tests
```

## Output Format

```
## Test Report

### Tests Created
| Test | Type | Status |
|------|------|--------|
| test_name | unit | ✅ |

### Coverage
[Coverage report]

### Run Command
[How to run tests]
```

## Execution Rules

- Test behavior, not implementation
- Each test tests ONE thing
- Tests must be independent
- Tests must be deterministic
- Mock external dependencies
- Test edge cases and errors

## Verification

- [ ] All tests pass
- [ ] Coverage is adequate
- [ ] Tests are independent
- [ ] Edge cases covered

## Anti-Patterns

- ❌ Testing implementation details
- ❌ Tests that depend on each other
- ❌ Tests that are non-deterministic
- ❌ Mocking everything (integration tests need real deps)
- ❌ Ignoring flaky tests
- ❌ Writing tests after deployment

## Skill Interactions

- ← code-review: Identifies testing gaps
- → verification: Tests verify correctness
- → debugging: Test failures guide debugging
