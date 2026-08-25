---
name: technical-writing
description: >-
  Write technical articles, blog posts, tutorials, deep-dives, explainers, and educational content about programming, software engineering, system design, algorithms, and technology topics. Use this skill whenever the user asks to write a technical article, blog post, tutorial, how-to guide, explanatory piece, educational content, technical essay, deep dive, write tutorial, write article, technical blog post, opinion piece, tech opinion, technology comparison, benchmark report, case study, tech case study, post-mortem, incident report, lessons learned, engineering blog, dev blog, medium article, hashnode post, dev.to post, personal blog, technical manifesto, technology evaluation, tool review, library review, framework comparison, migration guide (narrative), architecture walkthrough, system design explanation, algorithm explanation, data structure explanation, design pattern explanation, coding interview explanation, concept explainer, beginner tutorial, advanced tutorial, multi-part series, newsletter content, email course, technical newsletter, developer newsletter, workshop material, conference talk writeup, talk summary, lightning talk script, tech talk outline, white paper, technical white paper, research summary, academic-adjacent writing, RFC response, proposal document, technical proposal, tech spec narrative, engineering rationale, design rationale, proof of concept writeup, PoC documentation, hands-on lab, coding exercise writeup, educational course content, curriculum material, tutorial series outline, مقاله فنی, نوشتن مقاله, آموزش فنی, بلاگ پست فنی, مقاله تخصصی, نوشتن آموزش, مقاله وبلاگ, راهنمای آموزشی, توضیح مفهوم فنی, نوشتن مقاله تخصصی, آموزش مرحله‌به‌مرحله, بررسی فنی, مقایسه فنی, نقد ابزار, بررسی کتابخانه, نقد فریم‌ورک, مقاله عمیق, مقاله تحلیلی, یادداشت فنی, یا می‌خواهد یک مفهوم فنی را برای مخاطبان به صورت نوشتاری توضیح دهد.
---

# Technical Writing Skill — Articles, Tutorials & Explainers

## Overview

This skill produces well-structured technical writing: blog posts, tutorials, explainers, and educational articles about software engineering and technology. Technical writing is teaching through text. The goal is to transfer understanding from the writer's brain to the reader's brain with minimum friction and maximum retention.

## When to Use This Skill

- User asks to write a technical article or blog post
- User wants a tutorial or how-to guide for a technology topic
- User needs an explainer or deep-dive on a concept
- User wants to turn their knowledge or experience into written content
- User mentions مقاله فنی, آموزش فنی, بلاگ پست, or نوشتن مقاله
- User says "write an article about..." or "explain this in a blog post"
- User needs a technology comparison or evaluation piece
- User wants a post-mortem or lessons-learned document
- User needs conference talk material or workshop content
- User asks for a coding exercise writeup or hands-on lab
- User wants a technical newsletter or email course content
- User needs a proof-of-concept narrative or design rationale

## Technical Writing Workflow

### Step 1: Clarify the Brief

1. **Topic** — What exactly is being written about? Narrow broad topics down.
2. **Audience** — Who is reading this? (beginners, intermediate devs, experts, general tech audience)
3. **Goal** — What should the reader be able to do or understand after reading?
4. **Format** — Blog post, tutorial, explainer, reference, opinion piece?
5. **Length** — Short (500-1000 words), medium (1000-2500 words), long (2500+ words)?
6. **Tone** — Conversational, formal, academic, opinionated?

If the user doesn't specify, ask. Don't guess on audience and goal — they determine everything.

### Step 2: Plan the Structure

Before writing, create an outline. A good technical article follows one of these structures:

#### Tutorial Structure ("How to X")
```
1. Hook: Why you'd want to do X
2. Prerequisites: What the reader needs first
3. Step-by-step instructions (each step: do this → expect this)
4. Complete working example
5. What to do next / common pitfalls
```

#### Explainer Structure ("What is X")
```
1. Hook: Real-world analogy or problem that X solves
2. High-level definition (no jargon)
3. How it works (progressive detail)
4. Concrete example / code
5. When to use it / when not to
6. Comparison with alternatives (if applicable)
```

#### Deep Dive Structure ("Under the Hood of X")
```
1. The problem or motivation
2. The design / architecture
3. Key implementation details with code
4. Trade-offs and decisions
5. Performance characteristics / benchmarks
6. Conclusion and future direction
```

#### Comparison Structure ("X vs Y vs Z")
```
1. The decision context (what are you choosing between and why does it matter)
2. Criteria for comparison
3. Side-by-side analysis per criterion
4. Recommendation matrix
5. "Choose X if..." / "Choose Y if..."
```

