---
name: task-planning
description: >-
  Plan work by breaking complex tasks into ordered, verifiable steps with clear dependencies.
  TRIGGERS: plan, how to approach, break down, steps, roadmap, task list, work plan, what order,
  decomposition, implementation plan, development plan, parallel tasks, sequential tasks,
  برنامه, چطور شروع کنم, قدم‌ها, مراحل, لیست کارها, شکستن کار, ترتیب اجرا
  任务规划, 工作分解, 实施计划, 步骤, 路线图, 依赖关系, 任务列表
priority: P1
dependencies: [project-analysis, requirement-analysis]
conflicts: []
---

# Task Planning Skill

## Overview

Break complex tasks into ordered, verifiable, dependency-aware implementation steps. Prevents random coding and ensures systematic progress. Integrates multiple planning methodologies: MoSCoW prioritization, Critical Path Method (CPM), Walking Skeleton approach, and Risk-First ordering. Produces structured implementation plans with rollback strategies and verification points for each step.

## When to Use This Skill

- Task has multiple steps or affects multiple files/modules
- User asks "how should I approach this?"
- Before starting any non-trivial implementation
- When unsure about implementation order
- Task involves multiple components with dependencies
- Multiple team members may work on different parts
- Risk assessment is needed before committing to a plan

## When NOT to Use This Skill

- Single-line fix with clear instructions
- User provides exact step-by-step implementation
- Trivial tasks (< 3 steps, zero risk)
- Emergency hotfix where speed is critical

## Workflow (Detailed Multi-Phase)

### Phase 1: Decomposition (Work Breakdown Structure)

```
1. Define the END STATE
   → What does "done" look like concretely?
   → What is the acceptance criteria from requirement-analysis?
   → What verification will confirm completion?

2. Work BACKWARDS from end state
   → What must exist immediately before completion?
   → What must exist before that?
   → Continue until reaching atomic, independently verifiable steps

3. Apply Walking Skeleton approach
   → Identify the thinnest end-to-end vertical slice
   → This slice proves the architecture works
   → Build the skeleton FIRST, then flesh out

4. Break into atomic steps
   → Each step must be independently verifiable
   → Each step should be completable in one focused work session
   → Each step must produce a testable artifact
```

### Phase 2: Dependency Mapping

```
1. Map step dependencies
   → Which steps BLOCK other steps?
   → Which steps can run IN PARALLEL?
   → Are there shared resources that create implicit dependencies?

2. Identify the Critical Path
   → Longest chain of dependent steps
   → Determines minimum project duration
   → Steps on the critical path get priority attention

3. Detect circular dependencies
   → If A depends on B and B depends on A → restructure
   → Break cycles by extracting shared code or redefining boundaries
```

### Phase 3: Prioritization (MoSCoW Method)

```
Classify each step using MoSCoW:
  MUST    — Critical for this release. Without it, the feature is broken.
  SHOULD  — Important but not critical. Can work around it temporarily.
  COULD   — Nice to have. Improves quality but not essential.
  WON'T   — Deferred to a future iteration. Documented but not implemented now.

Constraints:
  - No more than 60% of effort on MUST items
  - SHOULD items fill the remaining capacity
  - COULD items are only if time permits
  - WON'T items are explicitly deferred with justification
```

### Phase 4: Risk Assessment & Ordering

```
For each step, assess:

1. Risk Level (Risk-First approach)
   → HIGH risk: uncertain outcome, complex integration, new technology
   → MEDIUM risk: known pattern but untested in this context
   → LOW risk: straightforward, well-understood, isolated change

2. Risk-First Ordering
   → Tackle HIGH-risk items EARLY
   → This validates feasibility before investing in low-risk work
   → If a high-risk step fails, minimal effort is wasted
   → Exception: Walking Skeleton (build thin slice first regardless of risk)

3. For each step document:
   → Risk: LOW / MEDIUM / HIGH
   → What could go wrong?
   → How to verify success?
   → Rollback plan if it fails?
   → Dependencies (blocking and non-blocking)
```

