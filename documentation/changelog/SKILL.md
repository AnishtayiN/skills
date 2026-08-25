---
name: changelog
description: >-
  Generate changelogs, release notes, and migration guides from commit history and code changes.
  TRIGGERS: changelog, release notes, version history, what changed, migration guide, breaking changes,
  what's new, version log, commit history, semantic versioning, semver, conventional commits,
  تاریخچه تغییرات, یادداشت انتشار, راهنمای مهاجرت, تغییرات شکستنده, نسخه جدید چی داره
  更新日志, 发布说明, 变更历史, 迁移指南, 破坏性变更, 语义化版本
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Changelog & Release Notes Skill

## Overview

Generate structured changelogs, user-facing release notes, and migration guides from commit history, git tags, and code changes. Ensures consistent formatting following industry standards like Keep a Changelog and Conventional Commits. Supports monorepo environments, semantic versioning enforcement, and multi-audience output (developer-facing vs. user-facing).

## When to Use This Skill

- User asks "what changed since version X?" or "generate release notes"
- Before tagging a new release, a changelog entry is needed
- A breaking change was made and a migration guide is required
- User requests a summary of commit history for a time period
- Automating release documentation in CI/CD pipelines
- Monorepo packages need per-package changelogs
- Auditing version history for compliance or auditing purposes

## When NOT to Use This Skill

- Simple `git log` display (no formatting needed)
- User only wants to see diff of a single commit
- Commit message rewriting (use git-workflow skill)
- Real-time collaboration or pair-programming notes

## Workflow (Detailed Multi-Phase)

### Phase 1: Source Collection

```
1. Detect commit convention
   → Read last 50-100 commits: git log --oneline -100
   → Check for Conventional Commits pattern: type(scope): message
   → If no convention → infer from commit message patterns

2. Identify version boundaries
   → List existing git tags: git tag --sort=-version:refname
   → Identify the latest release tag
   → Determine the commit range for the new changelog

3. Detect monorepo structure
   → Check for workspaces in package.json / lerna.json / pnpm-workspace.yaml
   → If monorepo → scope commits to affected packages
   → If single package → proceed with full commit range
```

### Phase 2: Classification & Parsing

```
1. Parse each commit in the range
   → Extract: type, scope, subject, body, breaking indicator
   → Normalize commit types to categories:
       feat     → Added
       fix      → Fixed
       docs     → Documentation
       style    → Formatting (skip in user-facing notes)
       refactor → Changed (internal)
       perf     → Performance
       test     → Tests (skip in user-facing notes)
       build    → Build system
       ci       → CI/CD
       chore    → Maintenance (skip in user-facing notes)
       revert   → Reverted

2. Identify breaking changes
   → Commits with "!" before colon: feat!: ...
   → Commits with "BREAKING CHANGE:" in body
   → Commits with "BREAKING-CHANGE:" in body
   → Major version bump required if any found

3. Group commits by category
   → Added (feat)
   → Changed (refactor, perf)
   → Deprecated (deprecated:)
   → Removed (removed:, breaking)
   → Fixed (fix)
   → Security (security:)
   → Documentation (docs)
```

### Phase 3: Version Determination

```
1. Determine next version (if not specified)
   → If any BREAKING changes → increment MAJOR
   → If any feat commits → increment MINOR
   → If only fix commits → increment PATCH

2. Validate version
   → Check against existing tags (no duplicates)
   → Verify semantic versioning compliance
   → Format: MAJOR.MINOR.PATCH[-prerelease][+build]
```

### Phase 4: Generation

```
1. Select output format
   → Keep a Changelog (keepachangelog.com)
   → GitHub Releases markdown
   → Simple bullet list
   → Full structured report

2. Generate content per format
   → Apply templates (see Output Format Templates)
   → Filter noise commits (chore, style, test)
   → Add commit hashes for traceability
   → Link to compare URLs when possible

3. Generate migration guide (if breaking changes)
   → List each breaking change with before/after code
   → Provide step-by-step migration instructions
   → Note deprecated alternatives
```

### Phase 5: Review & Finalize

```
1. Validate output
   → All significant commits captured
   → No formatting errors
   → Version numbers consistent
   → Links are valid (if generated)

2. Present to user
   → Show draft for approval
   → Offer format alternatives
   → Suggest release strategy if applicable
```

## Advanced Techniques

### 1. Conventional Commits Deep Parsing

