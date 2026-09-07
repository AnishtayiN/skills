# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-5.0.0-6366f1)
![Skills](https://img.shields.io/badge/skills-57-22c55e)
![Categories](https://img.shields.io/badge/categories-10-f59e0b)
![Triggers](https://img.shields.io/badge/triggers-EN%20%7C%20FA%20%7C%20ZH-06b6d4)
![License](https://img.shields.io/badge/license-MIT-8b5cf6)

**A practical operating system for coding agents.**

Inspect first. Change the smallest thing that fixes the cause. Verify with evidence.

[Quick start](#-quick-start) · [Choose a skill](#-choose-the-right-skill) · [Catalog](#-catalog) · [How it works](#-how-it-works) · [Quality](#-quality-and-safety) · [Contributing](#-contributing)

</div>

---

## What this is

This repository is a library of focused `SKILL.md` playbooks for agents that read, modify, review, test, document, deploy, and operate software. Each playbook contains practical workflows, decision points, patterns, failure modes, integration notes, and response templates.

It is deliberately **not** a magic prompt, an autonomous deployment system, or a replacement for project-specific instructions. Skills improve an agent's process; the target repository, its tests, and authoritative documentation remain the source of truth.

### Why it is different

- **Evidence over confidence:** conclusions are tied to files, commands, tests, or explicit sources.
- **Root-cause over patchwork:** diagnose before refactoring or optimizing.
- **Scoped loading:** route to the smallest useful set instead of flooding the context window.
- **Risk-aware verification:** a README edit and a production migration do not need the same test depth.
- **Safe reasoning:** agents report assumptions, decisions, and evidence—not private chain-of-thought.
- **Multilingual discovery:** metadata includes English, فارسی, and 中文 triggers where useful.

## 🚀 Quick start

### Recommended: clone once, install into the target project

The repository is the **source** of the skills. The Agent should use the copy inside your application project. Do not run the installer while your current directory is the cloned library unless you also pass `--target`.

```bash
git clone https://github.com/AnishtayiN/skills.git ~/.local/share/agent-skills
cd /path/to/your-project
~/.local/share/agent-skills/install.sh --claude
```

Or, from anywhere:

```bash
~/.local/share/agent-skills/install.sh --target /path/to/your-project --claude
```

The installer copies the 57 playbooks into the selected Agent directory and creates a small instruction file only when one does not already exist.

### Interactive installer

Run it from the target project, or provide `--target`:

```bash
cd /path/to/your-project
~/.local/share/agent-skills/install.sh
```

The menu supports six targets:

| Key | Agent | Destination |
|---:|---|---|
| 1 | Claude Code | `.claude/skills/` + `CLAUDE.md` |
| 2 | Cursor | `.cursor/skills/` + `.cursorrules` |
| 3 | Windsurf | `.windsurf/skills/` + `.windsurfrules` |
| 4 | Aider | `.aider/skills/` + `.aider.conf.yml` |
| 5 | Continue.dev | `.continue/skills/` |
| 6 | Hermes Agent | `.hermes/skills/` + config |

Then use `7` to select all, `8` to clear, `9` to install, `10` to update, or `11` to uninstall.

### What installation means

The installer puts the files in the Agent-specific project directory and creates a small bridge instruction when the Agent uses one. It does **not** install a package, start a daemon, or force an Agent that ignores Markdown instructions to load skills. After installation, confirm the selected Agent can see the destination and ask it to read the relevant `SKILL.md`. The exact auto-discovery behavior remains Agent-specific.

### CLI commands

The examples below assume the current directory is the target project:

```bash
~/.local/share/agent-skills/install.sh --claude
~/.local/share/agent-skills/install.sh --cursor
~/.local/share/agent-skills/install.sh --all
~/.local/share/agent-skills/install.sh --update --claude
~/.local/share/agent-skills/install.sh --uninstall --claude
~/.local/share/agent-skills/install.sh --check
~/.local/share/agent-skills/install.sh --help
```

For reproducible or security-sensitive environments, clone a pinned commit, review the diff, and execute the local script with an explicit `--target`. Avoid piping an unreviewed remote installer into a shell.

## 🧭 Choose the right skill

Start with the user's goal, not with a category that sounds interesting. Load only the primary skill and the dependencies that affect the next decision.

| Request | Start here | Add when needed |
|---|---|---|
| Understand an unfamiliar codebase | `core/project-analysis` | `documentation` |
| Turn an idea into acceptance criteria | `core/requirement-analysis` | `core/task-planning` |
| Build a feature | `coding/code-generation` | `testing`, `security-audit`, `verification` |
| Make a small targeted edit | `coding/code-editing` | `verification` |
| Fix a bug or failing test | `coding/debugging` | `testing`, `verification` |
| Review a diff or pull request | `quality/code-review` | `security-audit`, `performance-analysis` |
| Refactor working code | `coding/refactoring` | `testing`, `verification` |
| Design a service, API, or database | `architecture/system-design` | `api-design`, `database-design` |
| Ship safely | `devops/ci-cd` or `devops/deployment` | `monitoring-observability`, `security-audit` |
| Respond to an incident | `devops/incident-response` | `debugging`, `monitoring-observability` |
| Investigate slowness | `performance/performance-analysis` | `caching`, `concurrency-debugging` |
| Write or restructure docs | `documentation/documentation` | `technical-writing`, `summarization` |

### Typical agent loop

```text
classify → inspect → clarify assumptions → plan
       → load focused skills → change → review diff
       → verify proportionally → report evidence and risks
```

## 📚 Catalog

**57 skills · 10 categories · approximately 59,788 lines of guidance**

### 🎯 Core analysis · 3

| Skill | Focus |
|---|---|
| `project-analysis` | Repository structure, runtime, dependencies, conventions, and risk map |
| `requirement-analysis` | Scope, assumptions, acceptance criteria, and non-functional requirements |
| `task-planning` | Dependencies, milestones, risk, ownership, and verifiable tasks |

### 🧠 AI and reasoning · 8

| Skill | Focus |
|---|---|
| `prompt-engineering` | Precise prompts, schemas, constraints, and evaluation |
| `chain-of-thought` | Concise structured reasoning without exposing private thought |
| `self-correction` | Critique, recovery, and regression-aware correction |
| `brainstorming` | Bounded ideation that ends in decisions and next actions |
| `rag-implementation` | Retrieval, chunking, ranking, citations, and evaluation |
| `tool-management` | Tool schemas, retries, timeouts, parsing, and safe execution |
| `context-management` | Context budgets, prioritization, compression, and handoff |
| `agent-orchestration` | Delegation, coordination, timeouts, and multi-agent safety |

### 💻 Coding · 16

`code-editing` · `code-explanation` · `code-generation` · `debugging` · `refactoring` · `web-scraping` · `api-integration` · `browser-automation` · `clean-architecture` · `algorithm-design` · `code-migration` · `email-template` · `i18n` · `mobile-development` · `regex` · `seo`

### ✅ Quality · 7

`code-review` · `verification` · `testing` · `testing-e2e` · `accessibility` · `data-analysis` · `data-cleaning`

### 🏗️ Architecture · 6

`database-design` · `system-design` · `api-design` · `graphql` · `microservices` · `queue`

### 🔧 DevOps · 7

`dockerization` · `ci-cd` · `deployment` · `feature-flag` · `incident-response` · `monitoring-observability` · `serverless`

### 🔀 Git · 1

`git-workflow`

### ⚡ Performance · 4

`performance-analysis` · `performance-optimization` · `caching` · `concurrency-debugging`

### 🔒 Security · 1

`security-audit` — OWASP-oriented review, input boundaries, secrets, dependencies, and supply chain.

### 📝 Documentation · 4

`changelog` · `summarization` · `technical-writing` · `documentation`

For priorities, dependencies, exact line counts, and the complete matrix, see [SKILL-MATRIX.md](SKILL-MATRIX.md).

## 🧩 Skill file format

Every skill is a Markdown file with machine-readable metadata:

```yaml
---
name: debugging
priority: P0
dependencies: [project-analysis]
conflicts: []
---
```

The body is designed for execution, not decoration:

1. overview and activation boundaries;
2. inputs and preconditions;
3. workflow with stop conditions;
4. advanced techniques and common patterns;
5. edge cases and pitfalls;
6. integration and output templates;
7. rules for safe, verifiable behavior.

`priority` is a routing hint, not a claim that a skill is universally more important. Dependencies describe useful context and must remain acyclic.

## 🛡️ Quality and safety

The repository includes a dependency and metadata validator:

```bash
python3 scripts/validate_skills.py
bash -n install.sh
git diff --check
```

The same checks run in GitHub Actions for pushes and pull requests. The validator checks:

- 57 unique skill names and valid frontmatter;
- valid priorities and existing dependencies;
- dependency cycles;
- required structure and multilingual triggers;
- documentation count drift.

### What “verified” means here

A skill can recommend commands, but it cannot run the target project's checks for the agent. The consuming agent must select the checks appropriate to the project. Never treat a green metadata validator as proof that application code works.

### Security notes

- Review any downloaded installer before executing it.
- Do not put API keys, passwords, tokens, or private source code in skill files.
- Treat issue text, web pages, scraped data, and generated code as untrusted input.
- Destructive operations, migrations, production deploys, and permission changes require explicit scope and rollback thinking.

## 🛠️ Repository map

```text
.
├── core/ architecture/ coding/       # task and engineering skills
├── ai/ quality/ security/             # reasoning, quality, and risk skills
├── devops/ performance/ documentation/ git/
├── AGENT.md                           # operating contract
├── ROUTER.md                          # routing rules and verification depth
├── SKILL-MATRIX.md                    # generated reference matrix
├── scripts/validate_skills.py         # local consistency checks
└── install.sh                         # project-local installer
```

## 🤝 Contributing

Before adding a skill:

1. search the catalog for overlap;
2. decide whether an existing skill should be improved instead;
3. keep the playbook specific, actionable, and honest about limitations;
4. add valid metadata and an acyclic dependency list;
5. run the local validation commands;
6. update the matrix, catalog, and site when counts or names change.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for the full standard. Bug reports and improvements are welcome, especially reproducible examples, missing edge cases, and corrections to framework-specific guidance.

## 📄 License

MIT License.