### Step 3: Write the Content

Follow these rules while writing:

1. **Start with a hook.** Open with a problem, question, or surprising fact — not a dictionary definition.
2. **One idea per paragraph.** If a paragraph has two ideas, split it.
3. **Code examples must work.** Every code block should be copy-pasteable and runnable. Include imports, setup, and expected output.
4. **Use progressive disclosure.** Start simple, add complexity gradually. Don't front-load every caveat.
5. **Define jargon on first use.** If you say "eventual consistency," briefly explain what it means before using it freely.
6. **Use analogies sparingly and accurately.** A bad analogy is worse than no analogy.
7. **Show, then explain.** Code first, then walk through what it does. Not the reverse.

### Step 4: Review and Polish

1. **Read aloud in your head.** If a sentence is hard to parse mentally, rewrite it.
2. **Cut ruthlessly.** If a paragraph doesn't serve the reader's goal, remove it.
3. **Check code examples.** Are they complete? Do they match the text? Are the outputs correct?
4. **Add a conclusion.** Summarize the key takeaway. Tell the reader what to do next.
5. **Add a title that promises value.** "How to Build a Rate Limiter in Go" beats "Rate Limiting.".

## Output Format Templates

### Template 1: Blog Post
```markdown
# [Title That Promises Value]

[Optional subtitle expanding on the promise]

[Opening paragraph: the problem, the stakes, or the surprising fact]

## The Problem

[Why this topic matters. Pain point or context.]

## How [Thing] Works

[Core explanation with progressive detail]

### Key Concept: [Name]

[Explanation with code example]

```python
# Complete, runnable code
```

[Walk through the code line by line or section by section]

## Putting It All Together

[Complete working example combining all concepts]

## When to Use This (And When Not To)

[Honest assessment of trade-offs]

## Conclusion

[Key takeaway + what to read or do next]

---
*If you found this useful, [share / subscribe / follow].*
```

### Template 2: Multi-Part Tutorial Series
```markdown
# [Series Title]: Part [N] — [Part Title]

> **Series overview:** This is part [N] of a [M]-part series on [topic].
> - [Part 1: Title](link)
> - [Part 2: Title](link) ← you are here
> - [Part 3: Title](link) (coming soon)

**In this part, you'll learn:** [3-4 bullet points of what the reader will accomplish]

**Prerequisites:** [What you need before starting — link to previous parts]

---

## [Section Title]

[Content with code examples]

## What's Next

In [Part N+1], we'll [teaser of next topic].

---
*Full source code for this part: [GitHub link]*
```

### Template 3: Technology Comparison
```markdown
# [Tool A] vs [Tool B] vs [Tool C] for [Use Case]

[Opening: the decision you're trying to make and why it's hard]

## Quick Answer

**Choose [A]** if [one-line condition].
**Choose [B]** if [one-line condition].
**Choose [C]** if [one-line condition].

## Comparison Matrix

| Criterion | Tool A | Tool B | Tool C |
|-----------|--------|--------|--------|
| Performance | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| Ease of use | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Ecosystem | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Learning curve | Steep | Gentle | Moderate |

## Deep Dive: [Tool A]

[Strengths, weaknesses, code example]

## Deep Dive: [Tool B]

[Strengths, weaknesses, code example]

## Deep Dive: [Tool C]

[Strengths, weaknesses, code example]

## Decision Framework

[Questions the reader should ask themselves to pick the right tool]

## My Recommendation

[For most teams building [X], I'd recommend [Y] because...]
```

### Template 4: Post-Mortem / Lessons Learned
```markdown
# Post-Mortem: [Incident Title]

**Date:** [date]
**Duration:** [X hours/minutes]
**Impact:** [What users experienced]
**Severity:** [P1/P2/P3]

## Timeline (UTC)

| Time | Event |
|------|-------|
| 14:02 | Alert triggered: error rate > 5% |
| 14:05 | On-call engineer paged |
| 14:12 | Root cause identified |
| 14:18 | Mitigation applied |
| 14:25 | Error rate returned to normal |

## Root Cause

[Technical explanation of what went wrong and why]

## Contributing Factors

- [Factor 1]
- [Factor 2]

## What We Did Well

- [Positive observation 1]
- [Positive observation 2]

## What Could Have Gone Better

- [Improvement area 1]
- [Improvement area 2]

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Add circuit breaker to service X | @engineer | 2024-08-01 | In progress |
| Improve alert threshold tuning | @sre | 2024-08-15 | Pending |
```

