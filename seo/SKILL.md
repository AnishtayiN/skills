---
name: seo
description: >-
  Optimize websites for search engines including technical SEO, on-page SEO, structured data,
  meta tags, performance optimization, and analytics. Use this skill when the user mentions
  SEO, search engine optimization, meta tags, structured data, sitemap, robots.txt,
  page speed, Core Web Vitals, backlinks, keyword research, on-page SEO, technical SEO,
  or says سئو، بهینه‌سازی موتور جستجو، متاتگ، نقشه سایت، سرعت صفحه.
---

# SEO Skill — Technical SEO, On-Page Optimization & Analytics

## Overview

This skill covers search engine optimization: technical SEO (crawlability, indexability), on-page SEO (content, meta tags, structure), structured data (Schema.org), performance optimization (Core Web Vitals), and analytics. SEO is a long-term strategy — this skill provides the technical foundation for ranking well in search engines.

## When to Use This Skill

- User wants to optimize their website for search engines
- User needs to add meta tags or structured data
- User asks about Core Web Vitals or page speed
- User mentions sitemap, robots.txt, or crawlability
- User wants to improve their Google ranking
- User mentions سئو or بهینه‌سازی موتور جستجو

---

## Part 1: Technical SEO

### robots.txt

```txt
# Allow all crawlers
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/
Disallow: /private/

# Specific crawler rules
User-agent: Googlebot
Allow: /

User-agent: Bingbot
Allow: /

# Sitemap location
Sitemap: https://example.com/sitemap.xml
```

### XML Sitemap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <lastmod>2024-01-15</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://example.com/products</loc>
    <lastmod>2024-01-15</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://example.com/about</loc>
    <lastmod>2024-01-10</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.5</priority>
  </url>
</urlset>
```

### Canonical URLs

```html
<!-- Prevent duplicate content -->
<link rel="canonical" href="https://example.com/page" />

<!-- For paginated content -->
<link rel="canonical" href="https://example.com/products?page=2" />
```

### Redirects

```nginx
# 301 Permanent Redirect
location /old-page {
    return 301 /new-page;
}

# 302 Temporary Redirect
location /maintenance {
    return 302 /maintenance-page;
}

# Redirect non-www to www
if ($host !~ ^www\.example\.com$) {
    rewrite ^(.*)$ https://www.example.com$1 permanent;
}

# Redirect HTTP to HTTPS
if ($scheme = http) {
    return 301 https://$host$request_uri;
}
```

---

## Part 2: On-Page SEO

### Meta Tags

```html
<!-- Primary Meta Tags -->
<title>Best Coffee Shop in NYC | Daily Brew</title>
<meta name="title" content="Best Coffee Shop in NYC | Daily Brew">
<meta name="description" content="Daily Brew serves the best artisan coffee in New York City. Visit us for freshly roasted beans, specialty drinks, and a cozy atmosphere.">
<meta name="keywords" content="coffee shop NYC, best coffee New York, artisan coffee">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://dailybrew.com/">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://dailybrew.com/">
<meta property="og:title" content="Best Coffee Shop in NYC | Daily Brew">
<meta property="og:description" content="Daily Brew serves the best artisan coffee in New York City.">
<meta property="og:image" content="https://dailybrew.com/images/og-image.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="https://dailybrew.com/">
<meta name="twitter:title" content="Best Coffee Shop in NYC | Daily Brew">
<meta name="twitter:description" content="Daily Brew serves the best artisan coffee in New York City.">
<meta name="twitter:image" content="https://dailybrew.com/images/twitter-card.jpg">
```

### Heading Structure

```html
<!-- Proper heading hierarchy -->
<h1>Best Coffee Shop in NYC</h1>  <!-- Only ONE h1 per page -->
  <h2>Our Menu</h2>
    <h3>Coffee Drinks</h3>
    <h3>Tea Options</h3>
  <h2>Location & Hours</h2>
    <h3>Weekday Hours</h3>
    <h3>Weekend Hours</h3>
  <h2>Customer Reviews</h2>
```

### Image Optimization

```html
<!-- Responsive images with alt text -->
<img 
  src="coffee-shop.jpg" 
  alt="Cozy interior of Daily Brew coffee shop with wooden tables and warm lighting"
  width="800"
  height="600"
  loading="lazy"
  fetchpriority="high"
/>

<!-- WebP with fallback -->
<picture>
  <source srcset="coffee.webp" type="image/webp">
  <img src="coffee.jpg" alt="Artisan coffee being poured" loading="lazy">
</picture>
```

### Internal Linking

```html
<!-- descriptive anchor text -->
<a href="/blog/best-coffee-beans">Learn about our best coffee beans</a>

