---
name: web-scraping
description: >-
  English: Web scraping and data extraction, HTTP clients, HTML parsing, CSS selectors, XPath queries, headless browsers, anti-bot detection bypass, proxy rotation, rate limiting, pagination handling, JavaScript rendering, API reverse-engineering, robots.txt compliance, ethical scraping practices, data transformation, structured extraction.
  Farsi: استخراج داده‌های وب و کراولینگ، کلاینت‌های HTTP، پارس HTML، انتخابگرهای CSS، کوئری‌های XPath، مرورگرهای بدون سر، دور زدن تشخیص ربات، چرخش پراکسی، محدودیت نرخ، مدیریت صفحه‌بندی، رندرینگ JavaScript، مهندسی معکوس API، رعایت robots.txt، شیوه‌های اخلاقی کراولینگ.
  Chinese: 网页抓取和数据提取，HTTP客户端，HTML解析，CSS选择器，XPath查询，无头浏览器，反机器人检测绕过，代理轮换，速率限制，分页处理，JavaScript渲染，API逆向工程，robots.txt合规性，道德抓取实践。
priority: P3
dependencies: []
conflicts: []
---

# Web Scraping

## Overview

Web scraping is the automated extraction of data from websites. It combines HTTP requests, HTML parsing, CSS/XPath selectors, and sometimes headless browsers to collect, transform, and structure data from the web. This skill covers the complete spectrum—from simple static page fetching to complex dynamic content extraction with anti-bot evasion, ethical compliance, and production-grade reliability.

Modern web scraping requires understanding both the technical stack (HTTP protocols, HTML/DOM structure, JavaScript rendering) and the ethical/legal landscape (robots.txt, rate limiting, Terms of Service). This skill provides battle-tested patterns for building scrapers that are reliable, respectful, and maintainable.

## When to Use This Skill

- Extracting product data, prices, or reviews from e-commerce sites
- Collecting news articles or blog posts for content aggregation
- Building search engine indexes or specialized crawlers
- Monitoring competitor pricing or availability
- Collecting job listings, real estate data, or social media posts
- Training ML models with web-scraped datasets
- Building lead generation tools from public directories
- Aggregating reviews, ratings, or sentiment data
- Monitoring brand mentions across the web
- Researching market trends or public opinion

## When NOT to Use This Skill

- Accessing data available through official APIs (prefer APIs over scraping)
- Scraping private/protected content without authorization
- Circumventing security measures for unauthorized access
- Creating excessive load on target servers
- Violating Terms of Service or copyright laws

## Workflow

### Phase 1: Reconnaissance

1. **Analyze the target**: Identify data sources, page structure, and JavaScript dependencies
2. **Check robots.txt**: Review `/robots.txt` for allowed/disallowed paths and crawl-delay
3. **Inspect the page**: Use browser DevTools to understand DOM structure, XHR requests, and data loading patterns
4. **Identify anti-bot measures**: Check for CAPTCHA, rate limiting, fingerprinting, Cloudflare/DataDome
5. **Choose extraction method**: Static HTML vs. JavaScript-rendered vs. API reverse-engineering

### Phase 2: Setup

1. **Select tools**: HTTP client (fetch/axios), parser (cheerio/jsdom), browser (Playwright/Puppeteer)
2. **Configure rate limiting**: Set appropriate delays between requests
3. **Set up proxy rotation**: If needed for scale or anti-detection
4. **Design data schema**: Define output structure before coding
5. **Plan error handling**: Retry logic, fallback extraction methods

### Phase 3: Extraction

1. **Fetch pages**: Use appropriate client with proper headers
2. **Parse HTML**: Apply CSS selectors or XPath to extract target data
3. **Handle JavaScript rendering**: Use headless browser if content is JS-rendered
4. **Follow pagination**: Implement next-page detection and traversal
5. **Extract structured data**: Transform raw HTML into clean, typed data