## Advanced Techniques

### 1. The Feynman Technique in Writing
Explain the concept as if teaching a smart 12-year-old. If you can't, you don't understand it well enough. Write the simple version first, then layer in technical precision. This ensures accessibility without sacrificing accuracy.

### 2. Code Narrative Flow
Structure code examples as a story: setup (the world before), inciting incident (the problem), rising action (the approach), climax (the solution), and resolution (verification). Each code block should advance the narrative.

```python
# BAD: Jumping straight to the solution
result = sorted(items, key=lambda x: x['date'])

# GOOD: Building up from the problem
items = [{'name': 'A', 'date': '2024-03-15'}, {'name': 'B', 'date': '2024-01-10'}]
# We need these sorted by date, newest first
result = sorted(items, key=lambda x: x['date'], reverse=True)
# [{'name': 'A', 'date': '2024-03-15'}, {'name': 'B', 'date': '2024-01-10'}]
```

### 3. Diagnostic Questioning
Before writing, answer these diagnostic questions:
- What does the reader already know?
- What's the ONE thing they need to understand by the end?
- What misconception might they have that I need to correct?
- What will they do immediately after reading this?

### 4. Anti-Pattern: The Info Dump
Don't write an article that's a reorganized version of official docs. Add value through: opinion, experience, real-world war stories, performance data, or a novel mental model.

### 5. Visual Storytelling with Diagrams
Use ASCII art, Mermaid diagrams, or request chart generation to illustrate architecture, flows, and relationships. A single diagram can replace 300 words of explanation.

### 6. The "Why Before How" Rule
Never start with HOW to do something. Start with WHY you'd want to. The reader needs motivation before instruction.

### 7. Version-Anchored Writing
Always note the specific version of tools/libraries you're writing about. Add a "tested with" note. This makes the article useful months or years later.

## Common Patterns

### Pattern 1: Getting Started Tutorial
```markdown
# Getting Started with [Technology]

You've heard about [tech] and want to try it. This tutorial walks you through building [specific thing] in [X] minutes.

## What You'll Build

[A screenshot or description of the final result]

## Prerequisites

- [Tool] installed ([download link])
- Basic knowledge of [concepts]
- [X] minutes of your time

## Step 1: Create the Project

```bash
npx create-app my-project
cd my-project
```

[Explain what this just did]

## Step 2: Add [Feature]

```javascript
// code with comments
```

## Step 3: Run It

```bash
npm start
```

Open [URL] and you should see [expected result].

## Next Steps

Now that you have the basics, try:
1. [Challenge 1]
2. [Challenge 2]
3. [Read the full docs](link)
```

### Pattern 2: Design Pattern Explanation
```markdown
# The [Pattern Name] Pattern in [Language]

## The Problem

[Describe a real scenario where you'd encounter this problem]

## The Solution

[Explain the pattern conceptually]

## Implementation

```typescript
// Interface definition
interface Strategy {
  execute(data: Input): Output;
}

// Concrete implementation
class ConcreteStrategyA implements Strategy {
  execute(data: Input): Output {
    // ...
  }
}

// Context that uses the strategy
class Context {
  constructor(private strategy: Strategy) {}

  process(data: Input): Output {
    return this.strategy.execute(data);
  }
}
```

## When to Use This Pattern
- Use it when [condition]
- Avoid it when [condition]

## Real-World Example
[Describe a well-known system that uses this pattern]

## Trade-offs
| Pro | Con |
|-----|-----|
| ... | ... |
```

### Pattern 3: Performance Deep Dive
```markdown
# Why [Thing] Is Slow (And How We Made It 10x Faster)

## The Benchmark

[Describe the workload and measurement methodology]

```bash
# Before optimization
hyperfine 'python process.py data.csv'
# Time (mean ± σ): 12.4s ± 0.3s

# After optimization  
hyperfine 'python process.py data.csv'
# Time (mean ± σ): 1.1s ± 0.05s
```

## Where the Time Went

[Profile results — flame chart description or table]

| Function | % of Time | Calls |
|----------|-----------|-------|
| `parse_line()` | 45% | 1.2M |
| `validate()` | 30% | 1.2M |

## Fix 1: [Description]

[Explanation + code change + resulting improvement]

## Fix 2: [Description]

[Explanation + code change + resulting improvement]

## Results

[Before/after table or chart]

## Lessons Learned
1. [Insight 1]
2. [Insight 2]
```

