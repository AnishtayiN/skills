---
name: seo
description: >-
  Optimize websites for search engines with technical SEO, structured data, Core Web Vitals, and crawlability.
  TRIGGERS: SEO, search engine optimization, meta tags, structured data, sitemap, robots.txt, Core Web Vitals, technical SEO, on-page SEO,
  سئو, بهینه‌سازی موتور جستجو, متاتگ, نقشه سایت, سرعت صفحه, بهینه‌سازی سئو,
  SEO优化, 搜索引擎优化, 站点地图, 元标签, 网站速度, 结构化数据
priority: P1
dependencies: [performance-optimization]
conflicts: []
---

# SEO Skill — Technical SEO, Structured Data & Crawlability

## Overview

Search Engine Optimization (SEO) is the practice of increasing organic visibility in search engine results pages (SERPs) through technical infrastructure, content structure, and authority signals. This skill focuses on the technical and structural foundations: crawlability (robots.txt, sitemaps, canonical URLs), indexability (meta tags, rendering strategies, SSR/SSG), structured data (Schema.org markup for rich results), Core Web Vitals (LCP, CLS, INP), and server-side rendering implications. SEO is a long-term, compounding strategy — the technical foundation determines whether your content can be discovered at all.

## When to Use This Skill (6-9 bullets)

- **Auditing a website's technical SEO** — crawl errors, indexation issues, broken links, redirect chains, and sitemap validation
- **Implementing structured data / Schema.org** — JSON-LD markup for articles, products, FAQs, breadcrumbs, organization, and local business
- **Optimizing Core Web Vitals** — improving LCP, reducing CLS, minimizing INP, and passing Google's Page Experience signals
- **Setting up SSR or SSG** for JavaScript-heavy sites (Next.js, Nuxt, Astro) to ensure search engines can render content
- **Creating or fixing XML sitemaps** — dynamic sitemaps, sitemap index files, image sitemaps, and video sitemaps
- **Configuring robots.txt** — crawl budget optimization, bot management, and preventing indexation of private paths
- **Implementing canonical URLs, hreflang, and pagination** — preventing duplicate content and managing multilingual/multi-regional sites
- **Setting up Google Search Console and analytics** — property verification, sitemap submission, and performance monitoring
- **Migrating domains or restructuring URLs** — 301 redirect mapping, preserving link equity, and monitoring post-migration

## When NOT to Use This Skill (5-7 bullets)

- **Content writing and keyword research** — this skill covers technical infrastructure, not content strategy
- **Social media marketing** — social signals are not a direct ranking factor; different discipline
- **PPC / paid search advertising** — Google Ads and SEO are complementary but distinct
- **Email marketing** — email deliverability is a separate concern from search ranking
- **Building mobile apps** — app store optimization (ASO) is a different skill
- **Local business listing management** — Google Business Profile optimization is partially covered but is a separate specialty
- **Link building outreach** — this skill covers technical foundations, not outreach strategies

## Workflow

### Step 1: robots.txt Configuration

```txt
# robots.txt — Crawl budget optimization
# Place at: https://example.com/robots.txt

# Default: Allow all crawlers
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/
Disallow: /private/
Disallow: /cart/
Disallow: /checkout/
Disallow: /account/settings
Disallow: /search?*
Disallow: /*?sort=*
Disallow: /*?filter=*
Disallow: /*?page=*

# Googlebot specific rules
User-agent: Googlebot
Allow: /
Disallow: /admin/
Disallow: /api/
Crawl-delay: 0

# Bingbot specific rules
User-agent: Bingbot
Allow: /
Crawl-delay: 1

# AI/ML training crawlers (block if desired)
User-agent: GPTBot
Disallow: /

User-agent: ChatGPT-User
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Google-Extended
Disallow: /

# Sitemap location
Sitemap: https://example.com/sitemap.xml
Sitemap: https://example.com/sitemap-images.xml
Sitemap: https://example.com/sitemap-videos.xml
```

### Step 2: XML Sitemap Generation

```javascript
// scripts/generate-sitemap.js
const fs = require('fs');
const path = require('path');

const SITE_URL = 'https://example.com';
const OUTPUT_DIR = path.join(__dirname, '../public');

// Static pages
const staticPages = [
  { path: '/', changefreq: 'daily', priority: '1.0' },
  { path: '/about', changefreq: 'monthly', priority: '0.7' },
  { path: '/contact', changefreq: 'monthly', priority: '0.5' },
  { path: '/pricing', changefreq: 'weekly', priority: '0.8' },
  { path: '/blog', changefreq: 'daily', priority: '0.9' },
  { path: '/privacy', changefreq: 'yearly', priority: '0.3' },
  { path: '/terms', changefreq: 'yearly', priority: '0.3' },
];

// Dynamic pages from database
async function getDynamicPages() {
  // In production, query your CMS or database
  const posts = [
    { slug: 'getting-started', lastmod: '2025-01-15', changefreq: 'weekly', priority: '0.8' },
    { slug: 'advanced-guide', lastmod: '2025-01-10', changefreq: 'monthly', priority: '0.7' },
    // ... more pages
  ];

  return posts.map((post) => ({
    path: `/blog/${post.slug}`,
    lastmod: post.lastmod,
    changefreq: post.changefreq,
    priority: post.priority,
  }));
}

function generateSitemapXML(pages) {
  const urls = pages
    .map((page) => {
      const lastmod = page.lastmod || new Date().toISOString().split('T')[0];
      return `  <url>
    <loc>${SITE_URL}${page.path}</loc>
    <lastmod>${lastmod}</lastmod>
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`;
    })
    .join('\n');

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
${urls}
</urlset>`;
}

function generateSitemapIndex(sitemaps) {
  const entries = sitemaps
    .map(
      (s) => `  <sitemap>
    <loc>${SITE_URL}/${s.file}</loc>
    <lastmod>${s.lastmod}</lastmod>
  </sitemap>`
    )
    .join('\n');

  return `<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${entries}
</sitemapindex>`;
}

async function main() {
  const dynamicPages = await getDynamicPages();
  const allPages = [...staticPages, ...dynamicPages];

  // Main sitemap
  const sitemap = generateSitemapXML(allPages);
  fs.writeFileSync(path.join(OUTPUT_DIR, 'sitemap.xml'), sitemap);

  // Sitemap index for large sites
  const sitemapIndex = generateSitemapIndex([
    { file: 'sitemap.xml', lastmod: new Date().toISOString().split('T')[0] },
    { file: 'sitemap-images.xml', lastmod: new Date().toISOString().split('T')[0] },
  ]);
  fs.writeFileSync(path.join(OUTPUT_DIR, 'sitemap-index.xml'), sitemapIndex);

  console.log(`✅ Generated sitemap with ${allPages.length} URLs`);
}

main().catch(console.error);
```

### Step 3: Canonical URLs and Duplicate Content Prevention

```html
<!-- Basic canonical -->
<link rel="canonical" href="https://example.com/page" />

<!-- Paginated content -->
<link rel="canonical" href="https://example.com/blog" />

<!-- Self-referencing canonical (recommended) -->
<link rel="canonical" href="https://example.com/blog/page-1" />

<!-- HTTPS canonical (never HTTP) -->
<link rel="canonical" href="https://example.com/page" />

