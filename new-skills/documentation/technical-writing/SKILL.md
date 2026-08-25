---
name: technical-writing
description: >-
  Create clear, effective technical documentation and content.
  English: technical writing, documentation, tutorials, API docs, README, user guides,
    knowledge base, style guides, editorial, content strategy, plain language, UX writing,
    release notes, changelogs, whitepapers, case studies, how-to guides, troubleshooting guides.
  فارسی: نگارش فنی، مستندسازی، آموزش‌ها، مستندات API، راهنمای کاربر، پایگاه دانش،
    سبک‌نامه، استراتژی محتوا، زبان ساده، نوشتن تجربه کاربری، یادداشت‌های انتشار.
  中文: 技术写作，文档编写，教程，API文档，README，用户指南，知识库，风格指南，
    内容策略，纯语言，用户体验写作，发布说明，白皮书，案例研究。
---

# Technical Writing and Documentation

## Overview

Technical writing transforms complex information into clear, actionable content that enables readers to understand concepts, follow procedures, or make decisions. Unlike creative writing, technical writing prioritizes clarity, accuracy, and usability over style or entertainment value. Every sentence should serve a purpose: to inform, instruct, or guide.

This skill covers the full spectrum of technical documentation: tutorials that teach, how-to guides that solve specific problems, reference documentation that answers detailed questions, and conceptual explanations that build understanding. Each type serves a different reader need and requires a different structure, tone, and approach.

The core principles of effective technical writing are: know your audience, structure for scanning, write for action, test with real users, and maintain relentlessly. A document that isn't maintained becomes worse than no document — it provides outdated information with false confidence.

## When to Use This Skill

- Writing tutorials, how-to guides, or getting-started documentation
- Creating API documentation, SDKs, or developer guides
- Writing README files, CONTRIBUTING guides, or CHANGELOGs
- Producing internal knowledge bases, runbooks, or playbooks
- Crafting user manuals, FAQ pages, or troubleshooting guides
- Writing technical blog posts, whitepapers, or case studies
- Creating release notes, deprecation notices, or migration guides
- Developing style guides or editorial standards for a team
- Reviewing and editing existing technical content for clarity

## When NOT to Use This Skill

- Marketing copy or promotional content (use copywriting skills)
- Creative fiction or narrative storytelling (use creative writing skills)
- Legal documents or contracts (use legal drafting skills)
- Scientific papers with strict academic formatting (use academic writing skills)
- Casual social media posts or chat messages
- When the content is too technical for you to verify accuracy (consult a subject matter expert first)

---

## Workflow

### Phase 1: Planning and Audience Analysis

**Objective:** Define the purpose, audience, and scope of the document before writing a single sentence.

```
Purpose Definition → Audience Analysis → Scope Setting → Outline → Review Plan
```

**Step 1.1 — Define Purpose**
Answer: What problem does this document solve? What should the reader be able to do after reading it? What is the single most important takeaway?

**Step 1.2 — Audience Analysis**

| Audience | Knowledge Level | Needs | Tone |
|---|---|---|---|
| Beginner | New to the topic | Step-by-step guidance, context, analogies | Patient, explanatory |
| Intermediate | Familiar with basics | Efficient solutions, best practices | Direct, practical |
| Expert | Deep knowledge | Reference details, edge cases, API specs | Concise, precise |
| Decision-maker | High-level understanding | Business impact, trade-offs, recommendations | Strategic, outcome-focused |
| Support team | Knows the product | Troubleshooting steps, escalation paths | Action-oriented, structured |

**Step 1.3 — Scope Setting**
Define what's in and out of scope. Be ruthless: a document that tries to cover everything covers nothing well. Split into multiple documents if needed.

**Step 1.4 — Outline**
Create a hierarchical outline with headings and key points under each. This is the skeleton — every section should map to a reader need.

### Phase 2: Writing

**Objective:** Draft the content following established structure and style principles.

```
First Draft → Structure Check → Clarity Pass → Code Examples → Visual Aids
```

**Step 2.1 — Write the First Draft**
Start with the structure you defined. Write each section independently. Don't edit as you go — get ideas down first, refine later.

**Step 2.2 — Apply Structure Principles**
- **Inverted pyramid:** Most important information first
- **Progressive disclosure:** Simple → detailed → advanced
- **Task-oriented headings:** "Configure the API" not "API Configuration"
- **Parallel structure:** Consistent grammatical patterns in lists and headings

**Step 2.3 — Clarity Pass**
Apply the Feynman technique: could you explain this to someone unfamiliar with the topic? Replace jargon with plain language where possible. Define technical terms on first use.

**Step 2.4 — Code Examples**
Every code example should: be complete enough to run, include expected output, show error handling where relevant, and use realistic (not contrived) data.

### Phase 3: Editing and Refinement

**Objective:** Transform a rough draft into polished, publication-ready content.

```
Structural Edit → Line Edit → Copy Edit → Technical Review → Final Proofread
```

