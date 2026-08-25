---
name: incident-response
description: >-
  Manage production incidents including root cause analysis (RCA), post-mortem writing,
  incident command, and prevention. Use this skill when the user mentions incident response,
  post-mortem, RCA, root cause analysis, production outage, incident management,
  on-call, incident commander, blameless postmortem, error budget, SLA/SLO/SLI,
  or says واکنش به حادثه, تحلیل ریشه مشکل, پست‌مورتوم, مدیریت حادثه.
---

# Incident Response Skill — RCA, Post-Mortem & Incident Management

## Overview

This skill covers the full lifecycle of production incidents: detection, triage, mitigation, root cause analysis, post-mortem, and prevention. The goal is to minimize impact, learn from failures, and prevent recurrence. Follows blameless post-mortem principles and industry-standard incident management practices.

## When to Use This Skill

- User is dealing with a production incident right now
- User wants to write a post-mortem or RCA
- User asks about incident management processes
- User mentions on-call, SLA, SLO, SLI, error budget
- User says "something is broken in production"
- User wants to improve incident response processes
- User mentions واکنش به حادثه, تحلیل ریشه مشکل, or پست‌مورتوم

---

## Part 1: Active Incident Response

### Incident Severity Levels

| Severity | Description | Response Time | Example |
|----------|-------------|--------------|---------|
| **SEV-1 (Critical)** | Complete outage, data loss, security breach | Immediate (page) | Database down, data leak |
| **SEV-2 (Major)** | Major feature broken, significant user impact | < 15 min | Payment system down |
| **SEV-3 (Minor)** | Minor feature broken, limited impact | < 1 hour | Search feature slow |
| **SEV-4 (Low)** | Cosmetic issue, workaround available | Next day | UI glitch |

### Incident Response Workflow

```
1. DETECT → Alert fires or user reports issue
2. TRIAGE → Assess severity, identify affected systems
3. MITIGATE → Stop the bleeding (rollback, disable feature, scale up)
4. DIAGNOSE → Find root cause (while mitigating)
5. RESOLVE → Fix the issue permanently
6. REVIEW → Write post-mortem, implement prevention
```

### Incident Command Template

```markdown
## Incident: [Brief Description]

**Severity:** SEV-X
**Incident Commander:** [Name]
**Started:** [Timestamp]
**Duration:** [Current duration]

### Impact
- [What users are affected]
- [What features are broken]
- [How many users/requests affected]

### Timeline
- [HH:MM] Alert fired / Issue reported
- [HH:MM] Incident commander assigned
- [HH:MM] Root cause identified
- [HH:MM] Mitigation applied
- [HH:MM] Issue resolved

### Status Updates
- [HH:MM] [Update 1]
- [HH:MM] [Update 2]
```

### Mitigation Strategies

| Problem | Mitigation |
|---------|-----------|
| **Service crash** | Restart, scale up, failover to healthy instance |
| **Database overload** | Enable read replicas, increase connection pool, cache hot queries |
| **Bad deployment** | Rollback to previous version |
| **Traffic spike** | Auto-scale, enable CDN, shed non-critical traffic |
| **Third-party outage** | Enable circuit breaker, switch to backup provider |
| **Memory leak** | Restart process, reduce memory-intensive operations |
| **Security breach** | Isolate affected systems, revoke credentials, notify stakeholders |

---

## Part 2: Root Cause Analysis (RCA)

### RCA Framework: 5 Whys

```
Problem: Users cannot log in

Why 1: Why can't users log in?
→ The auth service is returning 500 errors.

Why 2: Why is the auth service returning 500 errors?
→ It cannot connect to the database.

Why 3: Why can't it connect to the database?
→ The connection pool is exhausted.

Why 4: Why is the connection pool exhausted?
→ A slow query is holding connections for 30+ seconds.

Why 5: Why is the query slow?
→ A recent deployment added a missing index.

Root Cause: Missing database index in deployment v2.3.1
```

### RCA Framework: Fishbone Diagram

```
                          ┌─────────────────────┐
                          │   Production Outage  │
                          └──────────┬──────────┘
                                     │
        ┌────────────┬───────────────┼───────────────┬────────────┐
        │            │               │               │            │
    People      Process         Technology        Environment    Data
        │            │               │               │            │
   - On-call    - Deploy       - Missing index    - High        - Corrupted
     rotation     process        in DB            traffic       records
   - Training   - Rollback     - Memory leak     - Network     - Stale cache
     gaps         procedure      in service       latency
```

### RCA Checklist

- [ ] **Timeline reconstruction** — What happened and when?
- [ ] **Contributing factors** — What made this possible?
- [ ] **Root cause** — The underlying reason, not just symptoms
- [ ] **Detection** — How was it detected? How long before response?
- [ ] **Mitigation** — What stopped the bleeding?
- [ ] **Resolution** — What fixed it permanently?
- [ ] **Prevention** — What prevents recurrence?

---

## Part 3: Post-Mortem Writing

### Blameless Post-Mortem Template

