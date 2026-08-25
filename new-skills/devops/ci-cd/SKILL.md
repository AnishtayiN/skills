---
name: ci-cd
description: >-
  Set up CI/CD pipelines for automated testing, building, and deployment.
  TRIGGERS: ci cd, pipeline, github actions, gitlab ci, jenkins, continuous integration,
  continuous deployment, automated testing, build pipeline, deploy pipeline,
  پایپ‌لاین, اتوماسیون, اکشن, CI/CD, استقرار خودکار,
  持续集成, 持续部署, 流水线, 自动化测试, GitHub Actions, GitLab CI
priority: P3
dependencies: [testing, dockerization]
conflicts: []
---

# CI/CD Skill

## Purpose

Automate testing, building, and deployment with production-grade CI/CD pipelines including GitHub Actions deep dive, GitLab CI, pipeline optimization, matrix builds, caching strategies, secrets management, OIDC federation, canary deployments, and rollback strategies.

## When to Activate

- Setting up CI/CD for new or existing projects
- Optimizing pipeline speed and cost
- Configuring matrix builds for multi-platform testing
- Implementing canary or blue-green deployments
- Managing secrets across environments
- Setting up OIDC federation for cloud deployments
- Configuring caching to speed up builds
- Implementing rollback strategies

## Workflow

### Step 1: Define Pipeline Stages

```
1. Lint & Type Check
2. Unit Tests
3. Integration Tests
4. Build (Docker image, binaries)
5. Security Scan (SAST, dependency audit, container scan)
6. Deploy to Staging
7. Smoke Tests / E2E Tests
8. Deploy to Production (with approval gate)
9. Post-deploy verification
```

### Step 2: Create Pipeline

```yaml
# GitHub Actions example
name: CI/CD Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/

  build:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: kubectl set image deployment/app app=ghcr.io/${{ github.repository }}:${{ github.sha }}
```

### Step 3: Verify and Monitor

```
1. All pipeline stages pass
2. Coverage thresholds met
3. Security scans clean
4. Deployment succeeds
5. Health checks pass
6. No increase in error rates
```

## Advanced Techniques

### 1. GitHub Actions Deep Dive

```yaml
# ── Advanced GitHub Actions patterns ──

# Reusable workflow (called from other repos)
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      image-tag:
        required: true
        type: string
    secrets:
      DEPLOY_KEY:
        required: true

# Composite action
# .github/actions/setup-project/action.yml
name: 'Setup Project'
description: 'Install deps, cache, and verify'
runs:
  using: 'composite'
  steps:
    - uses: actions/setup-node@v4
      with:
        node-version: 20
        cache: 'npm'
    - run: npm ci
      shell: bash
    - run: npm run lint
      shell: bash

# Workflow with concurrency control
name: Deploy
on:
  push:
    branches: [main]
concurrency:
  group: deploy-production
  cancel-in-progress: false   # Don't cancel in-progress deployments

# Workflow with matrix strategy
jobs:
  test:
    strategy:
      matrix:
        node-version: [18, 20, 22]
        os: [ubuntu-latest, windows-latest]
        exclude:
          - os: windows-latest
            node-version: 18
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test

# Conditional steps with expressions
steps:
  - if: startsWith(github.ref, 'refs/tags/v')
    run: echo "This is a release tag"
  - if: contains(github.event.pull_request.labels.*.name, 'skip-tests')
    run: echo "Tests skipped"
```

### 2. GitLab CI Deep Dive

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_TLS_CERTDIR: "/certs"

# Cache between jobs
.cache_template: &cache_template
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/
    policy: pull-push

# Test stage with parallel jobs
lint:
  <<: *cache_template
  stage: test
  image: node:20-alpine
  script:
    - npm ci
    - npm run lint
    - npm run typecheck

test:unit:
  <<: *cache_template
  stage: test
  image: node:20-alpine
  script:
    - npm ci
    - npm run test:unit
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'

test:integration:
  <<: *cache_template
  stage: test
  image: node:20-alpine
  services:
    - postgres:16-alpine
    - redis:7-alpine
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: "postgresql://test:test@postgres:5432/testdb"
    REDIS_URL: "redis://redis:6379"
  script:
    - npm ci
    - npm run test:integration

