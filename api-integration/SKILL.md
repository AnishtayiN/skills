---
name: api-integration
description: >-
  Connect to third-party APIs and services, implement authentication (OAuth, API keys, JWT, Bearer tokens), manage tokens and credentials, write API client code, handle rate limits and retries, and debug API integration issues. Use this skill whenever the user mentions API integration, connecting to an API, third-party service, OAuth, API authentication, API key, Bearer token, JWT, REST client, API wrapper, connect to service, integrate with service, call external API, webhooks, rate limiting, token refresh, اتصال API, اتصال به سرویس, احراز هویت API, کلید API, توکن, وب‌هوک, or wants to write code that communicates with an external service. Also triggers for circuit breaker pattern, webhook implementation, API client patterns for Python/Go/Java, PKCE flow, device authorization flow, client credentials flow, API testing strategies, request logging patterns.
---

# API Integration Skill — Connect to Any External Service

## Overview

This skill handles everything involved in connecting your code to third-party APIs and services. From writing the first HTTP request to implementing full OAuth flows, managing token lifecycle, handling retries and rate limits, implementing circuit breakers, designing webhook receivers, and debugging connection issues. The goal is to produce production-ready integration code that's secure, resilient, and well-documented.

## When to Use This Skill

- User wants to connect to a third-party API or service
- User needs to implement OAuth, API key auth, or JWT authentication
- User asks to write an API client, wrapper, or SDK
- User needs help with token refresh, session management, or credential storage
- User is debugging an API integration (auth failures, rate limits, unexpected responses)
- User needs webhook implementation (receiving, verifying, processing events)
- User wants to implement circuit breaker or resilience patterns
- User mentions اتصال API, احراز هویت, کلید API, or توکن
- User says "connect to X API" or "integrate with Y service"
- User needs API testing strategies (mocking, recording, contract testing)

---

## Part 1: Understanding the Target API

### Step 1: Research the API

1. **Identify the service** — Which API are we integrating with? (Stripe, GitHub, OpenAI, Slack, etc.)
2. **Find the documentation** — Use web-search to locate the official API docs
3. **Determine authentication method**:

   | Method | When Used | Where to Put It |
   |--------|-----------|-----------------|
   | API Key (header) | Most common | `Authorization: Bearer <key>` or `X-API-Key: <key>` |
   | API Key (query param) | Simple services | `?api_key=<key>` in URL |
   | OAuth 2.0 (Authorization Code) | Web apps with user login | Redirect flow with code exchange |
   | OAuth 2.0 (PKCE) | SPAs, mobile apps, CLI tools | Authorization code + code verifier |
   | OAuth 2.0 (Client Credentials) | Server-to-server, no user | Direct token request with client_id/secret |
   | OAuth 2.0 (Device Authorization) | Smart TVs, CLI tools, IoT | Device code polling flow |
   | JWT | Token-based auth | `Authorization: Bearer <jwt>` |
   | Basic Auth | Legacy/simple | `Authorization: Basic base64(user:pass)` |
   | HMAC Signatures | Webhook verification | Signature in header |

4. **Identify rate limits** — Check for rate limit headers, quotas, retry-after behavior
5. **Check for SDK** — Does the service provide an official SDK? If so, recommend using it

### Step 2: Understand Request/Response Patterns

- What content types are accepted/returned? (JSON, form-encoded, multipart)
- Are there idempotency keys? (Stripe, Square)
- How does pagination work? (cursor, offset, token)
- What are the error response formats?
- Are there versioning headers?

---

## Part 2: OAuth 2.0 Flows in Depth

### Flow 1: Authorization Code (Web Applications)

