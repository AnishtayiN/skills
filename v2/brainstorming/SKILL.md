---
name: brainstorming
description: >-
  Ideation, brainstorming, and exploring alternative solutions for any problem — technical, product, or creative. Use this skill when the user wants to brainstorm, ایده‌پردازی, طوفان فکری, explore alternatives, generate ideas, help me think of solutions, what are my options, I need ideas, come up with alternatives, think creatively, list possible approaches, what's the best way to do X, how could I solve this, suggest some approaches, pros and cons of different approaches, compare approaches, creative solutions, out-of-the-box thinking, innovate, design thinking session, ideation session, help me decide between options, weigh alternatives, give me choices, show me options, what are the alternatives, alternative approaches, think outside the box, راه حل, ایده جدید, روش جایگزین, مقایسه روش‌ها, بهترین راه حل, چطوری حل کنم, بهم ایده بده, طوفان فکری کن, ایده‌های خلاقانه, روش‌های مختلف, مقایسه مزایا و معایب, فکر کنم, راهکار پیشنهاد بده, پیشنهاد بده, گزینه‌ها چیه, چه راه‌هایی داریم, چطور میشه اینو حل کرد, روش‌های نوآورانه, ایده‌سازی, جلسه ایده‌پردازی, تصمیم‌گیری بین گزینه‌ها, تحلیل گزینه‌ها, مزایا و معایب, روش‌های جایگزین, نقطه ضعف و نقطه قوت.
---

# Brainstorming Skill — Ideation & Alternative Exploration

## Overview

This skill facilitates structured ideation sessions. Instead of jumping to the first solution that comes to mind, it forces breadth-first exploration of the solution space before converging on the best option. Good brainstorming is about quantity first, quality second — and separating generation from evaluation.

## When to Use This Skill

- User asks for ideas, alternatives, or options for a problem
- User is stuck and needs creative approaches
- User wants to compare multiple approaches before committing
- User asks "what's the best way to..." or "how should I..."
- User wants a pros/cons analysis of different approaches
- User needs to decide between multiple technologies or patterns
- User wants to innovate or find unconventional solutions
- User needs to evaluate build vs. buy decisions
- User is designing a feature and doesn't know which approach to take

## Brainstorming Workflow

### Phase 1: Understand the Problem

1. **Identify the core problem** — Strip away assumptions. What is the user actually trying to achieve? Often the stated problem is a symptom, not the root.
2. **Clarify constraints** — Ask about or infer:
   - Time and budget constraints
   - Technology stack limitations
   - Team size and expertise
   - Non-negotiable requirements (compliance, performance, scale)
   - Nice-to-haves vs. must-haves
3. **Define success criteria** — What does "done" look like? How will the user evaluate which idea is best?
4. **Identify stakeholders** — Who will use, review, or be affected by the solution?
5. **Determine the problem class** — Is this a solved problem with known patterns, or a novel domain?

### Phase 2: Generate Options (Diverge)

Generate at least 4-6 distinct approaches. Do NOT evaluate them yet. Categories to pull from:

- **Obvious/standard approach** — The conventional, well-documented way
- **Minimal approach** — What's the simplest thing that could work?
- **Over-engineered approach** — Design for 10x the current requirement (useful as a reference point)
- **Unconventional approach** — Flip assumptions, use an unusual technology, or borrow from a different domain
- **Hybrid approach** — Combine elements from 2+ of the above
- **Buy vs. build** — Can an existing tool, library, or service handle this?
- **Defer approach** — What if we don't solve this at all? Can we work around it?

For each approach, write a one-line summary of the core idea.

### Phase 3: Evaluate Options (Converge)

For each approach, assess against these dimensions:

| Dimension | Question |
|-----------|----------|
| **Feasibility** | Can this actually be built with the given constraints? |
| **Complexity** | How much effort? How many moving parts? |
| **Scalability** | Does it handle growth? |
| **Maintainability** | Will future developers understand and modify it? |
| **Risk** | What could go wrong? What are the unknowns? |
| **Time-to-value** | How quickly can the user get results? |
| **Cost** | Infrastructure, licensing, and maintenance cost? |
| **Team fit** | Does the team have the skills, or is there a learning curve? |

### Phase 4: Recommend

