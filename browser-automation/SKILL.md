---
name: browser-automation
description: >-
  Write, debug, and improve browser automation scripts using Playwright, Puppeteer, Selenium, or Cypress for UI testing, E2E testing, web scraping, screenshot generation, and interaction automation. Use this skill whenever the user mentions browser automation, Playwright, Puppeteer, Selenium, Cypress, UI testing, E2E test, end-to-end test, automate browser, web scraping with browser, screenshot testing, visual regression testing, page automation, headless browser, اتوماسیون مرورگر, تست E2E, تست رابط کاربری, اتوماسیون وب, پلی‌رایت, پاپیتیر, or wants to write scripts that control a browser programmatically.
---

# Browser Automation Skill — Complete Playwright, Puppeteer & E2E Mastery

## Overview

This skill creates, debugs, and improves browser automation scripts. It covers the full spectrum from simple page navigation and screenshot capture to complex E2E test suites with assertions, wait strategies, network interception, visual regression testing, accessibility testing, performance testing, parallel execution, CI/CD integration, and advanced patterns like mobile emulation and PDF generation. Primary focus is on Playwright (modern, recommended) and Puppeteer, with awareness of Selenium and Cypress patterns.

## When to Use This Skill

- User wants to write browser automation scripts (Playwright, Puppeteer, Selenium, Cypress)
- User needs E2E tests, UI tests, or integration tests that use a real browser
- User wants to automate browser interactions (click, type, navigate, scrape)
- User needs screenshot or PDF generation from web pages
- User wants visual regression testing
- User mentions اتوماسیون مرورگر, تست E2E, or پلی‌رایت
- User needs accessibility testing with browser automation
- User wants performance testing with Lighthouse or similar
- User needs mobile emulation or responsive testing
- User wants to set up parallel test execution or CI/CD integration

---

## Part 1: Tool Selection

### Choose the Right Tool

| Feature | Playwright | Puppeteer | Cypress | Selenium |
|---------|-----------|-----------|---------|----------|
| Browser support | Chromium, Firefox, WebKit | Chromium only | Chromium, Firefox | All browsers |
| Language support | JS/TS, Python, Java, C# | JS/TS | JS/TS | All languages |
| Auto-wait | Built-in | Manual | Built-in | Manual |
| Parallel execution | Built-in | Manual | Paid feature | Manual |
| Visual regression | Built-in | Plugin | Plugin | Plugin |
| Network interception | Built-in | Built-in | Limited | Limited |
| Mobile emulation | Built-in | Built-in | Limited | Limited |
| PDF generation | Built-in | Built-in | No | No |
| Recommended for | New projects, multi-browser | Chrome-only automation | React/frontend-heavy apps | Legacy, language-agnostic |

---

## Part 2: Playwright — Complete Reference

### Project Setup

```bash
# Initialize Playwright project
npm init playwright@latest

# Install browsers
npx playwright install

# Install with system dependencies
npx playwright install --with-deps

# Install specific browser
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

### Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'test-results' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }]
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
```

### Basic Test Patterns

```typescript
import { test, expect } from '@playwright/test';

// Navigation
test('homepage loads', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/My App/);
  await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
});

// Click and verify
test('navigation works', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('link', { name: 'About' }).click();
  await expect(page).toHaveURL('/about');
});

// Fill form and submit
test('login form', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await expect(page).toHaveURL('/dashboard');
});

// Wait for specific conditions
test('data loads', async ({ page }) => {
  await page.goto('/data');
  await page.waitForResponse(resp => resp.url().includes('/api/data'));
  await expect(page.getByText('Data loaded')).toBeVisible();
});
```

### Advanced Selector Patterns

```typescript
// Semantic selectors (preferred)
page.getByRole('button', { name: 'Submit' });
page.getByLabel('Email');
page.getByPlaceholder('Enter email');
page.getByText('Welcome back');
page.getByTestId('login-form');

// CSS selectors (when semantic selectors don't work)
page.locator('[data-testid="user-card"]');
page.locator('.modal-overlay');
page.locator('div.content > p:first-child');

// XPath (last resort)
page.locator('xpath=//button[contains(text(), "Submit")]');

// Locator chaining
const form = page.locator('#login-form');
await form.getByLabel('Email').fill('user@example.com');
await form.getByRole('button', { name: 'Sign In' }).click();

// Filtering
page.getByRole('listitem').filter({ hasText: 'Product' });
page.locator('.product-card').filter({ has: page.getByText('In Stock') });
page.locator('.product-card').nth(2);  // Third product
```

