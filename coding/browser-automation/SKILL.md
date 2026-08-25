---
name: browser-automation
description: >-
  English: Browser automation with Playwright, Puppeteer, Selenium, page object model, selectors strategy, waiting strategies, network interception, authentication state, parallel testing, visual regression testing, accessibility testing, mobile emulation, file downloads and uploads, shadow DOM handling, cross-browser testing, test orchestration.
  Farsi: اتوماسیون مرورگر با Playwright، Puppeteer، Selenium، مدل شیء صفحه، استراتژی انتخابگرها، استراتژی‌های انتظار، رهگیری شبکه، وضعیت احراز هویت، تست موازی، تست بازگشت بصری، تست دسترسی‌پذیری، شبیه‌سازی موبایل، دانلود و آپلود فایل، مدیریت shadow DOM.
  Chinese: 浏览器自动化与Playwright、Puppeteer、Selenium，页面对象模型，选择器策略，等待策略，网络拦截，认证状态，并行测试，视觉回归测试，可访问性测试，移动端模拟，文件下载上传，Shadow DOM处理。
priority: P3
dependencies: []
conflicts: []
---

# Browser Automation

## Overview

Browser automation is the programmatic control of web browsers to perform tasks that would otherwise require manual interaction. This skill covers the three major automation frameworks (Playwright, Puppeteer, Selenium), along with production patterns for page object modeling, selector strategies, waiting strategies, network interception, and advanced scenarios like visual regression, accessibility testing, and mobile emulation.

Modern browser automation goes far beyond simple click-and-type scripts. It encompasses end-to-end testing, UI automation, data extraction, PDF generation, screenshot capture, and complex multi-tab workflows. This skill provides battle-tested patterns for building reliable, maintainable, and performant browser automation solutions.

## When to Use This Skill

- End-to-end testing of web applications
- Cross-browser compatibility testing
- UI automation for repetitive workflows
- Visual regression testing (pixel-perfect comparisons)
- Accessibility auditing (WCAG compliance)
- Screenshot and PDF generation
- Form filling and submission automation
- File upload/download automation
- Social media automation (posting, engagement)
- Data extraction from JavaScript-rendered pages
- Performance testing and profiling

## When NOT to Use This Skill

- Simple HTTP API testing (use API testing frameworks)
- Unit testing of JavaScript functions (use Jest/Vitest)
- Testing pure CSS styles without interaction
- Tasks achievable via server-side APIs without browser
- High-frequency, high-throughput scenarios (browser overhead is high)

## Workflow

### Phase 1: Planning

1. **Identify target pages**: List all URLs and user flows to automate
2. **Choose framework**: Playwright (recommended), Puppeteer (Chrome-only), Selenium (cross-language)
3. **Design page objects**: Map UI elements to reusable classes
4. **Plan test data**: Determine test accounts, fixtures, and state setup
5. **Set up CI/CD**: Configure headless execution in pipelines

### Phase 2: Framework Setup

1. **Install dependencies**: Framework + browser binaries
2. **Configure timeouts**: Global, navigation, and action timeouts
3. **Set up fixtures**: Browser context, authentication state, test data
4. **Configure reporters**: HTML, JSON, JUnit for CI integration
5. **Set up parallel execution**: Workers, test isolation

### Phase 3: Page Object Implementation

1. **Create base page class**: Common navigation, waiting, and utility methods
2. **Implement page-specific objects**: Selectors and actions for each page
3. **Define locators**: Use data-testid, ARIA roles, or CSS selectors
4. **Add validation methods**: Assertions for page state and content
5. **Handle dynamic content**: Wait for loading states, animations

### Phase 4: Test Implementation

1. **Write test flows**: Step-by-step user scenarios
2. **Add assertions**: Verify expected outcomes at each step
3. **Handle errors**: Screenshot on failure, retry flaky tests
4. **Implement data-driven tests**: Parameterized test cases
5. **Add performance assertions**: Page load times, Core Web Vitals

### Phase 5: Maintenance

