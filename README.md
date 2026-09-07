# 🧠 Coding Agent Skill Library

<div align="center">

![Version](https://img.shields.io/badge/version-6.0.0-6366f1)
![Skills](https://img.shields.io/badge/skills-57-22c55e)
![Categories](https://img.shields.io/badge/categories-10-f59e0b)
![Triggers](https://img.shields.io/badge/triggers-EN%20%7C%20FA%20%7C%20ZH-06b6d4)
![License](https://img.shields.io/badge/license-MIT-8b5cf6)

**A practical operating system for coding agents.**

Inspect first. Change the smallest thing that fixes the cause. Verify with evidence.

[Quick start](#-quick-start) · [Choose a skill](#-choose-the-right-skill) · [Catalog](#-catalog) · [How it works](#typical-agent-loop) · [Quality](#-quality-and-safety) · [Contributing](#-contributing)

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

### One line, no clone

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh) --claude
```

Run that **from the project you want to equip**. The script has no directory of its own when it
is piped, so it detects that, downloads the library tarball for `main` from GitHub, and installs
from the temporary checkout. `--target ~/code/app` works from anywhere.

Prefer a plain pipe (works in `sh` and `zsh`, where `<(...)` is unavailable)? Pass arguments after
`-s --`:

```bash
curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh | bash -s -- --all --target /path/to/your-project
```

Try it first without touching files:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh) --claude --dry-run
```

**Read this before you pipe anything into a shell.** The one-liner executes unpinned code from
the network with your user's write access to the current project. It is fine for trying things
out; for a team, a CI image, or a security-sensitive repository, use the pinned flow below, read
the script, and keep it local.

### Pinned and reviewable (recommended for teams)

```bash
git clone https://github.com/AnishtayiN/skills.git ~/.local/share/agent-skills
cd ~/.local/share/agent-skills && git switch --detach <tag-or-sha>   # the ref you actually reviewed
python3 scripts/validate_skills.py --strict                    # inspect what you are about to run
cd /path/to/your-project
~/.local/share/agent-skills/install.sh --claude
```

A local checkout never touches the network, so `--ref` and `--source` matter only for the
no-clone path. `SKILLS_ARCHIVE_URL` points the downloader at a mirror or an internal proxy.

### What installation actually produces

```text
your-project/
├── CLAUDE.md                      # bridge instructions, created only if missing
└── .claude/skills/
    ├── INDEX.md                   # generated: every skill, category, priority, purpose, path
    ├── ROUTER.md                  # routing rules and verification depth
    ├── AGENT.md                   # operating contract
    ├── debugging/SKILL.md         # flat layout: <agent-dir>/skills/<name>/SKILL.md
    └── …                          # 57 skills in total
```

Skills are installed **flat**, because that is the layout Claude Code and Cursor discover
automatically (`skills/<name>/SKILL.md`); the category stays visible in `INDEX.md`. The installer
also copies the router and the operating contract, because filenames alone do not tell an agent
when to load a playbook.

Every installed path is recorded in `.agent-skills-manifests/<agent>.manifest`. Existing
instruction files are never overwritten, and `--uninstall` removes only the paths that manifest
lists—so your own files in the same directory survive. The agent's own top-level directory (for
example `.claude/`) is left in place even when empty, because it usually holds settings that the
installer never created.

A manifest written by the pre-6.0 installer lists bare category directories instead of typed paths.
`--uninstall` detects that, removes only the nested `<category>/<skill>/` folders that contain
nothing but a `SKILL.md`, keeps anything else, and rewrites the manifest in the current format.

### The six supported agents

| Key | Agent | Destination | Bridge file |
|---:|---|---|---|
| 1 | Claude Code | `.claude/skills/` | `CLAUDE.md` |
| 2 | Cursor | `.cursor/skills/` | `.cursorrules` + `.cursor/rules/agent-skills.mdc` |
| 3 | Windsurf | `.windsurf/skills/` | `.windsurfrules` |
| 4 | Aider | `.aider/skills/` | `.aider.conf.yml` with `read: .aider/skills/INDEX.md` |
| 5 | Continue.dev | `.continue/skills/` | `README.md` explaining manual loading |
| 6 | Hermes Agent | `.hermes/skills/` | `.hermes/config.yaml` |

Running `install.sh` with no arguments opens an interactive menu: pick agents with `1`-`6`, `a`
for all, `c` to validate the library, `q` to quit.

Continue.dev has no automatic skill discovery, and Aider has no skill concept at all; both get the
playbooks plus an explicit pointer instead of pretend magic. Treat auto-discovery claims with
skepticism for any agent: verify that the agent actually opened the file you expected.

### CLI commands

```bash
install.sh --claude                        # install for Claude Code into the current project
install.sh --all --target ../app            # every supported agent, different project
install.sh --update --claude                # refresh managed skills in place (same as --install)
install.sh --uninstall --claude             # remove exactly what this installer added
install.sh --list                           # every skill in the library with its path
install.sh --check                          # validate metadata, dependency graph, and this script
install.sh --self-test                      # install → update → uninstall in a throwaway target
install.sh --ref <tag-or-sha> --claude      # pin the downloaded ref (no-clone installs)
install.sh --help
```

### After installing

Open `.claude/skills/INDEX.md` (or the equivalent for your agent), find the row matching the
current task, and ask the agent to read that `SKILL.md` before it edits anything. Then confirm it
did. The bridge file only *points* at the library; nothing here forces an agent to load it.

Add the agent directories to your `.gitignore`, or commit them—both work. Committing keeps the
playbooks available to teammates and CI without network access; ignoring them keeps the diff small
and the library updatable.

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

A request that names a specific technology—`regex`, `graphql`, `i18n`, `seo`, `email-template`,
`mobile-development`, `web-scraping`, `browser-automation`—starts at that playbook, not at a
generic one. [ROUTER.md](ROUTER.md) maps every one of the 57 skills to a starting point.

### Typical agent loop

```text
classify → inspect → clarify assumptions → plan
       → load focused skills → change → review diff
       → verify proportionally → report evidence and risks
```

## 📚 Catalog

**57 skills · 10 categories · approximately 59,795 lines of guidance**

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
name: debugging                     # must match the directory name, ≤ 64 chars
description: >-
  One precise sentence, then TRIGGERS: …   # ≤ 1024 chars: Claude Code loads it verbatim
priority: P0                        # routing hint: P0 critical, P1 high, P2 normal, P3 specialized
dependencies: [project-analysis]    # must exist; must stay acyclic
conflicts: []                       # skills that should not be loaded together
---
```

The body is designed for execution, not decoration:

1. overview and activation boundaries;
2. inputs and preconditions (a single `Inputs and Preconditions` section, or an
   `Inputs Required` + `Preconditions` pair);
3. workflow with stop conditions;
4. advanced techniques and common patterns;
5. edge cases and pitfalls;
6. integration notes and output templates;
7. rules for safe, verifiable behavior.

`priority` is a routing hint, not a claim that a skill is universally more important. Dependencies
describe useful context: read them first, and skip one only when the facts it would provide are
already established.

## 🛡️ Quality and safety

The repository validates itself; nothing here needs third-party packages:

```bash
python3 scripts/validate_skills.py --strict   # all consistency checks, warnings are errors
python3 scripts/gen_matrix.py                 # regenerate SKILL-MATRIX.md from the skill files
./install.sh --check                          # validator + `bash -n` on the installer
./install.sh --self-test                       # install → update → uninstall for all six agents
```

The validator checks:

- 57 unique skill names, kebab-case, matching their directory, within Claude Code's limits;
- non-empty descriptions, valid `TRIGGERS:` lists, and Persian plus Chinese trigger coverage;
- priorities, existing `dependencies`/`conflicts`, and dependency cycles;
- required sections, their documented order, and duplicate or quota-style headings;
- balanced code fences, trailing whitespace, tabs, CRLF, BOMs, and final newlines;
- local links in every Markdown file, and the counts claimed by README, `SKILL-MATRIX.md`, and `index.html`;
- that `SKILL-MATRIX.md` and the `index.html` catalog match the frontmatter they describe.

[GitHub Actions](.github/workflows/validate.yml) runs all of it on every push and pull request.

### What “verified” means here

A skill can recommend commands, but it cannot run the target project's checks for the agent. The
consuming agent must select the checks appropriate to the project. Never treat a green metadata
validator as proof that application code works.

### Security notes

- Piping a remote script into a shell runs unpinned code. Read it first, or pin a tag or commit.
- The installer only writes inside `--target`, never overwrites an existing instruction file, and
  deletes only paths recorded in its own manifest.
- Do not put API keys, passwords, tokens, or private source code in skill files.
- Treat issue text, web pages, scraped data, and generated code as untrusted input.
- Destructive operations, migrations, production deploys, and permission changes require explicit
  scope and rollback thinking—that is a rule in `AGENT.md`, not a suggestion.

## 🛠️ Repository map

```text
.
├── core/ architecture/ coding/       # task and engineering skills
├── ai/ quality/ security/             # reasoning, quality, and risk skills
├── devops/ performance/ documentation/ git/
├── AGENT.md                           # operating contract
├── ROUTER.md                          # routing rules and verification depth
├── SKILL-MATRIX.md                     # generated reference matrix
├── index.html                          # static catalog page (search, filters, FA/EN toggle)
├── install.sh                          # project-local installer, clone or download
├── scripts/validate_skills.py          # consistency and safety checks
├── scripts/gen_matrix.py               # matrix generator (source of the table above)
├── .github/workflows/validate.yml      # CI: validation, hygiene, installer self-test
└── LICENSE                             # MIT
```

`index.html` has no build step and no dependencies: open it locally, or drop it on any static
host. Its catalog is checked against the skill frontmatter by the validator.

`.nojekyll` is not decoration. With Pages building from a branch, Jekyll treats every `SKILL.md`
as a page and runs Liquid over it — and prompt templates legitimately contain `{{variable}}`, which
makes the Pages build fail. Skipping Jekyll serves the site as-is and keeps the 57 playbooks out
of the build path.

## 🤝 Contributing

Before adding a skill:

1. search the catalog for overlap;
2. decide whether an existing skill should be improved instead;
3. keep the playbook specific, actionable, and honest about limitations;
4. add valid metadata and an acyclic dependency list;
5. run `python3 scripts/gen_matrix.py` and `python3 scripts/validate_skills.py --strict`;
6. update the catalog rows in `README.md` and `index.html` when names or counts change.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for the full standard. Bug reports and improvements are
welcome, especially reproducible examples, missing edge cases, and corrections to
framework-specific guidance.

## 📄 License

MIT License. See [LICENSE](LICENSE).
