---
name: summarization
description: >-
  Generate intelligent, structured summaries of documents, meetings, code, logs, and content.
  English: summarization, text summarization, extractive summarization, abstractive summarization,
    meeting summaries, PR summaries, codebase overview, log summarization, document summarization,
    executive summary, literature review, research summary, content distillation,
    hierarchical summarization, confidence-flagged summaries, action-first summarization,
    sentiment-aware summarization, key point extraction.
  فارسی: خلاصه‌سازی، خلاصه‌سازی استخراجی، خلاصه‌سازی انتزاعی، خلاصه جلسات، خلاصه PR،
    مرور کد، خلاصه لاگ، خلاصه سند، خلاصه اجرایی، مرور ادبیات، استخراج نکات کلیدی.
  中文: 摘要生成，提取式摘要，生成式摘要，会议摘要，PR摘要，代码库概览，日志摘要，
    文档摘要，执行摘要，文献综述，关键点提取，分层摘要，置信度标记摘要。
---

# Intelligent Summarization

## Overview

Summarization is the process of distilling large volumes of information into concise, accurate, and useful representations. Unlike simple truncation or excerpting, intelligent summarization preserves the essential meaning, key decisions, action items, and critical context while removing noise, redundancy, and irrelevant detail.

The core challenge is **information compression with fidelity**: reducing 10,000 words to 500 without losing the 3 sentences that matter most. This requires understanding the content's structure, identifying what's important (which varies by audience and purpose), and representing the result in a format that enables quick comprehension and action.

This skill covers both extractive summarization (selecting key passages from the source) and abstractive summarization (generating new text that captures the essence), applied across diverse content types: documents, meetings, code, logs, PRs, research papers, and more. Each content type has unique structural patterns, key information locations, and audience needs.

## When to Use This Skill

- Summarizing long documents, reports, or papers for quick comprehension
- Creating meeting summaries with action items, decisions, and key discussion points
- Writing PR summaries that explain changes, risks, and testing notes
- Generating codebase overviews for onboarding or architecture reviews
- Detecting patterns in log files and creating actionable summaries
- Creating executive summaries from technical reports
- Distilling research papers into literature reviews
- Summarizing support tickets or customer feedback
- Compressing code reviews into actionable feedback

## When NOT to Use This Skill

- Simple keyword extraction (use keyword extraction patterns)
- Full document translation (use translation skills)
- Creative rewriting or paraphrasing for style (use content writing skills)
- Real-time streaming summarization (use streaming patterns)
- When the source content is too short to summarize (under 500 words)

---

## Workflow

### Phase 1: Content Analysis

**Objective:** Understand the source material's structure, type, and key information patterns.

```
Source Content → Type Detection → Structure Analysis → Key Information Extraction → Priority Assessment
```

**Step 1.1 — Content Type Detection**
Identify the content type: document (report, paper, article), meeting (transcript, notes), code (PR, codebase, function), log (application, system, audit), or structured data (table, JSON). Each type has different summarization strategies.

**Step 1.2 — Structure Analysis**
Map the content's structure: headings, sections, paragraphs, code blocks, timestamps, speaker turns, commit messages. Key information often lives in specific structural locations (e.g., abstracts, conclusions, first sentences of paragraphs).

**Step 1.3 — Key Information Extraction**
Identify the most important information: main claims, decisions, action items, metrics, errors, and recommendations. Use position-based heuristics (first/last paragraph), cue phrases ("the key finding is", "we decided to"), and structural markers (headings, bullet points).

**Step 1.4 — Priority Assessment**
Determine what matters most for the target audience: an executive needs decisions and business impact, an engineer needs technical details and action items, a researcher needs methodology and findings.

### Phase 2: Summarization Strategy Selection

**Objective:** Choose the right summarization approach based on content type, length, and audience needs.

```
Content Type → Strategy Selection → Method Configuration → Compression Ratio → Output Format
```

| Content Type | Primary Strategy | Compression Ratio | Key Elements |
|---|---|---|---|
| Research Paper | Hierarchical (abstract → sections) | 10-20% | Claims, methods, findings, limitations |
| Meeting Transcript | Action-first | 5-15% | Decisions, action items, key discussion |
| PR/Code Review | Structured extraction | 10-25% | Changes, risks, testing, context |
| Codebase | Architecture-first | 5-15% | Structure, patterns, key components |
| Log Files | Pattern detection | 1-5% | Errors, anomalies, trends, frequency |
| Executive Report | Inverted pyramid | 10-20% | Bottom line, key metrics, recommendations |
| Support Tickets | Issue-action format | 15-30% | Problem, impact, resolution, follow-up |

### Phase 3: Summarization Execution

**Objective:** Generate the summary using the selected strategy.

```
Source Content → Preprocessing → Key Point Extraction → Ordering → Compression → Post-processing
```

**Step 3.1 — Preprocessing**
For text: normalize whitespace, remove boilerplate headers/footers, identify sections. For code: parse structure, extract function signatures, identify dependencies. For logs: parse timestamps, extract error patterns, aggregate by type.

**Step 3.2 — Key Point Extraction**
Extract the most important information using: position-based extraction (first/last sentences), frequency-based extraction (terms that appear in multiple sections), importance-based extraction (entities, numbers, decisions), and cue-phrase extraction ("the key insight", "we decided", "the root cause is").

**Step 3.3 — Ordering and Compression**
Order key points by importance (most important first for executive summaries, chronological for meeting summaries). Compress by removing redundancy, merging similar points, and simplifying language while preserving meaning.

**Step 3.4 — Post-processing**
Add structure (headers, bullet points, tables), verify completeness (all major topics covered), check accuracy (no misrepresentation of source), and add confidence flags (mark uncertain inferences).

### Phase 4: Validation and Refinement

**Objective:** Ensure the summary is accurate, complete, and useful.

```
Completeness Check → Accuracy Verification → Audience Calibration → Final Polish
```