```bash
# Parse structured commit messages with regex
git log --format="%H|%s|%b" v1.0.0..HEAD | while IFS='|' read -r hash subject body; do
  # Match: type(scope)?: description
  if [[ "$subject" =~ ^([a-zA-Z]+)(\(([^)]+)\))?!?:\ (.+)$ ]]; then
    TYPE="${BASH_REMATCH[1]}"
    SCOPE="${BASH_REMATCH[3]}"
    DESC="${BASH_REMATCH[4]}"
    IS_BREAKING=false
    [[ "$subject" == *"!"* ]] && IS_BREAKING=true
    # Check body for BREAKING CHANGE
    if echo "$body" | grep -qi "BREAKING CHANGE:"; then
      IS_BREAKING=true
    fi
  fi
done
```

### 2. Semantic Version Bumping Logic

```python
def determine_bump_type(commits: list[dict]) -> str:
    """Analyze commits to determine version bump type."""
    has_breaking = any(c['breaking'] for c in commits)
    has_feat = any(c['type'] == 'feat' for c in commits)
    has_fix = any(c['type'] == 'fix' for c in commits)

    if has_breaking:
        return 'major'
    elif has_feat:
        return 'minor'
    elif has_fix:
        return 'patch'
    else:
        return 'none'

def next_version(current: str, bump: str) -> str:
    major, minor, patch = map(int, current.split('.'))
    if bump == 'major':
        return f"{major + 1}.0.0"
    elif bump == 'minor':
        return f"{major}.{minor + 1}.0"
    elif bump == 'patch':
        return f"{major}.{minor}.{patch + 1}"
    return current
```

### 3. Monorepo Scoped Changelog

```bash
# Generate changelog scoped to a specific package
SCOPE="frontend"
git log --oneline --all -- "packages/$SCOPE/" | while read -r line; do
  HASH=$(echo "$line" | cut -d' ' -f1)
  MSG=$(echo "$line" | cut -d' ' -f2-)
  echo "| $HASH | $MSG |"
done
```

### 4. Breaking Changes Documentation Generator

```markdown
## Breaking Changes

### 1. Removed `legacyAuth` parameter from `login()`
**Before:**
\```js
login({ username, password, legacyAuth: true })
\```

**After:**
\```js
login({ username, password, authVersion: 2 })
\```

**Migration:** Replace `legacyAuth: true` with `authVersion: 2`.
```

### 5. Automated Changelog Validation

```bash
# Validate that changelog has been updated before release
CHANGELOG_MODIFIED=$(git diff --name-only HEAD~1..HEAD | grep -c "CHANGELOG.md")
if [ "$CHANGELOG_MODIFIED" -eq 0 ]; then
  echo "WARNING: CHANGELOG.md not updated in this release"
  exit 1
fi
```

### 6. Diff-Based Changelog for Untagged Projects

```bash
# When no tags exist, use first commit as baseline
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)
git log --oneline "$FIRST_COMMIT"..HEAD
```

### 7. Multi-Audience Changelog Generation

```bash
# Developer-facing: includes commit hashes, PR numbers, technical details
# User-facing: plain language, feature descriptions, upgrade instructions
# Generate both simultaneously from same commit data
```

## Common Patterns

### Pattern 1: Generate Changelog from Git Tags

```bash
PREV_TAG=$(git tag --sort=-version:refname | head -n1)
NEXT_VERSION="1.2.0"
echo "## [$NEXT_VERSION] - $(date +%Y-%m-%d)" >> CHANGELOG.md
echo "" >> CHANGELOG.md
git log "$PREV_TAG"..HEAD --pretty=format:"- %s (%h)" >> CHANGELOG.md
```

### Pattern 2: Auto-detect Version Bump from Commits

```python
import subprocess, re

output = subprocess.check_output(['git', 'log', '--oneline', '-50']).decode()
bump = 'patch'
for line in output.splitlines():
    if re.search(r'^(feat|fix)\b', line.split(' ', 1)[1] if ' ' in line else ''):
        if 'feat' in line:
            bump = 'minor'
    if 'BREAKING' in line or re.search(r'\w+!', line.split(' ')[1]):
        bump = 'major'
        break
```

### Pattern 3: GitHub-Style Release Notes Template

