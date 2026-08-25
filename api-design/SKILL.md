---
name: api-design
description: >-
  Design RESTful APIs and GraphQL schemas with proper resource modeling, endpoint naming, status codes, versioning, authentication, pagination, error handling, and documentation. Use this skill when the user asks to design an API, طراحی API, REST API design, GraphQL schema, API endpoints, API structure, resource modeling, design my API, API best practices, API versioning, authentication flow, pagination design, error response format, openAPI spec, swagger, endpoint naming, HTTP methods, طراحی Endpoints, ساختار API, اسکیمای GraphQL, مستندسازی API, HATEOAS, Richardson Maturity Model, cursor pagination, offset pagination, gRPC design, rate limiting, API gateway, token bucket, sliding window, leaky bucket, API lifecycle, Stripe API design, GitHub API design, schema stitching, GraphQL subscriptions, DataLoader pattern.
---

# API Design Skill — Comprehensive API Architecture & Design

## Overview

This skill designs well-structured APIs — RESTful HTTP APIs, GraphQL schemas, and gRPC services. A good API is intuitive, consistent, and hard to misuse. The focus is on practical design decisions: resource naming, request/response formats, error handling, versioning, pagination strategies, rate limiting, and documentation. This skill covers the full spectrum from basic CRUD to advanced patterns like HATEOAS, event-driven APIs, and API gateway architectures.

## When to Use This Skill

- User wants to design a new API or API endpoints
- User asks about REST conventions, GraphQL schema design, or API best practices
- User needs an OpenAPI/Swagger specification
- User wants to restructure an existing API
- User asks about API versioning, authentication, or pagination strategies
- User asks about rate limiting, API gateway, or API lifecycle management
- User mentions HATEOAS, Richardson Maturity Model, or advanced REST patterns
- User needs gRPC service definitions or protobuf schemas
- User wants to compare GraphQL vs REST vs gRPC for their use case
- User mentions طراحی API, ساختار API, اسکیمای GraphQL, مستندسازی API

---

## Part 1: REST API Design

### Step 1: Identify Resources

From the user's description, extract the core entities:
- What are the main nouns? (users, orders, products, posts)
- What relationships exist between them?
- What actions can be performed on each?
- Which are aggregate roots vs child resources?

### Step 2: Design Endpoints

Follow REST conventions:

| Action | Method | Path | Status | Notes |
|--------|--------|------|--------|-------|
| List | GET | /resources | 200 | Support filtering, sorting, pagination |
| Get one | GET | /resources/:id | 200/404 | Return 404 if not found |
| Create | POST | /resources | 201 | Return 201 with created resource |
| Update (full) | PUT | /resources/:id | 200 | Return 200 with updated resource |
| Update (partial) | PATCH | /resources/:id | 200 | Only include changed fields |
| Delete | DELETE | /resources/:id | 204 | Return 204 No Content |
| Bulk create | POST | /resources/batch | 201 | Accept array, return array |
| Search | POST | /resources/search | 200 | Complex queries that don't fit GET params |

Rules for endpoint design:
- Use **plural nouns** for resource names: `/users` not `/user`
- Use **kebab-case** for multi-word resources: `/user-profiles`
- Nest only when there's a true ownership relationship: `/users/:id/orders` not `/orders/by-user/:userId`
- Limit nesting depth to 2 levels max: `/users/:id/orders/:orderId/items`
- Avoid verbs in URLs: use HTTP methods to express actions
- Use query parameters for filtering, sorting, and pagination
- Use query parameters for sparse fieldsets: `?fields=id,name,email`
- Avoid query strings for state mutations — use POST/PUT/PATCH instead

### Step 3: Richardson Maturity Model

Classify your API's REST maturity level:

**Level 0 — Swamp of POX:**
Single endpoint (e.g., `/api`), everything via POST with XML/JSON payloads describing the operation.
```
POST /api
Body: { "operation": "getUser", "id": 123 }
```

**Level 1 — Resources:**
Multiple endpoints, one per resource, but still using verbs.
```
GET /users/123
POST /createUser
POST /updateUser
```

**Level 2 — HTTP Verbs:**
Proper use of HTTP methods, status codes, and headers. This is the minimum for a well-designed REST API.
```
GET /users/123        → 200
POST /users           → 201
PUT /users/123        → 200
DELETE /users/123     → 204
```