1. **Monitor flaky tests**: Track and fix intermittent failures
2. **Update selectors**: When UI changes break locators
3. **Optimize test speed**: Parallel execution, smart waits
4. **Review test coverage**: Ensure critical paths are tested
5. **Update for new browsers**: Keep browser versions current

## Advanced Techniques

### 1. Page Object Model with Dynamic Locators

```typescript
import { Page, Locator, expect } from '@playwright/test';

// Base page with common functionality
class BasePage {
  constructor(protected page: Page) {}

  async navigate(path: string): Promise<void> {
    await this.page.goto(path, { waitUntil: 'networkidle' });
  }

  async waitForLoading(): Promise<void> {
    await this.page.waitForSelector('[data-testid="loading-spinner"]', {
      state: 'hidden',
      timeout: 10000,
    });
  }

  async screenshot(name: string): Promise<void> {
    await this.page.screenshot({
      path: `screenshots/${name}.png`,
      fullPage: true,
    });
  }
}

// Product page object
class ProductPage extends BasePage {
  // Dynamic locators using data-testid
  private get title(): Locator {
    return this.page.locator('[data-testid="product-title"]');
  }

  private get price(): Locator {
    return this.page.locator('[data-testid="product-price"]');
  }

  private get addToCartButton(): Locator {
    return this.page.locator('[data-testid="add-to-cart"]');
  }

  private get quantityInput(): Locator {
    return this.page.locator('[data-testid="quantity-input"]');
  }

  private get reviewSection(): Locator {
    return this.page.locator('[data-testid="reviews-section"]');
  }

  // Actions
  async addToCart(quantity = 1): Promise<void> {
    if (quantity > 1) {
      await this.quantityInput.fill(String(quantity));
    }
    await this.addToCartButton.click();
    await this.waitForLoading();
  }

  async getProductTitle(): Promise<string> {
    return this.title.textContent() || '';
  }

  async getProductPrice(): Promise<number> {
    const text = await this.price.textContent() || '0';
    return parseFloat(text.replace(/[^0-9.]/g, ''));
  }

  async getReviewCount(): Promise<number> {
    const text = await this.reviewSection
      .locator('[data-testid="review-count"]')
      .textContent() || '0';
    return parseInt(text.replace(/[^0-9]/g, ''));
  }

  // Assertions
  async expectTitle(expected: string): Promise<void> {
    await expect(this.title).toHaveText(expected);
  }

  async expectPrice(expected: number): Promise<void> {
    await expect(this.price).toContainText(`$${expected}`);
  }

  async expectInStock(): Promise<void> {
    await expect(this.addToCartButton).toBeEnabled();
  }
}

// Checkout page object
class CheckoutPage extends BasePage {
  private get emailInput(): Locator {
    return this.page.locator('[data-testid="email-input"]');
  }

  private get cardNumberInput(): Locator {
    return this.page.locator('[data-testid="card-number"]');
  }

  private get submitOrderButton(): Locator {
    return this.page.locator('[data-testid="submit-order"]');
  }

  async fillEmail(email: string): Promise<void> {
    await this.emailInput.fill(email);
  }

  async fillCardDetails(card: CardDetails): Promise<void> {
    await this.page.locator('[data-testid="card-number"]').fill(card.number);
    await this.page.locator('[data-testid="card-expiry"]').fill(card.expiry);
    await this.page.locator('[data-testid="card-cvc"]').fill(card.cvc);
  }

  async submitOrder(): Promise<void> {
    await this.submitOrderButton.click();
    await this.waitForLoading();
  }
}
```

### 2. Smart Waiting Strategies

