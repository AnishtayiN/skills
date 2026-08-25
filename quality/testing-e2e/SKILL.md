---
name: testing-e2e
description: >-
  Write end-to-end tests with Playwright and Cypress, eliminate flaky tests, parallelize in CI,
  and implement visual regression testing. TRIGGERS: E2E testing, end-to-end tests, Playwright,
  Cypress, browser tests, visual regression, screenshot testing, cross-browser testing,
  flaky tests, test automation, page object, test pyramid, CI parallelization,
  تست E2E، تست یکپارچه، تست مرورگر، تست خودکار، Playwright، Cypress,
  端到端测试, E2E测试, Playwright, Cypress, 浏览器测试, 截图测试, 视觉回归
priority: P2
dependencies: [ci-cd, testing]
conflicts: []
---

# E2E Testing Skill — Playwright, Cypress, Flaky Test Elimination & Visual Regression

## Overview

End-to-end (E2E) tests validate complete user journeys in real browsers, catching issues that unit and integration tests cannot: broken UI, incorrect navigation, form submission failures, API integration bugs, and cross-browser incompatibilities. This skill covers Playwright (recommended) and Cypress in depth: configuration, selectors, assertions, page objects, API mocking, authentication helpers, CI/CD integration with parallelization, flaky test identification and elimination, visual regression testing, and strategic placement in the test pyramid. The goal is reliable, fast, and maintainable E2E test suites that catch real bugs without creating development friction.

## When to Use This Skill

- Writing E2E tests for critical user journeys (login, checkout, onboarding)
- Setting up Playwright or Cypress for a new or existing project
- Eliminating flaky tests that fail intermittently and erode trust
- Implementing visual regression testing to catch UI drift
- Parallelizing E2E tests in CI to reduce pipeline time
- Configuring cross-browser testing (Chromium, Firefox, WebKit)
- Building page objects or component objects for test maintainability
- Setting up API mocking to isolate frontend from backend
- Integrating E2E tests into CI/CD pipelines with proper artifact handling

## When NOT to Use This Skill

- Writing unit tests (→ testing)
- Writing integration tests (→ testing)
- Setting up CI/CD pipelines (→ ci-cd)
- Testing accessibility specifically (→ accessibility)
- Writing API tests (→ testing or api-design)
- Performance/load testing (→ performance)
- Debugging application logic (→ debugging)
- Testing mobile-native apps (→ mobile testing)

## Workflow

### Step 1: Plan Test Coverage

```
1. Map critical user journeys (business value × risk)
2. Identify happy path, error path, and edge cases per journey
3. Determine which journeys justify E2E vs integration tests
4. Design test data strategy (fixtures, factories, seeding)
5. Plan authentication approach (login helpers, stored state)
```

### Step 2: Implement Tests

```
1. Configure Playwright/Cypress with proper settings
2. Create reusable page objects for critical flows
3. Write tests using stable selectors (data-testid, roles, labels)
4. Add API mocking for external dependencies
5. Implement proper assertions (visibility, URL, text, state)
```

### Step 3: CI/CD Integration

```
1. Configure parallel test execution
2. Set up browser installation and caching
3. Configure artifact collection (reports, traces, screenshots)
4. Add retry logic for known-flaky patterns
5. Set up failure notifications (Slack, PR comments)
```

### Step 4: Maintain and Optimize

```
1. Monitor flaky test rates weekly
2. Delete tests that no longer provide value
3. Update selectors when UI changes
4. Review and prune test suite quarterly
5. Track test suite health metrics (pass rate, duration, flakiness)
```

## Advanced Techniques

### 1. Playwright Configuration for Production

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  timeout: 30_000,
  expect: {
    timeout: 5_000,
  },

  reporter: process.env.CI
    ? [
        ['html', { outputFolder: 'playwright-report', open: 'never' }],
        ['json', { outputFile: 'test-results.json' }],
        ['github'],
      ]
    : [['html', { open: 'on-failure' }]],

  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10_000,
    navigationTimeout: 15_000,
  },

  projects: [
    // Setup project: authenticate once, save state
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },

    // Chromium (primary)
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'e2e/.auth/user.json',
      },
      dependencies: ['setup'],
    },

    // Firefox
    {
      name: 'firefox',
      use: {
        ...devices['Desktop Firefox'],
        storageState: 'e2e/.auth/user.json',
      },
      dependencies: ['setup'],
    },

    // WebKit (Safari engine)
    {
      name: 'webkit',
      use: {
        ...devices['Desktop Safari'],
        storageState: 'e2e/.auth/user.json',
      },
      dependencies: ['setup'],
    },

    // Mobile viewport tests
    {
      name: 'mobile-chrome',
      use: {
        ...devices['Pixel 5'],
        storageState: 'e2e/.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],

  webServer: process.env.CI
    ? undefined // CI provides its own server
    : {
        command: 'npm run dev',
        url: 'http://localhost:3000',
        reuseExistingServer: true,
        timeout: 30_000,
      },
});
```

### 2. Authentication Setup and State Management

```typescript
// e2e/auth.setup.ts
import { test as setup, expect } from '@playwright/test';

