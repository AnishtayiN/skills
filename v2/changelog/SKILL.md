---
name: changelog
description: >-
  Generate changelogs and release notes from git commit history, pull requests, or issue trackers. Supports Conventional Commits, Keep a Changelog, semantic-release, standard-version, auto-changelog, and custom formats. Use this skill whenever the user mentions changelog, release notes, what's new, release summary, version notes, update log, changelog from commits, generate changelog, release notes from git, what changed, what's different, version history, release log, update notes, new release notes, version update summary, commit history summary, git log summary, release announcement, release blog post, migration notes, upgrade guide, breaking changes list, deprecation list, feature summary per version, patch notes, release highlights, release changelog, CHANGELOG.md, HISTORY.md, RELEASES.md, NEWS.md, CHANGES.md, یادداشت نسخه, لاگ تغییرات, تاریخچه تغییرات, یادداشت انتشار, نسخه جدید, تغییرات نسخه, خلاصه تغییرات, انتشار جدید, نوتیس انتشار, لیست تغییرات, یادداشت‌های انتشار, تغییرات مهم, یا از کاربر می‌خواهد خلاصه‌ای از تغییرات یک نسخه یا بازه زمانی را تولید کند.
---

# Changelog Skill — Release Notes from Git History

## Overview

This skill generates human-readable changelogs and release notes by analyzing git commit history, pull request descriptions, and issue references. It categorizes changes by type (features, fixes, breaking changes) and produces a structured document that tells users and developers what changed, why, and what they need to do about it.

## When to Use This Skill

- User asks for a changelog, release notes, or "what's new"
- User wants to summarize changes between two git refs (tags, branches, commits)
- User needs release notes for a new version release
- User mentions یادداشت نسخه, لاگ تغییرات, or تاریخچه تغییرات
- User asks "what changed since [version/tag]"
- User wants patch notes for a game, app, or service release
- User needs an upgrade guide or migration notes between major versions
- User wants a release announcement or blog post draft
- User needs to generate CHANGELOG.md from a large commit history
- User wants to audit changes in a specific date range
- User needs a summary of PRs merged in a sprint or milestone
- User asks to compare two branches and document differences
- User wants to identify all breaking changes across multiple versions

## Changelog Workflow

### Step 1: Determine the Scope

1. **Identify the range** — Ask or detect which commits to include:
   - Between two tags (e.g., `v1.2.0..v1.3.0`)
   - Between a tag and HEAD (`v1.3.0..HEAD`)
   - Between two branches
   - All commits within a date range
   - All commits by a specific author
2. **Identify the version** — If generating release notes, confirm the new version number.
3. **Check for existing conventions** — Look for:
   - `CHANGELOG.md`, `HISTORY.md`, `RELEASES.md`
   - Conventional Commits (`feat:`, `fix:`, `BREAKING CHANGE:`)
   - `semantic-release` or `standard-version` config
   - Existing formatting patterns

### Step 2: Extract Commit Data

1. Run `git log <range> --oneline` to get commit summaries
2. Run `git log <range> --format="%H %s %an %ad" --date=short` for full details
3. If conventional commits are used, parse the commit prefixes:
   - `feat:` → New Feature
   - `fix:` → Bug Fix
   - `perf:` → Performance Improvement
   - `docs:` → Documentation
   - `refactor:` → Code Refactoring
   - `test:` → Tests
   - `chore:` / `ci:` → Internal / CI
   - `BREAKING CHANGE:` → Breaking Change (check body too)
   - `security:` → Security Fix
   - `deprecate:` → Deprecation
4. If no conventional commits, classify each commit by its subject line and diff

### Step 3: Categorize and Group

Group commits into these standard categories:

```
### Breaking Changes
[Changes that require user action or migration]

### New Features
[New functionality added]

### Bug Fixes
[Issues resolved]

### Performance
[Speed, memory, or efficiency improvements]

### Security
[Security vulnerabilities addressed]

### Deprecations
[Features marked for removal]

### Documentation
[Docs-only changes]

### Internal
[Refactors, CI, tests, chores — usually collapsed or omitted in user-facing notes]
```

Within each category, sort by significance (most impactful first) or by component/module.

### Step 4: Enrich with Context

