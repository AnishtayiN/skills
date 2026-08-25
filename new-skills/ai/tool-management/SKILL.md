---
name: tool-management
description: >-
  Manage tool calls: validation, error recovery, retry strategies, tool routing,
  parallel execution, timeout handling, rate limiting, and result parsing.
  TRIGGERS: tool call, tool error, tool failure, tool not found, invalid arguments,
  tool retry, tool routing, hallucinated tool, tool validation, tool timeout,
  parallel tools, rate limit, tool schema, tool parsing,
  فراخوانی ابزار, خطای ابزار, ابزار پیدا نشد, اعتبارسنجی ابزار,
  محدودیت ابزار, اجرای موازی ابزار
priority: P1
dependencies: [agent-orchestration, context-management]
conflicts: []
---

# Tool Management Skill

## Purpose

Manage tool calls effectively throughout their entire lifecycle: validate inputs,
handle errors with intelligent retry strategies, prevent infinite loops, execute
tools in parallel when safe, respect rate limits, parse and validate results,
and recover gracefully from any failure mode. This skill ensures that every
tool interaction is robust, efficient, and predictable.

## When to Activate

- Tool call fails with any error
- Tool returns unexpected or malformed result
- Agent is stuck in a tool retry loop
- User mentions tool issues, timeouts, or failures
- Multiple independent tool calls are needed simultaneously
- Tool rate limit is being approached
- Tool schema validation fails
- Tool call takes longer than expected

## When NOT to Activate

- Simple single tool call that succeeds on first try
- User provides exact tool call with known-good arguments
- Tool is being used correctly and returning expected results

## Inputs Required

- Tool name and schema definition
- Arguments to be passed to the tool
- Previous error history (if retrying)
- Tool availability status

## Preconditions

- Tool registry is accessible
- Tool schemas are defined and versioned
- Rate limit configuration is loaded
- Error classification taxonomy is available

---

## Workflow

### Step 1: Validate Tool Call

```
Before calling ANY tool:
1. Is the tool name registered and available?
2. Is the tool currently in a usable state (not disabled, not rate-limited)?
3. Do all REQUIRED arguments have values?
4. Are argument TYPES correct (string, number, array, object)?
5. Are argument VALUES within acceptable ranges?
6. Does the tool schema match the expected version?
7. Is this the appropriate tool for the current task?
8. Have you checked for tools with overlapping functionality?
```

### Step 2: Execute with Safety

```
During tool execution:
1. Set appropriate timeout based on tool type
2. If parallel-safe, batch independent calls
3. If sequential, respect dependency ordering
4. Track execution time for performance monitoring
5. Monitor for stuck or hanging calls
```

### Step 3: Parse and Validate Result

```
After tool returns:
1. Check if result matches expected schema
2. Validate data types and structure
3. Check for null/empty/error indicators
4. Extract relevant information
5. Store result for downstream consumption
6. Log result metadata (latency, size, status)
```

### Step 4: Handle Failure

```
If tool fails:
1. READ the error message carefully — do not ignore details
2. CLASSIFY the error:
   - TRANSIENT: network timeout, temporary service unavailable
   - PERMANENT: invalid arguments, tool not found, permission denied
   - RATE_LIMITED: too many requests, quota exceeded
   - SCHEMA_MISMATCH: unexpected result format
   - DEPENDENCY_FAILURE: upstream service down
3. Based on classification:
   - TRANSIENT → retry with backoff (max 3 attempts)
   - PERMANENT → fix the cause, do NOT retry blindly
   - RATE_LIMITED → wait or switch to alternative tool
   - SCHEMA_MISMATCH → report and adapt
   - DEPENDENCY_FAILURE → report to user
4. NEVER retry the same failed call without changing something
```

### Step 5: Prevent Loops

```
Loop prevention rules:
- Maximum 3 retries for the same tool with same arguments
- Maximum 5 retries for the same tool with DIFFERENT arguments
- After 3 consecutive failures → switch approach entirely
- After 5 total failures for a task → stop and report to user
- Never call a tool that does not exist
- Never hallucinate tool outputs
- Never create circular tool dependencies
```

---

## Advanced Techniques

### Technique 1: Tool Call Validation Pipeline

Build a multi-stage validation pipeline that catches errors before execution:

