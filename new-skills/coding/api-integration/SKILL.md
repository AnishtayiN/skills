---
name: api-integration
description: >-
  English: API integration with external services, REST clients, GraphQL queries, WebSocket connections, gRPC services, Server-Sent Events (SSE), OAuth 2.0 authentication, JWT token handling, API key management, webhook implementation, rate limiting, circuit breaker pattern, idempotency, retry with exponential backoff, response validation with Zod, OpenAPI code generation.
  Farsi: اتصال API با سرویس‌های خارجی، کلاینت‌های REST، کوئری‌های GraphQL، اتصالات WebSocket، سرویس‌های gRPC، رویدادهای سمت سرور (SSE)، احراز هویت OAuth 2.0، مدیریت توکن JWT، مدیریت کلید API، پیاده‌سازی وب‌هوک، محدودیت نرخ، الگوی مدار شکن، عدم وابستگی، تلاش مجدد با پشتیبانی نمایی، اعتبارسنجی پاسخ با Zod.
  Chinese: API集成与外部服务，REST客户端，GraphQL查询，WebSocket连接，gRPC服务，服务端事件(SSE)，OAuth 2.0认证，JWT令牌处理，API密钥管理，Webhook实现，速率限制，断路器模式，幂等性，指数退避重试，Zod响应验证，OpenAPI代码生成。
---

# API Integration

## Overview

API integration is the process of connecting software applications with external services through standardized interfaces. This skill covers the complete lifecycle of building robust, secure, and maintainable API integrations—from authentication and request design to error handling, resilience patterns, and code generation. Modern applications rarely exist in isolation; they consume and expose APIs for authentication, payments, messaging, data enrichment, and countless other capabilities.

This skill provides battle-tested patterns for integrating with REST, GraphQL, WebSocket, gRPC, and SSE endpoints. It emphasizes production-grade concerns: authentication (OAuth 2.0, JWT, API keys), resilience (retry with exponential backoff, circuit breaker), correctness (idempotency, response validation), and developer experience (OpenAPI code generation, typed clients).

## When to Use This Skill

- Consuming third-party REST, GraphQL, or gRPC APIs
- Implementing OAuth 2.0 flows or JWT-based authentication
- Building webhook receivers and processors
- Creating typed API clients from OpenAPI/GraphQL schemas
- Implementing resilience patterns (retry, circuit breaker, rate limiting)
- Validating API responses at runtime with Zod or similar schemas
- Setting up WebSocket or SSE connections for real-time data
- Designing idempotent API operations for reliability
- Integrating payment gateways, email services, or cloud providers
- Building API gateways or proxy layers

## When NOT to Use This Skill