1. **Rank** the options based on the user's constraints and priorities
2. **Pick a top recommendation** and explain why
3. **Present the trade-off** — what is the user giving up by choosing this path?
4. **Offer a runner-up** in case the top choice has hidden blockers
5. **Suggest a decision framework** — What should the user consider to make the final call?

## Advanced Techniques

### 1. Inversion Thinking (Reverse Brainstorming)

Instead of asking "how do we solve this?", ask "how do we make this worse?" The answers reveal what to avoid and often surface hidden risks. Then invert each anti-solution into a positive approach.

```
Problem: "How to improve API response times?"
Inverted: "How to make API response times terrible?"
→ Remove all caching → Add strategic caching layer
→ Query entire database on every request → Use pagination + selective fields
→ Single-threaded processing → Add async job queues for heavy work
```

### 2. Constraint Removal

Temporarily remove a major constraint and brainstorm as if it didn't exist. This reveals approaches that might be partially viable even with the constraint.

```
Constraint: "We only have $0 budget (open source only)"
Without constraint: "Use Datadog, Sentry, LaunchDarkly, Algolia"
Reflected back: "Prometheus + Grafana, self-hosted Sentry, feature flags in-code, PostgreSQL full-text search"
```

### 3. SCAMPER Framework

Apply each SCAMPER verb to the problem:
- **S**ubstitute — What component can be replaced?
- **C**ombine — Can two approaches be merged?
- **A**dapt — Can we borrow from another domain/industry?
- **M**odify — What if we changed the scale or timing?
- **P**ut to other use — Can this solve a different problem?
- **E**liminate — What if we removed a requirement entirely?
- **R**everse — What if we did the opposite?

### 4. Time-Boxed Forced Output

Generate options under artificial time pressure. Force exactly N options in rapid succession. The first 2-3 will be obvious; options 4+ will be more creative because obvious answers are exhausted.

### 5. Analogy Mapping

Map the current problem to a well-solved problem in another domain:

```
Problem: "How to handle concurrent edits to a document?"
Analogy: "Version control (Git) handles concurrent code edits"
→ Operational transforms or CRDTs (like Git merge but for documents)

Problem: "How to throttle API requests fairly?"
Analogy: "Traffic lights manage intersection flow"
→ Token bucket algorithm with priority lanes for critical requests
```

### 6. Worst-Case Scenario Analysis

For each option, describe the worst realistic outcome. Then assess: (a) how likely is it, (b) can we recover from it, (c) is it acceptable? This prevents analysis paralysis by quantifying fear.

### 7. Pareto Front Analysis

Plot options on a 2D grid (e.g., effort vs. impact). Identify the Pareto front — options where no other option is better on both axes. These are the only ones worth serious consideration.

## Common Patterns

### Pattern 1: Build vs. Buy Decision

```markdown
## Build vs. Buy: Authentication System

### Option A: Build Custom Auth
- **Idea:** Implement JWT auth from scratch with refresh tokens
- **Pros:** Full control, no vendor lock-in, custom flows
- **Cons:** Security risk, weeks of development, ongoing maintenance
- **Effort:** High (3-4 weeks)
- **Best for:** Products with unique auth requirements (SAML, hardware keys)

### Option B: Use Auth0 / Clerk / Supabase Auth
- **Idea:** Delegate auth to a managed identity provider
- **Pros:** Production-ready in hours, SOC2 compliant, MFA built-in
- **Cons:** Vendor dependency, cost scales with users, limited customization
- **Effort:** Low (1-2 days)
- **Best for:** Standard SaaS apps that need to ship fast

### Recommendation
→ **Option B (Clerk)** for most teams. Switch to Option A only if
  compliance requirements prohibit third-party auth providers.
```

### Pattern 2: Architecture Style Selection

```markdown
## Monolith vs. Microservices vs. Modular Monolith

### Option A: Monolith
- **Idea:** Single deployable unit, shared database
- **Best for:** Teams < 5, MVP stage, simple domain

### Option B: Microservices
- **Idea:** Independent services, separate databases, API gateway
- **Best for:** Teams > 10, complex domain, independent scaling needs

### Option C: Modular Monolith
- **Idea:** Single deployable with strict module boundaries
- **Best for:** Teams 5-10, transitioning from monolith, domain complexity growing
```

