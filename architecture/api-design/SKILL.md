---
name: api-design
description: >-
  Design RESTful and GraphQL APIs. Endpoints, schemas, versioning, documentation.
  TRIGGERS: api design, rest api, graphql, endpoint, route, api schema, api documentation,
  swagger, openapi, api versioning, crud, http methods,
  طراحی API, طراحی روت, اندپوینت, گراف‌کیوال, مستندات API,
  API设计, REST, GraphQL, 端点, 路由, 接口设计
priority: P2
dependencies: [system-design]
conflicts: []
---

# API Design Skill

## Overview

Design clean, consistent, well-documented APIs covering REST conventions deep dive, GraphQL schema design, versioning strategies, error handling patterns, pagination, rate limiting, authentication/authorization, and OpenAPI spec generation.

## When to Use This Skill

- Designing new API endpoints
- Creating API documentation
- Choosing between REST/GraphQL
- API versioning decisions
- Designing API error handling
- Adding pagination to lists
- API设计 (API design), 接口设计 (interface design)
- طراحی API (API design)

## When NOT to Use This Skill

- Implementing business logic only (→ code-generation)
- Database design only (→ database-design)
- No API involved

## Inputs Required

- Resources to expose
- Client types (web, mobile, third-party)
- Authentication requirements
- Data volume expectations
- Versioning strategy preference

## Preconditions

- System architecture is defined (or being designed)
- Data model is understood

---

## Workflow

### Step 1: Define Resources

```
1. Identify resources (nouns, not verbs)
2. Define relationships between resources
3. Choose naming conventions
4. Determine resource granularity
```

**Resource Naming Conventions**:
```
├── Use plural nouns: /users, /orders, /products
├── Use kebab-case for multi-word: /order-items
├── Use nested for relationships: /users/{id}/orders
├── Use query params for filtering: /users?role=admin
└── Never use verbs in URLs: /getUser ❌ → /users/{id} ✅
```

### Step 2: Design Endpoints (REST Deep Dive)

```
RESTful CRUD Operations:
├── GET    /resources          → List (with pagination)
├── GET    /resources/:id      → Get one
├── POST   /resources          → Create (return 201 + Location header)
├── PUT    /resources/:id      → Full update (return 200)
├── PATCH  /resources/:id      → Partial update (return 200)
├── DELETE /resources/:id      → Delete (return 204)

Non-CRUD Operations (use RPC-style for actions):
├── POST   /resources/:id/actions/activate  → Activate resource
├── POST   /resources/:id/actions/archive   → Archive resource
└── POST   /resources/actions/batch-delete  → Batch operation
```

**HTTP Status Codes**:
```
├── 200 OK — Successful read/update
├── 201 Created — Successful creation (include Location header)
├── 202 Accepted — Async operation started (include job URL)
├── 204 No Content — Successful deletion
├── 400 Bad Request — Invalid input / validation error
├── 401 Unauthorized — Not authenticated
├── 403 Forbidden — Not authorized
├── 404 Not Found — Resource doesn't exist
├── 409 Conflict — Resource state conflict (duplicate, version mismatch)
├── 422 Unprocessable Entity — Validation error (semantic)
├── 429 Too Many Requests — Rate limit exceeded
├── 500 Internal Server Error — Unexpected server error
└── 503 Service Unavailable — Temporary unavailability
```

**HTTP Methods Semantics**:
```
GET     — Idempotent, safe, cacheable
PUT     — Idempotent, not safe
DELETE  — Idempotent, not safe
POST    — Not idempotent, not safe
PATCH   — Not idempotent, not safe (but can be designed to be)
HEAD    — Same as GET but no body (useful for checking resource existence)
OPTIONS — Returns allowed methods (CORS preflight)
```

### Step 3: Design GraphQL Schema

```graphql
# Schema Design Principles:
# 1. Use noun-based types, not verb-based
# 2. Use Input types for mutations
# 3. Use connections for pagination
# 4. Provide meaningful descriptions

type User {
  id: ID!
  name: String!
  email: String!
  orders(first: Int, after: String): OrderConnection!
  createdAt: DateTime!
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
  total: Float!
  status: OrderStatus!
}

enum OrderStatus {
  PENDING
  CONFIRMED
  SHIPPED
  DELIVERED
  CANCELLED
}

input CreateUserInput {
  name: String!
  email: String!
}

input UpdateUserInput {
  name: String
  email: String
}

type Query {
  user(id: ID!): User
  users(first: Int, after: String, filter: UserFilter): UserConnection!
}

type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UpdateUserPayload!
  deleteUser(id: ID!): DeleteUserPayload!
}

# Mutation payloads with errors
type CreateUserPayload {
  user: User
  errors: [UserError!]!
}

type UserError {
  field: String
  message: String!
  code: ErrorCode!
}
```

