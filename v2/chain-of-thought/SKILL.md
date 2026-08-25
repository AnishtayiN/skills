---
name: chain-of-thought
description: >-
  Apply chain-of-thought and step-by-step reasoning techniques to improve AI output quality on complex problems.
  Use this skill when the user mentions: chain of thought, استدلال گام به گام, step by step reasoning,
  think step by step, show your reasoning, explain your thinking, work through this, break it down,
  reasoning trace, thought process, CoT, zero-shot CoT, few-shot CoT, self-consistency, tree of thought,
  show your work, تفکر مرحله به مرحله, تحلیل گام به گام, استنتاج, استدلال منطقی,
  reasoning chain, thought chain, step by step analysis, think through this carefully,
  walk me through your logic, explain how you arrived at this, show the math, prove your answer,
  derive this, work out the solution, analyze step by step, decompose this problem,
  break this into steps, plan before answering, think aloud, reasoning process,
  logical deduction, mathematical reasoning, multi-step reasoning, complex problem solving,
  structured reasoning, analytical thinking, critical reasoning, decision tree analysis,
  pros and cons reasoning, comparative analysis, root cause analysis, diagnostic reasoning.
---

# Chain-of-Thought Skill

## Overview

This skill guides the application of structured reasoning techniques to improve accuracy on complex tasks. The core insight: forcing explicit intermediate steps dramatically reduces errors in math, logic, planning, and multi-step analysis. This skill covers when and how to apply chain-of-thought (CoT), its variants, and when simpler approaches are sufficient.

## When to Use This Skill

- The problem requires multi-step calculation or deduction
- The user explicitly asks for step-by-step reasoning
- The task involves planning with dependencies
- Accuracy matters more than speed (e.g., legal analysis, medical reasoning, financial calculations)
- The problem is complex enough that jumping to the answer risks errors
- The user says "show your work" or "explain your thinking"
- The problem has multiple constraints that must all be satisfied
- The user is making a high-stakes decision and needs to see the rationale
- Debugging complex issues where the root cause is not obvious
- Any task where an incorrect intermediate step would invalidate the final answer

## When NOT to Use This Skill

- Simple factual lookups ("What is the capital of France?")
- Straightforward formatting tasks ("Convert this to JSON")
- Tasks where the user wants a quick answer, not a reasoning trace
- Problems where the reasoning would be longer and more confusing than helpful
- Tasks with a single obvious correct answer that needs no derivation

## Chain-of-Thought Techniques

### Technique 1: Zero-Shot CoT

Simply append a reasoning trigger. Minimal overhead, surprisingly effective.

**Trigger phrases to add to a prompt:**
- "Think step by step."
- "Let's work through this methodically."
- "Before answering, reason through each step."
- "Show your complete reasoning process."
- "First analyze, then conclude."
- "Walk through the logic before giving the final answer."

**When to use:** Quick tasks where adding examples would be overkill. Works well for math word problems, logical deductions, and multi-step analysis.

### Technique 2: Few-Shot CoT

Provide worked examples that demonstrate the desired reasoning chain.

```
## Examples

Q: A store has 23 apples. If 5 are sold each day for 3 days, how many remain?
A: Starting with 23 apples.
   Day 1: sell 5 → 23 - 5 = 18 remaining.
   Day 2: sell 5 → 18 - 5 = 13 remaining.
   Day 3: sell 5 → 13 - 5 = 8 remaining.
   Answer: 8 apples.

Q: {user's question}
A:
```

**When to use:** When the reasoning pattern is specific and you need the model to follow a particular structure. More reliable than zero-shot for domain-specific tasks.

### Technique 3: Structured Decomposition

Break the problem into named sub-problems before solving.

```
## Reasoning Plan
1. **Identify** the given information and what we need to find.
2. **Decompose** the problem into sub-problems.
3. **Solve** each sub-problem in order.
4. **Verify** the answer by checking against constraints.

## Execution
Step 1: ...
Step 2: ...
```

**When to use:** Complex planning tasks, multi-constraint problems, architectural decisions, or any task with 4+ interdependent steps.

### Technique 4: Self-Consistency

Generate multiple reasoning paths and take the majority answer.