```typescript
import { Page, Locator } from '@playwright/test';

class SmartWaiter {
  constructor(private page: Page) {}

  // Wait for element to be visible and stable
  async waitForObject(selector: string, timeout = 10000): Promise<Locator> {
    const locator = this.page.locator(selector);
    await locator.waitFor({ state: 'visible', timeout });
    // Wait for no animations
    await this.page.waitForFunction(
      (sel) => {
        const el = document.querySelector(sel);
        if (!el) return false;
        const style = window.getComputedStyle(el);
        return style.animationPlayState === 'running' ||
               style.transitionDuration === '0s' ||
               style.transitionDuration === '';
      },
      selector,
      { timeout }
    );
    return locator;
  }

  // Wait for network to be idle
  async waitForNetworkIdle(timeout = 5000): Promise<void> {
    await this.page.waitForLoadState('networkidle', { timeout });
  }

  // Wait for specific API response
  async waitForApiResponse(
    urlPattern: string | RegExp,
    timeout = 10000
  ): Promise<Response> {
    return this.page.waitForResponse(
      (response) => {
        const url = response.url();
        if (typeof urlPattern === 'string') {
          return url.includes(urlPattern);
        }
        return urlPattern.test(url);
      },
      { timeout }
    );
  }

  // Wait for JavaScript to execute
  async waitForJS(condition: string, timeout = 10000): Promise<void> {
    await this.page.waitForFunction(condition, { timeout });
  }

  // Wait for multiple conditions
  async waitForConditions(conditions: Array<() => Promise<boolean>>): Promise<void> {
    const checkAll = async (): Promise<boolean> => {
      for (const condition of conditions) {
        if (!(await condition())) return false;
      }
      return true;
    };

    await this.page.waitForFunction(checkAll, { timeout: 30000 });
  }

  // Wait for element to stop moving
  async waitForStable(
    selector: string,
    stabilityMs = 300
  ): Promise<void> {
    let lastRect: DOMRect | null = null;
    let stableTime = 0;

    while (stableTime < stabilityMs) {
      const rect = await this.page.locator(selector).boundingBox();
      if (!rect) break;

      if (lastRect &&
          rect.x === lastRect.x &&
          rect.y === lastRect.y &&
          rect.width === lastRect.width &&
          rect.height === lastRect.height) {
        stableTime += 100;
      } else {
        stableTime = 0;
      }

      lastRect = rect;
      await this.page.waitForTimeout(100);
    }
  }
}
```

### 3. Network Interception and Mocking

```typescript
import { Page, Route, Request } from '@playwright/test';

class NetworkInterceptor {
  constructor(private page: Page) {}

  // Mock API responses
  async mockAPI(
    urlPattern: string | RegExp,
    response: { status?: number; body?: unknown; headers?: Record<string, string> }
  ): Promise<void> {
    await this.page.route(urlPattern, async (route) => {
      await route.fulfill({
        status: response.status || 200,
        contentType: 'application/json',
        body: JSON.stringify(response.body),
        headers: response.headers,
      });
    });
  }

  // Intercept and modify requests
  async modifyRequest(
    urlPattern: string | RegExp,
    modifier: (request: Request) => Partial<Request>
  ): Promise<void> {
    await this.page.route(urlPattern, async (route) => {
      const originalRequest = route.request();
      const modifications = modifier(originalRequest);

      await route.continue({
        url: modifications.url,
        method: modifications.method as any,
        headers: modifications.headers,
        postData: modifications.postData,
      });
    });
  }

  // Block specific resources
  async blockResources(types: string[]): Promise<void> {
    await this.page.route('**/*', (route) => {
      const resourceType = route.request().resourceType();
      if (types.includes(resourceType)) {
        route.abort();
      } else {
        route.continue();
      }
    });
  }

  // Record all network traffic
  async recordTraffic(): Promise<Array<{
    url: string;
    method: string;
    status: number;
    timing: number;
  }>> {
    const traffic: Array<{
      url: string;
      method: string;
      status: number;
      timing: number;
    }> = [];

    this.page.on('request', (request) => {
      const startTime = Date.now();
      request.failure()?.then(() => {
        traffic.push({
          url: request.url(),
          method: request.method(),
          status: 0,
          timing: Date.now() - startTime,
        });
      });
    });

    this.page.on('response', (response) => {
      traffic.push({
        url: response.url(),
        method: response.request().method(),
        status: response.status(),
        timing: Date.now() - Date.now(), // Simplified
      });
    });

    return traffic;
  }

  // Simulate slow network
  async simulateSlowNetwork(
    downloadSpeed = 500, // KB/s
    uploadSpeed = 500,
    latency = 100 // ms
  ): Promise<void> {
    const context = this.page.context();
    await context.route('**/*', async (route) => {
      // Add latency
      await new Promise(r => setTimeout(r, latency));
      await route.continue();
    });
  }

  // Modify response headers
  async modifyHeaders(
    urlPattern: string | RegExp,
    headersToAdd: Record<string, string>
  ): Promise<void> {
    await this.page.route(urlPattern, async (route) => {
      const response = await route.fetch();
      const headers = {
        ...response.headers(),
        ...headersToAdd,
      };
      await route.fulfill({
        response,
        headers,
      });
    });
  }
}
```

