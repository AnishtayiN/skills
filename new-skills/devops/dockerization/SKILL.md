---
name: dockerization
description: >-
  Create and optimize Dockerfiles and docker-compose configurations.
  TRIGGERS: docker, dockerfile, container, compose, docker-compose, image, build image,
  containerize, docker run, multi-stage build, docker optimization,
  داکر, داکر فایل, کانتینر, کانتینرسازی, بهینه‌سازی داکر,
  docker镜像, 容器化, 多阶段构建, docker优化, 容器安全
priority: P3
dependencies: [project-analysis]
conflicts: []
---

# Dockerization Skill

## Purpose

Create production-ready Docker configurations with optimized builds, security hardening, proper signal handling, health checks, multi-architecture support, and comprehensive docker-compose patterns.

## When to Activate

- Creating Dockerfiles for new or existing applications
- Optimizing Docker image size and build speed
- Setting up docker-compose for local development
- Configuring health checks and signal handling
- Building multi-architecture images (amd64, arm64)
- Hardening containers for production security
- Configuring GPU-enabled containers
- Setting up BuildKit cache mounts for faster builds

## Workflow

### Step 1: Analyze Application

```
1. What language/framework and runtime version?
2. What dependencies (system, language, build tools)?
3. What build steps (compile, bundle, transpile)?
4. What runtime requirements (environment variables, ports, volumes)?
5. What architecture targets (amd64, arm64)?
6. Does it need GPU access?
7. What health check endpoints exist?
```

### Step 2: Create Dockerfile

```dockerfile
# ── Modern multi-stage Dockerfile with BuildKit ──
# syntax=docker/dockerfile:1

# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --prefer-offline

# Stage 2: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN --mount=type=cache,target=/root/.cache \
    npm run build

# Stage 3: Production runner (distroless or minimal)
FROM node:20-alpine AS runner
WORKDIR /app

# Security: non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

USER appuser
EXPOSE 3000

# Tini for zombie process prevention
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]
```

### Step 3: Create docker-compose

```yaml
version: '3.9'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 512M
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    restart: unless-stopped

volumes:
  pgdata:
    driver: local
```

## Advanced Techniques

### 1. BuildKit Cache Mounts

```dockerfile
# syntax=docker/dockerfile:1

# Cache npm packages across builds
RUN --mount=type=cache,target=/root/.npm \
    npm ci --prefer-offline

# Cache pip packages
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# Cache Go modules
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download && go build -o /app ./cmd/server

# Cache Rust cargo
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/app/target \
    cargo build --release && cp /app/target/release/myapp /usr/local/bin/

# Cache APT packages
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Cache Yarn packages
RUN --mount=type=cache,target=/root/.cache/yarn \
    yarn install --frozen-lockfile
```

### 2. Distroless and Minimal Images

```dockerfile
# ── Distroless (Google's minimal images, no shell, no package manager) ──
FROM gcr.io/distroless/nodejs20-debian12 AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["dist/index.js"]

# ── Alpine-based with specific pinned versions ──
FROM node:20.11.1-alpine3.19 AS runner
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]

# ── Scratch image (Go static binaries) ──
FROM scratch
COPY --from=builder /app/server /server
COPY --from=builder /app/configs /configs
EXPOSE 8080
ENTRYPOINT ["/server"]

# ── Chainguard images (supply-chain secure) ──
FROM cgr.dev/chainguard/node:latest AS runner
```

### 3. Multi-Architecture Builds

```bash
# Create buildx builder for multi-arch
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap

# Build for multiple architectures
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    -t myregistry/myapp:latest \
    --push .

# In CI/CD (GitHub Actions)
# - uses: docker/setup-buildx-action@v3
# - uses: docker/setup-qemu-action@v3  # For cross-platform emulation
# - uses: docker/build-push-action@v5
#   with:
#     platforms: linux/amd64,linux/arm64

# Dockerfile for multi-arch
FROM --platform=$TARGETPLATFORM node:20-alpine
# $TARGETPLATFORM is set by buildx (linux/amd64, linux/arm64, etc.)
```

### 4. GPU Containers

```yaml
# docker-compose.yml for GPU workloads
services:
  ml-inference:
    image: nvcr.io/nvidia/pytorch:24.01-py3
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1          # or "all"
              capabilities: [gpu]
    volumes:
      - ./models:/models:ro
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
```

```dockerfile
# Dockerfile with CUDA support
FROM nvidia/cuda:12.3.1-base-ubuntu22.04
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu121
WORKDIR /app
COPY . .
CMD ["python3", "inference.py"]
```

### 5. Docker Compose Advanced Patterns

