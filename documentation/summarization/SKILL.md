---
name: summarization
description: >-
  Create clear, accurate summaries of documents, articles, conversations, and code.
  English: summarization, text summarization, executive summary, abstract generation,
    content distillation, key point extraction, TL;DR, digest, briefing, recap,
    meeting notes summary, article summary, book summary, research summary.
  فارسی: خلاصه‌سازی، خلاصه متن، خلاصه اجرایی، استخراج نکات کلیدی، چکیده،
    بازبینی، یادداشت جلسات، خلاصه مقاله، خلاصه کتاب، خلاصه پژوهش.
  中文: 摘要生成，文本摘要，执行摘要，关键点提取，内容提炼，会议纪要摘要，
    文章摘要，书籍摘要，研究摘要，简报。
priority: P3
dependencies: []
conflicts: []
---

# Summarization

## Overview

Summarization is the process of distilling a source document into a shorter version that preserves the essential meaning, key points, and critical information. A good summary enables the reader to understand the source's main ideas without reading the full text, while a bad summary either omits critical information or introduces misinterpretation.

The two fundamental approaches are **extractive** (selecting the most important sentences or phrases directly from the source) and **abstractive** (generating new sentences that capture the meaning, potentially using different words and structure). Most effective summarization combines both: extract key information, then rephrase for clarity and conciseness.

This skill covers summarization across diverse content types: research papers, articles, books, meetings, code, conversations, and reports. Each type has different structural conventions, key information locations, and audience expectations for the summary.

## When to Use This Skill

- Creating executive summaries of reports or proposals
- Summarizing research papers or articles for quick comprehension
- Writing meeting notes and action item summaries
- Generating abstracts for academic papers
- Creating TL;DR sections for long documents
- Distilling technical specifications into decision briefs
- Summarizing books, chapters, or long-form content
- Creating digests or newsletters from multiple sources
- Producing code summaries or architecture overviews

## When NOT to Use This Skill

- Full-text translation (use translation skills)
- Creative rewriting or rephrasing for style (use paraphrasing skills)
- Detailed analysis or critique (use analytical skills)
- When the source is too short to summarize meaningfully (< 200 words)
- When verbatim quotes are required (use citation skills)
- Real-time summarization of live events (use note-taking skills)

---

## Workflow

### Phase 1: Source Analysis

**Objective:** Understand the source document's structure, type, and key information before attempting to summarize.

```
Source Document → Type Identification → Structure Analysis → Key Point Extraction → Audience Consideration
```

**Step 1.1 — Identify Source Type**
Different content types have different summarization patterns:
- **Research paper:** Abstract, introduction, methods, results, discussion, conclusion
- **News article:** Lead paragraph, supporting details, background, quotes
- **Meeting transcript:** Agenda items, discussions, decisions, action items
- **Book chapter:** Thesis, arguments, evidence, conclusions
- **Technical document:** Overview, specifications, implementation details, examples

**Step 1.2 — Analyze Structure**
Map the document's structure: headings, sections, paragraphs, key sentences (topic sentences), supporting evidence, conclusions. Identify the hierarchy of importance.

**Step 1.3 — Extract Key Points**
Identify the main ideas, supporting arguments, key data points, conclusions, and action items. Use position-based heuristics (first/last sentences, heading text) and content-based heuristics (signal words like "the key finding is," "in conclusion," "we recommend").

**Step 1.4 — Consider Audience**
Adjust summary depth and vocabulary based on the target reader. An executive needs business impact and decisions. A researcher needs methodology and findings. A developer needs implementation details and trade-offs.

### Phase 2: Summary Strategy Selection

**Objective:** Choose the right summarization approach based on content type and purpose.

```
Content Type → Purpose → Strategy → Length Target → Format Selection
```

| Content Type | Purpose | Strategy | Length Target |
|---|---|---|---|
| Research paper | Quick overview | Structured abstract format | 150-300 words |
| News article | Inform | Inverted pyramid | 2-3 paragraphs |
| Meeting | Track decisions | Action-oriented | Bullet points |
| Book chapter | Understand | Concept extraction | 200-500 words |
| Technical doc | Implement | Task-oriented | Steps + context |
| Report | Decide | Executive brief | 1 page |

### Phase 3: Summary Generation

**Objective:** Create the summary using the selected strategy and structure.

```
Key Points → Organization → Drafting → Compression → Polish
```

**Step 3.1 — Organize Key Points**
Arrange key points in order of importance (deductive) or logical flow (inductive). For most technical content, use deductive order: conclusion first, then supporting evidence.

