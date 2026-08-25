---
name: code-editing
description: >-
  Precisely modify existing code with minimal changes. Edit, patch, update, or modify specific parts.
  TRIGGERS: edit code, modify, change, update, fix this line, replace, patch, adjust, tweak,
  change this, update this, اصلاح کد, تغییر کد, ویرایش, اصلاح این خط, جایگزین کردن,
  修改代码, 编辑, 更改, 更新, 替换, 补丁, 调整
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Code Editing Skill

## Overview

Make precise, minimal changes to existing code. Preserve context, avoid side effects, maintain formatting, and ensure backward compatibility.

## When to Use This Skill

- User asks to change a specific line/function/block
- User wants to update existing behavior
- User provides a patch or diff
- Small targeted modifications
- Merge conflict resolution
- Batch edits across multiple files

## When NOT to Use This Skill

- Writing new code from scratch (→ code-generation)
- Fixing bugs (→ debugging)
- Large-scale restructuring (→ refactoring)

## Inputs Required

- File path
- What to change (exact location)
- What to change to (new code)
- Reason for change

## Preconditions

- File exists and is accessible
- Current code content is known
- No conflicting concurrent edits

## Workflow

### Step 1: Read Current Code

```
1. Read the target file completely
2. Understand the context around the change
3. Identify any dependencies on the code being changed
4. Check for tests that might be affected
5. Understand the import/export relationships
6. Note the formatting style (indentation, quotes, semicolons)
```

### Step 2: Plan Minimal Change

```
1. What is the SMALLEST change that achieves the goal?
2. Will this change break anything else?
3. Are there callers/users of this code?
4. Does the change maintain backward compatibility?
5. Should this edit be split into multiple atomic edits?
6. Is there a safer way to make this change?
```

### Step 3: Make the Edit

```
1. Use edit tool with exact old_string → new_string
2. Preserve indentation and formatting
3. Keep changes focused — one logical change per edit
4. Do NOT reformat unrelated code
5. Verify the edit string is unique in the file
6. If not unique, provide more context in old_string
```

### Step 4: Verify Edit

```
1. Re-read the edited section
2. Check syntax is valid
3. Check no accidental deletions
4. Run related tests if available
5. Verify the change produces the intended behavior
```

## Advanced Techniques

### 1. Minimal Diff Strategy

The goal is to produce the smallest possible diff that achieves the desired change:

```diff
# GOOD: Minimal, focused change
- const user = getUser(id);
+ const user = await getUser(id);

# BAD: Unnecessary reformatting mixed with the real change
- const user = getUser(id);
-   .then(u => u);
+ const user = await getUser(id);
```

**Rules for minimal diffs:**
- Change only the lines that need to change
- Don't reformat surrounding code
- Don't move code unless the move IS the change
- Don't rename variables unless renaming IS the change
- Prefer adding over deleting when both achieve the goal
- Keep whitespace changes in separate edits from logic changes

### 2. Merge Conflict Resolution

When encountering merge conflicts:

```
1. IDENTIFY the nature of each conflict:
   ├── Both sides changed same lines → Need to understand both intentions
   ├── One side deleted, other modified → Decide if deletion was intentional
   ├── Both sides added different code → Usually needs manual integration
   └── Structural conflict (rename + modify) → Apply rename + reapply changes

2. RESOLUTION strategy:
   a. Read both versions completely
   b. Understand the INTENT of each change
   c. If both are correct, MERGE them (not choose one)
   d. If ambiguous, prefer the more recent change
   e. Test thoroughly after resolution
```

**Conflict resolution patterns:**
```python
# Conflict: Both sides modified the same function
# Side A: Added logging
# Side B: Added error handling
# Resolution: Combine both changes

def process_payment(amount: float) -> Result:
    logger.info(f"Processing payment: {amount}")  # From side A
    try:
        result = _charge(amount)
        logger.info(f"Payment successful: {result.id}")
        return Result.success(result)
    except PaymentError as e:
        logger.error(f"Payment failed: {e}")  # From side A
        return Result.failure(e)  # From side B
```

### 3. Batch Editing

When multiple related edits are needed across files:

```
1. PLAN all changes first (don't edit until you have the full picture)
2. GROUP related changes:
   ├── Rename: Update all references atomically
   ├── API change: Update all callers
   ├── Type change: Update all consumers
   └── Config change: Update all environments
3. EXECUTE in dependency order (definitions before usages)
4. VERIFY each file after editing
5. TEST the complete set of changes
```

