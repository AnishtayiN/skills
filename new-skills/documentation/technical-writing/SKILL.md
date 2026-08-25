---
name: technical-writing
description: >-
  Technical writing, content creation, and knowledge transfer. Covers tutorial structure
  (setup→first success→expand), explainer articles, deep dives, comparison posts, post-mortems,
  workshop materials, Feynman technique (teach to 12-year-old), code narrative flow
  (setup→inciting incident→climax→resolution), progressive disclosure, audience analysis,
  anti-info-dump philosophy, version-anchored writing. نگارش فنی، تولید محتوا، آموزش‌نامه‌نویسی،
  مقاله‌نویسی فنی، مستندسازی. 技术写作，内容创作，教程编写，技术文档，比较文章
---

# Technical Writing & Content Creation

## Overview

Technical writing is the practice of translating complex technical concepts into clear, actionable, and accessible content. Unlike academic writing (which optimizes for rigor) or marketing writing (which optimizes for persuasion), technical writing optimizes for **understanding and action**. The reader should finish your piece knowing something they didn't before, and being able to do something they couldn't before.

This skill covers the full lifecycle of technical content: from audience analysis and structure planning, through writing and revision, to publication and maintenance. It addresses the specific challenges of writing about software—rapidly evolving tools, version-specific behavior, code examples that must actually work, and audiences that range from curious beginners to seasoned architects.

**Core Philosophy:** Great technical writing is invisible. The reader doesn't admire your prose—they absorb your knowledge. If someone says "that was a really well-written article," you've done well. If they say "I finally understand X," you've done brilliantly.

**The Anti-Info-Dump Principle:** Content is not a database. Dumping every fact you know about a topic is not teaching—it's referential. Teaching means selecting, sequencing, and scaffolding information so the reader builds understanding incrementally. Every paragraph must earn its place by advancing the reader's comprehension.

## When to Use This Skill

- Writing tutorials that guide readers from zero to working implementation
- Creating explainer articles that demystify complex concepts or architectures
- Producing deep dives that explore the internals of a system, algorithm, or pattern
- Writing comparison posts that help readers choose between tools, libraries, or approaches
- Authoring post-mortems that communicate what went wrong, why, and what was learned
- Developing workshop materials (labs, exercises, handouts) for live or asynchronous learning
- Creating technical blog posts for company engineering blogs or personal portfolios
- Writing API documentation, README files, or inline code documentation
- Preparing conference talk slides and speaker notes
- Drafting RFCs, design documents, or architectural decision records

## When NOT to Use This Skill

- Writing marketing copy, sales emails, or promotional content (different skill, different goals)
- Creating legal documents, compliance reports, or formal contracts (requires legal expertise)
- Authoring academic papers with formal citation requirements (different structure and norms)
- Writing social media posts shorter than a paragraph (too brief for this framework)
- Producing video scripts without accompanying text (video has its own grammar)
- Creating API specifications in OpenAPI/Swagger format (more schema than prose)

## Workflow

### Phase 1: Audience Analysis

Before writing a single word, understand who you're writing for.

```python
audience_profile = {
    "primary_persona": {
        "role": "Backend developer with 3 years of experience",
        "knowledge_level": "Intermediate — knows HTTP, databases, basic design patterns",
        "goal": "Understand how to implement CQRS in their existing Node.js application",
        "pain_points": [
            "Confused by too many blog posts that explain CQRS abstractly without code",
            "Worried about over-engineering a simple CRUD application",
            "Needs to justify the approach to their team lead",
        ],
        "time_budget": "15-20 minutes to read; 1-2 hours to try the code",
        "reading_context": "Desktop, focused work session (not mobile, not commute)",
    },
    "secondary_persona": {
        "role": "Team lead evaluating architecture patterns",
        "knowledge_level": "Advanced — familiar with DDD, knows when patterns apply",
        "goal": "Quickly assess whether CQRS fits their team's needs",
        "reading_context": "Skimming for structure and key takeaways, not reading every line",
    },
}

def audience_checklist(topic: str) -> list:
    """Generate questions to answer before writing about a topic."""
    return [
        f"Who is the primary reader of '{topic}'?",
        "What do they already know about this topic?",
        "What do they NOT know that they need to learn?",
        "What will they DO with this knowledge after reading?",
        "How much time will they invest in reading this?",
        "What is their emotional state? (Frustrated? Curious? Urgent?)",
        "What alternatives have they already tried or read?",
        "What objections or skepticism might they have?",
    ]

# Apply before every piece of content
questions = audience_checklist("Implementing CQRS in Node.js")
for q in questions:
    print(f"  → {q}")
```

### Phase 2: Content Type Selection

Choose the right format for your goal:

