---
name: technical-writing
description: >-
  Write clear, effective technical content: tutorials, explainers, deep dives, 
  comparison posts, post-mortems, and workshop materials.
  English: technical writing, technical documentation, tutorial writing, explainer articles,
    deep dives, comparison posts, post-mortems, workshop materials, code narrative,
    progressive disclosure, audience analysis, Feynman technique, developer documentation,
    API documentation, architecture decision records, knowledge base articles.
  فارسی: نگارش فنی، مستندسازی فنی، نوشتن آموزش‌ها، مقالات توضیحی، مقالات عمیق،
    مقالات مقایسه‌ای، گزارش‌های پس‌مرگ، مواد کارگاهی، روایت کد، تکنیک فاینمن.
  中文: 技术写作，技术文档，教程编写，解释性文章，深度文章，比较文章，事后分析，
    工作坊材料，代码叙事，渐进式披露，受众分析，费曼技巧，开发者文档。
---

# Technical Writing and Content Creation

## Overview

Technical writing is the practice of communicating complex information clearly, accurately, and efficiently to a specific audience. Unlike creative writing, technical writing prioritizes utility over beauty — the reader should be able to accomplish something after reading. The best technical writing is invisible: readers absorb the information without noticing the prose.

The core challenge of technical writing is managing complexity. Every technical topic exists on a spectrum from "total beginner" to "domain expert," and the writer must decide where on that spectrum to target. Writing for too advanced an audience alienates newcomers; writing for too basic an audience bores experts. The Feynman technique — explain the concept as if teaching it to someone with no background — is the writer's most powerful tool for finding this balance.

This skill covers the complete technical writing lifecycle: audience analysis, content type selection, structural planning, drafting with code integration, revision for clarity, and publication. It includes templates for every major content type and techniques for making complex topics accessible.

## When to Use This Skill

- Writing tutorials that teach readers to build something step-by-step
- Creating explainer articles that make complex concepts understandable
- Writing deep dives that explore advanced topics in detail
- Building comparison posts that help readers choose between options
- Documenting post-mortems after incidents or project completions
- Developing workshop materials for hands-on learning sessions
- Writing architecture decision records (ADRs) for technical decisions
- Creating developer documentation for APIs, libraries, or frameworks

## When NOT to Use This Skill

- Writing marketing copy or sales-focused content (use copywriting skills)
- Creating UI/UX microcopy (use UX writing patterns)
- Writing academic papers (follow academic conventions instead)
- Composing internal status updates or meeting notes (use summarization skills)
- Writing legal or compliance documents (requires specialized legal writing)

---

## Workflow

### Phase 1: Audience Analysis

**Objective:** Determine who you're writing for, what they already know, and what they need to accomplish.

```
Audience Identification → Knowledge Assessment → Goal Mapping → Content Calibration
```

**Step 1.1 — Identify Primary and Secondary Audiences**
Who is the intended reader? A junior developer learning a new framework? A senior architect evaluating a technology choice? A product manager understanding a technical constraint? Each audience requires different depth, vocabulary, and examples.

**Step 1.2 — Assess Knowledge Level**
Map the audience's likely knowledge: What concepts do they already understand? What terminology is familiar? What's the gap between their current knowledge and the article's content? The article should bridge this gap without being condescending or overwhelming.

**Step 1.3 — Define the Reader's Goal**
What does the reader want to accomplish after reading? "Understand how RAG works" (explainer), "Build a RAG pipeline" (tutorial), "Choose between vector databases" (comparison), or "Learn from our RAG deployment failure" (post-mortem). The goal determines the content type and structure.

**Step 1.4 — Calibrate Content**
Adjust: vocabulary (jargon vs. plain language), code complexity (complete examples vs. snippets), depth of explanation (why vs. how vs. what), and assumed context (standalone vs. series).

### Phase 2: Content Type Selection

**Objective:** Choose the content structure that best serves the reader's goal.

```
Reader Goal → Content Type → Structure Template → Outline → First Draft
```

| Content Type | Reader Goal | Structure | Length |
|---|---|---|---|
| Tutorial | Learn by building | Steps with code | 1500-4000 words |
| Explainer | Understand a concept | Definition → Why → How → Examples | 1000-2500 words |
| Deep Dive | Master advanced topics | Context → Mechanics → Trade-offs → Edge cases | 3000-8000 words |
| Comparison | Make a decision | Criteria → Side-by-side → Verdict | 2000-4000 words |
| Post-mortem | Learn from failure | Timeline → Impact → Root cause → Lessons | 2000-5000 words |
| Workshop | Hands-on learning | Setup → Exercises → Challenges → Solutions | 4000-10000 words |
| ADR | Document a decision | Context → Decision → Consequences | 500-1500 words |

### Phase 3: Structural Planning

**Objective:** Create a detailed outline that ensures logical flow and completeness.

```
Key Messages → Logical Sequence → Section Breakdown → Heading Hierarchy → Time Estimates
```