### Phase 4: Processing

1. **Clean data**: Remove HTML entities, normalize text, handle encoding
2. **Validate data**: Ensure extracted fields match expected schema
3. **Deduplicate**: Remove duplicate entries based on unique identifiers
4. **Store results**: Save to database, CSV, JSON, or other formats
5. **Monitor and alert**: Track scraper health and data quality

### Phase 5: Maintenance

1. **Monitor for changes**: Track selector success rates and data quality
2. **Update selectors**: When target site structure changes
3. **Scale responsibly**: Adjust rate limits and proxies as needed
4. **Comply with robots.txt**: Re-check periodically for policy changes
5. **Archive raw data**: Keep original HTML for re-processing if needed

## Advanced Techniques

### 1. Anti-Bot Detection Bypass with Browser Fingerprinting

```typescript
// Playwright with stealth plugins
import { chromium, BrowserContext } from 'playwright';

async function createStealthBrowser(): Promise<BrowserContext> {
  const browser = await chromium.launch({
    headless: false,
    args: [
      '--disable-blink-features=AutomationControlled',
      '--disable-features=IsolateOrigins,site-per-process',
      '--no-sandbox',
    ],
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    viewport: { width: 1920, height: 1080 },
    locale: 'en-US',
    timezoneId: 'America/New_York',
    geolocation: { latitude: 40.7128, longitude: -74.0060 },
    permissions: ['geolocation'],
  });

  // Inject anti-detection scripts
  await context.addInitScript(() => {
    // Override webdriver property
    Object.defineProperty(navigator, 'webdriver', { get: () => false });

    // Override plugins
    Object.defineProperty(navigator, 'plugins', {
      get: () => [1, 2, 3, 4, 5],
    });

    // Override languages
    Object.defineProperty(navigator, 'languages', {
      get: () => ['en-US', 'en'],
    });

    // Override permissions API
    const originalQuery = window.navigator.permissions.query;
    window.navigator.permissions.query = (parameters: any) =>
      parameters.name === 'notifications'
        ? Promise.resolve({ state: Notification.permission } as PermissionStatus)
        : originalQuery(parameters);
  });

  return context;
}
```

### 2. Dynamic Content Extraction with MutationObserver

```typescript
// Wait for specific content to appear in dynamically loaded page
async function waitForContent(
  page: Page,
  selector: string,
  timeout = 10000
): Promise<ElementHandle> {
  return page.waitForFunction(
    (sel) => {
      const el = document.querySelector(sel);
      return el && el.textContent.trim().length > 0;
    },
    { timeout },
    selector
  );
}

// Extract data after AJAX loads
async function extractAfterAjax(
  page: Page,
  triggerSelector: string,
  dataSelector: string
): Promise<string[]> {
  // Click to trigger AJAX
  await page.click(triggerSelector);

  // Wait for response
  await page.waitForResponse(
    (response) => response.url().includes('/api/') && response.status() === 200
  );

  // Extract new data
  return page.$$eval(dataSelector, (els) =>
    els.map((el) => el.textContent?.trim() || '')
  );
}
```

### 3. Proxy Rotation with Health Checks

