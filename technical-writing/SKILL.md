---
name: technical-writing
description: >-
  Write technical articles, blog posts, tutorials, deep-dives, explainers, and educational content about programming, software engineering, system design, algorithms, and technology topics. Use this skill whenever the user asks to write a technical article, blog post, tutorial, how-to guide, explanatory piece, educational content, technical essay, deep dive, write tutorial, write article, technical blog post, مقاله فنی, نوشتن مقاله, آموزش فنی, بلاگ پست فنی, مقاله تخصصی, نوشتن آموزش, SEO for technical content, audience analysis for tech writing, editing checklist, title formulas, content promotion, writing for Dev.to, Medium, or newsletter, or wants to explain a technical concept in writing for an audience.
---

# Technical Writing Skill — Articles, Tutorials & Explainers

## Overview

This skill produces well-structured technical writing: blog posts, tutorials, explainers, and educational articles about software engineering and technology. Technical writing is **teaching through text**. The goal is to transfer understanding from the writer's brain to the reader's brain with minimum friction and maximum retention. This skill covers multiple writing structures, audience analysis, SEO patterns, editing checklists, title formulas, platform-specific strategies, and content promotion.

## When to Use This Skill

- User asks to write a technical article or blog post
- User wants a tutorial or how-to guide for a technology topic
- User needs an explainer or deep-dive on a concept
- User wants to turn their knowledge or experience into written content
- User mentions مقاله فنی, آموزش فنی, بلاگ پست, or نوشتن مقاله
- User says "write an article about..." or "explain this in a blog post"
- User needs help with SEO, titles, editing, or publishing technical content
- User wants to write for a specific platform (Dev.to, Medium, personal blog, newsletter)

---

## Writing Structures

### Structure 1: Tutorial ("How to X")

Best for: Task-oriented readers who want to accomplish something specific.

```
1. Hook: Why you'd want to do X (problem it solves, pain it removes)
2. Prerequisites: What the reader needs first (tools, knowledge, accounts)
3. Step-by-step instructions
   - Each step: do this → expect this → verify this
   - Include code/output for every step
4. Complete working example (the full thing, end-to-end)
5. Common pitfalls and troubleshooting
6. Next steps / what to learn next
```

**Example outline — "How to Build a Rate Limiter in Go":**
```
1. Hook: "Your API got 10x traffic. Without rate limiting, your database melts."
2. Prerequisites: Go 1.21+, understanding of HTTP middleware
3. Step 1: Set up the project
4. Step 2: Implement a token bucket algorithm (code + explanation)
5. Step 3: Wrap it in HTTP middleware (code + explanation)
6. Step 4: Add Redis for distributed rate limiting (code + explanation)
7. Step 5: Test with load testing tool (k6/vegeta)
8. Complete example: Full working code with Docker setup
9. Pitfalls: Clock skew in distributed mode, choosing the right algorithm
10. Next steps: Sliding window logs, adaptive rate limiting
```

### Structure 2: Explainer ("What is X")

Best for: Readers encountering a concept for the first time. Builds understanding from zero.

```
1. Hook: Real-world analogy or problem that X solves
2. High-level definition (no jargon, no code yet)
3. Why it exists (what problem does it solve?)
4. How it works (progressive detail — simple → complex)
5. Concrete example / code walkthrough
6. When to use it / when NOT to use it
7. Comparison with alternatives (if applicable)
8. Quick reference summary
```

**Example outline — "What is Event Sourcing?":**
```
1. Hook: "Imagine if your bank only showed your current balance,
   but you had no idea how you got there. That's how most apps work.
   Event sourcing remembers every step."
2. Definition: "Event sourcing stores every state change as an
   immutable event, rather than just the current state."
3. Why: Auditing, debugging, time travel, CQRS
4. How: Append-only log → current state derived by replaying events
5. Code: Simple event store implementation in TypeScript
6. When to use: Financial systems, collaboration tools, audit-heavy domains
7. When NOT: Simple CRUD apps, rapid prototyping, small projects
8. Comparison: Event sourcing vs. CRUD vs. CQRS
```

### Structure 3: Deep Dive ("Under the Hood of X")

Best for: Experienced developers who want to understand internals.