**Step 4.1 — Completeness Check**
Verify that all major topics in the source are represented in the summary. No critical information should be missing. For action-oriented summaries, verify all action items are captured.

**Step 4.2 — Accuracy Verification**
Check that the summary doesn't misrepresent the source. Verify that numbers, dates, names, and technical terms are correct. Ensure that inferences are clearly marked as such.

**Step 4.3 — Audience Calibration**
Adjust language, depth, and format for the target audience. An executive summary should be jargon-free with business impact. A technical summary should include implementation details and trade-offs.

---

## Advanced Techniques

### 1. Hierarchical Summarization

Create summaries at multiple levels of detail: a one-line overview, a paragraph summary, and a detailed section-by-section summary. This lets readers choose their depth of engagement.

```python
def hierarchical_summary(document, llm, levels=None):
    """
    Create a multi-level summary: TL;DR → Paragraph → Detailed.
    
    Each level provides progressively more detail, allowing readers 
    to choose their depth of engagement.
    """
    if levels is None:
        levels = {
            "tldr": {"max_tokens": 50, "instruction": "One sentence that captures the single most important point."},
            "paragraph": {"max_tokens": 150, "instruction": "One paragraph (3-5 sentences) covering the key points, decisions, and outcomes."},
            "detailed": {"max_tokens": 500, "instruction": "A structured summary with: Key Points (bullet list), Decisions Made, Action Items, and Notable Details."},
        }
    
    summary = {}
    for level_name, config in levels.items():
        prompt = f"""{config['instruction']}

Source document:
{document}

Summary ({level_name}):"""
        
        response = llm.generate(prompt, max_tokens=config["max_tokens"], temperature=0)
        summary[level_name] = response.strip()
    
    # Add structural metadata
    summary["metadata"] = {
        "source_length": len(document),
        "compression_ratio": {k: len(v) / len(document) for k, v in summary.items() if isinstance(v, str)},
        "word_counts": {k: len(v.split()) for k, v in summary.items() if isinstance(v, str)}
    }
    
    return summary

# Usage
summary = hierarchical_summary(long_report, llm)
print(summary["tldr"])        # One sentence
print(summary["paragraph"])   # One paragraph
print(summary["detailed"])    # Full structured summary
```

### 2. Confidence-Flagged Summaries

Mark claims in the summary with confidence levels based on how directly they're supported by the source material. This prevents the summary from presenting inferences as facts.

```python
import re

def confidence_flagged_summary(document, llm):
    """
    Generate a summary where each claim is flagged with a confidence level.
    
    Confidence levels:
    - HIGH: Directly stated in the source
    - MEDIUM: Strongly implied by multiple source passages
    - LOW: Inferred or extrapolated from limited evidence
    - SPECULATIVE: Reasonable but not directly supported
    """
    
    prompt = f"""Summarize the following document. For EACH claim or statement in your 
summary, include a confidence tag in brackets at the end of the sentence:

[HIGH] - Directly stated in the source document
[MEDIUM] - Strongly implied by the source
[LOW] - Inferred from limited evidence
[SPECULATIVE] - Reasonable but not directly supported

Format each point as a bullet point with its confidence tag.

Source document:
{document}

Summary with confidence flags:"""
    
    response = llm.generate(prompt, temperature=0)
    
    # Parse and analyze confidence distribution
    lines = response.strip().split('\n')
    summary_points = []
    confidence_distribution = {"HIGH": 0, "MEDIUM": 0, "LOW": 0, "SPECULATIVE": 0}
    
    for line in lines:
        line = line.strip()
        if not line or not line.startswith('-'):
            continue
        
        # Extract confidence tag
        tag_match = re.search(r'\[(HIGH|MEDIUM|LOW|SPECULATIVE)\]', line)
        if tag_match:
            confidence = tag_match.group(1)
            claim = re.sub(r'\[(HIGH|MEDIUM|LOW|SPECULATIVE)\]', '', line).strip().lstrip('- ')
            summary_points.append({"claim": claim, "confidence": confidence})
            confidence_distribution[confidence] += 1
    
    # Calculate overall confidence score
    weights = {"HIGH": 1.0, "MEDIUM": 0.7, "LOW": 0.4, "SPECULATIVE": 0.1}
    total = sum(confidence_distribution.values())
    overall_score = sum(
        confidence_distribution[k] * weights[k] for k in weights
    ) / total if total > 0 else 0
    
    return {
        "summary_points": summary_points,
        "confidence_distribution": confidence_distribution,
        "overall_confidence_score": round(overall_score, 2),
        "confidence_interpretation": (
            "High confidence — most claims directly supported" if overall_score > 0.8 else
            "Good confidence — majority of claims well-supported" if overall_score > 0.6 else
            "Moderate confidence — some claims are inferred" if overall_score > 0.4 else
            "Low confidence — many claims are speculative"
        )
    }
```

### 3. Action-First Summarization

For meetings, PRs, and operational content, lead with actions and decisions, not narrative. The reader needs to know "what do I do next?" before "what happened?"

