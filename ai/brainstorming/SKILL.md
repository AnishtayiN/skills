---
name: brainstorming
description: >-
  Structured brainstorming and ideation using SCAMPER technique, inversion thinking,
  constraint removal, analogy mapping, pareto front analysis, six thinking hats,
  mind mapping, decision matrices, and systematic creative problem-solving frameworks.
  Includes when to use and when NOT to use structured brainstorming.
  طوفان فکری ساختاریافته و ایده‌پردازی با تکنیک SCAMPER، تفکر وارونه، حذف محدودیت‌ها،
  نگاشت قیاسی، تحلیل جلوی پارتو، کلاه‌های شش‌گانه تفکر، نقشه ذهنی و ماتریس‌های تصمیم‌گیری.
  结构化头脑风暴与创意生成，涵盖SCAMPER技术、逆向思维、约束消除、类比映射、
  帕累托前沿分析、六顶思考帽、思维导图和决策矩阵。包含何时使用以及何时不使用结构化头脑风暴。
  结构化头脑风暴和创意激发技术，包含SCAMPER方法、反转思维、约束移除、类比映射、
  帕累托前沿分析、六顶思考帽、思维导图和决策矩阵，以及系统性创意问题解决框架。
priority: P2
dependencies: [requirement-analysis]
conflicts: []
---

# Structured Brainstorming and Ideation

## Overview

Structured brainstorming transforms the chaotic process of idea generation into a systematic, reproducible methodology. Unlike unstructured brainstorming — which often devolves into the loudest voice dominating or the first idea winning — structured approaches ensure diverse idea spaces are explored, cognitive biases are mitigated, and the best ideas are rigorously selected.

This skill provides a toolkit of brainstorming techniques, each optimized for different types of creative challenges. Some techniques work by removing mental constraints (constraint removal, inversion), others by forcing unexpected connections (analogy mapping, SCAMPER), and others by systematically exploring decision spaces (pareto front analysis, decision matrices).

The core principle: creativity is not magic. It is a skill that can be structured, practiced, and improved. These techniques make the creative process transparent, auditable, and effective.

## When to Use This Skill

- **Product design** — New features, product direction, UX improvements
- **Strategic planning** — Business strategy, market positioning, competitive response
- **Problem-solving** — When standard approaches have failed and novel solutions are needed
- **Process improvement** — Optimizing workflows, reducing inefficiency, automating manual tasks
- **Content creation** — Blog posts, marketing campaigns, educational materials
- **Architecture design** — System design, API design, infrastructure planning
- **Team facilitation** — Leading brainstorming sessions for groups
- **Innovation workshops** — Structured ideation in corporate or startup settings
- **Personal projects** — When you're stuck and need fresh perspectives
- **Decision-making** — When multiple viable options exist and you need to explore them systematically

## When NOT to Use This Skill

- **Simple problems with known solutions** — If the answer is straightforward, brainstorming adds unnecessary overhead
- **Urgent crises** — When speed matters more than thoroughness, act first, brainstorm later
- **Data-driven decisions** — When the answer is clearly in the data, analyze the data instead of generating alternatives
- **Problems requiring expertise, not creativity** — Some problems need a specialist, not new ideas
- **When the team is too small** — Some techniques require diverse perspectives that a solo practitioner cannot provide
- **Highly constrained problems** — When there's only one viable option, exploring alternatives wastes time
- **Implementation phase** — Brainstorming should happen before implementation; switching between modes reduces effectiveness

## Workflow

### Phase 1: Problem Framing

1. **Define the challenge precisely** — A well-framed problem is half-solved. Use "How might we..." or "What if..." formulations.
2. **Identify stakeholders** — Who is affected by this problem? Who will be affected by the solution?
3. **Establish constraints** — What are the non-negotiable requirements? What are the soft preferences?
4. **Set success criteria** — How will you know when you've found a great solution?
5. **Choose the right technique** — Match the brainstorming method to the problem type (see technique selection guide below).

### Phase 2: Idea Generation