```typescript
interface Proxy {
  host: string;
  port: number;
  username?: string;
  password?: string;
  protocol: 'http' | 'https' | 'socks5';
  lastUsed: number;
  failCount: number;
  avgResponseTime: number;
}

class ProxyRotator {
  private proxies: Proxy[] = [];
  private currentIndex = 0;

  constructor(proxyList: Array<Omit<Proxy, 'lastUsed' | 'failCount' | 'avgResponseTime'>>) {
    this.proxies = proxyList.map(p => ({
      ...p,
      lastUsed: 0,
      failCount: 0,
      avgResponseTime: 0,
    }));
  }

  getNext(): Proxy {
    // Sort by: fewest failures, fastest response, least recently used
    const sorted = [...this.proxies].sort((a, b) => {
      if (a.failCount !== b.failCount) return a.failCount - b.failCount;
      if (a.avgResponseTime !== b.avgResponseTime) return a.avgResponseTime - b.avgResponseTime;
      return a.lastUsed - b.lastUsed;
    });

    const proxy = sorted[0];
    proxy.lastUsed = Date.now();
    return proxy;
  }

  reportSuccess(proxy: Proxy, responseTime: number): void {
    proxy.avgResponseTime = (proxy.avgResponseTime + responseTime) / 2;
    proxy.failCount = Math.max(0, proxy.failCount - 1);
  }

  reportFailure(proxy: Proxy): void {
    proxy.failCount++;
    if (proxy.failCount > 5) {
      this.proxies = this.proxies.filter(p => p !== proxy);
    }
  }

  async checkProxy(proxy: Proxy): Promise<boolean> {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 5000);

      const response = await fetch('http://httpbin.org/ip', {
        signal: controller.signal,
        // @ts-ignore
        agent: new (require('https-proxy-agent'))(proxy.host + ':' + proxy.port),
      });

      clearTimeout(timeout);
      return response.ok;
    } catch {
      return false;
    }
  }
}
```

### 4. API Reverse-Engineering Pattern

```typescript
// Intercept network requests to discover API endpoints
async function reverseEngineerAPI(page: Page): Promise<APIEndpoint[]> {
  const endpoints: APIEndpoint[] = [];

  // Listen for all network requests
  page.on('request', (request) => {
    const url = request.url();
    if (url.includes('/api/') || url.includes('/graphql')) {
      endpoints.push({
        url,
        method: request.method(),
        headers: request.headers(),
        postData: request.postData(),
        resourceType: request.resourceType(),
      });
    }
  });

  // Also capture responses for data structure analysis
  page.on('response', async (response) => {
    const url = response.url();
    if (url.includes('/api/') && response.status() === 200) {
      try {
        const contentType = response.headers()['content-type'];
        if (contentType?.includes('application/json')) {
          const body = await response.json();
          console.log(`API Response from ${url}:`, JSON.stringify(body, null, 2));
        }
      } catch {}
    }
  });

  return endpoints;
}

// Build direct API client from discovered endpoints
class ReverseEngineeredClient {
  constructor(private baseHeaders: Record<string, string>) {}

  async fetchJSON<T>(url: string, options?: RequestInit): Promise<T> {
    const response = await fetch(url, {
      ...options,
      headers: {
        ...this.baseHeaders,
        ...options?.headers,
      },
    });

    if (!response.ok) {
      throw new APIError(response.status, await response.text());
    }

    return response.json();
  }
}
```

### 5. Intelligent Pagination Handler

```typescript
interface PaginationConfig {
  // CSS selector for next button
  nextSelector?: string;
  // URL pattern for page parameter
  urlPattern?: (page: number) => string;
  // Function to detect if there are more pages
  hasMore: (page: number, data: unknown[]) => boolean;
  // Maximum pages to scrape
  maxPages?: number;
  // Delay between pages (ms)
  delay?: number;
}

async function scrapePaginated<T>(
  scrapeFn: (page: number) => Promise<T[]>,
  config: PaginationConfig
): Promise<T[]> {
  const allData: T[] = [];
  let page = 1;
  const maxPages = config.maxPages || 100;
  const delay = config.delay || 2000;

  while (page <= maxPages) {
    console.log(`Scraping page ${page}...`);

    try {
      const data = await scrapeFn(page);
      allData.push(...data);

      if (!config.hasMore(page, data)) {
        console.log(`No more pages after page ${page}`);
        break;
      }

      page++;
      await new Promise(r => setTimeout(r, delay));
    } catch (error) {
      console.error(`Error on page ${page}:`, error);
      if (page === 1) throw error;
      break;
    }
  }

  return allData;
}

// Usage with URL pattern
const data = await scrapePaginated(
  async (page) => {
    const url = `https://example.com/products?page=${page}`;
    const html = await fetchHTML(url);
    return parseProducts(html);
  },
  {
    hasMore: (page, data) => data.length > 0,
    maxPages: 50,
    delay: 3000,
  }
);
```

### 6. Structured Data Extraction with CSS Selectors

```typescript
import * as cheerio from 'cheerio';

