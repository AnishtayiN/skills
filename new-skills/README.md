# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Skills](https://img.shields.io/badge/skills-28-green)
![Size](https://img.shields.io/badge/size-optimized-purple)
![Priority](https://img.shields.io/badge/priority-P0%20to%20P3-orange)

**A professional, verification-first, root-cause-driven skill library for autonomous coding agents.**

</div>

---

## 🎯 Philosophy

This skill library is built on three core principles:

1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes the root cause.
3. **Verification Required** — Never claim success without proof.

## 📋 Skill Categories

### Core Analysis (3 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| project-analysis | P1 | Understand project structure |
| requirement-analysis | P1 | Clarify user requirements |
| task-planning | P1 | Break work into steps |

### Core Coding (5 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| code-generation | P1 | Write new code |
| code-editing | P1 | Modify existing code |
| code-explanation | P2 | Explain code |
| debugging | P0 | Find and fix bugs |
| refactoring | P2 | Improve code structure |

### Quality (3 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| code-review | P1 | Review code quality |
| testing | P1 | Create and run tests |
| verification | P0 | Verify changes work |

### Architecture (3 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| system-design | P2 | Design system architecture |
| api-design | P2 | Design APIs |
| database-design | P2 | Design databases |

### Git & Repository (1 skill)
| Skill | Priority | Purpose |
|-------|----------|---------|
| git-workflow | P2 | Manage Git operations |

### DevOps (3 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| dockerization | P3 | Docker configuration |
| ci-cd | P3 | CI/CD pipelines |
| deployment | P3 | Deploy applications |

### Security (1 skill)
| Skill | Priority | Purpose |
|-------|----------|---------|
| security-audit | P0 | Security review |

### Performance (2 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| performance-analysis | P2 | Performance optimization |
| concurrency-debugging | P0 | Debug concurrency issues |

### AI/Agent (3 skills)
| Skill | Priority | Purpose |
|-------|----------|---------|
| agent-orchestration | P2 | Multi-agent coordination |
| tool-management | P1 | Tool call management |
| context-management | P1 | Token management |

### Documentation (1 skill)
| Skill | Priority | Purpose |
|-------|----------|---------|
| documentation | P3 | Write documentation |

---

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/AnishtayiN/skills.git
cd skills

# Install for your agent
./install.sh claude      # Claude Code
./install.sh cursor      # Cursor AI
./install.sh windsurf    # Windsurf
./install.sh hermes      # Hermes Agent
./install.sh aider       # Aider
./install.sh continue    # Continue.dev
./install.sh all         # All agents
```

---

## 🧭 Skill Routing

The agent routes tasks automatically:

```
User Request → Task Classification → Skill Detection → Dependency Resolution → Execution → Verification
```

See [ROUTER.md](ROUTER.md) for complete routing logic.

---

## 📊 Priority System

| Priority | When to Use |
|----------|------------|
| **P0** | Critical: debugging, verification, security |
| **P1** | High: code-review, testing, generation |
| **P2** | Normal: refactoring, design, git |
| **P3** | Standard: docs, deployment |

---

## 🔗 Dependencies

Skills can depend on other skills:

```
debugging → project-analysis
refactoring → code-review, testing
deployment → testing, ci-cd, dockerization
```

See [SKILL-MATRIX.md](SKILL-MATRIX.md) for complete dependency graph.

---

## ⚔️ Conflict Resolution

| Conflict | Resolution |
|----------|------------|
| debugging vs refactoring | Debug first |
| security vs performance | Security first |
| minimal-fix vs refactoring | Minimal fix first |

---

## 📖 Usage

### For Claude Code

Add to `CLAUDE.md`:

```markdown
## Skills

This project uses skills from the Skills Library.
When performing tasks, read the relevant skill file first.

Available skills:
- skills/debugging/SKILL.md — For debugging
- skills/code-review/SKILL.md — For code review
- skills/testing/SKILL.md — For testing
```

### For Cursor AI

Add to `.cursorrules`:

```markdown
## Skills

Read the relevant skill file before performing tasks.
Skills are in the skills/ directory.
```

---

## 🏗️ Architecture

```
skills/
├── core/           # Analysis & Planning
├── coding/         # Code Generation, Editing, Debugging
├── quality/        # Review, Testing, Verification
├── architecture/   # System, API, Database Design
├── git/            # Git Operations
├── devops/         # Docker, CI/CD, Deployment
├── security/       # Security Audit
├── performance/    # Performance & Concurrency
├── ai/             # Agent & Tool Management
└── documentation/  # Documentation
```

---

## 📝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for standards.

---

## 📄 License

MIT License