**Step 3.2 — Draft the Summary**
Write the summary sentence by sentence. Each sentence should convey one key point. Avoid redundancy. Use the source's terminology for accuracy but simplify complex sentences.

**Step 3.3 — Compress and Refine**
Review for length. Remove unnecessary words, combine related points, and eliminate examples unless they're essential for understanding. Every word should earn its place.

**Step 3.4 — Final Polish**
Check for accuracy (does the summary faithfully represent the source?), completeness (are all key points covered?), and clarity (could a reader understand the summary without the source?).

### Phase 4: Quality Verification

**Objective:** Ensure the summary is accurate, complete, and appropriate for its purpose.

```
Accuracy Check → Completeness Check → Bias Check → Final Approval
```

**Step 4.1 — Accuracy Check**
Compare the summary against the source. Verify that no claims are made in the summary that aren't supported by the source. Check that key numbers, names, and dates are correct.

**Step 4.2 — Completeness Check**
Verify that all major points from the source are represented. Check that the summary doesn't omit important caveats, limitations, or counter-arguments.

**Step 4.3 — Bias Check**
Ensure the summary doesn't introduce bias by selectively representing only certain viewpoints or emphasizing minor points over major ones.

---

## Advanced Techniques

### 1. Hierarchical Summarization

Create summaries at multiple levels of detail, allowing readers to choose their depth of engagement.

```python
def hierarchical_summary(document, levels=None):
    """
    Create a multi-level summary:
    - Level 1: One-line TL;DR (1 sentence)
    - Level 2: Brief summary (1 paragraph, 3-5 sentences)
    - Level 3: Detailed summary (key points with supporting details)
    - Level 4: Structured overview (section-by-section summary)
    """
    if levels is None:
        levels = [1, 2, 3, 4]
    
    # Extract key information
    key_points = extract_key_points(document)
    main_argument = extract_main_argument(document)
    supporting_evidence = extract_supporting_evidence(document)
    conclusions = extract_conclusions(document)
    
    summary = {}
    
    if 1 in levels:
        # One-line TL;DR
        summary['tldr'] = f"{main_argument['claim']}. {conclusions['primary']}"
    
    if 2 in levels:
        # Brief paragraph summary
        sentences = [
            main_argument['claim'],
            f"The key evidence shows: {supporting_evidence[0]}",
            f"This leads to the conclusion that {conclusions['primary']}",
        ]
        if main_argument.get('limitation'):
            sentences.append(f"The authors note that {main_argument['limitation']}")
        summary['brief'] = ' '.join(sentences)
    
    if 3 in levels:
        # Detailed summary with key points
        summary['detailed'] = {
            'main_argument': main_argument,
            'key_findings': supporting_evidence[:5],
            'conclusions': conclusions,
            'limitations': extract_limitations(document),
            'implications': extract_implications(document)
        }
    
    if 4 in levels:
        # Section-by-section summary
        sections = extract_sections(document)
        summary['section_by_section'] = {}
        for section in sections:
            summary['section_by_section'][section['title']] = {
                'key_point': section['main_idea'],
                'supporting': section['supporting_points'][:3]
            }
    
    return summary

def extract_key_points(document):
    """Extract the most important points from a document."""
    sentences = split_into_sentences(document)
    
    # Score sentences by importance signals
    scores = []
    for sent in sentences:
        score = 0
        # Position bonus (first/last sentences often important)
        if sentences.index(sent) < 3:
            score += 2
        if sentences.index(sent) >= len(sentences) - 2:
            score += 2
        
        # Signal words
        signal_phrases = [
            'the key finding', 'in conclusion', 'we show that',
            'the main result', 'importantly', 'significantly',
            'the authors argue', 'the evidence suggests'
        ]
        for phrase in signal_phrases:
            if phrase in sent.lower():
                score += 3
                break
        
        # Length bonus (not too short, not too long)
        word_count = len(sent.split())
        if 10 <= word_count <= 30:
            score += 1
        
        # Contains numbers or data
        import re
        if re.search(r'\d+\.?\d*', sent):
            score += 1
        
        scores.append((sent, score))
    
    # Return top sentences
    scores.sort(key=lambda x: x[1], reverse=True)
    return [s[0] for s in scores[:10]]
```

### 2. Confidence-Flagged Summarization

Explicitly mark which parts of the summary are directly stated in the source vs. inferred or interpreted.

