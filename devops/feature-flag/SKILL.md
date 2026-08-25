---
name: feature-flag
description: >-
  Implement feature flags, progressive rollouts, A/B experiments, and kill switches for
  controlled feature releases. TRIGGERS: feature flag, feature toggle, kill switch,
  progressive rollout, percentage rollout, A/B testing, canary deployment, dark launch,
  release flag, experiment flag, user targeting, LaunchDarkly, Unleash, flag debt,
  پرچم ویژگی, کنترل انتشار, تست A/B, استقرار تدریجی, کلید کشتن, پرچم قاتل,
  持续发布, 功能开关, 灰度发布, A/B测试, 熔断开关, 渐进发布, 标志清理
priority: P2
dependencies: [ci-cd, monitoring-observability, testing-e2e]
conflicts: []
---

# Feature Flag Skill — Controlled Releases, A/B Experiments & Progressive Rollouts

## Overview

Feature flags (also called feature toggles or feature switches) decouple deployment from release, enabling teams to ship code to production without exposing it to all users immediately. This skill covers the full lifecycle: designing flag architectures, implementing percentage rollouts, building A/B testing infrastructure, wiring kill switches for incident response, and cleaning up flag debt. Production-grade patterns for LaunchDarkly, Unleash, and custom flag systems are included, along with the statistical rigor required for experimentation and the operational discipline needed to prevent flag sprawl.

## When to Use This Skill

- Gradually releasing a new feature to a subset of users before full rollout
- Implementing A/B testing or multivariate experiments with statistical analysis
- Building kill switches to instantly disable problematic features during incidents
- Setting up percentage-based rollouts (canary → early adopters → general availability)
- Targeting features to specific users, groups, cohorts, or environments
- Managing feature flag lifecycle from creation through cleanup and debt removal
- Integrating with LaunchDarkly, Unleash, Flagsmith, or building a custom flag service
- Optimizing flag evaluation performance and reducing latency in hot paths
- Auditing flag usage, ownership, and expiration dates for flag debt management
- Coordinating flags across microservices with consistent evaluation semantics

## When NOT to Use This Skill

- Writing application logic unrelated to feature gating (→ application code)
- Setting up CI/CD pipelines (→ ci-cd)
- Designing database schemas or data models (→ database-design)
- Building monitoring dashboards or alerting rules (→ monitoring-observability)
- Debugging runtime errors in feature code (→ debugging)
- Writing unit or integration tests (→ testing)
- Deploying infrastructure or configuring cloud resources (→ infrastructure)
- Designing API contracts or schemas (→ api-design)

## Workflow

### Step 1: Define Flag Strategy

```
1. Identify the type of flag (release, experiment, ops, permission)
2. Define the target audience and rollout plan
3. Set success criteria and guardrail metrics
4. Establish a cleanup timeline and owner
5. Document the flag in your flag registry
```

### Step 2: Implement Flag Evaluation

```
1. Choose a flag delivery mechanism (SDK, file-based, database)
2. Implement consistent hashing for percentage rollouts
3. Add targeting rules (user ID, group, attribute, environment)
4. Wire up fallback defaults for flag resolution failures
5. Add observability (log evaluations, track metrics per variant)
```

### Step 3: Roll Out and Monitor

```
1. Start with internal users (dogfooding)
2. Roll out to 1% → 5% → 25% → 50% → 100%
3. Monitor error rates, latency, and business metrics at each stage
4. Pause or rollback if guardrail metrics are breached
5. Complete rollout when all metrics are stable
```

### Step 4: Clean Up Flag Debt

```
1. Confirm flag is at 100% for the required bake period (2+ weeks)
2. Remove dead code paths controlled by the flag
3. Remove flag from codebase, configuration, and dashboard
4. Close associated experiment or tracking records
5. Archive documentation
```

## Advanced Techniques

### 1. Flag Evaluation Engine with Consistent Hashing

