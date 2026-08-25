---
name: changelog
description: >-
  Generate changelogs, release notes, and version documentation from git commit history,
  pull requests, or issue trackers. Use this skill whenever the user mentions changelog,
  release notes, what's new, release summary, version notes, update log, changelog from commits,
  generate changelog, release notes from git, semantic versioning, semver, conventional commits,
  breaking changes, migration guide, Keep a Changelog, versioning strategy,
  یادداشت نسخه, لاگ تغییرات, تاریخچه تغییرات, یادداشت انتشار, نسخه جدید,
  or wants to generate a summary of changes for a release or time period.
---

# Changelog Skill — Professional Release Notes & Version Documentation

## Overview

This skill generates human-readable changelogs, release notes, and version documentation by analyzing git commit history, pull request descriptions, and issue references. It categorizes changes by type (features, fixes, breaking changes) and produces structured documents that tell users and developers what changed, why, and what they need to do about it. This skill also covers semantic versioning strategy, conventional commits, breaking change documentation, and migration guide generation.

## When to Use This Skill

- User asks for a changelog, release notes, or "what's new"
- User wants to summarize changes between two git refs (tags, branches, commits)
- User needs release notes for a new version release
- User asks about semantic versioning or versioning strategy
- User needs a migration guide for breaking changes
- User mentions یادداشت نسخه, لاگ تغییرات, or تاریخچه تغییرات
- User asks "what changed since [version/tag]"
- User wants to generate a CHANGELOG.md file

---

## Part 1: Changelog Formats

### Format 1: Keep a Changelog (Recommended)

The most widely adopted format. Based on https://keepachangelog.com/

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature X that does Y
- Support for Z integration

### Changed
- Updated API endpoint for better performance
- Migrated from library A to library B

### Deprecated
- Feature X will be removed in v3.0.0 (use Feature Y instead)

### Removed
- Removed legacy endpoint `/api/v1/old-endpoint`

### Fixed
- Fixed crash when input is empty
- Fixed memory leak in connection pool

### Security
- Updated dependency CVE-2024-1234
- Added rate limiting to auth endpoints

## [1.2.0] - 2024-01-15

### Added
- User dashboard with analytics
- CSV export functionality

### Fixed
- Login timeout on slow connections
- Incorrect timezone handling

## [1.1.1] - 2024-01-10

### Fixed
- Critical bug in payment processing
- Session expiration not working correctly
```

### Format 2: Conventional Commits Based

Auto-generated from commit messages following Conventional Commits spec:

```markdown
# Changelog

## [2.0.0] - 2024-03-01

### ⚠ BREAKING CHANGES

