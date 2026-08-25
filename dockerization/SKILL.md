---
name: dockerization
description: >-
  Create, optimize, and debug Dockerfiles and docker-compose configurations for any application.
  Trigger this skill when the user wants to dockerize an app, write a Dockerfile, create a docker-compose setup,
  containerize a project, build images, or configure multi-container environments.
  Also activate for: داکرایز کردن, داکر, کانتینرسازی, Dockerfile, docker-compose, containerize this app,
  create container, Docker setup, multi-stage build, optimize Docker image, Docker networking,
  Docker volumes, container orchestration, dockerize, containerize, build image, push to registry.
---

# Dockerization Skill — Complete Docker Mastery

## Overview

This skill handles creating production-grade Docker configurations for any application. It covers single-service Dockerfiles, multi-service docker-compose setups, image optimization, multi-stage builds, Docker networking patterns, security hardening, multi-architecture builds, BuildKit patterns, container monitoring, and troubleshooting. The goal is always a small, secure, fast-building image that actually works in production.

## When to Use This Skill

- User wants to containerize an application
- User asks for a Dockerfile or docker-compose.yml
- User mentions Docker, containers, or image builds
- User needs to fix a broken Docker build or runtime
- User wants multi-stage builds, volume mounts, or network configuration
- User asks about Docker best practices or image optimization
- User needs Docker security hardening or multi-architecture builds
- User needs container monitoring or production deployment patterns

---

## Part 1: Project Analysis

### Step 1: Analyze the Project

Before writing any Docker configuration:

1. **Read the project structure** — Identify language, framework, build system, and entry point. Look for `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, `Gemfile`, `build.gradle`, etc.
2. **Identify dependencies** — Database, cache, message queue, external services?
3. **Determine build vs. runtime needs** — What's needed at build time (compilers, bundlers) vs. runtime (interpreters, libraries)?
4. **Check for existing Docker files** — Read any existing Dockerfile or docker-compose.yml.
5. **Check deployment target** — Local dev? Kubernetes? Cloud Run? This affects the configuration.

---

## Part 2: Dockerfile Mastery

### Step 2: Write the Dockerfile

Follow these principles in order:

#### Principle 1: Choose the Right Base Image

```dockerfile
# ❌ Bad: Full base image (1GB+)
FROM node:20

# ✅ Good: Alpine (50-150MB)
FROM node:20-alpine

# ✅ Better: Distroless (minimal attack surface)
FROM gcr.io/distroless/nodejs20-debian12

# ✅ Best for Go: Scratch (5-10MB)
FROM scratch
```

**Base Image Decision Matrix:**

| Language | Development Base | Production Base | Size |
|----------|-----------------|-----------------|------|
| Node.js | `node:20` | `node:20-alpine` | 50MB |
| Python | `python:3.12` | `python:3.12-slim` | 25MB |
| Go | `golang:1.22` | `scratch` or `alpine` | 5MB |
| Rust | `rust:1.75` | `debian:bookworm-slim` | 20MB |
| Java | `eclipse-temurin:21` | `eclipse-temurin:21-jre-alpine` | 80MB |

#### Principle 2: Multi-Stage Builds

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
USER node
CMD ["node", "dist/server.js"]
```

#### Principle 3: Layer Caching Optimization

```dockerfile
# Order from least to most frequently changing
FROM node:20-alpine

# 1. System dependencies (rarely change)
RUN apk add --no-cache dumb-init

# 2. Language dependencies (occasionally change)
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# 3. Application code (frequently changes)
COPY . .

# 4. Build step (only if needed)
RUN npm run build

USER node
CMD ["dumb-init", "node", "dist/server.js"]
```

#### Principle 4: Security Hardening

```dockerfile
# Complete security-hardened Dockerfile
FROM node:20-alpine AS builder

# Install security updates
RUN apk update && apk upgrade && apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Copy only what's needed
COPY package*.json ./
RUN npm ci --only=production

# Copy source and build
COPY . .
RUN npm run build

# Final stage
FROM node:20-alpine AS runner

# Security: Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Security: Run as non-root
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Security: Copy only production artifacts
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules

# Security: Drop all capabilities
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

EXPOSE 3000

# Security: Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/server.js"]
```

#### Principle 5: Read-Only Filesystem Pattern

```dockerfile
# For maximum security, use read-only filesystem
FROM node:20-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app
COPY --from=builder /app/dist ./dist

# Create writable directories for temp files
RUN mkdir -p /tmp/app-cache && chown appuser:appgroup /tmp/app-cache

USER appuser

# In docker-compose, add:
# read_only: true
# tmpfs:
#   - /tmp
#   - /var/run
```