1. **Divergent thinking phase** — Generate as many ideas as possible without judgment. Quantity over quality initially.
2. **Apply the chosen technique systematically** — Follow the technique's steps precisely. Don't skip steps or jump to favorites.
3. **Build on others' ideas** — "Yes, and..." not "No, but..."
4. **Push past the obvious** — The first 10 ideas are usually conventional. Ideas 11-50 are where innovation lives.
5. **Record everything** — Every idea, no matter how seemingly absurd, gets recorded. Today's absurd idea is tomorrow's breakthrough.

### Phase 3: Idea Convergence

1. **Group related ideas** — Cluster similar ideas into themes or categories
2. **Evaluate against criteria** — Apply your success criteria from Phase 1
3. **Use structured evaluation** — Decision matrices, pareto analysis, or six thinking hats
4. **Identify top candidates** — Select 3-5 ideas for deeper exploration
5. **Synthesize combinations** — The best solution often combines elements of multiple ideas

### Phase 4: Refinement and Selection

1. **Deep dive on top candidates** — Flesh out the details of each promising idea
2. **Stress-test** — What could go wrong? What are the failure modes?
3. **Prototype (mental or physical)** — Make the idea concrete enough to evaluate
4. **Final selection** — Choose the best approach using decision matrices or group consensus
5. **Action plan** — Define next steps, owners, and timelines

## Advanced Techniques

### 1. SCAMPER Method

SCAMPER is a structured checklist of creative thinking prompts, each letter standing for an operation you can apply to existing products, processes, or ideas:

- **S**ubstitute — What can be replaced? (materials, people, processes)
- **C**ombine — What can be merged with something else?
- **A**dapt — What can be borrowed or adapted from another domain?
- **M**odify/Magnify — What can be changed in scale, shape, or form?
- **P**ut to other use — Can this be used for something entirely different?
- **E**liminate — What can be removed or simplified?
- **R**everse/Rearrange — What if we did the opposite or reordered steps?

```
SCAMPER Applied to: "Improve a coffee shop experience"

Substitute: Replace paper cups with reusable mugs (membership program)
Combine: Coffee shop + coworking space = "work café"
Adapt: Borrow library's quiet zones → "silent coffee corners"
Modify: Magnify the loyalty program → tier-based rewards with exclusive blends
Put to other use: Coffee shop space during off-hours → evening events, workshops
Eliminate: Remove the counter entirely → table-side ordering via app
Reverse: Instead of customers coming to the shop, the shop comes to customers (mobile coffee cart)

Top ideas: Coworking hybrid, mobile cart fleet, app-based table service
```

### 2. Inversion Thinking

Instead of asking "How do I succeed?" ask "How do I guarantee failure?" Then invert those failure modes into success strategies.

```
Problem: "How do we build a great developer experience?"

Inversion — "How would we guarantee TERRIBLE developer experience?"
1. Make the documentation incomplete and outdated
2. Require 47 configuration steps before anything works
3. Give cryptic error messages with no suggestions
4. Break backward compatibility with every release
5. Make the API inconsistent (different patterns for similar operations)
6. Never respond to community issues or feedback
7. Provide no examples or tutorials

Inversion to success strategies:
1. Keep documentation current with automated freshness checks
2. Minimize setup to ≤3 steps with sensible defaults
3. Write helpful error messages with suggested fixes
4. Follow semantic versioning strictly
5. Design a consistent API pattern and stick to it
6. Respond to issues within 24 hours
7. Provide comprehensive examples for every feature

Result: A concrete, actionable improvement roadmap derived from failure avoidance.
```

### 3. Constraint Removal (Temporal or Forced)

Deliberately remove constraints that seem fundamental to see what remains:

```
Original problem: "How can we reduce customer support costs?"

Constraint removal exercise:
Remove TIME constraint: "What if response time didn't matter?"
→ Fully automated solutions become viable → chatbots, self-service portals

Remove BUDGET constraint: "What if money were no object?"
→ Hire 10x more support staff → doesn't help, still expensive
→ But: build a perfect knowledge base with AI search → proactive issue prevention

Remove TECHNOLOGY constraint: "What if we could only use phone and paper?"
→ Radical simplification of products → fewer support needs
→ Hire local support in every market → expensive but excellent

Remove STAFFING constraint: "What if we had no support staff?"
→ Community-driven support → forums, peer-to-peer help
→ Perfect documentation → zero-contact resolution

Key insight: The most innovative solutions came from removing the technology and 
staffing constraints, suggesting investment in self-service and community would 
have the highest ROI.
```

