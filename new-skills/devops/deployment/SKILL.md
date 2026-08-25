---
name: deployment
description: >-
  Deploy applications to cloud providers, manage environments, and handle releases.
  TRIGGERS: deploy, deployment, release, production, staging, environment, publish,
  deploy to aws, deploy to gcp, deploy to azure, serverless, lambda,
  استقرار, انتشار, پروداکشن, محیط اجرا, استقرار ابری,
  部署, 发布, 蓝绿部署, 金丝雀发布, 特性标志, 多区域部署
priority: P3
dependencies: [testing, ci-cd, dockerization]
conflicts: []
---

# Deployment Skill

## Purpose

Deploy applications safely with rollback capability using production-grade strategies including blue-green deployments, canary releases, rolling updates, feature flags, database migration coordination, monitoring, cost optimization, and multi-region architecture.

## When to Activate

- Deploying to staging or production environments
- Planning deployment strategy for a new service
- Implementing blue-green or canary deployment patterns
- Setting up feature flags for progressive rollouts
- Coordinating database migrations with deployments
- Configuring rollback mechanisms
- Setting up post-deployment monitoring
- Optimizing cloud infrastructure costs
- Planning multi-region deployment architecture

## Workflow

### Step 1: Pre-Deployment Checks

```
- [ ] All tests pass in CI/CD pipeline
- [ ] Build succeeds and image is tagged
- [ ] Security scan clean (no critical vulnerabilities)
- [ ] Environment variables configured for target environment
- [ ] Database migrations are backward compatible
- [ ] Rollback plan documented and tested
- [ ] Monitoring dashboards ready
- [ ] Team notified of deployment window
- [ ] Feature flags configured for gradual rollout
```

### Step 2: Deploy

```
1. Deploy to staging first
2. Run smoke tests against staging
3. Verify health checks pass
4. Deploy to production using chosen strategy
5. Monitor for anomalies
6. Gradually increase traffic (canary/blue-green)
```

### Step 3: Post-Deployment

```
1. Verify all health checks pass
2. Monitor error rates and latency
3. Check key business metrics
4. Validate database migrations completed
5. Confirm logging and alerting working
6. Update deployment changelog
7. Be ready to rollback if issues arise
```

## Advanced Techniques

### 1. Blue-Green Deployment

```yaml
# Kubernetes Blue-Green with two deployments
# blue-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
  labels:
    app: myapp
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: blue
  template:
    metadata:
      labels:
        app: myapp
        version: blue
    spec:
      containers:
        - name: app
          image: myapp:1.0.0
          ports:
            - containerPort: 3000

# green-deployment.yaml (new version)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
  labels:
    app: myapp
    version: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: green
  template:
    metadata:
      labels:
        app: myapp
        version: green
    spec:
      containers:
        - name: app
          image: myapp:2.0.0
          ports:
            - containerPort: 3000

# service.yaml (switch traffic)
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
    version: green    # Change to 'blue' to rollback instantly
  ports:
    - port: 80
      targetPort: 3000
```

```bash
# Blue-Green deployment script
#!/bin/bash
set -euo pipefail

CURRENT_COLOR=$(kubectl get service myapp -o jsonpath='{.spec.selector.version}')
NEW_COLOR=$([ "$CURRENT_COLOR" = "blue" ] && echo "green" || echo "blue")

echo "Deploying to $NEW_COLOR (current: $CURRENT_COLOR)"

# Deploy new version
kubectl apply -f ${NEW_COLOR}-deployment.yaml
kubectl rollout status deployment/app-${NEW_COLOR} --timeout=300s

# Switch traffic
kubectl patch service myapp -p "{\"spec\":{\"selector\":{\"version\":\"${NEW_COLOR}\"}}}"

echo "Traffic switched to $NEW_COLOR"
echo "To rollback: kubectl patch service myapp -p '{\"spec\":{\"selector\":{\"version\":\"${CURRENT_COLOR}\"}}}'"
```

