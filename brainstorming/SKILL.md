---
name: brainstorming
description: >-
  Ideation, brainstorming, and exploring alternative solutions for any problem — technical, product, or creative. Use this skill when the user wants to brainstorm, ایده‌پردازی, طوفان فکری, explore alternatives, generate ideas, help me think of solutions, what are my options, I need ideas, come up with alternatives, think creatively, list possible approaches, what's the best way to do X, how could I solve this, suggest some approaches, pros and cons of different approaches, compare approaches, creative solutions, out-of-the-box thinking, innovate, design thinking session, ideation session, help me decide between options, weigh alternatives, SCAMPER, six thinking hats, mind mapping, analogical thinking, reverse brainstorming, decision matrix, structured evaluation, convergent thinking, or facilitated group brainstorming.
---

# Brainstorming Skill — Ideation & Alternative Exploration

## Overview

This skill facilitates structured ideation sessions. Instead of jumping to the first solution that comes to mind, it forces breadth-first exploration of the solution space before converging on the best option. Good brainstorming is about **quantity first, quality second** — and separating generation from evaluation. This skill covers multiple ideation techniques, evaluation frameworks, convergent thinking strategies, and facilitation patterns for group sessions.

## When to Use This Skill

- User asks for ideas, alternatives, or options for a problem
- User is stuck and needs creative approaches
- User wants to compare multiple approaches before committing
- User asks "what's the best way to..." or "how should I..."
- User wants a pros/cons analysis of different approaches
- User wants to explore unconventional or creative solutions
- User needs to make a decision between multiple viable options
- User mentions brainstorming, ideation, or creative problem-solving

---

## Phase 1: Understand the Problem

Before generating any ideas, deeply understand what needs solving.

1. **Identify the core problem** — Strip away assumptions. What is the user actually trying to achieve? Often the stated problem is a symptom, not the root.
2. **Reframe the problem** — Restate it as a question:
   - "How might we...?" (HMW) — opens creative space
   - "In what ways could we...?" — invites multiple solutions
   - "What would it look like if...?" — enables impossible-feeling ideas
3. **Clarify constraints** — Ask about or infer:
   - Time and budget constraints
   - Technology stack limitations
   - Team size and expertise
   - Non-negotiable requirements (compliance, performance, scale)
   - Nice-to-haves vs. must-haves
4. **Define success criteria** — What does "done" look like? How will the user evaluate which idea is best?

---

## Phase 2: Generate Options (Diverge)

### Standard Divergent Categories

Generate at least 4-6 distinct approaches. Do NOT evaluate them yet. Categories to pull from:

- **Obvious/standard approach** — The conventional, well-documented way
- **Minimal approach** — What's the simplest thing that could work?
- **Over-engineered approach** — Design for 10x the current requirement (useful as a reference point)
- **Unconventional approach** — Flip assumptions, use an unusual technology, or borrow from a different domain
- **Hybrid approach** — Combine elements from 2+ of the above
- **Buy vs. build** — Can an existing tool, library, or service handle this?

For each approach, write a one-line summary of the core idea.

### Ideation Technique 1: SCAMPER

SCAMPER is a structured creativity framework that applies 7 operation types to existing solutions:

| Operation | Question to Ask | Example |
|-----------|----------------|---------|
| **Substitute** | What component, material, or process can be replaced? | "Replace REST with GraphQL for this API" |
| **Combine** | What features or processes can be merged? | "Combine auth and user management into one service" |
| **Adapt** | What can be borrowed from another solution? | "Adopt Stripe's idempotency pattern for our payments" |
| **Modify** | What can be enlarged, minimized, or reshaped? | "Make the cache TTL configurable per endpoint" |
| **Put to other use** | Can this serve a different audience or context? | "Repurpose the admin dashboard as a customer portal" |
| **Eliminate** | What can be removed entirely? | "Drop the sync step — async is fine" |
| **Reverse** | What if we did the opposite? | "Instead of push notifications, let users pull on-demand" |

