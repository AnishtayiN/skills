---
name: debug
description: >-
  Diagnose and fix bugs in any programming language code, with special expertise in AI agent code, LLM pipelines, tool-calling loops, and autonomous system failures. Use this skill whenever the user mentions debugging, fixing errors, troubleshooting code, investigating crashes, resolving exceptions, diagnosing runtime failures, fixing agent loops, or says something isn't working. Also trigger when the user pastes error messages, stack traces, or describes unexpected behavior in their code — even if they don't explicitly say "debug." Additional triggers: دیباگ کردن, رفع باگ, عیب‌یابی, رفع خطا, خرابی, کراپ کردن, اینترنت کار نمیکنه, ارور دارم, استک تریس, اکسپشن, حل مشکل کد, برنامه هنگ کرد, بی‌نهایت لوپ, حلقه بی‌نهایت, مشکل ایجنت, خطای زمان اجرا, خطای کامپایل, memory leak, segfault, race condition, deadlock, why is this failing, it's broken, doesn't work, unexpected behavior, weird output, wrong result, intermittent failure, flaky test, silent failure, error log analysis, crash report, core dump, stack overflow, out of memory, OOM killed, type error, null pointer, nil dereference, panic, unhandled exception, infinite loop, hung process, frozen UI, 500 error, 404 loop, timeout, connection refused, broken pipe, bad gateway, deployment failure, build failure, compilation error, linker error, runtime exception, logic flaw, incorrect output, data corruption, encoding issue, character set problem, locale bug, timezone bug, regression, introduced bug, broke after update, broke after merge, works locally but not in prod, works on my machine, CI failure, test flakiness, non-deterministic, heisenbug, schrödinbug, month of Sundays bug, how do I fix this, what's wrong with my code, help me debug, look at this error, can you find the bug, something is off, this shouldn't happen, it was working yesterday,突然不工作了, 报错了, 调试, 修bug, 出错了, 崩溃了, 内存泄漏, 空指针, 段错误, 死锁, 竞态条件.
---

# Debug Skill — Universal Code & Agent Debugger

## Overview

This skill enables systematic debugging of any programming language, with deep specialization in AI/agent code. Debugging is fundamentally about forming hypotheses, testing them, and iterating — not about guessing. The instructions below guide you through a structured process that works for everything from a one-line Python syntax error to a mysterious agent infinite-loop that only manifests at 3am on Thursdays.

The debug skill treats every problem as a detective case: gather evidence, form hypotheses, test them against the code, narrow down the suspect list, and identify the root cause before proposing any fix. This discipline prevents the #1 debugging mistake: "fixing" a symptom while the real bug remains hidden.

## When to Use This Skill

- User reports an error, exception, or crash
- Code produces wrong output or unexpected behavior
- Agent or LLM pipeline behaves incorrectly (loops, hallucinations, tool failures)
- Performance issues (slow code, memory leaks, high CPU)
- Security vulnerabilities or best-practice violations
- User asks "why isn't this working?" or "fix my code"
- User shares a stack trace, error log, or panic message
- User describes a problem behaviorally without sharing code
- User says their code "used to work but broke after X"
- Tests are failing after a refactor or dependency update
- Intermittent or non-deterministic failures (flaky tests, race conditions)
- User needs help reading and understanding a complex error message
- CI/CD pipeline fails with cryptic error messages
- Application hangs, freezes, or becomes unresponsive
- Memory issues: OOM kills, leaks, growing heap, unbounded caches
- Deployment or build failures after dependency changes
- Encoding/charset/locale/timezone-related data corruption
- Network-related failures: connection refused, timeout, DNS resolution
- Database-related: deadlocks, constraint violations, connection pool exhaustion

## Debugging Workflow

### Phase 1: Gather Information

Before proposing any fix, understand the problem completely. Most debugging failures come from fixing the wrong thing.

**1a. Read the code**
- Use Read tool to examine the file(s) the user mentions.
- If they don't mention files, ask which file contains the problematic code.
- Read related files if the error involves imports, dependencies, or cross-module calls.
- If the user mentions a recent change, use `git log` or `git diff` to see what changed.

