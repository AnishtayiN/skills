---
name: git-workflow
description: >-
  Git operations: commits, branches, merges, rebases, conflict resolution, history management.
  TRIGGERS: git, commit, branch, merge, rebase, conflict, stash, cherry-pick, revert, reset,
  git log, git diff, pull request, pr, merge conflict,
  گیت, کامیت, برانچ, ادغام, کانفلیکت, ری‌بیس, درخواست ادغام,
  git分支, git合并, git变基, 冲突解决, 提交规范, 代码管理
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Git Workflow Skill

## Purpose

Manage Git operations safely and effectively, including branching strategies, conflict resolution, bisect debugging, cherry-pick workflows, interactive rebase, stash management, conventional commits, and Git hooks.

## When to Activate

- Creating commits or conventional commits
- Managing branches with defined strategies
- Resolving merge conflicts
- Reviewing or approving PRs
- Recovering from Git mistakes
- Debugging with bisect
- Cherry-picking specific commits
- Configuring Git hooks
- Managing stashes across context switches

## Workflow

### Step 1: Understand the Repository

```
1. What branching strategy is in use? (gitflow, trunk-based, GitHub flow)
2. What is the commit convention? (conventional commits, angular)
3. What hooks are configured? (pre-commit, commit-msg, pre-push)
4. What is the remote strategy? (rebase vs merge for PRs)
5. Are there protected branches? (main, develop)
```

### Step 2: Choose the Right Operation

```
Need to create a feature?       → git checkout -b feature/name
Need to save work temporarily?   → git stash
Need to apply specific commit?   → git cherry-pick <sha>
Need to find breaking commit?    → git bisect
Need to clean up history?        → git rebase -i
Need to undo last commit?        → git reset --soft HEAD~1
Need to undo a commit entirely?  → git revert <sha>
```

### Step 3: Execute and Verify

```
1. Perform the Git operation
2. Verify with git log / git status / git diff
3. Push with appropriate flags (--force-with-lease for rebase)
4. Create/update PR with clear description
```

### Step 4: Post-Operation Cleanup

```
1. Delete merged branches
2. Prune remote tracking refs
3. Verify CI passes on updated branch
4. Update related documentation if needed
```

## Advanced Techniques

### 1. Branching Strategies

```bash
# ── Gitflow Strategy ──
# Ideal for: projects with scheduled releases, mobile apps
#
# main          ── production releases
#   └── develop ── integration branch
#       ├── feature/* ── new features (branch off develop)
#       ├── release/* ── release prep (branch off develop)
#       └── hotfix/*  ── emergency fixes (branch off main)

# Create feature branch
git checkout -b feature/user-auth develop

# Finish feature (merge back to develop)
git checkout develop
git merge --no-ff feature/user-auth
git branch -d feature/user-auth

# Create release
git checkout -b release/1.2.0 develop
# ... final fixes ...
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release 1.2.0"
git checkout develop
git merge --no-ff release/1.2.0

# Hotfix
git checkout -b hotfix/critical-fix main
# ... fix ...
git checkout main
git merge --no-ff hotfix/critical-fix
git tag -a v1.2.1
git checkout develop
git merge --no-ff hotfix/critical-fix

# ── Trunk-Based Strategy ──
# Ideal for: continuous deployment, microservices, small teams
#
# main ── all development happens here
#   └── short-lived feature branches (< 2 days)
#   └── release tags (not branches)

# Short-lived feature branch
git checkout -b feature/quick-fix main
# ... work (keep under 2 days) ...
git rebase main
git checkout main
git merge --no-ff feature/quick-fix
git branch -d feature/quick-fix

# ── GitHub Flow Strategy ──
# Ideal for: web applications, continuous deployment
#
# main ── always deployable
#   └── feature branches (PR-based)
git checkout -b feature/new-page main
# ... work ...
git push origin feature/new-page
# Create PR → review → merge to main → auto-deploy
```

### 2. Conflict Resolution

