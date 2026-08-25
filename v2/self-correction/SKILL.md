---
name: self-correction
description: >-
  Review, verify, and correct AI outputs including your own previous responses.
  Use this skill when the user mentions: self correction, خود اصلاحی, review your output,
  check your work, verify your answer, double check, review this response, is this correct,
  did you make a mistake, look at this again, re-examine, self-verify, quality check,
  critique your answer, find errors in this, proofread, are you sure about this,
  بررسی پاسخ, اصلاح خروجی, بررسی خطا, آیا این درست است، بازبینی کن،
  دوباره چک کن، خطایابی، ویرایش و بررسی، کنترل کیفیت،
  can you double-check, verify this claim, fact-check this, is this accurate,
  review this code for bugs, check for mistakes, something seems wrong,
  are you confident about this, challenge your answer, devil's advocate,
  stress test this answer, what if you're wrong, second opinion,
  validate this output, audit this response, check your reasoning,
  review your logic, verify the calculation, check the math,
  review for accuracy, error analysis, output validation,
  red team this response, adversarial review, find the flaw.
---

# Self-Correction Skill

## Overview

This skill provides a systematic framework for reviewing and correcting AI outputs — including your own. Self-correction is not about being defensive; it's about applying the same rigor you'd use when reviewing someone else's work. The key insight: most AI errors are catchable if you know what categories to check.

## When to Use This Skill

- User explicitly asks you to review, verify, or double-check an output
- User points out a potential error or inconsistency
- You notice uncertainty in your own response
- The task involves factual claims that should be verified
- The output involves calculations, code, or logical reasoning
- User asks "is this correct?" or "did you miss anything?"
- The output will be used in a high-stakes context (legal, medical, financial)
- The user is building something and needs reliable code or data
- A previous response was long or complex and errors are likely
- The user says "are you sure?" or expresses doubt

## Categories of Errors to Check

### 1. Factual Errors
- Are all factual claims accurate? (Names, dates, statistics, terminology)
- Are citations or references real and correctly attributed?
- Are technical specifications correct (API names, parameter types, version numbers)?
- Are historical claims correct and properly contextualized?
- Are geographic or demographic claims accurate?

### 2. Logical Errors
- Does the conclusion follow from the premises?
- Are there logical contradictions between different parts of the response?
- Are implicit assumptions valid and stated?
- Does the reasoning handle edge cases correctly?
- Are there any circular reasoning patterns?
- Does the argument commit any known fallacies (straw man, false dichotomy, etc.)?

### 3. Completeness Errors
- Did I answer all parts of the user's question?
- Are there obvious aspects of the problem I didn't address?
- Are there important caveats or limitations I should mention?
- Did I cover all the items in a list the user asked about?
- Are there required dependencies or prerequisites I didn't mention?

### 4. Consistency Errors
- Is the terminology consistent throughout?
- Do examples match the claims being made?
- Is the tone and level of detail consistent?
- Do code examples actually run if executed?
- Are variable names and function names used consistently?
- Does the response contradict anything stated earlier in the conversation?

### 5. Calculation Errors
- Are all mathematical calculations correct?
- Are units consistent and correct (e.g., mixing KB and KB vs. KiB)?
- Are numerical results in a reasonable range?
- Were any steps skipped in the calculation?
- Are percentage calculations based on the correct base?
- Are currency conversions using current rates?

### 6. Code Errors
- Does the code actually accomplish the stated goal?
- Are there syntax errors, missing imports, undefined variables?
- Are edge cases handled (null, empty, out-of-bounds)?
- Is the code compatible with the stated language/framework version?
- Are there security vulnerabilities (injection, hardcoded secrets)?
- Does the code handle errors gracefully or fail silently?

### 7. Reasoning Errors
- Is the chain of thought valid from start to finish?
- Were any assumptions treated as facts?
- Is there a more direct or efficient way to reach the conclusion?
- Does the reasoning hold under the stated constraints?
- Would the reasoning change if input values were at their extremes?

## Self-Correction Workflow

### Phase 1: Re-Read the Original Request

Before reviewing the output, re-read what was actually asked:
1. What was the specific question or task?
2. What constraints or requirements were specified?
3. What level of detail was expected?