```python
def action_first_summary(content, content_type="meeting", llm=None):
    """
    Generate action-first summaries that lead with what matters:
    decisions, action items, and outcomes.
    
    Content types: meeting, pr, incident, review
    """
    
    type_specific_prompts = {
        "meeting": """Summarize this meeting transcript with the following structure:

## DECISIONS MADE
- List each decision with who made it

## ACTION ITEMS  
| Action | Owner | Due Date | Priority |
|--------|-------|----------|----------|
| {action} | {person} | {date} | {P0-P3} |

## KEY DISCUSSION POINTS
- {topic}: {one-line summary of discussion and outcome}

## OPEN QUESTIONS
- {questions that need follow-up}

## ATTENDEES
- {list of participants and their roles}

Meeting transcript:
{content}""",

        "pr": """Summarize this pull request with the following structure:

## WHAT Changed
{one paragraph: what this PR does and why}

## CHANGES
| File | Change Type | Description |
|------|-------------|-------------|
| {file} | {add/modify/delete} | {what changed} |

## RISK ASSESSMENT
- **Risk Level:** {Low/Medium/High}
- **Reason:** {why this risk level}
- **Rollback Plan:** {how to revert if needed}

## TESTING
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- {test coverage impact}

## DEPENDENCIES
- {depends on PR #X}
- {blocks PR #Y}

## REVIEWER NOTES
{specific areas that need attention}

PR diff:
{content}""",

        "incident": """Summarize this incident report with the following structure:

## SEVERITY & IMPACT
- **Severity:** {SEV1-SEV4}
- **Duration:** {start} to {end}
- **Users Affected:** {number/percentage}
- **Services Impacted:** {list}

## TIMELINE
| Time | Event |
|------|-------|
| {time} | {event} |

## ROOT CAUSE
{technical explanation}

## RESOLUTION
{what fixed it}

## ACTION ITEMS
| Action | Owner | Due | Priority |
|--------|-------|-----|----------|
| {action} | {owner} | {date} | {priority} |

## LESSONS
1. {lesson}

Incident report:
{content}"""
    }
    
    prompt = type_specific_prompts.get(content_type, type_specific_prompts["meeting"])
    
    if llm:
        return llm.generate(prompt.format(content=content), temperature=0)
    
    return prompt.format(content=content)
```

### 4. Sentiment-Aware Summarization

Track the emotional tone and sentiment shifts throughout the content, and include this in the summary. Particularly useful for customer feedback, reviews, and support tickets.

```python
def sentiment_aware_summary(content, llm=None):
    """
    Generate a summary that tracks sentiment throughout the content.
    
    Useful for:
    - Customer feedback analysis
    - Support ticket summaries
    - Review aggregation
    - Survey response analysis
    """
    
    prompt = f"""Analyze the following content and provide a summary that includes 
both the key points AND the overall sentiment trajectory.

## OVERALL SENTIMENT
- **Primary Sentiment:** {{Positive | Negative | Neutral | Mixed}}
- **Sentiment Score:** {{-1.0 to 1.0}}
- **Confidence:** {{High | Medium | Low}}

## SENTIMENT JOURNEY
Track how sentiment changes through the content:
| Section/Topic | Sentiment | Key Phrases | Score |
|---------------|-----------|-------------|-------|
| {{topic_1}} | {{pos/neg/neu}} | {{representative phrases}} | {{-1 to 1}} |

## KEY POSITIVE POINTS
- {{positive point with supporting quote}}

## KEY NEGATIVE POINTS  
- {{negative point with supporting quote}}

## PAIN POINTS (if negative sentiment detected)
1. {{pain point with severity: Critical/High/Medium/Low}}

## PRAISE POINTS (if positive sentiment detected)
1. {{praise point with context}}

## RECOMMENDATIONS
Based on the sentiment analysis:
1. {{actionable recommendation to address negative sentiment}}
2. {{actionable recommendation to amplify positive sentiment}}

## SUMMARY
{{2-3 sentence summary incorporating both content and sentiment}}

Content to analyze:
{content}"""
    
    return prompt
```

### 5. Log Pattern Detection and Summarization

Detect patterns, anomalies, and trends in log files, then summarize them in a human-readable format.

```python
import re
from collections import Counter
from datetime import datetime

def summarize_logs(log_content, time_window="1h"):
    """
    Analyze log files and create a structured summary with:
    - Error patterns and frequencies
    - Time-based trends
    - Anomalies
    - Root cause candidates
    """
    lines = log_content.strip().split('\n')
    
    # Parse log entries
    entries = []
    error_pattern = re.compile(r'(ERROR|FATAL|CRITICAL|WARN|WARNING)', re.IGNORECASE)
    timestamp_pattern = re.compile(r'(\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2})')
    
    errors = []
    warnings = []
    by_hour = Counter()
    by_component = Counter()
    error_messages = Counter()
    
    for line in lines:
        # Extract timestamp
        ts_match = timestamp_pattern.search(line)
        if ts_match:
            try:
                ts = datetime.fromisoformat(ts_match.group(1))
                by_hour[ts.strftime('%Y-%m-%d %H:00')] += 1
            except ValueError:
                pass
        
        # Classify log level
        level_match = error_pattern.search(line)
        if level_match:
            level = level_match.group(1).upper()
            if level in ('ERROR', 'FATAL', 'CRITICAL'):
                errors.append(line)
                # Extract error message (after the level)
                msg = re.sub(r'^.*?(ERROR|FATAL|CRITICAL)[:\s]+', '', line).strip()
                error_messages[msg[:100]] += 1
            elif level in ('WARN', 'WARNING'):
                warnings.append(line)
    
    # Detect anomalies (hours with significantly more entries than average)
    hourly_counts = list(by_hour.values())
    if hourly_counts:
        avg = sum(hourly_counts) / len(hourly_counts)
        anomaly_threshold = avg * 2
        anomalous_hours = [
            hour for hour, count in by_hour.items() 
            if count > anomaly_threshold
        ]
    else:
        anomaly_threshold = 0
        anomalous_hours = []
    
    # Build summary
    total_lines = len(lines)
    error_rate = len(errors) / total_lines * 100 if total_lines > 0 else 0
    
    summary = {
        "overview": {
            "total_lines": total_lines,
            "errors": len(errors),
            "warnings": len(warnings),
            "error_rate": f"{error_rate:.2f}%",
            "time_span": f"{min(by_hour.keys()) if by_hour else 'N/A'} to {max(by_hour.keys()) if by_hour else 'N/A'}"
        },
        "top_errors": [
            {"message": msg, "count": count, "pct": f"{count/len(errors)*100:.1f}%" if errors else "0%"}
            for msg, count in error_messages.most_common(10)
        ],
        "anomalies": {
            "anomalous_hours": anomalous_hours,
            "threshold": anomaly_threshold,
            "severity": "HIGH" if error_rate > 5 else "MEDIUM" if error_rate > 1 else "LOW"
        },
        "recommendations": []
    }
    
    # Generate recommendations
    if error_rate > 5:
        summary["recommendations"].append(
            f"HIGH PRIORITY: Error rate of {error_rate:.1f}% is critically high. "
            f"Investigate top error patterns immediately."
        )
    if anomalous_hours:
        summary["recommendations"].append(
            f"Anomalous activity detected during: {', '.join(anomalous_hours[:5])}. "
            f"Correlate with deployment or infrastructure changes."
        )
    if error_messages:
        top_error = error_messages.most_common(1)[0]
        summary["recommendations"].append(
            f"Most frequent error ({top_error[1]} occurrences): '{top_error[0][:50]}...' "
            f"This is likely a systemic issue."
        )
    
    return summary
```