```typescript
import { createHash } from 'crypto';

interface FlagDefinition {
  enabled: boolean;
  type: 'release' | 'experiment' | 'ops' | 'permission';
  owner: string;
  createdAt: string;
  cleanupBy: string;
  percentage?: number;
  userIds?: string[];
  excludeUserIds?: string[];
  groups?: string[];
  attributes?: Record<string, unknown>;
  variants?: Record<string, { weight: number }>;
  defaultVariant?: string;
}

interface EvaluationResult {
  enabled: boolean;
  variant: string | null;
  reason: string;
  flagRevision: number;
}

class FeatureFlagEngine {
  private flags: Map<string, FlagDefinition>;
  private revision: number = 0;

  constructor(flags: Map<string, FlagDefinition>) {
    this.flags = flags;
  }

  /**
   * Evaluate a flag for a specific user context.
   * Evaluation order matters: global kill switch → whitelist → blacklist →
   * group targeting → attribute targeting → percentage rollout → variant assignment.
   */
  evaluate(
    flagName: string,
    userId: string,
    context: {
      groups?: string[];
      attributes?: Record<string, unknown>;
      environment?: string;
    } = {}
  ): EvaluationResult {
    const flag = this.flags.get(flagName);

    if (!flag) {
      return { enabled: false, variant: null, reason: 'flag_not_found', flagRevision: this.revision };
    }

    // 1. Global kill switch
    if (!flag.enabled) {
      return { enabled: false, variant: null, reason: 'flag_disabled', flagRevision: this.revision };
    }

    // 2. User whitelist (always enabled, bypasses percentage)
    if (flag.userIds && flag.userIds.includes(userId)) {
      return {
        enabled: true,
        variant: this.resolveVariant(flag, userId),
        reason: 'user_whitelisted',
        flagRevision: this.revision,
      };
    }

    // 3. User blacklist (always disabled)
    if (flag.excludeUserIds && flag.excludeUserIds.includes(userId)) {
      return { enabled: false, variant: null, reason: 'user_blacklisted', flagRevision: this.revision };
    }

    // 4. Group targeting
    if (flag.groups && flag.groups.length > 0) {
      const userGroups = context.groups || [];
      const hasMatchingGroup = flag.groups.some((g) => userGroups.includes(g));
      if (!hasMatchingGroup) {
        return { enabled: false, variant: null, reason: 'group_not_matched', flagRevision: this.revision };
      }
    }

    // 5. Attribute targeting
    if (flag.attributes && context.attributes) {
      const matches = Object.entries(flag.attributes).every(([key, value]) => {
        return context.attributes![key] === value;
      });
      if (!matches) {
        return { enabled: false, variant: null, reason: 'attribute_not_matched', flagRevision: this.revision };
      }
    }

    // 6. Percentage rollout
    const percentage = flag.percentage ?? 100;
    const hashBucket = this.hashToBucket(flagName, userId);
    if (hashBucket >= percentage) {
      return { enabled: false, variant: null, reason: 'percentage_not_reached', flagRevision: this.revision };
    }

    // 7. Enabled with variant
    return {
      enabled: true,
      variant: this.resolveVariant(flag, userId),
      reason: 'flag_enabled',
      flagRevision: this.revision,
    };
  }

  /**
   * Consistent hashing: same user always gets the same bucket.
   * Uses MD5 for speed (determinism matters, not cryptographic strength).
   */
  private hashToBucket(flagName: string, userId: string): number {
    const hash = createHash('md5').update(`${flagName}:${userId}`).digest('hex');
    return parseInt(hash.substring(0, 8), 16) % 100;
  }

  /**
   * Assign a variant based on weighted distribution.
   * Uses the same hash as percentage rollout for consistency.
   */
  private resolveVariant(flag: FlagDefinition, userId: string): string | null {
    if (!flag.variants || Object.keys(flag.variants).length === 0) {
      return flag.defaultVariant || null;
    }

    const hashBucket = this.hashToBucket(`variant:${flag.variants}`, userId);
    let cumulative = 0;

    for (const [variant, config] of Object.entries(flag.variants)) {
      cumulative += config.weight;
      if (hashBucket < cumulative) {
        return variant;
      }
    }

    // Fallback to last variant (should not happen with valid weights)
    return Object.keys(flag.variants).pop() || null;
  }

  /**
   * Bulk evaluate multiple flags for a user (SDK-style).
   */
  evaluateAll(
    userId: string,
    context: { groups?: string[]; attributes?: Record<string, unknown> } = {}
  ): Record<string, EvaluationResult> {
    const results: Record<string, EvaluationResult> = {};
    for (const flagName of this.flags.keys()) {
      results[flagName] = this.evaluate(flagName, userId, context);
    }
    return results;
  }
}
```

### 2. LaunchDarkly SDK Integration

```typescript
import { initialize, LDClient, LDContext } from '@launchdarkly/node-server-sdk';

class LaunchDarklyFlagService {
  private client: LDClient;
  private initialized: boolean = false;

  constructor(sdkKey: string) {
    this.client = initialize(sdkKey);
  }

  async waitForReady(timeoutMs: number = 10000): Promise<void> {
    const ready = await Promise.race([
      this.client.waitForInitialization(),
      new Promise<boolean>((_, reject) =>
        setTimeout(() => reject(new Error('LD init timeout')), timeoutMs)
      ),
    ]);
    this.initialized = true;
  }

  /**
   * Evaluate a boolean flag.
   */
  async isEnabled(
    flagKey: string,
    userId: string,
    fallback: boolean = false
  ): Promise<boolean> {
    if (!this.initialized) return fallback;

    const context: LDContext = {
      kind: 'user',
      key: userId,
    };

    try {
      return await this.client.variation(flagKey, context, fallback);
    } catch (err) {
      console.error(`LD evaluation failed for ${flagKey}:`, err);
      return fallback;
    }
  }

  /**
   * Evaluate a multivariate flag and return the variant key.
   */
  async getVariant(
    flagKey: string,
    userId: string,
    fallback: string = 'control'
  ): Promise<string> {
    if (!this.initialized) return fallback;

    const context: LDContext = {
      kind: 'user',
      key: userId,
    };

    try {
      return (await this.client.variation(flagKey, context, fallback)) as string;
    } catch (err) {
      console.error(`LD variant evaluation failed for ${flagKey}:`, err);
      return fallback;
    }
  }

  /**
   * Track a custom event for experiment analysis.
   */
  async trackEvent(
    eventName: string,
    userId: string,
    value?: number,
    data?: Record<string, unknown>
  ): Promise<void> {
    if (!this.initialized) return;

    const context: LDContext = { kind: 'user', key: userId };
    await this.client.track(eventName, context, value, data);
  }

  /**
   * Register a feature flag listener for real-time updates.
   */
  onFlagChange(
    flagKey: string,
    callback: (oldValue: unknown, newValue: unknown) => void
  ): void {
    this.client.on(`change:${flagKey}`, callback);
  }

  async close(): Promise<void> {
    await this.client.close();
  }
}
```

