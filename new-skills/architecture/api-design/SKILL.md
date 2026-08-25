---
name: api-design
description: >-
  Design RESTful and GraphQL APIs. Endpoints, schemas, versioning, documentation.
  TRIGGERS: api design, rest api, graphql, endpoint, route, api schema, api documentation,
  swagger, openapi, api versioning, crud, http methods,
  طراحی API, طراحی روت, اندپوینت, گراف‌کیوال, مستندات API
priority: P2
dependencies: [system-design]
conflicts: []
---

# API Design Skill

## Purpose

Design clean, consistent, well-documented APIs.

## When to Activate

- Designing new API endpoints
- Creating API documentation
- Choosing between REST/GraphQL
- API versioning decisions

## Workflow

### Step 1: Define Resources

```
1. Identify resources (nouns, not verbs)
2. Define relationships between resources
3. Choose naming conventions
```

### Step 2: Design Endpoints

```
REST conventions:
GET    /resources          → List
GET    /resources/:id      → Get one
POST   /resources          → Create
PUT    /resources/:id      → Update
DELETE /resources/:id      → Delete

GraphQL:
type Query { resource(id: ID): Resource }
type Mutation { createResource(input: CreateInput): Resource }
```

### Step 3: Define Schemas

```
1. Request schemas (input validation)
2. Response schemas (consistent format)
3. Error schemas (standard error format)
4. Pagination schemas
```

### Step 4: Add cross-cutting concerns

```
1. Authentication/Authorization
2. Rate limiting
3. Pagination
4. Filtering/Sorting
5. Error handling
6. Versioning strategy
```

## Output Format

```
## API Design

### Endpoints
| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | /api/v1/users | List users | Yes |

### Schemas
[Request/Response schemas]

### Error Format
[Standard error response]

### Versioning
[Strategy]
```

## Anti-Patterns

- ❌ Using verbs in URLs (/getUser)
- ❌ Inconsistent naming
- ❌ No error handling
- ❌ No pagination for lists
- ❌ No authentication

## Skill Interactions

- ← system-design: System context
- → database-design: Data layer for API
- → code-generation: Implement API
