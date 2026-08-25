---
name: explain-code
description: >-
  Analyze and explain code in detail — what it does, how it works, why design decisions were made, and how components interact. Use this skill when the user asks to explain this code, توضیح کد, what does this code do, analyze this code, how does this work, walk me through this, understand this code, break down this function, what is this codebase doing, explain this algorithm, how does this architecture work, توضیح بده این کد چیکار میکنه, تحلیل کد, این کد چطور کار میکنه, توضیح الگوریتم, explain this snippet, read this code for me, help me understand, what's going on here, can you walk through this, break down this module, explain this class, how does this function work, what does this file do, what's the flow here, explain the data flow, how do these components interact, decode this regex, what does this one-liner do, explain this config, what's this pattern called, why is this written this way, is this a known pattern, explain this test, what is this testing, how does dependency injection work here, explain this middleware, what does this hook do, how does this state management work, explain this database query, what's the query plan, explain this migration, how does this cache work, explain this algorithm's complexity, what's the time complexity, 为什么这么写, 解释这段代码, 这段代码做什么, 帮我看看这个, 代码分析, 算法解释.
---

# Explain Code Skill

## Overview

This skill breaks down code into understandable pieces. It explains not just *what* code does, but *how* it works and *why* it's structured that way. Explanations are layered — a quick summary first, then progressive detail for those who need depth.

Code explanation is a teaching skill, not a judgment skill. The goal is to build the user's mental model of the code, regardless of whether the code is well-written or not. Bugs and code smells are noted as asides, never as the main focus.

## When to Use This Skill

- User asks what a piece of code does
- User wants to understand an unfamiliar codebase or module
- User needs a walkthrough of an algorithm or complex function
- User is learning and wants line-by-line or concept-level explanation
- User asks "how does this work?" or "why is it written this way?"
- User wants to understand the flow between multiple files or components
- User asks about a specific design pattern they spotted in code
- User needs to understand a complex one-liner, regex, or terse expression
- User wants to understand configuration files, schemas, or DSLs
- User asks about algorithm complexity (time/space) of a piece of code
- User is onboarding to a new codebase and needs orientation
- User wants to understand test code and what behaviors it verifies
- User asks about framework-specific patterns (hooks, middleware, decorators, etc.)

## Explanation Workflow

### Step 1: Read the Code

1. Read the file(s) the user wants explained using the Read tool.
2. If the code references other files (imports, dependencies), read those too to understand the full picture.
3. Identify the language, framework, and domain.
4. If the user provides a code snippet directly (not a file), work with what's given but note if context is missing.
5. Check for related configuration, type definitions, or interface files that clarify intent.

### Step 2: Build a Mental Model

Before explaining, construct your understanding:

- **Purpose**: What problem does this code solve?
- **Inputs/Outputs**: What goes in, what comes out?
- **Data flow**: How does data transform from input to output?
- **Key abstractions**: What are the main components and how do they relate?
- **Patterns used**: Are there recognizable design patterns?
- **Dependencies**: What external systems or libraries does it rely on?
- **Invariants**: What conditions does this code assume to be true?
- **State**: Does this code manage state? What state, and how does it transition?
- **Concurrency**: Is this code safe for concurrent use? Does it use locks, channels, or async?

### Step 3: Deliver Layered Explanation

Structure the explanation in three layers so the user can stop reading at the level that satisfies them:

#### Layer 1: One-Sentence Summary
A single sentence explaining what the code does, in plain language.

#### Layer 2: High-Level Walkthrough
A paragraph or bullet list describing the main flow, key components, and their roles. No code snippets at this level — just concepts.

#### Layer 3: Detailed Breakdown
For each significant function or section:
- What it does and why
- How it works step by step
- Important edge cases or subtle behavior
- Any non-obvious design decisions
- Time and space complexity where relevant

Use inline code references (file:function or line numbers) to anchor the explanation.

### Step 4: Address Follow-Up Questions

If the user asks follow-up questions, dive deeper into the specific area. Common follow-ups:
- "Why was X implemented this way instead of Y?"
- "What happens if Z is null/empty/wrong?"
- "Can you explain this specific function in more detail?"
- "What's the time complexity of this approach?"
- "How would this behave under concurrent access?"

