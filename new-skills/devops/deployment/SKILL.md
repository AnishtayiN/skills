---
name: deployment
description: >-
  Deploy applications to cloud providers, manage environments, and handle releases.
  TRIGGERS: deploy, deployment, release, production, staging, environment, publish,
  deploy to aws, deploy to gcp, deploy to azure, serverless, lambda,
  استقرار, انتشار, پروداکشن, محیط اجرا, استقرار ابری
priority: P3
dependencies: [testing, ci-cd, dockerization]
conflicts: []
---

# Deployment Skill

## Purpose

Deploy applications safely with rollback capability.

## Workflow

### Step 1: Pre-Deployment Checks

```
- [ ] All tests pass
- [ ] Build succeeds
- [ ] Security scan clean
- [ ] Environment variables configured
- [ ] Database migrations ready
```

### Step 2: Deploy

```
1. Deploy to staging first
2. Run smoke tests
3. Deploy to production
4. Monitor for errors
```

### Step 3: Post-Deployment

```
1. Verify health checks
2. Monitor logs
3. Check key metrics
4. Be ready to rollback
```

## Anti-Patterns

- ❌ Deploying without tests
- ❌ No rollback plan
- ❌ Deploying on Friday
- ❌ No health checks
- ❌ Manual deployment steps

## Skill Interactions

- ← ci-cd: Automated deployment
- ← testing: Pre-deployment testing
- → monitoring: Post-deployment monitoring