```
Reason through this problem three different ways. If all three agree,
report high confidence. If they disagree, identify where the
reasoning diverges and resolve the conflict.
```

**When to use:** High-stakes decisions where you want to reduce the chance of a single reasoning error. Trade-off: 3x more tokens, but significantly higher accuracy on hard problems.

### Technique 5: Tree of Thought (Exploratory)

For problems with branching decisions, explore multiple paths and evaluate.

```
Consider 3 possible approaches to this problem. For each:
- Outline the approach in 2-3 sentences.
- Identify the main risk or limitation.
- Rate it 1-5 for likelihood of success.

Then select the best approach and execute it step by step.
```

**When to use:** Open-ended problems with multiple valid strategies: system design, creative tasks, strategic planning, debugging complex issues.

### Technique 6: Backward Chain-of-Thought

Start from the desired conclusion and work backward to verify or find the path.

```
I need to determine: {target conclusion}.

Working backward:
- For {conclusion} to be true, {precondition_1} must hold.
- For {precondition_1} to hold, {precondition_2} must hold.
- Checking: does {precondition_2} hold given the data? {analysis}
- Therefore: {final conclusion}.
```

**When to use:** Verification tasks, proof-like reasoning, debugging (start from the error and trace backward), goal-setting (what needs to be true for success?).

### Technique 7: Analogical Reasoning

Solve by analogy to a known problem, then verify the analogy holds.

```
## Analogical Reasoning

1. **Identify a similar problem** I know how to solve: {analog}
2. **Map the elements**: How does the current problem map to the analogy?
   - {element_a} ↔ {analog_element_a}
   - {element_b} ↔ {analog_element_b}
3. **Apply the solution** from the analogy to the current problem.
4. **Check the analogy** holds: Where does it break down? Are there disanalogies?
5. **Adjust** the solution for any disanalogies found.
```

**When to use:** Novel problems in familiar domains, teaching/explaining concepts, cross-domain transfer, problems where the user would benefit from a conceptual bridge.

## Workflow

### Step 1: Assess Problem Complexity

Ask: Would a direct answer likely be correct, or does this need reasoning?
- **Simple** (direct answer fine): Just answer.
- **Moderate** (2-3 steps): Use zero-shot CoT.
- **Complex** (4+ steps, multiple constraints): Use structured decomposition.
- **High-stakes / ambiguous**: Use self-consistency or tree of thought.

### Step 2: Select the Technique

Match the technique to the problem type:

| Problem Type | Recommended Technique |
|-------------|----------------------|
| Math / calculation | Zero-shot or few-shot CoT |
| Logic / deduction | Few-shot CoT with explicit logical steps |
| Planning / multi-step | Structured decomposition |
| Decision with multiple options | Tree of thought |
| Critical / high-stakes | Self-consistency |
| Verification / debugging | Backward CoT |
| Novel / unfamiliar | Analogical reasoning |

### Step 3: Execute Reasoning

Write out each step explicitly. For every step:
- State what you're doing and why
- Show the calculation or logic
- State the intermediate result
- Check: does this intermediate result make sense before proceeding?

### Step 4: Verify the Answer

Before delivering the final answer:
1. **Recency check** — Re-read the question and confirm your answer addresses it.
2. **Sanity check** — Is the answer in a reasonable range? (No negative counts, no impossible probabilities.)
3. **Back-solve** — If I plug my answer back in, does it satisfy the original constraints?
4. **Confidence assessment** — State your confidence level and any assumptions made.

## Common Patterns (Real-World Examples)

### Pattern 1: Financial Calculation

```
**Problem:** A SaaS company has 10,000 users. Churn is 3%/month. New signups
are 800/month at $50/user/month. What's the MRR after 6 months?

**Reasoning:**
Step 1: Calculate monthly retention: 1 - 0.03 = 0.97 (97% retain each month)
Step 2: Build month-by-month table:
  Month 0: 10,000 users × $50 = $500,000 MRR
  Month 1: (10,000 × 0.97) + 800 = 10,500 users × $50 = $525,000 MRR
  Month 2: (10,500 × 0.97) + 800 = 10,985 users × $50 = $549,250 MRR
  Month 3: (10,985 × 0.97) + 800 = 11,455.45 users × $50 = $572,773 MRR
  Month 4: (11,455 × 0.97) + 800 = 11,911.35 users × $50 = $595,568 MRR
  Month 5: (11,911 × 0.97) + 800 = 12,353.61 users × $50 = $617,681 MRR
  Month 6: (12,354 × 0.97) + 800 = 12,783.40 users × $50 = $639,170 MRR
Step 3: Verification — user count is growing (~28% over 6 months), MRR growth is proportional. ✓

**Answer:** ~$639,170 MRR after 6 months.
**Confidence:** High — straightforward compound calculation.
```