### 2. Canary Releases

```yaml
# Progressive traffic shifting
# canary-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-canary
  labels:
    app: myapp
    track: canary
spec:
  replicas: 1     # 1 replica vs 9 stable = ~10% traffic
  selector:
    matchLabels:
      app: myapp
      track: canary
  template:
    metadata:
      labels:
        app: myapp
        track: canary
    spec:
      containers:
        - name: app
          image: myapp:2.0.0     # New version
          ports:
            - containerPort: 3000
```

```yaml
# Argo Rollouts for automated canary analysis
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: myapp
spec:
  replicas: 10
  strategy:
    canary:
      canaryService: myapp-canary
      stableService: myapp-stable
      trafficRouting:
        nginx:
          stableIngress: myapp-ingress
      analysis:
        templates:
          - templateName: canary-analysis
        args:
          - name: service-name
            value: myapp-canary.myapp.svc.cluster.local
      steps:
        - setWeight: 5
        - pause: { duration: 5m }
        - setWeight: 10
        - pause: { duration: 10m }
        - setWeight: 25
        - pause: { duration: 10m }
        - setWeight: 50
        - pause: { duration: 10m }
        - setWeight: 100

---
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: canary-analysis
spec:
  args:
    - name: service-name
  metrics:
    - name: success-rate
      interval: 2m
      count: 5
      successCondition: result[0] >= 0.99
      provider:
        prometheus:
          address: http://prometheus:9090
          query: |
            sum(rate(http_requests_total{service="{{args.service-name}}",status!~"5.*"}[2m])) /
            sum(rate(http_requests_total{service="{{args.service-name}}"}[2m]))
    - name: latency-p99
      interval: 2m
      count: 5
      successCondition: result[0] <= 500
      provider:
        prometheus:
          address: http://prometheus:9090
          query: |
            histogram_quantile(0.99,
              sum(rate(http_request_duration_seconds_bucket{service="{{args.service-name}}"}[2m])) by (le)
            ) * 1000
```

### 3. Rolling Updates

```yaml
# Kubernetes Rolling Update strategy
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2          # Allow 2 extra pods during update
      maxUnavailable: 1    # Allow 1 pod to be unavailable
  selector:
    matchLabels:
      app: myapp
  template:
    spec:
      containers:
        - name: app
          image: myapp:2.0.0
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 5
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "sleep 15"]   # Graceful drain
```

```bash
# Monitor rolling update
kubectl rollout status deployment/myapp --timeout=600s

# Check rollout history
kubectl rollout history deployment/myapp

# Rollback to previous version
kubectl rollout undo deployment/myapp

# Rollback to specific revision
kubectl rollout undo deployment/myapp --to-revision=3
```

### 4. Feature Flags

```typescript
// Feature flag implementation
interface FeatureFlags {
  newCheckoutFlow: boolean;
  darkMode: boolean;
  maxUploadSize: number;
}

class FeatureFlagService {
  private flags: FeatureFlags;
  private overrides: Map<string, boolean> = new Map();

  constructor(flags: FeatureFlags) {
    this.flags = flags;
  }

  isEnabled(flag: keyof FeatureFlags, userId?: string): boolean {
    // Check user-specific override first
    if (userId && this.overrides.has(`${userId}:${flag}`)) {
      return this.overrides.get(`${userId}:${flag}`)!;
    }
    // Fall back to global flag
    return this.flags[flag] as boolean;
  }

  // Gradual rollout by user ID hash
  isRolloutEnabled(flag: string, userId: string, percentage: number): boolean {
    const hash = this.hashCode(userId + flag);
    return (hash % 100) < percentage;
  }

  private hashCode(str: string): number {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.charCodeAt(i);
      hash |= 0;
    }
    return Math.abs(hash);
  }
}

// Usage in application
const flags = new FeatureFlagService({
  newCheckoutFlow: process.env.FF_NEW_CHECKOUT === 'true',
  darkMode: process.env.FF_DARK_MODE === 'true',
  maxUploadSize: parseInt(process.env.FF_MAX_UPLOAD || '10'),
});

// In route handler
app.post('/checkout', (req, res) => {
  if (flags.isEnabled('newCheckoutFlow', req.user.id)) {
    return newCheckoutHandler(req, res);
  }
  return legacyCheckoutHandler(req, res);
});
```

