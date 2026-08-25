---
name: incident-response
description: >-
  Manage production incidents with severity classification, on-call rotations, runbooks,
  blameless postmortems, and stakeholder communication. TRIGGERS: incident response,
  postmortem, RCA, root cause analysis, production outage, incident management, on-call,
  incident commander, blameless postmortem, error budget, SLA, SLO, SLI, runbook,
  واکنش به حادثه, تحلیل ریشه مشکل, پست‌مورتوم, مدیریت حادثه, تیم آن‌کال,
  事故响应, 故障复盘, 根因分析, 值班, 应急响应, SLO, 事后总结
priority: P0
dependencies: [monitoring-observability, feature-flag]
conflicts: []
---

# Incident Response Skill — Severity Levels, On-Call, Runbooks & Blameless Postmortems

## Overview

Incident response is the structured process for detecting, triaging, mitigating, diagnosing, and learning from production failures. This skill covers the complete incident lifecycle: establishing severity classification systems, building effective on-call rotations, writing actionable runbooks, conducting blameless postmortems, communicating with stakeholders, and implementing prevention measures through chaos engineering and SLO/error budget frameworks. The goal is not to prevent all incidents (impossible) but to minimize mean time to detect (MTTD), mean time to resolve (MTTR), and mean time between failures (MTBF) while building organizational resilience.

## When to Use This Skill

- Responding to an active production incident and need a structured triage process
- Writing or improving blameless postmortems and root cause analyses (RCA)
- Designing on-call rotations, escalation policies, and pager configurations
- Building or updating runbooks for recurring alert patterns
- Establishing severity classification systems for your organization
- Communicating incident status to stakeholders, leadership, and customers
- Implementing SLO/SLA frameworks and error budget policies
- Setting up chaos engineering or game day exercises for resilience testing
- Conducting incident response drills or fire drills to train teams

## When NOT to Use This Skill

- Setting up monitoring dashboards or alerting rules (→ monitoring-observability)
- Debugging application-level bugs without production impact (→ debugging)
- Implementing feature flags for gradual rollouts (→ feature-flag)
- Designing CI/CD rollback mechanisms (→ ci-cd)
- Writing application code or tests (→ application code, testing)
- Setting up infrastructure or cloud resources (→ infrastructure)
- Designing system architecture for resilience (→ system-design)
- Writing documentation unrelated to incidents (→ documentation)

## Workflow

### Step 1: Detect and Triage

```
1. Alert fires or user reports an issue
2. On-call engineer acknowledges within SLA
3. Classify severity (SEV-1 through SEV-4)
4. Assign Incident Commander (IC) for SEV-1/SEV-2
5. Open an incident channel/thread for communication
6. Begin timeline documentation
```

### Step 2: Mitigate and Contain

```
1. Stop the bleeding (rollback, feature flag kill switch, scale up)
2. Isolate affected systems to prevent cascade failures
3. Communicate initial impact assessment to stakeholders
4. Begin parallel investigation while mitigating
5. Escalate if mitigation is not working within expected timeframe
```

### Step 3: Diagnose and Resolve

```
1. Identify root cause using structured techniques (5 Whys, fishbone)
2. Implement permanent fix
3. Verify fix in production with monitoring confirmation
4. Close the incident
5. Send final stakeholder communication
```

### Step 4: Review and Prevent

```
1. Schedule postmortem within 48 hours
2. Conduct blameless review with all involved parties
3. Document timeline, root cause, contributing factors
4. Identify action items with owners and due dates
5. Track action items to completion
6. Share learnings across the organization
```

## Advanced Techniques

### 1. Incident Severity Classification System

```typescript
type SeverityLevel = 'SEV-1' | 'SEV-2' | 'SEV-3' | 'SEV-4';

interface SeverityDefinition {
  level: SeverityLevel;
  label: string;
  description: string;
  responseTimeMinutes: number;
  updateFrequencyMinutes: number;
  examples: string[];
  requiresIC: boolean;
  requiresExecNotification: boolean;
  requiresCustomerNotification: boolean;
}

const SEVERITY_MATRIX: Record<SeverityLevel, SeverityDefinition> = {
  'SEV-1': {
    level: 'SEV-1',
    label: 'Critical',
    description: 'Complete service outage, data loss or corruption, security breach affecting customers, or revenue-critical system failure',
    responseTimeMinutes: 5,
    updateFrequencyMinutes: 30,
    examples: [
      'Complete database failure',
      'Authentication service down — no user can log in',
      'Payment processing system failure',
      'Data breach or unauthorized data access',
      'Production environment unreachable',
    ],
    requiresIC: true,
    requiresExecNotification: true,
    requiresCustomerNotification: true,
  },
  'SEV-2': {
    level: 'SEV-2',
    label: 'Major',
    description: 'Major feature degradation affecting significant user base, partial outage of critical path, or data inconsistency',
    responseTimeMinutes: 15,
    updateFrequencyMinutes: 60,
    examples: [
      'Search functionality returning incorrect results',
      'Checkout flow failing for 20% of users',
      'API response times exceeding 10s for critical endpoints',
      'Email notifications not being delivered',
      'Mobile app crashing on specific OS version',
    ],
    requiresIC: true,
    requiresExecNotification: false,
    requiresCustomerNotification: true,
  },
  'SEV-3': {
    level: 'SEV-3',
    label: 'Minor',
    description: 'Minor feature broken with workaround available, limited user impact, or non-critical system degradation',
    responseTimeMinutes: 60,
    updateFrequencyMinutes: 240,
    examples: [
      'Admin dashboard showing incorrect metrics',
      'Export function timing out for large datasets',
      'Non-critical background job failing',
      'UI rendering issue on specific browser',
      'Rate limiting triggering for a single endpoint',
    ],
    requiresIC: false,
    requiresExecNotification: false,
    requiresCustomerNotification: false,
  },
  'SEV-4': {
    level: 'SEV-4',
    label: 'Low',
    description: 'Cosmetic issues, negligible impact, or easily workable problems',
    responseTimeMinutes: 1440, // Next business day
    updateFrequencyMinutes: 1440,
    examples: [
      'Typo in error message',
      'Non-functional link in footer',
      'Minor UI misalignment',
      'Documentation outdated',
      'Non-critical deprecation warning',
    ],
    requiresIC: false,
    requiresExecNotification: false,
    requiresCustomerNotification: false,
  },
};

function classifyIncident(impact: {
  affectedUsersPercent: number;
  revenueImpact: boolean;
  dataIntegrity: boolean;
  securityBreach: boolean;
  serviceFullyDown: boolean;
  workaroundAvailable: boolean;
}): SeverityLevel {
  if (impact.serviceFullyDown || impact.dataIntegrity || impact.securityBreach) {
    return 'SEV-1';
  }
  if (impact.revenueImpact || impact.affectedUsersPercent > 10) {
    return 'SEV-2';
  }
  if (impact.affectedUsersPercent > 1 || !impact.workaroundAvailable) {
    return 'SEV-3';
  }
  return 'SEV-4';
}
```

