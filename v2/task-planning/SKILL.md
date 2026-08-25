---
name: task-planning
description: >-
  Breaking large projects into small, executable, ordered tasks with clear dependencies and deliverables. Use this skill when the user wants to break down a project, شکستن پروژه, task planning, create a plan, project roadmap, plan this feature, what should I do first, how do I approach this project, steps to build X, implementation plan, project breakdown, work breakdown structure, sprint planning, milestone planning, what's the order of tasks, dependency mapping, chunk this into tasks, I have a big project help me plan, give me a roadmap, phase this project, organize my work, برنامه‌ریزی, مراحل ساخت, قدم به قدم, نقشه راه, چطور شروع کنم, چه کارهایی باید بکنم, ترتیب کارها, وابستگی‌ها, فازبندی پروژه, اسپرینت پلنینگ, تجزیه پروژه, کارهای اولیه چیه, پروژه بزرگ, مدیریت پروژه, تسک بندی, بریک دان پروژه, برنامه ریزی پروژه, لیست کارها, اولویت‌بندی, چه چیزی اول ساخته بشه, از کجا شروع کنم, مراحل اجرایی, پلن اجرایی, ساختار پروژه.
---

# Task Planning Skill — Project Decomposition & Roadmapping

## Overview

This skill turns a vague project idea into a concrete, ordered list of executable tasks. The key principle: every task should be small enough that a developer can complete it in one sitting and verify it works. If a task is too big, it gets broken down further.

## When to Use This Skill

- User describes a project or feature and needs a plan
- User asks to break something down into steps
- User needs a roadmap, milestone plan, or sprint plan
- User says "I want to build X, where do I start?"
- User has a large task and feels overwhelmed or unsure of the order
- User needs dependency mapping between components
- User wants to estimate timeline or effort for a project
- User is transitioning from design to implementation
- User needs to organize a backlog or create a sprint
- User wants to identify parallelizable work streams

## Planning Workflow

### Phase 1: Scope the Project

1. **Identify the goal** — What is the final deliverable? What does "done" look like?
2. **Detect the tech stack** — Read any existing code, config files, or ask the user. This determines what's realistic and what tooling to plan for.
3. **Identify existing assets** — Are there existing files, APIs, designs, or dependencies already in place? Don't plan to build what already exists.
4. **Clarify constraints** — Deadline, team size, budget, deployment target, compliance requirements.
5. **Assess the domain complexity** — Is this a CRUD app, a real-time system, a data pipeline, or an ML system? Each has different task patterns.

### Phase 2: Identify Major Milestones

Break the project into 3-7 milestones. Each milestone should represent a meaningful, demonstrable checkpoint.

Good milestone test: "If I stopped after this milestone, would I have something useful?"

Order milestones by dependency and value delivery. Get something working early rather than building all infrastructure first.

Types of milestones:
- **Foundation** — Project setup, CI/CD, database, auth skeleton
- **Core Feature** — First working end-to-end feature
- **Feature Expansion** — Additional features building on the core
- **Polish** — Error handling, loading states, edge cases
- **Hardening** — Tests, monitoring, performance optimization
- **Launch** — Deployment, documentation, rollback plan

### Phase 3: Decompose Into Tasks

For each milestone, list the specific tasks. Follow these rules:

| Rule | Guideline |
|------|------------|
| **Size** | Each task = 1-4 hours of focused work |
| **Verifiability** | You must be able to tell when a task is done (test passes, page renders, API responds) |
| **Independence** | Minimize dependencies between tasks within the same milestone |
| **Naming** | Use verb-noun format: "Create user model", "Add login endpoint", "Write unit tests for cart" |
| **Specificity** | Include the file, library, or technology name where relevant |

If a task can't be done in one sitting, split it:
- Bad: "Build the entire authentication system"
- Good: "Create User model with email/password fields"
- Good: "Add JWT token generation utility"
- Good: "Implement login POST endpoint with validation"
- Good: "Add auth middleware for protected routes"

