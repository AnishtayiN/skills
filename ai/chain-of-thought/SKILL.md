---
name: chain-of-thought
description: >-
  Chain-of-thought reasoning for AI agents. Covers step-by-step reasoning, decomposition
  techniques, self-consistency, tree of thought, reflection, analogical reasoning,
  constraint propagation, and when NOT to use CoT. Includes practical reasoning patterns
  for complex problem solving.
  استدلال زنجیره‌ای تفکر برای عوامل هوش مصنوعی. شامل استدلال گام‌به‌گام، تکنیک‌های
  تجزیه‌وتحلیل، سازگاری درونی، درخت تفکر، بازتاب، استدلال قیاسی، و انتشار قید و شرط.
  含何时不使用思维链。适用于复杂问题求解的实用推理模式。
  思维链推理技术，适用于AI智能体。涵盖逐步推理、分解技术、自洽性、思维树、
  反思、类比推理和约束传播。包含何时不使用CoT的指导以及复杂问题求解的实用推理模式。
priority: P2
dependencies: [prompt-engineering]
conflicts: []
---

# Chain-of-Thought Reasoning

## Overview

Chain-of-thought (CoT) reasoning is a prompting and reasoning methodology that enables AI systems to solve complex problems by breaking them into intermediate reasoning steps rather than jumping directly to an answer. It mirrors how humans approach multi-step problems: we think through each piece before arriving at a conclusion.

CoT is not a single technique but a family of approaches sharing a common principle: making reasoning explicit. This explicitness serves multiple purposes — it improves accuracy on complex tasks, makes model reasoning auditable, enables error detection at intermediate steps, and provides a framework for multi-agent collaboration.

The key insight behind CoT is that language models, like humans, perform better when they can externalize their thinking. Just as a mathematician writes out proof steps rather than stating only the theorem, an LLM produces better results when it articulates its reasoning process.

## When to Use This Skill

- **Multi-step logical reasoning** — Problems that require chaining multiple facts or rules together
- **Mathematical and numerical reasoning** — Word problems, calculations, quantitative analysis
- **Complex decision-making** — Choices involving multiple criteria, trade-offs, or conditional logic
- **Code debugging and analysis** — Tracing execution, identifying logic errors, understanding complex code
- **Legal and regulatory interpretation** — Applying rules to specific cases with multiple interacting constraints
- **Scientific reasoning** — Hypothesis evaluation, experimental design interpretation, causal analysis
- **Strategic planning** — Multi-step plans where each step depends on previous outcomes
- **Medical or diagnostic reasoning** — Symptom analysis, differential diagnosis, treatment planning
- **Ethical dilemma analysis** — Evaluating competing values with nuanced trade-offs
- **Any task where the model's first instinct gives wrong answers** — CoT forces deeper engagement

## When NOT to Use This Skill

- **Simple factual lookups** — "What is the capital of France?" does not need CoT; it adds latency and cost for no benefit
- **Tasks requiring speed over depth** — Real-time chat responses, quick categorizations, simple sentiment analysis
- **Tasks where the model already excels** — If zero-shot performance is already >95% accuracy, CoT overhead is wasteful
- **Creative generation** — Poetry, fiction, and brainstorming often benefit from unstructured, associative thinking rather than rigid step-by-step reasoning
- **Tasks with simple, linear dependency chains** — If the problem has only one step, CoT is redundant
- **High-volume, low-complexity processing** — Batch processing of simple transformations should prioritize throughput
- **Tasks better solved by code** — Arithmetic, sorting, data transformation should be delegated to deterministic tools

## Workflow

### Phase 1: Problem Analysis

1. **Identify the reasoning type** — Is this a deduction (applying rules), induction (finding patterns), or abduction (explaining observations)?
2. **Map the dependency graph** — Which reasoning steps depend on which other steps?
3. **Determine granularity** — How fine-grained should each step be? Too coarse misses errors; too fine wastes tokens.
4. **Select the CoT variant** — Simple step-by-step, self-consistency, tree of thought, or other variant
5. **Set stopping criteria** — When should reasoning stop? What constitutes "enough" depth?

### Phase 2: Reasoning Architecture

1. **Design the step structure** — What is the exact sequence of reasoning steps?
2. **Define step inputs and outputs** — What does each step need, and what does it produce?
3. **Plan for branching** — Are there decision points where the reasoning might diverge?
4. **Incorporate verification** — At which points should intermediate results be checked?
5. **Allocate token budget** — How many tokens per step? What is the total budget?

### Phase 3: Execution