```python
CONTENT_TYPES = {
    "tutorial": {
        "goal": "Guide reader from zero to working implementation",
        "structure": "Setup → First Success → Expand → Deepen → Polish",
        "best_for": "Specific tools, libraries, frameworks, features",
        "length": "1500-4000 words",
        "key_principle": "Get to a working result as fast as possible, then iterate",
    },
    "explainer": {
        "goal": "Demystify a concept or idea",
        "structure": "Hook → Context → Core Concept → Example → Implications",
        "best_for": "Architecture patterns, design decisions, abstract ideas",
        "length": "1200-3000 words",
        "key_principle": "Use concrete analogies before abstract definitions",
    },
    "deep_dive": {
        "goal": "Reveal internals, edge cases, and advanced behavior",
        "structure": "Surface Overview → Assumptions → Internals → Edge Cases → Advanced",
        "best_for": "Library internals, algorithm explanations, performance analysis",
        "length": "3000-6000 words",
        "key_principle": "Build mental models, not just instructions",
    },
    "comparison": {
        "goal": "Help reader make an informed choice between options",
        "structure": "Context → Criteria → Head-to-Head → Trade-offs → Recommendation",
        "best_for": "Library/tool selection, architectural approaches, methodologies",
        "length": "2000-4000 words",
        "key_principle": "Be honest about trade-offs; no tool is universally best",
    },
    "post_mortem": {
        "goal": "Share lessons from an incident or failure",
        "structure": "Timeline → Impact → Root Cause → Fix → Lessons → Prevention",
        "best_for": "Outages, bugs, failed projects, security incidents",
        "length": "1500-3000 words",
        "key_principle": "Blame systems, not people; focus on prevention, not punishment",
    },
    "workshop": {
        "goal": "Enable hands-on learning in a structured session",
        "structure": "Prerequisites → Setup → Guided Exercises → Challenges → Wrap-up",
        "best_for": "Training sessions, conference workshops, team learning",
        "length": "Variable (30 min to full day)",
        "key_principle": "Every exercise should produce something working; dead ends kill motivation",
    },
}

def select_content_type(goal: str, audience: str, time_budget: str) -> str:
    """Recommend the best content type based on constraints."""
    if "zero to working" in goal.lower() or "tutorial" in goal.lower():
        return "tutorial"
    elif "explain" in goal.lower() or "what is" in goal.lower():
        return "explainer"
    elif "internals" in goal.lower() or "how it works" in goal.lower():
        return "deep_dive"
    elif "compare" in goal.lower() or "vs" in goal.lower() or "which" in goal.lower():
        return "comparison"
    elif "incident" in goal.lower() or "postmortem" in goal.lower():
        return "post_mortem"
    elif "workshop" in goal.lower() or "hands-on" in goal.lower():
        return "workshop"
    return "explainer"  # Default
```

### Phase 3: The Feynman Technique — Write for a 12-Year-Old

Richard Feynman's approach to understanding: if you can't explain it simply, you don't understand it well enough.

```python
def feynman_check(section_text: str) -> dict:
    """
    Analyze a section of text for Feynman technique compliance.
    Flags jargon, unnecessary complexity, and missing analogies.
    """
    jargon_words = [
        "abstraction", "polymorphism", "idempotent", "eventual consistency",
        "throughput", "latency", "partitioning", "replication", "serialization",
        "dependency injection", "inversion of control", "middleware", "schema",
        "canonical", "entropy", "coupling", "cohesion", "orthogonal",
    ]

    findings = {"jargon_found": [], "sentences_too_long": [], "missing_analogies": []}

    sentences = section_text.split(".")
    for sent in sentences:
        words = sent.split()
        if len(words) > 30:
            findings["sentences_too_long"].append(sent.strip()[:80] + "...")
        for jargon in jargon_words:
            if jargon.lower() in sent.lower():
                findings["jargon_found"].append(jargon)

    analogy_indicators = [
        "think of it like", "imagine", "analogy", "metaphor", "similar to",
        "like when", "as if", "for example", "for instance", "picture this",
    ]
    has_analogy = any(ind in section_text.lower() for ind in analogy_indicators)
    if not has_analogy and len(section_text) > 500:
        findings["missing_analogies"].append(
            "No analogy or concrete example found in a long section"
        )

    return findings

# The Feynman Test: After writing, ask yourself:
# "Could I explain this to a smart 12-year-old?"
# If not, simplify until you can.
```

### Phase 4: Code Narrative Flow

Structure code-heavy content as a story:

```
NARRATIVE STRUCTURE:
1. SETUP — What are we building? Why? What's the starting point?
2. INCITING INCIDENT — The problem, limitation, or challenge that demands change
3. RISING ACTION — Step-by-step implementation, each step building on the last
4. CLIMAX — The "aha!" moment where it all comes together
5. RESOLUTION — What we've learned, when to use this, when NOT to
```

