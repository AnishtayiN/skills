---
name: dockerization
description: >-
  Create, optimize, and debug Dockerfiles and docker-compose configurations for any application.
  Trigger this skill when the user wants to dockerize an app, write a Dockerfile, create a docker-compose setup,
  containerize a project, build images, or configure multi-container environments.
  Also activate for: داکرایز کردن, داکر, کانتینرسازی, Dockerfile, docker-compose, containerize this app,
  create container, Docker setup, multi-stage build, optimize Docker image, Docker networking,
  Docker volumes, container orchestration, dockerize, containerize, build image, push to registry,
  Docker Desktop, container runtime, OCI image, image optimization, layer caching,
  docker buildx, buildkit, multi-arch build, arm64 docker, container health check,
  docker secret, docker config, docker swarm, rootless docker,
  compose watch, compose profiles, GPU container, CUDA docker,
  نحوه ساخت داکرفایل, فایل داکر کامپوز, بهینه‌سازی ایمیج داکر, حجم ایمیج داکر,
  کانتینر دیتابیس, داکر محلی, محیط توسعه داکر, شبکه‌بندی داکر,
  Dockerfile best practices, slim image, alpine vs debian, scratch image, distroless image,
  build cache mount, .dockerignore patterns, non-root container,
  entrypoint vs cmd, docker init process, signal handling in docker, zombie processes,
  container logging driver, docker resource limits, memory limit, CPU quota, OOM killer,
  multi-platform image, QEMU docker, docker credential helper,
  ARG vs ENV, build secrets, mount type=cache,
  docker compose v2, depends_on condition, service healthy,
  docker network driver, bridge vs overlay, macvlan,
  docker volume plugin, tmpfs mount, bind mount vs volume,
  داکر را اجرا کن, کانتینر بساز, ایمیج داکر, داکرفایل بنویس,
  داکر کامپوز تنظیم, داکر را بهینه کن, مشکل داکر, خطای داکر,
  ساخت ایمیج, پوش ایمیج, رجیستری داکر, لایه داکر,
  کش داکر, داکراینور, پورت داکر, حجم داکر,
  داکر در ویندوز, داکر در مک, داکر در لینوکس, داکر روتلز,
  containerd, podman, nerdctl, buildah, skopeo, OCI spec,
  docker scout, docker sbom, docker buildx bake, docker compose env,
  heredoc in dockerfile, shell-form vs exec-form, onbuild trigger,
  docker trust, notary, content trust, image signing,
  scratch container, static binary container, minimal container,
  docker build context, docker ignore, copy vs add,
  workdir instruction, expose instruction, volume instruction,
  docker networking dns, container dns resolution, embedded dns,
  docker compose override, compose merge, compose include,
  docker desktop wsl2, docker desktop mac, docker engine linux,
  container restart policy, docker stop timeout, docker kill signal,
  docker system prune, docker image prune, dangling images,
  multi-container app, microservice docker, monolith dockerize.
---

# Dockerization Skill — Dockerfile & Docker Compose

## Overview

This skill handles creating production-grade Docker configurations for any application. It covers single-service Dockerfiles, multi-service docker-compose setups, image optimization, multi-stage builds, GPU container support, and troubleshooting common container issues. The goal is always a small, secure, fast-building image that actually works.

## When to Use This Skill

- User wants to containerize an application
- User asks for a Dockerfile or docker-compose.yml
- User mentions Docker, containers, or image builds
- User needs to fix a broken Docker build or runtime
- User wants multi-stage builds, volume mounts, or network configuration
- User asks about Docker best practices or image optimization
- User needs GPU/CUDA support in containers
- User wants multi-architecture (arm64/amd64) images
- User asks about Docker Compose profiles, watch mode, or override files
- User needs to debug container startup failures, signal handling, or zombie processes
- User wants to set up local development environment with Docker
- User asks about Docker resource limits, memory management, or OOM issues
- User needs to configure container networking, DNS, or service discovery
- User wants to understand layer caching, build context, or .dockerignore patterns
- User needs rootless Docker or security-hardened containers

## Workflow

### Step 1: Analyze the Project

1. **Read the project structure** — Identify language, framework, build system, entry point. Look for package.json, requirements.txt, go.mod, Cargo.toml, pom.xml, Gemfile, etc.
2. **Identify dependencies** — Database, cache, message queue, external service?
3. **Determine build vs. runtime needs** — Compilers/bundlers at build time, interpreters/libraries at runtime.
4. **Check for existing Docker files** — Read Dockerfile, docker-compose.yml to understand what exists.
5. **Check for monorepo patterns** — Multiple services that need separate Dockerfiles.

