---
name: ci-cd-pipeline
description: >-
  Set up, configure, and debug CI/CD pipelines for continuous integration and deployment.
  Trigger this skill when the user wants to create or fix a CI/CD pipeline, set up GitHub Actions, GitLab CI,
  configure automated testing, build automation, deployment automation, or continuous delivery workflows.
  Also activate for: CI/CD, پایپ‌لاین, پایپ‌لاین استقرار, GitHub Actions, GitLab CI, continuous integration,
  continuous deployment, deployment pipeline, build pipeline, automated testing, setup pipeline,
  workflow configuration, CI pipeline broken, CD pipeline fix, pipeline as code, DevOps pipeline,
  automated deploy, test automation, branch protection, merge queue, release workflow,
  Jenkins pipeline, Jenkinsfile, CircleCI config, Bitbucket pipelines, Azure DevOps pipelines,
  GitHub Actions reusable workflows, composite actions, workflow concurrency,
  canary deployment pipeline, blue-green deploy, rolling update pipeline, monorepo CI,
  پیکربندی پایپ‌لاین, تست خودکار, استقرار خودکار, گردش کار GitHub,
  پایپ‌لاین شکسته, خطای پایپ‌لاین, زمان‌بندی CI, لینت خودکار,
  OIDC federation, ephemeral environments, preview deployments,
  semantic release, changelog automation, GitHub environments,
  E2E testing in CI, Playwright CI, Cypress CI, Docker in CI,
  container registry push, ECR login, GCR push, ACR push,
  smoke test, rollback pipeline, deploy notification, Slack notification,
  pipeline observability, flaky test detection,
  پایپ‌لاین جیت‌هاب, اکشنز گیت‌هاب, پایپ‌لاین گیت‌لب,
  تست سی‌آی شکسته, دیپلوی شکسته, بیلد شکسته,
  جیکینز, سرکل‌سی‌آی, بیتباکت پایپ‌لاینز,
  اتوماسیون تست, اتوماسیون دیپلوی, خط لوله یکپارچه,
  GitHub Actions matrix, GitHub Actions cache, GitHub Actions artifacts,
  GitHub Actions self-hosted runner, GitHub Actions OIDC,
  GitLab CI/CD variables, GitLab CI cache, GitLab CI artifacts,
  GitLab CI include, GitLab CI rules, GitLab CI trigger,
  Jenkins declarative pipeline, Jenkins shared library, Jenkins agent,
  Jenkins credentials, Jenkins multibranch pipeline,
  feature flag pipeline, trunk-based development CI,
  deployment slot, traffic splitting, progressive delivery,
  ArgoCD, Flux CD, GitOps pipeline, Pull Request preview,
  build notification, test report, coverage report in CI,
  code quality gate, SonarQube CI, CodeClimate CI,
  dependency update CI, Dependabot, Renovate,
  artifact versioning, immutable artifact, build reproducibility,
  CI runner security, CI secret management, CI environment isolation.
---

# CI/CD Pipeline Skill — Build, Test & Deploy Automation

## Overview

This skill creates and debugs CI/CD pipelines that automate building, testing, and deploying code. It covers GitHub Actions, GitLab CI, Jenkins, and general pipeline patterns. The focus is on pipelines that are fast, reliable, secure, and maintainable — not just "something that runs."

## When to Use This Skill

- User wants to set up a CI/CD pipeline from scratch
- User needs to fix a broken GitHub Actions or GitLab CI pipeline
- User asks about automated testing, builds, or deployments
- User mentions continuous integration, continuous delivery, or deployment pipelines
- User wants branch-based workflows (test on PR, deploy on merge)
- User needs environment-specific deployments (staging, production)
- User needs canary, blue-green, or rolling deployment pipelines
- User wants monorepo-aware CI with path-based triggers
- User needs preview/ephemeral environments for pull requests
- User asks about release automation, changelog generation, or semantic versioning
- User needs to integrate security scanning into the pipeline
- User wants to set up branch protection rules with required status checks
- User needs custom actions or composite actions for code reuse
- User wants to debug flaky tests or optimize pipeline speed

## Workflow

### Step 1: Understand the Project and Requirements