### Network Interception

```typescript
// Mock API responses
test('shows empty state when no data', async ({ page }) => {
  await page.route('**/api/items', route =>
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([]),
    })
  );
  await page.goto('/items');
  await expect(page.getByText('No items found')).toBeVisible();
});

// Modify request headers
test('sets auth header', async ({ page }) => {
  await page.route('**/api/**', route => {
    route.continue({
      headers: {
        ...route.request().headers(),
        'Authorization': 'Bearer test-token',
      },
    });
  });
  await page.goto('/protected');
});

// Block specific requests (images, analytics)
test('blocks analytics', async ({ page }) => {
  await page.route('**/analytics/**', route => route.abort());
  await page.route('**/*.png', route => route.abort());
  await page.goto('/');
});

// Simulate network errors
test('handles network failure', async ({ page }) => {
  await page.route('**/api/data', route =>
    route.fulfill({ status: 500, body: 'Server Error' })
  );
  await page.goto('/data');
  await expect(page.getByText('Something went wrong')).toBeVisible();
});

// Record network requests
test('logs all requests', async ({ page }) => {
  const requests = [];
  page.on('request', req => requests.push(req.url()));
  await page.goto('/');
  console.log('Requests:', requests);
});
```

### Mobile Emulation

```typescript
// Mobile viewport emulation
test('mobile layout', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 812 });  // iPhone X
  await page.goto('/');
  await expect(page.getByRole('button', { name: 'Menu' })).toBeVisible();
});

// Using device descriptors
import { devices } from '@playwright/test';

const iPhone = devices['iPhone 13'];

test('iPhone experience', async ({ browser }) => {
  const context = await browser.newContext({
    ...iPhone,
  });
  const page = await context.newPage();
  await page.goto('/');
  // Test mobile-specific features
  await context.close();
});
```

### PDF Generation

```typescript
// Generate PDF from page
test('generates PDF', async ({ page }) => {
  await page.goto('/report');
  await page.waitForLoadState('networkidle');
  await page.pdf({
    path: 'report.pdf',
    format: 'A4',
    printBackground: true,
    margin: {
      top: '20mm',
      right: '15mm',
      bottom: '20mm',
      left: '15mm',
    },
  });
});

// Generate PDF with header/footer
await page.pdf({
  path: 'report.pdf',
  format: 'A4',
  displayHeaderFooter: true,
  headerTemplate: '<div style="font-size:10px;text-align:center;width:100%">Report Title</div>',
  footerTemplate: '<div style="font-size:10px;text-align:center;width:100%"><span class="pageNumber"></span>/<span class="totalPages"></span></div>',
});
```

### Screenshots

```typescript
// Full page screenshot
await page.screenshot({ path: 'full-page.png', fullPage: true });

// Element screenshot
const card = page.locator('.product-card').first();
await card.screenshot({ path: 'product.png' });

// Viewport-only screenshot
await page.screenshot({ path: 'viewport.png' });

// Screenshot with mask (hide sensitive areas)
await page.screenshot({
  path: 'masked.png',
  mask: [
    page.locator('.user-avatar'),
    page.locator('.credit-card-info'),
  ],
});
```

---

## Part 3: Visual Regression Testing

### Playwright Visual Comparison

```typescript
// Compare screenshots
test('homepage looks correct', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixelRatio: 0.01,
    threshold: 0.2,
  });
});

// Compare element screenshots
test('card component', async ({ page }) => {
  const card = page.locator('.product-card').first();
  await expect(card).toHaveScreenshot('product-card.png');
});

// Update baseline screenshots
// npx playwright test --update-snapshots

// Custom snapshot configuration
test('dark mode screenshot', async ({ page }) => {
  await page.emulateMedia({ colorScheme: 'dark' });
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage-dark.png', {
    animations: 'disabled',
  });
});
```

### Visual Regression Strategy

