---
name: i18n
description: >-
  Internationalize and localize web applications for multiple languages, regions, and cultures.
  Use this skill when the user mentions i18n, internationalization, localization, l10n, translation,
  multi-language, multi-locale, RTL support, right-to-left, locale detection, date formatting,
  number formatting, currency formatting, pluralization, translation keys,
  or says بین‌المللی‌سازی، ترجمه، چندزبانه، پشتیبانی RTL، فرمت تاریخ، فرمت ارز.
---

# Internationalization (i18n) Skill — Multi-Language, Locale & RTL Support

## Overview

This skill covers internationalization (i18n) and localization (l10n): making applications work for multiple languages, regions, and cultures. This includes translation management, date/number/currency formatting, pluralization rules, RTL layout support, and locale detection. Proper i18n makes your app accessible to a global audience.

## When to Use This Skill

- User wants to make their app multi-language
- User needs RTL (right-to-left) support
- User asks about date/number/currency formatting for different locales
- User mentions translation, localization, or i18n
- User wants to add a new language to their app
- User mentions بین‌المللی‌سازی, ترجمه, or چندزبانه

---

## Part 1: i18n Framework Setup

### React (react-intl / next-intl)

```typescript
// next-intl setup
// messages/en.json
{
  "common": {
    "greeting": "Hello, {name}!",
    "items": "{count, plural, =0 {No items} one {1 item} other {{count} items}}"
  },
  "navigation": {
    "home": "Home",
    "about": "About",
    "contact": "Contact"
  }
}

// messages/fa.json
{
  "common": {
    "greeting": "!سلام {name}",
    "items": "{count, plural, =0 {آیتمی نیست} one {۱ آیتم} other {{count} آیتم}}"
  },
  "navigation": {
    "home": "خانه",
    "about": "درباره ما",
    "contact": "تماس"
  }
}

// Usage in components
import { useTranslations } from 'next-intl';

function HomePage() {
  const t = useTranslations('common');
  
  return (
    <div>
      <h1>{t('greeting', { name: 'John' })}</h1>
      <p>{t('items', { count: 5 })}</p>
    </div>
  );
}
```

### Vue (vue-i18n)

```typescript
// i18n.ts
import { createI18n } from 'vue-i18n';

const i18n = createI18n({
  legacy: false,
  locale: 'en',
  fallbackLocale: 'en',
  messages: {
    en: {
      greeting: 'Hello, {name}!',
      items: '{count} items'
    },
    fa: {
      greeting: '!سلام {name}',
      items: '{count} آیتم'
    }
  }
});

export default i18n;

// Usage in components
<template>
  <h1>{{ $t('greeting', { name: 'John' }) }}</h1>
</template>
```

### Node.js (i18next)

```typescript
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: { greeting: 'Hello!' } },
    fa: { translation: { greeting: '!سلام' } }
  },
  lng: 'en',
  fallbackLng: 'en',
  interpolation: { escapeValue: false }
});
```

---

## Part 2: Translation Patterns

### ICU Message Format (Pluralization)

```json
{
  "cart": {
    "empty": "Your cart is empty",
    "items": "{count, plural, =0 {Your cart is empty} one {You have # item in your cart} other {You have # items in your cart}}",
    "total": "Total: {amount, currency}"
  }
}
```

### Gender Sensitivity

```json
{
  "welcome": "{gender, select, male {Welcome, Mr. {name}} female {Welcome, Ms. {name}} other {Welcome, {name}}}"
}
```

### Nested Keys

```typescript
// Access nested translation keys
t('user.profile.settings.language')
// Equivalent to: messages.user.profile.settings.language
```

### HTML in Translations

```tsx
// React with embedded HTML
import { Trans } from 'react-i18next';

<Trans i18nKey="description">
  Read the <a href="/docs">documentation</a> for more info.
</Trans>

// Translation
{
  "description": "Read the <1>documentation</1> for more info."
}
```

---

## Part 3: Date, Number & Currency Formatting

### Date Formatting

