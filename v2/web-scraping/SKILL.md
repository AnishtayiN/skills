---
name: web-scraping
description: >-
  Write scripts to extract structured data from websites, web pages, and HTML sources.
  Use this skill whenever the user mentions web scraping, extract data from website, scrape this site,
  crawl website, parse HTML, get data from a web page, scrape a table from a webpage,
  extract links from a page, scrape product data, scrape search results, collect data from a site,
  build a scraper, automate data collection from web, extract articles from a website,
  scrape prices, scrape reviews, scrape contact info, scrape job listings, scrape news,
  parse XML/HTML, extract metadata from a page, download data from a website,
  scrape real estate listings, scrape stock data, scrape sports statistics,
  scrape restaurant menus, scrape event listings, scrape government data,
  scrape API data, intercept XHR requests, reverse-engineer website APIs,
  handle pagination scraping, scrape with login, scrape behind authentication,
  handle infinite scroll scraping, scrape dynamic content, scrape single-page apps,
  handle CAPTCHA scraping, scrape with proxies, rotate user agents,
  parse JSON-LD structured data, extract Open Graph metadata, parse sitemap XML,
  scrape multiple pages, batch scraping, scheduled scraping, incremental scraping,
  or says اسکرپینگ وب، استخراج داده از وبسایت، پارس HTML، خزش وب،
  دریافت اطلاعات از سایت، اسکرپ سایت، استخراج لینک، کراولر وب،
  جمع‌آوری داده از وب، دانلود داده از سایت، استخراج قیمت، استخراج نظرات،
  استخراج اطلاعات تماس، استخراج آگهی‌های شغلی، استخراج اخبار،
  پارس جدول از وبسایت، اسکرپ با لاگین، اسکرپ صفحات پویا،
  مدیریت صفحه‌بندی در اسکرپینگ، اسکرپ API، دریافت داده از API مخفی،
  خزش وبسایت‌های فارسی، استخراج داده از سایت‌های ایرانی،
  دانلود دسته‌ای از وب، استخراج متادیتا، پارس JSON-LD.
---

# Web Scraping Skill — Extract Structured Data from Websites

## Overview

This skill creates scripts to extract structured data from web pages. It handles everything from a single-page table extraction to multi-page crawls with pagination, login, and rate limiting. The output is always clean, structured data (CSV, JSON, or DataFrame) ready for analysis.

## When to Use This Skill

- User wants data from a specific website or URL
- User needs to extract tables, lists, articles, or product info from web pages
- User wants to scrape multiple pages (pagination, search results)
- User needs to extract links, images, or metadata from HTML
- User says "scrape this site" or "get data from this page"
- User needs a reusable scraper for recurring data collection
- User wants to reverse-engineer a website's hidden API
- User needs to scrape content behind login/authentication
- User wants to extract structured data (JSON-LD, Open Graph, microdata)
- User needs to scrape Persian/Farsi websites with RTL content
- User wants to parse sitemaps or RSS feeds for URL discovery

## Scraping Workflow

### Step 1: Understand the Target

Before writing any code, inspect the target page:

1. **Get the URL** — Ask the user for the specific URL(s) to scrape.
2. **Fetch the page** — Use `curl` or a simple Python `requests.get()` to retrieve the HTML.
3. **Inspect the structure** — Identify the HTML elements containing the target data:
   - Use `curl` + Read tool to examine raw HTML
   - Look for `<table>`, `<article>`, `<div class="...">`, `<li>`, or other containers
   - Note CSS classes, IDs, or data attributes that uniquely identify elements
   - Check if data is in the HTML or loaded dynamically via JavaScript
4. **Check for anti-scraping measures** — Look for:
   - Rate limiting or CAPTCHAs
   - Login requirements
   - Cookie/JavaScript-dependent content
   - `robots.txt` restrictions
5. **Check for hidden APIs** — Open browser DevTools, look for XHR/fetch network requests that return JSON. Calling the API directly is 10-100x faster than parsing HTML.

### Step 2: Choose the Right Approach

| Scenario | Approach |
|----------|----------|
| Simple static HTML, single page | `requests` + `BeautifulSoup` |
| Tables or lists on a single page | `pandas.read_html()` or BeautifulSoup |
| Multiple pages with pagination | Loop with URL patterns or follow "Next" links |
| JavaScript-rendered content | Use the **agent-browser** skill for Playwright-based rendering |
| Login required | `requests.Session()` with credentials, or agent-browser |
| API behind the page | Intercept XHR/fetch requests; call the API directly (much faster) |
| JSON-LD / Schema.org data | Parse `<script type="application/ld+json">` tags directly |
| Sitemap / RSS | Parse XML with `ElementTree` or `feedparser` |