```python
def confidence_flagged_summary(document):
    """
    Create a summary where each claim is tagged with its confidence level:
    - DIRECT: Explicitly stated in the source
    - INFERRED: Reasonably implied but not directly stated
    - INTERPRETED: Requires reader judgment or domain knowledge
    """
    key_points = extract_key_points(document)
    
    summary = []
    
    for point in key_points:
        # Determine confidence level
        confidence = classify_confidence(point, document)
        
        summary.append({
            'claim': point,
            'confidence': confidence,
            'source_location': find_source_location(point, document),
            'supporting_quote': find_supporting_quote(point, document)
        })
    
    return summary

def classify_confidence(claim, document):
    """
    Classify whether a claim is directly stated, inferred, or interpreted.
    """
    claim_lower = claim.lower()
    doc_lower = document.lower()
    
    # Check for direct quotes or near-quotes
    claim_words = claim_lower.split()
    for i in range(len(claim_words) - 3):
        phrase = ' '.join(claim_words[i:i+4])
        if phrase in doc_lower:
            return 'DIRECT'
    
    # Check for signal words indicating inference
    inference_signals = ['suggests', 'implies', 'indicates', 'appears to', 'seems']
    if any(signal in claim_lower for signal in inference_signals):
        return 'INFERRED'
    
    # Default to interpreted
    return 'INTERPRETED'
```

### 3. Action-First Summarization

For documents with decisions or action items, lead with what needs to be done, not what was discussed.

```python
def action_first_summary(meeting_notes):
    """
    Summarize meeting notes by leading with action items and decisions,
    followed by context and discussion.
    """
    # Extract action items
    action_items = extract_action_items(meeting_notes)
    
    # Extract decisions
    decisions = extract_decisions(meeting_notes)
    
    # Extract key discussion points
    discussion_points = extract_discussion_points(meeting_notes)
    
    summary = {
        'action_items': [],
        'decisions': [],
        'key_discussion': [],
        'next_meeting': None
    }
    
    # Prioritize action items by urgency
    for item in action_items:
        summary['action_items'].append({
            'action': item['description'],
            'owner': item.get('owner', 'Unassigned'),
            'deadline': item.get('deadline', 'Not set'),
            'priority': item.get('priority', 'Medium'),
            'context': item.get('context', '')
        })
    
    # Sort by priority
    priority_order = {'Critical': 0, 'High': 1, 'Medium': 2, 'Low': 3}
    summary['action_items'].sort(
        key=lambda x: priority_order.get(x['priority'], 2)
    )
    
    # Add decisions with rationale
    for decision in decisions:
        summary['decisions'].append({
            'decision': decision['content'],
            'rationale': decision.get('rationale', ''),
            'dissent': decision.get('dissent', None)
        })
    
    # Add key discussion points (what influenced the decisions)
    summary['key_discussion'] = [
        {
            'topic': point['topic'],
            'consensus': point.get('consensus', 'TBD'),
            'key_insight': point.get('insight', '')
        }
        for point in discussion_points[:5]
    ]
    
    return summary
```

### 4. Sentiment-Aware Summarization

For reviews, feedback, or opinion-heavy content, summarize while preserving sentiment distribution and key emotional themes.

```python
def sentiment_aware_summary(document):
    """
    Create a summary that preserves the sentiment distribution 
    of the source document.
    """
    from collections import Counter
    
    sentences = split_into_sentences(document)
    
    # Classify sentiment for each sentence
    sentiment_groups = {'positive': [], 'negative': [], 'neutral': []}
    
    for sent in sentences:
        sentiment = classify_sentiment(sent)
        sentiment_groups[sentiment].append(sent)
    
    # Calculate proportions
    total = len(sentences)
    sentiment_distribution = {
        k: len(v) / total if total > 0 else 0 
        for k, v in sentiment_groups.items()
    }
    
    # Create balanced summary that reflects proportions
    summary_parts = []
    
    # Lead with the dominant sentiment
    dominant = max(sentiment_distribution, key=sentiment_distribution.get)
    if sentiment_groups[dominant]:
        summary_parts.append(f"[Overall sentiment: {dominant}]")
        # Include top sentences from dominant sentiment
        for sent in sentiment_groups[dominant][:2]:
            summary_parts.append(sent)
    
    # Include notable points from other sentiments
    for sentiment in ['positive', 'negative', 'neutral']:
        if sentiment != dominant and sentiment_groups[sentiment]:
            # Include the strongest statement from each other sentiment
            strongest = max(
                sentiment_groups[sentiment],
                key=lambda s: sentiment_strength(s)
            )
            summary_parts.append(strongest)
    
    return {
        'summary': ' '.join(summary_parts),
        'sentiment_distribution': sentiment_distribution,
        'dominant_sentiment': dominant,
        'key_positive_points': sentiment_groups['positive'][:3],
        'key_negative_points': sentiment_groups['negative'][:3],
    }
```

