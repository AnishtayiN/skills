# 🧠 DSH Skills Collection — Comprehensive Skill Library for AI Agents

<div align="center">

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![Skills](https://img.shields.io/badge/skills-31-green)
![Languages](https://img.shields.io/badge/languages-Farsi%20%7C%20English-purple)
![License](https://img.shields.io/badge/license-MIT-orange)

**The ultimate skill library for powering AI agents with structured, production-ready capabilities.**

[Installation](#-installation) • [Skills Catalog](#-skills-catalog) • [Agent Integration](#-agent-integration) • [Customization](#-customization) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [What Are Skills?](#what-are-skills)
- [Why Use This Collection?](#why-use-this-collection)
- [Installation](#-installation)
  - [Claude Code](#claude-code)
  - [Hermes Agent](#hermes-agent)
  - [Cursor AI](#cursor-ai)
  - [Windsurf](#windsurf)
  - [Aider](#aider)
  - [Continue.dev](#continuedev)
  - [Custom Agent](#custom-agent-integration)
- [Skills Catalog](#-skills-catalog)
  - [Coding Skills](#-coding-skills)
  - [Architecture & Design Skills](#-architecture--design-skills)
  - [DevOps & Infrastructure Skills](#-devops--infrastructure-skills)
  - [AI & Data Skills](#-ai--data-skills)
  - [Communication & Documentation Skills](#-communication--documentation-skills)
  - [Reasoning & Planning Skills](#-reasoning--planning-skills)
- [Skill Structure](#-skill-structure)
- [Using Skills Together](#-using-skills-together)
- [Customization](#-customization)
- [Contributing](#-contributing)
- [FAQ](#-faq)
- [License](#-license)

---

## What Are Skills?

Skills are **structured instruction documents** that tell an AI agent *how* to perform a specific task. Each skill contains:

- **Trigger conditions** — When to activate this skill
- **Step-by-step workflow** — Exactly what to do, in what order
- **Output format** — How to present results
- **Rules and constraints** — What NOT to do
- **Examples** — Real-world patterns and code

Think of skills as **professional playbooks** for your AI agent. Instead of the agent guessing how to debug code or design an API, it follows a proven, systematic workflow.

## Why Use This Collection?

| Feature | Benefit |
|---------|---------|
| 🎯 **31 Production-Ready Skills** | Cover every major software engineering task |
| 🌐 **Bilingual (Farsi + English)** | Trigger in Farsi or English — works both ways |
| 📐 **Structured Workflows** | Not vague advice — step-by-step procedures |
| 🔗 **Skill Composition** | Skills work together (debug + code-review + refactor) |
| 🏗️ **Agent-Agnostic** | Works with Claude Code, Hermes, Cursor, and any LLM agent |
| 📝 **Consistent Output** | Every skill defines its output format for predictable results |
| 🛡️ **Built-in Guardrails** | Each skill includes "what NOT to do" rules |
| 🧪 **Battle-Tested Patterns** | Based on real-world software engineering practices |

---

## 🚀 Installation

### Prerequisites

- An AI agent that supports custom instructions/system prompts
- Access to the file system (to read skill files)
- Basic understanding of how your agent loads instructions

---

### Claude Code

Claude Code uses **CLAUDE.md** files for project-level instructions. You can load skills in several ways:

#### Option 1: Symlink Skills Directory (Recommended)

```bash
# From your project root
ln -s /path/to/skills .claude/skills

# Then in CLAUDE.md, add:
```

```markdown
# CLAUDE.md

## Skills Reference

When performing tasks, check the skills directory for relevant instructions:
- `skills/debug/SKILL.md` — For debugging any code issue
- `skills/code-review/SKILL.md` — For reviewing code quality
- `skills/refactor/SKILL.md` — For refactoring code
- `skills/test-generation/SKILL.md` — For writing tests
- [Add all relevant skills here]

Before starting any task, read the relevant skill file first.
```

#### Option 2: Direct Reference in CLAUDE.md

```markdown
# CLAUDE.md

## Skills

This project uses a skill-based approach. Available skills:

### Debugging
When the user asks to debug code, read `skills/debug/SKILL.md` and follow its workflow.

### Code Review
When reviewing code, read `skills/code-review/SKILL.md` and follow its workflow.

### Refactoring
When refactoring, read `skills/refactor/SKILL.md` and follow its workflow.

[... repeat for each skill]
```

#### Option 3: Automatic Skill Detection

```markdown
# CLAUDE.md

## Skill System

This project has skills in the `skills/` directory. Each skill is a SKILL.md file
with a YAML frontmatter containing trigger conditions.

When the user's request matches a skill's trigger conditions:
1. Read that skill's SKILL.md file
2. Follow its workflow exactly
3. Use its output format
4. Respect its rules and constraints

Skills are organized by category:
- `skills/debug/` — Debugging
- `skills/code-review/` — Code review
- `skills/refactor/` — Refactoring
[... list all directories]
```

---

### Hermes Agent

Hermes uses a configuration system for loading instructions.

#### Method 1: System Prompt Integration

Add to your Hermes system prompt configuration:

```yaml
# hermes-config.yaml
system_prompt: |
  You have access to a library of skills in the skills/ directory.
  
  Before performing any task:
  1. Check if a relevant skill exists for this task type
  2. If yes, read the skill file and follow its workflow
  3. If no, use your general knowledge
  
  Available skill categories:
  - coding: debug, code-review, refactor, test-generation, explain-code
  - architecture: api-design, system-design, clean-architecture, database-schema
  - devops: dockerization, ci-cd-pipeline, cloud-deployment, git-workflow
  - data: rag-implementation, data-analysis, data-cleaning, web-scraping
  - documentation: documentation, technical-writing, summarization, changelog
  - reasoning: chain-of-thought, brainstorming, task-planning, prompt-engineering
  - security: security-audit
  - automation: browser-automation, api-integration

instructions:
  - path: skills/*/SKILL.md
    pattern: true
```

#### Method 2: Dynamic Skill Loading

```yaml
# hermes-config.yaml
tool_use:
  - name: read_skill
    description: "Read a skill file for task instructions"
    parameters:
      skill_name: "string"
    handler: |
      skill_path = f"skills/{skill_name}/SKILL.md"
      return read_file(skill_path)
```

---

### Cursor AI

Cursor uses `.cursorrules` for project-level instructions.

```markdown
# .cursorrules

## Skill-Based Development

This project uses structured skills for common tasks. Before performing any task,
check if a relevant skill exists.

### Available Skills

When the user asks to:
- **Debug code** → Read `skills/debug/SKILL.md` and follow its workflow
- **Review code** → Read `skills/code-review/SKILL.md` and follow its workflow
- **Refactor code** → Read `skills/refactor/SKILL.md` and follow its workflow
- **Write tests** → Read `skills/test-generation/SKILL.md` and follow its workflow
- **Design API** → Read `skills/api-design/SKILL.md` and follow its workflow
- **Design system** → Read `skills/system-design/SKILL.md` and follow its workflow
- **Write documentation** → Read `skills/documentation/SKILL.md` and follow its workflow
- **Clean data** → Read `skills/data-cleaning/SKILL.md` and follow its workflow
- **Analyze data** → Read `skills/data-analysis/SKILL.md` and follow its workflow
- **Scrape web** → Read `skills/web-scraping/SKILL.md` and follow its workflow
- **Plan tasks** → Read `skills/task-planning/SKILL.md` and follow its workflow
- **Brainstorm** → Read `skills/brainstorming/SKILL.md` and follow its workflow
- **Security audit** → Read `skills/security-audit/SKILL.md` and follow its workflow
- **Deploy cloud** → Read `skills/cloud-deployment/SKILL.md` and follow its workflow
- **Docker setup** → Read `skills/dockerization/SKILL.md` and follow its workflow
- **CI/CD pipeline** → Read `skills/ci-cd-pipeline/SKILL.md` and follow its workflow
- **Git problems** → Read `skills/git-workflow/SKILL.md` and follow its workflow
- **Write prompt** → Read `skills/prompt-engineering/SKILL.md` and follow its workflow
- **RAG system** → Read `skills/rag-implementation/SKILL.md` and follow its workflow
- **Browser automation** → Read `skills/browser-automation/SKILL.md` and follow its workflow
- **API integration** → Read `skills/api-integration/SKILL.md` and follow its workflow
- **Database design** → Read `skills/database-schema/SKILL.md` and follow its workflow
- **Architecture** → Read `skills/clean-architecture/SKILL.md` and follow its workflow
- **Reason step by step** → Read `skills/chain-of-thought/SKILL.md` and follow its workflow
- **Self-correct** → Read `skills/self-correction/SKILL.md` and follow its workflow
- **Explain code** → Read `skills/explain-code/SKILL.md` and follow its workflow
- **Summarize** → Read `skills/summarization/SKILL.md` and follow its workflow
- **Technical writing** → Read `skills/technical-writing/SKILL.md` and follow its workflow
- **Changelog** → Read `skills/changelog/SKILL.md` and follow its workflow

### Rules
1. Always read the skill file before performing the task
2. Follow the skill's workflow step by step
3. Use the skill's output format
4. Respect the skill's rules and constraints
5. If multiple skills apply, use them together
```

---

### Windsurf

Windsurf uses `.windsurfrules` for project instructions.

```markdown
# .windsurfrules

## Skill System

This project includes a comprehensive skill library in the `skills/` directory.

### How to Use Skills

When the user's request matches a skill:
1. Read the skill file at `skills/<skill-name>/SKILL.md`
2. Follow its workflow precisely
3. Use its output format
4. Respect its rules

### Skill Categories

**Coding:** debug, code-review, refactor, test-generation, explain-code, self-correction
**Architecture:** api-design, api-integration, clean-architecture, system-design, database-schema, prompt-engineering
**DevOps:** git-workflow, dockerization, ci-cd-pipeline, cloud-deployment
**Data & AI:** rag-implementation, data-analysis, data-cleaning, web-scraping
**Documentation:** documentation, technical-writing, summarization, changelog
**Reasoning:** chain-of-thought, brainstorming, task-planning
**Security:** security-audit
**Automation:** browser-automation
```

---

### Aider

Aider uses `.aider.conf.yml` and can reference instruction files.

```yaml
# .aider.conf.yml

# Add skills directory to aider's context
instructions:
  - skills/debug/SKILL.md
  - skills/code-review/SKILL.md
  - skills/refactor/SKILL.md
  - skills/test-generation/SKILL.md
  # Add more as needed
```

Or in your `.aider.conf.yml`:

```yaml
# Pre-load common skills
load_skills:
  - debug
  - code-review
  - refactor
  - test-generation
```

---

### Continue.dev

Continue uses `.continue/config.json` for configuration.

```json
{
  "systemMessage": "You have access to skills in the skills/ directory. Before performing any task, check if a relevant skill exists and follow its workflow.",
  "contextProviders": [
    {
      "name": "skills",
      "type": "files",
      "params": {
        "paths": ["skills/*/SKILL.md"]
      }
    }
  ]
}
```

---

### Custom Agent Integration

For any custom agent, you can integrate skills by:

#### 1. Loading Skills as System Prompt

```python
import os
from pathlib import Path

def load_skills(skills_dir: str) -> str:
    """Load all skills into a system prompt."""
    skills = []
    skills_path = Path(skills_dir)
    
    for skill_dir in skills_path.iterdir():
        if skill_dir.is_dir():
            skill_file = skill_dir / "SKILL.md"
            if skill_file.exists():
                skills.append(skill_file.read_text(encoding="utf-8"))
    
    return "\n\n---\n\n".join(skills)

# Usage
system_prompt = f"""You are a helpful AI agent with access to the following skills:

{load_skills('skills/')}

When the user's request matches a skill's trigger conditions, follow that skill's workflow.
"""
```

#### 2. Dynamic Skill Selection

```python
import re
from pathlib import Path

def find_relevant_skills(user_message: str, skills_dir: str) -> list[str]:
    """Find skills relevant to the user's message."""
    relevant = []
    skills_path = Path(skills_dir)
    
    for skill_dir in skills_path.iterdir():
        if not skill_dir.is_dir():
            continue
        
        skill_file = skill_dir / "SKILL.md"
        if not skill_file.exists():
            continue
        
        content = skill_file.read_text(encoding="utf-8")
        
        # Extract triggers from YAML frontmatter
        triggers = extract_triggers(content)
        
        # Check if any trigger matches the user message
        for trigger in triggers:
            if trigger.lower() in user_message.lower():
                relevant.append(str(skill_file))
                break
    
    return relevant

def extract_triggers(skill_content: str) -> list[str]:
    """Extract trigger words from skill YAML frontmatter."""
    # Simple extraction - adapt to your YAML parser
    triggers = []
    in_description = False
    
    for line in skill_content.split("\n"):
        if line.strip().startswith("description:"):
            in_description = True
            # Get first line of description
            desc_line = line.split(":", 1)[1].strip()
            if desc_line:
                triggers.append(desc_line)
        elif in_description and line.startswith("  "):
            triggers.append(line.strip())
        elif in_description:
            in_description = False
    
    return triggers
```

#### 3. Agent Framework Integration

```python
# Example with LangChain
from langchain.agents import AgentExecutor
from langchain.tools import Tool

def create_skill_tool(skills_dir: str):
    """Create a tool that loads and follows skills."""
    
    def use_skill(task_description: str) -> str:
        # Find relevant skill
        skills = find_relevant_skills(task_description, skills_dir)
        
        if not skills:
            return "No relevant skill found. Use general knowledge."
        
        # Load and follow the first relevant skill
        skill_content = Path(skills[0]).read_text(encoding="utf-8")
        return f"Following skill workflow:\n\n{skill_content}"
    
    return Tool(
        name="use_skill",
        description="Load and follow a skill for the given task",
        func=use_skill
    )
```

---

## 📚 Skills Catalog

### 🔧 Coding Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[debug](skills/debug/SKILL.md)** | Universal code & agent debugger with 5-phase workflow | debug, fix error, troubleshooting, اشکال‌زدایی، رفع باگ |
| **[code-review](skills/code-review/SKILL.md)** | 4-pass code review: correctness, security, performance, maintainability | code review, review code, بررسی کد، کیفیت کد |
| **[refactor](skills/refactor/SKILL.md)** | Code refactoring with smell detection and safe transformations | refactor, clean up code, بازنویسی کد، بهبود ساختار |
| **[test-generation](skills/test-generation/SKILL.md)** | Generate unit, integration, and E2E tests | write tests, generate tests, نوشتن تست، تست واحد |
| **[explain-code](skills/explain-code/SKILL.md)** | Layered code explanation (summary → details) | explain code, what does this do, توضیح کد، تحلیل کد |
| **[self-correction](skills/self-correction/SKILL.md)** | Review and correct AI outputs systematically | check your work, verify, خود اصلاحی، بررسی خروجی |

### 🏗️ Architecture & Design Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[api-design](skills/api-design/SKILL.md)** | RESTful API & GraphQL schema design | design API, REST API, طراحی API، اسکیمای GraphQL |
| **[api-integration](skills/api-integration/SKILL.md)** | Connect to third-party APIs with OAuth, retries, rate limits | API integration, OAuth, اتصال API، احراز هویت |
| **[clean-architecture](skills/clean-architecture/SKILL.md)** | SOLID principles, DDD, and layered architecture | clean architecture, SOLID, معماری تمیز، اصول SOLID |
| **[system-design](skills/system-design/SKILL.md)** | Scalable system design with diagrams and trade-offs | system design, architecture, طراحی سیستم، معماری |
| **[database-schema](skills/database-schema/SKILL.md)** | Database design, ER modeling, SQL schema generation | database design, schema, طراحی دیتابیس، مدل‌سازی داده |
| **[prompt-engineering](skills/prompt-engineering/SKILL.md)** | Write, optimize, and critique LLM prompts | prompt engineering, prompt design, نوشتن پرامپت |

### 🚀 DevOps & Infrastructure Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[git-workflow](skills/git-workflow/SKILL.md)** | Git problem resolution, merge conflicts, recovery | git problem, merge conflict, مشکل گیت، کانفلیکت |
| **[dockerization](skills/dockerization/SKILL.md)** | Production-grade Dockerfile & docker-compose | Docker, containerize, داکر، کانتینرسازی |
| **[ci-cd-pipeline](skills/ci-cd-pipeline/SKILL.md)** | CI/CD pipeline setup (GitHub Actions, GitLab CI) | CI/CD, pipeline, پایپ‌لاین، اتوماسیون استقرار |
| **[cloud-deployment](skills/cloud-deployment/SKILL.md)** | Deploy to AWS, GCP, Azure with IaC | deploy cloud, AWS, استقرار ابری، استقرار در ابر |
| **[security-audit](skills/security-audit/SKILL.md)** | Code security review & vulnerability assessment | security audit, vulnerability, بررسی امنیتی، آسیب‌پذیری |

### 🧠 AI & Data Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[rag-implementation](skills/rag-implementation/SKILL.md)** | Build RAG systems with vector DBs and embeddings | RAG, vector search, پیاده‌سازی RAG، جستجوی برداری |
| **[data-analysis](skills/data-analysis/SKILL.md)** | Dataset exploration, statistics, and visualization | data analysis, statistics, تحلیل داده، آمار |
| **[data-cleaning](skills/data-cleaning/SKILL.md)** | Raw data preprocessing and quality assurance | clean data, preprocess, پاکسازی داده، پیش‌پردازش |
| **[web-scraping](skills/web-scraping/SKILL.md)** | Extract structured data from websites | web scraping, scrape, اسکرپینگ وب، استخراج داده |
| **[browser-automation](skills/browser-automation/SKILL.md)** | Playwright, Puppeteer, E2E testing scripts | browser automation, Playwright, اتوماسیون مرورگر |

### 📝 Communication & Documentation Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[documentation](skills/documentation/SKILL.md)** | Project docs, README, API docs, code comments | documentation, README, مستندات، داکیومنت |
| **[technical-writing](skills/technical-writing/SKILL.md)** | Articles, tutorials, and educational content | technical article, blog post, مقاله فنی، بلاگ پست |
| **[summarization](skills/summarization/SKILL.md)** | Condense files, conversations, and codebases | summarize, TL;DR, خلاصه، چکیده |
| **[changelog](skills/changelog/SKILL.md)** | Generate changelogs from git history | changelog, release notes, لاگ تغییرات، یادداشت نسخه |

### 🎯 Reasoning & Planning Skills

| Skill | Description | Triggers (EN/FA) |
|-------|-------------|-------------------|
| **[chain-of-thought](skills/chain-of-thought/SKILL.md)** | Step-by-step reasoning techniques | think step by step, CoT, استدلال گام به گام |
| **[brainstorming](skills/brainstorming/SKILL.md)** | Structured ideation and alternative exploration | brainstorm, ideas, ایده‌پردازی، طوفان فکری |
| **[task-planning](skills/task-planning/SKILL.md)** | Project decomposition and roadmapping | plan project, breakdown, شکستن پروژه، برنامه‌ریزی |

---

## 📁 Skill Structure

Each skill follows a consistent structure:

```
skills/
├── skill-name/
│   ├── SKILL.md                    # Main skill file
│   └── references/                 # Optional reference files
│       └── language-patterns.md    # Language-specific patterns
├── another-skill/
│   └── SKILL.md
└── README.md                       # This file
```

### SKILL.md Format

Every SKILL.md file has:

```markdown
---
name: skill-name
description: >-
  Trigger words and phrases in English and Farsi.
  When to activate this skill.
---

# Skill Title

## Overview
[What this skill does and why it exists]

## When to Use This Skill
[Specific trigger conditions]

## Workflow
### Step 1: [Phase name]
[Detailed instructions]

### Step 2: [Phase name]
[Detailed instructions]

[... more steps]

## Output Format
[Exactly how to present results]

## Rules
[What NOT to do]

## Common Pitfalls to Avoid
[Mistakes to watch out for]
```

---

## 🔗 Using Skills Together

Skills are designed to compose. Here are common skill combinations:

### Code Quality Pipeline
```
code-review → debug (if bugs found) → refactor → test-generation
```

### Feature Development
```
task-planning → system-design → api-design → database-schema → 
dockerization → ci-cd-pipeline → documentation
```

### Data Project
```
data-cleaning → data-analysis → rag-implementation (if needed)
```

### Security Hardening
```
security-audit → code-review (security pass) → dockerization (hardening) → ci-cd-pipeline (security scanning)
```

### Documentation Workflow
```
explain-code → documentation → technical-writing → changelog
```

---

## 🎨 Customization

### Adding New Skills

1. Create a new directory: `skills/your-skill/`
2. Create `SKILL.md` with the standard format
3. Add trigger words in the YAML frontmatter
4. Define the workflow, output format, and rules

```markdown
---
name: my-custom-skill
description: >-
  Trigger words for this skill in English and Farsi.
  Use this when the user asks to do X, Y, or Z.
---

# My Custom Skill

## Overview
[Description]

## Workflow
[Steps]

## Output Format
[Format]

## Rules
[Constraints]
```

### Modifying Existing Skills

1. Read the existing SKILL.md
2. Add your own patterns, examples, or rules
3. Keep the YAML frontmatter format
4. Test with your agent

### Creating Skill Bundles

Group skills for specific agent types:

```markdown
# coding-agent-skills.md
# Include these skills for a coding agent:
- debug
- code-review
- refactor
- test-generation
- explain-code
- self-correction
```

---

## 🤝 Contributing

We welcome contributions! To add or improve a skill:

### Adding a New Skill

1. Fork the repository
2. Create a new directory under `skills/`
3. Create `SKILL.md` following the standard format
4. Add trigger words in both English and Farsi
5. Include at least:
   - Overview
   - When to Use
   - Workflow (3+ steps)
   - Output Format
   - Rules
   - Common Pitfalls
6. Submit a pull request

### Improving Existing Skills

1. Read the existing skill
2. Identify areas for improvement:
   - More examples
   - Better workflows
   - Additional edge cases
   - New patterns
3. Make your changes
4. Submit a pull request

### Quality Standards

- ✅ Clear, step-by-step workflows
- ✅ Concrete output formats
- ✅ Bilingual triggers (English + Farsi)
- ✅ Rules and constraints
- ✅ Common pitfalls
- ✅ At least 100 lines per skill
- ✅ No vague advice — be specific

---

## ❓ FAQ

### Q: Can I use these skills with any AI agent?

**A:** Yes! These skills are designed to be agent-agnostic. They work with any LLM that supports custom instructions or system prompts, including Claude, GPT-4, Gemini, Hermes, and open-source models.

### Q: Do I need to use all skills?

**A:** No. Pick the skills relevant to your use case. A coding agent might use 5-6 skills, while a data agent might use 3-4.

### Q: Can I modify the skills?

**A:** Absolutely. The skills are templates. Customize them for your team's conventions, tech stack, and workflows.

### Q: How do skills work with tool use?

**A:** Skills provide the "how" — they tell the agent what steps to follow. Tools provide the "what" — they let the agent read files, run commands, etc. Skills + Tools = Capable Agent.

### Q: What's the difference between skills and system prompts?

**A:** System prompts define the agent's identity and general behavior. Skills define how to perform specific tasks. A system prompt might say "you are a senior engineer," while a skill says "when debugging, follow these 5 steps."

### Q: Do skills work with non-English prompts?

**A:** Yes. Each skill includes trigger words in both English and Farsi. The agent can activate skills regardless of which language the user writes in.

### Q: How do I handle conflicting skills?

**A:** If two skills could apply, use the more specific one. For example, `security-audit` is more specific than `code-review` for security-focused reviews.

---

## 📊 Skill Comparison Matrix

| Skill | Complexity | Best For | Estimated Lines |
|-------|-----------|----------|----------------|
| debug | ⭐⭐⭐⭐⭐ | Any code issue | 400+ |
| code-review | ⭐⭐⭐⭐ | Code quality | 350+ |
| security-audit | ⭐⭐⭐⭐⭐ | Security issues | 400+ |
| system-design | ⭐⭐⭐⭐⭐ | Architecture | 400+ |
| api-design | ⭐⭐⭐⭐ | API development | 350+ |
| refactor | ⭐⭐⭐⭐ | Code cleanup | 300+ |
| test-generation | ⭐⭐⭐⭐ | Testing | 300+ |
| rag-implementation | ⭐⭐⭐⭐⭐ | AI/ML systems | 400+ |
| prompt-engineering | ⭐⭐⭐⭐ | AI prompts | 350+ |
| dockerization | ⭐⭐⭐⭐ | Containerization | 300+ |
| ci-cd-pipeline | ⭐⭐⭐⭐ | Automation | 300+ |
| cloud-deployment | ⭐⭐⭐⭐⭐ | Cloud infrastructure | 350+ |
| database-schema | ⭐⭐⭐⭐ | Data modeling | 300+ |
| chain-of-thought | ⭐⭐⭐ | Reasoning tasks | 300+ |
| task-planning | ⭐⭐⭐ | Project planning | 250+ |
| brainstorming | ⭐⭐⭐ | Ideation | 250+ |
| documentation | ⭐⭐⭐ | Project docs | 250+ |
| technical-writing | ⭐⭐⭐ | Content creation | 250+ |
| summarization | ⭐⭐⭐ | Content condensing | 250+ |
| explain-code | ⭐⭐⭐ | Code understanding | 250+ |
| git-workflow | ⭐⭐⭐ | Git problems | 250+ |
| self-correction | ⭐⭐⭐ | Error detection | 250+ |
| data-analysis | ⭐⭐⭐⭐ | Data insights | 300+ |
| data-cleaning | ⭐⭐⭐ | Data preparation | 250+ |
| web-scraping | ⭐⭐⭐ | Data extraction | 250+ |
| browser-automation | ⭐⭐⭐⭐ | E2E testing | 300+ |
| api-integration | ⭐⭐⭐⭐ | External services | 300+ |
| changelog | ⭐⭐ | Release notes | 200+ |

---

## 📜 License

MIT License — use freely in personal and commercial projects.

---

<div align="center">

**Built with ❤️ for the AI Agent community**

[⬆ Back to Top](#-dsh-skills-collection--comprehensive-skill-library-for-ai-agents)

</div>
