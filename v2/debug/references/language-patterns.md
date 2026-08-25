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
| `AttributeError: 'str' object has no attribute...` | Wrong type passed — expected an object, got a string | Check the variable's actual type with `type()`; trace where the wrong type was assigned |
| `ImportError: cannot import name 'X' from 'Y'` | Circular import, wrong module name, or missing export | Check for circular imports; verify the name is actually defined in the source module |
| `SyntaxError: EOL while scanning string literal` | Unclosed string, missing quote | Search for unmatched quotes in the vicinity of the reported line |
| `UnboundLocalError: local variable 'X' referenced before assignment` | Variable assigned inside a conditional but accessed outside | Initialize the variable before the conditional, or use `nonlocal`/`global` |

### Python-Specific Debugging Tips

- Use `print(type(variable), variable)` instead of just `print(variable)` — many bugs are type mismatches
- For async code, check that every `await` is actually awaited. A missing `await` returns a coroutine object instead of the result
- Python's `is` checks identity, `==` checks equality. `x is None` is correct; `x == None` works but is not idiomatic
- List comprehensions create new lists. Modifying a list while iterating over it leads to skipped elements
- Default mutable arguments (`def f(x=[])`) are shared across calls. Use `None` as default and create inside the function
- `__init__.py` files must exist (even empty) for Python to recognize a directory as a package
- `try/except` catches `BaseException` subclasses including `KeyboardInterrupt` and `SystemExit`. Always catch specific exceptions
- `isinstance()` checks include subclasses. Use `type(x) is MyClass` for exact type matching
- `==` on floats can fail due to precision. Use `math.isclose()` or `pytest.approx()` for float comparisons
- `*args` and `**kwargs` shadow variable names. If a function parameter is named `items` and you also have `**kwargs` with an `items` key, they don't conflict — but they can confuse developers

### Python Debugging Tools

- `python -m pdb script.py` — built-in debugger
- `breakpoint()` — drops into pdb (Python 3.7+)
- `python -c "import ast; ast.parse(open('file.py').read())"` — check syntax without executing
- `python -m traceback` — format tracebacks from log files

### Agent/AI Python Code

- **LangChain**: Check that chain output keys match the next input keys. Mismatches cause `KeyError` in chains
- **OpenAI API**: Verify `response.choices[0].message.content` — the structure changed across API versions
- **FastAPI + LLM**: Check that async endpoints are actually `async def`. Mixing sync and async can cause deadlocks
- **Pandas + LLM output**: LLM-generated data may have inconsistent types. Validate before DataFrame construction
- **Celery + LLM**: Long-running LLM calls can exceed Celery's soft/hard time limits. Increase timeout or use async task patterns

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
| `TypeError: Cannot set properties of null` | Trying to set a property on null | Add null check before property assignment |
| `SyntaxError: Cannot use import statement outside a module` | Missing `"type": "module"` in package.json or wrong file extension | Add `"type": "module"` to package.json or use `.mjs` extension |
| `TypeError: NetworkError when attempting to fetch resource` | CORS issue, wrong URL, or server unreachable | Check CORS headers, verify URL is correct, check network connectivity |
| `UnhandledPromiseRejection` | Missing `.catch()` or `try/catch` around async operation | Add error handling to all promise chains |

### JS/TS-Specific Debugging Tips

- `console.log` is synchronous but `console.table()` formats arrays/objects as tables — much more readable for debugging
- In TypeScript, if the type system says something is fine but it crashes at runtime, the type is a lie. Check actual runtime values
- `typeof null === 'object'` is a well-known JS quirk. Always check for null explicitly before type checks
- `const` doesn't make objects immutable — only the binding is const. Use `Object.freeze()` if needed
- Async/await in a loop runs sequentially. Use `Promise.all()` for parallel execution
- Event loop starvation: long-running synchronous code blocks the event loop, causing setTimeout/setInterval delays
- `==` performs type coercion. Always use `===` unless you specifically want coercion
- `Array.prototype.forEach` cannot be broken out of. Use `for...of` or `Array.prototype.some` if early exit is needed
- In Node.js, unhandled promise rejections crash the process by default (since Node 16). Always handle rejections
- `JSON.stringify()` drops undefined values, functions, and Symbols silently. Use a replacer function if needed
- JavaScript numbers are IEEE 754 doubles. `0.1 + 0.2 !== 0.3`. Use `Number.EPSILON` for comparison