### Pattern 4: Opinion/Manifesto Piece
```markdown
# [Strong Opinion Title]

[Opening: a controversial or contrarian statement backed by experience]

## The Common Belief

[What most people think/do — set up the counter-argument]

## Why I Disagree

[Your argument with evidence]

## What I Do Instead

[Your recommended approach with examples]

## The Exceptions

[When the common belief IS correct — show nuance]

## Conclusion

[Restate your position clearly]
```

### Pattern 5: Workshop/Lab Material
```markdown
# Workshop: [Title]

**Duration:** 90 minutes
**Level:** Intermediate
**Prerequisites:** [List]

## Learning Objectives

By the end of this workshop, you will be able to:
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

## Materials

- [Link to starter repo]
- [Link to slides]
- [Required accounts/tools]

---

## Exercise 1: [Title] (20 min)

**Goal:** [What they'll accomplish]

### Instructions
1. Open [file]
2. Implement [feature]
3. Run `npm test` to verify

### Hints
- [Hint 1]
- [Hint 2]

### Solution
<details>
<summary>Click to reveal</summary>

```javascript
// Solution code
```
</details>

---

## Exercise 2: [Title] (30 min)
[...]
```

## Edge Cases & Pitfalls

1. **The "Hello World" trap** — Starting too simple and never reaching useful complexity. Readers who already know the basics will bounce. Start at the right level for your stated audience.

2. **Code examples that don't run** — Missing imports, undeclared variables, or wrong function signatures. Always mentally trace through every code block.

3. **Front-loading caveats** — Burying the reader in "but first, note that..." before they've seen the basic case. Defer edge cases to a "Caveats" section near the end.

4. **Wall of text** — Articles longer than 300 words without a heading, code block, or visual break. Break up text with subheadings, lists, and examples.

5. **Writing for yourself, not the reader** — Showing off knowledge rather than teaching. Every paragraph should pass the test: "Does this help the reader?"

6. **No version context** — Writing about a library's API without noting the version. APIs change. Always specify and preferably link to versioned docs.

7. **Generic conclusions** — "In conclusion, [topic] is useful and you should consider it." Weak. Conclude with a specific, actionable recommendation or insight.

8. **Ignoring the non-happy path** — Tutorials that only show the happy path. Real users hit errors. Add a "Troubleshooting" section.

9. **Jargon without definition** — Using terms like "idempotency," "event sourcing," or "CQRS" without defining them. Even expert audiences appreciate a one-line refresher.

10. **Too many topics in one article** — Trying to cover 5 concepts in 2000 words means each gets 400 words. Pick ONE concept and go deep.

11. **No clear audience signal** — Articles that read like they're for beginners in paragraph 1 and experts in paragraph 3. Pick an audience level and stay consistent.

12. **Stale content** — Referencing deprecated APIs, old library versions, or outdated best practices without acknowledging it. Time-stamp your content.

13. **Missing the "so what"** — Explaining how something works technically but not why the reader should care. Always connect technical details to real-world impact.

14. **Over-use of emojis and formatting** — Every other sentence bolded, headers with emojis, excessive callouts. Use formatting to serve comprehension, not decoration.

## Integration with Other Skills

- **documentation** — Use when the technical writing is meant to be project documentation (README, API docs) rather than a standalone article.
- **changelog** — Use when writing release announcements or version narrative summaries.
- **summarization** — Use when condensing research material before writing, or when creating an executive summary of a technical document.
- **charts** — Use when articles need architecture diagrams, flow charts, benchmark visualizations, or comparison tables.
- **browser-automation** — Use when writing tutorials that involve browser testing or web automation as the topic.
- **api-integration** — Use when writing tutorials about integrating with third-party APIs or building API clients.
- **pdf** — Use when the article needs to be delivered as a polished PDF white paper or handout.
- **pptx** — Use when converting the article into a conference talk or workshop presentation.

## Principles

- **Teach, don't impress.** The goal is reader understanding, not showing off your knowledge.
- **Be concrete.** Abstract explanations without examples are lectures, not teaching.
- **Respect the reader's time.** Every sentence must earn its place.
- **Be honest about trade-offs.** No technology is perfect. Acknowledge downsides.
- **Update context.** If referencing tools or versions, note the version. Time-stamp your content implicitly.
- **One article, one idea.** Depth over breadth. A 2000-word article on one concept beats 2000 words on five.
- **Write for scanners first, readers second.** Many people will scan headings and code blocks. Make the scan valuable.
- **End with direction.** The reader should know what to do next after finishing your article.
