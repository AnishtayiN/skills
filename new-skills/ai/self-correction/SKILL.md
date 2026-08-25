---
name: self-correction
description: >-
  Self-correction and error recovery for AI agents. Covers output validation, fact-checking,
  consistency checking, error detection, rollback strategies, quality gates, confidence scoring,
  iterative refinement, and systematic approaches to catching and fixing AI errors.
  خود-اصلاحی و بازیابی خطا برای عوامل هوش مصنوعی. شامل اعتبارسنجی خروجی،
  بررسی واقعیت، بررسی سازگاری، تشخیص خطا، استراتژی‌های بازگشت، دروازه‌های کیفیت،
  امتیازدهی اطمینان، و تکرار ظریف.
  AI智能体的自我纠错与错误恢复。涵盖输出验证、事实核查、一致性检查、错误检测、
  回滚策略、质量门控、置信度评分和迭代优化。包含系统性捕获和修复AI错误的方法。
---

# Self-Correction and Error Recovery

## Overview

Self-correction is the capability of an AI system to detect, diagnose, and fix its own errors without external intervention. It transforms a model from a one-shot generator into an iterative refinement engine that不断提高 output quality through internal feedback loops.

Self-correction addresses a fundamental limitation of LLMs: they generate text sequentially without the ability to "go back and fix" earlier mistakes. By building correction mechanisms into the agent's workflow, we create systems that catch errors before they propagate, verify claims against evidence, and refine outputs to meet quality standards.

The self-correction framework encompasses multiple layers: syntactic validation (is the output well-formed?), semantic verification (does it make sense?), factual accuracy (is it true?), logical consistency (does it contradict itself?), and alignment with intent (does it actually solve the problem?).

## When to Use This Skill

- **High-stakes outputs** — Legal documents, medical advice, financial analysis, safety-critical instructions
- **Multi-step reasoning** — When errors in early steps propagate to later steps
- **Factual generation** — Any output where incorrect facts have consequences
- **Code generation** — When generated code must compile and run correctly
- **Structured data extraction** — When output must conform to schemas or formats
- **User-facing responses** — Chatbots, assistants, and customer-facing AI systems
- **Regulated domains** — Healthcare, finance, legal where accuracy is legally required
- **Long-form generation** — When outputs are long enough that inconsistencies are likely
- **Multi-agent systems** — When agents must verify each other's outputs
- **Anything that would be embarrassing or costly if wrong**

## When NOT to Use This Skill

- **Real-time interactive responses** — Correction loops add latency that may be unacceptable in live conversation
- **Creative brainstorming** — Premature correction kills creative flow; generate first, evaluate later
- **Simple classification tasks** — If the model's first-attempt accuracy is high and errors are low-stakes
- **Temporary or disposable outputs** — Draft notes, throwaway examples, quick estimates
- **Tasks already solved by deterministic code** — If a function can compute the answer, don't use LLM self-correction
- **Extremely token-constrained environments** — When the token budget cannot accommodate correction loops

## Workflow

### Phase 1: Error Detection

1. **Syntactic validation** — Does the output match the required format? (JSON valid? Schema conforms? Length within bounds?)
2. **Semantic validation** — Does the output make logical sense? Are there contradictions or nonsensical statements?
3. **Fact verification** — Are factual claims correct? Cross-reference with known facts or provided context.
4. **Completeness check** — Does the output address all parts of the input? Are any requirements unmet?
5. **Consistency check** — Does the output contradict itself, earlier outputs, or known context?

### Phase 2: Error Classification

1. **Severity assessment** — Is this a critical error (factually wrong), moderate error (incomplete), or minor error (style/format)?
2. **Root cause analysis** — Did the error come from misunderstanding the task, insufficient context, model limitations, or ambiguity?
3. **Correctability assessment** — Can this error be fixed by rephrasing, or does it require a fundamentally different approach?
4. **Propagation risk** — Will this error cause downstream failures?
5. **Frequency assessment** — Is this a one-off error or a systematic failure pattern?

### Phase 3: Correction Strategy

1. **Targeted fix** — For minor errors, generate a specific correction for just the problematic part
2. **Regeneration** — For moderate errors, regenerate the affected section with additional constraints
3. **Full restart** — For critical errors, restart the generation with revised instructions
4. **External tool delegation** — For errors the model cannot fix (e.g., arithmetic), delegate to appropriate tools
5. **Human escalation** — When the model cannot determine the correct answer, flag for human review

### Phase 4: Quality Assurance