<!-- Hreflang for multilingual sites -->
<link rel="alternate" hreflang="en" href="https://example.com/page" />
<link rel="alternate" hreflang="es" href="https://example.com/es/page" />
<link rel="alternate" hreflang="fr" href="https://example.com/fr/page" />
<link rel="alternate" hreflang="x-default" href="https://example.com/page" />
```

```nginx
# Nginx redirect rules for canonical domain
# Redirect non-www to www
server {
    listen 80;
    listen 443 ssl;
    server_name example.com;
    return 301 https://www.example.com$request_uri;
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name www.example.com;
    return 301 https://www.example.com$request_uri;
}

# Remove trailing slashes (unless it's the root)
location ~ ^(.+)/$ {
    return 301 $1;
}

# Redirect .html extensions
location ~ ^(.+)\.html$ {
    return 301 $1;
}
```

### Step 4: Core Web Vitals Optimization

```html
<!-- LCP Optimization: Preload critical resources -->
<link rel="preload" as="image" href="/hero-image.webp" type="image/webp" fetchpriority="high">
<link rel="preload" as="font" href="/fonts/inter-var.woff2" type="font/woff2" crossorigin>
<link rel="preload" as="style" href="/critical.css">

<!-- LCP: Inline critical CSS -->
<style>
  /* Critical above-the-fold CSS inlined */
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: Inter, -apple-system, sans-serif; line-height: 1.6; color: #1a1a1a; }
  .hero { min-height: 60vh; display: flex; align-items: center; }
  .hero h1 { font-size: clamp(2rem, 5vw, 3.5rem); font-weight: 800; }
  .hero img { width: 100%; height: auto; display: block; }
</style>

<!-- CLS Prevention: Explicit dimensions on all media -->
<img
  src="/hero-image.webp"
  alt="Product hero image"
  width="1200"
  height="675"
  fetchpriority="high"
  decoding="async"
>

<!-- CLS: Reserve space for dynamic content (ads, embeds) -->
<div style="min-height: 250px; background: #f0f0f0;">
  <!-- Ad slot — height reserved to prevent layout shift -->
  <div id="ad-slot" aria-label="Advertisement"></div>
</div>

<!-- CLS: Font loading without layout shift -->
<style>
  @font-face {
    font-family: 'Inter';
    src: url('/fonts/inter-var.woff2') format('woff2');
    font-display: swap; /* Shows fallback immediately, swaps when loaded */
    unicode-range: U+0000-00FF; /* Only load Latin subset for English */
  }
</style>

<!-- INP / Interaction Optimization: Defer non-critical JS -->
<script src="/analytics.js" defer></script>
<script src="/chat-widget.js" async></script>
<!-- Critical interaction JS loaded normally -->
<script src="/app.js"></script>
```

```javascript
// Performance monitoring — track Core Web Vitals
// scripts/cwv-monitor.js
(function () {
  // LCP (Largest Contentful Paint)
  new PerformanceObserver((entryList) => {
    const entries = entryList.getEntries();
    const lastEntry = entries[entries.length - 1];
    console.log('[CWV] LCP:', lastEntry.startTime);
    // Send to analytics
    if (window.gtag) {
      gtag('event', 'web_vitals', {
        event_category: 'Web Vitals',
        event_label: 'LCP',
        value: Math.round(lastEntry.startTime),
        non_interaction: true,
      });
    }
  }).observe({ type: 'largest-contentful-paint', buffered: true });

  // CLS (Cumulative Layout Shift)
  let clsValue = 0;
  let clsEntries = [];
  new PerformanceObserver((entryList) => {
    for (const entry of entryList.getEntries()) {
      if (!entry.hadRecentInput) {
        clsValue += entry.value;
        clsEntries.push(entry);
      }
    }
    console.log('[CWV] CLS:', clsValue);
  }).observe({ type: 'layout-shift', buffered: true });

  // INP (Interaction to Next Paint) — using Event Timing API
  new PerformanceObserver((entryList) => {
    const entries = entryList.getEntries();
    let maxINP = 0;
    for (const entry of entries) {
      const duration = entry.processingEnd - entry.startTime;
      if (duration > maxINP) {
        maxINP = duration;
      }
    }
    console.log('[CWV] INP:', maxINP);
  }).observe({ type: 'event', buffered: true, durationThreshold: 40 });
})();
```

## Advanced Techniques

### 1. Structured Data — JSON-LD Schema.org Implementation

```html
<!-- Organization Schema — appears in Knowledge Panel -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Example Company",
  "url": "https://example.com",
  "logo": "https://example.com/images/logo.png",
  "image": "https://example.com/images/og-image.jpg",
  "description": "Leading provider of innovative solutions.",
  "foundingDate": "2020-01-15",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Innovation Drive",
    "addressLocality": "San Francisco",
    "addressRegion": "CA",
    "postalCode": "94105",
    "addressCountry": "US"
  },
  "contactPoint": [
    {
      "@type": "ContactPoint",
      "telephone": "+1-415-555-0123",
      "contactType": "customer service",
      "availableLanguage": ["English", "Spanish"],
      "areaServed": "US"
    }
  ],
  "sameAs": [
    "https://twitter.com/example",
    "https://linkedin.com/company/example",
    "https://github.com/example"
  ]
}
</script>

<!-- Article Schema — for blog posts and news articles -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://example.com/blog/getting-started"
  },
  "headline": "Getting Started with Our Platform: A Complete Guide",
  "description": "Learn how to set up your account, configure your workspace, and start building in minutes.",
  "image": {
    "@type": "ImageObject",
    "url": "https://example.com/images/blog/getting-started.jpg",
    "width": 1200,
    "height": 675
  },
  "author": {
    "@type": "Person",
    "name": "Jane Smith",
    "url": "https://example.com/authors/jane-smith",
    "image": {
      "@type": "ImageObject",
      "url": "https://example.com/images/authors/jane.jpg"
    }
  },
  "publisher": {
    "@type": "Organization",
    "name": "Example Company",
    "logo": {
      "@type": "ImageObject",
      "url": "https://example.com/images/logo.png"
    }
  },
  "datePublished": "2025-01-15T09:00:00-08:00",
  "dateModified": "2025-01-20T14:30:00-08:00",
  "articleSection": "Tutorials",
  "keywords": ["getting started", "tutorial", "setup guide"]
}
</script>

<!-- FAQ Schema — triggers FAQ rich results in SERPs -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How do I reset my password?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "To reset your password, click the 'Forgot Password' link on the login page. Enter your email address, and we'll send you a reset link within 2 minutes. The link expires after 24 hours for security."
      }
    },
    {
      "@type": "Question",
      "name": "What payment methods do you accept?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "We accept all major credit cards (Visa, Mastercard, American Express), PayPal, and bank transfers for annual plans. All payments are processed securely through Stripe."
      }
    },
    {
      "@type": "Question",
      "name": "Can I cancel my subscription at any time?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, you can cancel your subscription at any time from your Account Settings. Your access continues until the end of your current billing period. No cancellation fees apply."
      }
    }
  ]
}
</script>

