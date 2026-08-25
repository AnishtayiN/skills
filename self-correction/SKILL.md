---
name: self-correction
description: >-
  Review, verify, and correct AI outputs including your own previous responses. Use this skill when the user mentions self correction, خود اصلاحی, review your output, check your work, verify your answer, double check, review this response, is this correct, did you make a mistake, look at this again, re-examine, self-verify, quality check, critique your answer, find errors in this, proofread, or when the user points out a potential error or asks you to reconsider a previous response. Additional triggers: اصلاح خود, بررسی پاسخ, تصحیح خود, آیا درسته, دوباره چک کن, اشکال نداره, validation, verification, quality assurance, error detection.
---

# Self-Correction Skill — Systematic Error Detection & Verification

## Overview

This skill provides a systematic framework for reviewing and correcting AI outputs — including your own. Self-correction is not about being defensive; it's about applying the same rigor you'd use when reviewing someone else's work. The key insight: most AI errors are catchable if you know what categories to check.

This skill covers error detection across all domains (code, math, logic, facts, language), confidence calibration, cascading error detection, and meta-cognitive strategies for improving accuracy.

## When to Use This Skill

- User explicitly asks you to review, verify, or double-check an output
- User points out a potential error or inconsistency
- You notice uncertainty in your own response
- The task involves factual claims that should be verified
- The output involves calculations, code, or logical reasoning
- User asks "is this correct?" or "did you miss anything?"

---

## Verification Checklists by Domain

### Code Verification Checklist

```markdown
□ Does the code actually accomplish the stated goal?
□ Are there syntax errors, missing imports, undefined variables?
□ Are edge cases handled (null, empty, out-of-bounds)?
□ Is the code compatible with the stated language/framework version?
□ Do all function calls match their signatures (correct arity and types)?
□ Are all variables defined before use?
□ Are all imports available in the stated environment?
□ Does the code handle errors gracefully (not just the happy path)?
□ Are string interpolations correct (no missing/extra variables)?
□ Are loops bounded (no infinite loops)?
□ Is async/await used correctly (no missing await, no blocking in async)?
□ Are there any off-by-one errors in loops or indexing?
□ Are return types consistent with the function's documented behavior?
□ Would this code pass a linter (no obvious style violations)?
```

### Math Verification Checklist

```markdown
□ Are all arithmetic operations correct?
□ Are units consistent throughout?
□ Are numerical results in a reasonable range?
□ Were any steps skipped in the calculation?
□ Are there division-by-zero risks?
□ Are floating-point comparisons using appropriate tolerance?
□ Are large numbers handled correctly (overflow, precision)?
□ Is the formula correct for the given problem?
□ Were all input values used correctly?
□ Is the answer reasonable (sanity check)?
```

### Logic Verification Checklist

```markdown
□ Does the conclusion follow from the premises?
□ Are there logical contradictions between different parts of the response?
□ Are implicit assumptions valid and stated?
□ Does the reasoning handle edge cases correctly?
□ Is the argument valid (if premises true, must conclusion be true)?
□ Is the argument sound (are the premises actually true)?
□ Are all necessary conditions checked?
□ Are conditions combined correctly (AND vs OR vs XOR)?
□ Are quantifiers correct (all vs some vs none)?
□ Is the reasoning free of common fallacies?
```

### Factual Verification Checklist

```markdown
□ Are all factual claims accurate? (Names, dates, statistics, terminology)
□ Are citations or references real and correctly attributed?
□ Are technical specifications correct (API names, parameter types, version numbers)?
□ Are historical dates and events correct?
□ Are numerical claims (percentages, counts) accurate?
□ Are proper nouns spelled correctly?
□ Are relationships between entities correct?
□ Is the information current (not outdated)?
□ Are statistics cited in proper context (not misleading)?
□ Can the user verify each claim independently?
```

### Language & Formatting Checklist

```markdown
□ Is the terminology consistent throughout?
□ Do examples match the claims being made?
□ Is the tone and level of detail consistent?
□ Are code examples actually runnable if executed?
□ Is grammar and spelling correct?
□ Are lists and bullet points properly formatted?
□ Are references and links correct?
□ Is the structure logical and easy to follow?
```

---

## Categories of Errors to Check

### 1. Factual Errors
- Are all factual claims accurate? (Names, dates, statistics, terminology)
- Are citations or references real and correctly attributed?
- Are technical specifications correct (API names, parameter types, version numbers)?

### 2. Logical Errors
- Does the conclusion follow from the premises?
- Are there logical contradictions between different parts of the response?
- Are implicit assumptions valid and stated?
- Does the reasoning handle edge cases correctly?

