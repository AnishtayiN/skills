---
name: git-workflow
description: >-
  Resolve Git problems — merge conflicts, branch management, rebase issues, detached HEAD, force push recovery, and general version control workflow. Use this skill when the user has a git problem, needs to resolve a conflict, merge issue, rebase problem, branch management, KANFLEKT GIT actually کانفلیکت گیت, merge branch, rebase onto, git stuck, accidentally pushed wrong branch, undo commit, cherry-pick, squash commits, recover lost work, git workflow advice, branching strategy, مشکل گیت, حل کانفلیکت, مرج برنچ, ریبیس, بازگشت کامیت, استراتژی شاخه‌بندی.
---

# Git Workflow Skill — Complete Git Mastery

## Overview

This skill handles every Git version control problem — from everyday operations (merge, rebase, branch) to advanced workflows (trunk-based development, forking, monorepo patterns), recovery scenarios (lost commits, force push undo, corrupted index), and tooling (bisect, worktree, hooks, submodules). Git is powerful but unforgiving; the goal is to give precise, safe commands for each situation with full understanding of the underlying mechanics.

## When to Use This Skill

- User encounters a merge conflict or merge failure
- User needs help with branching, merging, or rebasing
- User accidentally committed, pushed, or deleted something
- User asks about Git workflow, branching strategy, or best practices
- User is confused by a Git error message
- User needs to undo, revert, or recover Git operations
- User asks about Git bisect, worktree, submodules, hooks, or advanced Git features
- User needs interactive rebase help
- User needs to recover lost stash, corrupted index, or detached HEAD deep dive

---

## Part 1: Diagnostic Foundation

### Step 1: Diagnose the Situation

Always run diagnostic commands before suggesting any action:

```bash
# Current branch, staged/modified files, untracked files
git status

# Recent commit history (full hash for safety)
git log --oneline --graph -15

# All branches including remote tracking
git branch -a

# Configured remotes
git remote -v

# Any stashed changes
git stash list

# Current HEAD vs branch tips
git reflog -20

# Working tree health check
git fsck --no-dangling
```

### Step 2: Classify the Problem

| Problem | Common Cause | Urgency |
|---------|-------------|---------|
| Merge conflict | Divergent changes in the same file | Medium |
| Detached HEAD | Checked out a specific commit instead of a branch | Low (unless commits made) |
| Push rejected | Remote has commits not in local branch | Medium |
| Lost commit | Reset, amend, or rebase without saving the ref | High |
| Wrong branch | Committed on main instead of feature branch | Medium |
| Rebase failure | Conflicts during interactive rebase | Medium |
| Force push needed | History rewritten and need to update remote | High |
| Submodule issues | Detached or out-of-sync submodule | Medium |
| Corrupted index | Interrupted Git operation, disk error | High |
| Lost stash | Pop applied stash with conflicts, dropped stash | Medium |
| Broken bisect | Bisect session interrupted or bad state | Low |

---

## Part 2: Core Recovery Patterns

### Merge Conflict Resolution

```bash
# See which files have conflicts
git status

# Open conflicted files, look for <<<<<<< / ======= / >>>>>>> markers
# Three options for each conflict:
#   - Accept theirs (incoming change)
#   - Accept ours (current change)
#   - Manually resolve (most common for real conflicts)

# Quick resolution using theirs/ours
git checkout --theirs <file>     # Take the incoming version
git checkout --ours <file>       # Take the current version

# Use a merge tool for complex conflicts
git mergetool

# After resolving all conflicts
git add <resolved-files>
git commit                      # Creates merge commit
```

#### Merge Conflict in Specific Lines Strategy

```bash
# When you know which lines are conflicting
# Use git diff to see the exact conflict
git diff --name-only --diff-filter=U

# For each conflicted file
grep -n "<<<<<<" <file>  # Find conflict markers
# Edit the file at those line numbers
# Remove conflict markers, keep the correct code
```

### Common Recovery Patterns

```bash
# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (keep changes unstaged)
git reset HEAD~1

# Undo last commit (discard changes — DESTRUCTIVE)
git reset --hard HEAD~1

# Recover lost commit via reflog
git reflog                        # Find the commit hash
git checkout <hash>               # Inspect it
git branch recover-branch <hash>  # Create a branch to save it
git cherry-pick <hash>            # Or apply it to current branch

# Move commit to new branch
git branch <new-branch>           # Create branch at current commit
git reset --hard HEAD~1           # Remove commit from original branch

# Abort a failed merge
git merge --abort

# Abort a failed rebase
git rebase --abort

# Recover a dropped stash
git fsck --no-dangling | grep commit
# Or check reflog
git stash list                    # Stash entries show in reflog too
git stash apply stash@{n}        # Re-apply a specific stash
```