### 4. Analogy Mapping

Systematically map solutions from unrelated domains to your problem:

```
Problem: "How to manage a growing microservices architecture?"

Source Domain 1: City planning
- City zoning → Service domain boundaries
- Highway system → Service mesh / API gateway
- Emergency services → Circuit breakers, health checks
- City budget → Resource allocation per service
- Building codes → API standards, design patterns
- Building inspectors → Automated testing, code review

Source Domain 2: Ecosystem biology
- Food web → Service dependency graph
- Keystone species → Critical services that many depend on
- Biodiversity → Technology diversity (right-sized)
- Carrying capacity → Maximum load each service can handle
- Symbiosis → Services that benefit from co-location
- Invasive species → Rogue services that consume excessive resources

Source Domain 3: Military logistics
- Supply chain → Deployment pipeline
- Forward operating base → Edge computing / CDNs
- Intelligence gathering → Monitoring and observability
- Communication protocol → Service-to-service protocols
- Redundancy → High availability, failover

Insight: City planning is the most productive analogy because both systems 
involve independent entities following standards, interacting through defined 
channels, with centralized governance and distributed execution.
```

### 5. Pareto Front Analysis

When facing multi-objective optimization, identify the Pareto front — solutions where no objective can be improved without worsening another:

```
Problem: Choose a cloud architecture balancing Cost, Performance, and Reliability.

Options evaluated:
A: Static hosting → Cost: $, Performance: ★★, Reliability: ★★
B: Basic cloud → Cost: $$, Performance: ★★★, Reliability: ★★★
C: Premium cloud → Cost: $$$, Performance: ★★★★★, Reliability: ★★★★★
D: Over-engineered → Cost: $$$$$, Performance: ★★★★★, Reliability: ★★★★★
E: Cheapest possible → Cost: $, Performance: ★, Reliability: ★

Pareto front: A, B, C (D is dominated by C; E is dominated by A)

A → B: +Performance +Reliability, -Cost (moderate)
B → C: +Performance +Reliability, -Cost (significant)

Decision: B dominates for most scenarios. C only if maximum performance/reliability 
justifies the cost premium. A only if budget is the absolute constraint.

Not on Pareto front: D (over-engineered, dominated by C) and E (too cheap, dominated by A)
```

### 6. Six Thinking Hats

Edward de Bono's framework for structured parallel thinking, where each "hat" represents a different thinking mode:

```
Problem: "Should we launch our AI product now or delay 3 months?"

⚪ WHITE HAT (Facts/Data):
- 78% of features are complete
- 3 competitor products launching in next 6 months
- Current customer satisfaction: 72%
- Technical debt level: moderate (estimated 6 weeks to address)
- Beta feedback: 4.2/5.0 rating

🔴 RED HAT (Emotions/Intuition):
- Team feels anxious about the current state
- Leadership is excited about market timing
- Customers are asking for the product
- Gut feeling: launch now, iterate fast

⚫ BLACK HAT (Caution/Risk):
- Incomplete features may cause churn
- Technical debt could cause production issues
- Reputation damage if launch is buggy
- Support team may be overwhelmed
- Security vulnerabilities in rushed code

🟡 YELLOW HAT (Optimism/Benefits):
- Early market entry captures mindshare
- Real user feedback more valuable than internal testing
- Revenue starts flowing immediately
- Team morale from shipping
- Competitive pressure on rivals

🟢 GREEN HAT (Creativity/Alternatives):
- Soft launch to 10% of users now, full launch in 3 months
- Launch with "beta" label, manage expectations
- Launch core features now, announce roadmap for remaining
- Launch now but with dedicated rapid-response team
- Delay 6 weeks (compromise) to address top 3 technical debt items

🔵 BLUE HAT (Process/Control):
- Decision needed by Friday for marketing timeline
- Need input from: engineering, product, marketing, support
- Evaluate Green hat options against Black hat risks
- Decision framework: risk-adjusted value of early vs. late launch

SYNTHESIS: Option 3 (Launch core features now, announce roadmap) balances 
market timing with quality concerns. It captures early revenue while 
maintaining credibility.
```

