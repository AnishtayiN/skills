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
  rotating proxies, headless browser scraping, API reverse engineering, anti-bot bypass,
  Playwright scraping, Selenium scraping, Playwright scraping, Scrapy, crawl depth,
  scrape schedule, proxy rotation, rate limiting, scraping at scale,
  or says اسکرپینگ وب، استخراج داده از وبسایت، پارس HTML، خزش وب،
  دریافت اطلاعات از سایت، اسکرپ سایت، استخراج لینک، کراولر وب،
  جمع‌آوری داده از وب، دانلود داده از سایت.
---

# Web Scraping Skill — Extract Structured Data from Websites

## Overview

This skill creates scripts to extract structured data from web pages. It handles everything from a single-page table extraction to multi-page crawls with pagination, login, anti-bot bypass, proxy rotation, and rate limiting. The output is always clean, structured data (CSV, JSON, or DataFrame) ready for analysis. This skill covers static HTML scraping, JavaScript-rendered pages, API reverse engineering, and production-grade scraping at scale.

## When to Use This Skill

- User wants data from a specific website or URL
- User needs to extract tables, lists, articles, or product info from web pages
- User wants to scrape multiple pages (pagination, search results)
- User needs to extract links, images, or metadata from HTML
- User says "scrape this site" or "get data from this page"
- User needs a reusable scraper for recurring data collection
- User needs to handle JavaScript-rendered content
- User wants to reverse-engineer an API behind a website
- User mentions اسکرپینگ وب، استخراج داده از وبسایت, or خزش وب

---

## Part 1: Approach Selection

### Decision Matrix

| Scenario | Approach | Library | Speed |
|----------|----------|---------|-------|
| Simple static HTML, single page | HTTP + Parse | `requests` + `BeautifulSoup` | ⚡⚡⚡ |
| Tables or lists on a single page | Auto-parse HTML | `pandas.read_html()` | ⚡⚡⚡ |
| Multiple pages with pagination | Loop + URL patterns | `requests` + `BeautifulSoup` | ⚡⚡⚡ |
| JavaScript-rendered content | Headless browser | `Playwright` or `Puppeteer` | ⚡⚡ |
| Login required | Session + cookies | `requests.Session()` | ⚡⚡⚡ |
| API behind the page | Intercept XHR/fetch | Direct API call | ⚡⚡⚡⚡ |
| Large-scale crawling | Framework | `Scrapy` | ⚡⚡⚡⚡ |
| Anti-bot protected site | Browser + stealth | `Playwright-stealth` | ⚡ |

**Golden Rule:** Always prefer the simplest approach. If the data is in clean HTML, `pandas.read_html()` is one line. Don't over-engineer.

---

## Part 2: Static HTML Scraping

### Basic Scraper Structure

```python
import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

# 1. Configuration
BASE_URL = "https://example.com/products"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

# 2. Fetch with error handling and retry
def fetch(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = requests.get(url, headers=HEADERS, timeout=10)
            response.raise_for_status()
            return response
        except requests.RequestException as e:
            if attempt < max_retries - 1:
                time.sleep(2 ** attempt)  # Exponential backoff
            else:
                raise

# 3. Parse function (extract structured data)
def parse(html):
    soup = BeautifulSoup(html, "html.parser")
    results = []
    for item in soup.select(".product-card"):
        results.append({
            "name": item.select_one(".product-name").get_text(strip=True),
            "price": item.select_one(".price").get_text(strip=True),
            "rating": item.select_one(".rating")["data-rating"] if item.select_one(".rating") else None,
            "url": item.select_one("a")["href"],
        })
    return results

# 4. Main loop with pagination
all_data = []
for page in range(1, 11):
    print(f"Scraping page {page}/10...")
    html = fetch(f"{BASE_URL}?page={page}").text
    data = parse(html)
    if not data:
        break  # No more data
    all_data.extend(data)
    time.sleep(2)  # Be polite

# 5. Save output
df = pd.DataFrame(all_data)
df.to_csv("products.csv", index=False)
print(f"Scraped {len(df)} products")
```

### CSS Selector Patterns

