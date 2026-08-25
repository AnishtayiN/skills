---
name: database-design
description: >-
  Design database schemas, models, relationships, migrations, and queries.
  TRIGGERS: database design, schema, model, table, column, relation, foreign key, index,
  migration, sql, nosql, er diagram, normalization, denormalization,
  طراحی دیتابیس, اسکیما, مدل, جدول, رابطه, ایندکس, مایگریشن,
  数据库设计, 模式, 迁移, 关系型数据库, 索引, 数据建模
priority: P2
dependencies: [system-design]
conflicts: []
---

# Database Design Skill

## Purpose

Design efficient, normalized, well-structured database schemas with production-grade patterns including multi-tenancy, event sourcing, JSONB modeling, and advanced indexing strategies.

## When to Activate

- Designing new database schemas or redesigning existing ones
- Creating forward and rollback migrations
- Optimizing queries and indexing strategies
- Choosing between SQL/NoSQL for a given workload
- Implementing multi-tenancy, soft delete, or event sourcing patterns
- Designing partition strategies for large tables
- Planning materialized view refresh strategies
- Architecting JSONB document storage in relational databases

## Workflow

### Step 1: Understand Data

```
1. What entities exist?
2. What are the relationships? (1:1, 1:N, M:N, self-referencing)
3. What are the access patterns? (read-heavy, write-heavy, mixed)
4. What are the volume/scale requirements?
5. What is the tenancy model? (shared DB, schema-per-tenant, DB-per-tenant)
6. Are there regulatory/compliance requirements for data isolation?
7. What is the expected data lifecycle? (hot/warm/cold, archival, soft delete)
```

### Step 2: Design Schema

```
1. Define tables/collections
2. Define columns/fields with explicit types
3. Define relationships with proper foreign keys
4. Define indexes for common queries (including partial and covering indexes)
5. Consider normalization vs denormalization trade-offs
6. Add created_at, updated_at, deleted_at columns where appropriate
7. Design JSONB columns for semi-structured attributes
8. Plan table partitioning for time-series or large tables
9. Define materialized views for complex aggregation queries
```

### Step 3: Create Migration

```sql
-- Example: multi-table migration with proper constraints
BEGIN;

CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    metadata JSONB DEFAULT '{}',
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(tenant_id, email)
);

CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_tenant ON users(tenant_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);

CREATE TABLE event_store (
    id BIGSERIAL PRIMARY KEY,
    aggregate_id UUID NOT NULL,
    aggregate_type VARCHAR(100) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    metadata JSONB DEFAULT '{}',
    version INTEGER NOT NULL,
    occurred_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_event_store_aggregate ON event_store(aggregate_id, version);

COMMIT;
```

### Step 4: Verify

```
1. Does the schema support all queries?
2. Are indexes appropriate and not over-indexed?
3. Is there proper constraint enforcement?
4. Are migrations reversible and zero-downtime safe?
5. Have you run EXPLAIN ANALYZE on critical queries?
6. Are materialized views scheduled for refresh?
7. Is the partitioning strategy aligned with query patterns?
```

## Advanced Techniques

### 1. Multi-Tenancy Patterns

```sql
-- Pattern A: Shared database, shared schema with tenant_id discriminator
-- Best for SaaS with many small tenants
CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_name VARCHAR(255),
    amount DECIMAL(10,2),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (tenant_id, id)  -- tenant_id as leading key
);

-- Row Level Security for automatic tenant isolation
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

-- Pattern B: Schema-per-tenant for moderate isolation
-- Each tenant gets its own schema, shared database
-- Good balance between cost and isolation

-- Pattern C: Database-per-tenant for high isolation
-- Maximum isolation, higher cost, for regulated industries
```

### 2. Event Sourcing

```sql
-- Event store as source of truth
CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    stream_id UUID NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    version INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(stream_id, version)
);

-- Snapshot table for performance optimization
CREATE TABLE snapshots (
    stream_id UUID PRIMARY KEY,
    state JSONB NOT NULL,
    version INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Projection: rebuild read model from events
-- SELECT * FROM events WHERE stream_id = $1 ORDER BY version;
-- Materialized view for aggregated read models
CREATE MATERIALIZED VIEW order_summaries AS
SELECT
    (payload->>'tenant_id')::UUID AS tenant_id,
    (payload->>'customer_id')::UUID AS customer_id,
    COUNT(*) AS order_count,
    SUM((payload->>'amount')::DECIMAL) AS total_amount
FROM events
WHERE event_type = 'OrderCreated'
GROUP BY tenant_id, customer_id;
```

### 3. JSONB Document Patterns

