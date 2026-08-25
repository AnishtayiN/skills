---
name: documentation
description: >-
  Write, generate, and improve project documentation including README files, API documentation (OpenAPI/Swagger), user guides, developer onboarding docs, code comments, inline docstrings, architecture decision records (ADRs), contributing guides, RFCs, design docs, runbooks, postmortems, and setup instructions. Use this skill whenever the user mentions writing documentation, documenting code, creating a README, API docs, user guide, developer guide, onboarding docs, code documentation, JSDoc, docstrings, writing help text, مستندات, نوشتن مستندات, مستندسازی, راهنمای کاربر, راهنمای توسعه‌دهنده, داکیومنت, فایل README, مستند کردن کد, OpenAPI, Swagger, architecture decision record, ADR, RFC, design doc, runbook, postmortem, documentation as code, or asks you to explain or document their project, library, API, or module.
---

# Documentation Skill — Project & Code Documentation Writer

## Overview

This skill produces clear, accurate, and actionable documentation for software projects. Good documentation answers the reader's next question before they ask it. Whether it's a README for an open-source library, API reference docs, an internal user guide, an architecture decision record, or a postmortem, the goal is always the same: **help the reader understand and use the thing without needing to talk to you**. This skill covers all major documentation types, audience-specific patterns, tooling recommendations, and maintenance strategies.

## When to Use This Skill

- User asks to write or update a README, CONTRIBUTING, or CHANGELOG file
- User needs API documentation (REST, GraphQL, SDK, CLI)
- User wants a user guide, getting-started guide, or tutorial
- User asks to document code (add docstrings, JSDoc, comments)
- User needs architecture decision records or design docs
- User wants an RFC for a proposed change
- User needs a runbook for operations
- User wants to write a postmortem after an incident
- User says "document this code" or "write docs for this project"
- User mentions مستندات, مستندسازی, راهنما, or داکیومنت

---

## Documentation Types & Templates

### Type 1: README

The most important document in any project. Most people will read only the README.

#### Standard README Template

```markdown
# [Project Name]

[![Build Status](badge-url)](link)
[![npm version](badge-url)](link)
[![License](badge-url)](link)

> One-line description of what this project does and why it exists.

## Features

- ✅ [Feature 1 — what it does for the user]
- ✅ [Feature 2]
- ✅ [Feature 3]
- 🔜 [Feature 4 — planned, for roadmap transparency]

## Quick Start

\`\`\`bash
# Install
npm install @org/project-name

# Run
npx project-name --help
\`\`\`

## Installation

### Prerequisites
- [Requirement 1]
- [Requirement 2]

### Install
\`\`\`bash
[install command]
\`\`\`

### Verify
\`\`\`bash
[verification command — should output something specific]
\`\`\`

## Usage

### Basic Usage
\`\`\`[language]
// Minimal working example
[complete, runnable code]
\`\`\`

### Advanced Usage
\`\`\`[language]
// More complex example
[complete, runnable code]
\`\`\`

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `option1` | string | `"default"` | What this option controls |
| `option2` | number | `3000` | Port number for the server |
| `option3` | boolean | `true` | Whether to enable feature X |

## API Reference

### `functionName(param1, param2)`
[Description of what it does.]

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `param1` | string | Yes | [Description] |
| `param2` | number | No | [Description, default: 42] |

**Returns:** `Promise<Result>` — [what the result contains]

**Example:**
\`\`\`javascript
const result = await functionName("hello", 42);
// result = { status: "ok", data: [...] }
\`\`\`

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development setup and guidelines.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## License

[MIT](./LICENSE) © [Your Name]
```

#### Library/Package README Template

Focus on: installation, API reference, usage examples. Less about architecture.

#### Application README Template

Focus on: features, screenshots/GIFs, installation, configuration, deployment. More about end-user experience.

#### Monorepo README Template

Focus on: package listing, how packages relate, shared tooling, development workflow.

---

### Type 2: API Documentation

#### OpenAPI 3.1 Specification Template

