---
name: ci-cd-pipeline
description: >-
  Set up, configure, and debug CI/CD pipelines for continuous integration and deployment.
  Trigger this skill when the user wants to create or fix a CI/CD pipeline, set up GitHub Actions, GitLab CI,
  configure automated testing, build automation, deployment automation, or continuous delivery workflows.
  Also activate for: CI/CD, پایپ‌لاین, پایپ‌لاین استقرار, GitHub Actions, GitLab CI, continuous integration,
  continuous deployment, deployment pipeline, build pipeline, automated testing, setup pipeline,
  workflow configuration, CI pipeline broken, CD pipeline fix, pipeline as code, DevOps pipeline,
  automated deploy, test automation, branch protection, merge queue, release workflow.
---

# CI/CD Pipeline Skill — Complete Build, Test & Deploy Mastery

## Overview

This skill creates and debugs CI/CD pipelines that automate building, testing, and deploying code. It covers GitHub Actions, GitLab CI, advanced deployment strategies (blue-green, canary, feature flags), pipeline security (SAST, DAST, dependency scanning), optimization (caching, parallelization, matrix builds), and rollback patterns. The focus is on pipelines that are fast, reliable, secure, and maintainable.

## When to Use This Skill

- User wants to set up a CI/CD pipeline from scratch
- User needs to fix a broken GitHub Actions or GitLab CI pipeline
- User asks about automated testing, builds, or deployments
- User mentions continuous integration, continuous delivery, or deployment pipelines
- User wants branch-based workflows (test on PR, deploy on merge)
- User needs environment-specific deployments (staging, production)
- User asks about blue-green deployment, canary release, or feature flags
- User needs pipeline security scanning (SAST, DAST, dependency, container)
- User needs rollback patterns or deployment strategies

---

## Part 1: Pipeline Design

### Step 1: Understand the Project and Requirements

1. **Read the project** — Identify language, framework, test runner, build tool, and deployment target.
2. **Check for existing pipelines** — Read `.github/workflows/`, `.gitlab-ci.yml`, or `Jenkinsfile`.
3. **Determine the CI/CD platform** — GitHub Actions (default), GitLab CI, Jenkins, CircleCI, etc.
4. **Identify the pipeline scope:**

| Stage | Purpose | When |
|-------|---------|------|
| Lint / format check | Code quality | Every push / PR |
| Unit tests | Fast feedback | Every push / PR |
| Integration tests | Component correctness | Every push / PR |
| Security scanning | Vulnerability detection | Every push / PR |
| Build | Compile, bundle, Docker image | Every push to main |
| Deploy to staging | Pre-production validation | Every push to main |
| Deploy to production | Release | Manual or tag-triggered |

### Step 2: Design the Pipeline

1. **Choose trigger events:**
   - `push` to main: full build + deploy to staging
   - `pull_request`: lint + test + security scan (no deploy)
   - `release` or tag: build + deploy production
   - `workflow_dispatch`: manual trigger
   - `schedule`: periodic builds for dependency updates

2. **Define job dependencies** — Tests must pass before deploy. Build must succeed before publish.

3. **Plan caching strategy:**
   - `node_modules` / npm cache
   - pip cache / Maven repo / Go modules
   - Docker layer cache
   - Build artifact cache

4. **Plan secrets management:**
   - Deploy keys, API tokens, credentials
   - Use the platform's secrets store, never hardcode
   - Use OIDC for cloud provider authentication when possible

---

## Part 2: GitHub Actions — Complete Reference

### Basic Workflow

```yaml
name: CI/CD Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t myapp:${{ github.sha }} .

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploy to production"
```

### Reusable Workflows

```yaml
# .github/workflows/reusable-deploy.yml (called by other workflows)
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
      deploy-token:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        env:
          DEPLOY_TOKEN: ${{ secrets.deploy-token }}
          IMAGE_TAG: ${{ inputs.image-tag }}
        run: |
          echo "Deploying $IMAGE_TAG to ${{ inputs.environment }}"
```