This prevents the common failure of "correctly" answering the wrong question.

### Phase 2: Systematic Category Review

Go through each error category. For each:
- Scan the output specifically for that category of error
- Mark any issues found
- Rate severity: **critical** (changes the answer), **moderate** (misleading), **minor** (cosmetic)

### Phase 3: Address Each Issue

For each issue found:
1. **Acknowledge it** — State clearly what was wrong. Don't hedge.
2. **Explain the fix** — Why is the corrected version better?
3. **Provide the correction** — Give the fixed version, not just a description of it.
4. **Check for cascading errors** — If one fact was wrong, did downstream reasoning depend on it?

### Phase 4: Re-Assess Confidence

After corrections:
- Overall confidence level (high/medium/low)
- Any remaining uncertainties
- Areas where the user should verify independently

## Advanced Techniques

### Technique 1: Adversarial Self-Review
Actively try to break your own output. Assume a hostile reviewer:
```
Adversarial review of my response:
1. What is the weakest claim I made? Can I defend it?
2. Where would a domain expert disagree with me?
3. What's the most embarrassing error I could have made?
4. If I had to argue the opposite position, what evidence would I use?
```
This catches errors that a friendly review misses because you're motivated to find flaws.

### Technique 2: Independent Re-Derivation
After producing an answer, solve the problem again from scratch without looking at your first answer, then compare:
```
**First pass:** {original reasoning} → {answer}
**Second pass (fresh):** {new reasoning} → {answer}
**Comparison:** {do they agree? if not, where do they diverge?}
```
This is the single most effective technique for catching calculation and logic errors.

### Technique 3: Boundary Testing
Test the output against edge cases and extreme values:
- What if the input is zero? Empty? Null? Maximum? Negative?
- What if the input is in a different language or format?
- What if the user is a beginner vs. expert — does the advice still hold?
- What if the scale is 10x larger or smaller?

### Technique 4: Source Tracing
For every factual claim in the output, mentally trace it to a source:
- "I stated X. Where does X come from? Is it in my training data? Is it current?"
- Flag any claims where you cannot identify a reliable source.
- For time-sensitive data (APIs, pricing, statistics), explicitly note the potential staleness.

### Technique 5: Code Execution Simulation
For code outputs, mentally (or actually) trace through execution:
- What happens on the first iteration? The last? An empty input?
- What happens if the external dependency is unavailable?
- What happens if the input has unexpected types (string instead of int)?
- Are all resources (files, connections, memory) properly cleaned up?

### Technique 6: Structural Consistency Audit
Check the response structure against its own internal logic:
- If I defined terms in an introduction, are they used consistently throughout?
- If I provided a numbered list of 5 items, do I reference all 5 in the conclusion?
- If I stated "there are 3 approaches," do I actually cover exactly 3?
- If I gave a table, do the column headers match the data descriptions?

### Technique 7: Confidence Calibration
Explicitly calibrate confidence by identifying the weakest link:
```
**Confidence decomposition:**
- Part A: {claim} — High confidence (well-established)
- Part B: {claim} — Medium confidence (based on inference, not direct knowledge)
- Part C: {claim} — Low confidence (could not verify, may be outdated)

**Overall confidence:** Medium — driven by uncertainty in Part C.
**User should verify:** {specific claims in Part C}
```

## Common Patterns (Real-World Examples)

### Pattern 1: Code Review Self-Correction
```
## Self-Correction: Code Review

**Original code provided:**
```python
def get_user(id):
    db = connect()
    user = db.query(f"SELECT * FROM users WHERE id = {id}")
    return user
```

**Issues found:**
1. [CRITICAL] Security: SQL injection via string interpolation in query.
   - Fix: Use parameterized queries.
2. [MODERATE] Resource leak: Database connection is never closed.
   - Fix: Use context manager (`with` statement) or explicit `db.close()`.
3. [MINOR] Shadowing: `id` shadows Python builtin.
   - Fix: Rename to `user_id`.

**Corrected code:**
```python
def get_user(user_id: int) -> dict:
    with connect() as db:
        user = db.query("SELECT * FROM users WHERE id = %s", (user_id,))
        return user