```javascript
// Stage 1: Schema validation
function validateToolSchema(toolName, args, schema) {
  const required = schema.required || [];
  const properties = schema.properties || {};

  for (const field of required) {
    if (args[field] === undefined || args[field] === null) {
      throw new ToolValidationError(`Missing required field: ${field}`);
    }
  }

  for (const [key, value] of Object.entries(args)) {
    const propSchema = properties[key];
    if (propSchema) {
      if (propSchema.type === 'string' && typeof value !== 'string') {
        throw new ToolValidationError(`Field ${key} must be string, got ${typeof value}`);
      }
      if (propSchema.type === 'number' && typeof value !== 'number') {
        throw new ToolValidationError(`Field ${key} must be number, got ${typeof value}`);
      }
      if (propSchema.enum && !propSchema.enum.includes(value)) {
        throw new ToolValidationError(`Field ${key} value "${value}" not in allowed: ${propSchema.enum.join(', ')}`);
      }
    }
  }

  return true;
}

// Stage 2: Pre-flight checks
function preflightCheck(toolName, context) {
  const tool = registry.get(toolName);
  if (!tool) throw new ToolNotFoundError(`Tool "${toolName}" not registered`);
  if (tool.disabled) throw new ToolDisabledError(`Tool "${toolName}" is disabled`);
  if (rateLimiter.isLimited(toolName)) throw new RateLimitError(`Tool "${toolName}" is rate-limited`);
  if (tool.requiresContext && !context.has(tool.requiresContext)) {
    throw new ContextError(`Tool "${toolName}" requires context "${tool.requiresContext}"`);
  }
  return true;
}
```

### Technique 2: Intelligent Retry Strategies

Implement different retry strategies based on error type:

```javascript
// Exponential backoff with jitter for transient errors
async function retryWithBackoff(fn, maxAttempts = 3, baseDelay = 1000) {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxAttempts - 1) throw error;
      if (!isTransientError(error)) throw error;

      const jitter = Math.random() * 1000;
      const delay = baseDelay * Math.pow(2, attempt) + jitter;
      await sleep(delay);
    }
  }
}

// Fixed delay for rate limiting
async function retryWithFixedDelay(fn, maxAttempts = 5, delayMs = 5000) {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxAttempts - 1) throw error;
      if (error.type !== 'RATE_LIMITED') throw error;
      await sleep(delayMs);
    }
  }
}

// Circuit breaker pattern for cascading failures
class CircuitBreaker {
  constructor(threshold = 5, resetTimeout = 60000) {
    this.failures = 0;
    this.threshold = threshold;
    this.resetTimeout = resetTimeout;
    this.state = 'CLOSED';
    this.lastFailureTime = null;
  }

  async call(fn) {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.resetTimeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new CircuitOpenError('Circuit breaker is open');
      }
    }
    try {
      const result = await fn();
      if (this.state === 'HALF_OPEN') this.state = 'CLOSED';
      this.failures = 0;
      return result;
    } catch (error) {
      this.failures++;
      this.lastFailureTime = Date.now();
      if (this.failures >= this.threshold) this.state = 'OPEN';
      throw error;
    }
  }
}
```

### Technique 3: Timeout Handling

Implement tool-specific timeouts with graceful degradation:

```javascript
// Timeout wrapper with abort controller
async function callWithTimeout(toolFn, args, timeoutMs = 30000) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const result = await Promise.race([
      toolFn(args, { signal: controller.signal }),
      new Promise((_, reject) =>
        setTimeout(() => reject(new TimeoutError(`Tool exceeded ${timeoutMs}ms`)), timeoutMs)
      )
    ]);
    clearTimeout(timeoutId);
    return result;
  } catch (error) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new TimeoutError(`Tool call timed out after ${timeoutMs}ms`);
    }
    throw error;
  }
}

// Adaptive timeout based on historical performance
class AdaptiveTimeout {
  constructor(defaultMs = 30000, maxMs = 300000) {
    this.defaultMs = defaultMs;
    this.maxMs = maxMs;
    this.history = new Map(); // toolName -> [latencies]
  }

  getTimeout(toolName) {
    const latencies = this.history.get(toolName) || [];
    if (latencies.length < 3) return this.defaultMs;
    const avg = latencies.reduce((a, b) => a + b, 0) / latencies.length;
    const p95 = this.getPercentile(latencies, 0.95);
    return Math.min(p95 * 2, this.maxMs);
  }

  recordLatency(toolName, latencyMs) {
    if (!this.history.has(toolName)) this.history.set(toolName, []);
    const arr = this.history.get(toolName);
    arr.push(latencyMs);
    if (arr.length > 100) arr.shift(); // Keep last 100
  }

  getPercentile(arr, p) {
    const sorted = [...arr].sort((a, b) => a - b);
    const idx = Math.ceil(sorted.length * p) - 1;
    return sorted[Math.max(0, idx)];
  }
}
```

