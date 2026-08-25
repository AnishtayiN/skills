---
name: dockerization
description: >-
  Create and optimize Dockerfiles and docker-compose configurations.
  TRIGGERS: docker, dockerfile, container, compose, docker-compose, image, build image,
  containerize, docker run, multi-stage build, docker optimization,
  داکر, داکر فایل, کانتینر, کانتینرسازی, بهینه‌سازی داکر
priority: P3
dependencies: [project-analysis]
conflicts: []
---

# Dockerization Skill

## Purpose

Create production-ready Docker configurations.

## Workflow

### Step 1: Analyze Application

```
1. What language/framework?
2. What dependencies?
3. What build steps?
4. What runtime requirements?
```

### Step 2: Create Dockerfile

```dockerfile
# Multi-stage build example
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Step 3: Create docker-compose

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - db
  db:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data
```

## Anti-Patterns

- ❌ Using latest tag for base images
- ❌ Running as root
- ❌ Not using multi-stage builds
- ❌ Copying unnecessary files
- ❌ Not using .dockerignore

## Skill Interactions

- ← project-analysis: Understand app requirements
- → ci-cd: Docker in pipelines
- → deployment: Deploy containers