### Phase 5: Plan Creation

```
1. Sequence steps using combined ordering:
   a. Walking Skeleton first (prove end-to-end)
   b. High-risk items early (validate feasibility)
   c. Critical Path items prioritized (determine timeline)
   d. Parallel opportunities identified (maximize throughput)
   e. MoSCoW applied (ensure MUST items dominate)

2. Assign verification criteria to each step

3. Define rollback strategy for each step

4. Estimate effort (relative: S/M/L/XL or story points)

5. Identify parallelization opportunities
   → Steps with no mutual dependency → can be done simultaneously
```

### Phase 6: Review & Approval

```
1. Present plan in structured format
2. Highlight critical path and high-risk items
3. Confirm with user before execution
4. Adjust based on feedback
```

## Advanced Techniques

### 1. Critical Path Method (CPM)

```python
def calculate_critical_path(tasks: list[dict]) -> dict:
    """Calculate the critical path through task dependencies."""
    # Forward pass: calculate earliest start/finish
    for task in tasks:
        task['es'] = max(
            (t['ef'] for t in tasks if task['id'] in t.get('depends_on', [])),
            default=0
        )
        task['ef'] = task['es'] + task['duration']

    # Backward pass: calculate latest start/finish
    project_end = max(t['ef'] for t in tasks)
    for task in reversed(tasks):
        task['lf'] = min(
            (t['ls'] for t in tasks if t['id'] in task.get('depends_on', [])),
            default=project_end
        )
        task['ls'] = task['lf'] - task['duration']

    # Float = LS - ES (zero float = critical path)
    for task in tasks:
        task['float'] = task['ls'] - task['es']
        task['on_critical_path'] = task['float'] == 0

    critical_path = [t for t in tasks if t['on_critical_path']]
    return {
        'critical_path': critical_path,
        'duration': project_end,
        'total_float_used': sum(t['float'] for t in tasks)
    }
```

### 2. Walking Skeleton Strategy

```python
def build_walking_skeleton(requirements: dict) -> list[dict]:
    """Identify the thinnest end-to-end vertical slice."""
    skeleton = []
    # Map: entry point → core logic → data persistence → basic output
    layers = ['entry_point', 'core_logic', 'data_layer', 'presentation']
    for layer in layers:
        skeleton.append({
            'name': f'walking_skeleton_{layer}',
            'priority': 'MUST',
            'risk': 'MEDIUM',
            'description': f'Thin implementation of {layer} for end-to-end flow',
            'verification': f'Basic {layer} works in isolation and integration',
            'depends_on': [f'walking_skeleton_{layers[i]}'
                          for i in range(layers.index(layer))],
            'effort': 'S'
        })
    return skeleton
```

### 3. Risk-First Planning Matrix

```python
def risk_first_order(tasks: list[dict]) -> list[dict]:
    """Order tasks with highest risk first (with Walking Skeleton exception)."""
    # Separate Walking Skeleton from regular tasks
    skeleton = [t for t in tasks if 'walking_skeleton' in t['name']]
    regular = [t for t in tasks if 'walking_skeleton' not in t['name']]

    # Order regular tasks by risk (highest first), then by priority
    risk_order = {'HIGH': 0, 'MEDIUM': 1, 'LOW': 2}
    priority_order = {'MUST': 0, 'SHOULD': 1, 'COULD': 2, 'WON\'T': 3}

    regular.sort(key=lambda t: (
        risk_order.get(t.get('risk', 'LOW'), 2),
        priority_order.get(t.get('priority', 'SHOULD'), 1)
    ))

    # Skeleton first, then risk-ordered tasks
    return skeleton + regular
```

### 4. Parallel Execution Planner