1. **Re-validate** — Run the same detection checks on the corrected output
2. **Regression check** — Ensure the fix didn't introduce new errors
3. **A/B comparison** — Compare original and corrected versions to confirm improvement
4. **Confidence update** — Adjust confidence score based on correction history
5. **Learning capture** — Record the error pattern for future prevention

## Advanced Techniques

### 1. Output Schema Validation with Repair

When the model generates structured output, validate it against a schema and use the validation error to guide correction:

```
# Step 1: Generate output
output = llm.generate("Extract user info from: {text}\nReturn JSON with name, email, age fields.")

# Step 2: Validate
errors = validate_json_schema(output, expected_schema)

# Step 3: Correct with error context
if errors:
    corrected = llm.generate("""
    Your previous output had validation errors:
    {errors}
    
    Original output: {output}
    
    Fix ONLY the errors listed above. Keep everything else the same.
    Return the corrected JSON.
    """)
```

### 2. Chain-of-Verification (CoVe)

Generate claims, then systematically verify each claim independently:

```
Step 1: Generate the response
"The Eiffel Tower is 330 meters tall, was completed in 1889, and was designed 
by Gustave Eiffel. It was originally intended to be temporary and was supposed 
to be demolished after 20 years."

Step 2: Extract individual claims
Claim 1: Eiffel Tower height = 330 meters
Claim 2: Completion year = 1889
Claim 3: Designer = Gustave Eiffel
Claim 4: Originally intended to be temporary
Claim 5: Supposed to be demolished after 20 years

Step 3: Verify each claim independently
Claim 1: VERIFIED (330m including antenna, 300m to roof — context-dependent)
Claim 2: VERIFIED (completed March 31, 1889)
Claim 3: VERIFIED (structural engineer, company was Eiffel et Cie)
Claim 4: VERIFIED (originally permitted for 20 years)
Claim 5: NEEDS CLARIFICATION (20-year permit, not explicitly "supposed to be demolished")

Step 4: Revise with verified claims only
"The Eiffel Tower stands 330 meters tall (including antenna), was completed in 1889, 
and was designed by Gustave Eiffel. It was originally permitted for only 20 years 
and was at risk of demolition."
```

### 3. Self-Consistency Checking

Generate the same answer multiple times and check for agreement:

```
Generate answer 3 times:
Run 1: "Python was created by Guido van Rossum in 1991"
Run 2: "Python was created by Guido van Rossum in 1991"  
Run 3: "Python was developed by Guido van Rossum, first released in 1991"

Consistency analysis:
- Creator: 3/3 agree on Guido van Rossum ✓
- Date: 3/3 agree on 1991 ✓
- Wording variation: "created" vs "developed" — trivial difference ✓

Result: HIGH confidence in all claims
```

If the runs disagreed, the disagreement indicates an area requiring additional verification.

### 4. Confidence-Calibrated Refinement

Only apply correction effort proportional to the risk of error:

```
Confidence Assessment Framework:

HIGH confidence (0.9-1.0): Output directly, no correction needed
- Pattern matching, well-known facts, simple transformations

MEDIUM confidence (0.6-0.9): Single verification pass
- Reasoning tasks, complex extraction, nuanced writing

LOW confidence (0.3-0.6): Multiple verification passes + external validation
- Multi-step reasoning, numerical calculations, ambiguous tasks

VERY LOW confidence (0.0-0.3): Flag for human review or use alternative approach
- Novel problems, high-stakes decisions, uncertain domain knowledge
```

### 5. Rollback with Checkpointing

For multi-step generation, save checkpoints and rollback on error:

```
Generation pipeline with checkpoints:

Step 1: Generate outline → CHECKPOINT_1
  ✓ Validation passed

Step 2: Generate section 1 (uses CHECKPOINT_1) → CHECKPOINT_2
  ✓ Validation passed

Step 3: Generate section 2 (uses CHECKPOINT_1, CHECKPOINT_2) → CHECKPOINT_3
  ✗ Validation failed: section contradicts outline

ROLLBACK to CHECKPOINT_1
  Retry Step 2 with added constraint: "Maintain consistency with outline point 3"
  
Step 2 (retry): → CHECKPOINT_2b
  ✓ Validation passed

Step 3 (retry): → CHECKPOINT_3b
  ✓ Validation passed
```

### 6. Rule-Based Guard Filters

Apply deterministic checks that catch common error patterns:

```
Guard Filters (applied to every output):

FILTER 1: Format Check
- If output should be JSON: parse JSON. If fails, regenerate.
- If output should be a list: check for list structure. If not, reformat.
- If output has max length: count tokens. If exceeds, truncate or regenerate shorter.

FILTER 2: Content Check
- If output should not contain PII: scan for email patterns, phone numbers, SSNs.
- If output should not mention competitors: scan for competitor names.
- If output should be factual: check for hedging language ("I think", "maybe", "might").

FILTER 3: Consistency Check
- If output should match a template: compare structure.
- If output references prior context: verify references are accurate.
- If output makes promises: check if promises are fulfillable.
```

### 7. Iterative Refinement with Evaluation Feedback

Use an evaluator model to provide structured feedback, then refine:

```
Round 1: Generate initial output
"Climate change causes more frequent extreme weather events."

Round 2: Evaluator provides structured feedback
{
  "accuracy": 7/10 — "Too vague; specify which types of extreme weather",
  "specificity": 4/10 — "No data, no examples, no citations",
  "actionability": 3/10 — "Doesn't tell the reader what to do",
  "tone": 8/10 — "Appropriate level of formality"
}

Round 3: Refine based on feedback
"Climate change is increasing the frequency and intensity of heatwaves, 
heavy precipitation events, and tropical cyclones. According to IPCC AR6, 
heatwaves have become 5x more likely since pre-industrial times. 
Organizations should: 1) Assess climate risks to operations, 2) Develop 
adaptation plans for extreme weather scenarios, 3) Reduce emissions to 
limit future warming."

Round 4: Re-evaluate
{
  "accuracy": 9/10 — "Specific claims, verifiable",
  "specificity": 8/10 — "Provides data and examples",
  "actionability": 8/10 — "Three concrete action items",
  "tone": 8/10 — "Consistent formality"
}

Acceptable quality reached. Finalize output.
```

## Common Patterns

### Pattern 1: The Pre-Flight Check

Validate output before sending to the user:

```python
def generate_with_preflight(prompt, constraints):
    # Generate
    output = llm.generate(prompt)
    
    # Pre-flight checks
    checks = {
        "format_valid": validate_format(output, constraints.format),
        "length_ok": len(output) <= constraints.max_length,
        "no_pii": not contains_pii(output),
        "no_hallucination_markers": not has_hedging(output),
        "schema_valid": validate_schema(output, constraints.schema),
    }
    
    failures = [k for k, v in checks.items() if not v]
    
    if not failures:
        return output
    
    # Correct failures
    corrected = llm.generate(f"""
    Fix the following issues in this output:
    Failures: {failures}
    Output: {output}
    Constraints: {constraints}
    """)
    
    # Re-validate
    rechecks = run_checks(corrected, constraints)
    if all(rechecks.values()):
        return corrected
    else:
        return flag_for_human_review(corrected, rechecks)
```

### Pattern 2: The Contrastive Correction

Show the model what's wrong by contrasting correct and incorrect versions:

```
Your output contains an error. Here is a comparison:

YOUR OUTPUT:
"The population of Tokyo is approximately 38 million people in the city proper."

CORRECT VERSION:
"The population of Tokyo is approximately 14 million in the city proper, 
or approximately 37 million in the greater metropolitan area."

The error: Conflating city proper population with metropolitan area population.

Please correct your output to distinguish between city and metropolitan populations.
```

### Pattern 3: The Decompose-and-Verify

Break a complex output into individual claims, verify each, then reassemble:

```
Original output: [complex multi-claim response]

Step 1 - Claim decomposition:
Claim A: [extracted claim 1]
Claim B: [extracted claim 2]
Claim C: [extracted claim 3]

Step 2 - Individual verification:
Claim A: ✗ INCORRECT — [correction needed]
Claim B: ✓ CORRECT
Claim C: ✓ CORRECT

Step 3 - Corrected output:
[Reassemble with corrected Claim A and verified Claims B and C]
```

### Pattern 4: The Confidence-Gated Pipeline

Route outputs through different verification depths based on confidence:

```python
def confidence_gated_pipeline(output, confidence_score):
    if confidence_score >= 0.9:
        # High confidence: direct output
        return output
    
    elif confidence_score >= 0.7:
        # Medium confidence: single verification pass
        verified = verify(output)
        if verified.is_correct:
            return output
        else:
            return correct_and_verify(output, verified.errors)
    
    elif confidence_score >= 0.4:
        # Low confidence: multiple verification passes
        for attempt in range(3):
            verified = verify(output)
            if verified.is_correct:
                return output
            output = correct(output, verified.errors)
        return flag_for_review(output)
    
    else:
        # Very low confidence: don't use this output
        return regenerate_with_different_approach(output)
```