interface Product {
  name: string;
  price: number;
  rating: number;
  reviewCount: number;
  imageUrl: string;
  url: string;
}

function extractProducts(html: string): Product[] {
  const $ = cheerio.load(html);
  const products: Product[] = [];

  $('.product-card').each((_, element) => {
    const $el = $(element);

    // Extract price, handling various formats
    const priceText = $el.find('.price').text().trim();
    const price = parseFloat(priceText.replace(/[^0-9.]/g, ''));

    // Extract rating from star classes or data attributes
    const ratingAttr = $el.find('.rating').attr('data-rating');
    const rating = ratingAttr ? parseFloat(ratingAttr) : 0;

    // Extract review count, handling "1.2k" format
    const reviewText = $el.find('.review-count').text().trim();
    const reviewCount = parseReviewCount(reviewText);

    products.push({
      name: $el.find('.product-title a').text().trim(),
      price,
      rating,
      reviewCount,
      imageUrl: $el.find('img').attr('src') || '',
      url: $el.find('.product-title a').attr('href') || '',
    });
  });

  return products;
}

function parseReviewCount(text: string): number {
  const match = text.match(/([\d.]+)\s*[kK]?/);
  if (!match) return 0;
  const num = parseFloat(match[1]);
  return text.toLowerCase().includes('k') ? num * 1000 : num;
}
```

### 7. Headless Browser Session Management

```typescript
import { chromium, BrowserContext, Page } from 'playwright';

class BrowserPool {
  private contexts: BrowserContext[] = [];
  private maxContexts: number;

  constructor(private maxPages: number = 10) {
    this.maxContexts = Math.ceil(maxPages / 5); // ~5 pages per context
  }

  async init(): Promise<void> {
    const browser = await chromium.launch({ headless: true });

    for (let i = 0; i < this.maxContexts; i++) {
      const context = await browser.newContext({
        userAgent: this.getRandomUserAgent(),
        viewport: { width: 1920, height: 1080 },
        locale: 'en-US',
      });

      // Set up cookie persistence
      await context.addCookies([]);

      this.contexts.push(context);
    }
  }

  async getPage(): Promise<{ context: BrowserContext; page: Page; release: () => void }> {
    const context = this.contexts[Math.floor(Math.random() * this.contexts.length)];
    const page = await context.newPage();

    let released = false;
    const release = () => {
      if (!released) {
        page.close();
        released = true;
      }
    };

    return { context, page, release };
  }

  private getRandomUserAgent(): string {
    const agents = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0',
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    ];
    return agents[Math.floor(Math.random() * agents.length)];
  }

  async close(): Promise<void> {
    for (const context of this.contexts) {
      await context.close();
    }
    this.contexts = [];
  }
}
```

## Common Patterns

### Pattern 1: Static HTML Scraping with Fetch + Cheerio

```typescript
import * as cheerio from 'cheerio';

async function scrapeStaticPage(url: string): Promise<ScrapedData> {
  const response = await fetch(url, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (compatible; DataBot/1.0)',
      'Accept': 'text/html,application/xhtml+xml',
      'Accept-Language': 'en-US,en;q=0.9',
    },
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
  }

  const html = await response.text();
  const $ = cheerio.load(html);

  // Extract structured data
  const title = $('h1').first().text().trim();
  const description = $('meta[name="description"]').attr('content') || '';
  const items: Item[] = [];

  $('.item').each((_, el) => {
    const $el = $(el);
    items.push({
      name: $el.find('.name').text().trim(),
      value: $el.find('.value').text().trim(),
      link: $el.find('a').attr('href') || '',
    });
  });

  return { title, description, items, scrapedAt: new Date().toISOString() };
}
```

### Pattern 2: JavaScript-Rendered Content with Playwright

```typescript
import { chromium } from 'playwright';