### Detached HEAD Deep Dive

When HEAD is detached, you're on a specific commit, not a branch. Any new commits are orphaned unless you create a branch.

```bash
# Check if you're detached
git status
# "HEAD detached at abc1234" = you're detached

# Option 1: Create a branch to save work
git branch my-temp-branch
git checkout my-temp-branch

# Option 2: If you haven't made commits, just switch to a branch
git checkout main

# Option 3: If you made commits on detached HEAD and want to save them
git branch temp-save HEAD
git checkout main
git cherry-pick temp-save         # Apply to main
# Or: git merge temp-save

# Option 4: Abandon work on detached HEAD
git checkout main                # Commits become orphaned, eventually garbage collected
```

---

## Part 3: Advanced Git Workflows

### GitHub Flow

Best for: Small teams, continuous deployment, web applications.

```
main ──────────────────────────────────────── (always deployable)
  │
  ├── feature/login ── PR ── merge ── deploy
  │
  ├── feature/search ── PR ── merge ── deploy
  │
  └── fix/typo ── PR ── merge ── deploy
```

**Rules:**
- `main` is always deployable
- All work happens on feature branches
- Feature branches are short-lived (hours to days)
- Pull requests are required for all merges
- Deploy immediately after merge

```bash
# Start feature
git checkout main && git pull
git checkout -b feature/user-dashboard

# Work on feature (multiple commits)
git add .
git commit -m "feat: add dashboard layout"
git add .
git commit -m "feat: add widget components"

# Sync with main before PR
git fetch origin
git rebase origin/main           # Keep linear history

# Push and create PR
git push origin feature/user-dashboard

# After PR approval and merge
git checkout main && git pull
git branch -d feature/user-dashboard
```

### Git Flow

Best for: Release-based software, versioned products, desktop/mobile apps.

```
main ───────────── v2.0 ─────────────────── v2.1
  │                    │                       │
  └── develop ────────┴── release/v2.0 ───────┘
         │                    │
         ├── feature/auth ────┘
         │
         └── hotfix/critical-bug ──→ main + develop
```

**Branch Types:**
- `main` — production-ready code, tagged releases
- `develop` — integration branch for next release
- `feature/*` — new features branched from develop
- `release/*` — release preparation (only bugfixes, docs)
- `hotfix/*` — emergency fixes branched from main

```bash
# Initialize Git Flow
git flow init

# Start a feature
git flow feature start user-authentication
# Creates: feature/user-authentication from develop

# Finish a feature (merges into develop)
git flow feature finish user-authentication

# Start a release
git flow release start 2.0.0
# Creates: release/2.0.0 from develop

# Finish release (merges into main, tags, merges back to develop)
git flow release finish 2.0.0

# Hotfix (from main, merges into main + develop)
git flow hotfix start critical-fix
git flow hotfix finish critical-fix
```

### Trunk-Based Development

Best for: Large teams, continuous deployment, Google/Facebook-scale organizations.

**Rules:**
- Everyone commits to `main` (trunk) or very short-lived branches (< 24 hours)
- Feature flags gate incomplete features
- No long-lived branches
- `main` is always deployable

```bash
# Short-lived branch (commit same day)
git checkout main && git pull
git checkout -b short-feature-x
# ... make changes ...
git add . && git commit -m "feat: partial feature behind flag"
git push origin short-feature-x
# Create PR, merge within hours

# Deploying with feature flags
# Code is deployed but hidden behind flag
# When flag is enabled, feature is live
# When flag is removed, feature is fully merged
```

#### Feature Flag Pattern

```typescript
// Code with feature flag
const showNewDashboard = featureFlags.isEnabled('new-dashboard');

if (showNewDashboard) {
  return <NewDashboard />;
} else {
  return <OldDashboard />;
}
```

### Forking Workflow

Best for: Open source projects, large organizations with untrusted contributors.

```
upstream/main ─────────────────────────────
       │
       ├── fork/user-repo/main ──────────── (synced with upstream)
       │       │
       │       └── feature/x ── PR to upstream
       │
       └── fork/other-user/main ───────────
               │
               └── fix/y ── PR to upstream
```

