---
name: database-design
description: >-
  Design database schemas, models, relationships, migrations, and queries.
  TRIGGERS: database design, schema, model, table, column, relation, foreign key, index,
  migration, sql, nosql, er diagram, normalization, denormalization,
  طراحی دیتابیس, اسکیما, مدل, جدول, رابطه, ایندکس, مایگریشن
priority: P2
dependencies: [system-design]
conflicts: []
---

# Database Design Skill

## Purpose

Design efficient, normalized, well-structured database schemas.

## When to Activate

- Designing new database schemas
- Creating migrations
- Optimizing queries
- Choosing between SQL/NoSQL

## Workflow

### Step 1: Understand Data

```
1. What entities exist?
2. What are the relationships?
3. What are the access patterns?
4. What are the volume/scale requirements?
```

### Step 2: Design Schema

```
1. Define tables/collections
2. Define columns/fields with types
3. Define relationships (1:1, 1:N, M:N)
4. Define indexes for common queries
5. Consider normalization vs denormalization
```

### Step 3: Create Migration

```sql
-- Example migration
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

### Step 4: Verify

```
1. Does the schema support all queries?
2. Are indexes appropriate?
3. Is there proper constraint enforcement?
4. Are migrations reversible?
```

## Decision Tree

```
SQL or NoSQL?
├── Structured data, relationships → SQL
├── Document store, flexible schema → NoSQL
├── Key-value, caching → Redis
└── Full-text search → Elasticsearch
```

## Anti-Patterns

- ❌ No indexes on query columns
- ❌ Over-normalization (too many joins)
- ❌ Under-normalization (data duplication)
- ❌ No constraints (allow invalid data)
- ❌ Not considering migration rollback

## Skill Interactions

- ← system-design: System requirements
- → code-generation: Generate models/ORM
- → performance: Query optimization