**1b. Identify the language and framework**
- Detect the programming language, framework, and key dependencies from file extensions, imports, and syntax.
- Check for config files (package.json, requirements.txt, Cargo.toml, go.mod, pom.xml) to understand the dependency tree.
- Note the runtime version if visible — many bugs are version-specific.

**1c. Parse the error message**
- What is the exact error type? (e.g., TypeError, NullPointerException, E0382)
- Which file and line number? Note that the *reported* line may not be the *root cause* line.
- What is the call stack telling you about the execution path? Trace from top (most recent) to bottom (entry point).
- Is it a compile-time error, runtime error, or logical error?
- Are there chained/causal errors? The first error in a chain is usually the root cause.

**1d. Understand the intent**
- What is this code *supposed* to do? If unclear, ask the user.
- A "bug" is only a bug relative to an expectation.
- Check if there are tests or documentation that define expected behavior.

**1e. Collect environment context**
- What OS and runtime version?
- What environment variables are set? (check .env files, docker-compose.yml)
- Is this running locally, in CI/CD, or in production?
- Were there recent dependency updates? (`package-lock.json` changes, `pip freeze` diffs)

### Phase 2: Classify the Bug

Categorize the problem to select the right debugging strategy:

| Category | Signs | Common in |
|----------|-------|----------|
| **Syntax Error** | Parser rejects the code, won't compile/run | All languages |
| **Runtime Error** | Code starts but crashes (exceptions, segfaults) | All languages |
| **Logic Error** | Code runs but produces wrong results | All languages |
| **Concurrency Bug** | Race conditions, deadlocks, non-deterministic failures | JS, Python, Go, Java, Rust |
| **Agent/Loop Bug** | Infinite loops, repeated tool calls, stuck agents | AI agent code, LLM pipelines |
| **Performance Bug** | Slow execution, high memory, timeouts | All languages, especially Python |
| **Integration Bug** | API failures, wrong data formats, auth issues | Web apps, agents calling external tools |
| **Security Bug** | Injections, exposed secrets, unsafe deserialization | All languages |
| **Environment Bug** | Works on my machine, config mismatch, missing env vars | All languages |
| **Dependency Bug** | Breaking changes, version conflicts, missing packages | All languages |
| **Memory Bug** | Leaks, use-after-free, buffer overflows, OOM kills | C/C++, Rust, Go, Java, Python, JS |
| **Data Bug** | Encoding issues, timezone offsets, floating-point precision | All languages |

### Phase 3: Diagnose Root Cause

For each bug category, apply targeted analysis:

#### For Syntax Errors
- Check for mismatched brackets, parentheses, quotes
- Verify indentation (Python) or semicolons (JS/C/Java)
- Look for typos in keywords, function names, variable names
- Check import statements and module paths
- In YAML/TOML configs: check indentation (spaces vs tabs), colons in unquoted strings
- In regex: check for unescaped special characters

#### For Runtime Errors
- Trace the execution path that leads to the crash
- Check variable types and values at the point of failure
- Look for null/undefined access, division by zero, index out of bounds
- Verify that all required resources (files, connections, handles) exist
- Check for resource exhaustion (file descriptors, memory, connections)
- Verify exception handling doesn't swallow the real error

#### For Logic Errors
- Add mental print statements: what are the variable values at each step?
- Check boundary conditions (empty inputs, zero, negative numbers, very large values)
- Verify control flow: are if/else conditions correct? Are loops terminating?
- Compare the algorithm against the intended behavior step by step
- Look for integer overflow, floating-point precision issues, timezone problems
- Check for off-by-one errors (especially in loops and array indexing)
- Verify string comparisons (case sensitivity, whitespace, encoding)