**Step 3.1 — Structural Edit**
Check document flow, section ordering, and logical coherence. Does each section build on the previous one? Are there gaps in the explanation?

**Step 3.2 — Line Edit**
Improve sentence-level clarity: eliminate unnecessary words, replace passive voice with active voice, break long sentences, and ensure consistent terminology.

**Step 3.3 — Technical Review**
Verify all technical claims: do code examples actually work? Are version numbers current? Are API endpoints correct? Is the described behavior accurate?

**Step 3.4 — Final Proofread**
Check for typos, grammar errors, broken links, inconsistent formatting, and missing images.

### Phase 4: Publication and Maintenance

**Objective:** Publish the content and establish a maintenance schedule.

```
Format → Publish → Gather Feedback → Schedule Updates → Version
```

**Step 4.1 — Format**
Apply consistent formatting: headers, code blocks, callout boxes, tables, and images. Ensure accessibility: alt text for images, logical heading hierarchy, sufficient color contrast.

**Step 4.2 — Gather Feedback**
Share with representative users. Watch them read and follow the document. Note where they hesitate, re-read, or get confused.

**Step 4.3 — Schedule Maintenance**
Set a review cadence: monthly for fast-moving topics, quarterly for stable ones. Assign an owner for each document. Create a changelog.

---

## Advanced Techniques

### 1. The Feynman Technique for Technical Explanation

Named after physicist Richard Feynman, this technique ensures you truly understand something before explaining it. If you can't explain it simply, you don't understand it well enough.

```python
class FeynmanExplainer:
    """
    Framework for creating clear technical explanations
    using the Feynman Technique.
    """
    
    def __init__(self, topic):
        self.topic = topic
        self.steps = []
    
    def step1_define(self):
        """Write the topic name at the top of a blank page."""
        return {
            "step": "Define",
            "instruction": f"Write '{self.topic}' at the top.",
            "purpose": "Focus your explanation on a specific concept."
        }
    
    def step2_explain_child(self):
        """
        Explain the topic as if teaching a 12-year-old.
        Use simple words, no jargon, concrete examples.
        """
        return {
            "step": "Explain to a child",
            "instruction": (
                f"Explain {self.topic} using only words a smart "
                "12-year-old would understand. Use analogies from "
                "everyday life. Avoid all technical jargon."
            ),
            "template": """## {topic}

### In Simple Terms
{analogy_explanation}

### A Real-World Example
{concrete_example}

### Why It Matters
{practical_importance}""",
            "rules": [
                "No jargon — if you must use a technical term, define it immediately",
                "Use analogies from everyday life",
                "One concept at a time — don't combine multiple ideas",
                "Use short sentences (under 20 words when possible)",
            ]
        }
    
    def step3_identify_gaps(self):
        """
        Review your explanation for gaps or hand-waving.
        Where did you struggle to explain simply? That's a gap.
        """
        return {
            "step": "Identify gaps",
            "instruction": (
                "Review your simple explanation. Where did you use "
                "vague language? Where did you say 'it's just like...' "
                "without completing the analogy? Those are gaps in "
                "your understanding."
            ),
            "checklist": [
                "Can I explain WHY this exists (not just what it is)?",
                "Can I explain HOW it works step by step?",
                "Can I explain WHEN to use it (and when not to)?",
                "Can I give a concrete example that demonstrates each point?",
                "Does my analogy actually map to the real concept?"
            ]
        }
    
    def step4_simplify_and_refine(self):
        """
        Go back to the source material, fill gaps, then 
        simplify your explanation further.
        """
        return {
            "step": "Simplify and refine",
            "instruction": (
                "Rewrite your explanation. Use simpler words, "
                "better analogies, and more precise examples. "
                "Read it aloud — if any sentence is hard to say, "
                "it's too complex."
            ),
            "quality_checks": [
                "Every sentence has one idea",
                "Technical terms are defined on first use",
                "Examples are concrete and runnable",
                "The explanation builds progressively",
                "A complete beginner could follow it"
            ]
        }

# Usage
explainer = FeynmanExplainer("Kubernetes Pods")
print(explainer.step2_explain_child())

# Output template:
# ## Kubernetes Pods
# ### In Simple Terms
# A Pod is like a backpack for your applications. Just like a backpack 
# carries everything a hiker needs (water, snacks, map), a Pod carries 
# everything an application needs to run (the code, the files, the 
# network connection)...
```

### 2. Code Narrative Flow

Structure code documentation so the reader understands the "why" before the "how," and the "what" before the "how."