**When to use:** When you have an existing solution that needs improvement or when you need to systematically explore variations.

### Ideation Technique 2: Six Thinking Hats

Evaluate the problem from six distinct perspectives, one at a time:

```
🎩 White Hat (Facts & Data):
What do we know for certain? What data is available?
- [List factual information]

🔴 Red Hat (Emotions & Intuition):
What's your gut feeling? What does instinct say?
- [List emotional/intuitive responses]

⚫ Black Hat (Caution & Risks):
What could go wrong? What are the weaknesses?
- [List risks and potential failures]

🟡 Yellow Hat (Optimism & Benefits):
What's the best case? What are the opportunities?
- [List benefits and positive outcomes]

🟢 Green Hat (Creativity & Alternatives):
What wild ideas haven't been considered?
- [List creative/unconventional ideas]

🔵 Blue Hat (Process & Next Steps):
How do we organize this? What's the decision framework?
- [List process decisions and next actions]
```

**When to use:** Complex decisions with emotional, technical, and strategic dimensions. When the team is stuck in one perspective. For stakeholder communication — helps present balanced analysis.

### Ideation Technique 3: Mind Mapping

Create a visual/structured expansion of the problem space:

```
## Mind Map: [Problem Statement]

                    ┌── [Sub-topic A]
                    │   ├── [Idea A1]
                    │   └── [Idea A2]
[Core Problem] ─────┼── [Sub-topic B]
                    │   ├── [Idea B1]
                    │   ├── [Idea B2]
                    │   └── [Idea B3]
                    ├── [Sub-topic C]
                    │   └── [Idea C1]
                    └── [Sub-topic D]
                        ├── [Idea D1]
                        └── [Idea D2]
```

**When to use:** Exploring a topic with multiple dimensions. Visual thinkers. Organizing large idea sets before evaluation.

### Ideation Technique 4: Analogical Thinking

Borrow solutions from unrelated domains:

```
## Analogical Brainstorming

**Our problem:** [Problem in our domain]

**Analogous problems in other domains:**
1. How does the airline industry handle [analogous aspect]?
   → Adapt: [borrowed idea]
2. How does nature solve [analogous aspect]?
   → Adapt: [borrowed idea]
3. How does gaming handle [analogous aspect]?
   → Adapt: [borrowed idea]
4. How does healthcare handle [analogous aspect]?
   → Adapt: [borrowed idea]
```

**When to use:** When direct approaches are exhausted. When you want truly novel solutions. When the problem has been solved well in another domain.

**Example:**
```
Our problem: How to handle concurrent database writes without conflicts.
- Airline industry: Overbooking strategy → Over-provision capacity, handle conflicts after the fact
- Nature: Ant colony pheromone trails → Distributed consensus via gossip protocol
- Gaming: Turn-based systems → Optimistic concurrency with version stamps
- Healthcare: Triage system → Priority queues for write operations
```

### Ideation Technique 5: Reverse Brainstorming

Start with the opposite of what you want, then flip the solutions:

```
## Reverse Brainstorming

**Goal:** Make the API fast and reliable.

**Reverse question:** How could we make the API slow and unreliable?
1. Add synchronous database calls in every request
2. Use no caching at all
3. Block on every external service call
4. Log everything at DEBUG level in production
5. Store large files in the request/response path

**Flipped solutions:**
1. → Use async I/O and connection pooling
2. → Implement multi-layer caching (Redis + in-memory)
3. → Use circuit breakers and bulkheads for external calls
4. → Use structured logging at appropriate levels
5. → Use object storage (S3) for large files, reference by URL
```

**When to use:** When you're stuck on what to do. When the problem feels too broad. When you want to identify failure modes proactively.

---

## Industry-Specific Brainstorming Patterns

### Software Architecture Decisions
```
1. What are the access patterns? (read-heavy vs. write-heavy)
2. What's the consistency requirement? (strong vs. eventual)
3. What's the scale target? (users, requests/sec, data volume)
4. What existing infrastructure can we leverage?
5. What are the failure modes and recovery requirements?
```

