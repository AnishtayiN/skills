---
name: requirement-analysis
description: >-
  Analyze and clarify user requirements before implementing. Distinguish what user wants from what they need.
  TRIGGERS: requirement, what do you need, clarify requirements, user story, acceptance criteria,
  what exactly do you want, define scope, functional requirement, non-functional requirement,
  نیازمندی, چی میخوای, دقیقاً چه کاری, محدوده کار, شرایط پذیرش
  需求分析, 需求澄清, 用户故事, 验收标准, 功能需求, 非功能需求, 明确范围
priority: P1
dependencies: [project-analysis]
conflicts: []
---

# Requirement Analysis Skill

## Overview

Transform vague, ambiguous, or incomplete user requests into clear, actionable, verifiable requirements BEFORE writing any code. Bridges the gap between what the user says and what they actually need. Produces structured requirement documents with acceptance criteria, scope boundaries, risk assessments, and explicit assumptions. Prevents scope creep, rework, and misaligned expectations.

## When to Use This Skill

- User request is ambiguous or open-ended ("add a feature", "make it better")
- Task involves multiple possible approaches
- Task affects multiple files, modules, or systems
- Before any significant code change or new feature
- User describes a problem but not a solution
- Multiple stakeholders may have different expectations
- Requirements come in fragments across multiple messages

## When NOT to Use This Skill

- User provides exact code to write with no ambiguity
- Simple typo fixes or formatting corrections
- Clear single-file changes with explicit instructions
- Emergency hotfix where speed is critical and scope is obvious

## Workflow (Detailed Multi-Phase)

### Phase 1: Intent Extraction

```
1. Parse user's exact words
   → What is the GOAL? (outcome, not implementation)
   → What is the expected BEHAVIOR?
   → What is the current STATE? (problem to solve)
   → What is the desired STATE? (solution vision)

2. Identify explicit vs. implicit requirements
   → Explicit: directly stated by user
   → Implicit: logically follow from the goal but not stated
   → Hidden: requirements the user doesn't know they have

3. Extract constraints
   → Technical: language, framework, compatibility
   → Business: timeline, budget, regulations
   → Quality: performance, security, accessibility
   → Organizational: team skills, existing patterns
```

### Phase 2: Gap Analysis

```
Questions to investigate (ask if unanswered):
- Which files/modules are affected?
- What existing behavior must NOT change?
- What edge cases should be handled?
- What is the testing strategy?
- Are there backwards compatibility requirements?
- Who is the end user of this feature/change?
- What does "done" look like concretely?
- Are there similar features to model after?
```

### Phase 3: Acceptance Criteria Definition

```
For EACH requirement, define testable criteria:
- Given [precondition/context]
- When [user action or trigger]
- Then [expected result]
- And [additional expected behavior]

Negative criteria (what should NOT happen):
- Given [precondition]
- When [invalid action]
- Then [appropriate error handling]
```

### Phase 4: Scope Boundary Definition

```
1. IN SCOPE — What will be implemented
2. OUT OF SCOPE — What explicitly will NOT be done
3. FUTURE — What might be done later (parking lot)
4. DEPENDENCIES — What must exist first
```

### Phase 5: Risk Assessment

```
For each requirement:
- Complexity: LOW / MEDIUM / HIGH
- Uncertainty: LOW / MEDIUM / HIGH
- Risk: What could go wrong?
- Mitigation: How to reduce the risk?
```

### Phase 6: User Validation

```
Present structured summary:
1. "I understand you want [GOAL]"
2. "This means [SPECIFIC CHANGES] will happen"
3. "I will NOT touch [OUT OF SCOPE ITEMS]"
4. "I'm making these assumptions: [LIST]"
5. "Is this correct?"
```

## Advanced Techniques

### 1. SMART Requirements Framework

```python
def validate_requirement(req: dict) -> dict:
    """Validate a requirement against SMART criteria."""
    checks = {
        'specific': bool(req.get('description', '')) and len(req['description']) > 10,
        'measurable': bool(req.get('acceptance_criteria', [])),
        'achievable': req.get('complexity', 'HIGH') != 'HIGH',
        'relevant': bool(req.get('goal_alignment', '')),
        'time_bound': bool(req.get('deadline') or req.get('estimated_effort')),
    }
    return {
        'requirement': req.get('id'),
        'smart_score': sum(checks.values()) / len(checks),
        'gaps': [k for k, v in checks.items() if not v]
    }
```