<!-- Product Schema — for e-commerce product pages -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Wireless Noise-Cancelling Headphones",
  "image": [
    "https://example.com/images/products/headphones-front.jpg",
    "https://example.com/images/products/headphones-side.jpg",
    "https://example.com/images/products/headphones-box.jpg"
  ],
  "description": "Premium wireless headphones with active noise cancellation, 30-hour battery life, and Hi-Res Audio support.",
  "brand": {
    "@type": "Brand",
    "name": "Example Audio"
  },
  "sku": "EXH-1000-BLK",
  "gtin13": "0123456789012",
  "color": "Black",
  "offers": {
    "@type": "Offer",
    "url": "https://example.com/products/headphones",
    "priceCurrency": "USD",
    "price": "299.99",
    "priceValidUntil": "2025-12-31",
    "itemCondition": "https://schema.org/NewCondition",
    "availability": "https://schema.org/InStock",
    "seller": {
      "@type": "Organization",
      "name": "Example Store"
    },
    "shippingDetails": {
      "@type": "OfferShippingDetails",
      "shippingRate": {
        "@type": "MonetaryAmount",
        "value": "0",
        "currency": "USD"
      },
      "shippingDestination": {
        "@type": "DefinedRegion",
        "addressCountry": "US"
      },
      "deliveryTime": {
        "@type": "ShippingDeliveryTime",
        "handlingTime": {
          "@type": "QuantitativeValue",
          "minValue": 1,
          "maxValue": 2,
          "unitCode": "DAY"
        },
        "transitTime": {
          "@type": "QuantitativeValue",
          "minValue": 3,
          "maxValue": 5,
          "unitCode": "DAY"
        }
      }
    }
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "bestRating": "5",
    "reviewCount": "2,341"
  },
  "review": [
    {
      "@type": "Review",
      "reviewRating": {
        "@type": "Rating",
        "ratingValue": "5",
        "bestRating": "5"
      },
      "author": {
        "@type": "Person",
        "name": "Alex Johnson"
      },
      "reviewBody": "Best headphones I've ever owned. The noise cancellation is incredible and the battery lasts forever."
    }
  ]
}
</script>

<!-- BreadcrumbList Schema — shows breadcrumb trail in SERPs -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://example.com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Blog",
      "item": "https://example.com/blog"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Getting Started",
      "item": "https://example.com/blog/getting-started"
    }
  ]
}
</script>

<!-- LocalBusiness Schema — for local businesses -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Example Coffee Co.",
  "image": "https://example.com/images/storefront.jpg",
  "url": "https://example.com",
  "telephone": "+1-415-555-0123",
  "priceRange": "$$",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "456 Market Street",
    "addressLocality": "San Francisco",
    "addressRegion": "CA",
    "postalCode": "94105",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 37.7749,
    "longitude": -122.4194
  },
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "06:00",
      "closes": "20:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Saturday", "Sunday"],
      "opens": "07:00",
      "closes": "18:00"
    }
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "567"
  }
}
</script>
```

### 2. Next.js / SSR / SSG SEO Implementation

```tsx
// pages/blog/[slug].tsx (Next.js Pages Router)
import { GetServerSideProps, GetStaticPaths, GetStaticProps } from 'next';
import Head from 'next/head';
import { Article } from '../../types';

// SSG (Static Site Generation) — best for SEO
export const getStaticPaths: GetStaticPaths = async () => {
  const posts = await fetchAllPosts();
  const paths = posts.map((post) => ({
    params: { slug: post.slug },
  }));

  return {
    paths,
    blocking: true, // ISR: generate on first request, then cache
  };
};

export const getStaticProps: GetStaticProps = async ({ params }) => {
  const post = await fetchPost(params?.slug as string);
  const siteUrl = process.env.SITE_URL || 'https://example.com';

  return {
    props: {
      post,
      siteUrl,
    },
    revalidate: 3600, // ISR: revalidate every hour
  };
};

// SSR (Server-Side Rendering) — for dynamic, personalized content
export const getServerSideProps: GetServerSideProps = async ({ req, res }) => {
  // Cache for 60 seconds on server
  res.setHeader('Cache-Control', 's-maxage=60, stale-while-revalidate');

  const post = await fetchPost(req.url?.split('/blog/')[1] || '');
  const siteUrl = process.env.SITE_URL || 'https://example.com';

  return {
    props: {
      post,
      siteUrl,
    },
  };
};

interface BlogPostProps {
  post: Article;
  siteUrl: string;
}

export default function BlogPost({ post, siteUrl }: BlogPostProps) {
  const canonicalUrl = `${siteUrl}/blog/${post.slug}`;

  const structuredData = {
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: post.title,
    description: post.excerpt,
    image: post.coverImage,
    datePublished: post.publishedAt,
    dateModified: post.updatedAt,
    author: {
      '@type': 'Person',
      name: post.author.name,
      url: `${siteUrl}/authors/${post.author.slug}`,
    },
    publisher: {
      '@type': 'Organization',
      name: 'Example Company',
      logo: {
        '@type': 'ImageObject',
        url: `${siteUrl}/images/logo.png`,
      },
    },
    mainEntityOfPage: {
      '@type': 'WebPage',
      '@id': canonicalUrl,
    },
  };

  const breadcrumbData = {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: [
      { '@type': 'ListItem', position: 1, name: 'Home', item: siteUrl },
      { '@type': 'ListItem', position: 2, name: 'Blog', item: `${siteUrl}/blog` },
      { '@type': 'ListItem', position: 3, name: post.title, item: canonicalUrl },
    ],
  };

  return (
    <>
      <Head>
        <title>{post.title} | Example Blog</title>
        <meta name="description" content={post.excerpt} />
        <link rel="canonical" href={canonicalUrl} />

        {/* Open Graph */}
        <meta property="og:type" content="article" />
        <meta property="og:title" content={post.title} />
        <meta property="og:description" content={post.excerpt} />
        <meta property="og:image" content={post.coverImage} />
        <meta property="og:url" content={canonicalUrl} />
        <meta property="article:published_time" content={post.publishedAt} />
        <meta property="article:modified_time" content={post.updatedAt} />
        <meta property="article:author" content={post.author.name} />

        {/* Twitter Card */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={post.title} />
        <meta name="twitter:description" content={post.excerpt} />
        <meta name="twitter:image" content={post.coverImage} />

        {/* Structured Data */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbData) }}
        />
      </Head>

      <article>
        <h1>{post.title}</h1>
        <time dateTime={post.publishedAt}>
          {new Date(post.publishedAt).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
          })}
        </time>
        <div dangerouslySetInnerHTML={{ __html: post.content }} />
      </article>
    </>
  );
}
```

### 3. Technical SEO Audit Script

```javascript
// scripts/seo-audit.js
const fs = require('fs');
const { JSDOM } = require('jsdom');

