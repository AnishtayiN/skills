---
name: chain-of-thought
description: >-
  Apply chain-of-thought and step-by-step reasoning techniques to improve AI output quality on complex problems. Use this skill when the user mentions chain of thought, استدلال گام به گام, step by step reasoning, think step by step, show your reasoning, explain your thinking, work through this, break it down, reasoning trace, thought process, CoT, zero-shot CoT, few-shot CoT, self-consistency, tree of thought, faithful reasoning, cumulative reasoning, contrastive reasoning, self-refine, verify reasoning, or when the problem involves multi-step logic, math, analysis, planning, code generation, scientific reasoning, or any task where jumping to the answer would likely produce errors.
---

# Chain-of-Thought Skill — Structured Reasoning for Complex Problems

## Overview

This skill guides the application of structured reasoning techniques to dramatically improve accuracy on complex tasks. The core insight: **forcing explicit intermediate steps reduces errors** in math, logic, planning, code, science, and multi-step analysis. This skill covers when and how to apply chain-of-thought (CoT), its many variants, verification strategies, domain-specific reasoning patterns, and when simpler approaches are sufficient.

## When to Use This Skill

- The problem requires multi-step calculation or deduction
- The user explicitly asks for step-by-step reasoning
- The task involves planning with dependencies
- Accuracy matters more than speed (e.g., legal analysis, medical reasoning, financial calculations)
- The problem is complex enough that jumping to the answer risks errors
- The user says "show your work" or "explain your thinking"
- The task involves code debugging, algorithm design, or system architecture decisions
- The user asks to compare, evaluate, or decide between multiple options with trade-offs

## When NOT to Use This Skill

- Simple factual lookups ("What is the capital of France?")
- Straightforward formatting tasks ("Convert this to JSON")
- Tasks where the user wants a quick answer, not a reasoning trace
- Problems where the reasoning would be longer and more confusing than helpful
- Creative writing where flow matters more than precision

---

## Chain-of-Thought Techniques

### Technique 1: Zero-Shot CoT

Simply append a reasoning trigger. Minimal overhead, surprisingly effective.

**Trigger phrases to add to a prompt:**
- "Think step by step."
- "Let's work through this methodically."
- "Before answering, reason through each step."
- "Show your complete reasoning process."
- "Work through this problem before giving your final answer."

**When to use:** Quick tasks where adding examples would be overkill. Works well for math word problems, logical deductions, and multi-step analysis.

**Example:**
```
Q: A farmer has 15 cows. All but 8 died. How many are alive?
Think step by step.

A: "All but 8 died" means 8 survived.
Answer: 8 cows.
```

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

Q: A train travels 120 km in 2 hours. It then travels another 180 km in 3 hours. What is its average speed?
A: Total distance = 120 + 180 = 300 km.
   Total time = 2 + 3 = 5 hours.
   Average speed = 300 / 5 = 60 km/h.
   Answer: 60 km/h.

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

---

## Advanced CoT Variants

### Variant 6: Faithful Chain-of-Thought

Faithful CoT requires the reasoning chain to faithfully represent the actual thought process — no post-hoc rationalization. Every conclusion must follow logically from explicitly stated premises.

```
## Faithful Reasoning

**Given:**
- Premise 1: [stated fact]
- Premise 2: [stated fact]
- Assumption: [explicitly marked assumption]

**Reasoning:**
Step 1: From Premise 1, we can derive [X] because [reason].
Step 2: Combining [X] with Premise 2, we get [Y] because [reason].
Step 3: Under the stated assumption, [Y] implies [Z].

**Conclusion:** [Z]

**Confidence:** High — each step follows from explicitly stated premises.
**If assumption is wrong:** The conclusion may be invalid because [reason].
```

**When to use:** Legal reasoning, scientific argumentation, any domain where the chain of reasoning itself must be auditable and defensible. Essential when the reasoning may be challenged or reviewed.

**Key difference from standard CoT:** Every logical step must be justified by prior premises, and all assumptions must be explicitly flagged. No "hand-waving" steps.

### Variant 7: Cumulative Chain-of-Thought

Build reasoning incrementally, where each step produces a "knowledge artifact" that the next step consumes. This prevents context loss in long reasoning chains.