1. **Read the project** — Identify language, framework, test runner, build tool, deployment target.
2. **Check for existing pipelines** — Read `.github/workflows/`, `.gitlab-ci.yml`, or `Jenkinsfile`.
3. **Determine the CI/CD platform** — GitHub Actions default. Ask if user prefers GitLab CI, Jenkins, CircleCI.
4. **Identify the pipeline scope:**
   - Lint / format check
   - Unit tests
   - Integration tests
   - Build (compile, bundle, Docker image)
   - Security scanning
   - Deploy to staging
   - Deploy to production

### Step 2: Design the Pipeline

1. **Choose trigger events:**
   - `push` to main: full build + deploy
   - `pull_request`: lint + test (no deploy)
   - `release` or tag: build + deploy production
   - `workflow_dispatch`: manual trigger
   - `schedule`: cron-based periodic jobs
2. **Define job dependencies** — Tests before deploy, build before publish.
3. **Plan caching strategy** — Cache node_modules, pip cache, Maven repo, Go modules.
4. **Plan secrets management** — Use platform secrets store, never hardcode.

### Step 3: Write the Pipeline Configuration

#### GitHub Actions (Default)

```yaml
name: CI/CD Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

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
    steps:
      # Deploy steps here
```

#### GitLab CI

```yaml
stages:
  - test
  - build
  - deploy

test:
  stage: test
  image: node:20-alpine
  script:
    - npm ci
    - npm test

build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .

deploy_staging:
  stage: deploy
  script:
    - echo "Deploy to staging"
  only:
    - main
```

### Step 4: Implement Key Features

1. **Dependency caching** — Cut build times by 50-80%.
2. **Parallel jobs** — Unit tests, lint, type-check in parallel.
3. **Artifact passing** — `actions/upload-artifact` or GitLab artifacts between jobs.
4. **Environment protection** — Require approvals for production deploys.
5. **Failure notifications** — Slack or Discord notifications on failure.
6. **Matrix builds** — Test across multiple versions.

### Step 5: Debug Existing Pipelines

1. Read pipeline file and error output.
2. **Common failures:** YAML syntax, wrong action versions, missing permissions, misspelled secrets, path issues, timeouts, missing `needs`.
3. Propose exact fix with explanation.

## Advanced Techniques

### 1. Monorepo Path-Based Triggers

```yaml
name: Monorepo CI
on:
  push:
    branches: [main]
    paths:
      - 'apps/api/**'
      - 'packages/shared/**'
jobs:
  api-test:
    if: contains(github.event.commits[0].modified, 'apps/api/') || contains(github.event.commits[0].modified, 'packages/shared/')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cd apps/api && npm ci && npm test
```

### 2. Concurrency Control to Cancel Redundant Runs

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}
```

Cancels in-progress PR runs but allows main deploys to complete.

### 3. OIDC Federation for Secret-Free Cloud Auth

```yaml
- uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789012:role/github-actions
    role-session-name: github-${{ github.run_id }}
    aws-region: us-east-1
- name: Push to ECR
  run: |
    aws ecr get-login-password | docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com
    docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:${{ github.sha }}
```

### 4. Ephemeral Preview Environments

```yaml
deploy-preview:
  needs: build
  if: github.event_name == 'pull_request'
  runs-on: ubuntu-latest
  environment:
    name: preview/pr-${{ github.event.number }}
    url: ${{ steps.deploy.outputs.url }}
  steps:
    - name: Deploy to Preview
      id: deploy
      run: |
        echo "url=https://pr-${{ github.event.number }}.preview.example.com" >> $GITHUB_OUTPUT
    - name: Comment PR with URL
      uses: actions/github-script@v7
      with:
        script: |
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner, repo: context.repo.repo,
            body: `🚀 Preview: ${{ steps.deploy.outputs.url }}`
          })
```

### 5. Reusable Workflows for DRY Pipeline Code

```yaml
# .github/workflows/reusable-test.yml
name: Reusable Test
on:
  workflow_call:
    inputs:
      node-version: {type: string, default: '20'}
      test-command: {type: string, default: 'npm test'}
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: {node-version: '${{ inputs.node-version }}'}
      - run: npm ci
      - run: ${{ inputs.test-command }}