function auditSEO(html, url) {
  const dom = new JSDOM(html);
  const doc = dom.window.document;
  const results = {
    passed: [],
    warnings: [],
    errors: [],
    score: 0,
    maxScore: 0,
  };

  function check(name, testFn, weight = 1) {
    results.maxScore += weight;
    try {
      const result = testFn(doc);
      if (result === true) {
        results.passed.push(name);
        results.score += weight;
      } else if (result === 'warning') {
        results.warnings.push(name);
        results.score += weight * 0.5;
      } else {
        results.errors.push(name);
      }
    } catch (e) {
      results.errors.push(`${name} (check failed: ${e.message})`);
    }
  }

  // === Meta Tags ===
  check('Title tag exists', (doc) => !!doc.querySelector('title')?.textContent?.trim(), 2);
  check('Title length 30-60 chars', (doc) => {
    const len = doc.querySelector('title')?.textContent?.trim().length || 0;
    if (len >= 30 && len <= 60) return true;
    if (len > 0) return 'warning';
    return false;
  }, 1);
  check('Meta description exists', (doc) => !!doc.querySelector('meta[name="description"]')?.getAttribute('content'), 2);
  check('Meta description 120-160 chars', (doc) => {
    const len = doc.querySelector('meta[name="description"]')?.getAttribute('content')?.length || 0;
    if (len >= 120 && len <= 160) return true;
    if (len > 0) return 'warning';
    return false;
  }, 1);
  check('Canonical URL set', (doc) => !!doc.querySelector('link[rel="canonical"]')?.getAttribute('href'), 2);
  check('Viewport meta tag', (doc) => !!doc.querySelector('meta[name="viewport"]'), 1);
  check('Charset declared', (doc) => !!doc.querySelector('meta[charset]') || !!doc.querySelector('meta[http-equiv="Content-Type"]'), 1);
  check('Language attribute on html', (doc) => !!doc.querySelector('html')?.getAttribute('lang'), 1);

  // === Headings ===
  check('Single H1 tag', (doc) => doc.querySelectorAll('h1').length === 1, 2);
  check('Heading hierarchy (no skipped levels)', (doc) => {
    const headings = Array.from(doc.querySelectorAll('h1, h2, h3, h4, h5, h6'));
    let prevLevel = 0;
    for (const h of headings) {
      const level = parseInt(h.tagName[1]);
      if (level > prevLevel + 1 && prevLevel > 0) return false;
      prevLevel = level;
    }
    return true;
  }, 1);

  // === Images ===
  check('All images have alt text', (doc) => {
    const imgs = doc.querySelectorAll('img');
    const missing = Array.from(imgs).filter((img) => !img.getAttribute('alt'));
    return missing.length === 0;
  }, 2);
  check('Images have explicit dimensions', (doc) => {
    const imgs = doc.querySelectorAll('img');
    const missing = Array.from(imgs).filter(
      (img) => !img.getAttribute('width') || !img.getAttribute('height')
    );
    if (missing.length === 0) return true;
    return 'warning';
  }, 1);

  // === Links ===
  check('No broken internal links (basic)', (doc) => {
    const links = doc.querySelectorAll('a[href]');
    const empty = Array.from(links).filter(
      (a) => !a.getAttribute('href') || a.getAttribute('href') === '#'
    );
    return empty.length === 0;
  }, 1);
  check('External links have rel="noopener"', (doc) => {
    const links = doc.querySelectorAll('a[target="_blank"]');
    const missing = Array.from(links).filter(
      (a) => !a.getAttribute('rel')?.includes('noopener')
    );
    return missing.length === 0;
  }, 1);

  // === Structured Data ===
  check('JSON-LD structured data present', (doc) => {
    const scripts = doc.querySelectorAll('script[type="application/ld+json"]');
    return scripts.length > 0;
  }, 2);
  check('Structured data has @context and @type', (doc) => {
    const script = doc.querySelector('script[type="application/ld+json"]');
    if (!script) return false;
    try {
      const data = JSON.parse(script.textContent || '{}');
      return !!(data['@context'] && data['@type']);
    } catch {
      return false;
    }
  }, 1);

  // === Performance Hints ===
  check('Preload critical resources', (doc) => doc.querySelectorAll('link[rel="preload"]').length > 0, 1);
  check('Images use lazy loading', (doc) => {
    const imgs = doc.querySelectorAll('img:not([fetchpriority="high"])');
    const lazy = Array.from(imgs).filter(
      (img) => img.getAttribute('loading') === 'lazy'
    );
    return lazy.length > 0 || imgs.length === 0;
  }, 1);
  check('No render-blocking resources', (doc) => {
    const blocking = doc.querySelectorAll('link[rel="stylesheet"]:not([media="print"])');
    return blocking.length <= 2; // Allow 1-2 critical stylesheets
  }, 1);

  // === Social / Open Graph ===
  check('Open Graph title', (doc) => !!doc.querySelector('meta[property="og:title"]'), 1);
  check('Open Graph image', (doc) => !!doc.querySelector('meta[property="og:image"]'), 1);
  check('Twitter Card', (doc) => !!doc.querySelector('meta[name="twitter:card"]'), 1);

  // === Security ===
  check('HTTPS (no mixed content)', (doc) => {
    const httpResources = doc.querySelectorAll('[src^="http://"], [href^="http://"]');
    return httpResources.length === 0;
  }, 1);

  // Calculate final score
  const percentage = Math.round((results.score / results.maxScore) * 100);
  results.percentage = percentage;
  results.grade =
    percentage >= 90 ? 'A' :
    percentage >= 75 ? 'B' :
    percentage >= 60 ? 'C' :
    percentage >= 40 ? 'D' : 'F';

  return results;
}

// Run audit
if (require.main === module) {
  const htmlFile = process.argv[2] || 'dist/index.html';
  const html = fs.readFileSync(htmlFile, 'utf-8');
  const results = auditSEO(html, 'https://example.com');

  console.log(`\n🔍 SEO Audit Report`);
  console.log(`${'='.repeat(50)}`);
  console.log(`Grade: ${results.grade} (${results.percentage}%)\n`);

  if (results.passed.length > 0) {
    console.log(`✅ Passed (${results.passed.length}):`);
    results.passed.forEach((p) => console.log(`   ✓ ${p}`));
    console.log('');
  }

  if (results.warnings.length > 0) {
    console.log(`⚠️  Warnings (${results.warnings.length}):`);
    results.warnings.forEach((w) => console.log(`   ⚠ ${w}`));
    console.log('');
  }

  if (results.errors.length > 0) {
    console.log(`❌ Errors (${results.errors.length}):`);
    results.errors.forEach((e) => console.log(`   ✗ ${e}`));
    console.log('');
  }
}

module.exports = { auditSEO };
```

### 4. Sitemap Validation Script

```javascript
// scripts/validate-sitemap.js
const fs = require('fs');
const { parseString } = require('xml2js');

