---
name: summarization
description: >-
  Summarize long files, documents, codebases, meeting transcripts, video content, email threads, conversation logs, pull requests, issue threads, or any lengthy text. Use this skill whenever the user asks to summarize something, condense information, give a TL;DR, create an executive summary, meeting summary, brief overview, key takeaways, summarize this file, summarize this code, خلاصه کردن, خلاصه, جمع‌بندی, چکیده, نکات کلیدی, خلاصه فایل, خلاصه جلسه, TL;DR, give me the gist, brief me, progressive summary, key phrase extraction, query-focused summary, multi-granularity summary, domain-specific summary, legal summary, medical summary, technical summary, financial summary, or wants to quickly understand a large body of text without reading all of it.
---

# Summarization Skill — Condense Anything Into Key Points

## Overview

This skill takes lengthy content — files, conversations, code, meetings, or documents — and produces focused, structured summaries. A good summary preserves the essential information, strips the noise, and adapts to the reader's needs. A 200-line config file, a 45-minute meeting transcript, or a 50-file codebase all deserve different summary strategies. This skill covers multiple summarization techniques, domain-specific patterns, multi-granularity outputs, and quality criteria.

## When to Use This Skill

- User asks to summarize a file, document, or text
- User wants a TL;DR or executive summary
- User needs meeting notes or action items from a transcript
- User wants a quick overview of a codebase or module
- User asks for key takeaways from a long discussion
- User mentions خلاصه, چکیده, جمع‌بندی, or نکات کلیدی
- User says "give me the gist" or "brief me on this"
- User wants a summary at a specific granularity (one-liner, paragraph, detailed)
- User asks for key phrases or topics from a document

---

## Summarization Techniques

### Technique 1: Extractive Summarization

Select the most important sentences directly from the source text without rephrasing. Preserves exact wording and reduces risk of misrepresentation.

```
## Extractive Summary

**Key sentences from the document:**

1. [Sentence 1 — most important finding/claim]
2. [Sentence 2 — supporting evidence or second key point]
3. [Sentence 3 — conclusion or action item]
4. [Sentence 4 — caveat or important qualification]
```

**When to use:** Legal documents, scientific papers, contracts, regulatory text — anywhere exact wording matters. When you cannot afford to misinterpret or paraphrase.

**Pros:** High fidelity, no misinterpretation risk, fast to produce.
**Cons:** Can be choppy, may not flow well, doesn't synthesize across paragraphs.

### Technique 2: Abstractive Summarization

Generate new sentences that capture the meaning of the source, using your own words. Synthesizes information across the entire document.

```
## Abstractive Summary

[2-5 sentences that capture the core message, combining information
from multiple parts of the document into a coherent paragraph.
Uses your own words while preserving the original meaning.]
```

**When to use:** Most general-purpose summaries. When the reader needs to understand the gist without reading the source. When the source is repetitive and needs synthesis.

**Pros:** Concise, readable, can synthesize across sections.
**Cons:** Risk of misinterpretation, may miss nuances, harder to verify.

### Technique 3: Query-Focused Summarization

Tailor the summary to answer a specific question the user has.

```
## Query-Focused Summary

**Your question:** [user's specific question]

**Answer from the document:**

[Directly answer the question using information from the document.
Cite specific sections or page numbers when available.]

**Supporting details:**
- [Detail 1 that supports the answer]
- [Detail 2 that provides context]
- [Caveat or limitation of the answer]

**Confidence:** [High/Medium/Low] — [why]
**Note:** [any information the document doesn't cover related to the question]
```

**When to use:** When the user has a specific question about a document. When the document is very long and the user only cares about one aspect.

### Technique 4: Hierarchical / Multi-Granularity Summary

Produce summaries at multiple levels of detail:

```
## One-Liner (1 sentence)
[The absolute core message in one sentence.]

## Paragraph Summary (3-5 sentences)
[Expand to cover the main points: what, why, how, result.
This is the "elevator pitch" version of the document.]

## Detailed Summary (1-2 pages)
[Comprehensive summary covering all major sections.
Preserves structure and flow of the original.
Includes key data points, arguments, and conclusions.]
```