#### Principle 6: .dockerignore

```dockerignore
# Version control
.git
.gitignore

# Dependencies (will be installed in container)
node_modules
vendor
target
__pycache__

# Build artifacts
dist
build
*.egg-info

# Environment files (use secrets management instead)
.env
.env.*
!.env.example

# IDE files
.vscode
.idea
*.swp

# OS files
.DS_Store
Thumbs.db

# Docker files
Dockerfile
docker-compose*.yml
.dockerignore

# Documentation
*.md
LICENSE

# Test files (don't ship tests in production)
tests
__tests__
*.test.*
*.spec.*
```

---

## Part 3: Docker Compose Patterns

### Step 3: Write docker-compose.yml

#### Basic Multi-Service Setup

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner          # Multi-stage target
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M

  db:
    image: postgres:16-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:

networks:
  default:
    name: app-network
```

#### Development Override

```yaml
# docker-compose.override.yml (auto-loaded)
services:
  app:
    build:
      target: builder         # Use build stage
    volumes:
      - .:/app               # Live reload
      - /app/node_modules    # Don't mount node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=app:*
    command: npm run dev
    ports:
      - "3000:3000"
      - "9229:9229"          # Node.js debugger

  db:
    ports:
      - "5432:5432"          # Expose for local tools
```

#### Production Compose

```yaml
# docker-compose.prod.yml
services:
  app:
    image: myregistry/myapp:${TAG:-latest}
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
        order: start-first
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    environment:
      - NODE_ENV=production
    secrets:
      - db_password
      - api_key
    networks:
      - frontend
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - app
    networks:
      - frontend

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    file: ./secrets/api_key.txt

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # No external access
```

---

## Part 4: Docker Networking Patterns

### Network Types

```yaml
services:
  app:
    networks:
      - frontend
      - backend

  db:
    networks:
      backend:
        aliases:
          - database
          - postgres

  cache:
    networks:
      backend:
        aliases:
          - redis

  nginx:
    networks:
      frontend:
        aliases:
          - web
    ports:
      - "443:443"

networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

  backend:
    driver: bridge
    internal: true  # Isolated from external network
```

### Custom Bridge Network (Recommended)

```bash
# Create custom network
docker network create --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.0.1 \
  my-network

# Run containers on custom network
docker run --network my-network --name app myapp
docker run --network my-network --name db postgres

# Containers can reach each other by name
docker exec app ping db    # Works!
```

### Overlay Network (Docker Swarm)

```bash
# Create overlay network for multi-host communication
docker network create --driver overlay \
  --attachable \
  --subnet 10.0.9.0/24 \
  my-overlay

# Use in docker-compose for swarm mode
# docker-compose.yml:
# networks:
#   my-overlay:
#     external: true
```

### Macvlan Network (Give Container Its Own IP)

```bash
# Container gets its own IP on the physical network
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 \
  my-macvlan

docker run --network my-macvlan --ip 192.168.1.100 myapp
```

### DNS and Service Discovery

```yaml
services:
  app:
    environment:
      # Service discovery via container names
      - DB_HOST=database
      - DB_PORT=5432
      - REDIS_HOST=cache
    networks:
      - backend

  database:
    # Accessible as "database" on the backend network
    networks:
      backend:
        aliases:
          - database
          - db
          - postgres
```

---

## Part 5: Docker Security Hardening

### Security Checklist

| Category | Check | How |
|----------|-------|-----|
| Base image | Use minimal images | Alpine, distroless, scratch |
| User | Run as non-root | USER directive |
| Filesystem | Read-only rootfs | `--read-only` flag or compose `read_only: true` |
| Capabilities | Drop all, add needed | `--cap-drop ALL --cap-add NET_BIND_SERVICE` |
| Seccomp | Use default or custom profile | `--security-opt seccomp=profile.json` |
| Secrets | Don't embed in image | Use Docker secrets or external secrets |
| Network | Restrict inter-container traffic | Internal networks, specific port exposure |
| Updates | Keep base images updated | Regular rebuilds with updated base |

### Capabilities Management

```bash
# Drop all capabilities and add only needed ones
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  --cap-add CHOWN \
  myapp

# In docker-compose
services:
  app:
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
      - CHOWN
      - SETGID
      - SETUID