build:
  stage: build
  image: docker:24.0
  services:
    - docker:24.0-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only:
    - main

deploy:staging:
  stage: deploy
  script:
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - main

deploy:production:
  stage: deploy
  script:
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n production
  environment:
    name: production
    url: https://example.com
  when: manual   # Requires manual approval
  only:
    - main
```

### 3. Pipeline Optimization

```yaml
# ── Speed optimization techniques ──

# 1. Parallel job execution
jobs:
  lint:
    runs-on: ubuntu-latest
  test:unit:
    runs-on: ubuntu-latest      # Runs in parallel with lint
  test:e2e:
    runs-on: ubuntu-latest      # Runs in parallel with lint
  typecheck:
    runs-on: ubuntu-latest      # Runs in parallel with lint

# 2. Dependency caching
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: 'npm'               # Automatic npm cache

# Custom cache for other tools
- uses: actions/cache@v4
  with:
    path: |
      ~/.cache/eslint
      ~/.cache/typescript
    key: eslint-ts-${{ runner.os }}-${{ hashFiles('**/*.ts') }}
    restore-keys: |
      eslint-ts-${{ runner.os }}-

# 3. Conditional job execution
jobs:
  deploy:
    if: >
      github.ref == 'refs/heads/main' &&
      !contains(github.event.head_commit.message, '[skip-deploy]')

# 4. Skip redundant runs on PR updates
on:
  pull_request:
    types: [opened, synchronize, reopened]
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number }}
  cancel-in-progress: true     # Cancel previous run on new push

