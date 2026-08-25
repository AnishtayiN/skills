---
name: project-analysis
description: >-
  Analyze and understand project structure, tech stack, dependencies, and architecture before any coding task.
  TRIGGERS: project structure, understand this codebase, analyze project, what is this project, what tech stack,
  project overview, codebase overview, explore project, map the codebase, architecture overview,
  تحلیل پروژه, ساختار پروژه, بررسی پروژه, کدوم فایل, این پروژه چیه, ساختار کد, معماری پروژه
  项目结构, 理解代码库, 分析项目, 技术栈, 架构概览, 代码库探索, 项目概览
priority: P1
dependencies: []
conflicts: []
---

# Project Analysis Skill

## Overview

Comprehensive analysis of a project's structure, tech stack, dependencies, conventions, and architecture BEFORE any modification. This is the foundational skill — every coding task starts here. Produces a structured report that feeds into requirement analysis, task planning, debugging, refactoring, and code review. Read-only by design; never modifies project files.

## When to Use This Skill

- Starting work on an unfamiliar codebase
- User asks "what is this project?" or "explain this codebase"
- Before debugging, refactoring, or adding features to existing code
- Context is unclear and assumptions would be risky
- After receiving a new task on existing code
- Migrating or onboarding to a new team/project
- Evaluating a project for adoption, contribution, or dependency

## When NOT to Use This Skill

- Modifying a single well-understood file with exact instructions
- User provides explicit file paths and clear implementation details
- Simple one-line fixes or typo corrections
- Working on a freshly created project you just built yourself

## Workflow (Detailed Multi-Phase)

### Phase 1: Discovery & Identification

```
1. Read manifest files
   → package.json / requirements.txt / go.mod / Cargo.toml / pom.xml / build.gradle / Gemfile
   → Identify: language, framework, version constraints, entry points

2. Read configuration files
   → tsconfig.json, .eslintrc, pyproject.toml, Makefile, CMakeLists.txt, webpack.config.js
   → Identify: build system, linting rules, compiler options, module resolution

3. List top-level directory structure
   → Identify: src/, lib/, tests/, docs/, scripts/, configs/
   → Note: monorepo indicators (workspaces, lerna.json, nx.json, turbo.json)

4. Read README.md and CONTRIBUTING.md if they exist
   → Understand: project purpose, setup instructions, contribution guidelines

5. Check for environment files
   → .env.example, .env.local, docker-compose.yml
   → Understand: runtime requirements, external services
```

### Phase 2: Architecture Mapping

```
1. Identify entry points
   → main.*, index.*, app.*, server.*, cli.*
   → Trace import chains from entry points

2. Identify module boundaries
   → Feature-based? Layer-based? Domain-driven? Plugin architecture?
   → How are modules connected? (imports, events, IPC, HTTP)

3. Identify data layer
   → Database: PostgreSQL, MongoDB, SQLite, Redis
   → ORM: Prisma, SQLAlchemy, TypeORM, Sequelize
   → Models, schemas, migrations, seeds

4. Identify API layer
   → REST, GraphQL, gRPC, WebSocket
   → Routes, controllers, resolvers, middleware
   → Authentication/authorization patterns

5. Identify presentation layer
   → Frontend framework: React, Vue, Angular, Svelte
   → State management: Redux, Zustand, Pinia, MobX
   → Styling: CSS modules, Tailwind, styled-components

6. Identify test structure
   → Where are tests? Co-located? Separate directory?
   → Test framework: Jest, Vitest, pytest, Go testing
   → Coverage configuration

7. Map cross-cutting concerns
   → Logging, error handling, authentication, caching
   → Configuration management, feature flags
```

### Phase 3: Dependency Analysis

```
1. Categorize dependencies
   → Core: framework, language runtime
   → Database: ORM, drivers, migration tools
   → Utilities: lodash, moment, date-fns
   → Dev: build tools, linters, test frameworks

2. Assess dependency health
   → Check versions against latest releases
   → Identify deprecated packages
   → Look for known vulnerabilities (npm audit, safety)
   → Note any unusual or custom dependencies

3. Analyze dependency graph
   → Circular dependencies?
   → Very deep dependency trees?
   → Bundled vs. external dependencies?

4. Check lock files
   → package-lock.json / yarn.lock / pnpm-lock.yaml / poetry.lock
   → Lock file integrity (committed? .gitignored?)
```