### Step 4: Error Handling Patterns

```json
// Standard Error Response Format
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address",
        "code": "INVALID_FORMAT"
      },
      {
        "field": "age",
        "message": "Must be at least 18",
        "code": "OUT_OF_RANGE"
      }
    ],
    "request_id": "req_abc123",
    "documentation_url": "https://api.example.com/docs/errors#VALIDATION_ERROR"
  }
}

// Minimal Error Response (for simple APIs)
{
  "error": "Not found",
  "code": "NOT_FOUND"
}
```

**Error Handling Rules**:
```
├── Always return structured error responses
├── Include error code for programmatic handling
├── Include human-readable message
├── Include request ID for debugging
├── Don't expose internal errors (stack traces, SQL)
├── Use appropriate HTTP status codes
├── Provide documentation URL for error codes
└── Log all errors with full context (server-side only)
```

### Step 5: Pagination

```json
// Cursor-based Pagination (Recommended for APIs)
// Request: GET /users?first=10&cursor=abc123
{
  "data": [...],
  "pagination": {
    "has_more": true,
    "next_cursor": "def456",
    "previous_cursor": "xyz789"
  }
}

// Offset-based Pagination (Simpler but less reliable)
// Request: GET /users?page=2&per_page=20
{
  "data": [...],
  "pagination": {
    "page": 2,
    "per_page": 20,
    "total": 156,
    "total_pages": 8
  }
}

// GraphQL Connection Pattern
{
  "data": {
    "users": {
      "edges": [
        {"node": {"id": "1", "name": "Alice"}, "cursor": "abc"}
      ],
      "pageInfo": {
        "hasNextPage": true,
        "endCursor": "abc",
        "hasPreviousPage": false,
        "startCursor": "abc"
      }
    }
  }
}
```

**Pagination Strategy Selection**:
```
├── Cursor-based: Best for real-time data, infinite scroll, large datasets
├── Offset-based: Best for admin UIs, known total, page numbers
└── Keyset: Best for performance, consistent ordering
```

### Step 6: Rate Limiting

```
Rate Limiting Headers (RFC 6585):
├── X-RateLimit-Limit: Maximum requests per window
├── X-RateLimit-Remaining: Remaining requests in window
├── X-RateLimit-Reset: Time when window resets (Unix timestamp)
├── Retry-After: Seconds to wait (on 429 response)

Rate Limiting Strategies:
├── Fixed Window: X requests per Y seconds (simplest)
├── Sliding Window: Rolling window (more accurate)
├── Token Bucket: Allows bursts (most flexible)
└── Leaky Bucket: Smooths traffic (strictest)

Rate Limit Tiers:
├── Anonymous: 100 requests/hour
├── Authenticated: 1000 requests/hour
├── Premium: 10000 requests/hour
└── Internal: Unlimited (service-to-service)
```

### Step 7: Authentication & Authorization

```
Authentication Methods:
├── API Key: Simple, for server-to-server
│   └── Header: X-API-Key: abc123
├── JWT Bearer Token: Stateless, for user sessions
│   └── Header: Authorization: Bearer <token>
├── OAuth 2.0: For third-party access
│   └── Flows: Authorization Code, Client Credentials
├── Basic Auth: Simple, for internal tools only
│   └── Header: Authorization: Basic <base64>
└── mTLS: Mutual TLS, for high-security services

Authorization Patterns:
├── Role-Based (RBAC): Admin, User, Viewer
├── Attribute-Based (ABAC): Fine-grained, context-aware
├── Resource-Based: Owner can edit, others can view
└── Scope-Based: API scopes limit what tokens can do

Implementation:
├── Always use HTTPS
├── Validate tokens on every request
├── Check permissions at every endpoint
├── Use short-lived tokens (15 min) with refresh tokens
└── Log all auth failures
```

### Step 8: OpenAPI Spec Generation

```yaml
# OpenAPI 3.0 Specification
openapi: 3.0.3
info:
  title: User Service API
  version: 1.0.0
  description: API for managing users

paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: per_page
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      summary: Create user
      operationId: createUser
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserInput'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '422':
          $ref: '#/components/responses/ValidationError'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        name:
          type: string
        email:
          type: string
          format: email
        created_at:
          type: string
          format: date-time

    CreateUserInput:
      type: object
      required: [name, email]
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 100
        email:
          type: string
          format: email
```

