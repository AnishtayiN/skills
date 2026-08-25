---
name: project-analysis
description: >-
  Analyze and understand project structure, tech stack, dependencies, and architecture before any coding task.
  TRIGGERS: project structure, understand this codebase, analyze project, what is this project, what tech stack,
  project overview, codebase overview, explore project, map the codebase, architecture overview,
  تحلیل پروژه, ساختار پروژه, بررسی پروژه, کدوم فایل, این پروژه چیه, ساختار کد, معماری پروژه
priority: P1
dependencies: []
conflicts: []
---

# Project Analysis Skill

## Purpose

Understand a project's structure, tech stack, dependencies, conventions, and architecture BEFORE any modification. Every coding task starts here.

## When to Activate

- Starting work on an unfamiliar codebase
- User asks "what is this project?" or "explain this codebase"
- Before debugging, refactoring, or adding features
- When context is unclear
- After receiving a new task on existing code

## When NOT to Activate

- Modifying a single well-understood file
- User provides exact file paths and clear instructions
- Simple one-line fixes

## Inputs Required

- Project root path (or auto-detect from working directory)
- Optional: specific area of interest

## Preconditions

- Agent has file system access
- Project files are accessible

## Workflow

### Step 1: Discovery

```
1. Read package.json / requirements.txt / go.mod / Cargo.toml / pom.xml
   → Identify language, framework, version

2. Read config files
   → tsconfig.json, .eslintrc, pyproject.toml, Makefile, etc.

3. List top-level directory structure
   → Identify src/, lib/, tests/, docs/, etc.

4. Read README.md if exists
   → Understand project purpose
```

### Step 2: Architecture Mapping

```
1. Identify entry points
   → main.*, index.*, app.*, server.*

2. Identify module boundaries
   → How is code organized? Feature-based? Layer-based?

3. Identify data layer
   → Database, ORM, models, schemas

4. Identify API layer
   → Routes, controllers, handlers

5. Identify test structure
   → Where are tests? What framework?
```

### Step 3: Dependency Analysis

```
1. List key dependencies and their versions
2. Identify deprecated or vulnerable packages
3. Check for lock files (package-lock.json, poetry.lock)
4. Note any unusual or custom dependencies
```

### Step 4: Convention Detection

```
1. Naming conventions (camelCase, snake_case, PascalCase)
2. File organization patterns
3. Import style (relative vs absolute)
4. Error handling patterns
5. Logging patterns
6. Testing patterns
```

## Decision Tree

```
Is this a new/unknown project?
├── YES → Full analysis (all steps)
├── PARTIAL → Targeted analysis (relevant modules only)
└── NO → Skip to task
```

## Execution Rules

- READ files before making assumptions
- NEVER guess the tech stack — verify from config files
- Report findings in structured format
- If project is too large, focus on relevant modules
- Save analysis for reuse in same session

## Verification

- [ ] Tech stack identified correctly
- [ ] Entry points found
- [ ] Module structure understood
- [ ] Key dependencies listed
- [ ] Conventions documented

## Failure Handling

- If config files missing → Infer from code syntax and imports
- If project too large → Focus on relevant directories
- If ambiguous → Ask user for clarification

## Safety Constraints

- READ-ONLY analysis — do not modify any files
- Do not run arbitrary code during analysis
- Do not install packages

## Output Format

```
## Project Analysis

### Tech Stack
- Language: [language + version]
- Framework: [framework + version]
- Database: [database]
- Package Manager: [pm]

### Structure
[directory tree]

### Entry Points
[main files]

### Key Modules
[module descriptions]

### Dependencies
[notable dependencies]

### Conventions
[naming, patterns, style]

### Architecture Pattern
[MVC, layered, feature-based, etc.]

### Notes
[any observations]
```

## Anti-Patterns

- ❌ Starting to code without understanding the project
- ❌ Assuming tech stack from file extensions alone
- ❌ Ignoring configuration files
- ❌ Skipping dependency analysis
- ❌ Not checking for existing tests

## Skill Interactions

- → task-planning: After analysis, plan next steps
- → debugging: Analysis provides context for debugging
- → refactoring: Analysis identifies refactoring opportunities
- → code-review: Analysis provides baseline for review