function validateSitemap(sitemapPath) {
  const xml = fs.readFileSync(sitemapPath, 'utf-8');
  const issues = [];

  return new Promise((resolve) => {
    parseString(xml, { explicitArray: false }, (err, result) => {
      if (err) {
        issues.push({ severity: 'error', message: `Invalid XML: ${err.message}` });
        resolve({ valid: false, issues, urlCount: 0 });
        return;
      }

      // Check for sitemap index
      if (result.sitemapindex) {
        console.log('📋 Sitemap Index detected');
        const sitemaps = result.sitemapindex.sitemap;
        if (sitemaps) {
          const sitemapList = Array.isArray(sitemaps) ? sitemaps : [sitemaps];
          console.log(`   Found ${sitemapList.length} sub-sitemaps`);
          sitemapList.forEach((s) => {
            console.log(`   • ${s.loc}`);
          });
        }
        resolve({ valid: true, issues, urlCount: 0 });
        return;
      }

      // Validate URL set
      if (!result.urlset) {
        issues.push({ severity: 'error', message: 'Missing <urlset> root element' });
        resolve({ valid: false, issues, urlCount: 0 });
        return;
      }

      const urls = result.urlset.url;
      if (!urls) {
        issues.push({ severity: 'error', message: 'No <url> entries found' });
        resolve({ valid: false, issues, urlCount: 0 });
        return;
      }

      const urlList = Array.isArray(urls) ? urls : [urls];
      console.log(`\n📊 Sitemap Validation: ${urlList.length} URLs\n`);

      // Validate each URL
      urlList.forEach((url, i) => {
        // Required: <loc>
        if (!url.loc) {
          issues.push({ severity: 'error', message: `URL #${i + 1}: Missing <loc>` });
        } else {
          // URL format
          if (!url.loc.startsWith('https://')) {
            issues.push({ severity: 'error', message: `${url.loc}: Must use HTTPS` });
          }
          if (url.loc.includes(' ')) {
            issues.push({ severity: 'error', message: `${url.loc}: URL contains spaces` });
          }
          if (url.loc.length > 2048) {
            issues.push({ severity: 'warning', message: `${url.loc}: URL exceeds 2048 characters` });
          }
        }

        // Optional: <lastmod>
        if (url.lastmod) {
          const dateRegex = /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2})?$/;
          if (!dateRegex.test(url.lastmod)) {
            issues.push({ severity: 'warning', message: `${url.loc}: Invalid lastmod date format` });
          }
        }

        // Optional: <changefreq>
        const validFreqs = ['always', 'hourly', 'daily', 'weekly', 'monthly', 'yearly', 'never'];
        if (url.changefreq && !validFreqs.includes(url.changefreq)) {
          issues.push({ severity: 'error', message: `${url.loc}: Invalid changefreq "${url.changefreq}"` });
        }

        // Optional: <priority>
        if (url.priority) {
          const p = parseFloat(url.priority);
          if (isNaN(p) || p < 0 || p > 1) {
            issues.push({ severity: 'error', message: `${url.loc}: Priority must be 0.0-1.0` });
          }
        }
      });

      // Sitemap size check
      const xmlSizeKB = Buffer.byteLength(xml, 'utf-8') / 1024;
      if (xmlSizeKB > 50 * 1024) {
        issues.push({
          severity: 'warning',
          message: `Sitemap exceeds 50MB (uncompressed). Consider splitting into multiple sitemaps.`,
        });
      }
      if (urlList.length > 50000) {
        issues.push({
          severity: 'warning',
          message: `Sitemap contains >50,000 URLs. Consider using a sitemap index.`,
        });
      }

      // Summary
      const errors = issues.filter((i) => i.severity === 'error');
      const warnings = issues.filter((i) => i.severity === 'warning');

      console.log(`✅ Valid URLs: ${urlList.length - errors.length}`);
      console.log(`⚠️  Warnings: ${warnings.length}`);
      console.log(`❌ Errors: ${errors.length}`);

      if (errors.length > 0) {
        console.log('\nErrors:');
        errors.forEach((e) => console.log(`  ✗ ${e.message}`));
      }
      if (warnings.length > 0) {
        console.log('\nWarnings:');
        warnings.forEach((w) => console.log(`  ⚠ ${w.message}`));
      }

      resolve({
        valid: errors.length === 0,
        issues,
        urlCount: urlList.length,
      });
    });
  });
}

module.exports = { validateSitemap };
```

### 5. Structured Data Validator

```javascript
// scripts/validate-schema.js
const fs = require('fs');

const REQUIRED_FIELDS = {
  Article: ['headline', 'author', 'datePublished', 'image'],
  Product: ['name', 'image', 'offers'],
  FAQPage: ['mainEntity'],
  Organization: ['name', 'url'],
  LocalBusiness: ['name', 'address', 'telephone'],
  BreadcrumbList: ['itemListElement'],
  Event: ['name', 'startDate', 'location'],
  HowTo: ['name', 'step'],
};

const RECOMMENDED_FIELDS = {
  Article: ['dateModified', 'publisher', 'description'],
  Product: ['description', 'brand', 'sku', 'aggregateRating'],
  Organization: ['logo', 'sameAs', 'contactPoint'],
  LocalBusiness: ['geo', 'openingHoursSpecification', 'aggregateRating'],
  BreadcrumbList: [],
  Event: ['description', 'image', 'offers'],
  HowTo: ['description', 'image', 'totalTime'],
};

function validateSchema(htmlPath) {
  const html = fs.readFileSync(htmlPath, 'utf-8');
  const scriptRegex = /<script\s+type="application\/ld\+json"\s*>([\s\S]*?)<\/script>/gi;
  const schemas = [];
  let match;

  while ((match = scriptRegex.exec(html)) !== null) {
    try {
      const data = JSON.parse(match[1]);
      schemas.push(data);
    } catch (e) {
      schemas.push({ error: `Invalid JSON: ${e.message}` });
    }
  }

  console.log(`\n📋 Schema Validation Report`);
  console.log(`${'='.repeat(50)}\n`);

  let totalErrors = 0;
  let totalWarnings = 0;

  schemas.forEach((schema, index) => {
    if (schema.error) {
      console.log(`❌ Schema #${index + 1}: ${schema.error}`);
      totalErrors++;
      return;
    }

    const type = schema['@type'];
    console.log(`Schema #${index + 1}: ${type || 'Unknown'}`);

    // Check @context
    if (schema['@context'] !== 'https://schema.org') {
      console.log(`  ❌ Missing or incorrect @context (should be "https://schema.org")`);
      totalErrors++;
    }

    // Check required fields
    const required = REQUIRED_FIELDS[type] || [];
    required.forEach((field) => {
      if (!schema[field]) {
        console.log(`  ❌ Missing required field: ${field}`);
        totalErrors++;
      }
    });

    // Check recommended fields
    const recommended = RECOMMENDED_FIELDS[type] || [];
    recommended.forEach((field) => {
      if (!schema[field]) {
        console.log(`  ⚠️  Missing recommended field: ${field}`);
        totalWarnings++;
      }
    });

    // Type-specific validations
    if (type === 'Article' && schema.datePublished) {
      const date = new Date(schema.datePublished);
      if (isNaN(date.getTime())) {
        console.log(`  ❌ Invalid datePublished format: ${schema.datePublished}`);
        totalErrors++;
      }
    }

    if (type === 'Product' && schema.offers) {
      const offers = Array.isArray(schema.offers) ? schema.offers : [schema.offers];
      offers.forEach((offer, i) => {
        if (!offer.price) console.log(`  ⚠️  Offer #${i + 1}: Missing price`);
        if (!offer.priceCurrency) console.log(`  ⚠️  Offer #${i + 1}: Missing priceCurrency`);
        if (!offer.availability) console.log(`  ⚠️  Offer #${i + 1}: Missing availability`);
      });
    }

    console.log('');
  });

  console.log(`${'─'.repeat(50)}`);
  console.log(`Total schemas: ${schemas.length}`);
  console.log(`Errors: ${totalErrors}`);
  console.log(`Warnings: ${totalWarnings}`);
  console.log(totalErrors === 0 ? '✅ All schemas pass validation' : '❌ Fix errors before publishing');

  return { schemas, totalErrors, totalWarnings };
}

module.exports = { validateSchema };
```

### 6. Redirect Chain Detection

```javascript
// scripts/find-redirect-chains.js
const https = require('https');
const http = require('http');