```yaml
# ── Development override file (docker-compose.override.yml) ──
version: '3.9'
services:
  app:
    build:
      target: builder        # Build to dev stage, not runner
    volumes:
      - .:/app               # Live reload
      - /app/node_modules    # Don't overwrite node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=app:*
    ports:
      - "3000:3000"
      - "9229:9229"          # Node.js debugger
    command: npm run dev

# ── Production override (docker-compose.prod.yml) ──
version: '3.9'
services:
  app:
    restart: always
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '2.0'
          memory: 512M

# Usage:
# docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# ── Profile-based services ──
services:
  app:
    image: myapp
    # Always starts

  debug-tools:
    image: busybox
    profiles: ["debug"]
    # Only starts with: docker compose --profile debug up

  mailhog:
    image: mailhog/mailhog
    profiles: ["dev"]
    # Only starts with: docker compose --profile dev up

# ── Shared network isolation ──
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true   # No external access

services:
  nginx:
    networks:
      - frontend
  app:
    networks:
      - frontend
      - backend
  db:
    networks:
      - backend       # Only accessible from app, not from host
```

### 6. Health Checks

```dockerfile
# HTTP health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# TCP health check (for databases)
HEALTHCHECK --interval=10s --timeout=3s --retries=5 \
    CMD pg_isready -U $POSTGRES_USER || exit 1

# Custom script health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD /app/healthcheck.sh || exit 1

# Redis health check
HEALTHCHECK --interval=10s --timeout=3s --retries=5 \
    CMD redis-cli ping | grep PONG || exit 1
```

```yaml
# docker-compose health check with dependency conditions
services:
  db:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
      start_period: 10s

  app:
    depends_on:
      db:
        condition: service_healthy   # Wait for healthy, not just started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
```

### 7. Security Hardening

```dockerfile
# ── Security-hardened Dockerfile ──

# 1. Use specific version tags, never :latest
FROM node:20.11.1-alpine3.19 AS builder

# 2. Don't run as root
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 3. Remove unnecessary packages
RUN apk --no-cache add dumb-init && \
    apk --no-cache del curl wget

# 4. Set read-only root filesystem compatible permissions
RUN mkdir -p /app && chown appuser:appgroup /app

WORKDIR /app

# 5. Copy with specific ownership
COPY --chown=appuser:appgroup --from=builder /app/dist ./dist
COPY --chown=appuser:appgroup --from=builder /app/node_modules ./node_modules

# 6. Drop all capabilities, add only what's needed
USER appuser

# 7. Read-only filesystem hint (enforced at runtime)
# docker run --read-only --tmpfs /tmp myapp

# 8. No new privileges
# docker run --security-opt=no-new-privileges myapp

# 9. Scan for vulnerabilities
# docker scout cves myapp:latest

# 10. Use .dockerignore to exclude sensitive files
# .dockerignore:
# .git
# .env
# node_modules
# *.key
# *.pem
# docker-compose*.yml
# Dockerfile*
```

### 8. Signal Handling and Zombie Process Prevention

```dockerfile
# ── Tini: lightweight init system for containers ──
# Tini forwards signals and reaps zombie processes

# Install tini
RUN apk add --no-cache tini

# Use as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

# Application as CMD (can be overridden)
CMD ["node", "dist/index.js"]

# ── Without Tini, PID 1 is your app ──
# Problem: Node.js doesn't handle SIGTERM by default
# Problem: Zombie processes accumulate if PID 1 doesn't reap

# ── Using dumb-init (alternative) ──
RUN apk add --no-cache dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "dist/index.js"]

# ── In docker-compose ──
# services:
#   app:
#     init: true    # Equivalent to using tini
```

```yaml
# Handle graceful shutdown in docker-compose
services:
  app:
    stop_grace_period: 30s  # Time to gracefully shut down
    # SIGTERM is sent first; SIGKILL after grace period
```

### 9. Dockerfile Optimizations

```dockerfile
# ── Layer caching optimization ──

# BAD: package.json changes invalidate all subsequent layers
COPY . .
RUN npm ci

# GOOD: Copy dependency files first, cache dependencies
COPY package.json package-lock.json ./
RUN npm ci --only=production
COPY . .

# ── Remove dev dependencies in production ──
RUN npm ci && npm run build && \
    rm -rf node_modules && \
    npm ci --only=production --ignore-scripts

# ── Combine RUN commands to reduce layers ──
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ── Use COPY instead of ADD (COPY is explicit) ──
COPY package.json ./
# ADD auto-extracts archives and supports URLs (avoid unless needed)

# ── Pin versions in FROM ──
FROM node:20.11.1-alpine3.19   # Not node:latest or node:20
```