### Phase 4: Order and Dependency Map

1. **Within each milestone**, order tasks by dependency (what must be built first)
2. **Flag blocking dependencies** — if Task C is blocked by Task A from a previous milestone, note it
3. **Identify parallelizable work** — which tasks can be done simultaneously by different people?
4. **Mark the critical path** — the chain of tasks that determines the minimum project duration

### Phase 5: Risk & Unknowns

For each milestone, flag:
- **Technical unknowns** — "We haven't used this library before" or "API spec is not finalized"
- **Integration risks** — "Depends on third-party service signup"
- **Scope risks** — "Requirements might change based on user testing"
- **External dependencies** — "Waiting on designer to deliver Figma mockups"

### Phase 6: Effort Estimation

Use a consistent estimation approach:
- **Story points or T-shirt sizes** for rough planning (S/M/L/XL)
- **Hour ranges** for detailed sprint planning (2-4h, 4-8h, 8-16h)
- Always include a buffer: actual effort = estimate × 1.3 (for unknown unknowns)

## Advanced Techniques

### 1. Vertical Slice Planning

Instead of building all backend, then all frontend, then all tests — build one complete vertical slice from UI to database for the most important feature. This validates the architecture early and delivers value fast.

```
Horizontal (slow value delivery):
  M1: All models → M2: All APIs → M3: All UI → M4: All tests

Vertical Slice (fast value delivery):
  M1: Complete user registration (model + API + UI + tests)
  M2: Complete login flow (model + API + UI + tests)
  M3: Complete dashboard (model + API + UI + tests)
```

### 2. Walking Skeleton Approach

Identify the absolute minimum infrastructure needed to deploy end-to-end, then build that first. Every subsequent feature plugs into the skeleton.

```
Task 1: Set up Next.js project with TypeScript and Tailwind
Task 2: Add Prisma with PostgreSQL connection
Task 3: Create a single API route that reads from DB
Task 4: Create a single page that renders the API data
Task 5: Deploy to Vercel with environment variables
→ Now you have a deployed, working skeleton. Everything else builds on this.
```

### 3. Risk-First Ordering

Instead of ordering by feature importance, order by risk. Tackle the riskiest technical unknown first. If it fails, you find out early. If it succeeds, everything else is easier.

```
Standard order: Auth → Users → Posts → Comments → Search
Risk-first order: Search (unknown tech) → Auth → Users → Posts → Comments
```

### 4. Strangler Fig Pattern for Migrations

When adding features to an existing system, plan the migration as incremental strangulation rather than a big bang rewrite.

```
Task 1: Add new endpoint alongside old one (both active)
Task 2: Route 10% of traffic to new endpoint (canary)
Task 3: Monitor metrics, fix issues
Task 4: Route 50% traffic
Task 5: Route 100% traffic
Task 6: Remove old endpoint
```

### 5. Test-Driven Task Sequencing

Plan tasks in test-first order: write the test that describes the behavior, then implement the minimum code to pass it.

```
Task 1: Write failing test for user registration validation
Task 2: Implement validation logic to pass the test
Task 3: Write failing test for duplicate email rejection
Task 4: Implement unique constraint handling
Task 5: Write integration test for full registration flow
Task 6: Wire up the endpoint and middleware
```

### 6. Dependency Graph Visualization

For complex projects, represent the task dependencies as a graph to identify parallel opportunities and bottlenecks.

```
  [1.1 Setup DB] ──→ [1.3 Create Models]
       │                    │
       └──→ [1.2 Setup Auth] ┘
                             │
                    ┌───────┴───────┐
               [2.1 User API]  [2.2 Admin API]   ← can be parallel
                    │               │
                    └───────┬───────┘
                            │
                    [3.1 Frontend Shell]
```

### 7. MoSCoW Priority Tagging

Tag every task with a MoSCoW priority to help the user decide what to cut if time runs short.