### 5. Code and Architecture Summarization

Summarize codebases, pull requests, or technical implementations for quick comprehension.

```python
def summarize_codebase(structure, key_files):
    """
    Create a high-level summary of a codebase structure.
    """
    summary = {
        'overview': '',
        'architecture': '',
        'key_components': [],
        'entry_points': [],
        'dependencies': [],
        'patterns_used': []
    }
    
    # Analyze structure
    total_files = sum(len(files) for files in structure.values())
    languages = detect_languages(structure)
    
    summary['overview'] = (
        f"This codebase contains {total_files} files across "
        f"{len(structure)} directories. Primary languages: "
        f"{', '.join(languages[:3])}."
    )
    
    # Identify key components
    for path, files in structure.items():
        if any(kw in path.lower() for kw in ['src', 'lib', 'core']):
            summary['key_components'].append({
                'path': path,
                'purpose': infer_purpose(path, files),
                'file_count': len(files)
            })
    
    # Identify entry points
    for path, files in structure.items():
        for f in files:
            if any(name in f.lower() for name in ['main', 'index', 'app', 'server']):
                summary['entry_points'].append(f"{path}/{f}")
    
    # Analyze key files for patterns
    for file_path, content in key_files.items():
        patterns = detect_patterns(content)
        summary['patterns_used'].extend(patterns)
    
    summary['patterns_used'] = list(set(summary['patterns_used']))
    
    return summary

def detect_patterns(content):
    """Detect common code patterns in source files."""
    patterns = []
    
    if 'class ' in content and 'def __init__' in content:
        patterns.append('OOP')
    if 'async def' in content or 'await ' in content:
        patterns.append('async/await')
    if '@app.route' in content or '@router' in content:
        patterns.append('REST API')
    if 'class.*TestCase' in content or 'def test_' in content:
        patterns.append('unit testing')
    if 'try:' in content and 'except' in content:
        patterns.append('error handling')
    if 'logging' in content or 'logger' in content:
        patterns.append('structured logging')
    
    return patterns
```

### 6. Multi-Document Summarization

Synthesize information from multiple sources into a coherent, unified summary.

```python
def multi_document_summary(documents, topic=None):
    """
    Create a unified summary from multiple documents on the same topic.
    Handles conflicting information and identifies consensus vs. disagreement.
    """
    
    # Extract key points from each document
    all_points = []
    for doc in documents:
        points = extract_key_points(doc['content'])
        for point in points:
            all_points.append({
                'point': point,
                'source': doc['title'],
                'confidence': classify_confidence(point, doc['content'])
            })
    
    # Cluster similar points
    clusters = cluster_similar_points(all_points)
    
    # Build consensus summary
    summary = {
        'consensus_points': [],
        'conflicting_points': [],
        'unique_points': [],
        'coverage_analysis': {}
    }
    
    for cluster in clusters:
        if len(cluster) >= 3:
            # Consensus: mentioned by multiple sources
            summary['consensus_points'].append({
                'claim': cluster[0]['point'],
                'sources': [p['source'] for p in cluster],
                'source_count': len(cluster)
            })
        elif len(cluster) == 1:
            # Unique: mentioned by only one source
            summary['unique_points'].append(cluster[0])
    
    # Detect conflicts
    summary['conflicting_points'] = detect_conflicts(all_points)
    
    # Coverage analysis
    total_sources = len(documents)
    summary['coverage_analysis'] = {
        'total_sources': total_sources,
        'points_by_source': {
            doc['title']: len([p for p in all_points if p['source'] == doc['title']])
            for doc in documents
        }
    }
    
    return summary
```

### 7. Progressive Summarization

Create summaries that build in detail, allowing readers to expand sections they want to explore.