```python
def validate_narrative_flow(outline: dict) -> list:
    """Validate that an outline follows the code narrative flow."""
    required_sections = ["setup", "inciting_incident", "rising_action", "climax", "resolution"]
    issues = []
    for section in required_sections:
        if section not in outline or not outline[section]:
            issues.append(f"Missing section: {section}")

    if "setup" in outline and "climax" in outline:
        setup_pos = outline.get("setup", {}).get("position", 0)
        climax_pos = outline.get("climax", {}).get("position", 999)
        if setup_pos >= climax_pos:
            issues.append("Setup must come before climax")

    if "rising_action" in outline:
        has_code = "code" in str(outline["rising_action"]).lower()
        if not has_code:
            issues.append("Rising action should include code, not just text")

    return issues

# Example narrative for a CQRS tutorial:
#
# SETUP: "You have a simple Express.js app with a /users endpoint.
#         It queries the same database for reads and writes."
#
# INCITING INCIDENT: "Your traffic grows. Reads spike during business hours.
#                     Writes spike at night during batch imports.
#                     Your single database can't optimize for both."
#
# RISING ACTION: "Step 1: Define separate read and write models.
#                 Step 2: Create the command handler.
#                 Step 3: Create the query handler.
#                 Step 4: Wire it up with event sourcing."
#
# CLIMAX: "You run the load test. Read latency drops 10x. Write throughput
#          triples. The system handles the asymmetric load gracefully."
#
# RESOLUTION: "CQRS isn't always the answer. It adds complexity.
#              Use it when read/write patterns diverge significantly."
```

### Phase 5: Progressive Disclosure

Layer information from simple to complex:

```python
PROGRESSIVE_DISCLOSURE_LAYERS = {
    "layer_1_basics": {
        "description": "The absolute minimum to understand the concept",
        "audience": "Everyone who reads the article",
        "technique": "Simple language, concrete examples, no jargon",
        "example": "A function that takes two numbers and returns their sum.",
    },
    "layer_2_intermediate": {
        "description": "The practical details needed to use it effectively",
        "audience": "Readers who want to apply the concept",
        "technique": "Code examples, configuration options, common patterns",
        "example": "How to handle edge cases: NaN, overflow, string inputs.",
    },
    "layer_3_advanced": {
        "description": "Internals, edge cases, and optimization",
        "audience": "Readers who need to master the topic",
        "technique": "Deep dives, benchmarks, implementation details",
        "example": "How the compiler optimizes the function, memory layout.",
    },
    "layer_4_reference": {
        "description": "Complete API, all parameters, error codes",
        "audience": "People who already understand and need a reference",
        "technique": "Tables, parameter lists, complete examples",
        "example": "Function signature, all overloads, type constraints.",
    },
}

def apply_progressive_disclosure(content: str, layer: str) -> str:
    """Wrap content in a progressive disclosure container."""
    if layer == "layer_1_basics":
        return f"""## Concept

{content}

> **Key takeaway:** [One sentence summary of the core idea]"""
    elif layer == "layer_2_intermediate":
        return f"""<details>
<summary><strong>Dive deeper: Implementation details</strong></summary>

{content}

</details>"""
    elif layer == "layer_3_advanced":
        return f"""<details>
<summary><strong>Advanced: Internals and edge cases</strong></summary>

{content}

</details>"""
    elif layer == "layer_4_reference":
        return f"""<details>
<summary><strong>Reference: Complete API</strong></summary>

{content}

</details>"""
    return content
```

### Phase 6: Version-Anchored Writing

Pin content to specific versions to prevent staleness:

```python
def version_anchor(article: dict) -> str:
    """Add version anchoring metadata to an article."""
    return f"""---
title: {article['title']}
last_updated: {article.get('last_updated', 'YYYY-MM-DD')}
versions:
  primary: {article.get('primary_version', 'v1.0.0')}
  tested_with:
{chr(10).join(f'    - {tool}: {ver}' for tool, ver in article.get('tested_with', {}).items())}
  known_broken_after: {article.get('known_broken_after', 'TBD')}
  verified_by: {article.get('verified_by', 'author')}
---

> **⚠️ Version Note:** This article was written and tested with {article.get('primary_version', 'v1.0.0')}.
> If you're using a different version, some details may have changed.
> Last verified: {article.get('last_updated', 'YYYY-MM-DD')}.
"""

# VERSION ANCHORING CHECKLIST:
# - Pin every code example to a specific version
# - Record when the article was last tested
# - Note known versions where the content breaks
# - Include a "last verified" date
# - Use semantic versioning in dependencies
# - Test on CI before publishing (automated freshness check)
```

### Phase 7: The Revision Process