**Step 3.1 — Define Key Messages**
What are the 3-5 essential points the reader must take away? Everything in the article should support, elaborate, or exemplify these messages.

**Step 3.2 — Sequence Logically**
Order sections to build understanding progressively: foundation → application → nuance → mastery. Never assume the reader will read linearly — use headings that work as a table of contents.

**Step 3.3 — Estimate Reading Time**
Respect the reader's time. A 3000-word article takes ~12 minutes to read. Add code examples and the total engagement time rises to 20-30 minutes. Set expectations with the reader upfront.

### Phase 4: Drafting with Code Integration

**Objective:** Write the first draft with proper code narrative flow and progressive disclosure.

```
Introduction → Conceptual Foundation → Working Code → Explanation → Variations → Conclusion
```

**Step 4.1 — Write the Introduction Last**
The introduction should state: what the reader will learn, why it matters, what they'll build/understand by the end, and prerequisites. Write it after the body so it accurately reflects the content.

**Step 4.2 — Integrate Code Naturally**
Code should illustrate a concept, not be the concept. Every code block needs: context (what this code does), the code itself (complete and runnable), explanation (what each part does), and expected output. Never show code without explaining it.

**Step 4.3 — Apply Progressive Disclosure**
Layer information: start with the simplest version that works, then add complexity. Show the 5-line version before the 50-line production version. Explain the concept before the implementation.

### Phase 5: Revision for Clarity

**Objective:** Eliminate confusion, reduce friction, and ensure every sentence serves the reader.

```
First Draft → Clarity Pass → Technical Accuracy Pass → Readability Pass → Final Polish
```

**Step 5.1 — Clarity Pass**
Read every sentence and ask: "Would a member of my target audience understand this on first read?" If not, simplify. Replace passive voice with active voice. Eliminate unnecessary words. Break long sentences.

**Step 5.2 — Technical Accuracy Pass**
Verify every technical claim, code example, and assertion. Test all code examples. Check version numbers, API names, and command syntax. Have a subject matter expert review if possible.

**Step 5.3 — Readability Pass**
Check: sentence length (target <25 words average), paragraph length (target <4 sentences), heading hierarchy (H2 > H3, never skip levels), code-to-prose ratio (aim for 40-60% prose), and scanning-friendliness (bullets, tables, bold key terms).

### Phase 6: Publication and Maintenance

**Objective:** Publish in the right format and keep the content accurate over time.

```
Format Selection → SEO/Discovery → Publication → Feedback Collection → Maintenance Schedule
```

**Step 6.1 — Format for Platform**
Adapt content for the publication platform: blog (Markdown, front matter), documentation site (structured pages, navigation), GitHub (README, docs folder), or workshop (exercises, solutions).

**Step 6.2 — Set Up Maintenance**
Technical content decays. Set review dates: API docs (every release), tutorials (quarterly), explainers (biannually). Track when referenced tools or versions change.

---

## Advanced Techniques

### 1. The Feynman Technique for Technical Explanations

Richard Feynman's approach to understanding: explain the concept in simple language, identify gaps in your explanation, go back to the source to fill gaps, and simplify further. This technique is the foundation of great technical writing.

```python
# Concept: Event-Driven Architecture

# Level 1: Simple Explanation (What a 10-year-old would understand)
"""
Instead of one person calling another person and waiting for them to finish 
before moving on (like a phone call), imagine you send a text message and 
continue with your day. When the other person replies, you deal with it then. 
That's event-driven: you send a signal and don't wait around.
"""

# Level 2: Developer Explanation (What a junior developer needs)
"""
Event-driven architecture is a design pattern where components communicate 
by sending and receiving events. Instead of direct function calls (Request → 
Response), a component publishes an event (e.g., "OrderPlaced") and other 
components react to it independently. This decouples the sender from the 
receiver — the order service doesn't need to know which other services care 
about new orders.
"""

# Level 3: Architect Explanation (What a senior architect needs)
"""
Event-driven architecture (EDA) uses events as the primary mechanism for 
inter-service communication in distributed systems. Key patterns include:

- Event Notification: Minimal event payload, consumers fetch details
- Event-Carried State Transfer: Full state in event, no callback needed  
- Event Sourcing: Events as the source of truth, state derived from event log
- CQRS: Separate read and write models, often combined with event sourcing

Trade-offs: EDA improves scalability and resilience but introduces eventual 
consistency, debugging complexity (distributed tracing), and schema evolution 
challenges (event versioning). Use when loose coupling and independent scaling 
matter more than strong consistency.
"""
```

### 2. Code Narrative Flow

Every code example should tell a story: setup → action → result → interpretation. Never drop code without context.

```python
# BAD: Code without narrative
"""
```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

embeddings = OpenAIEmbeddings()
db = Chroma.from_documents(docs, embeddings)
results = db.similarity_search("query", k=5)
```
"""

# GOOD: Code with narrative flow
"""
### Step 2: Create the Vector Store

First, we initialize the embedding model. This converts text into 
1536-dimensional vectors that capture semantic meaning:

```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