**Always prefer the simplest approach.** If the data is in a clean HTML table, `pandas.read_html()` is one line. Don't over-engineer.

### Step 3: Write the Scraper

Build the scraper as a standalone Python script with these components:

```python
# 1. Configuration
BASE_URL = "..."
HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}

# 2. Fetch function (with error handling and retry)
def fetch(url, session=None, retries=3):
    s = session or requests.Session()
    for attempt in range(retries):
        try:
            response = s.get(url, headers=HEADERS, timeout=15)
            response.raise_for_status()
            return response
        except requests.RequestException as e:
            if attempt == retries - 1:
                raise
            time.sleep(2 ** attempt)

# 3. Parse function (extract structured data)
def parse(html):
    soup = BeautifulSoup(html, "html.parser")
    results = []
    for item in soup.select(".item-selector"):
        results.append({
            "field1": item.select_one(".field1").get_text(strip=True),
            "field2": item.select_one(".field2")["href"],
        })
    return results

# 4. Main loop (pagination if needed)
all_data = []
for page in range(1, max_pages + 1):
    html = fetch(f"{BASE_URL}?page={page}").text
    all_data.extend(parse(html))
    time.sleep(random.uniform(1, 3))  # Be polite

# 5. Save output
df = pd.DataFrame(all_data)
df.to_csv("output.csv", index=False)
print(f"Scraped {len(df)} records")
```