### Phase 4: Convention Detection

```
1. Naming conventions
   → Variables: camelCase, snake_case, SCREAMING_SNAKE_CASE
   → Files: kebab-case, PascalCase, camelCase, snake_case
   → Classes: PascalCase, snake_case
   → Constants: UPPER_SNAKE_CASE, camelCase

2. File organization patterns
   → Feature-based: src/features/auth/, src/features/users/
   → Layer-based: src/controllers/, src/services/, src/models/
   → Domain-driven: bounded contexts, aggregates

3. Import style
   → Relative vs. absolute imports
   → Barrel files (index.ts re-exports)
   → Import ordering conventions

4. Error handling patterns
   → try/catch, Result types, error boundaries
   → Custom error classes vs. string errors
   → Error logging strategy

5. Testing patterns
   → AAA (Arrange-Act-Assert)
   → BDD (Given-When-Then)
   → Mocking strategy
   → Test naming conventions

6. Code style
   → Prettier/ESLint configuration
   → Indentation (tabs vs. spaces, size)
   → Semicolons, quotes, trailing commas
   → Line length limits
```

### Phase 5: Health Assessment

```
1. Code quality indicators
   → Test coverage percentage
   → Linting violations (if detectable)
   → TODO/FIXME/HACK comments count
   → Dead code indicators

2. Documentation quality
   → README completeness
   → API documentation (Swagger, JSDoc, docstrings)
   → Inline comments density
   → Architecture Decision Records (ADRs)

3. Build & deployment
   → Build scripts in package.json
   → CI/CD configuration files
   → Docker/containerization setup
   → Environment-specific configurations
```

## Advanced Techniques

### 1. Dependency Graph Visualization

```bash
# Generate dependency graph for Node.js projects
npx madge --image deps.svg src/

# Find circular dependencies
npx madge --circular src/

# For Python projects
pydeps src/ --max-bacon=2 --cluster --grouped
```

### 2. Automated Tech Stack Detection

```python
def detect_stack(project_path: str) -> dict:
    """Detect project tech stack from file patterns."""
    indicators = {
        'react': ['jsx', 'tsx', 'next.config'],
        'vue': ['vue', 'nuxt.config'],
        'angular': ['angular.json', 'component.ts'],
        'python': ['requirements.txt', 'pyproject.toml', 'setup.py'],
        'go': ['go.mod', 'go.sum'],
        'rust': ['Cargo.toml'],
        'java': ['pom.xml', 'build.gradle'],
    }
    detected = []
    for stack, patterns in indicators.items():
        for pattern in patterns:
            if any(Path(project_path).rglob(f"*{pattern}")):
                detected.append(stack)
                break
    return {'stacks': detected, 'confidence': len(detected) > 0}
```

### 3. Architecture Pattern Recognition

```bash
# Detect MVC pattern
find src/ -name "*Controller*" -o -name "*Model*" -o -name "*View*" | head -5

# Detect feature-based organization
ls src/features/ 2>/dev/null || ls src/modules/ 2>/dev/null || ls src/domains/ 2>/dev/null

# Detect layered architecture
find src/ -name "*Service*" -o -name "*Repository*" -o -name "*Controller*" | head -10
```

### 4. Codebase Size Metrics

```bash
# Lines of code by language
find . -name "*.ts" -o -name "*.js" | xargs wc -l | tail -1
find . -name "*.py" | xargs wc -l | tail -1

# File count by extension
find . -not -path '*/node_modules/*' -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10

# Directory depth analysis
find src/ -type d | awk -F/ '{print NF-1}' | sort -n | uniq -c
```

### 5. API Surface Analysis

```bash
# Extract all exported functions from a Node.js project
grep -r "export " src/ --include="*.ts" | grep -v "export default" | head -20

# Count API endpoints in Express/Fastify
grep -r "router\.\(get\|post\|put\|delete\|patch\)" src/ | wc -l

# Count GraphQL resolvers
grep -r "Query\|Mutation\|Subscription" src/ --include="*.ts" | head -10
```

### 6. Security Posture Quick Scan

```bash
# Check for hardcoded secrets patterns
grep -rn "password\|secret\|api_key\|token" src/ --include="*.{ts,js,py}" | grep -v "test\|example\|mock"

# Check .gitignore for sensitive files
grep -i "env\|secret\|key\|token\|credential" .gitignore

# Check for SQL injection risks
grep -rn "query.*+\|execute.*+" src/ --include="*.ts" --include="*.js" | head -5
```