# Initialize the embedding model
# Each text chunk will be converted to a 1536-dimensional vector
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
```

Next, we create the vector store from our chunked documents. This 
embeds each chunk and stores it for efficient similarity search:

```python
# Create vector store from documents
# This step: embed each chunk → store vectors + metadata
db = Chroma.from_documents(
    documents=chunks,      # Our preprocessed document chunks
    embedding=embeddings,  # The embedding model
    persist_directory="./chroma_db"  # Save to disk for persistence
)

print(f"Indexed {db._collection.count()} chunks")
# Output: Indexed 1,247 chunks
```

Finally, we can search for relevant documents. The query is embedded 
using the same model, and we find the 5 most similar chunks:

```python
# Search for relevant chunks
results = db.similarity_search(
    "How do I configure authentication?",  # The user's query
    k=5  # Return top 5 results
)

# Display results with metadata
for i, doc in enumerate(results):
    print(f"[{i+1}] Source: {doc.metadata['source']}")
    print(f"    {doc.page_content[:200]}...")
    print()
```

The results are ranked by cosine similarity — higher scores mean 
more relevant to the query. In the next step, we'll use these 
results to generate a grounded response.
"""
```

### 3. Progressive Disclosure in Technical Content

Start with the simplest version that works, then layer complexity. This respects cognitive load and serves multiple audience levels.

```python
# LEVEL 1: Minimal Working Example (5 lines)
"""
The simplest way to build a RAG pipeline:

```python
from langchain.chat_models import ChatOpenAI
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA

db = Chroma.from_documents(docs, OpenAIEmbeddings())
qa = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(model="gpt-4"),
    retriever=db.as_retriever()
)
answer = qa.invoke("What is RAG?")
```

This works, but lacks control over chunking, retrieval quality, and 
citation. Let's add those one at a time.
"""

# LEVEL 2: Added Chunking Control (20 lines)
"""
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

# Step 1: Control how documents are split
splitter = RecursiveCharacterTextSplitter(
    chunk_size=512,      # Max tokens per chunk
    chunk_overlap=50,    # Overlap between chunks (preserves context)
    separators=["\n\n", "\n", ". ", " "],  # Split at these boundaries
    length_function=len,  # Use character count (or tiktoken for tokens)
)
chunks = splitter.split_documents(documents)
print(f"Split {len(documents)} docs into {len(chunks)} chunks")
"""
"""

# LEVEL 3: Production-Ready (50+ lines, with metadata, hybrid search, citations)
"""
Now let's build a production pipeline with metadata, hybrid search, 
and source citations. This adds 30 lines but 10x the reliability...

[Full production example with all features]
"""
```

### 4. Post-Mortem Writing Framework

Write post-mortems that are blameless, actionable, and educational. The goal is learning, not punishment.

```markdown
# Post-Mortem Template

## Title: {Incident Name} — {Date}

### TL;DR
{One paragraph: what happened, impact, resolution, root cause}

### Impact
- **Duration:** {start_time} to {end_time} ({total_duration})
- **Affected Services:** {list}
- **Affected Users:** {number or percentage}
- **Revenue Impact:** ${amount} (if applicable)
- **SLA Impact:** {SLO breached, error budget consumed}

### Timeline (UTC)
| Time | Event |
|------|-------|
| {t0} | {Trigger event — what started the incident} |
| {t1} | {Detection — when monitoring alerted} |
| {t2} | {Response start — who acknowledged} |
| {t3} | {Investigation — what was discovered} |
| {t4} | {Mitigation — what was done to stop the bleeding} |
| {t5} | {Resolution — what fixed the root cause} |
| {t6} | {Verification — confirmed the fix works} |

### Root Cause
{Technical explanation of why this happened. Focus on systems, not people. 
Use the "5 Whys" technique to get to the actual root cause.}

### What Went Well
- {Thing 1 that worked as designed}
- {Thing 2 that helped}

### What Went Wrong
- {Thing 1 that failed or was inadequate}
- {Thing 2 that was missing}

### Where We Got Lucky
- {Thing that could have been much worse}

### Action Items
| Priority | Action | Owner | Due Date | Status |
|----------|--------|-------|----------|--------|
| P0 | {Immediate fix} | {person} | {date} | {status} |
| P1 | {Prevention measure} | {person} | {date} | {status} |
| P2 | {Long-term improvement} | {person} | {date} | {status} |

### Lessons Learned
1. {Lesson 1}
2. {Lesson 2}
3. {Lesson 3}
```

### 5. Comparison Post Framework

Write fair, evidence-based comparisons that help readers make informed decisions.