```python
REVISION_CHECKLIST = {
    "structural": [
        "Does the title accurately reflect the content?",
        "Is the introduction hooking? Does it establish why the reader should care?",
        "Does each section have a clear purpose and flow logically to the next?",
        "Is there a clear conclusion or next-steps section?",
        "Are headings descriptive (not clever but vague)?",
    ],
    "technical": [
        "Does every code example actually run? (Test it!)",
        "Are all commands, APIs, and syntax current for the pinned version?",
        "Are error scenarios addressed?",
        "Are there any hidden assumptions about the reader's environment?",
        "Are the technical claims accurate and verifiable?",
    ],
    "clarity": [
        "Can any sentence be shorter without losing meaning?",
        "Are there unnecessary adjectives, adverbs, or qualifiers?",
        "Is every pronoun unambiguous (he/she/it/they/this/that)?",
        "Are there transitions between paragraphs?",
        "Would a non-native English speaker understand this?",
    ],
    "completeness": [
        "Are prerequisites explicitly stated?",
        "Is the reader told what they'll have working by the end?",
        "Are all pieces of the puzzle introduced before they're used?",
        "Are there any gaps in the step-by-step flow?",
        "Is there a way for the reader to verify they've done it correctly?",
    ],
    "accessibility": [
        "Are images described with alt text?",
        "Is color the only way information is conveyed?",
        "Are code blocks syntax-highlighted?",
        "Is the reading level appropriate for the audience?",
        "Are there multiple entry points for different skill levels?",
    ],
}

def run_revision_pass(draft: str, checklist_category: str) -> list:
    """Simulate running a revision pass against a specific checklist."""
    issues = []
    checklist = REVISION_CHECKLIST.get(checklist_category, [])
    for item in checklist:
        issues.append({"checklist_item": item, "status": "needs_review"})
    return issues
```

## Advanced Techniques

### Technique 1: The Hook → Context → Stakes Pattern

Every article needs a hook that makes the reader want to continue:

```python
HOOK_PATTERNS = {
    "problem_first": {
        "structure": "Start with a relatable problem, then promise a solution.",
        "example": """Every time you deploy, your tests pass locally but fail in production.
You've checked the code. You've checked the config. You've checked the environment.
The problem isn't in any of those—it's in the assumptions they share.
Here's how to surface hidden assumptions before they surface as outages.""",
        "best_for": "Tutorials, how-to guides, debugging articles",
    },
    "surprising_fact": {
        "structure": "Lead with something counterintuitive or surprising.",
        "example": """Your database is 10x slower on reads than it needs to be,
and the fix has nothing to do with indexes, caching, or query optimization.
It's about the shape of your data—and most developers never think about it.""",
        "best_for": "Deep dives, explainer articles, performance analysis",
    },
    "story_first": {
        "structure": "Open with a brief narrative, then extract the lesson.",
        "example": """At 3 AM on a Tuesday, our API started returning 500 errors
for exactly 12% of requests. Not 11%. Not 13%. Exactly 12%.
It took us three days to find the cause: a leap-year bug in a date library
we didn't even know we were using.""",
        "best_for": "Post-mortems, war stories, experience reports",
    },
    "question_first": {
        "structure": "Pose a question the reader wants answered.",
        "example": """What's the difference between a library that handles 100 requests/second
and one that handles 100,000? It's not the algorithm. It's not the language.
It's the architecture—and it's simpler than you think.""",
        "best_for": "Comparison posts, explainer articles, architecture discussions",
    },
}
```

### Technique 2: The "Show, Don't Tell" Principle for Code

```python
# BAD: Telling without showing
bad_example = """
Caching improves performance by storing frequently accessed data in memory.
You should use caching when your application reads the same data repeatedly.
Redis is a popular caching solution that supports various data structures.
"""

# GOOD: Showing with a narrative
good_example = """
Every time a user visits their dashboard, your API makes this query:

```sql
SELECT * FROM dashboard_widgets WHERE user_id = ? ORDER BY position;
```

That query hits the database 50,000 times per hour. The data doesn't change
between deploys. Here's what happens when we cache it:

| Metric | Before | After |
|--------|--------|-------|
| p50 latency | 45ms | 2ms |
| p99 latency | 230ms | 8ms |
| DB connections | 340 | 89 |

The change? One line in the query handler:
"""

# Show the actual code change
# Show the actual benchmark results
# Let the reader draw the conclusion
```

### Technique 3: The Anti-Info-Dump Framework

```python
def filter_info_dump(paragraphs: list) -> list:
    """
    Review paragraphs and flag those that are informational without being instructional.
    Each paragraph should advance the reader's understanding, not just state facts.
    """
    filtered = []
    for i, para in enumerate(paragraphs):
        advances = any([
            "here's how" in para.lower(),
            "this means" in para.lower(),
            "because" in para.lower(),
            "the result is" in para.lower(),
            "you can now" in para.lower(),
            "notice that" in para.lower(),
            "this works because" in para.lower(),
            "```" in para,
        ])

        purely_informational = all([
            not advances,
            para.count(";") > 2,
            "supports" in para.lower() and "and" in para.lower(),
            len(para) > 200 and para.count(".") < 3,
        ])

        if purely_informational:
            filtered.append(f"⚠️ INFO DUMP (paragraph {i+1}): Consider removing or adding context")
        else:
            filtered.append(para)

    return filtered

