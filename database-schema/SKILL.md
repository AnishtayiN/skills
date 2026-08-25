---
name: database-schema
description: >-
  Database design, table creation, relationship modeling, and SQL schema generation. Use this skill when the user needs database design, طراحی دیتابیس, create table schema, ER diagram, database modeling, SQL schema, design my database, how should I structure my data, table design, database schema, create tables for, data model, entity relationship, normalize this schema, add indexes, what indexes should I add, foreign key design, many-to-many relationship, database migration, schema migration, ORM model design, Prisma schema, SQLAlchemy model, data modeling, database structure, how to model this domain in a database, partial indexes, expression indexes, covering indexes, query optimization, partitioning, replication, NoSQL design, MongoDB schema, DynamoDB design, database performance tuning, migration strategies, bulk migration, zero-downtime migration.
---

# Database Schema Skill — Data Modeling, Indexing & Performance

## Overview

This skill produces concrete, production-ready database schemas. It covers entity identification, relationship modeling, normalization, advanced indexing strategies (partial, expression, covering indexes), query optimization, partitioning, replication patterns, NoSQL schema design (MongoDB, DynamoDB), migration strategies, and performance tuning. The focus is on correctness, performance, and maintainability.

## When to Use This Skill

- User needs to design a database for a new project or feature
- User asks to create tables, model relationships, or design a schema
- User needs an ER diagram or visual representation of their data model
- User wants help with normalization, indexing, or query optimization
- User needs to convert a conceptual design into SQL or ORM code
- User asks about partial indexes, expression indexes, or covering indexes
- User asks about partitioning, replication, or database scaling
- User needs NoSQL schema design for MongoDB or DynamoDB
- User needs migration strategies or zero-downtime migrations
- User asks about database performance tuning

---

## Part 1: Schema Design Workflow

### Phase 1: Identify Entities

1. **Extract nouns from the problem description** — Each noun is a candidate entity (User, Order, Product, etc.)
2. **Distinguish entities from attributes** — "User email" is an attribute of User, not a separate entity
3. **Check for value objects** — Some nouns are better as fields (address, money amount) than tables
4. **Validate against requirements** — Does this entity map to a real concept in the domain?

### Phase 2: Define Attributes & Types

For each entity, define columns with:

- **Primary key** — Always include one. Use `BIGSERIAL`/`BIGINT AUTO_INCREMENT`/UUID depending on scale and distributed needs
- **Required fields** — Mark NOT NULL constraints
- **Data types** — Be specific: `VARCHAR(255)`, `DECIMAL(10,2)`, `TIMESTAMPTZ`, not just `string`
- **Default values** — Set sensible defaults (e.g., `NOW()` for created_at)
- **Constraints** — CHECK constraints for business rules, UNIQUE where needed

### Phase 3: Define Relationships

| Relationship | Pattern | Implementation |
|--------------|---------|----------------|
| **One-to-many** | Parent has many children | Foreign key on the "many" table |
| **Many-to-many** | Posts have many tags | Junction/join table with two foreign keys |
| **One-to-one** | User has one profile | Foreign key with UNIQUE constraint, or same table |
| **Self-referencing** | Category has subcategories | Foreign key referencing same table |
| **Polymorphic** | Comments on posts or videos | Separate table per type (preferred) or nullable FKs |
| **Hierarchical** | Org chart, comment threads | Adjacency list, nested sets, or materialized path |

### Phase 4: Normalize

Apply normalization up to 3NF:

1. **1NF** — No repeating groups, atomic values
2. **2NF** — No partial dependencies (all non-key fields depend on the full primary key)
3. **3NF** — No transitive dependencies (non-key fields depend only on the primary key)
4. **BCNF** — Every determinant is a candidate key (stronger than 3NF)

Also consider when to **denormalize** for read performance (e.g., cached counts, materialized views).

### Phase 5: Indexing Strategy

### Phase 6: Add Metadata & Audit

Every table should have:
- `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`
- `updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` (with trigger or app-level update)

Consider:
- `deleted_at` for soft deletes
- `created_by` for audit trails
- `version` for optimistic locking

---

## Part 2: Indexing Strategies in Depth

### Index Types

#### B-Tree Index (Default)
Most common. Good for equality and range queries.
```sql
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_orders_created ON orders (created_at);
```

#### Partial Index (Index subset of rows)
Only index rows matching a condition. Saves storage and improves write performance:
```sql
-- Only index active users (most queries filter by active=true)
CREATE INDEX idx_users_active ON users (email) WHERE is_active = true;

-- Only index unresolved tickets
CREATE INDEX idx_tickets_open ON tickets (assigned_to, created_at) 
  WHERE status = 'open';

-- Only index recent orders (last 90 days)
CREATE INDEX idx_orders_recent ON orders (customer_id, created_at) 
  WHERE created_at > NOW() - INTERVAL '90 days';
```