```markdown
# Comparison Post Template

## {Option A} vs {Option B}: {Subtitle} ({Year})

### TL;DR
{One sentence verdict: "Choose {A} if {condition}, choose {B} if {condition}."}

### Quick Comparison
| Criteria | {Option A} | {Option B} | Winner |
|----------|-----------|-----------|--------|
| Performance | {metric} | {metric} | {A/B/Tie} |
| Learning Curve | {description} | {description} | {A/B/Tie} |
| Ecosystem | {description} | {description} | {A/B/Tie} |
| Cost | {price} | {price} | {A/B/Tie} |
| Scalability | {description} | {description} | {A/B/Tie} |
| Community | {description} | {description} | {A/B/Tie} |

### Deep Dive: {Key Criterion 1}
{Detailed analysis with benchmarks, examples, and nuance}

### Deep Dive: {Key Criterion 2}
{Detailed analysis with benchmarks, examples, and nuance}

### When to Choose {Option A}
- {Scenario 1}
- {Scenario 2}
- {Scenario 3}

### When to Choose {Option B}
- {Scenario 1}
- {Scenario 2}
- {Scenario 3}

### Migration Guide
{If relevant: how to switch from one to the other}

### Conclusion
{Restate the verdict with nuance. Acknowledge that neither option is universally better.}
```

### 6. Workshop Material Design

Design workshops that keep participants engaged through active learning, not passive reading.

```python
# Workshop Design Pattern

"""
## Workshop: Building a RAG Pipeline (3 hours)

### Prerequisites (30 min)
- Install Python 3.11+, pip, git
- Clone the starter repo: `git clone {url}`
- Run `pip install -r requirements.txt`
- Verify: `python verify_setup.py` (should print "Ready!")

### Module 1: Foundations (45 min)
**Goal:** Understand RAG architecture
**Format:** Live coding + explanation

Exercise 1.1: Load and chunk a document (15 min)
- Starter code: `exercises/module1/ex1_chunking.py`
- Task: Load `data/sample.pdf`, chunk it, print chunk count
- Checkpoint: `python check_module1_1.py`

Exercise 1.2: Create embeddings and search (15 min)
- Starter code: `exercises/module1/ex2_embedding.py`
- Task: Embed chunks, run a similarity search, display results
- Checkpoint: `python check_module1_2.py`

Exercise 1.3: Build a basic QA chain (15 min)
- Starter code: `exercises/module1/ex3_qa.py`
- Task: Connect retrieval to LLM, ask a question, get an answer
- Checkpoint: `python check_module1_3.py`

### Module 2: Production Patterns (60 min)
**Goal:** Add metadata, hybrid search, and citations
**Format:** Pair programming

Exercise 2.1: Add metadata to chunks (20 min)
Exercise 2.2: Implement hybrid search (20 min)
Exercise 2.3: Add source citations to responses (20 min)

### Module 3: Advanced Topics (45 min)
**Goal:** Reranking, query decomposition, evaluation
**Format:** Group exercise

Exercise 3.1: Implement reranking (15 min)
Exercise 3.2: Multi-query retrieval (15 min)
Exercise 3.3: RAGAS evaluation (15 min)

### Bonus Challenges
- Implement streaming responses
- Add conversation history
- Deploy to production

### Solutions
Available in `solutions/` directory (unzip after workshop)
"""
```

### 7. Architecture Decision Record (ADR) Writing

ADRs capture technical decisions with context and rationale, creating institutional knowledge.

```markdown
# ADR Template

## ADR-{number}: {Title}

**Status:** {Proposed | Accepted | Deprecated | Superseded by ADR-XXX}
**Date:** {YYYY-MM-DD}
**Deciders:** {list of people involved}
**Technical Story:** {link to issue/ticket}

### Context
{What is the issue that we're seeing that is motivating this decision? 
What are the forces at play (technical, business, political, social)? 
Include constraints and requirements.}

### Decision
{What is the change that we're proposing and/or doing? 
Be specific and unambiguous. State what IS being done, not just what 
options were considered.}

### Consequences

#### Positive
- {benefit 1}
- {benefit 2}

#### Negative
- {cost 1}
- {cost 2}

#### Risks
- {risk 1} — Mitigation: {how}

### Alternatives Considered

#### {Alternative 1}
- **Pros:** {pros}
- **Cons:** {cons}
- **Reason for rejection:** {why}

#### {Alternative 2}
- **Pros:** {pros}
- **Cons:** {cons}
- **Reason for rejection:** {why}

### References
- {link 1}
- {link 2}
```

### 8. Anti-Info-Dump Philosophy

The anti-info-dump philosophy is the principle that technical content should present information in the order the reader needs it, not in the order the author learned it. Info dumps happen when writers front-load everything they know before getting to the point. The reader drowns in context before reaching the single fact they came for.

**Why info dumps fail:**
- Readers arrive with a specific question; dumping unrelated context first forces them to wade through noise.
- Cognitive overload: too much information at once makes none of it stick.
- Trust erosion: if the first 500 words don't answer the question, readers leave.

**How to avoid info dumps:**