- Building purely internal functions with no external dependencies
- Simple database CRUD without external service calls
- Static site generation without API calls
- CLI tools that read/write local files only
- When the "API" is just a library import (use that library's docs directly)

## Workflow

### Phase 1: Discovery and Design

1. **Identify the target API**: Gather endpoint URLs, authentication requirements, rate limits, and data formats
2. **Review documentation**: Read the official API docs, OpenAPI specs, or GraphQL schema
3. **Choose protocol**: REST for resource-oriented APIs, GraphQL for flexible queries, WebSocket for real-time, gRPC for high-performance, SSE for server-push
4. **Design the integration layer**: Define interfaces, error types, and response shapes
5. **Plan authentication**: Determine OAuth 2.0 flow type, JWT handling, or API key management

### Phase 2: Authentication Setup

1. **OAuth 2.0**: Implement authorization code, client credentials, or PKCE flows
2. **JWT**: Handle token acquisition, refresh, storage, and expiry detection
3. **API Keys**: Secure storage, rotation, and request header injection
4. **Token management**: Build token refresh queues, secure storage (not localStorage), and automatic renewal

### Phase 3: Client Implementation

1. **HTTP client**: Configure base URL, timeouts, headers, interceptors
2. **Request builders**: Create typed request/response objects
3. **Error handling**: Define error taxonomy (network, auth, validation, rate limit, server)
4. **Resilience**: Add retry logic, circuit breaker, rate limit awareness
5. **Response validation**: Validate and transform responses with Zod schemas

### Phase 4: Integration Testing

1. **Mock servers**: Set up MSW or WireMock for deterministic tests
2. **Contract tests**: Verify API contracts against mock or real endpoints
3. **Error simulation**: Test network failures, rate limits, auth expiry
4. **Load testing**: Verify rate limiting and circuit breaker behavior under load

### Phase 5: Monitoring and Maintenance

1. **Logging**: Structured logs for requests, responses, and errors
2. **Metrics**: Track latency, error rates, retry counts, circuit state
3. **Alerting**: Set up alerts for elevated error rates or degraded performance
4. **Schema drift detection**: Monitor for upstream API changes

## Advanced Techniques

### 1. Circuit Breaker Pattern

Prevent cascading failures by stopping requests to a failing service.

```typescript
class CircuitBreaker {
  private state: 'closed' | 'open' | 'half-open' = 'closed';
  private failureCount = 0;
  private lastFailureTime = 0;
  private readonly failureThreshold = 5;
  private readonly recoveryTimeout = 30000; // 30 seconds

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'open') {
      if (Date.now() - this.lastFailureTime > this.recoveryTimeout) {
        this.state = 'half-open';
      } else {
        throw new CircuitOpenError('Circuit is open');
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess(): void {
    this.failureCount = 0;
    this.state = 'closed';
  }

  private onFailure(): void {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    if (this.failureCount >= this.failureThreshold) {
      this.state = 'open';
    }
  }
}
```

```python
import time
from enum import Enum
from typing import Callable, TypeVar

T = TypeVar('T')

class CircuitState(Enum):
    CLOSED = 'closed'
    OPEN = 'open'
    HALF_OPEN = 'half-open'

class CircuitBreaker:
    def __init__(self, failure_threshold: int = 5, recovery_timeout: int = 30):
        self.state = CircuitState.CLOSED
        self.failure_count = 0
        self.last_failure_time = 0
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout

    async def execute(self, fn: Callable[..., T], *args, **kwargs) -> T:
        if self.state == CircuitState.OPEN:
            if time.time() - self.last_failure_time > self.recovery_timeout:
                self.state = CircuitState.HALF_OPEN
            else:
                raise CircuitOpenError("Circuit is open")

        try:
            result = await fn(*args, **kwargs)
            self._on_success()
            return result
        except Exception as e:
            self._on_failure()
            raise

    def _on_success(self):
        self.failure_count = 0
        self.state = CircuitState.CLOSED

    def _on_failure(self):
        self.failure_count += 1
        self.last_failure_time = time.time()
        if self.failure_count >= self.failure_threshold:
            self.state = CircuitState.OPEN
```

### 2. Retry with Exponential Backoff and Jitter

```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxRetries = 5,
  baseDelay = 1000,
  maxDelay = 30000
): Promise<T> {
  let lastError: Error;
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;
      if (attempt === maxRetries) break;
      if (!isRetryableError(error)) throw error;

      const exponentialDelay = Math.min(baseDelay * Math.pow(2, attempt), maxDelay);
      const jitter = exponentialDelay * 0.1 * Math.random();
      const delay = exponentialDelay + jitter;
      await new Promise(r => setTimeout(r, delay));
    }
  }
  throw lastError!;
}

function isRetryableError(error: unknown): boolean {
  if (error instanceof Response) {
    return [408, 429, 500, 502, 503, 504].includes(error.status);
  }
  if (error instanceof TypeError) {
    return error.message.includes('fetch');
  }
  return false;
}
```

### 3. OAuth 2.0 Authorization Code Flow with PKCE

```typescript
import crypto from 'crypto';

class OAuth2PKCE {
  private codeVerifier: string;
  private codeChallenge: string;

  constructor(private config: {
    clientId: string;
    authorizationEndpoint: string;
    tokenEndpoint: string;
    redirectUri: string;
    scopes: string[];
  }) {
    this.codeVerifier = this.generateCodeVerifier();
    this.codeChallenge = this.generateCodeChallenge(this.codeVerifier);
  }

  private generateCodeVerifier(): string {
    return crypto.randomBytes(32).toString('base64url');
  }

  private generateCodeChallenge(verifier: string): string {
    return crypto.createHash('sha256').update(verifier).digest('base64url');
  }

  getAuthorizationUrl(): string {
    const params = new URLSearchParams({
      response_type: 'code',
      client_id: this.config.clientId,
      redirect_uri: this.config.redirectUri,
      scope: this.config.scopes.join(' '),
      code_challenge: this.codeChallenge,
      code_challenge_method: 'S256',
      state: crypto.randomBytes(16).toString('hex'),
    });
    return `${this.config.authorizationEndpoint}?${params}`;
  }

  async exchangeCode(code: string): Promise<TokenSet> {
    const response = await fetch(this.config.tokenEndpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'authorization_code',
        code,
        redirect_uri: this.config.redirectUri,
        client_id: this.config.clientId,
        code_verifier: this.codeVerifier,
      }),
    });
    return response.json();
  }
}
```

### 4. Idempotency Key Implementation

```typescript
import { v4 as uuid } from 'uuid';

class IdempotentClient {
  private processedKeys = new Map<string, { status: number; body: unknown }>();
  private ttl = 24 * 60 * 60 * 1000; // 24 hours

  async post(url: string, body: unknown, idempotencyKey?: string): Promise<Response> {
    const key = idempotencyKey || uuid();

    // Check cache
    const cached = this.processedKeys.get(key);
    if (cached) {
      return new Response(JSON.stringify(cached.body), {
        status: cached.status,
        headers: { 'X-Idempotent-Replayed': 'true' },
      });
    }

    // Execute
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Idempotency-Key': key,
      },
      body: JSON.stringify(body),
    });

    // Cache result
    const responseBody = await response.clone().json();
    this.processedKeys.set(key, {
      status: response.status,
      body: responseBody,
    });

    // Cleanup after TTL
    setTimeout(() => this.processedKeys.delete(key), this.ttl);

    return response;
  }
}
```

### 5. GraphQL Query Builder with Type Safety

```typescript
import { z } from 'zod';

interface GraphQLQuery<TVariables = Record<string, unknown>> {
  query: string;
  variables?: TVariables;
}

class TypedGraphQLClient {
  constructor(
    private endpoint: string,
    private headers: Record<string, string> = {}
  ) {}

  async query<TResponse, TVariables = Record<string, unknown>>(
    gql: GraphQLQuery<TVariables>,
    schema: z.ZodSchema<TResponse>
  ): Promise<TResponse> {
    const response = await fetch(this.endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...this.headers,
      },
      body: JSON.stringify(gql),
    });

    const json = await response.json();

    if (json.errors) {
      throw new GraphQLError(json.errors);
    }

    return schema.parse(json.data);
  }
}

// Usage
const UserSchema = z.object({
  user: z.object({
    id: z.string(),
    name: z.string(),
    email: z.string().email(),
    posts: z.array(z.object({
      id: z.string(),
      title: z.string(),
      publishedAt: z.string().nullable(),
    })),
  }),
});

type UserResponse = z.infer<typeof UserSchema>;

const client = new TypedGraphQLClient('https://api.example.com/graphql', {
  Authorization: 'Bearer token',
});

const result = await client.query<UserResponse>(
  {
    query: `query GetUser($id: ID!) {
      user(id: $id) {
        id
        name
        email
        posts {
          id
          title
          publishedAt
        }
      }
    }`,
    variables: { id: '123' },
  },
  UserSchema
);
```

### 6. WebSocket Connection Manager with Reconnection

```typescript
class WebSocketManager {
  private ws: WebSocket | null = null;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 10;
  private baseDelay = 1000;
  private listeners = new Map<string, Set<(data: unknown) => void>>();

  constructor(private url: string, private protocols?: string | string[]) {}

  connect(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(this.url, this.protocols);

      this.ws.onopen = () => {
        this.reconnectAttempts = 0;
        resolve();
      };

      this.ws.onmessage = (event) => {
        const data = JSON.parse(event.data);
        const type = data.type || 'message';
        this.listeners.get(type)?.forEach(fn => fn(data));
      };

      this.ws.onclose = (event) => {
        if (!event.wasClean) {
          this.reconnect();
        }
      };

      this.ws.onerror = (error) => {
        reject(error);
      };
    });
  }

  private reconnect(): void {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      this.emit('reconnect_failed', {});
      return;
    }

    const delay = Math.min(
      this.baseDelay * Math.pow(2, this.reconnectAttempts),
      30000
    );
    const jitter = delay * 0.1 * Math.random();

    setTimeout(() => {
      this.reconnectAttempts++;
      this.connect().catch(() => {});
    }, delay + jitter);
  }

  on(type: string, callback: (data: unknown) => void): void {
    if (!this.listeners.has(type)) {
      this.listeners.set(type, new Set());
    }
    this.listeners.get(type)!.add(callback);
  }

  private emit(type: string, data: unknown): void {
    this.listeners.get(type)?.forEach(fn => fn(data));
  }

  send(data: unknown): void {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(data));
    }
  }

  close(): void {
    this.ws?.close(1000, 'Client closing');
    this.reconnectAttempts = this.maxReconnectAttempts;
  }
}
```

### 7. OpenAPI Code Generation Pipeline

```typescript
// Generate typed client from OpenAPI spec
// Run: npx openapi-typescript https://api.example.com/openapi.json -o src/types/api.d.ts

import { createClient } from '@openapi-fetch';
import type { paths } from './types/api.d.ts';
import { z } from 'zod';

// Runtime validation schema for a specific endpoint
const ListUsersSchema = z.object({
  data: z.array(z.object({
    id: z.string().uuid(),
    name: z.string(),
    email: z.string().email(),
    role: z.enum(['admin', 'user', 'viewer']),
  })),
  pagination: z.object({
    page: z.number(),
    perPage: z.number(),
    total: z.number(),
  }),
});

type ListUsersResponse = z.infer<typeof ListUsersSchema>;

export function createApiClient(baseUrl: string, apiKey: string) {
  const client = createClient<paths>({
    baseUrl,
    headers: {
      'X-API-Key': apiKey,
    },
  });

  return {
    async listUsers(params?: { page?: number; perPage?: number }): Promise<ListUsersResponse> {
      const { data, error } = await client.GET('/api/users', {
        params: { query: params },
      });

      if (error) throw new ApiError(error);
      return ListUsersSchema.parse(data);
    },
  };
}
```

## Common Patterns

### Pattern 1: Typed HTTP Client with Interceptors

```typescript
// TypeScript
interface RequestConfig {
  url: string;
  method: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';
  headers?: Record<string, string>;
  body?: unknown;
  params?: Record<string, string | number>;
  timeout?: number;
}

interface ResponseInterceptor {
  onFulfilled: (response: Response) => Promise<Response> | Response;
  onRejected?: (error: unknown) => unknown;
}

class TypedHttpClient {
  private interceptors: ResponseInterceptor[] = [];
  private baseURL: string;
  private defaultHeaders: Record<string, string>;

  constructor(baseURL: string, defaultHeaders: Record<string, string> = {}) {
    this.baseURL = baseURL;
    this.defaultHeaders = defaultHeaders;
  }

  addInterceptor(interceptor: ResponseInterceptor): void {
    this.interceptors.push(interceptor);
  }

  async request<T>(config: RequestConfig): Promise<T> {
    const url = new URL(config.url, this.baseURL);

    if (config.params) {
      Object.entries(config.params).forEach(([key, value]) => {
        url.searchParams.set(key, String(value));
      });
    }

    const response = await fetch(url.toString(), {
      method: config.method,
      headers: {
        'Content-Type': 'application/json',
        ...this.defaultHeaders,
        ...config.headers,
      },
      body: config.body ? JSON.stringify(config.body) : undefined,
      signal: AbortSignal.timeout(config.timeout || 30000),
    });

    let finalResponse = response;
    for (const interceptor of this.interceptors) {
      finalResponse = await interceptor.onFulfilled(finalResponse);
    }

    if (!finalResponse.ok) {
      throw new ApiError(finalResponse.status, await finalResponse.json());
    }

    return finalResponse.json();
  }

  get<T>(url: string, params?: Record<string, string | number>): Promise<T> {
    return this.request<T>({ url, method: 'GET', params });
  }

  post<T>(url: string, body?: unknown): Promise<T> {
    return this.request<T>({ url, method: 'POST', body });
  }

  put<T>(url: string, body?: unknown): Promise<T> {
    return this.request<T>({ url, method: 'PUT', body });
  }

  delete<T>(url: string): Promise<T> {
    return this.request<T>({ url, method: 'DELETE' });
  }
}
```

### Pattern 2: Webhook Receiver with Signature Verification

```typescript
import crypto from 'crypto';
import express from 'express';

class WebhookHandler {
  constructor(private secret: string) {}

  verifySignature(payload: string, signature: string): boolean {
    const expected = crypto
      .createHmac('sha256', this.secret)
      .update(payload)
      .digest('hex');
    return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expected));
  }

  createMiddleware() {
    return (req: express.Request, res: express.Response, next: express.NextFunction) => {
      const signature = req.headers['x-webhook-signature'] as string;
      const body = JSON.stringify(req.body);

      if (!this.verifySignature(body, signature)) {
        return res.status(401).json({ error: 'Invalid signature' });
      }

      next();
    };
  }

  async processEvent(event: WebhookEvent): Promise<void> {
    switch (event.type) {
      case 'payment.completed':
        await this.handlePaymentCompleted(event.data);
        break;
      case 'user.created':
        await this.handleUserCreated(event.data);
        break;
      default:
        console.log(`Unhandled event type: ${event.type}`);
    }
  }
}
```

### Pattern 3: Rate-Limited API Client

```typescript
class RateLimitedClient {
  private queue: Array<{ resolve: () => void }> = [];
  private tokens: number;
  private lastRefill: number;

  constructor(
    private requestsPerSecond: number,
    private burstSize: number = requestsPerSecond
  ) {
    this.tokens = burstSize;
    this.lastRefill = Date.now();
  }

  private refill(): void {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(
      this.burstSize,
      this.tokens + elapsed * this.requestsPerSecond
    );
    this.lastRefill = now;
  }

  async acquire(): Promise<void> {
    this.refill();
    if (this.tokens >= 1) {
      this.tokens--;
      return;
    }

    return new Promise(resolve => {
      this.queue.push({ resolve });
      setTimeout(() => this.processQueue(), 1000 / this.requestsPerSecond);
    });
  }

  private processQueue(): void {
    this.refill();
    while (this.queue.length > 0 && this.tokens >= 1) {
      this.tokens--;
      this.queue.shift()!.resolve();
    }
    if (this.queue.length > 0) {
      setTimeout(() => this.processQueue(), 1000 / this.requestsPerSecond);
    }
  }

  async fetch<T>(url: string, init?: RequestInit): Promise<T> {
    await this.acquire();
    const response = await fetch(url, init);
    if (response.status === 429) {
      const retryAfter = parseInt(response.headers.get('Retry-After') || '1');
      await new Promise(r => setTimeout(r, retryAfter * 1000));
      return this.fetch<T>(url, init);
    }
    return response.json();
  }
}
```

### Pattern 4: GraphQL Batch Query Runner

```typescript
class GraphQLBatchRunner {
  private queue: Array<{
    query: string;
    variables?: Record<string, unknown>;
    resolve: (data: unknown) => void;
    reject: (error: Error) => void;
  }> = [];
  private batchTimer: NodeJS.Timeout | null = null;
  private batchInterval = 50; // ms

  constructor(
    private endpoint: string,
    private headers: Record<string, string> = {}
  ) {}

  async query<T>(query: string, variables?: Record<string, unknown>): Promise<T> {
    return new Promise((resolve, reject) => {
      this.queue.push({ query, variables, resolve: resolve as any, reject });

      if (!this.batchTimer) {
        this.batchTimer = setTimeout(() => this.flush(), this.batchInterval);
      }
    });
  }

  private async flush(): Promise<void> {
    this.batchTimer = null;
    const batch = this.queue.splice(0, 10); // Max batch size

    if (batch.length === 0) return;

    try {
      const response = await fetch(this.endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...this.headers },
        body: JSON.stringify(
          batch.map(({ query, variables }) => ({ query, variables }))
        ),
      });

      const results = await response.json();

      batch.forEach((item, index) => {
        const result = Array.isArray(results) ? results[index] : results;
        if (result.errors) {
          item.reject(new Error(result.errors[0].message));
        } else {
          item.resolve(result.data);
        }
      });
    } catch (error) {
      batch.forEach(item => item.reject(error as Error));
    }
  }
}
```

### Pattern 5: Server-Sent Events (SSE) Client

```typescript
class SSEClient {
  private eventSource: EventSource | null = null;
  private listeners = new Map<string, Set<(data: unknown) => void>>();
  private reconnectTimeout: NodeJS.Timeout | null = null;

  constructor(private url: string, private headers: Record<string, string> = {}) {}

  connect(): void {
    // EventSource doesn't support custom headers in browser;
    // Use fetch-based approach for production
    const eventSource = new EventSource(this.url);
    this.eventSource = eventSource;

    eventSource.onmessage = (event) => {
      const data = JSON.parse(event.data);
      this.listeners.get('message')?.forEach(fn => fn(data));
    };

    eventSource.onerror = () => {
      eventSource.close();
      this.scheduleReconnect();
    };
  }

  private scheduleReconnect(delay = 3000): void {
    this.reconnectTimeout = setTimeout(() => this.connect(), delay);
  }

  on(event: string, callback: (data: unknown) => void): () => void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set());
    }
    this.listeners.get(event)!.add(callback);
    return () => this.listeners.get(event)?.delete(callback);
  }

  close(): void {
    this.eventSource?.close();
    if (this.reconnectTimeout) clearTimeout(this.reconnectTimeout);
  }
}
```

## Edge Cases & Pitfalls

| # | Edge Case | Problem | Solution |
|---|-----------|---------|----------|
| 1 | **Clock skew in JWT validation** | Tokens rejected due to time drift between servers | Use `leeway` (e.g., 30s) in JWT verification; sync NTP |
| 2 | **Retry storm** | All clients retry simultaneously after outage | Add jitter to exponential backoff; implement circuit breaker |
| 3 | **Idempotency key expiry** | Replayed requests after key TTL | Extend TTL to cover business-critical operations; persist keys |
| 4 | **Race condition in token refresh** | Multiple concurrent requests trigger parallel refreshes | Use a mutex/lock on token refresh; queue pending requests |
| 5 | **Empty response body** | Parsing `undefined` as JSON throws | Check `Content-Length` and `Content-Type` before parsing |
| 6 | **Trailing slash mismatch** | `api/users/` ≠ `api/users` on some servers | Normalize URLs; always strip trailing slashes or configure base |
| 7 | **Large pagination** | Infinite pagination or missing records | Use cursor-based pagination; enforce maximum page size |
| 8 | **Binary response handling** | Binary data corrupted by text encoding | Set `responseType: 'arraybuffer'` or `response.arrayBuffer()` |
| 9 | **Cookie-based auth in fetch** | `fetch` doesn't send cookies by default | Use `credentials: 'include'` or redirect-based auth |
| 10 | **GraphQL partial errors** | `data` and `errors` both present | Always check for `errors` even when `data` exists |
| 11 | **Webhook replay attacks** | Old webhooks replayed by attacker | Verify timestamp freshness; reject webhooks > 5 minutes old |
| 12 | **gRPC deadline propagation** | Deadline not passed through call chain | Propagate `grpc-timeout` header; set deadlines on all calls |
| 13 | **SSE connection leak** | EventSource not closed on component unmount | Return cleanup function; use `AbortController` for fetch-based SSE |
| 14 | **Content-Type mismatch** | Server returns `text/plain` for JSON | Always set `Accept: application/json`; handle both types |
| 15 | **DNS resolution caching** | Stale DNS after IP change | Use connection pooling; don't cache DNS aggressively |

## Integration with Other Skills

| Skill | Integration Points |
|-------|-------------------|
| **Database Design** | Store API response caches, webhook events, integration logs |
| **Authentication** | OAuth 2.0 flows, JWT validation, API key management |
| **Caching** | Response caching, ETag handling, cache invalidation on webhooks |
| **Error Handling** | Structured error types, error boundary for API failures |
| **Logging & Monitoring** | Request/response logging, metrics, distributed tracing |
| **Testing** | Contract testing, mock servers (MSW), integration tests |
| **Security** | Token storage, CSRF protection, rate limiting, input validation |
| **Performance** | Connection pooling, request batching, response compression |
| **Microservices** | Service mesh, gRPC between services, API gateway patterns |
| **DevOps** | API versioning, backward compatibility, feature flags for rollouts |

## Output Format Templates

### Standard Template

```markdown
# API Integration: [Service Name]

## Configuration
- Base URL: [url]
- Auth: [type]
- Rate Limit: [limit]

## Endpoints
| Method | Path | Description |
|--------|------|-------------|
| GET | /resource | List resources |
| POST | /resource | Create resource |

## Code Example
[language-specific code block]

## Error Handling
[error types and handling strategy]
```

### Quick Template

```markdown
# Quick Integration: [Service]

1. Install: `npm install [package]`
2. Configure: [env vars]
3. Usage: [3-line code example]
```

### Deep Template

```markdown
# Comprehensive API Integration Guide: [Service]

## Architecture
[diagram or description of integration architecture]

## Authentication Flow
[step-by-step auth flow]

## Client Implementation
[full client class with error handling, retries, validation]

## Testing Strategy
[mock setup, contract tests, error simulation]

## Monitoring
[metrics, logging, alerting configuration]

## Migration Guide
[version upgrade path, breaking changes]
```

### Agent Template

```markdown
# API Integration Agent Instructions

## Task
Integrate with [Service] API for [use case].

## Requirements
- [ ] Auth implementation
- [ ] Client with typed responses
- [ ] Error handling for all failure modes
- [ ] Retry logic with exponential backoff
- [ ] Response validation
- [ ] Unit tests with MSW
- [ ] Integration tests
- [ ] Documentation

## Code Standards
- Use TypeScript with strict mode
- Validate all responses with Zod
- Log all API calls (redact sensitive data)
- Handle all HTTP status codes
- Implement circuit breaker for external calls

## Testing Checklist
- [ ] Happy path works
- [ ] Auth failures handled
- [ ] Rate limits respected
- [ ] Network errors retried
- [ ] Timeout handled
- [ ] Malformed responses handled
- [ ] Empty responses handled
```

## Rules

1. **Always validate responses** — Never trust external API responses; use Zod or similar schema validation
2. **Never store secrets in code** — Use environment variables, secret managers, or vaults
3. **Implement exponential backoff with jitter** — Never use fixed retry delays
4. **Use idempotency keys** for non-idempotent operations — Especially payments and mutations
5. **Set timeouts on every request** — Prevent hanging connections from exhausting resources
6. **Handle all error types** — Network, auth, validation, rate limit, server errors
7. **Log API calls with correlation IDs** — Enable distributed tracing across services
8. **Use circuit breakers for external calls** — Prevent cascading failures
9. **Respect rate limits** — Read `Retry-After` headers; implement client-side throttling
10. **Version your API integrations** — Support multiple API versions during transitions
11. **Test with contract tests** — Verify API contracts, not just HTTP status codes
12. **Secure token storage** — Use httpOnly cookies or secure storage; never localStorage for sensitive tokens
13. **Handle partial responses** — GraphQL may return both `data` and `errors`
14. **Monitor API health** — Track latency, error rates, and circuit breaker state
15. **Document all integrations** — Include setup, auth, usage, and failure modes