```sql
-- Schemaless attributes with GIN indexing
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    attributes JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- GIN index for containment queries
CREATE INDEX idx_products_attrs ON products USING GIN(attributes);

-- JSONB path queries
SELECT * FROM products
WHERE attributes @> '{"color": "red", "size": "L"}';

SELECT * FROM products
WHERE attributes->>'brand' = 'Nike';

-- JSONB aggregation
SELECT
    jsonb_object_keys(attributes) AS attr_key,
    COUNT(*) AS frequency
FROM products
GROUP BY attr_key
ORDER BY frequency DESC;

-- Partial index on JSONB with conditional
CREATE INDEX idx_products_color ON products((attributes->>'color'))
WHERE attributes ? 'color';
```

### 4. Partial Indexes

```sql
-- Index only active rows (soft delete pattern)
CREATE INDEX idx_active_users ON users(email) WHERE deleted_at IS NULL;

-- Index only unprocessed items (queue pattern)
CREATE INDEX idx_pending_jobs ON jobs(created_at)
WHERE status = 'pending';

-- Index for unique constraint excluding deleted rows
CREATE UNIQUE INDEX idx_unique_active_email
ON users(email) WHERE deleted_at IS NULL;

-- Covering index for common query
CREATE INDEX idx_covering_user_list ON users(tenant_id, email)
INCLUDE (name, created_at)
WHERE deleted_at IS NULL;
```

### 5. Soft Delete and Temporal Patterns

```sql
-- Soft delete with deleted_at timestamp
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMPTZ;

-- Partial unique index to allow re-registration after soft delete
CREATE UNIQUE INDEX idx_unique_active_email
ON users(email) WHERE deleted_at IS NULL;

-- Temporal tables for audit trail
CREATE TABLE users_history (
    id UUID NOT NULL,
    tenant_id UUID NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_to TIMESTAMPTZ NOT NULL
);

-- Trigger to archive on UPDATE/DELETE
CREATE OR REPLACE FUNCTION archive_user_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO users_history (id, tenant_id, email, name, valid_from, valid_to)
    VALUES (OLD.id, OLD.tenant_id, OLD.email, OLD.name, OLD.created_at, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_history
AFTER UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION archive_user_changes();
```

### 6. Materialized Views

```sql
-- Pre-computed dashboard aggregation
CREATE MATERIALIZED VIEW mv_dashboard_metrics AS
SELECT
    tenant_id,
    DATE_TRUNC('day', created_at) AS day,
    COUNT(*) AS total_orders,
    SUM(amount) AS revenue,
    AVG(amount) AS avg_order_value
FROM orders
WHERE created_at >= NOW() - INTERVAL '90 days'
GROUP BY tenant_id, DATE_TRUNC('day', created_at)
WITH DATA;

-- Unique index for concurrent refresh
CREATE UNIQUE INDEX idx_mv_dashboard
ON mv_dashboard_metrics(tenant_id, day);

-- Refresh strategy: concurrent refresh avoids locking
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_dashboard_metrics;

-- Schedule refresh with pg_cron
-- SELECT cron.schedule('refresh-dashboard', '*/5 * * * *',
--   'REFRESH MATERIALIZED VIEW CONCURRENTLY mv_dashboard_metrics');
```

### 7. Table Partitioning

```sql
-- Range partitioning by time for time-series data
CREATE TABLE events_partitioned (
    id BIGSERIAL,
    tenant_id UUID NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE events_2024_01 PARTITION OF events_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE events_2024_02 PARTITION OF events_partitioned
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Default partition for out-of-range data
CREATE TABLE events_default PARTITION OF events_partitioned DEFAULT;

-- Automatic partition creation (use pg_partman)
-- SELECT partman.create_parent('public.events_partitioned', 'created_at', 'native', 'monthly');

-- Partition pruning for query performance
EXPLAIN ANALYZE
SELECT * FROM events_partitioned
WHERE created_at >= '2024-01-15' AND created_at < '2024-02-01'
  AND tenant_id = '...';

-- Detach old partitions for archival
ALTER TABLE events_partitioned DETACH PARTITION events_2023_01;
```

## Common Patterns

### Pattern 1: Migration with Rollback

```sql
-- Forward migration
-- V001__create_users_table.sql
BEGIN;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
COMMIT;

-- Rollback migration
-- V001_rollback__drop_users_table.sql
BEGIN;
DROP INDEX IF EXISTS idx_users_email;
DROP TABLE IF EXISTS users;
COMMIT;
```

### Pattern 2: Zero-Downtime Migration

```sql
-- Step 1: Add new column as nullable
ALTER TABLE users ADD COLUMN display_name VARCHAR(100);

-- Step 2: Backfill data
UPDATE users SET display_name = name WHERE display_name IS NULL;

-- Step 3: Add NOT NULL constraint after backfill
ALTER TABLE users ALTER COLUMN display_name SET NOT NULL;

-- Step 4: Drop old column in next migration (after code deploy)
-- ALTER TABLE users DROP COLUMN name;
```