```python
def identify_parallel_groups(tasks: list[dict]) -> list[list[str]]:
    """Identify groups of tasks that can run in parallel."""
    groups = []
    completed = set()

    while len(completed) < len(tasks):
        # Find all tasks whose dependencies are satisfied
        ready = [
            t for t in tasks
            if t['id'] not in completed
            and all(dep in completed for dep in t.get('depends_on', []))
        ]
        if not ready:
            break  # Deadlock or circular dependency
        groups.append([t['id'] for t in ready])
        completed.update(t['id'] for t in ready)

    return groups
```

### 5. Effort Estimation with Cone of Uncertainty

```python
def estimate_with_uncertainty(tasks: list[dict]) -> dict:
    """Apply cone of uncertainty to task estimates."""
    ESTIMATION_FACTORS = {
        'S': {'optimistic': 0.5, 'nominal': 1.0, 'pessimistic': 2.0},
        'M': {'optimistic': 0.75, 'nominal': 1.5, 'pessimistic': 3.0},
        'L': {'optimistic': 1.0, 'nominal': 3.0, 'pessimistic': 6.0},
        'XL': {'optimistic': 2.0, 'nominal': 5.0, 'pessimistic': 12.0},
    }
    totals = {'optimistic': 0, 'nominal': 0, 'pessimistic': 0}
    for task in tasks:
        size = task.get('size', 'M')
        factor = ESTIMATION_FACTORS.get(size, ESTIMATION_FACTORS['M'])
        for key in totals:
            totals[key] += factor[key]
    # PERT estimate: (O + 4N + P) / 6
    pert = (totals['optimistic'] + 4*totals['nominal'] + totals['pessimistic']) / 6
    return {**totals, 'pert_estimate': pert}
```

### 6. Milestone Definition

```python
def define_milestones(tasks: list[dict]) -> list[dict]:
    """Create milestones from task groupings."""
    milestones = []
    must_tasks = [t for t in tasks if t.get('priority') == 'MUST']
    should_tasks = [t for t in tasks if t.get('priority') == 'SHOULD']
    could_tasks = [t for t in tasks if t.get('priority') == 'COULD']

    milestones.append({
        'name': 'M1: Core Functionality',
        'tasks': [t['id'] for t in must_tasks],
        'description': 'All MUST items complete, feature is usable',
        'gate_criteria': ['All acceptance criteria met', 'Tests passing']
    })
    milestones.append({
        'name': 'M2: Quality Enhancement',
        'tasks': [t['id'] for t in should_tasks],
        'description': 'SHOULD items complete, quality improved',
        'gate_criteria': ['Performance targets met', 'Edge cases handled']
    })
    if could_tasks:
        milestones.append({
            'name': 'M3: Polish & Extras',
            'tasks': [t['id'] for t in could_tasks],
            'description': 'COULD items complete, feature polished',
            'gate_criteria': ['Documentation complete', 'Nice-to-haves added']
        })
    return milestones
```

### 7. Rollback Strategy Builder

```python
def build_rollback_strategies(tasks: list[dict]) -> list[dict]:
    """Define rollback strategy for each task."""
    strategies = []
    for task in tasks:
        rollback = {
            'task_id': task['id'],
            'strategy': 'unknown',
            'preconditions': [],
            'estimated_rollback_time': 'unknown'
        }
        # Determine rollback strategy based on task type
        if task.get('type') == 'database':
            rollback['strategy'] = 'migration_rollback'
            rollback['preconditions'] = ['Backup created', 'Migration reversible']
        elif task.get('type') == 'api':
            rollback['strategy'] = 'feature_flag_toggle'
            rollback['preconditions'] = ['Feature flag in place']
        elif task.get('type') == 'ui':
            rollback['strategy'] = 'git_revert'
            rollback['preconditions'] = ['Commit made before change']
        else:
            rollback['strategy'] = 'git_revert'
            rollback['preconditions'] = ['Clean git state']

        strategies.append(rollback)
    return strategies
```

### 8. Buffer Estimation (1.3x Multiplier)

Apply a consistent buffer to estimates to account for unknowns and typical underestimation:

```python
def apply_buffer(tasks: list[dict], buffer_factor: float = 1.3) -> list[dict]:
    """Apply a 1.3x buffer to each task estimate.

    Research shows developers underestimate by 30-50% on average.
    The 1.3x multiplier is a conservative buffer that:
    - Accounts for unexpected complexity
    - Covers context-switching overhead
    - Includes time for code review and iteration
    - Leaves room for minor scope adjustments

    When to use different factors:
    - 1.2x: Well-understood work, experienced team, clear requirements
    - 1.3x: Standard buffer for most tasks (DEFAULT)
    - 1.5x: New technology, unclear requirements, or complex integration
    - 2.0x: Research/spike work, greenfield projects, or external dependencies
    """
    buffered = []
    for task in tasks:
        buffered_task = task.copy()
        original_size = task.get('size', 'M')
        # Map sizes to hours for calculation
        size_hours = {'S': 4, 'M': 16, 'L': 40, 'XL': 80}
        hours = size_hours.get(original_size, 16)
        buffered_hours = int(hours * buffer_factor)
        # Map back to size
        if buffered_hours <= 6:
            buffered_task['size'] = 'S'
        elif buffered_hours <= 20:
            buffered_task['size'] = 'M'
        elif buffered_hours <= 50:
            buffered_task['size'] = 'L'
        else:
            buffered_task['size'] = 'XL'
        buffered_task['original_estimate'] = original_size
        buffered_task['buffered_estimate'] = buffered_task['size']
        buffered_task['buffer_factor'] = buffer_factor
        buffered.append(buffered_task)
    return buffered

# Usage in plan output:
# | Task | Original | Buffered (1.3x) | Rationale |
# |------|----------|-----------------|-----------|
# | Schema | S (4h) | S (5h) | Well-understood |
# | API | M (16h) | M (21h) | External API integration |
# | Payment | L (40h) | L (52h) | Complex integration |

BUDGET ALLOCATION RULE:
- Total project estimate = Sum of BUFFERED estimates
- If total exceeds deadline, cut COULD items first
- NEVER remove buffers to fit a deadline — cut scope instead
- Track actual vs estimated to calibrate future buffers
```

### 9. TDD Task Sequencing

Structure tasks to follow the Red-Green-Refactor cycle:

```
TECHNIQUE: Test-Driven Development Task Ordering

WHEN TO USE:
- Building new features from scratch
- Tasks that involve business logic
- When test coverage is a priority
- When the team follows TDD practices

TASK STRUCTURE (for each feature):
  Step 1: Write failing test (RED)
    → Define expected behavior in a test
    → Run test, confirm it fails
    → Time estimate: 20% of task

  Step 2: Implement minimum code (GREEN)
    → Write just enough code to pass the test
    → Run test, confirm it passes
    → Time estimate: 40% of task

  Step 3: Refactor (REFACTOR)
    → Clean up code while keeping tests green
    → Extract methods, improve naming, remove duplication
    → Run tests, confirm still passing
    → Time estimate: 40% of task

EXAMPLE TASK BREAKDOWN:
  Task: "Add user registration"

  1a. [RED] Write test: test_register_new_user_success
  1b. [RED] Write test: test_register_duplicate_email_fails
  1c. [RED] Write test: test_register_invalid_email_fails
  1d. [GREEN] Implement register_user() to pass all tests
  1e. [REFACTOR] Extract validation into separate method
  1f. [REFACTOR] Add proper error types

PLANNING INTEGRATION:
  - Each TDD cycle is a micro-step within a larger task
  - Tests are written BEFORE implementation (reduces rework)
  - Refactoring happens naturally within each cycle
  - Verification is automatic (tests pass or fail)

BENEFITS FOR PLANNING:
  - More accurate estimates (test-first reveals hidden complexity)
  - Built-in verification at each step
  - Reduces debugging time later
  - Forces clear acceptance criteria upfront
```

### 10. Vertical Slice Planning

Plan features as thin vertical slices through all layers, not horizontal layers:

```
TECHNIQUE: Vertical Slice Architecture for Task Planning

WHY VERTICAL SLICES:
  Traditional (horizontal):        Vertical Slice:
  ┌──────────────────────┐        ┌──────────────────────┐
  │ All database changes  │        │ Feature A: DB + API  │
  │ All API changes       │        │   + UI + Tests       │
  │ All UI changes        │        ├──────────────────────┤
  │ All test changes      │        │ Feature B: DB + API  │
  └──────────────────────┘        │   + UI + Tests       │
                                  └──────────────────────┘
  Problem: Nothing works until     Benefit: Each slice is
  everything is done               independently shippable

VERTICAL SLICE STRUCTURE:
  For each user-facing feature:
  1. Database: schema/migration for this feature ONLY
  2. Backend: API endpoint/service for this feature ONLY
  3. Frontend: UI component for this feature ONLY
  4. Tests: unit + integration tests for this feature ONLY
  5. Documentation: docs for this feature ONLY

PLANNING APPROACH:
  1. Identify all features (user stories)
  2. For EACH feature, plan the full vertical slice
  3. Each slice is independently developable and deployable
  4. Slices can be worked on in parallel by different developers
  5. Integration happens at the API/contract level

EXAMPLE:
  Feature: "User Registration"
  ┌─ DB: users table, email index
  ├─ API: POST /api/auth/register
  ├─ UI: Registration form component
  ├─ Tests: register unit + integration tests
  └─ Docs: Registration API documentation

  Feature: "User Login"
  ┌─ DB: sessions table, token storage
  ├─ API: POST /api/auth/login
  ├─ UI: Login form component
  ├─ Tests: login unit + integration tests
  └─ Docs: Authentication flow documentation
```

## Common Patterns

### Pattern 1: Full Task Plan Output

```markdown
## Implementation Plan: [Feature Name]

### Goal
[What we're building — from requirement-analysis]

### Walking Skeleton
1. Create minimal API endpoint (returns hardcoded data)
2. Create minimal UI component (displays hardcoded data)
3. Connect UI to API (end-to-end flow works)
4. Add database layer (data persists)
5. Add error handling (graceful failures)

### Task List
| # | Task | Priority | Risk | Size | Deps | Verify |
|---|------|----------|------|------|------|--------|
| 1 | Create DB schema | MUST | MED | S | — | Migration runs |
| 2 | API endpoint | MUST | LOW | M | 1 | Returns valid JSON |
| 3 | UI component | MUST | LOW | M | — | Renders correctly |
| 4 | Connect UI↔API | MUST | MED | M | 2,3 | E2E flow works |
| 5 | Error handling | SHOULD | LOW | S | 4 | Errors shown |
| 6 | Loading states | COULD | LOW | S | 4 | Skeleton visible |
| 7 | Caching layer | COULD | MED | M | 4 | Cache hit works |

### Critical Path
1 → 2 → 4 (Schema → API → Integration)

### Parallel Opportunities
- Steps 2 and 3 can run in parallel (different layers)
- Step 5 can run parallel with step 6

### MoSCoW Summary
- MUST (4): Schema, API, UI, Integration
- SHOULD (1): Error handling
- COULD (2): Loading states, Caching
- WON'T: Analytics, Admin panel (deferred)

### Risk Register
| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| API contract mismatch | HIGH | MED | API-first design, contract test |
| DB performance | MED | LOW | Index critical columns |

### Rollback Plan
- Each step has a git commit before it
- Database changes use reversible migrations
- Feature flags for UI changes

### Milestones
- M1: Core functionality working (steps 1-4)
- M2: Quality improvements (step 5)
- M3: Polish (steps 6-7)
```

### Pattern 2: Quick Plan for Small Tasks

