---
name: api-integration
description: >-
  Connect to third-party APIs and services, implement authentication (OAuth, API keys, JWT, Bearer tokens), manage tokens and credentials, write API client code, handle rate limits and retries, and debug API integration issues. Covers REST, GraphQL, WebSocket, gRPC, and SSE integrations. Use this skill whenever the user mentions API integration, connecting to an API, third-party service, OAuth, API authentication, API key, Bearer token, JWT, REST client, API wrapper, connect to service, integrate with service, call external API, webhooks, rate limiting, token refresh, API client, SDK wrapper, HTTP client, fetch wrapper, axios interceptor, REST API, GraphQL API, WebSocket client, gRPC client, SSE client, server-sent events, webhook handler, webhook signature verification, HMAC verification, API gateway, API proxy, BFF (backend for frontend), microservice communication, service-to-service auth, mTLS, client certificates, API versioning, pagination, cursor pagination, offset pagination, batch API, bulk API, API rate limiter, retry with backoff, circuit breaker, API timeout, API error handling, API response validation, Zod schema validation, JSON Schema validation, OpenAPI client generation, Swagger codegen, GraphQL codegen, TypeScript API client, typed API client, API mocking, MSW (mock service worker), API testing, integration testing, API debugging, API monitoring, API health checks, API observability, distributed tracing, OpenTelemetry API, API caching, cache invalidation, ETag, conditional requests, HTTP/2, HTTP/3, streaming API, long polling, webhooks vs polling, event-driven API, async API, fire-and-forget API, idempotency key, optimistic concurrency, API migration, API deprecation, Stripe integration, GitHub API, OpenAI API, Slack API, Twilio integration, SendGrid integration, AWS SDK, Google Cloud API, Firebase, Auth0, Clerk, Supabase, database API, payment API, email API, SMS API, storage API, search API, map API, analytics API, notification API, اتصال API, اتصال به سرویس, احراز هویت API, کلید API, توکن, وب‌هوک, احراز هویت, کلید دسترسی, توکن رفرش, ریت لیمیت, محدودیت نرخ, درخواست HTTP, کلاینت API, پوشه API, یکپارچه‌سازی API, اتصال به سرویس خارجی, وب سرویس, REST API, GraphQL, وب‌سوکت, or wants to write code that communicates with an external service.
---

# API Integration Skill — Connect to Any External Service

## Overview

This skill handles everything involved in connecting your code to third-party APIs and services. From writing the first HTTP request to implementing full OAuth flows, managing token lifecycle, handling retries and rate limits, and debugging connection issues. The goal is to produce production-ready integration code that's secure, resilient, and well-documented.

## When to Use This Skill

- User wants to connect to a third-party API or service
- User needs to implement OAuth, API key auth, or JWT authentication
- User asks to write an API client, wrapper, or SDK
- User needs help with token refresh, session management, or credential storage
- User is debugging an API integration (auth failures, rate limits, unexpected responses)
- User mentions اتصال API, احراز هویت, کلید API, or توکن
- User says "connect to X API" or "integrate with Y service"
- User needs webhook handling or signature verification
- User wants to implement rate limiting, retries, or circuit breakers for API calls
- User needs to generate typed API clients from OpenAPI or GraphQL specs
- User wants to mock APIs for testing (MSW, interceptors)
- User needs to handle pagination, streaming responses, or SSE
- User wants to implement API caching, ETags, or conditional requests
- User needs service-to-service authentication (mTLS, JWT)

## API Integration Workflow

### Step 1: Understand the Target API

1. **Identify the service** — Which API are we integrating with? (Stripe, GitHub, OpenAI, Slack, etc.)
2. **Find the documentation** — Use web-search or web-reader to locate the official API docs for the target service.
3. **Determine authentication method**:

   | Method | When Used | Where to Put It |
   |--------|-----------|-----------------|
   | API Key (header) | Most common | `Authorization: Bearer <key>` or `X-API-Key: <key>` |
   | API Key (query param) | Simple services | `?api_key=<key>` in URL |
   | OAuth 2.0 | User-scoped access | Authorization code flow (web), PKCE (mobile/SPAs), client credentials (server-to-server) |
   | JWT | Token-based auth | `Authorization: Bearer <jwt>` |
   | Basic Auth | Legacy/simple | `Authorization: Basic base64(user:pass)` |
   | Webhook signatures | Event verification | HMAC signature in header |
   | mTLS | Service-to-service | Client certificate in TLS handshake |

4. **Identify rate limits** — Check the docs for rate limit headers, quotas, and retry-after behavior.
5. **Check for SDK** — Does the service provide an official SDK? If so, recommend using it instead of writing raw HTTP calls.