### 4. Authentication State Management

```typescript
import { BrowserContext, Page } from 'playwright';

class AuthManager {
  private storageStatePath = './auth-state.json';

  // Save authentication state
  async saveAuthState(context: BrowserContext): Promise<void> {
    await context.storageState({ path: this.storageStatePath });
  }

  // Load authentication state
  async loadAuthState(browser: any): Promise<BrowserContext> {
    return browser.newContext({
      storageState: this.storageStatePath,
    });
  }

  // Login flow
  async login(
    page: Page,
    credentials: { email: string; password: string }
  ): Promise<void> {
    await page.goto('/login');
    await page.locator('[data-testid="email"]').fill(credentials.email);
    await page.locator('[data-testid="password"]').fill(credentials.password);
    await page.locator('[data-testid="login-button"]').click();

    // Wait for successful login
    await page.waitForURL('/dashboard');
    await page.waitForSelector('[data-testid="user-menu"]');
  }

  // Handle multi-factor authentication
  async handleMFA(page: Page, code: string): Promise<void> {
    await page.waitForSelector('[data-testid="mfa-input"]');
    await page.locator('[data-testid="mfa-input"]').fill(code);
    await page.locator('[data-testid="verify-button"]').click();
    await page.waitForURL('/dashboard');
  }

  // Handle OAuth flow
  async handleOAuth(
    page: Page,
    provider: 'google' | 'github' | 'microsoft',
    credentials: { email: string; password: string }
  ): Promise<void> {
    await page.locator(`[data-testid="oauth-${provider}"]`).click();

    // Handle provider's login page
    switch (provider) {
      case 'google':
        await page.locator('input[type="email"]').fill(credentials.email);
        await page.locator('#identifierNext').click();
        await page.locator('input[type="password"]').fill(credentials.password);
        await page.locator('#passwordNext').click();
        break;
      case 'github':
        await page.locator('#login_field').fill(credentials.email);
        await page.locator('#password').fill(credentials.password);
        await page.locator('[type="submit"]').click();
        break;
    }

    // Wait for callback
    await page.waitForURL('**/dashboard**');
  }
}
```

### 5. Parallel Test Execution with Isolation