```yaml
# .github/workflows/main.yml (calls reusable workflow)
name: Main Pipeline
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v4
      - id: meta
        run: echo "tags=myapp:${{ github.sha }}" >> "$GITHUB_OUTPUT"

  deploy-staging:
    needs: build
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      image-tag: ${{ needs.build.outputs.image-tag }}
    secrets:
      deploy-token: ${{ secrets.STAGING_DEPLOY_TOKEN }}

  deploy-production:
    needs: deploy-staging
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
      image-tag: ${{ needs.build.outputs.image-tag }}
    secrets:
      deploy-token: ${{ secrets.PRODUCTION_DEPLOY_TOKEN }}
```

### Composite Actions

```yaml
# .github/actions/setup-project/action.yml
name: Setup Project
description: Install dependencies and setup project
inputs:
  node-version:
    description: Node.js version
    default: '20'
runs:
  using: composite
  steps:
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
        cache: npm
    - run: npm ci
      shell: bash
    - run: npm run build
      shell: bash
```

```yaml
# Using composite action in workflow
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ./.github/actions/setup-project
      - run: npm test
```

### OIDC for Cloud Authentication (No Static Secrets)

```yaml
# AWS OIDC Authentication
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
          role-to-assume: arn:aws:iam::123456789012:role/github-actions-deploy
          aws-region: us-east-1

      - run: aws s3 sync ./dist s3://my-bucket
```

```yaml
# GCP OIDC Authentication
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: 'projects/123/locations/global/workloadIdentityPools/github'
          service_account: 'github-actions@project.iam.gserviceaccount.com'
      - uses: google-github-actions/deploy-cloudrun@v2
        with:
          service: my-service
          region: us-central1
```

### Matrix Builds

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node-version: [18, 20, 22]
      fail-fast: false  # Don't cancel other jobs on failure
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
```

### GitHub Actions Patterns

```yaml
# Conditional steps
- name: Deploy
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: echo "Deploying"

# Environment variables
env:
  NODE_ENV: production
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
run: echo "Deploying to $NODE_ENV"

# Job outputs
jobs:
  build:
    outputs:
      version: ${{ steps.version.outputs.version }}
    steps:
      - id: version
        run: echo "version=$(node -p 'require(\"./package.json\").version')" >> "$GITHUB_OUTPUT"

# Caching
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: npm-${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}
    restore-keys: npm-${{ runner.os }}-

# Artifacts
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/
    retention-days: 7

# Concurrency control
concurrency:
  group: deploy-${{ github.ref }}
  cancel-in-progress: true
```

---

## Part 3: GitLab CI — Advanced Patterns

### Basic Structure

```yaml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_TLS_CERTDIR: "/certs"

test:
  stage: test
  image: node:20-alpine
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
  script:
    - npm ci
    - npm test
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'

build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
  only:
    - main
    - tags

deploy_staging:
  stage: deploy
  script:
    - echo "Deploy to staging"
  only:
    - main
  environment:
    name: staging
    url: https://staging.example.com
```

### Parent-Child Pipelines

```yaml
# .gitlab-ci.yml (parent pipeline)
include:
  - local: .gitlab-ci/test-pipeline.yml
  - local: .gitlab-ci/build-pipeline.yml
  - local: .gitlab-ci/deploy-pipeline.yml

stages:
  - build
  - test
  - deploy

# Child pipeline triggered by parent
generate-child-pipeline:
  stage: build
  script:
    - echo "Generating child pipeline"
  artifacts:
    paths:
      - child-pipeline.yml

child-pipeline:
  stage: test
  trigger:
    include:
      - artifact: child-pipeline.yml
        job: generate-child-pipeline
    strategy: depend
```

### DAG Pipelines

```yaml
# Use DAG for parallel execution without stages
stages:
  - test
  - build
  - deploy

unit-tests:
  stage: test
  script: npm test
  needs: []

lint:
  stage: test
  script: npm run lint
  needs: []

type-check:
  stage: test
  script: npm run type-check
  needs: []

build:
  stage: build
  script: npm run build
  needs: [unit-tests, lint, type-check]  # Wait for all test jobs

deploy-staging:
  stage: deploy
  script: ./deploy.sh staging
  needs: [build]
  only:
    - main

deploy-production:
  stage: deploy
  script: ./deploy.sh production
  needs: [deploy-staging]
  only:
    - main
  when: manual
```

### GitLab CI Rules

```yaml
# Advanced rules
deploy:
  script: ./deploy.sh
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: on_success
    - if: $CI_COMMIT_BRANCH == "develop"
      when: on_success
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: never
    - if: $CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/
      when: on_success