```python
def write_code_narrative(code, context, purpose):
    """
    Generate narrative documentation for code that explains:
    1. Why this code exists (problem it solves)
    2. What it does (high-level overview)
    3. How it works (detailed walkthrough)
    4. When to modify it (extension points)
    """
    
    template = f"""## {context}

### Why This Code Exists
{purpose}

### What It Does (Overview)
```python
# High-level: This function processes user data and returns validated records.
# It handles three main tasks:
# 1. Validates input against the schema
# 2. Transforms data types (strings → numbers, dates)
# 3. Deduplicates based on business rules
{code.split(chr(10))[0]}  # Just the signature
```

### How It Works (Step by Step)

| Step | What Happens | Why |
|------|-------------|-----|
| 1 | Parse input data | Raw input may have different formats |
| 2 | Validate each field | Catch errors early with clear messages |
| 3 | Transform types | Ensure downstream code gets correct types |
| 4 | Apply business rules | Dedup based on company-specific logic |
| 5 | Return results | Structured output for callers |

### Example Walkthrough
```
Input:  {{"name": "Alice", "age": "30", "email": "alice@example.com"}}
Step 1: Parsed — fields extracted
Step 2: Validated — all fields pass schema
Step 3: Transformed — age: "30" → 30 (int)
Step 4: No duplicates found
Output: {{"name": "Alice", "age": 30, "email": "alice@example.com", "valid": true}}
```

### When to Modify This Code
- **Adding a new field:** Add to the schema dict and update the transform step
- **Changing validation rules:** Modify the validation logic in step 2
- **Adding dedup rules:** Update the business rules in step 4
- **Performance issues:** Consider batching validation for large datasets

### Common Pitfalls
- Don't add fields without updating the schema — they'll be silently dropped
- The age field must be a string in input (API constraint), not an int
- Dedup is case-sensitive — "Alice" and "alice" are different users
"""
    return template
```

### 3. Progressive Disclosure Documentation

Structure content so readers can choose their depth of engagement: skim for overview, read for understanding, deep-dive for implementation.

```python
def progressive_disclosure_content(topic, overview, details, implementation):
    """
    Create content at three levels of detail.
    
    Level 1 (Overview): 30 seconds — what is this and why care?
    Level 2 (Details): 5 minutes — how does it work?
    Level 3 (Implementation): 30 minutes — how do I use it?
    """
    
    content = f"""# {topic}

## Quick Overview (30 seconds)
{overview}

> 💡 **Need more detail?** Keep reading. Use the section links to jump to what you need.

---

## How It Works (5 minutes)

{details}

> 💡 **Ready to implement?** Jump to the [Implementation Guide](#implementation-guide) below.

---

## Implementation Guide (30 minutes)

{implementation}

---

## Reference

### Configuration Options
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `timeout` | int | 30 | Max seconds per request |
| `retries` | int | 3 | Number of retry attempts |
| `backoff` | float | 1.5 | Exponential backoff multiplier |

### Error Codes
| Code | Meaning | Resolution |
|------|---------|------------|
| `E001` | Connection timeout | Check network, increase timeout |
| `E002` | Invalid schema | Verify input matches expected format |
| `E003` | Rate limited | Wait and retry with exponential backoff |
"""
    return content
```

### 4. Post-Mortem Writing Framework

Write effective incident post-mortems that build organizational learning, not assign blame.

```python
def post_mortem_template(incident_data):
    """
    Generate a blameless post-mortem document.
    
    Focus: What happened, why it happened, how we prevent it next time.
    Not: Who caused it.
    """
    
    template = f"""# Post-Mortem: {incident_data.get('title', 'Untitled Incident')}

## Incident Summary

| Field | Value |
|-------|-------|
| **Date:** | {incident_data.get('date', 'TBD')} |
| **Duration:** | {incident_data.get('duration', 'TBD')} |
| **Severity:** | {incident_data.get('severity', 'SEV?')} |
| **Impact:** | {incident_data.get('impact', 'TBD')} |
| **Author:** | {incident_data.get('author', 'TBD')} |
| **Status:** | {incident_data.get('status', 'Draft')} |

## Executive Summary
{incident_data.get('summary', '[2-3 sentences: What happened, what was the impact, what did we do about it]')}

## Timeline (All times in UTC)
| Time | Event |
|------|-------|
| {incident_data.get('timeline', 'HH:MM — [event description]')} |

## What Went Well
- [What worked during the incident response]
- [What mitigated the impact]
- [What monitoring/alerting helped]

## What Went Wrong
- [What caused the incident]
- [What delayed detection]
- [What delayed resolution]

## Where We Got Lucky
- [What could have been worse]
- [What accidental mitigations existed]

## Root Cause Analysis

### 5 Whys
1. **Why did the service fail?** → [immediate cause]
2. **Why did that happen?** → [underlying condition]
3. **Why wasn't this caught?** → [detection gap]
4. **Why does this condition exist?** → [systemic issue]
5. **Why wasn't this prevented?** → [process/tooling gap]

### Contributing Factors
- **Technical:** [code, infrastructure, configuration issues]
- **Process:** [procedural gaps, missing reviews]
- **Human:** [cognitive load, training gaps, communication]

## Action Items

| # | Action | Owner | Priority | Due Date | Status |
|---|--------|-------|----------|----------|--------|
| 1 | {incident_data.get('actions', '[action item]')} | [owner] | P0-P3 | [date] | Open |

## Lessons Learned
1. [Key takeaway 1]
2. [Key takeaway 2]
3. [Key takeaway 3]

## Supporting Data
- Dashboard links
- Log excerpts
- Alert configurations

---

*This post-mortem is blameless. Its purpose is to learn and improve, not to assign fault.*
"""
    return template
```