```markdown
# BAD: Info Dump

## Authentication System

The authentication system was built in Q3 2023. It uses JSON Web Tokens (JWT)
with RS256 signing. The system supports multiple providers including OAuth 2.0,
SAML, and password-based authentication. JWT tokens have a configurable expiry
defaulting to 15 minutes. Refresh tokens are stored in HTTP-only cookies with
a 7-day expiry. The system also supports MFA via TOTP and SMS. Rate limiting
is applied at 100 requests per minute per IP. The system was built using Node.js
with Express and PostgreSQL for token storage.

Now, if you want to know how to add a new authentication provider...

# GOOD: Answer First, Context After

## Adding a New Authentication Provider

**Quick answer:** Create a new class implementing `AuthProvider` interface,
register it in `auth-config.ts`, and add the provider to the login UI.

### Step-by-Step

1. **Create the provider class:**
```typescript
// src/auth/providers/saml-provider.ts
export class SAMLProvider implements AuthProvider {
  async authenticate(credentials: Credentials): Promise<AuthResult> {
    // ...
  }
}
```

2. **Register in config:**
```typescript
// src/auth/auth-config.ts
providers: {
  saml: new SAMLProvider(config.saml),
}
```

### How the Auth System Works

If you want to understand the full auth architecture (JWT, refresh tokens,
MFA, rate limiting), read on...
```

**Key principles:**
1. **Answer first, explain after** — Lead with the actionable information. Context follows.
2. **Progressive layers** — Start with the minimum viable answer, then expand for those who need depth.
3. **Let the reader choose depth** — Use collapsible sections (`<details>`) or "read more" links.
4. **Separate reference from tutorial** — Reference docs (what does this API do?) are different from tutorials (how do I build X?). Don't mix them.
5. **Respect the "just tell me" impulse** — Many readers just want the answer. Make it impossible to miss.

### 9. Version-Anchored Writing

Every piece of technical content should be anchored to specific versions of the tools, languages, and frameworks it describes. This prevents readers from following instructions that don't apply to their version, and it helps content authors know when to update.

**Implementation:**

```markdown
---
title: "Deploying with Docker Compose"
last_updated: 2024-07-10
tested_with:
  docker: "27.0.3"
  docker_compose: "2.28.1"
  ubuntu: "24.04"
  python: "3.12.4"
---

# Deploying with Docker Compose

> **Version note:** This guide was written for Docker Compose v2.28.1
> (the `docker compose` plugin, not the legacy `docker-compose` v1).
> If you're using an older version, some commands may differ.
```

**Version-anchoring rules:**

1. **State versions in the introduction** — Don't bury version requirements in a prerequisites section the reader might skip.
2. **Use version ranges when appropriate** — "Docker 24.0+ (tested with 27.0.3)" is more useful than just "Docker 27.0.3."
3. **Mark version-sensitive content** — When a feature or API changed between versions, note which version introduced or deprecated it.
4. **Date your content** — "Last updated: YYYY-MM-DD" helps readers assess freshness.
5. **Test against stated versions** — If you say "tested with Python 3.12.4," actually test with that version.
6. **Plan for decay** — Add a "review by" date. Tutorial content should be reviewed quarterly. API docs should be reviewed with each release.

---

## Common Patterns

### Pattern 1: Tutorial Structure with Checkpoints

```markdown
# How to Build {Thing}: A Step-by-Step Tutorial

## What You'll Build
{Screenshot or diagram of the final product}

## What You'll Learn
- {Skill 1}
- {Skill 2}
- {Skill 3}

## Prerequisites
- {Requirement 1}
- {Requirement 2}
- Estimated time: {X} minutes

## Step 1: {Action}

{Brief explanation of what we're doing and why}

{Code block}

{Expected output}

✅ **Checkpoint:** You should see {expected result}. If not, {troubleshooting}.

## Step 2: {Action}
{Repeat pattern}

## Step 3: {Action}
{Repeat pattern}

## Next Steps
- {Extension 1}
- {Extension 2}

## Troubleshooting
| Problem | Cause | Solution |
|---------|-------|----------|
| {error message} | {why it happens} | {how to fix} |
```

### Pattern 2: Concept Explainer with Analogies

```markdown
# {Concept}: A Clear Explanation

## The One-Line Explanation
{Concept} is {simplest possible definition}.

## The Analogy
Think of {concept} like {everyday analogy}.
{Explain the analogy in 2-3 sentences, mapping each part to the technical concept}

## How It Actually Works
{Technical explanation with diagram}

## Why It Matters
- {Reason 1 with concrete example}
- {Reason 2 with concrete example}

## Code Example
{Working code with detailed comments}

## Common Misconceptions
- ❌ {Misconception 1} → ✅ {Reality}
- ❌ {Misconception 2} → ✅ {Reality}

## Further Reading
- {Resource 1} — {why it's useful}
- {Resource 2} — {why it's useful}
```