### 2. MoSCoW Prioritization

```python
def prioritize_requirements(requirements: list[dict]) -> dict:
    """Classify requirements using MoSCoW method."""
    prioritized = {'must': [], 'should': [], 'could': [], 'wont': []}
    for req in requirements:
        priority = req.get('priority', 'should')
        prioritized[priority].append(req)
    # Validate: Must-haves should be achievable in timeline
    # Should-haves are secondary goals
    # Could-haves are nice-to-have improvements
    # Won't-haves are deferred to future releases
    return prioritized
```

### 3. User Story Mapping

```python
def create_user_story_map(stories: list[dict]) -> dict:
    """Organize user stories into a story map."""
    activities = {}
    for story in stories:
        activity = story.get('activity', 'unknown')
        tasks = story.get('user_tasks', [])
        activities.setdefault(activity, {
            'user_tasks': [],
            'releases': {'mvp': [], 'v1': [], 'v2': []}
        })
        for task in tasks:
            release = story.get('release', 'mvp')
            activities[activity]['releases'].setdefault(release, []).append(task)
    return activities
```

### 4. Conflict Resolution Matrix

```python
def resolve_conflicts(requirements: list[dict]) -> list[dict]:
    """Identify and resolve conflicting requirements."""
    conflicts = []
    for i, req_a in enumerate(requirements):
        for req_b in requirements[i+1:]:
            # Check for resource conflicts (same file, same module)
            # Check for behavioral conflicts (opposite expected outcomes)
            # Check for constraint conflicts (incompatible requirements)
            overlap = set(req_a.get('files', [])) & set(req_b.get('files', []))
            if overlap:
                conflicts.append({
                    'req_a': req_a['id'],
                    'req_b': req_b['id'],
                    'shared_resources': list(overlap),
                    'resolution': 'priority_ordering'  # or 'merge' or 'defer'
                })
    return conflicts
```

### 5. Assumption Tracking

```python
class AssumptionTracker:
    def __init__(self):
        self.assumptions = []

    def add(self, assumption: str, impact: str, validated: bool = False):
        self.assumptions.append({
            'id': f'A-{len(self.assumptions) + 1}',
            'assumption': assumption,
            'impact_if_wrong': impact,
            'validated': validated,
            'validation_method': None
        })

    def get_unvalidated(self) -> list:
        return [a for a in self.assumptions if not a['validated']]

    def report(self) -> str:
        total = len(self.assumptions)
        validated = sum(1 for a in self.assumptions if a['validated'])
        return f"Assumptions: {validated}/{total} validated"
```

### 6. Traceability Matrix

```python
def build_traceability_matrix(requirements, tasks, tests, code):
    """Map requirements → tasks → tests → code."""
    matrix = []
    for req in requirements:
        mapped_tasks = [t for t in tasks if req['id'] in t.get('requirement_ids', [])]
        mapped_tests = [t for t in tests if req['id'] in t.get('requirement_ids', [])]
        matrix.append({
            'requirement': req['id'],
            'tasks': [t['id'] for t in mapped_tasks],
            'tests': [t['id'] for t in mapped_tests],
            'coverage': 'complete' if mapped_tests else 'partial' if mapped_tasks else 'none'
        })
    return matrix
```

### 7. INVEST Criteria Evaluation

```python
def evaluate_user_story(story: dict) -> dict:
    """Evaluate a user story against INVEST criteria."""
    return {
        'independent': not story.get('blocking_dependencies', []),
        'negotiable': story.get('flexible', False),
        'valuable': bool(story.get('user_value', '')),
        'estimable': bool(story.get('story_points') or story.get('tshirt_size')),
        'small': story.get('story_points', 99) <= 8,
        'testable': bool(story.get('acceptance_criteria', [])),
        'score': sum([
            not story.get('blocking_dependencies', []),
            story.get('flexible', False),
            bool(story.get('user_value', '')),
            bool(story.get('story_points') or story.get('tshirt_size')),
            story.get('story_points', 99) <= 8,
            bool(story.get('acceptance_criteria', []))
        ]) / 6
    }
```

## Common Patterns

### Pattern 1: Vague to Specific Transformation