### 2. On-Call Rotation Manager

```typescript
interface OnCallSchedule {
  team: string;
  primary: string[];
  secondary: string[];
  escalationPolicy: EscalationLevel[];
}

interface EscalationLevel {
  delayMinutes: number;
  notify: string[];
  channels: ('pager' | 'slack' | 'sms' | 'phone')[];
}

class OnCallManager {
  private schedules: Map<string, OnCallSchedule> = new Map();
  private incidents: Map<string, IncidentRecord> = new Map();

  /**
   * Determine the current on-call engineer for a team.
   */
  getCurrentOnCall(team: string): { primary: string; secondary: string } {
    const schedule = this.schedules.get(team);
    if (!schedule) throw new Error(`No schedule found for team: ${team}`);

    const now = new Date();
    const dayOfYear = Math.floor(
      (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) / 86400000
    );

    const primaryIndex = dayOfYear % schedule.primary.length;
    const secondaryIndex = (dayOfYear + 1) % schedule.secondary.length;

    return {
      primary: schedule.primary[primaryIndex],
      secondary: schedule.secondary[secondaryIndex],
    };
  }

  /**
   * Create an incident and begin escalation.
   */
  createIncident(params: {
    title: string;
    severity: SeverityLevel;
    team: string;
    reporter: string;
    description: string;
  }): IncidentRecord {
    const id = `INC-${Date.now().toString(36).toUpperCase()}`;
    const onCall = this.getCurrentOnCall(params.team);
    const severityDef = SEVERITY_MATRIX[params.severity];

    const incident: IncidentRecord = {
      id,
      title: params.title,
      severity: params.severity,
      status: 'open',
      team: params.team,
      reporter: params.reporter,
      incidentCommander: severityDef.requiresIC ? onCall.primary : undefined,
      onCallPrimary: onCall.primary,
      onCallSecondary: onCall.secondary,
      description: params.description,
      createdAt: new Date().toISOString(),
      timeline: [{
        timestamp: new Date().toISOString(),
        event: 'Incident created',
        author: params.reporter,
      }],
      updates: [],
    };

    this.incidents.set(id, incident);
    this.startEscalation(incident, severityDef);
    return incident;
  }

  /**
   * Begin escalation timer based on severity.
   */
  private startEscalation(incident: IncidentRecord, severityDef: SeverityDefinition): void {
    // Immediate notification to primary on-call
    this.notify(incident.onCallPrimary, {
      incident: incident,
      urgency: severityDef.responseTimeMinutes <= 15 ? 'critical' : 'high',
    });

    // Escalation timer
    setTimeout(() => {
      if (incident.status === 'open') {
        this.notify(incident.onCallSecondary, {
          incident: incident,
          urgency: 'critical',
          message: `Escalation: ${incident.id} not acknowledged within ${severityDef.responseTimeMinutes} minutes`,
        });
      }
    }, severityDef.responseTimeMinutes * 60_000);
  }

  /**
   * Update incident status and timeline.
   */
  addTimelineEntry(incidentId: string, event: string, author: string): void {
    const incident = this.incidents.get(incidentId);
    if (!incident) throw new Error(`Incident not found: ${incidentId}`);

    incident.timeline.push({
      timestamp: new Date().toISOString(),
      event,
      author,
    });
  }

  /**
   * Update incident status.
   */
  updateStatus(incidentId: string, status: IncidentRecord['status']): void {
    const incident = this.incidents.get(incidentId);
    if (!incident) throw new Error(`Incident not found: ${incidentId}`);

    incident.status = status;
    if (status === 'resolved') {
      incident.resolvedAt = new Date().toISOString();
    }

    this.addTimelineEntry(incidentId, `Status changed to ${status}`, 'system');
  }

  /**
   * Send stakeholder notification.
   */
  private notify(recipient: string, params: {
    incident: IncidentRecord;
    urgency: 'critical' | 'high' | 'medium';
    message?: string;
  }): void {
    // In production, this would integrate with PagerDuty, Slack, SMS, etc.
    console.log(`[NOTIFY] ${recipient} — ${params.urgency.toUpperCase()}: ${params.incident.id} — ${params.incident.title}`);
    if (params.message) {
      console.log(`  ${params.message}`);
    }
  }

  /**
   * Generate incident metrics.
   */
  getMetrics(): {
    totalIncidents: number;
    bySeverity: Record<SeverityLevel, number>;
    byStatus: Record<string, number>;
    averageResolutionTimeHours: number;
  } {
    const incidents = [...this.incidents.values()];
    const resolved = incidents.filter((i) => i.resolvedAt);

    return {
      totalIncidents: incidents.length,
      bySeverity: {
        'SEV-1': incidents.filter((i) => i.severity === 'SEV-1').length,
        'SEV-2': incidents.filter((i) => i.severity === 'SEV-2').length,
        'SEV-3': incidents.filter((i) => i.severity === 'SEV-3').length,
        'SEV-4': incidents.filter((i) => i.severity === 'SEV-4').length,
      },
      byStatus: {
        open: incidents.filter((i) => i.status === 'open').length,
        mitigating: incidents.filter((i) => i.status === 'mitigating').length,
        resolved: incidents.filter((i) => i.status === 'resolved').length,
      },
      averageResolutionTimeHours:
        resolved.length > 0
          ? resolved.reduce((sum, i) => {
              const duration = new Date(i.resolvedAt!).getTime() - new Date(i.createdAt).getTime();
              return sum + duration / 3_600_000;
            }, 0) / resolved.length
          : 0,
    };
  }
}

interface IncidentRecord {
  id: string;
  title: string;
  severity: SeverityLevel;
  status: 'open' | 'mitigating' | 'diagnosing' | 'resolved' | 'closed';
  team: string;
  reporter: string;
  incidentCommander?: string;
  onCallPrimary: string;
  onCallSecondary: string;
  description: string;
  createdAt: string;
  resolvedAt?: string;
  timeline: Array<{
    timestamp: string;
    event: string;
    author: string;
  }>;
  updates: string[];
}
```

