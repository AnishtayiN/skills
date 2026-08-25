---
name: git-workflow
description: >-
  Resolve Git problems — merge conflicts, branch management, rebase issues, detached HEAD, force push recovery, and general version control workflow. Use this skill when the user has a git problem, needs to resolve a conflict, merge issue, rebase problem, branch management, KANFLEKT GIT actually کانفلیکت گیت, merge branch, rebase onto, git stuck, accidentally pushed wrong branch, undo commit, cherry-pick, squash commits, recover lost work, git workflow advice, branching strategy, مشکل گیت, حل کانفلیکت, مرج برنچ, ریبیس, بازگشت کامیت, استراتژی شاخه‌بندی, git冲突, 解决git冲突, 合并分支, 变基, 撤销提交, 恢复丢失代码, git问题, 分支管理, git stash, git bisect, git rerere, interactive rebase, force push, revert commit, amend commit, git hook, pre-commit hook, commit message, conventional commits, gitignore, submodule, worktree, git tag, git cherry-pick, git bisect run, merge driver, resolve conflict, git help.
---

# Git Workflow Skill

## Overview

This skill handles Git version control problems — from everyday operations (merge, rebase, branch) to recovery scenarios (lost commits, force push undo). Git is powerful but unforgiving; the goal is to give precise, safe commands for each situation.

Every git command should be accompanied by a one-line explanation of what it does. The user should understand the command, not just copy-paste it blindly.

## When to Use This Skill

- User encounters a merge conflict or merge failure
- User needs help with branching, merging, or rebasing
- User accidentally committed, pushed, or deleted something
- User asks about Git workflow, branching strategy, or best practices
- User is confused by a Git error message
- User needs to undo, revert, or recover Git operations
- User wants to cherry-pick, squash, or rebase commits
- User has a detached HEAD and doesn't know how to get back
- User accidentally force-pushed and needs to recover
- User needs to set up or fix git hooks
- User asks about commit message conventions
- User needs to deal with submodules or subtrees
- User wants to use git bisect to find a bug-introducing commit
- User needs to manage multiple worktrees
- User wants to understand or configure .gitignore
- User asks about git tags and release management

## Workflow

### Step 1: Diagnose the Situation

1. Run diagnostic commands to understand the current state:
   - `git status` — current branch, staged/modified files
   - `git log --oneline -10` — recent commit history
   - `git branch -a` — all branches
   - `git remote -v` — configured remotes
   - `git stash list` — any stashed changes
   - `git diff --stat` — summary of uncommitted changes
   - `git reflog -10` — recent HEAD movements (for recovery)
2. Read the error message if the user provided one.
3. Understand what the user was trying to do and what went wrong.

### Step 2: Classify the Problem

| Problem | Common Cause | Danger Level |
|---------|-------------|-------------|
| Merge conflict | Divergent changes in the same file | Low |
| Detached HEAD | Checked out a specific commit instead of a branch | Low |
| Push rejected | Remote has commits not in local branch | Low |
| Lost commit | Reset, amend, or rebase without saving the ref | Medium |
| Wrong branch | Committed on main instead of feature branch | Low |
| Rebase failure | Conflicts during interactive rebase | Medium |
| Force push needed | History rewritten and need to update remote | High |
| Submodule issues | Detached or out-of-sync submodule | Medium |
| Accidental delete | Branch, tag, or commit deleted | Medium |
| Corrupted repo | File system issues, interrupted operations | High |
| Large files | Committed binary files exceeding limits | Medium |
| Permission denied | SSH key or access rights issue | Low |

### Step 3: Provide the Solution

For each problem type, provide:
1. The exact commands to run, in order
2. What each command does in one line
3. Any risks or irreversible actions
4. How to verify the fix worked

#### Merge Conflict Resolution
```bash
# 1. See which files have conflicts
git status

# 2. Open conflicted files, look for <<<<<<< / ======= / >>>>>>> markers
# 3. Resolve each conflict (edit the file to keep the correct version)
# 4. Mark as resolved and commit
git add <resolved-files>
git commit
```

#### Common Recovery Patterns