### Step 2: Write the Dockerfile

1. **Choose the right base image** — Official slim/Alpine variants. `node:20-alpine` > `node:20`. Consider distroless for security.
2. **Use multi-stage builds** — Separate build and runtime. Can reduce image size by 10x.
3. **Leverage layer caching** — Order: system deps → language deps → app code.
4. **Set a non-root user** — Dedicated user + USER directive. Never root in production.
5. **Use .dockerignore** — Exclude node_modules, .git, dist, build artifacts.
6. **Set HEALTHCHECK** — So orchestrators know the container is alive.
7. **Pin dependency versions** — Specific tags, not `latest`. Use digests for reproducibility.
8. **Use BuildKit features** — `--mount=type=cache`, `--mount=type=secret`.

### Step 3: Write docker-compose.yml (if needed)

1. Define services with clear naming
2. Use Compose Specification (no version key for v2)
3. Configure custom networks for isolation
4. Named volumes for persistent data, bind mounts for dev only
5. `env_file` or `.env` for secrets — never hardcode
6. Health checks on each service
7. Restart policies: `unless-stopped` for production
8. Profiles for dev-only services
9. `depends_on` with `condition: service_healthy`

### Step 4: Create .dockerignore

Generate tailored to the project's language and framework.

### Step 5: Add Build & Run Instructions

Provide clear copy-pasteable commands.

## Language-Specific Patterns

### Node.js
- Multi-stage: `node` for build, `node:alpine` for runtime
- Run as `node` user (pre-existing in official image)
- Copy package files first, `npm ci`, then source
- Next.js: `standalone` output mode for minimal images

### Python
- `python:3.x-slim` base, create venv, install deps, copy source
- `gunicorn` or `uvicorn` in production, pin with `requirements.txt` hashes

### Go
- Multi-stage: `golang` build → `alpine`/`scratch` runtime
- `CGO_ENABLED=0` for static binaries, final image 10-20MB

### Rust
- Multi-stage: `rust` build → `alpine`/`debian:bookworm-slim` runtime
- `cargo chef` for dependency caching

### Java/JVM
- Multi-stage: `maven`/`gradle` build → `eclipse-temurin:21-jre-alpine` runtime
- Copy only the JAR or use jlink for custom JRE

## Advanced Techniques

### 1. BuildKit Cache Mounts for Lightning-Fast Builds

Use `--mount=type=cache` to persist dependency caches across builds without bloating the image:

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine AS builder
RUN --mount=type=cache,target=/root/.npm \
    npm ci
COPY . .
RUN --mount=type=cache,target=/root/.npm/node_modules \
    npm run build
```

This avoids reinstalling all npm packages on every code change while keeping them out of the final image.

### 2. Distroless Images for Maximum Security

Google's distroless images contain only your application and its runtime dependencies — no shell, no package manager, no attack surface:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server

FROM gcr.io/distroless/static-debian12
COPY --from=builder /server /server
ENTRYPOINT ["/server"]
```

### 3. Multi-Architecture Builds with buildx

Build images that run on amd64, arm64, and more in a single command:

```bash
docker buildx create --use --name multiarch
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 \
  -t myregistry/myapp:v1.0.0 --push .
```

### 4. Docker Compose Watch Mode for Development

```yaml
services:
  web:
    build: .
    develop:
      watch:
        - action: sync
          path: ./src
          target: /app/src
        - action: rebuild
          path: ./package.json
```

Run: `docker compose up --watch` for hot-reload-like behavior.

### 5. Build-Time Secrets

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine
RUN --mount=type=secret,id=npm_token \
    npm config set //registry.npmjs.org/:_authToken $(cat /run/secrets/npm_token) && \
    npm ci