### 3. Unleash SDK Integration

```typescript
import { initialize, InMemStorageProvider, Unleash } from 'unleash-client';

class UnleashFlagService {
  private unleash: Unleash;

  constructor(config: {
    url: string;
    appName: string;
    customHeaders: { Authorization: string };
  }) {
    this.unleash = initialize({
      url: config.url,
      appName: config.appName,
      customHeaders: config.customHeaders,
      refreshInterval: 15_000,
      metricsInterval: 60_000,
      disableMetrics: false,
      bootstrap: {
        data: {},
        url: `${config.url}/api/client/bootstrap`,
      },
    });
  }

  isEnabled(
    featureName: string,
    context: { userId: string; properties?: Record<string, string> } = { userId: 'anonymous' },
    fallback: boolean = false
  ): boolean {
    try {
      return this.unleash.isEnabled(featureName, context, fallback);
    } catch (err) {
      console.error(`Unleash evaluation failed for ${featureName}:`, err);
      return fallback;
    }
  }

  getVariant(
    featureName: string,
    context: { userId: string } = { userId: 'anonymous' }
  ): { enabled: boolean; variant: string } {
    try {
      const variant = this.unleash.getVariant(featureName, context);
      return {
        enabled: variant?.enabled ?? false,
        variant: variant?.name ?? 'disabled',
      };
    } catch (err) {
      console.error(`Unleash variant failed for ${featureName}:`, err);
      return { enabled: false, variant: 'disabled' };
    }
  }
}
```

### 4. Progressive Rollout Controller

```typescript
interface RolloutStage {
  name: string;
  percentage: number;
  durationMinutes: number;
  healthCheck: {
    errorRateThreshold: number;   // e.g., 0.01 = 1%
    latencyP95Threshold: number;  // e.g., 500ms
    conversionDropThreshold: number; // e.g., 0.10 = 10% drop
  };
}

interface HealthMetrics {
  errorRate: number;
  p95Latency: number;
  conversionRate: number;
  baselineConversionRate: number;
}

class ProgressiveRolloutController {
  private stages: RolloutStage[];
  private flagName: string;
  private currentStageIndex: number;
  private stageStartTime: Date;

  constructor(flagName: string, stages?: RolloutStage[]) {
    this.flagName = flagName;
    this.stages = stages || [
      { name: 'canary', percentage: 1, durationMinutes: 60, healthCheck: { errorRateThreshold: 0.005, latencyP95Threshold: 500, conversionDropThreshold: 0.15 } },
      { name: 'early_adopters', percentage: 5, durationMinutes: 120, healthCheck: { errorRateThreshold: 0.005, latencyP95Threshold: 500, conversionDropThreshold: 0.10 } },
      { name: 'quarter', percentage: 25, durationMinutes: 180, healthCheck: { errorRateThreshold: 0.01, latencyP95Threshold: 500, conversionDropThreshold: 0.10 } },
      { name: 'half', percentage: 50, durationMinutes: 180, healthCheck: { errorRateThreshold: 0.01, latencyP95Threshold: 500, conversionDropThreshold: 0.05 } },
      { name: 'full', percentage: 100, durationMinutes: 0, healthCheck: { errorRateThreshold: 0.01, latencyP95Threshold: 500, conversionDropThreshold: 0.05 } },
    ];
    this.currentStageIndex = 0;
    this.stageStartTime = new Date();
  }

  /**
   * Evaluate whether the current stage is healthy and we should advance.
   */
  async evaluate(metrics: HealthMetrics): Promise<{
    action: 'advance' | 'hold' | 'rollback';
    currentStage: RolloutStage;
    reason: string;
  }> {
    const stage = this.stages[this.currentStageIndex];

    // Check health criteria
    const violations: string[] = [];

    if (metrics.errorRate > stage.healthCheck.errorRateThreshold) {
      violations.push(
        `error rate ${(metrics.errorRate * 100).toFixed(2)}% > threshold ${(stage.healthCheck.errorRateThreshold * 100).toFixed(2)}%`
      );
    }

    if (metrics.p95Latency > stage.healthCheck.latencyP95Threshold) {
      violations.push(
        `p95 latency ${metrics.p95Latency}ms > threshold ${stage.healthCheck.latencyP95Threshold}ms`
      );
    }

    if (metrics.baselineConversionRate > 0) {
      const conversionDrop =
        (metrics.baselineConversionRate - metrics.conversionRate) /
        metrics.baselineConversionRate;
      if (conversionDrop > stage.healthCheck.conversionDropThreshold) {
        violations.push(
          `conversion drop ${(conversionDrop * 100).toFixed(1)}% > threshold ${(stage.healthCheck.conversionDropThreshold * 100).toFixed(1)}%`
        );
      }
    }

    // If violations, rollback
    if (violations.length > 0) {
      return {
        action: 'rollback',
        currentStage: stage,
        reason: `Health check failed: ${violations.join('; ')}`,
      };
    }

    // Check if duration has elapsed
    const elapsed = (Date.now() - this.stageStartTime.getTime()) / 60_000;
    if (elapsed < stage.durationMinutes) {
      return {
        action: 'hold',
        currentStage: stage,
        reason: `Stage ${stage.name} at ${stage.percentage}% — waiting ${Math.ceil(stage.durationMinutes - elapsed)} more minutes`,
      };
    }

    // Advance to next stage
    if (this.currentStageIndex < this.stages.length - 1) {
      this.currentStageIndex++;
      this.stageStartTime = new Date();
      return {
        action: 'advance',
        currentStage: this.stages[this.currentStageIndex],
        reason: `Advancing to ${this.stages[this.currentStageIndex].name} at ${this.stages[this.currentStageIndex].percentage}%`,
      };
    }

    // Already at full rollout
    return {
      action: 'advance',
      currentStage: stage,
      reason: 'Rollout complete — at 100%',
    };
  }

  getCurrentPercentage(): number {
    return this.stages[this.currentStageIndex].percentage;
  }

  reset(): void {
    this.currentStageIndex = 0;
    this.stageStartTime = new Date();
  }
}
```

