# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-4.0.0-blue)
![Skills](https://img.shields.io/badge/skills-39-green)
![Lines](https://img.shields.io/badge/lines-27%2C700+-purple)
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

### CLI Mode

```bash
./install.sh --claude          # Install for Claude Code
./install.sh --cursor          # Install for Cursor AI
./install.sh --all             # Install for all agents
./install.sh --uninstall all   # Uninstall all
./install.sh --update all      # Update all
```

---

## 📋 Skills (39 Total)

### 🧠 AI & Reasoning (8 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **prompt-engineering** | 353 | Write & optimize LLM prompts |
| **chain-of-thought** | 441 | Step-by-step reasoning |
| **self-correction** | 467 | Fix AI output errors automatically |
| **brainstorming** | 570 | Structured ideation (SCAMPER, Six Hats) |
| **rag-implementation** | 772 | Build RAG pipelines with vector DBs |
| **agent-orchestration** | 1,198 | Multi-agent coordination |
| **tool-management** | 1,027 | Tool call validation & retry |
| **context-management** | 1,229 | Token budget & context optimization |

### 💻 Coding (10 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **code-generation** | 648 | Write new code (framework-aware) |
| **code-editing** | 431 | Modify code with minimal diffs |
| **code-explanation** | 430 | Multi-level code walkthrough |
| **debugging** | 579 | Evidence-driven bug fixing |
| **refactoring** | 679 | Code smell catalog + SOLID |
| **api-integration** | 791 | Connect to external APIs (OAuth, webhooks) |
| **web-scraping** | 722 | Extract data from websites |
| **browser-automation** | 886 | Playwright/Puppeteer automation |
| **clean-architecture** | 1,034 | SOLID, hexagonal, CQRS |

### ✅ Quality (7 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **code-review** | 495 | 5-pass review + STRIDE threat model |
| **testing** | 658 | Unit/integration/E2E + property-based |
| **verification** | 603 | Build → lint → type → test → manual |
| **data-analysis** | 1,143 | Statistical analysis + A/B testing |
| **data-cleaning** | 1,328 | Preprocessing + imputation |

### 🏗️ Architecture (3 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **system-design** | 628 | Bounded context + back-of-envelope |
| **api-design** | 766 | REST + GraphQL + versioning |
| **database-design** | 483 | Multi-tenancy + event sourcing |

### 🔧 DevOps (4 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **git-workflow** | 542 | Gitflow + conflict resolution |
| **dockerization** | 677 | BuildKit + distroless + GPU |
| **ci-cd** | 778 | GitHub Actions + GitLab CI |
| **deployment** | 911 | Blue-green + canary + feature flags |

### 🔒 Security & Performance (3 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **security-audit** | 589 | OWASP Top 10 + supply chain |
| **performance-analysis** | 677 | Profiling + caching + optimization |
| **concurrency-debugging** | 821 | Race conditions + deadlocks |

### 📝 Documentation (4 skills)

| Skill | Lines | Purpose |
|-------|------:|---------|
| **documentation** | 1,284 | README + API docs + ADRs + runbooks |
| **technical-writing** | 753 | Tutorials + deep dives + post-mortems |
| **summarization** | 1,261 | Meetings + PRs + codebase overviews |
| **changelog** | 402 | Conventional Commits + release notes |

---

## 🧭 Routing

```
Request → Classify → Detect Skills → Sort Priority
→ Check Dependencies → Resolve Conflicts
→ Load Only Needed → Execute → Verify → Response
```

---

## 📊 Statistics

| Metric | Value |
|--------|------:|
| Total Skills | **39** |
| Total Lines | **27,713** |
| Avg Lines/Skill | **711** |
| Categories | **11** |
| Trigger Languages | **3** (EN + FA + ZH) |
| Advanced Techniques | **273+** |
| Common Patterns | **195+** |
| Edge Cases | **585+** |
| Output Templates | **156** |
| Rules | **390+** |

---

## 📄 License

MIT License