```python
# Common selectors
soup.select("div.classname")           # By class
soup.select("#element-id")             # By ID
soup.select("div > p")                 # Direct children
soup.select("div p")                   # All descendants
soup.select("a[href^='https']")       # Links starting with https
soup.select("img[data-src]")           # Lazy-loaded images
soup.select("tr:nth-child(even)")      # Alternating rows
soup.select("[data-product-id]")       # By data attribute

# Text-based selection
soup.find("h2", string="Features")     # Exact text match
soup.find("div", text=re.compile(r"Price:.*\$"))  # Regex match

# Navigation
item.find_next_sibling("div")          # Next sibling
item.find_parent("tr")                 # Parent element
item.select_one("~ .price")            # Sibling selector
```

---

## Part 3: Table Extraction

### Using pandas.read_html()

```python
import pandas as pd

# Extract ALL tables from a page
tables = pd.read_html("https://example.com/data-tables")

# Select the table you need
df = tables[0]  # First table
print(df.head())

# With specific attributes
tables = pd.read_html(
    "https://example.com/financials",
    attrs={"class": "financial-table"},
    header=0,
    flavor="bs4"
)
```

### Manual Table Extraction

```python
def extract_table(html, table_selector="table"):
    """Extract a table into a list of dictionaries."""
    soup = BeautifulSoup(html, "html.parser")
    table = soup.select_one(table_selector)
    
    # Get headers
    headers = [th.get_text(strip=True) for th in table.select("thead th")]
    
    # Get rows
    rows = []
    for tr in table.select("tbody tr"):
        cells = [td.get_text(strip=True) for td in tr.select("td")]
        if cells:
            rows.append(dict(zip(headers, cells)))
    
    return rows
```

---

## Part 4: JavaScript-Rendered Content

### Using Playwright (Recommended)

```python
from playwright.sync_api import sync_playwright
import time

def scrape_js_page(url, wait_for=".product-card"):
    """Scrape a JavaScript-rendered page."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        # Navigate and wait for content
        page.goto(url)
        page.wait_for_selector(wait_for, timeout=10000)
        
        # Optional: scroll to load lazy content
        page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
        time.sleep(1)
        
        # Get rendered HTML
        html = page.content()
        browser.close()
    
    return html

# Usage
html = scrape_js_page("https://example.com/dynamic-page")
soup = BeautifulSoup(html, "html.parser")
```

### Using Playwright for Multi-Page Scraping

```python
def scrape_multiple_pages(base_url, max_pages=10):
    """Scrape multiple pages with Playwright."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        all_data = []
        for i in range(1, max_pages + 1):
            url = f"{base_url}?page={i}"
            page.goto(url)
            page.wait_for_selector(".item")
            
            # Extract data from the page
            items = page.query_selector_all(".item")
            for item in items:
                all_data.append({
                    "name": item.query_selector(".name").inner_text(),
                    "price": item.query_selector(".price").inner_text(),
                })
            
            # Check if there's a next page
            next_btn = page.query_selector(".pagination .next")
            if not next_btn:
                break
        
        browser.close()
    return all_data
```

---

## Part 5: API Reverse Engineering

### Finding Hidden APIs

Many websites load data via hidden APIs (XHR/fetch requests). Calling the API directly is 10-100x faster than scraping HTML.

```python
# Method 1: Intercept network requests in browser DevTools
# Open DevTools → Network tab → Filter by XHR/Fetch → Find the API call

# Method 2: Intercept with Playwright
def intercept_api(url):
    """Intercept API calls made by a page."""
    api_calls = []
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        
        # Listen for API responses
        def handle_response(response):
            if "/api/" in response.url:
                try:
                    data = response.json()
                    api_calls.append({"url": response.url, "data": data})
                except:
                    pass
        
        page.on("response", handle_response)
        page.goto(url)
        page.wait_for_timeout(5000)  # Wait for API calls
        browser.close()
    
    return api_calls

# Method 3: Direct API call (if you found the endpoint)
def call_api_directly():
    """Call the API directly instead of scraping HTML."""
    api_url = "https://example.com/api/products"
    params = {
        "page": 1,
        "limit": 50,
        "sort": "price",
        "order": "asc"
    }
    headers = {
        "Authorization": "Bearer <token>",  # If needed
        "X-Requested-With": "XMLHttpRequest",
    }
    
    response = requests.get(api_url, params=params, headers=headers)
    return response.json()
```

---

## Part 6: Anti-Bot Techniques

### Common Anti-Bot Measures