### Pattern 3: Caching Strategy Selection

```markdown
## Caching Approaches: Product Catalog API

### Option A: Application-Level Cache (in-memory, LRU)
- **Idea:** Node.js `lru-cache` for hot products
- **Best for:** Single instance, < 10K SKUs, simple invalidation

### Option B: Redis Cache Layer
- **Idea:** Redis with TTL + write-through invalidation
- **Best for:** Multi-instance, > 10K SKUs, need shared cache state

### Option C: CDN + Edge Caching
- **Idea:** Cloudflare Workers / Vercel Edge with stale-while-revalidate
- **Best for:** Public APIs, global users, read-heavy, acceptable staleness

### Option D: Database Query Cache
- **Idea:** PostgreSQL materialized views refreshed on schedule
- **Best for:** Complex aggregations, acceptable minute-level staleness
```

### Pattern 4: State Management in Frontend

```markdown
## State Management: React Application

### Option A: React Context + useReducer
- **Idea:** Built-in React state, no dependencies
- **Best for:** Small apps, shallow state trees, minimal re-renders

### Option B: Zustand
- **Idea:** Lightweight store with hooks-based API
- **Best for:** Medium apps, want simplicity, minimal boilerplate

### Option C: Redux Toolkit
- **Idea:** Full-featured store with middleware ecosystem
- **Best for:** Large apps, complex async flows, team needs strict patterns

### Option D: TanStack Query (Server State)
- **Idea:** Cache server data separately from client state
- **Best for:** Data-heavy apps, API interactions, real-time updates
```

### Pattern 5: Background Job Processing

```markdown
## Background Jobs: Email Notifications

### Option A: In-Process Queue (BullMQ in same Node process)
- **Idea:** Redis-backed queue, same deployment
- **Best for:** Low volume (< 1K/day), simple infrastructure

### Option B: Separate Worker Process
- **Idea:** Dedicated Node process consuming from Redis/RabbitMQ
- **Best for:** Medium volume, want isolation from API servers

### Option C: Managed Queue (AWS SQS + Lambda)
- **Idea:** Cloud-native queue with serverless consumers
- **Best for:** Variable load, AWS ecosystem, pay-per-use

### Option D: Third-Party (Resend / SendGrid with webhooks)
- **Idea:** Offload entirely to email service provider
- **Best for:** Teams without DevOps capacity, need deliverability
```

## Edge Cases & Pitfalls

1. **Premature convergence** — User presents one idea and you just validate it instead of exploring alternatives. Always generate at least 3 options regardless.

2. **Analysis paralysis** — Generating 20 options when 5 would suffice. If options are too similar, group them. Present 4-7 distinct approaches maximum.

3. **Ignoring hidden constraints** — The user might not mention compliance, legal, or organizational constraints. Always ask or flag assumptions.

4. **Technology bias** — Recommending your favorite stack instead of the best fit. Evaluate against the user's actual constraints, not your preferences.

5. **Feature creep during ideation** — Each option should solve the stated problem, not the stated problem plus three more features.

6. **Underestimating integration cost** — "Just use microservices" ignores the cost of service-to-service communication, data consistency, and operational complexity.

7. **Assuming the user wants the cheapest option** — Some users prefer robust over cheap. Always clarify priorities before ranking.

8. **Ignoring the team's skill gap** — Recommending Kubernetes to a team that has never used Docker. Factor learning curve into effort estimates.

9. **Presenting options without a recommendation** — The user wants help deciding, not a homework assignment. Always rank and recommend.

10. **Failing to identify the real problem** — The user says "I need a real-time database" but the real problem is "I need optimistic UI updates." Solve the right problem.

11. **Over-indexing on current state** — Designing for the current user count when the product is about to launch. Consider growth trajectory.

12. **Ignoring operational cost** — A $0 open-source solution with 40 hours of setup is not "free." Account for total cost of ownership.

13. **Not considering the "do nothing" option** — Sometimes the best action is to defer, simplify requirements, or accept the current state.

14. **Confirmation bias in evaluation** — Having a favorite option and scoring it higher on every dimension. Use objective criteria and force honest comparison.