```typescript
import { test, expect, Browser, BrowserContext } from '@playwright/test';

// playwright.config.ts
const config = {
  testDir: './tests',
  fullyParallel: true,
  workers: process.env.CI ? 2 : 4,
  retries: process.env.CI ? 2 : 0,
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
};

// Test fixtures with isolated browser contexts
test.describe('Product Tests', () => {
  let browser: Browser;

  test.beforeAll(async ({ browser: b }) => {
    browser = b;
  });

  test('should add product to cart', async () => {
    const context = await browser.newContext();
    const page = await context.newPage();

    try {
      await page.goto('/products/1');
      await page.locator('[data-testid="add-to-cart"]').click();
      await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');
    } finally {
      await context.close();
    }
  });

  test('should display product details', async () => {
    const context = await browser.newContext();
    const page = await context.newPage();

    try {
      await page.goto('/products/1');
      await expect(page.locator('[data-testid="product-title"]')).toBeVisible();
      await expect(page.locator('[data-testid="product-price"]')).toBeVisible();
    } finally {
      await context.close();
    }
  });
});

// Shared authentication state across tests
test.describe('Authenticated Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Load saved auth state
    await page.context().addCookies([]);
    // Or login programmatically
    const authManager = new AuthManager();
    await authManager.login(page, {
      email: process.env.TEST_EMAIL!,
      password: process.env.TEST_PASSWORD!,
    });
  });

  test('should view order history', async ({ page }) => {
    await page.goto('/orders');
    await expect(page.locator('[data-testid="order-list"]')).toBeVisible();
  });

  test('should update profile', async ({ page }) => {
    await page.goto('/profile');
    await page.locator('[data-testid="name-input"]').fill('New Name');
    await page.locator('[data-testid="save-button"]').click();
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
  });
});
```

### 6. Visual Regression Testing

```typescript
import { test, expect } from '@playwright/test';

class VisualTester {
  constructor(private page: any) {}

  // Compare full page screenshot
  async compareFullPage(
    name: string,
    options: { maxDiffPixelRatio?: number; threshold?: number } = {}
  ): Promise<void> {
    await expect(this.page).toHaveScreenshot(`${name}.png`, {
      fullPage: true,
      maxDiffPixelRatio: options.maxDiffPixelRatio || 0.01,
      threshold: options.threshold || 0.2,
    });
  }

  // Compare specific element
  async compareElement(
    selector: string,
    name: string,
    options: { maxDiffPixelRatio?: number } = {}
  ): Promise<void> {
    await expect(this.page.locator(selector)).toHaveScreenshot(
      `${name}.png`,
      {
        maxDiffPixelRatio: options.maxDiffPixelRatio || 0.01,
      }
    );
  }

  // Compare with custom mask (hide dynamic content)
  async compareWithMask(
    name: string,
    maskSelectors: string[]
  ): Promise<void> {
    await expect(this.page).toHaveScreenshot(`${name}.png`, {
      mask: maskSelectors.map(sel => this.page.locator(sel)),
    });
  }

  // Generate baseline screenshots
  async generateBaseline(name: string): Promise<void> {
    await this.page.screenshot({
      path: `screenshots/baseline/${name}.png`,
      fullPage: true,
    });
  }
}

// Usage in tests
test('homepage visual regression', async ({ page }) => {
  await page.goto('/');
  const visualTester = new VisualTester(page);
  await visualTester.compareFullPage('homepage', {
    maxDiffPixelRatio: 0.01,
  });
});

test('login page visual regression', async ({ page }) => {
  await page.goto('/login');
  const visualTester = new VisualTester(page);
  await visualTester.compareElement(
    '[data-testid="login-form"]',
    'login-form'
  );
});
```

### 7. Accessibility Testing Integration

