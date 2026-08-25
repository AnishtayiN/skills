# 📊 Skill Matrix

## Complete Skill Reference (57 Skills · 10 Categories)

| Skill | Category | Priority | Dependencies | Lines |
|-------|----------|----------|-------------|------:|
| project-analysis | core | P1 | - | 602 |
| requirement-analysis | core | P1 | project-analysis | 648 |
| task-planning | core | P1 | project-analysis, requirement-analysis | 878 |
| prompt-engineering | ai | P1 | - | 492 |
| chain-of-thought | ai | P2 | prompt-engineering | 587 |
| self-correction | ai | P1 | prompt-engineering | 610 |
| brainstorming | ai | P2 | requirement-analysis | 728 |
| rag-implementation | ai | P2 | api-integration | 937 |
| tool-management | ai | P1 | agent-orchestration, context-management | 1028 |
| context-management | ai | P1 | tool-management | 1229 |
| agent-orchestration | ai | P2 | task-planning | 1335 |
| code-editing | coding | P1 | project-analysis | 536 |
| code-explanation | coding | P2 | project-analysis | 660 |
| code-generation | coding | P1 | project-analysis, requirement-analysis | 796 |
| debugging | coding | P0 | project-analysis | 752 |
| refactoring | coding | P2 | project-analysis, code-review, testing | 830 |
| web-scraping | coding | P3 | - | 891 |
| api-integration | coding | P2 | project-analysis | 964 |
| browser-automation | coding | P3 | - | 1077 |
| clean-architecture | coding | P2 | project-analysis, refactoring | 1563 |
| algorithm-design | coding | P0 | testing | 991 |
| code-migration | coding | P0 | testing, code-review | 1356 |
| email-template | coding | P1 | performance-optimization | 1580 |
| i18n | coding | P1 | regex, code-review | 1385 |
| mobile-development | coding | P1 | performance-optimization | 1825 |
| regex | coding | P1 | testing | 1063 |
| seo | coding | P1 | performance-optimization | 1768 |
| code-review | quality | P1 | project-analysis | 614 |
| verification | quality | P0 | - | 753 |
| testing | quality | P1 | project-analysis, code-review | 811 |
| testing-e2e | quality | P2 | ci-cd, testing | 1131 |
| accessibility | quality | P1 | testing-e2e | 1223 |
| data-analysis | quality | P2 | - | 1297 |
| data-cleaning | quality | P2 | - | 1483 |
| database-design | architecture | P2 | system-design | 608 |
| system-design | architecture | P2 | project-analysis | 790 |
| api-design | architecture | P2 | system-design | 907 |
| graphql | architecture | P2 | api-design, system-design | 1705 |
| microservices | architecture | P2 | system-design, api-design, queue | 1448 |
| queue | architecture | P2 | system-design | 1384 |
| git-workflow | git | P2 | project-analysis | 697 |
| dockerization | devops | P3 | project-analysis | 830 |
| ci-cd | devops | P3 | testing, dockerization | 912 |
| deployment | devops | P3 | testing, ci-cd, dockerization | 1065 |
| feature-flag | devops | P2 | ci-cd, monitoring-observability, testing-e2e | 1374 |
| incident-response | devops | P0 | monitoring-observability, feature-flag | 1496 |
| monitoring-observability | devops | P1 | ci-cd | 1211 |
| serverless | devops | P2 | monitoring-observability, ci-cd | 1184 |
| security-audit | security | P0 | project-analysis | 698 |
| performance-analysis | performance | P2 | project-analysis | 803 |
| performance-optimization | performance | P2 | caching | 1487 |
| caching | performance | P2 | performance-optimization | 1356 |
| concurrency-debugging | performance | P0 | debugging | 954 |
| changelog | documentation | P2 | project-analysis | 530 |
| summarization | documentation | P3 | - | 1105 |
| technical-writing | documentation | P3 | - | 1283 |
| documentation | documentation | P3 | project-analysis | 1847 |

## Priority Summary

| Priority | Skills | Count |
|----------|--------|------:|
| **P0** (critical) | debugging, verification, security-audit, concurrency-debugging, incident-response, algorithm-design, code-migration | 7 |
| **P1** (high) | project-analysis, requirement-analysis, task-planning, prompt-engineering, self-correction, tool-management, context-management, code-generation, code-editing, code-review, testing, accessibility, email-template, i18n, mobile-development, regex, seo, monitoring-observability | 18 |
| **P2** (normal) | chain-of-thought, brainstorming, rag-implementation, agent-orchestration, code-explanation, refactoring, api-integration, clean-architecture, data-analysis, data-cleaning, testing-e2e, database-design, system-design, api-design, graphql, microservices, queue, git-workflow, feature-flag, serverless, performance-analysis, performance-optimization, caching, changelog | 24 |
| **P3** (standard) | web-scraping, browser-automation, deployment, dockerization, ci-cd, summarization, technical-writing, documentation | 8 |

## Category Summary

| Category | Count |
|----------|------:|
| core | 3 |
| ai | 8 |
| coding | 16 |
| quality | 7 |
| architecture | 6 |
| devops | 7 |
| git | 1 |
| security | 1 |
| performance | 4 |
| documentation | 4 |

**Total: 57 Skills · ~60,000 lines**