**Batch rename example:**
```typescript
// Before: rename getUserById → findUser
// Step 1: Update the definition
export function findUser(id: string): Promise<User | null> { /* ... */ }

// Step 2: Update all imports
import { findUser } from './users'; // was getUserById

// Step 3: Update all call sites
const user = await findUser(userId); // was getUserById

// Step 4: Update tests
describe('findUser', () => { /* was getUserById */ });
```

### 4. Refactoring While Editing

Sometimes editing naturally includes small refactors:

```python
# Before: nested if statements
def process_order(order):
    if order is not None:
        if order.is_valid():
            if order.has_stock():
                return _fulfill(order)
    return None

# After: guard clauses (small refactor during edit)
def process_order(order):
    if order is None:
        return None
    if not order.is_valid():
        return None
    if not order.has_stock():
        return None
    return _fulfill(order)
```

**When to include small refactors:**
- When the edit already touches the same lines
- When the refactor makes the edit clearer
- When the refactor is trivially safe (e.g., extract variable)
- When NOT: large restructuring unrelated to the edit goal

### 5. Preserving Formatting

```
CRITICAL RULES:
1. Match the existing indentation exactly (tabs vs spaces, width)
2. Match the quote style (single vs double)
3. Match the semicolon usage
4. Match the trailing comma style
5. Match the line length conventions
6. Match the blank line patterns
7. Match the comment style (// vs #, doc block style)
8. Match the import ordering

DETECTION:
- Read the file and identify the dominant style
- Apply the same style in new/modified code
- Don't "fix" style in code you're not changing
```

### 6. Undo Strategies

```
BEFORE editing:
1. Note the exact line numbers and content
2. For complex edits, save the original content mentally

AFTER editing:
1. If the edit is wrong, REVERT immediately
2. Use the edit tool to restore the original string
3. If multiple edits were made, revert in reverse order

RECOVERY:
- If uncertain, re-read the file to see current state
- If lost, compare with version control (git diff)
- For critical files, create a backup before editing
```

### 7. Conditional and Environment-Aware Editing

```typescript
// Edit that accounts for different environments
// Adding environment-specific configuration

// Before:
const config = {
  apiUrl: 'http://localhost:3000',
};

// After: environment-aware
const config = {
  apiUrl: process.env.API_URL || 'http://localhost:3000',
  logLevel: process.env.LOG_LEVEL || 'info',
  timeout: parseInt(process.env.TIMEOUT || '30000', 10),
};
```

## Common Patterns

### Pattern 1: Extract Variable
```python
# Before
result = expensive_computation(data['key1'], data['key2'], data['key3'])

# After: extract for clarity
key1 = data['key1']
key2 = data['key2']
key3 = data['key3']
result = expensive_computation(key1, key2, key3)
```

### Pattern 2: Add Guard Clause
```typescript
// Before
function processUser(user: User | null): string {
  if (user !== null) {
    if (user.isActive) {
      return `Active: ${user.name}`;
    } else {
      return `Inactive: ${user.name}`;
    }
  }
  return 'No user';
}

// After
function processUser(user: User | null): string {
  if (!user) return 'No user';
  if (!user.isActive) return `Inactive: ${user.name}`;
  return `Active: ${user.name}`;
}
```

### Pattern 3: Replace Magic Number
```javascript
// Before
if (user.age >= 18) { /* ... */ }

// After
const LEGAL_AGE = 18;
if (user.age >= LEGAL_AGE) { /* ... */ }
```

### Pattern 4: Add Type Guard
```typescript
// Before
function process(data: any) {
  console.log(data.name);
}

// After
function isUser(data: unknown): data is User {
  return (
    typeof data === 'object' &&
    data !== null &&
    'name' in data &&
    typeof (data as User).name === 'string'
  );
}

function process(data: unknown) {
  if (!isUser(data)) throw new Error('Invalid user data');
  console.log(data.name);
}
```

### Pattern 5: Add Error Handling
```python
# Before
def read_config(path):
    return json.load(open(path))

# After
def read_config(path: str) -> dict:
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError:
        logger.warning(f"Config not found at {path}, using defaults")
        return DEFAULT_CONFIG
    except json.JSONDecodeError as e:
        raise ConfigError(f"Invalid config at {path}: {e}") from e
```

## Edge Cases & Pitfalls

1. **Whitespace sensitivity**: Trailing whitespace changes create noise in diffs
2. **Encoding issues**: Files may be UTF-8, UTF-8-BOM, or ASCII — detect before editing
3. **Line endings**: CRLF vs LF can cause false diffs across platforms
4. **Unique match requirement**: `old_string` must appear exactly once in the file
5. **Partial line matches**: Be careful with partial line replacements that break syntax
6. **Indentation mismatch**: Mixed tabs/spaces can silently break formatting
7. **String interpolation**: Editing template literals requires careful escaping
8. **Multi-line strings**: Edit the entire string, not just a portion
9. **Regex patterns**: Editing regex requires escaping special characters
10. **JSON trailing commas**: Some parsers allow, some don't — check project config
11. **Import order**: Some linters enforce import ordering — maintain it
12. **Named exports**: Renaming requires updating all import sites
13. **Default exports**: Renaming changes the import name for consumers
14. **Re-exports**: Barrel files re-export symbols — update them too
15. **Generated code**: Don't edit auto-generated code — edit the generator instead