### Pattern 3: Deep Dive with Layered Complexity

```markdown
# {Advanced Topic}: A Deep Dive

## Who This Is For
This article assumes you {prerequisites}. If you're not familiar with 
{concept}, read {prerequisite article} first.

## The Big Picture
{High-level overview with architecture diagram}

## Part 1: {Subtopic} — The Basics
{Foundational explanation}

## Part 2: {Subtopic} — Under the Hood
{Implementation details with source code references}

## Part 3: {Subtopic} — Edge Cases and Failure Modes
{What goes wrong and how to handle it}

## Part 4: {Subtopic} — Production Considerations
{Real-world deployment concerns, monitoring, scaling}

## Performance Analysis
| Configuration | Throughput | Latency (p99) | Memory |
|---------------|-----------|---------------|--------|
| {config_1} | {metric} | {metric} | {metric} |
| {config_2} | {metric} | {metric} | {metric} |

## Decision Framework
{When to use this, when not to, alternatives}

## Summary
{Key takeaways as bullet points}
```

### Pattern 4: Post-Mortem with 5 Whys

```markdown
# Post-Mount: {Incident Name}

## Summary
{One paragraph: what, when, impact, how resolved}

## Timeline
{Chronological event list}

## 5 Whys Analysis

**Why did {symptom} occur?**
→ Because {immediate cause}

**Why did {immediate cause} happen?**
→ Because {underlying cause 1}

**Why did {underlying cause 1} happen?**
→ Because {underlying cause 2}

**Why did {underlying cause 2} happen?**
→ Because {systemic cause}

**Why wasn't this caught earlier?**
→ Because {detection gap}

## Root Cause
{Synthesized root cause from 5 Whys}

## Action Items
{Table of actions with owners and deadlines}

## Lessons
{Numbered list of key takeaways}
```

### Pattern 5: Workshop Exercise Card

```markdown
## Exercise {N}: {Title}

**Time:** {X} minutes
**Goal:** {What the participant will accomplish}
**Starting point:** `{file path}`

### Instructions
1. {Step 1}
2. {Step 2}
3. {Step 3}

### Hints
<details>
<summary>Hint 1 (click to expand)</summary>
{Hint text}
</details>

<details>
<summary>Hint 2 (click to expand)</summary>
{Hint text}
</details>

### Expected Result
```
{Expected output}
```

### Solution
<details>
<summary>Click to reveal solution</summary>

```python
# Solution code
```

**Key concepts:** {list of concepts demonstrated}
</details>
```

---

## Edge Cases & Pitfalls

### 1. Writing for Yourself, Not the Reader
**Problem:** Experts write at their own knowledge level, making content inaccessible to the target audience.
**Solution:** Apply the Feynman technique. Have someone from the target audience read it. If they can't follow it, simplify.

### 2. Code Examples That Don't Run
**Problem:** Code snippets with missing imports, outdated API calls, or context-dependent variables that readers can't reproduce.
**Solution:** Every code example must be complete and runnable. Test all code before publishing. Include all imports.

### 3. The "Curse of Knowledge"
**Problem:** Once you understand something, it's hard to remember what it was like not to understand it. This leads to skipping steps and undefined terms.
**Solution:** Define every technical term on first use. Never assume the reader knows abbreviations or jargon.

### 4. Tutorial Hell (Step-by-Step Without Understanding)
**Problem:** Tutorials that work perfectly but teach readers to follow instructions, not to think. Readers can't adapt when their situation differs.
**Solution:** After each step, explain WHY this step is necessary and what alternatives exist. Include "try modifying X" prompts.

### 5. Overloading the Introduction
**Problem:** Putting too much context, motivation, and background in the introduction before getting to the point.
**Solution:** Keep introductions under 200 words. State what the reader will learn and why it matters, then start the content.

### 6. Missing Error Handling in Examples
**Problem:** Code examples that only show the happy path, leaving readers unprepared for errors.
**Solution:** Show error handling for critical operations. At minimum, mention what can go wrong and how to handle it.

### 7. Inconsistent Naming Conventions
**Problem:** Using different variable names, terminology, or formatting styles across the same article.
**Solution:** Create a terminology glossary for the article. Use find-and-replace to ensure consistency.

### 8. Wall-of-Text Syndrome
**Problem:** Long paragraphs without visual breaks, making content hard to scan and intimidating to read.
**Solution:** Break text into short paragraphs (3-4 sentences max). Use bullets, tables, code blocks, and headings to create visual rhythm.

### 9. Forgetting Mobile Readers
**Problem:** Long code lines that overflow on mobile screens, tables that don't scroll, and images that are too small to read.
**Solution:** Keep code lines under 80 characters. Use horizontal scroll for wide tables. Ensure images are high-resolution.

### 10. Not Updating Outdated Content
**Problem:** Publishing a tutorial that references deprecated APIs, old versions, or discontinued tools.
**Solution:** Add "Last updated: {date}" to every article. Set calendar reminders to review content quarterly.