```typescript
// Format date by locale
const date = new Date('2024-01-15');

// English (US)
new Intl.DateTimeFormat('en-US', {
  year: 'numeric', month: 'long', day: 'numeric'
}).format(date); // "January 15, 2024"

// Persian (Iran)
new Intl.DateTimeFormat('fa-IR', {
  year: 'numeric', month: 'long', day: 'numeric'
}).format(date); // "۱۵ ژانویه ۲۰۲۴"

// Japanese
new Intl.DateTimeFormat('ja-JP', {
  year: 'numeric', month: 'long', day: 'numeric'
}).format(date); // "2024年1月15日"

// Relative time
const rtf = new Intl.RelativeTimeFormat('en', { numeric: 'auto' });
rtf.format(-1, 'day');  // "yesterday"
rtf.format(3, 'day');   // "in 3 days"
```

### Number Formatting

```typescript
const number = 1234567.89;

// English (US)
new Intl.NumberFormat('en-US').format(number); // "1,234,567.89"

// German
new Intl.NumberFormat('de-DE').format(number); // "1.234.567,89"

// French
new Intl.NumberFormat('fr-FR').format(number); // "1 234 567,89"

// Persian
new Intl.NumberFormat('fa-IR').format(number); // "۱٬۲۳۴٬۵۶۷٫۸۹"

// Percentage
new Intl.NumberFormat('en-US', { style: 'percent' }).format(0.85); // "85%"
```

### Currency Formatting

```typescript
const amount = 1234.56;

// USD
new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount);
// "$1,234.56"

// EUR
new Intl.NumberFormat('de-DE', { style: 'currency', currency: 'EUR' }).format(amount);
// "1.234,56 €"

// IRR (Iranian Rial)
new Intl.NumberFormat('fa-IR', { style: 'currency', currency: 'IRR' }).format(amount);
// "۱٬۲۳۴﷼۵۶"

// JPY (no decimal)
new Intl.NumberFormat('ja-JP', { style: 'currency', currency: 'JPY' }).format(amount);
// "￥1,235"
```

---

## Part 4: RTL (Right-to-Left) Support

### CSS for RTL

```css
/* CSS logical properties (recommended) */
.element {
  margin-inline-start: 16px;   /* Instead of margin-left */
  margin-inline-end: 16px;     /* Instead of margin-right */
  padding-inline-start: 24px;  /* Instead of padding-left */
  padding-inline-end: 24px;    /* Instead of padding-right */
  border-inline-start: 1px solid #ccc;  /* Instead of border-left */
  border-inline-end: 1px solid #ccc;    /* Instead of border-right */
  text-align: start;           /* Instead of text-align: left */
}

/* For[dir="rtl"] overrides */
[dir="rtl"] .sidebar {
  border-right: none;
  border-left: 1px solid #ccc;
}

/* Or use :dir() pseudo-class */
.sidebar:dir(rtl) {
  border-right: none;
  border-left: 1px solid #ccc;
}
```

### HTML RTL

```html
<html lang="fa" dir="rtl">
<head>
  <meta charset="UTF-8">
  <title>عنوان صفحه</title>
</head>
<body>
  <!-- Content automatically flows right-to-left -->
</body>
</html>
```

### Auto-Detect Direction

```typescript
function getDirection(text: string): 'ltr' | 'rtl' {
  // Check for RTL characters
  const rtlRegex = /[\u0591-\u07FF\u200F\u202B\u202E\uFB1D-\uFDFD\uFE70-\uFEFC]/;
  return rtlRegex.test(text) ? 'rtl' : 'ltr';
}

// Set direction dynamically
const direction = getDirection(userLanguage);
document.documentElement.dir = direction;
document.documentElement.lang = userLanguage;
```

---

## Part 5: Locale Detection

### Detection Strategies