```

### Seccomp Profiles

```json
// custom-seccomp.json - Restrict syscalls
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {
      "names": ["read", "write", "open", "close", "stat", "fstat",
                "mmap", "mprotect", "munmap", "brk", "ioctl",
                "access", "pipe", "select", "sched_yield",
                "clone", "fork", "execve", "exit", "wait4",
                "kill", "getpid", "socket", "connect", "accept",
                "sendto", "recvfrom", "bind", "listen", "getsockname",
                "getpeername", "socketpair", "setsockopt", "getsockopt",
                "clone", "uname", "fcntl", "flock", "fsync",
                "fdatasync", "truncate", "ftruncate", "getdents",
                "getcwd", "chdir", "mkdir", "rmdir", "creat",
                "unlink", "readlink", "chmod", "chown", "getuid",
                "getgid", "geteuid", "getegid", "getppid", "getpgrp",
                "setpgid", "umask", "gettimeofday", "getrlimit",
                "getrusage", "sysinfo", "times", "ptrace", "syslog",
                "getuid", "getgid", "setuid", "setgid", "geteuid",
                "getegid", "setreuid", "setregid", "getgroups",
                "setgroups", "setresuid", "getresuid", "setresgid",
                "getresgid", "getpgid", "setfsuid", "setfsgid",
                "getsid", "setsid", "getgroups", "setgroups",
                "setreuid", "setregid", "getgroups", "setgroups",
                "capget", "capset", "rt_sigaction", "rt_sigprocmask",
                "rt_sigreturn", "rt_sigpending", "rt_sigtimedwait",
                "rt_sigqueueinfo", "rt_sigsuspend", "rt_sigtimedwait",
                "rt_sigreturn", "rt_sigaction", "rt_sigprocmask",
                "nanosleep", "getitimer", "setitimer", "alarm",
                "setitimer", "getpid", "sendfile", "socket", "connect",
                "accept", "sendto", "recvfrom", "sendmsg", "recvmsg",
                "shutdown", "bind", "listen", "getsockname", "getpeername",
                "socketpair", "setsockopt", "getsockopt", "clone",
                "fork", "vfork", "execve", "exit", "exit_group",
                "wait4", "kill", "uname", "semget", "semop", "semctl",
                "shmdt", "msgget", "msgsnd", "msgrcv", "msgctl",
                "fcntl", "flock", "fsync", "fdatasync", "truncate",
                "ftruncate", "getdents", "getcwd", "chdir", "fchdir",
                "mkdir", "rmdir", "creat", "link", "unlink",
                "symlink", "readlink", "chmod", "fchmod", "chown",
                "fchown", "lchown", "umask", "gettimeofday", "getrlimit",
                "getrusage", "sysinfo", "times", "ptrace", "syslog",
                "getuid", "getgid", "setuid", "setgid", "geteuid",
                "getegid", "setreuid", "setregid", "getgroups",
                "setgroups", "setresuid", "getresuid", "setresgid",
                "getresgid", "getpgid", "setfsuid", "setfsgid",
                "getsid", "setsid", "capget", "capset", "rt_sigaction",
                "rt_sigprocmask", "rt_sigreturn", "rt_sigpending",
                "rt_sigtimedwait", "rt_sigqueueinfo", "rt_sigsuspend",
                "rt_sigtimedwait", "rt_sigreturn", "rt_sigaction",
                "rt_sigprocmask", "nanosleep", "getitimer", "setitimer",
                "alarm", "setitimer", "getpid", "sendfile", "socket",
                "connect", "accept", "sendto", "recvfrom", "sendmsg",
                "recvmsg", "shutdown", "bind", "listen", "getsockname",
                "getpeername", "socketpair", "setsockopt", "getsockopt",
                "clone", "fork", "vfork", "execve", "exit", "exit_group",
                "wait4", "kill", "uname"],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}

# Use custom seccomp profile
docker run --security-opt seccomp=custom-seccomp.json myapp
```

### Resource Limits

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 256M
    pids_limit: 100           # Prevent fork bombs
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
      nproc:
        soft: 4096
        hard: 4096
```

---

## Part 6: Multi-Architecture Builds

### Building for Multiple Platforms

```bash
# Create a buildx builder
docker buildx create --name multiarch --driver docker-container --use

# Build for multiple architectures
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t myregistry/myapp:latest \
  --push \
  .

# Build and load locally (single platform only)
docker buildx build \
  --platform linux/amd64 \
  -t myapp:latest \
  --load \
  .
```

### Dockerfile for Multi-Arch