### Pattern 5: The Feedback Loop Collector

Build persistent error tracking to improve over time:

```
Error Tracking Schema:
{
  "timestamp": "ISO-8601",
  "task_type": "classification|extraction|generation|reasoning",
  "error_type": "format|factual|logical|completeness|consistency",
  "severity": "critical|major|minor|cosmetic",
  "input_hash": "SHA-256 of input",
  "error_description": "human-readable description",
  "correction_applied": "what was done to fix it",
  "correction_successful": true/false,
  "root_cause": "hypothesis about why the error occurred",
  "prevention_rule": "rule to prevent this error class in future"
}

Use this data to:
1. Identify the most common error types
2. Build targeted guard filters for frequent errors
3. Improve prompts based on systematic failure patterns
4. Set appropriate confidence thresholds per task type
```

## Edge Cases & Pitfalls

### 1. **Over-Correction**
Correcting output too aggressively can degrade quality. If the original output is 95% correct, a correction pass might fix the 5% error while introducing new errors in the 95%. Measure net improvement, not just error count.

### 2. **Correction Cascades**
One correction can trigger a chain of corrections. Each pass modifies the output, which may violate different constraints, requiring another pass. Implement a maximum correction iteration limit (typically 2-3 rounds).

### 3. **False Positive Error Detection**
The correction system may flag correct outputs as errors. This is especially common with style preferences vs. actual errors. Distinguish between "I would write it differently" and "this is wrong."

### 4. **Confidence Calibration Drift**
Over time, the model's confidence scores may become miscalibrated — it becomes overconfident or underconfident. Regularly recalibrate using held-out test data.

### 5. **Correction Loop Instability**
Some outputs oscillate between two states during correction (A → B → A → B). Detect oscillation by comparing current and previous outputs; if they're too similar to the previous version, stop.

### 6. **Context Window Limitations on Verification**
For very long outputs, the verification step may not be able to hold the entire output in context. Use sliding window verification or chunk-based checking.

### 7. **Hallucination in Correction**
The correction process itself can introduce hallucinated "facts" to fix an error. Verify corrections with the same rigor as original outputs.

### 8. **Ignoring Legitimate Ambiguity**
Some outputs are legitimately ambiguous — multiple correct answers exist. The correction system should distinguish between "this is wrong" and "this is one valid interpretation."

### 9. **Cultural and Contextual Bias in Validation**
Validation rules may encode cultural biases. "Professional tone" may differ across cultures. Ensure validation criteria are reviewed for inclusivity.

### 10. **Latency vs. Quality Trade-off**
Each correction pass adds latency. For interactive applications, the cost of correction must be balanced against the user's tolerance for delay. Set hard time limits.

### 11. **Overfitting to Common Errors**
Building guards for frequent errors may make the system rigid and unable to handle novel inputs. Balance specificity of guards with general flexibility.

### 12. **Error Attribution Errors**
When a correction system identifies an error, it may misidentify the cause. If the root cause is wrong, the fix will be wrong. Invest in accurate error diagnosis.

### 13. **Dependency on External Fact Sources**
Fact-checking requires access to authoritative sources. If those sources are unavailable or outdated, fact-checking degrades. Plan for source unavailability.

### 14. **Multi-Language Correction Quality**
Correction quality may vary significantly across languages. Corrections in English are typically more reliable than in lower-resource languages.

### 15. **Systematic vs. Random Errors**
Systematic errors (always wrong in the same way) are easier to fix with guards. Random errors require probabilistic approaches. Misclassifying systematic errors as random wastes correction resources.

## Integration with Other Skills

| Related Skill | Integration Pattern | When to Combine |
|---|---|---|
| prompt-engineering | Design prompts with built-in self-correction instructions | When prompts should elicit self-aware outputs |
| chain-of-thought | Use CoT reasoning as a verification mechanism | When complex reasoning needs intermediate validation |
| brainstorming | Apply self-correction to evaluate and refine generated ideas | When ideation requires quality filtering |
| evaluation | Use evaluation metrics to drive correction decisions | Building automated quality assessment pipelines |
| deployment | Implement correction as a pre-deployment quality gate | Production systems requiring reliability guarantees |
| monitoring | Track correction rates and patterns for system health | Observability for AI system quality |

## Output Format Templates

### Standard Output Template