#### For Agent/Loop Bugs (AI-Specific)
- **Infinite tool-call loops**: Check if the agent has a termination condition. Does it know when to stop calling tools? Is the prompt clear about completion criteria?
- **Repeated failures**: Look at error handling — is the agent retrying without backoff or without changing its approach?
- **Context window overflow**: Is the agent accumulating too much context? Check if conversation history is being truncated or summarized.
- **Tool call format errors**: Verify the tool call schema matches what the tool expects. Check parameter names, types, and required fields.
- **Hallucinated tool names**: Ensure the agent can only call tools that actually exist. Check the tool list in the system prompt.
- **Stuck in planning**: If the agent keeps planning but never acts, check if the prompt gives it permission to use tools and take actions.
- **Degraded output over turns**: Quality drops as conversation grows — check context management and token budgets.
- **Tool execution order**: Agent calls tools in wrong sequence, e.g., tries to read a file before creating it.

#### For Performance Bugs
- Identify the hot path: which function/loop consumes the most time?
- Look for O(n^2) or worse algorithms where O(n) or O(n log n) would work
- Check for unnecessary re-computation (caching opportunities)
- Look for N+1 query patterns (especially in database code)
- Check for large data structures being copied unnecessarily
- In Python: look for global interpreter lock issues, missing async/await
- In JS: look for blocking operations in the event loop, missing promise handling
- Profile if possible: suggest `cProfile`, `perf`, Chrome DevTools, or language-specific profilers

#### For Concurrency Bugs
- Check shared mutable state without proper synchronization
- Look for race conditions in async code (missing await, fire-and-forget)
- Verify deadlock potential (circular lock dependencies)
- Check for resource leaks (unclosed connections, file handles)
- Look for callback hell or promise chain breakage
- Check for starvation — some goroutines/tasks never getting scheduled

#### For Integration Bugs
- Verify the request/response format matches the API contract
- Check authentication headers, tokens, and their expiration
- Look for URL construction errors (missing path segments, wrong query params)
- Check for timeout configurations (too short, too long, or missing)
- Verify SSL/TLS certificate handling
- Check for rate limiting being hit
- Look for network DNS resolution failures or connectivity issues

#### For Environment/Dependency Bugs
- Compare working vs. broken environment configurations
- Check for platform-specific path separators, line endings (CRLF vs LF)
- Verify environment variable names and values
- Check dependency version constraints (lock file vs. manifest)
- Look for native module compilation failures (node-gyp, Rust extensions)

### Phase 4: Propose and Apply Fix

Based on the user's preference (from Phase 1), operate in one of two modes:

#### Mode A: Analysis Only (default)

Present the diagnosis in this structure:

```
## Debug Report

**Problem:** [one-line summary of what's wrong]
**Root Cause:** [why it happens — the underlying reason, not just the symptom]
**Location:** [file:line or function name]
**Severity:** [Critical / High / Medium / Low]
**Category:** [Syntax / Runtime / Logic / Concurrency / Agent / Performance / Integration / Security / Memory / Data]

### Evidence
[What specific code, error message, or behavior led to this diagnosis]

### Explanation
[2-4 sentences explaining the mechanics of the bug — why this specific
combination of code + inputs produces this failure]

### Suggested Fix
[Code diff or rewritten code block showing the fix]

### Why This Fix Works
[1-2 sentences connecting the fix back to the root cause]

### Verification Steps
[How to verify the fix works and doesn't introduce regressions]
```

#### Mode B: Auto-Fix (when user explicitly requests it)

1. Apply the fix directly to the file using the Edit tool
2. Explain what was changed and why
3. If multiple fixes are possible, pick the minimal change that resolves the issue
4. If the fix is risky or could have side effects, flag this to the user
5. After applying, run any available tests or suggest verification commands

**Important**: Always start in Analysis Mode unless the user says something like "fix it for me," "apply the fix," or "go ahead and change it."

### Phase 5: Verify and Prevent

After proposing or applying a fix:

1. **Sanity check**: Does the fix actually address the root cause, or just mask the symptom?
2. **Regression check**: Could this fix break something else? Scan for side effects.
3. **Sibling check**: Search for the same pattern in other files — if this bug exists here, it likely exists elsewhere.
4. **Prevention**: Suggest how to prevent similar bugs in the future:
   - Add type hints or assertions
   - Add input validation
   - Add error handling for edge cases
   - Suggest a test case that would have caught this bug
   - Suggest a linting rule or static analysis check