- **MUST** — The project doesn't work without this
- **SHOULD** — Important but can launch without
- **COULD** — Nice to have, adds polish
- **WON'T** — Explicitly out of scope for this iteration

## Common Patterns

### Pattern 1: SaaS Application Build

```markdown
### Milestone 1: Foundation (Week 1)
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 1.1 | Initialize Next.js project with TypeScript + Tailwind | — | MUST | 1h |
| 1.2 | Set up Prisma with PostgreSQL in Docker | 1.1 | MUST | 2h |
| 1.3 | Create User, Session, Organization models | 1.2 | MUST | 2h |
| 1.4 | Implement JWT auth with refresh tokens | 1.3 | MUST | 4h |
| 1.5 | Set up CI/CD with GitHub Actions | 1.1 | SHOULD | 2h |
| 1.6 | Add ESLint + Prettier + Husky pre-commit | 1.1 | SHOULD | 1h |

### Milestone 2: Core Feature — Onboarding (Week 2)
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 2.1 | Build registration API (email + password) | 1.4 | MUST | 3h |
| 2.2 | Build login API with session management | 2.1 | MUST | 2h |
| 2.3 | Create registration form with validation | 2.1 | MUST | 3h |
| 2.4 | Create login form with error states | 2.2 | MUST | 2h |
| 2.5 | Add email verification flow | 2.1 | SHOULD | 3h |
| 2.6 | Write integration tests for auth flow | 2.1-2.4 | MUST | 3h |
```

### Pattern 2: API-First Service

```markdown
### Milestone 1: Project Skeleton
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 1.1 | Scaffold FastAPI project with Poetry | — | MUST | 1h |
| 1.2 | Set up Alembic migrations | 1.1 | MUST | 1h |
| 1.3 | Configure Pydantic models for request/response | 1.1 | MUST | 2h |
| 1.4 | Add CORS, rate limiting middleware | 1.1 | MUST | 1h |
| 1.5 | Create health check endpoint | 1.1 | MUST | 0.5h |
| 1.6 | Write OpenAPI spec for first resource | 1.3 | SHOULD | 2h |
```

### Pattern 3: Database Migration Project

```markdown
### Milestone 1: Assessment
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 1.1 | Inventory all tables, views, and stored procedures | — | MUST | 4h |
| 1.2 | Map data types from source to target DB | 1.1 | MUST | 3h |
| 1.3 | Identify incompatible features (e.g., MySQL enums → PG) | 1.2 | MUST | 2h |
| 1.4 | Estimate data volume and plan migration window | 1.1 | MUST | 1h |

### Milestone 2: Schema Migration
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 2.1 | Generate new schema DDL in target DB | 1.2 | MUST | 3h |
| 2.2 | Write data migration scripts with validation | 2.1 | MUST | 6h |
| 2.3 | Test migration on a copy of production data | 2.2 | MUST | 4h |
| 2.4 | Write rollback script | 2.2 | MUST | 2h |
```

### Pattern 4: Feature Addition to Existing Codebase

```markdown
### Milestone 1: Understand & Prepare
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 1.1 | Read existing codebase structure and patterns | — | MUST | 2h |
| 1.2 | Identify files that need modification | 1.1 | MUST | 1h |
| 1.3 | Verify no existing partial implementation | 1.1 | MUST | 0.5h |
| 1.4 | Create a feature branch from main | — | MUST | 0.1h |

### Milestone 2: Implement
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 2.1 | Add new database table/columns via migration | 1.4 | MUST | 1h |
| 2.2 | Implement backend logic (service + controller) | 2.1 | MUST | 4h |
| 2.3 | Add API endpoints for the feature | 2.2 | MUST | 2h |
| 2.4 | Build UI components for the feature | 2.3 | MUST | 3h |
| 2.5 | Add unit and integration tests | 2.2, 2.4 | MUST | 3h |
| 2.6 | Update documentation and API docs | 2.5 | SHOULD | 1h |
```

