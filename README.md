# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-5.0.0-blue)
![Skills](https://img.shields.io/badge/skills-57-green)
![Lines](https://img.shields.io/badge/lines-60%2C000+-purple)
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
- Auto-detects installed agents and shows `(Installed) [n/57 skills]`
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

## 📋 Skills (57 Total · 10 Categories)

### 🎯 Core Analysis (3 skills)

The entry point for every non-trivial task: understand → clarify → plan.

| Skill | Purpose |
|-------|---------|
| **project-analysis** | Understand project structure & tech stack |
| **requirement-analysis** | Clarify requirements & acceptance criteria |
| **task-planning** | Break work into ordered, verifiable steps |

### 🧠 AI & Reasoning (8 skills)

| Skill | Purpose |
|-------|---------|
| **prompt-engineering** | Write & optimize LLM prompts |
| **chain-of-thought** | Step-by-step reasoning techniques |
| **self-correction** | Fix AI output errors automatically |
| **brainstorming** | Structured ideation (SCAMPER, Six Hats) |
| **rag-implementation** | Build RAG pipelines with vector DBs |
| **tool-management** | Tool call validation & retry |
| **context-management** | Token budget & context optimization |
| **agent-orchestration** | Multi-agent coordination |

### 💻 Coding (16 skills)

| Skill | Purpose |
|-------|---------|
| **code-editing** | Modify code with minimal diffs |
| **code-explanation** | Multi-level code walkthrough |
| **code-generation** | Write new code (framework-aware) |
| **debugging** | Evidence-driven bug fixing |
| **refactoring** | Code smell catalog + SOLID |
| **web-scraping** | Extract data from websites |
| **api-integration** | Connect to external APIs (OAuth, webhooks) |
| **browser-automation** | Playwright/Puppeteer automation |
| **clean-architecture** | SOLID, hexagonal, CQRS |
| **algorithm-design** | Algorithms & data structures done right |
| **code-migration** | Move code between languages/frameworks |
| **email-template** | HTML emails that survive Outlook & Gmail |
| **i18n** | Internationalization & localization |
| **mobile-development** | Cross-platform mobile apps |
| **regex** | Regular expressions mastery |
| **seo** | Technical SEO & Core Web Vitals |

### ✅ Quality (7 skills)

| Skill | Purpose |
|-------|---------|
| **code-review** | 5-pass review + STRIDE threat model |
| **verification** | Build → lint → type → test → manual |
| **testing** | Unit/integration/E2E + property-based |
| **testing-e2e** | Deep E2E strategy (Playwright/Cypress) |
| **accessibility** | WCAG 2.2 AA & inclusive UI |
| **data-analysis** | Statistical analysis + A/B testing |
| **data-cleaning** | Preprocessing + imputation |

### 🏗️ Architecture (6 skills)

| Skill | Purpose |
|-------|---------|
| **database-design** | Multi-tenancy + event sourcing |
| **system-design** | Bounded context + back-of-envelope |
| **api-design** | REST + GraphQL + versioning |
| **graphql** | Schema design, DataLoader, federation |
| **microservices** | Boundaries, sagas, strangler fig |
| **queue** | Message queues & async processing |

### 🔧 DevOps (7 skills)

| Skill | Purpose |
|-------|---------|
| **git-workflow** | Gitflow + conflict resolution |
| **dockerization** | BuildKit + distroless + GPU |
| **ci-cd** | GitHub Actions + GitLab CI |
| **deployment** | Blue-green + canary + feature flags |
| **feature-flag** | Progressive delivery & kill switches |
| **incident-response** | On-call, runbooks, postmortems |
| **monitoring-observability** | Metrics/logs/traces, SLOs |
| **serverless** | Lambda patterns & cost control |

### ⚡ Performance (4 skills)

| Skill | Purpose |
|-------|---------|
| **performance-analysis** | Profiling + caching + optimization |
| **performance-optimization** | Make slow code fast, evidence-driven |
| **caching** | Redis/CDN/browser strategies |
| **concurrency-debugging** | Race conditions + deadlocks |

### 🔒 Security (1 skill)

| Skill | Purpose |
|-------|---------|
| **security-audit** | OWASP Top 10 + supply chain |

### 📝 Documentation (4 skills)

| Skill | Purpose |
|-------|---------|
| **changelog** | Conventional Commits + release notes |
| **summarization** | Meetings + PRs + codebase overviews |
| **technical-writing** | Tutorials + deep dives + post-mortems |
| **documentation** | README + API docs + ADRs + runbooks |

---

## 🧭 Routing

```
Request → Classify → Detect Skills → Sort Priority
→ Check Dependencies → Resolve Conflicts
→ Load Only Needed → Execute → Verify → Response
```

Every skill declares its `priority` (P0–P3), `dependencies`, and `conflicts` in YAML frontmatter.
See [ROUTER.md](ROUTER.md), [AGENT.md](AGENT.md), and [SKILL-MATRIX.md](SKILL-MATRIX.md).

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

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the skill format standard.

## 📄 License

MIT License
