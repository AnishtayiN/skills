---
name: task-planning
description: >-
  Breaking large projects into small, executable, ordered tasks with clear dependencies and deliverables. Use this skill when the user wants to break down a project, شکستن پروژه, task planning, create a plan, project roadmap, plan this feature, what should I do first, how do I approach this project, steps to build X, implementation plan, project breakdown, work breakdown structure, sprint planning, milestone planning, what's the order of tasks, dependency mapping, chunk this into tasks, I have a big project help me plan, give me a roadmap, phase this project, organize my work, estimation, planning poker, t-shirt sizing, risk assessment, resource allocation, buffer planning, Gantt chart, critical path, contingency planning, or dependency graph.
---

# Task Planning Skill — Project Decomposition & Roadmapping

## Overview

This skill turns a vague project idea into a concrete, ordered list of executable tasks. The key principle: **every task should be small enough that a developer can complete it in one sitting and verify it works**. If a task is too big, it gets broken down further. This skill covers decomposition, estimation, risk assessment, dependency mapping, sprint planning, and project-type-specific templates.

## When to Use This Skill

- User describes a project or feature and needs a plan
- User asks to break something down into steps
- User needs a roadmap, milestone plan, or sprint plan
- User says "I want to build X, where do I start?"
- User has a large task and feels overwhelmed or unsure of the order
- User needs estimation help or risk assessment for a project
- User asks about resource allocation or capacity planning

---

## Planning Workflow

### Phase 1: Scope the Project

1. **Identify the goal** — What is the final deliverable? What does "done" look like?
2. **Detect the tech stack** — Read any existing code, config files, or ask the user. This determines what's realistic and what tooling to plan for.
3. **Identify existing assets** — Are there existing files, APIs, designs, or dependencies already in place? Don't plan to build what already exists.
4. **Clarify constraints** — Deadline, team size, budget, deployment target, compliance requirements.
5. **Define done criteria** — For each deliverable, what does "shipped" mean? (Tests pass? Docs written? Deployed to production?)

### Phase 2: Identify Major Milestones

Break the project into 3-7 milestones. Each milestone should represent a meaningful, demonstrable checkpoint.

Good milestone test: "If I stopped after this milestone, would I have something useful?"

Order milestones by dependency and value delivery. Get something working early rather than building all infrastructure first.

### Phase 3: Decompose Into Tasks

For each milestone, list the specific tasks. Follow these rules:

| Rule | Guideline |
|------|-----------|
| **Size** | Each task = 1-4 hours of focused work |
| **Verifiability** | You must be able to tell when a task is done (test passes, page renders, API responds) |
| **Independence** | Minimize dependencies between tasks within the same milestone |
| **Naming** | Use verb-noun format: "Create user model", "Add login endpoint", "Write unit tests for cart" |

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

### Phase 5: Risk & Unknowns

For each milestone, flag:
- **Technical unknowns** — "We haven't used this library before" or "API spec is not finalized"
- **Integration risks** — "Depends on third-party service signup"
- **Scope risks** — "Requirements might change based on user testing"
- **External dependencies** — "Waiting on design team for UI mockups"

---

## Estimation Techniques

### Technique 1: T-Shirt Sizing

Quick, rough estimation for initial planning. Use when you need speed over precision.

| Size | Description | Typical Range |
|------|-------------|---------------|
| **XS** | Trivial, can do without thinking | 15-30 minutes |
| **S** | Small, well-understood task | 30 min - 2 hours |
| **M** | Medium, may have some complexity | 2-6 hours |
| **L** | Large, needs decomposition | 6-16 hours (split into sub-tasks) |
| **XL** | Too large, must be broken down | 16+ hours (MUST decompose) |

**When to use:** Initial project scoping, backlog grooming, quick triage.

### Technique 2: Three-Point Estimation

More precise. Use for tasks where uncertainty is significant.

```
For each task, estimate:
- Optimistic (O): Best case if everything goes right
- Most Likely (M): Realistic estimate
- Pessimistic (P): Worst case if things go wrong

Expected Duration = (O + 4M + P) / 6
Standard Deviation = (P - O) / 6
```