async function followRedirects(url, maxRedirects = 10) {
  const chain = [url];
  let currentUrl = url;

  for (let i = 0; i < maxRedirects; i++) {
    try {
      const response = await new Promise((resolve, reject) => {
        const protocol = currentUrl.startsWith('https') ? https : http;
        const req = protocol.request(currentUrl, { method: 'HEAD' }, resolve);
        req.on('error', reject);
        req.setTimeout(10000, () => { req.destroy(); reject(new Error('Timeout')); });
        req.end();
      });

      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        const nextUrl = new URL(response.headers.location, currentUrl).href;
        if (nextUrl === currentUrl) break; // Prevent infinite loops
        chain.push(nextUrl);
        currentUrl = nextUrl;
      } else {
        break; // Reached final destination
      }
    } catch (error) {
      console.error(`Error following redirect from ${currentUrl}: ${error.message}`);
      break;
    }
  }

  return {
    start: url,
    end: currentUrl,
    chain,
    hops: chain.length - 1,
    hasChain: chain.length > 1,
  };
}

async function analyzeRedirects(urls) {
  console.log('\n🔗 Redirect Chain Analysis\n');
  console.log(`${'='.repeat(60)}\n`);

  const results = [];
  const chains = [];

  for (const url of urls) {
    const result = await followRedirects(url);
    results.push(result);

    if (result.hasChain) {
      chains.push(result);
      console.log(`⚠️  Redirect chain (${result.hops} hops):`);
      result.chain.forEach((u, i) => {
        const arrow = i < result.chain.length - 1 ? ' →' : ' ✓';
        console.log(`   ${i === 0 ? '  ' : '   '}${u}${arrow}`);
      });
      console.log('');
    } else {
      console.log(`✅ ${url} → ${result.end} (direct)`);
    }
  }

  console.log(`${'─'.repeat(60)}`);
  console.log(`Total URLs: ${urls.length}`);
  console.log(`Direct (no chain): ${urls.length - chains.length}`);
  console.log(`With chains: ${chains.length}`);

  if (chains.length > 0) {
    const maxHops = Math.max(...chains.map((c) => c.hops));
    console.log(`Max hops: ${maxHops}`);
    if (maxHops >= 3) {
      console.log('⚠️  Chains with 3+ hops should be shortened to reduce latency and crawl budget waste');
    }
  }

  return { results, chains };
}

module.exports = { followRedirects, analyzeRedirects };
```

### 7. Internal Link Analysis

```javascript
// scripts/analyze-internal-links.js
const fs = require('fs');
const { JSDOM } = require('jsdom');

function analyzeInternalLinks(html, currentUrl) {
  const dom = new JSDOM(html);
  const doc = dom.window.document;
  const domain = new URL(currentUrl).hostname;

  const links = Array.from(doc.querySelectorAll('a[href]'));
  const internal = [];
  const external = [];
  const broken = [];

  links.forEach((a) => {
    const href = a.getAttribute('href');
    const text = a.textContent?.trim() || '';

    // Skip anchors, javascript:, mailto:
    if (!href || href.startsWith('#') || href.startsWith('javascript:') || href.startsWith('mailto:')) {
      return;
    }

    try {
      const url = new URL(href, currentUrl);
      const isInternal = url.hostname === domain || url.hostname === `www.${domain}`;

      const linkData = {
        href: url.href,
        text: text.substring(0, 100),
        isNofollow: a.getAttribute('rel')?.includes('nofollow') || false,
        hasTargetBlank: a.getAttribute('target') === '_blank',
      };

      if (isInternal) {
        internal.push(linkData);
      } else {
        external.push(linkData);
      }
    } catch {
      broken.push({ href, text: text.substring(0, 50) });
    }
  });

  // Analysis
  const anchorTexts = internal.map((l) => l.text.toLowerCase());
  const emptyAnchors = internal.filter((l) => !l.text);
  const nofollowInternal = internal.filter((l) => l.isNofollow);

  console.log(`\n🔗 Internal Link Analysis for ${currentUrl}`);
  console.log(`${'='.repeat(50)}\n`);
  console.log(`Total links: ${links.length}`);
  console.log(`Internal: ${internal.length}`);
  console.log(`External: ${external.length}`);
  console.log(`Broken: ${broken.length}`);
  console.log(`Empty anchor text: ${emptyAnchors.length}`);
  console.log(`Nofollow internal: ${nofollowInternal.length}`);

  if (emptyAnchors.length > 0) {
    console.log('\n⚠️  Links with empty anchor text (bad for SEO):');
    emptyAnchors.slice(0, 5).forEach((l) => console.log(`   ${l.href}`));
  }

  if (broken.length > 0) {
    console.log('\n❌ Broken or malformed links:');
    broken.slice(0, 5).forEach((l) => console.log(`   ${l.href} ("${l.text}")`));
  }

  return { internal, external, broken, emptyAnchors, nofollowInternal };
}

module.exports = { analyzeInternalLinks };
```

## Common Patterns

### Pattern 1: Complete SEO Meta Tags Block

```html
<!-- Complete meta tag template — copy and customize per page -->
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Primary SEO -->
  <title>{Page Title} | {Brand Name}</title>
  <meta name="description" content="{Compelling 155-char description with target keyword}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="{canonical URL}">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="{website|article|product}">
  <meta property="og:url" content="{page URL}">
  <meta property="og:title" content="{title — same or similar to <title>}">
  <meta property="og:description" content="{description — same or similar to meta description}">
  <meta property="og:image" content="{1200x630 image URL}">
  <meta property="og:image:alt" content="{descriptive alt text for image}">
  <meta property="og:site_name" content="{brand name}">
  <meta property="og:locale" content="{en_US}">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{title}">
  <meta name="twitter:description" content="{description}">
  <meta name="twitter:image" content="{image URL}">
  <meta name="twitter:image:alt" content="{alt text}">

  <!-- Hreflang (multilingual) -->
  <link rel="alternate" hreflang="en" href="{english URL}">
  <link rel="alternate" hreflang="es" href="{spanish URL}">
  <link rel="alternate" hreflang="x-default" href="{default URL}">

  <!-- Preconnect to critical origins -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://cdn.example.com">

  <!-- Preload critical resources -->
  <link rel="preload" href="/hero.webp" as="image">
  <link rel="preload" href="/font.woff2" as="font" type="font/woff2" crossorigin>
</head>
```

### Pattern 2: Breadcrumb Navigation with Schema

```html
<!-- Visual breadcrumbs with structured data -->
<nav aria-label="Breadcrumb">
  <ol class="breadcrumbs" itemscope itemtype="https://schema.org/BreadcrumbList">
    <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
      <a itemprop="item" href="https://example.com">
        <span itemprop="name">Home</span>
      </a>
      <meta itemprop="position" content="1">
    </li>
    <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
      <a itemprop="item" href="https://example.com/blog">
        <span itemprop="name">Blog</span>
      </a>
      <meta itemprop="position" content="2">
    </li>
    <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
      <a itemprop="item" href="https://example.com/blog/getting-started" aria-current="page">
        <span itemprop="name">Getting Started</span>
      </a>
      <meta itemprop="position" content="3">
    </li>
  </ol>
</nav>