### Pattern 3: JSONB Search with Index

```sql
-- Store flexible product attributes
INSERT INTO products (name, attributes) VALUES
('Running Shoe', '{"brand": "Nike", "sizes": [8,9,10,11], "colors": ["red","blue"]}');

-- Search with GIN index
SELECT name FROM products
WHERE attributes @> '{"brand": "Nike"}';

-- Full-text search combined with JSONB
SELECT name FROM products
WHERE attributes->>'brand' ILIKE '%nik%'
  AND (attributes->>'price')::NUMERIC < 100;
```

### Pattern 4: Soft Delete with Unique Constraints

```sql
-- Unique email but allow soft-deleted users with same email
CREATE UNIQUE INDEX idx_unique_active_email
ON users(email) WHERE deleted_at IS NULL;

-- Soft delete
UPDATE users SET deleted_at = NOW() WHERE id = $1;

-- Re-register after soft delete (works because old row is excluded)
INSERT INTO users (email, name) VALUES ('jane@example.com', 'Jane');
-- This succeeds because the old row has deleted_at IS NOT NULL
```

### Pattern 5: Event Sourcing Aggregates

```sql
-- Emit events for state changes
INSERT INTO events (stream_id, event_type, payload, version)
VALUES ($1, 'OrderCreated', $2, 1);

INSERT INTO events (stream_id, event_type, payload, version)
VALUES ($1, 'ItemAdded', $3, 2);

INSERT INTO events (stream_id, event_type, payload, version)
VALUES ($1, 'OrderConfirmed', $4, 3);

-- Rebuild state from events
SELECT event_type, payload
FROM events
WHERE stream_id = $1
ORDER BY version ASC;
```

## Edge Cases & Pitfalls

1. **Over-normalization causing N+1 queries** — Too many joins degrade performance; denormalize strategically for read-heavy paths.
2. **Missing partial indexes on soft-deleted data** — Queries filtering `WHERE deleted_at IS NULL` need partial indexes or they scan all rows including deleted ones.
3. **JSONB type casting errors** — `payload->>'amount'` returns text; casting to DECIMAL without error handling causes runtime failures on malformed data.
4. **Migration without backward compatibility** — Dropping a column before deploying code that no longer references it causes immediate outages.
5. **Materialized view staleness** — Forgetting to refresh materialized views leads to dashboards showing outdated data; automate refresh schedules.
6. **Partition pruning not working** — Queries that use functions on the partition key (e.g., `DATE_TRUNC`) prevent partition pruning; use raw column comparisons.
7. **Cascade delete side effects** — `ON DELETE CASCADE` can silently remove millions of rows; always consider the full dependency tree.
8. **UUID v4 for primary keys and fragmentation** — Random UUIDs cause B-tree index page splits; consider UUIDv7 or ULID for ordered UUIDs.
9. **Transaction isolation level surprises** — Default READ COMMITTED may miss concurrent writes; use SERIALIZABLE for financial calculations.
10. **Unique constraints on nullable columns** — In PostgreSQL, multiple NULL values are allowed in unique columns; this is correct but unintuitive.
11. **Column type changes without data migration** — Changing VARCHAR(100) to VARCHAR(50) silently truncates data; always add a check constraint first.
12. **Event sourcing without idempotency keys** — Duplicate events can corrupt aggregate state; always include an idempotency key in event payloads.
13. **Table bloat from frequent updates without VACUUM** — PostgreSQL MVCC leaves dead tuples; configure autovacuum aggressively for high-update tables.
14. **Foreign key constraints on partitioned tables** — Some databases restrict FK constraints on partitioned tables; verify platform support.
15. **Multi-tenant data leakage** — Forgetting tenant_id in WHERE clauses or RLS policies exposes cross-tenant data; always test with multi-tenant data.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| system-design | System requirements, data model | ← | Database design derives from system architecture |
| code-generation | ORM models, repositories | → | Schema drives code generation |
| performance | Query optimization, indexing | ↔ | Database design affects performance; profiling drives schema changes |
| api-design | Endpoint data contracts | ↔ | API responses must align with schema |
| testing | Database test fixtures, factories | → | Schema enables test data generation |
| security | Encryption at rest, RLS policies | ↔ | Security requirements shape schema design |
| dockerization | Database containers | → | Dev database containers for local development |
| ci-cd | Migration automation in pipelines | → | Migrations run as part of CI/CD |
| deployment | Production database provisioning | → | Schema migrations in deployment pipeline |
| monitoring | Query performance metrics | ↔ | Metrics identify schema optimization needs |

## Output Format Templates

### Template 1: Schema Design Document

