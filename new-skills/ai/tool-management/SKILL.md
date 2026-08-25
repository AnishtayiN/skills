---
name: tool-management
description: >-
  Manage tool calls: validation, error recovery, retry strategies, tool routing.
  TRIGGERS: tool call, tool error, tool failure, tool not found, invalid arguments,
  tool retry, tool routing, hallucinated tool, tool validation,
  فراخوانی ابزار, خطای ابزار, ابزار پیدا نشد, اعتبارسنجی ابزار
priority: P1
dependencies: [agent-orchestration]
conflicts: []
---

# Tool Management Skill

## Purpose

Manage tool calls effectively. Validate inputs, handle errors, prevent loops.

## When to Activate

- Tool call fails
- Tool returns unexpected result
- Agent is stuck in tool retry loop
- User mentions tool issues

## Workflow

### Step 1: Validate Tool Call

```
Before calling a tool:
1. Is the tool available?
2. Are arguments valid?
3. Are arguments complete?
4. Is the tool appropriate for this task?
```

### Step 2: Handle Failure

```
If tool fails:
1. Read the error message
2. Identify the cause
3. Fix the issue (don't just retry)
4. If fixable → fix and retry
5. If not fixable → try alternative approach
6. If no alternative → report to user
```

### Step 3: Prevent Loops

```
Rules:
- Maximum 3 retries for same tool with same arguments
- If tool fails 3 times → change approach
- Never call a tool that doesn't exist
- Never hallucinate tool outputs
```

## Execution Rules

- Always validate tool arguments before calling
- Never retry the same failed call without changes
- Maximum 3 retries
- If all retries fail, stop and report

## Anti-Patterns

- ❌ Retrying same failed call infinitely
- ❌ Hallucinating tool outputs
- ❌ Calling tools with invalid arguments
- ❌ Not checking tool availability

## Skill Interactions

- ← agent-orchestration: Tool calls in agent workflows
- → debugging: Debug tool failures