<!-- NOT generic text -->
<a href="/blog/best-coffee-beans">Click here</a>  <!-- ❌ BAD -->
```

---

## Part 3: Structured Data (Schema.org)

### JSON-LD (Recommended)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Daily Brew",
  "description": "Best artisan coffee in NYC",
  "url": "https://dailybrew.com",
  "logo": "https://dailybrew.com/images/logo.png",
  "image": "https://dailybrew.com/images/storefront.jpg",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main Street",
    "addressLocality": "New York",
    "addressRegion": "NY",
    "postalCode": "10001",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 40.7128,
    "longitude": -74.0060
  },
  "telephone": "+1-212-555-0123",
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "07:00",
      "closes": "20:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Saturday", "Sunday"],
      "opens": "08:00",
      "closes": "18:00"
    }
  ],
  "priceRange": "$$",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "324"
  }
}
</script>
```

### Article Schema

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "10 Best Coffee Beans for Home Brewing",
  "author": {
    "@type": "Person",
    "name": "John Smith"
  },
  "datePublished": "2024-01-15",
  "dateModified": "2024-01-20",
  "image": "https://dailybrew.com/images/coffee-beans.jpg",
  "publisher": {
    "@type": "Organization",
    "name": "Daily Brew",
    "logo": {
      "@type": "ImageObject",
      "url": "https://dailybrew.com/images/logo.png"
    }
  },
  "description": "Discover the top 10 coffee beans for home brewing...",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://dailybrew.com/blog/best-coffee-beans"
  }
}
</script>
```

### FAQ Schema

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What are your opening hours?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "We're open Monday-Friday 7am-8pm, Saturday-Sunday 8am-6pm."
      }
    },
    {
      "@type": "Question",
      "name": "Do you offer free Wi-Fi?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! Free Wi-Fi is available for all customers."
      }
    }
  ]
}
</script>
```

---

## Part 4: Core Web Vitals

### Metrics

| Metric | What It Measures | Good | Needs Improvement | Poor |
|--------|-----------------|------|-------------------|------|
| **LCP** | Largest Contentful Paint | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **FID** | First Input Delay | ≤ 100ms | ≤ 300ms | > 300ms |
| **CLS** | Cumulative Layout Shift | ≤ 0.1 | ≤ 0.25 | > 0.25 |
| **INP** | Interaction to Next Paint | ≤ 200ms | ≤ 500ms | > 500ms |

### Optimization Tips

```html
<!-- LCP: Preload critical resources -->
<link rel="preload" href="hero-image.webp" as="image">
<link rel="preload" href="main-font.woff2" as="font" crossorigin>

<!-- LCP: Use fetchpriority for hero image -->
<img src="hero.webp" fetchpriority="high" alt="Hero">

<!-- CLS: Set dimensions for images/videos -->
<img src="photo.jpg" width="800" height="600" alt="Photo">

<!-- CLS: Reserve space for dynamic content -->
<div style="min-height: 200px;">
  <!-- Ad or dynamic content loads here -->
</div>

<!-- FID: Defer non-critical JS -->
<script src="app.js" defer></script>
<script src="analytics.js" async></script>
```

### Performance Checklist

- [ ] Image optimization (WebP, lazy loading, proper sizing)
- [ ] Code splitting and lazy loading
- [ ] Minimize third-party scripts
- [ ] Use CDN for static assets
- [ ] Enable compression (gzip/brotli)
- [ ] Preload critical resources
- [ ] Minimize render-blocking resources

---

## Part 5: React/Next.js SEO

```tsx
// Next.js Head component
import Head from 'next/head';

function SEOHead({ title, description, image, url }) {
  return (
    <Head>
      <title>{title}</title>
      <meta name="description" content={description} />
      
      {/* Open Graph */}
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:url" content={url} />
      
      {/* Twitter */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />
      
      {/* Canonical */}
      <link rel="canonical" href={url} />
    </Head>
  );
}

// SSR for SEO (pages render on server)
export async function getServerSideProps() {
  const data = await fetchData();
  return { props: { data } };
}
```

---

## Part 6: Analytics

### Google Analytics Setup

```html
<!-- Google Analytics 4 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### Search Console

```xml
<!-- Verify ownership -->
<meta name="google-site-verification" content="your-verification-code" />
```

---

## Output Format

```
## SEO Audit Report

### Technical SEO
- [ ] robots.txt configured
- [ ] XML sitemap submitted
- [ ] Canonical URLs set
- [ ] HTTPS enabled
- [ ] Mobile-friendly

### On-Page SEO
- [ ] Title tags optimized
- [ ] Meta descriptions written
- [ ] Heading hierarchy correct
- [ ] Images have alt text
- [ ] Internal linking done

### Structured Data
- [Schema types implemented]

### Core Web Vitals
- LCP: Xs
- FID: Xms
- CLS: X
```

## Rules

- **Content is king** — No SEO trick replaces good content
- **Mobile-first** — Google indexes mobile versions first
- **Page speed matters** — Slow sites rank lower
- **Use structured data** — Helps search engines understand your content
- **Write for humans** — Don't keyword stuff
- **Build quality backlinks** — One good link > 100 bad links
- **Monitor regularly** — Use Search Console and Analytics
