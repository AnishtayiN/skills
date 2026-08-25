---
name: code-editing
description: >-
  Precisely modify existing code with minimal changes. Edit, patch, update, or modify specific parts.
  TRIGGERS: edit code, modify, change, update, fix this line, replace, patch, adjust, tweak,
  change this, update this, اصلاح کد, تغییر کد, ویرایش, اصلاح این خط, جایگزین کردن
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Code Editing Skill

## Purpose

Make precise, minimal changes to existing code. Preserve context, avoid side effects.

## When to Activate

- User asks to change a specific line/function/block
- User wants to update existing behavior
- User provides a patch or diff
- Small targeted modifications

## When NOT to Activate

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

## Workflow

### Step 1: Read Current Code

```
1. Read the target file completely
2. Understand the context around the change
3. Identify any dependencies on the code being changed
4. Check for tests that might be affected
```

### Step 2: Plan Minimal Change

```
1. What is the SMALLEST change that achieves the goal?
2. Will this change break anything else?
3. Are there callers/users of this code?
4. Does the change maintain backward compatibility?
```

### Step 3: Make the Edit

```
1. Use edit tool with exact old_string → new_string
2. Preserve indentation and formatting
3. Keep changes focused — one logical change per edit
4. Do NOT reformat unrelated code
```

### Step 4: Verify Edit

```
1. Re-read the edited section
2. Check syntax is valid
3. Check no accidental deletions
4. Run related tests if available
```

## Decision Tree

```
How big is the change?
├── 1-5 lines → Direct edit
├── 5-20 lines → Edit with careful review
├── 20+ lines → Consider if refactoring needed
└── Full file rewrite → Use code-generation instead
```

## Execution Rules

- READ the file before editing
- EDIT with exact string matching
- PRESERVE formatting and style
- DO NOT reformat unrelated code
- VERIFY the edit is correct
- ONE logical change per edit

## Verification

- [ ] File syntax is valid
- [ ] No accidental deletions
- [ ] Formatting preserved
- [ ] Related tests still pass

## Failure Handling

- If edit fails → Re-read file, check for changes
- If syntax breaks → Fix syntax immediately
- If tests fail → Revert and reassess

## Safety Constraints

- Do NOT edit files you haven't read
- Do NOT make unrelated changes in the same edit
- Do NOT delete code without understanding its purpose
- Do NOT change public APIs without explicit approval

## Anti-Patterns

- ❌ Editing without reading the full file first
- ❌ Making multiple unrelated changes in one edit
- ❌ Reformatting code you didn't change
- ❌ Deleting code you don't understand
- ❌ Changing more than necessary

## Skill Interactions

- ← project-analysis: Understand file context
- → verification: Verify edit works
- → code-review: Review the change