```typescript
// Skip animations for consistent screenshots
test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
});

// Wait for animations to complete
await page.waitForLoadState('networkidle');
await page.waitForTimeout(500);  // Wait for CSS transitions

// Ignore dynamic content
await expect(page).toHaveScreenshot('page.png', {
  mask: [
    page.locator('.timestamp'),        // Dynamic date
    page.locator('.user-avatar'),      // User-specific
    page.locator('.ad-banner'),        // Changes frequently
  ],
  maxDiffPixelRatio: 0.01,
});
```

---

## Part 4: Accessibility Testing

### Axe Integration

```typescript
import AxeBuilder from '@axe-core/playwright';

test('homepage is accessible', async ({ page }) => {
  await page.goto('/');
  const accessibilityScanResults = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
    .analyze();

  expect(accessibilityScanResults.violations).toEqual([]);
});

// Test specific component
test('modal is accessible', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Open Modal' }).click();

  const results = await new AxeBuilder({ page })
    .include('.modal')
    .withTags(['wcag2a', 'wcag2aa'])
    .analyze();

  expect(results.violations).toEqual([]);
});

// Custom rules
test('custom accessibility rules', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .disableRules(['color-contrast'])  // Skip color contrast
    .withRules(['image-alt', 'label']) // Only check these rules
    .analyze();

  expect(results.violations).toEqual([]);
});
```

### Manual Accessibility Checks

```typescript
// Check keyboard navigation
test('keyboard navigation', async ({ page }) => {
  await page.goto('/form');

  // Tab through form fields
  await page.keyboard.press('Tab');
  await expect(page.getByLabel('Name')).toBeFocused();

  await page.keyboard.press('Tab');
  await expect(page.getByLabel('Email')).toBeFocused();

  // Submit with Enter
  await page.keyboard.press('Enter');
});

// Check ARIA attributes
test('ARIA attributes', async ({ page }) => {
  await page.goto('/');

  // Check button has accessible name
  const button = page.locator('.icon-button');
  await expect(button).toHaveAttribute('aria-label', 'Close dialog');

  // Check live region
  await page.getByRole('button', { name: 'Submit' }).click();
  await expect(page.getByRole('status')).toHaveText('Form submitted successfully');
});

// Check color contrast
test('sufficient color contrast', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .withRules(['color-contrast'])
    .analyze();

  expect(results.violations).toEqual([]);
});
```

---

## Part 5: Performance Testing with Browser Automation

### Core Web Vitals

```typescript
import { test, expect } from '@playwright/test';

test('page performance', async ({ page }) => {
  await page.goto('/');

  // Measure navigation timing
  const performanceData = await page.evaluate(() => {
    const [navigation] = performance.getEntriesByType('navigation');
    return {
      domContentLoaded: navigation.domContentLoadedEventEnd - navigation.startTime,
      loadComplete: navigation.loadEventEnd - navigation.startTime,
      firstPaint: performance.getEntriesByName('first-paint')[0]?.startTime,
    };
  });

  console.log('Performance metrics:', performanceData);
  expect(performanceData.domContentLoaded).toBeLessThan(3000);
  expect(performanceData.loadComplete).toBeLessThan(5000);
});

// Check for layout shifts
test('no layout shifts', async ({ page }) => {
  await page.goto('/');

  const cls = await page.evaluate(() => {
    return new Promise(resolve => {
      let clsValue = 0;
      const observer = new PerformanceObserver(list => {
        for (const entry of list.getEntries()) {
          if (!entry.hadRecentInput) {
            clsValue += entry.value;
          }
        }
      });
      observer.observe({ type: 'layout-shift', buffered: true });
      setTimeout(() => resolve(clsValue), 5000);
    });
  });

  expect(cls).toBeLessThan(0.1);
});

// Check for long tasks
test('no long tasks', async ({ page }) => {
  const longTasks = [];
  await page.evaluate(() => {
    const observer = new PerformanceObserver(list => {
      for (const entry of list.getEntries()) {
        (window as any).__longTasks = (window as any).__longTasks || [];
        (window as any).__longTasks.push(entry.duration);
      }
    });
    observer.observe({ type: 'longtask', buffered: true });
  });

  await page.goto('/');
  await page.waitForTimeout(5000);

  const tasks = await page.evaluate(() => (window as any).__longTasks || []);
  expect(tasks.every((t: number) => t < 50)).toBeTruthy();
});
```

### Lighthouse Integration

```bash
# Run Lighthouse via CLI
npx lighthouse http://localhost:3000 --output json --output-path ./lighthouse.json

# Or use lighthouse-ci
npx lhci autorun --config=lighthouserc.json
```

