---
name: browser-automation
description: >-
  Write, debug, and improve browser automation scripts using Playwright, Puppeteer, Selenium, or Cypress for UI testing, E2E testing, web scraping, screenshot generation, and interaction automation. Covers page object models, test fixtures, visual regression testing, network interception, file downloads, multi-tab handling, iframe interaction, drag-and-drop, hover states, responsive testing, mobile emulation, accessibility testing, performance testing, video recording of tests, trace viewing, parallel test execution, CI/CD integration, headless vs headed mode, browser contexts, cookies/localStorage management, geolocation mocking, timezone mocking, permission mocking, device descriptor management, screenshot comparison, PDF generation, web font loading, SPA navigation, client-side routing, WebSocket testing, real-time application testing, form automation, login flow automation, multi-step wizard automation, data-driven testing, API mocking in browser tests, service worker testing, PWA testing, cross-browser testing, visual diff tools, screenshot testing, snapshot testing, interaction testing, state management testing, end-to-end test suites, smoke tests, regression tests, acceptance tests, integration tests with real browser, crawl automation, content extraction, price monitoring, social media automation, form filling bots, RPA (robotic process automation) in browser, test data generation for browser tests, test environment setup, Docker-based browser testing, cloud browser testing (BrowserStack, Sauce Labs, LambdaTest), page load performance testing, Core Web Vitals measurement, accessibility auditing, Lighthouse integration, اتوماسیون مرورگر, تست E2E, تست رابط کاربری, اتوماسیون وب, پلی‌رایت, پاپیتیر, سلنیوم, سایپرس, تست بصری, اسکرین‌شات خودکار, خزش وب, استخراج داده, فرم‌های خودکار, ربات مرورگر, تست چندمرورگری, تست پاسخ‌گو, تست موبایل, or wants to write scripts that control a browser programmatically.
---

# Browser Automation Skill — Playwright, Puppeteer & E2E Testing

## Overview

This skill creates, debugs, and improves browser automation scripts. It covers the full spectrum from simple page navigation and screenshot capture to complex E2E test suites with assertions, wait strategies, and parallel execution. Primary focus is on Playwright (modern, recommended) and Puppeteer, with awareness of Selenium and Cypress patterns.

## When to Use This Skill

- User wants to write browser automation scripts (Playwright, Puppeteer, Selenium, Cypress)
- User needs E2E tests, UI tests, or integration tests that use a real browser
- User wants to automate browser interactions (click, type, navigate, scrape)
- User needs screenshot or PDF generation from web pages
- User wants visual regression testing
- User mentions اتوماسیون مرورگر, تست E2E, or پلی‌رایت
- User needs to automate form filling, login flows, or multi-step wizards
- User wants web scraping with a real browser (JavaScript-rendered content)
- User needs accessibility testing or performance testing via browser
- User wants to test responsive designs or mobile emulation
- User needs to handle iframes, shadow DOM, or web components
- User wants network interception or API mocking in browser tests
- User needs parallel test execution or CI/CD integration for browser tests

## Browser Automation Workflow

### Step 1: Understand the Requirements

1. **What browser and tool?** — Determine if the user has a preference (Playwright, Puppeteer, etc.) or if you should recommend one:
   - **Playwright** — Recommended for new projects. Multi-browser, auto-wait, built-in assertions, TypeScript-native.
   - **Puppeteer** — Good for Chrome-only automation, PDF generation, and simpler scripts.
   - **Cypress** — Good for React/frontend-heavy apps with real-time reload.
   - **Selenium** — Legacy projects, language-agnostic needs.
2. **What are we automating?** — Testing? Scraping? Screenshots? Form submission? Data extraction?
3. **What's the target?** — A specific URL? The user's local dev server? A deployed app?

### Step 2: Check the Project Context

1. Look for existing test configuration:
   - `playwright.config.ts`, `puppeteer.config.js`, `cypress.config.ts`
   - `tests/`, `e2e/`, `spec/` directories
   - `package.json` for installed dependencies
2. Determine if this is a new setup or adding to existing tests
3. Check the framework of the app being tested (React, Vue, Next.js, etc.) — this affects selectors and test patterns

### Step 3: Write the Automation Script

#### Key Principles for Reliable Automation

1. **Use semantic selectors.** Prefer `getByRole`, `getByText`, `getByTestId` over CSS selectors or XPath. They're resilient to styling changes.
2. **Never use `sleep` or fixed timeouts.** Use auto-wait (Playwright) or explicit waits for specific conditions.
3. **Make tests independent.** Each test should set up its own state and clean up after itself.
4. **Handle async properly.** Always `await` browser operations. Never fire-and-forget.