```bash
# Step 1: Understand the conflict
git status
# Shows: both modified: path/to/file.js

# Step 2: Open conflicted file and resolve markers
# <<<<<<< HEAD
# Current branch changes
# =======
# Incoming branch changes
# >>>>>>> feature/new-stuff

# Step 3: Use mergetool for complex conflicts
git mergetool --tool=vimdiff

# Step 4: Verify resolution
git diff --check  # Check for leftover conflict markers
git diff          # Review the final result

# Step 5: Complete the merge
git add .
git commit        # or git merge --continue

# Advanced: Take specific sides
git checkout --ours path/to/file.js      # Keep our version
git checkout --theirs path/to/file.js    # Take incoming version

# Advanced: Semantic merge with git mergetool
# Configure for specific file types
git config merge.tool vimdiff
git config mergetool.keepBackup false
```

### 3. Bisect Debugging

```bash
# Binary search for the commit that introduced a bug

# Start bisect
git bisect start
git bisect bad          # Current commit is broken
git bisect good v1.0.0  # This tag was working

# Git checks out a middle commit. Test it:
# Run your test or manual check

# Mark as good or bad
git bisect good   # If this commit works
git bisect bad    # If this commit is broken

# Repeat until Git identifies the culprit
# Bisect: first bad commit is abc1234

# Clean up
git bisect reset

# Automated bisect with a script
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
git bisect run npm test  # Automatically marks good/bad based on exit code

# Save bisect session
git bisect log > bisect.log
# Resume later
git bisect replay bisect.log
```

### 4. Cherry-Pick

```bash
# Apply a specific commit without merging the whole branch

# Single commit
git cherry-pick abc1234

# Multiple commits
git cherry-pick abc1234 def5678

# Range of commits (excluding start)
git cherry-pick abc1234..ghi9012

# Cherry-pick without committing (stage only)
git cherry-pick --no-commit abc1234

# Cherry-pick a merge commit
git cherry-pick -m 1 <merge-commit-sha>
# -m 1 keeps the branch side (parent 1)

# Abort in progress
git cherry-pick --continue  # After resolving conflicts
git cherry-pick --abort     # Cancel entirely

# Practical use: backport fix to release branch
git checkout release/1.x
git cherry-pick abc1234  # The fix from develop
git push origin release/1.x
```

### 5. Interactive Rebase

```bash
# Rewrite, reorder, squash, and clean up commit history

# Rebase last 5 commits
git rebase -i HEAD~5

# Editor opens with:
# pick abc1234 feat: add user login
# pick def5678 fix: typo in login
# pick ghi9012 feat: add user logout
# pick jkl3456 fix: logout bug
# pick mno7890 chore: update deps

# Commands:
# pick   = keep commit as-is
# reword = keep commit, edit message
# squash = merge into previous commit
# fixup  = like squash but discard this message
# drop   = remove commit entirely

# Rewritten example:
# pick   abc1234 feat: add user login
# fixup  def5678 fix: typo in login        → squashed into feat: add user login
# pick   ghi9012 feat: add user logout
# fixup  jkl3456 fix: logout bug            → squashed into feat: add user logout
# drop   mno7890 chore: update deps          → removed entirely

# Split a commit into two
git rebase -i HEAD~3
# Mark commit as 'edit'
# After rebase stops:
git reset HEAD^        # Unstage the commit
git add file1.js
git commit -m "feat: part 1"
git add file2.js
git commit -m "feat: part 2"
git rebase --continue

# Reorder commits
# Just reorder the lines in the editor
```

### 6. Stash Management

```bash
# Save work in progress without committing

# Basic stash
git stash
git stash push -m "WIP: login feature"  # Named stash

# Stash including untracked files
git stash -u              # Include untracked files
git stash --all           # Include ignored files too
git stash -p              # Interactive: choose hunks to stash

# List stashes
git stash list
# stash@{0}: On feature: WIP: login feature
# stash@{1}: On main: WIP: hotfix attempt

# Apply stash (keep stash in list)
git stash apply stash@{0}

# Pop stash (apply + remove from list)
git stash pop             # Latest stash
git stash pop stash@{2}  # Specific stash

# Create branch from stash
git stash branch new-feature stash@{0}
# Creates branch, checks out stash state, drops stash

# View stash contents
git stash show -p stash@{0}

# Drop stash
git stash drop stash@{0}
git stash clear           # Drop all stashes

# Practical: context switch mid-feature
git stash push -m "half-done login feature"
git checkout main
git pull
# ... urgent hotfix ...
git checkout feature/login
git stash pop
# Continue where left off
```