### Pattern 5: Performance Optimization Sprint

```markdown
### Milestone 1: Measure & Identify
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 1.1 | Set up APM or profiling tool | — | MUST | 2h |
| 1.2 | Capture baseline metrics (p95 latency, throughput) | 1.1 | MUST | 1h |
| 1.3 | Identify top 5 slowest endpoints/queries | 1.1 | MUST | 3h |
| 1.4 | Analyze query execution plans for slow queries | 1.3 | MUST | 2h |

### Milestone 2: Optimize
| # | Task | Depends On | Priority | Estimate |
|---|------|-----------|----------|----------|
| 2.1 | Add missing indexes identified in Phase 1 | 1.4 | MUST | 1h |
| 2.2 | Implement caching for hot paths | 1.3 | MUST | 3h |
| 2.3 | Optimize N+1 queries with eager loading | 1.4 | MUST | 2h |
| 2.4 | Add pagination to list endpoints | 1.3 | MUST | 2h |
| 2.5 | Re-measure and compare against baseline | 2.1-2.4 | MUST | 1h |
```

## Edge Cases & Pitfalls

1. **Planning without reading existing code** — Creating a plan that duplicates work already done. Always read the codebase first.

2. **Tasks too large to verify** — "Implement the payment system" can't be verified in one sitting. Break it into testable units.

3. **Missing infrastructure tasks** — Forgetting Docker setup, environment variables, CI/CD, SSL certificates, DNS configuration.

4. **No testing tasks** — Tests are not "extra work," they are part of the implementation. Plan them explicitly.

5. **Linear dependency chains** — If every task depends on the previous one, there's no parallelism. Look for opportunities to split work streams.

6. **Ignoring deployment** — A feature is not done until it's deployed. Include deployment and monitoring tasks.

7. **Vague task names** — "Set up database" is unclear. "Create PostgreSQL database in Docker with utf8 encoding" is actionable.

8. **Planning too far ahead** — A 6-month plan will be wrong. Plan the next 2-4 weeks in detail, the rest at milestone level.

9. **Forgetting rollback tasks** — Every deployment task should have a corresponding rollback task.

10. **No acceptance criteria** — Each task should have a clear "done" condition. Without it, tasks linger.

11. **Ignoring the learning curve** — If the team hasn't used a technology before, add explicit learning/research tasks.

12. **Not accounting for review time** — Code reviews, design reviews, and QA take real time. Include them.

13. **Single point of failure in the plan** — If one person owns the critical path and they get sick, the project stalls. Identify and mitigate.

14. **Feature-level tasks instead of task-level** — "Build search" is a feature. "Add PostgreSQL full-text search index" and "Implement search API with filters" are tasks.

15. **No buffer for unknowns** — Technical projects always have surprises. Add 20-30% buffer to estimates.

16. **Forgetting cross-cutting tasks** — Error handling, logging, input validation, and security headers apply to every feature but are easy to forget.

## Integration with Other Skills

| Skill | When to Chain | How It Connects |
|-------|---------------|-----------------|
| **brainstorming** | Before planning | Evaluate different approaches before committing to a task sequence |
| **system-design** | Before planning for new systems | Use the architecture as the basis for task breakdown |
| **database-schema** | When tasks involve data modeling | Generate concrete schemas as part of the plan |
| **fullstack-dev** | After planning | Execute the plan by implementing each task |
| **charts** | For visual roadmaps | Create Gantt charts or dependency diagrams |

## Output Format Templates

### Template 1: Standard Milestone Plan

