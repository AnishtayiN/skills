---
name: ci-cd
description: >-
  Set up CI/CD pipelines for automated testing, building, and deployment.
  TRIGGERS: ci cd, pipeline, github actions, gitlab ci, jenkins, continuous integration,
  continuous deployment, automated testing, build pipeline, deploy pipeline,
  پایپ‌لاین, اتوماسیون, اکشن, CI/CD, استقرار خودکار
priority: P3
dependencies: [testing, dockerization]
conflicts: []
---

# CI/CD Skill

## Purpose

Automate testing, building, and deployment.

## Workflow

### Step 1: Define Pipeline Stages

```
1. Lint & Type Check
2. Unit Tests
3. Integration Tests
4. Build
5. Security Scan
6. Deploy (staging)
7. Smoke Tests
8. Deploy (production)
```

### Step 2: Create Pipeline

```yaml
# GitHub Actions example
name: CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test
      - run: npm run build
```

### Step 3: Add Deployment

```yaml
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t app .
      - run: docker push registry/app:latest
```

## Anti-Patterns

- ❌ No tests in pipeline
- ❌ Deploying without tests passing
- ❌ No caching (slow builds)
- ❌ Hardcoded secrets
- ❌ No rollback strategy

## Skill Interactions

- ← testing: Tests run in pipeline
- ← dockerization: Docker builds in pipeline
- → deployment: Pipeline deploys
