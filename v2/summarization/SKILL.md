---
name: summarization
description: >-
  Summarize long files, documents, codebases, meeting transcripts, video content, email threads, conversation logs, pull requests, issue threads, or any lengthy text. Use this skill whenever the user asks to summarize something, condense information, give a TL;DR, create an executive summary, meeting summary, brief overview, key takeaways, summarize this file, summarize this code, give me the gist, brief me, too long didn't read, condense, abstract, digest, recap, synthesize, distill, boil down, nutshell, elevator pitch, bullet point summary, one-pager, quick overview, high-level summary, detailed summary, comprehensive summary, annotated summary, structured summary, key points, main points, highlights, cliff notes, sparknotes, book summary, paper summary, research summary, literature review summary, code review summary, PR summary, pull request summary, design review summary, architectural review summary, technical review summary, product review summary, user research summary, survey results summary, data analysis summary, report summary, status report summary, weekly summary, daily standup summary, sprint review summary, retrospective summary, 1:1 meeting summary, all-hands summary, board meeting summary, interview transcript summary, focus group summary, customer call summary, support ticket summary, incident timeline summary, postmortem summary, root cause analysis summary, thread summary, email thread summary, slack thread summary, discord thread summary, documentation summary, RFC summary, ADR summary, proposal summary, spec summary, codebase overview, project overview, repository overview, library overview, module overview, file summary, class summary, function summary, diff summary, git diff summary, code change summary, changelog summary, version diff summary, log file summary, error log summary, access log summary, audit log summary, debug log summary, stack trace summary, crash report summary, performance report summary, benchmark summary, A/B test summary, experiment summary, analytics summary, metric summary, KPI summary, dashboard summary, financial summary, budget summary, investment memo summary, competitive analysis summary, market research summary, خلاصه کردن, خلاصه, جمع‌بندی, چکیده, نکات کلیدی, خلاصه فایل, خلاصه جلسه, خلاصه کد, خلاصه پروژه, چکیده مقاله, خلاصه کتاب, نکات مهم, نتیجه‌گیری, برداشت کلی, خلاصه‌نویسی, خلاصه مکالمه, خلاصه ایمیل, یا می‌خواهد به سرعت محتوای طولانی را بدون خواندن همه آن درک کند.
---

# Summarization Skill — Condense Anything Into Key Points

## Overview

This skill takes lengthy content — files, conversations, code, meetings, or documents — and produces focused, structured summaries. A good summary preserves the essential information, strips the noise, and adapts to the reader's needs. A 200-line config file, a 45-minute meeting transcript, or a 50-file codebase all deserve different summary strategies.

## When to Use This Skill

- User asks to summarize a file, document, or text
- User wants a TL;DR or executive summary
- User needs meeting notes or action items from a transcript
- User wants a quick overview of a codebase or module
- User asks for key takeaways from a long discussion
- User mentions خلاصه, چکیده, جمع‌بندی, or نکات کلیدی
- User says "give me the gist" or "brief me on this"
- User wants a PR review summary or code change summary
- User needs a thread/email/conversation condensed
- User wants incident timeline or postmortem summary
- User asks for research paper or article summary
- User needs sprint retrospective or standup summary
- User wants log file or error log analysis summary
- User asks for competitive analysis or market research summary
- User needs data analysis or report summary

## Summarization Workflow

### Step 1: Identify What to Summarize and Why

1. **Source type** — What are you summarizing?
   - **File / code** — Read the file with the Read tool
   - **Codebase** — Use Glob to find files, Read key ones, understand the structure
   - **Meeting transcript** — Accept the text or read the file
   - **Conversation / thread** — Accept the text or read the log
   - **Document / article** — Accept the text or read the file
   - **PR / diff** — Read the changed files and diff context
   - **Log file** — Read and analyze patterns
2. **Purpose** — Why does the user need this summary?
   - Quick orientation ("what is this project?")
   - Decision-making ("should I use this library?")
   - Action extraction ("what do I need to do after this meeting?")
   - Knowledge capture ("what did we learn from this discussion?")
   - Compliance/audit ("what was decided and by whom?")
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
   - **PR**: Files changed, purpose of change, potential risks, review concerns
   - **Log**: Error patterns, frequency, severity, affected components, timeline

### Step 3: Produce the Summary

Choose the appropriate format based on the source and purpose.

## Output Format Templates

### Template 1: File / Code Summary
```
**Purpose:** [one-line description]
**Key components:** [list of main modules/classes/functions]
**How it works:** [2-4 sentence explanation of the core logic]
**Dependencies:** [external libraries or services]
**Gotchas:** [non-obvious behavior, edge cases]
```

### Template 2: Meeting Summary
```
**Attendees:** [list]
**Duration:** [length]

**Key Decisions:**
- [decision 1]
- [decision 2]

**Action Items:**
- [ ] [task] — @owner — due: [date]
- [ ] [task] — @owner — due: [date]

**Open Questions:**
- [unresolved item 1]
- [unresolved item 2]

**Discussion Highlights:**
- [key point 1]
- [key point 2]
```