---

## Versioning Strategies

### URL Versioning
```
├── /v1/users
├── /v2/users
└── Pros: Simple, explicit, cacheable
└── Con: URL proliferation, breaks hypermedia
```

### Header Versioning
```
├── Accept: application/vnd.api.v2+json
├── API-Version: 2
└── Pros: Clean URLs, flexible
└── Con: Less visible, harder to test in browser
```

### Query Parameter Versioning
```
├── /users?version=2
└── Pros: Simple, visible
└── Con: Clutters URL, cache invalidation
```

### Content Negotiation (REST Best Practice)
```
├── Use Accept header for content type
├── Use API-Version header for breaking changes
├── Deprecate old versions with Sunset header
└── Provide migration guides between versions
```

### Versioning Decision Matrix
```
| Strategy | When to Use | Example |
|----------|------------|---------|
| URL | Public APIs, mobile clients | /v1/users |
| Header | Internal APIs, microservices | API-Version: 2 |
| Query Param | Simple versioning needs | ?version=2 |
| Content Type | REST purists | Accept: v2+json |
```

---

## Advanced Techniques (7 Techniques)

### 1. API-First Design
Design the API contract before implementation. Use OpenAPI/GraphQL schema as the source of truth. Generate server stubs and client SDKs from the spec.

### 2. HATEOAS (Hypermedia)
Include links in responses to guide clients to related resources. Reduces coupling between client and server.

```json
{
  "id": "123",
  "name": "Order #123",
  "links": [
    {"rel": "self", "href": "/orders/123", "method": "GET"},
    {"rel": "cancel", "href": "/orders/123/cancel", "method": "POST"},
    {"rel": "items", "href": "/orders/123/items", "method": "GET"}
  ]
}
```

### 3. Bulk Operations
Support batch operations to reduce network round trips.

```
POST /api/users/batch
{
  "operations": [
    {"method": "create", "data": {"name": "Alice"}},
    {"method": "create", "data": {"name": "Bob"}},
    {"method": "update", "id": "123", "data": {"name": "Charlie"}}
  ]
}
```

### 4. Idempotency Keys
For non-idempotent operations (POST, PATCH), require idempotency keys to prevent duplicate processing.

```
POST /api/payments
Idempotency-Key: unique-key-123
Content-Type: application/json

{"amount": 100, "currency": "USD"}
```

### 5. Conditional Requests (ETags)
Use ETags for caching and conflict detection.

```
GET /api/users/123
Response: ETag: "abc123"

PUT /api/users/123
If-Match: "abc123"
→ 200 OK (if ETag matches)
→ 412 Precondition Failed (if ETag mismatch)
```

### 6. Field Selection (Sparse Fieldsets)
Allow clients to request only the fields they need.

```
GET /api/users?fields=id,name,email
GET /api/users?fields=id,name,orders{id,total}
```

### 7. API Composition
Combine multiple API calls into a single response for complex client needs.

```
GET /api/users/123?include=orders,profile,preferences
Response:
{
  "id": "123",
  "name": "Alice",
  "orders": [...],
  "profile": {...},
  "preferences": {...}
}
```

---

## Common Patterns (5 Patterns with Code Examples)

### Pattern 1: Resource Transformation Layer
```python
# Transform internal models to API responses
class UserSerializer:
    @staticmethod
    def to_dict(user, include_private=False):
        data = {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "created_at": user.created_at.isoformat(),
        }
        if include_private:
            data["internal_id"] = user.internal_id
            data["role"] = user.role
        return data

    @staticmethod
    def to_list(users, pagination):
        return {
            "data": [UserSerializer.to_dict(u) for u in users],
            "pagination": pagination.to_dict(),
        }
```

### Pattern 2: Request Validation
```python
from pydantic import BaseModel, EmailStr, validator

class CreateUserRequest(BaseModel):
    name: str
    email: EmailStr
    age: int

    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError('Name cannot be empty')
        return v.strip()

    @validator('age')
    def age_must_be_reasonable(cls, v):
        if v < 0 or v > 150:
            raise ValueError('Age must be between 0 and 150')
        return v
```