```

---

## Part 4: Pipeline Security

### SAST (Static Application Security Testing)

```yaml
# GitHub Actions - SAST with CodeQL
name: Security Scan
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  sast:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript
          queries: security-and-quality
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
```

### DAST (Dynamic Application Security Testing)

```yaml
# DAST with OWASP ZAP
dast:
  runs-on: ubuntu-latest
  needs: deploy-staging
  steps:
    - uses: actions/checkout@v4
    - name: OWASP ZAP Scan
      uses: zaproxy/action-full-scan@v0.10.0
      with:
        target: https://staging.example.com
        rules_file_name: '.zap/rules.tsv'
        cmd_options: '-a'
    - name: Upload results
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: zap-results
        path: report_html.html
```

### Dependency Scanning

```yaml
# npm audit
- name: Dependency Audit
  run: npm audit --audit-level=high

# Snyk
- name: Snyk Security Scan
  uses: snyk/actions/node@master
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
  with:
    args: --severity-threshold=high

# Trivy for container scanning
- name: Trivy Container Scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:${{ github.sha }}
    format: sarif
    output: trivy-results.sarif
    severity: CRITICAL,HIGH

# Upload results to GitHub Security tab
- name: Upload SARIF
  uses: github/codeql-action/upload-sarif@v3
  if: always()
  with:
    sarif_file: trivy-results.sarif
```

### Secret Scanning

```yaml
# Gitleaks
- name: Secret Scan
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# Or manual
- name: Secret Scan
  run: |
    pip install detect-secrets
    detect-secrets scan --all-files
```

### Container Image Scanning

```yaml
# Trivy image scan
- name: Build and Scan
  run: |
    docker build -t myapp:scan .
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      aquasec/trivy:latest image \
      --severity HIGH,CRITICAL \
      --exit-code 1 \
      myapp:scan