```markdown
## Quick Plan

**Task:** Fix login timeout bug
**Risk:** LOW
**Size:** S

### Steps
1. Reproduce the bug (verify: timeout occurs on login)
2. Identify root cause in auth middleware (verify: found issue)
3. Apply fix (verify: login works within 2s)
4. Test edge cases (verify: concurrent logins, expired tokens)

### Verification
- [ ] Login completes in < 2 seconds
- [ ] No regression in existing auth tests
```

### Pattern 3: Decomposition Tree

```markdown
## Decomposition: Payment Integration

Payment Integration
├── 1. Payment Gateway Setup (MUST)
│   ├── 1a. API key configuration
│   ├── 1b. SDK installation
│   └── 1c. Connection test
├── 2. Checkout Flow (MUST)
│   ├── 2a. Payment form UI
│   ├── 2b. Validation logic
│   └── 2c. Submit handler
├── 3. Webhook Handler (MUST)
│   ├── 3a. Endpoint creation
│   ├── 3b. Signature verification
│   └── 3c. Status update logic
├── 4. Error Handling (SHOULD)
│   ├── 4a. Payment declined handling
│   └── 4b. Timeout retry logic
└── 5. Receipt Generation (COULD)
    ├── 5a. Email template
    └── 5b. PDF generation
```

### Pattern 4: Dependency Graph Visualization

```markdown
## Dependency Graph

```
[1: DB Schema]
    ↓
[2: API Endpoint] ← [3: UI Component]
    ↓                ↓
[4: Integration Layer]
    ↓
[5: Error Handling] → [6: Loading States]
    ↓
[7: Caching]
```

### Parallel Groups
- Group 1: [1] (no deps)
- Group 2: [2], [3] (parallel after 1)
- Group 3: [4] (after 2, 3)
- Group 4: [5], [6] (parallel after 4)
- Group 5: [7] (after 5)
```

### Pattern 5: Risk-Based Priority Matrix

```markdown
## Risk-Priority Matrix

| | LOW Risk | MED Risk | HIGH Risk |
|---|----------|----------|-----------|
| **MUST** | Do immediately | Do early, validate | Validate FIRST |
| **SHOULD** | Do after MUST | Schedule carefully | Challenge necessity |
| **COULD** | Do if time permits | Defer unless confident | Skip for now |
| **WON'T** | Document only | Document only | Document only |

### Current Tasks Placed
- MUST + LOW: DB Schema → Do first (quick win)
- MUST + MED: API Integration → Do second, with testing
- MUST + HIGH: Payment Gateway → Validate feasibility FIRST
- SHOULD + LOW: Error Messages → After core is done
- COULD + MED: Caching → Defer to Phase 2
```

## Edge Cases & Pitfalls

1. **Analysis paralysis** — Spending more time planning than implementing. Time-box planning to 10-15% of total effort. For simple tasks, plan in your head.

2. **Circular dependencies** — Task A depends on B and B depends on A. This indicates a design flaw. Extract a shared interface or restructure.

3. **Hidden dependencies** — Two tasks share a file but neither explicitly depends on the other. This creates merge conflicts. Identify implicit resource dependencies.

4. **Over-decomposition** — Breaking a 30-minute task into five 6-minute micro-steps. This wastes time on overhead. Keep steps at a meaningful granularity.

5. **Under-decomposition** — A single "implement authentication" step covers 20 files and 3 days of work. This hides complexity. Break it down further.

6. **Ignoring the Walking Skeleton** — Jumping to detailed implementation without proving the end-to-end flow first. Build the skeleton to validate architecture early.

7. **Critical path neglect** — Focusing on easy low-risk tasks while the critical path (longest dependency chain) is delayed. Prioritize the critical path.

8. **MoSCoW drift** — Everything becomes MUST. Enforce the 60% rule: no more than 60% of tasks should be MUST.

9. **Missing rollback plan** — No way to undo if something goes wrong. Every step should have a documented rollback strategy.

10. **Parallel tasks sharing state** — Two parallel tasks modifying the same file or data. This creates conflicts. Add explicit synchronization points.

11. **Risk assessment bias** — Underestimating risk for familiar patterns and overestimating for new ones. Use objective criteria: "Have I done this exact thing before?"

