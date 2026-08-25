# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Skills](https://img.shields.io/badge/skills-25-green)
![Size](https://img.shields.io/badge/size-optimized-purple)
![License](https://img.shields.io/badge/license-MIT-orange)

**A professional, verification-first, root-cause-driven skill library for autonomous coding agents.**

[Installation](#-installation) • [Skills](#-skills) • [Routing](#-routing) • [Architecture](#-architecture)

</div>

---

## 🎯 Philosophy

This skill library is built on three core principles:

| Principle | Rule |
|-----------|------|
| **Evidence First** | Never guess. Always verify. |
| **Minimal Fix** | Smallest change that fixes the root cause. |
| **Verification Required** | Never claim success without proof. |

---

## 🚀 Installation

### One-Command Install

```bash
# Clone the repository
git clone https://github.com/AnishtayiN/skills.git
cd skills

# Install for your agent
./install.sh claude      # Claude Code
./install.sh cursor      # Cursor AI
./install.sh all         # All agents
```

### Manual Install

Copy the `new-skills/` directory to your project and configure your agent to read skill files.

---

## 📋 Skills

### Core Analysis (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **project-analysis** | P1 | Understand project structure | project structure, codebase, architecture, تحلیل پروژه |
| **requirement-analysis** | P1 | Clarify user requirements | requirement, what do you need, scope, نیازمندی |
| **task-planning** | P1 | Break work into steps | plan, steps, breakdown, roadmap, برنامه |

### Core Coding (5 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **code-generation** | P1 | Write new code | write code, create, implement, build, بنویس کد |
| **code-editing** | P1 | Modify existing code | edit, modify, change, update, patch, اصلاح کد |
| **code-explanation** | P2 | Explain code | explain, what does this do, walkthrough, توضیح بده |
| **debugging** | P0 | Find and fix bugs | debug, bug, error, crash, exception, عیب‌یابی |
| **refactoring** | P2 | Improve code structure | refactor, clean up, simplify, restructure, بازسازی |

### Quality (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **code-review** | P1 | Review code quality | review, code quality, PR review, بررسی کد |
| **testing** | P1 | Create and run tests | test, unit test, coverage, mock, تست |
| **verification** | P0 | Verify changes work | verify, check, does it work, build, lint, بررسی کن |

### Architecture (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **system-design** | P2 | Design system architecture | system design, architecture, scalable, طراحی سیستم |
| **api-design** | P2 | Design APIs | api, rest, graphql, endpoint, طراحی API |
| **database-design** | P2 | Design databases | database, schema, table, migration, طراحی دیتابیس |

### Git & DevOps (4 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **git-workflow** | P2 | Manage Git operations | git, commit, branch, merge, conflict, گیت |
| **dockerization** | P3 | Docker configuration | docker, dockerfile, container, داکر |
| **ci-cd** | P3 | CI/CD pipelines | ci cd, pipeline, github actions, پایپ‌لاین |
| **deployment** | P3 | Deploy applications | deploy, release, production, استقرار |

### Security & Performance (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **security-audit** | P0 | Security review | security, vulnerability, injection, auth, امنیت |
| **performance-analysis** | P2 | Performance optimization | performance, slow, bottleneck, optimize, عملکرد |
| **concurrency-debugging** | P0 | Debug concurrency issues | race condition, deadlock, async, thread, همزمانی |

### AI & Documentation (4 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **agent-orchestration** | P2 | Multi-agent coordination | agent, multi-agent, orchestration, هماهنگی اجنت |
| **tool-management** | P1 | Tool call management | tool call, tool error, tool failure, فراخوانی ابزار |
| **context-management** | P1 | Token management | context, token, context window, کانتکست |
| **documentation** | P3 | Write documentation | documentation, docs, readme, مستندات |

---

## 🧭 Skill Routing

The agent routes tasks automatically:

```
User Request
     ↓
┌─────────────────┐
│ Task Classifier  │  What type of task?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Skill Detector   │  Which skills are relevant?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Priority Sort    │  What's the priority?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Dependency Check │  What must run first?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Conflict Check   │  Are skills conflicting?
└────────┬────────┘
         ↓
┌─────────────────┐
│ Load ONLY Needed │  Don't load all skills
└────────┬────────┘
         ↓
┌─────────────────┐
│ Execute          │  Run in order
└────────┬────────┘
         ↓
┌─────────────────┐
│ Verify           │  Check results
└────────┬────────┘
     Response
```

### Routing by Task Type

| Task | Primary Skills | Secondary Skills |
|------|---------------|-----------------|
| **New Feature** | project-analysis, requirement-analysis, task-planning, code-generation | code-review, testing, verification |
| **Bug Fix** | debugging, verification | testing, code-review |
| **Code Review** | code-review | security-audit, performance-analysis |
| **Refactoring** | refactoring, code-review | testing, verification |
| **Architecture** | system-design, api-design, database-design | project-analysis |
| **DevOps** | dockerization, ci-cd, deployment | testing, security-audit |
| **Security** | security-audit | code-review, debugging |
| **Performance** | performance-analysis, concurrency-debugging | debugging |

---

## 🔗 Dependencies

Skills can depend on other skills:

```
debugging → project-analysis
refactoring → code-review, testing
deployment → testing, ci-cd, dockerization
code-generation → project-analysis, requirement-analysis
```

---

## ⚔️ Conflict Resolution

| Conflict | Resolution |
|----------|------------|
| debugging vs refactoring | Debug first, refactor after fix |
| security vs performance | Security first |
| minimal-fix vs refactoring | Default to minimal-fix |

---

## 🏗️ Architecture

```
new-skills/
├── core/                    # تحلیل و برنامه‌ریزی
│   ├── project-analysis     # P1
│   ├── requirement-analysis # P1
│   └── task-planning        # P1
│
├── coding/                  # کدنویسی
│   ├── code-generation      # P1
│   ├── code-editing         # P1
│   ├── code-explanation     # P2
│   ├── debugging            # P0 ⭐
│   └── refactoring          # P2
│
├── quality/                 # کیفیت
│   ├── code-review          # P1
│   ├── testing              # P1
│   └── verification         # P0 ⭐
│
├── architecture/            # معماری
│   ├── system-design        # P2
│   ├── api-design           # P2
│   └── database-design      # P2
│
├── git/                     # گیت
│   └── git-workflow         # P2
│
├── devops/                  # عملیات
│   ├── dockerization        # P3
│   ├── ci-cd                # P3
│   └── deployment           # P3
│
├── security/                # امنیت
│   └── security-audit       # P0 ⭐
│
├── performance/             # عملکرد
│   ├── performance-analysis # P2
│   └── concurrency-debugging # P0 ⭐
│
├── ai/                      # هوش مصنوعی
│   ├── agent-orchestration  # P2
│   ├── tool-management      # P1
│   └── context-management   # P1
│
├── documentation/           # مستندات
│   └── documentation        # P3
│
├── README.md                # این فایل
├── ROUTER.md                # سیستم مسیریابی
├── SKILL-MATRIX.md          # ماتریکس Skillها
├── AGENT.md                 # قوانین Agent
├── CONTRIBUTING.md          # راهنمای مشارکت
└── install.sh               # اسکریپت نصب
```

---

## 📖 Usage

### For Claude Code

Add to `CLAUDE.md`:

```markdown
## Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file first.

Available skills in `skills/new-skills/`:
- `core/project-analysis/SKILL.md` — Analyze project structure
- `coding/debugging/SKILL.md` — Debug issues
- `quality/code-review/SKILL.md` — Review code
- `quality/testing/SKILL.md` — Write tests
- `quality/verification/SKILL.md` — Verify changes
```

### For Cursor AI

Add to `.cursorrules`:

```markdown
## Skills

Read the relevant skill file from `skills/new-skills/` before performing tasks.
Follow the verification-first principle.
```

---

## 📊 Priority System

| Priority | Skills | When to Use |
|----------|--------|------------|
| **P0** | debugging, verification, security-audit, concurrency-debugging | Critical: always include when relevant |
| **P1** | project-analysis, requirement-analysis, task-planning, code-generation, code-editing, code-review, testing, tool-management, context-management | High: include for most tasks |
| **P2** | code-explanation, refactoring, system-design, api-design, database-design, git-workflow, performance-analysis, agent-orchestration | Normal: standard development |
| **P3** | dockerization, ci-cd, deployment, documentation | Standard: nice to have |

---

## 📝 Contributing

See [CONTRIBUTING.md](new-skills/CONTRIBUTING.md) for standards.

---

## 📄 License

MIT License
