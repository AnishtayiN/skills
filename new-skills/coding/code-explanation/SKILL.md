---
name: code-explanation
description: >-
  Explain code clearly at multiple levels of detail. From high-level overview to line-by-line analysis.
  TRIGGERS: explain, what does this code do, how does this work, describe this code, walkthrough,
  code walkthrough, what is happening, explain this function, explain this class,
  توضیح بده, این کد چیکار میکنه, این تابع چیه, توضیح بده چطور کار میکنه, وارد کد شو,
  解释代码, 这段代码做什么, 这个函数怎么回事, 代码走查, 代码流程, 分析这段代码
priority: P2
dependencies: [project-analysis]
conflicts: []
---

# Code Explanation Skill

## Purpose

Explain code at the right level of detail for the audience. From 30,000-foot view to line-by-line analysis. Support multi-level explanations, visual diagrams, call flow tracing, dependency mapping, and architecture explanation.

## When to Activate

- User asks "what does this code do?"
- User asks to explain a function/class/module
- User is unfamiliar with a codebase
- Onboarding to new project
- User asks about code architecture or design decisions
- User wants a walkthrough of code flow
- User asks about call stacks or execution paths

## When NOT to Activate

- User wants to modify code (→ code-editing)
- User wants to fix bugs (→ debugging)
- User wants review (→ code-review)

## Inputs Required

- Code to explain (file, function, class, or snippet)
- Desired level of detail (overview / detailed / line-by-line)
- Audience level (beginner / intermediate / expert)

## Preconditions

- Code is accessible
- Understanding of the project context

## Workflow

### Step 1: Determine Scope

```
What level of explanation?
├── Overview → High-level purpose and flow (30,000-foot view)
├── Detailed → How each part works (component-level)
├── Line-by-line → Every line explained (pedagogical)
└── Architecture → System-wide design and patterns
```

### Step 2: Identify Key Elements

```
1. What is the PURPOSE of this code?
2. What are the INPUTS and OUTPUTS?
3. What is the CONTROL FLOW?
4. What DATA STRUCTURES are used?
5. What EXTERNAL DEPENDENCIES exist?
6. What ERROR CASES are handled?
7. What DESIGN PATTERNS are used?
8. What are the PERFORMANCE characteristics?
```

### Step 3: Structure Explanation

```
1. Start with PURPOSE (why this code exists)
2. Explain the INTERFACE (what it takes and returns)
3. Walk through the LOGIC (step by step)
4. Highlight KEY DECISIONS (why this approach)
5. Note EDGE CASES and error handling
6. Mention CONNECTIONS to other parts
```

### Step 4: Adapt to Audience

```
If audience is:
├── Beginner → More context, simpler terms, explain jargon
├── Intermediate → Focus on patterns and decisions
└── Expert → Focus on edge cases, trade-offs, alternatives
```

## Advanced Techniques

### 1. Multi-Level Explanation (Beginner / Intermediate / Expert)

**Beginner Level:**
```
This function takes a list of numbers and returns the average.

Think of it like calculating your grades: you add up all your
test scores and divide by how many tests you took.

Step by step:
1. It starts with zero as the total
2. It looks at each number one by one
3. It adds each number to the total
4. It divides the total by how many numbers there were
5. It gives you back the result
```

**Intermediate Level:**
```
This is a pure function implementing the arithmetic mean.

It uses functional programming patterns — reduce for aggregation
rather than imperative loops. The accumulator pattern (sum/n)
is O(n) time and O(1) space.

Note: it doesn't handle the empty list case — that would be
a division by zero. A production version should either return
Optional[float] or raise ValueError.
```

**Expert Level:**
```
Implements arithmetic mean via reduce with commutative/associative
accumulator. O(n) time, O(1) space. Numerically unstable for
large datasets due to floating-point accumulation error.

For production use, consider:
- Welford's online algorithm for streaming data
- Kahan summation for precision
- Decimal type for financial calculations
- NaN/infinity propagation behavior
```

### 2. Visual Diagrams (ASCII/Mermaid)

**Call Flow Diagram:**
```
┌─────────────┐
│   Request    │
│   arrives    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Middleware  │  ← auth, logging, rate limiting
│   Pipeline  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Router     │  ← matches URL pattern
│   Handler    │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌──────────────┐
│  Controller  │────▶│  Service     │
│   Layer      │     │   Layer      │
└─────────────┘     └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │  Repository  │
                    │    Layer     │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │   Database   │
                    └──────────────┘
```