## Language-Specific Notes

For detailed language-specific debugging patterns, read `references/language-patterns.md` when the code is in one of these languages:
- Python, JavaScript/TypeScript, Rust, Go, Java, C/C++, C#, Ruby, PHP, Swift, Kotlin
- SQL, Shell/Bash, YAML/JSON configuration

## Agent-Specific Debugging Patterns

For AI agent code, these are the most common failure modes and their fixes:

### 1. Agent Stuck in a Loop
- **Symptom**: Agent keeps calling the same tool with the same arguments
- **Cause**: No state tracking, or the agent doesn't recognize it's making no progress
- **Fix**: Add a "seen actions" tracker; if the agent repeats the same action 3+ times, force a different strategy or terminate

### 2. Tool Call Fails Silently
- **Symptom**: Agent claims it did something but nothing changed
- **Cause**: Error in tool response is not being propagated to the agent
- **Fix**: Ensure tool errors are surfaced clearly in the agent's context, not swallowed

### 3. Agent Ignores Instructions
- **Symptom**: Agent doesn't follow system prompt or user instructions
- **Cause**: Instructions are buried in too much context, or are contradictory
- **Fix**: Simplify and prioritize instructions; put the most important constraints last (recency bias)

### 4. Context Window Exhaustion
- **Symptom**: Agent's quality degrades over time, starts forgetting things
- **Cause**: Conversation history exceeds context window, older messages are truncated
- **Fix**: Implement conversation summarization or sliding window with key information extraction

### 5. Wrong Tool Arguments
- **Symptom**: Tool calls fail with schema validation errors
- **Cause**: Agent hallucinates parameter names or types
- **Fix**: Include the tool schema in the prompt; use structured output formats

### 6. Agent Calls Non-Existent Tools
- **Symptom**: Tool name in the call doesn't match any registered tool
- **Cause**: Tool list in the system prompt is outdated or the agent hallucinated
- **Fix**: Validate tool names against the registered list before execution; return a clear error listing available tools

### 7. Partial Tool Execution with No Rollback
- **Symptom**: Agent partially completes a multi-step task, leaves system in inconsistent state
- **Cause**: No transactional boundary around multi-tool operations
- **Fix**: Implement compensating actions or rollback logic for multi-step agent workflows

## Advanced Techniques

### Binary Search Debugging
When the failure point is unclear in a long execution, use binary search to isolate it:
1. Add a checkpoint/log at the midpoint of the execution path
2. Determine if the bug has already manifested by that point
3. Narrow to the half where the bug originates
4. Repeat until the exact location is found

### Delta Debugging
For intermittent failures that depend on input:
1. Start with a minimal failing input
2. Remove parts of the input and check if it still fails
3. Keep removing until you find the smallest input that triggers the bug
4. This often reveals the exact condition that causes the failure

### Hypothesis-Driven Debugging
1. Form a clear hypothesis: "The bug is caused by X"
2. Predict what you'd observe if the hypothesis is true
3. Check the code — does it match the prediction?
4. If yes, you've found the root cause. If no, form a new hypothesis.
5. Never skip steps 2-3 — this is what separates systematic debugging from guessing

### Reproduction-First Debugging
1. Before analyzing any code, try to reproduce the bug with the simplest possible input
2. A bug you can't reproduce is a bug you can't verify is fixed
3. For intermittent bugs, identify the conditions that make it more likely (load, timing, specific input values)
4. Write a reproduction script if possible — this becomes a regression test

### Rubber Duck Debugging via Explanation
1. Explain the code aloud (or in writing) as if teaching someone who knows nothing
2. The act of explaining often reveals the bug, because you're forced to state assumptions explicitly
3. Pay attention to moments where your explanation feels vague — that's where the bug usually hides