Key scraper requirements:
- **Error handling**: Catch HTTP errors, timeouts, and parse failures per page (don't crash on one bad page)
- **Rate limiting**: Always add `time.sleep()` between requests (1-3 seconds minimum)
- **User-Agent header**: Include a realistic browser User-Agent
- **Logging**: Print progress (page X of Y) so the user can monitor
- **Incremental saving**: For large scrapes, save after each page or every N pages

### Step 4: Handle Common Challenges

- **Pagination**: Detect the pattern (URL params, "Next" button href) and loop
- **Inconsistent HTML**: Use defensive parsing — check if elements exist before accessing them; use `.get_text(strip=True, separator=" ")` for clean text
- **Relative URLs**: Convert to absolute using `urllib.parse.urljoin(base, relative)`
- **Encoded content**: Handle `charset` from response headers; decode with `response.encoding` or `response.content.decode('utf-8')`
- **Lazy-loaded images/data**: Check `data-src` or `data-lazy-src` attributes in addition to `src`
- **Nested structures**: Use recursive parsing or multiple passes for complex nested data
- **Anti-bot detection**: Rotate User-Agents, add delays, use session cookies

### Step 5: Validate and Save

1. **Validate output**: Check record count, spot-check a few rows, verify no empty critical fields
2. **Save in requested format**: CSV (default), JSON, or Excel
3. **Report results**: Show sample rows and total count

## Advanced Techniques

### 1. Reverse-Engineering Hidden APIs

Many modern websites load data via AJAX. Intercepting the API call is vastly faster than parsing HTML:

```python
import json
import requests

# Discovered from browser DevTools Network tab
api_url = "https://api.example.com/products"
params = {"page": 1, "limit": 50}
headers = {
    "User-Agent": "...",
    "Accept": "application/json",
    "Referer": "https://www.example.com/products"
}

all_products = []
page = 1
while True:
    params["page"] = page
    resp = requests.get(api_url, headers=headers, params=params, timeout=15)
    data = resp.json()
    items = data.get("items", data.get("results", data.get("data", [])))
    if not items:
        break
    all_products.extend(items)
    page += 1
    time.sleep(0.5)

print(f"Total products: {len(all_products)}")
```

### 2. Session-Based Login Scraping

Maintain authentication across multiple requests:

```python
import requests

session = requests.Session()

# Step 1: Get login page (to load CSRF token)
login_page = session.get("https://example.com/login")
# Extract CSRF token from HTML (varies by site)
csrf_token = BeautifulSoup(login_page.text, "html.parser").select_one('input[name="csrf"]')["value"]

# Step 2: Submit login form
session.post("https://example.com/login", data={
    "email": "user@example.com",
    "password": "password",
    "csrf_token": csrf_token
})

# Step 3: Scrape protected pages
for url in protected_urls:
    html = session.get(url, headers=HEADERS).text
    # parse(html) ...
    time.sleep(2)
```

### 3. JSON-LD Structured Data Extraction

Many pages embed structured data in `<script type="application/ld+json">` tags:

```python
import json
from bs4 import BeautifulSoup

def extract_json_ld(html):
    soup = BeautifulSoup(html, "html.parser")
    data = []
    for script in soup.find_all("script", type="application/ld+json"):
        try:
            parsed = json.loads(script.string)
            if isinstance(parsed, list):
                data.extend(parsed)
            else:
                data.append(parsed)
        except (json.JSONDecodeError, TypeError):
            continue
    return data

# Extract product data from JSON-LD
for item in extract_json_ld(html):
    if item.get("@type") == "Product":
        print(item.get("name"), item.get("offers", {}).get("price"))
```

### 4. Sitemap Parsing for URL Discovery

Discover all pages on a site before scraping:

```python
import xml.etree.ElementTree as ET
import requests

def parse_sitemap(sitemap_url):
    resp = requests.get(sitemap_url, headers=HEADERS, timeout=15)
    root = ET.fromstring(resp.content)
    ns = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
    urls = [loc.text for loc in root.findall(".//sm:loc", ns)]
    # Check for sitemap index (nested sitemaps)
    sitemaps = [loc.text for loc in root.findall(".//sm:sitemap/sm:loc", ns)]
    for sm_url in sitemaps:
        urls.extend(parse_sitemap(sm_url))
    return urls
```

### 5. Handling Infinite Scroll

Infinite scroll pages load more content as you scroll. The key is finding the API endpoint:

```python
# Method 1: Direct API (preferred) — found via DevTools
offset = 0
all_items = []
while True:
    resp = requests.get(f"https://api.example.com/items?offset={offset}&limit=20",
                        headers=HEADERS, timeout=15)
    items = resp.json().get("items", [])
    if not items:
        break
    all_items.extend(items)
    offset += len(items)
    time.sleep(0.5)

# Method 2: Playwright (if no API found) — use agent-browser skill
```

### 6. Robust Selector Patterns with Fallbacks

Websites change their HTML frequently. Write selectors with fallbacks:

```python
def safe_extract(element, selectors, attr=None):
    """Try multiple CSS selectors, return first match."""
    for sel in selectors:
        el = element.select_one(sel)
        if el:
            if attr:
                return el.get(attr, "").strip()
            return el.get_text(strip=True, separator=" ")
    return ""  # Return empty string instead of None to avoid NaN in DataFrame

# Usage with primary and fallback selectors
price = safe_extract(item, [".price-current", ".product-price", "[data-price]", ".price"])
title = safe_extract(item, ["h1.product-title", ".product-name", "h2 a"])
```

### 7. Concurrent Scraping with ThreadPoolExecutor

For I/O-bound scraping (most cases), threads dramatically speed up multi-page scrapes:

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading

lock = threading.Lock()
results = []
MAX_WORKERS = 3  # Keep low to avoid overwhelming the server

def scrape_page(url):
    try:
        resp = requests.get(url, headers=HEADERS, timeout=15)
        items = parse(resp.text)
        with lock:
            results.extend(items)
        return len(items)
    except Exception as e:
        return 0

with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
    futures = {executor.submit(scrape_page, url): url for url in all_urls}
    for future in as_completed(futures):
        url = futures[future]
        count = future.result()
        print(f"  Scraped {url} → {count} items")
```

## Common Patterns

### Pattern 1: Scrape a Wikipedia Table

```python
import pandas as pd

url = "https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)"
dfs = pd.read_html(url, match="GDP.*nominal")
df = dfs[0]
df.columns = ["Rank", "Country", "GDP_USD", ""]  # Clean multi-level headers
df = df.drop(columns=[""]).dropna(subset=["Country"])
df.to_csv("gdp_countries.csv", index=False)
```

### Pattern 2: Scrape Product Listings with Pagination

```python
all_products = []
page = 1
while True:
    url = f"https://store.example.com/category?page={page}"
    resp = requests.get(url, headers=HEADERS, timeout=15)
    if resp.status_code != 200:
        break
    soup = BeautifulSoup(resp.text, "html.parser")
    items = soup.select(".product-card")
    if not items:
        break
    for item in items:
        all_products.append({
            "name": safe_extract(item, [".product-name"]),
            "price": safe_extract(item, [".price"])
        })
    page += 1
    time.sleep(random.uniform(1, 3))
```

### Pattern 3: Extract All Links from a Page

```python
from urllib.parse import urljoin

def extract_links(html, base_url, pattern=None):
    soup = BeautifulSoup(html, "html.parser")
    links = []
    for a in soup.find_all("a", href=True):
        full_url = urljoin(base_url, a["href"])
        if pattern and not re.search(pattern, full_url):
            continue
        links.append({"url": full_url, "text": a.get_text(strip=True)})
    return links
```

### Pattern 4: Scrape News Articles with Metadata

```python
article = {}
soup = BeautifulSoup(html, "html.parser")

# Try JSON-LD first
for ld in extract_json_ld(html):
    if ld.get("@type") == "NewsArticle":
        article["title"] = ld.get("headline", "")
        article["date"] = ld.get("datePublished", "")
        article["author"] = ld.get("author", {}).get("name", "")
        break

# Fallback to HTML parsing
article.setdefault("title", safe_extract(soup, ["h1", ".headline", "title"]))
article.setdefault("date", safe_extract(soup, ["time", ".date", ".published"]))
article["content"] = safe_extract(soup, ["article", ".post-content", ".entry-content"])
```

### Pattern 5: Scrape with Rotating User-Agents

```python
import random

USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
]