## Advanced Techniques

### Execution Tracing
For complex algorithms, walk through a concrete example with actual values:
```
Example: processItems([3, 1, 4, 1, 5])
  Step 1: Initialize seen={} → seen={}
  Step 2: Process 3 → seen={3} → keep 3
  Step 3: Process 1 → seen={3,1} → keep 1
  Step 4: Process 4 → seen={3,1,4} → keep 4
  Step 5: Process 1 → already in seen → skip
  Result: [3, 1, 4, 5]
```

### Pattern Recognition
Identify and name well-known patterns when present:
- **Creational**: Factory, Singleton, Builder, Prototype, Abstract Factory
- **Structural**: Adapter, Decorator, Facade, Proxy, Composite, Bridge
- **Behavioral**: Strategy, Observer, Command, Iterator, State, Template Method, Chain of Responsibility
- **Concurrency**: Producer-Consumer, Read-Write Lock, Thread Pool, Actor Model, CSP
- **Functional**: Map-Reduce, Pipeline, Monad, Currying, Memoization, Lazy Evaluation

### Dependency Graph Analysis
For multi-file code, trace the dependency graph:
- Which modules depend on which?
- Are there circular dependencies?
- What is the entry point and what is the leaf code?
- Draw a simple text-based dependency diagram if helpful.

### Complexity Analysis
When explaining algorithms, provide:
- **Time complexity**: Big-O notation for best, average, and worst case
- **Space complexity**: Memory usage in Big-O notation
- **Comparison**: Briefly note if a better algorithm exists for this problem

### Comparative Explanation
If the user asks "why not X?", compare approaches:
```
Why use a hash map here instead of a list?
- List lookup: O(n) — must scan every element
- HashMap lookup: O(1) average — direct access by key
- Trade-off: HashMap uses more memory (O(n) space overhead)
- Decision: Correct here because lookups are frequent and n can be large
```

## Common Patterns

### Pattern 1: The Middleware/Pipeline Chain
Code that passes data through a series of transformations, each adding or modifying something.
```
# Each function takes data, transforms it, passes to next
# Common in Express (middleware), Redux (middleware), ETL pipelines
# Explain: what each stage does, order matters, early exit conditions
```

### Pattern 2: The Strategy Selector
Code that selects an algorithm or implementation at runtime based on input type or configuration.
```
# A map/dict of strategies keyed by type/condition
# The caller doesn't know which strategy will be used
# Explain: what triggers each strategy, fallback behavior, extensibility
```

### Pattern 3: The State Machine
Code that transitions between discrete states based on events or conditions.
```
# An enum/object of states, a transition table or switch
# Validate: are all states reachable? Is there a terminal state?
# Explain: valid transitions, invalid transitions, default/fallback behavior
```

### Pattern 4: The Repository Pattern
Code that abstracts data access behind an interface, hiding the storage mechanism.
```
# An interface with CRUD methods, implemented by different backends
# Explain: what the interface guarantees, what the concrete implementation does
```

### Pattern 5: The Observer/Pub-Sub
Code where components subscribe to events and react when those events are emitted.
```
# Event emitter, subscription list, callback dispatch
# Explain: what events exist, who subscribes, order of notification, error handling
```

## Edge Cases & Pitfalls

1. **Explaining without reading** — Never explain code from memory or assumptions. Always read the actual file first.
2. **Wrong audience level** — A senior developer asking about a system design doesn't need "variables are like boxes" analogies. Match the depth to the question.
3. **Explaining everything equally** — Not every line deserves the same detail. Focus on the non-obvious parts and summarize boilerplate.
4. **Missing the forest for the trees** — Sometimes the user needs the 10,000-foot architecture view, not line-by-line. Offer both and let them choose.
5. **Assuming framework knowledge** — If the code uses framework-specific features (React hooks, Django ORM, Spring annotations), briefly explain those conventions.
6. **Ignoring side effects** — Code that looks pure but calls external APIs, modifies global state, or writes to disk has hidden complexity. Surface these.
7. **Not checking for bugs** — If you spot a bug while explaining, mention it briefly as an aside ("Note: there's a potential null pointer on line 42"), but don't turn the explanation into a code review.
8. **Over-abstracting the explanation** — Don't introduce design pattern names if the code is just straightforward procedural logic. Call a spade a spade.
9. **Ignoring the "why"** — Explaining *what* code does is easy. Explaining *why* it's structured that way is what makes a great explanation. Look for clues in git history, comments, and surrounding context.
10. **Not adapting to code size** — A 10-line snippet gets a different explanation style than a 1000-file codebase. Adjust granularity.
11. **Skipping the data model** — For data-processing code, explaining the data shape (types, fields, relationships) is often more valuable than explaining the code that processes it.
12. **Assuming synchronous execution** — Always check if the code is async. Missing an `await` in the explanation creates a misleading mental model.