### 3. Structured RCA Framework (5 Whys + Fishbone)

```typescript
interface RootCauseAnalysis {
  incidentId: string;
  problemStatement: string;
  timeline: Array<{ time: string; event: string; impact?: string }>;
  fiveWhys: FiveWhysEntry[];
  contributingFactors: ContributingFactor[];
  rootCause: string;
  correctiveActions: ActionItem[];
  preventiveActions: ActionItem[];
}

interface FiveWhysEntry {
  why: number;
  question: string;
  answer: string;
}

interface ContributingFactor {
  category: 'people' | 'process' | 'technology' | 'environment' | 'data';
  description: string;
  severity: 'primary' | 'secondary' | 'minor';
}

interface ActionItem {
  id: string;
  description: string;
  owner: string;
  priority: 'P0' | 'P1' | 'P2' | 'P3';
  dueDate: string;
  status: 'open' | 'in_progress' | 'completed' | 'cancelled';
  type: 'corrective' | 'preventive' | 'detective';
}

class RCAFramework {
  /**
   * Perform 5 Whys analysis with structured output.
   */
  static perform5Whys(problemStatement: string): FiveWhysEntry[] {
    // This is a template; in practice, the IC fills this in during the postmortem.
    return [
      { why: 1, question: `Why did "${problemStatement}" happen?`, answer: '' },
      { why: 2, question: 'Why did the above cause occur?', answer: '' },
      { why: 3, question: 'Why was that the case?', answer: '' },
      { why: 4, question: 'Why did that condition exist?', answer: '' },
      { why: 5, question: 'Why was that not prevented?', answer: '' },
    ];
  }

  /**
   * Generate fishbone (Ishikawa) diagram categories.
   */
  static generateFishbone(problem: string): Record<string, string[]> {
    return {
      'People': [
        'Insufficient training or knowledge transfer',
        'Single point of knowledge (bus factor)',
        'On-call fatigue or burnout',
        'Unclear roles during incident',
      ],
      'Process': [
        'Missing or outdated runbook',
        'No code review for the change',
        'Inadequate testing before deployment',
        'No staged rollout process',
      ],
      'Technology': [
        'Missing monitoring or alerting',
        'No circuit breaker or rate limiting',
        'Insufficient redundancy or failover',
        'Hardcoded configuration',
      ],
      'Environment': [
        'Unexpected traffic spike',
        'Third-party service degradation',
        'Network partition or latency',
        'Resource exhaustion (CPU, memory, disk)',
      ],
      'Data': [
        'Corrupted or invalid data',
        'Missing database index',
        'Data migration without rollback plan',
        'Stale cache or stale data',
      ],
    };
  }

  /**
   * Validate completeness of an RCA document.
   */
  static validate(rca: RootCauseAnalysis): {
    isComplete: boolean;
    missingItems: string[];
  } {
    const missingItems: string[] = [];

    if (!rca.problemStatement) missingItems.push('Problem statement');
    if (rca.timeline.length < 3) missingItems.push('Timeline needs at least 3 entries');

    const answeredWhys = rca.fiveWhys.filter((w) => w.answer.trim() !== '').length;
    if (answeredWhys < 3) missingItems.push(`Only ${answeredWhys}/5 Whys answered (minimum 3)`);

    if (rca.contributingFactors.length === 0) missingItems.push('No contributing factors identified');

    if (!rca.rootCause) missingItems.push('Root cause not stated');

    const correctiveItems = rca.correctiveActions.filter((a) => a.status === 'open');
    if (correctiveItems.length === 0) missingItems.push('No open corrective actions');

    const ownersAssigned = rca.correctiveActions.every((a) => a.owner);
    if (!ownersAssigned) missingItems.push('Some corrective actions missing owners');

    return {
      isComplete: missingItems.length === 0,
      missingItems,
    };
  }

  /**
   * Generate a postmortem template as markdown.
   */
  static generatePostmortemTemplate(rca: RootCauseAnalysis): string {
    return `# Postmortem: ${rca.problemStatement}

**Incident ID:** ${rca.incidentId}
**Date:** ${new Date().toISOString().split('T')[0]}
**Author:** [Author Name]
**Reviewers:** [Reviewer Names]

## Summary
[1-2 sentence summary of the incident and its impact]

## Impact
- **Users affected:** [Number and percentage]
- **Duration:** [X hours Y minutes]
- **Revenue impact:** [$X, if applicable]
- **SLA/SLO impact:** [X minutes of error budget consumed]

## Timeline (UTC)
${rca.timeline.map((t) => `| ${t.time} | ${t.event} |`).join('\n')}

## Root Cause
${rca.rootCause}

## Contributing Factors
${rca.contributingFactors.map((f) => `1. **[${f.category}]** ${f.description} (${f.severity})`).join('\n')}