**Example:**
```
Task: Implement OAuth2 login flow
- Optimistic: 3 hours (library does most of the work)
- Most Likely: 6 hours (need to handle edge cases)
- Pessimistic: 14 hours (OAuth provider has bad docs, need custom work)

Expected = (3 + 4×6 + 14) / 6 = 41/6 ≈ 6.8 hours
Std Dev = (14 - 3) / 6 ≈ 1.8 hours

So estimate: ~7 hours, range 5-9 hours (within 1 std dev)
```

**When to use:** Sprint planning, when stakeholders need confidence intervals, when tasks have significant uncertainty.

### Technique 3: Planning Poker (Team Estimation)

Consensus-based estimation technique for team planning:

1. Each team member independently estimates a task (using T-shirt sizes, Fibonacci numbers, or three-point)
2. All estimates revealed simultaneously
3. If estimates differ significantly (e.g., 3 vs 8), discuss why
4. Re-estimate after discussion
5. Repeat until consensus (or within acceptable range)

**When to use:** Team sprint planning, when estimates need team buy-in, when different team members have different perspectives on complexity.

### Technique 4: Reference-Based Estimation

Compare to a known completed task:

```
"Task X is similar to Task Y we completed last sprint.
Task Y took 4 hours. Task X has 2 additional edge cases.
Estimate: 4 + 2 = 6 hours."
```

**When to use:** When you have a history of completed similar tasks. More accurate than pure guessing.

---

## Dependency Graph Visualization

### ASCII Dependency Map

```
## Dependency Graph

Task 1.1 ──────→ Task 1.2 ──────→ Task 1.3
                                 ↗
Task 1.4 ──────→ Task 1.5 ──────→ Task 2.1 ──────→ Task 2.2
                                          ↑
Task 1.6 ──────→ Task 1.7 ─────────────────┘

Legend: ──────→ = blocks / is prerequisite for
        ↗       = merges from multiple paths
```

### Critical Path Identification

The **critical path** is the longest sequence of dependent tasks — it determines the minimum project duration. Any delay on the critical path delays the entire project.

```
## Critical Path Analysis

Path A: 1.1 → 1.2 → 1.3 → 2.1 → 2.2 = 18 hours
Path B: 1.4 → 1.5 → 2.1 → 2.2 = 14 hours
Path C: 1.6 → 1.7 → 2.1 → 2.2 = 12 hours

Critical Path: Path A (18 hours)
Float (Path B): 4 hours
Float (Path C): 6 hours

→ Tasks 1.1, 1.2, 1.3, 2.1, 2.2 are on the critical path.
  Any delay to these tasks delays the entire project.
  Focus resources here first.
```

### Parallel Execution Map

```
## Parallel Execution Opportunities

Week 1 (parallel track):
├─ Developer A: Task 1.1 → Task 1.2 → Task 1.3
├─ Developer B: Task 1.4 → Task 1.5 → Task 1.6
└─ Developer C: Task 1.7 → Task 1.8 (independent)

Week 2 (merge point):
├─ All developers: Task 2.1 (integration task)
└─ Then: Task 2.2 → Task 2.3 → Task 2.4
```

---

## Risk Assessment Framework

### Risk Matrix

For each identified risk, assess probability and impact:

```
## Risk Register

| # | Risk | Probability | Impact | Score | Mitigation |
|---|------|-------------|--------|-------|------------|
| R1 | Third-party API changes before launch | Medium (3) | High (4) | 12 | Pin API version, write adapter layer |
| R2 | Database schema migration fails | Low (2) | Critical (5) | 10 | Test migration on staging first, keep rollback script |
| R3 | Team member unavailable for 1 week | Medium (3) | Medium (3) | 9 | Document all tasks, cross-train on critical paths |
| R4 | Requirements change mid-sprint | High (4) | Medium (3) | 12 | Use feature flags, keep changes behind toggle |
| R5 | Performance doesn't meet target | Medium (3) | High (4) | 12 | Profile early, set performance budgets |

Probability scale: 1 (Rare) - 5 (Almost certain)
Impact scale: 1 (Negligible) - 5 (Critical)
Score = Probability × Impact
```