### 5. A/B Test Statistical Analysis

```typescript
interface ExperimentResult {
  controlVisitors: number;
  controlConversions: number;
  treatmentVisitors: number;
  treatmentConversions: number;
}

interface SignificanceResult {
  controlRate: number;
  treatmentRate: number;
  lift: number;
  pValue: number;
  isSignificant: boolean;
  confidence: number;
  sampleSize: number;
  power: number;
  recommendedAction: string;
}

class ABTestAnalyzer {
  private confidenceLevel: number;
  private minimumDetectableEffect: number;

  constructor(confidenceLevel: number = 0.95, mde: number = 0.05) {
    this.confidenceLevel = confidenceLevel;
    this.minimumDetectableEffect = mde;
  }

  /**
   * Two-proportion z-test for statistical significance.
   */
  analyze(result: ExperimentResult): SignificanceResult {
    const n1 = result.controlVisitors;
    const n2 = result.treatmentVisitors;
    const x1 = result.controlConversions;
    const x2 = result.treatmentConversions;

    if (n1 === 0 || n2 === 0) {
      return this.emptyResult();
    }

    const p1 = x1 / n1;
    const p2 = x2 / n2;

    // Pooled proportion
    const pPooled = (x1 + x2) / (n1 + n2);
    const sePooled = Math.sqrt(pPooled * (1 - pPooled) * (1 / n1 + 1 / n2));

    if (sePooled === 0) {
      return this.emptyResult();
    }

    const zScore = (p2 - p1) / sePooled;
    const pValue = 2 * (1 - this.normalCDF(Math.abs(zScore)));

    const lift = p1 > 0 ? ((p2 - p1) / p1) * 100 : 0;
    const isSignificant = pValue < 1 - this.confidenceLevel;

    // Statistical power calculation
    const seUnpooled = Math.sqrt((p1 * (1 - p1)) / n1 + (p2 * (1 - p2)) / n2);
    const effectSize = Math.abs(p2 - p1) / (sePooled || 0.001);
    const power = 1 - this.normalCDF(1.96 - effectSize);

    // Recommended action
    let recommendedAction: string;
    if (!isSignificant) {
      recommendedAction = 'Continue experiment — no statistically significant difference detected';
    } else if (lift > 0 && isSignificant) {
      recommendedAction = `Deploy treatment — ${(lift).toFixed(2)}% improvement with ${(1 - pValue) * 100}% confidence`;
    } else {
      recommendedAction = `Keep control — treatment shows ${(Math.abs(lift)).toFixed(2)}% regression`;
    }

    return {
      controlRate: p1,
      treatmentRate: p2,
      lift,
      pValue,
      isSignificant,
      confidence: (1 - pValue) * 100,
      sampleSize: n1 + n2,
      power,
      recommendedAction,
    };
  }

  /**
   * Calculate required sample size for desired power and MDE.
   */
  calculateRequiredSampleSize(
    baselineRate: number,
    mde: number = this.minimumDetectableEffect,
    power: number = 0.80
  ): number {
    const alpha = 1 - this.confidenceLevel;
    const p1 = baselineRate;
    const p2 = baselineRate * (1 + mde);
    const pAvg = (p1 + p2) / 2;

    const zAlpha = this.normalQuantile(1 - alpha / 2);
    const zBeta = this.normalQuantile(power);

    const numerator = Math.pow(
      zAlpha * Math.sqrt(2 * pAvg * (1 - pAvg)) +
        zBeta * Math.sqrt(p1 * (1 - p1) + p2 * (1 - p2)),
      2
    );
    const denominator = Math.pow(p2 - p1, 2);

    return Math.ceil(numerator / denominator);
  }

  private normalCDF(x: number): number {
    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;
    const p = 0.3275911;

    const sign = x >= 0 ? 1 : -1;
    x = Math.abs(x) / Math.sqrt(2);

    const t = 1.0 / (1.0 + p * x);
    const y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);

    return 0.5 * (1.0 + sign * y);
  }

  private normalQuantile(p: number): number {
    // Rational approximation for the normal quantile function
    if (p <= 0) return -Infinity;
    if (p >= 1) return Infinity;
    if (p === 0.5) return 0;

    const a = [
      -3.969683028665376e+01, 2.209460984245205e+02,
      -2.759285104469687e+02, 1.383577518672690e+02,
      -3.066479806614716e+01, 2.506628277459239e+00,
    ];
    const b = [
      -5.447609879822406e+01, 1.615858368580409e+02,
      -1.556989798598866e+02, 6.680131188771972e+01,
      -1.328068155288572e+01,
    ];
    const c = [
      -7.784894002430293e-03, -3.223964580411365e-01,
      -2.400758277161838e+00, -2.549732539343734e+00,
      4.374664141464968e+00, 2.938163982698783e+00,
    ];
    const d = [
      7.784695709041462e-03, 3.224671290700398e-01,
      2.445134137142996e+00, 3.754408661907416e+00,
    ];

    const pLow = 0.02425;
    const pHigh = 1 - pLow;
    let q: number;
    let r: number;

    if (p < pLow) {
      q = Math.sqrt(-2 * Math.log(p));
      return (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) /
        ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
    } else if (p <= pHigh) {
      q = p - 0.5;
      r = q * q;
      return (((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]) * q /
        (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1);
    } else {
      q = Math.sqrt(-2 * Math.log(1 - p));
      return -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) /
        ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
    }
  }

  private emptyResult(): SignificanceResult {
    return {
      controlRate: 0, treatmentRate: 0, lift: 0,
      pValue: 1, isSignificant: false, confidence: 0,
      sampleSize: 0, power: 0,
      recommendedAction: 'Insufficient data — continue collecting',
    };
  }
}
```