```markdown
# Database Schema: [Table Name]

## Overview
- **Purpose**: [Why this table exists]
- **Tenancy**: [Shared/Isolated]
- **Partitioning**: [None/Range/Hash/List]
- **Soft Delete**: [Yes/No]

## Columns
| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | UUID | NO | gen_random_uuid() | Primary key |
| ... | ... | ... | ... | ... |

## Indexes
| Index | Columns | Type | Condition | Rationale |
|-------|---------|------|-----------|-----------|
| idx_... | col1 | btree | WHERE active | Query pattern X |

## Constraints
| Constraint | Type | Columns | Notes |
|------------|------|---------|-------|
| ... | UNIQUE | (tenant_id, email) | Excludes soft-deleted |

## Migrations
- Forward: [migration ID]
- Rollback: [migration ID]
- Zero-downtime: [Yes/No, steps]
```

### Template 2: Migration File

```markdown
# Migration: [Description]

## Forward (V{N}__)
- [ ] Table creation/modification
- [ ] Index creation
- [ ] Data backfill
- [ ] Constraint addition

## Rollback (V{N}_rollback__)
- [ ] Reverse operations in correct order
- [ ] Verify no data loss

## Risk Assessment
- **Downtime**: [None / seconds / minutes]
- **Data loss**: [None / requires backup]
- **Rollback safety**: [Safe / requires caution]
- **Backward compatible**: [Yes / No]
```

### Template 3: Query Optimization Report

```markdown
## Query Analysis: [Query Description]

### Before Optimization
```sql
-- Original query
SELECT ...
```
- **Execution plan**: [Seq Scan / Index Scan]
- **Duration**: [Xms]
- **Rows examined**: [N]

### Proposed Optimization
```sql
-- Optimized query
SELECT ...
```
- **New index**: CREATE INDEX ...
- **Expected duration**: [Xms]
- **Trade-offs**: [Storage / write overhead]

### Verification
- [ ] EXPLAIN ANALYZE confirms improvement
- [ ] All tests pass
- [ ] Edge cases tested (empty table, NULL values, large datasets)
```

### Template 4: Data Model Review Checklist

```markdown
## Data Model Review

### Normalization
- [ ] Third Normal Form (3NF) achieved or justified denormalization
- [ ] No transitive dependencies on non-key columns
- [ ] Many-to-many relationships resolved with junction tables

### Constraints
- [ ] All primary keys defined
- [ ] Foreign keys with appropriate ON DELETE/UPDATE actions
- [ ] CHECK constraints for domain validation
- [ ] UNIQUE constraints with correct NULL handling

### Performance
- [ ] Indexes for all WHERE clause columns
- [ ] Indexes for JOIN columns
- [ ] Covering indexes for hot queries
- [ ] Partial indexes for filtered queries
- [ ] No redundant indexes

### Migration Safety
- [ ] Migrations are backward compatible
- [ ] Rollback plan documented
- [ ] Zero-downtime where required
- [ ] Data backfill scripts tested

### Security
- [ ] Row Level Security configured (multi-tenant)
- [ ] Sensitive columns identified for encryption
- [ ] No plaintext secrets in schema
```

## Rules

1. **Always use UUID or SERIAL for primary keys** — Never use natural keys as primary keys; they change over time and cause cascading updates.
2. **Always add created_at and updated_at timestamps** — Every table must have audit timestamps for debugging and temporal queries.
3. **Never use SELECT * in production queries** — Always specify columns to avoid performance issues and breakage from schema changes.
4. **Always make migrations reversible** — Every forward migration must have a corresponding rollback migration.
5. **Use partial indexes for filtered queries** — If a query always filters on a condition (e.g., `WHERE deleted_at IS NULL`), use a partial index.
6. **Enable Row Level Security for multi-tenant databases** — Never rely on application-level tenant filtering alone; RLS provides defense in depth.
7. **Never drop columns or tables without a deprecation period** — Mark as deprecated first, remove in a later migration after code is updated.
8. **Use JSONB over JSON for queryable semi-structured data** — JSONB supports GIN indexing and containment operators; JSON does not.
9. **Test migrations against production-like data volumes** — A migration that takes 1s on 100 rows may take hours on 100M rows.
10. **Configure VACUUM and analyze for high-update tables** — PostgreSQL MVCC requires aggressive autovacuum tuning for tables with frequent updates.
11. **Use EXPLAIN ANALYZE before and after every index change** — Never assume an index improves performance without measuring.
12. **Prefer composite indexes over multiple single-column indexes** — A composite index `(tenant_id, created_at)` serves queries on both columns; two separate indexes do not.
13. **Document the tenancy model in every schema design** — Explicitly state whether a table is shared, schema-isolated, or database-isolated per tenant.