## Output Format Templates

### Template 1: Playwright Test File
```typescript
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
  });

  test('successful login with valid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('user@example.com');
    await page.getByLabel('Password').fill('securepassword');
    await page.getByRole('button', { name: 'Sign In' }).click();

    await expect(page).toHaveURL('/dashboard');
    await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
  });

  test('shows error with invalid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('user@example.com');
    await page.getByLabel('Password').fill('wrongpassword');
    await page.getByRole('button', { name: 'Sign In' }).click();

    await expect(page.getByText('Invalid email or password')).toBeVisible();
    await expect(page).toHaveURL('/login');
  });
});

// How to run:
// npx playwright test tests/auth.spec.ts
// npx playwright test tests/auth.spec.ts --headed     # Watch the browser
// npx playwright test tests/auth.spec.ts --debug       # Step through
```

### Template 2: Playwright Page Object Model
```typescript
// pages/login.page.ts
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.submitButton = page.getByRole('button', { name: 'Sign In' });
    this.errorMessage = page.getByText('Invalid email or password');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}

// tests/auth.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/login.page';

test('login flow with page object', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'securepassword');
  await expect(page).toHaveURL('/dashboard');
});
```

### Template 3: Puppeteer Scripting (Non-Test)
```javascript
import puppeteer from 'puppeteer';

async function scrapeProducts(url) {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  await page.goto(url, { waitUntil: 'networkidle2' });

  const products = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('.product-card')).map(card => ({
      name: card.querySelector('.product-name')?.textContent?.trim(),
      price: card.querySelector('.price')?.textContent?.trim(),
      url: card.querySelector('a')?.href,
    }));
  });

  await browser.close();
  return products;
}

// Usage
const products = await scrapeProducts('https://example.com/products');
console.log(products);
```

### Template 4: Visual Regression Test
```typescript
import { test, expect } from '@playwright/test';

test.describe('Dashboard Visual Regression', () => {
  test('dashboard looks correct', async ({ page }) => {
    await page.goto('/dashboard');
    await page.waitForLoadState('networkidle');

    // Full page snapshot
    await expect(page).toHaveScreenshot('dashboard-full.png', {
      maxDiffPixelRatio: 0.01, // Allow 1% pixel difference
    });

    // Component-level snapshot
    await expect(page.locator('.chart-container')).toHaveScreenshot('chart.png');
  });

  test('dashboard in dark mode', async ({ page }) => {
    await page.goto('/dashboard');
    await page.getByLabel('Theme').selectOption('dark');
    await expect(page).toHaveScreenshot('dashboard-dark.png');
  });

  test('dashboard on mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/dashboard');
    await expect(page).toHaveScreenshot('dashboard-mobile.png');
  });
});

// First run: generates baseline screenshots
// Subsequent runs: compares against baseline
// npx playwright test --update-snapshots  # Update baselines after intentional changes
```

## Advanced Techniques

### 1. Network Interception and API Mocking
Intercept API calls to control the data the page receives. This decouples UI tests from backend availability.

```typescript
test('shows empty state when API returns no data', async ({ page }) => {
  await page.route('**/api/products', route =>
    route.fulfill({ status: 200, body: JSON.stringify({ data: [] }) })
  );

  await page.goto('/products');
  await expect(page.getByText('No products found')).toBeVisible();
});

test('shows error state when API fails', async ({ page }) => {
  await page.route('**/api/products', route =>
    route.fulfill({ status: 500, body: 'Internal Server Error' })
  );

  await page.goto('/products');
  await expect(page.getByText('Something went wrong')).toBeVisible();
});
```

### 2. Storage State Persistence
Avoid logging in before every test by saving and reusing browser storage (cookies, localStorage).

```typescript
// auth.setup.ts — Run once to capture auth state
import { test as setup, expect } from '@playwright/test';

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('admin@example.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await expect(page).toHaveURL('/dashboard');
  await page.context().storageState({ path: '.auth/user.json' });
});

// playwright.config.ts
export default defineConfig({
  projects: [
    { name: 'setup', testMatch: /.*\.setup\.ts/ },
    {
      name: 'authenticated tests',
      use: { storageState: '.auth/user.json' },
      dependencies: ['setup'],
      testMatch: /.*\.spec\.ts/,
    },
  ],
});
```

### 3. Parallel Execution with Worker Isolation
Playwright runs tests in parallel by default within a single file (using workers). For cross-test isolation, use projects or separate browser contexts.