## Five Whys
${rca.fiveWhys.map((w) => `**Why ${w.why}:** ${w.question}\n→ ${w.answer}`).join('\n\n')}

## What Went Well
- [List things that worked during the incident]

## What Went Wrong
- [List things that did not work]

## Action Items
${rca.correctiveActions.map((a) => `| ${a.id} | ${a.description} | ${a.owner} | ${a.priority} | ${a.dueDate} | ${a.status} |`).join('\n')}

## Lessons Learned
1. [Lesson 1]
2. [Lesson 2]
3. [Lesson 3]

## Appendix
- [Link to incident channel]
- [Link to dashboards]
- [Link to logs]
`;
  }
}
```

### 4. Runbook Automation Framework

```typescript
interface RunbookStep {
  order: number;
  action: string;
  command?: string;
  expected: string;
  ifUnexpected: string;
  timeout: number;
}

interface Runbook {
  alertName: string;
  description: string;
  impact: string;
  severity: SeverityLevel;
  prerequisites: string[];
  investigationSteps: RunbookStep[];
  mitigationSteps: RunbookStep[];
  escalation: {
    afterMinutes: number;
    contact: string[];
    channels: string[];
  };
}

class RunbookExecutor {
  private runbooks: Map<string, Runbook> = new Map();
  private executionLog: Array<{
    runbook: string;
    step: number;
    action: string;
    result: 'success' | 'failure' | 'skipped';
    timestamp: string;
    output: string;
  }> = [];

  /**
   * Load a runbook for the given alert.
   */
  getRunbook(alertName: string): Runbook | undefined {
    return this.runbooks.get(alertName);
  }

  /**
   * Execute a runbook step and log the result.
   */
  async executeStep(
    runbookName: string,
    step: RunbookStep,
    executor: (command: string) => Promise<string>
  ): Promise<{ success: boolean; output: string }> {
    const startTime = Date.now();

    try {
      let output: string;
      if (step.command) {
        output = await Promise.race([
          executor(step.command),
          new Promise<string>((_, reject) =>
            setTimeout(() => reject(new Error(`Step timed out after ${step.timeout}s`)), step.timeout * 1000)
          ),
        ]);
      } else {
        output = `Manual step: ${step.action}`;
      }

      const success = output.includes(step.expected);
      this.executionLog.push({
        runbook: runbookName,
        step: step.order,
        action: step.action,
        result: success ? 'success' : 'failure',
        timestamp: new Date().toISOString(),
        output,
      });

      if (!success) {
        console.error(`[Runbook] Step ${step.order} failed. Expected: ${step.expected}`);
        console.error(`[Runbook] Recovery: ${step.ifUnexpected}`);
      }

      return { success, output };
    } catch (err) {
      this.executionLog.push({
        runbook: runbookName,
        step: step.order,
        action: step.action,
        result: 'failure',
        timestamp: new Date().toISOString(),
        output: String(err),
      });

      return { success: false, output: String(err) };
    }
  }

  /**
   * Generate a runbook as markdown.
   */
  static generateRunbookMarkdown(runbook: Runbook): string {
    return `# Runbook: ${runbook.alertName}

## Alert Description
${runbook.description}

## Impact
${runbook.impact}

## Severity: ${runbook.severity}

## Prerequisites
${runbook.prerequisites.map((p) => `- ${p}`).join('\n')}

## Investigation Steps
${runbook.investigationSteps.map((s) => `${s.order}. **${s.action}**
   - Command: \`${s.command || 'N/A'}\`
   - Expected: ${s.expected}
   - If unexpected: ${s.ifUnexpected}
   - Timeout: ${s.timeout}s
`).join('\n')}

## Mitigation Steps
${runbook.mitigationSteps.map((s) => `${s.order}. **${s.action}**
   - Command: \`${s.command || 'N/A'}\`
   - Expected: ${s.expected}
   - If unexpected: ${s.ifUnexpected}
   - Timeout: ${s.timeout}s
`).join('\n')}

## Escalation
If not resolved within ${runbook.escalation.afterMinutes} minutes:
- Contact: ${runbook.escalation.contact.join(', ')}
- Channels: ${runbook.escalation.channels.join(', ')}
`;
  }
}
```

### 5. Stakeholder Communication Templates

```typescript
class IncidentCommunications {
  /**
   * Generate initial incident notification.
   */
  static initialNotification(incident: {
    id: string;
    severity: SeverityLevel;
    title: string;
    impact: string;
  }): string {
    const severityDef = SEVERITY_MATRIX[incident.severity];
    const now = new Date().toISOString();

    return `## 🚨 Incident Notification — ${incident.id}

**Severity:** ${incident.severity} — ${severityDef.label}
**Status:** Investigating
**Started:** ${now}
**Incident Commander:** [Assign IC]

### Impact
${incident.impact}

### Current Status
We are actively investigating this issue. Initial triage is underway.

### Next Update
Next update in ${severityDef.updateFrequencyMinutes} minutes or when status changes.

---
*This is an automated notification. Do not reply to this channel for updates.*`;
  }

  /**
   * Generate status update.
   */
  static statusUpdate(params: {
    incidentId: string;
    status: 'investigating' | 'identified' | 'monitoring' | 'resolved';
    update: string;
    nextUpdateMinutes: number;
  }): string {
    const statusEmoji: Record<string, string> = {
      investigating: '🔍',
      identified: '🔧',
      monitoring: '📊',
      resolved: '✅',
    };

    return `## ${statusEmoji[params.status]} Incident Update — ${params.incidentId}

**Status:** ${params.status.charAt(0).toUpperCase() + params.status.slice(1)}
**Updated:** ${new Date().toISOString()}

### Update
${params.update}