const authFile = 'e2e/.auth/user.json';

setup('authenticate as standard user', async ({ page }) => {
  // Navigate to login
  await page.goto('/login');

  // Fill in credentials
  await page.getByLabel('Email').fill(process.env.TEST_USER_EMAIL || 'test@example.com');
  await page.getByLabel('Password').fill(process.env.TEST_USER_PASSWORD || 'testpassword123');

  // Submit login
  await page.getByRole('button', { name: 'Sign in' }).click();

  // Wait for redirect to dashboard
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Dashboard');

  // Save authentication state
  await page.context().storageState({ path: authFile });
});

// ── Page Object: Login ──

import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly signInButton: Locator;
  readonly errorMessage: Locator;
  readonly forgotPasswordLink: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.signInButton = page.getByRole('button', { name: 'Sign in' });
    this.errorMessage = page.locator('[data-testid="login-error"]');
    this.forgotPasswordLink = page.getByRole('link', { name: 'Forgot password?' });
  }

  async goto() {
    await this.page.goto('/login');
    await this.waitForReady();
  }

  async waitForReady() {
    await this.emailInput.waitFor({ state: 'visible' });
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.signInButton.click();
  }

  async getError(): Promise<string | null> {
    if (await this.errorMessage.isVisible()) {
      return (await this.errorMessage.textContent()) ?? null;
    }
    return null;
  }
}

// ── Page Object: Dashboard ──

export class DashboardPage {
  readonly page: Page;
  readonly heading: Locator;
  readonly userMenu: Locator;
  readonly notificationBell: Locator;
  readonly notificationCount: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: 'Dashboard' });
    this.userMenu = page.getByRole('button', { name: /user menu/i });
    this.notificationBell = page.getByRole('button', { name: /notifications/i });
    this.notificationCount = page.locator('[data-testid="notification-count"]');
  }

  async expectLoaded() {
    await expect(this.heading).toBeVisible();
  }

  async openUserMenu() {
    await this.userMenu.click();
  }

  async getNotificationCount(): Promise<number> {
    const text = await this.notificationCount.textContent();
    return text ? parseInt(text, 10) : 0;
  }
}

// ── Page Object: Checkout ──

export class CheckoutPage {
  readonly page: Page;
  readonly cartSummary: Locator;
  readonly totalPrice: Locator;
  readonly checkoutButton: Locator;
  readonly paymentForm: Locator;
  readonly submitOrderButton: Locator;
  readonly orderConfirmation: Locator;

  constructor(page: Page) {
    this.page = page;
    this.cartSummary = page.locator('[data-testid="cart-summary"]');
    this.totalPrice = page.locator('[data-testid="total-price"]');
    this.checkoutButton = page.getByRole('button', { name: 'Proceed to checkout' });
    this.paymentForm = page.locator('[data-testid="payment-form"]');
    this.submitOrderButton = page.getByRole('button', { name: 'Place order' });
    this.orderConfirmation = page.locator('[data-testid="order-confirmation"]');
  }

  async proceedToCheckout() {
    await this.checkoutButton.click();
    await this.paymentForm.waitFor({ state: 'visible' });
  }

  async fillPayment(cardNumber: string, expiry: string, cvv: string) {
    await page.getByLabel('Card number').fill(cardNumber);
    await page.getByLabel('Expiry date').fill(expiry);
    await page.getByLabel('CVV').fill(cvv);
  }

  async placeOrder() {
    await this.submitOrderButton.click();
    await this.orderConfirmation.waitFor({ state: 'visible' });
  }
}
```

### 3. Stable Selectors Strategy

```typescript
// ── Selector Priority (most stable → least stable) ──