```bash
# Fork once (on GitHub), then clone your fork
git clone https://github.com/YOUR-USER/repo.git
cd repo

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL-OWNER/repo.git

# Sync fork before starting work
git fetch upstream
git checkout main
git merge upstream/main           # or: git rebase upstream/main
git push origin main

# Create feature branch
git checkout -b fix/issue-123

# Work, commit, push to your fork
git push origin fix/issue-123

# Create PR from your fork to upstream main

# Before next contribution, sync again
git fetch upstream
git rebase upstream/main
git push origin fix/next-feature --force-with-lease
```

### Monorepo Workflow

Best for: Multiple related packages, shared libraries, full-stack applications.

```bash
# Using Turborepo (recommended for Node.js monorepos)
npx create-turbo@latest my-monorepo

# Directory structure
# my-monorepo/
#   apps/
#     web/
#     api/
#   packages/
#     ui/
#     config/
#     utils/

# Run commands across packages
npx turbo run build               # Build all packages
npx turbo run test --filter=web   # Test only web app
npx turbo run lint --filter=!api  # Lint everything except api

# Using workspace protocol in package.json
# "dependencies": {
#   "@myorg/ui": "workspace:*"
# }
```

```bash
# Git submodules for monorepo (when packages are in different repos)
git submodule add https://github.com/org/shared-lib.git packages/shared-lib
git submodule update --init --recursive

# Update submodule to latest
cd packages/shared-lib
git pull origin main
cd ../..
git add packages/shared-lib
git commit -m "chore: update shared-lib submodule"

# Clone repo with submodules
git clone --recurse-submodules https://github.com/org/monorepo.git

# Or after clone
git submodule update --init --recursive
```

---

## Part 4: Interactive Rebase Patterns

Interactive rebase is the most powerful Git tool for cleaning up commit history.

### Basic Interactive Rebase

```bash
# Rebase last 3 commits
git rebase -i HEAD~3

# This opens an editor with:
pick abc1234 feat: add login page
pick def5678 fix: typo in login
pick ghi9012 feat: add dashboard

# Commands:
# p, pick   = use commit as-is
# r, reword = use commit, but edit the commit message
# e, edit   = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup  = like squash, but discard this commit's message
# d, drop   = remove commit entirely
# x, exec   = run a shell command after this commit

# Example: squash the fix into the feature commit
pick abc1234 feat: add login page
squash def5678 fix: typo in login
pick ghi9012 feat: add dashboard
```

### Advanced Interactive Rebase Patterns

```bash
# Reorder commits
# Change the order of lines in the editor
# Useful when commit B depends on commit A but they're in reverse order

# Split a commit
git rebase -i HEAD~1
# Change 'pick' to 'edit' for the commit you want to split
# Git will stop at that commit
git reset HEAD^                  # Undo the commit, keep changes
git add <part1>
git commit -m "first part"
git add <part2>
git commit -m "second part"
git rebase --continue

# Fixup with rebase (combine all fixups automatically)
git rebase -i --autosquash HEAD~5
# Requires: git config --global rebase.autoSquash true

# Rebase from a merge base (rebase only the branch, not the whole history)
git rebase -i --onto main 5 commits-ago~1
```

### Rebase onto Another Branch

```bash
# Rebase current branch onto main
git rebase main

# Rebase feature分支 onto a specific commit
git rebase --onto <target-branch> <since-commit> <branch>

# Example: replay commits from feature starting at abc1234 onto release
git rebase --onto release abc1234 feature
```

### Safe Rebase with Preserve-Merges

```bash
# Preserve merge commits during rebase
git rebase -i --preserve-merges HEAD~5

# Or use --rebase-merges (newer Git versions)
git rebase -i --rebase-merges HEAD~5
```

---

## Part 5: Git Bisect — Binary Search for Bugs

Git bisect performs a binary search through commit history to find which commit introduced a bug.

### Basic Bisect

```bash
# Start bisect
git bisect start

# Mark current commit as bad (has the bug)
git bisect bad

# Mark a known good commit (no bug)
git bisect good v1.0.0

# Git checks out a middle commit
# Test your application, then mark it:
git bisect good    # If this commit is fine
# OR
git bisect bad     # If this commit has the bug

# Git narrows down until it finds the first bad commit

# When done, return to original branch
git bisect reset
```

### Automated Bisect