### 7. Mind Mapping for Idea Exploration

Create visual, non-linear representations of the problem space to discover unexpected connections:

```
Central Node: "Improve Developer Onboarding"

Branch 1: FIRST DAY
├── Account setup automation
├── Welcome package (digital)
├── Buddy assignment
├── Development environment setup
└── First task assignment

Branch 2: FIRST WEEK
├── Architecture overview sessions
├── Codebase walkthrough
├── Write first PR (guided)
├── Meet key stakeholders
└── Understand deployment process

Branch 3: FIRST MONTH
├── Complete starter project
├── Participate in code review
├── Understand monitoring/alerting
├── Join on-call rotation (shadow)
└── 1:1 with engineering manager

Branch 4: TOOLS & AUTOMATION
├── Dev environment: Docker Compose / Nix
├── IDE setup: pre-configured dotfiles
├── CI/CD: automated pipeline per repo
├── Documentation: search-enabled wiki
└── Knowledge: recorded architecture talks

Branch 5: METRICS
├── Time to first commit
├── Time to first deployed change
├── 30-day retention rate
├── Onboarding satisfaction survey
└── Time to independent contribution

Cross-connections:
- "Dev environment setup" connects to "First day" AND "Tools & Automation"
- "First PR" connects to "First week" AND "CI/CD"
- "Architecture overview" connects to "First week" AND "Knowledge"

Emergent insight: Automation of dev environment setup would improve both 
Day 1 experience and Week 1 productivity — high-leverage investment.
```

## Common Patterns

### Pattern 1: The Brainstorm-Then-Evaluate Pipeline

```python
def structured_brainstorm(problem, technique, num_ideas=30):
    # Phase 1: Generate ideas using the chosen technique
    ideas = []
    for round in range(num_ideas // 5):  # 5 ideas per round
        batch = llm.generate(f"""
        Problem: {problem}
        Technique: {technique}
        
        Generate 5 NEW ideas that are different from previously generated ideas:
        {format_ideas(ideas)}
        
        Push beyond conventional thinking. Ideas #{len(ideas)+1} to #{len(ideas)+5}:
        """)
        ideas.extend(parse_ideas(batch))
    
    # Phase 2: Evaluate and rank
    ranked = llm.generate(f"""
    Evaluate each idea against these criteria:
    1. Feasibility (1-5): Can we actually do this?
    2. Impact (1-5): How much value would this create?
    3. Novelty (1-5): How different is this from existing approaches?
    4. Risk (1-5, inverted): How low is the risk?
    
    Ideas: {format_ideas(ideas)}
    
    Score each idea and rank from best to worst.
    """)
    
    return ranked
```

### Pattern 2: The How-Might-We (HMW) Question Generator

```
Break a big problem into focused, actionable questions:

BIG PROBLEM: "Our mobile app has poor user retention"

HMW QUESTIONS:
1. HMW make the first-time experience so compelling users return naturally?
2. HMW create habits that bring users back daily without notifications?
3. HMW make the app valuable enough that users recommend it to others?
4. HMW reduce friction so users accomplish their goals in under 30 seconds?
5. HMW make users feel they're losing something by not opening the app?
6. HMW turn passive users into active contributors?
7. HMW make the app adapt to individual users over time?
8. HMW create social proof that encourages continued use?

Each HMW question becomes a focused brainstorming session.
```

### Pattern 3: The Concept Combination Matrix