### Step 2: Set Up the Integration

1. **Check the project** — What language/framework is the user's project in? What HTTP client is already available?
2. **Manage credentials securely**:
   - NEVER hardcode API keys or secrets in source code
   - Use environment variables (`.env` files for local dev, secrets manager for production)
   - For OAuth: store refresh tokens encrypted, never in code or logs

### Step 3: Implement Resilience

1. **Retry with backoff** — For transient failures (429, 500, 502, 503, 504)
2. **Rate limit handling** — Parse rate limit headers and throttle proactively
3. **Timeout** — Always set a request timeout (default 30s, adjust per API)
4. **Idempotency** — For POST/PUT requests, use idempotency keys if the API supports them

### Step 4: Test the Integration

1. Write a minimal test script that calls one endpoint and logs the response
2. Verify authentication works before building out full functionality
3. Test error cases: invalid token, rate limit hit, malformed request
4. If the API has a sandbox/test mode, use it during development

## Output Format Templates

### Template 1: Complete API Client Module
```typescript
// src/lib/external-service.ts
import type { AxiosInstance, AxiosError, InternalAxiosRequestConfig } from 'axios';
import axios from 'axios';

export class ApiError extends Error {
  constructor(
    public readonly status: number,
    public readonly code: string,
    message: string,
    public readonly data?: unknown,
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export interface ServiceClientConfig {
  apiKey: string;
  baseUrl?: string;
  timeout?: number;
  maxRetries?: number;
}

export class ServiceClient {
  private http: AxiosInstance;
  private maxRetries: number;

  constructor(config: ServiceClientConfig) {
    this.maxRetries = config.maxRetries ?? 3;
    this.http = axios.create({
      baseURL: config.baseUrl ?? 'https://api.service.com/v1',
      timeout: config.timeout ?? 30_000,
      headers: {
        'Authorization': `Bearer ${config.apiKey}`,
        'Content-Type': 'application/json',
        'User-Agent': 'MyApp/1.0',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    // Request logging (without secrets)
    this.http.interceptors.request.use((config) => {
      console.debug(`[API] ${config.method?.toUpperCase()} ${config.url}`);
      return config;
    });

    // Response error handling
    this.http.interceptors.response.use(
      (response) => response,
      async (error: AxiosError<{ error: { code: string; message: string } }>) => {
        const status = error.response?.status ?? 0;
        const code = error.response?.data?.error?.code ?? 'UNKNOWN';
        const message = error.response?.data?.error?.message ?? error.message;

        if (status === 429) {
          const retryAfter = error.response?.headers?.['retry-after'];
          console.warn(`[API] Rate limited. Retry after: ${retryAfter}s`);
        }

        throw new ApiError(status, code, message, error.response?.data);
      },
    );
  }

  // --- Public methods ---

  async getResource(id: string) {
    const { data } = await this.http.get(`/resources/${id}`);
    return data;
  }

  async listResources(params?: { page?: number; limit?: number }) {
    const { data } = await this.http.get('/resources', { params });
    return data;
  }

  async createResource(payload: { name: string; type: string }) {
    const { data } = await this.http.post('/resources', payload, {
      headers: { 'Idempotency-Key': crypto.randomUUID() },
    });
    return data;
  }
}
```

### Template 2: OAuth 2.0 Client Credentials Flow
```typescript
// src/lib/oauth-client-credentials.ts
interface TokenResponse {
  access_token: string;
  expires_in: number;
  token_type: 'Bearer';
}

export class OAuthClient {
  private token: string | null = null;
  private tokenExpiresAt = 0;
  private tokenPromise: Promise<string> | null = null;

  constructor(
    private clientId: string,
    private clientSecret: string,
    private tokenUrl: string,
  ) {}

  async getToken(): Promise<string> {
    // Return cached token if still valid (with 60s buffer)
    if (this.token && Date.now() < this.tokenExpiresAt - 60_000) {
      return this.token;
    }

    // Deduplicate concurrent token requests
    if (!this.tokenPromise) {
      this.tokenPromise = this.fetchNewToken();
    }

    try {
      return await this.tokenPromise;
    } finally {
      this.tokenPromise = null;
    }
  }

  private async fetchNewToken(): Promise<string> {
    const response = await fetch(this.tokenUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'client_credentials',
        client_id: this.clientId,
        client_secret: this.clientSecret,
      }),
    });

    if (!response.ok) {
      throw new Error(`Token request failed: ${response.status}`);
    }

    const data: TokenResponse = await response.json();
    this.token = data.access_token;
    this.tokenExpiresAt = Date.now() + data.expires_in * 1000;
    return this.token;
  }

  async authenticatedFetch(url: string, init: RequestInit = {}): Promise<Response> {
    const token = await this.getToken();
    return fetch(url, {
      ...init,
      headers: {
        ...init.headers,
        'Authorization': `Bearer ${token}`,
      },
    });
  }
}
```