- **Undo last commit (keep changes staged):** `git reset --soft HEAD~1`
- **Undo last commit (keep changes unstaged):** `git reset HEAD~1`
- **Recover lost commit:** `git reflog` to find the hash, then `git checkout <hash>` or `git cherry-pick <hash>`
- **Move commit to new branch:** `git branch <new-branch>`, then `git reset --hard HEAD~1` on the original branch
- **Abort a failed merge:** `git merge --abort`
- **Abort a failed rebase:** `git rebase --abort`
- **Undo a pushed commit (safe):** `git revert <hash>` — creates a new commit that undoes the change
- **Unstage a file:** `git restore --staged <file>`
- **Discard uncommitted changes to a file:** `git restore <file>`
- **Recover a deleted branch:** `git reflog` to find the hash, then `git branch <branch-name> <hash>`

### Step 4: Advise on Workflow

If the user asks for general Git advice, recommend based on team size and project type:

- **Solo/small team:** GitHub Flow (main + feature branches, PR to merge)
- **Release-based teams:** Git Flow (main, develop, feature, release, hotfix branches)
- **Continuous deployment:** Trunk-based development with short-lived feature branches

## Advanced Techniques

### Interactive Rebase
For cleaning up commit history before merging:
```bash
git rebase -i HEAD~5  # Rebase last 5 commits
# Commands in editor:
# pick   = keep commit as-is
# squash = merge into previous commit
# reword = keep changes, edit message
# drop   = remove commit
# reorder by moving lines
```

### Git Bisect
For finding which commit introduced a bug:
```bash
git bisect start
git bisect bad              # Current commit has the bug
git bisect good <hash>     # This commit did NOT have the bug
# Git will check out middle commits; mark each as good or bad
git bisect run <command>   # Automate with a test command
git bisect reset           # Done
```

### Cherry-Picking
Apply specific commits from one branch to another:
```bash
git cherry-pick <hash>          # Pick one commit
git cherry-pick <hash1> <hash2> # Pick multiple
git cherry-pick --abort          # Abort if conflicts occur
```

### Worktrees
Work on multiple branches simultaneously without stashing:
```bash
git worktree add ../feature-branch feature-branch  # Create worktree
git worktree list                                    # List all worktrees
git worktree remove ../feature-branch                # Remove worktree
```

### Stash Management
Temporarily shelve changes:
```bash
git stash push -m "work in progress"  # Stash with message
git stash list                         # List stashes
git stash pop                          # Apply and remove latest stash
git stash apply stash@{2}             # Apply specific stash without removing
git stash drop stash@{2}              # Remove specific stash
```

## Common Patterns

### Pattern 1: The Accidental Main Commit
Developer commits work directly to main instead of a feature branch.
```bash
# Create branch from current commit, then reset main back
git branch feature/my-work
git reset --hard HEAD~1  # Or to the previous commit hash
```

### Pattern 2: The Diverged Feature Branch
Remote and local branch have diverged after force-push or reset.
```bash
# Fetch remote state and rebase local onto it
git fetch origin
git rebase origin/main  # Or: git reset --hard origin/main (if local changes aren't needed)
```

### Pattern 3: The Messy PR History
Many small, messy commits that should be clean before merging.
```bash
# Interactive rebase to squash, reorder, and reword
git rebase -i main
```

### Pattern 4: The Wrong Commit Message
Committed with a typo or wrong message.
```bash
# If not yet pushed:
git commit --amend -m "correct message"
# If already pushed (creates new commit):
git commit --amend -m "correct message"
git push --force-with-lease
```

### Pattern 5: The Partial Staged File
Need to commit only part of a modified file.
```bash
git add -p <file>  # Interactive staging: choose hunks to stage
git commit -m "commit only selected changes"
```

## Edge Cases & Pitfalls