**When to use:** When the user might want different levels of detail. When you're not sure how much detail they need. For executive briefings where different stakeholders need different depths.

### Technique 5: Progressive Summarization

Build up a layered summary where each layer can stand alone:

```
## Layer 1: Title + Tagline
**Document:** [Document Title]
**One-liner:** [What this is about in one sentence]

## Layer 2: Key Points
- [Point 1]
- [Point 2]
- [Point 3]
- [Point 4]
- [Point 5]

## Layer 3: Section Summaries
### [Section 1 Title]
[2-3 sentences summarizing this section]

### [Section 2 Title]
[2-3 sentences summarizing this section]

### [Section 3 Title]
[2-3 sentences summarizing this section]

## Layer 4: Full Summary
[Detailed paragraph-form summary of the entire document]
```

**When to use:** Large documents where the reader should be able to "zoom in" to the level of detail they need. Knowledge management. Building a personal knowledge base from articles and papers.

---

## Domain-Specific Summarization Patterns

### Legal Document Summary

```
## Legal Summary: [Document Name]

**Document Type:** [Contract / Agreement / Regulation / Brief]
**Parties Involved:** [Party A] and [Party B]
**Effective Date:** [date]

**Key Terms:**
- [Term 1]: [plain-English explanation]
- [Term 2]: [plain-English explanation]

**Obligations:**
- [Party A] must: [list key obligations]
- [Party B] must: [list key obligations]

**Financial Terms:**
- Payment: [amount, schedule, conditions]
- Penalties: [for breach or late payment]

**Termination:**
- Conditions for termination by either party
- Notice period: [duration]
- Post-termination obligations: [surviving clauses]

**Risks & Red Flags:**
- ⚠️ [Risk 1: e.g., "Unlimited liability clause on line 47"]
- ⚠️ [Risk 2: e.g., "Non-compete extends to 2 years and 3 states"]

**Missing Standard Clauses:**
- [e.g., "No force majeure clause — unusual for this type of agreement"]
```

### Medical / Clinical Summary

```
## Clinical Summary

**Patient Context:** [relevant demographics — age, sex, relevant history]
**Chief Complaint:** [primary symptom or reason for visit]

**Key Findings:**
- [Finding 1] — [clinical significance]
- [Finding 2] — [clinical significance]

**Assessment:** [differential diagnosis or working diagnosis]

**Differential Diagnoses:**
1. [Diagnosis A] — [probability level] — [supporting evidence]
2. [Diagnosis B] — [probability level] — [supporting evidence]
3. [Diagnosis C] — [probability level] — [supporting evidence]

**Recommended Workup:**
- [ ] [Test 1] — to rule out [condition]
- [ ] [Test 2] — to confirm [condition]

**Red Flags:**
- 🚨 [Symptom or finding that requires immediate attention]
```

**Important:** Always include a disclaimer that this is informational only and not medical advice.

### Technical Document Summary

```
## Technical Summary: [Document/Component Name]

**What it is:** [one-line description]
**Technology:** [languages, frameworks, protocols]
**Status:** [production / staging / experimental]

**Architecture:**
- [Component 1] → communicates with → [Component 2] via [protocol]
- [Data flow description]

**Key Design Decisions:**
1. [Decision 1] — because [rationale]
2. [Decision 2] — because [rationale]

**API Surface:**
- [Endpoint/Function 1]: [purpose]
- [Endpoint/Function 2]: [purpose]

**Dependencies:**
- [Service/Library 1] — [purpose]
- [Service/Library 2] — [purpose]

**Known Limitations:**
- [Limitation 1]
- [Limitation 2]

**Operational Notes:**
- [How to deploy]
- [How to monitor]
- [Common failure modes]
```

### Financial Document Summary

```
## Financial Summary: [Report Name]

**Period:** [quarter/year]
**Company:** [name]

**Key Metrics:**
| Metric | Value | Change (YoY) | Change (QoQ) |
|--------|-------|--------------|--------------|
| Revenue | $X | +Y% | +Z% |
| Net Income | $X | +Y% | -Z% |
| Gross Margin | X% | +Y pp | -Z pp |
| Cash | $X | +Y% | +Z% |

**Highlights:**
- [Positive development 1]
- [Positive development 2]

**Concerns:**
- [Negative trend 1]
- [Negative trend 2]

**Guidance:**
- Next quarter revenue: $[range]
- Next quarter margin: [range]

**Analysis:**
[2-3 sentences on the overall financial health and trajectory]
```