### Next Update
${params.status === 'resolved' ? 'Issue resolved. Postmortem to follow.' : `Next update in ${params.nextUpdateMinutes} minutes.`}`;
  }

  /**
   * Generate customer-facing incident page update.
   */
  static customerPage(params: {
    service: string;
    components: Array<{
      name: string;
      status: 'operational' | 'degraded' | 'outage';
      message?: string;
    }>;
  }): string {
    const overallStatus = params.components.every((c) => c.status === 'operational')
      ? '🟢 All Systems Operational'
      : params.components.some((c) => c.status === 'outage')
        ? '🔴 Major System Outage'
        : '🟡 Partial System Outage';

    const components = params.components
      .map((c) => {
        const emoji = c.status === 'operational' ? '✅' : c.status === 'degraded' ? '⚠️' : '🔴';
        return `- ${emoji} **${c.name}** — ${c.status.charAt(0).toUpperCase() + c.status.slice(1)}${c.message ? `\n  ${c.message}` : ''}`;
      })
      .join('\n');

    return `# ${params.service} Status

## ${overallStatus}

${components}

*Last updated: ${new Date().toISOString()}*`;
  }

  /**
   * Generate post-incident summary for leadership.
   */
  static leadershipSummary(incident: {
    id: string;
    severity: SeverityLevel;
    title: string;
    duration: string;
    affectedUsers: number;
    revenueImpact: string;
    rootCause: string;
    correctiveActions: Array<{ description: string; owner: string; dueDate: string }>;
  }): string {
    return `# Incident Summary — ${incident.id}

## Quick Facts
| Field | Value |
|-------|-------|
| Severity | ${incident.severity} |
| Title | ${incident.title} |
| Duration | ${incident.duration} |
| Affected Users | ${incident.affectedUsers.toLocaleString()} |
| Revenue Impact | ${incident.revenueImpact} |

## Root Cause (One Sentence)
${incident.rootCause}

## Corrective Actions
${incident.correctiveActions.map((a) => `- [ ] **${a.description}** — ${a.owner} (due: ${a.dueDate})`).join('\n')}

## Key Learnings
1. [Most important learning]
2. [Second most important learning]

## Follow-Up
Postmortem document: [Link]
Next review meeting: [Date/Time]`;
  }
}
```

### 6. Error Budget and SLO Framework

```typescript
interface SLODefinition {
  name: string;
  description: string;
  indicator: string;  // What you measure (SLI)
  target: number;     // e.g., 99.9 (percent)
  windowDays: number; // Measurement window
  burnRateAlertThreshold: number; // e.g., 14.4 for 1-hour window
}

interface ErrorBudgetStatus {
  slo: SLODefinition;
  budgetTotalMinutes: number;
  budgetConsumedMinutes: number;
  budgetRemainingMinutes: number;
  budgetRemainingPercent: number;
  isExhausted: boolean;
  burnRate: number; // Current burn rate (1.0 = on track)
  canDeploy: boolean;
}

class ErrorBudgetManager {
  private slos: SLODefinition[] = [];

  registerSLO(slo: SLODefinition): void {
    this.slos.push(slo);
  }

  /**
   * Calculate error budget status for a given SLO.
   */
  calculateBudgetStatus(
    slo: SLODefinition,
    downtimeMinutes: number
  ): ErrorBudgetStatus {
    const budgetTotalMinutes = (slo.windowDays * 24 * 60) * ((100 - slo.target) / 100);
    const budgetRemainingMinutes = budgetTotalMinutes - downtimeMinutes;
    const budgetRemainingPercent = (budgetRemainingMinutes / budgetTotalMinutes) * 100;

    // Burn rate: 1.0 means consuming budget at the expected rate
    const expectedDailyBurn = budgetTotalMinutes / slo.windowDays;
    const actualDailyBurn = downtimeMinutes / slo.windowDays;
    const burnRate = expectedDailyBurn > 0 ? actualDailyBurn / expectedDailyBurn : 0;

    // Deploy policy: can deploy if > 50% budget remaining
    const canDeploy = budgetRemainingPercent > 50;

    return {
      slo,
      budgetTotalMinutes,
      budgetConsumedMinutes: downtimeMinutes,
      budgetRemainingMinutes: Math.max(0, budgetRemainingMinutes),
      budgetRemainingPercent: Math.max(0, budgetRemainingPercent),
      isExhausted: budgetRemainingMinutes <= 0,
      burnRate,
      canDeploy,
    };
  }

  /**
   * Check burn rate alerts (multi-window, multi-burn-rate).
   */
  checkBurnRateAlerts(slo: SLODefinition, currentBurnRate: number): {
    shouldAlert: boolean;
    alertSeverity: SeverityLevel | null;
    window: string;
  } {
    // Fast burn: 1% budget in 1 hour (14.4x burn rate) → SEV-2
    // Slow burn: 1% budget in 3 days (2x burn rate) → SEV-3
    if (currentBurnRate >= 14.4) {
      return { shouldAlert: true, alertSeverity: 'SEV-2', window: '1 hour' };
    }
    if (currentBurnRate >= 6) {
      return { shouldAlert: true, alertSeverity: 'SEV-3', window: '6 hours' };
    }
    if (currentBurnRate >= 2) {
      return { shouldAlert: true, alertSeverity: 'SEV-3', window: '3 days' };
    }
    return { shouldAlert: false, alertSeverity: null, window: 'none' };
  }

  /**
   * Generate a budget status dashboard.
   */
  generateDashboard(
    statuses: ErrorBudgetStatus[]
  ): string {
    const rows = statuses
      .map((s) => {
        const bar = '█'.repeat(Math.round(s.budgetRemainingPercent / 5)) +
                    '░'.repeat(20 - Math.round(s.budgetRemainingPercent / 5));
        return `| ${s.slo.name} | ${s.slo.target}% | ${bar} | ${s.budgetRemainingPercent.toFixed(1)}% | ${s.burnRate.toFixed(1)}x | ${s.canDeploy ? '✅' : '⛔'} |`;
      })
      .join('\n');

    return `## Error Budget Dashboard

| SLO | Target | Budget | Remaining | Burn Rate | Deploy? |
|-----|--------|--------|-----------|-----------|---------|
${rows}

