# 📝 Contributing Guide

## How to Add a New Skill

### Step 1: Check if Needed

Before creating a new skill:
1. Does an existing skill cover this? Check [SKILL-MATRIX.md](SKILL-MATRIX.md)
2. Can it be merged with an existing skill?
3. Is it relevant for a coding agent?

### Step 2: Follow the Frontmatter Standard

```yaml
---
name: skill-name
description: >-
  {2-line description of what the skill does}.
  TRIGGERS: {8+ English trigger phrases},
  {6+ Farsi trigger phrases},
  {5+ Chinese trigger phrases}
priority: P0/P1/P2/P3
dependencies: [other-skill-names]
conflicts: [conflicting-skill-names]
---
```

**Rules:**
- `dependencies` must reference skills that actually exist in this repo
- `conflicts` lists skills that should not run at the same time
- Triggers must be specific enough to avoid false activation

### Step 3: Required Sections

Every skill MUST include these 10 sections, in this order:

| # | Section | Requirement |
|---|---------|-------------|
| 1 | `## Overview` | 2–3 sentences on what & why |
| 2 | `## When to Use This Skill` | 6–9 concrete bullets |
| 3 | `## When NOT to Use This Skill` | 5–7 bullets |
| 4 | `## Workflow` | Multi-phase with `### Step N` + code |
| 5 | `## Advanced Techniques` | ≥ 7 numbered (`### 1. Name`) with code |
| 6 | `## Common Patterns` | ≥ 5 (`### Pattern N:`) with production-ready code |
| 7 | `## Edge Cases & Pitfalls` | ≥ 15 numbered cases (problem → solution) |
| 8 | `## Integration with Other Skills` | Markdown table: Skill / When / How |
| 9 | `## Output Format Templates` | ≥ 4 templates (Standard / Detailed / Quick / Agent-friendly) |
| 10 | `## Rules` | ≥ 10 numbered rules |

### Step 4: Quality Standards

- [ ] Minimum 500 lines
- [ ] Triggers in all three languages (English + فارسی + 中文)
- [ ] Code examples are production-ready and runnable
- [ ] Workflow is actionable, not vague
- [ ] Dependencies reference existing skills only
- [ ] No duplicate coverage with an existing skill
- [ ] UTF-8 encoded, valid YAML frontmatter
- [ ] Token-efficient prose — examples carry the weight

### Step 5: Verify Before PR

Run against your new skill:
```bash
# frontmatter has priority?
grep -c "^priority:" <skill>/SKILL.md        # must be 1

# all 10 sections present?
grep -c "^## " <skill>/SKILL.md              # >= 10

# trilingual triggers present?
grep -P "[\x{0600}-\x{06FF}]" <skill>/SKILL.md   # Farsi found
grep -P "[\x{4E00}-\x{9FFF}]" <skill>/SKILL.md   # Chinese found
```

Then confirm the installer still counts correctly:
```bash
./install.sh --help    # runs without error
```

## Naming Conventions

- Kebab-case directories: `code-review`, `testing-e2e`
- Lowercase everywhere: `debugging`, not `Debugging`
- One skill per directory: `<skill-name>/SKILL.md`
- Place the skill inside the correct category directory (`ai/`, `coding/`, …)

## Priority Guidelines

| Priority | Meaning | Examples |
|----------|---------|----------|
| **P0** | Critical for correctness/security | debugging, verification, security-audit |
| **P1** | Important for most tasks | code-generation, testing, code-review |
| **P2** | Normal development tasks | refactoring, api-design, caching |
| **P3** | Specialized / nice to have | documentation, deployment, seo |

## File Structure

```
<repo-root>/
├── ai/ coding/ quality/ ...     # category directories
│   └── skill-name/
│       └── SKILL.md             # main skill file
├── ROUTER.md                    # how agents pick skills
├── AGENT.md                     # agent behavior rules
├── SKILL-MATRIX.md              # full skill reference table
├── install.sh                   # interactive installer
└── index.html                   # GitHub Pages site
```

After adding a skill, update **SKILL-MATRIX.md**, the count in **README.md**, and the grid in **index.html**.
