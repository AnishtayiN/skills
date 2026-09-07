# 📊 Skill Matrix

## Complete Skill Reference (57 Skills · 10 Categories)

| Skill | Category | Priority | Dependencies | Lines |
|-------|----------|----------|-------------|------:|
| project-analysis | core | P1 | - | 603 |
| requirement-analysis | core | P1 | project-analysis | 649 |
| task-planning | core | P1 | project-analysis, requirement-analysis | 879 |
| prompt-engineering | ai | P1 | - | 497 |
| chain-of-thought | ai | P1 | prompt-engineering | 231 |
| self-correction | ai | P1 | prompt-engineering | 615 |
| brainstorming | ai | P2 | requirement-analysis | 733 |
| rag-implementation | ai | P2 | api-integration | 942 |
| tool-management | ai | P1 | context-management | 1029 |
| context-management | ai | P1 | - | 1231 |
| agent-orchestration | ai | P2 | task-planning | 1336 |
| code-editing | coding | P1 | project-analysis | 537 |
| code-explanation | coding | P2 | project-analysis | 661 |
| code-generation | coding | P1 | project-analysis, requirement-analysis | 797 |
| debugging | coding | P0 | project-analysis | 753 |
| refactoring | coding | P2 | project-analysis, code-review, testing | 831 |
| web-scraping | coding | P3 | - | 896 |
| api-integration | coding | P2 | project-analysis | 969 |
| browser-automation | coding | P3 | - | 1081 |
| clean-architecture | coding | P2 | project-analysis, refactoring | 1568 |
| algorithm-design | coding | P0 | testing | 992 |
| code-migration | coding | P0 | testing, code-review | 1357 |
| email-template | coding | P1 | - | 1581 |
| i18n | coding | P1 | regex, code-review | 1386 |
| mobile-development | coding | P1 | - | 1826 |
| regex | coding | P1 | testing | 1064 |
| seo | coding | P1 | - | 1769 |
| code-review | quality | P1 | project-analysis | 615 |
| verification | quality | P0 | - | 754 |
| testing | quality | P1 | project-analysis, code-review | 812 |
| testing-e2e | quality | P2 | testing | 1132 |
| accessibility | quality | P1 | testing | 1224 |
| data-analysis | quality | P2 | - | 1302 |
| data-cleaning | quality | P2 | - | 1488 |
| database-design | architecture | P2 | system-design | 609 |
| system-design | architecture | P2 | project-analysis | 791 |
| api-design | architecture | P2 | system-design | 908 |
| graphql | architecture | P2 | api-design, system-design | 1706 |
| microservices | architecture | P2 | system-design, api-design, queue | 1449 |
| queue | architecture | P2 | system-design | 1385 |
| git-workflow | git | P2 | project-analysis | 698 |
| dockerization | devops | P3 | project-analysis | 831 |
| ci-cd | devops | P3 | testing, dockerization | 913 |
| deployment | devops | P3 | testing, ci-cd, dockerization | 1066 |
| feature-flag | devops | P2 | ci-cd, monitoring-observability, testing-e2e | 1375 |
| incident-response | devops | P0 | monitoring-observability, feature-flag | 1497 |
| monitoring-observability | devops | P1 | ci-cd | 1212 |
| serverless | devops | P2 | monitoring-observability, ci-cd | 1185 |
| security-audit | security | P0 | project-analysis | 699 |
| performance-analysis | performance | P2 | project-analysis | 804 |
| performance-optimization | performance | P2 | performance-analysis | 1488 |
| caching | performance | P2 | performance-analysis | 1357 |
| concurrency-debugging | performance | P0 | debugging | 955 |
| changelog | documentation | P2 | project-analysis | 531 |
| summarization | documentation | P3 | - | 1110 |
| technical-writing | documentation | P3 | - | 1288 |
| documentation | documentation | P3 | project-analysis | 1848 |

## Priority Summary

| Priority | Skills | Count |
|----------|--------|------:|
| **P0** (critical) | algorithm-design, code-migration, concurrency-debugging, debugging, incident-response, security-audit, verification | 7 |
| **P1** (high) | accessibility, chain-of-thought, code-editing, code-generation, code-review, context-management, email-template, i18n, mobile-development, monitoring-observability, project-analysis, prompt-engineering, regex, requirement-analysis, self-correction, seo, task-planning, testing, tool-management | 19 |
| **P2** (normal) | agent-orchestration, api-design, api-integration, brainstorming, caching, changelog, clean-architecture, code-explanation, data-analysis, data-cleaning, database-design, feature-flag, git-workflow, graphql, microservices, performance-analysis, performance-optimization, queue, rag-implementation, refactoring, serverless, system-design, testing-e2e | 23 |
| **P3** (standard) | browser-automation, ci-cd, deployment, dockerization, documentation, summarization, technical-writing, web-scraping | 8 |

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

**Total: 57 Skills · 59,788 lines**