### Deploy Policy
- ✅ Green (> 50% budget): Normal deployment velocity
- ⚠️ Yellow (20-50%): Deploy with caution, focus on reliability
- ⛔ Red (< 20%): Feature freeze, focus on reliability improvements
- 🔴 Exhausted: No deployments until budget recovers`;
  }
}
```

### 7. Chaos Engineering Framework

```typescript
interface ChaosExperiment {
  name: string;
  hypothesis: string;
  steadyState: string;
  experiment: {
    type: 'network_latency' | 'kill_instance' | 'cpu_stress' | 'disk_fill' | 'dns_failure';
    target: string;
    duration: number; // seconds
    parameters: Record<string, unknown>;
  };
  rollback: string;
  blastRadius: string;
}

class ChaosEngine {
  private experiments: ChaosExperiment[] = [];
  private results: Array<{
    experiment: ChaosExperiment;
    startTime: string;
    endTime: string;
    steadyStateMaintained: boolean;
    observations: string[];
  }> = [];

  /**
   * Define a chaos experiment.
   */
  defineExperiment(experiment: ChaosExperiment): void {
    this.experiments.push(experiment);
  }

  /**
   * Execute a chaos experiment (in a controlled manner).
   */
  async runExperiment(
    experiment: ChaosExperiment,
    steadiStateChecker: () => Promise<boolean>,
    faultInjector: (params: ChaosExperiment['experiment']) => Promise<void>
  ): Promise<{
    passed: boolean;
    observations: string[];
  }> {
    console.log(`[Chaos] Starting experiment: ${experiment.name}`);
    console.log(`[Chaos] Hypothesis: ${experiment.hypothesis}`);
    console.log(`[Chaos] Blast radius: ${experiment.blastRadius}`);

    const startTime = new Date().toISOString();
    const observations: string[] = [];

    // Verify steady state before experiment
    const initialStateHealthy = await steadiStateChecker();
    if (!initialStateHealthy) {
      observations.push('ABORTED: System not in steady state before experiment');
      return { passed: false, observations };
    }

    try {
      // Inject fault
      await faultInjector(experiment.experiment);
      observations.push(`Fault injected: ${experiment.experiment.type} on ${experiment.experiment.target}`);

      // Wait for experiment duration
      await new Promise((resolve) => setTimeout(resolve, experiment.experiment.duration * 1000));

      // Check if steady state was maintained
      const steadyStateMaintained = await steadiStateChecker();
      observations.push(`Steady state after fault: ${steadyStateMaintained ? 'MAINTAINED' : 'BROKEN'}`);

      this.results.push({
        experiment,
        startTime,
        endTime: new Date().toISOString(),
        steadyStateMaintained,
        observations,
      });

      return { passed: steadyStateMaintained, observations };
    } catch (err) {
      observations.push(`Error during experiment: ${err}`);
      return { passed: false, observations };
    }
  }

  /**
   * Generate a chaos experiment report.
   */
  static generateReport(results: ChaosEngine['results']): string {
    const passed = results.filter((r) => r.steadyStateMaintained).length;
    const total = results.length;

    return `## Chaos Engineering Report

### Summary
- **Total Experiments:** ${total}
- **Passed:** ${passed}
- **Failed:** ${total - passed}
- **Pass Rate:** ${total > 0 ? ((passed / total) * 100).toFixed(0) : 0}%

### Results
${results.map((r) => `#### ${r.experiment.name}
- **Hypothesis:** ${r.experiment.hypothesis}
- **Result:** ${r.steadyStateMaintained ? '✅ PASSED' : '❌ FAILED'}
- **Duration:** ${r.experiment.experiment.duration}s
- **Observations:** ${r.observations.join(', ')}
`).join('\n')}

### Recommendations
${results.filter((r) => !r.steadyStateMaintained).map((r) =>
  `- **${r.experiment.name}:** ${r.experiment.rollback}`
).join('\n')}
`;
  }
}
```

## Common Patterns

### Pattern 1: Incident Response Checklist

```markdown
## Incident Response Checklist

### Immediate (0-5 minutes)
- [ ] Acknowledge alert
- [ ] Classify severity
- [ ] Open incident channel
- [ ] Page IC if SEV-1/SEV-2
- [ ] Begin timeline documentation

### Triage (5-15 minutes)
- [ ] Identify affected services
- [ ] Assess user impact
- [ ] Check recent deployments/changes
- [ ] Check dependent services
- [ ] Begin mitigation attempts

### Mitigation (15-60 minutes)
- [ ] Rollback if deployment-related
- [ ] Enable kill switch if feature-related
- [ ] Scale up if traffic-related
- [ ] Communicate to stakeholders
- [ ] Continue investigation

### Resolution (60+ minutes)
- [ ] Apply permanent fix
- [ ] Verify fix in production
- [ ] Monitor for recurrence
- [ ] Close incident
- [ ] Schedule postmortem
```

### Pattern 2: On-Call Shift Handoff

```markdown
## On-Call Handoff — [Date]

### Active Incidents
- [INC-XXX] SEV-2 — [Status] — [Brief description]

### Recent Incidents (last 24h)
- [INC-XXX] — [Resolution summary]

### System Health
- Error rate: X% (baseline: Y%)
- P95 latency: Xms (baseline: Yms)
- Error budget remaining: X%

### Known Issues
- [Issue 1 with context]
- [Issue 2 with context]

### Action Items Pending
- [ ] [Item 1] — Due: [Date]
- [ ] [Item 2] — Due: [Date]
```

### Pattern 3: Postmortem Facilitation Guide