async function scrapeDynamicPage(url: string): Promise<ScrapedData> {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  try {
    await page.goto(url, { waitUntil: 'networkidle' });

    // Wait for specific content
    await page.waitForSelector('.data-container', { timeout: 10000 });

    // Extract data
    const data = await page.evaluate(() => {
      const items = Array.from(document.querySelectorAll('.item'));
      return items.map(item => ({
        name: (item.querySelector('.name') as HTMLElement)?.innerText || '',
        value: (item.querySelector('.value') as HTMLElement)?.innerText || '',
        link: (item.querySelector('a') as HTMLAnchorElement)?.href || '',
      }));
    });

    return { items: data, scrapedAt: new Date().toISOString() };
  } finally {
    await browser.close();
  }
}
```

### Pattern 3: CSV Export with Streaming

```typescript
import { createWriteStream } from 'fs';
import { Transform } from 'stream';

class CSVExporter {
  private writeStream: ReturnType<typeof createWriteStream>;
  private headers: string[];
  private isFirstChunk = true;

  constructor(filePath: string, headers: string[]) {
    this.writeStream = createWriteStream(filePath, { encoding: 'utf-8' });
    this.headers = headers;
    this.writeHeaders();
  }

  private writeHeaders(): void {
    this.writeStream.write(this.headers.join(',') + '\n');
  }

  writeRow(row: Record<string, unknown>): void {
    const values = this.headers.map(header => {
      const value = String(row[header] || '');
      // Escape CSV special characters
      if (value.includes(',') || value.includes('"') || value.includes('\n')) {
        return `"${value.replace(/"/g, '""')}"`;
      }
      return value;
    });

    this.writeStream.write(values.join(',') + '\n');
  }

  async close(): Promise<void> {
    return new Promise((resolve) => {
      this.writeStream.end(resolve);
    });
  }
}

// Usage
const exporter = new CSVExporter('output.csv', ['name', 'price', 'url']);
for (const product of products) {
  exporter.writeRow(product);
}
await exporter.close();
```

### Pattern 4: robots.txt Compliance Checker

```typescript
import { URL } from 'url';

interface RobotsRule {
  userAgent: string;
  allow: string[];
  disallow: string[];
  crawlDelay?: number;
}

async function checkRobotsTxt(baseURL: string, path: string): Promise<boolean> {
  try {
    const robotsUrl = new URL('/robots.txt', baseURL).toString();
    const response = await fetch(robotsUrl);
    if (!response.ok) return true; // If no robots.txt, assume allowed

    const content = await response.text();
    const rules = parseRobotsTxt(content);

    // Check for our user agent
    const relevantRule = rules.find(r =>
      r.userAgent === '*' || r.userAgent.toLowerCase().includes('bot')
    );

    if (!relevantRule) return true;

    // Check disallow rules
    for (const disallowed of relevantRule.disallow) {
      if (path.startsWith(disallowed)) {
        return false;
      }
    }

    return true;
  } catch {
    return true; // If can't fetch robots.txt, assume allowed
  }
}

