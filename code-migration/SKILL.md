---
name: code-migration
description: >-
  Migrate code between frameworks, languages, libraries, or architectural patterns.
  Use this skill when the user mentions code migration, framework migration, language migration,
  refactor to new framework, upgrade codebase, migrate from X to Y, rewrite, modernize code,
  migrate to TypeScript, migrate to React, migrate to FastAPI, migrate database,
  schema migration, API versioning migration, legacy code migration,
  or says مهاجرت کد, ارتقای کد, بازنویسی کد, مهاجرت فریمورک, مهاجرت زبان.
---

# Code Migration Skill — Migrate Between Frameworks, Languages & Architectures

## Overview

This skill provides a systematic approach to migrating codebases between frameworks, languages, libraries, or architectural patterns. Migration is one of the riskiest operations in software engineering — done wrong, it can take months and break everything. This skill provides a safe, incremental migration strategy that minimizes risk and allows rollback at every step. Covers language migration (JS→TS, Python 2→3), framework migration (Vue→React, Express→FastAPI), database migration, and API versioning.

## When to Use This Skill

- User wants to migrate from one framework to another
- User wants to migrate from one language to another
- User needs to upgrade a major version of a library
- User wants to modernize legacy code
- User mentions migration, rewrite, or modernization
- User says " migrate from X to Y"
- User mentions مهاجرت کد, ارتقای کد, or بازنویسی کد

---

## Part 1: Migration Strategy

### The Strangler Fig Pattern (Recommended)

Don't rewrite everything at once. Gradually replace old code with new code:

```
Phase 1: Wrap old system with a proxy/facade
  ┌─────────────┐
  │   New UI    │
  └──────┬──────┘
         │
  ┌──────▼──────┐
  │   Facade    │ ← Routes to old or new
  └──────┬──────┘
    ┌────┴────┐
    │ Old     │ New
    │ System  │ Service
    └─────────┘

Phase 2: Migrate features one by one
Phase 3: Remove old system when all features migrated
```

### Migration Phases

| Phase | Description | Risk | Duration |
|-------|-------------|------|----------|
| **1. Audit** | Inventory all code, dependencies, and patterns | None | 1-2 days |
| **2. Plan** | Decide migration order, identify blockers | Low | 1-2 days |
| **3. Setup** | Create new project structure, tooling, CI/CD | Low | 1-2 days |
| **4. Migrate Core** | Move business logic first (shared code) | Medium | Varies |
| **5. Migrate Features** | One feature at a time, with tests | Medium | Varies |
| **6. Validate** | Compare old vs new behavior | Low | 1-2 days |
| **7. Cleanup** | Remove old code, update docs | Low | 1 day |

### Migration Order (Priority)

```
1. Shared utilities and types (least dependencies)
2. Data models and schemas
3. Business logic (core domain)
4. API endpoints
5. Frontend/UI
6. Tests
7. Documentation
```

---

## Part 2: Language Migration

### JavaScript → TypeScript

```typescript
// Step 1: Add TypeScript config
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"]
}

// Step 2: Add types to existing files
// Before (JS):
// function processUser(user) { return user.name.toUpperCase(); }

// After (TS):
interface User {
  id: string;
  name: string;
  email: string;
}

function processUser(user: User): string {
  return user.name.toUpperCase();
}

// Step 3: Enable strict mode gradually
// "strict": false → "noImplicitAny": true → "strict": true
```

### Python 2 → Python 3

```python
# Step 1: Use 2to3 tool
# 2to3 -w -n myproject/

# Step 2: Fix common patterns
# Before (Python 2):
# print "Hello"
# dict.has_key("key")
# xrange(10)

# After (Python 3):
# print("Hello")
# "key" in dict
# range(10)

# Step 3: Update dependencies
# pip install pyupgrade
# pyupgrade --py3-plus *.py
```

### Migrate to Go

```go
// Before (Python):
// def process_order(order_id: str) -> dict:
//     order = db.get_order(order_id)
//     order["total"] = calculate_total(order["items"])
//     db.save_order(order)
//     return order

// After (Go):
type Order struct {
    ID    string  `json:"id"`
    Items []Item  `json:"items"`
    Total float64 `json:"total"`
}

func processOrder(orderID string) (*Order, error) {
    order, err := db.GetOrder(orderID)
    if err != nil {
        return nil, fmt.Errorf("failed to get order: %w", err)
    }
    
    order.Total = calculateTotal(order.Items)
    
    if err := db.SaveOrder(order); err != nil {
        return nil, fmt.Errorf("failed to save order: %w", err)
    }
    
    return order, nil
}
```

---

## Part 3: Framework Migration

### Vue → React Migration

```jsx
// Before (Vue):
// <template>
//   <div>
//     <h1>{{ title }}</h1>
//     <ul>
//       <li v-for="item in items" :key="item.id">{{ item.name }}</li>
//     </ul>
//     <button @click="addItem">Add</button>
//   </div>
// </template>
//
// <script>
// export default {
//   data() { return { title: 'My List', items: [] } },
//   methods: {
//     addItem() { this.items.push({ id: Date.now(), name: 'New Item' }) }
//   }
// }
// </script>

// After (React):
import { useState } from 'react';

interface Item {
  id: number;
  name: string;
}

function MyList() {
  const [title] = useState('My List');
  const [items, setItems] = useState<Item[]>([]);

  const addItem = () => {
    setItems(prev => [...prev, { id: Date.now(), name: 'New Item' }]);
  };

  return (
    <div>
      <h1>{title}</h1>
      <ul>
        {items.map(item => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
      <button onClick={addItem}>Add</button>
    </div>
  );
}
```

