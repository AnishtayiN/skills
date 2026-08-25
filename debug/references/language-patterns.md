# Language-Specific Debugging Patterns

This reference provides targeted debugging strategies for common languages. Read the relevant section when debugging code in that language.

---

## Python

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `IndentationError` | Mixed tabs and spaces, wrong indent level | Use 4 spaces consistently; run `python -m py_compile file.py` to check |
| `TypeError: 'NoneType' object is not subscriptable` | Function returns None instead of expected value | Check that the function has a return statement in all code paths |
| `KeyError` | Accessing dict key that doesn't exist | Use `.get(key, default)` or check `key in dict` first |
| `ModuleNotFoundError` | Missing package or wrong import path | Check `pip list` and verify import statement matches the package name |
| `RecursionError` | Infinite recursion, no base case | Add base case; increase recursion limit only as last resort |
| `UnicodeDecodeError` | Reading file with wrong encoding | Specify `encoding='utf-8'` (or the correct encoding) when opening files |

### Python-Specific Debugging Tips

- Use `print(type(variable), variable)` instead of just `print(variable)` — many bugs are type mismatches
- For async code, check that every `await` is actually awaited. A missing `await` returns a coroutine object instead of the result
- Python's `is` checks identity, `==` checks equality. `x is None` is correct; `x == None` works but is not idiomatic
- List comprehensions create new lists. Modifying a list while iterating over it leads to skipped elements
- Default mutable arguments (`def f(x=[])`) are shared across calls. Use `None` as default and create inside the function

### Agent/AI Python Code

- **LangChain**: Check that chain output keys match the next input keys. Mismatches cause `KeyError` in chains
- **OpenAI API**: Verify `response.choices[0].message.content` — the structure changed across API versions
- **FastAPI + LLM**: Check that async endpoints are actually `async def`. Mixing sync and async can cause deadlocks
- **Pandas + LLM output**: LLM-generated data may have inconsistent types. Validate before DataFrame construction

---

## JavaScript / TypeScript

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `TypeError: Cannot read properties of undefined (reading 'x')` | Accessing property of undefined/null | Use optional chaining `obj?.x` or check existence first |
| `ReferenceError: x is not defined` | Variable used before declaration, or scope issue | Check `let`/`const` vs `var` scoping; ensure imports are correct |
| `SyntaxError: Unexpected token` | Invalid JSON, missing bracket/comma | Use `JSON.parse()` with try/catch; validate JSON structure |
| `RangeError: Maximum call stack size exceeded` | Infinite recursion or deeply nested callbacks | Check for accidental recursive calls; convert to iterative approach |
| `TypeError: x is not a function` | Import mismatch (default vs named) | Verify import/export statements match between files |

### JS/TS-Specific Debugging Tips

- `undefined` vs `null`: JavaScript has both. Check for both with `value == null`
- `const` doesn't make objects immutable. Use `Object.freeze()` or spread syntax for immutability
- `Promise` rejections are silently swallowed unless you `.catch()` or use `try/catch` with `await`
- `Array.prototype.forEach` cannot be broken out of. Use `for...of` if you need early termination
- In Node.js, unhandled promise rejections crash the process in newer versions. Always handle rejections

### Agent/AI JS/TS Code

- **z-ai-web-dev-sdk**: Must only be used in backend/server-side code, never in client-side
- **Next.js API routes**: Check that API routes return `Response` or `NextResponse` objects, not plain objects
- **Tool calling in JS**: Verify the tool schema matches the function signature exactly; parameter type mismatches are the #1 cause of tool call failures
- **WebSocket agents**: Check for message ordering issues; WebSocket messages can arrive out of order

---

## Rust

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `E0382: borrow of moved value` | Using a value after it's been moved | Clone before move, or use references |
| `E0596: cannot borrow as mutable` | Trying to mutate through an immutable reference | Change `&` to `&mut` in the function signature |
| `E0277: the trait bound is not satisfied` | Missing trait implementation | Add `use` for the trait, or implement it |
| `E0499: cannot borrow as mutable more than once` | Aliasing a mutable reference | Restructure to avoid overlapping borrows |
| Stack overflow | Excessively deep recursion or large stack allocations | Use `Box<T>` for heap allocation; convert recursion to loops |

### Rust-Specific Debugging Tips

- Rust errors are precise. Read them carefully — the compiler tells you exactly what's wrong and often suggests the fix
- Use `dbg!(expression)` instead of `println!` for debugging — it prints the expression and its value with file:line info
- Lifetime errors usually mean you're holding a reference to something that might be freed. Restructure ownership
- `Clone` has a performance cost. Only clone when necessary; prefer borrowing

---

## Go

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `nil pointer dereference` | Accessing a nil pointer | Initialize the pointer or check for nil before access |
| `panic: assignment to entry in nil map` | Using an uninitialized map | Use `make(map[keyType]valueType)` to initialize |
| `deadlock` | Goroutines waiting on each other | Use `go vet` and `race detector`; check lock ordering |
| `context canceled` | Parent context cancelled before goroutine finished | Handle context cancellation gracefully; check `ctx.Err()` |

### Go-Specific Debugging Tips

- Always handle errors. `if err != nil` is not optional in Go — ignoring errors is the source of most Go bugs
- Goroutine leaks are common. Ensure every goroutine has a clear exit path
- Use `defer` for cleanup, but be aware of deferred function execution order (LIFO)
- The `race` detector (`go run -race`) catches data races at runtime. Use it regularly

---

## Java

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `NullPointerException` | Accessing method/field on null | Add null checks; use `Optional` |
| `ClassNotFoundException` | Missing dependency in classpath | Add the dependency to your build file (Maven/Gradle) |
| `ConcurrentModificationException` | Modifying collection while iterating | Use `Iterator.remove()` or collect-and-modify pattern |
| `StackOverflowError` | Deep recursion, circular dependencies in Spring beans | Increase stack size (-Xss), fix circular dependencies |

### Java-Specific Debugging Tips

- `==` compares references, `.equals()` compares values. Always use `.equals()` for objects (especially Strings)
- Autoboxing can cause subtle NPEs: `Integer a = null; int b = a;` throws NPE on unboxing
- Spring `@Autowired` injection fails silently with `@RequiredArgsConstructor` if the field type doesn't match any bean

---

## SQL

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `syntax error near...` | Missing comma, keyword misspelled, unquoted identifier | Check the SQL statement character by character near the reported position |
| `relation does not exist` | Wrong table/schema name | Verify table name, check schema search path |
| `column does not exist` | Wrong column name or table alias | Check column names against the schema |
| `division by zero` | Aggregate on empty set without COALESCE | Use `NULLIF(denominator, 0)` |

### SQL-Specific Debugging Tips

- Run the query piece by piece: start with the FROM/JOIN clause, then add WHERE, then GROUP BY, then SELECT
- Use `EXPLAIN` / `EXPLAIN ANALYZE` to understand the query plan — most performance bugs are visible here
- N+1 query pattern: if you're querying in a loop, use a JOIN or subquery instead
- Always parameterize queries to prevent SQL injection — never concatenate user input into SQL strings

---

## YAML / JSON Configuration

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| YAML `mapping values are not allowed` | Colon in value without quoting | Quote the value or escape the colon |
| JSON `Unexpected token` | Trailing comma, single quotes, unquoted keys | Use double quotes; remove trailing commas |
| YAML `could not find expected ':'` | Incorrect indentation | YAML is indentation-sensitive. Use spaces, not tabs |
| Config not loading | Wrong file path, wrong environment variable name | Print the resolved config path; check env var names |