# THE ANTI-INFO-DUMP RULES:
# 1. Every fact needs a "so what?" — Why does the reader care?
# 2. Every feature needs a use case — When would someone use this?
# 3. Every capability needs a comparison — How does it compare to the alternative?
# 4. Every option needs a recommendation — Which should the reader choose?
# 5. Every abstraction needs a concrete example — Show, don't just describe.
```

### Technique 4: Headings as Navigation

```python
def validate_headings(headings: list) -> dict:
    """Validate that headings form a clear navigation structure."""
    issues = []
    suggestions = []

    for i, heading in enumerate(headings):
        vague_words = ["introduction", "overview", "background", "miscellaneous", "other", "notes"]
        if any(vw in heading.lower() for vw in vague_words):
            issues.append(f"Heading '{heading}' is vague — consider being more specific")

        if heading.strip().endswith("?"):
            suggestions.append(f"Consider rephrasing '{heading}' as a statement instead of a question")

        if heading and heading[0].islower():
            suggestions.append(f"Heading '{heading}' should start with a capital letter")

        if len(heading.split()) > 10:
            issues.append(f"Heading '{heading}' is too long — aim for 3-7 words")

    return {"issues": issues, "suggestions": suggestions}

# GOOD HEADING PATTERNS:
# ✅ "Setting Up the Development Environment" (action-oriented)
# ✅ "Why CQRS Fails for Simple CRUD" (specific claim)
# ✅ "Comparing Redis, Memcached, and MemSQL" (concrete)
# ❌ "Introduction" (vague, adds no value)
# ❌ "Some Thoughts on Performance" (unclear scope)
# ❌ "The" (incomplete)
```

### Technique 5: Writing for Skimmers (The 80/20 Rule)

```python
SKIMMER_OPTIMIZATION = {
    "summary_box": {
        "placement": "Immediately after the introduction",
        "content": "3-5 bullet points covering: what this is, why it matters, when to use it, key trade-off",
        "template": """
## TL;DR
- **What:** [One sentence description]
- **Why:** [One sentence motivation]
- **When to use:** [One sentence criteria]
- **Key trade-off:** [One sentence honesty]
- **Time to implement:** [Estimate]
""",
    },
    "section_summaries": {
        "placement": "First sentence of each section",
        "content": "A single sentence that captures the section's main point",
        "rationale": "A skimmer reading only first sentences should get the gist",
    },
    "code_highlighting": {
        "technique": "Add comments to code blocks highlighting the key lines",
        "example": """
# THIS IS THE KEY LINE — everything else is boilerplate
result = cache.get_or_set(f"user:{user_id}", lambda: db.query(user_id), ttl=300)
""",
    },
    "bold_key_phrases": {
        "technique": "Bold the most important phrase in each paragraph",
        "rationale": "A skimmer reading only bold text should understand the core argument",
        "example": """
**CQRS separates read and write models.** This means your read database can be
optimized for fast queries, while your write database ensures consistency.
**The trade-off is complexity.** You now have two schemas to maintain.
""",
    },
}
```

### Technique 6: Version-Specific Code Examples

```python
def generate_versioned_code_block(code: str, version: str, notes: list = None) -> str:
    """Wrap code in a versioned container with compatibility notes."""
    block = f"""```python
# Tested with: {version}
{code}
```"""
    if notes:
        block += "\n\n"
        for note in notes:
            block += f"> **Note ({note.get('version', 'latest')}):** {note['text']}\n"
    return block

# VERSION ANCHORING PATTERNS:
# 1. Pin the language/runtime version: "Python 3.11+"
# 2. Pin library versions: "pip install fastapi==0.104.1"
# 3. Pin OS/environment: "Ubuntu 22.04, Node 20 LTS"
# 4. Note breaking changes: "⚠️ This API changed in v3.0"
# 5. Provide migration paths: "If upgrading from v2, see migration guide"
```

### Technique 7: The "Explain Like I'm 5" Cascade

```python
EXPLAIN_CASCADE = {
    "level_1_intuition": {
        "goal": "Give a gut-level understanding",
        "technique": "Use a real-world analogy",
        "example": "A load balancer is like a restaurant hostess — it distributes incoming "
                    "customers (requests) to available tables (servers) so no single table "
                    "gets overwhelmed.",
        "word_count": "2-3 sentences",
    },
    "level_2_concept": {
        "goal": "Explain the mechanism",
        "technique": "Describe how it works in plain language",
        "example": "When a request arrives, the load balancer checks which backend server is "
                    "least busy and routes the request there. If a server goes down, the load "
                    "balancer stops sending traffic to it.",
        "word_count": "1 paragraph",
    },
    "level_3_technical": {
        "goal": "Provide implementation details",
        "technique": "Show code and configuration",
        "example": "Here's an nginx load balancer config with round-robin and health checks...",
        "word_count": "1-2 paragraphs with code",
    },
    "level_4_expert": {
        "goal": "Cover edge cases and internals",
        "technique": "Discuss algorithms, failure modes, and advanced configuration",
        "example": "Session affinity uses consistent hashing to ensure that a user's requests "
                    "always hit the same backend, which matters for WebSocket connections and "
                    "in-memory session stores.",
        "word_count": "As needed",
    },
}
```

## Common Patterns

### Pattern 1: The Tutorial Template

```markdown
# [Title: What You'll Build]