15. **Missing the hybrid path** — The best answer is often "use Option A for X and Option B for Y" rather than pure Option A or B.

## Integration with Other Skills

| Skill | When to Chain | How It Connects |
|-------|---------------|-----------------|
| **task-planning** | After selecting an approach | Turn the recommended option into a concrete task breakdown |
| **system-design** | When brainstorming architecture | Deep-dive the chosen architecture into components and data flow |
| **database-schema** | When brainstorming data modeling | Convert the data model discussion into concrete SQL/ORM schemas |
| **fullstack-dev** | When a web solution is chosen | Implement the brainstormed approach as actual code |
| **web-search** | When evaluating third-party tools | Research pricing, features, and community sentiment for buy options |
| **charts** | When comparing options visually | Create a comparison matrix or decision tree diagram |

## Output Format Templates

### Template 1: Standard Decision Matrix

```markdown
## Brainstorming Session: [Problem Statement]

### Problem Understanding
[Brief restatement of the core problem and key constraints]

### Options Explored

#### Option 1: [Name]
- **Idea:** [one-line description]
- **Pros:** [2-3 bullet points]
- **Cons:** [2-3 bullet points]
- **Effort:** [Low/Medium/High]
- **Cost:** [Free/$/高昂]
- **Risk:** [Low/Medium/High]
- **Best for:** [when this option shines]

#### Option 2: [Name]
...

### Decision Matrix
| Criteria (weight) | Option 1 | Option 2 | Option 3 |
|-------------------|----------|----------|----------|
| Feasibility (25%) | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Effort (20%) | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Scalability (20%) | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Time-to-value (20%) | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Team Fit (15%) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Weighted Total** | **3.65** | **3.00** | **3.40** |

### Recommendation
**→ [Option X]** is the best fit because [reason].
**Key trade-off:** You gain [benefit] but accept [cost].
**Runner-up:** [Option Y] if [condition changes].
```

### Template 2: Quick Comparison (for simpler problems)

```markdown
## Quick Comparison: [Topic]

| Approach | Pros | Cons | Effort | Verdict |
|----------|------|------|--------|---------|
| [A] | ... | ... | Low | ✅ Best for [case] |
| [B] | ... | ... | Med | Good for [case] |
| [C] | ... | ... | High | Only if [condition] |

**TL;DR:** Go with [A] unless [condition], then [B].
```

### Template 3: Deep-Dive with Decision Tree

```markdown
## Brainstorming: [Problem]

### Decision Framework
```
Start → Do you need [criterion]?
  ├─ Yes → Do you have [constraint]?
  │    ├─ Yes → Option A: [description]
  │    └─ No → Option B: [description]
  └─ No → Option C: [description]
```

### Detailed Options
[Full write-up of each option]

### Recommendation
[Ranked recommendation with reasoning]
```

### Template 4: Pros-Cons-Verdict with Risk Assessment

```markdown
## Analysis: [Problem]

### Options

#### 1. [Name] — [one-liner]
| Aspect | Detail |
|--------|--------|
| ✅ Pros | [list] |
| ❌ Cons | [list] |
| ⚠️ Risks | [list] |
| 🏗️ Effort | [estimate] |
| 💰 Cost | [estimate] |
| 🎯 Verdict | [summary] |

### Final Ranking
1. **[Option A]** — [why first]
2. **[Option B]** — [why second]
3. **[Option C]** — [why third]

### What to Watch Out For
[Key risk or unknown that could change the recommendation]
```

## Rules

- **Never present fewer than 3 options** unless the problem is truly trivial
- **Do not evaluate during generation** — list all ideas first, then judge
- **Be concrete** — "use Redis for caching" is better than "use caching"
- **Include code-level specifics** when the user is a developer — library names, patterns, architecture choices
- **Flag unknowns** — if you're unsure about a constraint, say so rather than guessing
- **Keep it concise** — one paragraph per option max during generation; expand only on the recommended path
- **Always rank and recommend** — don't dump options and walk away
- **Consider the "do nothing" option** — explicitly state if the problem can be deferred or simplified away
- **Adapt depth to complexity** — use the Quick Comparison template for simple problems, full matrix for strategic decisions
- **Be honest about trade-offs** — every option has downsides; stating them builds trust
