---
name: prompt-engineering
description: >-
  Write, design, optimize, and critique system prompts, user prompts, and prompt templates for any LLM.
  Use this skill when the user mentions writing a prompt, نوشتن پرامپت, optimize my prompt,
  بهینه‌سازی پرامپت, system prompt design, prompt engineering, crafting prompts, improve my prompt,
  make this prompt better, create a system message, design an AI persona, write instructions for AI,
  prompt template, prompt optimization, prompt testing, prompt evaluation, prompt refinement,
  prompt strategy, few-shot examples design, ReAct prompting, chain-of-thought prompting,
  Self-Ask, Least-to-Most, Directional Stimulus, prompt pattern, prompt framework,
  or asks how to get better results from an LLM or AI model.
---

# Prompt Engineering Skill — Advanced Prompt Design & Optimization

## Overview

This skill provides a systematic, expert-level approach to writing, optimizing, and evaluating prompts for large language models. Good prompt engineering is not guessing — it follows identifiable principles, proven patterns, and iterative testing. This skill covers everything from basic prompt construction to advanced techniques like ReAct, Self-Ask, Least-to-Most, and Directional Stimulus prompting. Whether you're designing a system prompt for an AI agent, crafting few-shot examples, or optimizing for production reliability, this skill gives you the complete toolkit.

## When to Use This Skill

- User wants to write a new system prompt or user prompt
- User wants to improve an existing prompt
- User asks how to get better results from an AI model
- User needs a prompt template for a recurring task
- User wants to design an AI persona or agent instructions
- User needs few-shot examples designed for a task
- User mentions prompt patterns, CoT, ReAct, or advanced prompting
- User shares a prompt and asks for feedback or improvement
- User mentions نوشتن پرامپت, بهینه‌سازی پرامپت, or طراحی پرامپت

---

## Phase 1: Understand the Goal

Before writing a single word, clarify what the prompt needs to achieve:

1. **Identify the task** — What exactly should the model do? Classify, generate, extract, summarize, translate, reason, code, plan, decide?
2. **Identify the audience** — Who reads the output? Technical users, end users, another system, another LLM?
3. **Identify constraints** — Length limits, format requirements, tone, forbidden content, language, cost budget?
4. **Identify failure modes** — What would a bad output look like? What mistakes is the model likely to make?
5. **Identify the model** — Which model is this for? GPT-4, Claude, Gemini, Llama, Mistral? Each has different strengths.
6. **Identify the context window** — How much input/output can the model handle?

---

## Phase 2: Prompt Architecture Layers

Structure the prompt using these layers (not all are needed every time):

| Layer | Purpose | Example |
|-------|---------|--------|
| **Role/Persona** | Set the model's identity and expertise | "You are a senior backend engineer specializing in distributed systems." |
| **Context** | Provide background the model needs | "The user is migrating a monolithic Rails app to microservices." |
| **Task** | State what needs to be done | "Review this pull request and identify potential race conditions." |
| **Constraints** | Define what NOT to do | "Do not suggest rewriting the entire module. Focus on incremental fixes." |
| **Output Format** | Specify the exact structure | "Return a JSON object with fields: severity, location, description, fix." |
| **Examples** | Show desired input/output pairs | 2-3 few-shot examples demonstrating the expected behavior |
| **Chain of Thought** | Guide step-by-step reasoning | "Think through this step by step before giving your final answer." |
| **Verification** | Ask model to check its work | "Before responding, verify your answer addresses all parts of the question." |

### Prompt Layer Priority by Task Type

| Task Type | Essential Layers | Optional Layers |
|-----------|-----------------|-----------------|
| Simple Q&A | Context, Task | Role, Output Format |
| Code Generation | Role, Task, Constraints, Output Format | Examples, Verification |
| Analysis/Reasoning | Role, Task, Chain of Thought | Examples, Verification |
| Classification | Task, Output Format, Examples | Role, Constraints |
| Creative Writing | Role, Context, Task | Constraints, Examples |
| Data Extraction | Task, Output Format, Examples | Role, Constraints |
| Agent System Prompt | Role, Task, Constraints, Output Format | Examples, CoT |

---

## Phase 3: Advanced Prompting Techniques

### Technique 1: Zero-Shot Prompting