## What You'll Learn
By the end of this tutorial, you will have [specific outcome].
Estimated time: [X] minutes.

## Prerequisites
- [Requirement 1]
- [Requirement 2]
- [What the reader should already know]

## Step 1: [Setup / Getting Started]
[Establish the working environment. Keep it minimal.]
```bash
# The ONE command to get started
[command]
```

## Step 2: [First Success — The Smallest Useful Thing]
[Get something working that proves the approach. This is the most important step.]
```[language]
# This should produce visible output within 30 seconds of pasting
[code]
```
Expected output:
```
[what they should see]
```

## Step 3: [Expand — Build On the Foundation]
[Add one more feature or capability. Each step builds on the previous.]

## Step 4: [Deepen — Handle Real-World Concerns]
[Error handling, edge cases, performance considerations.]

## Step 5: [Polish — Production Readiness]
[Testing, monitoring, deployment considerations.]

## What You've Learned
- [Key takeaway 1]
- [Key takeaway 2]
- [Key takeaway 3]

## Next Steps
- [Link to related tutorial]
- [Link to deep dive on the topic]
- [Link to production checklist]

## Troubleshooting
| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| [common error] | [cause] | [fix] |
```

### Pattern 2: The Comparison Post Template

```markdown
# [Tool A] vs [Tool B]: When to Use Which

## The Quick Answer
| Criterion | [Tool A] | [Tool B] |
|-----------|----------|----------|
| Best for | [scenario] | [scenario] |
| Learning curve | [easy/medium/hard] | [easy/medium/hard] |
| Performance | [characteristic] | [characteristic] |
| Community | [size/support level] | [size/support level] |

## The Detailed Breakdown

### Performance
[Quantified benchmarks with methodology]

### Developer Experience
[Subjective but honest assessment]

### Ecosystem & Integrations
[Plugin availability, library support]

### When to Choose [Tool A]
- [Specific scenario 1]
- [Specific scenario 2]

### When to Choose [Tool B]
- [Specific scenario 1]
- [Specific scenario 2]

### When to Choose Neither
[Alternative that might be better]