```

---

## Part 5: Pipeline Optimization

### Caching Strategies

```yaml
# GitHub Actions caching
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # npm cache
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      # Or manual cache
      - uses: actions/cache@v4
        with:
          path: |
            ~/.npm
            node_modules
          key: npm-${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            npm-${{ runner.os }}-
            npm-

      # Docker layer cache
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: myapp:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Parallelization

```yaml
# Run independent jobs in parallel
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run lint

  type-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run type-check

  unit-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test

  # All three run in parallel, then build waits for all
  build:
    needs: [lint, type-check, unit-test]
    runs-on: ubuntu-latest
    steps:
      - run: echo "All checks passed, building..."
```

### Matrix Builds for Speed

```yaml
# Split tests across matrix
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test --shard=${{ matrix.shard }}/4
```

### Incremental Builds

```yaml
# Only build/test what changed
jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      api: ${{ steps.changes.outputs.api }}
      web: ${{ steps.changes.outputs.web }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: changes
        with:
          filters: |
            api:
              - 'apps/api/**'
            web:
              - 'apps/web/**'

  test-api:
    needs: detect-changes
    if: needs.detect-changes.outputs.api == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing API..."

  test-web:
    needs: detect-changes
    if: needs.detect-changes.outputs.web == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing Web..."
```

---

## Part 6: Deployment Strategies

### Blue-Green Deployment

```yaml
# GitHub Actions blue-green deployment
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to inactive environment
        run: |
          # Determine current active environment
          ACTIVE=$(aws ecs describe-services --cluster my-cluster --services my-service \
            --query 'services[0].deployments[?status==`PRIMARY`].taskDefinition' \
            --output text)

          if [[ "$ACTIVE" == *"blue"* ]]; then
            TARGET="green"
            BLUE_GREEN_GROUP="green-tg"
          else
            TARGET="blue"
            BLUE_GREEN_GROUP="blue-tg"
          fi

          # Deploy to inactive
          aws ecs update-service --cluster my-cluster --service my-service-$TARGET \
            --task-definition my-app-$TARGET:${{ github.sha }}

      - name: Run smoke tests
        run: |
          # Test the inactive environment
          curl -f https://inactive.example.com/health || exit 1

      - name: Switch traffic
        run: |
          # Switch load balancer to new environment
          aws elbv2 modify-listener --listener-arn $LISTENER_ARN \
            --default-actions Type=forward,TargetGroupArn=$BLUE_GREEN_GROUP
```

### Canary Release

```yaml
# Canary deployment with weight shifting
jobs:
  canary:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy canary (10% traffic)
        run: |
          # Deploy new version with 10% traffic
          aws appmesh update-route --mesh-name my-mesh --virtual-service my-service \
            --route-name primary \
            --http-route '{
              "priority": 1,
              "action": {
                "weightedTargets": [
                  {"virtualNode": "current-vn", "weight": 90},
                  {"virtualNode": "canary-vn", "weight": 10}
                ]
              }
            }'

      - name: Monitor canary for 5 minutes
        run: sleep 300

      - name: Check canary health
        run: |
          # Check error rates, latency, etc.
          ERROR_RATE=$(curl -s "https://metrics.example.com/canary-error-rate")
          if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
            echo "Canary error rate too high: $ERROR_RATE"
            exit 1
          fi

      - name: Shift more traffic (50%)
        run: |
          aws appmesh update-route --mesh-name my-mesh --virtual-service my-service \
            --route-name primary \
            --http-route '{
              "priority": 1,
              "action": {
                "weightedTargets": [
                  {"virtualNode": "current-vn", "weight": 50},
                  {"virtualNode": "canary-vn", "weight": 50}
                ]
              }
            }'

      - name: Full rollout
        run: |
          aws appmesh update-route --mesh-name my-mesh --virtual-service my-service \
            --route-name primary \
            --http-route '{
              "priority": 1,
              "action": {
                "weightedTargets": [
                  {"virtualNode": "canary-vn", "weight": 100}
                ]
              }
            }'
```

### Feature Flags

```yaml
# Deploy behind feature flag
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy with feature flag OFF
        run: |
          # Deploy new code, but feature flag is OFF
          ./deploy.sh --feature-flag=disabled

      - name: Enable feature flag for 5% of users
        run: |
          curl -X PATCH "https://flags.example.com/api/flags/new-feature" \
            -H "Authorization: Bearer ${{ secrets.FLAG_TOKEN }}" \
            -d '{"enabled": true, "percentage": 5}'

      - name: Monitor for 1 hour
        run: sleep 3600

      - name: Enable for 50%
        run: |
          curl -X PATCH "https://flags.example.com/api/flags/new-feature" \
            -d '{"percentage": 50}'

      - name: Enable for 100%
        run: |
          curl -X PATCH "https://flags.example.com/api/flags/new-feature" \
            -d '{"percentage": 100, "enabled": true}'
```

### Rolling Update

```yaml
# Kubernetes rolling update
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # One extra pod during update
      maxUnavailable: 0   # Never reduce below desired count
  template:
    spec:
      containers:
        - name: myapp
          image: myapp:latest
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 5
```

---

## Part 7: Rollback Patterns

### Automated Rollback

```yaml
# GitHub Actions with automatic rollback
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Save current version
        id: current
        run: |
          CURRENT=$(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].image}')
          echo "version=$CURRENT" >> "$GITHUB_OUTPUT"

      - name: Deploy new version
        id: deploy
        run: |
          kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
          kubectl rollout status deployment/myapp --timeout=300s

      - name: Run smoke tests
        id: smoke
        run: |
          for i in {1..5}; do
            STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://example.com/health)
            if [ "$STATUS" != "200" ]; then
              echo "Health check failed (attempt $i)"
              sleep 10
              continue
            fi
            echo "Health check passed"
            exit 0
          done
          echo "All health checks failed"
          exit 1

      - name: Rollback on failure
        if: failure() && steps.deploy.outcome == 'success'
        run: |
          echo "Rolling back to ${{ steps.current.outputs.version }}"
          kubectl rollout undo deployment/myapp
          kubectl rollout status deployment/myapp --timeout=300s
```

### Manual Rollback Commands

```bash
# Kubernetes rollback
kubectl rollout undo deployment/myapp                    # Rollback to previous
kubectl rollout undo deployment/myapp --to-revision=3    # Rollback to specific revision
kubectl rollout history deployment/myapp                 # View revision history

# AWS ECS rollback
aws ecs update-service --cluster my-cluster --service my-service \
  --task-definition my-app:PREVIOUS_TASK_DEF

# Docker Compose rollback
docker compose up -d --force-recreate    # Recreate with current config
docker compose down && git checkout HEAD~1 docker-compose.yml && docker compose up -d
```

---

## Part 8: Pipeline Debugging

### Common Failure Patterns

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| YAML syntax errors | Indentation, missing colons | Use YAML linter |
| Wrong action versions | Using `@v1` when `@v4` is current | Update action versions |
| Missing permissions | `packages: write` for publishing | Add required permissions |
| Secret not set | Misspelled secret name | Check secret name spelling |
| Path issues | Wrong working directory | Add `working-directory` or use absolute paths |
| Timeout | Job exceeds 6-hour limit | Optimize or split into smaller jobs |
| Race conditions | Deploy before tests finish | Add `needs` dependencies |
| Flaky tests | Non-deterministic tests | Fix tests, add retries |
| Cache corruption | Inconsistent cache key | Use hash-based cache keys |

### Debugging Tips

```yaml
# Enable debug logging
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true

# Print environment variables
- run: env | sort

# Debug workflow with SSH
- name: Setup SSH
  if: failure()
  uses: luchihoraci/ssh-action@v1
  with:
    server: ${{ secrets.DEBUG_SSH_SERVER }}
    username: ${{ secrets.DEBUG_SSH_USER }}
    key: ${{ secrets.DEBUG_SSH_KEY }}

# Re-run failed jobs with debug
# In GitHub: Actions → Failed run → Re-run all jobs → Enable debug logging
```

---

## Part 9: Language-Specific Test Commands

| Language | Test Command | Coverage | Lint |
|----------|-------------|----------|------|
| Node.js | `npm test` / `npx vitest run` | `npx vitest run --coverage` | `npm run lint` |
| Python | `pytest` | `pytest --cov=src` | `ruff check .` or `flake8` |
| Go | `go test ./...` | `go test -cover ./...` | `golangci-lint run` |
| Rust | `cargo test` | `cargo tarpaulin` | `cargo clippy` |
| Java | `mvn test` / `gradle test` | `mvn jacoco:report` | `mvn checkstyle:check` |

---

## Part 10: Complete Pipeline Templates

### Full-Stack Application Pipeline

```yaml
name: Full-Stack CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # === Test Phase ===
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm' }
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check

  test-api:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_DB: test
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports: ['5432:5432']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm' }
      - run: npm ci
      - run: npm run test:api
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test

  test-e2e:
    runs-on: ubuntu-latest
    needs: [test-api]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20', cache: 'npm' }
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm audit --audit-level=high
      - uses: gitleaks/gitleaks-action@v2

  # === Build Phase ===
  build:
    needs: [lint, test-api, test-e2e, security]
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v4
      - id: meta
        run: echo "tags=ghcr.io/${{ github.repository }}:${{ github.sha }}" >> "$GITHUB_OUTPUT"
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # === Deploy Phase ===
  deploy-staging:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - run: echo "Deploying to staging with tag ${{ needs.build.outputs.image-tag }}"

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying to production"
```

---

## Output Format

1. **Pipeline file(s)** — Complete, ready-to-commit configuration files with filename headers.
2. **Setup instructions** — Any secrets to configure, branch protection rules to enable, or platform settings needed.
3. **Explanation** — Brief description of the pipeline structure and why specific choices were made.
4. **If debugging** — Root cause of the failure and the exact fix.

## Common Pitfalls to Avoid

- **Don't run heavy jobs on every PR** — Full E2E tests and deploys only on main branch.
- **Don't hardcode secrets.** Ever. Use the platform's encrypted secrets store.
- **Don't pin to `@master` or `@main`** for actions. Pin to specific versions or SHA commits for security.
- **Don't ignore caching.** A pipeline without caching is a slow pipeline.
- **Don't make the pipeline a single monolithic job.** Split into logical jobs with clear dependencies.
- **Don't forget to set `needs`** — Without it, all jobs run in parallel, which wastes resources and can deploy before tests pass.
- **Don't skip security scanning.** SAST, DAST, and dependency scanning should be part of every pipeline.
- **Don't deploy without rollback capability.** Always have a way to revert to the previous version.
- **Don't ignore flaky tests.** They erode confidence in the pipeline and waste developer time.