1. **Execute each reasoning step** — Generate the intermediate reasoning explicitly
2. **Validate intermediate outputs** — Check each step for logical consistency
3. **Handle branching** — At decision points, explore multiple paths if needed
4. **Detect and correct errors** — If a step produces an unlikely result, backtrack
5. **Synthesize final answer** — Combine the reasoning chain into a coherent conclusion

### Phase 4: Verification

1. **Consistency check** — Does the conclusion follow from the reasoning steps?
2. **Completeness check** — Were all relevant factors considered?
3. **Sanity check** — Does the answer make intuitive sense?
4. **Alternative path check** — Would a different reasoning chain lead to a different answer?
5. **Confidence assessment** — How confident should we be in this conclusion?

## Advanced Techniques

### 1. Step-by-Step Decomposition with Explicit Variables

Break the problem into named variables that are computed incrementally:

```
Problem: A store offers 20% off for purchases over $100. If Sarah buys 3 items
at $45 each and applies a $10 coupon, how much does she pay?

Step 1 - RAW_TOTAL: 3 × $45 = $135
Step 2 - DISCOUNT_ELIGIBLE: $135 > $100? YES → apply 20% discount
Step 3 - DISCOUNT_AMOUNT: $135 × 0.20 = $27
Step 4 - AFTER_DISCOUNT: $135 - $27 = $108
Step 5 - AFTER_COUPON: $108 - $10 = $98
Step 6 - FINAL_ANSWER: $98

Verification: $98 < $100 → no longer discount-eligible. 
But the discount was applied at time of purchase when total was $135. 
The coupon is applied after the percentage discount. Answer: $98.
```

### 2. Self-Consistency Voting

Generate multiple independent reasoning chains and select the most common answer:

```
Run the same problem through 5 independent reasoning chains:

Chain 1: [reasoning] → Answer A
Chain 2: [reasoning] → Answer B
Chain 3: [reasoning] → Answer A
Chain 4: [reasoning] → Answer A
Chain 5: [reasoning] → Answer C

Majority vote: Answer A (3/5 votes)
Confidence: MODERATE (60% agreement)
Note: Explore why Chains 2 and 5 diverged — may indicate ambiguity in the problem.
```

### 3. Tree of Thought (ToT)

Explore multiple reasoning branches in parallel, evaluate each branch, and prune low-quality paths:

```
Problem: "What is the best strategy for this chess position?"

Branch 1: Move knight to f5
  → Evaluation: Controls center, threatens bishop (+3)
  → Sub-branch 1a: Black responds with ...Bf4
    → Evaluation: Acceptable, knight still strong (+2)
  → Sub-branch 1b: Black responds with ...Nh5
    → Evaluation: Knight gets trapped (-1)
  → Branch score: +1

Branch 2: Push pawn to e5
  → Evaluation: Gains space, opens lines (+2)
  → Sub-branch 2a: Black captures with ...dxe5
    → Evaluation: Opens d-file for rook (+3)
  → Sub-branch 2b: Black ignores and plays ...Qd7
    → Evaluation: Pawn chain strong (+2)
  → Branch score: +2.5

Branch 3: Castle kingside
  → Evaluation: Safe but passive (0)
  → Sub-branches: [various defensive scenarios]
  → Branch score: +0.5

Select Branch 2 (highest score: +2.5)
```

### 4. Analogical Reasoning

Map the current problem to a known problem and transfer the solution structure:

```
Current Problem: Design a rate limiter for an API gateway.

Analogous Problem: Water flow regulation in plumbing systems.

Mapping:
- API requests → Water flow
- Rate limit → Pipe diameter constraint
- Time window → Pressure buildup period
- Burst allowance → Water tower capacity
- Throttling → Valve restriction

Insight from analogy: Just as plumbing systems use both pipe diameter limits (steady-state)
AND water towers (burst capacity), a good rate limiter needs both sustained rate limits
AND burst allowances.

Design: Token bucket algorithm (sustained rate + burst capacity)
```

### 5. Constraint Propagation

Systematically apply constraints to eliminate impossible options:

```
Problem: Determine the correct seating arrangement for 5 people at a round table.

Constraints:
C1: Alice sits next to Bob
C2: Carol sits across from David
C3: Eve does not sit next to Carol
C4: Bob sits in seat 1 (fixed)

Propagation:
Step 1: Fix Bob in seat 1. Alice must be in seat 2 or 5 (C1).
Step 2: If Alice in seat 2: Carol across from David → seats 3 & 5.
         Eve in remaining seat 4.
         Check C3: Eve(4) next to Carol(3)? YES → VIOLATES C3.
Step 3: If Alice in seat 5: Carol across from David → seats 2 & 4.
         Eve in remaining seat 3.
         Check C3: Eve(3) next to Carol(2 or 4)? 
         If Carol in 2: Eve(3) next to Carol(2) → VIOLATES C3.
         If Carol in 4: Eve(3) next to Carol(4) → VIOLATES C3.
Step 4: Both paths violate C3. Re-examine... 

Actually, let me re-check: "across" at a 5-seat table means seat i and seat (i+2.5)? 
For odd numbers, "across" is ambiguous. Let me assume seats 1-5, where "across" 
from seat i is seat (i+2) mod 5 or (i+3) mod 5.

Result: Multiple valid arrangements exist depending on interpretation of "across."
```