### 5. Comparison Post Framework

Write technical comparison articles that help readers make informed decisions.

```python
def comparison_post_template(comparison_data):
    """
    Framework for writing fair, comprehensive comparison posts.
    """
    
    template = f"""# {comparison_data.get('title', 'Comparison')}

## TL;DR
{comparison_data.get('tldr', '[One paragraph: Which option wins for which use case]')}

## Quick Comparison

| Feature | {comparison_data.get('option_a', 'Option A')} | {comparison_data.get('option_b', 'Option B')} | {comparison_data.get('option_c', 'Option C')} |
|---------|------------|------------|------------|
| {comparison_data.get('features', '[feature rows]')} |

## Decision Matrix

**Choose {comparison_data.get('option_a', 'Option A')} if you need:**
- [Use case 1]
- [Use case 2]

**Choose {comparison_data.get('option_b', 'Option B')} if you need:**
- [Use case 1]
- [Use case 2]

**Choose {comparison_data.get('option_c', 'Option C')} if you need:**
- [Use case 1]
- [Use case 2]

## Detailed Comparison

### Performance
{comparison_data.get('performance', '[Benchmarks, latency, throughput data]')}

### Developer Experience
{comparison_data.get('dx', '[Learning curve, documentation quality, community]')}

### Ecosystem and Integrations
{comparison_data.get('ecosystem', '[Libraries, plugins, third-party support]')}

### Cost
{comparison_data.get('cost', '[Licensing, hosting, operational costs]')}

### Production Readiness
{comparison_data.get('production', '[Maturity, reliability, enterprise features]')}

## Migration Guide
{comparison_data.get('migration', '[If switching: effort, risk, step-by-step]')}

## Our Recommendation
{comparison_data.get('recommendation', '[Honest recommendation with caveats]')}

## How We Tested
{comparison_data.get('methodology', '[What we measured, how, with what data]')}

## FAQ
{comparison_data.get('faq', '[Common questions and nuanced answers]')}

---

*Last updated: {comparison_data.get('date', 'YYYY-MM-DD')}*
*Disclosure: [any conflicts of interest or sponsorship]*
"""
    return template
```

### 6. Workshop and Training Material Design

```python
def workshop_module(topic, duration_minutes, learning_objectives, exercises):
    """
    Design a hands-on workshop module with clear learning outcomes.
    """
    
    template = f"""# Workshop Module: {topic}

## Module Info
- **Duration:** {duration_minutes} minutes
- **Level:** {exercises.get('level', 'Intermediate')}
- **Prerequisites:** {exercises.get('prerequisites', 'None')}
- **Materials:** {exercises.get('materials', 'Laptop with Python 3.9+')}

## Learning Objectives
By the end of this module, you will be able to:
{chr(10).join(f'- {obj}' for obj in learning_objectives)}

## Agenda

| Time | Activity | Type |
|------|----------|------|
| 0:00-0:05 | Welcome and setup check | Interactive |
| 0:05-0:15 | Concept introduction | Lecture |
| 0:15-0:25 | Guided exercise | Hands-on |
| 0:25-0:35 | Independent exercise | Hands-on |
| 0:35-0:45 | Q&A and wrap-up | Discussion |

## Concept Introduction
{exercises.get('concept', '[Key concepts to explain before exercises]')}

## Guided Exercise
{exercises.get('guided', '[Step-by-step exercise with instructor]')}

### Setup
```bash
{exercises.get('setup_commands', '# Setup commands')}
```

### Steps
1. {exercises.get('step1', '[First step with expected output]')}
2. {exercises.get('step2', '[Second step]')}

### Expected Output
```
{exercises.get('expected_output', '[What the student should see]')}
```

## Independent Exercise
{exercises.get('independent', '[Exercise for students to complete on their own]')}

### Challenge
{exercises.get('challenge', '[Extended challenge for fast finishers]')}

## Discussion Questions
1. {exercises.get('question1', '[Thought-provoking question]')}
2. {exercises.get('question2', '[Application question]')}

## Resources
- [Additional reading 1]
- [Additional reading 2]
- [Practice problems]
"""
    return template
```

### 7. API Documentation Standards

```python
def api_endpoint_doc(endpoint):
    """
    Generate comprehensive API documentation for an endpoint.
    """
    
    template = f"""## `{endpoint['method']} {endpoint['path']}`

{endpoint.get('description', '[Brief description of what this endpoint does]')}

### Authentication
{endpoint.get('auth', 'Required. Include `Authorization: Bearer <token>` header.')}

### Request

#### Headers
| Header | Required | Description |
|--------|----------|-------------|
| `Authorization` | Yes | Bearer token |
| `Content-Type` | Yes | `application/json` |
| `X-Request-ID` | No | Unique request identifier for tracing |

#### Path Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
{endpoint.get('path_params', '| `id` | string | Resource ID |')}

#### Query Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
{endpoint.get('query_params', '| `limit` | integer | No | `20` | Max results (1-100) |')}

#### Request Body
```json
{endpoint.get('request_body', '{\\n  "key": "value"\\n}')}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
{endpoint.get('body_fields', '| `name` | string | Yes | Resource name |')}