### 11. Burying the Lead
**Problem:** Making the reader wade through paragraphs before revealing the key information or answer.
**Solution:** Use the inverted pyramid: most important information first, details last. TL;DR at the top.

### 12. Overusing Screenshots
**Problem:** Screenshots of code instead of actual code blocks, making content unsearchable and uncopyable.
**Solution:** Always use text code blocks, not images of code. Use screenshots only for UI/visualization output.

### 13. Neglecting Prerequisites
**Problem:** Assuming readers have the right environment set up without explicitly stating what's needed.
**Solution:** Include a prerequisites section with exact versions, installation commands, and a verification step.

### 14. Excessive Qualification
**Problem:** Hedging every statement with "generally," "usually," "in most cases," which dilutes the message and bores the reader.
**Solution:** Be confident when the statement is generally true. Add qualifications only when the exception is common and important.

### 15. No Call to Action
**Problem:** The article ends without telling the reader what to do next, leaving them with knowledge but no direction.
**Solution:** End with: next steps to try, resources to explore, a community to join, or a project to build.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **Data Analysis** | Content Source | Statistical findings and analysis results are common subjects for technical articles |
| **RAG Implementation** | Content Subject | Many technical articles explain RAG concepts, patterns, and implementations |
| **Data Cleaning** | Content Source | Data cleaning techniques and patterns are frequently documented for teams |
| **Summarization** | Complementary | Summarize long technical content for quick reference or executive summaries |
| **Code Review** | Companion | Technical writing often accompanies code review processes and architecture docs |
| **Knowledge Management** | Output | Technical writing creates the knowledge base that teams rely on |
| **Presentation Skills** | Related | Workshop materials often become presentation decks; parallel skill development |

---

## Output Format Templates

### Standard Tutorial

```markdown
---
title: "How to {Action}: A Step-by-Step Tutorial"
description: "Learn to {goal} with this comprehensive tutorial. Covers {topics}."
date: {YYYY-MM-DD}
author: {Author}
tags: [{tag1}, {tag2}]
estimated_time: {X} minutes
difficulty: {beginner|intermediate|advanced}
---

# How to {Action}: A Step-by-Step Tutorial

> **TL;DR:** {One sentence summary of what you'll build/learn}

## Prerequisites
- {requirement_1}
- {requirement_2}

## What You'll Learn
- ✅ {learning_1}
- ✅ {learning_2}
- ✅ {learning_3}

## Step 1: {Action}
{explanation}

```{language}
{code}
```

{expected output}

## Step 2: {Action}
{explanation}

```{language}
{code}
```

## Summary
{recap key points}

## Next Steps
- {extension_1}
- {extension_2}
```

### Quick Explainer

```markdown
---
title: "{Concept} Explained"
description: "What is {concept} and why does it matter? A clear, concise explanation."
estimated_time: {X} minutes
---

# {Concept} Explained

**{Concept}** is {one-sentence definition}.

## Why It Matters
{2-3 sentences on importance}

## How It Works
{diagram or code example}

## Key Takeaways
- {takeaway_1}
- {takeaway_2}
- {takeaway_3}
```

### Deep Dive Article

```markdown
---
title: "{Advanced Topic}: A Deep Dive"
description: "Master {topic} with this comprehensive guide covering {subtopics}."
estimated_time: {X} minutes
difficulty: advanced
---

# {Advanced Topic}: A Deep Dive

> **Prerequisites:** This article assumes familiarity with {prerequisites}. 
> If you're new to {topic}, start with {prerequisite_article}.

## The Big Picture
{overview with architecture diagram}

## Part 1: {Subtopic}
{detailed content}

## Part 2: {Subtopic}
{detailed content}

## Part 3: {Subtopic}
{detailed content}

## Production Considerations
{deployment, monitoring, scaling advice}

## Decision Framework
{when to use, when not to, alternatives}

## Summary
{key takeaways}
```

### Post-Mortem

```markdown
---
title: "Post-Mortem: {Incident Name}"
date: {YYYY-MM-DD}
status: {draft|published}
severity: {SEV1|SEV2|SEV3}
---

# Post-Mortem: {Incident Name}

## TL;DR
{One paragraph summary}

## Impact
- Duration: {X hours}
- Users affected: {number}
- Revenue impact: ${amount}

## Timeline
{chronological list}

## Root Cause
{technical explanation}

## Action Items
| Action | Owner | Due | Priority |
|--------|-------|-----|----------|
| {action} | {owner} | {date} | {P0-P3} |

## Lessons Learned
1. {lesson}
2. {lesson}
```

### Blog Post