### 6. Kill Switch and Circuit Breaker

```typescript
interface CircuitBreakerConfig {
  failureThreshold: number;    // Consecutive failures before opening
  recoveryTimeMs: number;      // Time before attempting recovery
  halfOpenMaxAttempts: number; // Tests in half-open state
}

type CircuitState = 'closed' | 'open' | 'half-open';

class FeatureKillSwitch {
  private state: CircuitState = 'closed';
  private failureCount: number = 0;
  private lastFailureTime: number = 0;
  private halfOpenAttempts: number = 0;
  private config: CircuitBreakerConfig;
  private flagName: string;

  constructor(flagName: string, config?: Partial<CircuitBreakerConfig>) {
    this.flagName = flagName;
    this.config = {
      failureThreshold: config?.failureThreshold ?? 5,
      recoveryTimeMs: config?.recoveryTimeMs ?? 60_000,
      halfOpenMaxAttempts: config?.halfOpenMaxAttempts ?? 3,
    };
  }

  /**
   * Execute a function with kill switch protection.
   * Opens the circuit after consecutive failures; blocks calls while open.
   */
  async execute<T>(fn: () => Promise<T>): Promise<T> {
    // If circuit is open, check if recovery window has elapsed
    if (this.state === 'open') {
      const elapsed = Date.now() - this.lastFailureTime;
      if (elapsed >= this.config.recoveryTimeMs) {
        this.state = 'half-open';
        this.halfOpenAttempts = 0;
        console.log(`[KillSwitch:${this.flagName}] Entering half-open state`);
      } else {
        throw new CircuitOpenError(
          this.flagName,
          `Circuit open — retry in ${Math.ceil((this.config.recoveryTimeMs - elapsed) / 1000)}s`
        );
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (err) {
      this.onFailure();
      throw err;
    }
  }

  private onSuccess(): void {
    if (this.state === 'half-open') {
      this.halfOpenAttempts++;
      if (this.halfOpenAttempts >= this.config.halfOpenMaxAttempts) {
        this.state = 'closed';
        this.failureCount = 0;
        console.log(`[KillSwitch:${this.flagName}] Circuit closed — service recovered`);
      }
    } else {
      this.failureCount = 0;
    }
  }

  private onFailure(): void {
    this.failureCount++;
    this.lastFailureTime = Date.now();

    if (this.state === 'half-open') {
      this.state = 'open';
      console.log(`[KillSwitch:${this.flagName}] Reopened during half-open`);
    } else if (this.failureCount >= this.config.failureThreshold) {
      this.state = 'open';
      console.log(`[KillSwitch:${this.flagName}] Circuit OPENED after ${this.failureCount} failures`);
    }
  }

  getState(): CircuitState {
    return this.state;
  }

  /**
   * Manually trip the kill switch (e.g., during incident response).
   */
  trip(): void {
    this.state = 'open';
    this.lastFailureTime = Date.now();
    console.log(`[KillSwitch:${this.flagName}] Manually tripped`);
  }

  /**
   * Manually reset the kill switch.
   */
  reset(): void {
    this.state = 'closed';
    this.failureCount = 0;
    this.halfOpenAttempts = 0;
    console.log(`[KillSwitch:${this.flagName}] Manually reset`);
  }
}

class CircuitOpenError extends Error {
  flagName: string;
  constructor(flagName: string, message: string) {
    super(message);
    this.name = 'CircuitOpenError';
    this.flagName = flagName;
  }
}
```

### 7. Flag Registry and Debt Management