### Technique 4: Parallel Tool Execution

Safely execute multiple independent tool calls concurrently:

```javascript
// Parallel execution with concurrency limit
async function parallelToolCalls(calls, concurrency = 5) {
  const results = [];
  const executing = new Set();

  for (const call of calls) {
    const promise = callWithTimeout(call.fn, call.args, call.timeout)
      .then(result => ({ status: 'fulfilled', value: result, call }))
      .catch(error => ({ status: 'rejected', reason: error, call }));

    executing.add(promise);
    promise.then(() => executing.delete(promise));

    if (executing.size >= concurrency) {
      await Promise.race(executing);
    }
  }

  return Promise.all([...executing]);
}

// Dependency-aware parallel execution
async function executeWithDependencies(tasks) {
  const completed = new Set();
  const results = new Map();

  while (completed.size < tasks.length) {
    const ready = tasks.filter(t =>
      !completed.has(t.id) &&
      t.dependencies.every(d => completed.has(d))
    );

    if (ready.length === 0) {
      throw new DependencyError('Circular dependency detected or unresolvable deps');
    }

    const batch = ready.map(t =>
      callWithTimeout(t.fn, t.args, t.timeout)
        .then(result => {
          results.set(t.id, result);
          completed.add(t.id);
        })
        .catch(error => {
          results.set(t.id, { error });
          completed.add(t.id); // Mark completed even on error to unblock dependents
        })
    );

    await Promise.all(batch);
  }

  return results;
}
```

### Technique 5: Tool Result Parsing and Validation

Parse and validate tool results against expected schemas:

```javascript
// Result validation with detailed error reporting
function validateToolResult(result, expectedSchema) {
  const errors = [];

  if (expectedSchema.type === 'array') {
    if (!Array.isArray(result)) {
      errors.push(`Expected array, got ${typeof result}`);
      return { valid: false, errors };
    }
    if (expectedSchema.minItems && result.length < expectedSchema.minItems) {
      errors.push(`Array has ${result.length} items, minimum is ${expectedSchema.minItems}`);
    }
    result.forEach((item, idx) => {
      const itemErrors = validateToolResult(item, expectedSchema.items);
      if (!itemErrors.valid) {
        errors.push(`Item[${idx}]: ${itemErrors.errors.join(', ')}`);
      }
    });
  } else if (expectedSchema.type === 'object') {
    if (typeof result !== 'object' || result === null) {
      errors.push(`Expected object, got ${typeof result}`);
      return { valid: false, errors };
    }
    for (const [key, propSchema] of Object.entries(expectedSchema.properties || {})) {
      if (propSchema.required && !(key in result)) {
        errors.push(`Missing required property: ${key}`);
      }
    }
  } else if (expectedSchema.type === 'string') {
    if (typeof result !== 'string') {
      errors.push(`Expected string, got ${typeof result}`);
    }
  }

  return { valid: errors.length === 0, errors };
}

// Safe result extraction with fallbacks
function extractResult(result, path, fallback = null) {
  try {
    const parts = path.split('.');
    let current = result;
    for (const part of parts) {
      if (current === null || current === undefined) return fallback;
      current = current[part];
    }
    return current === undefined ? fallback : current;
  } catch {
    return fallback;
  }
}
```

### Technique 6: Tool Schema Validation

Validate tool schemas themselves at registration time:

```javascript
// Schema definition validation
function validateToolSchema(toolName, schema) {
  const issues = [];

  if (!schema.type) issues.push('Missing "type" in schema');
  if (!schema.properties && schema.type === 'object') {
    issues.push('Object schema missing "properties"');
  }

  for (const [name, prop] of Object.entries(schema.properties || {})) {
    if (!prop.type) issues.push(`Property "${name}" missing "type"`);
    if (prop.type === 'enum' && !prop.values) {
      issues.push(`Enum property "${name}" missing "values"`);
    }
  }

  if (schema.required) {
    for (const field of schema.required) {
      if (!schema.properties?.[field]) {
        issues.push(`Required field "${field}" not in properties`);
      }
    }
  }

  return { valid: issues.length === 0, issues };
}

// Runtime schema migration for backward compatibility
function migrateSchema(toolName, args, fromVersion, toVersion) {
  const migrations = schemaMigrations[toolName];
  if (!migrations) return args;

  let current = { ...args };
  for (const [version, migrator] of Object.entries(migrations)) {
    if (compareVersions(version, fromVersion) > 0 &&
        compareVersions(version, toVersion) <= 0) {
      current = migrator(current);
    }
  }
  return current;
}
```

