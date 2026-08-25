---
name: debugging
description: >-
  Systematically find and fix bugs. Evidence → Hypothesis → Experiment → Root Cause → Minimal Fix → Verify.
  TRIGGERS: debug, debugging, bug, error, exception, crash, stack trace, traceback, fails, broken,
  not working, wrong output, timeout, infinite loop, race condition, deadlock, memory leak,
  connection error, build failure, compilation error, syntax error, runtime error, type error,
  reference error, segfault, panic, assertion error, agent loop, tool call failure,
  context overflow, token limit, hallucinated tool, invalid arguments,
  عیب‌یابی, رفع باگ, خطا, ایراد, مشکل کد, کار نمیکنه, ارور میده, کرش میکنه,
  هنگ کرده, بی‌نهایت لوپ, تایم‌اوت, اتصال قطع شده, بیلد ناموفق
priority: P0
dependencies: [project-analysis]
conflicts: [refactoring]
---

# Debugging Skill

## Purpose

Find and fix bugs systematically. NO GUESSING. Evidence → Hypothesis → Experiment → Root Cause → Minimal Fix → Verify.

## When to Activate

- Any error, exception, or crash
- Wrong output or unexpected behavior
- Timeout, hang, or infinite loop
- Build or compilation failure
- Agent loop or tool call failure
- User says "it's broken" or "fix this"

## When NOT to Activate

- Writing new code (→ code-generation)
- User wants code review (→ code-review)
- No actual bug present

## Inputs Required

- Error message, stack trace, or description of wrong behavior
- File(s) involved
- Expected vs actual behavior

## Preconditions

- Error information available (or can be reproduced)

## Workflow

### Phase 1: Gather Evidence (NEVER skip)

```
1. READ the error message carefully
   - What is the EXACT error type?
   - Which file and line?
   - What is the call stack?

2. READ the relevant code
   - Understand what the code is SUPPOSED to do
   - Identify the failure point

3. REPRODUCE the bug
   - Can you make it happen consistently?
   - What are the exact steps?
```

### Phase 2: Form Hypotheses

```
List ALL possible causes:
1. [Most likely cause]
2. [Second possibility]
3. [Less likely but possible]

For each hypothesis:
- What EVIDENCE supports it?
- What EVIDENCE contradicts it?
- How can I TEST it?
```

### Phase 3: Test Hypotheses

```
For each hypothesis (in order of likelihood):
1. Design a minimal experiment
2. Run the experiment
3. Record the result
4. Accept or reject the hypothesis
```

### Phase 4: Identify Root Cause

```
Ask "WHY?" repeatedly:
- Why did this happen? → [cause]
- Why did [cause] happen? → [deeper cause]
- Why did [deeper cause] happen? → [root cause]

Stop when you reach a cause you can fix.
```

### Phase 5: Apply Minimal Fix

```
1. What is the SMALLEST change that fixes the root cause?
2. Does this fix break anything else?
3. Does this fix introduce new issues?
4. Is there a simpler fix?
```

### Phase 6: Verify Fix

```
1. Does the original bug still occur?
2. Do existing tests still pass?
3. Does the fix handle edge cases?
4. Is there a regression?
```

## Decision Tree

```
What type of bug?
├── Syntax/Compile Error → Fix the syntax
├── Runtime Error → Trace execution, find failure point
├── Logic Error → Compare expected vs actual behavior
├── Concurrency Bug → Check shared state, locks, timing
├── Integration Bug → Check API contracts, data formats
├── Performance Bug → Profile, find bottleneck
├── Agent/Tool Bug → Check tool calls, context, tokens
└── Unknown → Start with evidence gathering
```

## Debugging Patterns by Bug Type

### Syntax/Compile Error
```
1. Read the error message
2. Go to the exact line
3. Fix the syntax
4. Verify compilation
```

### Runtime Error
```
1. Parse stack trace
2. Find the failure point
3. Add logging/print statements
4. Trace variable values
5. Find the invalid state
6. Fix the cause
```

### Logic Error
```
1. Define expected behavior
2. Trace actual behavior
3. Find where they diverge
4. Fix the divergence
```

### Concurrency Bug
```
1. Identify shared state
2. Check synchronization
3. Look for race conditions
4. Add proper locking
5. Test under load
```

### Agent/Tool Bug
```
1. Check tool arguments
2. Check tool availability
3. Check context size
4. Check token limits
5. Check for infinite loops
6. Verify tool responses
```

## Execution Rules

- NEVER guess — always verify with evidence
- NEVER fix without understanding root cause
- ALWAYS apply minimal fix
- ALWAYS verify fix works
- ALWAYS check for regressions
- STOP if fix is too complex — reassess

## Verification

- [ ] Root cause identified with evidence
- [ ] Fix is minimal and targeted
- [ ] Original bug is fixed
- [ ] No regressions introduced
- [ ] Edge cases handled

## Failure Handling

- If root cause unclear → Add more logging, reproduce again
- If fix is complex → Consider if this is actually a refactor task
- If can't reproduce → Document conditions, ask user for more info

## Safety Constraints

- Do NOT guess root cause
- Do NOT apply multiple fixes at once
- Do NOT change code you don't understand
- Do NOT claim fix works without verification
- Do NOT skip regression checking

## Output Format

```
## Debug Report

### Problem
[What is wrong]

### Evidence
[Error messages, stack traces, observations]

### Hypotheses
1. [Likelihood]: [hypothesis] — [evidence for/against]
2. [Likelihood]: [hypothesis] — [evidence for/against]

### Root Cause
[The actual cause, with evidence]

### Fix
[What was changed and why]

### Files Changed
- [file1]: [what changed]
- [file2]: [what changed]

### Verification
- [ ] Original bug fixed
- [ ] Tests pass
- [ ] No regressions

### Remaining Issues
[Anything else that needs attention]
```

## Anti-Patterns

- ❌ Guessing root cause without evidence
- ❌ Applying multiple fixes at once
- ❌ Changing code you don't understand
- ❌ Claiming fix works without verification
- ❌ Skipping regression check
- ❌ "It should work now" without testing
- ❌ Fixing symptoms instead of root cause
- ❌ Deleting error handling to "fix" errors

## Skill Interactions

- ← project-analysis: Understand codebase context
- → verification: Verify fix works
- → testing: Create regression test
- → code-review: Review the fix