**Level 3 — HATEOAS (Hypermedia):**
Responses include links to related resources and available actions. The client discovers the API through hypermedia.

Most production APIs operate at Level 2. Level 3 is ideal for public APIs consumed by unknown clients.

### Step 4: HATEOAS (Hypermedia as the Engine of Application State)

HATEOAS makes your API self-documenting by including links in responses:

```json
{
  "id": "123",
  "name": "Acme Corp",
  "status": "active",
  "_links": {
    "self": { "href": "/api/v1/organizations/123" },
    "members": { "href": "/api/v1/organizations/123/members" },
    "invoices": { "href": "/api/v1/organizations/123/invoices" },
    "suspend": { "href": "/api/v1/organizations/123/suspend", "method": "POST" },
    "delete": { "href": "/api/v1/organizations/123", "method": "DELETE" }
  }
}
```

Benefits:
- Client doesn't hardcode URL paths
- API can change paths without breaking clients
- Available actions are discoverable from any response

When to use HATEOAS:
- Public APIs with long lifecycle
- APIs consumed by generic clients
- APIs where discoverability matters
- Skip for internal microservice APIs where tight coupling is acceptable

### Step 5: Pagination Patterns

#### Offset-Based Pagination
```
GET /api/v1/posts?page=3&limit=20
GET /api/v1/posts?offset=40&limit=20
```

Response:
```json
{
  "data": [...],
  "pagination": {
    "page": 3,
    "limit": 20,
    "total": 156,
    "total_pages": 8
  }
}
```

Pros: Simple, supports "jump to page N", widely understood.
Cons: Inconsistent results under concurrent writes (items shift), slow at high offsets (`OFFSET 100000` scans 100k rows).

#### Cursor-Based Pagination (Recommended)
```
GET /api/v1/posts?cursor=eyJpZCI6MTIzLCJjcmVhdGVkX2F0IjoiMjAyNC0wMS0xNSJ9&limit=20
```

Response:
```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTQzLCJjcmVhdGVkX2F0IjoiMjAyNC0wMS0xNiJ9",
    "previous_cursor": "eyJpZCI6MTAzLCJjcmVhdGVkX2F0IjoiMjAyNC0wMS0xNCJ9",
    "has_more": true
  }
}
```

Implementation:
```sql
-- Cursor-based: efficient, index-friendly
SELECT * FROM posts
WHERE (created_at, id) < ($cursor_created_at, $cursor_id)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

Pros: Consistent under concurrent writes, O(1) performance regardless of position.
Cons: Can't jump to arbitrary page, slightly more complex to implement.

#### Keyset Pagination (Alternative Name for Cursor)
Same concept, but the cursor is a composite key rather than an opaque token. Often preferred when the cursor is transparent.

#### Time-Based Pagination
For time-series data:
```
GET /api/v1/events?since=2024-01-15T10:30:00Z&until=2024-01-16T10:30:00Z
```

#### Pagination Header Patterns
- **Link header** (RFC 5988): `<https://api.example.com/posts?page=2>; rel="next"`
- **X-Total-Count**: Total number of matching resources
- **X-Pagination-Page-Count**: Total pages
- **Envelope pattern** (recommended for frontend convenience): pagination metadata inside the JSON body

---

## Part 2: GraphQL Schema Design

### Step 1: Define Types and Schema

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  posts: [Post!]!          # Relationship
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  body: String!
  author: User!             # Reverse relationship
  tags: [Tag!]!
  comments(first: Int, after: String): PostConnection!  # Paginated
  status: PostStatus!
  createdAt: DateTime!
}

enum PostStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
}
```

### Step 2: Design Queries and Mutations

```graphql
type Query {
  # Single resource
  user(id: ID!): User
  post(id: ID!): Post
  
  # List resources with filtering and pagination
  users(filter: UserFilter, first: Int, after: String): UserConnection!
  posts(filter: PostFilter, first: Int, after: String): PostConnection!
}

type Mutation {
  createPost(input: CreatePostInput!): CreatePostPayload!
  updatePost(id: ID!, input: UpdatePostInput!): UpdatePostPayload!
  deletePost(id: ID!): DeletePostPayload!
}
```

### Step 3: Prevent N+1 Query Problem

The N+1 problem occurs when resolving related fields causes separate database queries for each parent:

```
# 1 query for users + N queries for each user's posts = N+1 queries
query {
  users { name, posts { title } }
}
```

**Solution: DataLoader Pattern**
```typescript
import DataLoader from 'dataloader';