**State Machine Diagram:**
```
                    ┌──────────────┐
                    │    IDLE      │◀─────────┐
                    └──────┬───────┘          │
                           │ start()          │
                           ▼                  │
                    ┌──────────────┐          │
                    │  LOADING     │──error──▶│
                    └──────┬───────┘          │
                           │ success          │
                           ▼                  │
                    ┌──────────────┐          │
                    │  ACTIVE      │──reset──▶│
                    └──────┬───────┘
                           │ complete()
                           ▼
                    ┌──────────────┐
                    │  COMPLETED   │
                    └──────────────┘
```

**Data Flow Diagram:**
```
User Input ──▶ Validation ──▶ Transformation ──▶ Output
                  │                  │
                  ▼                  ▼
              Errors             Cache Hit?
              Queue              ├── YES: return cached
                                 └── NO: compute, cache, return
```

### 3. Call Flow Tracing

Walk through the execution step by step with actual values:

```
TRACE: processOrder(orderId="ORD-123")

1. orderController.getOrder("ORD-123")
   → calls orderService.findById("ORD-123")

2. orderService.findById("ORD-123")
   → calls orderRepository.get("ORD-123")
   → returns Order { id: "ORD-123", status: "pending", total: 99.99 }

3. orderService.findById("ORD-123")
   → calls paymentService.checkPayment("ORD-123")
   → returns PaymentStatus { paid: true, method: "credit_card" }

4. orderController.getOrder("ORD-123")
   → maps to OrderResponse DTO
   → returns 200 OK with { order: {...}, payment: {...} }

Total calls: 3 service calls, 1 DB query
Latency breakdown:
  - DB query: ~5ms
  - Payment check: ~50ms (external API)
  - Total: ~55ms
```

### 4. Dependency Mapping

```python
# Module dependency graph for user_service.py
#
# user_service.py
# ├── depends_on (imports):
# │   ├── models.user          (User, UserRole)
# │   ├── repositories.user    (UserRepository)
# │   ├── services.auth        (AuthService)
# │   ├── services.email       (EmailService)
# │   └── utils.validators     (validate_email)
#
# depended_on_by (imported by):
#   ├── controllers.user_controller
#   ├── controllers.admin_controller
#   └── middleware.auth_middleware
#
# External dependencies:
#   ├── sqlalchemy (ORM)
#   └── pydantic (validation)
```

### 5. Architecture Explanation

```
ARCHITECTURE: Event-Driven Microservices

┌─────────────────────────────────────────────────────────┐
│                     API Gateway                          │
│              (rate limiting, auth, routing)              │
└─────────┬───────────────┬───────────────┬───────────────┘
          │               │               │
    ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
    │  User      │  │  Order    │  │  Payment   │
    │  Service   │  │  Service  │  │  Service   │
    └─────┬─────┘  └─────┬─────┘  └─────┬─────┘
          │               │               │
          └───────────────┼───────────────┘
                          │
                   ┌──────▼──────┐
                   │   Message   │
                   │    Broker   │
                   │   (Kafka)   │
                   └─────────────┘

Design Decisions:
- Event sourcing for audit trail
- CQRS for read/write separation
- Saga pattern for distributed transactions
- Circuit breaker for fault tolerance
```

### 6. Explain Like I'm 5 (ELI5)

Simplify code concepts to their absolute core using everyday analogies:

```
TECHNIQUE: ELI5 — Explain Like I'm 5

WHEN TO USE:
- User is completely new to programming
- Concept is inherently complex (async, concurrency, state machines)
- User says "I don't get it" after a detailed explanation

HOW TO APPLY:
1. Strip away ALL jargon
2. Use a real-world analogy the user definitely knows
3. Map each code concept to the analogy
4. Keep it under 5 sentences
5. Then offer to "zoom in" for more detail

EXAMPLE — What is a database?

ELI5: "Imagine a giant filing cabinet. Every paper in the cabinet
has information about something — like a person's name and address.
When you want to find someone, you ask the librarian (the database)
to look through the cabinet and pull out the right folder. The
librarian is really fast because the folders are organized in a
specific order."

EXAMPLE — What is recursion?

ELI5: "Imagine you're standing in a line, and you ask the person
in front of you 'What position am I in?' They don't know either,
so they ask the person in front of THEM. This keeps going until
someone at the front says 'I'm position 1!' Then the answer
travels back: 'You're position 2, you're position 3...' until
you find out you're position 10."

EXAMPLE — What is an API?

ELI5: "Think of a restaurant. You (the app) can't go into the
kitchen (the server) and grab food yourself. You tell the waiter
(the API) what you want using a menu (the documentation). The
waiter brings back exactly what you ordered — or tells you if
they're out of stock."
```