### Pattern 2: Root Cause Analysis (Backward CoT)

```
**Problem:** Our API response time jumped from 200ms to 2000ms yesterday.

**Backward reasoning:**
Step 1: What changed yesterday?
  - Deployment v2.3.1 went out at 14:00 UTC
  - No infrastructure changes logged
Step 2: What did v2.3.1 change?
  - Added a new middleware for request logging
  - The middleware calls an external analytics endpoint synchronously
Step 3: Does this explain the latency?
  - If the analytics endpoint has ~1800ms latency (slow due to geography),
    that adds 1800ms to every request: 200ms + 1800ms = 2000ms ✓
Step 4: Verification — Can we confirm by checking analytics endpoint latency?
  - Recommendation: Check metrics for the analytics endpoint.
  - Quick fix: Make the analytics call async.

**Root cause:** Synchronous analytics call in new middleware.
**Confidence:** High — timing and deployment correlation are strong.
```

### Pattern 3: Multi-Constraint Scheduling

```
**Problem:** Schedule 5 meetings (A: 30min, B: 60min, C: 45min, D: 30min, E: 90min)
into a 9AM-5PM day. A must be before B. C and D must be adjacent. E needs
a 15-min break after it. Lunch 12-1PM is blocked.

**Decomposition:**
1. Available time: 8 hours (480 min) - 60 min lunch = 420 min
2. Total meeting time: 30+60+45+30+90 = 255 min + 15 min break = 270 min
3. Remaining buffer: 420 - 270 = 150 min (flexible)
4. Apply constraints:
   - C and D adjacent: schedule as block (75 min)
   - E + 15 min break: 105 min block
   - A before B: A then B in sequence

**Solution:**
  9:00 - 9:30  Meeting A (30 min)
  9:30 - 10:30 Meeting B (60 min)
  10:30 - 10:45 Buffer
  10:45 - 12:00 Meeting E (90 min)
  12:00 - 12:15 Break after E
  12:15 - 1:00  Lunch (extended slightly — still within blocked zone)
  1:00 - 2:30  Block: C (45 min) + D (30 min)
  2:30 - 5:00  Open / buffer

**Verification:** All constraints satisfied? A before B ✓, C adjacent to D ✓,
E has break after ✓, no overlap with lunch ✓.
**Confidence:** High.
```

### Pattern 4: Comparative Analysis (Tree of Thought)

```
**Problem:** Should we use PostgreSQL or MongoDB for our new application?

**Approach 1: PostgreSQL (Relational)**
- Strengths: ACID compliance, complex queries, mature ecosystem
- Weaknesses: Schema migrations, horizontal scaling complexity
- Success likelihood: 4/5 — our data is highly relational

**Approach 2: MongoDB (Document)**
- Strengths: Flexible schema, easy horizontal scaling, fast writes
- Weaknesses: Limited joins, eventual consistency in sharded clusters
- Success likelihood: 3/5 — our queries need complex joins

**Approach 3: Hybrid (PostgreSQL + Redis cache)**
- Strengths: Relational integrity + fast reads
- Weaknesses: Cache invalidation complexity, two systems to maintain
- Success likelihood: 4/5 — but adds operational complexity

**Decision:** PostgreSQL (Approach 1). Our data model is relational (users,
orders, products with foreign keys). The complexity of joins outweighs
MongoDB's schema flexibility benefit.
```

### Pattern 5: Self-Consistency on Ambiguous Question