```python
def progressive_summary(document, depth=3):
    """
    Create a progressive summary with expandable sections.
    
    Depth 1: Executive summary (1 paragraph)
    Depth 2: Key points (bullet list)
    Depth 3: Detailed section summaries
    Depth 4: Full analysis with evidence
    """
    
    sections = extract_sections(document)
    
    result = {}
    
    # Depth 1: Executive summary
    result['executive_summary'] = create_executive_summary(document)
    
    # Depth 2: Key points
    result['key_points'] = [
        extract_key_point(section) 
        for section in sections
    ]
    
    # Depth 3: Section details (if requested)
    if depth >= 3:
        result['section_details'] = {}
        for section in sections:
            result['section_details'][section['title']] = {
                'summary': summarize_section(section),
                'key_evidence': extract_evidence(section)[:3],
                'supporting_points': extract_supporting_points(section)[:5]
            }
    
    # Depth 4: Full analysis (if requested)
    if depth >= 4:
        result['full_analysis'] = {
            'methodology': assess_methodology(document),
            'strengths': identify_strengths(document),
            'weaknesses': identify_weaknesses(document),
            'implications': extract_implications(document),
            'further_reading': suggest_related_work(document)
        }
    
    return result
```

---

## Common Patterns

### Pattern 1: Research Paper Summary

```python
def summarize_research_paper(paper):
    """
    Create a structured summary of a research paper.
    Follows the standard academic structure.
    """
    
    summary = {
        'citation': format_citation(paper),
        'one_line': '',
        'problem': '',
        'approach': '',
        'key_findings': [],
        'limitations': [],
        'significance': '',
        'relevance_to_practice': ''
    }
    
    # Extract from structured sections
    if 'abstract' in paper:
        summary['one_line'] = extract_main_claim(paper['abstract'])
    
    if 'introduction' in paper:
        summary['problem'] = extract_problem_statement(paper['introduction'])
    
    if 'methods' in paper:
        summary['approach'] = extract_methodology(paper['methods'])
    
    if 'results' in paper:
        summary['key_findings'] = extract_findings(paper['results'])
    
    if 'discussion' in paper:
        summary['limitations'] = extract_limitations(paper['discussion'])
        summary['significance'] = extract_significance(paper['discussion'])
    
    # Generate formatted summary
    formatted = f"""## {summary['citation']}

**One-line summary:** {summary['one_line']}

**Problem:** {summary['problem']}

**Approach:** {summary['approach']}

**Key Findings:**
{chr(10).join(f'- {f}' for f in summary['key_findings'][:5])}

**Limitations:**
{chr(10).join(f'- {l}' for l in summary['limitations'][:3])}

**Significance:** {summary['significance']}
"""
    
    return formatted
```

### Pattern 2: Meeting Notes Summary

```python
def summarize_meeting(transcript, attendees=None):
    """
    Create structured meeting notes from a transcript or notes.
    """
    
    # Extract components
    discussions = extract_discussions(transcript)
    decisions = extract_decisions(transcript)
    action_items = extract_action_items(transcript)
    
    summary = {
        'meeting_info': {
            'attendees': attendees or extract_attendees(transcript),
            'duration': extract_duration(transcript),
            'date': extract_date(transcript)
        },
        'agenda_items': [],
        'decisions': [],
        'action_items': [],
        'parking_lot': [],  # Topics deferred
        'next_meeting': extract_next_meeting(transcript)
    }
    
    # Process discussions
    for discussion in discussions:
        item = {
            'topic': discussion['topic'],
            'discussion_summary': discussion['summary'],
            'outcome': discussion.get('outcome', 'No resolution'),
            'time_spent': discussion.get('duration', 'Unknown')
        }
        summary['agenda_items'].append(item)
    
    # Format action items
    for action in action_items:
        summary['action_items'].append({
            'action': action['description'],
            'owner': action.get('owner', 'TBD'),
            'deadline': action.get('deadline', 'TBD'),
            'status': 'New'
        })
    
    return summary

def format_meeting_summary(summary):
    """Format meeting summary as markdown."""
    
    output = f"""# Meeting Summary

**Date:** {summary['meeting_info']['date']}
**Duration:** {summary['meeting_info']['duration']}
**Attendees:** {', '.join(summary['meeting_info']['attendees'])}

## Agenda

{chr(10).join(f"### {item['topic']}" + chr(10) + item['discussion_summary'] + chr(10) + f"**Outcome:** {item['outcome']}" for item in summary['agenda_items'])}

## Decisions

{chr(10).join(f"- **{d['decision']}**" for d in summary['decisions'])}

## Action Items

| Action | Owner | Deadline | Status |
|--------|-------|----------|--------|
{chr(10).join(f"| {a['action']} | {a['owner']} | {a['deadline']} | {a['status']} |" for a in summary['action_items'])}

## Next Meeting
{summary['next_meeting'] or 'TBD'}
"""
    
    return output
```