### Meeting Transcript Summary

```
## Meeting Summary

**Date:** [date]
**Duration:** [length]
**Attendees:** [list]
**Meeting Type:** [standup / planning / review / ad-hoc]

**Decisions Made:**
1. [Decision 1] — decided by: [who], rationale: [why]
2. [Decision 2] — decided by: [who], rationale: [why]

**Action Items:**
- [ ] [Task] — @owner — due: [date] — priority: [high/medium/low]
- [ ] [Task] — @owner — due: [date] — priority: [high/medium/low]

**Discussion Summary:**
- [Topic 1]: [what was discussed, key points raised]
- [Topic 2]: [what was discussed, key points raised]

**Open Questions:**
- [Question 1] — needs input from [person/team]
- [Question 2] — deferred to [next meeting / future discussion]

**Parking Lot:**
- [Topic raised but not discussed — flagged for future]
```

### Codebase Summary

```
## Codebase Summary

**Project:** [name and purpose]
**Stack:** [languages, frameworks, database]
**Size:** [X files, Y lines of code, Z modules]

**Structure:**
├── src/
│   ├── auth/       — [purpose]
│   ├── api/        — [purpose]
│   ├── models/     — [purpose]
│   └── utils/      — [purpose]
├── tests/          — [purpose]
├── config/         — [purpose]
└── docs/           — [purpose]

**Entry Points:**
- Main: [file and function]
- CLI: [file and command]
- API: [first endpoint to call]

**Key Patterns:**
- [Architectural pattern used: e.g., "Repository pattern for data access"]
- [Design pattern used: e.g., "Middleware chain for request processing"]

**How to Run:**
```bash
[command 1]
[command 2]
```

**How to Test:**
```bash
[test command]
```

**Gotchas:**
- [Non-obvious behavior 1]
- [Known issue 1]
```

---

## Multi-Granularity Summary Templates

### The "Zoom Levels" Approach

```
## Summary at 3 Levels

### 📌 One-Liner (10 seconds)
[One sentence that captures the entire document.]

### 📝 Quick Brief (30 seconds)
[3-5 bullet points covering the most important information.
Each bullet is one sentence. Reader gets 80% of value in 30 seconds.]

### 📄 Full Summary (2-3 minutes)
[Detailed summary with sections, key data points, and structure.
Reader gets 95% of value in 2-3 minutes.]
```

### The "Stacked" Approach

```
## Layered Summary

**Layer 1 — Headline:**
[What is this? In 10 words or fewer.]

**Layer 2 — Key Points:**
- [Point 1]
- [Point 2]
- [Point 3]

**Layer 3 — Section Digest:**
[One sentence per major section of the original document.]

**Layer 4 — Full Summary:**
[Complete paragraph-form summary with all key details.]
```

---

## Key Phrase Extraction Patterns

Extract the most important terms and phrases from the source:

```
## Key Phrases

**Primary Topics:**
1. [Topic phrase 1] — appears [N] times, central to [section]
2. [Topic phrase 2] — appears [N] times, central to [section]
3. [Topic phrase 3] — appears [N] times, central to [section]

**Technical Terms:**
- [Term 1]: [brief definition if not obvious]
- [Term 2]: [brief definition if not obvious]

**Named Entities:**
- People: [names and roles]
- Organizations: [names]
- Products/Tools: [names]
- Locations: [names, if relevant]

**Acronyms:**
- [ACR]: [full form]
- [ACR]: [full form]
```

---

## Summarization Quality Criteria

A good summary must pass these checks:

### Checklist

| Criterion | Description | ✅ |
|-----------|-------------|---|
| **Accuracy** | All facts in the summary match the source | |
| **Completeness** | No major points are omitted | |
| **Conciseness** | Significantly shorter than source (10-20% of original) | |
| **Coherence** | Reads as a logical, flowing document | |
| **Fidelity** | Doesn't add information not in the source | |
| **No hallucination** | Every claim traces to source material | |
| **Appropriate granularity** | Matches what the user asked for | |
| **Actionable** | If action items exist, they're clearly listed | |