```typescript
interface FlagRegistryEntry {
  name: string;
  type: 'release' | 'experiment' | 'ops' | 'permission';
  owner: string;
  team: string;
  createdAt: string;
  cleanupBy: string;
  description: string;
  status: 'active' | 'stale' | 'scheduled_for_removal' | 'removed';
  references: {
    pr?: string;
    experiment?: string;
    runbook?: string;
  };
}

class FlagRegistry {
  private entries: Map<string, FlagRegistryEntry> = new Map();

  register(entry: FlagRegistryEntry): void {
    if (this.entries.has(entry.name)) {
      throw new Error(`Flag "${entry.name}" already registered`);
    }
    this.entries.set(entry.name, entry);
  }

  /**
   * Find all flags that have exceeded their cleanup date.
   */
  findStaleFlags(): FlagRegistryEntry[] {
    const now = new Date();
    const stale: FlagRegistryEntry[] = [];

    for (const entry of this.entries.values()) {
      if (entry.status === 'active' && new Date(entry.cleanupBy) < now) {
        stale.push(entry);
      }
    }

    return stale.sort((a, b) => new Date(a.cleanupBy).getTime() - new Date(b.cleanupBy).getTime());
  }

  /**
   * Generate a flag debt report.
   */
  generateDebtReport(): {
    total: number;
    active: number;
    stale: number;
    byTeam: Record<string, number>;
    byType: Record<string, number>;
    oldestFlags: FlagRegistryEntry[];
  } {
    const byTeam: Record<string, number> = {};
    const byType: Record<string, number> = {};
    let active = 0;
    let stale = 0;
    const now = new Date();

    for (const entry of this.entries.values()) {
      byTeam[entry.team] = (byTeam[entry.team] || 0) + 1;
      byType[entry.type] = (byType[entry.type] || 0) + 1;

      if (entry.status === 'active') {
        active++;
        if (new Date(entry.cleanupBy) < now) {
          stale++;
        }
      }
    }

    const oldestFlags = [...this.entries.values()]
      .filter((e) => e.status === 'active')
      .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
      .slice(0, 10);

    return {
      total: this.entries.size,
      active,
      stale,
      byTeam,
      byType,
      oldestFlags,
    };
  }

  /**
   * Enforce cleanup policy: mark flags past their cleanup date as stale.
   */
  enforceCleanupPolicy(): FlagRegistryEntry[] {
    const staleFlags = this.findStaleFlags();
    for (const flag of staleFlags) {
      flag.status = 'stale';
    }
    return staleFlags;
  }
}
```

### 8. Multi-Service Flag Synchronization

```typescript
interface FlagSyncConfig {
  pollingIntervalMs: number;
  etag?: string;
  baseUrl: string;
  authToken: string;
}

class MultiServiceFlagSync {
  private config: FlagSyncConfig;
  private flags: Map<string, FlagDefinition> = new Map();
  private listeners: Map<string, Set<(flag: FlagDefinition) => void>> = new Map();

  constructor(config: FlagSyncConfig) {
    this.config = config;
  }

  /**
   * Poll for flag changes and propagate to downstream services.
   */
  async startSync(): Promise<void> {
    while (true) {
      try {
        const response = await fetch(`${this.config.baseUrl}/api/flags`, {
          headers: {
            'Authorization': `Bearer ${this.config.authToken}`,
            'If-None-Match': this.config.etag || '',
          },
        });

        if (response.status === 304) {
          // No changes
          await this.sleep(this.config.pollingIntervalMs);
          continue;
        }

        this.config.etag = response.headers.get('etag') || undefined;
        const data = await response.json() as Record<string, FlagDefinition>;

        // Detect changes and notify listeners
        for (const [name, flag] of Object.entries(data)) {
          const oldFlag = this.flags.get(name);
          this.flags.set(name, flag);

          if (oldFlag && JSON.stringify(oldFlag) !== JSON.stringify(flag)) {
            this.notifyListeners(name, flag);
          }
        }
      } catch (err) {
        console.error('[FlagSync] Poll failed:', err);
      }

      await this.sleep(this.config.pollingIntervalMs);
    }
  }

  private notifyListeners(flagName: string, flag: FlagDefinition): void {
    const callbacks = this.listeners.get(flagName);
    if (callbacks) {
      for (const cb of callbacks) {
        try {
          cb(flag);
        } catch (err) {
          console.error(`[FlagSync] Listener error for ${flagName}:`, err);
        }
      }
    }
  }

  onChange(flagName: string, callback: (flag: FlagDefinition) => void): void {
    if (!this.listeners.has(flagName)) {
      this.listeners.set(flagName, new Set());
    }
    this.listeners.get(flagName)!.add(callback);
  }

  getFlag(name: string): FlagDefinition | undefined {
    return this.flags.get(name);
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
```

## Common Patterns

### Pattern 1: Release Flag with Gradual Rollout

```typescript
// Usage in application code
const flagEngine = new FeatureFlagEngine(flagStore);

async function renderCheckout(userId: string) {
  const result = flagEngine.evaluate('new_checkout_flow', userId, {
    groups: await getUserGroups(userId),
  });

  if (result.enabled) {
    return renderNewCheckout(userId);
  }
  return renderLegacyCheckout(userId);
}
```

### Pattern 2: A/B Test with Event Tracking

```typescript
// Experiment setup
const analyzer = new ABTestAnalyzer(0.95, 0.05);

async function handleSignup(userId: string, email: string) {
  const result = flagEngine.evaluate('signup_form_experiment', userId);

  if (!result.enabled) {
    return renderControlSignup(email);
  }

  // Track impression
  await trackEvent('signup_impression', userId, { variant: result.variant });

  // Render variant
  const conversion = result.variant === 'treatment'
    ? await renderNewSignup(email)
    : await renderControlSignup(email);

  // Track conversion
  await trackEvent('signup_conversion', userId, { variant: result.variant });

  return conversion;
}

// Later, analyze results
const results = analyzer.analyze({
  controlVisitors: 10_000,
  controlConversions: 500,
  treatmentVisitors: 10_000,
  treatmentConversions: 575,
});

console.log(results.recommendedAction);
// "Deploy treatment — 15.00% improvement with 98.3% confidence"
```

### Pattern 3: Kill Switch During Incident