// Batch loader: combines N individual loads into 1 query
const postsByUserIdLoader = new DataLoader(async (userIds: string[]) => {
  const posts = await db.posts.findMany({
    where: { userId: { in: userIds } }
  });
  // Return results in the same order as the input keys
  return userIds.map(id => posts.filter(p => p.userId === id));
});

// In resolver:
const resolvers = {
  User: {
    posts: (user) => postsByUserIdLoader.load(user.id)
  }
};
```

**Solution: JOIN Loading / Include Loading**
```typescript
// Eager loading at the query level
const users = await db.user.findMany({
  include: { posts: true }  // Single query with JOIN
});
```

### Step 4: Pagination in GraphQL (Relay Connection Specification)

```graphql
type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
  totalCount: Int
}

type PostEdge {
  node: Post!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}
```

### Step 5: Subscriptions (Real-Time)

```graphql
type Subscription {
  postCreated: Post!
  commentAdded(postId: ID!): Comment!
}

# Implementation with WebSocket (typically via graphql-ws)
# Client subscribes, server pushes events when mutations create new data
```

### Step 6: Schema Stitching / Federation

For large organizations with multiple GraphQL services:

**Apollo Federation:**
```graphql
# Service A (Users)
type User @key(fields: "id") {
  id: ID!
  name: String!
  email: String!
}

# Service B (Orders)
type Order @key(fields: "id") {
  id: ID!
  user: User!           # References User from Service A
  items: [OrderItem!]!
}
```

**Schema Stitching** (alternative): Merge multiple schemas at the gateway level using `mergeSchemas()` and custom resolvers to bridge types across services.

---

## Part 3: gRPC Service Design

### When to Use gRPC Over REST/GraphQL

- Internal microservice-to-microservice communication
- Need high throughput / low latency (binary protocol, HTTP/2 multiplexing)
- Strong typing with schema contracts (protobuf)
- Streaming (bidirectional) communication

### Service Definition

```protobuf
syntax = "proto3";
package userservice;

service UserService {
  // Unary RPC
  rpc GetUser(GetUserRequest) returns (User);
  
  // Server streaming
  rpc ListUsers(ListUsersRequest) returns (stream User);
  
  // Client streaming
  rpc UploadUsers(stream User) returns (UploadResponse);
  
  // Bidirectional streaming
  rpc Chat(stream ChatMessage) returns (stream ChatMessage);
}

message User {
  string id = 1;
  string name = 2;
  string email = 3;
  google.protobuf.Timestamp created_at = 4;
}

message GetUserRequest {
  string id = 1;
}

message ListUsersRequest {
  int32 page_size = 1;
  string page_token = 2;
}
```

### gRPC Design Principles
- Use consistent naming: `PascalCase` for messages, `PascalCase` for services, `camelCase` for fields
- Always use `proto3` with explicit field numbers
- Use `google.protobuf.Timestamp` and `google.protobuf.Duration` instead of raw types
- Version your proto files: `package myservice.v1;`
- Use `reserved` for removed field numbers to prevent reuse
- Implement health checks via `grpc.health.v1.Health`
- Use interceptors/middleware for cross-cutting concerns (auth, logging, metrics)

---

## Part 4: API Versioning Strategies

### Strategy 1: URL Path Versioning (Recommended for Public APIs)
```
/api/v1/users
/api/v2/users
```
Pros: Simple, explicit, easy to route and document. Cons: URL proliferation.

### Strategy 2: Header Versioning
```
Accept: application/vnd.myapi.v2+json
X-API-Version: 2
```
Pros: Clean URLs. Cons: Less discoverable, harder to test in browser.

### Strategy 3: Query Parameter Versioning
```
/api/users?version=2
```
Pros: Easy to implement. Cons: Pollutes URLs, easy to forget.

### Strategy 4: Content Negotiation
```
Accept: application/json; version=2
```

### Versioning Best Practices
- Deprecate, don't remove: keep old versions running with deprecation headers
- Use `Sunset` header (RFC 8594): `Sunset: Sat, 01 Jun 2025 00:00:00 GMT`
- Use `Deprecation` header: `Deprecation: true`
- Document migration guides for major version bumps
- Semantic versioning: bump version for breaking changes, not additions

---

## Part 5: Rate Limiting Algorithms

### Token Bucket
- Bucket holds N tokens, refills at rate R per second
- Each request consumes 1 token
- If bucket is empty, request is rejected/queued
- Allows bursts up to bucket size while enforcing average rate

```python
class TokenBucket:
    def __init__(self, capacity: int, refill_rate: float):
        self.capacity = capacity
        self.tokens = capacity
        self.refill_rate = refill_rate  # tokens per second
        self.last_refill = time.time()
    
    def allow(self) -> bool:
        self._refill()
        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False
    
    def _refill(self):
        now = time.time()
        elapsed = now - self.last_refill
        self.tokens = min(self.capacity, self.tokens + elapsed * self.refill_rate)
        self.last_refill = now
