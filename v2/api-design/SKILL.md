---
name: api-design
description: >-
  Design RESTful APIs and GraphQL schemas with proper resource modeling, endpoint naming, status codes, versioning, authentication, pagination, error handling, and documentation. Use this skill when the user asks to design an API, طراحی API, REST API design, GraphQL schema, API endpoints, API structure, resource modeling, design my API, API best practices, API versioning, authentication flow, pagination design, error response format, openAPI spec, swagger, endpoint naming, HTTP methods, طراحی Endpoints, ساختار API, اسکیمای GraphQL, مستندسازی API, design REST API, design GraphQL, API contract, resource naming, HTTP status codes, query parameters, request validation, response format, API documentation, OpenAPI, Swagger, API gateway, rate limiting, API security, CORS, HATEOAS, webhook design, API versioning strategy, pagination strategy, error handling pattern, 设计API, REST接口设计, GraphQL设计, API文档, 接口设计, 端点命名.
---

# API Design Skill

## Overview

This skill designs well-structured APIs — RESTful HTTP APIs and GraphQL schemas. A good API is intuitive, consistent, and hard to misuse. The focus is on practical design decisions: resource naming, request/response formats, error handling, versioning, and documentation.

API design is a UX problem for developers. Your consumers are other developers (or your future self). A well-designed API needs minimal documentation because it's self-descriptive through consistent conventions.

## When to Use This Skill

- User wants to design a new API or API endpoints
- User asks about REST conventions, GraphQL schema design, or API best practices
- User needs an OpenAPI/Swagger specification
- User wants to restructure an existing API
- User asks about API versioning, authentication, or pagination strategies
- User wants to design webhooks or event-driven APIs
- User asks about rate limiting, CORS, or API security patterns
- User needs to design error response formats
- User asks about HATEOAS or hypermedia APIs
- User wants to design internal microservice APIs
- User needs API documentation structure
- User asks about filtering, sorting, or field selection in APIs
- User wants to design a public API (for third-party consumers)

## REST API Design Workflow

### Step 1: Identify Resources

From the user's description, extract the core entities:
- What are the main nouns? (users, orders, products, posts)
- What relationships exist between them?
- What actions can be performed on each?
- Which resources are read-mostly vs. write-heavy?
- Are there sub-resources (e.g., orders belong to users)?

### Step 2: Design Endpoints

Follow REST conventions:

| Action | Method | Path | Status | Notes |
|--------|--------|------|--------|-------|
| List | GET | /resources | 200 | Support filtering, sorting, pagination |
| Get one | GET | /resources/:id | 200 / 404 | Return 404 if not found |
| Create | POST | /resources | 201 | Return created resource with Location header |
| Update (full) | PUT | /resources/:id | 200 / 404 | Return updated resource |
| Update (partial) | PATCH | /resources/:id | 200 / 404 | Only include changed fields |
| Delete | DELETE | /resources/:id | 204 / 404 | Return 204 No Content |

Rules for endpoint design:
- Use **plural nouns** for resource names: `/users` not `/user`
- Use **kebab-case** for multi-word resources: `/user-profiles`
- Nest only when there's a true ownership relationship: `/users/:id/orders` not `/orders/by-user/:userId`
- Avoid verbs in URLs: use HTTP methods to express actions
- Use query parameters for filtering, sorting, and pagination
- Keep URLs predictable: if `/users` lists users, `/users/:id` gets one user

### Step 3: Define Request/Response Formats

- Use consistent field naming (camelCase for JSON APIs, snake_case if the team prefers)
- Include `id`, `created_at`, `updated_at` on all resources
- Use ISO 8601 for dates: `2024-01-15T10:30:00Z`
- Use ISO 4217 for currencies: `USD`, `EUR`
- Use IANA timezones: `America/New_York`
- Support pagination: `?page=1&limit=20` with metadata in response
- Support filtering: `?status=active&category=electronics`
- Support sorting: `?sort=-created_at,name` (prefix `-` for descending)
- Support field selection: `?fields=id,name,email`

### Step 4: Define Error Format