```bash
# Write a test script that exits 0 for good, non-zero for bad
# Example: test.sh
#!/bin/bash
npm run build && npm test

# Run bisect automatically
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
git bisect run ./test.sh

# Git will automatically find the bad commit using your script
```

### Bisect with Visual Studio Code

```bash
# VS Code has built-in bisect support
# Or use the Git Lens extension for visual bisect
```

### Bisect Patterns for Common Scenarios

```bash
# Find when performance regressed
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
git bisect run sh -c "npm run build && node -e 'const t=Date.now();require(\"./dist/app\");console.log(Date.now()-t)' | awk '{if(\$1>500)exit 1;else exit 0}'"

# Find when a specific function broke
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
git bisect run node -e "
  const fn = require('./dist/utils');
  try { fn.testSomething(); process.exit(0); }
  catch(e) { process.exit(1); }
"
```

---

## Part 6: Git Worktree — Parallel Working Trees

Worktrees allow multiple working directories from a single repository. Perfect for working on hotfixes while mid-feature.

### Basic Worktree Usage

```bash
# Create a new worktree for a hotfix
git worktree add ../hotfix-branch hotfix/critical-bug
cd ../hotfix-branch
# Make changes, commit, push
git push origin hotfix/critical-bug

# Return to main worktree
cd /path/to/main/repo

# List all worktrees
git worktree list

# Remove a worktree when done
git worktree remove ../hotfix-branch
```

### Worktree Patterns

```bash
# Create worktree from a specific commit
git worktree add ../debug-version abc1234

# Create worktree for a new branch
git worktree add -b feature/new-api ../new-api main

# Work on multiple features simultaneously
git worktree add -b feature/auth ../project-auth main
git worktree add -b feature/payments ../project-payments main
# Now you have 3 terminals, each on a different feature

# Prune stale worktree references
git worktree prune
```

### Worktree vs Branch

| Feature | Worktree | Branch + Checkout |
|---------|----------|-------------------|
| Speed | Instant | Requires checkout (can be slow) |
| IDE support | Each worktree = separate project | Must reindex after switching |
| Uncommitted changes | Each worktree has its own working directory | Stash required to switch |
| Disk usage | Shares .git objects | Shares .git objects |
| Best for | Parallel features, hotfixes, debugging | Single-feature workflow |

---

## Part 7: Submodules and Monorepo Patterns

### Submodule Management

```bash
# Add a submodule
git submodule add https://github.com/org/lib.git libs/lib
git commit -m "chore: add lib submodule"

# Clone with submodules
git clone --recurse-submodules https://github.com/org/project.git

# Update submodules to latest
cd libs/lib
git fetch origin
git checkout main
git pull origin main
cd ../..
git add libs/lib
git commit -m "chore: update lib submodule"

# Update all submodules to remote tracking
git submodule update --remote --merge

# Remove a submodule
git submodule deinit -f libs/lib
git rm -f libs/lib
rm -rf .git/modules/libs/lib
```

### Submodule Best Practices

```bash
# Always commit submodule pointer changes
git add libs/lib                  # Records the submodule's commit hash
git commit -m "chore: update lib to v2.1"

# Check submodule status
git submodule status
# -abc1234 lib  (not initialized)
# +abc1234 lib  (initialized, different commit than recorded)
#  abc1234 lib  (at recorded commit)

# Use .gitmodules for configuration
# [submodule "libs/lib"]
#   path = libs/lib
#   url = https://github.com/org/lib.git
#   branch = main
```

### Subtree Alternative

```bash
# Add a subtree (merges the repo into your tree)
git subtree add --prefix=libs/lib https://github.com/org/lib.git main --squash

# Update subtree
git subtree pull --prefix=libs/lib https://github.com/org/lib.git main --squash

# Push changes back to the subtree repo
git subtree push --prefix=libs/lib https://github.com/org/lib.git feature/fix
```

---

## Part 8: Git Hooks Patterns

### Hook Types

| Hook | When it runs | Use case |
|------|-------------|----------|
| `pre-commit` | Before commit is created | Linting, formatting, type checking |
| `prepare-commit-msg` | After default message is created | Add issue number to commit message |
| `commit-msg` | After commit message is entered | Enforce commit message format |
| `pre-push` | Before push is executed | Run tests, check for secrets |
| `post-merge` | After a merge completes | Auto-install dependencies |
| `pre-rebase` | Before rebase starts | Prevent rebasing shared branches |
| `post-checkout` | After checkout/clone | Set up environment, install deps |