### Technique 7: Rate Limiting Per Tool

Implement per-tool rate limiting with different strategies:

```javascript
// Token bucket rate limiter
class TokenBucketRateLimiter {
  constructor(toolName, config) {
    this.toolName = toolName;
    this.maxTokens = config.maxTokens || 10;
    this.refillRate = config.refillRate || 1; // tokens per second
    this.tokens = this.maxTokens;
    this.lastRefill = Date.now();
  }

  acquire() {
    this.refill();
    if (this.tokens >= 1) {
      this.tokens--;
      return true;
    }
    return false;
  }

  refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(this.maxTokens, this.tokens + elapsed * this.refillRate);
    this.lastRefill = now;
  }

  getRetryDelay() {
    this.refill();
    if (this.tokens >= 1) return 0;
    return ((1 - this.tokens) / this.refillRate) * 1000;
  }
}

// Sliding window rate limiter
class SlidingWindowRateLimiter {
  constructor(toolName, maxRequests, windowMs) {
    this.toolName = toolName;
    this.maxRequests = maxRequests;
    this.windowMs = windowMs;
    this.timestamps = [];
  }

  canExecute() {
    const now = Date.now();
    this.timestamps = this.timestamps.filter(t => now - t < this.windowMs);
    return this.timestamps.length < this.maxRequests;
  }

  record() {
    this.timestamps.push(Date.now());
  }

  getRetryDelay() {
    const now = Date.now();
    if (this.timestamps.length === 0) return 0;
    const oldest = this.timestamps[0];
    const waitMs = this.windowMs - (now - oldest);
    return Math.max(0, waitMs);
  }
}

// Unified rate limit manager
class ToolRateLimitManager {
  constructor() {
    this.limiters = new Map();
  }

  register(toolName, config) {
    if (config.strategy === 'token-bucket') {
      this.limiters.set(toolName, new TokenBucketRateLimiter(toolName, config));
    } else if (config.strategy === 'sliding-window') {
      this.limiters.set(toolName, new SlidingWindowRateLimiter(toolName, config.maxRequests, config.windowMs));
    }
  }

  async execute(toolName, fn) {
    const limiter = this.limiters.get(toolName);
    if (limiter) {
      if (!limiter.acquire()) {
        const delay = limiter.getRetryDelay();
        await sleep(delay);
        limiter.acquire();
      }
      limiter.record?.();
    }
    return fn();
  }
}
```

---

## Common Patterns

### Pattern 1: Tool Call Wrapper with Full Lifecycle

```javascript
// Complete tool call lifecycle management
async function managedToolCall(toolName, args, options = {}) {
  const {
    timeout = 30000,
    maxRetries = 3,
    retryStrategy = 'exponential',
    validateResult = true,
    onProgress = null,
  } = options;

  // Pre-call validation
  preflightCheck(toolName, context);
  validateToolSchema(toolName, registry.get(toolName).schema);
  validateToolArgs(toolName, args);

  // Rate limiting
  await rateLimiter.acquire(toolName);

  // Execution with retries
  let lastError;
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      onProgress?.({ phase: 'executing', attempt: attempt + 1 });
      const result = await callWithTimeout(
        () => registry.execute(toolName, args),
        timeout
      );

      // Post-call validation
      if (validateResult) {
        const schema = registry.get(toolName).resultSchema;
        const validation = validateToolResult(result, schema);
        if (!validation.valid) {
          throw new SchemaMismatchError(`Result validation failed: ${validation.errors.join(', ')}`);
        }
      }

      // Record success metrics
      metrics.record(toolName, 'success', Date.now() - startTime);
      return result;

    } catch (error) {
      lastError = error;
      metrics.record(toolName, 'error', error.type);

      if (!isRetryable(error) || attempt === maxRetries - 1) break;

      const delay = calculateRetryDelay(attempt, retryStrategy);
      await sleep(delay);
    }
  }

  throw new ToolExecutionError(
    `Tool "${toolName}" failed after ${maxRetries} attempts: ${lastError.message}`
  );
}
```