```yaml
# Feature flag environment variables
# staging.env
FF_NEW_CHECKOUT=true
FF_DARK_MODE=true
FF_MAX_UPLOAD=50

# production.env (gradual rollout)
FF_NEW_CHECKOUT=false      # Disabled in prod initially
FF_DARK_MODE=false
FF_MAX_UPLOAD=10
```

### 5. Database Migration Strategies

```sql
-- ── Zero-downtime migration pattern ──

-- Step 1: Expand (add new column, keep old)
ALTER TABLE users ADD COLUMN full_name VARCHAR(200);
CREATE INDEX idx_users_full_name ON users(full_name);

-- Step 2: Backfill (in background, batched)
DO $$
DECLARE
    batch_size INT := 1000;
    affected INT;
BEGIN
    LOOP
        UPDATE users
        SET full_name = first_name || ' ' || last_name
        WHERE id IN (
            SELECT id FROM users
            WHERE full_name IS NULL
            LIMIT batch_size
        );
        GET DIAGNOSTICS affected = ROW_COUNT;
        EXIT WHEN affected = 0;
        PERFORM pg_sleep(0.1);  -- Rate limit
        COMMIT;
    END LOOP;
END $$;

-- Step 3: Sync (application writes to both columns)
-- Code deploy: write to both full_name AND first_name/last_name

-- Step 4: Migrate reads (application reads from full_name)
-- Code deploy: read from full_name instead of first/last

-- Step 5: Contract (remove old columns)
-- ALTER TABLE users DROP COLUMN first_name;
-- ALTER TABLE users DROP COLUMN last_name;
-- Only after all application code is updated
```

```yaml
# Migration coordination in deployment pipeline
jobs:
  migrate:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Run migrations
        run: |
          npx prisma migrate deploy
          # or
          alembic upgrade head
      - name: Verify migration
        run: |
          npx prisma migrate status
          # Ensure all migrations applied

  deploy:
    needs: migrate    # Migrations run BEFORE deployment
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: kubectl apply -f k8s/
```

### 6. Rollback Strategies

```yaml
# ── Automated rollback with health check verification ──
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Capture current state
        id: state
        run: |
          PREVIOUS=$(kubectl get deployment app \
            -o jsonpath='{.spec.template.spec.containers[0].image}')
          echo "previous=$PREVIOUS" >> $GITHUB_OUTPUT
          echo "revision=$(kubectl rollout history deployment/app | tail -1 | awk '{print $1}')" >> $GITHUB_OUTPUT

      - name: Deploy new version
        id: deploy
        run: |
          kubectl set image deployment/app app=myapp:${{ github.sha }}
          kubectl rollout status deployment/app --timeout=300s

      - name: Verify health
        id: health
        run: |
          for i in {1..10}; do
            STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://example.com/health)
            if [ "$STATUS" != "200" ]; then
              echo "Health check failed (attempt $i)"
              sleep 10
            else
              echo "Health check passed"
              exit 0
            fi
          done
          echo "Health check failed after 10 attempts"
          exit 1

      - name: Auto-rollback on failure
        if: failure() && steps.deploy.outcome == 'success'
        run: |
          echo "Rolling back to revision ${{ steps.state.outputs.revision }}"
          kubectl rollout undo deployment/app --to-revision=${{ steps.state.outputs.revision }}
          kubectl rollout status deployment/app --timeout=300s
          echo "Rollback complete"
```

### 7. Monitoring Setup