### JS/TS Debugging Tools

- `node --inspect-brk script.js` + Chrome DevTools — Node.js debugging
- `console.trace()` — prints stack trace at current point
- `console.time('label')` / `console.timeEnd('label')` — simple timing
- VS Code debugger with `launch.json` — most common IDE debugging approach
- Browser DevTools: Sources tab for breakpoints, Network tab for API calls, Performance tab for profiling

---

## C / C++

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `Segmentation fault (core dumped)` | Dereferencing null/invalid pointer, buffer overflow, use-after-free | Use debugger (`gdb`) to get the exact line; check pointer validity before dereferencing |
| `Bus error` | Unaligned memory access, accessing freed memory mapped file | Ensure struct packing is correct; check mmap'd memory regions |
| `double free or corruption` | Freeing the same pointer twice | Set pointer to NULL after free; use valgrind to detect |
| `undefined reference to ...` | Linker error — function declared but not defined, or missing library | Check that the source file is compiled and linked; add `-l<library>` flag |
| `stack smashing detected` | Stack buffer overflow (local array overran) | Use `strncpy`/`snprintf` instead of `strcpy`/`sprintf`; increase buffer size |
| `abort() has been called` | Assertion failure or unhandled exception | Check `assert()` conditions; run in debugger to see the assertion that failed |
| `error: expected ';', ',', or ')' before ...` | Missing semicolon or brace in the line ABOVE the reported error | Check the previous line for syntax issues; mismatched parentheses |
| `undefined symbol` (runtime) | Shared library not found at runtime | Set `LD_LIBRARY_PATH` or use `rpath` linker option |

### C/C++-Specific Debugging Tips

- Use `-Wall -Wextra -Wpedantic` compiler flags. Most C/C++ bugs are caught by warnings treated as errors (`-Werror`)
- Memory bugs: use Valgrind (`valgrind --leak-check=full ./program`) or AddressSanitizer (`-fsanitize=address`)
- Undefined behavior in C/C++ is the root cause of many mysterious bugs. It can appear to work and then fail randomly
- `sizeof` doesn't give the length of an array passed to a function — it gives the pointer size. Pass array length separately
- `printf("%s")` with a NULL pointer is undefined behavior. Always check for NULL before printing strings
- In C++, use `std::unique_ptr` and `std::shared_ptr` instead of raw `new`/`delete`. They prevent most memory leaks
- `memcpy(dst, src, n)` with overlapping regions is undefined behavior. Use `memmove` for overlapping copies
- Integer overflow is undefined behavior for signed integers in C/C++. Use unsigned types for bit manipulation
- `static_cast` vs `dynamic_cast`: static_cast doesn't check types at runtime. Use dynamic_cast with polymorphic types
- In C, `char` may be signed or unsigned depending on the platform. Use `unsigned char` for byte data
- Use `gdb` with `tui` mode (`gdb -tui`) for a text-based visual debugger
- Thread bugs: use ThreadSanitizer (`-fsanitize=thread`) and Helgrind to detect data races
- C++ exceptions in destructors are dangerous. Destructors should never throw

### C/C++ Debugging Tools

- `gdb ./program` — GNU debugger
- `gdb ./program core` — debug from core dump
- `valgrind --tool=memcheck ./program` — memory error detection
- `-fsanitize=address,undefined` — compile-time sanitizers (GCC/Clang)
- `strace ./program` — trace system calls
- `ltrace ./program` — trace library calls
- `nm` / `objdump` — inspect symbols and disassembly

---

## C#

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `NullReferenceException` | Accessing a member on a null object | Add null check; use null-conditional operator `?.` |
| `IndexOutOfRangeException` | Array/list index out of bounds | Check length before access; use `TryGetValue` for dictionaries |
| `InvalidOperationException: Collection was modified` | Modifying a collection while iterating over it | Use `ToList()` to create a copy before iterating, or use `RemoveAll` |
| `ObjectDisposedException` | Using a disposed object (stream, connection, etc.) | Check `IsDisposed` before use; use `using` statements correctly |
| `TypeLoadException` | Missing assembly or version mismatch | Check assembly references and binding redirects in app.config/web.config |
| `SqlException: Timeout expired` | Query takes too long or connection pool exhausted | Check query performance; increase timeout; check for unclosed connections |
| `AggregateException` | One or more exceptions from parallel/async operations | Inspect `InnerExceptions` for the actual failures |
| `CS0103: The name 'X' does not exist in the current context` | Missing `using` directive, wrong namespace, or typo | Add the correct `using` statement; check namespace |