```
**Problem:** "If a hen and a half lays an egg and a half in a day and a half,
how many eggs does one hen lay in one day?"

**Path 1 (Rate-based):**
  1.5 hens → 1.5 eggs / 1.5 days
  Rate per hen per day = 1.5 / (1.5 × 1.5) = 1.5 / 2.25 = 2/3 egg per hen per day
  Answer: 2/3 egg

**Path 2 (Scaling):**
  1.5 hens lay 1.5 eggs in 1.5 days
  → 1 hen lays 1 egg in 1.5 days (divide everything by 1.5)
  → 1 hen lays (1/1.5) eggs in 1 day = 2/3 egg
  Answer: 2/3 egg

**Path 3 (Unit conversion):**
  Combined rate = 1.5 eggs / 1.5 days = 1 egg/day (for 1.5 hens)
  Per hen = 1 / 1.5 = 2/3 egg/day
  Answer: 2/3 egg

**All three paths agree.**
**Answer: 2/3 of an egg per hen per day.**
**Confidence: Very High** — three independent methods converge.
```

## Advanced Techniques

### Technique 1: Nested Chain-of-Thought
For multi-layer problems, reason at two levels:
1. **Meta-reasoning**: Plan which sub-problems to solve and in what order.
2. **Object-reasoning**: Solve each sub-problem with its own CoT.
This prevents the model from getting lost in details before understanding the full scope.

### Technique 2: Constraint Propagation
After each reasoning step, explicitly propagate constraints to narrow the solution space:
```
Step 1: {result}
  → This means {constraint_a} must be true, and {value_x} is now bounded to [{min}, {max}].
Step 2: {result}
  → Combined with constraint_a, this means {further_constraint}.
```
This catches impossibilities early rather than discovering them at the final step.

### Technique 3: Assumption Tracking
Maintain an explicit list of assumptions made during reasoning:
```
**Assumptions:**
1. {assumption_1} — if false, answer changes to {alternative}
2. {assumption_2} — if false, the calculation is off by ~{factor}
```
This makes the reasoning auditable and helps the user identify where they might disagree.

### Technique 4: Parallel Verification
After reaching an answer, verify it using a different method:
```
**Primary method:** {method_description} → {answer}
**Verification method:** {different_method} → {answer}
Both agree? {yes/no}
```

### Technique 5: Progressive Confidence
Update a running confidence score after each step:
```
Step 1: {reasoning} [Confidence: 90% — straightforward arithmetic]
Step 2: {reasoning} [Confidence: 85% — assumption about tax rate]
Step 3: {reasoning} [Confidence: 70% — uncertain market growth estimate]
Final confidence: 70% — driven by Step 3 uncertainty.
```

### Technique 6: Counter-Argument Generation
For decision problems, actively generate counter-arguments:
```
**My reasoning leads to:** {conclusion}
**Counter-argument 1:** {strongest objection}
  → Rebuttal: {why the objection doesn't change the conclusion, or how it modifies it}
**Counter-argument 2:** {second objection}
  → Rebuttal: {response}
**Revised conclusion:** {may be the same or adjusted}
```

### Technique 7: Quantified Uncertainty
When reasoning involves estimates, use ranges instead of point values:
```
Step 1: Revenue is estimated at $1M-$1.5M (base case: $1.2M)
Step 2: Costs are estimated at $600K-$800K (base case: $700K)
Step 3: Profit range: $200K-$900K (base case: $500K)
**Answer:** Expected profit $500K, range $200K-$900K.
```

## Edge Cases & Pitfalls

1. **Over-reasoning simple problems** — Adding "think step by step" to "What is 2+2?" wastes tokens and can sometimes introduce errors. Match technique to complexity.

2. **Reasoning hallucination** — The model generates a plausible-sounding but incorrect reasoning chain. Counter: verify intermediate results independently.

3. **Premature convergence** — The model commits to an answer early in the reasoning and then rationalizes it, ignoring contradictory evidence. Counter: use self-consistency or tree of thought.

4. **Circular reasoning** — Step 3 assumes the conclusion that step 5 is supposed to prove. Counter: track assumptions explicitly and check that no step depends on the final answer.

5. **Calculation drift** — Small arithmetic errors compound across many steps. A wrong digit in step 2 makes the final answer completely wrong. Counter: verify calculations at each step, not just at the end.