```

```bash
docker build --secret id=npm_token,src=./.npm_token .
```

### 6. GPU Container with CUDA Support

```dockerfile
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
WORKDIR /app
CMD ["python3", "inference.py"]
```

```bash
docker run --gpus all my-gpu-app
```

### 7. Cross-Build with QEMU and buildx Bake

Use `docker-bake.hcl` for complex multi-service, multi-platform builds:

```hcl
# docker-bake.hcl
group "default" {
  targets = ["api", "worker"]
}
target "api" {
  dockerfile = "api/Dockerfile"
  context = "api"
  tags = ["myregistry/api:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
}
target "worker" {
  dockerfile = "worker/Dockerfile"
  context = "worker"
  tags = ["myregistry/worker:latest"]
}
```

```bash
docker buildx bake --push
```

## Common Patterns

### Pattern 1: Next.js with Standalone Output

```dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
ENV PORT=3000 HOSTNAME="0.0.0.0"
CMD ["node", "server.js"]
```

### Pattern 2: Python FastAPI with Gunicorn

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser appuser
COPY --from=builder /install /usr/local
COPY . .
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"
CMD ["gunicorn", "main:app", "-w", "4", "-b", "0.0.0.0:8000", "-k", "uvicorn.workers.UvicornWorker"]
```

### Pattern 3: Full Stack with Docker Compose

```yaml
services:
  frontend:
    build: ./frontend
    ports: ["3000:3000"]
    depends_on:
      api: { condition: service_healthy }
  api:
    build: ./api
    ports: ["8000:8000"]
    environment:
      DATABASE_URL: postgres://app:secret@db:5432/mydb
      REDIS_URL: redis://cache:6379
    depends_on:
      db: { condition: service_healthy }
      cache: { condition: service_healthy }
  db:
    image: postgres:16-alpine
    volumes: [pgdata:/var/lib/postgresql/data]
    environment: { POSTGRES_DB: mydb, POSTGRES_USER: app, POSTGRES_PASSWORD: secret }
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d mydb"]
      interval: 5s
      timeout: 5s
      retries: 5
  cache:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5
volumes:
  pgdata:
```

### Pattern 4: Go Microservice (Scratch Image)

```dockerfile
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git ca-certificates
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/server /app/server
EXPOSE 8080
ENTRYPOINT ["/app/server"]
```

### Pattern 5: Monorepo with Multiple Dockerfiles and Compose

```yaml
# docker-compose.yml
services:
  gateway:
    build: { context: ., dockerfile: packages/gateway/Dockerfile }
    ports: ["8080:8080"]
    depends_on:
      users: { condition: service_healthy }
      orders: { condition: service_healthy }
  users:
    build: { context: ., dockerfile: packages/users/Dockerfile }
    environment: { DATABASE_URL: postgres://app:secret@users-db:5432/users }
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8001/health"]
  orders:
    build: { context: ., dockerfile: packages/orders/Dockerfile }
    environment: { DATABASE_URL: postgres://app:secret@orders-db:5432/orders }
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8002/health"]
  users-db:
    image: postgres:16-alpine
    environment: { POSTGRES_DB: users, POSTGRES_USER: app, POSTGRES_PASSWORD: secret }
    volumes: [users-data:/var/lib/postgresql/data]
  orders-db:
    image: postgres:16-alpine
    environment: { POSTGRES_DB: orders, POSTGRES_USER: app, POSTGRES_PASSWORD: secret }
    volumes: [orders-data:/var/lib/postgresql/data]
volumes:
  users-data:
  orders-data:
```

```dockerfile
# packages/gateway/Dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .
COPY packages/gateway/package.json packages/gateway/
COPY packages/shared/package.json packages/shared/
RUN corepack enable && pnpm install --frozen-lockfile
COPY packages/shared/ packages/shared/
COPY packages/gateway/ packages/gateway/
RUN --mount=type=cache,target=/root/.pnpm-store \
    pnpm --filter gateway build

FROM node:20-alpine
WORKDIR /app
RUN addgroup --system --gid 1001 app && adduser --system --uid 1001 app
COPY --from=builder /app/packages/gateway/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages/shared/dist ./node_modules/shared
USER app
EXPOSE 8080
CMD ["node", "dist/index.js"]
```

## Edge Cases & Pitfalls

1. **Layer cache invalidation from COPY . .** — Copying all files before package install invalidates dependency cache on every code change. Copy package manifests first, install deps, then copy source.

2. **Timezone issues in Alpine containers** — Alpine uses musl libc which reads `/etc/localtime` differently. Install `tzdata` or set `TZ` environment variable explicitly.

3. **DNS resolution failures in Docker networks** — On Linux, Docker's embedded DNS can fail. Set `dns` in daemon.json or use fully qualified domain names within compose networks.

4. **Volume permission conflicts** — Bind-mounted volumes may have different UID/GID than the container user. Use `--user` flag or run `chown` in the entrypoint script.

5. **Zombie processes accumulating** — PID 1 must reap orphaned children. If app is not init-aware, use `--init` flag or `tini` to prevent zombies.

6. **Signal handling differences** — Shell-form CMD (`CMD npm start`) ignores signals. Use exec form (`CMD ["npm", "start"]`) or `exec` in entrypoint.

7. **Build context too large** — Sending huge context (monorepo with node_modules) makes `docker build` slow. Always use comprehensive `.dockerignore`.

8. **Multi-stage build breaks symlinks** — COPY may not preserve symlinks. Use `COPY --link` in BuildKit or verify symlink targets.

9. **ARG vs ENV scope confusion** — `ARG` is build-time only. `ENV` persists at runtime. ARG before FROM is not available inside stages without redeclaration.

10. **Health check causing restart loops** — Poorly configured HEALTHCHECK with short intervals triggers constant restarts. Set `interval >= 30s`, `timeout >= 5s`, `retries >= 3`.

11. **Docker Compose `.env` file precedence** — Compose reads `.env` from project root, not working directory. Use `--env-file` or `env_file` directive explicitly.

12. **Lost signals on docker stop** — `CMD java -jar app.jar` may not receive SIGTERM. Use `exec` in entrypoint or set `STOPSIGNAL SIGTERM`.

13. **Base image `latest` tag mutability** — `latest` can change over time, breaking reproducibility. Pin to digest: `image:tag@sha256:abc123`.

14. **Overlay2 driver with many small writes** — SQLite has poor performance on overlay2. Use named volume (not bind mount) for data directory.

15. **macOS/Windows file system performance** — Bind mounts on macOS (VirtioFS) and Windows (9P) are slower than Linux. Minimize files in bind-mounted directories.

16. **COPY vs ADD confusion** — Use COPY for local files. ADD only for remote URLs or auto-extract tarballs. ADD with URLs breaks build reproducibility (no caching guarantee).

17. **Docker Compose networking loopback** — Services can't reach `localhost` to access other services. Use service names as hostnames within the compose network.

18. **Stale image tags in registries** — Pushing with `:latest` can cause caching issues downstream. Use immutable tags (SHA or version) and rotate `latest` separately.

## Integration

### Related Skills

- **CI/CD Pipeline** (`ci-cd-pipeline`) — Use Dockerfiles inside CI for automated image building and pushing to registries. Cache strategies from this skill feed directly into CI build steps.
- **Cloud Deployment** (`cloud-deployment`) — Docker images are deployed to ECS, Cloud Run, AKS, or GKE. Cloud services need properly tagged, multi-arch images from this skill.
- **Security Audit** (`security-audit`) — Run Trivy, Snyk, or Grype scans on built images. Check for exposed secrets, non-root users, and base image CVEs.

### Common Integration Points

1. **Dockerization + CI/CD + Cloud** — Dockerfile → CI builds/pushes to ECR/GCR/ACR → Cloud deployment skill deploys.
2. **Security Audit + Dockerization** — Audit findings (non-root, distroless, no secrets) feed back into Dockerfile improvements.
3. **CI/CD + Dockerization** — Pipeline uses `docker buildx bake` for multi-service monorepo builds, BuildKit cache mounts for speed.

## Output Format Templates

### Template A: Standard Dockerization (Single Service)

```markdown
## Docker Configuration

**Base Image:** `node:20-alpine` (45MB, Node.js 20 on Alpine Linux)
**Strategy:** Multi-stage build separating build and runtime
**Final Image Size:** ~120MB (vs ~1.2GB without optimization)

### Dockerfile
[full Dockerfile with comments]

### .dockerignore
[full .dockerignore]

### Commands
[build, run, stop, logs commands]

### Key Decisions
- [2-3 sentence explanation]
```

### Template B: Multi-Service Compose Setup

```markdown
## Docker Compose Setup

**Services:** [list: app, db, cache, etc.]
**Networks:** [custom network names]
**Volumes:** [named volumes]

### docker-compose.yml
[full compose file]

### docker-compose.override.yml (Development)
[dev overrides: hot reload, debug ports, dev-only services]

### Service Architecture
[brief diagram or table showing service relationships]

### Commands
[up, down, logs, rebuild, scale commands]
```

### Template C: Optimization Report (Existing Dockerfile)

```markdown
## Dockerfile Optimization Report

### Current State
- Image size: XXX MB
- Layers: X
- Build time: ~Xs
- Security: [root/non-root, base image]

### Issues Found
1. [Issue]: [Explanation]
2. [Issue]: [Explanation]

### Optimized Dockerfile
[optimized Dockerfile]

### After Optimization
- Image size: XXX MB (XX% reduction)
- Build time: ~Xs (XX% faster with cache mounts)
- Security: non-root, distroless base
```

### Template D: Troubleshooting Diagnosis

```markdown
## Docker Issue Diagnosis

### Problem
[User's described problem]

### Root Cause
[Detailed explanation]

### Evidence
[Dockerfile/compose snippet showing the issue]

### Fix
[Corrected configuration]

### Verification
[Commands to verify the fix]
```