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

### 1b. Domain shortcuts

A named technology outranks a generic route: when the request says "Playwright", start at
`browser-automation`, not at `testing`. Everything the goal table does not reach lands here, so no
skill in the library is unreachable by routing.

| The request mentions | Primary | Often also |
|---|---|---|
| prompts, prompt files, model output formats | `ai/prompt-engineering` | `ai/self-correction` |
| reasoning steps, "think before answering" | `ai/chain-of-thought` | `ai/context-management` |
| the agent drifted, contradicted itself, or broke a fix | `ai/self-correction` | `coding/debugging` |
| open-ended design options, "how could we" | `ai/brainstorming` | `core/requirement-analysis` |
| RAG, embeddings, vector store, citations | `ai/rag-implementation` | `architecture/database-design` |
| tool/function calling, retries, JSON arguments | `ai/tool-management` | `ai/agent-orchestration` |
| long sessions, context limits, compaction, handoff | `ai/context-management` | `ai/agent-orchestration` |
| subagents, parallel workers, orchestration | `ai/agent-orchestration` | `core/task-planning` |
| explaining code, onboarding docs for a module | `coding/code-explanation` | `documentation/documentation` |
| moving between frameworks, versions, or languages | `coding/code-migration` | `testing`, `quality/verification` |
| data structures, complexity, "is there a faster algorithm" | `coding/algorithm-design` | `performance/performance-analysis` |
| clean architecture, hexagonal, dependency direction | `coding/clean-architecture` | `architecture/system-design` |
| REST/HTTP client work, webhooks, third-party APIs | `coding/api-integration` | `architecture/api-design` |
| Playwright, Puppeteer, Selenium, scraping | `coding/browser-automation` | `quality/testing-e2e` |
| scraping, parsers, robots.txt, rate limits | `coding/web-scraping` | `security/security-audit` |
| regular expressions, tokenizers, validation patterns | `coding/regex` | `quality/testing` |
| localization, RTL, plural rules, date/number formats | `coding/i18n` | `quality/accessibility` |
| emails, templates, SPF/DKIM/DMARC, deliverability | `coding/email-template` | `devops/monitoring-observability` |
| iOS, Android, React Native, Flutter, app stores | `coding/mobile-development` | `devops/ci-cd` |
| meta tags, sitemaps, Core Web Vitals, indexing | `coding/seo` | `performance/performance-optimization` |
| WCAG, screen readers, keyboard, contrast | `quality/accessibility` | `quality/testing-e2e` |
| flaky suites, selectors, visual regression | `quality/testing-e2e` | `devops/ci-cd` |
| notebooks, statistics, A/B analysis | `quality/data-analysis` | `quality/data-cleaning` |
| nulls, duplicates, schema drift, encoding fixes | `quality/data-cleaning` | `architecture/database-design` |
| GraphQL schemas, resolvers, federation, N+1 | `architecture/graphql` | `architecture/api-design` |
| service boundaries, sagas, decomposition | `architecture/microservices` | `architecture/queue` |
| queues, brokers, idempotency, dead letters | `architecture/queue` | `devops/monitoring-observability` |
| schema design, indexes, tenancy, migrations | `architecture/database-design` | `performance/performance-analysis` |
| branching, rebase, conflicts, release tags | `git/git-workflow` | `devops/ci-cd` |
| Dockerfiles, image size, reproducible builds | `devops/dockerization` | `security/security-audit` |
| rollouts, canaries, rollback plans | `devops/deployment` | `devops/incident-response` |
| feature toggles, kill switches, flag cleanup | `devops/feature-flag` | `devops/monitoring-observability` |
| metrics, logs, traces, SLOs, alert noise | `devops/monitoring-observability` | `devops/incident-response` |
| Lambda/Cloud Functions, cold starts, timeouts | `devops/serverless` | `performance/performance-analysis` |
| latency, throughput, "it is slow" | `performance/performance-analysis` | `performance/caching` |
| tuning after a measurement exists | `performance/performance-optimization` | `performance/caching` |
| races, deadlocks, ordering, torn writes | `performance/concurrency-debugging` | `coding/debugging` |
| dependency CVEs, secrets, injection, supply chain | `security/security-audit` | `devops/ci-cd` |
| release notes, changelog entries | `documentation/changelog` | `git/git-workflow` |
| condensing a document, thread, or diff | `documentation/summarization` | `documentation/technical-writing` |
| tutorials, guides, RFCs, postmortems | `documentation/technical-writing` | `documentation/documentation` |
| planning work, milestones, "break this down" | `core/task-planning` | `core/requirement-analysis` |

The generated `INDEX.md` that `install.sh` writes into each agent directory carries the same
routing information per skill—description, category, priority—so an installed agent can route
without this file.

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