* **auth:** remove deprecated `/api/v1/auth` endpoint (#456)
* **api:** change response format for list endpoints (#458)

### 🚀 Features

* **dashboard:** add real-time analytics widget (#445)
* **export:** support CSV and PDF export formats (#448)
* **webhooks:** add webhook delivery with retry logic (#452)

### 🐛 Bug Fixes

* **auth:** fix token refresh race condition (#444)
* **search:** fix pagination returning wrong page count (#450)
* **ui:** fix dark mode toggle not persisting (#455)

### 📦 Dependencies

* **core:** upgrade Express from 4.18 to 4.19 (#447)
* **security:** patch CVE-2024-1234 in lodash (#451)

### 🏗️ Internal

* **ci:** migrate from Travis CI to GitHub Actions (#443)
* **test:** increase coverage from 78% to 92% (#449)
```

### Format 3: User-Friendly Release Notes

For end-user facing releases:

```markdown
# What's New in v2.0.0

## 🎉 New Features

### Real-Time Dashboard
Get instant insights with our new real-time analytics dashboard.
View live metrics, track user engagement, and monitor system health
all in one place.

### CSV & PDF Export
Export your data in CSV or PDF format. Just click the export button
on any report page and choose your format.

### Webhook Notifications
Get notified when important events happen. Configure webhooks to
send alerts to Slack, Discord, or your custom endpoint.

## 🔧 Improvements

- **Faster searches:** Search results now load 3x faster
- **Better mobile experience:** Redesigned for mobile devices
- **Improved accessibility:** Full keyboard navigation support

## 🐛 Bug Fixes

- Fixed login issues on Safari browsers
- Fixed incorrect totals in monthly reports
- Fixed notification emails going to spam

## ⚠️ Breaking Changes

- The `/api/v1/auth` endpoint has been removed. Use `/api/v2/auth` instead.
- List API responses now use `items` instead of `data` field.

## 📦 Migration Guide

Upgrading from v1.x? See our [Migration Guide](./MIGRATION-v2.md) for step-by-step instructions.

## 🙏 Thank You

Thanks to all contributors who made this release possible!
@alice, @bob, @charlie
```

---

## Part 2: Semantic Versioning (SemVer)

### Version Format: `MAJOR.MINOR.PATCH`

| Change Type | Version Bump | Example |
|------------|-------------|---------|
| Breaking changes | MAJOR (X.0.0) | 1.0.0 → 2.0.0 |
| New features (backward-compatible) | MINOR (0.X.0) | 1.0.0 → 1.1.0 |
| Bug fixes (backward-compatible) | PATCH (0.0.X) | 1.0.0 → 1.0.1 |

### Pre-Release Versions

```
1.0.0-alpha.1    # Early development, unstable
1.0.0-alpha.2    # More testing needed
1.0.0-beta.1     # Feature complete, testing phase
1.0.0-beta.2     # Bug fixes during beta
1.0.0-rc.1       # Release candidate, final testing
1.0.0            # Stable release
```

### Version Bump Decision Tree

```
Does this change break the public API?
├── YES → Bump MAJOR (X.0.0)
│         Examples: Removed endpoint, changed response format,
│         removed function, changed error behavior
├── NO → Does this add new functionality?
│         ├── YES → Bump MINOR (0.X.0)
│         │         Examples: New endpoint, new parameter,
│         │         new feature, new optional field in response
│         └── NO → Bump PATCH (0.0.X)
│                   Examples: Bug fix, security patch,
│                   performance improvement, documentation fix
```

### What Counts as Breaking

- Removing an endpoint
- Renaming a field in the response
- Changing the type of a field
- Changing error response format
- Changing authentication requirements
- Removing a function or method
- Changing the behavior of a function
- Dropping support for a platform/version

### What Does NOT Count as Breaking

- Adding a new endpoint
- Adding a new field to the response
- Adding a new optional parameter
- Adding a new optional header
- Adding a new event type
- Fixing a bug (even if behavior changes from "broken" to "correct")

---

## Part 3: Conventional Commits

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description | Version Bump |
|------|-------------|-------------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | None |
| `style` | Code style (formatting, semicolons, etc.) | None |
| `refactor` | Code change that neither fixes a bug nor adds a feature | None |
| `perf` | Performance improvement | PATCH |
| `test` | Adding or updating tests | None |
| `build` | Build system or external dependencies | None |
| `ci` | CI configuration | None |
| `chore` | Other changes that don't modify src or test | None |
| `revert` | Reverts a previous commit | Depends on reverted commit |

### Breaking Change Indicator

```
feat!: remove deprecated API endpoints

BREAKING CHANGE: The /api/v1/* endpoints have been removed.
Use /api/v2/* instead.
```

Or in the footer:
```
feat: add new authentication system

BREAKING CHANGE: auth middleware now requires JWT tokens
instead of session cookies
```

### Examples

```bash
# Feature
git commit -m "feat(auth): add OAuth 2.0 login support"

# Bug fix
git commit -m "fix(api): handle null response from upstream service"

# Breaking change
git commit -m "feat(api)!: change list endpoint response format

BREAKING CHANGE: List endpoints now return { items: [], total: N }
instead of { data: [], count: N }"

# Multiple scopes
git commit -m "fix(auth,api): resolve token refresh race condition"

# With body
git commit -m "feat(dashboard): add real-time analytics

- WebSocket connection for live updates
- Auto-reconnect on disconnect
- Configurable refresh interval

Closes #123, #456"
```

---

## Part 4: Changelog Generation Workflow

### Step 1: Determine the Scope

1. **Identify the range** — Ask or detect which commits to include:
   - Between two tags: `v1.2.0..v1.3.0`
   - Between a tag and HEAD: `v1.3.0..HEAD`
   - Between two branches: `main..feature-xyz`
   - All commits within a date range
2. **Identify the version** — If generating release notes, confirm the new version number.
3. **Check for existing conventions** — Look for:
   - Existing `CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`
   - Conventional Commits (`feat:`, `fix:`, `BREAKING CHANGE:`)
   - `semantic-release` or `standard-version` config
   - Existing formatting patterns

### Step 2: Extract Commit Data

```bash
# Get commit summaries
git log v1.2.0..v1.3.0 --oneline

# Get full details
git log v1.2.0..v1.3.0 --format="%H %s %an %ad" --date=short

# Get stats
git log v1.2.0..v1.3.0 --stat

# Get conventional commit prefixes
git log v1.2.0..v1.3.0 --format="%s" | grep -E "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)"
```

### Step 3: Parse Conventional Commits

If conventional commits are used, parse the prefixes:
- `feat:` → New Feature
- `fix:` → Bug Fix
- `perf:` → Performance Improvement
- `docs:` → Documentation
- `refactor:` → Code Refactoring
- `test:` → Tests
- `chore:` / `ci:` → Internal / CI
- `BREAKING CHANGE:` → Breaking Change (check body too)

### Step 4: Categorize and Group

Group commits into standard categories:

```markdown
### Breaking Changes
[Changes that require user action or migration]

### New Features
[New functionality added]

### Bug Fixes
[Issues resolved]

### Performance
[Speed, memory, or efficiency improvements]

### Documentation
[Docs-only changes]

### Internal
[Refactors, CI, tests, chores]
```

Within each category, sort by significance (most impactful first) or by component/module.

### Step 5: Enrich with Context

For each significant change:
1. **Summarize the commit message** — Rewrite terse commit messages into user-friendly descriptions
2. **Link to issues/PRs** — If commit messages reference `#123` or `PR-456`, include those references
3. **Identify migration steps** — For breaking changes, briefly state what users need to change
4. **Add contributor credits** — If desired, list contributors based on commit authors

---

## Part 5: Breaking Change Documentation

### Breaking Change Template

```markdown
## ⚠️ Breaking Changes

### Removed: [Feature Name]

**What changed:** The `/api/v1/users` endpoint has been removed.

**Why:** Replaced by the more efficient `/api/v2/users` endpoint with
better filtering and pagination support.

**Migration:**
1. Replace `/api/v1/users` with `/api/v2/users`
2. Update pagination parameters from `?page=1&per_page=20` to
   `?cursor=xxx&limit=20`
3. Update response parsing: `response.data` → `response.items`

**Timeline:** v1.x endpoints will be removed on 2024-06-01.
```

### Migration Guide Template

```markdown
# Migration Guide: v1.x → v2.0

## Overview

v2.0.0 introduces several breaking changes to improve API consistency
and performance. This guide will help you upgrade.

## Breaking Changes

### 1. Authentication Change
- **Before:** Session cookies
- **After:** JWT Bearer tokens
- **Action:** Update your auth middleware to send `Authorization: Bearer <token>` header

### 2. List Response Format
- **Before:** `{ data: [...], count: 100 }`
- **After:** `{ items: [...], total: 100, has_more: true }`
- **Action:** Update response parsing in your API client

### 3. Removed Endpoints
- `/api/v1/upload` → Use `/api/v2/files` (POST)
- `/api/v1/export` → Use `/api/v2/reports/export`

## Upgrade Steps

1. Update the package: `npm install @myapp/sdk@2.0.0`
2. Update authentication: [see auth section]
3. Update API calls: [see endpoint changes]
4. Run tests: `npm test`
5. Deploy to staging first, verify, then production

## Rollback

If you need to roll back to v1.x:
1. `npm install @myapp/sdk@1.9.0`
2. Revert auth changes
3. Redeploy
```

---

## Part 6: Automated Changelog Tools

### Tool Recommendations

| Tool | Type | Best For |
|------|------|----------|
| **standard-version** | CLI | Node.js projects, Conventional Commits |
| **semantic-release** | CI/CD | Fully automated releases |
| **conventional-changelog** | CLI | Generate changelog from commits |
| **git-cliff** | CLI | Fast, customizable, Rust-based |
| **release-please** | CI/CD | Google-maintained, GitHub Actions |
| **auto-changelog** | CLI | Python projects |
| **github-changelog-generator** | CLI | GitHub-centric workflows |

### standard-version Usage

```bash
# Install
npm install -g standard-version

# Auto-detect version bump from commits
standard-version

# Specific bump type
standard-version --release-as minor

# Dry run (preview)
standard-version --dry-run

# Include specific files
standard-version --header "# Changelog"
```

### semantic-release Usage

```yaml
# .releaserc.yml
branches:
  - main
  - next

plugins:
  - "@semantic-release/commit-analyzer"
  - "@semantic-release/release-notes-generator"
  - "@semantic-release/changelog"
  - "@semantic-release/npm"
  - "@semantic-release/github"

# In CI/CD pipeline
# Runs automatically on push to main
```

### git-cliff Usage

```bash
# Install
cargo install git-cliff

# Generate changelog
git-cliff --output CHANGELOG.md

# With conventional commits
git-cliff --tag v1.0.0

# Custom config
git-cliff --config cliff.toml
```

---

## Part 7: Changelog Quality Rules

### DO

- ✅ Group changes by type (features, fixes, breaking changes)
- ✅ Use human-readable language (not just commit messages)
- ✅ Link to issues and PRs
- ✅ Include migration steps for breaking changes
- ✅ Date each version (ISO 8601: YYYY-MM-DD)
- ✅ Follow an existing format if one exists
- ✅ Credit contributors
- ✅ Include the diff URL or comparison link

### DON'T

- ❌ Invent changes that don't exist in the commits
- ❌ Include every commit (filter internal/insignificant ones for user-facing notes)
- ❌ Use commit hashes without context
- ❌ Forget to document breaking changes prominently
- ❌ Mix user-facing and internal changes without separating them
- ❌ Use jargon that non-developers won't understand (for user-facing notes)

---

## Output Format

```markdown
# Changelog

## [X.Y.Z] - YYYY-MM-DD

### Breaking Changes ⚠️
- **Description of breaking change** ([#123](link))
  - Migration: What users need to do

### New Features 🚀
- **Feature name**: Brief description ([#124](link))

### Bug Fixes 🐛
- **Bug description**: What was fixed ([#125](link))

### Performance ⚡
- **Improvement description** ([#126](link))

### Documentation 📚
- **Doc change** ([#127](link))

### Internal 🏗️
- Refactors, CI, tests (collapsed for user-facing notes)

---

## [X.Y.(Z-1)] - YYYY-MM-DD
```

## Rules

- **Be accurate.** Every entry must correspond to a real commit. Don't invent changes.
- **Be useful.** A changelog is for humans, not machines. Explain impact, not just diff.
- **Be honest.** If nothing notable changed, say so. Don't pad the list.
- **Follow conventions.** If the project uses Conventional Commits, respect the structure.
- **Prioritize breaking changes.** They should always be the first section, highly visible.
- **Write for the audience.** User-facing release notes ≠ developer changelogs.
- **Include links.** Link to issues, PRs, and migration guides.
- **Date everything.** Every version entry must have a date.