```
Combine concepts from different columns to generate novel ideas:

             │ Technology A    │ Technology B    │ Technology C
─────────────┼─────────────────┼─────────────────┼────────────────
Business A   │ A1+A: Idea 1   │ A1+B: Idea 2   │ A1+C: Idea 3
Business B   │ A2+A: Idea 4   │ A2+B: Idea 5   │ A2+C: Idea 6
Business C   │ A3+A: Idea 7   │ A3+B: Idea 8   │ A3+C: Idea 9

Example: 
Rows: [Subscription model, Marketplace, Freemium]
Columns: [AI, Blockchain, AR/VR]

AI + Subscription = Personalized AI assistant as subscription
Blockchain + Marketplace = Decentralized creator marketplace
AR/VR + Freemium = Free AR try-on, premium VR experiences

Matrix forces consideration of combinations you'd never encounter naturally.
```

### Pattern 4: The Reverse Brainstorm

```
Instead of solving the problem, brainstorm how to CAUSE the problem:

Problem: "How to improve customer satisfaction?"

Reverse: "How to MAXIMALLY DISSATISFY customers?"

Ideas to maximize dissatisfaction:
1. Make them wait on hold for 30+ minutes
2. Never resolve their issue on first contact
3. Give contradictory information each time they call
4. Make the return process require 15 steps
5. Charge hidden fees they discover after purchase
6. Never acknowledge their loyalty or history
7. Make cancellation easier than getting support
8. Use automated responses that never address their actual issue

Now INVERT each:
1. Offer callback option so they never wait → implement callback system
2. Empower agents to fully resolve on first contact → first-contact resolution
3. Maintain a single source of truth for agents → unified knowledge base
4. One-click returns with prepaid label → simplified return process
5. Transparent pricing with no hidden fees → pricing transparency
6. Personalize interactions with customer history → CRM integration
7. Make getting support easier than cancelling → proactive support
8. Ensure every response addresses the specific issue → intent recognition

Result: Concrete improvement roadmap derived from failure inversion.
```

### Pattern 5: The Decision Matrix with Weighted Criteria

```python
def weighted_decision_matrix(options, criteria, weights):
    """
    options: list of alternative solutions
    criteria: list of evaluation criteria
    weights: importance weight for each criterion (sum to 1.0)
    """
    
    # Example evaluation
    matrix = {
        "Option A: Build in-house": {
            "Cost": 3,          # 1-5 scale, 5=best
            "Time to market": 2,
            "Customization": 5,
            "Maintenance burden": 2,
            "Team expertise": 4,
        },
        "Option B: Buy SaaS": {
            "Cost": 4,
            "Time to market": 5,
            "Customization": 2,
            "Maintenance burden": 5,
            "Team expertise": 3,
        },
        "Option C: Open source + customize": {
            "Cost": 4,
            "Time to market": 3,
            "Customization": 4,
            "Maintenance burden": 3,
            "Team expertise": 3,
        }
    }
    
    weights = {
        "Cost": 0.25,
        "Time to market": 0.30,
        "Customization": 0.20,
        "Maintenance burden": 0.15,
        "Team expertise": 0.10,
    }
    
    # Calculate weighted scores
    scores = {}
    for option, ratings in matrix.items():
        score = sum(ratings[c] * weights[c] for c in criteria)
        scores[option] = round(score, 2)
    
    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    return ranked

# Result:
# Option B: Buy SaaS = 4.15
# Option C: Open source + customize = 3.35
# Option A: Build in-house = 3.05
```

## Edge Cases & Pitfalls

### 1. **Groupthink in Team Brainstorming**
In group settings, social pressure leads to convergence on the first or most popular idea. Use anonymous idea generation before group discussion, and assign a "devil's advocate" role.

### 2. **Anchoring Bias**
The first idea presented disproportionately influences all subsequent ideas. Mitigate by generating ideas independently before sharing, or by explicitly asking for alternatives to the first idea.

### 3. **Ideas Without Action**
Brainstorming without follow-through is entertainment, not work. Every brainstorming session must end with assigned owners, next steps, and deadlines.

### 4. **Premature Evaluation**
Judging ideas during the generation phase kills creativity. Enforce strict separation between divergent (generation) and convergent (evaluation) phases.

### 5. **Technique-Problem Mismatch**
Using the wrong technique wastes time. SCAMPER works best for modifying existing products; it's less useful for inventing entirely new categories. Match technique to problem type.