```typescript
// 1. URL path prefix
// /en/about, /fa/about

// 2. Query parameter
// ?lang=fa

// 3. Cookie
function getLocaleFromCookie(): string {
  const match = document.cookie.match(/locale=([^;]+)/);
  return match ? match[1] : 'en';
}

// 4. Browser language
function getBrowserLocale(): string {
  return navigator.language.split('-')[0]; // 'en-US' → 'en'
}

// 5. Accept-Language header (server-side)
function getLocaleFromHeaders(request): string {
  const acceptLanguage = request.headers['accept-language'];
  // Parse and select best match
  return negotiateLocale(acceptLanguage, supportedLocales);
}

// Combined strategy
function detectLocale(): string {
  // 1. Check URL
  const urlLocale = getLocaleFromUrl();
  if (urlLocale) return urlLocale;
  
  // 2. Check cookie (user preference)
  const cookieLocale = getLocaleFromCookie();
  if (cookieLocale) return cookieLocale;
  
  // 3. Check browser
  return getBrowserLocale();
}
```

### Language Switcher Component

```tsx
function LanguageSwitcher() {
  const { locale, locales, setLocale } = useI18n();
  
  return (
    <select
      value={locale}
      onChange={(e) => setLocale(e.target.value)}
      aria-label="Select language"
    >
      {locales.map((loc) => (
        <option key={loc} value={loc}>
          {localeNames[loc]}
        </option>
      ))}
    </select>
  );
}

const localeNames = {
  en: 'English',
  fa: 'فارسی',
  ar: 'العربية',
  ja: '日本語',
};
```

---

## Part 6: Translation Management

### File Structure

```
locales/
├── en/
│   ├── common.json
│   ├── auth.json
│   ├── dashboard.json
│   └── errors.json
├── fa/
│   ├── common.json
│   ├── auth.json
│   ├── dashboard.json
│   └── errors.json
└── ar/
    ├── common.json
    ├── auth.json
    ├── dashboard.json
    └── errors.json
```

### Translation Tools

| Tool | Type | Best For |
|------|------|----------|
| **Crowdin** | SaaS | Large teams, professional |
| **Lokalise** | SaaS | Startup-friendly |
| **Weblate** | Self-hosted | Open source |
| **Poedit** | Desktop | Small projects |
| **i18n-ally** | VS Code extension | Developer workflow |

### VS Code Extension (i18n-ally)

```json
// .vscode/settings.json
{
  "i18n-ally.enabledFrameworks": ["next-intl", "react"],
  "i18n-ally.sourceLanguage": "en",
  "i18n-ally.pathMatcher": "locales/{locale}/{namespaces}.json",
  "i18n-ally.keystyle": "flat"
}
```

---

## Part 7: SEO for Multi-Language

```html
<!-- Alternate language links -->
<link rel="alternate" hreflang="en" href="https://example.com/en/about" />
<link rel="alternate" hreflang="fa" href="https://example.com/fa/about" />
<link rel="alternate" hreflang="x-default" href="https://example.com/about" />

<!-- For path-based routing -->
<link rel="alternate" hreflang="en" href="https://example.com/en/page" />
<link rel="alternate" hreflang="fa" href="https://example.com/fa/page" />
```

### hreflang Rules

```xml
<!-- In sitemap.xml -->
<url>
  <loc>https://example.com/en/page</loc>
  <xhtml:link rel="alternate" hreflang="en" href="https://example.com/en/page" />
  <xhtml:link rel="alternate" hreflang="fa" href="https://example.com/fa/page" />
</url>
```

---

## Output Format

```
## i18n Implementation

### Supported Languages
| Language | Locale | Direction | Status |
|----------|--------|-----------|--------|
| English | en | LTR | ✅ |
| فارسی | fa | RTL | ✅ |

### Translation Coverage
| Namespace | en | fa | % Complete |
|-----------|----|----|------------|
| common | 100% | 100% | 100% |
| auth | 100% | 85% | 92% |

### Formatting
- Dates: [locale-specific format]
- Numbers: [locale-specific format]
- Currency: [locale-specific format]

### RTL Support
[Implementation details]
```

## Rules

- **Use translation keys, not hardcoded text** — Every user-visible string must be translatable
- **Use ICU Message Format** — Handles pluralization, gender, and formatting
- **Don't concatenate strings** — Use parameterized messages instead
- **Support RTL from day one** — Adding RTL later is expensive
- **Use logical CSS properties** — margin-inline-start, not margin-left
- **Format dates/numbers/currencies by locale** — Don't hardcode formats
- **Test with real translations** — Don't just test with English
- **Keep translations in sync** — Use a translation management tool