### Response

#### Success (200 OK)
```json
{endpoint.get('success_response', '{\\n  "id": "abc123",\\n  "created_at": "2024-01-01T00:00:00Z"\\n}')}
```

#### Error Responses
| Status | Code | Description | Resolution |
|--------|------|-------------|------------|
| 400 | `INVALID_INPUT` | Request body validation failed | Check required fields |
| 401 | `UNAUTHORIZED` | Missing or invalid token | Re-authenticate |
| 404 | `NOT_FOUND` | Resource doesn't exist | Verify resource ID |
| 429 | `RATE_LIMITED` | Too many requests | Wait and retry |
| 500 | `INTERNAL_ERROR` | Server error | Contact support |

### Rate Limits
- **Limit:** {endpoint.get('rate_limit', '100')} requests per minute
- **Burst:** {endpoint.get('burst', '10')} requests per second

### Examples

#### cURL
```bash
{endpoint.get('curl_example', 'curl -X GET "https://api.example.com/resource" \\\n  -H "Authorization: Bearer $TOKEN"')}
```

#### Python
```python
import requests

response = requests.{endpoint.get('method', 'get').lower()}(
    "https://api.example.com{endpoint['path']}",
    headers={{"Authorization": f"Bearer {{TOKEN}}"}},
)
print(response.json())
```

### Changelog
| Date | Change |
|------|--------|
{endpoint.get('changelog', '| 2024-01-01 | Initial release |')}
"""
    return template
```

---

## Common Patterns

### Pattern 1: Tutorial Structure (Learning-by-Doing)

```python
def write_tutorial(topic, prerequisites, steps):
    """
    Structure a tutorial that teaches by doing.
    
    Each step: explain → show → do → verify
    """
    
    template = f"""# Tutorial: {topic}

## What You'll Build
{steps.get('what_youll_build', '[End result description with screenshot]')}

## Prerequisites
- {chr(10).join(f'- {p}' for p in prerequisites)}

## Time Required
{steps.get('time', '~30 minutes')}

---

## Step 1: {steps.get('step1_title', 'Setup')}

### What you're doing
{steps.get('step1_explain', '[Why this step matters]')}

### How to do it
```bash
{steps.get('step1_commands', '# Commands to run')}
```

### Verify it worked
```bash
{steps.get('step1_verify', '# Expected output')}
```

✅ **Checkpoint:** You should see [expected output]. If not, [troubleshooting tip].

---

## Step 2: {steps.get('step2_title', 'Implementation')}

### What you're doing
{steps.get('step2_explain', '[Why this step matters]')}

### How to do it
```python
{steps.get('step2_code', '# Code to write')}
```

### Verify it worked
{steps.get('step2_verify', '[How to confirm this step worked]')}

✅ **Checkpoint:** [What success looks like]

---

## Step 3: {steps.get('step3_title', 'Testing')}

### What you're doing
{steps.get('step3_explain', '[Why this step matters]')}

### How to do it
```bash
{steps.get('step3_commands', '# Test commands')}
```

✅ **Checkpoint:** All tests should pass.

---

## What You Learned
- [Key concept 1]
- [Key concept 2]
- [Key concept 3]

## Next Steps
- [Link to more advanced tutorial]
- [Link to API reference]
- [Link to community resources]

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| {steps.get('troubleshoot1', '[Error message]')} | [cause] | [fix] |
| {steps.get('troubleshoot2', '[Error message]')} | [cause] | [fix] |
"""
    return template
```

### Pattern 2: Concept Explainer (Analogy-First)

```python
def write_concept_explainer(concept, analogy, details):
    """
    Explain a technical concept using the Analogy → Reality → Details pattern.
    """
    
    template = f"""# {concept}

## The Short Version
{details.get('short_version', '[One sentence that captures the essence]')}

## Think of It Like...
{analogy.get('description', '[Everyday analogy that makes the concept intuitive]')}

> {analogy.get('quote', '[Key insight from the analogy]')}

## The Real Story

### What It Actually Is
{details.get('definition', '[Precise technical definition]')}

### How It Works
{details.get('how_it_works', '[Step-by-step explanation]')}

### Why It Matters
{details.get('why_matters', '[Practical importance]')}

## In Practice

### When to Use It
- {chr(10).join(f'- {use}' for use in details.get('when_to_use', ['Use case 1']))}

### When NOT to Use It
- {chr(10).join(f'- {avoid}' for avoid in details.get('when_not_to_use', ['Anti-pattern 1']))}

## Common Misconceptions
1. **Misconception:** {details.get('misconception1', '[Wrong belief]')}
   **Reality:** {details.get('reality1', '[Correct understanding]')}