// 1. data-testid (best: developer-controlled, framework-independent)
await page.click('[data-testid="submit-button"]');
await page.fill('[data-testid="email-input"]', 'user@example.com');

// 2. ARIA role + accessible name (good: matches screen reader experience)
await page.getByRole('button', { name: 'Submit' }).click();
await page.getByRole('link', { name: 'Dashboard' }).click();
await page.getByRole('textbox', { name: 'Email' }).fill('test@example.com');
await page.getByRole('heading', { name: 'Welcome' }).isVisible();

// 3. Label association (good: tests actual form accessibility)
await page.getByLabel('Email').fill('test@example.com');
await page.getByLabel('Password').fill('password');

// 4. Text content (ok: can break with copy changes)
await page.getByText('Welcome to Dashboard').click();
await page.getByText('Login', { exact: true }).click();

// 5. Placeholder text (acceptable for inputs)
await page.getByPlaceholder('Enter your email').fill('test@example.com');

// 6. CSS selectors (last resort: fragile)
await page.locator('.btn-primary').click();
await page.locator('#submit-form').submit();

// ── ❌ BAD: Brittle selectors that break with any UI change ──
await page.click('.app > div:nth-child(2) > form > button:nth-child(3)');
await page.click('button.css-1a2b3c');
await page.click('text=Submit >> xpath=.. >> button');

// ── ✅ GOOD: Stable selectors that survive refactors ──
await page.getByRole('button', { name: 'Submit' }).click();
await page.click('[data-testid="submit-button"]');
```

### 4. Flaky Test Detection and Elimination

```typescript
// ── Common Flaky Test Patterns and Fixes ──

// ❌ FLAKY: Race condition — element may not be ready
test('add item to cart', async ({ page }) => {
  await page.goto('/products');
  await page.click('[data-testid="add-to-cart"]'); // May click before page loads
  await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');
});

// ✅ STABLE: Wait for specific state before acting
test('add item to cart', async ({ page }) => {
  await page.goto('/products');
  await expect(page.locator('[data-testid="product-list"]')).toBeVisible();
  await page.getByRole('button', { name: 'Add to cart' }).click();
  await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');
});

// ❌ FLAKY: Hard-coded timeout
test('load dashboard', async ({ page }) => {
  await page.goto('/dashboard');
  await page.waitForTimeout(3000); // Arbitrary wait
  await expect(page.locator('.chart')).toBeVisible();
});

// ✅ STABLE: Wait for specific condition
test('load dashboard', async ({ page }) => {
  await page.goto('/dashboard');
  await expect(page.locator('[data-testid="chart"]')).toBeVisible({ timeout: 15_000 });
  await expect(page.locator('[data-testid="chart"]')).not.toHaveAttribute('aria-busy', 'true');
});

// ❌ FLAKY: Depends on API response timing
test('display user name', async ({ page }) => {
  await page.goto('/profile');
  const name = await page.locator('[data-testid="user-name"]').textContent();
  expect(name).toBe('John Doe');
});

// ✅ STABLE: Mock API or wait for specific state
test('display user name', async ({ page }) => {
  await page.route('**/api/user', async (route) => {
    await route.fulfill({
      status: 200,
      body: JSON.stringify({ name: 'John Doe', email: 'john@example.com' }),
    });
  });
  await page.goto('/profile');
  await expect(page.locator('[data-testid="user-name"]')).toHaveText('John Doe');
});

// ── Flaky Test Detector: Track test stability ──

interface TestResult {
  name: string;
  file: string;
  passed: boolean;
  duration: number;
  retryAttempt: number;
  timestamp: string;
}

class FlakyTestTracker {
  private results: Map<string, TestResult[]> = new Map();

  record(result: TestResult): void {
    const key = `${result.file}::${result.name}`;
    if (!this.results.has(key)) {
      this.results.set(key, []);
    }
    this.results.get(key)!.push(result);
  }