### 6. Codebase Overview Generation

Generate a high-level overview of a codebase suitable for onboarding new team members or architecture reviews.

```python
def generate_codebase_overview(codebase_files, llm=None):
    """
    Generate a structured codebase overview covering:
    - Architecture and structure
    - Key components and their responsibilities
    - Dependencies and integrations
    - Patterns and conventions
    - Entry points and data flow
    """
    
    # Categorize files
    categories = {
        "config": [],
        "entry_points": [],
        "models": [],
        "services": [],
        "controllers": [],
        "utils": [],
        "tests": [],
        "docs": [],
        "other": []
    }
    
    for file_path, content in codebase_files.items():
        path_lower = file_path.lower()
        if any(x in path_lower for x in ['config', 'settings', '.env']):
            categories["config"].append((file_path, content))
        elif any(x in path_lower for x in ['main', 'app', 'index', 'server']):
            categories["entry_points"].append((file_path, content))
        elif any(x in path_lower for x in ['model', 'schema', 'entity']):
            categories["models"].append((file_path, content))
        elif any(x in path_lower for x in ['service', 'handler', 'business']):
            categories["services"].append((file_path, content))
        elif any(x in path_lower for x in ['controller', 'route', 'api', 'endpoint']):
            categories["controllers"].append((file_path, content))
        elif any(x in path_lower for x in ['util', 'helper', 'common', 'lib']):
            categories["utils"].append((file_path, content))
        elif 'test' in path_lower:
            categories["tests"].append((file_path, content))
        elif any(x in path_lower for x in ['readme', 'doc', 'changelog']):
            categories["docs"].append((file_path, content))
        else:
            categories["other"].append((file_path, content))
    
    overview = {
        "structure": {
            "total_files": len(codebase_files),
            "by_category": {k: len(v) for k, v in categories.items()}
        },
        "architecture": None,
        "key_components": [],
        "dependencies": [],
        "patterns": [],
        "entry_points": [],
        "data_flow": None
    }
    
    if llm:
        # Generate architecture description
        entry_content = "\n".join([
            f"--- {path} ---\n{content[:500]}" 
            for path, content in categories["entry_points"]
        ])
        
        model_content = "\n".join([
            f"--- {path} ---\n{content[:500]}" 
            for path, content in categories["models"][:5]
        ])
        
        overview["architecture"] = llm.generate(
            f"""Based on these entry points and model files from a codebase, 
describe the overall architecture in 3-5 bullet points.

Entry points:
{entry_content}

Models:
{model_content}

Architecture overview:""",
            temperature=0
        )
    
    return overview
```

### 7. Meeting Summary with Decision Tracking

```python
def meeting_summary(transcript, participants=None, llm=None):
    """
    Generate a comprehensive meeting summary with:
    - Decisions made (with who decided)
    - Action items (with owners and deadlines)
    - Key discussion points
    - Unresolved questions
    - Sentiment assessment per topic
    """
    
    prompt = f"""Analyze this meeting transcript and create a structured summary.

Meeting participants: {', '.join(participants) if participants else 'Unknown'}

Create the summary with these EXACT sections:

## MEETING INFO
- **Date:** {{date if detectable}}
- **Duration:** {{duration if detectable}}
- **Participants:** {{list}}
- **Meeting Type:** {{status update | brainstorming | decision | retrospective | other}}

## DECISIONS
List every decision made, including who made it:
| # | Decision | Made By | Rationale |
|---|----------|---------|-----------|
| 1 | {{decision}} | {{person}} | {{why}} |

## ACTION ITEMS
| # | Action | Owner | Due Date | Priority | Status |
|---|--------|-------|----------|----------|--------|
| 1 | {{action}} | {{person}} | {{date}} | {{P0-P3}} | {{new}} |

## KEY DISCUSSION POINTS
### Topic 1: {{topic}}
- **Summary:** {{what was discussed}}
- **Consensus:** {{yes/partially/no}}
- **Next steps:** {{if any}}

### Topic 2: {{topic}}
{{repeat}}

## OPEN QUESTIONS
Questions that were raised but not answered:
1. {{question}} (raised by {{person}})

## RISKS & BLOCKERS
Identified risks or blockers mentioned:
1. {{risk/blocker}} — {{mitigation if discussed}}

## NEXT MEETING
- **Date:** {{if discussed}}
- **Agenda items:** {{if discussed}}

Transcript:
{transcript}"""
    
    return prompt
```

### 8. Comparative Summarization Matrix

When summarizing multiple options, approaches, or documents, force parallel structure into a matrix. This makes differences immediately visible and prevents the "they all sound similar" problem.