```markdown
---
title: "{Compelling Title That Promises Value}"
description: "{SEO-friendly description, 150-160 chars}"
date: {YYYY-MM-DD}
author: {Author Name}
tags: [{tag1}, {tag2}, {tag3}]
reading_time: {X} min
hero_image: {url or path}
---

# {Compelling Title}

> {One sentence that captures the core promise of this article.}

{1-2 paragraphs: Hook the reader with a relatable problem, surprising fact,
or bold claim. Then state what this article covers and who it's for.}

**In this article, you'll learn:**
- {takeaway 1}
- {takeaway 2}
- {takeaway 3}

---

## {Section 1: The Problem}

{Describe the problem. Make the reader feel understood.}

```{language}
// Example of the problem
{code that illustrates the challenge}
```

## {Section 2: The Solution}

{Introduce the approach. Explain the concept before the implementation.}

```{language}
// Solution code with clear comments
{complete, runnable code}
```

## {Section 3: Going Deeper}

{Advanced variations, edge cases, or production considerations.}

## {Section 4: Results and Trade-offs}

| Aspect | Result |
|--------|--------|
| {metric 1} | {before → after} |

## Summary

{3-5 bullet points recapping key takeaways.}

## What's Next

- {follow-up topic}
- {related technique}
- {community resource}

---

*Last updated: {YYYY-MM-DD} | Tested with: {versions}*
```

### Multi-Part Series

```markdown
---
series: "{Series Title}"
part: {N}
total_parts: {M}
description: "Part {N} of {M}: {subtitle}"
---

# Part {N}: {Title} — {Subtitle}

> **This is Part {N} of the "{Series Title}" series.**
> - [Part 1: {Title}]({url}) — {one-line summary}
> - [Part 2: {Title}]({url}) — {one-line summary}
> - **Part {N}: {Title}** ← You are here
> - [Part {N+1}: {Title}]({url}) — {one-line summary} (coming {date})

{Introduction connecting to previous part and previewing this part.}

**What you'll learn in this part:**
- {specific outcome 1}
- {specific outcome 2}

**Prerequisites:**
- Completion of Parts 1-{N-1}, or familiarity with {concepts}

---

## {Section 1}
{Content building on the series foundation}

## {Section 2}
{New material for this part}

## Series Recap So Far
After Parts 1-{N}, you now know:
- ✅ {concept from Part 1}
- ✅ **New:** {what this part added}

## Up Next
In **Part {N+1}: {Title}**, you'll learn:
- {preview of next content}

---

*Last updated: {YYYY-MM-DD} | Series started: {date}*
```

### Workshop Module

```markdown
---
title: "Workshop: {Topic}"
duration: {X} hours
level: {beginner|intermediate|advanced}
---

# Workshop: {Topic}

## Setup (30 min)
{prerequisites, installation, verification}

## Module 1: {Title} ({X} min)
**Goal:** {what participants will accomplish}

### Exercise 1.1: {Title}
- **Time:** {X} min
- **Instructions:** {steps}
- **Expected result:** {output}

### Exercise 1.2: {Title}
- **Time:** {X} min
- **Instructions:** {steps}
- **Expected result:** {output}

## Module 2: {Title} ({X} min)
{repeat pattern}

## Bonus Challenges
- {challenge_1}
- {challenge_2}

## Solutions
{available after workshop}
```

---

## Rules

1. **Know your audience** — Write for a specific knowledge level, not for everyone. A tutorial for beginners is different from a deep dive for experts. State prerequisites explicitly.
2. **Lead with value** — State what the reader will learn or build in the first paragraph. Respect their time by being upfront about the payoff.
3. **Every code example must run** — Test all code before publishing. Include imports, context, and expected output. Broken code destroys trust.
4. **Use the Feynman technique** — Explain concepts as if teaching someone with no background. If you can't explain it simply, you don't understand it well enough.
5. **Progressive disclosure** — Start simple, add complexity gradually. Show the 5-line version before the 50-line version. Don't overwhelm.
6. **Code needs narrative** — Every code block needs: what it does (context), the code itself, what each part does (explanation), and what happens (output). Never drop code without context.
7. **Break text visually** — Short paragraphs (3-4 sentences), bullets, tables, code blocks, and headings. No walls of text. Target a 40-60% code-to-prose ratio.
8. **Define every term** — Don't assume the reader knows jargon, abbreviations, or acronyms. Define on first use.
9. **Include error handling** — Show what happens when things go wrong, not just the happy path. Readers will encounter errors.
10. **Make it scannable** — Use headings that work as a table of contents. Bold key terms. Use TL;DR sections. Readers scan before they read.
11. **Update regularly** — Technical content decays. Add "Last updated" dates. Set review schedules. Remove or update deprecated information.
12. **End with next steps** — Don't leave the reader stranded. Suggest what to learn, build, or read next.
13. **Be blameless in post-mortems** — Focus on systems and processes, not people. The goal is learning and prevention.
14. **Test your tutorials** — Have someone unfamiliar with the topic follow your tutorial step by step. Where they get stuck, your writing needs improvement.
15. **Write the introduction last** — The introduction should accurately reflect the content. Write it after the body so it doesn't promise something the article doesn't deliver.