```typescript
import AxeBuilder from '@axe-core/playwright';
import { test, expect } from '@playwright/test';

class AccessibilityTester {
  constructor(private page: any) {}

  // Run full accessibility audit
  async audit(options?: {
    wcagLevel?: 'A' | 'AA' | 'AAA';
    include?: string[];
    exclude?: string[];
  }): Promise<AccessibilityResult> {
    let builder = new AxeBuilder({ page: this.page });

    if (options?.include) {
      builder = builder.include(options.include);
    }
    if (options?.exclude) {
      builder = builder.exclude(options.exclude);
    }

    const results = await builder.analyze();

    // Filter by WCAG level
    if (options?.wcagLevel) {
      results.violations = results.violations.filter(violation =>
        violation.tags.some(tag =>
          tag.includes(`wcag2${options.wcagLevel?.toLowerCase()}`) ||
          tag.includes(`wcag2a`)
        )
      );
    }

    return results;
  }

  // Assert no critical violations
  async expectNoCriticalViolations(): Promise<void> {
    const results = await this.audit({ wcagLevel: 'A' });
    expect(
      results.violations.filter(v => v.impact === 'critical' || v.impact === 'serious')
    ).toHaveLength(0);
  }

  // Generate accessibility report
  async generateReport(): Promise<string> {
    const results = await this.audit();
    const report = [
      '# Accessibility Report',
      '',
      `## Summary`,
      `- Violations: ${results.violations.length}`,
      `- Passes: ${results.passes.length}`,
      `- Incomplete: ${results.incomplete.length}`,
      '',
      '## Violations',
    ];

    for (const violation of results.violations) {
      report.push(
        `### ${violation.id} (${violation.impact})`,
        `- Description: ${violation.description}`,
        `- Help: ${violation.helpUrl}`,
        `- Elements: ${violation.nodes.length}`,
        '',
      );
    }

    return report.join('\n');
  }

  // Check color contrast
  async checkColorContrast(): Promise<void> {
    const results = await new AxeBuilder({ page: this.page })
      .withRules(['color-contrast'])
      .analyze();

    expect(results.violations).toHaveLength(0);
  }

  // Check keyboard navigation
  async testKeyboardNavigation(): Promise<void> {
    // Tab through interactive elements
    const focusableElements = await this.page.locator(
      'a, button, input, select, textarea, [tabindex]'
    ).all();

    for (let i = 0; i < focusableElements.length; i++) {
      await this.page.keyboard.press('Tab');
      const focusedElement = await this.page.evaluate(() => {
        const el = document.activeElement;
        return {
          tag: el?.tagName,
          text: el?.textContent?.trim(),
          hasFocusVisible: el?.matches(':focus-visible'),
        };
      });

      // Verify focus is visible
      expect(focusedElement.hasFocusVisible).toBeTruthy();
    }
  }
}
```

## Common Patterns

### Pattern 1: Multi-Tab Workflow

```typescript
import { test, expect, BrowserContext, Page } from '@playwright/test';

test('multi-tab workflow', async ({ context }) => {
  // Open first tab
  const page1 = await context.newPage();
  await page1.goto('/dashboard');

  // Open second tab
  const page2 = await context.newPage();
  await page2.goto('/settings');

  // Switch between tabs
  await page1.bringToFront();
  await expect(page1.locator('[data-testid="dashboard-title"]')).toBeVisible();

  await page2.bringToFront();
  await expect(page2.locator('[data-testid="settings-title"]')).toBeVisible();

  // Close tabs
  await page1.close();
  await page2.close();
});
```

### Pattern 2: File Upload Automation

```typescript
import { test, expect } from '@playwright/test';
import path from 'path';

test('file upload', async ({ page }) => {
  await page.goto('/upload');

  // Set file input
  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.locator('[data-testid="upload-button"]').click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(path.join(__dirname, 'test-file.pdf'));

  // Verify upload
  await expect(page.locator('[data-testid="file-name"]')).toContainText('test-file.pdf');
  await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
});

// Multiple file upload
test('multiple file upload', async ({ page }) => {
  await page.goto('/upload');

  await page.locator('[data-testid="file-input"]').setInputFiles([
    'file1.pdf',
    'file2.pdf',
    'file3.pdf',
  ]);

  await expect(page.locator('[data-testid="upload-count"]')).toHaveText('3 files');
});
```

### Pattern 3: File Download Handling

```typescript
import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

test('file download', async ({ page }) => {
  await page.goto('/downloads');

  // Wait for download
  const downloadPromise = page.waitForEvent('download');
  await page.locator('[data-testid="download-button"]').click();
  const download = await downloadPromise;

  // Save file
  const filePath = path.join(__dirname, 'downloads', download.suggestedFilename());
  await download.saveAs(filePath);

  // Verify file exists
  expect(fs.existsSync(filePath)).toBeTruthy();
  expect(fs.statSync(filePath).size).toBeGreaterThan(0);
});
```

### Pattern 4: Shadow DOM Handling

```typescript
import { test, expect } from '@playwright/test';