### C#-Specific Debugging Tips

- `async void` should only be used for event handlers. It swallows exceptions and can't be awaited. Use `async Task` instead
- `Task.Run` for CPU-bound work, `await` for I/O-bound work. Using both together creates unnecessary thread pool usage
- `string` is immutable in C#. Repeated concatenation in a loop creates garbage. Use `StringBuilder`
- `ValueTask` can avoid allocations for async methods that complete synchronously, but must only be awaited once
- LINQ `SingleOrDefault` throws if there's more than one match. Use `FirstOrDefault` unless you need that guarantee
- `DateTime.Now` uses local timezone (affected by DST changes). Use `DateTime.UtcNow` for consistent timestamps
- C# `struct` is value-typed. Mutating a struct property on a copy doesn't affect the original
- `IEnumerable<T>` is lazily evaluated. Calling `.ToList()` materializes it. Be careful of multiple enumeration
- `Equals()` vs `==`: `==` can be overloaded, `Equals` is virtual. For reference types, `==` checks reference equality by default
- `lock(this)` is an anti-pattern. Lock on a private readonly object to prevent external code from deadlocking you

### C# Debugging Tools

- Visual Studio Debugger — breakpoints, watch, immediate window, IntelliTrace
- `dotnet-dump` — collect and analyze .NET process dumps
- `dotnet-trace` — trace performance for .NET applications
- `dotnet-counters` — monitor runtime metrics
- LINQPad — test LINQ queries interactively

---

## Ruby

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `NoMethodError: undefined method 'X' for nil:NilClass` | Calling a method on nil (the "nil bomb") | Use safe navigation operator `&.` (Ruby 2.3+) or check for nil |
| `NameError: uninitialized constant X` | Missing require, typo in constant name, or wrong scope | Add `require` statement; check namespace/scoping |
| `ArgumentError: wrong number of arguments` | Method called with wrong number of args | Check method definition; use keyword arguments for clarity |
| `SystemStackError: stack level too deep` | Infinite recursion, or too many method calls | Check for accidental recursive calls; increase stack size only as last resort |
| `LoadError: cannot load such file` | Gem not installed or require path is wrong | Run `bundle install`; check gem name in Gemfile |
| `ActiveRecord::RecordNotFound` | `.find!` or `.find` with non-existent ID | Use `.find_by` which returns nil instead of raising |
| `ActiveRecord::RecordNotUnique` | Database unique constraint violation | Use `.find_or_create_by` or `.upsert` instead of `.create` |
| `TypeError: no implicit conversion of String into Integer` | Passing wrong type to a method | Check the value's class with `.class`; convert explicitly with `.to_i`, `.to_s` |

### Ruby-Specific Debugging Tips

- Everything in Ruby is an object, including `nil`, `true`, `false`, and even classes
- `nil?` is the idiomatic way to check for nil. Don't use `== nil` (though it works)
- Ruby's `require` only loads a file once. Use `load` to reload (useful in development/debugging)
- Mutable default arguments (`def f(x = [])`) are shared across calls, same as Python. Use `x = nil` as default
- `freeze` makes an object immutable. Useful for preventing accidental modification of constants or config
- String interpolation `"#{var}"` calls `.to_s` automatically. Be careful with non-string objects that have unexpected `.to_s`
- Rails: `update` saves to DB, `update_attribute` skips validations on single attribute, `update_columns` skips validations AND callbacks
- Rails: N+1 queries — use `.includes(:association)` to eager load. Check with `Bullet` gem in development
- `rescue` without specifying exception class catches `StandardError` (not `Exception`). This is correct in most cases
- Ruby's `&&` and `||` return the last evaluated value, not necessarily a boolean. Use `&.` and `||=` patterns
- Blocks vs Procs vs Lambdas: `lambda` checks argument count strictly, `Proc` does not. `return` in a lambda returns from the lambda; `return` in a Proc returns from the enclosing method

### Ruby Debugging Tools