```

**Confidence: High** — All known issues addressed. User should verify the
parameterized query syntax matches their specific DB driver.
```

### Pattern 2: Factual Claim Verification
```
## Self-Correction: Factual Review

**Claims in original response:**
1. "Python 3.12 was released in October 2023" → ✅ Correct
2. "The GIL was removed in Python 3.12" → ❌ INCORRECT
   - Correction: The GIL was not removed. A PEP 703 was accepted to allow
     making the GIL optional (free-threaded mode), but it's opt-in and
     experimental. The GIL still exists by default.
3. "JavaScript is a compiled language" → ⚠️ PARTIALLY CORRECT
   - Nuance: Modern JS engines (V8) compile JS to machine code (JIT),
     but JavaScript is traditionally classified as an interpreted language.
     The classification depends on context.

**Corrected output:** {revised section with accurate claims}
**Confidence: High** after corrections.
```

### Pattern 3: Mathematical Verification
```
## Self-Correction: Calculation Review

**Original calculation:**
"If you invest $10,000 at 7% annual return for 20 years:
$10,000 × 1.07^20 = $10,000 × 3.87 = $38,700"

**Verification:**
1.07^20: Let me recalculate.
1.07^5 = 1.4025
1.07^10 = 1.4025^2 = 1.9672
1.07^20 = 1.9672^2 = 3.8697
$10,000 × 3.8697 = $38,697

**Issue:** [MINOR] Rounding. $38,697, not $38,700. Small difference but
in a financial context the precise number matters.

**Corrected:** $38,697 (or ~$38,700 if rounding is acceptable for the context).
**Confidence: High.**
```

### Pattern 4: Completeness Check on Multi-Part Question
```
## Self-Correction: Completeness Review

**User asked:** "Compare React, Vue, and Svelte for a new e-commerce project.
Consider performance, learning curve, and ecosystem."

**Original response covered:**
- ✅ Performance comparison
- ✅ Learning curve comparison
- ❌ Ecosystem comparison — MISSING
- ❌ Specific e-commerce context — only generic comparison

**Issues found:**
1. [MODERATE] Completeness: Did not address ecosystem as requested.
2. [MODERATE] Context: User specified e-commerce but I gave a generic comparison.

**Corrections added:**
- Ecosystem section covering: component libraries (React: most options,
  Vue: solid options, Svelte: fewer), e-commerce templates, payment integrations.
- E-commerce-specific recommendations for each framework.

**Confidence: High** after adding missing sections.
```

### Pattern 5: Logical Consistency in Advice
```
## Self-Correction: Logic Review

**Original response:**
"You should always use microservices for scalability.
Monolithic architectures don't scale. Start with microservices from day one."

**Logical issues found:**
1. [CRITICAL] Overgeneralization: "Always use microservices" is not sound advice.
   Many successful companies run monoliths at massive scale (Shopify, Stack Overflow).
2. [MODERATE] Contradiction with best practice: Most experienced architects recommend
   starting with a monolith and extracting services when needed.
3. [MINOR] Absolutist language: "always" and "don't" leave no room for context.

**Corrected position:**
"Start with a monolith. Extract microservices only when you have clear
boundary evidence (different scaling needs, different deployment cadences,
different teams). Premature microservices add complexity without benefit."

**Confidence: High** — corrected position aligns with industry consensus.
```

## Edge Cases & Pitfalls

1. **Defensive correction** — When the user points out an error, resisting or making excuses instead of just fixing it. Always thank the user and correct immediately.

2. **Over-correction** — Finding and "fixing" things that aren't actually wrong, which introduces new errors and erodes trust. Only flag genuine issues.

3. **Silent correction** — Fixing errors without acknowledging them, making it seem like the original was fine. Always show what changed and why.

4. **Selective review** — Only checking the categories where errors are obvious while skipping categories where subtle errors hide. Use the full 7-category checklist every time.

5. **Cascade blindness** — Fixing a surface-level error without checking whether downstream content depends on the error. If you correct a premise, re-derive every conclusion that followed from it.

6. **False confidence after correction** — Assuming that because you found and fixed 2 errors, there aren't more. Corrections don't guarantee completeness; they improve it.