### Risk Categories

| Category | Examples | Questions to Ask |
|----------|----------|-----------------|
| **Technical** | New technology, unproven architecture | Has this been done before? By us? By anyone? |
| **Resource** | Key person leaves, budget cut | What's the bus factor? What if we lose 50% budget? |
| **Schedule** | Dependencies delayed, scope creep | What's the buffer? What can slip without breaking the deadline? |
| **Requirements** | Unclear specs, stakeholder disagreement | Are requirements locked? Who has final say? |
| **Integration** | Third-party APIs, vendor lock-in | What if the vendor goes down? Changes pricing? |
| **External** | Regulatory changes, market shifts | What if the rules change? What if a competitor ships first? |

---

## Sprint Planning Patterns

### Sprint Setup

```
## Sprint [Number] — [Date Range]

**Sprint Goal:** [One sentence — what will be achieved]
**Team Capacity:** [hours available] = [team size] × [hours/person] - [holidays/meetings]
**Velocity (historical):** [story points from last sprint]

### Committed Stories

| Story | Points | Assignee | Depends On | Status |
|-------|--------|----------|------------|--------|
| User login with email | 5 | Alice | — | ⬜ |
| Password reset flow | 3 | Bob | User login | ⬜ |
| Profile page | 5 | Carol | — | ⬜ |
| Admin dashboard | 8 | Alice + Bob | User login | ⬜ |

**Total committed:** 21 points (within velocity capacity)

### Buffer Tasks (if capacity allows)
| Story | Points | Assignee | Status |
|-------|--------|----------|--------|
| Dark mode toggle | 2 | Carol | ⬜ Optional |

### Sprint Risks
- Admin dashboard depends on User login (sequential, not parallel)
- Carol's Profile page is independent — good candidate for early completion
```

### Sprint Planning Checklist

- [ ] Sprint goal is clear and measurable
- [ ] Stories are estimated (points or hours)
- [ ] Total doesn't exceed team capacity
- [ ] Dependencies are identified and ordered
- [ ] Each story has acceptance criteria
- [ ] Buffer is allocated (10-20% for unplanned work)
- [ ] Risks are documented with mitigations

---

## Project Type Templates

### Web Application Template

```
## Web App Project Plan

### Milestone 1: Project Foundation
- Initialize project repository
- Set up development environment (Node.js/Python/etc.)
- Configure linting, formatting (ESLint, Prettier)
- Set up CI/CD pipeline (GitHub Actions/GitLab CI)
- Configure database (PostgreSQL/MongoDB) with Docker
- Set up environment variable management (.env)
- Create basic project structure (folders, entry points)

### Milestone 2: Backend Core
- Define database schema / ORM models
- Implement authentication system (JWT/OAuth2)
- Create core API endpoints (CRUD for main entity)
- Add input validation and error handling
- Write API integration tests
- Set up rate limiting and security headers

### Milestone 3: Frontend Core
- Set up frontend framework (React/Vue/Svelte)
- Create routing structure
- Build authentication pages (login, register, forgot password)
- Create main dashboard/layout component
- Implement API client layer
- Add loading states, error boundaries

### Milestone 4: Feature Development
- [Feature A] — [specific tasks]
- [Feature B] — [specific tasks]
- [Feature C] — [specific tasks]
- Write unit tests for each feature

### Milestone 5: Polish & Deployment
- Responsive design / mobile optimization
- Performance optimization (lazy loading, code splitting)
- Accessibility audit (WCAG 2.1)
- Security audit (OWASP top 10)
- Deploy to staging, QA
- Deploy to production
- Set up monitoring and alerting
```

### Mobile App Template