6. **Verbosity without value** — The model writes 20 reasoning steps when 5 would suffice, making it hard to find the actual logic. Counter: instruct "each step must advance the solution; do not repeat or restate."

7. **Anchoring on the first path** — In tree-of-thought, the model may evaluate the first approach favorably and then bias against later approaches. Counter: evaluate all approaches before comparing.

8. **Ignoring qualitative factors** — Purely quantitative reasoning may miss important context (legal requirements, user sentiment, brand risk). Counter: include a "qualitative considerations" step.

9. **False precision** — Presenting an answer to 6 decimal places when the inputs were estimates. Counter: round outputs to a precision justified by the inputs.

10. **Reasoning past the context window** — For very complex problems, the reasoning trace may exceed the context window, causing the model to forget earlier steps. Counter: use structured decomposition to keep sub-problems small.

11. **Confirmation bias in self-consistency** — If all three reasoning paths share the same faulty assumption, they'll agree on the wrong answer. Counter: ensure paths use genuinely different methods, not just different wording.

12. **Edge case blindness** — The reasoning works for the main case but fails on boundary conditions (zero, negative, empty, maximum). Counter: explicitly test boundary conditions in the verification step.

## Integration with Related Skills

- **Prompt Engineering** — CoT triggers and structured reasoning instructions are prompt engineering techniques. See `prompt-engineering` skill for embedding CoT into system prompts.
- **Self-Correction** — CoT makes self-correction possible by exposing intermediate steps that can be checked. See `self-correction` skill for verification workflows.
- **RAG Implementation** — RAG answers benefit from CoT: "Based on the retrieved documents, here's my reasoning..." See `rag-implementation` skill.
- **Fullstack Dev** — Complex debugging and architectural decisions in code benefit from structured reasoning. See `fullstack-dev` skill.

## Output Format Templates

### Template 1: Standard Reasoning Output

```
## Reasoning

**Step 1: {step name}**
{reasoning for this step}
→ {intermediate result}

**Step 2: {step name}**
{reasoning for this step}
→ {intermediate result}

...

**Step N: Final calculation**
{reasoning}
→ {final result}

## Verification
- {sanity check result}
- {constraint check result}

## Answer
{clear, concise final answer}

**Confidence:** {high/medium/low} — {reason for confidence level}
**Assumptions:** {any assumptions made}
```

### Template 2: Multi-Path (Self-Consistency) Output

```
## Reasoning Analysis

### Path 1: {method name}
{reasoning steps}
→ Result: {answer}

### Path 2: {method name}
{reasoning steps}
→ Result: {answer}

### Path 3: {method name}
{reasoning steps}
→ Result: {answer}

### Consensus
- All paths agree: {yes/partially/no}
- If disagreement: {where and why}

## Final Answer
{consensus or best answer with explanation}

**Confidence:** {level} — {justification}
```

### Template 3: Decision Analysis (Tree of Thought) Output

```
## Decision Analysis: {topic}

### Option A: {name}
- **Description:** {1-2 sentences}
- **Pros:** {list}
- **Cons:** {list}
- **Risk level:** {low/medium/high}
- **Score:** {N}/5

### Option B: {name}
{same structure}

### Option C: {name}
{same structure}

### Recommendation
**Selected:** {option}
**Rationale:** {why this option wins}
**Caveats:** {what could change the recommendation}
**Next steps:** {concrete actions}
```

### Template 4: Compact Reasoning (For Chat Interfaces)

```
**Thinking:**
1. {step} → {result}
2. {step} → {result}
3. {step} → {result}

**Answer:** {final answer}
*Confidence: {high/medium/low}. Key assumption: {assumption}.*
```

## Principles Summary

1. **Match technique to complexity** — Don't use a cannon to kill a fly.
2. **Show every step** — Hidden reasoning is unverifiable reasoning.
3. **Verify before concluding** — The final step is always verification.
4. **State confidence honestly** — Overconfidence is worse than underconfidence.
5. **Track assumptions** — Every assumption is a potential failure point.
6. **Use multiple methods for high-stakes** — Self-consistency catches errors that single-path misses.
7. **Keep reasoning lean** — Every step must earn its place in the chain.