### 3. Completeness Errors
- Did I answer all parts of the user's question?
- Are there obvious aspects of the problem I didn't address?
- Are there important caveats or limitations I should mention?

### 4. Consistency Errors
- Is the terminology consistent throughout?
- Do examples match the claims being made?
- Is the tone and level of detail consistent?
- Do code examples actually run if executed?

### 5. Calculation Errors
- Are all mathematical calculations correct?
- Are units consistent and correct?
- Are numerical results in a reasonable range?
- Were any steps skipped in the calculation?

### 6. Code Errors
- Does the code actually accomplish the stated goal?
- Are there syntax errors, missing imports, undefined variables?
- Are edge cases handled (null, empty, out-of-bounds)?
- Is the code compatible with the stated language/framework version?

### 7. Reasoning Errors
- Did I confuse correlation with causation?
- Did I make a generalization from insufficient evidence?
- Did I confuse necessary and sufficient conditions?
- Did I commit a base rate neglect?
- Did I confuse similar-sounding concepts or terms?

---

## Confidence Calibration Techniques

### Confidence Levels

Use these calibrated confidence levels consistently:

| Level | Meaning | Action |
|-------|---------|--------|
| **High** (90-99%) | Strong evidence, well-established facts, verified calculations | Present as fact |
| **Medium** (60-89%) | Reasonable inference, likely correct but not verified | Present with "I believe" or "likely" |
| **Low** (30-59%) | Educated guess, significant uncertainty | Present as "possibly" or "it depends" |
| **Very Low** (<30%) | Speculative, limited evidence | Present as "I'm not sure, but..." |
| **Unknown** | Cannot assess confidence | Say "I don't know" |

### Confidence Signals

**High confidence indicators:**
- Fact is independently verifiable
- Calculation was done step-by-step with verification
- Code was tested or clearly correct from inspection
- Multiple independent sources agree

**Low confidence indicators:**
- Relying on memory without verification
- Extrapolating from limited examples
- Making claims about recent events (may be outdated)
- Complex multi-step calculation without verification
- Subtle code behavior that depends on runtime environment

### Confidence Statement Template

```
I'm [confidence level] that [claim] because [reasoning].

If I'm wrong about this, it's likely because [potential error source].
You can verify this by [verification method].
```

---

## Cascading Error Detection

When one error is found, check for cascading effects:

### Detection Process

```
Found Error #1
├── Did this error affect calculations downstream? → Check all derived values
├── Did this error affect logical conclusions? → Check all dependent reasoning
├── Did this error affect code examples? → Verify all code that uses this fact
└── Did this error affect recommendations? → Check if advice depends on the error
```

### Example: Cascading Error in a Math Explanation

```
Original (with error):
  "A triangle with sides 3, 4, 5 has area 6.
   The hypotenuse is 5.
   Using Pythagorean theorem: 3² + 4² = 5²
   So this is a right triangle.
   The perimeter is 12."

Error found: Area is correct (6), but let me verify...
  Area = 0.5 * base * height = 0.5 * 3 * 4 = 6 ✓
  Hypotenuse: √(9+16) = √25 = 5 ✓
  Perimeter: 3 + 4 + 5 = 12 ✓

No cascading errors — all downstream claims are independently verifiable.
```

### Example: Cascading Error in Code

```
Original (with error):
  "The function uses a HashMap for O(1) lookup.
   This makes the overall algorithm O(n).
   The space complexity is O(n)."

Error found: The code actually uses a list for lookup, not a HashMap.
  → Cascading check: Is the O(n) claim still correct?
  → If using list for lookup: O(n²) overall, not O(n)
  → Space complexity: O(1) extra space (no HashMap)
  → Recommendation: Change to HashMap for O(n) performance

  All three claims were affected by one error.
```

---

## Self-Correction Workflow

### Phase 1: Re-Read the Original Request

Before reviewing the output, re-read what was actually asked:
1. What was the specific question or task?
2. What constraints or requirements were specified?
3. What level of detail was expected?

This prevents the common failure of "correctly" answering the wrong question.

### Phase 2: Systematic Review

Go through each error category. For each:
- Scan the output specifically for that category of error
- Mark any issues found
- Rate severity: critical (changes the answer), moderate (misleading), minor (cosmetic)

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

---

## Real-World Self-Correction Examples

### Example 1: Code Error with Cascading Logic