### Anti-Patterns to Avoid

1. **Padding:** Adding filler sentences to hit a word count
2. **Copy-paste summarization:** Just pasting the first and last paragraphs
3. **Hallucinated importance:** Emphasizing a minor point as major
4. **Lost context:** Summarizing a section without enough context to understand it
5. **Over-abstraction:** Making everything so general that nothing is actionable
6. **Missing caveats:** Presenting conclusions without their conditions or limitations

---

## Workflow

### Step 1: Identify What to Summarize and Why

1. **Source type** — What are you summarizing?
   - **File / code** — Read the file with the Read tool
   - **Codebase** — Use Glob to find files, Read key ones, understand the structure
   - **Meeting transcript** — Accept the text or read the file
   - **Conversation / thread** — Accept the text or read the log
   - **Document / article** — Accept the text or read the file
2. **Purpose** — Why does the user need this summary?
   - Quick orientation ("what is this project?")
   - Decision-making ("should I use this library?")
   - Action extraction ("what do I need to do after this meeting?")
   - Knowledge capture ("what did we learn from this discussion?")
   - Specific question answering ("does this doc cover X?")
3. **Audience** — Who will read the summary? (technical vs. non-technical, stakeholder vs. developer)
4. **Length** — How short? One paragraph? Bullet points? A structured document?

### Step 2: Read and Analyze the Source

1. **Read the full content** — Don't summarize from a partial read. Use Read, and for large files read in chunks if needed.
2. **Identify the structure** — What are the main sections, topics, or themes?
3. **Extract key information** — Depending on source type:
   - **Code**: Purpose, main components, dependencies, entry points, key logic, gotchas
   - **Meeting**: Decisions made, action items with owners/deadlines, open questions, key discussion points
   - **Article/Doc**: Main argument, supporting evidence, conclusions, recommendations
   - **Conversation/Thread**: Problem described, solutions discussed, outcome or next steps
   - **Codebase**: Architecture, tech stack, directory structure, key modules, how to run/test
4. **Identify key phrases** — Extract the most important terms, topics, and named entities.

### Step 3: Select the Technique

| Source Type | Best Technique | Why |
|-------------|---------------|-----|
| Legal/contract | Extractive + domain template | Exact wording matters |
| Meeting transcript | Meeting summary template | Action items and decisions needed |
| Long article/paper | Abstractive + progressive | Need synthesis across sections |
| Codebase | Codebase summary template | Structure and patterns needed |
| Unknown purpose | Multi-granularity (all levels) | Let the user choose depth |
| Specific question | Query-focused | Answer exactly what's asked |
| Technical document | Technical summary template | Architecture and decisions needed |
| Financial report | Financial summary template | Key metrics and trends needed |

### Step 4: Produce the Summary

Choose the appropriate format based on the source and purpose. Use the templates from this skill.

### Step 5: Verify Quality

Run through the quality checklist. Ensure no hallucination, no missing major points, and appropriate granularity.

---

## Output Format

- Write the summary in the user's language; keep code and technical identifiers in English
- Use bullet points for lists, bold for emphasis on key terms
- Keep the summary significantly shorter than the source (aim for 10-20% of original length)
- Lead with the most important information (inverted pyramid)
- If the user requests a specific format (e.g., "as bullet points" or "one paragraph"), follow that exactly
- Always cite the source when using extractive techniques

---

## Principles

- **Fidelity over brevity.** A shorter summary that misleads is worse than a longer one that's accurate.
- **No invented information.** Only include what's in the source. If the source is ambiguous, say so.
- **Prioritize actionability.** If there are action items, decisions, or next steps, put them first.
- **Adapt to the ask.** A TL;DR and a comprehensive brief are different products. Match what the user asked for.
- **Don't summarize the obvious.** If the source is already concise, don't pad the summary to hit a word count.
- **Preserve structure when it matters.** Technical and legal documents have intentional structure — don't flatten it.
- **Flag what's missing.** If the source doesn't cover something expected, mention the gap.
- **Use the right technique for the domain.** Legal ≠ medical ≠ technical ≠ meeting — each has specific needs.