12. **Plan rigidity** — Sticking to the plan when requirements change. Plans should be living documents that adapt to new information.

13. **Missing verification criteria** — Steps without clear "how do I know this is done?" are prone to scope creep. Every step needs a concrete verification method.

14. **Ignoring external dependencies** — Waiting for API access, third-party approvals, or environment setup. Identify external blockers early and have contingency plans.

15. **Single point of failure** — If only one person can do a task, it's a risk. Identify knowledge-sharing needs and document critical steps.

## Integration with Other Skills

| Skill | Relationship | How It Connects |
|-------|-------------|-----------------|
| project-analysis | Precedes | Project context informs what's feasible and how tasks map to code structure |
| requirement-analysis | Precedes | Requirements provide the "what" that tasks decompose into "how" |
| code-generation | Executes | Plan steps become code generation prompts |
| code-review | Validates | Each step's verification criteria become review checkpoints |
| debugging | Rescues | When a step fails, debugging skill investigates the failure |
| verification | Tests | Verification criteria define test cases for each step |
| refactoring | Opportunistic | During implementation, identify refactoring opportunities |
| git-workflow | Tracks | Each step maps to commits/branches for traceability |
| changelog | Documents | Completed tasks become changelog entries |
| system-design | Guides | Architectural decisions inform task decomposition |

## Output Format Templates

### Template 1: Comprehensive Plan

```markdown
## Implementation Plan: [Feature Name]

**Created:** [Date]
**Status:** Draft / Approved / In Progress
**Estimated Effort:** [total size]

### Context
[From requirement-analysis: what and why]

### Walking Skeleton
[Thin vertical slice that proves architecture]

### MoSCoW Breakdown
#### MUST (Estimated: [effort])
| # | Task | Size | Risk | Deps | Verify |
|---|------|------|------|------|--------|
| 1 | [task] | S | LOW | — | [criteria] |

#### SHOULD (Estimated: [effort])
| # | Task | Size | Risk | Deps | Verify |
|---|------|------|------|------|--------|
| 5 | [task] | M | MED | 4 | [criteria] |

#### COULD (Estimated: [effort])
| # | Task | Size | Risk | Deps | Verify |
|---|------|------|------|------|--------|
| 7 | [task] | S | LOW | 4 | [criteria] |

#### WON'T (Deferred)
| Task | Reason Deferred | Target Release |
|------|----------------|----------------|
| [task] | [reason] | v2.0 |

### Critical Path
[Steps that determine minimum duration]

### Parallel Opportunities
[Groups of steps that can run simultaneously]

### Risk Register
| Risk | Impact | Likelihood | Mitigation | Owner |
|------|--------|-----------|------------|-------|

### Rollback Strategies
| Step | Strategy | Preconditions | Rollback Time |
|------|----------|---------------|---------------|

### Milestones
| Milestone | Includes | Gate Criteria |
|-----------|----------|---------------|

### Dependencies External
| Dependency | Status | Blocker? | Contingency |
|------------|--------|----------|-------------|
```

### Template 2: Quick Plan (for small tasks)

```markdown
## Quick Plan: [Task Name]

**Size:** S/M | **Risk:** LOW/MED | **Estimated:** [time]

### Steps
1. [Step] → Verify: [criteria]
2. [Step] → Verify: [criteria]
3. [Step] → Verify: [criteria]

### Rollback
[Simple rollback: git revert, feature flag, etc.]

### Notes
[Any relevant context]
```

### Template 3: Decomposition Breakdown

```markdown
## Task Decomposition: [Parent Task]

### Level 0: [Parent Task]
- Size: XL
- Risk: HIGH

### Level 1: Subtasks
1. [Subtask A] — Size: M, Risk: MED
   1a. [Micro task] — Size: S
   1b. [Micro task] — Size: S
2. [Subtask B] — Size: M, Risk: LOW
3. [Subtask C] — Size: S, Risk: MED

### Dependency Tree
```
[Parent Task]
├── [A] → [A1, A2] (sequential)
├── [B] (parallel with A)
└── [C] (after A)
```
```