Use a consistent error response structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [
      {"field": "email", "message": "Invalid email format"}
    ]
  }
}
```

Standard status codes:
- 200: Success
- 201: Created
- 204: Deleted (no content)
- 400: Bad request / validation error
- 401: Unauthenticated
- 403: Unauthorized (authenticated but not allowed)
- 404: Not found
- 409: Conflict (duplicate, state conflict)
- 422: Unprocessable entity
- 429: Too many requests (rate limited)
- 500: Internal server error
- 502: Bad gateway (upstream failure)
- 503: Service unavailable (maintenance/overload)

### Step 5: Address Cross-Cutting Concerns

- **Versioning:** `/api/v1/resources` (URL path) or `Accept: application/vnd.api.v1+json` (header)
- **Authentication:** Bearer token (JWT), API key, or OAuth 2.0 — specify the flow
- **Rate limiting:** Include `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` headers
- **CORS:** Specify allowed origins, methods, and headers
- **Idempotency:** POST (not idempotent) vs PUT/DELETE (idempotent). For idempotent POSTs, use `Idempotency-Key` header.
- **Caching:** Use `ETag`, `Last-Modified`, and `Cache-Control` headers for GET endpoints
- **Compression:** Support `Accept-Encoding: gzip` for large responses

## GraphQL Schema Workflow

1. Identify types and their fields.
2. Define queries (reads) and mutations (writes).
3. Model relationships with types and connections.
4. Add input types for mutation arguments.
5. Define error handling strategy (union types or error field on responses).
6. Design pagination with Relay-style connections or simple cursor-based pagination.
7. Consider N+1 prevention with DataLoader or batched resolvers.

## Advanced Techniques

### Pagination Strategies

| Strategy | Best For | Trade-offs |
|----------|----------|------------|
| Offset (`?page=1&limit=20`) | Small datasets, UI with page numbers | Inconsistent with real-time inserts/deletes |
| Cursor (`?cursor=abc&limit=20`) | Large datasets, infinite scroll | No random page access, slightly more complex |
| Keyset (`?after_id=100&limit=20`) | Very large tables, consistent ordering | Requires a unique, sortable column |

### Webhook Design
- Use HTTPS with TLS verification
- Include a secret for HMAC signature verification
- Retry with exponential backoff (3-5 retries)
- Include the event type and timestamp in the payload
- Document the expected response (200 = success, any other = retry)
- Support a webhook testing/verification endpoint

### Rate Limiting Strategies
- **Fixed window**: X requests per minute (simple but has burst at window boundaries)
- **Sliding window**: X requests per any 60-second window (smoother)
- **Token bucket**: Burst allowed, steady rate enforced (best for APIs)
- **Per-user vs per-IP**: Choose based on authentication model

### API Gateway Patterns
- **BFF (Backend for Frontend)**: One API per client type (web, mobile, partner)
- **Aggregation**: Combine multiple internal APIs into one external response
- **Rate limiting at gateway**: Centralized rate limiting before hitting services
- **Circuit breaker**: Fail fast when upstream services are down

## Common Patterns

### Pattern 1: The Nested Resource Decision
When to nest vs. when to flatten.
```
// Nest when: strong ownership, sub-resource makes no sense without parent
//   /users/:userId/orders  ✓ (orders belong to a user)
// Don't nest when: weak relationship, both resources are independent
//   /categories/:categoryId/products  ✗ (use /products?category=categoryId)
```

### Pattern 2: The Action Endpoint
For actions that don't map to CRUD.
```
// POST /orders/:id/cancel  (not DELETE /orders/:id which means remove the record)
// POST /users/:id/activate
// POST /payments/:id/refund
// Rule: noun/verb pattern for non-CRUD actions, always POST
```

### Pattern 3: The Consistent Response Envelope
Wrapping all responses in a standard structure.
```json
{
  "data": {},
  "meta": { "page": 1, "total": 100, "total_pages": 10 },
  "errors": []
}
```

### Pattern 4: The Soft Delete Consideration
Whether to DELETE or mark as deleted.
```
// DELETE /resources/:id → returns 204 (hard delete, gone forever)
// PATCH /resources/:id → { "status": "archived" } (soft delete, recoverable)
// Choose based on: regulatory requirements, referential integrity, user expectations
```

### Pattern 5: The Batch Operations
For operations affecting multiple resources.
```
// POST /orders/batch-cancel  { "order_ids": ["a", "b", "c"] }
// PATCH /users/batch  { "updates": [{ "id": "a", "role": "admin" }] }
// Limit batch sizes (e.g., max 100) to prevent abuse and timeouts
```

## Edge Cases & Pitfalls

1. **Over-nesting URLs** — More than 2 levels deep is usually a sign to flatten or restructure.
2. **Inconsistent naming** — Mixing `user_id` and `userId` in the same API confuses consumers.
3. **Ignoring idempotency** — Non-idempotent GET requests (e.g., GET /create-user) break HTTP semantics and caching.
4. **Leaking internal IDs** — Exposing database auto-increment IDs reveals business metrics and allows enumeration.
5. **Missing pagination** — An unbounded list endpoint will eventually cause OOM or timeout as data grows.
6. **Over-engineering versioning** — Most APIs never need v2. Don't add versioning complexity until you actually need it.
7. **Inconsistent error codes** — Using 500 for everything makes debugging impossible. Use specific status codes.
8. **Not validating input** — Trusting client input leads to data corruption, crashes, and security vulnerabilities.
9. **Ignoring content negotiation** — Not supporting `Accept` headers or always returning JSON even when the client wants XML.
10. **Breaking changes without version bump** — Adding required fields, removing fields, or changing types without versioning breaks consumers.
11. **No rate limiting** — Without rate limiting, any client can exhaust server resources.
12. **Ignoring CORS for browser clients** — Browser-based consumers need proper CORS headers or requests will be blocked.
13. **Exposing too much data** — Returning all fields including internal ones (passwords, tokens, PII) in list endpoints.
14. **Not considering async operations** — Long-running operations should return 202 Accepted with a status check endpoint.

## Integration with Other Skills

- **api-integration**: When implementing the designed API, use api-integration for client code.
- **code-review**: Review API implementation against the design for consistency.
- **security-audit**: Before launching a public API, audit for security vulnerabilities.
- **documentation**: Generate API documentation (OpenAPI/Swagger) from the design.
- **clean-architecture**: API endpoints are interface adapters that route to application use cases.
- **database-schema**: API design may reveal schema requirements for the underlying data model.
- **test-generation**: Generate tests for API endpoints based on the designed contract.
- **version-management**: Track API version changes and communicate breaking changes.

## Output Format

### Full REST API Design Template

```
## API Design