```markdown
## What's New
- **Feature X**: Description of new feature (#123)
- **Improved Y**: Description of improvement (#456)

## Bug Fixes
- Fixed crash when loading large files (#789)
- Resolved race condition in auth flow (#012)

## Breaking Changes
- `oldFunction()` removed → use `newFunction()` instead

## Dependencies
- Updated `react` from 17.x to 18.x

**Full Changelog**: https://github.com/org/repo/compare/v1.0.0...v1.1.0
```

### Pattern 4: Conventional Commits to Keep a Changelog

```python
CATEGORY_MAP = {
    'feat': 'Added',
    'fix': 'Fixed',
    'perf': 'Changed',
    'refactor': 'Changed',
    'docs': 'Documentation',
    'deprecated': 'Deprecated',
    'removed': 'Removed',
    'security': 'Security',
}

def commits_to_changelog(commits: list[dict]) -> str:
    sections = {}
    for commit in commits:
        cat = CATEGORY_MAP.get(commit['type'], None)
        if cat is None:
            continue
        sections.setdefault(cat, []).append(f"- {commit['description']} ({commit['hash'][:7]})")

    output = ""
    for section in ['Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security']:
        if section in sections:
            output += f"### {section}\n"
            output += "\n".join(sections[section]) + "\n\n"
    return output
```

### Pattern 5: Migration Guide Generator

```python
def generate_migration(breaking_changes: list[dict]) -> str:
    guide = "# Migration Guide\n\n"
    guide += "## Upgrading from v1.x to v2.0\n\n"
    for i, change in enumerate(breaking_changes, 1):
        guide += f"### Step {i}: {change['title']}\n\n"
        guide += f"**What changed:** {change['description']}\n\n"
        guide += f"**Before:**\n```{change['lang']}\n{change['before']}\n```\n\n"
        guide += f"**After:**\n```{change['lang']}\n{change['after']}\n```\n\n"
        if change.get('migration_steps'):
            guide += "**Migration steps:**\n"
            for step in change['migration_steps']:
                guide += f"1. {step}\n"
            guide += "\n"
    return guide
```

## Edge Cases & Pitfalls

1. **No commits in range** — When comparing identical tags or no changes exist, generate empty changelog section with note "No changes since last release."

2. **Squash merges lose context** — Squash-merged PRs collapse individual commits; use PR titles and labels instead of individual commit messages.

3. **Revert commits** — A `revert` commit cancels out the original. Either exclude both or note the revert explicitly as a separate entry.

4. **Merge commits noise** — Merge commits like "Merge branch 'main' into feature" are noise. Filter them out during classification.

5. **Non-Conventional Commits** — When commits don't follow any convention, fall back to grouping by author or directory affected rather than commit type.

6. **Monorepo cross-package commits** — A single commit may affect multiple packages. Ensure each package's changelog includes only relevant changes.

7. **Pre-release versions** — Tags like `v1.0.0-beta.1` or `v1.0.0-rc.2` need special handling in version comparison logic.

8. **Changelog merge conflicts** — Multiple releases in parallel branches cause CHANGELOG.md conflicts. Recommend top-of-file insertion strategy.

9. **Binary file changes** — Binary files (images, compiled assets) don't produce meaningful diffs. Note them as "Updated assets" without diff details.

10. **Automated commit messages** — Dependabot, Renovate, and bot commits need special handling (grouped under "Dependencies" or filtered out).

11. **Footnote links break** — Keep a Changelog uses reference-style links; ensure link definitions are maintained across releases.

12. **Timezone in dates** — Use ISO 8601 format (`YYYY-MM-DD`) consistently. Avoid locale-dependent date formats.

13. **Large monorepo performance** — `git log` on massive repos is slow. Use `--first-parent` or path filters to scope commits efficiently.

14. **Partial releases** — When only some packages are released in a monorepo, ensure changelogs only reflect committed package versions.

15. **Missing closing parentheses in scope** — Malformed commits like `feat(api: missing closing paren` should be logged as parsing errors and skipped.

## Integration with Other Skills

| Skill | Relationship | Usage |
|-------|-------------|-------|
| project-analysis | Precedes changelog | Analyzes project structure to detect monorepo/package layout |
| git-workflow | Complements | Enforces Conventional Commits format that feed changelog generation |
| code-review | Feeds into | Review notes can supplement changelog descriptions |
| documentation | Parallel | Changelog entries link to full documentation updates |
| ci-cd | Automates | Changelog generation integrated into release pipelines |
| requirement-analysis | Supplements | Breaking changes require migration guide per requirements |

