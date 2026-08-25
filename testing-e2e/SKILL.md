---
name: testing-e2e
description: >-
  Write end-to-end (E2E) tests using Playwright, Cypress, or Selenium to test complete user
  journeys in real browsers. Use this skill when the user mentions E2E testing, end-to-end tests,
  integration tests, UI tests, browser tests, Playwright, Cypress, Selenium, test automation,
  visual regression, screenshot testing, cross-browser testing,
  or says تست E2E، تست یکپارچه، تست مرورگر، تست خودکار، Playwright، Cypress.
---

# E2E Testing Skill — Playwright, Cypress & Browser Test Automation

## Overview

This skill covers end-to-end testing: writing, organizing, and maintaining tests that run in real browsers and test complete user journeys. E2E tests catch issues that unit and integration tests miss: broken UI, incorrect navigation, form submission errors, and cross-browser compatibility. This skill covers Playwright (recommended) and Cypress, with patterns for selectors, assertions, page objects, and CI/CD integration.

## When to Use This Skill

- User wants to write E2E tests for their web application
- User asks about Playwright or Cypress
- User needs to test user flows (login, checkout, etc.)
- User mentions browser testing, UI testing, or visual regression
- User wants to set up E2E testing in CI/CD
- User mentions تست E2E or تست مرورگر

---

## Part 1: Playwright Setup

### Installation

```bash
# Install Playwright
npm init playwright@latest

# Or manually
npm install -D @playwright/test
npx playwright install
```

### Configuration

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { browserName: 'chromium' },
    },
    {
      name: 'firefox',
      use: { browserName: 'firefox' },
    },
    {
      name: 'webkit',
      use: { browserName: 'webkit' },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Basic Test

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="login-button"]');
    
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Welcome');
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[data-testid="email"]', 'wrong@example.com');
    await page.fill('[data-testid="password"]', 'wrongpassword');
    await page.click('[data-testid="login-button"]');
    
    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
    await expect(page.locator('[data-testid="error-message"]')).toContainText('Invalid credentials');
  });
});
```

---

## Part 2: Selectors

### Best Selectors (Priority)

```typescript
// 1. Best: data-testid (stable, developer-controlled)
await page.click('[data-testid="submit-button"]');

// 2. Good: ARIA role + accessible name
await page.getByRole('button', { name: 'Submit' }).click();
await page.getByRole('link', { name: 'Dashboard' }).click();
await page.getByRole('textbox', { name: 'Email' }).fill('test@example.com');

// 3. Good: Text content
await page.getByText('Welcome to Dashboard').click();
await page.getByText('Login', { exact: true }).click();

// 4. OK: Label association
await page.getByLabel('Email').fill('test@example.com');
await page.getByLabel('Password').fill('password');

// 5. Last resort: CSS selector (fragile)
await page.locator('.btn-primary').click();
```

### Locator Methods

```typescript
// Multiple elements
const items = page.locator('[data-testid="list-item"]');
await expect(items).toHaveCount(5);

// First/last/nth
await items.first().click();
await items.nth(2).click();

// Filter
const activeItems = page.locator('[data-testid="list-item"]').filter({ hasText: 'active' });

// Chaining
await page
  .locator('[data-testid="user-card"]')
  .filter({ hasText: 'John' })
  .locator('[data-testid="edit-button"]')
  .click();
```

---

## Part 3: Assertions

### Common Assertions

```typescript
// Page URL
await expect(page).toHaveURL('/dashboard');
await expect(page).toHaveURL(/dashboard/);

// Title
await expect(page).toHaveTitle('Dashboard | MyApp');

// Element visibility
await expect(page.locator('[data-testid="error"]')).toBeVisible();
await expect(page.locator('[data-testid="spinner"]')).toBeHidden();

// Text content
await expect(page.locator('h1')).toContainText('Welcome');
await expect(page.locator('[data-testid="count"]')).toHaveText('5');

// Input value
await expect(page.locator('[data-testid="email"]')).toHaveValue('user@example.com');

// Element count
await expect(page.locator('[data-testid="item"]')).toHaveCount(3);

// CSS properties
await expect(page.locator('.button')).toHaveCSS('background-color', 'rgb(0, 123, 255)');

// Attribute
await expect(page.locator('a')).toHaveAttribute('href', '/about');

