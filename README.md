# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-4.0.0-blue)
![Skills](https://img.shields.io/badge/skills-39-green)
![Lines](https://img.shields.io/badge/lines-28%2C779-purple)
![Languages](https://img.shields.io/badge/triggers-EN%20%7C%20FA%20%7C%20ZH-orange)
![License](https://img.shields.io/badge/license-MIT-orange)

**A professional, verification-first, root-cause-driven skill library for autonomous coding agents.**

[Installation](#-installation) • [Skills](#-skills) • [Routing](#-routing) • [Contributing](#-contributing)

</div>

---

## 🎯 Philosophy

| Principle | Rule |
|-----------|------|
| **Evidence First** | Never guess. Always verify. |
| **Minimal Fix** | Smallest change that fixes root cause. |
| **Verification Required** | Never claim success without proof. |

---

## 🚀 Installation

### One-Line Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/refs/heads/main/install.sh)
```

### Interactive Mode

```bash
git clone https://github.com/AnishtayiN/skills.git
cd skills
./install.sh
```

Interactive menu features:
- Auto-detects installed agents and shows `(Installed) [n/39 skills]`
- Toggle selection with keys `1-6`, Select All `7`, Deselect All `8`
- Install Selected `9`, Update Selected `10`, Uninstall Selected `11`

### CLI Mode

```bash
./install.sh --claude          # Install for Claude Code
./install.sh --cursor          # Install for Cursor AI
./install.sh --all             # Install for all agents
./install.sh --uninstall all   # Uninstall all
./install.sh --update all      # Update all
```

Supported agents: **Claude Code, Cursor AI, Windsurf, Aider, Continue.dev, Hermes Agent**

---

## 📋 Skills (39 Total)

### 🎯 Core Analysis (3 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **project-analysis** | 461 | Understand project structure & tech stack |
| **requirement-analysis** | 515 | Clarify requirements & acceptance criteria |
| **task-planning** | 695 | Break work into ordered, verifiable steps |

### 🧠 AI & Reasoning (8 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **prompt-engineering** | 353 | Write & optimize LLM prompts |
| **chain-of-thought** | 441 | Step-by-step reasoning techniques |
| **self-correction** | 467 | Fix AI output errors automatically |
| **brainstorming** | 570 | Structured ideation (SCAMPER, Six Hats) |
| **rag-implementation** | 772 | Build RAG pipelines with vector DBs |
| **tool-management** | 835 | Tool call validation & retry |
| **context-management** | 985 | Token budget & context optimization |
| **agent-orchestration** | 1,205 | Multi-agent coordination |

### 💻 Coding (9 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **code-editing** | 431 | Modify code with minimal diffs |
| **code-explanation** | 534 | Multi-level code walkthrough |
| **code-generation** | 648 | Write new code (framework-aware) |
| **debugging** | 579 | Evidence-driven bug fixing |
| **refactoring** | 679 | Code smell catalog + SOLID |
| **web-scraping** | 722 | Extract data from websites |
| **api-integration** | 791 | Connect to external APIs (OAuth, webhooks) |
| **browser-automation** | 886 | Playwright/Puppeteer automation |
| **clean-architecture** | 1,269 | SOLID, hexagonal, CQRS |

### ✅ Quality (5 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **code-review** | 495 | 5-pass review + STRIDE threat model |
| **verification** | 603 | Build → lint → type → test → manual |
| **testing** | 658 | Unit/integration/E2E + property-based |
| **data-analysis** | 1,143 | Statistical analysis + A/B testing |
| **data-cleaning** | 1,328 | Preprocessing + imputation |

### 🏗️ Architecture (3 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **database-design** | 490 | Multi-tenancy + event sourcing |
| **system-design** | 628 | Bounded context + back-of-envelope |
| **api-design** | 766 | REST + GraphQL + versioning |

### 🔧 DevOps (4 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **git-workflow** | 549 | Gitflow + conflict resolution |
| **dockerization** | 684 | BuildKit + distroless + GPU |
| **ci-cd** | 786 | GitHub Actions + GitLab CI |
| **deployment** | 918 | Blue-green + canary + feature flags |

### 🔒 Security & Performance (3 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **security-audit** | 596 | OWASP Top 10 + supply chain |
| **performance-analysis** | 684 | Profiling + caching + optimization |
| **concurrency-debugging** | 828 | Race conditions + deadlocks |

### 📝 Documentation (4 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **changelog** | 402 | Conventional Commits + release notes |
| **summarization** | 929 | Meetings + PRs + codebase overviews |
| **technical-writing** | 979 | Tutorials + deep dives + post-mortems |
| **documentation** | 1,475 | README + API docs + ADRs + runbooks |

---

## 🧭 Routing

```
Request → Classify → Detect Skills → Sort Priority
→ Check Dependencies → Resolve Conflicts
→ Load Only Needed → Execute → Verify → Response
```

Every skill declares its `priority` (P0–P3), `dependencies`, and `conflicts` in YAML frontmatter.

---

## ✅ Quality Standard

Every skill passes the same verification checklist:

| Requirement | Standard |
|-------------|----------|
| Sections | Overview, When to Use, When NOT to Use, Workflow, Advanced Techniques, Common Patterns, Edge Cases, Integration, Templates, Rules |
| Advanced Techniques | ≥ 7 |
| Common Patterns | ≥ 5 (with code) |
| Edge Cases & Pitfalls | ≥ 15 |
| Output Templates | ≥ 4 |
| Rules | ≥ 10 |
| Triggers | English + فارسی + 中文 |

---

## 📊 Statistics

| Metric | Value |
|--------|------:|
| Total Skills | **39** |
| Total Lines | **28,806** |
| Avg Lines/Skill | **738** |
| Categories | **10** |
| Trigger Languages | **3** (EN + FA + ZH) |

---

## 🤝 Contributing

See [CONTRIBUTING.md](new-skills/CONTRIBUTING.md) for the skill format standard.

## 📄 License

MIT License