### 6. **Echo Chamber Effect**
If the brainstorming group has similar backgrounds and perspectives, ideas will be narrow. Actively seek diverse viewpoints or use analogy mapping to import ideas from different domains.

### 7. **Analysis Paralysis**
Having too many options without clear selection criteria leads to indecision. Define evaluation criteria BEFORE brainstorming, so selection is systematic.

### 8. **Over-Reliance on a Single Technique**
Different techniques explore different parts of the idea space. Using only one technique leaves large areas unexplored. Combine 2-3 complementary techniques.

### 9. **Confirmation Bias in Evaluation**
Evaluators tend to favor ideas that confirm their existing beliefs. Use blind evaluation (hide idea origins) or structured evaluation criteria to reduce bias.

### 10. **Scale Mismatch**
Brainstorming solutions that are too large (enterprise-level) or too small (trivial fixes) for the problem. Keep solutions proportional to the problem's scope.

### 11. **Ignoring Constraints Too Long**
Constraint removal is a technique, not a lifestyle. After generating unconstrained ideas, reality-check them against actual constraints before selecting.

### 12. **Idea Theft and Attribution**
In team settings, credit for ideas matters for morale. Record who contributed which ideas and ensure proper attribution.

### 13. **Reinventing the Wheel**
Before finalizing an idea, check if it's been tried before (and why it succeeded or failed). Novelty for its own sake is wasteful.

### 14. **Scope Creep During Brainstorming**
Brainstorming sessions can expand the problem scope as new angles are discovered. The facilitator must maintain focus on the original problem statement.

### 15. **Survivorship Bias in Inspiration**
When using analogy mapping, you tend to draw from successful examples. Also consider failed attempts — they contain valuable lessons about what doesn't work.

## Integration with Other Skills

| Related Skill | Integration Pattern | When to Combine |
|---|---|---|
| chain-of-thought | Use CoT to evaluate and compare generated ideas | When ideas need rigorous analysis before selection |
| prompt-engineering | Design prompts that elicit diverse, creative responses | Building brainstorming systems that reliably generate novel ideas |
| self-correction | Apply validation to ensure generated ideas are feasible | When idea quality control is needed |
| evaluation | Systematic comparison of candidate solutions | Final selection phase of brainstorming |
| planning | Convert selected ideas into actionable plans | Post-brainstorming execution |
| deployment | Implement the winning idea as a production system | Moving from ideation to implementation |

## Output Format Templates

### Standard Output Template

```markdown
## Brainstorming Report

### Challenge Statement
[Clear, concise statement of the problem or opportunity]

### Brainstorming Session Details
- **Technique(s) Used:** [list techniques]
- **Participants:** [list or "solo"]
- **Duration:** [time spent]
- **Ideas Generated:** [count]

### Ideas by Theme

#### Theme 1: [name]
| # | Idea | Feasibility | Impact | Novelty | Score |
|---|------|------------|--------|---------|-------|
| 1 | [idea] | [1-5] | [1-5] | [1-5] | [calculated] |
| 2 | [idea] | [1-5] | [1-5] | [1-5] | [calculated] |

#### Theme 2: [name]
[...]

### Top Recommendations
1. **[Best idea]** — [1-sentence description] — [why it wins]
2. **[Second best]** — [description] — [strengths and trade-offs]
3. **[Third best]** — [description] — [when this might be preferred]

### Decision Matrix Summary
[Final ranking with weighted scores]

### Next Steps
- [ ] [Action item 1] — Owner: [name] — Due: [date]
- [ ] [Action item 2] — Owner: [name] — Due: [date]
- [ ] [Action item 3] — Owner: [name] — Due: [date]
```

### Quick Output Template

```
CHALLENGE: [problem statement]
TECHNIQUE: [primary technique used]
TOP IDEA: [one-line description]
WHY: [reason it wins]
ALTERNATIVE: [backup idea if top fails]
NEXT STEP: [immediate action]
```

### Deep Output Template

