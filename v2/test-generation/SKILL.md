---
name: test-generation
description: >-
  Generate unit tests, integration tests, and test suites for any codebase. Use this skill when the user asks to write tests, نوشتن تست, generate unit tests, test this code, add tests, create test cases, coverage, write test for this function, I need tests, test suite, integration tests, mocking tests, Jest tests, pytest, JUnit, mocha tests, تست نویسی, تست واحد, تست یکپارچه‌سازی, پوشش تست, نوشتن کیس تست, write tests for this, add test coverage, create a test file, test this function, test this module, test this class, how do I test this, write a test case for, add unit tests, add integration tests, mock this dependency, write e2e tests, write component tests, test my API, test my hook, test my middleware, property-based testing, snapshot test, regression test, edge case tests, write test for this bug, 测试, 写测试, 单元测试, 集成测试, 测试用例, 覆盖率, 测试覆盖率, mock测试.
---

# Test Generation Skill

## Overview

This skill generates practical, high-quality tests that provide real value. Good tests catch regressions, document expected behavior, and give developers confidence to change code. The focus is on tests that are readable, maintainable, and that test meaningful behavior — not just achieve high coverage numbers.

A test is only as good as the failure it produces. A test that always passes (or passes for the wrong reasons) is worse than no test at all because it gives false confidence.

## When to Use This Skill

- User asks to write tests, add tests, or generate test cases
- User mentions unit tests, integration tests, or test coverage
- User shares a function/module and asks to "test this"
- User wants to verify existing code works correctly
- User needs a test suite for a new or existing project
- User wants to test a specific bug fix (regression test)
- User asks to add tests for an API endpoint
- User wants component tests for UI code
- User asks about mocking, stubbing, or test doubles
- User wants property-based or fuzz testing
- User needs tests for async code, error paths, or edge cases
- User asks to achieve a specific coverage target

## Test Generation Workflow

### Step 1: Analyze the Code Under Test

1. Read the source file(s) using the Read tool.
2. Identify the language, framework, and existing test infrastructure.
3. Look for existing test files to match conventions (file naming, directory structure, test framework, assertion style).
4. Understand the function/module's public API — parameters, return values, side effects, error cases.
5. Read related types, interfaces, and type definitions.
6. Check for existing mocks, fixtures, or test utilities in the project.
7. Identify external dependencies that will need to be mocked (databases, APIs, file system, time).

### Step 2: Detect the Testing Stack

Look for existing test configuration and dependencies:

| Language | Common Test Frameworks | Common Mocking Libraries |
|----------|----------------------|------------------------|
| JavaScript/TypeScript | Jest, Vitest, Mocha, Node Test Runner | jest.fn(), vi.fn(), sinon, testdouble |
| Python | pytest, unittest | unittest.mock, pytest-mock, responses |
| Go | testing (stdlib), testify | testify/mock, gomock |
| Java | JUnit 5, TestNG | Mockito, EasyMock |
| Rust | #[test] (built-in) | mockall, mockall_double |
| C# | xUnit, NUnit, MSTest | Moq, NSubstitute |
| Ruby | RSpec, Minitest | RSpec mocks, webmock |
| PHP | PHPUnit | Prophecy, Mockery |
| Swift | XCTest, Quick | Cuckoo, Mockingbird |
| Kotlin | JUnit 5, Kotest, MockK | MockK, MockWebServer |