```python
def comparative_matrix(items, criteria, source_texts, llm=None):
    """
    Generate a comparison matrix summarizing multiple items across shared criteria.
    
    items: list of items being compared (e.g., ["Redis", "Memcached", "DragonflyDB"])
    criteria: list of comparison dimensions (e.g., ["performance", "persistence", "cost"])
    source_texts: dict mapping item names to their source content
    """
    
    matrix = {"items": items, "criteria": criteria, "cells": {}}
    
    for item in items:
        source = source_texts.get(item, "")
        for criterion in criteria:
            prompt = f"""Extract information about "{criterion}" for {item} from this text.
            
Return a brief summary (1-2 sentences) focused specifically on {criterion}.
If the text doesn't mention {criterion}, respond with "Not discussed."

Source text:
{source[:2000]}"""
            
            if llm:
                cell = llm.generate(prompt, temperature=0, max_tokens=100)
            else:
                cell = f"Summary of {criterion} for {item}"
            
            matrix["cells"][(item, criterion)] = cell.strip()
    
    # Determine "winner" for each criterion
    matrix["recommendations"] = {}
    for criterion in criteria:
        # In practice, this would use LLM reasoning or scoring
        matrix["recommendations"][criterion] = f"Best option for {criterion} depends on specific requirements"
    
    return matrix


def format_comparative_matrix(matrix):
    """Format a comparative matrix as a Markdown table."""
    items = matrix["items"]
    criteria = matrix["criteria"]
    
    # Header row
    header = "| Criteria | " + " | ".join(items) + " |"
    separator = "|" + "|".join(["---"] * (len(items) + 1)) + "|"
    
    rows = [header, separator]
    for criterion in criteria:
        cells = [matrix["cells"].get((item, criterion), "—") for item in items]
        row = f"| **{criterion.title()}** | " + " | ".join(cells) + " |"
        rows.append(row)
    
    return "\n".join(rows)

# Usage
matrix = comparative_matrix(
    items=["Redis", "Memcached", "DragonflyDB"],
    criteria=["performance", "persistence", "data_structures", "operational_maturity", "cost"],
    source_texts={
        "Redis": "Redis is an in-memory data store...",
        "Memcached": "Memcached is a distributed memory caching system...",
        "DragonflyDB": "DragonflyDB is a modern Redis-compatible..."
    },
    llm=my_llm
)
print(format_comparative_matrix(matrix))
```

### 9. Quote Extraction

When the author's exact words carry authority, nuance, or historical significance, extract key quotes alongside your summary rather than paraphrasing. This preserves the original voice and prevents the summary from inadvertently changing meaning.

```python
def extract_key_quotes(document, llm=None, max_quotes=7):
    """
    Extract the most significant quotes from a document, preserving original voice.
    
    Good quotes are:
    - Definitional: "A Staff Engineer's job is to make the team more effective"
    - Emotional: "We were 3 hours from losing all customer data"
    - Authoritative: "As the CTO, I want to be clear about..."
    - Surprising: "Despite expectations, performance actually decreased"
    - Declarative: "We will not ship without security review"
    """
    
    prompt = f"""Extract the {max_quotes} most significant quotes from this document.

For each quote, provide:
1. The exact quote (preserve the author's words precisely)
2. The author/speaker (if identifiable)
3. Why this quote is significant (one sentence)
4. The context surrounding the quote (one sentence)

Criteria for selection:
- definitional: statements that define or explain a concept
- emotional: statements that convey strong feeling or urgency
- authoritative: statements from leadership or subject matter experts
- surprising: statements that contradict expectations
- actionable: statements that commit to specific action

Document:
{document}

Return as a structured list."""

    if llm:
        return llm.generate(prompt, temperature=0)
    
    return prompt


def format_quote_summary(quotes):
    """Format extracted quotes with attribution and context."""
    output = ["## Key Quotes\n"]
    
    for i, quote in enumerate(quotes, 1):
        output.append(f"> \"{quote['text']}\"")
        output.append(f"> — {quote.get('author', 'Unknown')}\n")
        output.append(f"*Why it matters: {quote.get('significance', 'N/A')}*\n")
        output.append(f"*Context: {quote.get('context', 'N/A')}*\n")
        output.append("---\n")
    
    return "\n".join(output)

# Usage in a summary
def quote_enhanced_summary(document, llm=None):
    """Combine a standard summary with key quotes for maximum fidelity."""
    
    summary = generate_standard_summary(document, llm)  # Your existing summary function
    quotes = extract_key_quotes(document, llm, max_quotes=5)
    
    return f"""## Summary

{summary}

## Key Quotes (verbatim)

{format_quote_summary(quotes)}

*Note: Quotes are presented verbatim to preserve the author's original voice.*
"""
```

---

## Common Patterns

### Pattern 1: Extractive Summarization with TF-IDF Ranking

```python
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

def extractive_summary(text, num_sentences=5):
    """
    Extractive summarization: select the most important sentences 
    from the source text based on TF-IDF relevance scoring.
    """
    # Split into sentences
    sentences = [s.strip() for s in text.replace('\n', ' ').split('.') if s.strip()]
    
    if len(sentences) <= num_sentences:
        return '. '.join(sentences) + '.'
    
    # Compute TF-IDF
    vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = vectorizer.fit_transform(sentences)
    
    # Compute document vector (centroid of all sentence vectors)
    doc_vector = tfidf_matrix.mean(axis=0)
    
    # Score each sentence by similarity to document centroid
    scores = cosine_similarity(tfidf_matrix, doc_vector).flatten()
    
    # Add position bonus (first and last sentences often important)
    position_bonus = np.zeros(len(sentences))
    position_bonus[0] = 0.3  # First sentence bonus
    position_bonus[-1] = 0.2  # Last sentence bonus
    for i in range(1, min(3, len(sentences))):
        position_bonus[i] = 0.1  # Early sentences bonus
    
    final_scores = scores + position_bonus
    
    # Select top sentences
    top_indices = np.argsort(final_scores)[-num_sentences:][::-1]
    top_indices = sorted(top_indices)  # Maintain original order
    
    summary = '. '.join(sentences[i] for i in top_indices) + '.'
    return summary

# Usage
text = """Your long document text here. This method selects the most 
relevant sentences based on TF-IDF similarity to the document centroid."""
summary = extractive_summary(text, num_sentences=5)
```

### Pattern 2: Meeting Summary with Action Extraction