```yaml
# ── Post-deployment monitoring configuration ──
# prometheus/alerts/deployment.yml
groups:
  - name: deployment
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.*"}[5m])) /
          sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate after deployment"
          description: "Error rate is {{ $value | humanizePercentage }}"

      - alert: HighLatency
        expr: |
          histogram_quantile(0.99,
            sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
          ) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P99 latency above 2s"

      - alert: PodRestartLoop
        expr: |
          increase(kube_pod_container_status_restarts_total[1h]) > 5
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: "Pod is crash-looping"
```

### 8. Cost Optimization

```yaml
# ── Right-sizing and auto-scaling ──
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 20
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Pods
          value: 4
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300    # 5 min cooldown
      policies:
        - type: Percent
          value: 10
          periodSeconds: 60

# ── Spot instances for non-critical workloads ──
# In node pool configuration:
# - Use spot/preemptible instances for batch jobs
# - Use on-demand for production serving
# - Savings: 60-90% on compute costs
```

```bash
# Cost monitoring commands
# AWS
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY --metrics UnblendedCost

# GCP
gcloud billing budgets list
gcloud billing budgets describe BUDGET_ID

# Azure
az cost management query --time-period 2024-01-01:2024-01-31
```

### 9. Multi-Region Deployment

```yaml
# ── Multi-region with global load balancer ──
# CloudFlare / AWS CloudFront / GCP Cloud CDN

# Region 1: us-east-1 (primary)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: us-east-1
spec:
  replicas: 5
  template:
    spec:
      containers:
        - name: app
          image: myapp:2.0.0
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: us-east-1

# Region 2: eu-west-1 (secondary)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: eu-west-1
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: app
          image: myapp:2.0.0
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: eu-west-1

# Global load balancer routes traffic to nearest region
# Failover: if primary region unhealthy, route to secondary
```

```bash
# Multi-region deployment script
REGIONS=("us-east-1" "eu-west-1" "ap-southeast-1")

for REGION in "${REGIONS[@]}"; do
    echo "Deploying to $REGION..."
    kubectl --context "$REGION" set image deployment/app \
        app=myapp:${VERSION} -n production
    kubectl --context "$REGION" rollout status deployment/app \
        -n production --timeout=300s
done

echo "All regions deployed successfully"
```

## Common Patterns

### Pattern 1: Blue-Green with Traffic Switch

```bash
#!/bin/bash
# blue-green-deploy.sh
set -euo pipefail

CURRENT=$(kubectl get svc myapp -o jsonpath='{.spec.selector.track}')
NEXT=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")

echo "Current: $CURRENT → Next: $NEXT"

# Deploy new version
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-$NEXT
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      track: $NEXT
  template:
    metadata:
      labels:
        app: myapp
        track: $NEXT
    spec:
      containers:
        - name: app
          image: myapp:$NEXT
EOF

# Wait for ready
kubectl rollout status deployment/myapp-$NEXT --timeout=300s

# Smoke test
curl -f http://myapp-$NEXT:3000/health

# Switch traffic
kubectl patch svc myapp -p "{\"spec\":{\"selector\":{\"track\":\"$NEXT\"}}}"

# Cleanup old version (after verification period)
sleep 300
kubectl delete deployment myapp-$CURRENT
```

### Pattern 2: Canary with Automated Analysis

```bash
#!/bin/bash
# canary-deploy.sh
VERSION=$1
CANARY_WEIGHT=10

# Deploy canary
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
      track: canary
  template:
    metadata:
      labels:
        app: myapp
        track: canary
    spec:
      containers:
        - name: app
          image: myapp:$VERSION
EOF

# Wait and monitor
echo "Monitoring canary for 5 minutes..."
sleep 300

# Check error rate
ERROR_RATE=$(curl -s "http://prometheus:9090/api/v1/query?query=sum(rate(http_requests_total{track='canary',status=~'5.*'}[5m]))/sum(rate(http_requests_total{track='canary'}[5m]))" | jq -r '.data.result[0].value[1]')

if (( $(echo "$ERROR_RATE < 0.01" | bc -l) )); then
    echo "Canary healthy (error rate: $ERROR_RATE)"
    # Promote canary to stable
    kubectl set image deployment/myapp-stable app=myapp:$VERSION
    kubectl delete deployment myapp-canary
else
    echo "Canary unhealthy (error rate: $ERROR_RATE)"
    # Rollback canary
    kubectl delete deployment myapp-canary
    exit 1
fi
```