```markdown
## Postmortem Meeting Guide

### Pre-Meeting
- Gather timeline from incident channel
- Collect metrics and dashboards
- Invite all participants (no blame allowed)

### Meeting Structure (60 minutes)
1. **Read-through** (10 min): Silent reading of the draft postmortem
2. **Timeline review** (10 min): Verify facts, fill gaps
3. **Root cause discussion** (15 min): 5 Whys exercise
4. **What went well/wrong** (10 min): Add items
5. **Action items** (10 min): Assign owners and due dates
6. **Wrap-up** (5 min): Confirm next steps

### Rules
- Blameless: Focus on systems, not people
- Facts only: Verify before including
- Action-oriented: Every finding needs an action
- Follow up: Schedule a review of action items
```

### Pattern 4: Severity-Based Response Playbook

```typescript
function respondToIncident(incident: IncidentRecord): void {
  const severity = SEVERITY_MATRIX[incident.severity];

  // Step 1: Immediate actions based on severity
  if (incident.severity === 'SEV-1') {
    // Critical: Everything drops
    pageAllOnCall(incident.team);
    notifyExecutives(incident);
    openWarRoom(incident);
    pauseAllDeployments();
  } else if (incident.severity === 'SEV-2') {
    // Major: Priority response
    pagePrimaryOnCall(incident.team);
    notifyStakeholders(incident);
  } else {
    // Minor/Low: Normal process
    ticketIncident(incident);
  }

  // Step 2: Common mitigation patterns
  const mitigation = matchMitigation(incident);
  if (mitigation) {
    executeMitigation(mitigation);
  }
}

function matchMitigation(incident: IncidentRecord): string | null {
  const description = incident.description.toLowerCase();

  if (description.includes('database') && description.includes('connection')) {
    return 'database-connection-pool-overflow';
  }
  if (description.includes('memory') && description.includes('oom')) {
    return 'memory-leak-restart';
  }
  if (description.includes('deploy') || description.includes('release')) {
    return 'rollback-last-deployment';
  }
  if (description.includes('traffic') || description.includes('latency')) {
    return 'scale-out-and-cache';
  }
  return null;
}
```

### Pattern 5: Stakeholder Status Update Cadence

```
WHO sends WHAT, WHEN — during an active incident:

┌──────────────┬─────────────────────────┬───────────────────────────┐
│ Audience     │ Channel                 │ Cadence                   │
├──────────────┼─────────────────────────┼───────────────────────────┤
│ Responders   │ Incident channel        │ Continuous                │
│ Engineering  │ #eng-incidents          │ Every 30 min              │
│ Exec/Leadership │ status digest (auto) │ Every 60 min (SEV1)       │
│ Customers    │ status.page             │ Detection → 15 min first  │
│ Support team │ #support-warroom brief  │ Before each customer post │
└──────────────┴─────────────────────────┴───────────────────────────┘

CUSTOMER POST TEMPLATE (3 sentences max):
1. What's broken (user-visible symptom, no internal jargon)
2. What we're doing ("engineers are actively working on a fix")
3. Next update time ("next update by 14:30 UTC or sooner")

RULES:
- Never speculate on cause in customer comms ("root cause under investigation")
- Never promise an ETA you don't control ("working to restore" not "fixed by 3pm")
- Send updates at the promised time even if there is NO news — silence erodes trust faster than the outage itself
- One spokesperson; everyone else redirects press/partners to them
```

## Edge Cases & Pitfalls

1. **Alert fatigue from too many alerts** — When every alert is "critical", none are. Ruthlessly prune low-value alerts and require that every alert has an actionable runbook.

2. **Incident commander making technical decisions** — The IC coordinates communication and process, not debugging. Separate the IC role from the technical investigator to avoid bottlenecks.

3. **Postmortem blame culture** — If the postmortem becomes a blame session, people stop reporting incidents and near-misses. Enforce blameless principles by design: focus on "what allowed this to happen" not "who caused it".

4. **Action items without owners or deadlines** — An action item without an owner is a wish. Every action must have a named owner, a realistic due date, and a tracking mechanism.

5. **Stale runbooks worse than no runbook** — A runbook with outdated commands will waste time during an incident and erode trust. Include a "last verified" date in every runbook and require periodic review.

6. **Communication blackout during extended incidents** — Silence during a long incident erodes stakeholder trust. Even if there is nothing new, send periodic "still investigating" updates at the documented frequency.

7. **Ignoring near-misses** — Incidents that were narrowly avoided are equally valuable for learning. Track near-misses with the same rigor as actual incidents.

8. **Over-rotation on blameless** — Blameless does not mean actionless. Individuals can still be accountable for completing action items and following processes; the focus is on systemic improvement, not punishment.

9. **Missing escalation for after-hours incidents** — If the escalation policy only works during business hours, off-hours incidents will languish. Ensure 24/7 escalation paths are tested.

10. **Not testing the incident process** — An untested incident response process will fail when needed. Run game days and fire drills quarterly to keep teams sharp.

11. **Postmortem taking too long** — A postmortem should be completed within 48 hours while memories are fresh.拖延 leads to incomplete timelines and forgotten details.

12. **Single point of failure in on-call** — If only one person knows how to handle a class of incidents, you have a bus factor of 1. Cross-train and rotate on-call responsibilities.

13. **Ignoring customer communication** — Even internal incidents eventually affect customers. Proactive communication builds trust; reactive communication damages it.

14. **Not measuring MTTR and MTTD** — If you don't measure response times, you can't improve them. Track mean time to detect and mean time to resolve for every incident.

15. **Skipping the postmortem for "small" incidents** — Small incidents often reveal systemic issues that cause big incidents later. Conduct lightweight reviews for all SEV-3 and above.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| monitoring-observability | Alert detection, dashboards during incidents | ← | Monitoring feeds incident detection; incident data enriches dashboards |
| feature-flag | Kill switches, gradual rollback | ↔ | Flags enable instant mitigation; incidents trigger flag changes |
| ci-cd | Deployment rollback, pipeline pausing | → | Incident response may require rolling back deployments via CI/CD |
| serverless | Lambda error handling, DLQ processing | ← | Serverless incidents require different triage (cold starts, throttling) |
| logging | Structured logs for RCA, audit trail | ← | Logs are the primary evidence for root cause analysis |
| deployment | Rollback procedures, deployment freeze | ↔ | Incidents trigger deployment freezes; deployments cause incidents |
| testing-e2e | Smoke tests for incident verification | → | Post-fix verification uses E2E tests to confirm resolution |