| Measure | Detection | Bypass |
|---------|-----------|--------|
| **User-Agent check** | Blocks non-browser UAs | Set realistic User-Agent header |
| **Rate limiting** | Too many requests | Add delays, rotate IPs |
| **CAPTCHA** | visual challenge | Use CAPTCHA solving services (last resort) |
| **IP blocking** | Repeated requests from same IP | Rotate proxies |
| **Honeypot links** | Hidden links that trap scrapers | Check CSS visibility before following |
| **JavaScript fingerprinting** | Browser fingerprint validation | Use real browser (Playwright) |
| **Cookie/Session** | Requires valid session | Use requests.Session() |

### Realistic Headers

```python
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate, br",
    "DNT": "1",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "none",
    "Sec-Fetch-User": "?1",
}
```

### Rate Limiting & Politeness

```python
import time
import random

class PoliteScraper:
    def __init__(self, min_delay=1.0, max_delay=3.0):
        self.min_delay = min_delay
        self.max_delay = max_delay
        self.last_request_time = 0
    
    def wait(self):
        """Wait a random amount of time between requests."""
        elapsed = time.time() - self.last_request_time
        delay = random.uniform(self.min_delay, self.max_delay)
        if elapsed < delay:
            time.sleep(delay - elapsed)
        self.last_request_time = time.time()
    
    def fetch(self, url, session=None):
        """Fetch a URL with politeness."""
        self.wait()
        s = session or requests.Session()
        return s.get(url, headers=HEADERS, timeout=10)
```

### robots.txt Compliance

```python
from urllib.robotparser import RobotFileParser

def can_scrape(url, user_agent="*"):
    """Check if scraping is allowed by robots.txt."""
    from urllib.parse import urlparse
    parsed = urlparse(url)
    robots_url = f"{parsed.scheme}://{parsed.netloc}/robots.txt"
    
    rp = RobotFileParser()
    rp.set_url(robots_url)
    rp.read()
    
    return rp.can_fetch(user_agent, url)
```

---

## Part 7: Proxy Rotation

### Using Proxies

```python
PROXIES = [
    "http://proxy1:8080",
    "http://proxy2:8080",
    "http://proxy3:8080",
]

def fetch_with_proxy(url, proxy_list):
    """Fetch a URL using a random proxy."""
    proxy = random.choice(proxy_list)
    proxies = {"http": proxy, "https": proxy}
    
    try:
        response = requests.get(url, headers=HEADERS, proxies=proxies, timeout=10)
        response.raise_for_status()
        return response
    except requests.RequestException:
        # Try without proxy as fallback
        return requests.get(url, headers=HEADERS, timeout=10)
```

### Rotating User-Agents

```python
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/119.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/118.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
]

def random_headers():
    return {"User-Agent": random.choice(USER_AGENTS)}
```

---

## Part 8: Real-World Scraping Patterns

### E-Commerce Product Scraper

```python
def scrape_products(base_url, max_pages=50):
    """Scrape products from an e-commerce site."""
    products = []
    
    for page in range(1, max_pages + 1):
        html = fetch(f"{base_url}/products?page={page}").text
        soup = BeautifulSoup(html, "html.parser")
        
        for card in soup.select(".product-card"):
            product = {
                "name": card.select_one(".product-title").get_text(strip=True),
                "price": float(card.select_one(".price").get_text(strip=True).replace("$", "").replace(",", "")),
                "rating": float(card.select_one("[data-rating]")["data-rating"]) if card.select_one("[data-rating]") else None,
                "reviews": int(card.select_one(".review-count").get_text(strip=True).replace(" reviews", "")) if card.select_one(".review-count") else 0,
                "url": card.select_one("a.product-link")["href"],
            }
            products.append(product)
    
    return pd.DataFrame(products)
```

### Job Listings Scraper

```python
def scrape_jobs(search_query, location, max_pages=10):
    """Scrape job listings from a job board."""
    jobs = []
    
    for page in range(1, max_pages + 1):
        url = f"https://jobs.example.com/search?q={search_query}&l={location}&page={page}"
        html = fetch(url).text
        soup = BeautifulSoup(html, "html.parser")
        
        for listing in soup.select(".job-listing"):
            jobs.append({
                "title": listing.select_one(".job-title").get_text(strip=True),
                "company": listing.select_one(".company-name").get_text(strip=True),
                "location": listing.select_one(".job-location").get_text(strip=True),
                "salary": listing.select_one(".salary-range").get_text(strip=True) if listing.select_one(".salary-range") else None,
                "posted": listing.select_one(".post-date").get_text(strip=True),
                "url": listing.select_one("a.job-link")["href"],
            })
    
    return pd.DataFrame(jobs)
```