## Further Reading
- [{details.get('resource1_title', 'Resource 1')}]({details.get('resource1_url', '#')})
- [{details.get('resource2_title', 'Resource 2')}]({details.get('resource2_url', '#')})
"""
    return template
```

### Pattern 3: How-To Guide (Problem-Solution)

```python
def write_how_to(title, problem, solution):
    """
    Write a problem-solution how-to guide.
    """
    
    template = f"""# How to {title}

**Problem:** {problem.get('description', '[What the reader is trying to do]')}

**Solution:** {solution.get('summary', '[Brief overview of the approach]')}

**Difficulty:** {solution.get('difficulty', 'Intermediate')}
**Time:** {solution.get('time', '15 minutes')}

---

## Prerequisites
- {chr(10).join(f'- {p}' for p in solution.get('prerequisites', ['Basic knowledge']))}

## Steps

### 1. {solution.get('step1_title', 'Understand the Problem')}
{solution.get('step1', '[Detailed explanation]')}

```bash
{solution.get('step1_code', '# Example code')}
```

### 2. {solution.get('step2_title', 'Implement the Solution')}
{solution.get('step2', '[Detailed explanation]')}

```python
{solution.get('step2_code', '# Example code')}
```

### 3. {solution.get('step3_title', 'Verify the Result')}
{solution.get('step3', '[How to confirm it worked]')}

---

## Alternative Approaches
| Approach | Pros | Cons | Best For |
|----------|------|------|----------|
| {solution.get('alt1', '[Approach 1]')} | [pros] | [cons] | [use case] |
| {solution.get('alt2', '[Approach 2]')} | [pros] | [cons] | [use case] |

## Troubleshooting

### Error: {solution.get('error1', '[Common error message]')}
**Cause:** {solution.get('error1_cause', '[Why this happens]')}
**Fix:** {solution.get('error1_fix', '[How to fix it]')}

## Related
- [Link to related how-to]
- [Link to reference documentation]
"""
    return template
```

### Pattern 4: Release Notes

```python
def write_release_notes(version, changes):
    """
    Write clear, actionable release notes.
    """
    
    template = f"""# Release Notes — v{version}

**Release Date:** {changes.get('date', 'YYYY-MM-DD')}

## 🎉 What's New
{chr(10).join(f'- **{feat["title"]}:** {feat["description"]}' for feat in changes.get('features', [{'title': 'Feature', 'description': 'Description'}]))}

## 🔧 Improvements
{chr(10).join(f'- {imp}' for imp in changes.get('improvements', ['Improvement 1']))}

## 🐛 Bug Fixes
{chr(10).join(f'- {fix}' for fix in changes.get('bug_fixes', ['Fix 1']))}

## ⚠️ Breaking Changes
{chr(10).join(f'- **{bc["title"]}:** {bc["description"]} → **Migration:** {bc["migration"]}' for bc in changes.get('breaking_changes', []))}

## 📦 Dependencies Updated
{chr(10).join(f'- `{dep["name"]}` {dep["old_version"]} → {dep["new_version"]}' for dep in changes.get('dependencies', []))}

## 🔒 Security
{chr(10).join(f'- {sec}' for sec in changes.get('security', []))}

## 📝 Upgrade Instructions
{changes.get('upgrade_instructions', 'No special upgrade steps required.')}

## Known Issues
{chr(10).join(f'- {issue}' for issue in changes.get('known_issues', []))}

---

**Full Changelog:** https://github.com/org/repo/compare/v{changes.get('previous_version', 'X.Y.Z')}...v{version}
"""
    return template
```

### Pattern 5: Troubleshooting Guide

```python
def write_troubleshooting_guide(issue, symptoms, solutions):
    """
    Structure a troubleshooting guide that helps readers diagnose and fix issues.
    """
    
    template = f"""# Troubleshooting: {issue}

## Symptoms
- {chr(10).join(f'- {s}' for s in symptoms.get('indicators', ['Symptom 1']))}

## Quick Fix
{symptoms.get('quick_fix', 'Try restarting the service: `systemctl restart myservice`')}

## Diagnosis Flowchart

```
Start here: Is the service running?
├── YES → Is the port open?
│   ├── YES → Is the database accessible?
│   │   ├── YES → Check application logs
│   │   └── NO → Fix database connection
│   └── NO → Check firewall / load balancer
└── NO → Check service status and restart
```

## Detailed Solutions

### Solution 1: {solutions.get('sol1_title', 'Most Common Fix')}
**When to use:** {solutions.get('sol1_when', 'When you see error code E001')}
**Steps:**
1. {solutions.get('sol1_step1', '[First step]')}
2. {solutions.get('sol1_step2', '[Second step]')}
3. {solutions.get('sol1_step3', '[Verify fix]')}