# 5. Use slim Docker images for CI
container: node:20-alpine      # Instead of full ubuntu
```

### 4. Matrix Builds

```yaml
# ── Matrix strategy for multi-platform testing ──
jobs:
  test:
    strategy:
      fail-fast: false          # Don't cancel other jobs on failure
      matrix:
        node: [18, 20, 22]
        os: [ubuntu-latest, macos-latest, windows-latest]
        include:
          - node: 22
            os: ubuntu-latest
            experimental: true  # Mark as experimental
        exclude:
          - node: 18
            os: macos-latest    # Skip expensive combinations
    runs-on: ${{ matrix.os }}
    continue-on-error: ${{ matrix.experimental || false }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: npm ci
      - run: npm test

  # Report matrix results
  report:
    needs: test
    if: always()
    runs-on: ubuntu-latest
    steps:
      - name: Check matrix results
        run: |
          if [ "${{ needs.test.result }}" != "success" ]; then
            echo "Some matrix jobs failed"
            exit 1
          fi
```

### 5. Caching Strategies

```yaml
# ── Layered caching for Docker builds ──
- uses: docker/build-push-action@v5
  with:
    push: true
    tags: myapp:latest
    cache-from: |
      type=gha
      type=registry,ref=myapp:buildcache
    cache-to: |
      type=gha,mode=max
      type=registry,ref=myapp:buildcache,mode=max

# ── Dependency caching by lockfile hash ──
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: npm-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
    restore-keys: |
      npm-${{ runner.os }}-

# ── Tool-specific caches ──
# Rust cargo cache
- uses: actions/cache@v4
  with:
    path: |
      ~/.cargo/registry
      ~/.cargo/git
      target
    key: cargo-${{ runner.os }}-${{ hashFiles('Cargo.lock') }}

# Go module cache
- uses: actions/cache@v4
  with:
    path: ~/go/pkg/mod
    key: go-${{ runner.os }}-${{ hashFiles('go.sum') }}

# Python pip cache
- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
    cache: 'pip'
```

### 6. Secrets Management

```yaml
# ── GitHub Actions secrets ──
# Repository secrets: Settings > Secrets and variables > Actions
jobs:
  deploy:
    steps:
      - run: echo "Deploying with ${{ secrets.DEPLOY_KEY }}"
      # Never echo secrets in logs!

# ── OIDC Federation (no long-lived secrets) ──
# Replace static AWS keys with OIDC token exchange
permissions:
  id-token: write    # Required for OIDC
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789012:role/github-actions
      aws-region: us-east-1
  # Now aws CLI works without static credentials

# ── Environment-level secrets ──
jobs:
  deploy:
    environment:
      name: production
      url: https://example.com
    # Uses secrets specific to the "production" environment
    steps:
      - run: echo "${{ secrets.PROD_DATABASE_URL }}"

# ── Masking secrets in logs ──
# GitHub auto-masks secrets in logs
# For custom values, use add-mask
- run: |
    echo "::add-mask::my-secret-value"
    echo "Secret is now masked in logs"
```

### 7. OIDC Federation

```yaml
# ── GitHub Actions → AWS OIDC ──
name: Deploy to AWS
on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsDeploy
          aws-region: us-east-1

      - run: aws s3 sync ./dist s3://my-bucket/

# ── GitHub Actions → GCP OIDC ──
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/123/locations/global/workloadIdentityPools/github-pool/providers/github-provider
          service_account: github-actions@my-project.iam.gserviceaccount.com

      - uses: google-github-actions/deploy-cloudrun@v2
        with:
          service: my-service
          region: us-central1
          image: gcr.io/my-project/my-app:${{ github.sha }}
```

### 8. Canary Deployments

```yaml
# ── Canary deployment with percentage traffic shift ──
# Using Argo Rollouts or Flagger
jobs:
  canary:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy canary (10% traffic)
        run: |
          kubectl apply -f - <<EOF
          apiVersion: flagger.app/v1beta1
          kind: Canary
          metadata:
            name: my-app
          spec:
            targetRef:
              apiVersion: apps/v1
              kind: Deployment
              name: my-app
            progressDeadlineSeconds: 300
            service:
              port: 80
            analysis:
              interval: 60s
              threshold: 5
              maxWeight: 50
              stepWeight: 10
              metrics:
                - name: request-success-rate
                  thresholdRange:
                    min: 99
                - name: request-duration
                  thresholdRange:
                    max: 500
          EOF

      - name: Wait for canary promotion
        run: |
          kubectl wait --for=condition=available \
            canary/my-app --timeout=600s
```

### 9. Rollback Strategies

```yaml
# ── Automatic rollback on failure ──
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Record current version
        id: version
        run: |
          CURRENT=$(kubectl get deployment app -o jsonpath='{.spec.template.spec.containers[0].image}')
          echo "current=$CURRENT" >> $GITHUB_OUTPUT

      - name: Deploy new version
        id: deploy
        run: |
          kubectl set image deployment/app app=myapp:${{ github.sha }}
          kubectl rollout status deployment/app --timeout=300s

      - name: Verify deployment
        id: verify
        run: |
          curl -f https://example.com/health || exit 1
          # Run smoke tests
          npm run test:smoke

      - name: Rollback on failure
        if: failure() && steps.deploy.outcome == 'success'
        run: |
          echo "Rolling back to ${{ steps.version.outputs.current }}"
          kubectl rollout undo deployment/app
          kubectl rollout status deployment/app --timeout=300s
```

## Common Patterns

### Pattern 1: GitHub Actions with Reusable Workflows

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    uses: ./.github/workflows/reusable-test.yml
    with:
      node-version: 20
    secrets: inherit

# .github/workflows/reusable-test.yml
name: Reusable Test
on:
  workflow_call:
    inputs:
      node-version:
        type: number
        default: 20
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm test
```

### Pattern 2: GitLab CI with Rules

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  image: docker:24
  services: [docker:24-dind]
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: always
    - if: $CI_MERGE_REQUEST_IID
      when: always
    - when: never

deploy:production:
  stage: deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
      allow_failure: false
  script:
    - kubectl apply -f k8s/
```

### Pattern 3: Monorepo CI with Path Filters

```yaml
# Only run relevant jobs based on changed files
name: CI
on:
  push:
    paths:
      - 'packages/api/**'
      - 'packages/web/**'
      - '!packages/web/**/*.md'

jobs:
  api:
    if: contains(github.event.head_commit.modified, 'packages/api/')
    runs-on: ubuntu-latest
    steps:
      - run: echo "API changed, running API tests"

  web:
    if: contains(github.event.head_commit.modified, 'packages/web/')
    runs-on: ubuntu-latest
    steps:
      - run: echo "Web changed, running web tests"
```

### Pattern 4: Environment Promotion Pipeline

```yaml
name: Promote
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [staging, production]
      image-tag:
        required: true

jobs:
  promote:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - run: |
          kubectl set image deployment/app \
            app=ghcr.io/myorg/myapp:${{ inputs.image-tag }} \
            -n ${{ inputs.environment }}
```

### Pattern 5: Security Scan Pipeline

```yaml
name: Security Scan
on: [push, pull_request]

jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/analyze@v3
        with:
          languages: javascript

  dependency-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm audit --audit-level=high

  container-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:latest
          format: sarif
          output: trivy-results.sarif
          severity: CRITICAL,HIGH
```

## Edge Cases & Pitfalls

1. **Hardcoded secrets in workflow files** — Never put tokens or passwords in `.github/workflows/*.yml`; use secrets or OIDC federation.
2. **Missing `id-token: write` permission for OIDC** — OIDC federation fails silently without this permission; always declare it.
3. **Cache poisoning from unprotected branches** — PR workflows from forks can overwrite caches; use `cache-read-only: true` for fork PRs.
4. **Race conditions with concurrent deployments** — Multiple pushes to main trigger parallel deployments; use `concurrency` groups to serialize.
5. **Cost explosion from matrix builds** — A 3x3x3 matrix creates 27 jobs; be selective about which combinations are necessary.
6. **Stale cache causing phantom bugs** — Cached `node_modules` may contain incompatible packages; clear cache after dependency changes.
7. **OIDC token expiry during long jobs** — OIDC tokens have limited lifetime; don't use them for jobs exceeding 1 hour.
8. **GitHub Actions `pull_request` vs `pull_request_target`** — `pull_request_target` runs in the base repo context; using it with checkout of the PR head exposes secrets.
9. **Docker layer caching not working** — BuildKit cache requires explicit `cache-from` and `cache-to` configuration; default caching is minimal.
10. **GitLab CI `rules` vs `only/except`** — `rules` is the modern approach; `only/except` has edge cases with merge requests and tags.
11. **Environment protection rules not configured** — `environment: production` does nothing without configured protection rules in repository settings.
12. **Rollback triggered but new version already deployed** — Rollback restores previous version but doesn't prevent re-deployment of the same broken version.
13. **Smoke tests using production data** — E2E tests against production can create or modify real data; use isolated test environments.
14. **Missing `fail-fast: false` in matrix builds** — Default `fail-fast: true` cancels all matrix jobs on first failure, hiding the full failure picture.
15. **Permissions escalation via workflow triggers** — `workflow_dispatch` and `workflow_call` have different permission scopes; document and restrict triggers.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| testing | Unit, integration, E2E tests in pipeline | ← | Tests are the gatekeeper of CI/CD quality |
| dockerization | Docker builds, image pushes | ↔ | CI builds images; Dockerfiles define build stages |
| deployment | Pipeline-triggered deployments | → | CI/CD orchestrates deployment execution |
| security | SAST, dependency audit, container scan | → | Security scanning as pipeline stages |
| monitoring | Post-deploy health verification | → | Pipeline verifies deployment health |
| api-design | API contract testing | ← | Contract tests validate API compatibility |
| database-design | Migration execution in pipeline | → | Database migrations run as pipeline steps |
| git-workflow | Branch-based pipeline triggers | ↔ | Git events trigger pipelines; pipeline status reported back |
| performance | Build time optimization | → | Pipeline performance affects developer velocity |
| documentation | Changelog from conventional commits | → | CI generates changelogs from commit history |

## Output Format Templates

### Template 1: Pipeline Configuration

```markdown
# CI/CD Pipeline: [Project Name]

## Overview
- **CI Platform**: [GitHub Actions / GitLab CI / Jenkins]
- **Trigger**: [push, pull_request, manual]
- **Environments**: [development, staging, production]

## Pipeline Stages
| Stage | Jobs | Parallel | Timeout | Required |
|-------|------|----------|---------|----------|
| Lint | eslint, typecheck | Yes | 5min | Yes |
| Test | unit, integration, e2e | Yes | 15min | Yes |
| Build | docker, assets | Yes | 10min | Yes |
| Security | sast, audit, container | Yes | 10min | Yes |
| Deploy | staging | No | 5min | Yes |
| Deploy | production | No | 5min | Manual gate |

## Secrets Required
| Secret | Purpose | Environment |
|--------|---------|-------------|
| DEPLOY_KEY | Cloud deployment credentials | production |
| DOCKER_REGISTRY | Container registry auth | all |
```

### Template 2: GitHub Actions Workflow

```markdown
## Workflow: [Name]

### Triggers
- Push to: main, develop
- Pull request: main
- Manual dispatch: with inputs

### Jobs
| Job | Runner | Dependencies | Condition |
|-----|--------|-------------|-----------|
| lint | ubuntu-latest | - | Always |
| test | ubuntu-latest | lint | Always |
| build | ubuntu-latest | test | Main only |
| deploy | ubuntu-latest | build | Main only, manual |

### Caching
| Cache | Key | Path |
|-------|-----|------|
| npm | hash(package-lock.json) | ~/.npm |
| docker | gha | buildx cache |
```

### Template 3: Rollback Plan

```markdown
# Rollback Plan

## Trigger Conditions
- Health check failures after deploy
- Error rate increase > 5%
- Latency spike > 2x baseline
- Manual trigger

## Rollback Steps
1. Identify current and previous version: `kubectl rollout history deployment/app`
2. Rollback: `kubectl rollout undo deployment/app`
3. Verify: `kubectl rollout status deployment/app`
4. Confirm health: `curl -f https://example.com/health`
5. Notify team in #deployments channel

## Post-Rollback
- [ ] Root cause identified
- [ ] Fix developed and tested
- [ ] Fix deployed via normal pipeline
- [ ] Incident report written
```

### Template 4: Secrets Management

```markdown
## Secrets Inventory

### Repository Secrets
| Secret | Scope | Rotation | Last Rotated |
|--------|-------|----------|--------------|
| DOCKER_TOKEN | Container registry | 90 days | YYYY-MM-DD |

### Environment Secrets
| Environment | Secret | Purpose |
|-------------|--------|---------|
| staging | STAGING_DB_URL | Staging database |
| production | PROD_DB_URL | Production database |

### OIDC Providers
| Provider | Role ARN | Repository | Permissions |
|----------|----------|------------|-------------|
| AWS | arn:aws:iam::xxx:role/gh-actions | org/repo | s3:PutObject, ecr:* |

### Rotation Schedule
- [ ] Rotate static secrets every 90 days
- [ ] Prefer OIDC over static secrets
- [ ] Audit secrets access quarterly
- [ ] Remove unused secrets monthly
```

## Rules

1. **Never hardcode secrets in pipeline files** — Use platform-native secrets, OIDC federation, or external secret managers.
2. **Always cache dependencies** — Every CI run should cache package manager artifacts to reduce build times by 50%+.
3. **Always run tests in parallel** — Independent test suites should run concurrently to minimize total pipeline time.
4. **Require approval gates for production deployments** — No automatic production deployment without human approval or comprehensive automated verification.
5. **Always implement rollback in pipeline** — Every deployment pipeline must include an automatic or manual rollback mechanism.
6. **Use matrix builds strategically** — Test critical platform/version combinations; don't test every permutation.
7. **Implement concurrency controls** — Prevent overlapping deployments to the same environment using concurrency groups.
8. **Always scan for security vulnerabilities** — Include SAST, dependency audit, and container scanning as pipeline stages.
9. **Use OIDC federation over static credentials** — Eliminate long-lived secrets by using identity federation with cloud providers.
10. **Monitor pipeline health metrics** — Track build time, success rate, and flaky test rate as key pipeline health indicators.
11. **Isolate environments** — Staging and production must have separate secrets, credentials, and infrastructure.
12. **Document and version all pipeline configurations** — Pipeline files are code; review, version, and document them like any other source.