### 7. Conventional Commits

```bash
# Format: <type>[optional scope]: <description>

# Types:
# feat:     New feature (triggers MINOR version bump)
# fix:      Bug fix (triggers PATCH version bump)
# docs:     Documentation only
# style:    Formatting, missing semicolons (no code change)
# refactor: Code restructuring (no feature or fix)
# perf:     Performance improvement
# test:     Adding or correcting tests
# build:    Build system or dependencies
# ci:       CI configuration
# chore:    Maintenance tasks
# revert:   Revert a previous commit

# Examples with scopes
git commit -m "feat(auth): add OAuth2 Google login"
git commit -m "fix(api): handle null response in /users endpoint"
git commit -m "perf(db): add covering index for user queries"
git commit -m "refactor(core): extract validation middleware"

# Breaking changes
git commit -m "feat(api)!: change /users response format

BREAKING CHANGE: User object now returns 'fullName' instead of
separate 'firstName' and 'lastName' fields.

Migration guide: update all API consumers to use 'fullName'."

# Multi-paragraph commit body
git commit -m "feat(db): implement event sourcing for orders

Add event store table and projection rebuild logic.
Events are stored with stream_id, version, and payload JSONB.

Closes #234
Reviewed-by: Alice <alice@example.com>"

# Generate changelog from conventional commits
# npx conventional-changelog -p angular -i CHANGELOG.md -s
```

### 8. Git Hooks

```bash
# .git/hooks/pre-commit — runs before each commit
#!/bin/sh
set -e

# Run linter
echo "Running linter..."
npm run lint

# Run type check
echo "Running type check..."
npm run typecheck

# Run tests
echo "Running tests..."
npm test

echo "All checks passed!"

# .git/hooks/commit-msg — validate commit message format
#!/bin/sh
commit_msg=$(cat "$1")
pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,72}"

if ! echo "$commit_msg" | grep -qE "$pattern"; then
    echo "ERROR: Commit message does not follow Conventional Commits format."
    echo "Expected: <type>[scope]: <description>"
    echo "Got: $commit_msg"
    exit 1
fi

# .git/hooks/pre-push — prevent pushing to main directly
#!/bin/sh
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
if [ "$branch" = "main" ]; then
    echo "ERROR: Direct push to main is not allowed. Create a PR."
    exit 1
fi

# Install hooks using Husky (Node.js project)
# npx husky install
# npx husky add .husky/pre-commit "npm run lint"
# npx husky add .husky/commit-msg "npx commitlint --edit $1"
# npx husky add .husky/pre-push "npm test"

# Or use pre-commit framework (Python/universal)
# .pre-commit-config.yaml
# repos:
#   - repo: https://github.com/pre-commit/pre-commit-hooks
#     rev: v4.5.0
#     hooks:
#       - id: trailing-whitespace
#       - id: end-of-file-fixer
#       - id: check-yaml
#       - id: check-added-large-files
```

## Common Patterns

### Pattern 1: Feature Branch Workflow

```bash
# Create feature from main/develop
git checkout main
git pull origin main
git checkout -b feature/user-dashboard

# Work in small commits
git add src/components/Dashboard.tsx
git commit -m "feat(dashboard): add dashboard layout component"

git add src/api/dashboard.ts
git commit -m "feat(dashboard): add dashboard API client"

# Keep branch updated with main
git fetch origin
git rebase origin/main

# Push and create PR
git push origin feature/user-dashboard
# Create PR on GitHub/GitLab

# After approval, squash merge via UI or:
git checkout main
git merge --squash feature/user-dashboard
git commit -m "feat(dashboard): implement user dashboard (#42)"
git branch -d feature/user-dashboard
```

### Pattern 2: Hotfix Workflow