```python
# BEFORE: Vague user request
# "Add authentication to the app"

# AFTER: Structured requirements
requirements = {
    'goal': 'Enable user authentication so only authorized users can access protected routes',
    'functional': [
        'Users can register with email and password',
        'Users can log in and receive a JWT token',
        'Protected routes require valid JWT',
        'Users can log out (token invalidation)',
        'Password must meet complexity requirements (8+ chars, 1 uppercase, 1 number)',
    ],
    'non_functional': [
        'Login response time < 500ms',
        'Passwords stored with bcrypt (cost factor 12)',
        'JWT tokens expire after 24 hours',
        'Rate limiting: max 5 login attempts per minute per IP',
    ],
    'out_of_scope': [
        'OAuth/social login (future release)',
        'Two-factor authentication (future release)',
        'Password reset via email (separate requirement)',
    ],
    'acceptance_criteria': [
        {
            'given': 'A user with valid credentials',
            'when': 'They submit the login form',
            'then': 'They receive a JWT token and can access protected routes'
        },
        {
            'given': 'A user with invalid credentials',
            'when': 'They submit the login form',
            'then': 'They receive a 401 error and no token is issued'
        }
    ]
}
```

### Pattern 2: Problem-Solution Decomposition

```python
# User states a PROBLEM, not a solution
# "The app is too slow"

# Decompose into specific performance requirements
perf_requirements = {
    'problem': 'Application perceived as slow by users',
    'symptoms': [
        'Page load time > 5 seconds on dashboard',
        'API responses > 2 seconds for list endpoints',
        'Large dataset rendering causes UI freeze',
    ],
    'requirements': [
        'Dashboard must load in < 2 seconds on 3G connection',
        'API list endpoints must respond in < 500ms',
        'Large datasets must use virtual scrolling',
        'Implement loading skeletons for perceived performance',
    ],
    'measurable_targets': {
        'lighthouse_performance_score': '>= 80',
        'first_contentful_paint': '< 1.5s',
        'time_to_interactive': '< 3.0s',
    }
}
```

### Pattern 3: Acceptance Criteria Template

```markdown
### Requirement: User Registration

**AC-1: Successful Registration**
- Given a visitor on the registration page
- When they submit valid email, password, and display name
- Then a new account is created
- And they receive a confirmation email
- And they are redirected to the login page with a success message

**AC-2: Duplicate Email Rejection**
- Given a visitor on the registration page
- When they submit an email that already exists in the system
- Then they receive a clear error message: "An account with this email already exists"
- And no new account is created
- And the form retains the entered display name

**AC-3: Password Validation**
- Given a visitor on the registration page
- When they submit a password shorter than 8 characters
- Then they receive an error: "Password must be at least 8 characters"
- And the form is not submitted
```

### Pattern 4: Non-Functional Requirements Checklist

```markdown
## Non-Functional Requirements

### Performance
- [ ] Response time: < 500ms for API calls
- [ ] Throughput: Support 100 concurrent users
- [ ] Bundle size: < 200KB gzipped

### Security
- [ ] Input validation on all user inputs
- [ ] CSRF protection enabled
- [ ] Rate limiting on authentication endpoints
- [ ] SQL injection prevention (parameterized queries)

### Accessibility
- [ ] WCAG 2.1 AA compliance
- [ ] Screen reader compatibility
- [ ] Keyboard navigation support
- [ ] Color contrast ratios >= 4.5:1

### Compatibility
- [ ] Chrome, Firefox, Safari, Edge (latest 2 versions)
- [ ] iOS Safari 15+, Android Chrome 100+
- [ ] Node.js 18+ LTS

### Reliability
- [ ] Graceful error handling for network failures
- [ ] Offline support with service worker (if applicable)
- [ ] Data validation on both client and server
```

### Pattern 5: Requirements Validation Checklist

```python
def validate_all_requirements(requirements: list[dict]) -> dict:
    """Validate all requirements against quality criteria."""
    results = {
        'total': len(requirements),
        'valid': 0,
        'invalid': 0,
        'issues': []
    }
    for req in requirements:
        issues = []
        if not req.get('acceptance_criteria'):
            issues.append('Missing acceptance criteria')
        if not req.get('out_of_scope'):
            issues.append('No scope boundary defined')
        if req.get('complexity', 'LOW') == 'HIGH' and not req.get('risks'):
            issues.append('High complexity without risk assessment')
        if not req.get('priority'):
            issues.append('Missing priority level')

        if issues:
            results['invalid'] += 1
            results['issues'].append({'requirement': req['id'], 'issues': issues})
        else:
            results['valid'] += 1

    results['validation_rate'] = results['valid'] / results['total'] * 100
    return results
```