function parseRobotsTxt(content: string): RobotsRule[] {
  const rules: RobotsRule[] = [];
  let currentRule: RobotsRule | null = null;

  for (const line of content.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;

    const [key, ...valueParts] = trimmed.split(':');
    const value = valueParts.join(':').trim();

    if (key.toLowerCase() === 'user-agent') {
      currentRule = { userAgent: value, allow: [], disallow: [] };
      rules.push(currentRule);
    } else if (currentRule) {
      if (key.toLowerCase() === 'disallow') {
        currentRule.disallow.push(value);
      } else if (key.toLowerCase() === 'allow') {
        currentRule.allow.push(value);
      } else if (key.toLowerCase() === 'crawl-delay') {
        currentRule.crawlDelay = parseInt(value);
      }
    }
  }

  return rules;
}
```

### Pattern 5: Multi-Source Aggregator with Rate Limiting

```typescript
interface ScraperSource {
  name: string;
  url: string;
  extract: (html: string) => Promise<DataItem[]>;
  rateLimit: number; // ms between requests
}

class MultiSourceAggregator {
  private sources: ScraperSource[];
  private lastRequest: Map<string, number> = new Map();

  constructor(sources: ScraperSource[]) {
    this.sources = sources;
  }

  async scrapeAll(): Promise<DataItem[]> {
    const results = await Promise.allSettled(
      this.sources.map(source => this.scrapeSource(source))
    );

    const allData: DataItem[] = [];
    results.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        allData.push(...result.value);
      } else {
        console.error(`Failed to scrape ${this.sources[index].name}:`, result.reason);
      }
    });

    return this.deduplicate(allData);
  }

  private async scrapeSource(source: ScraperSource): Promise<DataItem[]> {
    // Rate limit
    const lastTime = this.lastRequest.get(source.name) || 0;
    const waitTime = source.rateLimit - (Date.now() - lastTime);
    if (waitTime > 0) {
      await new Promise(r => setTimeout(r, waitTime));
    }

    // Fetch and extract
    const response = await fetch(source.url);
    const html = await response.text();
    const data = await source.extract(html);

    this.lastRequest.set(source.name, Date.now());
    return data;
  }

  private deduplicate(items: DataItem[]): DataItem[] {
    const seen = new Set<string>();
    return items.filter(item => {
      const key = `${item.source}:${item.id}`;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    });
  }
}
```

## Edge Cases & Pitfalls

| # | Edge Case | Problem | Solution |
|---|-----------|---------|----------|
| 1 | **CAPTCHA challenges** | Automated requests trigger CAPTCHA | Use CAPTCHA-solving services; implement delays; use residential proxies |
| 2 | **JavaScript-rendered content** | Static HTML fetch returns empty/missing content | Use headless browser (Playwright/Puppeteer) for JS-rendered pages |
| 3 | **Anti-bot fingerprinting** | Browser detected as automated | Use stealth plugins; randomize fingerprints; use real browsers |
| 4 | **Rate limiting (429 errors)** | Too many requests from same IP | Implement exponential backoff; rotate proxies; respect Retry-After |
| 5 | **Dynamic class names** | CSS classes change on each build (CSS modules) | Use data attributes, semantic HTML, or relative selectors |
| 6 | **Infinite scroll** | Content loads on scroll, not page load | Simulate scrolling; intercept API calls; use IntersectionObserver |
| 7 | **Cookie/session expiration** | Session expires mid-scrape | Implement cookie refresh; handle re-authentication |
| 8 | **Encoding issues** | Special characters garbled | Detect encoding with `chardet`; use proper charset handling |
| 9 | **robots.txt violations** | Scraping disallowed paths | Always check robots.txt first; implement compliance checker |
| 10 | **Duplicate content** | Same page scraped multiple times | Use URL normalization; maintain seen-set; use content hashing |
| 11 | **Large HTML pages** | Memory issues with huge pages | Use streaming parsers; process in chunks; limit DOM size |
| 12 | **Timezone differences** | Dates/times in different timezones | Normalize to UTC; handle timezone-aware parsing |
| 13 | **Internationalized content** | Multi-language pages break selectors | Use language-agnostic selectors; handle RTL text |
| 14 | **Legal compliance** | Violating Terms of Service | Review ToS; consult legal; implement opt-out mechanisms |
| 15 | **Data quality degradation** | Scraper silently returns wrong data | Implement data validation; monitor extraction rates; alert on anomalies |

## Integration with Other Skills

| Skill | Integration Points |
|-------|-------------------|
| **Browser Automation** | Use Playwright/Puppeteer for JS-rendered content |
| **API Integration** | Reverse-engineer APIs; use discovered endpoints directly |
| **Data Transformation** | Clean, normalize, and transform scraped data |
| **Database Design** | Store scraped data; track scraping state |
| **Error Handling** | Handle network errors, parsing failures, anti-bot measures |
| **Caching** | Cache scraped pages; implement ETag/If-Modified-Since |
| **Security** | Protect scraped data; handle PII responsibly |
| **Performance** | Parallel scraping; connection pooling; memory management |
| **Monitoring** | Track scraper health; alert on failures |
| **Compliance** | robots.txt; rate limiting; data retention policies |

## Output Format Templates

### Standard Template

```markdown
# Web Scraper: [Target Site]