For each significant change:
1. **Summarize the commit message** — Rewrite terse commit messages into user-friendly descriptions
2. **Link to issues/PRs** — If commit messages reference `#123` or `PR-456`, include those references
3. **Identify migration steps** — For breaking changes, briefly state what users need to change
4. **Add contributor credits** — If desired, list contributors based on commit authors
5. **Extract stats** — Count of commits, files changed, lines added/removed for context

### Step 5: Generate the Changelog

Produce the final document using one of the templates below.

## Output Format Templates

### Template 1: Keep a Changelog (Standard)
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [2.1.0] - 2024-06-15

### Added
- **User avatars**: Users can now upload profile pictures ([#234](link))
- **Bulk export**: New `POST /users/export` endpoint for CSV export ([#238](link))
- **Dark mode**: Added theme toggle to user settings ([#240](link))

### Changed
- **API response format**: All list endpoints now return `{ data, pagination }` instead of plain arrays ([#235](link))
  - Migration: Update clients to access `response.data` instead of `response` directly

### Deprecated
- **`/v1/users/search`**: Use `POST /v1/users/query` instead. Removal planned for v3.0.0 ([#236](link))

### Removed
- **Node 16 support**: Minimum Node.js version is now 18 ([#241](link))

### Fixed
- **Login redirect loop**: Fixed infinite redirect when SSO session expires ([#237](link))
- **CSV encoding**: Exported files now use UTF-8 with BOM for Excel compatibility ([#239](link))

### Security
- **XSS prevention**: Sanitized user-supplied HTML in bio field ([#242](link))

---

## [2.0.1] - 2024-05-20
[...previous version...]
```

### Template 2: User-Facing Release Notes (Blog/Email)
```markdown
# What's New in v2.1.0

We're excited to announce version 2.1.0 with new features, improvements, and bug fixes.

## ✨ New Features

### User Avatars
Upload a profile picture to personalize your account. Go to **Settings → Profile** to upload.

### Dark Mode
We've heard you! Toggle between light and dark themes in Settings. Your preference is saved automatically.

### Bulk Export
Need to export your data? Use the new CSV export feature to download all user records at once.

## 🔧 Improvements
- API responses are now consistently paginated, making it easier to work with large datasets.
- Page load times improved by ~30% after optimizing database queries.

## 🐛 Bug Fixes
- Fixed a login redirect issue that affected some SSO users.
- CSV exports now open correctly in Microsoft Excel.

## ⚠️ Breaking Changes
**If you use our API, please note:**
- List endpoints now return `{ data: [...], pagination: {...} }` instead of plain arrays.
- See our [migration guide](link) for step-by-step upgrade instructions.

## 🙏 Thanks
Shoutout to @contributor1, @contributor2, and @contributor3 for their contributions!
```

### Template 3: Internal/Sprint Changelog
```markdown
# Sprint 24 — Changelog (2024-06-01 to 2024-06-14)

## Completed
| Ticket | Title | Category | Author |
|--------|-------|----------|--------|
| PROJ-101 | User avatar upload | Feature | @alice |
| PROJ-105 | Dark mode toggle | Feature | @bob |
| PROJ-108 | Fix login redirect | Bug Fix | @carol |
| PROJ-112 | API pagination refactor | Tech Debt | @alice |
| PROJ-115 | XSS sanitization | Security | @dave |

## In Progress
| Ticket | Title | Status |
|--------|-------|--------|
| PROJ-120 | Bulk export | In review |
| PROJ-125 | Performance optimization | QA testing |

## Stats
- Commits: 47
- Files changed: 89
- Lines added: +1,203
- Lines removed: -412
- PRs merged: 12
```

### Template 4: Upgrade/Migration Guide
```markdown
# Migrating from v1.x to v2.0

This guide covers all breaking changes and how to update your code.

## 1. API Response Format Change

**What changed:** All `GET` endpoints that return lists now wrap results in a `data` field.

**Before:**
```json
[{"id": 1, "name": "Alice"}]
```

**After:**
```json
{"data": [{"id": 1, "name": "Alice"}], "pagination": {"total": 1}}
```

**Action required:** Update all API client code to access `response.data`.

```javascript
// Before
const users = await api.get('/users');
console.log(users.length);

// After
const { data: users } = await api.get('/users');
console.log(users.length);
```

## 2. Removed `getUserByEmail()`

**Replacement:** Use `getUsers({ email: '...' })` which returns an array.

```javascript
// Before
const user = await client.getUserByEmail('a@b.com');

// After
const [user] = await client.getUsers({ email: 'a@b.com' });
```

## 3. Node.js 16 Dropped

Minimum version is now Node.js 18. Update your `package.json` engines field and CI config.
```

## Advanced Techniques

### 1. Conventional Commits Enforcement
Before generating changelogs, ensure the repo uses Conventional Commits. Add `commitlint` with `@commitlint/config-conventional` to CI. This makes automated changelog generation reliable.

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert'
    ]],
  },
};
```

### 2. Semantic Versioning Auto-Detection
Analyze the categorized commits to suggest the next version number:
- Any `BREAKING CHANGE` → bump major
- Any `feat:` → bump minor
- Only `fix:`, `docs:`, `chore:` etc. → bump patch

### 3. Commit-to-PR Correlation
If using GitHub, correlate commits to PRs using `git log --format="%s %b"` and extracting PR numbers. Then fetch PR descriptions for richer context. This transforms terse commit messages into well-described changelog entries.

### 4. Monorepo Package-Level Changelogs
In a monorepo, generate separate changelogs per package by filtering commits by the directories they touch. Use `git log --name-only` to identify which packages each commit affects.

```bash
# Get commits affecting only packages/auth
git log v1.0.0..v2.0.0 -- packages/auth/
```

### 5. Automated Release with semantic-release
Set up `semantic-release` to automate version bumping, changelog generation, and npm publishing on every merge to `main`. It reads Conventional Commits and handles the entire release pipeline.

```json
// .releaserc.json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/github"
  ]
}
```

### 6. Changelog Diff Generation
For upgrade guides, generate a focused diff showing only what changed between versions. Use `git diff --stat v1..v2` for file-level stats and `git diff v1..v2 -- <file>` for specific changes.

### 7. Multi-Format Changelog Output
Generate the same changelog in multiple formats from one source: Markdown for the repo, JSON for the API/website, and HTML for email announcements.

## Common Patterns

### Pattern 1: Open Source Library Release
```markdown
## [3.2.0] - 2024-07-01

### Features
- **`debounce()`**: Now accepts a `leading` option to fire on the leading edge ([#156](link))
- **`throttle()`**: Added `cancel()` method to pending throttled calls ([#158](link))

### Fixes
- **`memoize()`**: Fixed cache invalidation when arguments are `NaN` ([#160](link))

### Deprecations
- **`delay()`**: Use native `setTimeout` with Promises. Removal in v4.0.

**Full Changelog**: [v3.1.0...v3.2.0](link)
```

### Pattern 2: SaaS Product Release Notes
```markdown
## 🚀 Release 2024-07 — Team Dashboards

**New:**
- Team dashboards with shared widgets
- Custom date range filters on all reports
- Slack integration for daily summaries

**Improved:**
- Dashboard loading time reduced by 60%
- New chart types: scatter plot and funnel

**Fixed:**
- PDF export now includes all dashboard widgets
- Date picker timezone offset corrected for UTC+ users

**Requires Action:**
- Custom API integrations using `/v1/reports` must add `team_id` parameter by Aug 1. See [migration guide](link).
```

### Pattern 3: Internal Tool Deprecation Notice
```markdown
## ⚠️ Deprecation: Legacy Report Generator

**End of Life:** 2024-09-01
**Replacement:** New Analytics Dashboard (link)

### Timeline
- **2024-07-01**: Deprecation notice issued
- **2024-08-01**: Feature flag disabled (read-only mode)
- **2024-09-01**: Complete removal

### Migration Steps
1. Export existing saved reports (Settings → Export)
2. Recreate reports in the new Analytics Dashboard
3. Update any API integrations using `/legacy/reports`
```

### Pattern 4: Security-Focused Release
```markdown
## [1.4.2] - 2024-07-15 — Security Patch

### Security Fixes
- **CVE-2024-1234**: Fixed SQL injection in search endpoint ([#301](link))
- **CVE-2024-1235**: Patched dependency `lodash` to 4.17.21 (prototype pollution) ([#302](link))
- **Session fixation**: Regenerate session ID after login ([#303](link))

### Other Fixes
- Fixed pagination off-by-one error in user list ([#304](link))

**We recommend all users upgrade immediately.**
```

### Pattern 5: Microservice Changelog with Impact Analysis
```markdown
## [auth-service v2.3.0] - 2024-07-10

### Changes
| Change | Impact | Affected Services |
|--------|--------|-------------------|
| JWT expiry reduced to 15min | **Breaking**: `api-gateway` must implement token refresh | api-gateway, web-app |
| New `/introspect` endpoint | None (additive) | — |
| Redis session store migrated to Valkey | None (internal) | — |
| Rate limit headers added | None (additive) | api-gateway (should proxy headers) |

### Required Actions for Downstream Services
- `api-gateway`: Update token refresh logic before deploying auth-service v2.3.0
```

## Edge Cases & Pitfalls

1. **Merge commits cluttering the log** — Use `--no-merges` to exclude merge commits, or use `--first-parent` to show only commits on the main branch.

2. **Squash merges lose individual commits** — If the project squashes PRs on merge, the original commit messages are lost. Use PR titles and descriptions instead.

3. **Conventional commits in body, not subject** — `BREAKING CHANGE:` often appears in the commit body, not the subject line. Always parse both `git log --format="%s%n%b"`.

4. **Cherry-picked commits appear in multiple ranges** — A commit cherry-picked from a feature branch to a release branch will show up in both ranges. Deduplicate by commit hash.

5. **Revert commits** — A revert undoes a previous change. Detect `Revert "original message"` and either exclude the original entry or note the revert.

6. **No commits in range** — If the range is empty, don't fabricate changes. Output "No changes in this release" or skip the version entirely.

7. **Massive release ranges** — Ranges spanning hundreds of commits (e.g., v0.1.0 to v1.0.0) need summarization. Group by month or milestone, don't list every commit.

8. **Dependency-only updates** — A release that only bumps dependencies (e.g., `npm audit fix`) should be noted concisely, not listed dependency by dependency.

9. **Unconventional commit messages** — Not all repos use Conventional Commits. When classifying manually, check the actual diff (`git show --stat <hash>`) to categorize accurately.

10. **Date vs. tag-based ranges** — Date ranges (`--since="2024-01-01"`) include commits not yet tagged, while tag ranges (`v1..v2`) may exclude untagged commits. Clarify with the user which scope they want.

11. **Co-authored commits** — Multiple `Co-authored-by:` trailers. Credit all contributors, not just the committer.

12. **Signed commits / GPG** — Commit signatures don't affect changelog content but may affect `git log --format` parsing if the signature appears in the body.

13. **Monorepo scope issues** — In a monorepo, a commit touching 5 packages appears 5 times if you filter per-package. Deduplicate across per-package changelogs or use a shared "global changes" section.

14. **Empty PR descriptions** — When PRs have empty descriptions, fall back to the commit messages within the PR. If those are also terse, acknowledge the limitation.

15. **Timezone mismatches** — Git commit dates are in the committer's timezone. Use `--date=iso` or `--date=unix` for consistent formatting.

## Integration with Other Skills

- **documentation** — Use when the changelog needs to be integrated into project documentation sites or when writing release documentation pages.
- **technical-writing** — Use when drafting release blog posts, email announcements, or marketing content from changelog data.
- **summarization** — Use when condensing a long changelog into a brief summary or executive overview of recent changes.
- **api-integration** — Use when documenting API version changes, deprecated endpoints, or breaking API changes in release notes.

## Principles

- **Be accurate.** Every entry must correspond to a real commit. Don't invent changes.
- **Be useful.** A changelog is for humans, not machines. Explain impact, not just diff.
- **Be honest.** If nothing notable changed, say so. Don't pad the list.
- **Follow conventions.** If the project uses Conventional Commits, respect the structure. If it has an existing changelog format, match it.
- **Prioritize user impact.** Order categories by how much they affect the reader: breaking changes first, then features, then fixes.
- **Keep it scannable.** Users scan changelogs, they don't read them. Use bold, bullets, and short descriptions.
- **Link to details.** Every entry should link to the commit, PR, or issue for full context.
- **Date everything.** Always include the release date. Ambiguous timing is unhelpful.