```
## Cumulative Reasoning

### Layer 1: Problem Analysis
**Input:** The original problem statement.
**Artifacts produced:**
- Variables identified: X, Y, Z
- Constraints: [list]
- Goal: Find [target]

### Layer 2: Strategy Selection
**Input:** Artifacts from Layer 1.
**Artifacts produced:**
- Selected approach: [approach name]
- Justification: [why this approach]
- Sub-tasks: [A, B, C]

### Layer 3: Execution of Sub-task A
**Input:** Artifacts from Layers 1-2 + specific sub-task A.
**Artifacts produced:**
- Result of A: [value/finding]
- Updated state: [what changed]

### Layer 4: Execution of Sub-task B
**Input:** Artifacts from Layers 1-3 + specific sub-task B.
**Artifacts produced:**
- Result of B: [value/finding]
- Combined result with A: [synthesis]

### Final Synthesis
**Input:** All accumulated artifacts.
**Output:** Final answer with full provenance.
```

**When to use:** Long problems where context window management matters. Complex multi-phase analysis where later steps depend on explicitly captured earlier findings. Prevents the "lost in the middle" problem where models forget earlier reasoning in long chains.

### Variant 8: Contrastive Chain-of-Thought

Reason by comparing correct and incorrect approaches side-by-side. The model generates both a "right way" and a "common mistake" reasoning path, then explains the difference.

```
## Contrastive Reasoning

### Correct Approach:
Step 1: [correct reasoning]
Step 2: [correct reasoning]
Result: [correct answer]

### Common Mistake:
Step 1: [same starting point]
Step 2: [where it goes wrong — e.g., "Multiply instead of divide"]
Result: [incorrect answer]

### Why the Mistake Happens:
The error occurs because [explanation of the misconception or trap].

### How to Avoid It:
- [specific check or rule]
- [specific check or rule]
```

**When to use:** Teaching and learning scenarios. Debugging (compare working vs. broken code paths). Explaining why a commonly-seen answer is wrong. User asks "why is my approach wrong?"

---

## Verification Strategies

After producing a CoT answer, apply one or more verification strategies:

### Strategy A: Self-Consistency Check

Re-derive the answer from scratch without looking at the first derivation. Compare results.

```
## Verification: Independent Re-derivation
Original answer: [answer]
Re-derived answer: [answer]
Match: Yes/No
If mismatch: The error is in [which derivation] because [reason].
Confidence after verification: [level]
```

### Strategy B: Back-Solve / Substitution Check

Plug the answer back into the original problem and verify all constraints are satisfied.

```
## Verification: Back-Solve
If answer = [value], then:
- Constraint 1: [check] → ✅ satisfied
- Constraint 2: [check] → ✅ satisfied
- Constraint 3: [check] → ❌ FAILED — [which constraint]
→ Original answer was wrong. Corrected answer: [new value]
```

### Strategy C: Self-Refine

Critically review the reasoning chain, identify weaknesses, and produce an improved version.

```
## Self-Refine Cycle

### Round 1 Output:
[Original reasoning and answer]

### Self-Critique:
- Issue 1: [e.g., "Step 3 assumed X without justification"]
- Issue 2: [e.g., "Calculation in Step 5 appears incorrect: 7×8=56, not 48"]
- Weakness: [e.g., "Did not consider edge case where N=0"]

### Round 2 Output (Refined):
[Improved reasoning incorporating fixes]

### Final Answer:
[refined answer]
```

### Strategy D: Boundary / Edge Case Check

Test the answer against extreme values and boundary conditions.

```
## Verification: Edge Cases
- If input = 0: [what happens] → [does answer still make sense?]
- If input = 1: [what happens] → [does answer still make sense?]
- If input = MAX_INT: [what happens] → [overflow risk?]
- If all inputs are equal: [what happens] → [expected behavior?]
```

---

## Domain-Specific Reasoning Patterns

### Math & Arithmetic

```
Problem: [mathematical problem]

1. **Identify variables:** Let x = ..., y = ...
2. **Set up equations:** From the problem: x + y = 10, xy = 21
3. **Solve systematically:** From equation 1: y = 10 - x. Substitute: x(10-x) = 21 → x² - 10x + 21 = 0
4. **Factor/solve:** (x-3)(x-7) = 0 → x = 3 or x = 7
5. **Interpret:** Both solutions are valid. x=3,y=7 or x=7,y=3.
6. **Verify:** 3+7=10 ✅, 3×7=21 ✅
```

**Common math reasoning failures:**
- Division by zero when variables could be zero
- Forgetting negative roots in quadratic equations
- Mixing up radians and degrees
- Rounding errors that compound through multi-step calculations

### Code Reasoning & Debugging

```
## Code Analysis

**Code under review:**
[code snippet]

**Step 1: Trace execution with a concrete example.**
Input: x = [specific value]
Line 1: a = [what happens]
Line 2: b = [what happens]
Line 3: [what happens] → Expected: [value], Actual: [value]

**Step 2: Identify divergence point.**
The expected and actual values diverge at line [N] because [reason].

**Step 3: Root cause.**
[Explanation of the bug]

**Step 4: Fix.**
[Corrected code]

**Step 5: Verify fix with other inputs.**
Test with x = [edge case 1], x = [edge case 2], x = [edge case 3].
```