### 6. Reflection and Self-Critique

After initial reasoning, explicitly critique the reasoning:

```
Initial reasoning: The answer is 42 because [reasoning chain].

Reflection:
- Did I use all the given information? Checked: I used constraints 1, 2, and 3 but 
  forgot constraint 4.
- Are there any assumptions I made that weren't justified? Assumed X without evidence.
- Does the answer pass a quick sanity check? 42 seems too high given the constraints.
- What would change if I considered constraint 4? It eliminates options above 30.

Revised reasoning: [incorporating forgotten constraint] → Answer is 28.
```

### 7. Decomposition with Sub-Task Independence Analysis

Before decomposing, analyze which sub-tasks are independent and which have dependencies:

```
Problem: Build a data pipeline that ingests, transforms, and visualizes sales data.

Dependency Analysis:
- Task A (Ingest data): INDEPENDENT — can start immediately
- Task B (Transform data): DEPENDS ON A — needs ingested data
- Task C (Validate data): DEPENDS ON B — needs transformed data
- Task D (Design visualization): INDEPENDENT — can start immediately
- Task E (Implement visualization): DEPENDS ON C and D — needs both validated data and design

Execution plan:
Phase 1 (parallel): Task A + Task D
Phase 2 (sequential): Task B (after A) → Task C (after B)
Phase 3: Task E (after C and D)

Critical path: A → B → C → E
```

## Common Patterns

### Pattern 1: The Verification Loop

```python
# Pseudocode for CoT with verification
def solve_with_verification(problem):
    # Step 1: Generate initial reasoning chain
    reasoning = llm.generate(f"""
    Solve this problem step by step:
    {problem}
    
    Show your complete reasoning.
    """)
    
    # Step 2: Verify the reasoning
    verification = llm.generate(f"""
    Review this reasoning for errors:
    
    Problem: {problem}
    Reasoning: {reasoning}
    
    Check for:
    1. Logical errors in any step
    2. Arithmetic mistakes
    3. Missing constraints
    4. Unjustified assumptions
    
    If errors found, list them. If no errors, confirm "VERIFIED".
    """)
    
    # Step 3: Refine if needed
    if "VERIFIED" not in verification:
        refined = llm.generate(f"""
        Problem: {problem}
        Errors found: {verification}
        Original reasoning: {reasoning}
        
        Provide corrected reasoning.
        """)
        return refined
    
    return reasoning
```

### Pattern 2: Multi-Perspective Analysis

```
Analyze this business decision from three perspectives:

FINANCIAL PERSPECTIVE:
- Revenue impact
- Cost implications
- ROI calculation
- Risk-adjusted returns

OPERATIONAL PERSPECTIVE:
- Implementation complexity
- Resource requirements
- Timeline feasibility
- Dependency risks

STRATEGIC PERSPECTIVE:
- Market positioning
- Competitive advantage
- Long-term alignment
- Option value preserved

SYNTHESIS:
Combine insights from all three perspectives to reach a recommendation.
```

### Pattern 3: Progressive Disclosure Reasoning

```
Level 1 - Quick Assessment (1 sentence):
What is the most likely answer?

Level 2 - Supporting Evidence (3-5 points):
List the key facts that support your answer.

Level 3 - Detailed Analysis:
Walk through the complete reasoning chain.

Level 4 - Edge Cases:
What scenarios would change your answer?

Level 5 - Confidence Assessment:
Rate your confidence and explain what would increase or decrease it.
```

### Pattern 4: Backward Reasoning

```
Start from the desired conclusion and work backward:

Goal: We need to reduce customer churn by 15% this quarter.

Step backward 1: What causes churn? 
→ Poor onboarding (40%), missing features (25%), price sensitivity (20%), competitor switching (15%)

Step backward 2: Which causes can we address this quarter?
→ Poor onboarding: YES (can improve in 2 weeks)
→ Missing features: PARTIALLY (some features in development)
→ Price sensitivity: YES (can offer loyalty discounts)
→ Competitor switching: NO (need product changes)

Step backward 3: What interventions address the addressable causes?
→ Onboarding: Redesign first-week experience
→ Price: Launch loyalty program

Step backward 4: What resources do these interventions require?
→ Onboarding: 2 developers, 1 designer, 3 weeks
→ Loyalty program: 1 developer, 1 week, legal review

Conclusion: Redesign onboarding + launch loyalty program = projected 18% churn reduction
```