### Pattern 3: Article/News Summary

```python
def summarize_article(article, style='inverted_pyramid'):
    """
    Summarize a news article or blog post.
    
    Styles:
    - inverted_pyramid: Most important info first (news style)
    - chronological: Events in order
    - thematic: Organized by theme
    """
    
    # Extract key elements
    who = extract_entities(article, ['person', 'organization'])
    what = extract_main_event(article)
    when = extract_date(article)
    where = extract_location(article)
    why = extract_reason(article)
    impact = extract_impact(article)
    
    if style == 'inverted_pyramid':
        summary = f"""**What happened:** {what}

**Who's involved:** {', '.join(who[:3])}

**When:** {when}

**Why it matters:** {impact}

**Key details:** {why}"""
    
    elif style == 'chronological':
        events = extract_events(article)
        summary = f"""**Timeline of events:**

{chr(10).join(f"- **{e['time']}:** {e['description']}" for e in events)}

**Current status:** {extract_current_status(article)}"""
    
    return summary
```

### Pattern 4: Technical Document Summary

```python
def summarize_technical_doc(document, audience='developer'):
    """
    Summarize technical documentation for a specific audience.
    """
    
    # Extract technical content
    api_endpoints = extract_api_endpoints(document)
    key_concepts = extract_concepts(document)
    code_examples = extract_code_examples(document)
    common_tasks = extract_common_tasks(document)
    
    if audience == 'developer':
        summary = f"""## Quick Start

**What it does:** {extract_one_liner(document)}

**Key concepts:**
{chr(10).join(f"- **{c['name']}:** {c['description']}" for c in key_concepts[:5])}

**Common tasks:**
{chr(10).join(f"- {t}" for t in common_tasks[:5])}

**Main API endpoints:**
{chr(10).join(f"- `{e['method']} {e['path']}` — {e['description']}" for e in api_endpoints[:5])}

**Getting started:**
```bash
{extract_quickstart_command(document)}
```
"""
    
    elif audience == 'manager':
        summary = f"""## Overview

**Purpose:** {extract_business_purpose(document)}

**Key capabilities:**
{chr(10).join(f"- {c}" for c in extract_capabilities(document)[:5])}

**Integration requirements:**
{chr(10).join(f"- {r}" for r in extract_requirements(document)[:3])}

**Estimated implementation time:** {extract_effort_estimate(document)}
"""
    
    return summary
```

### Pattern 5: Book/Chapter Summary

```python
def summarize_book_chapter(chapter, chapter_number=None):
    """
    Create a structured summary of a book chapter.
    """
    
    # Extract chapter elements
    thesis = extract_chapter_thesis(chapter)
    key_arguments = extract_arguments(chapter)
    examples = extract_examples(chapter)
    conclusions = extract_chapter_conclusions(chapter)
    
    summary = f"""## Chapter {chapter_number or '?'} Summary

### Core Thesis
{thesis}

### Key Arguments
{chr(10).join(f"{i+1}. **{arg['claim']}** — {arg['evidence']}" for i, arg in enumerate(key_arguments[:5]))}

### Illustrative Examples
{chr(10).join(f"- {ex}" for ex in examples[:3])}

### Chapter Conclusions
{chr(10).join(f"- {c}" for c in conclusions[:3])}

### Key Takeaways
{chr(10).join(f"- {t}" for t in extract_takeaways(chapter)[:5])}

### Connections
- **Builds on:** {extract_prerequisites(chapter)}
- **Leads to:** {extract_follow_up_topics(chapter)}
"""
    
    return summary
```

---

## Edge Cases & Pitfalls

### 1. Losing Nuance in Compression
**Problem:** Aggressive summarization removes important caveats, qualifications, and context, making the summary misleading.
**Solution:** Always preserve: limitations, conditional statements ("under certain conditions"), and minority viewpoints. Use phrases like "the authors note that..." or "while some evidence suggests..."

### 2. Bias Amplification Through Selection
**Problem:** Selectively summarizing only certain points creates a biased representation of the source. This is especially dangerous for controversial topics.
**Solution:** Track which perspectives are represented. Include opposing viewpoints. Note when the source itself is one-sided.

### 3. Summarizing Without Understanding
**Problem:** Extractive summarization picks statistically important sentences that may lack context or be misleading when read in isolation.
**Solution:** Read and understand the full document before summarizing. Use context-dependent extraction, not just keyword frequency.