**When to use:** When a small percentage of rows match the condition and queries frequently filter by that condition.

#### Expression Index (Function-based index)
Index the result of an expression, not the raw column:
```sql
-- Case-insensitive email lookup
CREATE INDEX idx_users_lower_email ON users (LOWER(email));

-- Index JSON field
CREATE INDEX idx_events_event_type ON events ((payload->>'event_type'));

-- Index computed value
CREATE INDEX idx_orders_total ON orders ((quantity * unit_price));

-- Index date truncation (for daily aggregations)
CREATE INDEX idx_orders_day ON orders (DATE_TRUNC('day', created_at));
```

#### Covering Index (Include all needed columns)
Index contains all columns needed by a query, eliminating table lookups:
```sql
-- Query: SELECT id, name, email FROM users WHERE status = 'active'
CREATE INDEX idx_users_status_covering ON users (status) 
  INCLUDE (id, name, email);

-- Query: SELECT order_id, total FROM orders WHERE customer_id = ? ORDER BY created_at DESC
CREATE INDEX idx_orders_customer_covering ON orders (customer_id, created_at DESC) 
  INCLUDE (order_id, total);
```

**Performance impact:** Covering index queries can be 10-100x faster than non-covering because they avoid random I/O to the heap/table.

#### Composite Index (Multi-column)
Order of columns matters — put equality columns first, then range columns:
```sql
-- Query pattern: WHERE status = ? AND created_at > ? ORDER BY created_at
CREATE INDEX idx_orders_status_created ON orders (status, created_at);

-- Query: WHERE user_id = ? AND type = ? AND created_at > ?
CREATE INDEX idx_events_user_type_date ON events (user_id, type, created_at);
```

**Column order rules:**
1. Equality conditions first (WHERE col = value)
2. Range conditions next (WHERE col > value)
3. Sort columns next (ORDER BY col)
4. Include columns for covering index

#### GIN Index (Generalized Inverted Index)
For full-text search, arrays, and JSONB:
```sql
-- Full-text search
CREATE INDEX idx_posts_search ON posts USING GIN (to_tsvector('english', title || ' ' || body));

-- JSONB containment
CREATE INDEX idx_products_attrs ON products USING GIN (attributes);

-- Array contains
CREATE INDEX idx_articles_tags ON articles USING GIN (tags);
```

#### GiST Index (Generalized Search Tree)
For geometric data, ranges, and full-text:
```sql
-- Range overlap queries
CREATE INDEX idx_events_schedule ON events USING GIN (tsrange(start_time, end_time));

-- Full-text search (alternative to GIN, better for dynamic data)
CREATE INDEX idx_posts_fulltext ON posts USING GiST (to_tsvector('english', body));
```

### Index Maintenance

**Identify unused indexes:**
```sql
-- PostgreSQL: find indexes that are never used
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;
```

**Identify missing indexes:**
```sql
-- PostgreSQL: find sequential scans on large tables
SELECT relname, seq_scan, seq_tup_read, idx_scan
FROM pg_stat_user_tables
WHERE seq_scan > 100 AND seq_tup_read > 10000
ORDER BY seq_tup_read DESC;
```

**Index size monitoring:**
```sql
SELECT 
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
```

---

## Part 3: Query Optimization Patterns

### Use EXPLAIN ANALYZE
```sql
EXPLAIN ANALYZE
SELECT u.name, COUNT(o.id) as order_count
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.status = 'active'
GROUP BY u.id, u.name
ORDER BY order_count DESC
LIMIT 10;
```

**Look for:**
- Seq Scan on large tables → needs an index
- Nested Loop with high row estimates → consider hash join
- Sort operations on large datasets → add index to avoid sort

### Common Optimization Patterns

**1. Avoid SELECT \***
```sql
-- BAD
SELECT * FROM orders WHERE user_id = 123;

-- GOOD: Only select what you need
SELECT id, total, status FROM orders WHERE user_id = 123;
```

**2. Use EXISTS instead of COUNT for existence checks**
```sql
-- BAD (counts all matching rows)
SELECT COUNT(*) FROM orders WHERE user_id = 123 AND status = 'active';

-- GOOD (stops at first match)
SELECT EXISTS (SELECT 1 FROM orders WHERE user_id = 123 AND status = 'active');
```