- `binding.irb` — drops into IRB at current execution point (Ruby 2.4+)
- `byebug` — interactive debugger for Ruby
- `pry-byebug` — Pry with debugging support
- Rails: `rails console` for interactive exploration; `rails dbconsole` for direct database access

---

## PHP

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `Fatal error: Uncaught Error: Call to a member function ... on null` | Method called on null variable | Add null check before method call |
| `Fatal error: Allowed memory size of ... bytes exhausted` | Memory leak, unbounded loop, loading huge file | Increase `memory_limit` in php.ini; check for infinite loops; process data in chunks |
| `Warning: Undefined array key "X"` | Accessing array key that doesn't exist (PHP 8.0+) | Use `??` (null coalescing) or `isset()` before access |
| `Fatal error: Cannot redeclare ...` | Function or class defined twice (duplicate include) | Use `include_once`/`require_once` or check if already defined |
| `Parse error: syntax error, unexpected ...` | Missing semicolon, bracket, or quote | Check the line before the reported error |
| `TypeError: Argument #1 ($x) must be of type ...` | PHP 8 strict type enforcement | Verify the type passed matches the type hint; add type casts if needed |
| `SQLSTATE[HY000] [2002] Connection refused` | Database server not running or wrong connection settings | Check database service status; verify host, port, credentials in config |
| `Warning: session_start(): Cannot start session when headers already sent` | Output before `session_start()` (including BOM or whitespace) | Move `session_start()` to the very top; check for whitespace before `<?php` |

### PHP-Specific Debugging Tips

- PHP's `==` performs loose comparison (type coercion). `0 == "foo"` is `true`. Always use `===` for strict comparison
- `empty()` returns true for `"0"`, `0`, `null`, `false`, `""`, and `[]`. This can mask valid zero values
- PHP 8.0+ throws `TypeError` for type mismatches in function arguments. PHP 7.x would coerce silently — this is a common upgrade breakage
- `foreach` iterates over a copy of the array. Modifying the original array during iteration doesn't affect the loop (unlike by-reference foreach)
- `array_key_exists()` returns false for null values. `isset()` also returns false for null. If you need to distinguish, use `array_key_exists()`
- String comparison with `strcmp()` returns 0 for equal strings. A common bug: `if (!strcmp($a, $b))` — the `!` is needed and easy to forget
- Composer autoloading: run `composer dump-autoload` after adding new classes. Stale autoloader cache causes `Class not found` errors
- PHP's `DateTime` objects are mutable. Passing one to a function that modifies it affects the original. Clone it first: `$copy = clone $dt`
- `json_decode()` returns null for invalid JSON AND for the string `"null"`. Use `json_last_error()` to distinguish
- PHP's error reporting levels: use `error_reporting(E_ALL)` during development. In production, log errors but don't display them

### PHP Debugging Tools

- `Xdebug` — debugger, profiler, and code coverage tool
- `var_dump($var)` — structured variable output (better than `print_r`)
- `error_log(print_r($var, true))` — log variable contents to error log
- Laravel: `dd($var)`, `dump($var)` — dump and die / dump and continue
- PHPStan / Psalm — static analysis tools for catching type errors before runtime
- `php -l file.php` — syntax check without execution

---

## Swift

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `Fatal error: Unexpectedly found nil while unwrapping an Optional value` | Force-unwrapping (`!`) a nil optional | Use `if let`, `guard let`, or `??` instead of `!` |
| `EXC_BAD_ACCESS` | Memory access to deallocated object, dangling pointer | Enable Address Sanitizer in Xcode scheme; check for retain cycles |
| `Thread 1: EXC_BREAKPOINT` | Forced crash via `preconditionFailure()` or `fatalError()` | Check the condition that triggered the crash |
| `Cannot assign value of type 'X' to type 'Y'` | Type mismatch | Add explicit type conversion or check generic types |
| `'X' is inaccessible due to 'private' protection level` | Accessing private/internal member from wrong scope | Change access level or move the accessing code |
| `Use of unresolved identifier 'X'` | Missing import, typo, or out-of-scope variable | Add `import` statement; check spelling and scope |
| `Closure captures 'self' strongly, potentially causing a retain cycle` | Strong reference cycle in closure | Use `[weak self]` in the closure capture list |

### Swift-Specific Debugging Tips

