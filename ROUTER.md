# Skill router

The router selects a small, ordered set of skills. It is intentionally conservative: a skill is loaded when it changes the agent's next action, not merely because it is related to the topic.

## Routing algorithm

```text
request
  → classify goal and risk
  → inspect project and constraints
  → select one primary skill
  → add only required prerequisites and risk checks
  → execute
  → verify with evidence
```

### 1. Classify the request

| Goal | Primary | Add when relevant |
|---|---|---|
| understand an unfamiliar repository | `core/project-analysis` | `documentation` |
| clarify a feature or bug report | `core/requirement-analysis` | `core/task-planning` |
| implement a feature | `coding/code-generation` | `testing`, `security-audit`, `verification` |
| edit a small known location | `coding/code-editing` | `verification` |
| diagnose a failure | `coding/debugging` | `testing`, `verification` |
| review a diff or PR | `quality/code-review` | `security-audit`, `performance-analysis` |
| change structure without behavior change | `coding/refactoring` | `testing`, `verification` |
| design a system/API/data model | `architecture/system-design` | `api-design`, `database-design` |
| deploy or automate delivery | `devops/ci-cd` or `devops/deployment` | `security-audit`, `monitoring-observability` |
| respond to an incident | `devops/incident-response` | `monitoring-observability`, `debugging` |
| optimize a slow path | `performance/performance-analysis` | `caching`, `concurrency-debugging` |
| write or update docs | `documentation/documentation` | `technical-writing` |

Use specialized skills (`graphql`, `regex`, `i18n`, `browser-automation`, and so on) only when the request actually names or requires that domain.

### 2. Order and dependencies

Read declared dependencies first, in dependency order. Dependencies are context providers, not mandatory work products: skip a dependency's execution when the needed facts are already established, but record that decision.

### 3. Resolve overlap

- debugging precedes refactoring;
- implementation precedes review;
- testing and security checks happen before deployment;
- performance work starts with measurement, never with a guessed optimization;
- verification is a checkpoint, not a claim that every possible check must pass.

### 4. Scope and risk

Choose a verification depth:

- **quick:** syntax, focused test, diff review;
- **standard:** project lint/type/test commands plus a smoke test;
- **release:** standard checks, integration/E2E, security, migration/rollback review.

Increase depth for authentication, payments, destructive operations, public APIs, concurrency, migrations, or production incidents.

## Output from routing

Before execution, keep a short internal plan with: goal, files likely involved, selected skills, assumptions, verification commands, and stop conditions. Do not expose private chain-of-thought; report decisions and evidence instead.