### Pattern 3: Standardized Response Wrapper
```python
class APIResponse:
    @staticmethod
    def success(data, status_code=200, meta=None):
        response = {"data": data}
        if meta:
            response["meta"] = meta
        return response, status_code

    @staticmethod
    def error(message, code, status_code=400, details=None):
        error_obj = {
            "error": {
                "code": code,
                "message": message,
            }
        }
        if details:
            error_obj["error"]["details"] = details
        return error_obj, status_code

# Usage
@app.route('/users', methods=['POST'])
def create_user():
    try:
        user = user_service.create(request.json)
        return APIResponse.success(
            UserSerializer.to_dict(user),
            status_code=201
        )
    except ValidationError as e:
        return APIResponse.error(
            "Validation failed",
            "VALIDATION_ERROR",
            details=e.errors()
        )
```

### Pattern 4: Rate Limiting Middleware
```python
from functools import wraps
from time import time

class RateLimiter:
    def __init__(self, max_requests, window_seconds):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.requests = {}

    def is_allowed(self, key):
        now = time()
        window_start = now - self.window_seconds
        # Clean old entries
        self.requests[key] = [t for t in self.requests[key] if t > window_start]
        if len(self.requests[key]) >= self.max_requests:
            return False
        self.requests[key].append(now)
        return True

# Usage
limiter = RateLimiter(max_requests=100, window_seconds=60)

@app.before_request
def check_rate_limit():
    if not limiter.is_allowed(request.remote_addr):
        return APIResponse.error("Rate limit exceeded", "RATE_LIMITED", 429)
```

### Pattern 5: Versioned Response Building
```python
class UserV1Serializer:
    @staticmethod
    def to_dict(user):
        return {"id": user.id, "name": user.name}

class UserV2Serializer:
    @staticmethod
    def to_dict(user):
        return {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "created_at": user.created_at.isoformat(),
        }

def get_serializer(version):
    serializers = {"1": UserV1Serializer, "2": UserV2Serializer}
    return serializers.get(version, UserV2Serializer)

@app.route('/users/<id>')
def get_user(id):
    version = request.headers.get('API-Version', '2')
    serializer = get_serializer(version)
    user = user_service.get(id)
    return serializer.to_dict(user)
```

---

## Edge Cases & Pitfalls (15 Items)

1. **N+1 API calls**: Client makes separate calls for related resources. Use includes/embeds to batch.
2. **Missing pagination**: Unbounded lists grow forever and kill performance. Always paginate.
3. **Inconsistent error format**: Different endpoints return different error structures. Standardize.
4. **No idempotency on retries**: Duplicate payments on network retry. Use idempotency keys.
5. **Over-fetching**: Returning all fields when client needs 2. Use sparse fieldsets.
6. **Under-fetching**: Client needs multiple calls to render one page. Use API composition / includes.
7. **Race conditions on updates**: Two clients update the same resource. Use ETags or versioning.
8. **Timezone handling in timestamps**: Inconsistent timezone representation. Always use UTC + ISO 8601.
9. **Null vs. missing fields**: Distinguishing between "not provided" and "set to null". Use explicit schema.
10. **Batch operation partial failure**: Some operations in batch succeed, some fail. Report per-operation status.
11. **URL length limits**: Too many query params for filtering. Use POST for complex filters.
12. **Content-Type mismatch**: Client sends JSON but server expects form data. Validate Content-Type.
13. **CORS misconfiguration**: Browser blocks cross-origin requests. Configure proper CORS headers.
14. **Trailing slashes inconsistency**: `/users` vs `/users/` returning different results. Normalize.
15. **Large response bodies**: Sending megabytes of data. Use pagination, compression, streaming.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **system-design** | ← Depends on | API design is part of system architecture |
| **database-design** | → Feeds into | API resources map to data models |
| **code-generation** | → Feeds into | Implement API from design |
| **testing** | → Feeds into | API contract tests |
| **documentation** | → Feeds into | OpenAPI/GraphQL docs |
| **security** | → Feeds into | Auth/authz design |
| **monitoring** | → Feeds into | API metrics and logging |

---

## Output Format Templates

### Template 1: Standard API Design
```
## API Design — [Service Name]

### Resources
| Resource | Description | Relationships |
|----------|-------------|---------------|
| /users | User accounts | has orders |
| /orders | Customer orders | belongs to user |

### Endpoints
| Method | Path | Description | Auth | Rate Limit |
|--------|------|-------------|------|------------|
| GET | /users | List users | Yes | 100/min |
| POST | /users | Create user | Yes | 10/min |

### Schemas
[Request/Response schemas]

### Error Format
[Standard error response]

### Versioning
[Strategy and current version]

### Pagination
[Strategy and default page size]

### Rate Limits
[Tier-based limits]
```