## Integration with Other Skills

- **debug**: If during explanation you discover a bug, offer to switch to the debug skill for a formal diagnosis and fix.
- **code-review**: If the code has many quality issues, suggest a code review for actionable improvement recommendations.
- **refactor**: If the code works but is hard to understand due to poor structure, suggest refactoring for clarity.
- **test-generation**: If explaining test code, verify that the tests adequately cover the described behavior.
- **documentation**: If the user wants to turn the explanation into permanent documentation, use the documentation skill.
- **clean-architecture**: If explaining a module's role in a larger system, clean-architecture can provide the architectural context.
- **api-design**: If explaining API endpoint code, api-design can clarify the REST/GraphQL contract.

## Output Format

### Full Code Explanation Template

```
## Code Explanation

**File:** [file path]
**Language/Framework:** [detected stack]
**Lines:** [range or "full file"]

### Summary
[One-sentence explanation]

### How It Works
[High-level walkthrough with bullet points]

### Data Flow
[Input → Transform → Output, with intermediate states]

### Detailed Breakdown
#### [Section/Function 1]
[Explanation with line references]

#### [Section/Function 2]
[Explanation with line references]

### Key Design Decisions
- [Decision 1]: [Why it was made]
- [Decision 2]: [Why it was made]

### Complexity
- Time: [Big-O]
- Space: [Big-O]

### Potential Questions
- [Anticipate and answer likely follow-up questions]
```

### Quick Explanation Template (for snippets)

```
**What it does:** [one sentence]
**How:** [2-3 sentences]
**Key detail:** [the non-obvious part]
```

### Architecture Overview Template

```
## Architecture Overview: [Project/Module Name]

**Pattern:** [MVC, Clean Architecture, Microservices, etc.]

### Component Map
[Text diagram showing components and their relationships]

### Request/Data Flow
[Step-by-step flow from entry point to output]

### Key Modules
| Module | Responsibility | Depends On |
|--------|---------------|------------|
| [name] | [what it does] | [other modules] |

### Design Decisions
- [Decision]: [Rationale]
```

### Algorithm Explanation Template

```
## Algorithm: [Name or Description]

### Problem
[What problem does this algorithm solve?]

### Approach
[High-level strategy]

### Step-by-Step
1. [Step 1 with explanation]
2. [Step 2 with explanation]
...

### Complexity
- Time: O(?) — [explanation]
- Space: O(?) — [explanation]

### Example Trace
[Walk through with concrete input values]

### Edge Cases
- [Empty input]: [behavior]
- [Single element]: [behavior]
- [Already sorted/deduplicated]: [behavior]
```

## Rules

- Always read the actual code before explaining. Never explain from assumptions.
- Start simple. Not everyone asking for an explanation is a beginner, but everyone benefits from a clear starting point.
- Use the user's language for all explanation text. Keep code references and technical terms in English.
- If the code is poorly written or contains bugs, note them as an aside but don't turn the explanation into a code review.
- If a section of code is standard boilerplate (e.g., import statements, basic config), summarize it briefly rather than explaining each line.
- Admit when you're unsure. If a line's purpose is genuinely ambiguous given the available context, say so.
- When explaining test code, focus on *what behavior is being verified* and *why that behavior matters*, not just what the test does mechanically.
- When explaining configuration (YAML, JSON, TOML, .env), explain what each setting controls and what happens with different values.
- For framework-specific code, briefly explain the framework convention if it's not universally known.