### 7. Technical Debt Scoring

```python
def calculate_tech_debt(project_path: str) -> dict:
    """Score project technical debt from observable indicators."""
    debt = {
        'outdated_deps': 0,
        'todo_comments': 0,
        'test_coverage_gap': 0,
        'no_linting': 0,
        'missing_types': 0,
        'total_score': 0
    }
    # Count TODO/FIXME/HACK
    # Check for missing TypeScript/Type hints
    # Check for absent or weak linting config
    # Check test-to-source ratio
    # Weights and scoring logic
    debt['total_score'] = sum(debt.values())
    return debt
```

## Common Patterns

### Pattern 1: Quick Project Fingerprint

```bash
# One-shot project overview in 5 commands
echo "=== Package ===" && cat package.json | head -5
echo "=== Structure ===" && ls -la
echo "=== Dependencies ===" && cat package.json | jq '.dependencies | keys' 2>/dev/null | head -10
echo "=== Scripts ===" && cat package.json | jq '.scripts' 2>/dev/null
echo "=== Config ===" && ls *.config.* .eslintrc* tsconfig.json 2>/dev/null
```

### Pattern 2: Module Boundary Detection

```python
def find_module_boundaries(src_dir: str) -> list[str]:
    """Identify logical modules from directory structure."""
    boundaries = []
    for entry in Path(src_dir).iterdir():
        if entry.is_dir():
            has_index = (entry / 'index.ts').exists() or (entry / 'index.js').exists()
            has_types = any(entry.glob('*.types.ts')) or any(entry.glob('*.d.ts'))
            has_tests = any(entry.rglob('*.test.*'))
            if has_index or (has_types and has_tests):
                boundaries.append(entry.name)
    return boundaries
```

### Pattern 3: API Route Inventory

```bash
# Generate complete API route inventory
grep -rnE "\.(get|post|put|delete|patch|all)\(['\"]" src/ \
  | sed 's/.*\.\(get\|post\|put\|delete\|patch\|all\)/\1/' \
  | sort | uniq -c | sort -rn
```

### Pattern 4: Configuration Audit

```python
def audit_configs(project_root: str) -> dict:
    """Audit project configuration completeness."""
    configs = {
        'linting': Path(project_root, '.eslintrc*').exists(),
        'formatting': Path(project_root, '.prettierrc*').exists(),
        'typescript': Path(project_root, 'tsconfig.json').exists(),
        'testing': Path(project_root, 'jest.config*').exists(),
        'docker': Path(project_root, 'Dockerfile').exists(),
        'ci_cd': Path(project_root, '.github/workflows').exists(),
        'env_template': Path(project_root, '.env.example').exists(),
    }
    return configs
```

### Pattern 5: Technology Radar Snapshot

```markdown
## Technology Radar: [Project Name]

### ADOPT
- TypeScript 5.x — Primary language
- Vitest — Test framework

### TRIAL
- tRPC — API layer
- Drizzle ORM — Database access

### ASSESS
- Bun — Runtime alternative
- Turborepo — Monorepo tool

### HOLD
- Webpack — Use Vite instead
- Moment.js — Use date-fns
```

## Edge Cases & Pitfalls

1. **Monorepo confusion** — Single `package.json` at root doesn't mean single package. Always check for workspaces, `packages/`, or `apps/` directories.

2. **Generated code in analysis** — Auto-generated files (protobuf, OpenAPI, GraphQL codegen) inflate metrics and confuse architecture detection. Exclude `*.generated.*` files.

3. **Compiled vs. source confusion** — Always analyze `src/` or `lib/` source, not `dist/`, `build/`, or `node_modules/`. Compiled output reflects a different state.

4. **Multiple entry points** — Some projects have CLI, web, and worker entry points. Identifying only the main entry point misses the full picture.

5. **Dynamic imports obscure architecture** — `import()` calls hide module boundaries. Static analysis may miss lazy-loaded modules and route-based code splitting.

6. **Dead code indicators** — Files not imported anywhere may be dead code, but could also be dynamically loaded or used as configuration. Verify before flagging.

7. **Environment-dependent behavior** — Code may behave differently based on `NODE_ENV`, feature flags, or environment variables. Analysis captures one snapshot.