### Pre-commit Hook Example

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Run linter on staged files
echo "$STAGED_FILES" | grep -E '\.(js|ts|jsx|tsx)$' | xargs npx eslint --max-warnings=0
if [ $? -ne 0 ]; then
  echo "❌ Linting failed. Fix errors before committing."
  exit 1
fi

# Check for secrets
echo "$STAGED_FILES" | xargs grep -l -E '(api_key|secret|password)\s*=\s*["\x27]' 2>/dev/null
if [ $? -eq 0 ]; then
  echo "❌ Potential secrets found in staged files."
  exit 1
fi

# Run tests
npm test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed."
  exit 1
fi

echo "✅ All checks passed."
```

### Commit Message Hook

```bash
#!/bin/bash
# .git/hooks/commit-msg

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Enforce conventional commits format
# Pattern: type(scope): description
# Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
PATTERN="^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)(\(.+\))?: .{1,72}$"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo "❌ Invalid commit message format."
  echo ""
  echo "Expected format: type(scope): description"
  echo "Example: feat(auth): add login page"
  echo "Example: fix: resolve memory leak in worker"
  echo ""
  echo "Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build"
  exit 1
fi
```

### Pre-push Hook (Secret Scanner)

```bash
#!/bin/bash
# .git/hooks/pre-push

# Scan for secrets before pushing
CHANGED_FILES=$(git diff --name-only HEAD..$2)

echo "$CHANGED_FILES" | while read file; do
  if git show HEAD:$file 2>/dev/null | grep -qE '(AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|sk-[a-zA-Z0-9]{48})'; then
    echo "❌ Potential secret found in $file. Remove it before pushing."
    exit 1
  fi
done
```

### Using Husky for Git Hooks (Node.js Projects)

```bash
# Install Husky
npm install -D husky

# Initialize Husky
npx husky init

# Add a pre-commit hook
npx husky add .husky/pre-commit "npx lint-staged"

# Add a commit-msg hook
npx husky add .husky/commit-msg 'npx commitlint --edit "$1"'
```

```json
// package.json - lint-staged config
{
  "lint-staged": {
    "*.{js,ts,jsx,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md,yml}": ["prettier --write"]
  }
}
```

---

## Part 9: Branch Protection Strategies

### GitHub Branch Protection Rules

Configure via Settings → Branches → Add rule:

```yaml
# Branch protection for main
Branch protection:
  Pattern: main
  Rules:
    - Require pull request reviews before merging
      - Required approvals: 1-2
      - Dismiss stale pull request approvals on new pushes
      - Require review from Code Owners
    - Require status checks before merging
      - Required checks: build, test, lint
      - Require branches to be up to date before merging
    - Require conversation resolution before merging
    - Require linear history (squash merge only)
    - Do not allow bypassing the above settings
    - Do not allow force pushes
    - Do not allow deletions
```

### GitLab Branch Protection

```yaml
# .gitlab-ci.yml - Protected branches
Protected branches:
  main:
    - Allowed to merge: Maintainers
    - Allowed to push: No one
    - Allowed to force push: No
    - Require approval from code owners: Yes
    - Pipeline must succeed: Yes
```

### Pre-rebase Hook (Prevent Rebasing Shared Branches)

```bash
#!/bin/bash
# .git/hooks/pre-rebase

# Prevent rebasing branches that have been pushed
TARGET_BRANCH="origin/main"
MERGE_BASE=$(git merge-base HEAD "$TARGET_BRANCH")

if [ $(git log --oneline "$MERGE_BASE"..HEAD | wc -l) -gt 0 ]; then
  echo "⚠️  WARNING: You are rebasing commits that have been pushed to $TARGET_BRANCH"
  echo "This will rewrite history. Use --force-with-lease if you're sure."
  read -p "Continue? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi
```

---

## Part 10: Advanced Recovery Scenarios

### Recover Lost Stash

```bash
# Find dropped stash in reflog
git fsck --no-dangling | grep commit
# Or check stash reflog
git log --walk-reflogs --all | grep -i stash

# Recover a specific stash
git stash apply stash@{n}

# If stash was dropped during merge conflict
git checkout stash@{0} -- <file>  # Restore specific file from stash
```

### Corrupted Index Recovery

```bash
# Symptom: "fatal: index corrupt" or "error: bad index"

# Remove the index and let Git recreate it
rm .git/index
git reset                            # Recreates the index from HEAD