```markdown
## Comprehensive Brainstorming Analysis

### Problem Analysis
[Detailed problem decomposition and stakeholder mapping]

### Technique Application Details
#### Technique 1: [name]
[How it was applied, what was discovered, key insights]

#### Technique 2: [name]
[How it was applied, what was discovered, key insights]

### Complete Idea Inventory
[All ideas organized by theme, with initial scores]

### Evaluation Framework
- Criteria: [list with definitions]
- Weights: [how weights were determined]
- Scoring methodology: [how scores were assigned]

### Pareto Analysis
[Which options are on the Pareto front and why]

### Risk Assessment per Option
| Option | Risk | Mitigation | Residual Risk |
|--------|------|-----------|---------------|
| [option] | [risk] | [mitigation] | [remaining] |

### Sensitivity Analysis
[How results change if criteria weights shift]

### Recommendation with Justification
[Final recommendation with comprehensive rationale]
```

### Agent Output Template

```json
{
  "brainstorming_session": {
    "challenge": "string",
    "techniques_applied": ["SCAMPER", "inversion", "six_hats"],
    "ideas_generated": [
      {
        "id": 1,
        "description": "string",
        "theme": "string",
        "technique_origin": "string",
        "scores": {
          "feasibility": 4,
          "impact": 5,
          "novelty": 3,
          "risk_adjusted": 4
        },
        "weighted_score": 4.2,
        "risks": ["string"],
        "dependencies": ["string"]
      }
    ],
    "evaluation": {
      "criteria": [
        {"name": "feasibility", "weight": 0.3},
        {"name": "impact", "weight": 0.4},
        {"name": "novelty", "weight": 0.15},
        {"name": "risk", "weight": 0.15}
      ],
      "pareto_front": [2, 5, 8],
      "top_recommendations": [2, 5]
    },
    "action_items": [
      {
        "description": "string",
        "owner": "string",
        "due_date": "ISO-8601",
        "related_idea_id": 2
      }
    ],
    "session_metrics": {
      "total_ideas": 35,
      "unique_themes": 6,
      "techniques_used": 3,
      "time_spent_minutes": 45
    }
  }
}
```

## Rules

1. **Separate generation from evaluation** — Never judge ideas during the brainstorming phase. Generate freely, evaluate later. Mixing these modes kills creativity.

2. **Quantity enables quality** — You cannot select the best idea from a pool of three. Aim for 30+ ideas before starting evaluation. The best idea is often #27.

3. **Defer judgment explicitly** — In team settings, make "no judgment during generation" an explicit rule. Bad ideas often contain seeds of great ones.

4. **Use multiple techniques** — Each technique explores a different part of the idea space. Using at least 2-3 techniques ensures broader coverage.

5. **Make ideas concrete** — "Better UX" is not an idea. "One-click checkout with Apple Pay integration" is an idea. Push for specificity.

6. **Record everything** — Every idea should be documented immediately. Memory is unreliable, and ideas that aren't recorded are lost.

7. **Build on others' ideas** — Use "Yes, and..." not "No, but..." during generation. Combining ideas creates novel solutions that neither contributor would have reached alone.

8. **Assign ownership** — An idea without an owner is a wish, not a plan. Every selected idea must have a named owner and a next step.

9. **Set time limits** — Open-ended brainstorming loses energy. Use timeboxes: 20 minutes for generation, 15 minutes for evaluation, 10 minutes for selection.

10. **Challenge assumptions** — The most powerful brainstorming question is "What if this constraint didn't exist?" List all assumptions about the problem and challenge each one.

11. **Include diverse perspectives** — Homogeneous groups generate homogeneous ideas. Include people from different backgrounds, roles, and expertise areas.

12. **Check for novelty** — Before finalizing an idea, verify it hasn't been tried. A quick search for prior art saves wasted effort.

13. **Prototype quickly** — The gap between idea and reality is bridged by prototypes. Even a rough sketch or mockup makes an idea tangible and evaluable.

14. **Document the reasoning** — When an idea is selected, document WHY it was selected and WHY alternatives were rejected. This aids future decision-making.

15. **Close the loop** — After implementing the selected idea, review the brainstorming process. What worked? What would you do differently? Build your brainstorming skill over time.