```

### Sliding Window Log
- Store timestamp of each request in a sorted set
- On new request: remove timestamps older than window, count remaining
- If count < limit, allow; else reject
- Exact but memory-intensive (stores every request timestamp)

### Sliding Window Counter
- Hybrid of fixed window and sliding window
- Weighted count = previous window count * overlap% + current window count
- More memory efficient than sliding window log

### Leaky Bucket
- Requests enter a queue (bucket), processed at fixed rate
- If queue is full, new requests are rejected
- Produces smooth, constant-rate output regardless of input burstiness
- Good for protecting downstream services

### Fixed Window Counter
- Divide time into fixed windows (e.g., 1-minute intervals)
- Count requests per window, reject when count > limit
- Simple but suffers from burst at window boundaries

### Rate Limit Response Headers
```
X-RateLimit-Limit: 100          # Max requests per window
X-RateLimit-Remaining: 42       # Remaining in current window
X-RateLimit-Reset: 1705312800   # Unix timestamp when window resets
Retry-After: 30                 # Seconds to wait (on 429)
```

### Rate Limit Response
```json
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Try again in 30 seconds.",
    "retry_after": 30
  }
}
```

---

## Part 6: API Gateway Patterns

An API Gateway sits between clients and services, handling cross-cutting concerns:

```
Client → API Gateway → Service A
                    → Service B
                    → Service C
```

### Responsibilities
| Concern | Implementation |
|---------|---------------|
| Routing | Forward requests to appropriate backend service |
| Authentication | Validate JWT/API keys at the edge |
| Rate Limiting | Apply per-client or per-endpoint limits |
| Request Transformation | Modify headers, body, or path before forwarding |
| Response Caching | Cache responses for frequently accessed endpoints |
| Load Balancing | Distribute traffic across service instances |
| Circuit Breaking | Stop forwarding to failing services |
| API Composition | Aggregate responses from multiple services |
| Protocol Translation | REST ↔ gRPC, WebSocket ↔ HTTP |
| Logging & Monitoring | Centralized request logging and metrics |

### API Gateway Implementation Patterns
- **Kong**: Nginx-based, plugin architecture
- **AWS API Gateway**: Managed, serverless-friendly
- **Envoy / Istio**: Service mesh approach for microservices
- **Custom**: Express/Fastify middleware chain

---

## Part 7: Error Handling

### Standard Error Response
```json
{
  "error": {
    "type": "https://api.example.com/errors/validation-error",
    "code": "VALIDATION_ERROR",
    "message": "The request body contains invalid fields.",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Must be a valid email address."
      },
      {
        "field": "age",
        "code": "OUT_OF_RANGE",
        "message": "Must be between 0 and 150."
      }
    ],
    "request_id": "req_abc123"
  }
}
```

### Standard Status Codes
| Code | Usage | When to Use |
|------|-------|-------------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 202 | Accepted | Async operation started |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Malformed syntax, missing required fields |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but not permitted |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource, state conflict |
| 422 | Unprocessable Entity | Valid syntax but semantic errors |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server failure |
| 502 | Bad Gateway | Upstream service unavailable |
| 503 | Service Unavailable | Maintenance or overload |
| 504 | Gateway Timeout | Upstream service timeout |

### RFC 7807 Problem Details
```json
{
  "type": "https://api.example.com/errors/out-of-credit",
  "title": "Out of Credit",
  "status": 403,
  "detail": "Your account has insufficient credit to complete this operation.",
  "instance": "/accounts/12345/transactions/abc",
  "balance": 30,
  "accounts": ["/accounts/12345", "/accounts/67890"]
}
```

---

## Part 8: Request/Response Best Practices

### Consistent Field Naming
- **camelCase** (recommended for JSON APIs): `created_at` → `createdAt`
- **snake_case** (Rails/Python convention): keep `created_at`
- Pick one and stick with it across the entire API

### Standard Resource Fields
```json
{
  "id": "123",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "type": "user"
}
```

### Filtering Patterns
```
GET /users?status=active
GET /users?created_after=2024-01-01
GET /users?age_min=18&age_max=65
GET /users?search=john
GET /users?sort=-created_at,name    # - prefix for descending
```

### Bulk Operations
```json
POST /api/v1/users/batch
{
  "operations": [
    { "method": "create", "data": { "name": "Alice" } },
    { "method": "create", "data": { "name": "Bob" } }
  ]
}