```json
// lighthouserc.json
{
  "ci": {
    "collect": {
      "url": ["http://localhost:3000"],
      "numberOfRuns": 3
    },
    "assert": {
      "assertions": {
        "categories:performance": ["error", { "minScore": 0.9 }],
        "categories:accessibility": ["error", { "minScore": 0.9 }],
        "categories:best-practices": ["warn", { "minScore": 0.8 }],
        "categories:seo": ["warn", { "minScore": 0.8 }]
      }
    }
  }
}
```

---

## Part 6: E2E Test Patterns

### Authentication Patterns

```typescript
// Store and reuse authentication state
test('authenticated user', async ({ browser }) => {
  // Login and save state
  const context = await browser.newContext();
  const page = await context.newPage();
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.waitForURL('/dashboard');

  // Save storage state
  await context.storageState({ path: 'auth.json' });
  await context.close();

  // Reuse in new context
  const authedContext = await browser.newContext({ storageState: 'auth.json' });
  const authedPage = await authedContext.newPage();
  await authedPage.goto('/dashboard');
  await expect(authedPage.getByText('Welcome')).toBeVisible();
});

// Global setup for authentication
// playwright.config.ts
export default defineConfig({
  globalSetup: './auth-setup.ts',
});

// auth-setup.ts
import { chromium } from '@playwright/test';

export default async function globalSetup() {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  await page.goto('http://localhost:3000/login');
  await page.getByLabel('Email').fill(process.env.TEST_USER_EMAIL!);
  await page.getByLabel('Password').fill(process.env.TEST_USER_PASSWORD!);
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.waitForURL('/dashboard');

  await context.storageState({ path: 'playwright/.auth/user.json' });
  await browser.close();
}
```

### File Upload Patterns

```typescript
// Single file upload
test('upload single file', async ({ page }) => {
  await page.goto('/upload');

  // Set files on file input
  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.getByRole('button', { name: 'Choose File' }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles('test-file.pdf');

  await expect(page.getByText('File uploaded successfully')).toBeVisible();
});

// Multiple file upload
test('upload multiple files', async ({ page }) => {
  await page.goto('/upload');

  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.getByRole('button', { name: 'Choose Files' }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(['file1.pdf', 'file2.pdf', 'file3.pdf']);
});

// Drag and drop upload
test('drag and drop upload', async ({ page }) => {
  await page.goto('/upload');

  // Create file data
  const dataTransfer = await page.evaluateHandle(() => new DataTransfer());
  await page.getByTestId('drop-zone').dispatchEvent('drop', { dataTransfer });
});

// Upload via setInputFiles
test('upload via input', async ({ page }) => {
  await page.goto('/upload');
  await page.getByTestId('file-input').setInputFiles('test-file.pdf');
});
```

### Drag and Drop Patterns

```typescript
// Basic drag and drop
test('drag and drop', async ({ page }) => {
  await page.goto('/board');

  const source = page.getByTestId('task-1');
  const target = page.getByTestId('column-done');

  await source.dragTo(target);

  await expect(target.getByText('Task 1')).toBeVisible();
});

// Custom drag and drop (when native drag doesn't work)
test('custom drag and drop', async ({ page }) => {
  await page.goto('/board');

  const source = page.getByTestId('task-1');
  const target = page.getByTestId('column-done');

  const sourceBox = await source.boundingBox();
  const targetBox = await target.boundingBox();

  await page.mouse.move(sourceBox!.x + sourceBox!.width / 2, sourceBox!.y + sourceBox!.height / 2);
  await page.mouse.down();
  await page.mouse.move(targetBox!.x + targetBox!.width / 2, targetBox!.y + targetBox!.height / 2, { steps: 10 });
  await page.mouse.up();
});
```

### iframe Patterns

```typescript
// Interact with iframe content
test('interact with iframe', async ({ page }) => {
  await page.goto('/page-with-iframe');

  // Access iframe by locator
  const frame = page.frameLocator('#my-iframe');
  await frame.getByRole('button', { name: 'Click Me' }).click();
  await expect(frame.getByText('Result')).toBeVisible();

  // Access iframe by name
  const frame = page.frame({ name: 'iframe-name' });
  await frame.click('#button');
});

// Access multiple iframes
test('multiple iframes', async ({ page }) => {
  await page.goto('/dashboard');

  const sidebar = page.frameLocator('#sidebar');
  const main = page.frameLocator('#main-content');

  await sidebar.getByRole('link', { name: 'Settings' }).click();
  await expect(main.getByText('Settings Page')).toBeVisible();
});
```