## Edge Cases & Pitfalls

1. **"Just do what's best" trap** — User defers all decisions to you. This is dangerous. Always present options with trade-offs and get explicit confirmation.

2. **Hidden requirements** — User asks for feature A but implicitly expects B, C, and D. Always ask "what else should this handle?" and think about edge cases they haven't considered.

3. **Moving goalposts** — Requirements change after work begins. Maintain a baseline: if requirements change, re-evaluate scope, timeline, and impact before proceeding.

4. **Conflicting requirements** — Two requirements cannot both be satisfied. Identify the conflict explicitly, present options, and let the user choose.

5. **Scope creep** — Small additions that individually seem harmless but collectively double the workload. Every new item must be evaluated against the original scope.

6. **Technical requirements mixed with business requirements** — "Use React" is a technical constraint, not a business requirement. Separate the two for clarity.

7. **Unmeasurable acceptance criteria** — "The app should be fast" is not testable. Convert to "Response time < 500ms under 100 concurrent users."

8. **Requirements without constraints** — A feature without performance, security, or compatibility constraints is incomplete. Always ask about non-functional requirements.

9. **Over-specifying implementation** — User says "add a MySQL table with columns X, Y, Z." This constrains implementation unnecessarily. Focus on the data need, not the specific table design.

10. **Under-specifying error cases** — User specifies the happy path only. Always ask: "What should happen when [failure scenario]?"

11. **Cultural and language barriers** — In multilingual contexts, ensure requirements are translated precisely. Use simple, unambiguous language.

12. **Assumption cascade** — One unvalidated assumption leads to incorrect requirements, which lead to wrong implementation. Track and validate every assumption.

13. **Missing stakeholder** — The person requesting isn't the end user. Ensure requirements reflect actual user needs, not just the requester's interpretation.

14. **Perfect being the enemy of good** — Over-analyzing requirements delays delivery. Set a time-box for requirement analysis and proceed with documented assumptions.

15. **Requirements without codebase awareness** — Requirements that ignore existing patterns create inconsistency. Always ground requirements in the project-analysis context.

## Integration with Other Skills

| Skill | Relationship | How It Connects |
|-------|-------------|-----------------|
| project-analysis | Precedes | Project context informs what's feasible and how requirements map to code |
| task-planning | Feeds into | Requirements become the basis for task decomposition |
| code-generation | Guides | Requirements and acceptance criteria shape generated code |
| code-review | Validates | Acceptance criteria become review checkpoints |
| verification | Tests against | Acceptance criteria define what "passing" means |
| system-design | Constrains | Non-functional requirements drive architectural decisions |
| debugging | Context | Requirements provide the "expected behavior" reference |
| documentation | Documents | Requirements become living documentation |
| performance-analysis | Non-functional | Performance requirements set measurable targets |
| security-audit | Security reqs | Security requirements define threat model boundaries |

## Output Format Templates

### Template 1: User Story Format

```markdown
## User Story: [Title]

**As a** [user role]
**I want to** [action/capability]
**So that** [benefit/value]

### Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]

### Technical Notes
- Files affected: [list]
- Dependencies: [list]
- Priority: [MoSCoW: Must/Should/Could/Won't]

### Out of Scope
- [What will NOT be done]

### Assumptions
- [A-1] [assumption] — Impact if wrong: [impact]
```

### Template 2: Functional Specification

```markdown
## Functional Specification: [Feature Name]

### Overview
[Description of what the feature does]

### User Scenarios
1. [Scenario 1: user action → system response]
2. [Scenario 2: user action → system response]

### Data Model
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | yes | User's display name |
| email | string | yes | Unique email address |

### API Endpoints
| Method | Path | Description |
|--------|------|-------------|
| POST | /api/users | Create new user |
| GET | /api/users/:id | Get user by ID |

### Business Rules
1. Email must be unique across the system
2. Password must be hashed before storage
3. Users can only modify their own profile

### Error Handling
| Error | HTTP Status | Message |
|-------|------------|---------|
| Duplicate email | 409 | "Email already registered" |
| Invalid input | 400 | "Validation failed: [details]" |
```