  /**
   * Identify tests that have been retried (flaky indicator).
   */
  getFlakyTests(minRetries: number = 2): Array<{
    name: string;
    file: string;
    flakyRate: number;
    totalRuns: number;
    retriedRuns: number;
    avgDuration: number;
  }> {
    const flaky: Array<{
      name: string;
      file: string;
      flakyRate: number;
      totalRuns: number;
      retriedRuns: number;
      avgDuration: number;
    }> = [];

    for (const [key, results] of this.results) {
      const [file, name] = key.split('::');
      const retriedRuns = results.filter(r => r.retryAttempt > 0).length;
      const totalRuns = results.length;
      const flakyRate = retriedRuns / totalRuns;
      const avgDuration = results.reduce((sum, r) => sum + r.duration, 0) / totalRuns;

      if (retriedRuns >= minRetries || flakyRate > 0.1) {
        flaky.push({ name, file, flakyRate, totalRuns, retriedRuns, avgDuration });
      }
    }

    return flaky.sort((a, b) => b.flakyRate - a.flakyRate);
  }

  /**
   * Generate a stability report.
   */
  generateReport(): string {
    const flaky = this.getFlakyTests();
    const totalTests = this.results.size;
    const flakyCount = flaky.length;

    return `## Test Stability Report

### Summary
- **Total unique tests:** ${totalTests}
- **Flaky tests:** ${flakyCount} (${((flakyCount / totalTests) * 100).toFixed(1)}%)
- **Stable tests:** ${totalTests - flakyCount}

### Flaky Tests (sorted by flaky rate)
| Test | File | Flaky Rate | Runs | Retried | Avg Duration |
|------|------|------------|------|---------|-------------|
${flaky.map(f => `| ${f.name} | ${f.file} | ${(f.flakyRate * 100).toFixed(0)}% | ${f.totalRuns} | ${f.retriedRuns} | ${f.avgDuration.toFixed(0)}ms |`).join('\n')}

### Recommendations
${flaky.filter(f => f.flakyRate > 0.3).map(f =>
  `- **${f.name}**: Flaky rate ${(f.flakyRate * 100).toFixed(0)}% — consider rewriting or deleting`
).join('\n')}
`;
  }
}
```

### 5. Visual Regression Testing

```typescript
// ── Playwright Visual Regression ──

import { test, expect } from '@playwright/test';

test.describe('Visual Regression', () => {
  test('homepage matches snapshot', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveScreenshot('homepage.png', {
      maxDiffPixelRatio: 0.01,
      animations: 'disabled', // Freeze CSS animations for consistency
    });
  });

  test('login page matches snapshot', async ({ page }) => {
    await page.goto('/login');
    await expect(page).toHaveScreenshot('login.png', {
      maxDiffPixelRatio: 0.01,
    });
  });

  test('dashboard with data matches snapshot', async ({ page }) => {
    // Mock API to ensure consistent data
    await page.route('**/api/dashboard', async (route) => {
      await route.fulfill({
        status: 200,
        body: JSON.stringify({
          stats: { users: 1234, revenue: 56789, orders: 890 },
          chartData: [/* consistent data */],
        }),
      });
    });

    await page.goto('/dashboard');
    await expect(page.locator('[data-testid="stats-panel"]')).toBeVisible();
    await expect(page).toHaveScreenshot('dashboard-with-data.png', {
      maxDiffPixelRatio: 0.01,
    });
  });

  test('responsive: mobile homepage', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 }); // iPhone X
    await page.goto('/');
    await expect(page).toHaveScreenshot('homepage-mobile.png', {
      maxDiffPixelRatio: 0.01,
    });
  });

  test('dark mode homepage', async ({ page }) => {
    await page.emulateMedia({ colorScheme: 'dark' });
    await page.goto('/');
    await expect(page).toHaveScreenshot('homepage-dark.png', {
      maxDiffPixelRatio: 0.01,
    });
  });
});

// ── Update snapshots when design intentionally changes ──
// npx playwright test --update-snapshots

// ── CI configuration for visual regression ──
// In CI, compare against the baseline snapshots committed to the repo.
// Use a separate job for visual regression to isolate failures.
```

### 6. CI Parallelization and Sharding

```yaml
# .github/workflows/e2e.yml
name: E2E Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    timeout-minutes: 30
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [1, 2, 3, 4]

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps chromium

      - name: Run E2E tests (shard ${{ matrix.shard }}/4)
        run: npx playwright test --shard=${{ matrix.shard }}/4

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-results-${{ matrix.shard }}
          path: |
            test-results/
            playwright-report/
          retention-days: 14

  # Merge results from all shards
  merge-results:
    if: always()
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Download all artifacts
        uses: actions/download-artifact@v4
        with:
          pattern: playwright-results-*
          merge-multiple: true
          path: all-results/

      - name: Check for failures
        run: |
          if [ -f all-results/test-results.json ]; then
            FAILURES=$(cat all-results/test-results.json | jq '.suites[].specs[] | select(.ok == false) | length')
            if [ "$FAILURES" -gt 0 ]; then
              echo "E2E tests failed"
              exit 1
            fi
          fi