```
1. The problem or motivation (why should I care about internals?)
2. The design / architecture (high-level picture)
3. Key implementation details with code (the interesting parts)
4. Trade-offs and decisions (why was it built this way?)
5. Performance characteristics / benchmarks (how fast is it?)
6. Lessons learned / what we can apply to our own code
7. Conclusion and future direction
```

### Structure 4: Problem-Solution

Best for: Content that addresses a specific pain point. Very effective for blog posts.

```
1. The Problem: Describe the pain point vividly. Make the reader nod
   and say "yes, I've been there."
2. Why It Happens: Explain the root cause. Not just symptoms.
3. The Failed Attempts: Show 1-2 solutions that don't work well
   (builds credibility and anticipation).
4. The Solution: Present your approach with full implementation.
5. Results: Show before/after metrics, screenshots, or outcomes.
6. Key Takeaways: What the reader should remember.
```

**Example — "Why Your React App Re-renders 47 Times on Page Load (And How to Fix It)":**
```
1. Problem: "I opened React DevTools and the whole tree was flashing."
2. Why: Unnecessary state changes, inline objects/functions as props,
   missing useMemo/useCallback
3. Failed fix 1: "Adding React.memo everywhere — didn't help because
   the props were still new references"
4. Solution: Profiling → identify culprits → targeted fixes with
   useMemo, useCallback, and component splitting
5. Results: "47 renders → 3 renders. Load time: 2.1s → 0.4s"
6. Takeaways: Profile first, fix the root cause, not the symptom
```

### Structure 5: Before-After (Transformation Story)

Best for: Showing the impact of a technology or practice. Motivational content.

```
1. Before: Describe the painful state (metrics, experiences, problems)
2. The Change: What was done (technology adoption, migration, refactoring)
3. After: The improved state (metrics, experiences, benefits)
4. How You Can Do It: Steps for the reader to replicate the transformation
5. Lessons Learned: What went well, what was harder than expected
```

### Structure 6: Storytelling (Narrative Technical Writing)

Best for: Long-form content that needs to hold attention. Conference talks, personal blogs.

```
1. Opening Scene: A specific moment or incident that illustrates the problem
2. Rising Action: The journey of trying to solve it (setbacks, discoveries)
3. Climax: The breakthrough moment or key insight
4. Resolution: The solution and its impact
5. Reflection: What did you learn? What should the reader take away?
```

**When to use:** When you want to build emotional connection. When the lesson is as important as the technique. When you're sharing a war story or case study.

---

## Audience Analysis Techniques

Before writing, analyze your audience:

### Audience Profile Template

```
## Target Reader Profile

**Role:** [junior dev / senior dev / architect / CTO / hobbyist]
**Experience Level:** [beginner / intermediate / advanced / expert]
**Familiarity with Topic:** [hearing about it for the first time /
  knows the basics / uses it daily / has dug into internals]
**Primary Goal:** [learn to use / understand how it works /
  evaluate for adoption / troubleshoot a problem]
**Reading Context:** [desk research / on a break / in a meeting /
  following a tutorial step-by-step]
**Time Available:** [2 minutes / 10 minutes / 30+ minutes]
```

### Content Depth Calibration

| Audience Level | What They Need | What They Don't Need |
|---------------|----------------|---------------------|
| **Beginner** | Why it exists, basic concepts, hand-holding, analogies | Internal implementation, performance optimization, advanced patterns |
| **Intermediate** | How to use it well, patterns, common pitfalls, comparisons | Basic syntax, "what is a variable" level explanations |
| **Advanced** | Internals, trade-offs, performance characteristics, edge cases | Basic usage, simple examples, "what is Docker" level explanations |
| **Expert** | Novel insights, benchmarks, design decisions, novel combinations | Anything covered in official docs |

### Writing for Non-Technical Audiences

- Lead with **why** and **impact**, not how
- Replace code with diagrams, screenshots, and plain language
- Use analogies from everyday life
- Avoid all acronyms or define every one on first use
- Focus on **what it does for them**, not how it works under the hood

---

## SEO Patterns for Technical Content

### Title Formulas