### Dialog Handling

```typescript
// Auto-accept dialogs
test('confirm dialog', async ({ page }) => {
  page.on('dialog', dialog => dialog.accept());

  await page.goto('/delete-item');
  await page.getByRole('button', { name: 'Delete' }).click();
  await expect(page.getByText('Item deleted')).toBeVisible();
});

// Handle dialog with specific action
test('prompt dialog', async ({ page }) => {
  page.on('dialog', dialog => {
    if (dialog.type() === 'prompt') {
      dialog.accept('User input');
    } else {
      dialog.accept();
    }
  });

  await page.goto('/prompt-page');
  await page.getByRole('button', { name: 'Show Prompt' }).click();
});
```

---

## Part 7: Test Data Management

### Factory Pattern

```typescript
// test/factories/user.factory.ts
export class UserFactory {
  static create(overrides = {}) {
    return {
      email: `test-${Date.now()}@example.com`,
      name: 'Test User',
      password: 'SecurePassword123!',
      role: 'user',
      ...overrides,
    };
  }

  static createAdmin() {
    return this.create({ role: 'admin', email: `admin-${Date.now()}@example.com` });
  }
}

// Usage in tests
test('user profile', async ({ page }) => {
  const user = UserFactory.create({ name: 'John Doe' });
  await page.goto('/register');
  await page.getByLabel('Name').fill(user.name);
  await page.getByLabel('Email').fill(user.email);
  await page.getByLabel('Password').fill(user.password);
  await page.getByRole('button', { name: 'Register' }).click();
});
```

### API-Driven Test Data

```typescript
// Setup test data via API
test.beforeEach(async ({ request }) => {
  // Create test user via API
  await request.post('http://localhost:3000/api/users', {
    data: {
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
    },
  });
});

test.afterEach(async ({ request }) => {
  // Cleanup test data
  await request.delete('http://localhost:3000/api/users/test@example.com');
});
```

### Database Reset

```typescript
// Reset database before each test
test.beforeEach(async ({ request }) => {
  await request.post('http://localhost:3000/api/test/reset');
});

// Or use fixtures
import { test as base } from '@playwright/test';

const test = base.extend({
  database: async ({ request }, use) => {
    // Setup
    await request.post('/api/test/seed');
    await use({});
    // Teardown
    await request.post('/api/test/reset');
  },
});
```

---

## Part 8: Parallel Test Execution

### Playwright Parallel Configuration

```typescript
// playwright.config.ts
export default defineConfig({
  // Run tests in parallel
  fullyParallel: true,

  // Number of workers
  workers: process.env.CI ? 4 : undefined,

  // Retry failed tests
  retries: process.env.CI ? 2 : 0,

  // Test isolation
  testIsolation: 'serial',  // or 'parallel'

  // Shard tests across CI machines
  // npx playwright test --shard=1/3
});
```

### Sharding for CI

```yaml
# .github/workflows/test.yml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test --shard=${{ matrix.shard }}/4
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: report-${{ matrix.shard }}
          path: test-results/
```

### Test Distribution Strategy

```typescript
// Group tests by execution time
// Fast tests: unit-like E2E tests
// Slow tests: full workflow tests

// playwright.config.ts
export default defineConfig({
  projects: [
    {
      name: 'fast',
      testDir: './tests/fast',
      workers: 8,
    },
    {
      name: 'slow',
      testDir: './tests/slow',
      workers: 2,
    },
  ],
});
```

---

## Part 9: CI/CD Integration

### GitHub Actions Integration

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
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps

      # Start application
      - run: npm run dev &
      - run: npx wait-on http://localhost:3000

      # Run tests
      - run: npx playwright test

      # Upload test results
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30

      # Upload test results as HTML report
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: test-results/
          retention-days: 30
```

### GitLab CI Integration

```yaml
# .gitlab-ci.yml
e2e-tests:
  image: mcr.microsoft.com/playwright:v1.40.0-jammy
  services:
    - name: postgres:16-alpine
      alias: db
  variables:
    DATABASE_URL: postgresql://postgres:postgres@db:5432/test
  script:
    - npm ci
    - npm run dev &
    - npx wait-on http://localhost:3000
    - npx playwright test
  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    reports:
      junit: test-results/junit.xml