```bash
# Create hotfix from production tag
git checkout -b hotfix/critical-auth-fix v1.2.0

# Minimal fix
git add src/auth/login.ts
git commit -m "fix(auth): prevent token expiration bypass"

# Merge to both main and develop
git checkout main
git merge --no-ff hotfix/critical-auth-fix
git tag -a v1.2.1 -m "Hotfix: critical auth fix"

git checkout develop
git merge --no-ff hotfix/critical-auth-fix

git branch -d hotfix/critical-auth-fix
git push origin main --tags
```

### Pattern 3: Interactive Rebase Cleanup Before PR

```bash
# Before creating PR, clean up local history
git checkout feature/my-work
git rebase -i main

# Squash fixup commits, reorder, clean up messages
# Result: clean, logical commit history

# Force push (safe with --force-with-lease)
git push --force-with-lease origin feature/my-work
```

### Pattern 4: Bisect to Find Regression

```bash
# Automated bisect with test script
git bisect start
git bisect bad HEAD
git bisect good v2.0.0

# Create test script
cat > test.sh << 'EOF'
#!/bin/bash
npm run build 2>/dev/null || exit 125  # skip if build fails
npm test 2>/dev/null
EOF
chmod +x test.sh

git bisect run ./test.sh
# Output: abc1234 is the first bad commit
git bisect reset
```

### Pattern 5: Stash Context Switch

```bash
# Mid-feature, need to switch to urgent bug fix
git stash push -m "WIP: dashboard charts feature"
git checkout main
git checkout -b hotfix/api-crash

# Fix the bug
git add src/api/handler.ts
git commit -m "fix(api): handle nil pointer in user handler"
git push origin hotfix/api-crash
# Create PR, merge

# Return to feature work
git checkout feature/dashboard
git stash pop
# Continue exactly where left off
```

## Edge Cases & Pitfalls

1. **Force pushing to shared branches** — Never `git push --force` to main or develop; always use `--force-with-lease` which fails if someone else pushed first.
2. **Losing stashes with `git stash clear`** — Stashes are not branch-tracked; clearing them is permanent. Always list and verify before clearing.
3. **Merge conflicts after interactive rebase** — Rebasing rewrites history; if others have the old commits, they'll see conflicts. Coordinate with your team.
4. **Cherry-pick creating duplicate commits** — Cherry-picked commits have different SHAs; future merges may re-introduce the same changes. Document cherry-picks.
5. **Detached HEAD state** — Checking out a commit directly puts you in detached HEAD; new commits are orphaned. Always create a branch first.
6. **Bisect skipping too many commits** — If a commit doesn't build/test, use `git bisect skip` or return 125 (skip) in the test script.
7. **Squash merge losing context** — Squashing merges discards individual commit history; ensure the PR description captures sufficient context.
8. **Empty commits from `git commit --allow-empty`** — These can appear in `git log` and confuse `git bisect`; avoid them unless intentionally marking events.
9. **Submodule pointer drift** — Updating a submodule in a feature branch without updating the parent repo's pointer causes inconsistent states.
10. **Large file pushes exceeding limits** — Git LFS is required for large files; pushing binaries directly bloats the repository permanently.
11. **Git hooks not committed** — `.git/hooks/` is not tracked; use Husky or similar tools to manage hooks in `.husky/` or a tracked directory.
12. **Incorrect `git reset --hard`** — This discards all working directory changes; use `--soft` or `--mixed` unless you're certain about the data loss.
13. **PR merge commits from rebased branches** — After rebase, the merge base changes; GitHub may show confusing diffs. Verify the PR diff carefully.
14. **Convention enforcement without tooling** — Manual convention adherence fails; use commitlint, husky, and pre-commit hooks for enforcement.
15. **`.gitignore` not retroactive** — Files already tracked are not affected by `.gitignore` additions; use `git rm --cached` to stop tracking.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| project-analysis | Understand repo structure, history | ← | Analysis determines appropriate branching strategy |
| code-generation | Generate code in feature branches | → | Generated code follows commit conventions |
| testing | Pre-commit and pre-push test hooks | ↔ | Tests gate commits; CI validates on push |
| ci-cd | Pipeline triggers on push/PR | ↔ | Git events drive CI/CD; CI status reported back |
| code-review | PR-based review workflow | → | Branch strategy enables review gates |
| documentation | Commit messages as changelog source | → | Conventional commits auto-generate changelogs |
| security | Signed commits, GPG keys | ↔ | Security policies may require signed commits |
| dockerization | Docker build context via .gitignore | → | .gitignore affects Docker context sent to daemon |
| deployment | Deployment triggered by tags/merges | → | Git tags trigger release deployments |
| monitoring | Correlate deploys with git SHA | → | Git SHA in deploy metadata enables rollback correlation |