```
## Mobile App Project Plan

### Milestone 1: Project Setup
- Initialize React Native / Flutter project
- Configure build tools (Xcode, Android Studio)
- Set up code signing and provisioning profiles
- Configure CI/CD (Fastlane, EAS Build)
- Set up crash reporting (Sentry/Crashlytics)
- Set up analytics

### Milestone 2: Core Navigation & Auth
- Set up navigation framework (React Navigation / Flutter Routes)
- Build onboarding flow
- Implement authentication (login, register, biometric)
- Create main tab/drawer navigation
- Handle deep linking

### Milestone 3: Main Features
- [Feature A] with offline support
- [Feature B] with push notifications
- [Feature C] with camera/location integration
- State management setup (Redux/Zustand/Bloc)
- API integration layer with retry logic

### Milestone 4: Platform Polish
- iOS-specific adjustments (SafeArea, haptics)
- Android-specific adjustments (back button, permissions)
- Performance profiling and optimization
- App store assets (screenshots, descriptions)
- Submit to TestFlight / Internal Testing
- Submit to App Store / Play Store
```

### API / Backend Service Template

```
## API/Backend Service Plan

### Milestone 1: Foundation
- Initialize project (Express/FastAPI/Spring Boot)
- Set up database and migrations
- Configure dependency injection
- Set up logging (structured JSON)
- Create health check endpoint
- Set up Docker + docker-compose

### Milestone 2: Core API
- Define API contract (OpenAPI/Swagger)
- Implement authentication middleware
- Create CRUD endpoints for primary resources
- Add pagination, filtering, sorting
- Implement error handling and response format
- Write integration tests

### Milestone 3: Business Logic
- Implement core business rules
- Add background job processing (queues)
- Set up caching layer (Redis)
- Implement rate limiting
- Add request validation

### Milestone 4: Operations
- Set up monitoring (Prometheus/Grafana)
- Configure alerting rules
- Set up log aggregation
- Create runbook for common operations
- Load testing and performance baseline
- Security hardening
```

### Data Pipeline Template

```
## Data Pipeline Project Plan

### Milestone 1: Infrastructure
- Set up data processing environment (Airflow/Prefect/dbt)
- Configure source database connections
- Set up data warehouse / lake
- Create schema for staging and analytics layers
- Set up data quality monitoring

### Milestone 2: Ingestion
- Build extraction scripts for each data source
- Implement incremental loading logic
- Add error handling and retry logic
- Create data freshness monitoring
- Write tests for extraction logic

### Milestone 3: Transformation
- Build staging layer transformations
- Build analytics layer transformations
- Implement data quality checks (dbt tests)
- Create dimension and fact tables
- Document data lineage

### Milestone 4: Serving
- Create materialized views / tables for consumers
- Set up data access layer (API or direct query)
- Build dashboards / reports
- Implement alerting for data anomalies
- Create data catalog / documentation
```

---

## Resource Allocation Patterns

### Solo Developer Pattern

```
## Solo Developer Allocation

All tasks sequential (no parallelism possible).

Priority order:
1. Foundation tasks (unblock everything else)
2. Critical path tasks (longest dependency chain)
3. High-risk tasks (validate unknowns early)
4. Feature tasks (in priority order)
5. Polish tasks (only if time permits)

Time allocation per day:
- 70% development
- 15% testing and debugging
- 10% documentation
- 5% code review / planning
```

### Small Team (2-4 People) Pattern

```
## Small Team Allocation

Assign by expertise and preference:
- Backend specialist → API, database, infrastructure
- Frontend specialist → UI components, client logic
- Full-stack generalist → Integration, features that span both
- DevOps/Platform → CI/CD, deployment, monitoring

Parallel work rules:
- Different files = can work simultaneously
- Same file = must serialize (use feature branches)
- Shared module = coordinate before changing

Daily sync: 15-minute standup to catch conflicts early
```

### Large Team (5+ People) Pattern

```
## Large Team Allocation

Structure by feature teams:
- Team A: [Feature area 1]
- Team B: [Feature area 2]
- Platform Team: Shared infrastructure, CI/CD, tooling

Coordination mechanisms:
- Weekly cross-team sync
- Shared API contracts (OpenAPI specs)
- Feature flags for independent deployment
- Code review across team boundaries

Task assignment:
- Break features into tasks that fit within one team
- Minimize cross-team dependencies
- Platform team unblocks feature teams
- Shared components owned by one team (not "everyone")
```

---