```

### 7. API Mocking and Network Interception

```typescript
// ── Mock entire API layer for deterministic tests ──

test('product listing with mocked API', async ({ page }) => {
  // Mock products endpoint
  await page.route('**/api/products', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        products: [
          { id: 1, name: 'Widget A', price: 9.99, inStock: true },
          { id: 2, name: 'Widget B', price: 19.99, inStock: true },
          { id: 3, name: 'Widget C', price: 29.99, inStock: false },
        ],
        total: 3,
        page: 1,
      }),
    });
  });

  await page.goto('/products');

  // Verify products rendered
  await expect(page.locator('[data-testid="product-card"]')).toHaveCount(3);
  await expect(page.locator('[data-testid="product-card"]').first())
    .toContainText('Widget A');

  // Verify out-of-stock badge
  await expect(page.locator('[data-testid="out-of-stock"]').first())
    .toBeVisible();
});

// ── Mock error responses ──

test('handles API error gracefully', async ({ page }) => {
  await page.route('**/api/products', async (route) => {
    await route.fulfill({
      status: 500,
      body: JSON.stringify({ error: 'Internal server error' }),
    });
  });

  await page.goto('/products');

  await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
  await expect(page.locator('[data-testid="error-message"]'))
    .toContainText('Something went wrong');
});

// ── Modify responses (add items, change status) ──

test('add item to cart updates count', async ({ page }) => {
  let cartCount = 0;

  await page.route('**/api/cart', async (route) => {
    if (route.request().method() === 'POST') {
      cartCount++;
      await route.fulfill({
        status: 200,
        body: JSON.stringify({ count: cartCount }),
      });
    } else {
      await route.fulfill({
        status: 200,
        body: JSON.stringify({ count: cartCount }),
      });
    }
  });

  await page.goto('/products');
  await page.getByRole('button', { name: 'Add to cart' }).first().click();
  await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');
});

// ── Simulate slow network ──

test('shows loading state during slow API', async ({ page }) => {
  await page.route('**/api/products', async (route) => {
    // Simulate 3-second delay
    await new Promise(resolve => setTimeout(resolve, 3000));
    await route.fulfill({
      status: 200,
      body: JSON.stringify({ products: [] }),
    });
  });

  await page.goto('/products');
  await expect(page.locator('[data-testid="loading-spinner"]')).toBeVisible();
  await expect(page.locator('[data-testid="loading-spinner"]')).toBeHidden();
});
```

### 8. Cypress Alternative Pattern

```typescript
// cypress/e2e/checkout.cy.ts

describe('Checkout Flow', () => {
  beforeEach(() => {
    cy.intercept('GET', '/api/products', { fixture: 'products.json' }).as('getProducts');
    cy.intercept('POST', '/api/orders', { statusCode: 201, body: { orderId: 'ORD-123' } }).as('createOrder');
    cy.visit('/products');
    cy.wait('@getProducts');
  });

  it('completes checkout successfully', () => {
    // Add item to cart
    cy.get('[data-testid="product-card"]').first().within(() => {
      cy.get('button').contains('Add to cart').click();
    });

    // Verify cart count
    cy.get('[data-testid="cart-count"]').should('have.text', '1');

    // Go to checkout
    cy.get('[data-testid="checkout-button"]').click();
    cy.url().should('include', '/checkout');

    // Fill payment form
    cy.get('[data-testid="card-number"]').type('4242424242424242');
    cy.get('[data-testid="expiry"]').type('12/25');
    cy.get('[data-testid="cvv"]').type('123');

    // Place order
    cy.get('[data-testid="place-order"]').click();
    cy.wait('@createOrder');

    // Verify confirmation
    cy.url().should('include', '/order-confirmation');
    cy.get('[data-testid="order-id"]').should('contain', 'ORD-123');
  });

  it('shows validation errors for empty form', () => {
    cy.get('[data-testid="checkout-button"]').click();
    cy.get('[data-testid="place-order"]').click();

    cy.get('[data-testid="card-number-error"]').should('be.visible');
    cy.get('[data-testid="expiry-error"]').should('be.visible');
    cy.get('[data-testid="cvv-error"]').should('be.visible');
  });
});
```

## Common Patterns

### Pattern 1: Data-Testid Convention

```typescript
// Naming convention: component-action-target
// Examples:
data-testid="login-form"
data-testid="login-form-email"
data-testid="login-form-submit"
data-testid="login-form-error"