1. **Force-pushing shared branches** — NEVER force-push to shared branches (main, develop). This rewrites other developers' history. Use `--force-with-lease` as a safety check.
2. **Amending pushed commits** — Amending a pushed commit changes its hash, causing divergence. Only amend unpushed commits.
3. **Rebasing shared branches** — Don't rebase commits that others have based work on. It rewrites history and creates duplicate commits.
4. **Not pulling before pushing** — Push rejection happens when remote has new commits. Always pull/rebase first.
5. **Ignoring .gitignore changes** — After updating .gitignore, already-tracked files won't be untracked. Use `git rm --cached <file>`.
6. **Binary file conflicts** — Merge conflicts in binary files (images, PDFs) can't be resolved with text editors. Choose one version manually.
7. **Line ending conflicts** — CRLF vs LF differences can cause conflicts. Configure `git config core.autocrlf` and use `.gitattributes`.
8. **Large file recovery** — Once a large file is committed and garbage collected, recovering it requires specialized tools (git-lfs or external backups).
9. **Submodule detached HEAD** — Submodules default to detached HEAD state. Always commit submodule changes in the submodule first, then update the parent.
10. **Reflog expiry** — `git reflog` entries expire after ~90 days. Lost commits older than this may be unrecoverable.
11. **Merge commit vs. fast-forward** — Understand the difference. `--no-ff` creates a merge commit even when fast-forward is possible, preserving branch history.
12. **Case-sensitive filename conflicts** — On case-insensitive filesystems (macOS, Windows), `File.txt` and `file.txt` are the same file but Git sees them as different.
13. **Not running git status first** — Always diagnose before prescribing. The user's situation may be different from what they describe.

## Integration with Other Skills

- **debug**: If a bug was introduced in a specific commit, use `git bisect` to find it, then switch to debug to fix it.
- **code-review**: After resolving a merge, review the resulting code for conflicts that may have been resolved incorrectly.
- **refactor**: Use branches to safely refactor code. Feature branches allow experimenting without affecting main.
- **test-generation**: Run tests after merging to catch integration issues that conflict resolution may have introduced.
- **ci-cd-pipeline**: Git workflow integrates with CI/CD for automated testing, building, and deploying on specific branch events.
- **documentation**: Update documentation when merge conflicts are resolved in docs, or when branching strategy changes.

## Output Format

### Standard Resolution Template

```
## Git Problem Resolution

**Problem:** [one-line description]
**Current State:** [branch, status, relevant history]
**Danger Level:** Low / Medium / High

### Solution
```bash
# Step 1: [what this does]
git <command>

# Step 2: [what this does]
git <command>
```

### What Happened
[Brief explanation of why the problem occurred]

### Verification
[How to confirm the fix worked]

### Prevention
[How to avoid this in the future]
```

### Workflow Recommendation Template

```
## Git Workflow Recommendation

**Team Size:** [solo / small / large]
**Deployment:** [continuous / release-based]

### Recommended Strategy: [Name]
[Description of the branching strategy]

### Branch Structure
| Branch | Purpose | Lifetime |
|--------|---------|----------|
| main | Production-ready code | Permanent |
| develop | Integration branch | Permanent |
| feature/* | New features | Until merged |
| hotfix/* | Production fixes | Until merged |

### Conventions
- Commit messages: [convention, e.g., Conventional Commits]
- Branch naming: [convention, e.g., feature/ISSUE-123-description]
- PR requirements: [tests, review, CI passing]
```

### Recovery Scenario Template

```
## Git Recovery

**What was lost:** [commit, branch, file]
**How it was lost:** [reset, force push, accidental delete]
**Recoverable:** Yes / No / Possibly

### Recovery Steps
```bash
# Step 1: Find the lost reference
git <command>

# Step 2: Restore it
git <command>
```

### Success Verification
git log --oneline -5  # Should show the recovered commit
```

## Rules

- Always check `git status` and `git log` before suggesting commands. Never guess the repo state.
- Warn clearly before any command that is destructive or hard to reverse (e.g., `reset --hard`, `force push`).
- Provide the exact commands — don't say "rebase onto main" without showing the command.
- If the user's Git version matters for a command, note it.
- Present the response in the user's language; keep Git commands and technical terms in English.
- Prefer `--force-with-lease` over `--force` for safety.
- Always suggest verification steps after a recovery operation.
- Don't recommend rebasing published/shared commits without explicit warning.
- If the situation is complex, break the solution into numbered steps.