### Time-Travel Debugging
1. When available (e.g., Rust's `rr`, Python's `birdseye`, JS debugger), use time-travel to step backwards from the error
2. If not available, add strategic logging at key points and re-run
3. Focus on the state transitions: what changed between the last known-good state and the failure state?

### Fault Injection
1. Deliberately inject failures (null inputs, network timeouts, empty responses) to find unhandled edge cases
2. Use chaos engineering principles: if the system can't handle a component failing, it has a fragility bug
3. Check what happens when external dependencies return unexpected data types or formats

### Differential Debugging
1. Compare a working version with the broken version using git diff
2. Identify the exact change that introduced the bug
3. If the change is large, use `git bisect` to binary-search through commits

## Common Patterns

### Pattern 1: The Null Cascade
A function returns null/None/undefined, and every caller either crashes or passes null to the next caller, creating a cascade of failures.
```
# Typical: getUser returns None, getOrders crashes on None.user_id
# Fix: Handle None at the source or use Option/Monad types
```

### Pattern 2: The Stale Closure
In JavaScript/Python, a callback or lambda captures a variable by reference, but the variable changes before the callback executes.
```
# JS: for (var i = 0; i < 5; i++) { setTimeout(() => console.log(i), 100); }
# Prints: 5, 5, 5, 5, 5 — because `var` is function-scoped and all closures share the same `i`
# Fix: Use `let` (block-scoped) or capture via IIFE
```

### Pattern 3: The Mutable Default Argument (Python)
```python
def add_item(item, items=[]):  # BUG: [] is created ONCE and shared across all calls
    items.append(item)
    return items
# Fix: def add_item(item, items=None): items = items or []
```

### Pattern 4: The Off-By-One in Pagination
```
# Bug: for page in range(1, total_pages):  # misses last page
# Bug: for page in range(0, total_pages + 1):  # zero-indexed API but 1-indexed loop
# Fix: Verify the indexing convention of both the data source and the loop
```

### Pattern 5: The Silent Exception Swallower
```
try:
    risky_operation()
except:
    pass  # BUG: silently hides ALL errors including KeyboardInterrupt, SystemExit
# Fix: catch specific exceptions only, or at minimum log the error
```

## Edge Cases & Pitfalls

1. **Fixing the symptom, not the cause** — Adding a null check hides a null; find out *why* it's null. The bug will surface elsewhere.
2. **Rewriting large chunks of code** — Big rewrites introduce new bugs. Make the minimal change that fixes the bug.
3. **Assuming without verifying** — Read the actual code, don't reason from memory or assumptions about how the library works.
4. **Ignoring the user's context** — They may have constraints you can't see (old framework version, production restrictions, corporate policies).
5. **Over-explaining** — State the problem, the cause, and the fix. Move on. Don't write a tutorial unless asked.
6. **Trusting the error line number** — The reported line is where the error *manifested*, not necessarily where it was *caused*. Trace backwards.
7. **Changing behavior while debugging** — If the user asked you to debug, don't "also" refactor or add features. Stay focused.
8. **Not checking for the same bug elsewhere** — If a function has a bug, similar functions likely have the same bug. Search the codebase.
9. **Ignoring environment differences** — Code that works locally but fails in CI often has environment-specific issues (env vars, file paths, OS differences).
10. **Not verifying the fix** — Always trace through the code mentally with the fix applied to ensure it actually resolves the issue.
11. **Assuming a single root cause** — Sometimes multiple independent bugs combine to produce a failure. Don't stop after finding the first one.
12. **Blaming the library or framework** — 99% of the time, the bug is in your code, not the library. Always check your usage first.
13. **Over-fixing** — Applying defensive coding everywhere after finding one bug creates complexity. Fix the specific issue, then suggest systemic prevention.
14. **Ignoring log levels** — ERROR-level logs that are actually warnings dilute monitoring. Misclassified logs mask real problems in production.
15. **Not considering the data path** — The bug may not be in the code at all but in the data flowing through it. Check input data, database state, and cached values.

## Integration with Other Skills