```python
import re

def extract_actions_from_text(text):
    """
    Extract action items from meeting notes or transcripts.
    Uses pattern matching for common action item indicators.
    """
    action_patterns = [
        r'(?:will|should|needs to|must|going to|plan to)\s+(.+?)(?:\.|$)',
        r'(?:action item|todo|task)[:\s]+(.+?)(?:\.|$)',
        r'(?:assigned to|owned by)\s+(.+?)(?:\.|$)',
        r'(?:follow up on|follow-up on)\s+(.+?)(?:\.|$)',
        r'(?:decided to)\s+(.+?)(?:\.|$)',
    ]
    
    actions = []
    for pattern in action_patterns:
        matches = re.finditer(pattern, text, re.IGNORECASE)
        for match in matches:
            action_text = match.group(1).strip()
            if len(action_text) > 10:  # Filter out too-short matches
                actions.append({
                    "action": action_text,
                    "source_sentence": match.group(0),
                    "confidence": "high" if "action item" in match.group(0).lower() else "medium"
                })
    
    # Deduplicate similar actions
    unique_actions = []
    seen = set()
    for action in actions:
        key = action["action"].lower()[:50]
        if key not in seen:
            seen.add(key)
            unique_actions.append(action)
    
    return unique_actions

def format_meeting_summary(transcript, decisions=None, actions=None):
    """Format a structured meeting summary."""
    summary = []
    
    summary.append("## Meeting Summary\n")
    
    if decisions:
        summary.append("### Decisions Made\n")
        for i, d in enumerate(decisions, 1):
            summary.append(f"{i}. **{d.get('topic', 'Decision')}**: {d.get('decision', d)}")
            if d.get('made_by'):
                summary.append(f"   - Made by: {d['made_by']}")
        summary.append("")
    
    if actions:
        summary.append("### Action Items\n")
        summary.append("| # | Action | Owner | Due | Priority |")
        summary.append("|---|--------|-------|-----|----------|")
        for i, a in enumerate(actions, 1):
            summary.append(f"| {i} | {a['action']} | {a.get('owner', 'TBD')} | {a.get('due', 'TBD')} | {a.get('priority', 'P2')} |")
        summary.append("")
    
    return "\n".join(summary)
```

### Pattern 3: PR Summary Generator

```python
def generate_pr_summary(pr_data):
    """
    Generate a structured PR summary from GitHub PR data.
    
    pr_data should contain:
    - title, description, author
    - files_changed (list of {filename, additions, deletions, status})
    - commits (list of {message, author})
    - reviewers, labels
    """
    files = pr_data.get("files_changed", [])
    commits = pr_data.get("commits", [])
    
    # Categorize changes
    categories = {
        "features": [],
        "bugfixes": [],
        "refactoring": [],
        "tests": [],
        "docs": [],
        "config": [],
        "dependencies": [],
    }
    
    for f in files:
        path = f["filename"].lower()
        if "test" in path:
            categories["tests"].append(f)
        elif "readme" in path or "doc" in path or "changelog" in path:
            categories["docs"].append(f)
        elif "package.json" in path or "requirements" in path or "go.mod" in path:
            categories["dependencies"].append(f)
        elif any(x in path for x in ["config", "env", "dockerfile", "yaml"]):
            categories["config"].append(f)
        elif f.get("status") == "added":
            categories["features"].append(f)
        elif f.get("status") == "removed":
            categories["refactoring"].append(f)
        else:
            categories["features"].append(f)  # Default to feature
    
    # Calculate stats
    total_additions = sum(f.get("additions", 0) for f in files)
    total_deletions = sum(f.get("deletions", 0) for f in files)
    total_files = len(files)
    
    # Risk assessment
    risk_factors = []
    if total_files > 20:
        risk_factors.append(f"Large PR ({total_files} files changed)")
    if total_additions + total_deletions > 1000:
        risk_factors.append(f"Large diff ({total_additions + total_deletions} lines)")
    if any("migration" in f["filename"].lower() for f in files):
        risk_factors.append("Contains database migration")
    if any("config" in f["filename"].lower() for f in files):
        risk_factors.append("Configuration changes")
    
    risk_level = "High" if len(risk_factors) > 2 else "Medium" if len(risk_factors) > 0 else "Low"
    
    # Build summary
    summary = f"""## PR Summary

### Overview
**{pr_data.get('title', 'Untitled PR')}**
Author: {pr_data.get('author', 'Unknown')}
{pr_data.get('description', 'No description provided.')}

### Changes at a Glance
| Metric | Value |
|--------|-------|
| Files Changed | {total_files} |
| Lines Added | +{total_additions} |
| Lines Deleted | -{total_deletions} |
| Net Change | {'+' if total_additions > total_deletions else ''}{total_additions - total_deletions} |

### Change Categories
"""
    
    for category, cat_files in categories.items():
        if cat_files:
            summary += f"\n**{category.title()}** ({len(cat_files)} files):\n"
            for f in cat_files[:5]:  # Show top 5 per category
                summary += f"- `{f['filename']}` (+{f.get('additions', 0)}/-{f.get('deletions', 0)})\n"
            if len(cat_files) > 5:
                summary += f"- ... and {len(cat_files) - 5} more\n"
    
    summary += f"""
### Risk Assessment
**Risk Level:** {risk_level}
"""
    for factor in risk_factors:
        summary += f"- ⚠️ {factor}\n"
    
    if not risk_factors:
        summary += "- ✅ No significant risk factors detected\n"
    
    summary += f"""
### Testing Checklist
- [ ] Unit tests added/updated ({len(categories['tests'])} test files changed)
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Edge cases covered
- [ ] Performance impact assessed

### Reviewer Focus Areas
"""
    if risk_factors:
        for factor in risk_factors:
            summary += f"- Review {factor.lower()}\n"
    else:
        summary += "- Standard review sufficient\n"
    
    return summary
```

### Pattern 4: Research Paper Summary