<style>
  .breadcrumbs {
    display: flex;
    list-style: none;
    padding: 8px 0;
    margin: 0;
    font-size: 14px;
  }
  .breadcrumbs li:not(:last-child)::after {
    content: '›';
    margin: 0 8px;
    color: #999;
  }
  .breadcrumbs a {
    color: #007bff;
    text-decoration: none;
  }
  .breadcrumbs a:hover {
    text-decoration: underline;
  }
  .breadcrumbs [aria-current="page"] {
    color: #666;
    pointer-events: none;
  }
</style>
```

### Pattern 3: SEO-Friendly Pagination

```html
<!-- Pagination with proper SEO signals -->
<nav aria-label="Pagination">
  <ul class="pagination">
    <li>
      <a href="/blog?page=1" rel="prev" aria-label="Previous page">
        ← Previous
      </a>
    </li>
    <li><a href="/blog?page=1">1</a></li>
    <li><a href="/blog?page=2" aria-current="page">2</a></li>
    <li><a href="/blog?page=3">3</a></li>
    <li><span class="ellipsis">…</span></li>
    <li><a href="/blog?page=10">10</a></li>
    <li>
      <a href="/blog?page=3" rel="next" aria-label="Next page">
        Next →
      </a>
    </li>
  </ul>
</nav>

<!-- For SEO: self-referencing canonical per page -->
<!-- Page 2: -->
<link rel="canonical" href="https://example.com/blog?page=2">
<link rel="prev" href="https://example.com/blog?page=1">
<link rel="next" href="https://example.com/blog?page=3">
```

### Pattern 4: Image SEO Optimization

```html
<!-- SEO-optimized image with modern formats -->
<picture>
  <source
    srcset="/images/hero.avif"
    type="image/avif"
  >
  <source
    srcset="/images/hero.webp"
    type="image/webp"
  >
  <img
    src="/images/hero.jpg"
    alt="Descriptive alt text with natural keyword placement"
    width="1200"
    height="675"
    loading="lazy"
    decoding="async"
    fetchpriority="low"
  >
</picture>

<!-- Hero image: fetchpriority high, no lazy loading -->
<picture>
  <source srcset="/images/hero.avif" type="image/avif">
  <source srcset="/images/hero.webp" type="image/webp">
  <img
    src="/images/hero.jpg"
    alt="Main hero image"
    width="1200"
    height="675"
    fetchpriority="high"
    decoding="async"
  >
</picture>
```

### Pattern 5: robots.txt for Complex Sites

```txt
# robots.txt for a large e-commerce site
# Crawl budget optimization