If no test framework is installed, prefer the most common one for the language. Check `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, or similar for clues.

### Step 3: Design Test Cases

For each function/module, identify test cases covering:

1. **Happy path** — normal inputs produce correct outputs
2. **Edge cases** — empty inputs, zero, negative numbers, max values, boundary conditions
3. **Error cases** — invalid inputs, expected exceptions, error return values
4. **Type variations** — if the function accepts multiple types, test each
5. **Stateful behavior** — if the function modifies state, verify before/after
6. **Async behavior** — if async, test both resolve and reject paths
7. **Boundary values** — just above and below thresholds (0, 1, MAX_INT, MIN_INT, empty string, single char)
8. **Identity/No-op cases** — input that should produce unchanged or minimal output
9. **Ordering/sorting** — if order matters, test unsorted, already sorted, reverse sorted
10. **Idempotency** — calling the function twice with same input should produce same result

### Step 4: Write the Tests

Apply these principles when writing:

- **Descriptive names**: test names should describe the scenario and expected result, e.g., `returns_empty_array_when_input_is_null`
- **Arrange-Act-Assert**: structure each test with clear setup, execution, and verification
- **No test interdependence**: each test must run in isolation
- **Mock external dependencies**: use mocks/stubs for databases, APIs, file system, network
- **Keep tests focused**: one logical assertion per test; split if testing multiple behaviors
- **Avoid brittle tests**: don't test implementation details, test observable behavior
- **Use factories/builders for test data**: don't inline complex object creation in every test
- **Test error messages**: verify that error messages are helpful, not just that errors are thrown
- **Use parameterized tests**: for functions that should behave the same across many inputs
- **Avoid test helpers that obscure intent**: if a helper makes the test harder to read, inline instead

### Step 5: Write to File

1. Place the test file following the project's convention (e.g., `__tests__/`, `*.test.js`, `test_*.py`).
2. Include necessary imports and setup/teardown if needed.
3. Use the Write tool to create the test file.
4. If the project has a test config file that needs updating (e.g., adding to vitest.config.ts), note this.

## Advanced Techniques

### Test Doubles Hierarchy
Understand and apply the right level of test double:
- **Dummy**: Passed around but never actually used (e.g., required parameter you don't need)
- **Stub**: Returns canned responses (e.g., a mock database that always returns the same user)
- **Spy**: Records information about calls made to it (e.g., was this function called? with what args?)
- **Mock**: Pre-programmed with expectations about the calls it will receive
- **Fake**: Has a working implementation but takes shortcuts (e.g., in-memory database)

### Property-Based Testing
For pure functions, define properties that should hold for ANY input:
```python
# Instead of testing specific values, test that the property holds
# Property: reversing a list twice always gives the original list
# Property: sorting is idempotent (sorting a sorted list gives the same list)
# Property: for any valid email, the validation function is consistent
```

### Test Pyramid Strategy
Follow the test pyramid for comprehensive coverage:
- **Unit tests (many)**: Test individual functions and classes in isolation. Fast, cheap, targeted.
- **Integration tests (moderate)**: Test modules working together (e.g., service + database). Slower, more realistic.
- **E2E tests (few)**: Test the full system from outside. Slowest, most expensive, but most confidence.

### Mutation Testing Mindset
Write tests that would fail if the code was subtly modified:
- If you changed `>` to `>=`, would any test fail?
- If you removed a line, would any test fail?
- If you swapped two branches of an if/else, would any test fail?
If the answer is no, your test isn't testing that behavior.

### Snapshot Testing
For UI components or complex data structures where specifying the exact output is tedious:
- Record a snapshot of the output on first run
- Future runs compare against the snapshot
- Useful for React components, serialized data, error messages
- Must be reviewed when snapshots change — never blindly update

## Common Patterns

### Pattern 1: The Arranged Test
A well-structured test with clear setup, action, and assertion phases.
```
// Arrange: create test data
const user = { name: 'Alice', role: 'admin' };

// Act: call the function under test
const result = canAccessDashboard(user);