**3. Use LATERAL JOIN for correlated subqueries**
```sql
-- Get each user's 3 most recent orders
SELECT u.id, u.name, recent.*
FROM users u
LEFT JOIN LATERAL (
  SELECT id, total, created_at
  FROM orders o
  WHERE o.user_id = u.id
  ORDER BY created_at DESC
  LIMIT 3
) recent ON true;
```

**4. Batch inserts instead of row-by-row**
```sql
-- BAD
INSERT INTO logs (message) VALUES ('msg1');
INSERT INTO logs (message) VALUES ('msg2');
INSERT INTO logs (message) VALUES ('msg3');

-- GOOD
INSERT INTO logs (message) VALUES ('msg1'), ('msg2'), ('msg3');
```

**5. Use CTEs for readability, but be aware of performance**
```sql
-- CTEs in PostgreSQL are optimization fences (materialized by default)
WITH active_users AS MATERIALIZED (
  SELECT id, name FROM users WHERE status = 'active'
)
SELECT * FROM active_users WHERE name LIKE 'A%';
```

---

## Part 4: Partitioning Strategies

### Range Partitioning
Divide data by a range of values (typically time):
```sql
CREATE TABLE events (
  id BIGSERIAL,
  event_type VARCHAR(50),
  payload JSONB,
  created_at TIMESTAMPTZ NOT NULL
) PARTITION BY RANGE (created_at);

-- Create partitions
CREATE TABLE events_2024_01 PARTITION OF events
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE events_2024_02 PARTITION OF events
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Queries that filter by created_at automatically use partition pruning
SELECT * FROM events WHERE created_at >= '2024-01-15' AND created_at < '2024-02-01';
```

### Hash Partitioning
Distribute data evenly across partitions:
```sql
CREATE TABLE user_sessions (
  id BIGSERIAL,
  user_id BIGINT NOT NULL,
  session_data JSONB
) PARTITION BY HASH (user_id);

CREATE TABLE user_sessions_p0 PARTITION OF user_sessions
  FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE user_sessions_p1 PARTITION OF user_sessions
  FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE user_sessions_p2 PARTITION OF user_sessions
  FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE user_sessions_p3 PARTITION OF user_sessions
  FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

### List Partitioning
Divide by discrete values:
```sql
CREATE TABLE orders (
  id BIGSERIAL,
  region VARCHAR(20) NOT NULL,
  total DECIMAL(10,2)
) PARTITION BY LIST (region);

CREATE TABLE orders_na PARTITION OF orders FOR VALUES IN ('US', 'CA', 'MX');
CREATE TABLE orders_eu PARTITION OF orders FOR VALUES IN ('GB', 'DE', 'FR', 'ES');
CREATE TABLE orders_apac PARTITION OF orders FOR VALUES IN ('JP', 'AU', 'SG');
```

### When to Partition
- Tables larger than 100GB
- Time-series data with natural partition boundaries
- Multi-tenant systems where tenant isolation matters
- When you need fast data archival (drop entire partitions)

---

## Part 5: Replication Patterns

### Primary-Replica (Master-Slave)
```
              ┌─────────────┐
              │   Primary   │
              │   (Write)   │
              └──────┬──────┘
           ┌─────────┼─────────┐
           ▼         ▼         ▼
     ┌──────────┐ ┌──────────┐ ┌──────────┐
     │ Replica  │ │ Replica  │ │ Replica  │
     │  (Read)  │ │  (Read)  │ │  (Read)  │
     └──────────┘ └──────────┘ └──────────┘
```

- Writes go to primary, reads go to replicas
- Replication lag: expect 10-100ms delay
- Use for read-heavy workloads (80%+ reads)
- **Consistency trade-off:** Reads from replicas may be stale

### Multi-Primary (Master-Master)
```
     ┌──────────────┐     ┌──────────────┐
     │   Primary A  │◄───►│   Primary B  │
     │   (R/W)      │     │   (R/W)      │
     └──────┬───────┘     └──────┬───────┘
            ▼                    ▼
     ┌──────────┐          ┌──────────┐
     │ Replica  │          │ Replica  │
     └──────────┘          └──────────┘
```

- Both primaries accept writes, replicate to each other
- Conflict resolution needed (last-write-wins, custom logic)
- Complex to maintain — use only when needed (geo-distributed writes)

### Sync vs Async Replication
- **Synchronous:** Primary waits for replica confirmation. Strong consistency, higher latency.
- **Asynchronous:** Primary doesn't wait. Lower latency, risk of data loss on primary failure.

---

## Part 6: NoSQL Schema Design

### MongoDB Schema Design

**Embedding vs Referencing:**
```javascript
// EMBED: Data accessed together, limited cardinality
// Good: Comments on a post (10s of comments per post)
{
  _id: ObjectId("..."),
  title: "My Post",
  body: "Content...",
  comments: [
    { userId: ObjectId("..."), text: "Great!", createdAt: ISODate("...") },
    { userId: ObjectId("..."), text: "Thanks!", createdAt: ISODate("...") },
  ]
}