### Logic & Deduction

```
## Logical Reasoning

**Given:**
1. If A, then B. (A → B)
2. If B, then C. (B → C)
3. A is true.

**Deduction:**
Step 1: From (1) and (3): A → B, and A is true, therefore B is true. (Modus Ponens)
Step 2: From (2) and Step 1: B → C, and B is true, therefore C is true. (Modus Ponens)
Conclusion: C is true.

**Chain of reasoning:** A → B → C (Hypothetical Syllogism confirmed)
```

**Common logic failures:**
- Affirming the consequent: "If A then B; B is true; therefore A is true" ← INVALID
- Denying the antecedent: "If A then B; A is false; therefore B is false" ← INVALID
- Confusing necessary and sufficient conditions

### Scientific Reasoning

```
## Scientific Analysis

**Observation:** [what is observed]

**Hypothesis generation:**
- H1: [hypothesis] — Explains observation by [mechanism]
- H2: [hypothesis] — Explains observation by [mechanism]
- H3: [hypothesis] — Explains observation by [mechanism]

**Evidence evaluation:**
- Evidence supporting H1: [list]
- Evidence contradicting H1: [list]
- Evidence supporting H2: [list]
- Evidence contradicting H2: [list]

**Conclusion:** [Hypothesis] is best supported because [reason].
**Confidence:** [level] — Additional evidence needed: [what would strengthen/undermine]
```

### Financial & Business Analysis

```
## Financial Reasoning

**Problem:** [financial question]

**Assumptions (stated explicitly):**
- Growth rate: X%
- Time horizon: Y years
- Discount rate: Z%

**Calculation:**
Year 0: [value]
Year 1: [value] × (1 + X%) = [value]
Year 2: [value] × (1 + X%) = [value]
...
Year N: [value]

**NPV/ROI:** [calculation]

**Sensitivity analysis:**
- If growth = X% + 2%: result = [value]
- If growth = X% - 2%: result = [value]

**Conclusion:** [recommendation with confidence level]
```

---

## Decision Tree: Which Technique to Use?

```
START
│
├─ Is the problem simple (< 2 steps)?
│  ├─ YES → Just answer directly. No CoT needed.
│  └─ NO ↓
│
├─ Is the problem primarily calculation/math?
│  ├─ YES → Zero-shot CoT or Few-shot CoT
│  └─ NO ↓
│
├─ Does the problem involve branching decisions?
│  ├─ YES → Tree of Thought
│  └─ NO ↓
│
├─ Is this a high-stakes / auditable decision?
│  ├─ YES → Faithful CoT + Self-Consistency
│  └─ NO ↓
│
├─ Is the reasoning chain long (> 8 steps)?
│  ├─ YES → Cumulative CoT
│  └─ NO ↓
│
├─ Are you teaching or explaining why something is wrong?
│  ├─ YES → Contrastive CoT
│  └─ NO ↓
│
├─ Is this a multi-constraint problem?
│  ├─ YES → Structured Decomposition
│  └─ NO ↓
│
└─ Default: Zero-shot CoT

AFTER ANY TECHNIQUE:
  ├─ Is accuracy critical? → Apply Self-Consistency or Self-Refine
  ├─ Could edge cases break the answer? → Apply Boundary Check
  └─ Will the answer be audited? → Apply Faithful CoT + Back-Solve
```

---

## Common Reasoning Failures & How to Avoid Them

### Failure 1: Premature Convergence
**Symptom:** Jumping to an answer after identifying the first plausible approach.
**Fix:** Force yourself to list at least 2-3 approaches before selecting one (Tree of Thought).

### Failure 2: Hidden Assumptions
**Symptom:** Making an assumption without stating it, then treating the conclusion as certain.
**Fix:** Use Faithful CoT — explicitly list every assumption and mark it as [ASSUMPTION].

### Failure 3: Anchoring Bias
**Symptom:** Sticking with the first number or estimate encountered.
**Fix:** Use Self-Consistency — derive the answer independently 2-3 times from different starting points.

### Failure 4: Calculation Drift
**Symptom:** Small arithmetic errors compound through long chains.
**Fix:** After every calculation step, verify the intermediate result. Use Back-Solve verification at the end.

### Failure 5: Logical Fallacies
**Symptom:** Affirming the consequent, confusing necessary/sufficient conditions, or using invalid inference patterns.
**Fix:** When doing logical reasoning, explicitly name each inference rule you're using (Modus Ponens, Modus Tollens, etc.).