```
┌──────────┐          ┌──────────┐          ┌──────────┐
│  Browser  │          │ Your App │          │  OAuth   │
│           │          │ (Server) │          │ Provider │
└─────┬─────┘          └─────┬─────┘          └─────┬─────┘
      │  1. Click Login      │                      │
      │ ───────────────────> │                      │
      │  2. Redirect to      │                      │
      │     Authorization URL│                      │
      │ <─────────────────── │                      │
      │  3. User authenticates│                      │
      │  & grants consent    │                      │
      │ ───────────────────────────────────────────>│
      │  4. Redirect back with auth code            │
      │ <───────────────────────────────────────────│
      │  5. Exchange code for tokens                │
      │ ───────────────────> │                      │
      │                      │  6. POST /token      │
      │                      │ ────────────────────>│
      │                      │  7. Access + Refresh │
      │                      │ <────────────────────│
      │  8. Logged in        │                      │
      │ <─────────────────── │                      │
```

**Implementation:**
```typescript
// Step 1: Redirect to authorization URL
const authUrl = new URL('https://provider.com/authorize');
authUrl.searchParams.set('client_id', process.env.CLIENT_ID);
authUrl.searchParams.set('redirect_uri', 'https://yourapp.com/callback');
authUrl.searchParams.set('response_type', 'code');
authUrl.searchParams.set('scope', 'read write');
authUrl.searchParams.set('state', generateCsrfToken()); // CSRF protection

// Step 2: Handle callback and exchange code
async function handleCallback(code: string, state: string) {
  // Verify state to prevent CSRF
  if (state !== getStoredCsrfToken()) throw new Error('CSRF mismatch');
  
  const response = await fetch('https://provider.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'authorization_code',
      code,
      redirect_uri: 'https://yourapp.com/callback',
      client_id: process.env.CLIENT_ID,
      client_secret: process.env.CLIENT_SECRET,
    }),
  });
  
  const { access_token, refresh_token, expires_in } = await response.json();
  // Store tokens securely (encrypted in database)
  await storeTokens(access_token, refresh_token, expires_in);
}
```

### Flow 2: PKCE (Proof Key for Code Exchange)

For SPAs, mobile apps, and CLI tools where client_secret can't be kept secret.

```typescript
import crypto from 'crypto';

// Generate code verifier and challenge
const codeVerifier = crypto.randomBytes(32).toString('base64url');
const codeChallenge = crypto.createHash('sha256')
  .update(codeVerifier)
  .digest('base64url');

// Authorization URL includes code_challenge
const authUrl = `https://provider.com/authorize?` +
  `client_id=${CLIENT_ID}` +
  `&response_type=code` +
  `&code_challenge=${codeChallenge}` +
  `&code_challenge_method=S256` +
  `&redirect_uri=${REDIRECT_URI}` +
  `&state=${state}`;

// Token exchange includes code_verifier
const tokenResponse = await fetch('https://provider.com/token', {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  body: new URLSearchParams({
    grant_type: 'authorization_code',
    code,
    redirect_uri: REDIRECT_URI,
    client_id: CLIENT_ID,
    code_verifier: codeVerifier,  // No client_secret needed!
  }),
});
```

### Flow 3: Client Credentials (Server-to-Server)

No user interaction — your server authenticates directly with client_id and client_secret.

```typescript
async function getClientToken(): Promise<string> {
  const response = await fetch('https://provider.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'client_credentials',
      client_id: process.env.CLIENT_ID,
      client_secret: process.env.CLIENT_SECRET,
      scope: 'read write',
    }),
  });
  
  if (!response.ok) throw new Error(`Token request failed: ${response.status}`);
  const { access_token, expires_in } = await response.json();
  return access_token;
}
```

Use cases: microservice-to-microservice calls, background jobs accessing APIs, CI/CD pipelines.

### Flow 4: Device Authorization (Smart TVs, CLI, IoT)

For devices without a browser or with limited input capability.

```
┌──────────┐          ┌──────────┐          ┌──────────┐
│  Device   │          │ Your App │          │  OAuth   │
│ (no browser)          │  Server  │          │ Provider │
└─────┬─────┘          └─────┬─────┘          └─────┬─────┘
      │ 1. Request device code                      │
      │ ───────────────────────────────────────────>│
      │ 2. device_code, user_code,                   │
      │    verification_uri                         │
      │ <───────────────────────────────────────────│
      │ 3. Show user: "Go to https://provider.com/device"
      │    Enter code: ABCD-EFGH                    │
      │ 4. User visits URL on phone, enters code    │
      │ 5. Poll /token until authorized             │
      │ ───────────────────────────────────────────>│
      │    (pending... pending... authorized!)       │
      │ 6. Access token returned                    │
      │ <───────────────────────────────────────────│