## Output Format Templates

### Template 1: Incident Report

```markdown
# Incident Report: {INC-ID}

## Summary
[One-line summary of what happened and the impact]

## Severity & Impact
| Field | Value |
|-------|-------|
| Severity | SEV-X |
| Duration | X hours Y minutes |
| Users Affected | X (Y% of total) |
| Revenue Impact | $X |
| SLA Impact | X minutes of downtime |

## Timeline (UTC)
| Time | Event | Author |
|------|-------|--------|
| HH:MM | [Event] | [Name] |

## Root Cause
[Detailed root cause explanation]

## Contributing Factors
1. [Factor 1]
2. [Factor 2]

## Mitigation
[What was done to stop the bleeding]

## Resolution
[What fixed the issue permanently]

## Action Items
| ID | Action | Owner | Priority | Due Date | Status |
|----|--------|-------|----------|----------|--------|
| 1 | [Action] | @name | P1 | YYYY-MM-DD | Open |

## Lessons Learned
1. [Lesson 1]
2. [Lesson 2]
```

### Template 2: Runbook

```markdown
# Runbook: {Alert Name}

**Severity:** SEV-X
**Last Verified:** YYYY-MM-DD
**Owner:** @team-member

## Alert Description
[What this alert means and when it fires]

## Impact
[What services/users are affected]

## Prerequisites
- Access to [tool/dashboard]
- [Required permissions]

## Investigation Steps
1. **Check [dashboard/link]**
   - Expected: [What you should see]
   - If abnormal: [Next step]

2. **Run query: `[command]`**
   - Expected: [Output]
   - If abnormal: [Go to mitigation step X]

## Mitigation Steps
1. **[Mitigation action]**
   - Command: `[exact command]`
   - Expected: [Result]
   - Verification: `[verification command]`

## Escalation
If not resolved in 30 minutes:
- Contact: [Team/Person]
- Channel: [Slack/PagerDuty]

## Related Alerts
- [Alert 2]
- [Alert 3]

## Changelog
| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial version | @name |
```

### Template 3: Postmortem

```markdown
# Postmortem: {Incident Title}

**Date:** YYYY-MM-DD
**Incident ID:** {INC-ID}
**Severity:** SEV-X
**Duration:** X hours Y minutes
**Author:** [Name]
**Reviewers:** [Names]

## Summary
[1-2 sentence summary]

## Impact
- Users: X affected (Y%)
- Duration: X hours
- Revenue: $X
- SLO: X minutes of error budget consumed

## Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | [Event] |

## Root Cause
[Explanation]

## Contributing Factors
1. **[Technology]** [Factor]
2. **[Process]** [Factor]

## Five Whys
1. Why? → [Answer]
2. Why? → [Answer]
3. Why? → [Answer]
4. Why? → [Answer]
5. Why? → [Answer]

## What Went Well
- [Thing]

## What Went Wrong
- [Thing]

## Action Items
| # | Action | Owner | Priority | Due | Status |
|---|--------|-------|----------|-----|--------|
| 1 | [Action] | @name | P1 | date | Open |

## Lessons
1. [Lesson]
```

### Template 4: On-Call Dashboard

```markdown
## On-Call Dashboard — {Team}

### Current On-Call
| Role | Engineer | Since |
|------|----------|-------|
| Primary | @name | YYYY-MM-DD HH:MM |
| Secondary | @name | YYYY-MM-DD HH:MM |

### Active Incidents
| ID | Severity | Title | Duration | Status |
|----|----------|-------|----------|--------|
| INC-XXX | SEV-X | [Title] | Xh Xm | [Status] |

### Error Budget (30-day window)
| SLO | Target | Remaining | Burn Rate | Status |
|-----|--------|-----------|-----------|--------|
| Availability | 99.9% | X% | Xx | ✅/⚠️/⛔ |

### Recent Incidents (7 days)
| ID | Severity | Title | Duration | MTTR |
|----|----------|-------|----------|------|
| INC-XXX | SEV-X | [Title] | Xh Xm | Xh Xm |

### Pending Action Items
- [ ] [Action] — @name — Due: YYYY-MM-DD
```

## Rules

1. **Always blame systems, not people** — Postmortems must focus on what allowed the failure to occur, not who made a mistake. The goal is to build systems that prevent recurrence.

2. **Every alert must have a runbook** — An alert without a runbook is noise. If you cannot write a response procedure, the alert should not exist.

3. **Communicate early and often** — Silence during an incident erodes trust. Send updates at the documented frequency, even if there is nothing new to report.

4. **Track every action item to completion** — An unfinished action item from a postmortem is a future incident waiting to happen. Review action items weekly.

5. **Conduct postmortems within 48 hours** — Memories fade quickly. Schedule the postmortem meeting before the incident channel is closed.

6. **Test your incident process quarterly** — Run game days, fire drills, and tabletop exercises. An untested process will fail when needed.

7. **Keep runbooks current** — Verify runbooks monthly. A runbook with stale commands wastes time and erodes trust in the process.

8. **Measure MTTR and MTTD** — Track mean time to detect and mean time to resolve for every incident. These metrics drive process improvement.

9. **Classify severity consistently** — Use a standardized severity matrix. Inconsistent classification leads to inconsistent response.

10. **Escalate early** — If a SEV-1 is not contained in 15 minutes, escalate. Waiting too long to escalate turns a bad incident into a catastrophic one.

11. **Preserve evidence** — Capture logs, metrics, and timelines during the incident. After-the-fact reconstruction is unreliable.

12. **Share learnings broadly** — The value of a postmortem is multiplied when shared across teams. Publish postmortems (redacted for sensitive details) to a company-wide knowledge base.