### Express → FastAPI Migration

```python
# Before (Express):
# app.get('/users/:id', async (req, res) => {
#   const user = await db.getUser(req.params.id);
#   res.json(user);
# });

# After (FastAPI):
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class User(BaseModel):
    id: str
    name: str
    email: str

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: str):
    user = await db.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

### REST → GraphQL Migration

```graphql
# Before: Multiple REST endpoints
# GET /api/users/:id
# GET /api/users/:id/posts
# GET /api/posts/:id/comments

# After: Single GraphQL endpoint
type User {
  id: ID!
  name: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  content: String!
  comments: [Comment!]!
}

type Query {
  user(id: ID!): User
  post(id: ID!): Post
}

type Mutation {
  createUser(name: String!, email: String!): User!
  createPost(title: String!, content: String!, userId: ID!): Post!
}

# Resolver
type Resolvers = {
  Query: {
    user: (_, { id }) => db.getUser(id),
    post: (_, { id }) => db.getPost(id),
  },
  User: {
    posts: (user) => db.getPostsByUser(user.id),
  },
  Post: {
    comments: (post) => db.getCommentsByPost(post.id),
  },
};
```

---

## Part 4: Database Migration

### Schema Migration

```sql
-- Step 1: Create new schema (backward compatible)
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;

-- Step 2: Backfill data
UPDATE users SET email_verified = TRUE WHERE email IS NOT NULL;

-- Step 3: Add NOT constraint after backfill
ALTER TABLE users ALTER COLUMN email_verified SET NOT NULL;

-- Step 4: Drop old column (after all code updated)
-- ALTER TABLE users DROP COLUMN old_column;
```

### ORM Migration

```python
# Before (SQLAlchemy):
from sqlalchemy import Column, Integer, String
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(100))

# After (SQLAlchemy + Alembic):
# alembic revision --autogenerate -m "add email column"
# alembic upgrade head

from sqlalchemy import Column, Integer, String, Boolean
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(100))
    email = Column(String(255), unique=True, nullable=False)
    email_verified = Column(Boolean, default=False)
```

---

## Part 5: API Versioning Migration

### URL Versioning

```python
# Before: v1 API
@app.get("/api/v1/users/{user_id}")
def get_user_v1(user_id: str):
    return {"id": user_id, "name": "John"}

# After: v2 API (new response format)
@app.get("/api/v2/users/{user_id}")
def get_user_v2(user_id: str):
    return {"data": {"id": user_id, "name": "John"}, "meta": {"version": "2.0"}}

# Deprecation header
@app.middleware("http")
async def add_deprecation_header(request, call_next):
    response = await call_next(request)
    if "/api/v1/" in request.url.path:
        response.headers["Deprecation"] = "true"
        response.headers["Sunset"] = "2024-12-31"
        response.headers["Link"] = '</api/v2>; rel="successor-version"'
    return response
```

---

## Part 6: Testing During Migration

### Comparison Testing

```python
def compare_outputs(old_func, new_func, test_cases):
    """Compare old and new implementations."""
    mismatches = []
    
    for test_input in test_cases:
        old_output = old_func(test_input)
        new_output = new_func(test_input)
        
        if old_output != new_output:
            mismatches.append({
                "input": test_input,
                "old": old_output,
                "new": new_output
            })
    
    if mismatches:
        print(f"❌ Found {len(mismatches)} mismatches:")
        for m in mismatches:
            print(f"  Input: {m['input']}")
            print(f"  Old: {m['old']}")
            print(f"  New: {m['new']}")
    else:
        print("✅ All outputs match!")
    
    return mismatches
```

### A/B Testing Migration

```python
# Run both old and new implementations, compare results
def ab_test_migration(request):
    old_result = old_handler(request)  # Old code
    new_result = new_handler(request)  # New code
    
    # Log comparison
    log.info("migration_comparison", 
             old=old_result, new=new_result,
             match=(old_result == new_result))
    
    # Return old result (safely)
    return old_result
    
    # When confident, switch to new:
    # return new_result
```

---

## Output Format

```
## Migration Plan

### From → To
[Source] → [Target]

### Scope
- Files affected: X
- Lines of code: X
- Dependencies changed: X

### Migration Steps
1. [Step 1] — [Risk level] — [Estimated time]
2. [Step 2] — [Risk level] — [Estimated time]

### Testing Strategy
- [How to validate each step]
- [Rollback plan]

### Timeline
- Phase 1: [dates]
- Phase 2: [dates]
```

## Rules

- **Migrate incrementally** — Never rewrite everything at once
- **Keep old code running** — Strangler fig pattern until migration is complete
- **Test at every step** — Automated tests are your safety net
- **Have a rollback plan** — Every step should be reversible
- **Migrate the most-used features first** — Highest value, most testing
- **Document the migration** — Future developers need to understand the changes