```yaml
openapi: "3.1.0"
info:
  title: "[API Name]"
  version: "1.0.0"
  description: |
    [What this API does, who it's for, and how to get started.]
  contact:
    name: "API Support"
    email: "api-support@example.com"
  license:
    name: "MIT"

servers:
  - url: "https://api.example.com/v1"
    description: "Production"
  - url: "https://staging-api.example.com/v1"
    description: "Staging"

security:
  - bearerAuth: []

paths:
  /users:
    get:
      operationId: listUsers
      summary: "List all users"
      description: "Returns a paginated list of users."
      tags: [Users]
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
          description: "Page number"
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
          description: "Items per page"
      responses:
        "200":
          description: "Successful response"
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UserList"
          headers:
            X-Total-Count:
              schema:
                type: integer
              description: "Total number of users"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "429":
          $ref: "#/components/responses/RateLimited"

    post:
      operationId: createUser
      summary: "Create a new user"
      tags: [Users]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateUserRequest"
      responses:
        "201":
          description: "User created"
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "400":
          $ref: "#/components/responses/BadRequest"
        "409":
          description: "User with this email already exists"

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    User:
      type: object
      required: [id, email, name, createdAt]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        role:
          type: string
          enum: [admin, user, viewer]
        createdAt:
          type: string
          format: date-time

    CreateUserRequest:
      type: object
      required: [email, name]
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        role:
          type: string
          enum: [admin, user, viewer]
          default: user

    UserList:
      type: object
      required: [data, pagination]
      properties:
        data:
          type: array
          items:
            $ref: "#/components/schemas/User"
        pagination:
          $ref: "#/components/schemas/Pagination"

    Pagination:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        total:
          type: integer
        pages:
          type: integer

  responses:
    BadRequest:
      description: "Invalid request parameters"
      content:
        application/json:
          schema:
            type: object
            properties:
              error:
                type: string
              details:
                type: array
                items:
                  type: object
                  properties:
                    field:
                      type: string
                    message:
                      type: string

    Unauthorized:
      description: "Missing or invalid authentication"
      content:
        application/json:
          schema:
            type: object
            properties:
              error:
                type: string

    RateLimited:
      description: "Rate limit exceeded"
      headers:
        Retry-After:
          schema:
            type: integer
          description: "Seconds until rate limit resets"
```

#### GraphQL API Documentation

```markdown
## Schema Overview

### Types
- **User**: Core user entity
- **Post**: Blog post or article
- **Comment**: Comment on a post

### Queries
- \`user(id: ID!)\` → User
- \`users(filter: UserFilter)\` → [User!]!
- \`post(id: ID!)\` → Post

### Mutations
- \`createUser(input: CreateUserInput!)\` → CreateUserPayload
- \`updateUser(id: ID!, input: UpdateUserInput!)\` → UpdateUserPayload

### Subscriptions
- \`onPostCreated\` → Post (real-time notification)
```

---

### Type 3: Architecture Decision Record (ADR)

ADRs capture important architectural decisions with context and consequences.

```markdown
# ADR-[Number]: [Title]

**Status:** [Proposed | Accepted | Deprecated | Superseded by ADR-XXX]
**Date:** [YYYY-MM-DD]
**Deciders:** [names/roles]
**Technical Story:** [link to issue/ticket]

## Context

[What is the issue that we're seeing that motivates this decision or change?
What forces are at play (technical, political, social, project)?]

## Decision

[What is the change that we're proposing and/or doing? State it clearly
and concisely. What is the solution to the forces at play?]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Cost 1]
- [Cost 2]

### Risks
- [Risk 1 and mitigation]

## Alternatives Considered

### Alternative A: [Name]
[Description]
**Why rejected:** [reason]

### Alternative B: [Name]
[Description]
**Why rejected:** [reason]

## References
- [Link 1]
- [Link 2]
```

---

### Type 4: RFC (Request for Comments)

RFCs are for proposing significant changes before implementation.

```markdown
# RFC-[Number]: [Title]

**Author:** [name]
**Status:** [Draft | Review | Accepted | Rejected | Implemented]
**Created:** [date]
**Updated:** [date]

## Summary

[2-3 sentences: what is this RFC proposing?]

## Motivation

[Why are we doing this? What problem does it solve?
What happens if we do nothing?]

## Detailed Design

[The meat of the proposal. Be specific about:
- New APIs, interfaces, or data structures
- Changes to existing behavior
- Migration path from current state
- How this integrates with existing systems]

\`\`\`
[Code examples, diagrams, or pseudocode]
\`\`\`

## Alternatives

[What other approaches were considered? Why were they rejected?]

## Migration Plan

[How do we get from current state to proposed state?
What's the rollout strategy?]

## Testing

[How will we verify this works? What test scenarios need coverage?]

## Open Questions

- [Question 1 that needs resolution]
- [Question 2 that needs resolution]

## References

- [Related ADRs, issues, or external resources]
```