Simply describe the task without examples. Works well for simple tasks.

```
Classify the following text as positive, negative, or neutral:
"The product works great but the shipping was slow."
```

**When to use:** Simple classification, summarization, or extraction where the task is well-defined.

### Technique 2: Few-Shot Prompting

Provide examples that demonstrate the desired behavior.

```
Classify customer feedback as urgent or non-urgent.

Feedback: "The app crashes every time I open it" → Urgent
Feedback: "Would be nice to have dark mode" → Non-urgent
Feedback: "I can't log in and I have a presentation in 1 hour" → Urgent
Feedback: "The font is a bit small on mobile" → Non-urgent

Now classify:
Feedback: "All my data disappeared after the update" →
```

**Example Selection Strategy:**
- Include 2-5 examples (more for complex tasks)
- Cover edge cases and boundary conditions
- Show diversity (don't pick similar examples)
- Place the most representative example first
- Match the complexity of examples to the actual task
- Use the same format in examples as you want in the output

### Technique 3: Chain-of-Thought (CoT) Prompting

Force the model to show its reasoning before answering.

**Zero-shot CoT** — Just add "Think step by step":
```
A store has 23 apples. They sell 5 per day for 3 days.
How many apples remain? Think step by step.
```

**Few-shot CoT** — Include examples of reasoning:
```
Q: A store has 23 apples. They sell 5 per day for 3 days. How many remain?
A: Starting with 23 apples.
   Day 1: sell 5 → 23 - 5 = 18 remaining.
   Day 2: sell 5 → 18 - 5 = 13 remaining.
   Day 3: sell 5 → 13 - 5 = 8 remaining.
   Answer: 8 apples.

Q: A factory produces 100 widgets per hour. It runs for 8 hours,
   but stops for a 30-minute break. How many widgets are produced?
A:
```

**When to use:** Math, logic, multi-step reasoning, planning, analysis.

### Technique 4: ReAct (Reasoning + Acting)

Combine reasoning with tool use in a structured loop.

```
You have access to these tools:
- search(query): Search the web
- calculator(expression): Evaluate math
- code_runner(code): Execute Python

Use this format:
Thought: [What you need to find out]
Action: [tool_name(input)]
Observation: [Tool result]
... (repeat as needed)
Thought: I now have enough information to answer.
Final Answer: [Your answer]

Question: What is the population of Paris divided by the population of Tokyo?
```

**ReAct Flow:**
1. **Thought** → What do I need to know?
2. **Action** → Call a tool to get that information
3. **Observation** → Process the tool's response
4. **Repeat** until enough information is gathered
5. **Final Answer** → Synthesize everything

**When to use:** Tasks requiring external information, multi-step research, tasks where the model needs to gather facts before reasoning.

### Technique 5: Self-Ask

The model asks itself clarifying questions to break down complex problems.

```
Answer the following question, and if it can be broken down into sub-questions,
answer the sub-questions first.

Question: What is the tallest building in the country with the most islands?

Is the answer directly ascertainable? No.
Sub-question 1: What is the country with the most islands?
Answer 1: Sweden, with approximately 267,570 islands.
Sub-question 2: What is the tallest building in Sweden?
Answer 2: Turning Torso in Malmö at 190 meters.

Final answer: Turning Torso in Malmö, Sweden.
```

**When to use:** Complex multi-hop reasoning, research tasks, questions requiring chained lookups.

### Technique 6: Least-to-Most Prompting

Break a problem into sub-problems, solve the simplest first, then build up.

```
Solve this step by step, starting with the simplest sub-problem.

"A farmer has 3 fields. Field A produces 2x the wheat of Field B.
Field C produces 50% more than Field B. If Field A produces 400 bushels,
how much do all fields produce together?"

Step 1 (simplest): What does Field A produce? 400 bushels (given)
Step 2: What does Field B produce? Since A = 2B, B = 400/2 = 200
Step 3: What does Field C produce? Since C = 1.5B, C = 300
Step 4 (combine): Total = 400 + 200 + 300 = 900 bushels
```

**When to use:** Problems with hierarchical dependencies, educational explanations, complex calculations.

### Technique 7: Directional Stimulus Prompting

Provide a hint or keyword to guide the model's output.

```
Complete the following with a focus on [SCALABILITY] and [SECURITY]:

Design a login system for a social media platform with 100M users.

Hint: Consider horizontal scaling, distributed sessions, rate limiting,
and OAuth 2.0 flows.
```

**When to use:** When the task is too broad and you need to steer toward specific aspects.

### Technique 8: Tree of Thought (ToT)

Explore multiple reasoning paths and evaluate each.

```
Consider 3 different approaches to solve this problem.
For each approach:
1. Describe the approach in 2-3 sentences
2. Identify the main risk or limitation
3. Rate it 1-5 for feasibility, performance, and maintainability

Then select the best approach and explain why.

Problem: Design a real-time notification system for 10M users.
```

**When to use:** Design decisions, strategic planning, open-ended problems with multiple valid solutions.

### Technique Comparison Table

| Technique | When to Use | Token Cost | Accuracy |
|-----------|------------|------------|----------|
| Zero-shot | Simple, well-defined tasks | Low | Medium |
| Few-shot | Classification, formatting | Medium | High |
| CoT | Math, logic, reasoning | Medium | High |
| ReAct | External info needed | High | Very High |
| Self-Ask | Multi-hop questions | High | High |
| Least-to-Most | Complex decomposition | Medium | High |
| Directional Stimulus | Broad tasks needing focus | Low | Medium |
| Tree of Thought | Design decisions | Very High | Very High |

---

## Phase 4: System Prompt Design Patterns

### Pattern 1: Agent System Prompt

```
You are {role_name}, an AI assistant specializing in {domain}.

## Capabilities
- {capability_1}
- {capability_2}

## Constraints
- {constraint_1}
- {constraint_2}

## Workflow
1. First, {step_1}
2. Then, {step_2}
3. Finally, {step_3}

## Output Format
{format_specification}

## Edge Cases
- If {edge_case_1}: {handling}
- If {edge_case_2}: {handling}
```

### Pattern 2: Classification Prompt

```
Classify the following input into exactly one category.

Categories:
- {category_1}: {description}
- {category_2}: {description}

Rules:
- Choose exactly one category
- If unsure, choose the most likely
- Respond with only the category name

Input: {input}
```

### Pattern 3: Extraction Prompt

```
Extract the following information from the text:

Required fields:
- {field_1}: {type} — {description}
- {field_2}: {type} — {description}

Rules:
- If a field is not found, use null
- Preserve original text for extracted values
- Return as JSON

Text: {input_text}
```

### Pattern 4: Role + Constraint + Format

```
You are a {role}. {context}.

Your task: {task_description}

Rules:
- {rule_1}
- {rule_2}
- {rule_3}

Output format: {format_spec}
```

### Pattern 5: Generation with Quality Gates

```
Generate {output_type} following these requirements:

Requirements:
{list_of_requirements}

Quality Checklist (verify before outputting):
- [ ] All requirements addressed
- [ ] Output is complete, not truncated
- [ ] No placeholder text ("TODO", "...")
- [ ] Format matches specification
- [ ] Edge cases handled

Generate the output, then mentally run the quality checklist.
If any item fails, fix it before outputting.
```

---

## Phase 5: Model-Specific Considerations

### GPT-4 / GPT-4o
- Best at following complex, multi-step instructions
- Responds well to structured prompts with clear sections
- Supports function calling / tool use natively
- Use system message for persona, user message for task
- Good at code generation with explicit language specification

### Claude (Anthropic)
- Excellent at following detailed instructions
- Responds well to XML tags: `<instructions>`, `<examples>`, `<context>`
- Strong at analysis and reasoning tasks
- Prefers explicit, detailed system prompts
- Good at self-correction when asked to review output
- Use `---` separators between sections

### Gemini (Google)
- Good at multimodal tasks (text + images)
- Responds well to clear, concise prompts
- Good at long-context tasks (1M+ tokens)
- Prefers simpler prompt structures

### Open-Source Models (Llama, Mistral, etc.)
- More sensitive to prompt format
- May need more explicit instructions
- Few-shot examples help significantly
- Smaller context windows require concise prompts
- System prompt may need to be shorter

---

## Phase 6: Prompt Optimization

### Optimization Checklist

| Aspect | Question | Fix |
|--------|----------|-----|
| **Clarity** | Could a human follow these instructions unambiguously? | Rewrite ambiguous parts |
| **Completeness** | Does it cover the main task + edge cases? | Add missing cases |
| **Robustness** | Will it produce good output with unusual inputs? | Add adversarial tests |
| **Conciseness** | Can anything be removed without losing quality? | Remove padding |
| **Testability** | Can you verify the output matches expectations? | Add verification step |
| **Specificity** | Are instructions specific enough? | Replace vague with concrete |

### Common Prompt Problems and Fixes

| Problem | Symptom | Fix |
|---------|---------|-----|
| Too vague | Generic, unhelpful output | Add specific constraints and examples |
| Too long | Model ignores parts of the prompt | Restructure with clear sections, put constraints last |
| Conflicting instructions | Inconsistent output | Remove or resolve contradictions |
| No format spec | Unstructured text output | Add explicit output format |
| No examples | Doesn't understand expected pattern | Add 2-3 few-shot examples |
| No edge case handling | Fails on unusual inputs | Add explicit handling instructions |
| Too many tasks | Does some tasks poorly | Split into multiple prompts |

### Prompt Testing Strategy

1. **Normal case** — Does it work with typical input?
2. **Edge cases** — Empty input, very long input, special characters
3. **Adversarial** — Contradictory input, misleading input, injection attempts
4. **Boundary** — Minimum and maximum length inputs
5. **Regression** — After changes, verify previous cases still work

---

## Phase 7: Prompt Patterns Library

### Pattern: Structured Output
```
Return your response as a JSON object with exactly these fields:
- "analysis": string — your reasoning
- "decision": "approve" | "reject" | "needs_changes"
- "details": string — explanation for the user
```

### Pattern: Few-Shot with Examples
```
## Examples

Input: "I need to cancel my order #12345"
Output: {"intent": "cancel_order", "order_id": "12345", "confidence": 0.95}

Input: "When will my package arrive?"
Output: {"intent": "track_order", "order_id": null, "confidence": 0.8}

## Now process this input:
Input: "{user_input}"
```

### Pattern: Iterative Refinement
```
Step 1: Generate an initial response.
Step 2: Critique your response against these criteria:
- Accuracy: Are all facts correct?
- Completeness: Did you address all parts?
- Clarity: Is it easy to understand?
Step 3: Produce a refined version based on your critique.
```

---

## Output Format

When delivering a prompt to the user:

```
## Prompt: {name}

{the actual prompt in a code block}

### Design Notes
- {why you made key decisions}
- {what tradeoffs were made}
- {which technique was used and why}

### Test Cases
1. **Normal case**: {input} → {expected behavior}
2. **Edge case**: {input} → {expected behavior}
3. **Failure case**: {input} → {expected behavior}

### Optimization Suggestions
- {tuning recommendations}
- {model-specific adjustments}
```

## Rules

- **Be specific, not vague** — "Summarize in 3 bullet points, each under 15 words" beats "summarize briefly"
- **Use imperative language** — "Return JSON" not "Could you maybe return JSON?"
- **Put constraints last** — Models have recency bias; instructions at the end get more weight
- **Define edge cases** — "If the input is ambiguous, ask a clarifying question"
- **Separate sections clearly** — Use headers, XML tags, or numbered lists
- **Avoid negation when possible** — "Use only the provided data" beats "Don't use outside knowledge"
- **Specify failure behavior** — "If you cannot complete the task, respond with error"
- **Test before deploying** — Run the prompt against multiple inputs before production
- **Iterate systematically** — Change one thing at a time and measure impact
- **Keep a prompt library** — Save successful prompts for reuse

## Common Pitfalls to Avoid

- **Don't over-prompt.** If a short instruction works, don't pad it with unnecessary detail.
- **Don't use conflicting instructions.** "Be concise" and "explain in detail" conflict.
- **Don't forget failure behavior.** Unhandled edge cases produce unpredictable outputs.
- **Don't assume the model knows your context.** State everything explicitly.
- **Don't copy prompt patterns blindly.** Adapt them to your specific task and model.
- **Don't skip examples for complex tasks.** Few-shot examples are the most reliable way to shape output.
- **Don't use the same prompt for different models.** Each model has different strengths.
- **Don't ignore prompt injection.** For user-facing prompts, guard against override attempts.