```dockerfile
# Use TARGETPLATFORM and TARGETARCH ARGs
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

ARG TARGETPLATFORM
ARG TARGETARCH

# Install platform-specific dependencies if needed
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      apk add --no-cache python3 make g++; \
    fi

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Final stage (will be pulled for each target platform)
FROM node:20-alpine

WORKDIR /app
COPY --from=builder /app/dist ./dist
USER node
CMD ["node", "dist/server.js"]
```

### CI/CD Multi-Arch Build

```yaml
# .github/workflows/multi-arch-build.yml
name: Multi-Arch Build
on:
  push:
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: docker/setup-qemu-action@v3
        with:
          platforms: linux/amd64,linux/arm64

      - uses: docker/setup-buildx-action@v3

      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.ref_name }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

---

## Part 7: Docker BuildKit Patterns

### Enabling BuildKit

```bash
# Set as default
export DOCKER_BUILDKIT=1

# Or in daemon.json
# { "features": { "buildkit": true } }
```

### BuildKit Features

```dockerfile
# Syntax directive for BuildKit
# syntax=docker/dockerfile:1

# --- Cache mounts (speed up builds) ---
FROM node:20-alpine
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# --- Secret mounts (don't bake secrets into layers) ---
FROM node:20-alpine
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci

# --- SSH mounts (for private repos) ---
FROM node:20-alpine
RUN --mount=type=ssh \
    npm ci

# --- Bind mount (temp directory) ---
FROM node:20-alpine
RUN --mount=type=bind,source=./scripts,target=/scripts \
    /scripts/setup.sh

# --- Cache with type=local ---
FROM python:3.12-slim
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

### Advanced BuildKit Patterns

```dockerfile
# syntax=docker/dockerfile:1

# Pattern 1: Conditional copy
FROM node:20-alpine AS base
COPY package*.json ./
RUN npm ci

# Pattern 2: Build arguments
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Pattern 3: Multi-platform with build args
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder
ARG TARGETOS
ARG TARGETARCH
RUN npm run build -- --target ${TARGETARCH}

# Pattern 4: Export artifacts for CI
FROM scratch AS artifacts
COPY --from=builder /app/dist /dist
```

### BuildKit Cache Export

```bash
# Export cache to registry
docker buildx build \
  --cache-to type=registry,ref=myregistry/myapp:cache \
  --cache-from type=registry,ref=myregistry/myapp:cache \
  -t myapp:latest \
  .

# Export cache to local directory
docker buildx build \
  --cache-to type=local,dest=/tmp/docker-cache \
  --cache-from type=local,src=/tmp/docker-cache \
  -t myapp:latest \
  .
```

---

## Part 8: Container Monitoring Patterns

### Health Check Patterns

```dockerfile
# HTTP health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# TCP health check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD nc -z localhost 5432 || exit 1

# Custom script health check
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD /app/healthcheck.sh || exit 1
```

### Prometheus Metrics in Docker

```yaml
services:
  app:
    image: myapp:latest
    ports:
      - "3000:3000"
      - "9090:9090"  # Metrics port

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9091:9090"

  grafana:
    image: grafana/grafana:latest
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

### Log Aggregation

```yaml
services:
  app:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    # Or use fluentd for production
    logging:
      driver: fluentd
      options:
        fluentd-address: localhost:24224
        tag: docker.{{.Name}}

  # ELK stack for log aggregation
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    volumes:
      - es_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
```

---

## Part 9: Language-Specific Patterns

### Node.js

```dockerfile
# Production-optimized Node.js Dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
USER nextjs
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Python

```dockerfile
# Multi-stage Python with venv
FROM python:3.12-slim AS builder
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim AS runner
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY . /app
WORKDIR /app
USER appuser
EXPOSE 8000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
```

### Go

```dockerfile
# Multi-stage Go build
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/server

FROM scratch
COPY --from=builder /app/server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
```

### Rust

```dockerfile
# Multi-stage Rust with cargo-chef for dependency caching
FROM rust:1.75-slim AS chef
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json .
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim AS runner
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/server /usr/local/bin/server
EXPOSE 8080
CMD ["server"]
```

### Java

```dockerfile
# Multi-stage Java build
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:21-jre-alpine
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
COPY --from=builder /app/target/*.jar /app/app.jar
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```

---

## Part 10: Docker Compose Patterns

### Sidecar Pattern

```yaml
services:
  app:
    image: myapp:latest
    networks:
      - internal

  # Sidecar: log collector
  fluentd:
    image: fluentd:latest
    volumes:
      - ./fluentd.conf:/fluentd/etc/fluentd.conf
    networks:
      - internal

  # Sidecar: monitoring agent
  datadog-agent:
    image: datadog/agent:latest
    environment:
      - DD_API_KEY=${DD_API_KEY}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - internal

  # Sidecar: reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - internal
```