// Response
{
  "results": [
    { "status": "created", "data": { "id": "1", "name": "Alice" } },
    { "status": "created", "data": { "id": "2", "name": "Bob" } }
  ]
}
```

---

## Part 9: Real-World API Examples

### Stripe-Like API Design Principles
- Idempotency keys on all POST requests: `Idempotency-Key: unique-key`
- Expandable nested objects: `?expand[]=data.customer`
- Version pinning via header: `Stripe-Version: 2024-01-01`
- List endpoints return `has_more` boolean (cursor-based)
- Resources have metadata: `metadata: { key: "value" }`
- Events for webhook integration: `evt_1234`
- Consistent resource IDs with type prefix: `cus_`, `ch_`, `sub_`

### GitHub-Like API Design Principles
- HATEOAS links in responses (`_links` object)
- Conditional requests with ETags: `If-None-Match: "abc123"`
- Pagination via Link header with `rel="next"` and `rel="prev"`
- Preview headers for experimental features: `Accept: application/vnd.github.v3+json`
- Rate limiting with `X-RateLimit-*` headers
- Resource embedding: `?per_page=5&page=1`
- Partial responses via `?fields=name,email`

### OpenAI-Like API Design
- Streaming responses via SSE (Server-Sent Events)
- Token-based billing reflected in response: `usage: { prompt_tokens, completion_tokens, total_tokens }`
- Model-specific endpoints: `/v1/chat/completions`, `/v1/embeddings`
- Async support: return `id` immediately, poll for completion

---

## Part 10: OpenAPI Specification

Generate OpenAPI 3.1 specs for documentation and code generation:

```yaml
openapi: 3.1.0
info:
  title: My API
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive]
        - name: page
          in: query
          schema:
            type: integer
            default: 1
      responses:
        '200':
          description: Paginated list of users
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
    post:
      summary: Create a user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        email:
          type: string
          format: email
```

---

## Output Format

```
## API Design

**Type:** [REST / GraphQL / gRPC]
**Base URL:** [e.g., /api/v1]
**Maturity Level:** [Richardson Level 1-3]

### Resources
| Resource | Endpoints | Description |
|----------|-----------|-------------|
| Users | GET, POST /users; GET, PUT, DELETE /users/:id | ... |

### Pagination Strategy
[Cursor-based / Offset-based / Hybrid]

### Rate Limiting
[Algorithm, limits per tier]

### Versioning
[Strategy, deprecation policy]

### Example Request/Response
[Detailed request and response examples with headers]

### Error Format
[JSON error structure with RFC 7807 compliance]

### OpenAPI Spec
[Full OpenAPI specification if requested]

### Notes
- [Authentication approach, versioning, pagination, etc.]
```

## Rules

- Match the user's specified style (REST, GraphQL, or gRPC). If they don't specify, default to REST.
- Be consistent within the design — don't mix naming conventions.
- Don't over-design. If the user needs 5 endpoints, don't design 20.
- If the user has an existing API, read it first and propose improvements that maintain backward compatibility.
- Design for the client's needs, not theoretical purity.
- Always include error handling and pagination in the design.
- Present the response in the user's language; keep code, URLs, and technical terms in English.
- Prefer cursor-based pagination for large datasets and mobile clients.
- Include rate limiting headers in every API design.
- Design API responses for the frontend's actual consumption patterns.