def fetch_with_ua(url):
    headers = {"User-Agent": random.choice(USER_AGENTS)}
    return requests.get(url, headers=headers, timeout=15)
```

## Edge Cases & Pitfalls

1. **CAPTCHA / Bot Detection** — Cloudflare, reCAPTCHA, and custom bot detection block automated requests. If blocked, the agent-browser skill with Playwright may bypass simple checks, but complex CAPTCHAs require manual solving or third-party services.
2. **Dynamic Class Names** — CSS-in-JS frameworks (React, Vue) generate random class names like `sc-abc123`. These change on every deployment. Use data attributes (`data-testid`, `data-cy`) or stable parent selectors instead.
3. **Rate Limiting Triggers** — Even with delays, some sites detect scraping patterns (linear timing, no cookie variations). Add jitter to delays: `time.sleep(random.uniform(1, 4))`.
4. **robots.txt Disallow** — Always check `https://example.com/robots.txt`. Warn the user if their target path is disallowed. Do not scrape disallowed paths without explicit user acknowledgment.
5. **Paginated API Cursor vs Offset** — Some APIs use cursor-based pagination (`?cursor=abc123`) instead of offset. Cursor-based APIs don't allow jumping to specific pages, so you must follow the chain sequentially.
6. **Character Encoding Mismatch** — A server may declare `charset=ISO-8859-1` but serve UTF-8 content. Prefer `response.content.decode('utf-8', errors='replace')` over `response.text` when you know the actual encoding.
7. **Truncated Content from Lazy Loading** — Content loaded via Intersection Observer or on-scroll events won't be in the initial HTML. Detect by checking if expected elements are missing from the parsed HTML.
8. **Session Expiry During Long Scrapes** — Authentication tokens expire. For long-running scrapes, add token refresh logic or periodically re-authenticate.
9. **IP Ban After Too Many Requests** — Even polite scrapes can trigger IP bans on sensitive sites. Implement exponential backoff and consider using the agent-browser skill which can use different browser contexts.
10. **Inconsistent Page Structure** — Category pages, search results, and detail pages often have different HTML structures. Write separate parse functions for each page type rather than one generic parser.
11. **Missing Fields on Some Pages** — Not all product cards have the same attributes (e.g., some lack ratings, some lack price). Always use `safe_extract` with fallbacks rather than direct attribute access.
12. **JavaScript Redirect Before Content** — Some pages redirect via `window.location = ...` before loading actual content. The initial HTML is just a redirect stub. Use agent-browser to wait for the redirect to complete.
13. **Anti-Scraping Cookie Checks** — Sites set cookies via JavaScript and verify them on subsequent requests. Without executing JS, the cookie is never set. Use `requests.Session()` to maintain cookies, or agent-browser for JS-set cookies.
14. **Large HTML Responses** — Some pages are 5MB+ of HTML with embedded JSON state. Parsing these is slow. Consider extracting just the JSON state object (e.g., `window.__INITIAL_STATE__`) instead of parsing the entire DOM.
15. **Cross-Origin Resource Sharing (CORS)** — Direct API calls from a script (not a browser) bypass CORS restrictions. This is an advantage for scraping, but some APIs also check the `Origin` or `Referer` header — set these to match the website.
16. **Legal / Terms of Service** — Some websites explicitly prohibit scraping in their ToS. Always inform the user and let them decide. This skill does not provide legal advice.

## Output Format Templates

### Template A: Standard Scraping Report