### Template 3: Webhook Handler with Signature Verification
```typescript
// src/webhooks/stripe-handler.ts
import crypto from 'crypto';

export function verifyWebhookSignature(
  payload: string,
  signature: string,
  secret: string,
): boolean {
  const elements = signature.split(',');
  const sigMap = new Map(elements.map(e => {
    const [key, value] = e.split('=');
    return [key, value];
  }));

  const timestamp = sigMap.get('t');
  if (!timestamp) return false;

  // Reject events older than 5 minutes
   const fiveMinutes = 300_000;
  if (Date.now() - parseInt(timestamp) * 1000 > fiveMinutes) {
    return false;
  }

  const signedPayload = `${timestamp}.${payload}`;
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(signedPayload)
    .digest('hex');

  return crypto.timingSafeEqual(
    Buffer.from(expectedSignature),
    Buffer.from(sigMap.get('v1') ?? ''),
  );
}

// Usage in an Express/Next.js route handler
export async function handleWebhook(req: Request, res: Response) {
  const signature = req.headers['stripe-signature'] as string;
  const payload = req.body;

  if (!verifyWebhookSignature(payload, signature, process.env.WEBHOOK_SECRET!)) {
    return res.status(401).json({ error: 'Invalid signature' });
  }

  const event = JSON.parse(payload);

  switch (event.type) {
    case 'payment.succeeded':
      await handlePaymentSuccess(event.data);
      break;
    case 'payment.failed':
      await handlePaymentFailure(event.data);
      break;
  }

  return res.json({ received: true });
}
```

### Template 4: .env.example File
```bash
# .env.example — Copy to .env and fill in values

# Service API
SERVICE_API_KEY=sk_live_xxxxxxxxxxxx
SERVICE_BASE_URL=https://api.service.com/v1

# OAuth (if applicable)
OAUTH_CLIENT_ID=your-client-id
OAUTH_CLIENT_SECRET=your-client-secret
OAUTH_TOKEN_URL=https://auth.service.com/oauth/token

# Webhooks (if receiving)
WEBHOOK_SECRET=whsec_xxxxxxxxxxxx
WEBHOOK_SIGNING_KEY=your-signing-key

# Optional
SERVICE_TIMEOUT_MS=30000
SERVICE_MAX_RETRIES=3
SERVICE_LOG_LEVEL=info
```

## Advanced Techniques

### 1. Retry with Exponential Backoff and Jitter
Implement retries with both exponential backoff (increasing delay) and jitter (randomness to prevent thundering herd).

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  baseDelayMs = 1000,
): Promise<T> {
  let lastError: Error | undefined;

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;
      const status = (error as any)?.response?.status;

      // Don't retry client errors (except 429)
      if (status && status >= 400 && status < 500 && status !== 429) {
        throw error;
      }

      if (attempt < maxRetries) {
        const exponentialDelay = baseDelayMs * Math.pow(2, attempt);
        const jitter = Math.random() * baseDelayMs;
        const delay = exponentialDelay + jitter;
        console.warn(`[Retry] Attempt ${attempt + 1}/${maxRetries}, waiting ${Math.round(delay)}ms`);
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }

  throw lastError;
}
```

### 2. Circuit Breaker Pattern
Prevent cascading failures by stopping requests to a failing service after a threshold.

```typescript
type CircuitState = 'closed' | 'open' | 'half-open';

export class CircuitBreaker {
  private state: CircuitState = 'closed';
  private failureCount = 0;
  private lastFailureTime = 0;
  private readonly failureThreshold: number;
  private readonly recoveryTimeMs: number;

  constructor(failureThreshold = 5, recoveryTimeMs = 30_000) {
    this.failureThreshold = failureThreshold;
    this.recoveryTimeMs = recoveryTimeMs;
  }

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'open') {
      if (Date.now() - this.lastFailureTime > this.recoveryTimeMs) {
        this.state = 'half-open';
      } else {
        throw new Error('Circuit breaker is OPEN — service unavailable');
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

  private onSuccess() {
    this.failureCount = 0;
    this.state = 'closed';
  }

  private onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    if (this.failureCount >= this.failureThreshold) {
      this.state = 'open';
    }
  }
}
```

### 3. Response Validation with Zod
Validate every API response against a schema to catch unexpected data shapes early.

```typescript
import { z } from 'zod';