### Product Feature Brainstorming
```
1. What user pain point does this solve?
2. Who is the primary user persona?
3. What's the MVP vs. full feature set?
4. What's the engagement/retention mechanism?
5. What metrics will define success?
6. What are the competitive alternatives?
```

### DevOps / Infrastructure
```
1. What's the blast radius if this fails?
2. What's the recovery time objective (RTO)?
3. What's the recovery point objective (RPO)?
4. What monitoring and alerting is needed?
5. What's the rollback strategy?
6. What's the cost impact at 10x scale?
```

### Startup / Business Strategy
```
1. What's the unfair advantage?
2. Who is the early adopter?
3. What's the monetization model?
4. What's the competitive moat?
5. What's the smallest experiment to validate the idea?
```

---

## Phase 3: Evaluate Options (Converge)

### Framework 1: Quick Comparison Matrix

For each approach, assess against these dimensions:

| Dimension | Question |
|-----------|----------|
| **Feasibility** | Can this actually be built with the given constraints? |
| **Complexity** | How much effort? How many moving parts? |
| **Scalability** | Does it handle growth? |
| **Maintainability** | Will future developers understand and modify it? |
| **Risk** | What could go wrong? What are the unknowns? |
| **Time-to-value** | How quickly can the user get results? |

### Framework 2: Decision Matrix (Weighted Scoring)

For important decisions with multiple criteria:

```
## Decision Matrix

| Option | Weight | Option A | Option B | Option C |
|--------|--------|----------|----------|----------|
| Cost | 30% | 8 (Low cost) | 5 (Medium) | 3 (Expensive) |
| Time | 25% | 6 (2 weeks) | 8 (1 week) | 4 (1 month) |
| Risk | 20% | 7 (Low risk) | 4 (Medium) | 6 (Some risk) |
| Scalability | 15% | 5 (OK) | 7 (Good) | 9 (Excellent) |
| Maintainability | 10% | 6 (Moderate) | 8 (Simple) | 5 (Complex) |
| **Weighted Total** | | **6.55** | **6.20** | **5.25** |

**Winner: Option A** (score: 6.55)
```

### Framework 3: Pugh Matrix (Relative Comparison)

Compare options against a baseline ("datum") rather than absolute scores:

```
## Pugh Matrix

Baseline (Datum): Option B (current approach)

| Criterion | Option A | Datum (B) | Option C |
|-----------|----------|-----------|----------|
| Cost | + (better) | = (same) | - (worse) |
| Speed | - (worse) | = (same) | + (better) |
| Reliability | + (better) | = (same) | + (better) |
| Complexity | - (worse) | = (same) | - (worse) |
| **Net Score** | **+1** | **0** | **0** |

**Analysis:** Option A has a slight edge over the baseline. Option C trades complexity for speed and reliability — worth considering if speed is critical.
```

### Framework 4: Cost-Benefit Analysis

```
## Cost-Benefit Analysis: [Option Name]

### Benefits (Quantified where possible)
- [Benefit 1]: Estimated value = $X/year or Y hours saved
- [Benefit 2]: Estimated value = ...
- [Benefit 3]: Intangible — [description]

### Costs (One-time + Recurring)
- Development time: X hours × $rate = $Y
- Infrastructure: $Z/month
- Learning curve: W hours of team training
- Maintenance overhead: V hours/quarter

### Net Value
Total benefits: $X/year
Total costs (Year 1): $Y
Total costs (ongoing): $Z/year
Break-even point: [timeframe]
ROI (Year 1): [(benefits - costs) / costs] × 100%
```

---

## Convergent Thinking Techniques

After generating many ideas, use these techniques to narrow down:

### Technique 1: Impact-Effort Matrix

Plot each idea on a 2×2 grid:

```
                    HIGH IMPACT
                         │
    Quick Wins           │          Major Projects
    (Do first)           │          (Plan carefully)
    ─────────────────────┼─────────────────────────
    Fill-ins             │          Thankless Tasks
    (Delegate/batch)     │          (Avoid/deprioritize)
                         │
                    LOW IMPACT
         LOW EFFORT ─────┴────── HIGH EFFORT
```

### Technique 2: MoSCoW Prioritization

```
Must Have (M): [essential for launch]
Should Have (S): [important but not critical]
Could Have (C): [nice-to-have, include if time permits]
Won't Have (W): [explicitly out of scope for now]
```

### Technique 3: Dot Voting (for Group Sessions)

1. Give each participant 3-5 "votes" (dots)
2. Everyone votes on their top ideas
3. Count votes; highest-voted ideas win
4. Discuss near-misses before finalizing

### Technique 4: Argument Mapping

```
For the top 2-3 options, map the full argument:

Option: [name]

Arguments FOR:
├─ Reason 1: [evidence]
├─ Reason 2: [evidence]
└─ Reason 3: [evidence]

Arguments AGAINST:
├─ Objection 1: [evidence]
├─ Objection 2: [evidence]
└─ Objection 3: [evidence]

Rebuttals (addressing each objection):
├─ To Objection 1: [rebuttal]
├─ To Objection 2: [rebuttal]
└─ To Objection 3: [rebuttal]

Net assessment: [conclusion]
```

---

## Phase 4: Recommend

1. **Rank** the options based on the user's constraints and priorities
2. **Pick a top recommendation** and explain why
3. **Present the trade-off** — what is the user giving up by choosing this path?
4. **Offer a runner-up** in case the top choice has hidden blockers
5. **Identify next steps** — what should the user do to validate the recommendation?

---

## Real-World Brainstorming Session Example

```
## Brainstorming Session: "How to reduce API latency from 500ms to 100ms"

### Problem Understanding
- Current p95 latency: 500ms
- Target: 100ms
- Stack: Node.js + PostgreSQL
- Constraint: Can't rewrite from scratch, must be incremental

### Phase 2: Generate Options (using SCAMPER)

**S (Substitute):** Replace PostgreSQL queries with Redis cache lookups
**C (Combine):** Merge 3 sequential API calls into 1 aggregated call
**A (Adapt):** Use GraphQL DataLoader pattern for N+1 query batching
**M (Modify):** Add response compression and pagination
**P (Put to other use):** Use CDN edge caching for read-heavy endpoints
**E (Eliminate):** Remove unnecessary logging in hot path
**R (Reverse):** Move from request-response to WebSocket push

### Options Explored

#### Option 1: Redis Cache Layer
- **Idea:** Cache frequently-read data in Redis with 5-min TTL
- **Pros:** Fast to implement, 10-100x faster reads, well-understood pattern
- **Cons:** Cache invalidation complexity, memory cost, eventual consistency
- **Effort:** Medium (2-3 days)
- **Best for:** Read-heavy endpoints with stable data

#### Option 2: Response Aggregation
- **Idea:** Combine 3 sequential DB calls into 1 Promise.all with parallel execution
- **Pros:** Reduces serial wait time, no new infrastructure, simple change
- **Cons:** Limited improvement if DB is the bottleneck, not all queries can parallelize
- **Effort:** Low (0.5-1 day)
- **Best for:** APIs with sequential independent queries

#### Option 3: CDN Edge Caching
- **Idea:** Cache API responses at CDN edge nodes for GET endpoints
- **Pros:** Offloads server entirely, global distribution, free tier available
- **Cons:** Only for cacheable responses, invalidation is hard, adds complexity
- **Effort:** Medium (1-2 days)
- **Best for:** Public APIs with cacheable, non-personalized data

#### Option 4: Database Query Optimization
- **Idea:** Add missing indexes, optimize slow queries, use EXPLAIN ANALYZE
- **Pros:** Fundamental improvement, no new infrastructure, benefits all endpoints
- **Cons:** May not be enough alone, requires DB expertise
- **Effort:** Low-Medium (1-2 days)
- **Best for:** When DB queries are the identified bottleneck

#### Option 5: Hybrid — Cache + Query Optimization
- **Idea:** Optimize queries first, then add Redis caching for remaining hot paths
- **Pros:** Addresses root cause AND symptom, layered approach
- **Cons:** More work than any single option
- **Effort:** Medium-High (3-4 days)
- **Best for:** When you need guaranteed results and have time budget

### Recommendation
**→ Option 5: Hybrid — Cache + Query Optimization** is the best fit because:
- It addresses both the symptom (slow responses) and root cause (inefficient queries)
- It's incremental — can be shipped in stages
- The query optimization step (Option 4) alone might get us to 200ms, and caching handles the rest

**Key trade-off:** Takes 3-4 days instead of 1-2, but provides a durable solution.

**Runner-up:** Option 2 (Response Aggregation) as a quick first step — 0.5 days for potentially 30-40% improvement.
```