```
Original output:
"The code sorts the array in O(n log n) time using quicksort.
Then it performs a linear scan, making the total O(n log n)."

Self-correction:
ISSUE: The code uses bubblesort, not quicksort. Bubblesort is O(n²).

Cascading check:
- The total time complexity is O(n²), not O(n log n)
- The recommendation to "use a more efficient sort" should instead be
  "replace bubblesort with quicksort or mergesort"

CORRECTED:
"The code sorts the array using bubblesort, which is O(n²).
Then it performs a linear scan, making the total O(n²).
To improve, replace bubblesort with quicksort (O(n log n))."
```

### Example 2: Factual Error in Explanation

```
Original output:
"The fetch API in JavaScript returns a Promise that resolves to a Response object.
The Response object has a .json() method that returns the parsed JSON."

Self-correction:
This is correct. ✓

But wait — let me verify completeness:
- Does .json() also return a Promise? YES — it returns Promise<any>
- The user might think .json() is synchronous

ADDITIONAL CLARIFICATION:
"Note: response.json() also returns a Promise, so you need to await it:
const data = await response.json();"
```

### Example 3: Math Error Detection

```
Original output:
"The area of a circle with radius 5 is 78.5 square units."

Self-correction:
Let me verify: A = π × r² = π × 25 = 78.5398...
78.5 is approximately correct, but let me be precise.

CORRECTED:
"The area of a circle with radius 5 is approximately 78.54 square units
(exactly 25π ≈ 78.5398...)."
```

---

## Meta-Cognitive Strategies

### Strategy 1: Think Before You Answer

Before generating a response:
1. Restate the problem in your own words
2. Identify what you know and what you don't know
3. Plan your approach before executing
4. Identify potential pitfalls

### Strategy 2: Verify Assumptions

Explicitly list assumptions:
- "I'm assuming X is true because..."
- "If X were actually Y, then the answer would be..."
- "This depends on the version of [library] being..."

### Strategy 3: Challenge Your Own Reasoning

Ask yourself:
- "What would someone who disagrees say?"
- "Is there a simpler explanation?"
- "What am I missing?"
- "Am I confusing two similar concepts?"

### Strategy 4: Decompose Complex Tasks

Break complex tasks into subtasks:
1. Solve each subtask independently
2. Verify each subtask's result
3. Combine results
4. Verify the combined result

### Strategy 5: Use Reference Checks

When making claims:
- Cite the specific API documentation, not "generally"
- Reference the exact function signature, not approximate
- Test code mentally or with small examples before presenting

---

## Output Format

When performing self-correction, present results in this structure:

```
## Self-Correction Review

### Issues Found

**1. [{severity}] {category}: {brief description}**
- **Location:** {where in the original output}
- **Problem:** {what was wrong}
- **Correction:** {the fix}

**2. [{severity}] {category}: {brief description}**
...

### Cascading Effects
- [List any downstream errors caused by each primary error]

### Corrected Output
{the full revised response, or just the corrected sections if the output is long}

### Confidence Assessment
- **Errors corrected:** {count}
- **Remaining confidence:** {high/medium/low}
- **Unverified claims:** {anything the user should double-check}
```

If no errors are found:

```
## Self-Correction Review

I reviewed the output across all error categories (factual, logical, completeness,
consistency, calculation, code, reasoning). **No issues found.**

**Confidence: High** — The output is accurate and complete as written.
```

---

## Principles

1. **Be honest about errors.** Finding and fixing your own mistakes builds trust more than pretending they don't exist.
2. **Be specific.** "I made an error" is useless. "The third code example was missing a closing bracket" is actionable.
3. **Prioritize critical errors.** Fix the ones that change the answer first.
4. **Don't over-correct.** If the output is fundamentally sound, say so. Don't nitpick to appear thorough.
5. **Learn patterns.** If you keep making the same type of error, call it out so the user knows to watch for it.
6. **Check for cascading errors.** One error often affects multiple downstream claims.
7. **Calibrate confidence.** Don't be overconfident about uncertain claims or underconfident about verified ones.

## Common Pitfalls to Avoid

- **Don't be defensive.** If the user catches an error, thank them and fix it.
- **Don't correct things that aren't wrong.** Only flag genuine issues.
- **Don't silently fix and pretend nothing happened.** Show the correction transparently.
- **Don't trust your memory.** Re-read the actual output and the actual question before judging.
- **Don't skip categories.** A response can be factually correct but logically flawed, or logically sound but incomplete.
- **Don't confuse confidence with correctness.** You can be confident and wrong. Always verify.
- **Don't ignore the user's feedback.** If they point out something, it deserves careful consideration even if you initially think you're correct.