data-testid="product-list"
data-testid="product-card"
data-testid="product-card-name"
data-testid="product-card-price"
data-testid="product-card-add-to-cart"

data-testid="cart-sidebar"
data-testid="cart-sidebar-item"
data-testid="cart-sidebar-total"
data-testid="cart-sidebar-checkout"
```

### Pattern 2: Test Isolation with Database Seeding

```typescript
// Before each test, seed a clean database state
test.beforeEach(async ({ request }) => {
  // Reset database via API
  await request.post('/api/test/seed', {
    data: {
      users: [
        { id: 'user-1', email: 'test@example.com', name: 'Test User' },
      ],
      products: [
        { id: 'prod-1', name: 'Widget', price: 9.99 },
      ],
    },
  });
});

test('user can view products', async ({ page }) => {
  await page.goto('/products');
  await expect(page.locator('[data-testid="product-card"]')).toHaveCount(1);
});
```

### Pattern 3: Custom Playwright Fixture

```typescript
// e2e/fixtures.ts
import { test as base, expect, Page } from '@playwright/test';

type TestFixtures = {
  loginPage: LoginPage;
  dashboardPage: DashboardPage;
  authenticatedPage: Page;
};

export const test = base.extend<TestFixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },

  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },

  authenticatedPage: async ({ browser }, use) => {
    const context = await browser.newContext({
      storageState: 'e2e/.auth/user.json',
    });
    const page = await context.newPage();
    await use(page);
    await context.close();
  },
});

export { expect };
```

### Pattern 4: Test Data Factory

```typescript
// e2e/factories.ts
import { faker } from '@faker-js/faker';

export function createTestUser(overrides?: Partial<User>) {
  return {
    id: faker.string.uuid(),
    email: faker.internet.email(),
    name: faker.person.fullName(),
    password: faker.internet.password({ length: 12 }),
    ...overrides,
  };
}

export function createTestProduct(overrides?: Partial<Product>) {
  return {
    id: faker.string.uuid(),
    name: faker.commerce.productName(),
    price: parseFloat(faker.commerce.price()),
    description: faker.commerce.productDescription(),
    inStock: true,
    ...overrides,
  };
}

export function createTestOrder(overrides?: Partial<Order>) {
  return {
    id: `ORD-${faker.string.alphanumeric(8).toUpperCase()}`,
    userId: faker.string.uuid(),
    items: [createTestProduct()],
    totalAmount: parseFloat(faker.commerce.price()),
    status: 'pending' as const,
    createdAt: faker.date.recent().toISOString(),
    ...overrides,
  };
}
```

### Pattern 5: Flaky Test Quarantine with Auto-Triage

```typescript
// playwright.config.ts — retries + report the flakiness, don't hide it
export default defineConfig({
  retries: process.env.CI ? 2 : 0,
  reporter: [['json', { outputFile: 'results.json' }]],
});

// scripts/quarantine.ts — run in CI after the suite:
// A test that PASSED on retry is flaky, not fixed.
import { readFileSync } from 'fs';

const results = JSON.parse(readFileSync('results.json', 'utf8'));
const flaky = [...results.suites]
  .flatMap(s => s.specs ?? [])
  .filter(spec => spec.ok && spec.tests.some(t => t.results.length > 1));