test('shadow DOM interaction', async ({ page }) => {
  await page.goto('/shadow-dom-demo');

  // Playwright pierces shadow DOM by default
  const shadowInput = page.locator('my-component >> input[type="text"]');
  await shadowInput.fill('Hello World');

  // Deep shadow DOM
  const deepElement = page.locator(
    'outer-component::part(inner)::shadow(input)'
  );

  // Using evaluate for complex shadow DOM queries
  const value = await page.evaluate(() => {
    const outer = document.querySelector('outer-component');
    const shadowRoot = outer?.shadowRoot;
    const inner = shadowRoot?.querySelector('inner-component');
    const innerShadow = inner?.shadowRoot;
    const input = innerShadow?.querySelector('input');
    return input?.value;
  });

  expect(value).toBe('Hello World');
});
```

### Pattern 5: Mobile Emulation and Responsive Testing

```typescript
import { test, expect, devices } from '@playwright/test';

test.describe('Mobile Tests', () => {
  test('iPhone 14', async ({ browser }) => {
    const context = await browser.newContext({
      ...devices['iPhone 14'],
    });
    const page = await context.newPage();

    await page.goto('/');
    await expect(page.locator('[data-testid="mobile-menu"]')).toBeVisible();
    await expect(page.locator('[data-testid="desktop-nav"]')).not.toBeVisible();
  });

  test('iPad', async ({ browser }) => {
    const context = await browser.newContext({
      ...devices['iPad Pro 11'],
    });
    const page = await context.newPage();

    await page.goto('/');
    // iPad shows tablet layout
    await expect(page.locator('[data-testid="tablet-layout"]')).toBeVisible();
  });

  test('responsive breakpoints', async ({ page }) => {
    // Mobile
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.locator('[data-testid="mobile-layout"]')).toBeVisible();

    // Tablet
    await page.setViewportSize({ width: 768, height: 1024 });
    await expect(page.locator('[data-testid="tablet-layout"]')).toBeVisible();

    // Desktop
    await page.setViewportSize({ width: 1440, height: 900 });
    await expect(page.locator('[data-testid="desktop-layout"]')).toBeVisible();
  });
});
```

## Edge Cases & Pitfalls

| # | Edge Case | Problem | Solution |
|---|-----------|---------|----------|
| 1 | **Flaky tests** | Tests pass/fail inconsistently | Use proper waits; avoid hard-coded delays; implement retry logic |
| 2 | **Race conditions** | Actions before elements ready | Use Playwright's auto-waiting; add explicit waits for stability |
| 3 | **Shadow DOM** | Elements hidden in shadow roots | Playwright pierces shadow DOM; use `>>` or `evaluate` for complex cases |
| 4 | **Dynamic content** | Content loads after page load | Use `waitForSelector` with appropriate state; intercept network requests |
| 5 | **Browser context isolation** | Tests interfere with each other | Use fresh context per test; don't share state |
| 6 | **Timing issues** | Animations/transitions interfere | Wait for animation end; use `waitForStable` for moving elements |
| 7 | **Dialog handling** | Unexpected alerts/confirms | Set up dialog handlers before triggering; use `page.on('dialog')` |
| 8 | **iframe interaction** | Elements inside iframes | Use `frame.locator()` or `page.frame()` |
| 9 | **File upload dialogs** | Native file picker not accessible | Use `setInputFiles()` directly on file input |
| 10 | **Network throttling** | Tests slow on CI | Mock API responses; use `networkidle` carefully |
| 11 | **Screenshot differences** | Visual tests fail across OS | Use `maxDiffPixelRatio`; mask dynamic content |
| 12 | **Cookie consent popups** | Overlays block interactions | Dismiss before tests; add to fixtures |
| 13 | **Timezone differences** | Date tests fail in different TZ | Set timezone in context; use UTC in tests |
| 14 | **Browser version drift** | Tests pass locally, fail in CI | Pin browser versions; use Playwright's built-in browsers |
| 15 | **Memory leaks** | Tests crash on long runs | Close contexts properly; limit parallel tests |

## Integration with Other Skills

| Skill | Integration Points |
|-------|-------------------|
| **Web Scraping** | Use browser automation for JS-rendered content |
| **API Integration** | Mock API responses; intercept network traffic |
| **Testing** | End-to-end testing; test automation pipelines |
| **CI/CD** | Headless execution in pipelines; test reporting |
| **Performance** | Core Web Vitals testing; load time measurement |
| **Accessibility** | WCAG compliance testing; screen reader compatibility |
| **Security** | Authentication testing; CSRF validation |
| **DevOps** | Docker for CI; browser binary management |
| **Monitoring** | Production monitoring via synthetic tests |
| **Documentation** | Auto-generate screenshots for documentation |

## Output Format Templates

### Standard Template

```markdown
# Browser Automation: [Feature]