# Caller: uses: ./.github/workflows/reusable-test.yml with: {node-version: '22'}
```

### 6. Matrix Strategy with Fail-Fast Disabled

```yaml
jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node-version: [18, 20, 22]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci && npm test
```

### 7. Canary Deployment Pipeline with Rollback

```yaml
jobs:
  deploy-canary:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
      - run: kubectl rollout status deployment/myapp --timeout=120s
  smoke-test:
    needs: deploy-canary
    runs-on: ubuntu-latest
    steps:
      - run: npm run test:smoke -- --base-url https://canary.example.com
  deploy-full:
    needs: smoke-test
    runs-on: ubuntu-latest
    steps:
      - run: kubectl scale deployment myapp --replicas=10
  rollback-on-failure:
    needs: smoke-test
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - run: kubectl rollout undo deployment/myapp
```

## Common Patterns

### Pattern 1: Full-Stack Pipeline with Docker + ECR

```yaml
name: Full Stack CI/CD
on:
  push:
    branches: [main, staging]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env: {POSTGRES_DB: testdb, POSTGRES_USER: test, POSTGRES_PASSWORD: test}
        options: >-
          --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
    env: {DATABASE_URL: 'postgres://test:test@localhost:5432/testdb'}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: {node-version: '20', cache: 'npm'}
      - run: npm ci
      - run: npm run lint && npm run test
  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    permissions: {id-token: write, contents: read}
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/github-actions
          aws-region: us-east-1
      - uses: docker/setup-buildx-action@v3
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: |
            ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/myapp:${{ github.sha }}
            ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
  deploy-staging:
    needs: build-and-push
    if: github.ref == 'refs/heads/staging'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - run: echo "Deploy to ECS staging"
  deploy-production:
    needs: build-and-push
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploy to ECS production"
```

### Pattern 2: Automated Semantic Release

```yaml
name: Release
on:
  push:
    branches: [main]
jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci && npm run build
      - name: Semantic Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npx semantic-release
```

### Pattern 3: GitLab CI with Services and Caching

```yaml
stages: [test, build, deploy]
test:
  stage: test
  image: node:20-alpine
  services: [{name: postgres:16-alpine, alias: db}]
  variables: {DATABASE_URL: 'postgres://test:test@db:5432/testdb'}
  script: [npm ci, npm test]
  cache: {key: $CI_COMMIT_REF_SLUG-npm, paths: [node_modules/]}
  artifacts: {reports: {junit: test-results.xml}}
build:
  stage: build
  image: docker:24
  services: [docker:24-dind]
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only: [main]
deploy:
  stage: deploy
  image: alpine:3.19
  script:
    - curl -X POST -H "Authorization: Bearer $DEPLOY_TOKEN" https://deploy.example.com/webhook
  only: [main]
  when: manual
```

### Pattern 4: Playwright E2E Tests with Artifact Upload

```yaml
name: E2E Tests
on: {pull_request: {branches: [main]}}
jobs:
  e2e:
    runs-on: ubuntu-latest
    container: {image: 'mcr.microsoft.com/playwright:v1.42.0-jammy'}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: {node-version: '20', cache: 'npm'}
      - run: npm ci
      - run: npx playwright install --with-deps chromium
      - run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: failure()
        with: {name: playwright-report, path: playwright-report/, retention-days: 7}
```

### Pattern 5: Scheduled Security Scanning Pipeline

```yaml
name: Nightly Security Scan
on:
  schedule: [{cron: '0 3 * * *'}]
  workflow_dispatch: {}
jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aquasecurity/trivy-action@master
        with: {scan-type: 'fs', scan-ref: '.', severity: 'CRITICAL,HIGH', format: 'sarif', output: 'trivy-results.sarif'}
      - uses: github/codeql-action/upload-sarif@v3
        if: always()
        with: {sarif_file: 'trivy-results.sarif'}
  dependency-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: {node-version: '20'}
      - run: npm ci
      - run: npm audit --production --json > audit-results.json
      - run: |
          CRITICAL=$(jq '[.vulnerabilities[] | select(.severity=="critical")]' audit-results.json)
          if [ "$CRITICAL" != "[]" ]; then echo "::error::Critical CVEs"; exit 1; fi