```markdown
## Project Plan: [Project Name]

**Goal:** [one-line description of the final deliverable]
**Tech Stack:** [detected or stated stack]
**Estimated Total Tasks:** [number]

---

### Milestone 1: [Name] — [brief description]
**Deliverable:** [what the user has after this milestone]

| # | Task | Depends On | Priority | Status |
|---|------|-----------|----------|--------|
| 1.1 | [Task description] | — | MUST | ⬜ pending |
| 1.2 | [Task description] | 1.1 | MUST | ⬜ pending |
| 1.3 | [Task description] | — | SHOULD | ⬜ pending |

**Risks:** [any unknowns or blockers]
**Parallel opportunities:** [which tasks can run simultaneously]

---

### Milestone 2: [Name]
...

---

### Summary
- **Milestones:** [count]
- **Total tasks:** [count]
- **MUST tasks:** [count]
- **Critical path:** [which tasks chain determines the minimum timeline]
- **Parallel opportunities:** [which tasks can be done simultaneously]
- **Estimated effort:** [total hours/days]
- **Biggest risk:** [the one thing most likely to derail the plan]
```

### Template 2: Quick Sprint Plan

```markdown
## Sprint Plan: [Sprint Name/Number]
**Duration:** [e.g., 2 weeks]
**Goal:** [sprint goal statement]

| # | Task | Owner | Estimate | Status |
|---|------|-------|----------|--------|
| 1 | [task] | [name] | [2h] | ⬜ |
| 2 | [task] | [name] | [4h] | 🔄 in progress |
| 3 | [task] | [name] | [1h] | ✅ done |

**Carry-over:** [tasks from last sprint]
**Blocked by:** [external dependencies]
```

### Template 3: Checklist-Style Plan

```markdown
## Build Checklist: [Project Name]

### Phase 1: Setup
- [ ] Initialize project with [framework]
- [ ] Configure TypeScript/ESLint/Prettier
- [ ] Set up version control (.gitignore, branch strategy)
- [ ] Create Docker Compose for local development
- [ ] Set up environment variables (.env.example)

### Phase 2: Core
- [ ] Implement [feature A] end-to-end
- [ ] Implement [feature B] end-to-end
- [ ] Add error handling and validation

### Phase 3: Ship
- [ ] Set up CI/CD pipeline
- [ ] Configure production environment
- [ ] Deploy and smoke test
- [ ] Set up monitoring and alerts
```

### Template 4: Dependency Graph + Task List

```markdown
## Project Plan: [Name]

### Dependency Graph
```
[1.1] → [1.2] → [1.3] ──┬──→ [2.1] → [2.3]
                            └──→ [2.2] → [2.4]
[1.4] ──────────────────→ [2.1]
```

### Critical Path
[1.1] → [1.2] → [1.3] → [2.1] → [2.3] → [3.1] = 5 tasks (longest chain)

### Full Task List
| ID | Task | Depends On | On Critical Path | Parallelizable With |
|----|------|-----------|------------------|---------------------|
| 1.1 | ... | — | ✅ | — |
| 1.2 | ... | 1.1 | ✅ | 1.4 |
| 1.3 | ... | 1.2 | ✅ | 1.4, 1.5 |
| 1.4 | ... | — | ❌ | 1.2, 1.3 |
```

## Rules

- **Read existing code first** before planning — don't plan to recreate what's already there
- **Be specific** — "Set up PostgreSQL with Docker Compose" not "set up database"
- **Include setup and config tasks** — environment variables, Docker, CI/CD, linting, etc. are real work
- **Don't skip testing tasks** — plan for tests as first-class tasks, not afterthoughts
- **Order by value** — get a working end-to-end skeleton early, then fill in features
- **Keep it realistic** — don't plan 50 tasks for a weekend project
- **Every task must be verifiable** — if you can't tell when it's done, it's too vague
- **Use verb-noun naming** — "Create X", "Add Y", "Configure Z"
- **Include buffer** — add 20-30% to estimates for unknowns
- **Tag with priority** — use MoSCoW to help the user cut scope if needed
- **Identify the critical path** — the user needs to know which tasks determine the timeline
- **Plan for deployment** — a feature isn't done until it's deployed and monitored