```markdown
## Self-Correction Report

### Original Output
[The initial generated output]

### Error Analysis
| Error # | Type | Severity | Description | Location |
|---------|------|----------|-------------|----------|
| 1 | [type] | [severity] | [description] | [where in output] |
| 2 | [type] | [severity] | [description] | [where in output] |

### Correction Applied
[Description of changes made]

### Corrected Output
[The final, corrected output]

### Verification
- All identified errors fixed: ✓/✗
- No new errors introduced: ✓/✗
- Output meets all constraints: ✓/✗

### Confidence Assessment
- Original confidence: [score]
- Corrected confidence: [score]
- Remaining uncertainty: [description]
```

### Quick Output Template

```
ORIGINAL: [brief summary]
ERRORS FOUND: [count] ([list types])
CORRECTED: [brief summary of changes]
CONFIDENCE: [before] → [after]
```

### Deep Output Template

```markdown
## Comprehensive Self-Correction Analysis

### Generation Context
- Task: [what was being generated]
- Input: [summarized input]
- Constraints: [all constraints]

### Error Taxonomy
#### Category 1: [error type]
- Occurrences: [count]
- Severity distribution: [critical/major/minor]
- Root cause: [analysis]
- Prevention: [how to avoid in future]

#### Category 2: [error type]
[...]

### Correction History
| Pass | Errors Found | Errors Fixed | New Errors | Net Improvement |
|------|-------------|-------------|------------|-----------------|
| 1 | 5 | 4 | 1 | +3 |
| 2 | 2 | 2 | 0 | +2 |
| 3 | 0 | - | - | Complete |

### Quality Metrics
- Accuracy: [score]
- Completeness: [score]
- Consistency: [score]
- Format compliance: [score]

### Recommendations
1. [Process improvement]
2. [Prompt modification]
3. [Guard filter addition]
```

### Agent Output Template

```json
{
  "correction_session": {
    "task_id": "string",
    "timestamp": "ISO-8601",
    "original_output": "string",
    "corrections": [
      {
        "pass": 1,
        "errors_detected": [
          {
            "type": "format|factual|logical|completeness|consistency",
            "severity": "critical|major|minor|cosmetic",
            "location": "string",
            "description": "string",
            "correction": "string"
          }
        ],
        "correction_applied": "string",
        "output_after_correction": "string"
      }
    ],
    "final_output": "string",
    "quality_scores": {
      "accuracy": 0.95,
      "completeness": 0.90,
      "consistency": 0.98,
      "format_compliance": 1.0
    },
    "confidence": {
      "before_correction": 0.6,
      "after_correction": 0.92
    },
    "total_correction_passes": 2,
    "correction_iterations_used": 2,
    "escalated_to_human": false
  }
}
```

## Rules

1. **Correct proportionally** — The effort spent on correction should match the stakes of the error. Don't spend 1000 tokens correcting a cosmetic issue.

2. **Verify before and after** — Always validate the original output AND the corrected output. Correction can introduce new errors.

3. **Set correction budgets** — Limit correction to a maximum number of passes (recommended: 2-3). Beyond that, escalate to human review or alternative approaches.

4. **Track error patterns** — Individual corrections are useful; patterns across corrections are transformative. Systematically log and analyze errors.

5. **Never trust correction blindly** — The correction process uses the same model that made the error. Apply verification to corrections with the same rigor as original outputs.

6. **Detect oscillation** — If an output bounces between states during correction, stop. Oscillation indicates the model is uncertain and cannot resolve the ambiguity.

7. **Separate "wrong" from "different"** — Not every alternative phrasing is an error. Correction should fix actual errors, not impose stylistic preferences.

8. **Use deterministic checks first** — Schema validation, format checks, and length limits are cheap and reliable. Run these before expensive LLM-based verification.

9. **Preserve what works** — When correcting an output, change only what's wrong. Don't rewrite the entire output to fix one sentence.

10. **Escalate when uncertain** — If the correction system cannot determine the correct answer, it should say so. A confident wrong answer is worse than an honest "I'm not sure."

11. **Consider correction latency** — In real-time systems, every correction pass adds delay. Design correction pipelines with strict time budgets.

12. **Build domain-specific guards** — Generic checks catch generic errors. Domain-specific guards (medical accuracy, legal citation format, code compilation) catch the errors that matter most.

13. **Test correction pipelines** — Don't assume the correction system works. Test it with known errors and verify it catches them.

14. **Document correction decisions** — When a correction is applied or skipped, log why. This aids debugging and improves the system over time.

15. **Know when to stop correcting** — Perfect is the enemy of good. If the output meets quality thresholds after one correction pass, ship it. Don't chase diminishing returns.