### Pattern 3: Feature Flag Progressive Rollout

```bash
#!/bin/bash
# progressive-rollout.sh
FLAG="new_checkout"
STAGES=(1 5 10 25 50 100)

for PERCENTAGE in "${STAGES[@]}"; do
    echo "Rolling out $FLAG to $PERCENTAGE% of users..."

    # Update feature flag
    curl -X PATCH "https://flags.example.com/api/flags/$FLAG" \
        -H "Authorization: Bearer $FLAGS_TOKEN" \
        -d "{\"rollout_percentage\": $PERCENTAGE}"

    # Monitor for 10 minutes
    echo "Monitoring for 10 minutes..."
    sleep 600

    # Check success criteria
    ERROR_RATE=$(get_error_rate "$FLAG")
    LATENCY=$(get_p99_latency "$FLAG")

    if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
        echo "Rollback: error rate too high ($ERROR_RATE)"
        curl -X PATCH "https://flags.example.com/api/flags/$FLAG" \
            -d '{"rollout_percentage": 0}'
        exit 1
    fi

    echo "Stage $PERCENTAGE% passed"
done

echo "Full rollout complete for $FLAG"
```

### Pattern 4: Automated Rollback Pipeline

```yaml
# .github/workflows/deploy-with-rollback.yml
name: Deploy with Auto-Rollback
on:
  workflow_dispatch:
    inputs:
      version:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Record previous version
        id: prev
        run: |
          echo "version=$(kubectl get deploy app -o jsonpath='{.spec.template.spec.containers[0].image}')" >> $GITHUB_OUTPUT

      - name: Deploy
        id: deploy
        run: |
          kubectl set image deploy app=myapp:${{ inputs.version }}
          kubectl rollout status deploy app --timeout=300s

      - name: Verify (5 min window)
        id: verify
        run: |
          sleep 300
          curl -sf https://example.com/health || exit 1

      - name: Rollback on failure
        if: failure()
        run: |
          kubectl rollout undo deploy app
          kubectl rollout status deploy app --timeout=300s
```

### Pattern 5: Multi-Region Coordinated Deploy

```bash
#!/bin/bash
# multi-region-deploy.sh
VERSION=$1
REGIONS=("us-east-1" "eu-west-1" "ap-southeast-1")
FAILED=()

for REGION in "${REGIONS[@]}"; do
    echo "=== Deploying to $REGION ==="

    kubectl --context "$REGION" set image deploy app=myapp:$VERSION -n prod
    kubectl --context "$REGION" rollout status deploy app -n prod --timeout=600s

    if ! kubectl --context "$REGION" exec deploy/app -n prod -- curl -sf localhost:3000/health; then
        echo "FAILED: $REGION health check failed"
        FAILED+=("$REGION")
        kubectl --context "$REGION" rollout undo deploy app -n prod
    else
        echo "SUCCESS: $REGION"
    fi
done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo "Failed regions: ${FAILED[*]}"
    exit 1
fi

echo "All regions deployed successfully"
```

## Edge Cases & Pitfalls