- Swift optionals are the #1 source of crashes. Never use `!` unless you are absolutely certain the value is non-nil
- `guard let` is preferred over `if let` for early returns — it keeps the unwrapped variable in scope and reduces nesting
- Value types (struct, enum) are copied on assignment. Reference types (class) are shared. Choose intentionally
- Swift's `Codable` can fail silently with wrong key names. Use custom `CodingKeys` when JSON keys differ from property names
- `@escaping` closures that capture `self` strongly create retain cycles. Always use `[weak self]` and then `guard let self = self else { return }` inside
- Swift's `Array` subscript is unsafe — accessing an out-of-bounds index crashes. Use `indices.contains(index)` or safe subscript extension
- `async/await` in Swift: calling an async function from a sync context requires a Task wrapper. Forgetting this is a common mistake
- `weak` references become `nil` when the object is deallocated. Check for nil after unwrapping
- Protocol-oriented programming: prefer protocols with default implementations over class inheritance for shared behavior
- SwiftUI: state changes trigger view re-renders. Modifying state outside the main thread causes runtime warnings or crashes

### Swift Debugging Tools

- Xcode Debugger — breakpoints, LLDB console, memory graph
- `LLDB` — `po variable` to print, `frame variable` to inspect stack frame
- Instruments — Time Profiler, Allocations, Leaks, Network
- `print()` and `dump()` for console logging
- SwiftUI Preview — rapid UI iteration and debugging

---

## Kotlin

### Common Error Patterns

| Error | Typical Cause | Quick Fix |
|-------|--------------|----------|
| `NullPointerException` (Kotlin's !! operator) | Force-unwrapping a null with `!!` | Use safe calls `?.`, let blocks, or `?:` (Elvis operator) |
| `kotlin.UninitializedPropertyAccessException` | Accessing a `lateinit` property before initialization | Initialize the property; use `::isInitialized` to check |
| `IllegalStateException: Already resumed` | Resuming a coroutine continuation more than once | Ensure `Continuation.resume()` is called exactly once |
| `ClassCastException` | Unsafe cast with `as` operator on incompatible type | Use safe cast `as?` which returns null instead of throwing |
| `StackOverflowError` | Infinite recursion (often in data class `toString()` or `equals()` with circular references) | Break circular references; implement custom `toString()`/`equals()` |
| `ConcurrentModificationException` | Modifying a collection while iterating | Use `toList()` to copy, or use `iterator.remove()` |
| `NoWhenBranchMatchedException` | Exhaustive `when` missing a branch (sealed class/subclass) | Add `else` branch or handle all cases for sealed classes |
| `CancellationException` | Coroutine was cancelled | Handle cancellation gracefully; use `try/catch` or `isActive` checks |

### Kotlin-Specific Debugging Tips

- Kotlin promises null safety but `!!` bypasses it entirely. Treat `!!` like a code smell — it's an admission that you don't know if the value is null
- `lateinit var` is useful but dangerous. If possible, use constructor injection or lazy initialization instead
- Kotlin coroutines: `runBlocking` blocks the current thread. Never use it in production async code — only in main() and tests
- `suspend` functions can only be called from a coroutine or another suspend function. Use `CoroutineScope.launch` or `withContext` from non-suspend code
- Kotlin's `==` calls `.equals()` (structural equality). `===` checks referential equality. This is different from Java
- Data classes auto-generate `equals()`, `hashCode()`, `toString()`, `copy()`. But circular references in data classes cause StackOverflow in these methods
- Extension functions don't modify the original class. They're statically resolved at compile time. This matters for polymorphism
- `Sequence` vs `List`: sequences are lazy (like Python generators). Use `asSequence()` for chained operations on large collections
- `by lazy { }` is thread-safe by default (uses `LazyThreadSafetyMode.SYNCHRONIZED`). Be aware of the synchronization overhead
- Companion objects are Kotlin's equivalent of Java static members. But they're actual objects and can implement interfaces
- In Android: lifecycle-aware components (viewModelScope, lifecycleScope) auto-cancel coroutines. Don't use GlobalScope

### Kotlin Debugging Tools

- Android Studio / IntelliJ Debugger — breakpoints, evaluate expressions, coroutine debugger
- `println()` / `Log.d()` for Android logging
- Kotlin Coroutines Debugging: enable `-Dkotlinx.coroutines.debug` JVM flag to see coroutine names in debugger
- Android Profiler — CPU, memory, network profiling
- LeakCanary — detect memory leaks in Android apps
