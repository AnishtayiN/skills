# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Skills](https://img.shields.io/badge/skills-25-green)
![Size](https://img.shields.io/badge/size-optimized-purple)
![License](https://img.shields.io/badge/license-MIT-orange)
![Agents](https://img.shields.io/badge/agents-6-blue)

**A professional, verification-first, root-cause-driven skill library for autonomous coding agents.**

[Installation](#-installation) • [Skills](#-skills) • [Routing](#-routing) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Philosophy](#-philosophy)
- [Installation](#-installation)
- [Skills](#-skills)
- [Routing](#-routing)
- [Dependencies](#-dependencies)
- [Conflict Resolution](#-conflict-resolution)
- [Priority System](#-priority-system)
- [Architecture](#-architecture)
- [Usage](#-usage)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Philosophy

This skill library is built on three core principles:

| Principle | Rule | Example |
|-----------|------|---------|
| **Evidence First** | Never guess. Always verify. | Read code before debugging |
| **Minimal Fix** | Smallest change that fixes root cause | Fix the bug, don't rewrite the module |
| **Verification Required** | Never claim success without proof | Run tests, check build, verify output |

---

## 🚀 Installation

### Interactive Mode (Recommended)

```bash
# Clone the repository
git clone https://github.com/AnishtayiN/skills.git
cd skills

# Run interactive installer
./install.sh
```

The installer will show:

```
╔══════════════════════════════════════════════════════════════════╗
║           🧠 Coding Agent Skill Library - v3.0.0              ║
║           25 Professional Skills for Coding Agents             ║
╚══════════════════════════════════════════════════════════════════╝

  📦 Available Agents:
  ─────────────────────────────────────────────────────────────

    [✓] 1) Claude Code          (Installed) [25/25 skills]
    [ ] 2) Cursor AI            (Not Installed)
    [✓] 3) Windsurf             (Installed) [25/25 skills]
    [ ] 4) Aider                (Not Installed)
    [ ] 5) Continue.dev         (Not Installed)
    [ ] 6) Hermes Agent         (Not Installed)

  ─────────────────────────────────────────────────────────────
    7) Select All
    8) Deselect All

  ─────────────────────────────────────────────────────────────
    9) Install Selected
    10) Update Selected (reinstall with latest)
    11) Uninstall Selected
    0) Exit

  Selected: 2 agent(s)
  Total Skills: 25

  🔢 Enter command (1-11, 0): 
```

**Commands:**
- Press `1-6` to toggle selection for each agent
- Press `7` to select all agents
- Press `8` to deselect all
- Press `9` to install selected agents
- Press `10` to update/reinstall selected agents
- Press `11` to uninstall selected agents (with confirmation)
- Press `0` to exit

### One-Line Install (Fastest)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh)
```

### CLI Mode

```bash
# Install for specific agents
./install.sh --claude
./install.sh --cursor
./install.sh --claude --cursor

# Install for all agents
./install.sh --all

# Uninstall specific agents
./install.sh --uninstall claude
./install.sh --uninstall claude cursor

# Uninstall all agents
./install.sh --uninstall all

# Update specific agents
./install.sh --update claude
./install.sh --update all

# Show help
./install.sh --help
```

### Managing Installed Agents

You can run the installer anytime to:
- **Add new agents** — Select uninstalled agents and press 9
- **Remove agents** — Select installed agents and press 11
- **Update agents** — Select agents and press 10 to reinstall with latest
- **Check status** — See which agents are installed with skill counts

---

## 📋 Skills

### Core Analysis (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **project-analysis** | P1 | Understand project structure | project structure, codebase, architecture |
| **requirement-analysis** | P1 | Clarify user requirements | requirement, what do you need, scope |
| **task-planning** | P1 | Break work into steps | plan, steps, breakdown, roadmap |

### Core Coding (5 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **code-generation** | P1 | Write new code | write code, create, implement, build |
| **code-editing** | P1 | Modify existing code | edit, modify, change, update, patch |
| **code-explanation** | P2 | Explain code | explain, what does this do, walkthrough |
| **debugging** | P0 | Find and fix bugs | debug, bug, error, crash, exception |
| **refactoring** | P2 | Improve code structure | refactor, clean up, simplify, restructure |

### Quality (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **code-review** | P1 | Review code quality | review, code quality, PR review |
| **testing** | P1 | Create and run tests | test, unit test, coverage, mock |
| **verification** | P0 | Verify changes work | verify, check, does it work, build, lint |

### Architecture (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **system-design** | P2 | Design system architecture | system design, architecture, scalable |
| **api-design** | P2 | Design APIs | api, rest, graphql, endpoint |
| **database-design** | P2 | Design databases | database, schema, table, migration |

### Git & DevOps (4 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **git-workflow** | P2 | Manage Git operations | git, commit, branch, merge, conflict |
| **dockerization** | P3 | Docker configuration | docker, dockerfile, container |
| **ci-cd** | P3 | CI/CD pipelines | ci cd, pipeline, github actions |
| **deployment** | P3 | Deploy applications | deploy, release, production |

### Security & Performance (3 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **security-audit** | P0 | Security review | security, vulnerability, injection, auth |
| **performance-analysis** | P2 | Performance optimization | performance, slow, bottleneck, optimize |
| **concurrency-debugging** | P0 | Debug concurrency issues | race condition, deadlock, async, thread |

### AI & Documentation (4 skills)

| Skill | Priority | Purpose | Triggers |
|-------|----------|---------|----------|
| **agent-orchestration** | P2 | Multi-agent coordination | agent, multi-agent, orchestration |
| **tool-management** | P1 | Tool call management | tool call, tool error, tool failure |
| **context-management** | P1 | Token management | context, token, context window |
| **documentation** | P3 | Write documentation | documentation, docs, readme |

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

## 📊 Priority System

| Priority | Skills | When to Use |
|----------|--------|------------|
| **P0** | debugging, verification, security-audit, concurrency-debugging | Critical: always include when relevant |
| **P1** | project-analysis, requirement-analysis, task-planning, code-generation, code-editing, code-review, testing, tool-management, context-management | High: include for most tasks |
| **P2** | code-explanation, refactoring, system-design, api-design, database-design, git-workflow, performance-analysis, agent-orchestration | Normal: standard development |
| **P3** | dockerization, ci-cd, deployment, documentation | Standard: nice to have |

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

```markdown
# CLAUDE.md

## 🧠 Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file from `.claude/skills/` first.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.

### Quick Reference
| Task | Skill |
|------|-------|
| Analyze project | `skills/core/project-analysis/SKILL.md` |
| Plan work | `skills/core/task-planning/SKILL.md` |
| Write code | `skills/coding/code-generation/SKILL.md` |
| Fix bugs | `skills/coding/debugging/SKILL.md` |
| Review code | `skills/quality/code-review/SKILL.md` |
| Write tests | `skills/quality/testing/SKILL.md` |
| Verify changes | `skills/quality/verification/SKILL.md` |
```

### For Cursor AI

```markdown
# .cursorrules

## 🧠 Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.
```

---

## 📝 Contributing

### How to Add a New Skill

1. Check if an existing skill covers this
2. Create directory: `new-skills/<category>/<skill-name>/`
3. Create `SKILL.md` with the standard format
4. Update `SKILL-MATRIX.md`
5. Update `README.md`
6. Test the skill

### Standard Skill Format

```yaml
---
name: skill-name
description: >-
  Trigger phrases in English and Farsi.
priority: P0/P1/P2/P3
dependencies: [other-skills]
conflicts: [conflicting-skills]
---
```

### Required Sections

1. Purpose
2. When to Activate
3. When NOT to Activate
4. Inputs Required
5. Preconditions
6. Workflow
7. Decision Tree
8. Execution Rules
9. Verification
10. Failure Handling
11. Safety Constraints
12. Output Format
13. Anti-Patterns
14. Skill Interactions

---

## 📄 License

MIT License

---

<div align="center">

**Built with ❤️ for the AI Agent community**

[⬆ Back to Top](#-coding-agent-skill-library)

</div>