### Failure 6: Context Loss in Long Chains
**Symptom:** Forgetting earlier conclusions or contradicting yourself in steps 8+.
**Fix:** Use Cumulative CoT — explicitly carry forward a "state" object with all key conclusions.

### Failure 7: Over-Confidence
**Symptom:** Stating "the answer is X" without qualification when the reasoning has weak steps.
**Fix:** Always include a Confidence assessment with justification. Use Self-Refine to stress-test.

---

## Integration with Tool Use

CoT reasoning becomes more powerful when combined with tools:

### CoT + Code Execution
```
Reasoning:
Step 1: I need to calculate the factorial of 20.
Step 2: This is too large for manual calculation.
Step 3: [CALL TOOL: run code — "import math; print(math.factorial(20))"]
Step 4: Result = 2432902008176640000.
Step 5: Verify: 20! should end in many zeros because of factors of 5 and 2. ✅
```

### CoT + Web Search
```
Reasoning:
Step 1: I need to determine if Python 3.12 supports the syntax "X | Y" for type unions.
Step 2: This was introduced in Python 3.10 (PEP 604), so 3.12 should support it.
Step 3: But let me verify the current stable Python version.
Step 4: [CALL TOOL: web_search — "current Python stable release version 2025"]
Step 5: Verified — Python 3.12+ is stable and supports this syntax.
```

### CoT + File System
```
Reasoning:
Step 1: To answer this question, I need to check the project's configuration.
Step 2: [CALL TOOL: read — "package.json"]
Step 3: Found that the project uses React 18.2.0.
Step 4: React 18 introduced concurrent features. This changes the answer because...
```

### CoT + Calculator / Computation
```
Reasoning:
Step 1: The user needs the compound interest on $10,000 at 5% for 10 years.
Step 2: Formula: A = P(1 + r/n)^(nt), where P=10000, r=0.05, n=12 (monthly), t=10.
Step 3: [CALL TOOL: calculate — "10000 * (1 + 0.05/12)^(12*10)"]
Step 4: Result = $16,470.09
Step 5: Sanity check: Rule of 72 says money doubles in ~14.4 years at 5%. In 10 years, ~65% growth from 10,000 to ~16,470 seems right. ✅
```

---

## Workflow

### Step 1: Assess Problem Complexity

Ask: Would a direct answer likely be correct, or does this need reasoning?
- **Simple** (direct answer fine): Just answer.
- **Moderate** (2-3 steps): Use zero-shot CoT.
- **Complex** (4+ steps, multiple constraints): Use structured decomposition.
- **High-stakes / ambiguous**: Use self-consistency or tree of thought.
- **Long chain** (8+ steps): Use cumulative CoT.
- **Teaching moment**: Use contrastive CoT.

### Step 2: Select the Technique

| Problem Type | Recommended Technique |
|-------------|----------------------|
| Math / calculation | Zero-shot or few-shot CoT |
| Logic / deduction | Few-shot CoT with explicit logical steps |
| Planning / multi-step | Structured decomposition |
| Decision with multiple options | Tree of thought |
| Critical / high-stakes | Self-consistency + Faithful CoT |
| Debugging / code analysis | Code tracing pattern + Contrastive CoT |
| Teaching / explaining errors | Contrastive CoT |
| Long reasoning chains (>8 steps) | Cumulative CoT |
| Scientific analysis | Scientific reasoning pattern |
| Financial decisions | Financial reasoning pattern + sensitivity analysis |

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
5. **Edge case check** — Does the answer hold for boundary conditions?

---

## Output Format

When presenting chain-of-thought reasoning:

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
- {edge case check if applicable}

## Answer
{clear, concise final answer}

**Confidence:** {high/medium/low} — {reason for confidence level}
**Assumptions:** {any assumptions made}
**Alternative interpretations:** {if the problem is ambiguous, list them}
```

---

## Rules

- **Don't over-reason simple problems.** If the answer is obvious, just give it.
- **Don't skip verification.** The whole point of CoT is catching errors in intermediate steps.
- **Don't make the reasoning verbose for its own sake.** Each step should add value.
- **Don't ignore contradictions.** If step 3 contradicts step 2, flag it immediately.
- **Don't present uncertain reasoning as confident.** State when you're unsure and why.
- **Don't forget to state assumptions.** Hidden assumptions are the #1 source of errors in complex reasoning.
- **Don't skip the sanity check.** A 300% return in one month is probably wrong. A negative number of people is definitely wrong.
- **Use tools when reasoning alone isn't enough.** Calculate, search, and read files to fill knowledge gaps rather than guessing.