8. **Cross-language projects** — Full-stack projects may use TypeScript frontend + Python backend. Analyze both independently and map the API contract between them.

9. **Vendor lock-in signals** — Proprietary cloud SDKs (AWS, GCP, Azure) indicate infrastructure dependencies. Note these as migration risks.

10. **Circular dependency masks** — Barrel files (`index.ts`) can hide circular dependencies. Always verify with madge or dependency-cruiser.

11. **Private registry packages** — Internal packages from private registries won't resolve publicly. Note these as deployment prerequisites.

12. **Git submodule complexity** — Projects using git submodules have nested repositories. Each submodule needs independent analysis.

13. **Docker multi-stage builds** — Dockerfile may have multiple stages with different dependencies. Analyze the final stage for runtime, build stage for dev dependencies.

14. **Orphaned configuration** — Config files for removed tools (e.g., `.babelrc` after migrating to SWC) indicate incomplete migrations.

15. **License compliance** — Some dependencies have copyleft licenses (GPL, AGPL). Note these in analysis as they affect distribution rights.

## Integration with Other Skills

| Skill | Relationship | How It Connects |
|-------|-------------|-----------------|
| requirement-analysis | Feeds into | Project analysis provides context for understanding requirements |
| task-planning | Feeds into | Architecture knowledge informs task decomposition and ordering |
| debugging | Supports | Module boundaries and data flow understanding accelerate debugging |
| refactoring | Supports | Architecture patterns and conventions guide refactoring decisions |
| code-review | Baseline | Established conventions become the review standard |
| code-generation | Context | Tech stack and patterns guide generated code style |
| system-design | Foundation | Current architecture informs design decisions |
| testing | Scaffolding | Test framework and patterns are identified during analysis |
| git-workflow | Metadata | Branching strategy and commit conventions from repo history |
| ci-cd | Pipeline | Build and deployment setup identified during analysis |

## Output Format Templates

### Template 1: Quick Overview (for small projects)

```markdown
## Project Overview: [Project Name]

**Language:** TypeScript 5.2
**Framework:** Next.js 14 (App Router)
**Database:** PostgreSQL + Prisma ORM
**Package Manager:** pnpm

### Structure
src/
├── app/          # Next.js App Router pages
├── components/   # Shared React components
├── lib/          # Utilities and helpers
├── prisma/       # Database schema and migrations
└── types/        # TypeScript type definitions

### Key Entry Points
- `src/app/layout.tsx` — Root layout
- `src/app/api/` — API routes
- `src/lib/auth.ts` — Authentication

### Dependencies (Notable)
- next@14.1.0, react@18.2.0, prisma@5.9.0
- next-auth@4.24.0 (authentication)
- zod@3.22.0 (validation)

### Conventions
- PascalCase for components, camelCase for utilities
- Absolute imports from `@/` prefix
- Server Components by default, `"use client"` when needed
```

### Template 2: Full Analysis (for complex projects)

```markdown
## Full Project Analysis: [Project Name]

### 1. Tech Stack
| Layer | Technology | Version |
|-------|-----------|---------|
| Language | TypeScript | 5.2.0 |
| Runtime | Node.js | 20.x |
| Framework | NestJS | 10.x |
| Database | PostgreSQL | 15.x |
| ORM | TypeORM | 0.3.x |
| Auth | Passport.js | 0.6.x |
| Testing | Jest | 29.x |
| Build | SWC | latest |
| CI/CD | GitHub Actions | — |

### 2. Architecture Pattern
**Layered Architecture** with dependency injection.
- Controllers → Services → Repositories → Database
- Modules encapsulate domain boundaries
- Shared modules for cross-cutting concerns

### 3. Directory Structure
[tree output]

### 4. Module Map
| Module | Responsibility | Key Files |
|--------|---------------|-----------|
| auth | Authentication & authorization | auth.module.ts, auth.service.ts |
| users | User management | users.module.ts, users.service.ts |
| orders | Order processing | orders.module.ts, orders.service.ts |

### 5. Data Flow
[request lifecycle diagram]

### 6. Dependency Health
| Package | Current | Latest | Status |
|---------|---------|--------|--------|
| @nestjs/core | 10.3.0 | 10.3.0 | ✅ Current |
| typeorm | 0.3.17 | 0.3.20 | ⚠️ Update available |

### 7. Convention Summary
[convention details]

### 8. Technical Debt Indicators
- TODO comments: 12
- FIXME comments: 3
- Missing tests: 8 modules
- Outdated deps: 5 packages
```