1. **Deploying on Friday or before holidays** — Avoid deployments when team availability is reduced; have rollback procedures documented before deploying.
2. **Database migration incompatible with current code** — A migration that drops a column while old code still references it causes immediate outages; always use expand-migrate-contract.
3. **Feature flags accumulating without cleanup** — Dead feature flags create technical debt; establish a policy to remove flags after full rollout.
4. **Blue-green deployment with shared state** — If blue and green share a database, rolling back the application doesn't roll back data changes.
5. **Canary analysis using wrong metrics** — Monitoring error rate alone misses latency degradation; include latency, saturation, and business metrics.
6. **Rolling update with readiness probe too aggressive** — If readiness probe fails too quickly, pods are cycled constantly; tune `initialDelaySeconds` and `periodSeconds`.
7. **Multi-region deployment with eventual consistency** — Data replication lag between regions can cause stale reads; design for region-aware routing.
8. **Cost explosion during deployment** — Blue-green temporarily doubles infrastructure cost; canary with HPA can cause unexpected scaling; budget for deployment overhead.
9. **Missing pre-stop hook causing dropped connections** — Without `preStop` sleep, pods are terminated before load balancer removes them; connections are dropped.
10. **Feature flag testing complexity** — Every flag combination creates a new test matrix; limit concurrent flags and test the most impactful combinations.
11. **Database migration lock contention** — Large table migrations acquire locks that block writes; use online DDL tools (gh-ost, pt-online-schema-change).
12. **Deployment drift between environments** — Staging and production diverge when configuration isn't version-controlled; use infrastructure-as-code.
13. **Health check endpoint returning 200 during partial failure** — A health check should verify all critical dependencies; a shallow check gives false confidence.
14. **Rolling update stuck due to unschedulable pods** — Insufficient cluster resources prevent new pods from starting; `maxSurge` must leave room for scheduling.
15. **Multi-region failover during deployment** — Deploying to all regions simultaneously risks global outage; deploy region-by-region with verification.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| ci-cd | Automated deployment pipelines | ← | CI/CD orchestrates deployment execution |
| dockerization | Container images as deployment artifacts | ← | Docker images are the deployment unit |
| testing | Pre-deployment and post-deployment verification | ← | Tests gate deployments; smoke tests verify |
| monitoring | Post-deployment health and performance | ↔ | Monitoring detects deployment issues; metrics inform rollback |
| security | Deployment security, secrets management | ↔ | Security scanning before deploy; secrets provisioned during |
| database-design | Schema migrations coordinated with deployments | ← | Migrations run before or during deployment |
| api-design | API versioning during deployments | ↔ | API contracts must remain stable across versions |
| performance | Deployment impact on performance | ↔ | Performance baselines inform canary thresholds |
| git-workflow | Tag-based releases, branch strategy | ← | Git tags trigger deployments; branches control environments |
| documentation | Deployment changelog, runbooks | → | Deployments generate changelog entries |

## Output Format Templates

### Template 1: Deployment Plan

```markdown
# Deployment Plan: [Service] v[X.Y.Z]

## Pre-Deployment
- [ ] All tests pass
- [ ] Security scan clean
- [ ] Database migrations tested in staging
- [ ] Rollback plan documented
- [ ] Team notified
- [ ] Monitoring dashboards configured
- [ ] Feature flags set for gradual rollout

## Deployment Strategy
- **Strategy**: [Blue-Green / Canary / Rolling / Feature Flag]
- **Target environment**: [staging → production]
- **Estimated duration**: [X minutes]
- **Rollback time**: [X seconds/minutes]

## Deployment Steps
1. Deploy to staging
2. Verify staging health checks
3. Deploy to production (canary at 10%)
4. Monitor for 15 minutes
5. Increase to 50% traffic
6. Monitor for 15 minutes
7. Full rollout
8. Verify production health

## Rollback Triggers
- Error rate > 5%
- P99 latency > 2x baseline
- Health check failures
- Manual trigger

## Post-Deployment
- [ ] Verify all health checks pass
- [ ] Check error rates
- [ ] Review latency metrics
- [ ] Update changelog
- [ ] Notify team of completion
```

### Template 2: Rollback Runbook

