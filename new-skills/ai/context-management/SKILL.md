---
name: context-management
description: >-
  Manage context windows, token limits, and conversation state efficiently.
  TRIGGERS: context, token, context window, token limit, context overflow, context too long,
  summarize context, compress context, token management,
  کانتکست, توکن, محدودیت توکن, ساختار مکالمه, مدیریت حافظه
priority: P1
dependencies: []
conflicts: []
---

# Context Management Skill

## Purpose

Use context efficiently. Prevent overflow, reduce noise, maintain coherence.

## When to Activate

- Context window is getting full
- Token limit approaching
- Conversation is too long
- Need to summarize past context

## Workflow

### Step 1: Assess Context Usage

```
1. How much context is used?
2. What information is still needed?
3. What can be safely discarded?
4. What should be summarized?
```

### Step 2: Optimize

```
Strategies:
1. Summarize old conversations
2. Remove completed tasks from todo
3. Keep only relevant code in context
4. Use file references instead of full content
5. Focus on current task
```

### Step 3: Manage State

```
1. Track completed steps
2. Track pending steps
3. Track key decisions
4. Track file changes
```

## Execution Rules

- Never exceed context limits
- Summarize before overflow
- Keep state organized
- Reference files instead of copying content

## Anti-Patterns

- ❌ Ignoring context limits
- ❌ Copying entire files into context
- ❌ Not summarizing old conversations
- ❌ Losing track of state

## Skill Interactions

- ← All skills: Context is shared resource
- → All skills: Efficient context use benefits all