**Type:** [REST / GraphQL]
**Base URL:** [e.g., /api/v1]
**Authentication:** [Bearer JWT / API Key / OAuth 2.0]

### Resources
| Resource | Endpoints | Description |
|----------|-----------|-------------|
| Users | GET, POST /users; GET, PUT, PATCH, DELETE /users/:id | ... |

### Endpoints
#### GET /users
- **Description:** List all users
- **Query Params:** `?page`, `?limit`, `?sort`, `?status`, `?fields`
- **Response:** 200 with paginated user list

#### POST /users
- **Description:** Create a new user
- **Request Body:** `{ "name": "...", "email": "..." }`
- **Response:** 201 with created user, `Location: /api/v1/users/123`

### Example Request/Response
```http
GET /api/v1/users/123
Authorization: Bearer <token>
```
```json
{
  "id": "123",
  "name": "Alice",
  "email": "alice@example.com",
  "created_at": "2024-01-15T10:30:00Z"
}
```

### Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request body is invalid",
    "details": [
      {"field": "email", "message": "Must be a valid email address"}
    ]
  }
}
```

### Cross-Cutting
- **Versioning:** URL path `/api/v1/`
- **Rate Limiting:** 100 req/min per user, headers: X-RateLimit-*
- **Pagination:** Cursor-based with `?cursor` and `?limit`
- **Caching:** ETag-based for GET endpoints, 60s TTL
```

### GraphQL Schema Template

```
## GraphQL Schema

### Types
```graphql
type User {
  id: ID!
  name: String!
  email: String!
  orders: OrderConnection!
}

type Order {
  id: ID!
  user: User!
  total: Float!
  status: OrderStatus!
  createdAt: DateTime!
}
```

### Queries & Mutations
```graphql
type Query {
  user(id: ID!): User
  users(first: Int, after: String): UserConnection
}

type Mutation {
  createOrder(input: CreateOrderInput!): Order
  cancelOrder(id: ID!): Order
}
```
```

### Quick API Suggestion Template

```
**For your [resource], use:**
- `GET /resources` — list
- `POST /resources` — create
- `GET /resources/:id` — get one
- `PUT /resources/:id` — update
- `DELETE /resources/:id` — delete

**Note:** [any specific considerations]
```

## Rules

- Match the user's specified style (REST or GraphQL). If they don't specify, default to REST.
- Be consistent within the design — don't mix naming conventions.
- Don't over-design. If the user needs 5 endpoints, don't design 20.
- If the user has an existing API, read it first and propose improvements that maintain backward compatibility.
- Present the response in the user's language; keep code, URLs, and technical terms in English.
- Every endpoint must have an example request and response.
- Always include error cases in the design, not just happy paths.
- Consider backward compatibility for any changes to existing APIs.
- Use standard HTTP status codes correctly — don't invent new ones.