## Output Format Templates

### Template 1: Git Workflow Setup

```markdown
# Git Workflow Configuration

## Branching Strategy
- **Strategy**: [Gitflow / Trunk-Based / GitHub Flow]
- **Primary branch**: main
- **Integration branch**: develop (if Gitflow)
- **Feature prefix**: feature/, fix/, hotfix/, release/
- **Protected branches**: main, develop

## Commit Convention
- **Format**: Conventional Commits
- **Types**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- **Enforcement**: commitlint + husky pre-commit hook

## PR Rules
- [ ] Require 1 approval
- [ ] Require CI to pass
- [ ] Squash merge for features
- [ ] Rebase merge for hotfixes
- [ ] Delete branch after merge
```

### Template 2: Commit Message

```markdown
# Commit Message Template

<type>[optional scope]: <description>

[optional body]

[optional footer(s)]

---
Examples:
feat(auth): implement JWT refresh token rotation
fix(api): handle rate limit errors in webhook delivery
docs(readme): add deployment instructions for AWS
refactor(db): extract query builder into separate module
```

### Template 3: Branch Naming Convention

```markdown
# Branch Naming

## Format
<type>/<ticket-id>-<short-description>

## Examples
- feature/PROJ-123-user-dashboard
- fix/PROJ-456-login-redirect
- hotfix/PROJ-789-auth-bypass
- release/PROJ-100-v2.0.0
- chore/PROJ-200-upgrade-node

## Rules
- Lowercase only
- Hyphens for separators (no underscores)
- Max 50 characters
- Include ticket ID if available
```

### Template 4: Git Review Checklist

```markdown
## Git PR Review Checklist

### History
- [ ] Commits are logical and atomic
- [ ] Commit messages follow conventional format
- [ ] No merge commits in feature branch (rebased)
- [ ] No unnecessary files included
- [ ] .gitignore updated if needed

### Branch
- [ ] Branch is up to date with main
- [ ] Branch follows naming convention
- [ ] Not directly committed to protected branches

### Security
- [ ] No secrets in commits
- [ ] No large binary files (use LFS)
- [ ] Signed commits if required by policy
- [ ] No credentials in environment variables in code

### Post-Merge
- [ ] Branch auto-deletes after merge
- [ ] Related issues/tickets linked
- [ ] Changelog updated if needed
```

## Rules

1. **Never force push to shared branches** — Use `--force-with-lease` at minimum; coordinate with team before any history rewrite.
2. **Follow Conventional Commits for all commits** — Enforce via commitlint and pre-commit hooks; reject non-compliant messages.
3. **Keep feature branches short-lived** — Aim for < 2 days of work; long-lived branches increase merge conflict frequency.
4. **Always pull with rebase for feature branches** — `git pull --rebase` keeps history clean; reserve merge pulls for integration branches.
5. **Never commit directly to main or develop** — All changes go through feature branches and PRs, even small fixes.
6. **Delete branches after merge** — Merged branches are noise; delete them locally and remotely.
7. **Use `git stash` for temporary context switches only** — Don't stash for more than a few hours; commit or use work-in-progress branches instead.
8. **Test after every conflict resolution** — Resolved conflicts may introduce logical errors; always run the test suite.
9. **Tag every production release** — Semantic version tags (`v1.2.3`) enable precise rollback and bisect operations.
10. **Configure Git hooks via tooling, not manually** — Use Husky, pre-commit framework, or lint-staged to ensure hooks are shared across the team.
11. **Never commit generated files or secrets** — Verify `.gitignore` excludes `node_modules/`, `.env`, `dist/`, and build artifacts.
12. **Document all cherry-picks** — Cherry-picked commits create divergent history; add a note in the commit body indicating the source.