```markdown
# Post-Mortem: [Incident Title]

**Date:** YYYY-MM-DD
**Severity:** SEV-X
**Duration:** X hours Y minutes
**Author:** [Name]
**Reviewers:** [Names]

## Summary
[1-2 sentence summary of what happened and impact]

## Impact
- **Users affected:** X (Y% of total)
- **Duration:** X hours
- **Revenue impact:** $X (if applicable)
- **SLA impact:** X minutes of downtime

## Timeline (UTC)
| Time | Event |
|------|-------|
| HH:MM | [Event 1] |
| HH:MM | [Event 2] |
| HH:MM | [Event 3] |

## Root Cause
[Detailed explanation of the root cause]

## Contributing Factors
1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

## What Went Well
- [Thing 1 that worked well]
- [Thing 2]

## What Went Wrong
- [Thing 1 that went wrong]
- [Thing 2]

## Action Items

| # | Action | Owner | Priority | Due Date | Status |
|---|--------|-------|----------|----------|--------|
| 1 | [Action item 1] | @name | P1 | YYYY-MM-DD | Open |
| 2 | [Action item 2] | @name | P2 | YYYY-MM-DD | Open |
| 3 | [Action item 3] | @name | P3 | YYYY-MM-DD | Open |

## Lessons Learned
1. [Lesson 1]
2. [Lesson 2]

## Appendix
- [Links to logs, traces, dashboards]
- [Related incidents]
```

### Action Item Priorities

| Priority | Description | Timeline |
|----------|-------------|----------|
| **P0** | Must prevent recurrence immediately | Within 24 hours |
| **P1** | Should be fixed this sprint | Within 1 week |
| **P2** | Should be fixed next sprint | Within 2 weeks |
| **P3** | Improvement, no rush | Within 1 month |

---

## Part 4: SLO/SLA/SLI Framework

### Definitions

| Term | Definition | Example |
|------|-----------|---------|
| **SLI** (Service Level Indicator) | What you measure | "99.5% of requests succeed" |
| **SLO** (Service Level Objective) | What you target | "99.9% availability" |
| **SLA** (Service Level Agreement) | What you contractually promise | "99.5% uptime, or credit issued" |

### Error Budget

```
SLO: 99.9% availability
Error Budget: 0.1% = 43.2 minutes/month of allowable downtime

Current status:
- Downtime this month: 15 minutes
- Budget remaining: 28.2 minutes (65%)

Decision: Can deploy (budget allows risk)
```

### SLI Examples

```python
# Availability SLI
availability = successful_requests / total_requests

# Latency SLI
latency_sli = requests_under_threshold / total_requests
# e.g., "99% of requests complete under 200ms"

# Correctness SLI
correctness = correct_responses / total_responses

# Freshness SLI (for data systems)
freshness = data_updated_within_ttl / total_data
```

---

## Part 5: Incident Communication

### Status Page Template

```markdown
# [Service Name] Status

## 🟢 All Systems Operational
## 🟡 Partial System Outage
## 🔴 Major System Outage

### Current Issues
- [ ] **[Component Name]** — Investigating
  [Brief description of the issue]
  *Started: HH:MM UTC*

### Resolved Issues
- ✅ **[Component Name]** — Resolved
  [Brief description]
  *Duration: X hours Y minutes*
```

### Stakeholder Update Template

```markdown
## Incident Update — [Incident Title]

**Status:** [Investigating / Identified / Monitoring / Resolved]
**Severity:** SEV-X

### Current Status
[What's happening now]

### Impact
[Who is affected and how]

### Next Update
[When the next update will be sent]

### Actions Taken
1. [Action 1]
2. [Action 2]
```

---

## Part 6: Prevention Patterns

### Chaos Engineering

```python
# Netflix-style chaos testing
# Kill random instances to test resilience
def chaos_test(service_name, duration_minutes=30):
    """Inject failures to test system resilience."""
    import random
    
    start = time.time()
    while time.time() - start < duration_minutes * 60:
        # Random failure injection
        failure_type = random.choice(["kill_instance", "network_latency", "disk_full"])
        
        if failure_type == "kill_instance":
            kill_random_instance(service_name)
        elif failure_type == "network_latency":
            inject_latency(service_name, delay_ms=500)
        elif failure_type == "disk_full":
            fill_disk(service_name, fill_percent=90)
        
        # Wait and observe
        time.sleep(300)  # 5 minutes between experiments
        
        # Check if system recovered
        assert health_check(service_name), "System did not recover from chaos"
```

### Runbook Template

```markdown
# Runbook: [Alert Name]

## Alert Description
[What this alert means]

## Impact
[What is affected]

## Investigation Steps
1. Check dashboard: [link]
2. Check logs: `kubectl logs -f deployment/[service]`
3. Check metrics: [Prometheus query]

## Mitigation Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Escalation
If not resolved in 30 minutes, escalate to: [team/person]

## Related Alerts
- [Alert 2]
- [Alert 3]
```

---

## Output Format

```
## Incident Report

### Summary
[One-line summary]

### Severity & Impact
- Severity: SEV-X
- Duration: X hours
- Users affected: X

### Timeline
[Chronological events]

### Root Cause
[Explanation]

### Action Items
[Prioritized list with owners]

### Prevention
[What changes prevent recurrence]
```

## Rules

- **Be blameless** — Focus on systems, not people
- **Document everything** — If it's not written down, it didn't happen
- **Follow up on action items** — An unfinished action item is a future incident
- **Communicate early and often** — Silence during an incident erodes trust
- **Test your incident process** — Run game days and fire drills
- **Keep runbooks updated** — Outdated runbooks are worse than none