### Pattern 5: Elimination Reasoning

```
List all possible answers, then systematically eliminate:

Question: What is the most likely cause of this server error?

Possible causes:
1. Database connection timeout → ELIMINATED: Error logs show DB is responding
2. Memory exhaustion → REMAINS: Process RSS at 95% of limit
3. Disk full → ELIMINATED: Disk usage at 40%
4. Network partition → REMAINS: Some internal calls timing out
5. CPU throttling → ELIMINATED: CPU at 30% usage
6. Configuration error → REMAINS: Recent deploy changed config
7. Rate limiting → ELIMINATED: No rate limit logs

Remaining candidates: Memory exhaustion, Network partition, Configuration error

Further analysis:
- Memory exhaustion: Correlated with OOM kills in dmesg → HIGH probability
- Configuration error: Only changed networking config → relates to network issues
- Network partition: Internal calls timing out → could be symptom, not cause

Final assessment: Configuration error (networking config change) causing network partition 
symptoms, combined with memory exhaustion from retry loops.
```

## Edge Cases & Pitfalls

### 1. **Premature Convergence**
The model may lock onto the first plausible answer and construct reasoning to justify it, rather than genuinely exploring alternatives. Mitigate by explicitly requesting consideration of alternatives.

### 2. **Reasoning Hallucination**
The model may generate plausible-sounding but factually incorrect intermediate steps. Each step should be verifiable against known facts or explicit given information.

### 3. **Over-Decomposition**
Breaking a simple problem into too many steps wastes tokens and can introduce errors at each step. Match decomposition granularity to problem complexity.

### 4. **Circular Reasoning**
In complex problems, reasoning chains can loop back on themselves. Detect this by checking if any step's conclusion is used as an input to a previous step.

### 5. **Token Budget Exhaustion**
Deep reasoning chains can consume the entire context window before reaching a conclusion. Plan token budgets and implement early stopping.

### 6. **False Confidence from Detailed Reasoning**
A long, detailed reasoning chain can appear authoritative even if it contains errors. The length and detail of reasoning is not correlated with correctness.

### 7. **Analogical Reasoning Failures**
When mapping between domains, some features transfer and others don't. Explicitly check which properties of the source domain apply to the target domain.

### 8. **Constraint Interaction Blindness**
Individual constraints may be satisfied while their combination creates impossibilities. Always check for constraint interactions, not just individual satisfaction.

### 9. **Decomposition Dependency Errors**
When breaking a problem into sub-problems, failing to account for dependencies between sub-problems leads to incorrect results. Map dependencies before decomposing.

### 10. **Overfitting to Examples**
When few-shot examples demonstrate a specific reasoning pattern, the model may apply that pattern even when a different approach is more appropriate.

### 11. **Confirmation Bias in Reasoning**
The model may seek evidence that supports a predetermined conclusion while ignoring contradictory evidence. Request explicitly that counter-evidence be considered.

### 12. **Loss of Global Context**
In deep reasoning chains, earlier context may be "forgotten" as the chain grows. Periodically restate key facts and constraints to keep them in the model's attention.

### 13. **Arithmetic Accumulation Errors**
Each arithmetic step has a small error probability. In a chain of 10 steps, the cumulative error rate is significant. Use external calculators for critical arithmetic.

### 14. **Premature Abstraction**
Moving to abstract reasoning before grounding in specifics can cause errors. Keep reasoning concrete for as long as possible before generalizing.

### 15. **Reasoning Without Action**
CoT produces reasoning, not action. Ensure the final step explicitly connects reasoning to the desired output format or action. A perfect reasoning chain that doesn't answer the original question is useless.

## Integration with Other Skills

| Related Skill | Integration Pattern | When to Combine |
|---|---|---|
| prompt-engineering | Embed CoT instructions in prompt architecture | Designing prompts that elicit structured reasoning |
| self-correction | Add verification steps to each reasoning phase | When intermediate results need validation |
| brainstorming | Use CoT to evaluate and refine generated ideas | When ideation requires systematic assessment |
| evaluation | Apply CoT to judge the quality of model outputs | Building evaluation pipelines for LLM systems |
| planning | Use decomposition for multi-step task planning | Complex agent workflows with dependencies |
| debugging | Apply backward reasoning to trace root causes | Systematic troubleshooting of failures |