### Template 3: Monorepo Analysis

```markdown
## Monorepo Analysis: [Project Name]

### Workspace Structure
| Package | Path | Version | Dependencies |
|---------|------|---------|--------------|
| @org/core | packages/core | 1.0.0 | — |
| @org/api | packages/api | 1.0.0 | @org/core |
| @org/web | apps/web | 1.0.0 | @org/core, @org/api |
| @org/admin | apps/admin | 1.0.0 | @org/core |

### Shared Configuration
- Base TypeScript config: `tsconfig.base.json`
- Shared ESLint: `eslint-config/`
- Shared tooling: `tools/`

### Package Dependency Graph
@org/web → @org/api → @org/core
@org/admin → @org/core

### Build Order
1. @org/core (no deps)
2. @org/api (depends on core)
3. @org/web, @org/admin (depend on core + api)
```

### Template 4: Comparative Analysis

```markdown
## Comparative Analysis: [Project Name] vs. [Reference]

| Aspect | This Project | Reference | Gap |
|--------|-------------|-----------|-----|
| Language | JavaScript | TypeScript | Migration needed |
| Testing | None | 80% coverage | Critical gap |
| Linting | ESLint | ESLint + Prettier | Missing formatter |
| CI/CD | Manual | GitHub Actions | Automation needed |
| Auth | Custom | NextAuth | Risk — reinventing |
| Database | MongoDB | PostgreSQL | Different paradigm |

### Recommendations
1. Add TypeScript configuration and migrate incrementally
2. Set up Jest with minimum 60% coverage threshold
3. Add Prettier for consistent formatting
4. Create CI/CD pipeline with automated testing
```

## Rules

1. **READ before assuming** — Always read actual config files, never guess the tech stack from file extensions or directory names alone.

2. **Never modify during analysis** — This is a read-only skill. Do not create, edit, or delete any project files during analysis.

3. **Scope to relevant modules** — For large projects, focus analysis on the modules relevant to the current task. Do not attempt full-codebase analysis on enterprise projects.

4. **Verify claims with evidence** — Every assertion about the project must reference a specific file or command output. "Uses TypeScript" must come from `tsconfig.json` or `package.json`, not assumption.

5. **Report uncertainty explicitly** — If a pattern is ambiguous or a configuration is incomplete, say so. Never present guesses as facts.

6. **Cache analysis within session** — Store the analysis result so it can be referenced by subsequent skills (requirement-analysis, task-planning) without re-scanning.

7. **Respect .gitignore boundaries** — Do not analyze files excluded by `.gitignore` unless specifically requested. They may contain secrets or generated content.

8. **Check for security signals** — During analysis, note any hardcoded secrets, overly permissive CORS, SQL injection risks, or missing authentication. Report but do not fix.

9. **Identify risks proactively** — Outdated dependencies, missing tests, circular imports, and vendor lock-in should be flagged during analysis even if not explicitly asked.

10. **Distinguish conventions from accidents** — Not all patterns are intentional. Some are technical debt, legacy code, or mistakes. Label each appropriately.

11. **Always identify the version control system** — Git, Mercurial, SVN, or none. This affects workflow recommendations downstream.

12. **Output must be actionable** — Every finding should imply a next step. "Uses MongoDB" is less useful than "Uses MongoDB — consider whether the task requires SQL or document-model awareness."

## Verification Checklist

- [ ] Tech stack correctly identified with versions
- [ ] Entry points mapped
- [ ] Module structure documented
- [ ] Key dependencies listed with health status
- [ ] Conventions summarized
- [ ] Architecture pattern named
- [ ] Test structure identified
- [ ] Security signals noted
- [ ] Technical debt indicators collected
- [ ] Analysis report delivered in chosen template

## Failure Handling

- **Config files missing** → Infer from code syntax, imports, and file extensions. Note confidence level.
- **Project too large** → Focus on relevant directories. Use `find` or `glob` to scope.
- **Ambiguous architecture** → Present multiple possible interpretations and ask user to clarify.
- **No README** → Note this as a documentation gap. Proceed with code-based analysis.
- **Corrupted/incomplete repo** → Detect via missing lock files, broken imports. Report and ask user.