## Output Format Templates

### Template 1: Keep a Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Feature X for improved performance (#123)

### Fixed
- Crash on null input (#456)

### Changed
- Refactored auth module for clarity (#789)

## [1.2.0] - 2025-01-15

### Added
- Feature Y (#100)

### Fixed
- Login timeout issue (#200)

[Unreleased]: https://github.com/org/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/org/repo/compare/v1.1.0...v1.2.0
```

### Template 2: GitHub Releases Format

```markdown
## 🚀 What's New
- **New Feature X**: Enables real-time collaboration (#123)
- **Improved Y**: 50% faster load times (#456)

## 🐛 Bug Fixes
- Fixed crash when file size exceeds 100MB (#789)
- Resolved authentication loop on expired tokens (#012)

## ⚠️ Breaking Changes
- `config.legacy` option removed. Use `config.modern` instead.
- Minimum Node.js version is now 18.x

## 📦 Dependencies
- Upgraded `express` 4.x → 5.x

---
**📦 Installation:** `npm install package@2.0.0`
**📖 Docs:** [Migration Guide](./MIGRATION-v2.md)
**🔗 Full Changelog:** https://github.com/org/repo/compare/v1.0.0...v2.0.0
```

### Template 3: Simple Bullet List

```markdown
# Release v1.2.0 (2025-01-15)

- Added feature X for better performance
- Fixed crash on large file upload
- Updated documentation for API v2
- Removed deprecated `legacyAuth` option
```

### Template 4: Structured Report with Metadata

```markdown
# Release Report: v1.2.0

| Field | Value |
|-------|-------|
| Version | 1.2.0 |
| Release Date | 2025-01-15 |
| Previous Version | 1.1.0 |
| Commits | 47 |
| Contributors | 5 |
| Breaking Changes | 2 |
| New Features | 8 |
| Bug Fixes | 12 |

## Summary
Version 1.2.0 introduces real-time collaboration features and
improves performance by 50%. Two breaking changes require
migration — see [Migration Guide](./MIGRATION-v1.2.0.md).

## Commits by Category
### Features (8)
- `abc1234` feat(auth): add OAuth2 support (#123)
- `def5678` feat(ui): dark mode toggle (#124)
...

### Fixes (12)
- `ghi9012` fix(upload): handle files >100MB (#125)
...

### Breaking Changes (2)
- `jkl3456` feat!: remove legacy auth endpoint (#130)
- `mno7890` feat!: require Node.js 18+ (#131)

### Migration Required
See [MIGRATION-v1.2.0.md](./MIGRATION-v1.2.0.md) for upgrade instructions.
```

## Rules

1. **Always verify commit range** — Confirm the correct tag range before generating. A wrong range produces incorrect or duplicate entries.

2. **Never include internal-only commits in user-facing notes** — Commits of type `chore`, `style`, `test`, `ci`, and `build` are noise for end users.

3. **Always include commit hashes** — Every changelog entry must reference its source commit hash for traceability and debugging.

4. **Use ISO 8601 dates** — All dates must be in `YYYY-MM-DD` format. No exceptions.

5. **Determine version bump before generating** — Analyze all commits first, determine bump type, then generate content. Do not generate then decide version.

6. **Breaking changes always require a migration guide** — If any breaking change exists, produce a migration document with before/after code examples.

7. **Never modify existing changelog entries** — Past releases are immutable. Always append new entries above older ones.

8. **Filter automated bot commits appropriately** — Dependabot/Renovate PRs go under "Dependencies", not individual feature/fix categories.

9. **Validate monorepo package scope** — In monorepos, ensure each package's changelog only references commits that actually modified that package's code.

10. **Provide both developer and user views** — Generate commit-level detail for developers AND plain-language summary for end users when requested.

11. **Link to comparison URLs** — When a remote (GitHub/GitLab) is detected, include `compare` links between versions.

12. **Handle empty changelogs gracefully** — If no qualifying changes exist, state "No user-facing changes in this release" rather than producing an empty document.

13. **Escape markdown special characters** — Commit messages containing `|`, `*`, `_`, or `#` must be properly escaped in markdown output.

14. **Support pre-release versions** — Alpha, beta, and RC tags must be handled with proper semver pre-release ordering (alpha < beta < rc < release).

15. **Reproducible output** — Given the same commits and version, the output must be identical. Use deterministic sorting (by hash or commit order).