```python
def summarize_research_paper(paper_text, llm=None):
    """
    Create a structured summary of a research paper following
    the standard academic structure.
    """
    
    prompt = f"""Summarize this research paper with the following structured format:

## Paper Metadata
- **Title:** {{extract from text}}
- **Authors:** {{extract if available}}
- **Year:** {{extract if available}}
- **Venue:** {{extract if available}}

## TL;DR
{{
One sentence that captures the core contribution and finding.
}}

## Problem Statement
{{
What problem does this paper address? Why is it important?
2-3 sentences.
}}

## Key Contribution
{{
What is the novel contribution? What does this paper add to the field?
1-2 sentences.
}}

## Method
{{
How did they approach the problem? What technique/framework did they use?
3-5 sentences covering the key methodological choices.
}}

## Key Results
| Metric/Claim | Result | Comparison to Baseline |
|--------------|--------|----------------------|
| {{metric}} | {{value}} | {{vs baseline}} |

## Limitations
- {{limitation 1 stated or inferred by authors}}
- {{limitation 2}}
- {{limitation 3}}

## Relevance
- **For practitioners:** {{why this matters for building things}}
- **For researchers:** {{what research directions this opens}}
- **Caveats:** {{what to be careful about when applying this}}

## Key Takeaways
1. {{takeaway 1}}
2. {{takeaway 2}}
3. {{takeaway 3}}

## Related Work
{{2-3 sentences on how this relates to other work in the area}}

Paper text:
{paper_text}"""
    
    return prompt
```

### Pattern 5: Executive Summary Generator

```python
def executive_summary(technical_report, audience="executive", llm=None):
    """
    Generate an executive summary that translates technical content
    into business-relevant language.
    """
    
    audience_configs = {
        "executive": {
            "focus": "business impact, ROI, strategic implications",
            "avoid": "technical jargon, implementation details, code",
            "format": "bullet points with clear recommendations"
        },
        "board": {
            "focus": "strategic alignment, competitive advantage, risk",
            "avoid": "any technical details, metrics without context",
            "format": "3-5 key messages with supporting evidence"
        },
        "engineering_lead": {
            "focus": "technical approach, trade-offs, team impact",
            "avoid": "overly simplified language, business metrics only",
            "format": "structured technical summary with recommendations"
        }
    }
    
    config = audience_configs.get(audience, audience_configs["executive"])
    
    prompt = f"""Create an executive summary of this technical report for a {audience} audience.

Audience focus: {config['focus']}
Avoid: {config['avoid']}
Format: {config['format']}

## Executive Summary

### Key Message
{{One sentence that captures the most important finding or recommendation}}

### Background
{{2-3 sentences: why this matters, what was investigated}}

### Key Findings
{{Bullet list of 3-5 most important findings, translated for {audience}}}

### Business Impact
{{What do these findings mean for the business? Quantify if possible.}}

### Recommendations
{{Ordered list of recommended actions with expected outcomes}}

### Risks & Considerations
{{What could go wrong? What are the trade-offs?}}

### Next Steps
{{Concrete next actions with owners and timelines}}

Technical report:
{technical_report}"""
    
    return prompt
```

---

## Edge Cases & Pitfalls

### 1. Faithfulness Violations (Hallucination in Summaries)
**Problem:** The summary includes information not present in the source material. This is the most dangerous summarization failure.
**Solution:** Always verify summaries against the source. Use extractive methods when faithfulness is critical. Flag any inferred content.

### 2. Loss of Nuance in Compression
**Problem:** Aggressive summarization loses important caveats, conditions, or "except when..." clauses that change the meaning.
**Solution:** Preserve conditional statements and caveats. When compressing, use "with caveats" markers rather than stripping nuance.

### 3. Bias Amplification
**Problem:** The summary disproportionately represents certain viewpoints or topics from the source, amplifying existing biases.
**Solution:** Track topic coverage across the source. Ensure all major sections/perspectives are represented proportionally.

### 4. Inappropriate Confidence Level
**Problem:** The summary presents uncertain inferences with the same confidence as directly stated facts.
**Solution:** Use confidence-flagged summaries. Distinguish between "the paper says X" and "this implies Y."

### 5. Audience Mismatch
**Problem:** A technical summary given to executives (too much detail) or an executive summary given to engineers (too vague).
**Solution:** Always calibrate the summary for the intended audience. When in doubt, create multiple versions.

### 6. Missing Key Numbers
**Problem:** The summary omits critical quantitative data (dates, amounts, percentages, error rates) that are essential for decision-making.
**Solution:** Always preserve key metrics and numbers in summaries. Create a "key numbers" section.

### 7. Chronological Distortion in Meeting Summaries
**Problem:** Summarizing meetings by extracting sentences out of chronological context, losing the flow of discussion and decision evolution.
**Solution:** Maintain chronological order for discussion summaries. Use the "Decision → Rationale → Action" pattern.

### 8. Summarizing Too Short a Source
**Problem:** Applying summarization to content that's already concise (<500 words) produces a "summary" that's barely shorter and loses detail.
**Solution:** Set a minimum source length threshold. For short content, return the key points without compression.

### 9. Inconsistent Summaries Across Runs
**Problem:** Running the same summarization twice produces different summaries, making the process unreliable.
**Solution:** Use temperature=0 for deterministic summaries. For extractive methods, use fixed scoring algorithms.

### 10. Ignoring Code Context in PR Summaries
**Problem:** Summarizing code changes without understanding what the code does — just counting lines changed.
**Solution:** Parse the code structure (functions, classes, imports) to understand what changed, not just how much changed.

### 11. Log Summaries Missing Temporal Patterns
**Problem:** Summarizing logs as a flat list of errors, missing time-based patterns (error spikes after deployments).
**Solution:** Always include temporal analysis in log summaries. Group errors by time window and correlate with events.

### 12. Over-summarizing Action Items
**Problem:** Compressing action items so much that owners, deadlines, or specific tasks are lost.
**Solution:** Never compress action items below the level of "who does what by when." Action items need full detail.

### 13. Missing Cross-references
**Problem:** The summary doesn't link back to specific sections, pages, or timestamps in the source, making verification difficult.
**Solution:** Include page numbers, section references, or timestamps for key summary points.