## Configuration
- Target URL: [url]
- Rate Limit: [delay between requests]
- Proxy: [yes/no, rotation strategy]

## Data Schema
| Field | Type | Selector | Description |
|-------|------|----------|-------------|
| name | string | `.product-title` | Product name |
| price | number | `.price-value` | Price in USD |

## Code Example
[language-specific extraction code]

## Usage
[how to run the scraper]
```

### Quick Template

```markdown
# Quick Scrape: [Target]

1. Install: `npm install cheerio node-fetch`
2. Run: `npx tsx scrape.ts`
3. Output: `output.json`

## Selectors
- Title: `h1.title`
- Items: `.list-item`
```

### Deep Template

```markdown
# Comprehensive Scraper Guide: [Target]

## Architecture
[scraper architecture diagram]

## Anti-Bot Strategy
[detection methods and bypass techniques]

## Data Pipeline
[extraction → transformation → storage]

## Monitoring
[health checks, data quality metrics]

## Scaling
[parallel scraping, proxy rotation, distributed architecture]

## Compliance
[robots.txt, ToS review, rate limiting]
```

### Agent Template

```markdown
# Scraper Agent Instructions

## Task
Scrape [data type] from [target site] for [purpose].

## Requirements
- [ ] robots.txt compliance check
- [ ] Rate limiting implementation
- [ ] Error handling and retry logic
- [ ] Data validation
- [ ] Duplicate detection
- [ ] Structured output (JSON/CSV)
- [ ] Logging and monitoring

## Data Schema
[define expected output structure]

## Testing
- [ ] Unit tests for extractors
- [ ] Integration tests with mock HTML
- [ ] Performance tests for rate limits
- [ ] Compliance tests for robots.txt

## Ethics
- Respect rate limits
- Check robots.txt
- Don't overload servers
- Handle PII responsibly
```

## Rules

1. **Always check robots.txt** before scraping; respect Crawl-delay and Disallow directives
2. **Implement rate limiting** — Never send more than 1 request per second without explicit permission
3. **Use proper User-Agent** — Identify your scraper with a descriptive User-Agent string
4. **Handle errors gracefully** — Retry with backoff; don't crash on single failures
5. **Validate extracted data** — Ensure data matches expected schema before storage
6. **Minimize server load** — Use conditional requests (If-Modified-Since, ETag) when possible
7. **Cache responses** — Don't re-fetch unchanged pages
8. **Respect copyright** — Don't scrape and republish copyrighted content
9. **Handle PII responsibly** — Anonymize or delete personal data when not needed
10. **Monitor scraper health** — Track success rates, error types, and data quality
11. **Keep selectors maintainable** — Use data attributes over CSS classes when possible
12. **Archive raw HTML** — Keep original content for re-processing and debugging
13. **Use session management** — Handle cookies and authentication properly
14. **Document your scraper** — Include setup, usage, and maintenance instructions
15. **Plan for failure** — Assume selectors will break; build monitoring and alerting