### 4. Misrepresenting Confidence Levels
**Problem:** Presenting tentative findings or hypotheses as established facts in the summary.
**Solution:** Use qualifying language: "suggests," "indicates," "preliminary evidence shows." Mirror the source's confidence level.

### 5. Losing the Narrative Arc
**Problem:** Summarizing a story or argument by picking random points destroys the logical flow and progression.
**Solution:** Preserve the source's narrative structure. Summarize the argument chain: premise → evidence → conclusion.

### 6. Ignoring the Audience
**Problem:** Creating a one-size-fits-all summary that's too detailed for executives and too shallow for practitioners.
**Solution:** Create audience-specific summaries. An executive summary, a technical summary, and a detailed summary serve different readers.

### 7. Over-summarizing (Summary Longer Than Useful)
**Problem:** The summary is 80% the length of the original, defeating its purpose.
**Solution:** Set clear length targets before summarizing. A good summary is typically 10-30% of the original length, depending on content density.

### 8. Failing to Cite Sources in Multi-Source Summaries
**Problem:** When combining multiple sources, losing track of which claim came from which source.
**Solution:** Maintain source attribution throughout. Use inline citations or footnotes. Create a source index.

### 9. Copy-Pasting the Abstract
**Problem:** Using the paper's abstract as the summary is lazy and often inadequate — abstracts are written for experts, not general readers.
**Solution:** Write the summary in your own words, tailored to your audience. The abstract is input, not output.

### 10. Summarizing Code by Line Count
**Problem:** Describing code changes by "X lines added, Y lines removed" without explaining what actually changed.
**Solution:** Summarize code by: what functionality changed, why it changed, what the impact is, and what testing is needed.

### 11. Missing the Forest for the Trees
**Problem:** Summarizing every section equally without identifying the most important points.
**Solution:** Not all content is equally important. Identify and emphasize the 20% of content that carries 80% of the meaning.

### 12. Ignoring Contradictions in Source
**Problem:** The source contains contradictory statements, and the summary presents only one side.
**Solution:** Note contradictions explicitly: "The report both states X and Y, which appear to conflict."

### 13. Not Adapting to Format
**Problem:** Using the same summary format for a research paper, a meeting, and a news article.
**Solution:** Match the summary format to the content type. Research papers need methodology. Meetings need action items. News needs the 5 Ws.

### 14. Summarizing Before Reading
**Problem:** Attempting to summarize before fully reading and understanding the source, leading to superficial or incorrect summaries.
**Solution:** Always read the full document first. Identify the structure and key themes before attempting to extract or generate the summary.

### 15. Losing Quantitative Data
**Problem:** The summary omits key numbers, statistics, or data points that are essential for understanding the findings.
**Solution:** Always include: sample sizes, key statistics, effect sizes, dates, and any numbers that the reader needs for decision-making.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **RAG Implementation** | Core Application | Summarization is essential for RAG — summarize retrieved chunks to fit context windows |
| **Data Analysis** | Output Format | Summarize statistical findings and analysis results for stakeholders |
| **Technical Writing** | Companion | Technical documentation often includes summaries of longer content |
| **Data Cleaning** | Prerequisite | Clean data produces better summaries; remove noise before summarizing |
| **Code Understanding** | Enhancement | Code summarization requires understanding code structure and patterns |
| **Knowledge Management** | Core Component | Summaries are the navigable layer of a knowledge base |
| **Natural Language Processing** | Foundation | Text processing, tokenization, and NLP techniques underpin summarization |
| **Monitoring & Observability** | Application | Log summarization and incident summarization are key monitoring outputs |

---

## Output Format Templates

### Standard Summary

```markdown
## Summary: {Document Title}

### TL;DR
{One sentence capturing the most important point}

### Key Points
- {Point 1}
- {Point 2}
- {Point 3}

### Important Details
{Supporting information for key points}

### Conclusions
{Main conclusions or recommendations}

### Source
{Document title, author, date, length}
```

### Executive Brief

```markdown
# Executive Brief: {Topic}

## Bottom Line
{1-2 sentences: What should the reader know/do?}

## Key Findings
1. **{Finding 1}:** {significance}
2. **{Finding 2}:** {significance}
3. **{Finding 3}:** {significance}

## Recommendations
1. {Action 1} — {expected outcome}
2. {Action 2} — {expected outcome}

## Risk Assessment
- **High priority:** {risk}
- **Medium priority:** {risk}

## Supporting Data
| Metric | Value | Context |
|--------|-------|---------|
| {metric} | {value} | {significance} |
```

### Detailed Summary