### 14. Tone Mismatch
**Problem:** The summary's tone doesn't match the source — a casual Slack summary sounds formal, or a serious incident report sounds flippant.
**Solution:** Detect and preserve the source's tone. Adjust the summary's formality to match.

### 15. Not Handling Multi-source Input
**Problem:** Failing to properly merge summaries when the input comes from multiple sources (e.g., multiple meeting attendees' notes).
**Solution:** For multi-source input, identify overlapping and unique information. Merge with deduplication and conflict resolution.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **RAG Implementation** | Downstream | Summarize retrieved chunks before injection into context to manage token limits |
| **Data Analysis** | Output | Summarize statistical findings and analysis results for stakeholders |
| **Technical Writing** | Complementary | Summaries are a form of technical writing; use the same clarity principles |
| **Data Cleaning** | Upstream | Clean data produces better summaries; remove noise before summarizing |
| **Code Understanding** | Enhancement | Code-aware summarization requires understanding code structure and patterns |
| **Knowledge Management** | Core Component | Summaries create the navigable layer of a knowledge base |
| **Natural Language Processing** | Foundation | Text processing, tokenization, and NLP techniques underpin summarization |
| **Monitoring & Observability** | Application | Log summarization and incident summarization are key monitoring outputs |

---

## Output Format Templates

### Standard Document Summary

```markdown
## Summary: {Document Title}

### TL;DR
{One sentence capturing the single most important point}

### Key Points
- **{Point 1}:** {description}
- **{Point 2}:** {description}
- **{Point 3}:** {description}

### Decisions & Conclusions
1. {decision_1}
2. {decision_2}

### Key Numbers
| Metric | Value | Context |
|--------|-------|---------|
| {metric} | {value} | {what it means} |

### Recommendations
1. {recommendation_1}
2. {recommendation_2}

### Source Reference
- Original: {source_name}, {total_pages} pages
- Summary compression: {original_words} → {summary_words} words ({ratio}%)
```

### Quick Summary

```markdown
## {Topic}: Quick Summary

**What:** {one sentence}
**Why it matters:** {one sentence}
**Key numbers:** {key metrics}
**Action needed:** {yes/no + what}
**Confidence:** {high/medium/low}
```

### Deep Summary (Multi-section)

```markdown
## Comprehensive Summary: {Document Title}

### Overview
{2-3 paragraph overview covering context, main content, and conclusions}

### Section-by-Section Summary

#### {Section 1 Title}
**Key insight:** {one sentence}
**Details:** {2-3 sentences}
**Evidence:** {data/citations supporting the insight}

#### {Section 2 Title}
**Key insight:** {one sentence}
**Details:** {2-3 sentences}
**Evidence:** {data/citations}

### Cross-cutting Themes
- **Theme 1:** {how it appears across sections}
- **Theme 2:** {how it appears across sections}

### Actionable Takeaways
| Priority | Takeaway | Owner | Deadline |
|----------|----------|-------|----------|
| P0 | {takeaway} | {owner} | {date} |

### Confidence Assessment
| Claim | Confidence | Evidence Level |
|-------|-----------|----------------|
| {claim} | {HIGH/MED/LOW} | {direct/inferred/speculative} |
```

### Agent-Friendly Structured Output

```json
{
  "summary": {
    "type": "{document|meeting|pr|log|paper}",
    "title": "{title}",
    "source_length": 5000,
    "summary_length": 250,
    "compression_ratio": 0.05,
    "tldr": "{one sentence}",
    "key_points": [
      {"point": "...", "importance": "high", "confidence": "high"},
      {"point": "...", "importance": "medium", "confidence": "medium"}
    ],
    "decisions": [
      {"decision": "...", "made_by": "...", "rationale": "..."}
    ],
    "action_items": [
      {"action": "...", "owner": "...", "due": "...", "priority": "P1"}
    ],
    "numbers": [
      {"metric": "...", "value": "...", "context": "..."}
    ],
    "sentiment": {
      "overall": "positive",
      "score": 0.7,
      "confidence": "high"
    },
    "confidence_score": 0.85,
    "topics_covered": ["topic1", "topic2", "topic3"],
    "missing_topics": ["topic4"]
  }
}
```

---

## Rules

1. **Faithfulness is non-negotiable** — Never include information in a summary that isn't in the source. Mark inferences explicitly. A wrong summary is worse than no summary.
2. **Lead with what matters** — For action-oriented content (meetings, PRs, incidents), put decisions and action items first. For informational content, lead with the key finding.
3. **Preserve key numbers** — Dates, amounts, percentages, error rates, and metrics must survive summarization. They're often the most decision-relevant information.
4. **Maintain source structure** — Respect the source's logical organization. Don't reorder sections unless the summary format explicitly requires it.
5. **Calibrate for audience** — An executive summary is different from a technical summary. Know who's reading and adjust depth, vocabulary, and focus.
6. **Flag uncertainty** — Use confidence markers to distinguish between directly stated facts and inferences. Readers should know what's certain vs. extrapolated.
7. **Include source references** — Link summary points back to specific sections, pages, or timestamps so readers can verify and explore further.
8. **Never compress below utility** — An action item without an owner is useless. A finding without context is meaningless. Don't sacrifice utility for brevity.
9. **Validate completeness** — Check that all major topics in the source are covered in the summary. Missing a critical topic is worse than a slightly longer summary.
10. **Handle multi-source input gracefully** — When summarizing from multiple sources, deduplicate overlapping information and resolve conflicts explicitly.
11. **Preserve temporal order for meeting summaries** — The flow of discussion matters. Don't reorder discussion points unless the format explicitly requires it.
12. **Track sentiment for subjective content** — For reviews, feedback, and opinions, include sentiment analysis alongside content summary.
13. **Use consistent format** — Within a series of summaries (e.g., weekly meeting summaries), use the same format so readers can scan efficiently.
14. **Keep summaries scannable** — Use bullet points, tables, and headers. Nobody reads a summary as a wall of text.
15. **Review summaries against source** — Before finalizing, spot-check that key claims in the summary accurately represent the source. One misrepresentation destroys trust.