```markdown
# Rollback Runbook

## When to Rollback
- Error rate exceeds 5% for > 5 minutes
- P99 latency exceeds 2x baseline for > 5 minutes
- Health check failures persist
- Critical bug discovered post-deploy

## Rollback Steps
1. **Identify issue**: Check dashboards, logs, alerts
2. **Decide**: Fix forward or rollback?
3. **Execute rollback**:
   ```bash
   kubectl rollout undo deployment/app
   kubectl rollout status deployment/app --timeout=300s
   ```
4. **Verify**: Confirm health checks pass
5. **Communicate**: Post in #deployments channel
6. **Follow up**: Create incident ticket

## Post-Rollback
- [ ] Root cause identified
- [ ] Fix developed and tested
- [ ] Fix deployed via normal pipeline
- [ ] Incident report written
- [ ] Preventive measures implemented
```

### Template 3: Environment Configuration

```markdown
# Environment Configuration Matrix

## Environments
| Property | Development | Staging | Production |
|----------|------------|---------|------------|
| Replicas | 1 | 2 | 3+ |
| Resources | 0.5 CPU / 256M | 1 CPU / 512M | 2 CPU / 1G |
| Auto-scaling | No | No | Yes (2-20) |
| Database | SQLite/Local | Shared Postgres | Dedicated Postgres |
| Feature flags | All enabled | Staged rollout | Production flags |
| Monitoring | Basic | Full | Full + alerts |
| SSL | Self-signed | Let's Encrypt | Custom cert |

## Deployment Strategy per Environment
| Environment | Strategy | Approval | Rollback |
|-------------|----------|----------|----------|
| Development | Direct push | None | Manual |
| Staging | Rolling update | Auto | Auto |
| Production | Canary/Blue-Green | Manual gate | Auto |
```

### Template 4: Cost Optimization Checklist

```markdown
## Deployment Cost Optimization

### Compute
- [ ] Right-sized instances based on actual usage
- [ ] Auto-scaling configured with appropriate min/max
- [ ] Spot/preemptible instances for non-critical workloads
- [ ] Dev/staging environments scaled down outside business hours

### Storage
- [ ] Persistent volumes right-sized
- [ ] Old images/artifacts cleaned up
- [ ] Log retention policies configured

### Network
- [ ] CDN configured for static assets
- [ ] Regional deployment to reduce egress
- [ ] Load balancer optimized (not over-provisioned)

### Database
- [ ] Connection pooling configured
- [ ] Read replicas only where needed
- [ ] Automated backups optimized (retention, frequency)

### Monitoring
- [ ] Log aggregation retention optimized
- [ ] Metrics retention aligned with needs
- [ ] Alert routing to avoid alert fatigue
```

## Rules

1. **Never deploy without a rollback plan** — Every deployment must have a documented and tested rollback procedure; execute it within the defined time window.
2. **Always deploy to staging before production** — Staging catches environment-specific issues; treat staging as production-lite.
3. **Use progressive rollouts for risky changes** — Canary or blue-green deployments limit blast radius; never deploy 100% at once for critical changes.
4. **Coordinate database migrations with code deployments** — Use expand-migrate-contract to ensure backward compatibility across deployments.
5. **Always verify health checks after deployment** — A deployment that passes CI but fails health checks is not complete.
6. **Implement automated rollback on health check failure** — Don't rely on manual intervention for critical failures; automate rollback within 5 minutes.
7. **Monitor for 15 minutes minimum after production deployment** — Most issues manifest within 15 minutes; don't consider deployment complete until then.
8. **Keep feature flags small and temporary** — Remove flags within 2 weeks of full rollout; dead flags are technical debt.
9. **Use pre-stop hooks to drain connections gracefully** — A 15-second sleep in `preStop` prevents dropped connections during pod termination.
10. **Tag every production release with the Git SHA** — Enable traceability from deployed version to exact code commit.
11. **Deploy region-by-region for multi-region** — Never deploy to all regions simultaneously; verify each region before proceeding.
12. **Cost-optimize deployment infrastructure** — Use auto-scaling, spot instances, and right-sizing to minimize deployment overhead.