- **code-review**: After fixing a bug, a code review can catch similar issues in the same file or related files. Use code-review to audit the surrounding code for the same class of bug.
- **test-generation**: Every bug fix should be accompanied by a regression test. Use the test-generation skill to create one that captures the exact failure condition.
- **refactor**: After the bug is fixed and verified, the code may benefit from refactoring to prevent similar bugs. Structural improvements make the code more resistant to future issues.
- **explain-code**: If the user needs to understand the buggy code before fixing it, use explain-code first to build shared understanding of the code's intent.
- **git-workflow**: If the fix needs to be committed, cherry-picked, or reverted, use the git-workflow skill. Also for `git bisect` to find when a regression was introduced.
- **api-integration**: If the bug is in an API client or integration layer, use api-integration to verify the API contract matches the code's assumptions.
- **security-audit**: If the bug has security implications (injection, data exposure), escalate to the security-audit skill for a thorough vulnerability assessment.
- **database-schema**: If the bug involves data integrity, schema mismatches, or query failures, use database-schema to verify the schema supports the code's assumptions.

## Output Format

Present findings in the user's language. Keep explanations technical but accessible. Use code blocks with language tags. If the user's language is not English, write the report in their language but keep code and technical terms in English.

### Detailed Debug Report Template

```
## Debug Report

**Problem:** [one-line summary]
**Root Cause:** [underlying reason]
**Location:** [file:line or function name]
**Severity:** [Critical / High / Medium / Low]
**Category:** [Syntax / Runtime / Logic / Concurrency / Agent / Performance / Integration / Security / Memory / Data]

### Evidence
- Error message: [exact error]
- Stack trace: [relevant frames]
- Code context: [brief description of surrounding code]
- Reproduction steps: [how to trigger the bug]

### Root Cause Analysis
[Step-by-step explanation of why this happens]

### Fix
```diff
- [problematic code]
+ [fixed code]
```

### Verification
- [ ] Fix resolves the reported error
- [ ] No regressions in related functionality
- [ ] Similar pattern checked in other files
- [ ] Edge cases considered (empty input, null, boundary values)

### Prevention
- [Suggestion to prevent similar bugs]
- [Recommended test case for regression suite]
```

### Quick Fix Template (for simple bugs)

```
**Bug:** [one-line description]
**Cause:** [root cause]
**Fix:** [code snippet or description]
**Verify:** [one-line verification command or assertion]
```

### Agent Debug Report Template

```
## Agent Debug Report

**Agent Type:** [tool-calling / chat / autonomous]
**Symptom:** [what the agent is doing wrong]
**Loop Detection:** [is it stuck in a loop? what action repeats?]
**Context Length:** [approximate token count or message count]

### Diagnosis
[Explanation of the agent's failure mode]

### Fix
- **Prompt change:** [if applicable]
- **Code change:** [if applicable]
- **Configuration change:** [if applicable]

### Prevention
- [Guard rails to add]
- [Monitoring to implement]
- [Test scenario for regression]
```

### Multi-Bug Report Template

```
## Debug Report — Multiple Issues Found

### Issue 1: [Title]
- **Severity:** Critical
- **Location:** file:line
- **Fix:** [description]

### Issue 2: [Title]
- **Severity:** High
- **Location:** file:line
- **Fix:** [description]

### Summary
- Total issues found: [count]
- Critical: [count] | High: [count] | Medium: [count] | Low: [count]
- Recommended fix order: [list]
```

### Performance Debug Report Template

```
## Performance Debug Report

**Symptom:** [slow response, high memory, timeout, etc.]
**Measured Impact:** [latency, throughput, memory usage if known]

### Profiling Data
[Bottleneck location, hot path analysis]

### Root Cause
[Algorithmic, I/O-bound, memory-bound, etc.]

### Recommended Optimization
- **Quick win:** [simple change with immediate impact]
- **Structural fix:** [larger change for fundamental improvement]
- **Expected improvement:** [estimated speedup or reduction]

### Before/After Comparison
| Metric | Before | After (estimated) |
|--------|--------|-------------------|
| Response time | X ms | Y ms |
| Memory usage | X MB | Y MB |
```