const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  role: z.enum(['admin', 'user', 'guest']),
  created_at: z.string().datetime(),
});

const UserListResponseSchema = z.object({
  data: z.array(UserSchema),
  pagination: z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
  }),
});

// In the client
async listUsers() {
  const response = await this.http.get('/users');
  return UserListResponseSchema.parse(response.data); // Throws if shape is wrong
}
```

### 4. Cursor-Based Pagination Helper
Many modern APIs use cursor-based pagination. Build a helper that abstracts the iteration.

```typescript
async function* paginate<T>(
  fetchPage: (cursor?: string) => Promise<{ data: T[]; next_cursor: string | null }>,
): AsyncGenerator<T> {
  let cursor: string | undefined;

  do {
    const page = await fetchPage(cursor);
    for (const item of page.data) {
      yield item;
    }
    cursor = page.next_cursor ?? undefined;
  } while (cursor);
}

// Usage
for await (const user of paginate(client.listUsers.bind(client))) {
  console.log(user.name);
}
```

### 5. Request Deduplication
Prevent duplicate concurrent requests for the same resource (e.g., during React rendering).

```typescript
const pendingRequests = new Map<string, Promise<any>>();

export function deduplicatedFetch<T>(key: string, fetcher: () => Promise<T>): Promise<T> {
  if (pendingRequests.has(key)) {
    return pendingRequests.get(key)!;
  }

  const promise = fetcher().finally(() => {
    pendingRequests.delete(key);
  });

  pendingRequests.set(key, promise);
  return promise;
}
```

### 6. API Monitoring and Observability
Add structured logging and metrics for every API call.

```typescript
async function monitoredFetch(
  url: string,
  init?: RequestInit,
): Promise<Response> {
  const start = Date.now();
  try {
    const response = await fetch(url, init);
    const duration = Date.now() - start;

    console.log(JSON.stringify({
      event: 'api_call',
      url,
      method: init?.method ?? 'GET',
      status: response.status,
      duration_ms: duration,
      timestamp: new Date().toISOString(),
    }));

    return response;
  } catch (error) {
    console.error(JSON.stringify({
      event: 'api_error',
      url,
      method: init?.method ?? 'GET',
      error: (error as Error).message,
      duration_ms: Date.now() - start,
    }));
    throw error;
  }
}
```

### 7. OpenAPI Client Generation
For APIs with OpenAPI specs, generate typed clients instead of writing them manually.

```bash
# Generate a typed client from an OpenAPI spec
npx openapi-typescript https://api.service.com/openapi.json -o src/types/api.d.ts
npx openapi-fetch -o src/lib/api-client.ts https://api.service.com/openapi.json
```

## Common Patterns

### Pattern 1: Stripe Payment Integration
```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
});

export async function createPaymentSession(
  amount: number,
  currency: string,
  orderId: string,
) {
  return stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: [{ price_data: { currency, product_data: { name: `Order ${orderId}` }, unit_amount: amount }, quantity: 1 }],
    mode: 'payment',
    success_url: `${process.env.APP_URL}/order/${orderId}/success`,
    cancel_url: `${process.env.APP_URL}/order/${orderId}/cancel`,
    metadata: { orderId },
  });
}
```

### Pattern 2: GitHub API with Personal Access Token
```typescript
const GITHUB_API = 'https://api.github.com';

export async function listPRs(repo: string, state: 'open' | 'closed' = 'open') {
  const res = await fetch(
    `${GITHUB_API}/repos/${repo}/pulls?state=${state}&per_page=100`,
    {
      headers: {
        'Authorization': `Bearer ${process.env.GITHUB_TOKEN}`,
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    },
  );

  if (!res.ok) throw new Error(`GitHub API error: ${res.status}`);
  return res.json();
}
```

### Pattern 3: OpenAI Streaming Response
```typescript
export async function* streamChat(messages: ChatMessage[]) {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages,
      stream: true,
    }),
  });

  const reader = response.body!.getReader();
  const decoder = new TextDecoder();
  let buffer = '';

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });

    const lines = buffer.split('\n');
    buffer = lines.pop() ?? '';

    for (const line of lines) {
      if (line.startsWith('data: ') && line !== 'data: [DONE]') {
        yield JSON.parse(line.slice(6));
      }
    }
  }
}
```

### Pattern 4: Slack Webhook Notification
```typescript
export async function sendSlackNotification(
  webhookUrl: string,
  message: { text: string; channel?: string },
) {
  const res = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(message),
  });

  if (!res.ok) {
    throw new Error(`Slack webhook failed: ${res.status} ${await res.text()}`);
  }
}
```

### Pattern 5: GraphQL Client with Typed Queries
```typescript
import { GraphQLClient, gql } from 'graphql-request';