```

```typescript
async function deviceAuthorizationFlow() {
  // Step 1: Get device code
  const { device_code, user_code, verification_uri, interval } = 
    await postToTokenEndpoint({
      grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
      client_id: CLIENT_ID,
      scope: 'read',
    });

  // Step 2: Display to user
  console.log(`Go to: ${verification_uri}`);
  console.log(`Enter code: ${user_code}`);

  // Step 3: Poll until authorized
  while (true) {
    await sleep(interval * 1000);
    const response = await postToTokenEndpoint({
      grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
      device_code,
      client_id: CLIENT_ID,
    });
    
    if (response.access_token) return response;
    if (response.error === 'authorization_pending') continue;
    if (response.error === 'slow_down') { interval += 5; continue; }
    throw new Error(`Device auth failed: ${response.error}`);
  }
}
```

### Token Refresh Pattern

```typescript
class TokenManager {
  private accessToken: string | null = null;
  private refreshToken: string;
  private expiresAt: Date;

  async getAccessToken(): Promise<string> {
    if (this.isExpired()) {
      await this.refresh();
    }
    return this.accessToken!;
  }

  private isExpired(): boolean {
    return new Date() >= this.expiresAt;
  }

  async refresh(): Promise<void> {
    const response = await fetch('https://provider.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'refresh_token',
        refresh_token: this.refreshToken,
        client_id: CLIENT_ID,
      }),
    });

    if (!response.ok) {
      // Refresh token revoked — redirect to re-auth
      throw new AuthenticationError('Token refresh failed');
    }

    const data = await response.json();
    this.accessToken = data.access_token;
    this.refreshToken = data.refresh_token; // May rotate
    this.expiresAt = new Date(Date.now() + data.expires_in * 1000);
  }
}
```

---

## Part 3: Resilience Patterns

### Retry with Exponential Backoff

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  options: {
    maxRetries?: number;
    baseDelay?: number;
    maxDelay?: number;
    retryableStatuses?: number[];
  } = {}
): Promise<T> {
  const {
    maxRetries = 3,
    baseDelay = 1000,
    maxDelay = 30000,
    retryableStatuses = [429, 500, 502, 503, 504],
  } = options;

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      const status = error?.status || error?.response?.status;
      const retryAfter = error?.headers?.['retry-after'];
      
      if (status && !retryableStatuses.includes(status)) throw error;
      
      const delay = retryAfter
        ? parseInt(retryAfter) * 1000
        : Math.min(baseDelay * Math.pow(2, attempt) + Math.random() * 1000, maxDelay);
      
      console.log(`Retry ${attempt + 1}/${maxRetries} after ${delay}ms`);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  throw new Error('Max retries exceeded');
}
```

### Circuit Breaker Pattern

Prevents cascading failures by stopping requests to a failing service:

```typescript
class CircuitBreaker {
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  private failureCount = 0;
  private lastFailureTime = 0;
  private readonly failureThreshold = 5;
  private readonly resetTimeout = 30000; // 30 seconds

  async call<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.resetTimeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new CircuitOpenError('Circuit is open — service unavailable');
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
    this.state = 'CLOSED';
  }

  private onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    if (this.failureCount >= this.failureThreshold) {
      this.state = 'OPEN';
    }
  }
}

// Usage
const stripeBreaker = new CircuitBreaker();
const charge = await stripeBreaker.call(() => stripe.charges.create(params));
```

### Idempotency Keys

For POST requests that must not be processed twice:

```typescript
import { v4 as uuidv4 } from 'uuid';

async function createWithIdempotency<T>(data: unknown): Promise<T> {
  const idempotencyKey = uuidv4();
  
  // Check if we already have a result cached
  const cached = await cache.get(`idempotency:${idempotencyKey}`);
  if (cached) return cached;

  const result = await fetch('/api/charges', {
    method: 'POST',
    headers: {
      'Idempotency-Key': idempotencyKey,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  const response = await result.json();
  await cache.set(`idempotency:${idempotencyKey}`, response, { ttl: 86400 });
  return response;
}
```

---

## Part 4: API Client Patterns by Language

### TypeScript / Node.js

```typescript
import axios, { AxiosInstance, AxiosError } from 'axios';

class GitHubClient {
  private client: AxiosInstance;

  constructor(token: string) {
    this.client = axios.create({
      baseURL: 'https://api.github.com',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'MyApp/1.0',
      },
      timeout: 30000,
    });

    // Interceptor for error handling
    this.client.interceptors.response.use(
      (response) => response,
      (error: AxiosError) => {
        if (error.response?.status === 403) {
          const remaining = error.response.headers['x-ratelimit-remaining'];
          if (remaining === '0') {
            const reset = error.response.headers['x-ratelimit-reset'];
            throw new RateLimitError(`Rate limited until ${new Date(Number(reset) * 1000)}`);
          }
        }
        throw error;
      }
    );
  }

  async getUser(username: string) {
    const { data } = await this.client.get(`/users/${username}`);
    return data;
  }

  async listRepos(username: string, page = 1, perPage = 30) {
    const { data, headers } = await this.client.get(`/users/${username}/repos`, {
      params: { page, per_page: perPage },
    });
    return {
      repos: data,
      nextPage: headers.link?.includes('rel="next"') ? page + 1 : null,
    };
  }
}
```

### Python

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

class APIClient:
    def __init__(self, api_key: str, base_url: str = "https://api.example.com/v1"):
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        })
        
        # Configure retries
        retry_strategy = Retry(
            total=3,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
            allowed_methods=["HEAD", "GET", "POST", "PUT", "PATCH"],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
        self.base_url = base_url

    def get(self, path: str, params: dict = None) -> dict:
        response = self.session.get(f"{self.base_url}{path}", params=params)
        response.raise_for_status()
        return response.json()

    def post(self, path: str, data: dict = None) -> dict:
        response = self.session.post(f"{self.base_url}{path}", json=data)
        response.raise_for_status()
        return response.json()
```

### Go

```go
package apiclient

import (
    "context"
    "encoding/json"
    "fmt"
    "net/http"
    "time"
)

type Client struct {
    httpClient *http.Client
    baseURL    string
    apiKey     string
}

func NewClient(apiKey, baseURL string) *Client {
    return &Client{
        httpClient: &http.Client{
            Timeout: 30 * time.Second,
            Transport: &retryTransport{
                maxRetries: 3,
                base:       http.DefaultTransport,
            },
        },
        baseURL: baseURL,
        apiKey:  apiKey,
    }
}

func (c *Client) Get(ctx context.Context, path string, result interface{}) error {
    req, err := http.NewRequestWithContext(ctx, "GET", c.baseURL+path, nil)
    if err != nil {
        return fmt.Errorf("creating request: %w", err)
    }
    req.Header.Set("Authorization", "Bearer "+c.apiKey)
    
    resp, err := c.httpClient.Do(req)
    if err != nil {
        return fmt.Errorf("executing request: %w", err)
    }
    defer resp.Body.Close()
    
    if resp.StatusCode >= 400 {
        return &APIError{StatusCode: resp.StatusCode}
    }
    
    return json.NewDecoder(resp.Body).Decode(result)
}
```

---

## Part 5: Webhook Implementation

### Receiving Webhooks

```typescript
import express from 'express';
import crypto from 'crypto';

const app = express();

// IMPORTANT: Raw body needed for signature verification
app.post('/webhooks/stripe', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['stripe-signature'];
  
  // 1. Verify signature
  const event = verifyWebhookSignature(req.body, signature, WEBHOOK_SECRET);
  if (!event) {
    return res.status(400).json({ error: 'Invalid signature' });
  }

  // 2. Process event asynchronously
  processWebhookEvent(event).catch(console.error);

  // 3. Return 200 quickly (don't do heavy processing in the handler)
  res.status(200).json({ received: true });
});