### Template 4: Risk Assessment Report

```markdown
## Risk Assessment: [Task/Feature]

### Overall Risk Level: [LOW/MEDIUM/HIGH]

### Risk Items
| # | Risk | Category | Impact | Probability | Score | Mitigation |
|---|------|----------|--------|------------|-------|------------|
| R1 | [description] | Technical | HIGH | MED | 6 | [action] |
| R2 | [description] | External | MED | HIGH | 6 | [action] |
| R3 | [description] | Resource | LOW | LOW | 1 | [action] |

### Risk Score: Impact (1-3) × Probability (1-3)
- 1-3: Low (monitor)
- 4-6: Medium (mitigate)
- 7-9: High (resolve or defer)

### Contingency Plans
- If R1 occurs: [fallback approach]
- If R2 occurs: [alternative source]
```

## Rules

1. **Plan before implementing** — For any task with 3+ steps or affecting 3+ files, create a plan first. No exceptions for non-trivial work.

2. **Walking Skeleton first** — Always identify and prioritize the thinnest end-to-end slice. Proves the architecture works before deep implementation.

3. **Risk-First ordering** — Tackle high-risk items early to validate feasibility. Wasting time on low-risk work while a high-risk blocker looms is inefficient.

4. **Every step must be independently verifiable** — If you cannot define how to check a step is done, it is not granular enough. Break it down further.

5. **Critical path awareness** — Identify the longest dependency chain and give it priority. Delays on the critical path delay the entire project.

6. **MoSCoW discipline** — No more than 60% of tasks can be MUST. If everything is MUST, nothing is. Force prioritization.

7. **Rollback plan required** — Every step must have a documented way to undo the change if it fails. No step should be irreversible without explicit acknowledgment.

8. **Never skip verification** — Steps without verification criteria are incomplete. The plan is not done until every step has a concrete "done" test.

9. **Plans are living documents** — Update the plan as you learn. Requirements change, risks materialize, new information emerges. Adapt the plan accordingly.

10. **External dependencies flagged early** — If a step depends on something outside your control (API access, approval, environment setup), identify it immediately and have a contingency.

11. **Parallel optimization** — Identify independent tasks and plan for parallel execution when possible. Sequential processing of independent tasks wastes time.

12. **Document decisions and rationale** — When you choose one approach over another, record why. Future you (or your team) will thank you.

13. **Scope discipline** — If a task grows beyond its estimated size, stop and re-plan. Do not silently expand scope to "finish" a step.

14. **User approval for complex plans** — Plans with 10+ steps or HIGH-risk items require user approval before execution. Present the plan, get confirmation.

15. **Post-mortem on failed steps** — When a step fails, document what went wrong and adjust the remaining plan. This prevents repeating the same mistake.

## Verification Checklist

- [ ] End state clearly defined
- [ ] Walking Skeleton identified
- [ ] All steps decomposed and atomic
- [ ] Dependencies mapped (no cycles)
- [ ] Critical path identified
- [ ] MoSCoW prioritization applied
- [ ] Risk assessment completed for each step
- [ ] Verification criteria defined for each step
- [ ] Rollback strategy documented for each step
- [ ] Parallel opportunities identified
- [ ] External dependencies flagged
- [ ] User approval obtained (if complex)

## Failure Handling

- **Plan too complex** → Break into phases. Plan Phase 1 only in detail; plan subsequent phases at a high level.
- **Circular dependencies detected** → Extract shared interface, restructure module boundaries, or redefine task scope.
- **Step fails during execution** → Stop, debug, document root cause, adjust remaining plan. Do not skip ahead.
- **Requirements change mid-implementation** → Re-run requirement-analysis, update plan, get re-approval.
- **External blocker discovered** → Document blocker, create contingency plan, proceed with non-blocked steps.