---

### Type 5: Design Doc

```markdown
# Design Doc: [Feature/Component Name]

**Author:** [name]
**Status:** [Draft | In Review | Approved | Implemented]
**Date:** [date]

## Overview

[What are we building and why? 2-3 sentences.]

## Goals and Non-Goals

### Goals
- [Goal 1 — measurable if possible]
- [Goal 2]

### Non-Goals
- [Non-goal 1 — what we're explicitly NOT doing]
- [Non-goal 2]

## Architecture

[High-level architecture diagram or description]

\`\`\`
[ASCII diagram or link to diagram]
\`\`\`

## Data Model

[New or changed data structures, schemas, database tables]

## API Design

[New or changed endpoints, functions, or interfaces]

## Implementation Plan

[Key implementation steps and their order]

## Performance Considerations

[Expected performance characteristics, benchmarks, load estimates]

## Security Considerations

[Authentication, authorization, data privacy, attack surface]

## Alternatives

[Other approaches considered and why they were rejected]
```

---

### Type 6: Runbook

Operational procedures for production systems.

```markdown
# Runbook: [Service/System Name]

**Owner:** [team/person]
**Last Updated:** [date]
**On-call rotation:** [link]

## Overview

[What this service does, its criticality, and typical failure modes.]

## Architecture

\`\`\`
[Diagram of components, data flow, and dependencies]
\`\`\`

## Common Procedures

### Restarting the Service
\`\`\`bash
# Step 1: Check current status
kubectl get pods -n [namespace] -l app=[service]

# Step 2: Check logs for errors
kubectl logs -n [namespace] -l app=[service] --tail=100

# Step 3: Restart if needed
kubectl rollout restart deployment/[service] -n [namespace]

# Step 4: Verify recovery
kubectl get pods -n [namespace] -l app=[service] -w
\`\`\`

**Expected:** Pods go from Running → Terminating → Running within 2 minutes.
**If not recovered:** Escalate to [team/person].

### Scaling Up
\`\`\`bash
# Current replicas: [N]
kubectl scale deployment/[service] --replicas=[N+2] -n [namespace]
\`\`\`

### Database Failover
[Step-by-step procedure with expected outputs at each step.]

## Alerting

| Alert | Meaning | Action |
|-------|---------|--------|
| HighErrorRate | > 5% 5xx responses for 5 min | Check logs, restart if needed |
| HighLatency | p95 > 2s for 10 min | Check downstream services, scale up |
| DiskFull | > 85% disk usage | Clean logs, expand volume |
| MemoryPressure | > 90% memory usage | Check for memory leaks, restart |

## Troubleshooting

### Symptom: Users report 500 errors
1. Check: `kubectl logs -l app=[service] --tail=50`
2. If database connection errors: Check database health
3. If timeout errors: Check downstream service health
4. If OOM errors: Check memory limits, increase if needed

### Symptom: Slow response times
1. Check: Monitoring dashboard for latency breakdown
2. If database slow: Run `EXPLAIN ANALYZE` on slow queries
3. If CPU high: Check for infinite loops, scale up
4. If network high: Check external service dependencies

## Contacts

| Role | Name | Contact |
|------|------|---------|
| Service Owner | [name] | [slack/email] |
| On-call | [rotation] | [pagerduty link] |
| DBA | [name] | [contact] |
```

---

### Type 7: Postmortem

```markdown
# Postmortem: [Incident Title]

**Date:** [incident date]
**Author:** [name]
**Status:** [Draft | Reviewed | Final]
**Severity:** [SEV1 | SEV2 | SEV3 | SEV4]
**Duration:** [start time] — [end time] ([total duration])

## Summary

[2-3 sentences: What happened, when, and what was the impact?]

## Impact

- **Users affected:** [number or percentage]
- **Duration:** [time]
- **Revenue impact:** [estimated, if applicable]
- **Data loss:** [none / describe]
- **SLA impact:** [how this affected our SLA commitments]

## Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First detection — alert fires or user report] |
| HH:MM | [Investigation begins] |
| HH:MM | [Root cause identified] |
| HH:MM | [Mitigation applied] |
| HH:MM | [Service fully recovered] |

## Root Cause

[Detailed explanation of what caused the incident.
Be specific about the chain of events.
Include code snippets or config changes if relevant.]

## Detection

- **How was it detected?** [alert / user report / monitoring]
- **Time to detect:** [minutes]
- **Could it have been detected sooner?** [how?]

## Mitigation

[What was done to stop the bleeding? Was it the right response?]

## Resolution

[What was done to fully fix the issue?]

## What Went Well

- [Thing 1 that worked well during the incident]
- [Thing 2]

## What Went Poorly

- [Thing 1 that didn't work well]
- [Thing 2]

## Where We Got Lucky

- [Thing that could have been much worse]

## Action Items

| # | Action | Owner | Due | Priority | Status |
|---|--------|-------|-----|----------|--------|
| 1 | [Preventive action] | [name] | [date] | P0 | ⬜ |
| 2 | [Detection improvement] | [name] | [date] | P1 | ⬜ |
| 3 | [Process improvement] | [name] | [date] | P2 | ⬜ |

## Lessons Learned

[What did we learn that should change how we operate?
What should other teams know?]
```