### Template 3: Executive Summary / TL;DR
```
[2-5 sentence paragraph covering: what, why, key findings, and recommendation/next step]
```

### Template 4: Codebase Overview
```
**Project:** [name and purpose]
**Stack:** [languages, frameworks, database]
**Structure:**
├── dir1/ — [purpose]
├── dir2/ — [purpose]
└── file  — [purpose]
**Running:** [how to start the project]
**Testing:** [how to run tests]
```

### Template 5: PR Review Summary
```
**PR:** [number] — [title]
**Author:** [name]
**Files changed:** [count] | **Lines:** +[added] -[removed]

**Summary:**
[2-3 sentence description of what this PR does]

**Key Changes:**
- [change 1]
- [change 2]

**Concerns / Risks:**
- [potential issue 1]
- [potential issue 2]

**Recommendation:** [Approve / Request changes / Needs discussion]
```

### Template 6: Research / Article Summary
```
**Source:** [title, author, date]
**Main Argument:** [one sentence]

**Key Points:**
1. [point 1]
2. [point 2]
3. [point 3]

**Supporting Evidence:**
- [evidence 1]
- [evidence 2]

**Limitations:**
- [limitation 1]

**My Take:** [brief assessment of quality/usefulness]
```

### Template 7: Incident / Log Summary
```
**Incident:** [title]
**Time window:** [start] to [end]
**Severity:** [P1/P2/P3]

**Timeline:**
| Time | Event |
|------|-------|
| HH:MM | [what happened] |

**Root Cause:** [explanation]
**Impact:** [what was affected]
**Resolution:** [how it was fixed]
**Prevention:** [what will prevent recurrence]
```

## Advanced Techniques

### 1. Hierarchical Summarization
For very long content (books, large codebases, multi-hour transcripts), produce a two-level summary: a 3-line top-level summary, then expand each line into a paragraph. The reader can stop at any level.

```
**TL;DR:** [3 bullet points]

---

**1. [First bullet expanded]:**
[3-4 sentences with key details]

**2. [Second bullet expanded]:**
[3-4 sentences with key details]

**3. [Third bullet expanded]:**
[3-4 sentences with key details]
```

### 2. Comparative Summarization
When summarizing multiple sources (e.g., comparing two competing libraries, or two meeting transcripts about the same topic), create a comparison matrix that highlights agreements and disagreements.

```
| Aspect | Source A | Source B | Verdict |
|--------|----------|----------|---------|
| Performance | Claims 2x faster | Benchmarks show 1.5x | A is faster |
| Ease of use | Steep learning curve | Simple API | B is easier |
```

### 3. Action-First Summarization
For meetings and decision documents, lead with action items. Don't bury the "what should we do" inside a chronological summary. The most important output of a meeting is the list of actions.

### 4. Quote Extraction
For interview transcripts and research, extract notable direct quotes alongside the summary. This preserves the original voice for the most impactful statements.

```
**Key Quote:**
> "[exact quote]" — [speaker/author]

**Summary:** [paraphrased version]
```

### 5. Confidence-Flagged Summarization
When the source is ambiguous or you're uncertain about an interpretation, explicitly flag it. Don't present guesses as facts.

```
- The team decided to use PostgreSQL **(confirmed — stated explicitly)**
- The launch date appears to be March 15 **(inferred — not explicitly stated)**
- The budget was approved **(unclear — mentioned but no clear decision recorded)**
```

### 6. Pattern Detection in Logs
When summarizing log files, don't just list errors. Detect patterns: recurring errors, correlated failures, time-based spikes, and affected components. Group individual log entries into incident categories.

### 7. Sentiment-Aware Summarization
For customer feedback, support threads, or survey responses, capture the overall sentiment and distribution (e.g., "70% positive, 20% neutral, 10% negative") alongside the thematic summary.

## Common Patterns

### Pattern 1: Daily Standup Summary
```
**Standup — Team Alpha — 2024-07-15**

**Yesterday:**
- @alice: Completed user auth refactor, started API tests
- @bob: Fixed pagination bug, reviewed PR #234
- @carol: Deployed staging, investigated memory leak

**Today:**
- @alice: Finish API tests, start integration tests
- @bob: Begin notification service implementation
- @carol: Fix memory leak, update monitoring dashboards

**Blockers:**
- @alice: Waiting on design approval for settings page (#189)
```

### Pattern 2: Library Evaluation Summary
```
**Evaluation: library-x v3.2**

**What it does:** [one-line purpose]
**Install:** `npm install library-x`
**Bundle size:** 12KB gzipped
**License:** MIT

**Pros:**
- Tree-shakeable ESM exports
- TypeScript-first, fully typed
- Active maintenance (last commit: 2 days ago)

**Cons:**
- No SSR support for React < 18
- Missing documentation for advanced features

**Verdict:** ✅ Recommended for [use case]. Avoid if [condition].
```