---

## Group Brainstorming Facilitation Patterns

### Pattern 1: Brainwriting (6-3-5)

1. **6** people each write **3** ideas in **5** minutes
2. Pass papers to the right
3. Each person adds to/develops the ideas received
4. Repeat until papers return to original author
5. Discuss the top ideas as a group

**When to use:** When dominant personalities tend to overshadow quiet participants. Ensures equal contribution.

### Pattern 2: Round Robin

1. Go around the circle; each person shares one idea
2. No criticism allowed during generation phase
3. Continue until no new ideas emerge
4. Cluster and evaluate as a group

**When to use:** Small teams (3-8 people). When you need full participation.

### Pattern 3: Crazy 8s

1. Fold paper into 8 sections
2. In 8 minutes, sketch one idea per section (1 minute each)
3. Speed forces quantity over quality
4. Review and discuss the most promising ideas

**When to use:** Visual/product brainstorming. When the team is overthinking.

### Pattern 4: Gallery Walk

1. Post questions/problems on walls around the room
2. Participants move in groups, adding ideas via sticky notes
3. After 15-20 minutes, review all walls
4. Discuss themes and top ideas

**When to use:** Large groups (10+). When you need cross-pollination between sub-topics.

---

## Output Format

```markdown
## Brainstorming Session: [Problem Statement]

### Problem Understanding
[Brief restatement of the core problem, key constraints, and success criteria]

### Ideation Technique Used
[Which technique(s): standard divergent, SCAMPER, Six Hats, Analogical, Reverse, etc.]

### Options Explored

#### Option 1: [Name]
- **Idea:** [one-line description]
- **Pros:** [2-3 bullet points]
- **Cons:** [2-3 bullet points]
- **Effort:** [Low/Medium/High]
- **Best for:** [when this option shines]

#### Option 2: [Name]
...

### Evaluation
[Decision matrix, Pugh matrix, or cost-benefit analysis if applicable]

### Recommendation
**→ [Option X]** is the best fit because [reason].

**Key trade-off:** You gain [benefit] but accept [cost].

**Runner-up:** [Option Y] if [condition changes].

**Next steps:** [what the user should do to validate or implement]
```

---

## Rules

- **Never present fewer than 3 options** unless the problem is truly trivial
- **Do not evaluate during generation** — list all ideas first, then judge
- **Be concrete** — "use Redis for caching" is better than "use caching"
- **Include code-level specifics** when the user is a developer — library names, patterns, architecture choices
- **Flag unknowns** — if you're unsure about a constraint, say so rather than guessing
- **Keep it concise** — one paragraph per option max during generation; expand only on the recommended path
- **Separate divergent and convergent phases** — never mix idea generation with idea evaluation
- **Use the right technique for the problem** — SCAMPER for improving existing solutions, Reverse Brainstorming when stuck, Analogical for novel approaches
- **Quantify when possible** — estimated effort, cost, impact scores make decisions easier
- **Always recommend one option** — the user came for a recommendation, not just a list