```

## Edge Cases & Pitfalls

1. **Missing `needs` causing parallel execution** — Without `needs`, all jobs run simultaneously. Deploy might start before tests finish.

2. **Cached dependencies becoming stale** — Caching without proper cache key causes outdated dependencies. Include lockfile hash in key.

3. **GitHub Actions 6-hour timeout** — Long-running E2E tests can silently fail. Set explicit `timeout-minutes`.

4. **Secrets not available on forked PRs** — GitHub Actions doesn't pass secrets to forked PRs. Use `pull_request_target` carefully.

5. **Git shallow clone breaks version calculation** — Default checkout is 1 commit deep. Tools like `semantic-release` need `fetch-depth: 0`.

6. **Self-hosted runner state pollution** — Runners retain files between runs. Clean artifacts, pin tool versions.

7. **Matrix exploding runner minutes** — 3x3x3 = 27 parallel jobs. Use `include`/`exclude` to reduce.

8. **Docker layer cache not shared between branches** — GHA cache is branch-scoped. Use `cache: type=gha,scope=main` to share.

9. **GitLab CI runner tag mismatch** — Jobs with `tags: [docker]` won't run if no runner has that tag.

10. **Environment not persisting between steps** — Use `$GITHUB_ENV`: `echo "VAR=value" >> $GITHUB_ENV`.

11. **Action version pinning** — Pin to SHA for security, not just `@v4`.

12. **Concurrency cancelling deploys** — Never set `cancel-in-progress: true` for deployment workflows.

13. **Artifact size limits** — GitHub Actions artifacts limited to 2GB. Use caching for large files.

14. **Cron timezone mismatch** — GitHub Actions cron uses UTC.

15. **Permissions scoping** — Jobs pushing to registries or creating releases need explicit `permissions` blocks.

16. **Self-hosted runner security** — `pull_request_target` on self-hosted runners can execute untrusted code.

17. **Flaky test retries masking real bugs** — Adding retry logic without root-cause analysis hides real issues. Track flake rate.

## Integration

### Related Skills

- **Dockerization** (`dockerization`) — CI pipelines build and push Docker images. Cache strategies, multi-arch builds, and BuildKit features from dockerization are used in CI.
- **Cloud Deployment** (`cloud-deployment`) — CI pipelines deploy to cloud services. OIDC roles, ECS task definitions, and Cloud Run services all connect.
- **Security Audit** (`security-audit`) — Nightly security scan pipelines use tools from security audit skill (Trivy, Gitleaks, Bandit, gosec).

### Common Integration Points

1. **Dockerization + CI/CD** — Dockerfile → `docker build` in CI → push to registry → deploy from cloud skill.
2. **Security Audit + CI/CD** — Security tools run as CI jobs on schedule and on push.
3. **Cloud Deployment + CI/CD** — Terraform/CloudFormation applied by CI pipeline on infrastructure changes.

## Output Format Templates

### Template A: New Pipeline Setup

```markdown
## CI/CD Pipeline
**Platform:** GitHub Actions | **Triggers:** push to main, pull request, tags | **Runtime:** ~X min

### Workflow File: `.github/workflows/ci.yml`
[complete YAML]

### Required Secrets
| Secret | Purpose | How to Set |
|--------|---------|------------|
| AWS_ROLE_ARN | OIDC auth | GitHub Settings → Secrets → Add |

### Branch Protection
- Require status checks: [list jobs]
- Require PR reviews: [count]

### Pipeline Flow
[brief job dependency description]
```

### Template B: Pipeline Debug / Fix

```markdown
## Pipeline Fix
### Problem: [failure description]
### Root Cause: [explanation with problematic code]
### Fix: [corrected YAML]
### Changes: - [Change 1]: [Why] - [Change 2]: [Why]
### Verification: [steps to verify]
```

### Template C: Multi-Environment Pipeline

```markdown
## Multi-Environment CI/CD
**Environments:** dev → staging → production
**Strategy:** [Canary / Blue-Green / Rolling]

### Workflow File: [complete YAML]

### Environment Config
| Env | Branch | Auto? | Approval? |
|-----|--------|-------|------------|
| Dev | develop | Yes | No |
| Staging | main | Yes | No |
| Prod | tags v* | Yes | 2 reviewers |

### Rollback: [steps]
```

### Template D: Pipeline Optimization Report

```markdown
## Pipeline Optimization Report
### Current: Build X min, Test X min, Total X min, Runners X/mo
### Bottlenecks: 1. [Issue] 2. [Issue]
### Optimizations: - [Fix]: Save X min - [Fix]: Save X min
### Optimized Pipeline: [YAML]
### After: Total ~X min (XX% faster), Runners ~X/mo (XX% less)
```