# Or if that fails, full recovery
git fsck --full
# Look for dangling commits/blobs
# Recover any important data

# Nuclear option: reinitialize
git init
git remote add origin <url>
git fetch origin
git reset origin/main
```

### Recover Deleted Branch

```bash
# Find the last commit on the deleted branch
git reflog
# Look for the commit hash where the branch was

# Recreate the branch
git checkout -b recovered-branch <hash>

# Or if you just need the commits
git cherry-pick <hash1> <hash2> <hash3>
```

### Fix Accidental Force Push

```bash
# If you force pushed and need to undo it
# First, find where the branch was before force push
git reflog
# Look for "rebase" or "push" entries

# If someone else force pushed to remote
git fetch origin
git reflog origin/main              # See where origin/main was before

# Option 1: Reset to the pre-force-push state
git push origin pre-force-push:main --force

# Option 2: Contact the person who force pushed
# They should have the old history in their reflog
```

### Clean Up Messy History

```bash
# Nuclear option: squash all commits into one
git reset --soft main~5             # Go back 5 commits, keep changes
git commit -m "feat: complete feature implementation"

# Alternative: use rebase to clean up last N commits
git rebase -i HEAD~5
# Squash all into one commit

# Reset entire branch to match remote (discard all local changes)
git fetch origin
git reset --hard origin/main
```

### Undo a Cherry-Pick

```bash
# Cherry-pick created a merge conflict or wrong commit
git cherry-pick --abort            # If in progress

# If already committed, revert the cherry-picked commit
git revert <commit-hash>

# Or use reflog to find the state before cherry-pick
git reflog
git reset HEAD@{1}                 # Go back to before cherry-pick
```

---

## Part 11: Git Configuration Patterns

### Essential Git Config

```bash
# User identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Better diffs
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

# Auto-correct typos
git config --global help.autocorrect 10

# Default branch name
git config --global init.defaultBranch main

# Better merge strategy
git config --global merge.conflictstyle zdiff3  # Show common ancestor in conflicts

# Push settings
git config --global push.default current
git config --global push.autoSetupRemote true

# Rebase settings
git config --global pull.rebase true              # Pull always rebase
git config --global rebase.autoSquash true         # Auto-squash fixup commits

# Signing commits
git config --global commit.gpgsign true
git config --global user.signingkey <your-key-id>

# Aliases for productivity
git config --global alias.st "status -sb"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.lg "log --oneline --graph --all --decorate"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.undo "reset --soft HEAD~1"
```

### .gitattributes for Cross-Platform

```gitattributes
# Auto detect text files and perform LF normalization
* text=auto

# Explicitly declare text files
*.md text diff=markdown
*.txt text
*.json text
*.yaml text
*.yml text

# Declare binary files
*.png binary
*.jpg binary
*.gif binary
*.zip binary
*.pdf binary

# Custom diff drivers
*.ts diff=typescript
*.rs diff=rust
```

---

## Part 12: Output Format

### For Problem Resolution

```
## Git Problem Resolution

**Problem:** [one-line description]
**Current State:** [branch, status, relevant history]

### Solution
```bash
# Step 1: [what this does]
git <command>

# Step 2: [what this does]
git <command>
```

### What Happened
[Brief explanation of why the problem occurred]

### Prevention
[How to avoid this in the future]
```

### For Workflow Recommendations

```
## Recommended Git Workflow

**Team size:** [solo / small / large]
**Deployment model:** [continuous / release-based / hybrid]

### Workflow: [GitHub Flow / Git Flow / Trunk-Based / Forking]
[Description of how the workflow works]

### Branch Naming Convention
[Convention with examples]

### Commit Message Convention
[Convention with examples]

### Key Commands
[Essential commands for this workflow]
```

---

## Rules

- Always check `git status` and `git log` before suggesting commands. Never guess the repo state.
- Warn clearly before any command that is destructive or hard to reverse (e.g., `reset --hard`, `force push`).
- Provide the exact commands — don't say "rebase onto main" without showing the command.
- If the user's Git version matters for a command, note it.
- Present the response in the user's language; keep Git commands and technical terms in English.
- For force push recovery, always check reflog first — it's your safety net.
- For rebasing shared branches, warn about history rewrite and suggest `--force-with-lease` over `--force`.
- For submodule issues, always check if submodules are initialized before suggesting updates.
- For monorepo setups, prefer modern tools (Turborepo, Nx) over manual workspace management.