## Integration with Other Skills

| Skill | Direction | Description |
|-------|-----------|-------------|
| project-analysis | ← Input | Understand file context and conventions |
| code-generation | ↔ Bidirectional | Small edits vs full generation decision |
| code-explanation | ← Input | Understand code before editing |
| debugging | ↔ Bidirectional | Edit to fix bugs; editing may introduce bugs |
| refactoring | ↔ Bidirectional | Small refactors during editing vs dedicated refactoring |
| code-review | → Output | Review edits for correctness |
| testing | → Output | Verify edits don't break tests |
| version-control | ↔ Bidirectional | Commit edits properly; resolve VCS conflicts |

## Output Format Templates

### Standard Template
```
## Edit Summary

### File: [path]
### Change: [One-line description]

### Before
[Original code block]

### After
[Modified code block]

### Reason
[Why this change was made]

### Impact
- [What this affects]
- [What callers/consumers need to update]

### Verification
- [ ] Syntax valid
- [ ] Tests pass
- [ ] No side effects
```

### Quick Template
```
## Quick Edit

### Changed: [file:line]
[What changed, one line]

### Verification
[ ] Syntax valid
```

### Deep Template
```
## Comprehensive Edit

### Context
[Analysis of surrounding code and dependencies]

### Change
[Detailed diff with explanation for each change]

### Related Files
[Other files that may need similar changes]

### Risk Assessment
- Backward compatibility: [low/medium/high risk]
- Affected callers: [count/list]
- Test coverage: [what tests exist]

### Rollback Plan
[How to revert if needed]
```

### Agent-Specific Template
```
## Agent Edit

### Task
[What was requested]

### Changes Made
1. [file]: [what changed]
2. [file]: [what changed]

### Status
[ ] Complete
[ ] Verified
[ ] Tests pass

### Notes
[Any assumptions or follow-up items]
```

## Rules

1. **ALWAYS** read the file before editing — never edit blindly
2. **ALWAYS** use exact string matching for old_string
3. **ALWAYS** preserve existing formatting and style
4. **ALWAYS** verify the edit after making it
5. **ALWAYS** make one logical change per edit
6. **NEVER** reformat code you didn't change
7. **NEVER** delete code without understanding its purpose
8. **NEVER** change public APIs without explicit approval
9. **NEVER** make multiple unrelated changes in one edit
10. **NEVER** edit files you haven't read
11. **PREFER** additive changes over deletions
12. **PREFER** targeted edits over full file rewrites
13. **CHECK** for callers and consumers before changing interfaces
14. **VERIFY** syntax is valid after every edit
15. **REVERT** immediately if an edit breaks something

## Verification

- [ ] File syntax is valid
- [ ] No accidental deletions
- [ ] Formatting preserved
- [ ] Related tests still pass
- [ ] No side effects on other files
- [ ] Backward compatibility maintained
- [ ] Diff is minimal and focused

## Failure Handling

- If edit fails → Re-read file, check for concurrent changes
- If syntax breaks → Fix syntax immediately
- If tests fail → Revert and reassess the approach
- If old_string not found → Re-read file, adjust the string
- If multiple matches → Provide more context in old_string

## Safety Constraints

- Do NOT edit files you haven't read
- Do NOT make unrelated changes in the same edit
- Do NOT delete code without understanding its purpose
- Do NOT change public APIs without explicit approval
- Do NOT modify generated/auto-generated code
- Do NOT change code formatting in the same edit as logic changes
- Do NOT skip syntax validation after editing

## Anti-Patterns

- ❌ Editing without reading the full file first
- ❌ Making multiple unrelated changes in one edit
- ❌ Reformatting code you didn't change
- ❌ Deleting code you don't understand
- ❌ Changing more than necessary
- ❌ Editing generated code instead of the generator
- ❌ Mixing formatting changes with logic changes
- ❌ Editing without considering callers/consumers
- ❌ "Fix it and we'll see" approach without understanding the impact
- ❌ Editing multiple files simultaneously without tracking all changes

## Skill Interactions

- ← project-analysis: Understand file context
- → verification: Verify edit works
- → code-review: Review the change
- → testing: Run tests after edit
- ↔ version-control: Commit changes properly