### Pattern 2: Batch Tool Execution

```javascript
// Execute multiple tool calls efficiently
async function batchToolExecution(calls) {
  // Group by dependencies
  const independent = calls.filter(c => !c.dependencies?.length);
  const dependent = calls.filter(c => c.dependencies?.length);

  // Execute independent calls in parallel
  const independentResults = await parallelToolCalls(independent, {
    concurrency: 5,
    timeout: 30000,
  });

  // Execute dependent calls sequentially
  const allResults = new Map(independentResults.map(r => [r.call.id, r]));
  for (const call of dependent) {
    const deps = call.dependencies.map(d => allResults.get(d));
    if (deps.some(d => d?.status === 'rejected')) {
      allResults.set(call.id, { status: 'skipped', reason: 'dependency failed' });
      continue;
    }
    const result = await managedToolCall(call.toolName, call.args, call.options);
    allResults.set(call.id, { status: 'fulfilled', value: result });
  }

  return allResults;
}
```

### Pattern 3: Tool Call with Circuit Breaker

```javascript
// Resilient tool call with circuit breaker
class ResilientToolCaller {
  constructor() {
    this.breakers = new Map();
  }

  getBreaker(toolName) {
    if (!this.breakers.has(toolName)) {
      this.breakers.set(toolName, new CircuitBreaker(5, 60000));
    }
    return this.breakers.get(toolName);
  }

  async call(toolName, args, fallbackFn = null) {
    const breaker = this.getBreaker(toolName);
    try {
      return await breaker.call(() => registry.execute(toolName, args));
    } catch (error) {
      if (breaker.state === 'OPEN' && fallbackFn) {
        return fallbackFn(args);
      }
      throw error;
    }
  }
}
```

### Pattern 4: Tool Result Transformation Chain

```javascript
// Chain transformations on tool results
class ResultTransformer {
  constructor() {
    this.transforms = [];
  }

  addTransform(name, fn) {
    this.transforms.push({ name, fn });
    return this; // Allow chaining
  }

  async process(result) {
    let current = result;
    for (const transform of this.transforms) {
      try {
        current = await transform.fn(current);
      } catch (error) {
        throw new TransformError(`Transform "${transform.name}" failed: ${error.message}`);
      }
    }
    return current;
  }
}

// Usage
const transformer = new ResultTransformer()
  .addTransform('extract-data', r => r.data)
  .addTransform('filter-nulls', r => r.filter(item => item !== null))
  .addTransform('sort', r => r.sort((a, b) => a.timestamp - b.timestamp));

const cleanResult = await transformer.process(rawToolResult);
```

### Pattern 5: Tool Call Audit Trail

```javascript
// Complete audit trail for tool calls
class ToolAuditTrail {
  constructor(maxEntries = 1000) {
    this.entries = [];
    this.maxEntries = maxEntries;
  }

  log(entry) {
    this.entries.push({
      timestamp: Date.now(),
      toolName: entry.toolName,
      args: entry.args,
      result: entry.result,
      error: entry.error,
      duration: entry.duration,
      attempt: entry.attempt,
      sessionId: entry.sessionId,
    });

    if (this.entries.length > this.maxEntries) {
      this.entries.shift();
    }
  }

  getHistory(toolName, limit = 50) {
    return this.entries
      .filter(e => !toolName || e.toolName === toolName)
      .slice(-limit);
  }

  getErrorRate(toolName, windowMs = 300000) {
    const cutoff = Date.now() - windowMs;
    const recent = this.entries.filter(e => e.timestamp > cutoff && e.toolName === toolName);
    if (recent.length === 0) return 0;
    return recent.filter(e => e.error).length / recent.length;
  }

  getAverageLatency(toolName, windowMs = 300000) {
    const cutoff = Date.now() - windowMs;
    const recent = this.entries.filter(
      e => e.timestamp > cutoff && e.toolName === toolName && !e.error
    );
    if (recent.length === 0) return 0;
    return recent.reduce((sum, e) => sum + e.duration, 0) / recent.length;
  }
}
```

---

## Edge Cases & Pitfalls

### 1. Race Condition in Parallel Calls
Two parallel tool calls may modify shared state unexpectedly. Always use mutex locks or sequence dependent calls.