## Common Patterns

### Pattern 1: Multi-Stage Build for Compiled Languages

```dockerfile
# Go application multi-stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server ./cmd/server

FROM alpine:3.19 AS runner
RUN apk add --no-cache ca-certificates tini
COPY --from=builder /app/server /server
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/server"]
```

### Pattern 2: Development Environment

```yaml
# docker-compose.dev.yml
version: '3.9'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: builder
    volumes:
      - .:/app
      - node_modules:/app/node_modules
    ports:
      - "3000:3000"
      - "9229:9229"
    environment:
      - NODE_ENV=development
      - DEBUG=*
    command: npm run dev
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: devpass
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev -d devdb"]
      interval: 5s

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s

volumes:
  node_modules:
  pgdata:
```

### Pattern 3: Production with Nginx Reverse Proxy

```yaml
version: '3.9'
services:
  nginx:
    image: nginx:1.25-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - app
    restart: always

  app:
    build: .
    expose:
      - "3000"   # Only internal network, not host
    environment:
      - NODE_ENV=production
    deploy:
      replicas: 3
    restart: always
```

### Pattern 4: Distroless with Health Check

```dockerfile
# Java application with distroless
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./
RUN ./gradlew dependencies --no-daemon
COPY src/ src/
RUN ./gradlew bootJar --no-daemon

FROM gcr.io/distroless/java21-debian12
COPY --from=builder /app/build/libs/*.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### Pattern 5: Build-Arg Based Configuration

```dockerfile
# Flexible Dockerfile with build arguments
ARG NODE_VERSION=20
ARG ALPINE_VERSION=3.19

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG APP_ENV=production
ENV NODE_ENV=${APP_ENV}

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS runner
ARG APP_ENV=production
ENV NODE_ENV=${APP_ENV}

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

CMD ["node", "dist/index.js"]
```

```bash
# Build with different configurations
docker build --build-arg APP_ENV=staging -t myapp:staging .
docker build --build-arg NODE_VERSION=22 -t myapp:node22 .
```

## Edge Cases & Pitfalls

1. **Using `:latest` tag for base images** — Builds are not reproducible; pin exact versions (e.g., `node:20.11.1-alpine3.19`).
2. **Running as root in production** — Containers running as root can escape and compromise the host; always add a non-root user.
3. **Ignoring `.dockerignore`** — Sending `.git`, `node_modules`, or secrets as build context slows builds and risks leaking credentials.
4. **Not using multi-stage builds** — Build tools, compilers, and dev dependencies inflate final image size; separate build from runtime.
5. **Missing `HEALTHCHECK` directive** — Orchestrators can't detect unhealthy containers without explicit health checks; applications appear running while broken.
6. **Zombie processes accumulating** — Without `tini` or `dumb-init` as PID 1, zombie processes are never reaped and consume resources.
7. **Not handling SIGTERM** — Without `tini`, Node.js (PID 1) never receives SIGTERM; containers are force-killed after grace period, causing data loss.
8. **COPY invalidating cache unnecessarily** — `COPY . .` invalidates all subsequent layers; copy dependency files first, then source code.
9. **Docker Compose `depends_on` without health checks** — `depends_on: [db]` only waits for the container to start, not for the database to be ready; use `condition: service_healthy`.
10. **Exposing ports that should be internal** — Only expose ports that need host access; internal services should use `expose` only.
11. **Hardcoded secrets in Dockerfile or compose** — Use Docker secrets, `.env` files (not committed), or external secret managers.
12. **Large image layers from multiple RUN commands** — Each `RUN` creates a layer; combine related commands and clean up caches in the same layer.
13. **Missing `--no-cache-dir` for pip/npm** — Package manager caches remain in the image, bloating size by hundreds of MB.
14. **Not using `.dockerignore` for build context** — A 2GB project directory sent as context makes every build slow; exclude unnecessary files.
15. **Docker Compose version mismatch** — `version: '3.8'` may not support all features; use `3.9` for the latest compose specification.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| project-analysis | Understand app requirements, dependencies | ← | Analysis determines base image and build strategy |
| ci-cd | Docker builds in CI/CD pipelines | ↔ | CI builds images; Dockerfile optimization speeds pipelines |
| deployment | Deploy containers to production | → | Container images are deployment artifacts |
| security | Container vulnerability scanning, hardening | ↔ | Security scanning; hardened Dockerfiles improve posture |
| performance | Container resource limits, monitoring | ↔ | Resource constraints affect performance; profiling informs limits |
| database-design | Database containers for dev/test | → | docker-compose provides local database services |
| monitoring | Container health, resource metrics | → | Health checks feed monitoring systems |
| api-design | Port exposure, network configuration | → | API endpoints define container networking |

## Output Format Templates

### Template 1: Dockerfile

```markdown
# Dockerfile: [Application Name]