### Template 3: Requirements Summary (for user confirmation)

```markdown
## Requirements Summary

### What You Asked For
"[User's original request]"

### What I Understand You Need
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

### What Will Change
- [File/module]: [specific change]
- [File/module]: [specific change]

### What Will NOT Change
- [Explicitly preserved behavior]

### My Assumptions
1. [Assumption 1] — Correct?
2. [Assumption 2] — Correct?

### Estimated Complexity
[LOW / MEDIUM / HIGH] — [brief reason]

**Please confirm or correct before I proceed.**
```

### Template 4: Non-Functional Requirements Document

```markdown
## Non-Functional Requirements

### Performance
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| API response time | < 500ms | p95 latency |
| Page load time | < 2s | Lighthouse |
| Concurrent users | 100+ | Load test |

### Security
| Requirement | Standard | Implementation |
|-------------|----------|---------------|
| Authentication | JWT | Token-based auth |
| Input validation | OWASP Top 10 | Zod schema validation |
| Rate limiting | 100 req/min | Express rate limiter |

### Accessibility
| Standard | Level | Key Requirements |
|----------|-------|-----------------|
| WCAG | 2.1 AA | Keyboard nav, screen reader, contrast |

### Compatibility
| Platform | Version | Status |
|----------|---------|--------|
| Chrome | Latest 2 | Required |
| Firefox | Latest 2 | Required |
| Safari | 15+ | Required |
| Edge | Latest 2 | Best-effort |
```

## Rules

1. **Never implement without confirmed requirements** — If requirements are ambiguous, ask clarifying questions before writing code. Ambiguity in equals bugs in the output.

2. **Separate wants from needs** — User may want Feature X but need the underlying problem solved. Address the need, suggest the want as one possible solution.

3. **Document every assumption** — Every assumption is a risk. Track them explicitly and validate before implementation where possible.

4. **Every requirement needs a testable acceptance criterion** — If you cannot write a test for it, the requirement is too vague. Refine until testable.

5. **Define scope boundaries explicitly** — Always state what is OUT of scope. This prevents scope creep and sets clear expectations.

6. **Get user confirmation before proceeding** — Present the requirements summary and wait for explicit approval. "Proceeding unless you object" is not confirmation.

7. **Break complex requirements into sub-requirements** — A requirement that cannot be implemented in a single focused task is too large. Decompose it.

8. **Validate feasibility against project-analysis** — Requirements that conflict with the project's architecture or tech stack must be flagged early.

9. **Non-functional requirements are not optional** — Performance, security, accessibility, and compatibility requirements must be addressed even if not explicitly requested.

10. **Maintain requirement traceability** — Each requirement should link to implementation tasks, tests, and code. This enables impact analysis when requirements change.

11. **Never expand scope silently** — If you discover additional work needed to fulfill a requirement, surface it. Do not implement extras without approval.

12. **Use the user's language** — Avoid technical jargon in requirement summaries. Present in terms the user understands.

13. **Requirements are living documents** — Update requirements as understanding evolves. Mark changes and maintain version awareness.

14. **Time-box analysis** — Do not spend more time analyzing than implementing. For simple tasks, a quick confirmation is enough. For complex tasks, a structured document.

15. **When in doubt, ask** — Better to ask a question that seems obvious than to implement the wrong thing. There are no stupid questions in requirement analysis.

## Verification Checklist

- [ ] User's goal clearly understood and documented
- [ ] Acceptance criteria defined for each requirement
- [ ] Scope boundaries (in/out) explicitly stated
- [ ] Assumptions documented with impact analysis
- [ ] User has confirmed understanding
- [ ] Non-functional requirements addressed
- [ ] Conflicts between requirements resolved
- [ ] Feasibility verified against project context
- [ ] Traceability links established

## Failure Handling

- **User cannot clarify** → Make reasonable assumptions, document them prominently, and proceed with explicit caveat: "Proceeding with these assumptions — please correct if wrong."
- **Requirements conflict** → Present the conflict clearly with options and trade-offs. Ask user to prioritize.
- **Requirements infeasible** → Explain why, suggest alternatives, and let user choose.
- **Requirements keep changing** → Suggest a baseline freeze. Implement the current set, then iterate.