function verifyWebhookSignature(payload: string, signature: string, secret: string): object | null {
  const elements = signature.split(',');
  const timestamp = elements.find(e => e.startsWith('t='))?.slice(2);
  const signatureHash = elements.find(e => e.startsWith('v1='))?.slice(3);
  
  const signedPayload = `${timestamp}.${payload}`;
  const expectedHash = crypto.createHmac('sha256', secret)
    .update(signedPayload)
    .digest('hex');
  
  if (signatureHash !== expectedHash) return null;
  
  // Reject if timestamp is older than 5 minutes (replay protection)
  if (Math.abs(Date.now() / 1000 - Number(timestamp)) > 300) return null;
  
  return JSON.parse(payload);
}
```

### Webhook Processing Patterns

```typescript
// Idempotent event processing with dead letter queue
async function processWebhookEvent(event: WebhookEvent) {
  // 1. Check if already processed (idempotency)
  const existing = await db.webhookEvents.findOne({ eventId: event.id });
  if (existing?.status === 'processed') {
    console.log(`Event ${event.id} already processed, skipping`);
    return;
  }

  // 2. Record the event
  await db.webhookEvents.upsert({
    eventId: event.id,
    type: event.type,
    payload: event,
    status: 'processing',
    receivedAt: new Date(),
  });

  try {
    // 3. Route to handler
    switch (event.type) {
      case 'payment.succeeded':
        await handlePaymentSucceeded(event.data);
        break;
      case 'payment.failed':
        await handlePaymentFailed(event.data);
        break;
      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    // 4. Mark as processed
    await db.webhookEvents.updateOne(
      { eventId: event.id },
      { $set: { status: 'processed', processedAt: new Date() } }
    );
  } catch (error) {
    // 5. Handle failures with retry and dead letter queue
    await db.webhookEvents.updateOne(
      { eventId: event.id },
      { $set: { status: 'failed', error: error.message } }
    );
    
    // Retry logic: max 3 retries with exponential backoff
    const retries = existing?.retryCount || 0;
    if (retries < 3) {
      await scheduleRetry(event.id, retries + 1);
    } else {
      await moveToDeadLetterQueue(event);
      await alertOpsTeam(event, error);
    }
  }
}
```

---

## Part 6: Request/Response Logging

```typescript
// Structured logging for API integrations
interface IntegrationLog {
  timestamp: string;
  service: string;
  method: string;
  url: string;
  statusCode?: number;
  durationMs: number;
  requestId: string;
  error?: string;
  // NEVER log: Authorization headers, tokens, secrets
}

async function loggedRequest<T>(
  client: AxiosInstance,
  method: string,
  url: string,
  options?: { data?: unknown; params?: Record<string, string> }
): Promise<T> {
  const requestId = crypto.randomUUID();
  const startTime = Date.now();
  
  try {
    const response = await client.request({
      method,
      url,
      data: options?.data,
      params: options?.params,
      headers: { 'X-Request-ID': requestId },
    });

    logIntegration({
      timestamp: new Date().toISOString(),
      service: 'stripe',
      method,
      url,
      statusCode: response.status,
      durationMs: Date.now() - startTime,
      requestId,
    });

    return response.data;
  } catch (error) {
    logIntegration({
      timestamp: new Date().toISOString(),
      service: 'stripe',
      method,
      url,
      statusCode: error.response?.status,
      durationMs: Date.now() - startTime,
      requestId,
      error: error.message,
    });
    throw error;
  }
}
```

---

## Part 7: Real-World Integration Examples

### Stripe Payment Integration
```typescript
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

async function createCheckoutSession(items: CartItem[]) {
  return stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: items.map(item => ({
      price_data: {
        currency: 'usd',
        product_data: { name: item.name },
        unit_amount: item.priceInCents,
      },
      quantity: item.quantity,
    })),
    mode: 'payment',
    success_url: `${BASE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${BASE_URL}/cart`,
    idempotency_key: `checkout_${cartId}_${Date.now()}`,
  });
}
```

### GitHub API Integration
```typescript
// Search repositories with pagination
async function searchRepos(query: string) {
  const repos = [];
  let page = 1;
  
  while (true) {
    const response = await githubClient.get('/search/repositories', {
      params: { q: query, page, per_page: 100 },
    });
    
    repos.push(...response.data.items);
    
    if (repos.length >= response.data.total_count || response.data.items.length === 0) break;
    page++;
  }
  
  return repos;
}
```

### Slack Bot Integration
```typescript
// Send message with retry
async function sendSlackMessage(channel: string, text: string) {
  return withRetry(async () => {
    const response = await fetch('https://slack.com/api/chat.postMessage', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.SLACK_BOT_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ channel, text }),
    });
    
    const data = await response.json();
    if (!data.ok) throw new Error(data.error);
    return data;
  });
}
```

---

## Part 8: API Testing Strategies

### Unit Testing with Mocks
```typescript
// Mock the API client
jest.mock('./api-client', () => ({
  apiClient: {
    get: jest.fn(),
    post: jest.fn(),
  },
}));

