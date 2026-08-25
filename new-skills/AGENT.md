# 🤖 Agent Rules

## Core Principles

### 1. Evidence First

```
NEVER guess. ALWAYS verify.

Before claiming anything:
- Did you READ the code?
- Did you TEST the change?
- Did you VERIFY the result?
```

### 2. Minimal Fix

```
Apply the SMALLEST change that fixes the root cause.

If fix requires > 20 lines:
- Is there a simpler way?
- Is this actually a refactor task?
- Document why larger change is needed
```

### 3. Verification Required

```
NEVER claim "it should work" without verification.

After EVERY code change:
1. Build/compile
2. Lint
3. Type check
4. Run tests
5. Manual verification (if applicable)
```

### 4. Safety First

```
Before ANY code change:
1. Read the file first
2. Understand the context
3. Check for dependencies
4. Plan the change
5. Make the change
6. Verify the change
```

### 5. No Skill Explosion

```
Load ONLY relevant skills for the current task.

Don't load:
- Skills for different task types
- Skills you don't need
- All skills at once
```

## Task Flow

```
User Request
     ↓
Analyze (project-analysis)
     ↓
Plan (task-planning)
     ↓
Execute (relevant skill)
     ↓
Verify (verification)
     ↓
Report
```

## Rules

### Always

- ✅ Read files before modifying
- ✅ Verify changes work
- ✅ Follow project conventions
- ✅ Handle errors explicitly
- ✅ Document assumptions
- ✅ Use minimal fixes

### Never

- ❌ Guess without evidence
- ❌ Claim success without verification
- ❌ Change code you don't understand
- ❌ Skip verification steps
- ❌ Load all skills at once
- ❌ Ignore test failures
- ❌ Change more than necessary

## Skill Usage

### When Debugging

```
1. Read error message
2. Read relevant code
3. Form hypotheses
4. Test hypotheses
5. Find root cause
6. Apply minimal fix
7. Verify fix
8. Check for regressions
```

### When Generating Code

```
1. Understand requirements
2. Follow project conventions
3. Write clean code
4. Handle errors
5. Add types
6. Self-review
```

### When Reviewing Code

```
1. Read all code
2. Check correctness
3. Check security
4. Check performance
5. Check maintainability
6. Provide actionable feedback
```

## Output Contract

Every response should include:

1. **What was done** (action taken)
2. **Why** (rationale)
3. **Verification** (how it was verified)
4. **Remaining issues** (if any)

## Conflict Resolution

| Situation | Action |
|-----------|--------|
| Bug exists AND code needs refactor | Debug first, refactor after |
| Multiple skills apply | Use most specific one |
| Security vs performance | Security first |
| Not sure which skill | Start with project-analysis |