## Build Strategy
- **Multi-stage**: [Yes/No] — [number] stages
- **Base image**: [image:tag]
- **Final image**: [image:tag]
- **Target architecture**: [amd64 / arm64 / multi-arch]

## Security
- [ ] Non-root user configured
- [ ] Specific version tags (no :latest)
- [ ] No secrets in build args or environment
- [ ] .dockerignore configured
- [ ] Vulnerability scan passes

## Performance
- [ ] BuildKit cache mounts configured
- [ ] Dependency layer cached before source
- [ ] Multi-stage build separates build from runtime
- [ ] Final image size < [target]

## Health
- [ ] HEALTHCHECK directive present
- [ ] Signal handling (tini/dumb-init)
- [ ] Graceful shutdown configured
```

### Template 2: Docker Compose

```markdown
# Docker Compose: [Project Name]

## Services
| Service | Image | Port | Volume | Health Check |
|---------|-------|------|--------|--------------|
| app | custom | 3000 | ./:/app | HTTP /health |
| db | postgres:16 | 5432 | pgdata | pg_isready |
| redis | redis:7 | 6379 | - | redis-cli ping |

## Networks
| Network | Driver | Internal |
|---------|--------|----------|
| frontend | bridge | No |
| backend | bridge | Yes |

## Volumes
| Volume | Driver | Purpose |
|--------|--------|---------|
| pgdata | local | PostgreSQL data |

## Usage
- Development: `docker compose -f docker-compose.yml -f docker-compose.dev.yml up`
- Production: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d`
```

### Template 3: Optimization Report

```markdown
## Docker Optimization Report

### Image Size
| Stage | Size | Reduction |
|-------|------|-----------|
| Before optimization | [X] MB | - |
| After multi-stage | [Y] MB | [Z]% |
| After distroless | [W] MB | [Z]% |
| Final | [V] MB | [Z]% total |

### Build Speed
| Metric | Before | After |
|--------|--------|-------|
| Full build | [X]s | [Y]s |
| Cached build | [X]s | [Y]s |
| Context size | [X] MB | [Y] MB |

### Cache Hit Rate
- Layer cache hits: [X]%
- BuildKit mount cache: [enabled/disabled]
```

### Template 4: Security Audit

```markdown
## Docker Security Audit

### Dockerfile
- [ ] Base image pinned to specific version
- [ ] Non-root USER directive present
- [ ] No secrets in ENV or ARG
- [ ] Minimal base image (alpine/distroless/scratch)
- [ ] No unnecessary packages installed
- [ ] Build tools removed in production stage

### Runtime
- [ ] Read-only root filesystem (--read-only)
- [ ] No new privileges (--security-opt=no-new-privileges)
- [ ] Capabilities dropped (--cap-drop=ALL)
- [ ] Resource limits set (--memory, --cpus)
- [ ] Init process configured (tini/dumb-init)

### Build
- [ ] .dockerignore excludes sensitive files
- [ ] No credentials in build context
- [ ] BuildKit secrets used for credentials
- [ ] Vulnerability scan passes (docker scout/trivy)
```

## Rules

1. **Always use specific version tags for base images** — Never use `:latest`; pin to exact versions for reproducible builds.
2. **Never run containers as root in production** — Add a non-root user with `USER` directive in every Dockerfile.
3. **Always use multi-stage builds** — Separate build and runtime stages to minimize final image size and attack surface.
4. **Always include a HEALTHCHECK** — Without health checks, orchestrators cannot detect application failures.
5. **Always use tini or dumb-init as PID 1** — Prevents zombie process accumulation and ensures proper signal forwarding.
6. **Always create a .dockerignore file** — Exclude `.git`, `.env`, `node_modules`, `Dockerfile`, and other non-essential files from build context.
7. **Always handle SIGTERM in application code** — Register signal handlers to gracefully shut down on container stop.
8. **Never hardcode secrets in Dockerfile or compose** — Use Docker secrets, environment variables from `.env` files, or external secret managers.
9. **Always combine related RUN commands** — Each `RUN` creates a layer; combine commands and clean caches in a single layer.
10. **Always use BuildKit cache mounts for package managers** — Speeds up repeated builds by caching npm, pip, go, and cargo packages.
11. **Always use `depends_on` with `condition: service_healthy`** — Waiting for container start is insufficient; verify the service is actually ready.
12. **Always set resource limits in production** — Without memory and CPU limits, a single container can consume all host resources.