### 7. Mermaid Diagram Generation

Generate structured Mermaid diagrams for visual learners and documentation:

```markdown
TECHNIQUE: Mermaid Diagram Generation

USE CASES:
- Architecture documentation
- Data flow visualization
- Sequence diagrams for async code
- State machines
- Entity relationship diagrams

EXAMPLE — Sequence Diagram:
\`\`\`mermaid
sequenceDiagram
    participant U as User
    participant C as Controller
    participant S as Service
    participant D as Database

    U->>C: POST /api/orders
    C->>S: createOrder(data)
    S->>D: INSERT INTO orders
    D-->>S: order_id = 42
    S-->>C: Order { id: 42, status: "created" }
    C-->>U: 201 Created
\`\`\`

EXAMPLE — Flowchart:
\`\`\`mermaid
flowchart TD
    A[Request Received] --> B{Valid Input?}
    B -->|Yes| C[Process Request]
    B -->|No| D[Return 400 Error]
    C --> E{User Exists?}
    E -->|Yes| F[Execute Logic]
    E -->|No| G[Return 404]
    F --> H[Return 200 OK]
\`\`\`

EXAMPLE — State Diagram:
\`\`\`mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Loading: start()
    Loading --> Active: success
    Loading --> Idle: error
    Active --> Completed: finish()
    Active --> Idle: reset()
    Completed --> [*]
\`\`\`

EXAMPLE — Entity Relationship:
\`\`\`mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"
    USER {
        int id PK
        string name
        string email
    }
    ORDER {
        int id PK
        datetime created_at
        string status
    }
\`\`\`

WHEN TO CHOOSE MERMAID:
- Documentation that will be rendered (GitHub, Notion, GitBook)
- Complex flows that need visual representation
- Sharing architecture with team members
- README files and design documents
```

## Common Patterns

### Pattern 1: Explain by Analogy
```
"This code works like a restaurant kitchen:

- The Controller is the waiter — takes orders from customers
- The Service is the chef — prepares the food (business logic)
- The Repository is the pantry — stores and retrieves ingredients (data)
- The Database is the warehouse — long-term storage

When a customer (user) places an order (HTTP request):
1. Waiter (Controller) takes the order
2. Chef (Service) checks the recipe and prepares it
3. Pantry (Repository) provides the ingredients (data)
4. Waiter serves the result back to the customer"
```

### Pattern 2: Explain by Contrast
```
"Here's what this code does vs what you might expect:

EXPECTED: It filters the array and returns matching items
ACTUAL: It returns a NEW array with the matching items (immutably)

EXPECTED: The function throws on invalid input
ACTUAL: It returns null and logs a warning (fail silently)

EXPECTED: This is synchronous
ACTUAL: This is async — you need to await it"
```

### Pattern 3: Explain by Red Flags
```
"This code has several things to watch out for:

🚩 Line 15: Uses `eval()` — potential security risk
🚩 Line 23: No error handling — will crash on network failure
🚩 Line 31: Global mutable state — thread unsafe
🚩 Line 42: Magic number 86400 — should be a named constant
🚩 Line 58: Nested callbacks — consider async/await"
```

### Pattern 4: Explain with Execution Replay
```
"Let's trace through with example input:

Input: processTree({ value: 1, children: [{ value: 2 }, { value: 3 }] })

Step 1: node.value === 1, not leaf → recurse
Step 2:   child[0].value === 2, is leaf → return 2
Step 3:   child[1].value === 3, is leaf → return 3
Step 4: return 1 + 2 + 3 = 6

Output: 6"
```

### Pattern 5: Explain Design Intent
```
"This code was designed with these principles:

1. OPEN-CLOSED: The plugin system lets you add new processors
   without modifying existing code (open for extension,
   closed for modification)

2. SINGLE RESPONSIBILITY: Each class has ONE job:
   - Parser: reads input
   - Validator: checks rules
   - Transformer: converts format
   - Writer: outputs result

3. DEPENDENCY INVERSION: High-level modules (Parser) depend on
   abstractions (Processor interface), not concrete implementations"
```

## Edge Cases & Pitfalls

1. **Recursion depth**: Recursive code may cause stack overflow on large inputs
2. **Off-by-one errors**: Loop bounds, array indexing, range functions
3. **Null propagation**: Missing null checks cascade failures
4. **Type coercion**: Implicit type conversions cause subtle bugs
5. **Closure capture**: Variables captured by reference, not value
6. **Lazy evaluation**: Expressions evaluated when accessed, not when defined
7. **Mutation side effects**: Functions that modify their arguments
8. **Promise microtasks**: Execution order differs from synchronous code
9. **Operator precedence**: Complex expressions without parentheses
10. **Integer overflow**: Large numbers may overflow in some languages
11. **Floating point precision**: 0.1 + 0.2 !== 0.3
12. **String immutability**: Some "modifications" create new strings
13. **Hash map ordering**: Iteration order may not be insertion order
14. **Default parameters**: Evaluated once, not per call
15. **Import side effects**: Some imports execute code on load