## Output Format Templates

### Standard Output Template

```markdown
## Chain-of-Thought Analysis

### Problem Statement
[Clear, concise restatement of the problem]

### Reasoning Chain
| Step | Reasoning | Input | Output | Confidence |
|------|-----------|-------|--------|------------|
| 1 | [description] | [inputs] | [result] | [H/M/L] |
| 2 | [description] | [inputs] | [result] | [H/M/L] |
| ... | ... | ... | ... | ... |

### Conclusion
[Final answer derived from reasoning chain]

### Verification
- [ ] All given information used
- [ ] No logical gaps identified
- [ ] Answer passes sanity check
- [ ] Alternative approaches considered

### Confidence Assessment
- Overall confidence: [1-10]
- Key uncertainty: [what could change the answer]
- Risk if wrong: [consequence of incorrect answer]
```

### Quick Output Template

```
REASONING: [step 1] → [step 2] → [step 3] → ANSWER: [answer]
CONFIDENCE: [H/M/L]
CHECK: [sanity check result]
```

### Deep Output Template

```markdown
## Comprehensive Chain-of-Thought Report

### Problem Decomposition
[Hierarchical breakdown of the problem]

### Reasoning Graph
[Directed graph of reasoning dependencies]

### Multiple Solution Paths
#### Path A: [approach name]
- Steps: [detailed steps]
- Result: [answer]
- Score: [quality metric]

#### Path B: [approach name]
- Steps: [detailed steps]
- Result: [answer]
- Score: [quality metric]

### Synthesis
[Comparison of paths and final recommendation]

### Sensitivity Analysis
[What assumptions, if changed, would alter the conclusion]

### Meta-Reasoning
[Reflection on the reasoning process itself]
```

### Agent Output Template

```json
{
  "task": "reasoning_task_name",
  "technique": "step_by_step | self_consistency | tree_of_thought | analogical",
  "reasoning_chain": [
    {
      "step": 1,
      "description": "string",
      "input": "string",
      "output": "string",
      "confidence": "high|medium|low",
      "dependencies": []
    }
  ],
  "final_answer": "string",
  "confidence": {
    "overall": 0.85,
    "key_uncertainty": "string",
    "if_wrong_consequence": "string"
  },
  "verification": {
    "all_information_used": true,
    "no_logical_gaps": true,
    "sanity_check_passed": true,
    "alternatives_considered": 3
  },
  "token_usage": {
    "reasoning_tokens": 1500,
    "total_tokens": 2000
  }
}
```

## Rules

1. **Always decompose before reasoning** — Don't attempt complex problems in a single leap. Break them into manageable sub-problems with clear dependencies.

2. **Name your intermediate variables** — Give each computed value a descriptive name. "The result is 42" is less useful than "The total cost after discount is $42."

3. **Verify each step, not just the final answer** — Errors in intermediate steps propagate and compound. Check reasoning at each stage.

4. **Use self-consistency for high-stakes decisions** — When correctness matters more than cost, generate multiple independent reasoning chains and vote.

5. **Match decomposition granularity to problem complexity** — Simple problems need 2-3 steps. Complex problems may need 10-15. Don't over-decompose trivial tasks.

6. **Ground reasoning in explicit constraints** — Every constraint in the problem should appear explicitly in the reasoning chain. If a constraint is missing from the reasoning, it may be violated in the answer.

7. **Consider alternatives before committing** — At each decision point, briefly consider the alternative path before proceeding. This prevents premature convergence.

8. **State assumptions explicitly** — Any assumption not given in the problem should be flagged. "Assuming X because the problem doesn't specify" is better than silently assuming X.

9. **Use external tools for arithmetic** — Don't rely on the model for calculations. Delegate arithmetic to code, calculators, or tools.

10. **Keep reasoning concrete** — Abstract reasoning is error-prone. Stay grounded in specific values, numbers, and concrete examples as long as possible.

11. **Detect and break circular reasoning** — If a step's output feeds back as an input to an earlier step, the reasoning is circular. Restructure the chain.

12. **Don't confuse correlation with causation** — In abductive reasoning (explaining observations), ensure the proposed cause actually explains the observation, not just correlates with it.

13. **Budget tokens for reasoning** — Reasoning consumes context window. Plan for it and implement truncation strategies for deep chains.

14. **Document reasoning decisions** — When the reasoning makes a choice between alternatives, record why. This aids debugging and improvement.

15. **Know when to stop** — Not every problem requires infinite reasoning depth. Set clear stopping criteria: "Stop when confidence > 90% or after 10 steps."