test('fetches user by ID', async () => {
  const mockUser = { id: '123', name: 'Alice' };
  (apiClient.get as jest.Mock).mockResolvedValue(mockUser);
  
  const user = await getUser('123');
  
  expect(user).toEqual(mockUser);
  expect(apiClient.get).toHaveBeenCalledWith('/users/123');
});
```

### Integration Testing with Record/Replay
```typescript
// Record real API responses, replay in tests
import { setupPolly } from '@pollyjs/core';

const polly = setupPolly({
  adapters: ['fetch'],
  persister: 'fs',
  recordIfStarted: process.env.RECORD === 'true',
});

test('fetches user from GitHub', async () => {
  const user = await githubClient.getUser('octocat');
  expect(user.login).toBe('octocat');
});
```

### Contract Testing
```typescript
// Ensure your client matches the API's contract
import { Pact } from '@pact-foundation/pact';

const provider = new Pact({
  consumer: 'MyApp',
  provider: 'PaymentService',
});

describe('Payment API', () => {
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());

  test('creates a payment', async () => {
    await provider.addInteraction({
      state: 'user has valid card',
      uponReceiving: 'a create payment request',
      withRequest: {
        method: 'POST',
        path: '/payments',
        body: { amount: 1000, currency: 'USD' },
      },
      willRespondWith: {
        status: 201,
        body: { id: 'pay_123', status: 'succeeded' },
      },
    });

    const payment = await paymentClient.create({ amount: 1000, currency: 'USD' });
    expect(payment.status).toBe('succeeded');
  });
});
```

---

## Output Format

- Provide complete, runnable integration code with imports and configuration
- Include a `.env.example` file showing required environment variables
- Add a "Setup" section with steps to obtain API credentials
- Include error handling for common failure modes
- Include resilience patterns (retry, circuit breaker, idempotency) for production use
- Write explanations in the user's language; code and API identifiers in English

## Principles

- **Never expose secrets.** API keys, tokens, and client secrets must come from environment variables or a secrets manager, never from source code.
- **Fail gracefully.** When the API is down or returns an error, the app should not crash. Log the error and return a meaningful response.
- **Use the SDK when available.** Official SDKs handle auth, retries, types, and breaking changes. Don't reinvent the wheel.
- **Validate responses.** Don't trust that the API will always return the expected shape. Validate and handle unexpected data.
- **Log requests and responses (without secrets).** For debugging, log method, URL, status code, and response body — but never log authorization headers or token values.
- **Implement circuit breakers** for critical integrations to prevent cascading failures.
- **Use idempotency keys** for all non-idempotent operations (POST, PATCH) to handle network retries safely.
- **Design for token expiry.** Always implement proactive token refresh before the token expires.
- **Test with sandbox environments** before going to production.