## Buffer & Contingency Planning

### Buffer Calculation

```
## Buffer Strategy

Base estimate: [sum of all task estimates]

Buffer types:
1. **Task-level buffer:** 10-20% added to each uncertain task
   - Well-understood task: +10%
   - Somewhat uncertain: +20%
   - Unknown territory: +50% or decompose further

2. **Project-level buffer:** 20-30% of total estimated time
   - Short project (< 2 weeks): 30%
   - Medium project (2-8 weeks): 25%
   - Long project (8+ weeks): 20%

3. **Management reserve:** 10% for unknown unknowns
   - Held at project level, not task level
   - Released by project manager only for true surprises
```

### Contingency Plan Template

```
## Contingency Plans

### Risk: Key developer leaves mid-project
- **Trigger:** [developer name] unavailable for > 3 days
- **Contingency:** [other developer] takes over critical path tasks
- **Mitigation:** All critical tasks have at least 1 other person who understands them
- **Impact:** May delay timeline by [X days]

### Risk: Third-party service fails or changes
- **Trigger:** [service] becomes unavailable or changes API
- **Contingency:** Switch to [alternative service] or implement caching layer
- **Mitigation:** Abstracted service layer with adapter pattern
- **Impact:** [X days] to implement alternative

### Risk: Scope creep
- **Trigger:** New requirements added after sprint start
- **Contingency:** New requirements go to backlog for next sprint
- **Mitigation:** Feature flags — incomplete features hidden in production
- **Impact:** Minimal if enforced; catastrophic if not

### Risk: Technical blocker
- **Trigger:** Task blocked for > 1 day
- **Contingency:** Pair programming session, escalate to tech lead, or research spike
- **Mitigation:** Time-box research spikes to 2 hours before escalating
- **Impact:** [X hours] per blocker event
```

---

## Output Format

```markdown
## Project Plan: [Project Name]

**Goal:** [one-line description of the final deliverable]
**Tech Stack:** [detected or stated stack]
**Estimated Total Tasks:** [number]
**Estimated Timeline:** [rough duration]
**Team:** [solo / team size]

---

### Milestone 1: [Name] — [brief description]
**Deliverable:** [what the user has after this milestone]
**Estimate:** [hours/days]

| # | Task | Depends On | Size | Status |
|---|------|------------|------|--------|
| 1.1 | [Task description] | — | S | ⬜ pending |
| 1.2 | [Task description] | 1.1 | M | ⬜ pending |
| 1.3 | [Task description] | — | S | ⬜ pending |

**Risks:** [any unknowns or blockers]

---

### Milestone 2: [Name]
...

---

### Dependency Graph
[ASCII or text-based dependency visualization]

### Critical Path
[Which tasks chain determines the minimum timeline]

### Risk Register
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|

### Contingency Plans
[Top 3 risks with contingency actions]

### Summary
- **Milestones:** [count]
- **Total tasks:** [count]
- **Critical path:** [which tasks chain determines the minimum timeline]
- **Parallel opportunities:** [which tasks can be done simultaneously]
- **Estimated total effort:** [hours/days with buffer]
- **Biggest risk:** [one-liner]
- **First task to start:** [exact task number and name]
```

---

## Rules

- **Read existing code first** before planning — don't plan to recreate what's already there
- **Be specific** — "Set up PostgreSQL with Docker Compose" not "set up database"
- **Include setup and config tasks** — environment variables, Docker, CI/CD, linting, etc. are real work
- **Don't skip testing tasks** — plan for tests as first-class tasks, not afterthoughts
- **Order by value** — get a working end-to-end skeleton early, then fill in features
- **Keep it realistic** — don't plan 50 tasks for a weekend project
- **Always include a buffer** — things always take longer than expected
- **Identify the critical path** — know which tasks cannot slip without delaying everything
- **Plan for the unknown** — flag technical unknowns early and create spike tasks to investigate
- **Make tasks verifiable** — if you can't tell when a task is done, it's not specific enough
- **Estimate honestly** — add buffer for uncertainty, not optimism
- **Document assumptions** — if you assumed something, write it down so it can be challenged