| Formula | Example |
|---------|---------|
| **How to [Do X] in [Technology]** | "How to Build a REST API in Go" |
| **[Technology] vs [Technology]: [Key Differentiator]** | "PostgreSQL vs MongoDB: When to Choose Which" |
| **Why Your [X] is [Problem] (And How to Fix It)** | "Why Your Docker Build is Slow (And How to Fix It)" |
| **The Complete Guide to [Topic]** | "The Complete Guide to JWT Authentication" |
| **[Number] [Topic] Mistakes [Audience] Make** | "7 Docker Mistakes Junior Developers Make" |
| **What is [Concept]? A Practical Introduction** | "What is Event Sourcing? A Practical Introduction" |
| **[Concept] Explained: [What They'll Learn]** | "TCP vs UDP Explained: What Every Developer Needs to Know" |
| **Building [X] from Scratch with [Technology]** | "Building a Message Queue from Scratch with Rust" |
| **[Year] Guide to [Topic]** | "2025 Guide to React State Management" |
| **[Concept] for [Audience]: From Zero to [Outcome]** | "Kubernetes for Backend Developers: From Zero to Production" |

### Hook Formulas (First Lines)

The first line determines if the reader continues. Hook formulas:

| Formula | Example |
|---------|---------|
| **Problem statement** | "Your API is down. It's 3 AM. Your runbook is outdated." |
| **Surprising stat** | "80% of production incidents are caused by configuration changes, not code bugs." |
| **Contrarian take** | "Microservices are usually the wrong architecture choice. Here's why." |
| **Relatable scenario** | "You just pushed to main. The CI pipeline turns red. Again." |
| **Question** | "What if your database could version itself like Git?" |
| **Before/After** | "Last month, our deploy took 45 minutes. Today, it takes 90 seconds." |
| **Story opening** | "At 2:47 AM on a Tuesday, our monitoring dashboard went dark." |

### Keyword Research Patterns

For technical articles, target:
- **Primary keyword**: [technology] + [task] (e.g., "React pagination")
- **Long-tail keywords**: [technology] + [task] + [context] (e.g., "React pagination with infinite scroll")
- **Related questions**: "How to...", "What is...", "Why does...", "When to use..."
- **Competitor analysis**: Search the topic, read top 5 results, identify gaps

### On-Page SEO Checklist

- [ ] Primary keyword in title (H1)
- [ ] Primary keyword in first 100 words
- [ ] Primary keyword in at least one H2
- [ ] Related keywords throughout (natural, not stuffed)
- [ ] Alt text on all images
- [ ] Internal links to related content
- [ ] External links to authoritative sources
- [ ] Meta description (150-160 chars) includes primary keyword
- [ ] URL slug is short and includes primary keyword
- [ ] Code blocks are not counted as "thin content" — add explanatory text

---

## Editing and Revision Checklists

### Structural Edit (Big Picture)

- [ ] **Title promises value** — Does it tell the reader what they'll gain?
- [ ] **Hook grabs attention** — Does the first paragraph make them want to continue?
- [ ] **One clear takeaway** — Can you summarize the article's core message in one sentence?
- [ ] **Logical flow** — Does each section build on the previous one?
- [ ] **Appropriate length** — Long enough to cover the topic, short enough to respect time?
- [ ] **No wandering** — Every section serves the main thesis. Remove tangents.
- [ ] **Strong conclusion** — Ends with a clear takeaway or call to action, not a whimper.

### Line Edit (Sentence Level)

- [ ] **One idea per paragraph** — If a paragraph has two ideas, split it.
- [ ] **Active voice preferred** — "The function returns..." not "The value is returned by..."
- [ ] **No unnecessary jargon** — Every technical term is either common or defined.
- [ ] **Varied sentence length** — Mix short punchy sentences with longer explanatory ones.
- [ ] **Read aloud test** — If it's hard to say, it's hard to read.
- [ ] **No filler words** — Remove "basically", "actually", "just", "very", "quite", "really".
- [ ] **Specific over vague** — "3ms latency" not "very fast latency".

### Technical Accuracy Edit

- [ ] **Code examples work** — Run every code block. Copy-paste and execute.
- [ ] **Output matches claims** — If you say "it outputs X", the example should show X.
- [ ] **Versions correct** — Library versions, language versions, API versions are current.
- [ ] **No outdated information** — Links work, tools still exist, practices still apply.
- [ ] **Comparisons fair** — If comparing A vs B, present both accurately.
- [ ] **No hallucinated features** — Don't claim a tool does something it doesn't.

### Readability Edit

- [ ] **Scannable structure** — Headers, bullets, code blocks break up walls of text.
- [ ] **Key terms bolded** on first use.
- [ ] **Code blocks have language tags** — ` ```python `, not just ` ``` `.
- [ ] **Images/diagrams add value** — Not decorative. Each illustrates a concept.
- [ ] **Tables for comparisons** — Not paragraphs of "A does X, B does Y".
- [ ] **Consistent formatting** — Same heading style, same code block style throughout.

---

## Writing for Different Platforms

### Personal Blog / Portfolio

**Advantages:** Full control, no algorithm dependency, builds personal brand.
**Best practices:**
- Write in-depth content (2000-4000 words)
- Include your unique perspective and experiences
- Use a consistent voice and style
- Optimize for SEO (you own the domain)
- Include a clear about page and contact info

### Dev.to

**Audience:** Developers, especially early-to-mid career. Community-oriented.
**Best practices:**
- Title with clear value proposition
- Include a "TL;DR" at the top
- Use code blocks with language tags
- Tag appropriately (max 4 tags)
- Engage with comments
- Series format works well for multi-part content
- Cross-post from your own blog (canonical URL)

### Medium

**Audience:** Mixed technical and non-technical. Broader reach.
**Best practices:**
- Write for the "Technology" publication or relevant niche publication
- Use a compelling featured image
- Include a clear subtitle
- Use section headers every 200-300 words
- Link to your other content and external sources
- Consider the paywall implications (members-only vs. free)

### Technical Newsletter

**Audience:** Subscribers who opted in. More engaged, higher trust.
**Best practices:**
- Short, scannable format (500-1000 words)
- One main topic per issue
- Strong subject line (40-60 characters)
- Personal voice and opinion
- Curated links to supplementary reading
- Clear CTA (reply, share, check out a link)
- Consistent schedule (weekly, bi-weekly)

### Conference Talk / Slide Deck (Written Companion)

**Best practices:**
- Write for the "absent audience" — people who couldn't attend
- Include speaker notes / script alongside slides
- More narrative than a typical article
- Include diagrams and visuals prominently
- Link to recording if available

---

## Title and Hook Formulas (Advanced)

### The 4 U's Formula for Titles

Every title should be:
1. **Useful** — What will the reader gain?
2. **Urgent** — Why should they read it now?
3. **Unique** — What makes this different from existing content?
4. **Ultra-specific** — What exactly will they learn?

### The APP Formula for Hooks

1. **Agree** — Start with something the reader already believes
2. **Promise** — Tell them what they'll get from reading
3. **Preview** — Give a taste of what's coming

**Example:**
```
[Agree] "Debugging production issues at 3 AM is nobody's favorite activity."
[Promise] "But with the right tooling and practices, you can cut your
mean time to resolution by 60%."
[Preview] "Here are the 5 practices that transformed how our team
handles incidents."
```

### Advanced Title Techniques

| Technique | Example |
|-----------|---------|
| **Numbers + Adjective + Noun + Promise** | "5 Simple Patterns That Made Our API 10x Faster" |
| **Contrarian** | "Stop Using Docker Compose for Production" |
| **Specific Metric** | "Reducing Our Bundle Size from 2MB to 89KB" |
| **Question + Answer Promise** | "Is GraphQL Worth It? A Year of Production Data" |
| **Story + Lesson** | "How a $0.001 Bug Cost Us $50K: Lessons in Floating Point" |
| **Guide + Year** | "The Practical Guide to TypeScript in 2025" |

---

## Content Promotion Patterns

### Before Publishing

- [ ] Social media teaser: Share the title + hook on Twitter/LinkedIn
- [ ] Relevant communities: Identify 2-3 communities where this content is relevant (don't spam)
- [ ] Internal sharing: Share with team/company for early feedback and amplification

### After Publishing

- [ ] Share on Twitter/LinkedIn with a compelling thread or summary
- [ ] Post in relevant communities (Hacker News, Reddit, Dev.to, Discord servers)
- [ ] Cross-link from existing content
- [ ] Update any related articles with links to the new one
- [ ] Respond to comments and questions (engagement boosts visibility)

### Long-Term Promotion

- [ ] Update the article annually if it remains relevant
- [ ] Link to it from future related articles
- [ ] Monitor search rankings and optimize if needed
- [ ] Track which traffic sources drive the most readers

---

## Workflow

### Step 1: Clarify the Brief

1. **Topic** — What exactly is being written about? Narrow broad topics down.
2. **Audience** — Who is reading this? (beginners, intermediate devs, experts, general tech audience)
3. **Goal** — What should the reader be able to do or understand after reading?
4. **Format** — Blog post, tutorial, explainer, reference, opinion piece?
5. **Length** — Short (500-1000 words), medium (1000-2500 words), long (2500+ words)?
6. **Tone** — Conversational, formal, academic, opinionated?
7. **Platform** — Where will this be published? (personal blog, Dev.to, Medium, newsletter)

If the user doesn't specify, ask. Don't guess on audience and goal — they determine everything.

### Step 2: Plan the Structure

Before writing, create an outline. Select the appropriate structure from this skill:
- Tutorial structure for "How to X"
- Explainer structure for "What is X"
- Deep Dive for "Under the Hood of X"
- Problem-Solution for pain-point content
- Before-After for transformation stories
- Storytelling for narrative content

### Step 3: Write the Content

Follow these rules while writing:

1. **Start with a hook.** Open with a problem, question, or surprising fact — not a dictionary definition.
2. **One idea per paragraph.** If a paragraph has two ideas, split it.
3. **Code examples must work.** Every code block should be copy-pasteable and runnable. Include imports, setup, and expected output.
4. **Use progressive disclosure.** Start simple, add complexity gradually. Don't front-load every caveat.
5. **Define jargon on first use.** If you say "eventual consistency," briefly explain what it means before using it freely.
6. **Use analogies sparingly and accurately.** A bad analogy is worse than no analogy.
7. **Show, then explain.** Code first, then walk through what it does. Not the reverse.
8. **Break up text** with headers, bullets, code blocks, images, and tables. No walls of text.

### Step 4: Review and Polish

1. **Read aloud in your head.** If a sentence is hard to parse mentally, rewrite it.
2. **Cut ruthlessly.** If a paragraph doesn't serve the reader's goal, remove it.
3. **Check code examples.** Are they complete? Do they match the text? Are the outputs correct?
4. **Add a conclusion.** Summarize the key takeaway. Tell the reader what to do next.
5. **Run through the editing checklists** in this skill (structural, line, technical accuracy, readability).
6. **Add a title that promises value.** "How to Build a Rate Limiter in Go" beats "Rate Limiting."

### Step 5: Optimize and Publish

1. **SEO check** — Title, first paragraph, headings include target keywords.
2. **Meta description** — Compelling, 150-160 characters.
3. **Images** — Relevant, properly attributed, compressed for web.
4. **Internal/external links** — Reference related content and authoritative sources.
5. **Publish** — Choose the right platform based on audience and goals.

---

## Output Format

- Output in Markdown
- Use H2 (`##`) for main sections, H3 (`###`) for subsections
- Code blocks with language tags
- Use bold for key terms on first introduction
- Include a title, optional subtitle, and the article body
- Write in the user's language unless they specify English
- Include estimated reading time at the top for long articles

---

## Principles

- **Teach, don't impress.** The goal is reader understanding, not showing off your knowledge.
- **Be concrete.** Abstract explanations without examples are lectures, not teaching.
- **Respect the reader's time.** Every sentence must earn its place.
- **Be honest about trade-offs.** No technology is perfect. Acknowledge downsides.
- **Update context.** If referencing tools or versions, note the version. Time-stamp your content implicitly.
- **Write for scanners first, readers second.** Most people will scan before deciding to read.
- **Lead with value.** The first 30 seconds should tell the reader what they'll gain.
- **Have a point of view.** "Here are the facts" is less compelling than "Here's what I think, and here's why."
- **Edit mercilessly.** Good writing is rewriting. Cut 20% from your first draft.
- **Write the article you'd want to read.** If it bores you, it'll bore your readers.