### Solution 2: {solutions.get('sol2_title', 'Less Common Fix')}
**When to use:** {solutions.get('sol2_when', 'When the quick fix didn't work')}
**Steps:**
1. {solutions.get('sol2_step1', '[First step]')}

## Logs to Check
| Log File | Location | What to Look For |
|----------|----------|------------------|
| Application log | `/var/log/app/` | Error messages, stack traces |
| Access log | `/var/log/nginx/` | 5xx errors, slow requests |
| System log | `/var/log/syslog` | OOM kills, disk errors |

## Still Stuck?
- Search existing issues: [GitHub Issues](link)
- Check community forum: [Forum link]
- Contact support: [support@example.com](mailto:support@example.com)

**When contacting support, include:**
1. Error message (full text, not just the code)
2. Steps to reproduce
3. Application version and environment details
4. Relevant log excerpts
"""
    return template
```

---

## Edge Cases & Pitfalls

### 1. Writing for Yourself
**Problem:** You understand the topic deeply and write documentation that makes sense to you but not to your audience. This is the curse of knowledge.
**Solution:** Test with real users. Watch someone read your documentation for the first time. Their confusion is your documentation's failure, not their understanding.

### 2. Code Examples That Don't Run
**Problem:** Documentation includes code snippets with typos, missing imports, or incorrect API calls. Readers trust them and waste hours debugging.
**Solution:** Run every code example before publishing. Use CI/CD to test code snippets. Version code examples alongside documentation.

### 3. Tutorial Hell
**Problem:** Tutorials that only show the "happy path" leave readers unable to handle errors, edge cases, or customization.
**Solution:** Include error handling in examples. Show common failure modes. After the tutorial, show how to extend and customize.

### 4. Wall-of-Text Documentation
**Problem:** Long paragraphs without headers, lists, or visual breaks. Readers scan, not read — walls of text are invisible.
**Solution:** Use headers every 2-3 paragraphs. Use bullet points and numbered lists. Add diagrams, code blocks, and tables for visual variety.

### 5. Missing Prerequisites
**Problem:** Tutorials assume readers have specific tools, knowledge, or setup that isn't stated. Readers fail immediately and blame themselves.
**Solution:** Explicitly list prerequisites. Link to setup guides. Include a "Verify your setup" step at the beginning.

### 6. Overusing Screenshots
**Problem:** Documentation relies on screenshots that become outdated, aren't searchable, and don't work for screen readers.
**Solution:** Use text-based examples and command-line output over screenshots. When screenshots are necessary, supplement with text descriptions.

### 7. Inconsistent Terminology
**Problem:** The same concept is called different things in different documents ("user" vs "customer" vs "account" vs "member").
**Solution:** Create a glossary. Use find-and-replace to standardize. Add terminology guidelines to your style guide.

### 8. Burying the Lead
**Problem:** Putting the most important information deep in the document, requiring readers to read everything before finding what they need.
**Solution:** Lead with the answer. Use the inverted pyramid: most important information first, details later. Use callout boxes for critical information.

### 9. Ignoring Mobile Readers
**Problem:** Long code blocks and wide tables that require horizontal scrolling on mobile devices.
**Solution:** Keep code examples short. Use responsive tables. Test documentation on mobile devices. Consider mobile-first formatting.

### 10. Outdated Content
**Problem:** Documentation that references deprecated APIs, old versions, or discontinued features. Readers follow it and get errors.
**Solution:** Set review dates. Use version-aware documentation. Add "Last verified with version X.Y" notices. Automate link checking.

### 11. No Call to Action
**Problem:** Documentation explains concepts but doesn't tell the reader what to do next. They finish reading and are lost.
**Solution:** End every page with clear next steps: links to related docs, suggested exercises, or calls to try something.

### 12. Over-explaining Simple Things
**Problem:** Spending 500 words explaining how to install Python, while the target audience already knows how.
**Solution:** Match depth to audience level. Put basic setup in a "Prerequisites" section with links. Focus the main content on the actual topic.

### 13. Missing Context for Code
**Problem:** Showing code without explaining why this approach was chosen, what alternatives exist, or when to use it.
**Solution:** Always include: why (motivation), what (overview), how (implementation), when (use cases), and when not to (anti-patterns).

### 14. Not Versioning Documentation
**Problem:** A single documentation site serves all versions, but readers are on different API versions.
**Solution:** Version documentation alongside code. Use URL versioning (/v1/, /v2/) or version dropdowns. Clearly mark deprecated versions.

### 15. Ignoring Accessibility
**Problem:** Documentation uses color alone to convey meaning, lacks alt text for images, or has poor heading structure for screen readers.
**Solution:** Use semantic HTML. Add alt text to all images. Don't rely solely on color. Ensure sufficient contrast. Test with screen readers.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **Data Analysis** | Content Source | Analysis findings need clear documentation for stakeholders |
| **RAG Implementation** | Enhancement | Well-structured docs improve retrieval quality in knowledge bases |
| **Data Cleaning** | Companion | Document data cleaning procedures for reproducibility |
| **Summarization** | Complement | Summarize long documents for quick reference guides |
| **Code Understanding** | Input | Code comprehension informs API documentation and tutorials |
| **Knowledge Management** | Core Component | Technical writing is the primary content type in knowledge bases |
| **UX Writing** | Overlap | Technical writing shares principles with UX microcopy and interface text |
| **Project Management** | Process | Documentation planning integrates with sprint planning and release cycles |

---

## Output Format Templates

### Standard Tutorial

```markdown
# Tutorial: {Topic}

## What You'll Learn
- Learning objective 1
- Learning objective 2
- Learning objective 3

## Prerequisites
- Requirement 1
- Requirement 2

## Time Required
~{X} minutes

---

## Part 1: {Subtopic}

### Explanation
{Concept explanation with analogy}

### Hands-On
```{language}
{Runnable code example}
```

### Verify
{Expected output or verification step}

✅ **Checkpoint:** {What success looks like}

---

## Part 2: {Subtopic}
{Repeat pattern}

---

## Summary
- {Key concept 1}
- {Key concept 2}

## Next Steps
- {Link to advanced topic}
- {Link to reference}

## Troubleshooting
| Problem | Solution |
|---------|----------|
| {Problem 1} | {Solution 1} |
```

### Quick Reference Card

```markdown
# {Tool/Concept} Quick Reference

## Commands
| Command | Description | Example |
|---------|-------------|---------|
| `{cmd1}` | {desc} | `{example}` |

## Common Patterns
```{language}
{pattern1}
```

## Error Reference
| Error | Cause | Fix |
|-------|-------|-----|
| `{error}` | {cause} | {fix} |

## Configuration
| Option | Default | Description |
|--------|---------|-------------|
| `{opt}` | `{default}` | {desc} |
```

### Concept Explainer

```markdown
# {Concept}

## TL;DR
{One sentence explanation}

## Analogy
{Everyday analogy that makes it intuitive}

## How It Works
{Technical explanation with diagrams}

## When to Use
- Use case 1
- Use case 2

## When NOT to Use
- Anti-pattern 1
- Anti-pattern 2

## Example
```{language}
{Working code example}
```

## Further Reading
- {Resource 1}
- {Resource 2}
```

### API Reference Page

```markdown
# {Endpoint Name}

**Method:** `{METHOD}` | **Path:** `{path}` | **Auth:** {required/optional}

## Description
{What this endpoint does}

## Request
### Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| `{param}` | {type} | {yes/no} | {desc} |

### Body
```json
{request_body_example}
```

## Response
### Success (200)
```json
{success_response}
```

### Errors
| Code | Description |
|------|-------------|
| 400 | Bad request |
| 401 | Unauthorized |

## Examples
```bash
{curl_example}
```
```

### Agent-Friendly Structured Output

```json
{
  "document_type": "{tutorial|reference|how-to|concept|release-notes}",
  "title": "{title}",
  "target_audience": "{beginner|intermediate|expert}",
  "reading_time_minutes": 10,
  "sections": [
    {
      "heading": "{heading}",
      "level": 2,
      "content_type": "{text|code|table|diagram}",
      "key_points": ["point 1", "point 2"]
    }
  ],
  "code_examples": [
    {
      "language": "python",
      "description": "{what this example demonstrates}",
      "runnable": true
    }
  ],
  "links": [
    {"text": "{link text}", "url": "{url}", "type": "{internal|external}"}
  ],
  "metadata": {
    "version": "1.0",
    "last_reviewed": "2024-01-01",
    "review_cycle_days": 90
  }
}
```

---

## Rules

1. **Write for your reader, not for yourself** — Your audience has different knowledge, goals, and context. Test with real users before assuming clarity.
2. **Lead with the answer** — Put the most important information first. Use inverted pyramid: conclusion → supporting details → background.
3. **One idea per paragraph** — Each paragraph should have a single main point. If you're covering two concepts, use two paragraphs or two sections.
4. **Use active voice** — "Click the button" not "The button should be clicked." Active voice is clearer, shorter, and more direct.
5. **Show, don't just tell** — Code examples, screenshots, and diagrams communicate faster than paragraphs of description.
6. **Make code examples runnable** — Every code snippet should work as-is. Include imports, context, and expected output. Test before publishing.
7. **Use consistent terminology** — Pick one term for each concept and use it everywhere. Create a glossary for your project.
8. **Structure for scanning** — Use headers, bullet points, tables, and callout boxes. Readers scan before they read.
9. **Define jargon on first use** — If you must use a technical term, define it immediately. Better yet, use plain language instead.
10. **Include the "why" not just the "how"** — Understanding why an approach was chosen helps readers adapt it to their situation.
11. **Version your documentation** — Documentation should be versioned alongside code. Old versions should remain accessible.
12. **Write for accessibility** — Use semantic structure, alt text, sufficient contrast, and test with screen readers.
13. **Maintain a changelog** — Every significant documentation change should be logged. Readers need to know what's new.
14. **Keep code examples current** — Outdated code examples are worse than no examples. Automate testing where possible.
15. **End with clear next steps** — Every document should end with what to do next: related docs, exercises, or calls to action.