### Ambassador Pattern

```yaml
services:
  # Ambassador provides a local proxy to an external service
  redis-ambassador:
    image: svendowideit/ambassador
    environment:
      - REDIS_PORT_6379_TCP=tcp://redis-server:6379
    ports:
      - "6379:6379"
    networks:
      - app-network

  app:
    image: myapp:latest
    environment:
      - REDIS_HOST=redis-ambassador
      - REDIS_PORT=6379
    networks:
      - app-network

  # For a remote Redis service
  redis-remote-ambassador:
    image: svendowideit/ambassador
    environment:
      - REDIS_PORT_6379_TCP=tcp://remote-redis.example.com:6379
    ports:
      - "6379:6379"
```

---

## Part 11: Troubleshooting

### Common Issues

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Image too large (>1GB) | Full base image, no multi-stage | Switch to slim/alpine + multi-stage |
| Build is slow | No layer caching, dependencies reinstalled | Copy package files before source code |
| Container exits immediately | Entrypoint crashes, missing deps | Check logs with `docker logs <container>`, add shell for debugging |
| Permission denied | Running as root, volume mount permissions | Use non-root user, set correct file ownership |
| Networking between containers fails | Default bridge network | Use custom networks or compose networking |
| Volume data lost | Anonymous volume instead of named volume | Use named volumes in compose |
| Cannot connect to service | Service not ready | Add health checks and `depends_on` conditions |
| Out of disk space | Unused images and containers | `docker system prune -a` |
| DNS resolution fails | DNS configuration issue | Check `/etc/docker/daemon.json` for DNS settings |

### Debugging Commands

```bash
# Inspect container logs
docker logs -f <container>
docker logs --tail 100 <container>

# Execute commands in running container
docker exec -it <container> sh
docker exec -it <container> cat /etc/os-release

# Inspect container configuration
docker inspect <container>
docker inspect --format '{{.NetworkSettings.Networks}}' <container>

# Check container resource usage
docker stats
docker stats --no-stream

# Inspect network configuration
docker network inspect <network>

# Check image layers
docker history <image>
docker inspect <image>

# Clean up unused resources
docker system df                    # Show disk usage
docker system prune -a              # Remove all unused data
docker volume prune                 # Remove unused volumes
```

---

## Part 12: Production Checklist

- [ ] Multi-stage build for small image size
- [ ] Non-root user (USER directive)
- [ ] Health check defined
- [ ] .dockerignore configured
- [ ] Pinned base image versions (not `latest`)
- [ ] No secrets in Dockerfile or image layers
- [ ] Resource limits set (CPU, memory)
- [ ] Restart policy configured (`unless-stopped` for production)
- [ ] Logging configured (json-file driver with max-size)
- [ ] Read-only filesystem where possible
- [ ] Dropped capabilities (cap_drop ALL, add only needed)
- [ ] Network isolation between services
- [ ] Volume persistence for data
- [ ] Graceful shutdown handling (SIGTERM)
- [ ] Container monitoring and alerting
- [ ] Image scanning for vulnerabilities
- [ ] Backup strategy for persistent volumes
- [ ] CI/CD pipeline for automated builds

---

## Output Format

Provide all configuration files in code blocks with the correct filename as a header. Include:

1. **Dockerfile** — with comments explaining non-obvious choices
2. **docker-compose.yml** (if multi-service) — with service descriptions
3. **.dockerignore** — tailored to the project
4. **Build & run commands** — clear copy-pasteable commands
5. **Brief explanation** — 2-3 sentences on why key decisions were made

## Common Pitfalls to Avoid

- **Don't use `latest` tag.** Pin versions for reproducibility.
- **Don't install unnecessary packages.** Every package is an attack surface.
- **Don't run as root.** Always add a non-root USER.
- **Don't put secrets in the Dockerfile.** Use environment variables, secrets files, or Docker secrets.
- **Don't ignore .dockerignore.** Without it, you ship your .git history and node_modules into the image.
- **Don't use `ADD` when `COPY` suffices.** ADD has hidden behavior (auto-extract tar, URL fetch).
- **Don't skip health checks.** Without them, orchestrators can't detect unhealthy containers.
- **Don't use bind mounts in production.** Use named volumes for persistence.
- **Don't expose unnecessary ports.** Only publish ports that need external access.
- **Don't skip resource limits.** A runaway container can consume all host resources.