```typescript
// During a database overload incident
const killSwitch = new FeatureKillSwitch('real_time_sync', {
  failureThreshold: 3,
  recoveryTimeMs: 300_000, // 5 minutes
});

// Disable the feature globally
killSwitch.trip();

// Or in feature flag service
await flagService.setFlag('real_time_sync', { enabled: false });

// Resume after incident
killSwitch.reset();
await flagService.setFlag('real_time_sync', { enabled: true });
```

### Pattern 4: Flag Cleanup Pipeline

```typescript
// CI/CD check for stale flags
const registry = new FlagRegistry();
const staleFlags = registry.findStaleFlags();

if (staleFlags.length > 0) {
  console.error(`${staleFlags.length} feature flags have exceeded their cleanup date:`);
  for (const flag of staleFlags) {
    console.error(`  - ${flag.name} (owner: ${flag.owner}, cleanup by: ${flag.cleanupBy})`);
  }
  process.exit(1); // Fail the pipeline
}
```

### Pattern 5: Custom Flag Service with Redis Backend

```typescript
import Redis from 'ioredis';

class RedisFlagStore {
  private redis: Redis;
  private prefix = 'flags:';

  constructor(redisUrl: string) {
    this.redis = new Redis(redisUrl);
  }

  async getFlag(name: string): Promise<FlagDefinition | null> {
    const data = await this.redis.get(`${this.prefix}${name}`);
    return data ? JSON.parse(data) : null;
  }

  async setFlag(name: string, flag: FlagDefinition): Promise<void> {
    await this.redis.set(`${this.prefix}${name}`, JSON.stringify(flag));
    await this.redis.publish(`${this.prefix}changes`, JSON.stringify({ name, flag }));
  }

  async getAllFlags(): Promise<Map<string, FlagDefinition>> {
    const keys = await this.redis.keys(`${this.prefix}*`);
    const flags = new Map<string, FlagDefinition>();

    for (const key of keys) {
      const name = key.replace(this.prefix, '');
      const data = await this.redis.get(key);
      if (data) flags.set(name, JSON.parse(data));
    }

    return flags;
  }

  /**
   * Subscribe to real-time flag changes across services.
   */
  subscribeToChanges(callback: (name: string, flag: FlagDefinition) => void): void {
    const subscriber = this.redis.duplicate();
    subscriber.subscribe(`${this.prefix}changes`);
    subscriber.on('message', (_channel, message) => {
      const { name, flag } = JSON.parse(message);
      callback(name, flag);
    });
  }
}
```

## Edge Cases & Pitfalls

1. **Flag evaluation in the critical path** — Every flag evaluation adds latency; cache flag values locally and use async evaluation for non-critical flags to avoid slowing down request handling.

2. **Inconsistent evaluation across services** — Without synchronized flag state, Service A may see a flag as enabled while Service B sees it disabled; use a centralized flag store with pub/sub change notifications.

3. **Flag interaction explosions** — Two flags individually safe may break when combined; test flag combinations that could be active simultaneously, especially for experiment flags.

4. **Race condition during percentage rollouts** — A user may see different behavior on consecutive requests if the flag store is being updated mid-request; use consistent hashing with a stable flag revision to prevent flickering.

5. **Stale cache after flag change** — SDKs may cache flag values; ensure cache TTLs are short enough for kill switches to take effect within your required response time.

6. **Null pointer on missing flag** — Always provide a safe default when evaluating a flag that does not exist; never let a missing flag cause a production error.

7. **Dead code accumulation (flag debt)** — Flags left at 100% indefinitely create confusion and maintenance burden; enforce cleanup deadlines with automated checks in CI pipelines.

8. **Experiment contamination** — Users in multiple simultaneous experiments may receive conflicting treatments; use a mutually exclusive experiment framework or namespace experiments.

9. **Over-reliance on percentage rollouts** — Percentages alone are not sufficient for targeting; users with the same ID may have very different contexts (device, location, subscription tier) that affect rollout safety.

10. **Flag targeting rule precedence** — Unspecified precedence between whitelist, group, and percentage rules leads to unexpected behavior; always document and enforce a strict evaluation order.

11. **Missing observability on flag evaluations** — Without logging which variant was served, debugging experiment results or incident response becomes impossible; always emit evaluation events with flag name, user, variant, and reason.

12. **Cold start on flag initialization** — SDKs may need to download flag state on startup; ensure your application does not serve traffic until flags are initialized, or use a bootstrap file.

13. **Flag name collisions across teams** — Without namespacing, two teams may create flags with the same name; enforce a naming convention like `{team}.{feature}.{type}`.

14. **Experiment statistical invalidity** — Stopping an experiment early when results look promising inflates false positive rates; always reach the pre-calculated sample size before declaring significance.

15. **All-or-nothing flag cleanup** — Removing a flag and its dead code in one PR is risky if the flag was recently toggled; use a two-phase cleanup: first disable the flag, then remove the code in a follow-up PR after bake time.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| ci-cd | Pipeline-gated flag deployment, stale flag detection | ↔ | CI checks enforce flag cleanup policies; pipelines deploy flag configs |
| monitoring-observability | Flag evaluation metrics, experiment event tracking | → | Emit flag metrics to Prometheus; track experiment conversions |
| incident-response | Kill switch activation, rollback via flags | ↔ | Flags enable instant feature rollback during incidents |
| testing-e2e | Flag-aware E2E tests, experiment variant testing | → | Tests must cover both flag states; verify variant rendering |
| deployment | Progressive rollout orchestration | → | Flags control deployment traffic shifting |
| api-design | API versioning behind flags | ↔ | Flags gate new API behavior during rollout |
| logging | Structured flag evaluation logs | → | Log flag name, user, variant, and reason on each evaluation |