User-agent: *
Allow: /
Disallow: /cart/
Disallow: /checkout/
Disallow: /account/
Disallow: /admin/
Disallow: /api/
Disallow: /search?
Disallow: /*?sort=*
Disallow: /*?filter=*
Disallow: /*?ref=*
Disallow: /cgi-bin/

# Allow Google to render JS
User-agent: Googlebot
Allow: /

# Allow Bing
User-agent: Bingbot
Allow: /

# Block AI crawlers (optional)
User-agent: GPTBot
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Google-Extended
Disallow: /

User-agent: anthropic-ai
Disallow: /

# Specific product filter pages (prevent thin content)
User-agent: *
Disallow: /products?color=*
Disallow: /products?size=*
Disallow: /products?material=*

# Sitemaps
Sitemap: https://example.com/sitemap-index.xml
Sitemap: https://example.com/sitemap-products.xml
Sitemap: https://example.com/sitemap-blog.xml
Sitemap: https://example.com/sitemap-images.xml
```

## Edge Cases & Pitfalls

### 1. **JavaScript-Rendered Content Not Indexed**
Search engines may not execute JavaScript, so content rendered client-side (React, Vue, Angular) may never be indexed. **Solution**: Use SSR (Server-Side Rendering) or SSG (Static Site Generation) with Next.js, Nuxt, or Astro. If client-side rendering is unavoidable, implement dynamic rendering with a headless browser as a fallback.

### 2. **Canonical Tag Points to Redirect**
If a canonical URL redirects (301 or 302), search engines may ignore the canonical signal entirely. **Solution**: Always canonical to the final destination URL. Never canonical to a URL that itself redirects. Verify with crawling tools.

### 3. **Noindex on Staging Leaks to Production**
If a staging or development environment has noindex directives and those get deployed to production, the entire site becomes deindexed. **Solution**: Use environment variables to conditionally apply noindex. Never hardcode `noindex` in templates. Verify robots meta tag in production after every deploy.

### 4. **Faceted Navigation Creates Duplicate Content**
E-commerce filter pages (?color=red&size=large) can generate thousands of near-duplicate pages, wasting crawl budget. **Solution**: Use canonical tags pointing to the unfiltered page, disallow filtered URLs in robots.txt, or use AJAX-based filtering that doesn't create new URLs.

### 5. **Hreflang Tags Have Mismatched URLs**
If hreflang alternate tags don't point to reciprocal URLs (page A links to page B, but page B doesn't link back to page A), search engines ignore all hreflang declarations for that set. **Solution**: Always implement hreflang as a complete set — every language version must reference every other language version including itself. Validate with hreflang tag generators.

### 6. **Hidden Text / Keyword Stuffing Triggers Penalties**
Hiding text with CSS (`display:none`, `font-size:0`, `color: same as background`) or stuffing keywords unnaturally can trigger a manual penalty from Google. **Solution**: Never hide text that's meant for search engines but not users. All visible content should be genuinely useful to human readers. Write naturally, not for algorithms.

### 7. **302 Redirects Used Instead of 301**
Using 302 (temporary) redirects for permanent URL changes means search engines keep indexing the old URL and may not transfer link equity. **Solution**: Use 301 (permanent) redirects for all permanent URL changes. Only use 302 for genuinely temporary situations (maintenance, A/B tests, geolocation).

### 8. **Missing Alt Text on Images**
Images without alt text are invisible to search engines and screen readers. This is both an SEO problem and an accessibility violation. **Solution**: Write descriptive alt text for every meaningful image. Use empty alt (`alt=""`) only for purely decorative images. Include natural keywords where appropriate, but don't stuff.

### 9. **Slow Page Speed Kills Rankings**
Page speed is a confirmed ranking factor, and slow pages have higher bounce rates. Core Web Vitals (LCP, CLS, INP) directly impact ranking. **Solution**: Optimize images (WebP/AVIF, lazy loading), minimize JavaScript, use a CDN, enable compression, preload critical resources, and monitor CWV continuously.

### 10. **Orphan Pages Not Reachable by Crawlers**
Pages that have no internal links pointing to them (orphan pages) may never be discovered by search engine crawlers, even if they're in the sitemap. **Solution**: Ensure every indexable page has at least one internal link from a crawlable page. Use site crawlers (Screaming Frog, Ahrefs) to find orphan pages.

### 11. **Broken Internal Links Waste Crawl Budget**
404 errors on internal links waste search engine crawl budget and create poor user experience. **Solution**: Run regular crawls with Screaming Frog or similar tools. Set up 301 redirects for URLs that have moved. Fix or remove links to truly deleted pages. Monitor Search Console for crawl errors.

### 12. **Thin Content Pages Drag Down Site Quality**
Pages with very little content (under 300 words) or auto-generated content provide low value and can hurt overall site quality. **Solution**: Either add substantial unique content to thin pages, noindex them if they serve a purpose but shouldn't rank, or combine them with related content. Every page should provide unique value.

### 13. **Over-Optimized Anchor Text Looks Spammy**
Having all internal links use exact-match keyword anchor text ("best running shoes") appears manipulative to search engines. **Solution**: Use natural, varied anchor text. Mix exact match, partial match, branded, and generic anchors. The anchor text should describe what the linked page is about, not just stuff keywords.

### 14. **Missing Schema Markup for Rich Results**
Without structured data, your content can still rank but won't appear as rich results (FAQ dropdowns, product stars, recipe cards, event listings). This means lower click-through rates even at the same ranking position. **Solution**: Implement JSON-LD structured data for all applicable content types. Use Google's Rich Results Test to validate. Monitor Search Console for structured data errors.

### 15. **SSL Certificate Issues Block Crawling**
Mixed content warnings, expired certificates, or HTTP/HTTPS mismatches can block search engines from crawling your site entirely. **Solution**: Always use valid SSL certificates. Redirect all HTTP to HTTPS. Ensure all internal resources load over HTTPS. Use HSTS headers. Monitor certificate expiry dates.

## Integration with Other Skills

| Skill | Relationship | How It Integrates |
|-------|-------------|-------------------|
| **Performance Optimization** | Core Web Vitals | LCP, CLS, INP directly impact SEO rankings; shared optimization patterns |
| **Web Accessibility** | Accessibility patterns | Screen reader support, semantic HTML, heading hierarchy overlap with SEO |
| **HTML Email** | Minimal overlap | Email is not crawlable; but email marketing can drive traffic to SEO-optimized pages |
| **Content Writing** | Content strategy | Keyword research informs content; technical SEO enables content to be indexed |
| **React / Next.js** | Framework SEO | SSR/SSG, meta tags, structured data in React frameworks |
| **Analytics** | Performance tracking | Google Search Console, GA4, CWV monitoring, indexation tracking |
| **DevOps / CI** | Deployment | Automated sitemap generation, redirect validation, SEO testing in CI/CD |
| **Marketing Automation** | Strategy integration | SEO traffic feeds into email funnels, remarketing audiences |

## Output Format Templates

### Template 1: SEO Audit Report

```
## SEO Audit Report — [URL]

### Technical SEO
- [ ] robots.txt configured and accessible
- [ ] XML sitemap submitted to Search Console
- [ ] Canonical URLs set on all pages
- [ ] HTTPS enabled, no mixed content
- [ ] Mobile-friendly (responsive design)
- [ ] Page speed acceptable (LCP < 2.5s)
- [ ] No redirect chains
- [ ] No broken internal links

### On-Page SEO
- [ ] Title tags optimized (30-60 chars, includes keyword)
- [ ] Meta descriptions written (120-160 chars)
- [ ] H1 tag present, one per page
- [ ] Heading hierarchy correct (H1 → H2 → H3)
- [ ] Images have descriptive alt text
- [ ] Internal linking uses descriptive anchor text
- [ ] URL structure is clean and readable

### Structured Data
- [ ] JSON-LD implemented for applicable types
- [ ] Rich results tested and validated
- [ ] Schema types: [Article, Product, FAQ, etc.]

### Core Web Vitals
- LCP: [X.Xs] — [Good | Needs Improvement | Poor]
- CLS: [0.XX] — [Good | Needs Improvement | Poor]
- INP: [XXXms] — [Good | Needs Improvement | Poor]

### Indexation
- Pages indexed: [number]
- Pages submitted: [number]
- Coverage errors: [number]

### Priority Actions
1. [Highest impact action]
2. [Second highest]
3. [Third highest]
```

### Template 2: Structured Data Implementation Plan

```
## Structured Data Implementation

### Page Types
| Page Type | Schema Type | Priority | Status |
|-----------|-------------|----------|--------|
| Homepage | Organization | P1 | ⬜ |
| Blog Posts | Article | P1 | ⬜ |
| Product Pages | Product | P1 | ⬜ |
| FAQ Pages | FAQPage | P2 | ⬜ |
| Category Pages | BreadcrumbList | P2 | ⬜ |
| About Page | AboutPage | P3 | ⬜ |
| Contact Page | ContactPage | P3 | ⬜ |
| Events | Event | P2 | ⬜ |

### Implementation
- Format: JSON-LD (embedded in <script> tags)
- Validation: Google Rich Results Test
- Monitoring: Search Console → Enhancements
```

### Template 3: Sitemap Structure

```
## Sitemap Architecture

### Sitemap Index
sitemap-index.xml
├── sitemap-pages.xml (static pages)
├── sitemap-blog.xml (blog posts, paginated if >5000)
├── sitemap-products.xml (product pages)
├── sitemap-categories.xml (category pages)
└── sitemap-images.xml (image sitemap)

### Rules
- Max 50,000 URLs per sitemap
- Max 50MB uncompressed per sitemap
- Use lastmod dates (only when content actually changes)
- Submit index to Google Search Console and Bing Webmaster Tools
```

### Template 4: Redirect Mapping Template

```
## URL Redirect Map

| Old URL | New URL | Status Code | Notes |
|---------|---------|-------------|-------|
| /old-page | /new-page | 301 | Content moved |
| /blog/post-v1 | /blog/post | 301 | URL cleanup |
| /products?cat=1 | /category/shoes | 301 | Faceted → clean |
| /page.html | /page | 301 | Extension removal |

### Rules
- Use 301 for permanent changes
- Use 302 for temporary (A/B tests, maintenance)
- Chain maximum: 1 redirect (never chain 301→301→301)
- Test with: curl -I [old-url] to verify response
```

## Rules

1. **Every page must have a unique, descriptive title tag** — 30-60 characters, include the primary keyword naturally, and append the brand name
2. **Every page must have a unique meta description** — 120-160 characters, written as a compelling call-to-action that includes the target keyword
3. **Use exactly one H1 per page** — it should match or closely relate to the title tag and describe the page's primary topic
4. **Always implement canonical URLs** — self-referencing canonicals prevent duplicate content issues from URL parameters, tracking codes, and session IDs
5. **Use HTTPS everywhere** — no exceptions; HTTP pages are penalized and modern browsers flag them as insecure
6. **Never block CSS or JavaScript from crawlers** — search engines need to render your page to understand it; don't disallow CSS/JS in robots.txt
7. **Submit XML sitemaps to Search Console** — don't rely on crawlers discovering your sitemap through robots.txt alone
8. **Implement structured data (JSON-LD) for all applicable content types** — Article, Product, FAQ, BreadcrumbList, Organization at minimum
9. **Optimize Core Web Vitals continuously** — LCP under 2.5s, CLS under 0.1, INP under 200ms; monitor monthly
10. **Use 301 redirects for permanent URL changes** — never use 302 for permanent moves; always redirect to the final destination, never to a redirect
11. **Ensure every indexable page has at least one internal link** — orphan pages waste crawl budget and may never be indexed
12. **Write alt text for every meaningful image** — descriptive, natural, includes relevant context; empty alt only for decorative images
13. **Never use noindex on production without verification** — a single misplaced noindex tag can deindex your entire site
14. **Keep URL structures clean and readable** — use hyphens, lowercase, descriptive words; avoid parameters, IDs, and dynamic strings
15. **Monitor Search Console weekly** — check for crawl errors, indexation issues, manual actions, and Core Web Vitals reports