## Integration with Other Skills

| Skill | Direction | Description |
|-------|-----------|-------------|
| project-analysis | ← Input | Project context for explanation |
| code-generation | ↔ Bidirectional | Understand patterns before generating similar |
| code-editing | ↔ Bidirectional | Understand code before editing |
| debugging | → Output | Understanding aids debugging |
| code-review | → Output | Understanding aids review |
| documentation | → Output | Explanations feed into documentation |
| refactoring | → Output | Understanding identifies refactoring opportunities |

## Output Format Templates

### Standard Template
```
## Code Explanation

### Purpose
[One-paragraph summary of what this code does and why]

### How It Works
[Step-by-step walkthrough of the logic]

### Key Components
- **[Component 1]**: [What it does]
- **[Component 2]**: [What it does]

### Data Flow
[How data moves through the code]

### Edge Cases
- [Edge case 1]: [How handled]
- [Edge case 2]: [How handled]

### Connections
- Calls: [What this code calls]
- Called by: [What calls this code]
- Dependencies: [External libraries used]
```

### Quick Template
```
## Quick Explanation

**What**: [One sentence]
**How**: [2-3 bullet points]
**Watch out**: [One gotcha]
```

### Deep Template
```
## In-Depth Code Analysis

### Architecture Context
[Where this code fits in the larger system]

### Detailed Walkthrough
[Line-by-line or block-by-block explanation]

### Design Decisions
[Why this approach was chosen over alternatives]

### Performance Analysis
[Time/space complexity, optimization notes]

### Security Considerations
[Potential vulnerabilities, input validation]

### Testing Approach
[How to test this code, what to test]

### Improvement Suggestions
[Potential refactors, optimizations, fixes]
```

### Agent-Specific Template
```
## Agent Code Briefing

### Quick Context
[What this code does in one line]

### For Modification
[What to know before editing this code]

### For Debugging
[Known issues, common failure modes]

### For Extension
[How to add new features to this code]
```

## Rules

1. **ALWAYS** start with the big picture before details
2. **ALWAYS** use analogies when the concept is complex
3. **ALWAYS** highlight non-obvious decisions
4. **ALWAYS** point out potential issues or gotchas
5. **ALWAYS** connect to project context
6. **ALWAYS** adapt detail level to audience
7. **NEVER** just read the code aloud — explain WHY
8. **NEVER** skip error handling explanation
9. **NEVER** ignore edge cases in the explanation
10. **NEVER** assume the audience knows the language/framework
11. **USE** visual diagrams for complex flows
12. **USE** concrete examples to illustrate abstract concepts
13. **USE** execution traces for recursive/async code
14. **COMPARE** with alternatives when explaining design choices
15. **MENTION** performance implications when relevant

## Verification

- [ ] Purpose clearly stated
- [ ] Flow explained logically
- [ ] Key decisions highlighted
- [ ] Edge cases mentioned
- [ ] Appropriate detail level for audience
- [ ] Connections to other code noted
- [ ] No jargon without explanation

## Failure Handling

- If code is too complex → Break into smaller pieces, explain each
- If purpose is unclear → Ask user for context, explain what you CAN determine
- If dependencies are unknown → Document what would need to be investigated
- If audience level unclear → Default to intermediate, ask if adjustment needed

## Safety Constraints

- Do NOT claim certainty about code purpose without evidence
- Do NOT suggest changes during explanation (that's refactoring/code-review)
- Do NOT skip security-relevant code patterns
- Do NOT assume the code is correct — note potential bugs

## Anti-Patterns

- ❌ Explaining what (reading code aloud) instead of why
- ❌ Too much detail for overview request
- ❌ Too little detail for line-by-line request
- ❌ Not connecting to project context
- ❌ Missing edge cases
- ❌ Using undefined jargon
- ❌ Ignoring error handling paths
- ❌ Skipping non-obvious design decisions
- ❌ Explaining implementation without explaining purpose
- ❌ Treating all audiences the same way

## Skill Interactions

- ← project-analysis: Context for explanation
- → debugging: Understanding aids debugging
- → code-review: Understanding aids review
- → code-generation: Understanding patterns before generating
- → documentation: Explanations feed docs