const client = new GraphQLClient('https://api.example.com/graphql', {
  headers: { 'Authorization': `Bearer ${process.env.API_TOKEN}` },
});

const GetUserQuery = gql`
  query GetUser($id: ID!) {
    user(id: $id) {
      id
      name
      email
      posts(first: 10) {
        edges {
          node {
            title
            publishedAt
          }
        }
      }
    }
  }
`;

interface User {
  id: string;
  name: string;
  email: string;
  posts: { edges: { node: { title: string; publishedAt: string } }[] };
}

export async function getUser(id: string): Promise<{ user: User }> {
  return client.request(GetUserQuery, { id });
}
```

## Edge Cases & Pitfalls

1. **Hardcoded secrets in code** — The most common and dangerous mistake. Always use environment variables or a secrets manager. Never commit `.env` files.

2. **Token refresh race conditions** — Multiple concurrent requests may all try to refresh an expired token simultaneously. Use a mutex or promise deduplication to ensure only one refresh happens.

3. **Not respecting Rate-Limit headers** — Making requests faster than the API allows leads to 429 errors and potential IP bans. Parse `X-RateLimit-Remaining` and `Retry-After` headers.

4. **Ignoring response validation** — APIs can return unexpected shapes (extra fields, missing fields, wrong types). Validate with a schema, especially in production.

5. **Unbounded retries** — Retrying indefinitely on persistent failures. Always cap retries (3-5) and add a maximum total timeout.

6. **Timeout misconfiguration** — Setting timeouts too short for legitimate slow operations, or too long causing resource exhaustion. Tune per-endpoint.

7. **Non-idempotent request retries** — Retrying a POST that creates a resource (e.g., a payment) without an idempotency key may create duplicates. Always use idempotency keys for writes.

8. **Webhook replay attacks** — Not verifying webhook timestamps. Always check that the webhook timestamp is recent (within 5 minutes) to prevent replay attacks.

9. **CORS issues in browser** — Calling APIs from browser JavaScript hits CORS restrictions. Use a server-side proxy, or ensure the API supports CORS.

10. **Pagination not handled** — APIs that return paginated results: only fetching the first page and missing the rest. Always check for `next_page`, `next_cursor`, or `Link` headers.

11. **Timezone mismatches** — APIs returning timestamps in UTC while your code assumes local time. Always parse dates as UTC and convert for display.

12. **Silent failures** — Catching errors and logging them but not propagating. The caller thinks the request succeeded when it didn't.

13. **Logging secrets** — Logging full request/response bodies that contain tokens, API keys, or PII. Always redact sensitive fields before logging.

14. **SDK version lock-in** — Pinning to an exact SDK version without updating. SDKs deprecate and APIs change. Use `^` ranges and review changelogs.

15. **Missing error type discrimination** — Throwing generic `Error` objects instead of typed errors. Callers can't distinguish between auth errors, rate limits, and validation errors.

## Integration with Other Skills

- **documentation** — Use when writing API documentation, integration guides, or SDK usage docs.
- **changelog** — Use when documenting API version changes, deprecated endpoints, or breaking API changes in release notes.
- **technical-writing** — Use when writing tutorials about integrating with specific APIs or API design articles.
- **summarization** — Use when summarizing API documentation, response formats, or integration requirements.
- **browser-automation** — Use when testing API-powered web applications, or when browser tests need real API interactions.
- **charts** — Use when visualizing API performance metrics, error rate dashboards, or integration architecture diagrams.
- **pdf** — Use when creating API documentation PDFs or integration specification documents.
- **docx** — Use when delivering API integration specifications as Word documents for enterprise teams.

## Principles

- **Never expose secrets.** API keys, tokens, and client secrets must come from environment variables or a secrets manager, never from source code.
- **Fail gracefully.** When the API is down or returns an error, the app should not crash. Log the error and return a meaningful response.
- **Use the SDK when available.** Official SDKs handle auth, retries, types, and breaking changes. Don't reinvent the wheel.
- **Validate responses.** Don't trust that the API will always return the expected shape. Validate and handle unexpected data.
- **Log requests and responses (without secrets).** For debugging, log method, URL, status code, and response body — but never log authorization headers or token values.
- **Make integrations swappable.** Abstract the HTTP client behind an interface so you can swap implementations (real, mock, cached) without changing business logic.
- **Respect rate limits proactively.** Don't wait for 429 errors. Track your own request rate and slow down before hitting the limit.
- **Plan for failure.** Every external call can fail. Have a fallback, a retry strategy, and a clear error message for the end user.
