# 📊 Skill Matrix

## Complete Skill Reference

| Skill | Category | Priority | Dependencies | Conflicts | Triggers |
|-------|----------|----------|-------------|-----------|----------|
| project-analysis | Core | P1 | - | - | project structure, codebase, architecture |
| requirement-analysis | Core | P1 | project-analysis | - | requirement, what do you need, scope |
| task-planning | Core | P1 | project-analysis, requirement-analysis | - | plan, steps, breakdown, roadmap |
| code-generation | Coding | P1 | project-analysis, requirement-analysis | - | write code, create, implement, build |
| code-editing | Coding | P1 | project-analysis | - | edit, modify, change, update, patch |
| code-explanation | Coding | P2 | project-analysis | - | explain, what does this do, walkthrough |
| debugging | Coding | P0 | project-analysis | refactoring | debug, bug, error, crash, exception |
| refactoring | Coding | P2 | project-analysis, code-review, testing | debugging | refactor, clean up, simplify, restructure |
| code-review | Quality | P1 | project-analysis | - | review, code quality, PR review |
| testing | Quality | P1 | project-analysis, code-review | - | test, unit test, coverage, mock |
| verification | Quality | P0 | - | - | verify, check, does it work, build, lint |
| system-design | Architecture | P2 | project-analysis | - | system design, architecture, scalable |
| api-design | Architecture | P2 | system-design | - | api, rest, graphql, endpoint |
| database-design | Architecture | P2 | system-design | - | database, schema, table, migration |
| git-workflow | Git | P2 | project-analysis | - | git, commit, branch, merge, conflict |
| dockerization | DevOps | P3 | project-analysis | - | docker, dockerfile, container |
| ci-cd | DevOps | P3 | testing, dockerization | - | ci cd, pipeline, github actions |
| deployment | DevOps | P3 | testing, ci-cd, dockerization | - | deploy, release, production |
| security-audit | Security | P0 | project-analysis | - | security, vulnerability, injection, auth |
| performance-analysis | Performance | P2 | project-analysis | - | performance, slow, bottleneck, optimize |
| concurrency-debugging | Performance | P0 | debugging | - | race condition, deadlock, async, thread |
| agent-orchestration | AI | P2 | task-planning | - | agent, multi-agent, orchestration |
| tool-management | AI | P1 | agent-orchestration | - | tool call, tool error, tool failure |
| context-management | AI | P1 | - | - | context, token, context window |
| documentation | Docs | P3 | project-analysis | - | documentation, docs, readme |

## Priority Summary

| Priority | Skills | Count |
|----------|--------|-------|
| P0 | debugging, verification, security-audit, concurrency-debugging | 4 |
| P1 | project-analysis, requirement-analysis, task-planning, code-generation, code-editing, code-review, testing, tool-management, context-management | 9 |
| P2 | code-explanation, refactoring, system-design, api-design, database-design, git-workflow, performance-analysis, agent-orchestration | 8 |
| P3 | dockerization, ci-cd, deployment, documentation | 4 |

## Category Summary

| Category | Skills | Count |
|----------|--------|-------|
| Core | project-analysis, requirement-analysis, task-planning | 3 |
| Coding | code-generation, code-editing, code-explanation, debugging, refactoring | 5 |
| Quality | code-review, testing, verification | 3 |
| Architecture | system-design, api-design, database-design | 3 |
| Git | git-workflow | 1 |
| DevOps | dockerization, ci-cd, deployment | 3 |
| Security | security-audit | 1 |
| Performance | performance-analysis, concurrency-debugging | 2 |
| AI | agent-orchestration, tool-management, context-management | 3 |
| Documentation | documentation | 1 |

**Total: 28 Skills**