### Template 2: Quick API Reference
```
## Quick API Reference — [Service]

| Endpoint | Method | Description |
|----------|--------|-------------|
| /users | GET | List users |
| /users/:id | GET | Get user |
| /users | POST | Create user |

Base URL: https://api.example.com/v1
Auth: Bearer token
```

### Template 3: Deep API Specification
```
## API Specification — [Service]

### Design Principles
- RESTful conventions
- Cursor-based pagination
- JWT authentication
- Consistent error format

### OpenAPI Spec
[Full OpenAPI YAML]

### GraphQL Schema
[Full GraphQL schema]

### Authentication Flow
[OAuth/JWT flow diagram]

### Rate Limiting Policy
[Per-tier limits and headers]

### Versioning Policy
[Deprecation timeline]

### Migration Guide
[How to migrate from v1 to v2]
```

### Template 4: Agent-Specific (Structured for Automation)
```json
{
  "api_name": "User Service API",
  "version": "1.0.0",
  "base_url": "https://api.example.com/v1",
  "resources": [
    {
      "name": "users",
      "endpoints": [
        {"method": "GET", "path": "/users", "auth": true, "rate_limit": 100},
        {"method": "POST", "path": "/users", "auth": true, "rate_limit": 10}
      ]
    }
  ],
  "schemas": {
    "User": {"type": "object", "properties": {"id": {"type": "string"}}}
  },
  "error_codes": ["VALIDATION_ERROR", "NOT_FOUND", "RATE_LIMITED"],
  "pagination": "cursor",
  "auth": "jwt",
  "openapi_version": "3.0.3"
}
```

---

## Rules (12 Rules)

1. **Use plural nouns for resources** — `/users` not `/user`.
2. **Use HTTP methods correctly** — GET is safe/idempotent, POST is not.
3. **Return proper HTTP status codes** — 201 for creation, 204 for deletion, 4xx for client errors.
4. **Always paginate list endpoints** — No unbounded collections.
5. **Standardize error responses** — Same format across all endpoints.
6. **Version your API from day one** — `/v1/` prefix or header-based versioning.
7. **Document with OpenAPI/GraphQL** — Machine-readable specs for tooling.
8. **Implement rate limiting** — Protect against abuse and accidental overload.
9. **Use idempotency keys for non-idempotent operations** — Prevent duplicate processing.
10. **Validate all input** — Never trust client data; validate and sanitize.
11. **Support HTTPS only** — No plain HTTP in production.
12. **Design for evolvability** — Add fields, don't remove them; extend, don't break.

---

## Decision Tree

```
REST vs GraphQL?
├── Simple CRUD → REST
├── Multiple client types with different data needs → GraphQL
├── Real-time subscriptions → GraphQL (subscriptions) or WebSocket
├── File uploads → REST (multipart)
├── Complex nested data → GraphQL
└── Cache-heavy → REST (HTTP caching)

Versioning strategy?
├── Public API → URL versioning (/v1/)
├── Internal API → Header versioning
├── Mobile clients → URL versioning (explicit)
└── Evolving API → Additive changes only, no version bump

Pagination strategy?
├── Infinite scroll → Cursor-based
├── Admin UI with page numbers → Offset-based
├── Large datasets (>1M) → Cursor-based
└── Simple lists → Offset-based

Auth strategy?
├── User sessions → JWT Bearer tokens
├── Third-party access → OAuth 2.0
├── Server-to-server → API Keys or mTLS
└── Public read-only → None or API key
```

---

## Verification

- [ ] All resources use plural nouns
- [ ] HTTP methods used correctly
- [ ] Status codes are appropriate
- [ ] Error responses are standardized
- [ ] Pagination implemented for lists
- [ ] Rate limiting configured
- [ ] Authentication required where needed
- [ ] OpenAPI spec generated and valid

## Anti-Patterns

- ❌ Using verbs in URLs (/getUser, /createOrder)
- ❌ Inconsistent naming conventions
- ❌ No error handling or inconsistent error format
- ❌ No pagination for list endpoints
- ❌ No authentication on sensitive endpoints
- ❌ Returning 200 for all responses (including errors)
- ❌ Exposing internal IDs or database structure
- ❌ No versioning strategy
- ❌ Accepting unvalidated input
- ❌ Returning unnecessary fields (over-fetching)
- ❌ No rate limiting (DoS vulnerability)
- ❌ Hardcoding API keys in client code
- ❌ Not documenting API changes
- ❌ Breaking changes without version bump