7. **Reviewing the wrong thing** — Re-reading your own summary of what you said instead of the actual output. Always review the literal output, not your mental model of it.

8. **Anchoring on the first answer** — When re-deriving, unconsciously steering toward the first answer rather than truly starting fresh. Force yourself to begin from the problem statement, not from your previous conclusion.

9. **Severity miscalibration** — Marking a critical error as moderate because it's embarrassing to admit, or marking a cosmetic issue as critical because you want to appear thorough. Use the severity definitions consistently.

10. **Incomplete corrections** — Identifying the error and explaining it but not providing the actual corrected output. Always give the fixed version.

11. **Reviewing in isolation** — Checking the response against itself but not against the user's original question. Always re-read the question first.

12. **Time-sensitivity oversight** — Not flagging that factual claims may be outdated. For anything involving technology, APIs, pricing, regulations, or statistics, note the potential staleness.

13. **Code that "looks right" but isn't** — Syntax-valid code that has logical bugs (off-by-one, wrong comparison operator, missing null check). Always trace execution mentally, not just read the code.

14. **Agreeing with the user's incorrect correction** — When a user says something is wrong but they're actually mistaken. Politely explain why the original is correct rather than blindly agreeing.

## Integration with Related Skills

- **Chain-of-Thought** — CoT exposes intermediate steps, making it easier to identify where reasoning went wrong. See `chain-of-thought` skill.
- **Prompt Engineering** — Self-correction can be built into prompts: "After writing your answer, review it for errors before outputting." See `prompt-engineering` skill.
- **RAG Implementation** — RAG answers need correction for hallucination: verify every claim against the retrieved documents. See `rag-implementation` skill.
- **Fullstack Dev** — Code reviews in development workflows benefit from systematic self-correction. See `fullstack-dev` skill.

## Output Format Templates

### Template 1: Full Review with Corrections

```
## Self-Correction Review

### Issues Found

**1. [{severity}] {category}: {brief description}**
- **Location:** {where in the original output}
- **Problem:** {what was wrong}
- **Correction:** {the fix}

**2. [{severity}] {category}: {brief description}**
...

### Corrected Output
{the full revised response, or just the corrected sections if the output is long}

### Confidence Assessment
- **Errors corrected:** {count}
- **Remaining confidence:** {high/medium/low}
- **Unverified claims:** {anything the user should double-check}
```

### Template 2: No Errors Found

```
## Self-Correction Review

I reviewed the output across all error categories (factual, logical, completeness,
consistency, calculation, code, reasoning). **No issues found.**

**Confidence: High** — The output is accurate and complete as written.

**Checked:**
- [x] Factual accuracy
- [x] Logical consistency
- [x] Completeness (all parts of question answered)
- [x] Internal consistency
- [x] Calculations verified
- [x] Code correctness
- [x] Reasoning validity
```

### Template 3: Inline Correction (for short responses)

```
## Correction

**Original:** {what was said}
**Issue:** {what was wrong}
**Fixed:** {corrected version}

{any downstream impact}
```

### Template 4: Confidence Report (for uncertain outputs)

```
## Confidence Report

### Verified (High Confidence)
- {claim_1} ✅
- {claim_2} ✅

### Likely Correct (Medium Confidence)
- {claim_3} ⚠️ — {reason for reduced confidence}

### Unverified (User Should Check)
- {claim_4} ❓ — {what the user should verify and how}
- {claim_5} ❓ — {potential staleness or source uncertainty}

### Overall Confidence: {level}
### Recommended verification: {specific action for user}
```

## Principles

1. **Be honest about errors.** Finding and fixing your own mistakes builds trust more than pretending they don't exist.
2. **Be specific.** "I made an error" is useless. "The third code example was missing a closing bracket" is actionable.
3. **Prioritize critical errors.** Fix the ones that change the answer first.
4. **Don't over-correct.** If the output is fundamentally sound, say so. Don't nitpick to appear thorough.
5. **Learn patterns.** If you keep making the same type of error, call it out so the user knows to watch for it.
6. **Be proportional.** A 3-line correction for a 3-line error. Don't write more about the error than the error itself.
7. **Verify the fix.** After correcting, verify the correction is itself correct. Meta-correction matters.