---

### Type 8: CONTRIBUTING.md

```markdown
# Contributing to [Project Name]

Thank you for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/you/project.git`
3. Create a branch: `git checkout -b feature/my-feature`
4. Install dependencies: `[command]`
5. Make your changes
6. Run tests: `[command]`
7. Submit a pull request

## Development Setup

### Prerequisites
- [Tool 1] version [X.Y.Z+]
- [Tool 2] version [X.Y.Z+]

### Environment
\`\`\`bash
[setup commands]
\`\`\`

## Code Style

- [Linting rules]
- [Formatting rules]
- [Naming conventions]

## Pull Request Guidelines

- One feature/fix per PR
- Include tests for new functionality
- Update documentation if needed
- Write clear commit messages following [convention]
- PRs should be reviewable in < 30 minutes

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

\`\`\`
feat: add user authentication endpoint
fix: resolve race condition in cache invalidation
docs: update API reference for v2
\`\`\`

## Reporting Issues

- Use the issue template
- Include: steps to reproduce, expected behavior, actual behavior
- Include environment details (OS, browser, versions)

## Code of Conduct

[Link to or inline code of conduct]
```

---

## Documentation for Different Audiences

### End-User Documentation

- **Tone:** Friendly, non-technical, task-oriented
- **Structure:** "How to do X" with screenshots/GIFs
- **Avoid:** Jargon, code examples, internal architecture details
- **Include:** Step-by-step instructions, expected outcomes at each step, troubleshooting tips

### Developer Documentation

- **Tone:** Technical, precise, reference-oriented
- **Structure:** API reference, code examples, architecture diagrams
- **Avoid:** Hand-waving, vague descriptions, "it depends"
- **Include:** Working code examples, type signatures, error handling, edge cases

### Operations Documentation

- **Tone:** Direct, procedural, action-oriented
- **Structure:** Runbooks with numbered steps, expected outputs, and rollback procedures
- **Avoid:** Theory, long explanations, assuming context
- **Include:** Exact commands, monitoring queries, alert definitions, escalation paths

---

## Documentation Tooling Recommendations

| Tool | Best For | Type |
|------|----------|------|
| **MkDocs + Material theme** | Static documentation site | User/Developer docs |
| **Docusaurus** | Feature-rich documentation sites | Multi-audience docs |
| **Swagger UI / Redoc** | Interactive API docs | API reference |
| **Storybook** | Component documentation | UI component docs |
| **JSDoc / TypeDoc / rustdoc** | Code-level documentation | Inline code docs |
| **Madoko / Pandoc** | Formal documents from Markdown | RFCs, design docs |
| **Readme.so** | Quick README building | Project READMEs |
| **Notion / Confluence** | Collaborative internal docs | Team knowledge base |
| **GitHub Wiki** | Project-attached documentation | Open-source projects |
| **dbt docs** | Data pipeline documentation | Data/Analytics |

---

## Documentation as Code Patterns

### Pattern 1: Docs in Repository

Store documentation in the same repo as code. Changes to docs ship with code changes.

```
project/
├── src/
├── docs/
│   ├── getting-started.md
│   ├── api-reference.md
│   ├── architecture.md
│   └── contributing.md
├── README.md
└── mkdocs.yml
```

**Best for:** Projects where docs must stay in sync with code.

### Pattern 2: Docs as Code (GitBook/ReadMe)

Use a docs platform that reads from a git repo but renders beautifully.

**Best for:** Public-facing documentation that needs good SEO and styling.