## The Honest Truth
[What neither tool's marketing page will tell you]
```

### Pattern 3: The Post-Mortem Template

```markdown
# Post-Mortem: [Incident Title]

## Summary
- **Date:** [date]
- **Duration:** [hours/minutes]
- **Impact:** [what users experienced, how many affected]
- **Severity:** [P0/P1/P2/P3]
- **Author:** [name]
- **Status:** [investigating/identified/resolved/prevented]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | [What happened] |
| HH:MM | [What was detected] |
| HH:MM | [What action was taken] |
| HH:MM | [Resolution] |

## Root Cause
[Clear, blameless explanation of WHY this happened.
Focus on the systemic conditions that allowed the failure.]

## What Went Well
- [Thing 1 that worked]
- [Thing 2 that worked]

## What Went Wrong
- [Thing 1 that failed]
- [Thing 2 that failed]

## Where We Got Lucky
- [Thing that could have been much worse]

## Action Items
| # | Action | Owner | Priority | Status |
|---|--------|-------|----------|--------|
| 1 | [Concrete action] | [person] | [high/med/low] | [status] |
| 2 | [Concrete action] | [person] | [high/med/low] | [status] |

## Lessons Learned
- [Lesson 1]
- [Lesson 2]
```

### Pattern 4: The Explainer Article Structure

```markdown
# [Concept]: A Complete Guide

## The One-Sentence Summary
[What is this, in plain language?]

## Why Should You Care?
[The problem this solves or the opportunity it creates.
Make it concrete: "If your app does X, this matters because Y."]

## The Analogy
[A real-world analogy that captures the essence.
"The easiest way to think about it is..." or "Imagine you're..."]

## How It Works (The Core Concept)
[2-3 paragraphs explaining the mechanism. Use diagrams if possible.]

## A Working Example
[Complete, runnable code that demonstrates the concept.
Start simple, then add complexity.]

## When to Use It
- [Specific scenario 1]
- [Specific scenario 2]
- [Specific scenario 3]

## When NOT to Use It
- [Scenario where it's overkill]
- [Scenario where it makes things worse]

## Common Misconceptions
- **Myth:** [Common wrong belief]
  **Reality:** [Correct understanding]

## Further Reading
- [Link to official docs]
- [Link to advanced tutorial]
- [Link to related concept]
```

### Pattern 5: The Workshop/Lab Template

```markdown
# Workshop: [Title]

## Duration: [X] hours
## Level: [Beginner/Intermediate/Advanced]
## Participants: [Number]

## What You'll Build
[End-state description with screenshot or demo link]

## Prerequisites
### Required Software
- [Software 1]: [version] — [install link]
- [Software 2]: [version] — [install link]

### Required Knowledge
- [Concept the reader should already understand]

### Pre-Workshop Setup (do this BEFORE the session)
```bash
[setup commands]
```
Verify it works:
```bash
[verification command]
```

## Lab 1: [Title] (XX minutes)
### Goal
[What the participant will accomplish]

### Instructions
1. [Step 1 with exact commands]
2. [Step 2 with expected output]
3. [Step 3]

### Checkpoint
Your output should look like this:
```
[expected output]
```
If it doesn't: [common issue] → [fix]

### Discussion Questions
- [Question that connects the exercise to the bigger picture]

## Lab 2: [Title] (XX minutes)
[Same structure as Lab 1]

## Lab 3: [Title] (XX minutes)
[Same structure as Lab 1]

## Bonus Challenges (for fast finishers)
- [Challenge 1]
- [Challenge 2]

## Wrap-Up
### Key Takeaways
- [Takeaway 1]
- [Takeaway 2]
- [Takeaway 3]

### Resources for Continued Learning
- [Resource 1]
- [Resource 2]

### Feedback
[Link to feedback form]
```

## Edge Cases & Pitfalls

1. **Writing Before Outlining:** Jumping straight to prose leads to wandering, unfocused articles. Always outline first—even a rough bullet list provides essential structure.

2. **Assuming Too Much Knowledge:** If you use a term, define it. If you reference a tool, link to its installation guide. Your reader's time is valuable; don't make them Google basics.

3. **Code Without Context:** Pasting code without explaining WHY each line matters is not teaching—it's a reference manual. Every code block should be preceded by intent and followed by explanation.

4. **The "Everything is Great" Bias:** Comparison posts and tool reviews that only list positives are marketing, not writing. Readers trust honest trade-off analysis more than cheerleading.

5. **Outdated Code Examples:** The #1 source of reader frustration. Test every code example. Pin versions. Add "last verified" dates. Consider CI pipelines that test your article's code.

6. **Wall of Text Syndrome:** More than 4-5 paragraphs without a heading, code block, image, or list creates cognitive overload. Break up dense text with structural variety.

7. **Premature Optimization in Writing:** Don't add advanced topics "just in case." Start simple. Use progressive disclosure. Let readers self-select their depth.

8. **Forgetting the "Why":** Explaining WHAT to do without explaining WHY builds followers, not understanding. Readers who understand the "why" can adapt when your specific instructions become outdated.

9. **Passive Voice Overuse:** "The data is processed by the system" vs "The system processes the data." Active voice is clearer, shorter, and more engaging. Use it by default.

10. **Too Many Options:** "You can use A, B, C, D, or E" is not helpful. Recommend one default, explain when to deviate, and leave the rest as a reference footnote.

11. **Missing Error Paths:** Tutorials that only show the happy path leave readers stranded when things go wrong. Always include "If you see X error, it means Y, and you can fix it by Z."

12. **Inconsistent Terminology:** Using "user," "customer," "client," and "account" interchangeably creates confusion. Pick one term and use it consistently throughout.

13. **No Visual Aids:** Architecture and data flow concepts are poorly served by text alone. Use diagrams (Mermaid, Excalidraw, or even ASCII art) for anything structural.

14. **Ignoring Mobile Readers:** Code blocks that require horizontal scrolling, tiny fonts, and wide tables make content unusable on mobile. Test responsive rendering.

15. **Publishing Without Review:** Even experienced writers miss errors. Have someone else read your work—ideally someone who matches your target audience. Fresh eyes catch what yours miss.

## Integration with Other Skills

| Skill | Integration Point | How |
|-------|-------------------|-----|
| `data-cleaning` | Documentation of pipelines | Technical writing documents cleaning processes for team knowledge transfer |
| `summarization` | Content condensation | Summarization techniques help create TL;DR sections and executive summaries |
| `clean-architecture` | Architecture documentation | Writing about system design requires clear explanation of architectural decisions |
| `code-explanation` | Inline documentation | The same "explain clearly" principles apply to code comments and docstrings |
| `prompt-engineering` | AI-assisted writing | LLMs can help draft, structure, and refine technical content |
| `documentation` | Doc generation | Technical writing is the prose layer of documentation systems |
| `api-design` | API documentation | Good API docs require both technical accuracy and clear writing |
| `system-design` | Design documents | Architecture Decision Records (ADRs) are technical writing artifacts |
| `testing` | Test documentation | Test plans, test strategies, and bug reports all benefit from clear writing |
| `git-workflow` | Commit messages and PRs | Good commit messages and PR descriptions follow the same clarity principles |

## Output Format Templates

### Standard Template (Blog Post)

```markdown
---
title: [Descriptive Title with Keywords]
date: YYYY-MM-DD
author: [Name]
tags: [tag1, tag2, tag3]
reading_time: [X] minutes
version_tested: [vX.Y.Z]
---

# [Title]

**TL;DR:** [2-3 sentence summary of the entire article]

## Introduction
[Hook → Context → What the reader will learn → Why it matters]

## [Main Section 1]
[Content with code examples, diagrams, and explanations]

## [Main Section 2]
[Content building on Section 1]

## [Main Section 3]
[Content completing the narrative arc]

## Conclusion
[Key takeaways → Next steps → Call to action]

## Further Reading
- [Related resource 1]
- [Related resource 2]
```

### Quick Template (Social/Preview)

```markdown
# [Title]

**What:** [One sentence]
**Why:** [One sentence]
**When:** [One sentence]
**Time:** [X minutes to read]

[Link to full article]
```

### Deep Template (Long-form Analysis)

```markdown
# [Title]: A Deep Dive

## Abstract
[3-5 sentence executive summary]

## Table of Contents
[Linked TOC for navigation]

## Background & Context
[Why this topic matters now]

## Analysis
### [Sub-section 1]
[Detailed analysis with data]

### [Sub-section 2]
[Detailed analysis with evidence]

### [Sub-section 3]
[Detailed analysis with benchmarks]

## Implications
[What this means for the field]

## Recommendations
[Prioritized, actionable advice]

## Methodology
[How the analysis was conducted]

## Appendix
[Supporting data, raw numbers, extended examples]
```

### Agent Template (AI-Generated Content)

```markdown
# Content Generation Instructions

## Metadata
- **Type:** [tutorial | explainer | deep_dive | comparison | post_mortem | workshop]
- **Audience:** [persona description]
- **Goal:** [what the reader should know/do after reading]
- **Tone:** [professional | conversational | academic | playful]
- **Length:** [target word count]
- **Version:** [pinned software/tool versions]

## Structure
[Exact section outline with expected content for each]

## Constraints
- Maximum code block length: [X] lines
- Required sections: [list]
- Forbidden jargon: [list]
- Must include: [diagrams | benchmarks | comparisons | alternatives]

## Quality Gates
- [ ] Every code example tested and verified
- [ ] All claims backed by evidence or clearly marked as opinion
- [ ] Headings form a navigation structure for skimmers
- [ ] No section exceeds 500 words without a visual break
- [ ] Introduction establishes "why should I care?" within 3 sentences
```

## Rules

1. **Outline before you write.** Every article, no matter how short, benefits from a structure. The outline is your contract with the reader—it tells them what they'll learn and in what order.

2. **Get to the point in the first three sentences.** Your introduction must answer: What is this about? Why should I care? What will I learn? If it doesn't, readers will leave.

3. **Every code example must be tested.** Untested code in a tutorial is a landmine. It will waste hours of your readers' time and destroy their trust. Test on a clean environment before publishing.

4. **Show the result before the process.** Tell readers what they'll build or understand, then show them how. Context before mechanism, always.

5. **One concept per section.** If a section covers multiple ideas, split it. Each heading should map to exactly one learning objective.

6. **Use active voice by default.** "The system validates the input" is clearer than "The input is validated by the system." Reserve passive voice for when the action matters more than the actor.

7. **Write headings that work as a table of contents.** A skimmer reading only headings should understand the article's structure and find what they need. Vague headings like "Overview" or "Details" are navigation failures.

8. **Be honest about trade-offs.** No tool, pattern, or approach is perfect. Readers trust writers who acknowledge limitations more than those who only promote benefits.

9. **Version-pin everything.** Software changes. Your article's code examples will break if you don't pin versions. Add "last verified" dates and test on CI.

10. **The Feynman Test applies.** If you can't explain a concept in simple language, you don't understand it well enough to write about it. Simplify until a smart 12-year-old could follow.

11. **Progressive disclosure over info-dumping.** Layer information from simple to complex. Use collapsible sections, "advanced" callouts, and reference footnotes to serve multiple audience levels.

12. **Every paragraph must earn its place.** If a paragraph doesn't advance the reader's understanding, remove it. Content density is respect for the reader's time.

13. **Write for skimmers first, readers second.** Bold key phrases, use bullet lists, add section summaries. The 80/20 rule: 80% of readers will scan; give them what they need.

14. **End with action, not summary.** Don't just restate what you taught. Give readers a next step: a project to try, a resource to read, a question to consider.

15. **Revise in passes.** Structure first, then clarity, then polish. Don't try to fix grammar in a paragraph that might be deleted. Work top-down: big picture to small details.
