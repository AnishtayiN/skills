---
name: git-workflow
description: >-
  Git operations: commits, branches, merges, rebases, conflict resolution, history management.
  TRIGGERS: git, commit, branch, merge, rebase, conflict, stash, cherry-pick, revert, reset,
  git log, git diff, pull request, pr, merge conflict,
  گیت, کامیت, برانچ, ادغام, کانفلیکت, ری‌بیس, درخواست ادغام
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Git Workflow Skill

## Purpose

Manage Git operations safely and effectively.

## When to Activate

- Creating commits
- Managing branches
- Resolving merge conflicts
- Reviewing PRs
- Recovering from Git mistakes

## Workflow

### Commit Guidelines

```
1. Stage relevant changes
2. Write clear commit message:
   - type(scope): description
   - Types: feat, fix, docs, style, refactor, test, chore
3. Verify changes before committing
```

### Branch Strategy

```
main     ← production code
  └── feature/*  ← new features
  └── fix/*      ← bug fixes
  └── refactor/* ← refactoring
```

### Conflict Resolution

```
1. Read both versions
2. Understand the intent of each change
3. Choose the correct resolution (not just accept one)
4. Test after resolution
5. Commit the resolution
```

## Anti-Patterns

- ❌ Committing broken code
- ❌ Committing with message "fix" or "update"
- ❌ Force pushing to shared branches
- ❌ Resolving conflicts without understanding both sides

## Skill Interactions

- ← project-analysis: Understand repo structure
- → verification: Test after Git operations