```

### Docker CI Integration

```dockerfile
# Dockerfile.test
FROM mcr.microsoft.com/playwright:v1.40.0-jammy

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

CMD ["npx", "playwright", "test"]
```

```yaml
# docker-compose.test.yml
services:
  app:
    build: .
    ports:
      - "3000:3000"

  test:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      app:
        condition: service_healthy
    environment:
      - BASE_URL=http://app:3000
    volumes:
      - ./test-results:/app/test-results
      - ./playwright-report:/app/playwright-report
```

---

## Part 10: Debugging and Troubleshooting

### Debug Mode

```bash
# Run tests in headed mode (see the browser)
npx playwright test --headed

# Run specific test
npx playwright test login.test.ts

# Run with debug UI
npx playwright test --ui

# Show test retries
npx playwright test --retries=3

# Generate trace
npx playwright test --trace on

# View trace
npx playwright show-trace trace.zip
```

### Common Issues

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Test is flaky | Timing issues, network | Use auto-wait, mock network |
| Element not found | Wrong selector, page not ready | Use semantic selectors, add waits |
| Timeout exceeded | Slow page, wrong URL | Increase timeout, check baseURL |
| Auth state lost | Session expired | Re-authenticate, check storageState |
| Screenshot mismatch | Dynamic content | Mask dynamic areas, adjust threshold |
| iframe not accessible | Wrong frame context | Use frameLocator, check frame name |

### Trace Analysis

```typescript
// Enable tracing
test.use({ trace: 'on' });

// Or per-test
test('with trace', async ({ page }) => {
  await page.context().tracing.start({ screenshots: true, snapshots: true });
  // ... test code ...
  await page.context().tracing.stop({ path: 'trace.zip' });
});

// View trace
// npx playwright show-trace trace.zip
```

### Screenshot on Failure

```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',
  },
});
```

---

## Part 11: Puppeteer Patterns

### Basic Puppeteer

```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();

  await page.goto('https://example.com');
  await page.screenshot({ path: 'screenshot.png' });

  // Click element
  await page.click('#submit-button');

  // Type in input
  await page.type('#email', 'user@example.com');

  // Wait for selector
  await page.waitForSelector('.result');

  // Evaluate JavaScript
  const title = await page.evaluate(() => document.title);

  await browser.close();
})();
```

### Puppeteer Network Interception

```javascript
// Block images
await page.setRequestInterception(true);
page.on('request', req => {
  if (req.resourceType() === 'image') req.abort();
  else req.continue();
});

// Mock API
page.on('request', req => {
  if (req.url().includes('/api/data')) {
    req.respond({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({ data: 'mocked' }),
    });
  } else {
    req.continue();
  }
});
```

### Puppeteer PDF Generation

```javascript
await page.goto('http://localhost:3000/report');
await page.pdf({
  path: 'report.pdf',
  format: 'A4',
  printBackground: true,
});
```

---

## Part 12: Output Format

- Provide complete, runnable scripts with all imports and setup
- Include comments explaining non-obvious steps
- Add a "How to run" section with the exact command
- If writing tests, group them logically with `describe` blocks
- Use TypeScript by default unless the project uses JavaScript
- Write explanations in the user's language; code in English

## Principles

- **Reliability over speed.** A slow reliable test beats a fast flaky one.
- **Test behavior, not implementation.** Don't assert on CSS classes or internal state; assert on what the user sees.
- **Keep tests small.** One assertion per test is ideal. Multiple assertions per test are acceptable if they test the same behavior.
- **Use page objects for complex pages.** If a page has 5+ interactions, extract a page object class.
- **Mock external services.** Don't depend on third-party APIs in tests.
- **Use semantic selectors.** `getByRole`, `getByText`, `getByTestId` are resilient to styling changes.
- **Never use `sleep`.** Use auto-wait or explicit waits for specific conditions.
- **Isolate tests.** Each test should set up its own state and clean up after itself.
- **Use fixtures for shared setup.** Playwright fixtures are the recommended way to share setup across tests.
- **Enable tracing on CI.** Traces make debugging failures much easier.