```markdown
# Detailed Summary: {Document Title}

## Overview
{2-3 sentences covering the document's scope, purpose, and main contribution}

## Structure
{Brief description of how the document is organized}

## Section Summaries

### {Section 1 Title}
**Main point:** {one sentence}
**Key evidence:** {supporting details}
**Significance:** {why this matters}

### {Section 2 Title}
**Main point:** {one sentence}
**Key evidence:** {supporting details}
**Significance:** {why this matters}

## Key Data Points
- {Data point 1 with context}
- {Data point 2 with context}
- {Data point 3 with context}

## Strengths and Limitations
**Strengths:** {what the source does well}
**Limitations:** {what the source lacks or gets wrong}

## Relevance
{How this content relates to the reader's work or interests}
```

### Quick Summary (5-Line Digest)

```markdown
⚡ Quick Summary: {Document Title}

1. **TL;DR:** {single sentence capturing the entire document}
2. **Key finding:** {the one result or argument that matters most}
3. **Evidence:** {strongest supporting data point, cited}
4. **Caveat:** {biggest limitation or unverified claim}
5. **Action:** {what the reader should do next, if anything}

Confidence: {high/medium/low} | Source: {title, §section} | Date: {pub date}
```

Use when the consumer has under 30 seconds: standups, triage queues, chat pings. Never exceed 5 lines — if more is needed, escalate to Standard.

### Agent-Friendly Structured Output

```json
{
  "summary": {
    "source_type": "{article|paper|meeting|report|book}",
    "title": "{title}",
    "author": "{author}",
    "date": "{date}",
    "original_length": "{word_count} words",
    "summary_length": "{word_count} words",
    "compression_ratio": 0.15,
    "tldr": "{one sentence}",
    "key_points": [
      "{point 1}",
      "{point 2}",
      "{point 3}"
    ],
    "entities": {
      "people": ["{name}"],
      "organizations": ["{org}"],
      "dates": ["{date}"],
      "locations": ["{location}"]
    },
    "statistics": [
      {"metric": "{name}", "value": "{value}", "context": "{significance}"}
    ],
    "conclusions": ["{conclusion 1}"],
    "confidence_notes": [
      {"claim": "{claim}", "confidence": "{direct|inferred|interpreted}"}
    ],
    "sentiment": "{positive|negative|neutral|mixed}",
    "reading_time_original": "{minutes} min",
    "reading_time_summary": "{minutes} min"
  }
}
```

---

## Rules

1. **Read the entire source before summarizing** — Never attempt to summarize from skimming. Understand the full content, then distill it. Partial understanding produces partial (and misleading) summaries.
2. **Lead with the most important information** — For most content, put the conclusion or main finding first. Readers should be able to stop after the first sentence and still understand the key message.
3. **Preserve the source's confidence level** — If the source hedges ("suggests," "may," "preliminary"), your summary should hedge too. Don't convert tentative findings into definitive statements.
4. **Include quantitative data** — Key numbers, statistics, dates, and measurements should survive summarization. They're often the most decision-relevant information.
5. **Maintain source attribution** — When summarizing multiple sources, always track which claim came from which source. Lose this and you lose credibility.
6. **Match the summary to the audience** — An executive summary, a technical summary, and a general summary serve different readers. Know who will read it.
7. **Keep summaries proportional** — A 10,000-word document shouldn't have a 5,000-word summary. Typical compression ratios: 10-20% for dense technical content, 5-10% for narrative content.
8. **Don't add information** — A summary should only contain information from the source. Never introduce external knowledge, opinions, or interpretations without flagging them.
9. **Preserve structure when helpful** — For structured content (reports, papers), mirror the structure in the summary. For narrative content, follow the logical flow.
10. **Flag contradictions** — If the source contains contradictory statements, note them in the summary. Don't smooth over disagreements.
11. **Test comprehension** — After writing a summary, ask: Could someone make a decision based on this summary alone? If not, it's missing critical information.
12. **Use the source's terminology** — For technical summaries, use the same terms as the source. Don't substitute synonyms that might change the meaning.
13. **Summarize action items separately** — For meeting notes and reports, extract action items into their own section with owners and deadlines. Don't bury them in narrative.
14. **Version your summaries** — When summarizing evolving documents, include the version or date. A summary of version 1.0 is misleading if the document is now at version 3.0.
15. **Review against the source** — After writing, verify: Are all key points represented? Is nothing misrepresented? Are the proportions of emphasis correct? One inaccurate summary can do more harm than no summary.