### 2. Timeout Kills Successful Call
A tool may succeed just after the timeout fires. The result is lost and the call is reported as failed. Use AbortController to cancel the underlying operation, not just the promise.

### 3. Rate Limit Reset Timing
Rate limit windows may reset at unexpected times (server time vs local time). Always handle 429 responses gracefully and respect Retry-After headers.

### 4. Schema Version Mismatch
Tool schemas evolve over time. Old arguments may be silently accepted but produce unexpected results. Always validate against the current schema version.

### 5. Infinite Recursion via Tool Calls
A tool may internally trigger the same tool call, causing infinite recursion. Detect and break circular call chains using a call stack tracker.

### 6. Partial Result on Timeout
A tool may return partial results before timing down. Always check if the result is complete before using it.

### 7. Memory Leak from Unreleased Resources
Tool calls that allocate resources (file handles, connections) must clean up on failure. Use try/finally or explicit cleanup handlers.

### 8. Silent Failure Modes
Some tools return success status but include error information in the payload. Always inspect the full response structure, not just the status code.

### 9. Argument Type Coercion
String arguments passed where numbers are expected (or vice versa) may cause subtle bugs. Enforce strict type validation before calling.

### 10. Tool Hallucination Detection
Never assume a tool call succeeded without inspecting the result. Compare result structure against expected schema before trusting data.

### 11. Concurrent Modification of Shared State
Multiple tools modifying the same file or data structure simultaneously can cause corruption. Serialize access to shared resources.

### 12. Stale Tool Registry
The list of available tools may change during execution. Refresh the registry periodically or handle ToolNotFoundError gracefully.

### 13. Error Message Information Leakage
Tool error messages may contain sensitive information (API keys, internal paths). Sanitize error messages before presenting to users.

### 14. Tool Call Idempotency
Some tools are not idempotent (calling twice produces different results). Track which calls have been made and avoid duplicate execution.

### 15. Cascading Failure Propagation
One failing tool can cause downstream tools to fail. Implement bulkhead patterns to isolate failures and prevent cascade.

---

## Integration with Other Skills

| Skill | Relationship | Integration Point |
|-------|-------------|-------------------|
| agent-orchestration | Parent | Tool calls are executed within agent workflows; this skill provides the execution engine |
| context-management | Sibling | Tool results consume context tokens; coordinate to avoid context overflow |
| debugging | Downstream | Tool failures are investigated using debugging skill patterns |
| project-analysis | Upstream | Tool availability may depend on project dependencies and configuration |
| requirement-analysis | Upstream | Requirements determine which tools are needed |
| task-planning | Sibling | Tool availability influences task planning; parallel tools enable parallel tasks |
| code-generation | Downstream | Generated code may invoke tools; validation prevents invalid calls |
| verification | Downstream | Tool call success is verified using verification skill patterns |
| error-handling | Sibling | Shared error classification taxonomy and recovery strategies |
| performance-optimization | Sibling | Tool call latency and throughput are performance-critical metrics |

---

## Output Format Templates

### Template 1: Tool Call Report

```
## Tool Call Report

### Call Details
- **Tool:** [tool-name]
- **Arguments:** { [key]: [value], ... }
- **Timestamp:** [ISO timestamp]
- **Attempt:** [1 of max]

### Result
- **Status:** SUCCESS | FAILED | TIMEOUT | RATE_LIMITED
- **Duration:** [ms]
- **Response Size:** [bytes]

### Validation
- **Schema Valid:** YES | NO
- **Type Check:** PASS | FAIL

### Error (if failed)
- **Error Type:** [TRANSIENT | PERMANENT | RATE_LIMITED | SCHEMA_MISMATCH]
- **Message:** [error message]
- **Retryable:** YES | NO
- **Suggested Action:** [what to do next]
```

### Template 2: Batch Execution Report

```
## Batch Tool Execution Report

### Summary
- **Total Calls:** [N]
- **Successful:** [N]
- **Failed:** [N]
- **Skipped:** [N]
- **Total Duration:** [ms]

### Results
| # | Tool | Status | Duration | Error |
|---|------|--------|----------|-------|
| 1 | [tool] | ✅ | [ms] | - |
| 2 | [tool] | ❌ | [ms] | [reason] |

### Performance
- **Average Latency:** [ms]
- **P95 Latency:** [ms]
- **Slowest Call:** [tool] ([ms])
```

### Template 3: Error Diagnosis Report