// REFERENCE: Large cardinality, independent access
// Bad to embed: Orders for a user (thousands of orders)
{
  _id: ObjectId("..."),
  name: "Alice",
  email: "alice@example.com"
}

// Orders collection
{
  _id: ObjectId("..."),
  userId: ObjectId("..."),  // Reference to user
  items: [...],
  total: 99.99,
  createdAt: ISODate("...")
}

// Create index on userId for efficient lookups
db.orders.createIndex({ userId: 1, createdAt: -1 })
```

**MongoDB Indexing:**
```javascript
// Compound index
db.orders.createIndex({ userId: 1, status: 1, createdAt: -1 });

// Partial index (only active orders)
db.orders.createIndex({ userId: 1 }, { partialFilterExpression: { status: 'active' } });

// Text index for search
db.posts.createIndex({ title: 'text', body: 'text' });

// TTL index (auto-expire documents)
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 3600 });
```

### DynamoDB Schema Design

Design access patterns first, then build the table:

```javascript
// Single-table design for an e-commerce app
// Access patterns:
// 1. Get user by ID
// 2. Get all orders for a user
// 3. Get order by ID
// 4. Get all products in a category

const params = {
  TableName: 'AppData',
  KeySchema: [
    { AttributeName: 'PK', KeyType: 'HASH' },  // Partition key
    { AttributeName: 'SK', KeyType: 'RANGE' },  // Sort key
  ],
};

// Example items:
// User:    PK=USER#123,  SK=PROFILE, name="Alice"
// Order:   PK=USER#123,  SK=ORDER#2024-01-15#456, total=99.99
// Product: PK=CATEGORY#electronics, SK=PRODUCT#789, name="Laptop"
```

---

## Part 7: Migration Strategies

### Zero-Downtime Migration Patterns

**1. Expand and Contract:**
```sql
-- Step 1: Add new column (expand)
ALTER TABLE users ADD COLUMN display_name VARCHAR(255);

-- Step 2: Backfill data
UPDATE users SET display_name = first_name || ' ' || last_name 
WHERE display_name IS NULL;

-- Step 3: Add NOT NULL constraint (after backfill)
ALTER TABLE users ALTER COLUMN display_name SET NOT NULL;

-- Step 4: Update application code to use new column
-- Step 5: Remove old column (contract) — in a later migration
```

**2. Dual Write (for schema changes):**
```typescript
// Phase 1: Write to both old and new tables
async function createUser(data: UserData) {
  const user = await db.users.create(data);           // Old table
  await db.users_v2.create(data);                      // New table
  return user;
}

// Phase 2: Read from new table, write to both
async function getUser(id: string) {
  return db.users_v2.findById(id);  // Read from new
}

// Phase 3: Stop writing to old table
// Phase 4: Drop old table
```

**3. Backfill without locking:**
```sql
-- Process in batches to avoid long-running transactions
DO $$
DECLARE
  batch_size INT := 1000;
  last_id BIGINT := 0;
  rows_updated INT;
BEGIN
  LOOP
    UPDATE users 
    SET display_name = first_name || ' ' || last_name 
    WHERE id > last_id AND id <= last_id + batch_size 
      AND display_name IS NULL;
    
    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    last_id := last_id + batch_size;
    
    EXIT WHEN rows_updated = 0;
    
    -- Brief pause to reduce load
    PERFORM pg_sleep(0.1);
  END LOOP;
END $$;
```

### ORM Migration Examples

**Prisma:**
```prisma
// schema.prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String
  orders    Order[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Order {
  id         Int      @id @default(autoincrement())
  userId     Int
  user       User     @relation(fields: [userId], references: [id])
  total      Decimal  @db.Decimal(10, 2)
  status     String   @default("pending")
  createdAt  DateTime @default(now())
  
  @@index([userId, createdAt])
  @@index([status])
}
```

**SQLAlchemy:**
```python
from sqlalchemy import Column, Integer, String, Numeric, ForeignKey, DateTime, Index
from sqlalchemy.orm import relationship
from datetime import datetime

class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(255), unique=True, nullable=False)
    name = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    orders = relationship('Order', back_populates='user')