### Pattern 3: Sprint Retrospective Summary
```
**Sprint 24 Retrospective**

**What Went Well:**
- Shipped 3 features on time
- Cross-team collaboration on auth module
- Test coverage increased from 72% to 81%

**What Didn't Go Well:**
- 3 stories carried over due to unclear requirements
- QA bottleneck — only 1 reviewer for 5 developers
- Flaky CI tests wasted ~4 hours total

**Action Items:**
- [ ] Add acceptance criteria review to Definition of Done — @PM — next sprint
- [ ] Train 2 more developers as code reviewers — @Tech Lead — 2 weeks
- [ ] Fix top 5 flaky tests — @QA — 1 week
```

### Pattern 4: Competitive Analysis Summary
```
**Competitive Brief: [Competitor] vs [Our Product]**

**Competitor Overview:** [what they do, market position]

**Feature Comparison:**
| Feature | Competitor | Us |
|---------|-----------|-----|
| Feature A | ✅ | ❌ |
| Feature B | ❌ | ✅ |
| Pricing | $X/mo | $Y/mo |

**Their Strengths:**
- [strength 1]
- [strength 2]

**Their Weaknesses (vs us):**
- [weakness 1]
- [weakness 2]

**Threat Level:** Medium — strong in [segment], weak in [segment]
```

### Pattern 5: Email Thread Summary
```
**Thread:** "Re: Q3 Roadmap Prioritization" (8 emails, 3 participants)
**Date range:** July 10-14, 2024

**Topic:** Deciding Q3 priorities between [feature A] and [feature B]

**Positions:**
- @alice: Prioritize [feature A] — [reasoning]
- @bob: Prioritize [feature B] — [reasoning]
- @carol: Compromise — [proposed solution]

**Decision:** [what was agreed on, or "unresolved — needs sync call"]

**Next Step:** [action required]
```

## Edge Cases & Pitfalls

1. **Source is already concise** — If the input is already a summary or very short, don't pad the output to hit a target length. Say "This is already concise. Here's a one-line version: ..."

2. **Conflicting information in the source** — When the source contains contradictions (e.g., two people disagreeing in a meeting transcript), present both positions without taking sides. Flag the disagreement.

3. **Over-summarizing nuance** — Collapsing important caveats into a single bullet point. "We decided to use Postgres" loses the context that it was a close call and the team wants to revisit in 6 months.

4. **Inventing information** — Never add information not present in the source. If the source is vague, the summary should be vague too (and flag it).

5. **Wrong level of abstraction** — Summarizing a codebase at the file level when the user wanted function-level, or vice versa. Always clarify the desired granularity.

6. **Losing attribution** — In multi-person discussions, summarizing without noting who said what. Decisions and action items should always be attributed.

7. **Temporal confusion** — Mixing up the chronology of events. For meetings and incidents, always maintain a timeline. Don't group things thematically at the expense of temporal accuracy.

8. **Bias toward recent information** — Giving more weight to the last part of a long document. Consciously review the full source equally.

9. **Jargon mismatch** — The summary uses different jargon than the source. Preserve the source's terminology unless the user explicitly asks for plain language.

10. **Missing the "so what"** — Summarizing what was discussed without capturing why it matters or what should happen next. Action items and implications are the most valuable part of a summary.

11. **Unequal treatment of sections** — Spending 300 words on the first section and 50 words on the last when both are equally important. Aim for proportional coverage.

12. **Code summarization that just restates** — "This function takes a user ID and returns the user object" adds zero value. Explain the business logic, edge cases, and integration points instead.

13. **Multilingual source content** — When the source mixes languages, preserve the original language for technical terms and quotes, but provide the summary in the user's requested language.

14. **Missing numerical data** — Stripping out specific numbers, dates, and metrics that are the most actionable part of the content. Always preserve quantitative data.

15. **No structure indication** — Producing a flat paragraph when the source has clear structure (sections, chapters, phases). The summary should reflect the source's organization.

## Integration with Other Skills

- **documentation** — Use when the summary needs to become part of project documentation, or when creating overview docs from existing code.
- **changelog** — Use when summarizing a set of changes for changelog generation, or when creating a version diff summary.
- **technical-writing** — Use when the summary is the starting point for a larger article, or when creating an abstract for a technical paper.
- **api-integration** — Use when summarizing API documentation, response formats, or integration requirements.
- **browser-automation** — Use when summarizing E2E test results or browser test coverage reports.
- **charts** — Use when the summary needs visual representation — charts, graphs, or diagrams to complement the text.
- **pdf** — Use when the summary needs to be delivered as a formatted PDF report.
- **docx** — Use when delivering the summary as a Word document for enterprise stakeholders.

## Principles

- **Fidelity over brevity.** A shorter summary that misleads is worse than a longer one that's accurate.
- **No invented information.** Only include what's in the source. If the source is ambiguous, say so.
- **Prioritize actionability.** If there are action items, decisions, or next steps, put them first.
- **Adapt to the ask.** A TL;DR and a comprehensive brief are different products. Match what the user asked for.
- **Don't summarize the obvious.** If the source is already concise, don't pad the summary to hit a word count.
- **Preserve numbers.** Metrics, dates, and quantities carry more information than adjectives. "3 out of 5 tests failed" beats "some tests failed."
- **Flag uncertainty.** When the source is unclear or you're inferring, say so explicitly.
- **Be proportional.** Give each section of the source proportional attention in the summary based on its importance.