// Form state
await expect(page.locator('[data-testid="submit"]')).toBeEnabled();
await expect(page.locator('[data-testid="submit"]')).toBeDisabled();
```

---

## Part 4: Page Object Model

```typescript
// pages/LoginPage.ts
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly loginButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.loginButton = page.getByRole('button', { name: 'Login' });
    this.errorMessage = page.locator('[data-testid="error-message"]');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  async getError(): Promise<string | null> {
    if (await this.errorMessage.isVisible()) {
      return this.errorMessage.textContent();
    }
    return null;
  }
}

// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test('login with valid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  
  await expect(page).toHaveURL('/dashboard');
});
```

---

## Part 5: Test Patterns

### API Mocking

```typescript
test('shows products from API', async ({ page }) => {
  // Mock API response
  await page.route('**/api/products', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([
        { id: 1, name: 'Product 1', price: 9.99 },
        { id: 2, name: 'Product 2', price: 19.99 },
      ]),
    });
  });
  
  await page.goto('/products');
  await expect(page.locator('[data-testid="product"]')).toHaveCount(2);
});

// Intercept and modify
await page.route('**/api/orders', async (route) => {
  const response = await route.fetch();
  const body = await response.json();
  body.push({ id: 99, name: 'Test Order' });
  await route.fulfill({ body: JSON.stringify(body) });
});
```

### File Upload

```typescript
test('upload CSV file', async ({ page }) => {
  await page.goto('/upload');
  
  await page.locator('[data-testid="file-input"]').setInputFiles({
    name: 'data.csv',
    mimeType: 'text/csv',
    buffer: Buffer.from('name,price\nProduct 1,9.99\nProduct 2,19.99'),
  });
  
  await page.click('[data-testid="upload-button"]');
  await expect(page.locator('[data-testid="success"]')).toBeVisible();
});
```

### Authentication Helper

```typescript
// auth.setup.ts
import { test as setup } from '@playwright/test';

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[data-testid="email"]', 'test@example.com');
  await page.fill('[data-testid="password"]', 'password123');
  await page.click('[data-testid="login-button"]');
  await page.waitForURL('/dashboard');
  
  // Save authentication state
  await page.context().storageState({ path: 'auth.json' });
});

// Use saved state
test.use({ storageState: 'auth.json' });

test('access protected page', async ({ page }) => {
  await page.goto('/dashboard');
  await expect(page.locator('h1')).toContainText('Dashboard');
});
```

### Visual Regression

```typescript
test('homepage looks correct', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixelRatio: 0.01,
  });
});

// Full page screenshot
await expect(page).toHaveScreenshot('full-page.png', {
  fullPage: true,
});
```

---

## Part 6: CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/e2e.yml
name: E2E Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright browsers
        run: npx playwright install --with-deps
      
      - name: Run E2E tests
        run: npx playwright test
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

---

## Part 7: Cypress Alternative

```typescript
// cypress/e2e/login.cy.ts
describe('Login', () => {
  it('logs in successfully', () => {
    cy.visit('/login');
    cy.get('[data-testid="email"]').type('user@example.com');
    cy.get('[data-testid="password"]').type('password123');
    cy.get('[data-testid="login-button"]').click();
    cy.url().should('include', '/dashboard');
    cy.get('h1').should('contain', 'Welcome');
  });
});
```

---

## Output Format

```
## E2E Test Suite

### Coverage
| Flow | Tests | Status |
|------|-------|--------|
| Login | 3 | ✅ |
| Checkout | 5 | ✅ |
| Profile | 2 | ⚠️ |

### Configuration
- Framework: [Playwright/Cypress]
- Browsers: [Chrome, Firefox, Safari]
- CI: [GitHub Actions/GitLab CI]
```

## Rules

- **Use data-testid selectors** — Stable, don't break with UI changes
- **Test user journeys, not implementation** — Test what users do, not how it works
- **Keep tests independent** — Each test should work in isolation
- **Use page objects** — Reduce duplication, improve maintainability
- **Mock external services** — Don't depend on third-party APIs
- **Run in CI** — E2E tests should run on every PR
- **Don't test everything with E2E** — Unit and integration tests are faster
- **Handle flakiness** — Retry mechanisms, stable selectors, proper waits