class Order(Base):
    __tablename__ = 'orders'
    __table_args__ = (
        Index('idx_orders_user_created', 'user_id', 'created_at'),
        Index('idx_orders_status', 'status'),
    )
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    total = Column(Numeric(10, 2), nullable=False)
    status = Column(String(50), default='pending')
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship('User', back_populates='orders')
```

---

## Part 8: Performance Tuning Patterns

### Connection Pooling
```typescript
// Use connection pooling (e.g., pg-pool for PostgreSQL)
import { Pool } from 'pg';

const pool = new Pool({
  max: 20,           // Maximum connections
  min: 5,            // Minimum connections
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});
```

### Query Performance Monitoring
```sql
-- Find slow queries (PostgreSQL)
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Table bloat check
SELECT 
  schemaname, tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
  pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
  pg_size_pretty(pg_indexes_size(schemaname||'.'::regclass)) as index_size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(schemaname||'.'::tablename) DESC;
```

### Materialized Views for Complex Queries
```sql
CREATE MATERIALIZED VIEW order_summary AS
SELECT 
  u.id as user_id,
  u.name,
  COUNT(o.id) as total_orders,
  SUM(o.total) as total_spent,
  MAX(o.created_at) as last_order_date
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name;

-- Refresh periodically
REFRESH MATERIALIZED VIEW CONCURRENTLY order_summary;
```

### Caching with Redis
```typescript
// Cache frequently accessed, rarely changed data
async function getProduct(id: number): Promise<Product> {
  const cacheKey = `product:${id}`;
  const cached = await redis.get(cacheKey);
  if (cached) return JSON.parse(cached);
  
  const product = await db.query('SELECT * FROM products WHERE id = $1', [id]);
  await redis.setex(cacheKey, 3600, JSON.stringify(product));
  return product;
}
```

---

## Part 9: Real-World Schema Examples

### E-Commerce Schema
```sql
-- Products
CREATE TABLE products (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  sku VARCHAR(100) UNIQUE,
  stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  category_id BIGINT REFERENCES categories(id),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'draft', 'archived')),
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products (category_id) WHERE status = 'active';
CREATE INDEX idx_products_search ON products USING GIN (to_tsvector('english', name || ' ' || COALESCE(description, '')));
CREATE INDEX idx_products_sku ON products (sku) WHERE sku IS NOT NULL;
CREATE INDEX idx_products_price ON products (price) WHERE status = 'active';

-- Orders
CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
  shipping_address JSONB NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_user ON orders (user_id, created_at DESC);
CREATE INDEX idx_orders_status ON orders (status, created_at) WHERE status NOT IN ('delivered', 'cancelled');
```

### SaaS Multi-Tenant Schema
```sql
-- Tenant-scoped tables with row-level security
CREATE TABLE tenants (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  plan VARCHAR(50) DEFAULT 'free',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE tenant_users (
  id BIGSERIAL PRIMARY KEY,
  tenant_id BIGINT NOT NULL REFERENCES tenants(id),
  email VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'member',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (tenant_id, email)
);

-- Row Level Security
ALTER TABLE tenant_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON tenant_users
  USING (tenant_id = current_setting('app.current_tenant_id')::BIGINT);
```

---

## Output Format

```markdown
## Database Schema: [Project/Feature Name]

### Entity Relationship Summary
[Mermaid ER diagram or text description of relationships]

### Tables

#### [table_name]
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|

**Indexes:** [list of indexes with rationale]
**Relationships:** [FK references]

### SQL Schema
```sql
-- [Database engine]
CREATE TABLE ...
```

### Query Optimization Notes
[Common queries and their optimal index support]

### Migration Plan
[If modifying existing schema, the step-by-step migration approach]

### ORM Equivalent
[Prisma / SQLAlchemy / Django model code if applicable]
```

## Rules

- **Always generate runnable SQL** — Not just descriptions, actual DDL statements
- **Specify the database engine** — PostgreSQL, MySQL, and SQLite have different syntax and capabilities
- **Use appropriate data types** — No generic `TEXT` for everything; use `VARCHAR(n)`, `DECIMAL`, `TIMESTAMPTZ`
- **Index foreign keys** — This is not optional
- **Include partial, expression, and covering indexes** where they provide significant benefit
- **Avoid over-normalization** — If a join table would only ever have 2 columns and is queried 100x more than written, consider JSONB or a simpler structure
- **Consider the query patterns** — Schema design should serve how the data will be accessed, not just how it's stored
- **Be explicit about NULLs** — Every nullable column should be a conscious decision, documented with why
- **For NoSQL:** Design access patterns first, then the schema — not the other way around
- **For migrations:** Always use expand-and-contract pattern for zero-downtime deployments
- **Include performance tuning recommendations** with every schema