## Output Format Templates

### Template 1: Feature Flag Configuration

```markdown
## Feature Flag: `{flag_name}`

### Metadata
- **Type:** release | experiment | ops | permission
- **Owner:** @team-member
- **Team:** team-name
- **Created:** YYYY-MM-DD
- **Cleanup By:** YYYY-MM-DD
- **Description:** Brief description of the flag's purpose

### Configuration
| Setting | Value |
|---------|-------|
| Enabled | true |
| Default Percentage | 25% |
| Whitelist | user_123, user_456 |
| Blacklist | user_789 |
| Groups | beta-testers, internal |

### Variants (for experiments)
| Variant | Weight | Description |
|---------|--------|-------------|
| control | 50% | Current checkout flow |
| treatment | 50% | New Stripe checkout |

### Rollout Plan
1. **Canary (1%):** 24 hours, monitor error rate
2. **Early Adopters (5%):** 48 hours, monitor conversion
3. **Quarter (25%):** 72 hours, monitor latency
4. **Half (50%):** 72 hours, monitor all metrics
5. **Full (100%):** Bake for 2 weeks, then cleanup

### Guardrail Metrics
| Metric | Threshold | Action |
|--------|-----------|--------|
| Error rate | > 1% | Rollback |
| P95 latency | > 500ms | Hold |
| Conversion drop | > 10% | Rollback |
```

### Template 2: Experiment Results Report

```markdown
## Experiment: `{experiment_name}`

### Duration: X days (Y total visitors)
### Status: Completed | Running | Paused

### Results
| Metric | Control | Treatment | Lift | P-Value | Significant |
|--------|---------|-----------|------|---------|-------------|
| Conversion rate | X% | Y% | +Z% | 0.0XX | Yes/No |

### Sample Size
- Control: X visitors, Y conversions
- Treatment: X visitors, Y conversions
- Required: Z visitors per variant (at 80% power, 5% MDE)

### Recommendation
[Deploy treatment / Keep control / Continue experiment]

### Notes
[Any external factors, data quality issues, or segment breakdowns]
```

### Template 3: Flag Debt Audit Report

```markdown
## Flag Debt Audit — YYYY-MM-DD

### Summary
| Metric | Count |
|--------|-------|
| Total flags | X |
| Active | X |
| Stale (past cleanup) | X |
| Scheduled for removal | X |

### Stale Flags
| Flag | Owner | Team | Created | Cleanup By | Days Overdue |
|------|-------|------|---------|------------|--------------|
| flag_name | @user | team | YYYY-MM-DD | YYYY-MM-DD | X days |

### By Team
| Team | Active | Stale | Debt Ratio |
|------|--------|-------|------------|
| team-a | X | Y | Z% |

### Recommendations
1. [Priority stale flags to clean up]
2. [Teams with highest debt ratios]
3. [Oldest flags requiring investigation]
```

### Template 4: Kill Switch Runbook

```markdown
## Kill Switch: `{flag_name}`

### Feature Description
[What the feature does and why it might need to be killed]

### Activation Procedure
1. Navigate to [flag management dashboard]
2. Toggle `{flag_name}` to **disabled**
3. Confirm propagation (verify via `/flags` endpoint)
4. Monitor error rates for 5 minutes
5. Update incident channel with status

### Automated Kill Switch
```bash
# Via CLI
feature-flag disable --flag {flag_name} --reason "incident-{id}"
```

### Impact Assessment
- **User impact:** [Description of what changes when flag is disabled]
- **Data impact:** [Any data that may be lost or affected]
- **Rollback:** [How to re-enable the flag]

### Deactivation Procedure
1. Confirm incident is resolved
2. Re-enable flag at 1% canary
3. Monitor for 15 minutes
4. Gradually increase percentage
5. Confirm all metrics normal
```

## Rules

1. **Every flag must have an owner and a cleanup date** — Orphaned flags accumulate silently; no flag ships without an accountable person and a hard deadline for removal.

2. **Default to the safe (old) behavior** — When a flag is missing or evaluation fails, the application must behave exactly as it did before the flag existed.

3. **Remove flags within 2 weeks of full rollout** — Stale flags are technical debt; enforce this with automated CI checks that fail builds containing expired flags.

4. **Use consistent hashing for percentage rollouts** — The same user must always receive the same variant within a flag to prevent flickering and experiment contamination.

5. **Never put flag evaluation in a blocking hot path without caching** — Flag SDK calls may involve network round trips; cache evaluations locally with a short TTL.

6. **Always log flag evaluations with reason codes** — When debugging experiment results or incidents, you need to know which variant was served and why.

7. **Test both flag states in E2E tests** — Every code path behind a flag must be tested with the flag both enabled and disabled to prevent dead code regressions.

8. **Namespace flag names by team and feature** — Use a naming convention like `{team}.{feature}.{type}` to prevent cross-team collisions.

9. **Do not stop experiments early based on preliminary results** — Premature termination inflates false positive rates; always reach the pre-calculated sample size.

10. **Use a two-phase cleanup process** — First disable the flag for 1 week, then remove the code in a separate PR to reduce blast radius.

11. **Implement circuit breakers for flag service calls** — If the flag service is unreachable, the application must degrade gracefully, not crash.

12. **Audit flag combinations before shipping** — When multiple flags affect the same user flow, test the interaction to prevent unexpected combined behaviors.