```
## Scraping Report

**Target:** [URL]
**Pages scraped:** [N]
**Records extracted:** [M]
**Output file:** [path]
**Duration:** [time]

### Sample Data
[First 5 rows as a table]

### Notes
- [Any issues encountered: blocked pages, missing fields, etc.]
- [Suggestions for next steps: schedule regular runs, handle login, etc.]
```

### Template B: API Discovery Report

```
## API Discovery Report

**Website:** [URL]
**API Endpoint Found:** [endpoint URL]
**Method:** GET/POST
**Authentication:** None / Bearer Token / Cookie
**Rate Limit:** [if detected from headers]

### Response Structure
```json
{
  "items": [...],
  "total": 1000,
  "page": 1,
  "has_more": true
}
```

### Estimated Data
- **Total records available:** [N]
- **Records per request:** [M]
- **Estimated requests needed:** [N/M]
- **Estimated time at 1 req/sec:** [time]

**Script saved to:** [path]
```

### Template C: Error Summary Report (for problematic scrapes)

```
## Scraping Attempt Summary

**Target:** [URL]
**Status:** Partial Success / Blocked / Failed

### Results
- **Pages successfully scraped:** [N] / [total]
- **Records extracted:** [M]
- **Pages failed:** [list with error codes]

### Issues Encountered
1. **[Issue]** — [detail] — [workaround attempted]
2. **[Issue]** — [detail] — [workaround attempted]

### Recommendations
- [What the user should try next]
- [Alternative data sources if scraping isn't feasible]

**Partial data saved to:** [path]
```

### Template D: Multi-Source Aggregation Report

```
## Multi-Source Scraping Report

**Sources scraped:** [N] websites
**Total records:** [M]
**Duplicates removed:** [D]
**Output file:** [path]

### Per-Source Summary
| Source | Records | Status | Notes |
|--------|---------|--------|-------|
| site1.com | 150 | OK | Pagination worked |
| site2.com | 0 | Blocked | CAPTCHA detected |
| site3.com | 75 | Partial | 2/5 pages failed |

**Combined and deduplicated data saved to:** [path]
```

## Tools & Libraries

- **requests** — HTTP requests
- **BeautifulSoup (bs4)** — HTML parsing
- **lxml** — fast HTML/XML parsing backend
- **pandas** — data output and `read_html()` for tables
- **urllib.parse** — URL manipulation
- **time / random** — rate limiting delays with jitter
- **concurrent.futures** — ThreadPoolExecutor for parallel scraping
- **xml.etree.ElementTree** — sitemap/RSS parsing
- **feedparser** — RSS/Atom feed parsing
- Use the **agent-browser** skill for JavaScript-heavy sites, login-required pages, or CAPTCHA-protected content
- Use the **web-reader** skill if only content extraction (not structured data) is needed
- Use the **data-cleaning** skill to clean scraped data before analysis
- Use the **data-analysis** skill to analyze scraped data

## Integration with Other Skills

- **agent-browser** — Use for JavaScript-rendered pages, SPAs, login-required content, CAPTCHA handling, and interactive page actions (click, scroll, wait). This is the fallback when `requests` + BeautifulSoup fails.
- **web-reader** — Use when the goal is to read article content (text extraction) rather than structured data (tables, lists, fields).
- **web-search** — Use to discover URLs to scrape when the user doesn't have specific URLs (e.g., "find all Iranian e-commerce sites selling X").
- **data-cleaning** — Scraped data is always dirty. Always run data-cleaning after scraping to handle encoding issues, normalize text, remove HTML artifacts, and fix types.
- **data-analysis** — After scraping and cleaning, analyze the collected data.
- **xlsx** — Use when the user wants scraped data saved as a formatted Excel file.
- **charts** — Use to visualize scraped data (price trends, geographic distributions, etc.).

## Ethical Guidelines

- Always check `robots.txt` before scraping
- Respect `Crawl-delay` directives
- Add delays between requests (minimum 1 second)
- Identify your bot with a descriptive User-Agent if possible
- Do not scrape personal data (emails, phone numbers) without the user's explicit request and legal justification
- Warn the user if the target site's ToS prohibits scraping
- Do not overwhelm servers — limit concurrent connections
- Save data locally; do not redistribute scraped content

## Language Handling

- Write all narrative text, explanations, and reports in the user's language
- Keep code, CSS selectors, URLs, and technical terms in English
- For Persian/Farsi websites: be aware of RTL text direction when extracting and displaying content
- Persian websites often use non-standard encoding or mixed Arabic/Persian characters — apply normalization after scraping
- Use UTF-8 encoding explicitly when saving scraped text to files