## Setup
- Framework: [Playwright/Puppeteer/Selenium]
- Browser: [Chrome/Firefox/Safari]
- Mode: [Headless/Headed]

## Page Objects
| Page | URL | Key Elements |
|------|-----|--------------|
| HomePage | / | nav, hero, footer |
| LoginPage | /login | email, password, submit |

## Test Cases
| Test | Description | Expected |
|------|-------------|----------|
| TC-001 | Login with valid credentials | Dashboard displayed |

## Code Example
[automation code]

## CI Integration
[CI/CD configuration]
```

### Quick Template

```markdown
# Quick Automation: [Task]

1. Install: `npm install @playwright/test`
2. Record: `npx playwright codegen [url]`
3. Test: `npx playwright test`
4. Debug: `npx playwright test --debug`

## Selectors
- Button: `[data-testid="submit"]`
- Input: `input[name="email"]`
```

### Deep Template

```markdown
# Comprehensive Automation Guide: [Feature]

## Architecture
[automation architecture diagram]

## Page Object Design
[detailed page object hierarchy]

## Waiting Strategies
[specific wait implementations]

## Test Data Management
[fixtures, factories, seeds]

## Parallel Execution
[worker configuration, isolation]

## Visual Regression
[screenshot comparison setup]

## Accessibility Testing
[WCAG audit integration]
```

### Agent Template

```markdown
# Browser Automation Agent Instructions

## Task
Automate [user flow] in [application].

## Requirements
- [ ] Page objects for all pages
- [ ] Smart waiting (no hard delays)
- [ ] Error handling and screenshots
- [ ] Test data setup
- [ ] Authentication handling
- [ ] Cross-browser testing
- [ ] CI integration

## Selectors Strategy
Priority: data-testid > ARIA roles > CSS selectors

## Testing Checklist
- [ ] Happy path works
- [ ] Error scenarios handled
- [ ] Loading states tested
- [ ] Responsive layouts verified
- [ ] Accessibility passes
- [ ] Performance acceptable

## Maintenance
- Update selectors when UI changes
- Monitor flaky tests
- Review test coverage quarterly
```

## Rules

1. **Use Playwright's auto-waiting** — Never use `setTimeout` for waiting; use explicit waits
2. **Prioritize data-testid selectors** — Most stable against UI changes
3. **Isolate test contexts** — Fresh browser context for each test
4. **Handle dialogs before triggering** — Set up dialog handlers before actions
5. **Close resources properly** — Always close pages and contexts in finally blocks
6. **Don't test implementation details** — Test user-visible behavior
7. **Use fixtures for authentication** — Save and restore auth state
8. **Mock external APIs** — Don't depend on external services in tests
9. **Add screenshots on failure** — Capture state for debugging
10. **Keep tests fast** — Target < 30 seconds per test; mock slow operations
11. **Use trace recording** — Enable on first retry for debugging
12. **Test across browsers** — Run on Chrome, Firefox, and Safari
13. **Handle flaky tests immediately** — Track, investigate, and fix
14. **Document test data setup** — Clear instructions for test accounts
15. **Review tests regularly** — Remove outdated; update selectors