```typescript
// playwright.config.ts
export default defineConfig({
  workers: process.env.CI ? 2 : 4, // Fewer workers in CI to avoid OOM
  retries: process.env.CI ? 2 : 0,   // Retry flaky tests in CI
  reporter: [['html', { open: 'never' }]], // Generate HTML report
});
```

### 4. File Download Handling
```typescript
test('download CSV export', async ({ page }) => {
  const [download] = await Promise.all([
    page.waitForEvent('download'),
    page.getByRole('button', { name: 'Export CSV' }).click(),
  ]);

  const path = await download.path();
  expect(await download.suggestedFilename()).toBe('export.csv');
});
```

### 5. Multi-Tab / Popup Handling
```typescript
test('opens link in new tab', async ({ page, context }) => {
  await page.goto('/dashboard');

  const [newPage] = await Promise.all([
    context.waitForEvent('page'),
    page.getByRole('link', { name: 'Help' }).click(),
  ]);

  await newPage.waitForLoadState('networkidle');
  await expect(newPage).toHaveTitle(/Help Center/);
});
```

### 6. Responsive and Device Testing
```typescript
import { devices } from '@playwright/test';

for (const device of [devices['iPhone 14'], devices['Pixel 7']]) {
  test(`mobile layout on ${device.name}`, async ({ page }) => {
    await page.setViewportSize({ width: device.viewport.width, height: device.viewport.height });
    await page.goto('/dashboard');
    await expect(page).toHaveScreenshot(`${device.name}-dashboard.png`);
  });
}
```

### 7. Accessibility Testing with Playwright
```typescript
import { expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test('dashboard has no accessibility violations', async ({ page }) => {
  await page.goto('/dashboard');

  const accessibilityScanResults = await new AxeBuilder({ page }).analyze();
  expect(accessibilityScanResults.violations).toEqual([]);
});
```

## Common Patterns

### Pattern 1: Data-Driven Testing
```typescript
const credentials = [
  { email: 'admin@test.com', password: 'admin123', expectedRole: 'Admin' },
  { email: 'user@test.com', password: 'user123', expectedRole: 'User' },
  { email: 'guest@test.com', password: 'guest123', expectedRole: 'Guest' },
];

for (const { email, password, expectedRole } of credentials) {
  test(`login as ${expectedRole}`, async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel('Email').fill(email);
    await page.getByLabel('Password').fill(password);
    await page.getByRole('button', { name: 'Sign In' }).click();
    await expect(page.getByText(expectedRole)).toBeVisible();
  });
}
```

### Pattern 2: Multi-Step Wizard Automation
```typescript
test('complete onboarding wizard', async ({ page }) => {
  await page.goto('/onboarding');

  // Step 1: Profile
  await page.getByLabel('Full Name').fill('John Doe');
  await page.getByRole('button', { name: 'Next' }).click();
  await expect(page.getByText('Step 2 of 4')).toBeVisible();

  // Step 2: Preferences
  await page.getByLabel('Receive newsletters').check();
  await page.getByRole('button', { name: 'Next' }).click();
  await expect(page.getByText('Step 3 of 4')).toBeVisible();

  // Step 3: Team
  await page.getByRole('button', { name: 'Skip for now' }).click();

  // Step 4: Confirm
  await page.getByRole('button', { name: 'Complete Setup' }).click();
  await expect(page).toHaveURL('/dashboard');
});
```

### Pattern 3: Web Scraping with Pagination
```javascript
import puppeteer from 'puppeteer';

async function scrapeAllPages(baseUrl) {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  const allItems = [];
  let pageNum = 1;

  while (true) {
    await page.goto(`${baseUrl}?page=${pageNum}`, { waitUntil: 'networkidle2' });
    const items = await page.evaluate(() => {
      return Array.from(document.querySelectorAll('.item')).map(el => ({
        title: el.querySelector('.title')?.textContent.trim(),
        price: el.querySelector('.price')?.textContent.trim(),
      }));
    });

    if (items.length === 0) break;
    allItems.push(...items);
    pageNum++;
  }

  await browser.close();
  return allItems;
}
```

### Pattern 4: API Mocking for Isolated UI Tests
```typescript
test('search with mocked API', async ({ page }) => {
  await page.route('**/api/search**', async route => {
    const url = new URL(route.request().url());
    const query = url.searchParams.get('q');

    if (query === 'playwright') {
      await route.fulfill({
        status: 200,
        body: JSON.stringify({ results: [{ title: 'Playwright Docs', url: '/docs' }] }),
      });
    } else {
      await route.fulfill({ status: 200, body: JSON.stringify({ results: [] }) });
    }
  });

  await page.goto('/search');
  await page.getByPlaceholder('Search...').fill('playwright');
  await page.getByRole('button', { name: 'Search' }).click();
  await expect(page.getByText('Playwright Docs')).toBeVisible();
});
```