### News Article Scraper

```python
def scrape_articles(section_url, max_articles=100):
    """Scrape news articles with metadata."""
    articles = []
    
    html = fetch(section_url).text
    soup = BeautifulSoup(html, "html.parser")
    
    for link in soup.select("article a[href]"):
        if len(articles) >= max_articles:
            break
        
        article_url = link["href"]
        if not article_url.startswith("http"):
            article_url = f"https://example.com{article_url}"
        
        try:
            article_html = fetch(article_url).text
            article_soup = BeautifulSoup(article_html, "html.parser")
            
            articles.append({
                "title": article_soup.select_one("h1").get_text(strip=True),
                "author": article_soup.select_one(".author-name").get_text(strip=True) if article_soup.select_one(".author-name") else None,
                "date": article_soup.select_one("time")["datetime"] if article_soup.select_one("time") else None,
                "content": article_soup.select_one("article").get_text(strip=True) if article_soup.select_one("article") else None,
                "url": article_url,
            })
        except Exception as e:
            print(f"Failed to scrape {article_url}: {e}")
    
    return pd.DataFrame(articles)
```

---

## Part 9: Data Storage

```python
# CSV (default)
df.to_csv("output.csv", index=False)

# JSON
df.to_json("output.json", orient="records", indent=2)

# Excel
df.to_excel("output.xlsx", index=False, sheet_name="Scraped Data")

# Parquet (for large datasets)
df.to_parquet("output.parquet", index=False)

# SQLite (for querying)
import sqlite3
conn = sqlite3.connect("scraped_data.db")
df.to_sql("products", conn, if_exists="replace", index=False)
```

---

## Part 10: Legal & Ethical Considerations

### Do's and Don'ts

| ✅ DO | ❌ DON'T |
|-------|---------|
| Check robots.txt before scraping | Scrape behind login without permission |
| Respect rate limits | Overwhelm servers with rapid requests |
| Scrape publicly available data | Scrape private/protected data |
| Cache results to minimize requests | Re-scrape the same pages repeatedly |
| Identify your bot (contact email) | Impersonate a real user |
| Follow Terms of Service | Scrape data that violates copyright |
| Use APIs when available | Reverse-engineer proprietary APIs for commercial use |

### Legal Considerations

- **Public data** is generally scrapable (varies by jurisdiction)
- **Copyrighted content** (articles, images) may have usage restrictions
- **Personal data** (emails, names) may be subject to GDPR/CCPA
- **Terms of Service** may prohibit scraping (enforceability varies)
- **hiQ v. LinkedIn (2022)**: Scraping publicly available data is generally legal in the US

---

## Output Format

```
## Scraping Report

**Target:** [URL]
**Approach:** [Static HTML / Playwright / API]
**Pages scraped:** [N]
**Records extracted:** [M]
**Output file:** [path]
**Duration:** [time]

### Sample Data
[First 5 rows as a table]

### Notes
- [Any issues encountered: blocked pages, missing fields]
- [Suggestions for next steps]
```

## Tools & Libraries

- **requests** — HTTP requests (static pages)
- **BeautifulSoup (bs4)** — HTML parsing
- **pandas** — data output and `read_html()` for tables
- **lxml** — fast HTML/XML parsing backend
- **Playwright** — headless browser for JavaScript-rendered pages
- **Scrapy** — large-scale crawling framework
- **urllib.parse** — URL manipulation
- **rapidfuzz** — fuzzy matching for near-duplicates

## Common Pitfalls to Avoid

- **Don't skip rate limiting.** Aggressive scraping gets you blocked and is unethical.
- **Don't assume the HTML won't change.** Write resilient selectors; add fallbacks.
- **Don't scrape behind login without explicit consent.** Ask first.
- **Don't ignore robots.txt.** Check it and warn the user if scraping is disallowed.
- **Don't use Playwright when requests works.** Browser automation is 10-100x slower.
- **Don't save without validation.** Check the output before declaring success.
- **Don't forget error handling.** One bad page shouldn't crash the entire scraper.
- **Don't scrape too fast.** 1-3 seconds between requests is the minimum.