// Assert: verify the outcome
expect(result).toBe(true);
```

### Pattern 2: The Mocked Dependency
A test that replaces an external dependency with a test double.
```
// Before: function calls real database
// After: inject mock that returns controlled data
const mockDb = { findUser: jest.fn().mockResolvedValue({ id: 1, name: 'Alice' }) };
```

### Pattern 3: The Error Path Test
A test that verifies the function handles errors correctly.
```
// Test that the function throws, returns error, or handles gracefully
await expect(validateEmail('invalid')).rejects.toThrow(ValidationError);
// Or: expect(() => divide(1, 0)).toThrow(DivisionByZeroError);
```

### Pattern 4: The Parameterized Test
A single test logic applied to many input/output pairs.
```
// pytest: @pytest.mark.parametrize('input,expected', [(1,2), (2,4), (-1,-2)])
// Jest: test.each([[1,2], [2,4], [-1,-2]])('%s + 1 = %s', (input, expected) => ...)
```

### Pattern 5: The Setup/Teardown Pattern
Shared setup code that runs before each test to reduce duplication.
```
// Jest: beforeEach(() => { ... })
// pytest: @pytest.fixture
// JUnit: @BeforeEach
// Purpose: create fresh test data, reset mocks, establish known state
```

## Edge Cases & Pitfalls

1. **Testing implementation details** — Testing private methods or internal state makes tests brittle. Test the public API.
2. **Over-mocking** — If you mock everything, you're testing mocks, not code. Only mock external dependencies.
3. **Test interdependence** — Test B relying on Test A's side effects means tests can't run in isolation or in parallel.
4. **Flaky tests** — Tests that depend on timing, file system state, or network are unreliable. Mock these dependencies.
5. **Asserting too much** — One test checking 20 things means when it fails, you don't know which assertion broke.
6. **Not testing error paths** — Most bugs are in error handling, not happy paths. Test what happens when things go wrong.
7. **Meaningless assertions** — `expect(result).toBeDefined()` provides almost no value. Assert the specific expected value.
8. **Testing trivial code** — Getters, setters, and simple pass-through functions don't need unit tests. Focus on logic.
9. **Ignoring async** — Forgetting to await an async function means the test passes before the assertion runs.
10. **Hardcoded test data** — Using specific values like `user_id: 42` without explaining why 42 is meaningful makes tests hard to understand.
11. **Not cleaning up** — Tests that create files, database records, or temporary state without cleanup pollute the test environment.
12. **Testing the framework** — Don't test that React renders a component or that Express routes to a handler. Test your code.
13. **Giant test functions** — If a test has 50 lines of setup, extract the setup into a factory or fixture.
14. **Not using test isolation** — Running tests without resetting database state or clearing caches causes test pollution.

## Integration with Other Skills

- **debug**: When a test reveals a bug, switch to the debug skill to diagnose and fix the source code.
- **code-review**: After generating tests, a code review can verify the tests are well-structured and meaningful.
- **refactor**: If the source code needs restructuring before it can be properly tested, refactor first.
- **explain-code**: If you need to understand complex code before writing tests for it, use explain-code first.
- **api-integration**: When testing API clients, verify the test mocks match the actual API contract.
- **database-schema**: When testing database code, ensure the test fixtures match the actual schema.

## Output Format

### Standard Test Generation Summary Template

```
## Test Generation Summary

**Source file(s):** [files tested]
**Test file created:** [path to new test file]
**Framework:** [detected or chosen framework]
**Test cases generated:** [count]

### Test Coverage Map
| Function | Happy Path | Edge Cases | Error Cases | Total |
|----------|-----------|------------|-------------|-------|
| [Function A] | 2 | 2 | 1 | 5 |
| [Function B] | 1 | 1 | 1 | 3 |

### Notes
- [Assumptions made, external dependencies that need mocking]
- [Any behaviors that were difficult to test and why]
- [Suggested additional test scenarios the user might want]
```

### Regression Test Template

```
## Regression Test

**Bug:** [description of the bug being prevented]
**Test file:** [path]

### Test Case
```lang
// Test that specifically captures the bug condition
// This test should FAIL on the buggy code and PASS on the fixed code
```

### Verification
- [ ] Test fails on pre-fix code
- [ ] Test passes on post-fix code
```

### Quick Test Template (for simple functions)

```
**Generated:** [test file path]
**Cases:** [count] — [brief description of what's covered]
```

## Test Type Reference Guide

### Unit Tests
- Test a single function or class in isolation
- Mock all external dependencies (database, API, file system)
- Fast execution (< 100ms per test)
- No side effects — each test is hermetic
- Run on every commit

### Integration Tests
- Test 2+ modules working together
- May use real database (test container) or external service
- Slower execution (100ms - 10s per test)
- Test real interactions, not mocks
- Run on PR merge or before release

### E2E / Functional Tests
- Test the system from the outside (HTTP, CLI, UI)
- No mocking — full stack involved
- Slowest (seconds to minutes per test)
- Test user-facing behavior, not implementation
- Run in CI pipeline, not on every commit

### Contract Tests
- Verify that API consumers and providers agree on the interface
- Useful for microservices where services are developed independently
- Catch breaking API changes before deployment

## Rules

- Read the source code before writing any tests. Never guess at function signatures.
- Match the project's existing test style and conventions.
- Do not install packages or modify configuration files unless the user asks.
- If a function is trivially simple (e.g., a getter), skip it and focus on non-trivial logic.
- If the user specifies a framework, use it. Otherwise, detect from the project.
- Generate meaningful test data, not random strings or magic numbers without context.
- Present the summary in the user's language; keep code and technical terms in English.
- Always test the error paths, not just the happy path.
- Use descriptive test names that explain the scenario and expected result.
- Don't generate tests for generated code, vendored code, or framework internals.
- Prefer testing behavior over implementation details — if the implementation changes, the test should still pass.
- Group related tests in describe/context blocks for readability.
- If the code has complex setup requirements, create shared fixtures or factory functions.
- For async code, always test both the success and failure (rejection) paths.