for (const spec of flaky) {
  const file = spec.file.replace(/^\.\//, '');
  console.log(`::warning::FLAKY ${spec.title} (${file})`);
  // Append to quarantine list → test runs on separate schedule,
  // still visible, but stops blocking every PR:
  appendTo('.quarantine', `${file}:${spec.line} # auto-flagged ${new Date().toISOString()}\n`);
}

// playwright grep inversion keeps quarantined specs out of the main gate:
//   npx playwright test --grep-invert "$(cat .quarantine | cut -d: -f1 | paste -sd'|')"
```

**Discipline:** a quarantine entry MUST have an owner and an issue link; anything older than 14 days fails the weekly audit instead of hiding forever.

## Edge Cases & Pitfalls

1. **Tests that depend on time** — Using `new Date()` in tests creates non-deterministic results. Mock time with Playwright's `page.clock` or fixed timestamps in API mocks.

2. **Shared mutable test state** — Tests that modify shared data (database, files, cookies) break other tests. Each test must set up its own state and clean up after itself.

3. **Assertions without waits** — `expect(element).toHaveText('x')` fails if the element has not yet updated. Playwright auto-waits assertions, but some patterns need explicit waits.

4. **Cross-origin navigation in tests** — Tests that navigate to external URLs (OAuth, payment processors) are inherently flaky. Mock external services instead.

5. **Hard-coded port numbers** — If your dev server runs on a random port, tests break. Use environment variables and the `webServer` config in Playwright.

6. **Missing `data-testid` on key elements** — Without stable selectors, tests break on every CSS refactor. Require `data-testid` on all interactive and significant elements.

7. **Tests that run sequentially when they should be parallel** — Tests with shared state cannot run in parallel. Use `test.describe.serial` only when truly necessary.

8. **Video/trace collection filling disk** — Recording every test video and trace generates gigabytes of data. Use `retain-on-failure` or `on-first-retry` modes.

9. **Flaky tests silently retried** — Retrying flaky tests hides real problems. Track retry rates and fix or delete tests with >10% flaky rate.

10. **Browser installation not cached in CI** — Installing Playwright browsers on every CI run wastes 2-5 minutes. Cache the browser binaries or use the Playwright Docker image.

11. **Missing error context in failures** — When a test fails in CI, you need screenshots, traces, and logs. Configure `trace: 'on-first-retry'` and `screenshot: 'only-on-failure'`.

12. **Over-testing with E2E** — E2E tests are slow and expensive. Use them for critical user journeys only; unit and integration tests cover the rest faster.

13. **Ignoring mobile viewports** — Desktop-only tests miss responsive layout bugs. Add at least one mobile viewport test for critical flows.

14. **Test data leaking between tests** — API mocks and route interceptors from one test may affect the next. Use `page.unrouteAll()` in `afterEach` or rely on test isolation.

15. **Snapshot files not committed** — Visual regression snapshots must be committed to the repository. Forgetting to commit updated snapshots causes false failures for all team members.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| ci-cd | Parallel test execution, artifact collection | ↔ | CI orchestrates E2E runs; E2E results gate deployments |
| accessibility | axe-core assertions in E2E tests | → | E2E tests include accessibility checks as first-class assertions |
| feature-flag | Flag-aware test variants | ← | Tests must cover both flag states; use API to set flags in test setup |
| monitoring-observability | Test metrics in dashboards | → | Track test flakiness, duration, and pass rate as metrics |
| api-design | API contract verification | ← | E2E tests verify frontend-backend integration matches API contracts |
| deployment | Smoke tests after deployment | → | Post-deploy E2E smoke tests verify critical paths work |
| testing | Unit/integration test complementary | ↔ | E2E covers user journeys; unit/integration cover logic and boundaries |

## Output Format Templates

### Template 1: E2E Test Plan

```markdown
## E2E Test Plan: {Project Name}

### Critical User Journeys
| Journey | Priority | Pages | Estimated Tests |
|---------|----------|-------|----------------|
| User registration | P0 | /signup, /verify-email | 4 |
| Login/logout | P0 | /login, /logout | 3 |
| Product browsing | P0 | /products, /products/:id | 5 |
| Checkout flow | P0 | /cart, /checkout, /confirmation | 6 |
| User profile | P1 | /profile, /settings | 4 |
| Password reset | P1 | /forgot-password, /reset | 3 |

### Test Infrastructure
- Framework: Playwright
- Browsers: Chromium (primary), Firefox, WebKit
- Authentication: Stored state (login once, reuse)
- API mocking: MSW or Playwright route interception
- Visual regression: Playwright screenshots
- CI: GitHub Actions with 4-way sharding

### Test Data Strategy
- User accounts: Pre-seeded in test database
- Products: Factory-generated with deterministic data
- Orders: Created via API in test setup
- Cleanup: Database reset between test suites
```

### Template 2: Test Suite Health Report

```markdown
## E2E Test Suite Health — {Date}

### Summary
| Metric | Value | Trend |
|--------|-------|-------|
| Total tests | 85 | ↑ 5 |
| Pass rate | 98.2% | ↑ 1.2% |
| Flaky rate | 2.3% | ↓ 0.5% |
| Avg duration | 12.5s | ↓ 0.3s |
| Total suite time | 18m | ↓ 2m |

### Flaky Tests
| Test | Flaky Rate | Last 30 Days | Action |
|------|------------|-------------|--------|
| checkout/processes payment | 15% | 3/20 runs | Investigate |
| dashboard/loads chart data | 8% | 2/25 runs | Monitor |

### Slowest Tests
| Test | Avg Duration | P95 Duration |
|------|-------------|-------------|
| checkout/full flow | 12.3s | 15.1s |
| auth/login with OAuth | 8.7s | 11.2s |

### Coverage by Flow
| Flow | Tests | Status |
|------|-------|--------|
| Authentication | 8 | ✅ |
| Checkout | 12 | ✅ |
| Product browsing | 6 | ✅ |
| User profile | 4 | ⚠️ Missing edge cases |
```

### Template 3: Playwright Configuration Template

```markdown
## Playwright Configuration

### Projects
| Project | Browser | Viewport | Storage State |
|---------|---------|----------|---------------|
| chromium | Chrome | 1280x720 | auth/user.json |
| firefox | Firefox | 1280x720 | auth/user.json |
| webkit | Safari | 1280x720 | auth/user.json |
| mobile | Mobile Chrome | 375x812 | auth/user.json |

### Timeouts
| Setting | Value |
|---------|-------|
| Test timeout | 30s |
| Action timeout | 10s |
| Navigation timeout | 15s |
| Expect timeout | 5s |

### Artifacts
| Artifact | When | Retention |
|----------|------|-----------|
| Trace | On first retry | 14 days |
| Screenshot | On failure | 14 days |
| Video | On failure | 14 days |
| HTML report | Always | 14 days |
```

### Template 4: Flaky Test Triage

```markdown
## Flaky Test Triage — {Date}

### Process
1. Identify top 10 flaky tests by flaky rate
2. Classify root cause (timing, network, state, data)
3. Assign fix owner
4. Implement fix or mark for deletion
5. Verify fix reduces flaky rate to < 1%

### Root Cause Categories
| Category | Count | Example Fix |
|----------|-------|-------------|
| Timing/race condition | 5 | Add explicit wait for element state |
| Network dependency | 3 | Mock API responses |
| Shared test state | 2 | Add database seeding/cleanup |
| Browser difference | 1 | Skip on affected browser |
| Unknown | 2 | Add more logging, reproduce locally |

### Actions
| Test | Root Cause | Fix | Owner | Status |
|------|------------|-----|-------|--------|
| test-name | Timing | Add waitForSelector | @name | In Progress |
```

## Rules

1. **Use data-testid selectors** — They are stable across refactors, framework-agnostic, and self-documenting. Every interactive and significant element should have one.

2. **Test user journeys, not implementation** — Test what users do (click button, fill form), not how it works internally (React state, Redux actions). Implementation tests break on refactors.

3. **Keep tests independent** — Each test must work in isolation without depending on other tests. Tests that run in a specific order are fragile and cannot be parallelized.

4. **Use page objects for complex flows** — Page objects encapsulate selectors and actions for a page, reducing duplication and making maintenance easier when UI changes.

5. **Mock external services** — Never depend on third-party APIs in E2E tests. Mock payment processors, OAuth providers, email services, and any external HTTP calls.

6. **Run in CI on every PR** — E2E tests should gate merges. If they are too slow, run only critical path tests on PRs and full suite on main.

7. **Don't test everything with E2E** — Unit tests are 10-100x faster. Use E2E for critical user journeys; use unit/integration tests for logic, components, and API contracts.

8. **Track and eliminate flaky tests weekly** — A test that fails intermittently teaches the team to ignore failures. Track flaky rates and fix or delete tests with >5% flaky rate.

9. **Configure trace and screenshot on failure** — When tests fail in CI, you need evidence. Playwright traces show every action and DOM state; screenshots show what the user saw.

10. **Parallelize aggressively** — Playwright's `fullyParallel` and `--shard` options can reduce CI time by 4-8x. Tests must be independent to parallelize safely.

11. **Update snapshots intentionally** — Visual regression snapshots capture current state. When design changes are intentional, update snapshots with `--update-snapshots` and commit the change.

12. **Prune test suite quarterly** — Delete tests that no longer catch bugs, test deprecated features, or duplicate coverage. A lean test suite is faster and easier to maintain.