```
## Tool Error Diagnosis

### Error Summary
- **Tool:** [tool-name]
- **Error Type:** [type]
- **Frequency:** [N] times in last [window]
- **Error Rate:** [%]

### Root Cause Analysis
1. **Symptom:** [what happened]
2. **Cause:** [why it happened]
3. **Impact:** [what is affected]

### Remediation Steps
1. [step 1]
2. [step 2]
3. [step 3]

### Prevention
- [preventive measure 1]
- [preventive measure 2]
```

### Template 4: Rate Limit Status

```
## Tool Rate Limit Status

### Current Limits
| Tool | Strategy | Limit | Used | Remaining | Reset At |
|------|----------|-------|------|-----------|----------|
| [tool] | [strategy] | [N] | [N] | [N] | [time] |

### Recommendations
- [recommendation 1]
- [recommendation 2]

### Alternative Tools
- If [tool] is limited, consider: [alternative-tool]
```

---

## Rules

1. **Always validate tool arguments before calling.** Never pass raw user input directly to a tool without type checking and sanitization.

2. **Never retry the same failed call without changing something.** At minimum, change an argument, adjust timeout, or switch to an alternative approach.

3. **Maximum 3 retries for transient errors, maximum 5 for rate limits.** After exhausting retries, stop and report to the user with full error context.

4. **Never hallucinate tool outputs.** If a tool call fails, report the failure honestly. Do not fabricate what the tool "would have returned."

5. **Always check tool availability before calling.** A tool may be disabled, rate-limited, or unavailable due to missing dependencies.

6. **Use appropriate timeout for each tool type.** File operations need shorter timeouts than network calls. Use adaptive timeouts when historical data is available.

7. **Validate tool results against expected schemas.** Never trust tool output without structural validation. A malformed result can propagate errors downstream.

8. **Track all tool calls in an audit trail.** Every call, argument, result, and error must be logged for debugging and performance analysis.

9. **Respect rate limits proactively.** Check current usage before calling. Use exponential backoff when limits are hit. Never attempt to bypass rate limits.

10. **Clean up resources on failure.** Use try/finally blocks to ensure temporary files, connections, or locks are released even when errors occur.

11. **Prefer parallel execution for independent calls.** But always respect concurrency limits to avoid overwhelming downstream services.

12. **Document tool call patterns for reuse.** If a tool call sequence solves a common problem, extract it as a reusable pattern or template.

13. **Escalate to the user after 3 consecutive failures.** Do not continue retrying indefinitely. The user may need to provide different input or choose an alternative approach.

14. **Never modify tool schemas at runtime without migration.** Schema changes must be backward-compatible or accompanied by explicit migration logic.

15. **Sanitize error messages before user presentation.** Remove internal paths, API keys, and sensitive configuration details from error reports.

---

## Execution Rules

- Always validate tool arguments before calling
- Never retry the same failed call without changes
- Maximum 3 retries for transient errors
- Maximum 5 retries for rate-limited calls
- If all retries fail, stop and report with full context
- Use circuit breakers for tools with repeated failures
- Track audit trail for all tool interactions
- Respect rate limits proactively

## Anti-Patterns

- ❌ Retrying same failed call infinitely without changes
- ❌ Hallucinating tool outputs when calls fail
- ❌ Calling tools with invalid or unvalidated arguments
- ❌ Not checking tool availability before calling
- ❌ Ignoring rate limit headers and response codes
- ❌ Running parallel calls on dependent resources
- ❌ Not cleaning up resources on tool failure
- ❌ Trusting tool results without schema validation
- ❌ Not logging tool calls for debugging
- ❌ Using single timeout value for all tool types

## Skill Interactions

- ← agent-orchestration: Tool calls are orchestrated within agent workflows
- ↔ context-management: Tool results consume context tokens
- → debugging: Tool failures are investigated using debugging patterns
- ← project-analysis: Project dependencies determine tool availability
- ← requirement-analysis: Requirements specify which tools are needed
- ↔ task-planning: Tool capabilities influence task decomposition
- → code-generation: Validated tool calls inform code generation
- → verification: Tool success is verified against acceptance criteria

## Verification Checklist

- [ ] All tool arguments validated before call
- [ ] Retry strategy appropriate for error type
- [ ] Timeout set correctly for tool type
- [ ] Rate limits respected
- [ ] Result validated against schema
- [ ] Audit trail updated
- [ ] Error messages sanitized
- [ ] Resources cleaned up on failure