### Pattern 3: Auto-Generated Documentation

Generate docs from code annotations (JSDoc, docstrings, OpenAPI specs).

**Best for:** API reference docs, code-level documentation. Reduces drift between code and docs.

### Pattern 4: Changelog Automation

Use tools like `conventional-changelog` or `release-please` to auto-generate changelogs from commit messages.

```bash
# Add to CI/CD pipeline
npx conventional-changelog -p angular -i CHANGELOG.md -s
```

---

## Documentation Maintenance Patterns

### Freshness Checklist (Monthly)

- [ ] All code examples still work with current versions
- [ ] Installation instructions are current
- [ ] API docs match actual endpoints
- [ ] Configuration options are complete and accurate
- [ ] Links are not broken
- [ ] Version numbers are current
- [ ] Screenshots/GIFs still match the UI

### Documentation Debt Tracking

Track documentation issues like code issues:

```
## Documentation Debt
- [ ] README Quick Start example is outdated (since v2.1)
- [ ] API docs missing new /users/:id/roles endpoint
- [ ] CONTRIBUTING.md doesn't mention required Node version
- [ ] Runbook missing procedure for new service deployment
```

### Documentation Review in PRs

Add to PR template:
```
## Documentation
- [ ] Updated relevant docs (README, API docs, CHANGELOG)
- [ ] Added/updated code comments for new functions
- [ ] No documentation needed (explain why)
```

---

## Workflow

### Step 1: Understand the Project

Before writing a single word, understand what you're documenting.

1. **Read the codebase** — Use Glob to find key files, then Read them. Look for:
   - Package.json, setup.py, Cargo.toml, go.mod (project metadata)
   - Existing README or docs (to improve, not start from scratch)
   - Entry points and main modules
   - Configuration files
2. **Identify the audience** — Ask or infer who will read this:
   - End users? Developers integrating a library? Internal teammates? New hires?
3. **Identify the doc type** — README ≠ API reference ≠ tutorial ≠ architecture doc ≠ runbook ≠ postmortem. Each has different structure and tone.

### Step 2: Gather Information

1. **For README files**: Identify project purpose, installation steps, usage examples, configuration options, and contribution guidelines.
2. **For API docs**: Find route definitions, request/response schemas, authentication methods, and error codes. Read the actual handler code.
3. **For user guides**: Understand the user workflow. What tasks do they need to accomplish? What's the happy path vs. edge cases?
4. **For code docs (docstrings)**: Read the function signatures, understand parameters, return values, and side effects.
5. **For ADRs/Design Docs**: Read existing ADRs to understand the format and conventions. Talk to stakeholders about the decision context.
6. **For Runbooks**: Talk to on-call engineers about common procedures, failure modes, and troubleshooting steps.
7. **For Postmortems**: Read incident timelines, chat logs, and monitoring dashboards.

### Step 3: Write the Documentation

Follow the structure appropriate for the doc type. Use the templates from this skill as starting points. Customize to fit the project's needs.

### Step 4: Validate and Refine

1. **Accuracy check** — Do the code examples actually work? Do the installation commands match the project's build system?
2. **Completeness check** — Are all public APIs documented? Are all configuration options listed?
3. **Clarity check** — Can someone unfamiliar with the project follow along? Remove jargon or define it.
4. **Formatting** — Use consistent heading levels, code blocks with language tags, and proper markdown.
5. **Audience check** — Does the tone and depth match the intended reader?

---

## Output Format

- Output in Markdown unless the user specifies another format (e.g., AsciiDoc, reStructuredText)
- Use fenced code blocks with language identifiers
- Include working code examples that can be copy-pasted
- Use tables for configuration options and parameter lists
- Keep paragraphs short (2-3 sentences max)
- Use the user's language for explanatory text; keep code and technical identifiers in English

---

## Principles

- **Show, don't tell.** A working code example beats a paragraph of explanation.
- **Start with the simplest thing that works.** Progress to advanced usage gradually.
- **Keep it updatable.** Avoid documenting implementation details that change frequently.
- **Don't document what's obvious from the code.** Document intent, constraints, and gotchas.
- **Be honest about limitations.** If something doesn't work, say so explicitly.
- **Write for the reader, not yourself.** You already know how it works — they don't.
- **One document, one audience.** Don't mix end-user and developer documentation.
- **Maintain documentation like code.** Track debt, review in PRs, keep it fresh.
- **Version your docs** when you version your API or make breaking changes.