### Pattern 5: Drag and Drop Interaction
```typescript
test('reorder items via drag and drop', async ({ page }) => {
  await page.goto('/board');

  const itemA = page.getByTestId('item-a');
  const itemB = page.getByTestId('item-b');

  await itemA.dragTo(itemB);

  // Verify the new order
  const items = page.getByTestId(/^item-/);
  await expect(items.nth(0)).toHaveAttribute('data-testid', 'item-b');
  await expect(items.nth(1)).toHaveAttribute('data-testid', 'item-a');
});
```

## Edge Cases & Pitfalls

1. **Flaky tests from timing** — Never use `setTimeout` or `page.waitForTimeout()`. Use Playwright's auto-wait on assertions, or `page.waitForSelector()` / `page.waitForFunction()` for specific conditions.

2. **CSS selector brittleness** — `.btn-primary.submit` breaks when the designer changes the class name. Use `getByRole`, `getByText`, or `data-testid` attributes.

3. **iframe interaction** — Content inside iframes is in a separate DOM. Use `page.frameLocator('#iframe-id')` in Playwright or `frame()` methods in Puppeteer.

4. **Shadow DOM** — Standard selectors can't pierce shadow DOM. Use `page.locator('my-component').locator('#internal-button')` in Playwright.

5. **File upload inputs** — Use `setInputFiles()` with the full path. For hidden file inputs, you may need to reveal it first with `page.locator('input[type=file]').setInputFiles()`.

6. **Authentication cookies expiring mid-test** — Long test suites may outlive the auth session. Re-authenticate periodically or use storage state.

7. **SPA client-side routing** — After navigation within an SPA, the URL changes but there's no page load. Don't use `waitForNavigation()` — use `waitForURL()` or assertion-based waits.

8. **Dialog/alert handling** — Browser dialogs (alert, confirm, prompt) block execution. Always set up a listener BEFORE the action that triggers the dialog.

9. **Race conditions with multiple tabs** — Opening a new tab is async. Always use `Promise.all([context.waitForEvent('page'), clickAction])` to avoid missing the popup.

10. **CI environment differences** — CI machines have different fonts, screen resolutions, and rendering. Visual regression tests may need looser thresholds or CI-specific baselines.

11. **Memory leaks in test runner** — Not closing the browser or context after tests leads to zombie processes. Use `test.afterAll` to clean up, or let Playwright handle it with its built-in cleanup.

12. **Geolocation and permissions** — Pages requesting location or notifications need explicit permission grants in the browser context. Use `context.grantPermissions()` in Playwright.

13. **Content Security Policy blocking** — CSP headers may block inline scripts or resources that your test relies on. Use `page.route()` to modify response headers if needed.

14. **Dynamic content loaded by scroll** — Infinite scroll content requires simulating scroll events. Use `page.evaluate(() => window.scrollTo(0, document.body.scrollHeight))` in a loop.

15. **WebGL and canvas content** — Visual regression tests on canvas/WebGL elements may differ across machines due to GPU differences. Exclude canvas areas from screenshots or use pixel ratio normalization.

## Integration with Other Skills

- **documentation** — Use when writing E2E test documentation, test strategy docs, or test plan documents.
- **technical-writing** — Use when creating tutorials about browser automation, testing guides, or workshop materials.
- **summarization** — Use when summarizing test results, test coverage reports, or flaky test analysis.
- **api-integration** — Use when browser tests need to interact with real APIs, or when testing API-powered web applications.
- **charts** — Use when generating test result visualizations, coverage charts, or performance benchmark graphs from test data.
- **pdf** — Use when exporting test reports as PDF documents for stakeholders or compliance.

## Principles

- **Reliability over speed.** A slow reliable test beats a fast flaky one.
- **Test behavior, not implementation.** Don't assert on CSS classes or internal state; assert on what the user sees.
- **Keep tests small.** One assertion per test is ideal. Multiple assertions per test are acceptable if they test the same behavior.
- **Use page objects for complex pages.** If a page has 5+ interactions, extract a page object class.
- **Mock external dependencies.** UI tests should not depend on external APIs being available.
- **Run in CI from day one.** Tests that only pass locally are not tests. Ensure CI compatibility from the start.
- **Test the critical path first.** Login, core workflow, and checkout. Expand from there.
- **Make tests independent and idempotent.** Any test should pass regardless of what other tests ran before it.
