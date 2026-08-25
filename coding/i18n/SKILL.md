---
name: i18n
description: >-
  Expert internationalization and localization for web applications across
  languages, regions, and cultures. TRIGGERS: i18n, internationalization,
  localization, l10n, translation, multi-language, multi-locale, RTL support,
  right-to-left, locale detection, date formatting, number formatting,
  currency formatting, pluralization, translation keys, locale-aware sorting,
  internationalization setup, بین‌المللی‌سازی, ترجمه, چندزبانه, پشتیبانی RTL,
  فرمت تاریخ, فرمت ارز, محلی‌سازی, زبان‌های مختلف, م translate,
  国际化, 本地化, 多语言, 右到左, RTL支持, 日期格式, 货币格式,
  翻译, 区域设置, 复数化
priority: P1
dependencies: [regex, code-review]
conflicts: []
---

# Internationalization & Localization Skill

## Overview

This skill provides comprehensive guidance on internationalizing (i18n) and localizing (l10n) software applications for global audiences. It covers text translation management, locale-aware formatting (dates, numbers, currencies, units), bidirectional text support (RTL/LTR), pluralization rules, locale detection, and cultural adaptation. The focus is on production-grade implementations using established libraries (ICU, i18next, react-intl, gettext) with architecture that supports adding new locales without code changes.

## When to Use This Skill

- Adding multi-language support to an existing application (e.g., English + Arabic + Chinese).
- Implementing locale-aware date, time, number, and currency formatting.
- Adding right-to-left (RTL) language support (Arabic, Hebrew, Farsi, Urdu).
- Designing translation key hierarchies and managing translation files.
- Implementing pluralization rules for languages with complex plural forms.
- Detecting user locale from browser headers, geolocation, or user preferences.
- Sorting and comparing strings in locale-aware order.
- Formatting addresses, phone numbers, and names for different countries.
- Ensuring accessibility across languages (screen readers, ARIA labels).

## When NOT to Use This Skill

- Simple single-language applications with no international users.
- Machine translation of large document corpora (use the NLP skill).
- Typography or graphic design for multilingual layouts.
- Legal compliance for specific countries (consult legal counsel).
- Character encoding issues unrelated to i18n (use the database-design skill).
- Font rendering and web typography (use the front-end skill).

## Workflow

### Step 1 — Locale Audit and Planning

Before writing any i18n code, audit the existing codebase and plan the target locales:

```markdown
## i18n Audit Checklist

### Text Inventory
- [ ] Count all user-facing strings across the application
- [ ] Identify hardcoded strings in source code
- [ ] Catalog dynamic strings (with placeholders, variables)
- [ ] Identify strings that should NOT be translated (technical IDs, URLs, code)
- [ ] Map string context (UI labels, error messages, notifications, emails)

### Technical Assessment
- [ ] Current encoding: UTF-8 throughout? Any ASCII-only assumptions?
- [ ] Database: supports Unicode columns? Correct collation?
- [ ] APIs: accept/return Unicode properly?
- [ ] File system: Unicode file names supported?
- [ ] Current date/number formatting: locale-aware or hardcoded?

### Target Locales
- [ ] Select initial locales (start with 2-3, not 20)
- [ ] Identify RTL languages in scope (Arabic, Hebrew, Farsi, Urdu)
- [ ] Document locale-specific requirements (currency, legal, cultural)
- [ ] Estimate translation workload (word count × locales)
```

### Step 2 — Extract and Externalize Strings

Move all user-facing strings from source code to translation files:

```javascript
// BEFORE: Hardcoded strings (BAD)
function renderUserProfile(user) {
  return `
    <h1>Welcome, ${user.name}!</h1>
    <p>Email: ${user.email}</p>
    <p>Member since ${user.joinDate}</p>
    <button>Delete Account</button>
  `;
}

// AFTER: Externalized strings (GOOD)
import { t } from 'i18next';

function renderUserProfile(user) {
  return `
    <h1>${t('profile.welcome', { name: user.name })}</h1>
    <p>${t('profile.email')}: ${user.email}</p>
    <p>${t('profile.memberSince', { date: formatDate(user.joinDate) })}</p>
    <button>${t('profile.deleteAccount')}</button>
  `;
}
```

### Step 3 — Set Up Translation File Structure

Organize translations hierarchically for maintainability:

```
src/
  locales/
    en/
      common.json       # Shared strings: buttons, labels, navigation
      auth.json          # Authentication-related strings
      profile.json       # User profile strings
      errors.json        # Error messages
      validation.json    # Form validation messages
    ar/
      common.json
      auth.json
      profile.json
      errors.json
      validation.json
    zh-CN/
      common.json
      auth.json
      profile.json
      errors.json
      validation.json
    fa/
      common.json
      auth.json
      profile.json
      errors.json
      validation.json
```

### Step 4 — Configure i18n Framework

```javascript
// i18n.config.js — i18next configuration (React/Node.js)

import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import Backend from 'i18next-http-backend';

i18n
  .use(Backend)
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: 'en',
    debug: process.env.NODE_ENV === 'development',
    
    // Namespace configuration
    ns: ['common', 'auth', 'profile', 'errors', 'validation'],
    defaultNS: 'common',
    
    // Interpolation settings
    interpolation: {
      escapeValue: false, // React already escapes
      format: (value, format, lng) => {
        if (format === 'number') return new Intl.NumberFormat(lng).format(value);
        if (format === 'currency') return new Intl.NumberFormat(lng, {
          style: 'currency',
          currency: getCurrencyForLocale(lng),
        }).format(value);
        if (format === 'date') return new Intl.DateTimeFormat(lng).format(new Date(value));
        return value;
      },
    },
    
    // Pluralization
    pluralSeparator: '_',
    contextSeparator: '_',
    
    // Detection order
    detection: {
      order: ['querystring', 'localStorage', 'navigator', 'htmlTag'],
      lookupQuerystring: 'lng',
      lookupLocalStorage: 'i18n_lang',
      caches: ['localStorage'],
    },
  });

export default i18n;
```

### Step 5 — Implement Locale-Aware Formatting

Use the `Intl` API for production-grade locale-aware formatting:

```javascript
// formatters.js — Locale-aware formatting utilities

/**
 * Format a number according to the user's locale.
 * Examples: 1234567.89 → "1,234,567.89" (en), "1.234.567,89" (de), "١٬٢٣٤٬٥٦٧٫٨٩" (ar)
 */
export function formatNumber(value, locale, options = {}) {
  return new Intl.NumberFormat(locale, options).format(value);
}

/**
 * Format currency according to locale.
 * Examples: $1,234.56 (en-US), €1.234,56 (de-DE), ¥1,234 (ja-JP)
 */
export function formatCurrency(value, locale, currency) {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency,
  }).format(value);
}

/**
 * Format date/time according to locale.
 * Examples: 12/31/2024 (en-US), 31/12/2024 (en-GB), 2024年12月31日 (zh-CN)
 */
export function formatDate(value, locale, options = {}) {
  const defaultOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  };
  return new Intl.DateTimeFormat(locale, { ...defaultOptions, ...options }).format(
    new Date(value)
  );
}

/**
 * Format relative time (e.g., "3 hours ago", "in 2 days").
 */
export function formatRelativeTime(value, locale, unit) {
  const rtf = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });
  return rtf.format(value, unit);
}

/**
 * Sort strings in locale-aware order.
 */
export function localeSort(arr, locale) {
  return [...arr].sort((a, b) => a.localeCompare(b, locale));
}

/**
 * Get the display name of a language in the user's language.
 * Example: getLanguageName('ar', 'en') → "Arabic"
 *          getLanguageName('ar', 'ar') → "العربية"
 */
export function getLanguageName(code, inLocale) {
  const displayNames = new Intl.DisplayNames([inLocale], { type: 'language' });
  return displayNames.of(code);
}


// --- Usage Examples ---
console.log(formatNumber(1234567.89, 'en-US'));      // "1,234,567.89"
console.log(formatNumber(1234567.89, 'de-DE'));      // "1.234.567,89"
console.log(formatNumber(1234567.89, 'ar-SA'));       // "١٬٢٣٤٬٥٦٧٫٨٩"

console.log(formatCurrency(1234.56, 'en-US', 'USD')); // "$1,234.56"
console.log(formatCurrency(1234.56, 'de-DE', 'EUR')); // "1.234,56 €"
console.log(formatCurrency(1234.56, 'ja-JP', 'JPY')); // "￥1,234"

console.log(formatDate(new Date('2024-12-31'), 'en-US')); // "December 31, 2024"
console.log(formatDate(new Date('2024-12-31'), 'zh-CN')); // "2024年12月31日"

console.log(formatRelativeTime(-3, 'en', 'hour'));   // "3 hours ago"
console.log(formatRelativeTime(2, 'en', 'day'));     // "in 2 days"
```

### Step 6 — RTL Support

Implement bidirectional text support for RTL languages:

```css
/* RTL layout support */

/* Base direction switching */
[dir="rtl"] {
  direction: rtl;
  text-align: right;
}

[dir="ltr"] {
  direction: ltr;
  text-align: left;
}

/* Logical property alternatives (replaces margin-left/margin-right) */
.sidebar {
  margin-inline-start: 1rem;  /* Replaces margin-left */
  margin-inline-end: 2rem;    /* Replaces margin-right */
  padding-inline-start: 1rem;
  padding-inline-end: 1rem;
}

/* Logical float replacement */
.card-thumbnail {
  float: inline-start;  /* Replaces float: left */
}

/* Flexbox and Grid are naturally direction-aware */
.container {
  display: flex;
  direction: inherit;  /* Inherits from parent [dir] */
}

/* Icon direction flipping for RTL */
[dir="rtl"] .icon-back {
  transform: scaleX(-1);
}

[dir="rtl"] .dropdown-arrow {
  transform: scaleX(-1);
}

/* Ensure mixed LTR/RTL content displays correctly */
.bidi-text {
  unicode-bidi: plaintext;
}

/* Arabic/Persian numeral override */
[dir="rtl"] .preserve-ltr-numbers {
  unicode-bidi: embed;
  direction: ltr;
}
```

```javascript
// RTL-aware component utilities

/**
 * Get the appropriate text alignment for the current locale.
 */
export function getTextAlign(locale) {
  const rtlLocales = ['ar', 'fa', 'he', 'ur', 'ps', 'sd', 'yi'];
  const lang = locale.split('-')[0];
  return rtlLocales.includes(lang) ? 'right' : 'left';
}

/**
 * Get the appropriate "start" direction for the current locale.
 */
export function getInlineDirection(locale) {
  const rtlLocales = ['ar', 'fa', 'he', 'ur', 'ps', 'sd', 'yi'];
  const lang = locale.split('-')[0];
  return rtlLocales.includes(lang) ? 'right' : 'left';
}

/**
 * Flip an icon path for RTL display.
 */
export function flipIconForRTL(iconPath, locale) {
  const rtlLocales = ['ar', 'fa', 'he', 'ur'];
  if (!rtlLocales.includes(locale.split('-')[0])) return iconPath;
  return `<g transform="scale(-1,1) translate(-${iconPath.width},0)">${iconPath}</g>`;
}

/**
 * Set document direction based on locale.
 */
export function setDocumentDirection(locale) {
  const rtlLocales = ['ar', 'fa', 'he', 'ur', 'ps', 'sd', 'yi'];
  const lang = locale.split('-')[0];
  const dir = rtlLocales.includes(lang) ? 'rtl' : 'ltr';
  document.documentElement.setAttribute('dir', dir);
  document.documentElement.setAttribute('lang', locale);
}
```

### Step 7 — Pluralization Rules

Implement complex pluralization for languages with multiple plural forms:

```javascript
// pluralization.js — ICU MessageFormat-based pluralization

/**
 * English pluralization rules:
 * - one: exactly 1 (1 item)
 * - other: everything else (0, 2, 3, 4, ... items)
 *
 * Arabic pluralization rules:
 * - zero: 0
 * - one: exactly 1
 * - two: exactly 2
 * - few: 3-10
 * - many: 11-99
 * - other: 100+
 *
 * Polish pluralization rules:
 * - one: 1, 21, 31, 41, ...
 * - few: 2-4, 22-24, 32-34, ...
 * - many: 5-21, 25-31, ...
 * - other: everything else
 */

// Using ICU MessageFormat syntax
const translations = {
  en: {
    items: '{count, plural, one {# item} other {# items}}',
    messages: '{count, plural, one {You have # unread message} other {You have # unread messages}}',
  },
  ar: {
    items: '{count, plural, zero {لا عناصر} one {عنصر واحد} two {عنصران} few {# عناصر} many {# عنصراً} other {# عنصر}}',
    messages: '{count, plural, zero {ليس لديك رسائل} one {لديك رسالة واحدة غير مقروءة} two {لديك رسالتان غير مقروءتان} few {لديك # رسائل غير مقروءة} many {لديك # رسالة غير مقروءة} other {لديك # رسالة غير مقروءة}}',
  },
  pl: {
    items: '{count, plural, one {# element} few {# elementy} many {# elementów} other {# elementów}}',
  },
  zh: {
    items: '{count, plural, other {# 个项目}}',  // Chinese: no plural forms
  },
  ja: {
    items: '{count, plural, other {# 個のアイテム}}',  // Japanese: no plural forms
  },
};

/**
 * Simple pluralization helper (when ICU MessageFormat is not available).
 */
function pluralize(count, forms, locale = 'en') {
  // forms: { one: '...', few: '...', many: '...', other: '...' }
  const rules = new Intl.PluralRules(locale);
  const category = rules.select(count);
  return (forms[category] || forms.other).replace('#', count);
}

// Examples
console.log(pluralize(1, { one: '# item', other: '# items' }, 'en'));
// "1 item"
console.log(pluralize(5, { one: '# item', other: '# items' }, 'en'));
// "5 items"
console.log(pluralize(1, { one: '# عنصر', other: '# عناصر' }, 'ar'));
// "1 عنصر"
console.log(pluralize(5, { one: '# عنصر', few: '# عناصر', many: '# عنصراً', other: '# عنصر' }, 'ar'));
// "5 عناصر"
```

## Advanced Techniques (7 Techniques)

### 1. Pseudo-Localization for Internationalization Testing

Pseudo-localization automatically transforms strings to simulate translated content without actual translations. It reveals hard-coded strings, layout issues, and truncation problems early.

```javascript
// pseudo-localize.js — Generate pseudo-localized strings for i18n testing

const PSEUDO_MAP = {
  'a': 'á', 'b': 'β', 'c': 'ç', 'd': 'δ', 'e': 'é',
  'f': 'ƒ', 'g': 'ϱ', 'h': 'λ', 'i': 'í', 'j': 'J',
  'k': 'κ', 'l': 'ℓ', 'm': 'm', 'n': 'ñ', 'o': 'ó',
  'p': 'ρ', 'q': 'q', 'r': 'r', 's': 'š', 't': 'τ',
  'u': 'ú', 'v': 'ν', 'w': 'ω', 'x': 'χ', 'y': 'ý',
  'z': 'ž',
};

/**
 * Convert a string to pseudo-localized form.
 * Expands text by ~30% to simulate longer translations.
 * Wraps with brackets to make untranslated strings visible.
 * Replaces ASCII chars with accented equivalents.
 */
function pseudoLocalize(str) {
  // Skip strings that look like interpolation keys or URLs
  if (str.startsWith('{{') || str.startsWith('http') || str.startsWith('/')) {
    return str;
  }
  
  let result = '';
  for (const char of str.toLowerCase()) {
    result += PSEUDO_MAP[char] || char;
  }
  
  // Add 30% padding to simulate longer translations
  const padding = '.'.repeat(Math.floor(str.length * 0.3));
  
  return `[${result}${padding}]`;
}

// Example
console.log(pseudoLocalize('Hello World'));
// "[λéℓℓó ωóρℓδ...]"
console.log(pseudoLocalize('Submit Form'));
// "[šúβmíτ ƒóρm.]"
console.log(pseudoLocalize('{{userName}}'));
// "{{userName}}" — untouched, it's a variable
```

### 2. Date/Time Format Detection and Fallback

Handle the complexity of date format preferences across cultures:

```javascript
// date-formats.js — Comprehensive locale-aware date formatting

const LOCALE_DATE_FORMATS = {
  'en-US': { date: 'MM/DD/YYYY', time: 'hh:mm A', datetime: 'MM/DD/YYYY hh:mm A' },
  'en-GB': { date: 'DD/MM/YYYY', time: 'HH:mm', datetime: 'DD/MM/YYYY HH:mm' },
  'de-DE': { date: 'DD.MM.YYYY', time: 'HH:mm', datetime: 'DD.MM.YYYY HH:mm' },
  'ja-JP': { date: 'YYYY年MM月DD日', time: 'HH:mm', datetime: 'YYYY年MM月DD日 HH:mm' },
  'zh-CN': { date: 'YYYY年MM月DD日', time: 'HH:mm', datetime: 'YYYY年MM月DD日 HH:mm' },
  'ar-SA': { date: 'DD/MM/YYYY', time: 'hh:mm', datetime: 'DD/MM/YYYY hh:mm' },
  'fa-IR': { date: 'YYYY/MM/DD', time: 'HH:mm', datetime: 'YYYY/MM/DD HH:mm' },
  'ko-KR': { date: 'YYYY년 MM월 DD일', time: 'HH:mm', datetime: 'YYYY년 MM월 DD일 HH:mm' },
  'hi-IN': { date: 'DD/MM/YYYY', time: 'HH:mm', datetime: 'DD/MM/YYYY HH:mm' },
  'pt-BR': { date: 'DD/MM/YYYY', time: 'HH:mm', datetime: 'DD/MM/YYYY HH:mm' },
  'ru-RU': { date: 'DD.MM.YYYY', time: 'HH:mm', datetime: 'DD.MM.YYYY HH:mm' },
  'th-TH': { date: 'DD/MM/YYYY', time: 'HH:mm', datetime: 'DD/MM/YYYY HH:mm' },
};

/**
 * Get the first day of week for a locale.
 * 0 = Sunday, 1 = Monday, 6 = Saturday
 */
function getFirstDayOfWeek(locale) {
  const region = locale.split('-')[1];
  const saturdayRegions = ['AE', 'BH', 'DJ', 'DZ', 'EG', 'IQ', 'JO', 'KW', 'LY', 'OM', 'QA', 'SA', 'SD', 'SY', 'YE'];
  if (saturdayRegions.includes(region)) return 6;
  
  const sundayRegions = ['US', 'CA', 'JP', 'TW', 'KR', 'PH', 'TH', 'SA', 'VE'];
  if (sundayRegions.includes(region)) return 0;
  
  return 1; // Default: Monday (most of Europe, Asia)
}

/**
 * Get locale-appropriate week header.
 */
function getWeekDays(locale) {
  const weekDays = [];
  const startDay = getFirstDayOfWeek(locale);
  
  for (let i = 0; i < 7; i++) {
    const dayIndex = (startDay + i) % 7;
    const date = new Date(2024, 0, 1 + dayIndex); // A Sunday in January 2024
    weekDays.push(new Intl.DateTimeFormat(locale, { weekday: 'short' }).format(date));
  }
  
  return weekDays;
}

// Examples
console.log(getWeekDays('en-US')); // ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
console.log(getWeekDays('ar-SA')); // ['سبت', 'أحد', 'اثنين', ...]
console.log(getWeekDays('zh-CN')); // ['日', '一', '二', '三', '四', '五', '六']
```

### 3. Locale-Aware Number Parsing

Handle the complexity of parsing numbers across different locale conventions:

```javascript
// number-parsing.js — Parse numbers from different locales

/**
 * Parse a locale-formatted number string into a JavaScript number.
 * Handles: grouping separators, decimal separators, currency symbols,
 * negative numbers, and Arabic-Indic digits.
 */
function parseLocaleNumber(str, locale = navigator.language) {
  // Remove currency symbols and whitespace
  let cleaned = str.replace(/[\s$\u00a0\u200b]/g, '');
  
  // Remove currency codes and symbols at start/end
  cleaned = cleaned.replace(/^[A-Z]{3}\s*/, '');
  cleaned = cleaned.replace(/\s*[A-Z]{3}$/, '');
  cleaned = cleaned.replace(/^[£€¥₹руб]/, '');
  cleaned = cleaned.replace(/[£€¥₹руб]$/, '');
  
  // Convert Arabic-Indic digits to Western Arabic
  cleaned = cleaned.replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660));
  // Convert Eastern Arabic-Indic digits
  cleaned = cleaned.replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06F0));
  
  // Determine grouping and decimal separators from locale
  const sample = new Intl.NumberFormat(locale).format(1234567.89);
  const groupingChar = sample.includes('.') && sample.includes(',')
    ? (sample.indexOf('.') < sample.indexOf(',') ? '.' : ',')
    : (sample.includes(',') ? ',' : null);
  const decimalChar = sample.includes('.') ? '.' : (sample.includes(',') ? ',' : null);
  
  // Remove grouping separators
  if (groupingChar) {
    cleaned = cleaned.split(groupingChar).join('');
  }
  
  // Replace locale decimal separator with JavaScript decimal point
  if (decimalChar && decimalChar !== '.') {
    cleaned = cleaned.replace(decimalChar, '.');
  }
  
  return parseFloat(cleaned);
}


// Examples
console.log(parseLocaleNumber('1,234,567.89', 'en-US'));  // 1234567.89
console.log(parseLocaleNumber('1.234.567,89', 'de-DE'));  // 1234567.89
console.log(parseLocaleNumber('١٬٢٣٤٬٥٦٧٫٨٩', 'ar-SA')); // 1234567.89
console.log(parseLocaleNumber('۱٬۲۳۴٬۵۶۷٫۸۹', 'fa-IR')); // 1234567.89
console.log(parseLocaleNumber('1 234 567,89', 'fr-FR'));  // 1234567.89
console.log(parseLocaleNumber('$1,234.56', 'en-US'));      // 1234.56
console.log(parseLocaleNumber('€1.234,56', 'de-DE'));      // 1234.56
```

### 4. Address Format Localization

Different countries have different address formats:

```javascript
// address-formats.js — Locale-aware address formatting

const ADDRESS_FORMATS = {
  'US': {
    format: (a) => `${a.name}\n${a.street}\n${a.city}, ${a.state} ${a.zip}\n${a.country}`,
    fields: ['name', 'street', 'city', 'state', 'zip'],
    postalCode: { label: 'ZIP Code', pattern: /^\d{5}(-\d{4})?$/ },
  },
  'GB': {
    format: (a) => `${a.name}\n${a.street}\n${a.city}\n${a.postcode}\n${a.country}`,
    fields: ['name', 'street', 'city', 'postcode'],
    postalCode: { label: 'Postcode', pattern: /^[A-Z]{1,2}\d[A-Z\d]?\s*\d[A-Z]{2}$/i },
  },
  'DE': {
    format: (a) => `${a.name}\n${a.street}\n${a.postalCode} ${a.city}\n${a.country}`,
    fields: ['name', 'street', 'postalCode', 'city'],
    postalCode: { label: 'PLZ', pattern: /^\d{5}$/ },
  },
  'JP': {
    format: (a) => `${a.country}\n〒${a.postalCode}\n${a.prefecture}${a.city}\n${a.street}\n${a.name}`,
    fields: ['name', 'postalCode', 'prefecture', 'city', 'street'],
    postalCode: { label: '郵便番号', pattern: /^\d{3}-?\d{4}$/ },
    order: 'country-first',
  },
  'CN': {
    format: (a) => `${a.country}\n${a.postalCode}\n${a.province}${a.city}${a.district}\n${a.street}\n${a.name}`,
    fields: ['name', 'postalCode', 'province', 'city', 'district', 'street'],
    postalCode: { label: '邮编', pattern: /^\d{6}$/ },
    order: 'country-first',
  },
  'KR': {
    format: (a) => `${a.country}\n${a.postalCode}\n${a.city} ${a.district}\n${a.street}\n${a.name}`,
    fields: ['name', 'postalCode', 'city', 'district', 'street'],
    postalCode: { label: '우편번호', pattern: /^\d{5}$/ },
    order: 'country-first',
  },
  'SA': {
    format: (a) => `${a.name}\n${a.street}\n${a.district}\n${a.city} ${a.postalCode}\n${a.country}`,
    fields: ['name', 'street', 'district', 'city', 'postalCode'],
    postalCode: { label: 'الرمز البريدي', pattern: /^\d{5}(-\d{5})?$/ },
    order: 'name-first',
  },
};

/**
 * Format an address according to the target country's conventions.
 */
function formatAddress(address, countryCode) {
  const format = ADDRESS_FORMATS[countryCode];
  if (!format) {
    // Fallback: generic format
    return Object.values(address).filter(Boolean).join('\n');
  }
  return format.format(address);
}

/**
 * Get address form field order for a country.
 */
function getAddressFields(countryCode) {
  return ADDRESS_FORMATS[countryCode]?.fields || ['name', 'street', 'city', 'postalCode', 'country'];
}
```

### 5. Unicode-Aware String Operations

Handle Unicode complexity for i18n-correct string operations:

```javascript
// unicode-utils.js — Unicode-aware string utilities for i18n

/**
 * Get the display length of a string, accounting for emoji,
 * combining characters, and zero-width joiners.
 */
function displayLength(str) {
  // Use the Intl.Segmenter API for accurate grapheme cluster counting
  if (typeof Intl.Segmenter !== 'undefined') {
    const segmenter = new Intl.Segmenter('en', { granularity: 'grapheme' });
    return [...segmenter.segment(str)].length;
  }
  // Fallback: spread operator (handles basic emoji, not all)
  return [...str].length;
}

/**
 * Truncate a string at a grapheme cluster boundary.
 */
function truncateGraphemes(str, maxLength) {
  if (typeof Intl.Segmenter !== 'undefined') {
    const segmenter = new Intl.Segmenter('en', { granularity: 'grapheme' });
    const segments = [...segmenter.segment(str)];
    if (segments.length <= maxLength) return str;
    return segments.slice(0, maxLength).map(s => s.segment).join('') + '…';
  }
  // Fallback: use spread operator
  const chars = [...str];
  if (chars.length <= maxLength) return str;
  return chars.slice(0, maxLength).join('') + '…';
}

/**
 * Locale-aware string comparison using Collator.
 */
function localeCompare(a, b, locale = navigator.language) {
  return a.localeCompare(b, locale, { sensitivity: 'base' });
}

/**
 * Sort an array of strings in locale-aware order.
 */
function localeSort(arr, locale = navigator.language, options = {}) {
  const collator = new Intl.Collator(locale, options);
  return [...arr].sort(collator.compare);
}

/**
 * Normalize Unicode strings to NFC form (composed).
 * Critical for consistent string comparison across locales.
 */
function normalize(str) {
  return str.normalize('NFC');
}

// Examples
console.log(displayLength('Hello'));           // 5
console.log(displayLength('مرحبا'));           // 5
console.log(displayLength('🎉🎊🎈'));         // 3
console.log(displayLength('é'));               // 1 (composed) or 2 (decomposed)

console.log(truncateGraphemes('مرحبا بالعالم', 5)); // 'مرحبا…'

const germanWords = ['Öl', 'über', 'Apfel', 'Ärger'];
console.log(localeSort(germanWords, 'de'));
// ['Apfel', 'Ärger', ' Öl', 'über'] (German sorting ignores umlauts)
console.log(localeSort(germanWords, 'de', { sensitivity: 'base' }));
// With base sensitivity: Ä and A are equal
```

### 6. Translation Quality Assurance Automation

Automated checks to catch common translation issues:

```python
# i18n_lint.py — Automated i18n quality checks

import json
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

class I18nLinter:
    """
    Automated linting for internationalization files.
    Catches common issues: missing translations, inconsistent interpolation,
    RTL/LTR conflicts, and formatting problems.
    """
    
    def __init__(self, base_locale: str = 'en'):
        self.base_locale = base_locale
        self.issues = []
    
    def lint_directory(self, locales_dir: str) -> List[Dict]:
        """Lint all translation files in a directory."""
        base_path = Path(locales_dir)
        base_files = self._load_locale(base_path, self.base_locale)
        
        for locale_dir in base_path.iterdir():
            if not locale_dir.is_dir() or locale_dir.name == self.base_locale:
                continue
            
            locale_files = self._load_locale(locale_dir, locale_dir.name)
            self._check_missing_keys(base_files, locale_files, locale_dir.name)
            self._check_extra_keys(base_files, locale_files, locale_dir.name)
            self._check_interpolation_args(base_files, locale_files, locale_dir.name)
            self._check_empty_translations(locale_files, locale_dir.name)
            self._check_untranslated_content(base_files, locale_files, locale_dir.name)
        
        return self.issues
    
    def _load_locale(self, path: Path, locale: str) -> Dict[str, str]:
        """Load all JSON translation files for a locale."""
        result = {}
        for json_file in path.glob('*.json'):
            namespace = json_file.stem
            data = json.loads(json_file.read_text(encoding='utf-8'))
            for key, value in self._flatten(data).items():
                result[f"{namespace}.{key}"] = value
        return result
    
    def _flatten(self, data: dict, prefix: str = '') -> dict:
        """Flatten nested dict to dot-notation keys."""
        result = {}
        for key, value in data.items():
            full_key = f"{prefix}.{key}" if prefix else key
            if isinstance(value, dict):
                result.update(self._flatten(value, full_key))
            else:
                result[full_key] = str(value)
        return result
    
    def _check_missing_keys(self, base: Dict, target: Dict, locale: str):
        """Check for translation keys present in base but missing in target."""
        missing = set(base.keys()) - set(target.keys())
        for key in sorted(missing):
            self.issues.append({
                'severity': 'ERROR',
                'locale': locale,
                'key': key,
                'message': f'Missing translation key: {key}',
            })
    
    def _check_extra_keys(self, base: Dict, target: Dict, locale: str):
        """Check for translation keys present in target but not in base (unused)."""
        extra = set(target.keys()) - set(base.keys())
        for key in sorted(extra):
            self.issues.append({
                'severity': 'WARNING',
                'locale': locale,
                'key': key,
                'message': f'Extra key not in base locale: {key}',
            })
    
    def _check_interpolation_args(self, base: Dict, target: Dict, locale: str):
        """Check that interpolation variables match between base and target."""
        interpolation_pattern = re.compile(r'\{\{(\w+)\}\}|%\{(\w+)\}|:__(\w+)__')
        
        for key in set(base.keys()) & set(target.keys()):
            base_vars = set(self._extract_vars(base[key], interpolation_pattern))
            target_vars = set(self._extract_vars(target[key], interpolation_pattern))
            
            missing = base_vars - target_vars
            extra = target_vars - base_vars
            
            if missing:
                self.issues.append({
                    'severity': 'ERROR',
                    'locale': locale,
                    'key': key,
                    'message': f'Missing interpolation variables: {missing}',
                })
            if extra:
                self.issues.append({
                    'severity': 'WARNING',
                    'locale': locale,
                    'key': key,
                    'message': f'Extra interpolation variables: {extra}',
                })
    
    def _extract_vars(self, text: str, pattern) -> list:
        """Extract interpolation variable names from a string."""
        return [match for groups in pattern.findall(text) for match in groups if match]
    
    def _check_empty_translations(self, translations: Dict, locale: str):
        """Check for empty or whitespace-only translations."""
        for key, value in translations.items():
            if not value.strip():
                self.issues.append({
                    'severity': 'ERROR',
                    'locale': locale,
                    'key': key,
                    'message': 'Empty translation value',
                })
    
    def _check_untranslated_content(self, base: Dict, target: Dict, locale: str):
        """Check if translated values are identical to base (possibly untranslated)."""
        for key in set(base.keys()) & set(target.keys()):
            if base[key] == target[key] and not re.match(r'^[\d\s\W]+$', base[key]):
                # Skip numeric-only strings, URLs, etc.
                if not base[key].startswith(('http', '/', '{{', '%{')):
                    self.issues.append({
                        'severity': 'INFO',
                        'locale': locale,
                        'key': key,
                        'message': f'Translation identical to base locale — may be untranslated',
                    })


# Usage
linter = I18nLinter(base_locale='en')
issues = linter.lint_directory('src/locales')
for issue in issues:
    print(f"[{issue['severity']}] {issue['locale']}: {issue['message']} ({issue['key']})")
```

### 7. Locale Detection and Fallback Chain

Robust locale detection with multiple fallback sources:

```javascript
// locale-detection.js — Multi-source locale detection

/**
 * Detect the user's preferred locale using multiple sources.
 * Returns a fallback chain: [exact match, language only, default].
 *
 * Sources (in priority order):
 * 1. URL query parameter (?lang=ar)
 * 2. Cookie (i18n_lang=ar-SA)
 * 3. localStorage (i18n_lang=ar-SA)
 * 4. Accept-Language header (ar-SA,ar;q=0.9,en;q=0.8)
 * 5. Browser/OS language setting
 * 6. Fallback to default locale
 */
function detectLocale(supportedLocales, defaultLocale = 'en') {
  // 1. Check URL query parameter
  const urlParams = new URLSearchParams(window.location.search);
  const urlLang = urlParams.get('lang') || urlParams.get('locale');
  if (urlLang && isSupported(urlLang, supportedLocales)) {
    return urlLang;
  }
  
  // 2. Check cookie
  const cookieLang = getCookie('i18n_lang');
  if (cookieLang && isSupported(cookieLang, supportedLocales)) {
    return cookieLang;
  }
  
  // 3. Check localStorage
  const storedLang = localStorage.getItem('i18n_lang');
  if (storedLang && isSupported(storedLang, supportedLocales)) {
    return storedLang;
  }
  
  // 4. Check Accept-Language header
  const browserLocales = getBrowserLocales();
  for (const browserLocale of browserLocales) {
    if (isSupported(browserLocale, supportedLocales)) {
      return browserLocale;
    }
    // Try language-only match (e.g., "ar" matches "ar-SA")
    const langOnly = browserLocale.split('-')[0];
    const match = supportedLocales.find(l => l.startsWith(langOnly));
    if (match) return match;
  }
  
  // 5. Fallback
  return defaultLocale;
}

function getBrowserLocales() {
  if (navigator.languages) return navigator.languages;
  if (navigator.language) return [navigator.language];
  return [];
}

function getCookie(name) {
  const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
  return match ? decodeURIComponent(match[2]) : null;
}

function isSupported(locale, supportedLocales) {
  return supportedLocales.includes(locale) ||
         supportedLocales.some(l => l.startsWith(locale.split('-')[0]));
}

// Example
const supported = ['en', 'en-US', 'en-GB', 'ar', 'ar-SA', 'fa', 'fa-IR',
                    'zh', 'zh-CN', 'zh-TW', 'ja', 'ko', 'de', 'de-DE',
                    'fr', 'fr-FR', 'es', 'es-ES', 'pt-BR'];

const detected = detectLocale(supported);
console.log(`Detected locale: ${detected}`);
```

## Common Patterns

### Pattern 1 — Translation Key Naming Convention

```javascript
// Consistent key naming: {namespace}.{context}.{entity}.{action}
// Example structure:
const translationKeys = {
  // Navigation
  'nav.home': 'Home',
  'nav.about': 'About Us',
  'nav.contact': 'Contact',
  
  // Auth module
  'auth.login.title': 'Sign In',
  'auth.login.email.label': 'Email Address',
  'auth.login.email.placeholder': 'Enter your email',
  'auth.login.password.label': 'Password',
  'auth.login.submit': 'Sign In',
  'auth.login.error.invalidCredentials': 'Invalid email or password',
  'auth.login.error.tooManyAttempts': 'Too many attempts. Please try again in {{minutes}} minutes.',
  
  // Profile module
  'profile.welcome': 'Welcome, {{name}}!',
  'profile.memberSince': 'Member since {{date}}',
  'profile.deleteAccount.confirm': 'Are you sure you want to delete your account? This action cannot be undone.',
  'profile.deleteAccount.success': 'Your account has been deleted.',
  
  // Common
  'common.buttons.save': 'Save',
  'common.buttons.cancel': 'Cancel',
  'common.buttons.delete': 'Delete',
  'common.buttons.confirm': 'Confirm',
  'common.buttons.loading': 'Loading...',
  'common.errors.generic': 'Something went wrong. Please try again.',
  'common.errors.network': 'Network error. Please check your connection.',
  'common.validation.required': '{{field}} is required',
  'common.validation.email': 'Please enter a valid email address',
};
```

### Pattern 2 — Lazy Loading Translations

Load translation files on demand to reduce initial bundle size:

```javascript
// lazy-load-translations.js

const loadedNamespaces = new Set();

/**
 * Dynamically load a translation namespace.
 * Caches loaded namespaces to avoid re-fetching.
 */
async function loadNamespace(locale, namespace) {
  const key = `${locale}:${namespace}`;
  if (loadedNamespaces.has(key)) return;
  
  try {
    const translations = await import(
      `./locales/${locale}/${namespace}.json`
    );
    
    i18n.addResourceBundle(locale, namespace, translations.default, true, true);
    loadedNamespaces.add(key);
  } catch (error) {
    console.error(`Failed to load translation: ${key}`, error);
    
    // Fallback to base locale
    if (locale !== 'en') {
      await loadNamespace('en', namespace);
    }
  }
}

/**
 * React hook for lazy-loading translations.
 */
function useTranslation(namespace) {
  const { i18n, t, ready } = useTranslation(namespace);
  
  useEffect(() => {
    loadNamespace(i18n.language, namespace);
  }, [i18n.language, namespace]);
  
  return { t, ready };
}

/**
 * Preload common namespaces for performance.
 */
async function preloadTranslations(locale) {
  const commonNamespaces = ['common', 'errors', 'navigation'];
  await Promise.all(
    commonNamespaces.map(ns => loadNamespace(locale, ns))
  );
}
```

### Pattern 3 — Inline RTL/LTR Switching

```javascript
// rtl-switching.js — React component for RTL-aware layouts

import { useEffect, useState } from 'react';

function RTLProvider({ locale, children }) {
  const [direction, setDirection] = useState('ltr');
  
  useEffect(() => {
    const rtlLocales = ['ar', 'fa', 'he', 'ur', 'ps', 'sd', 'yi'];
    const lang = locale.split('-')[0];
    const newDir = rtlLocales.includes(lang) ? 'rtl' : 'ltr';
    
    setDirection(newDir);
    document.documentElement.setAttribute('dir', newDir);
    document.documentElement.setAttribute('lang', locale);
    
    // Cleanup
    return () => {
      document.documentElement.removeAttribute('dir');
    };
  }, [locale]);
  
  return (
    <div dir={direction} lang={locale}>
      {children}
    </div>
  );
}

/**
 * Hook to get layout-aware margins/paddings.
 */
function useLayoutDirection() {
  const dir = document.documentElement.getAttribute('dir') || 'ltr';
  
  return {
    marginStart: dir === 'rtl' ? 'marginRight' : 'marginLeft',
    marginEnd: dir === 'rtl' ? 'marginLeft' : 'marginRight',
    paddingStart: dir === 'rtl' ? 'paddingRight' : 'paddingLeft',
    paddingEnd: dir === 'rtl' ? 'paddingLeft' : 'paddingRight',
    textAlign: dir === 'rtl' ? 'right' : 'left',
    floatStart: dir === 'rtl' ? 'right' : 'left',
    floatEnd: dir === 'rtl' ? 'left' : 'right',
  };
}
```

### Pattern 4 — Pluralization with ICU MessageFormat

```javascript
// icu-pluralization.js — Full ICU MessageFormat integration

import { MessageFormat } from '@messageformat/core';

/**
 * Create a pluralized message formatter.
 */
function createFormatter(locale) {
  return new MessageFormat(locale);
}

// Example usage with MessageFormat
const formatter = createFormatter('en');

const message = formatter.compile(
  '{count, plural, one {You have # new message} other {You have # new messages}}'
);

console.log(message({ count: 1 }));  // "You have 1 new message"
console.log(message({ count: 5 }));  // "You have 5 new messages"

// Arabic with 6 plural forms
const arFormatter = createFormatter('ar');
const arMessage = arFormatter.compile(
  '{count, plural, zero {لا رسائل جديدة} one {رسالة جديدة واحدة} two {رسالتان جديدتان} few {# رسائل جديدة} many {# رسالة جديدة} other {# رسالة جديدة}}'
);

console.log(arMessage({ count: 0 }));  // "لا رسائل جديدة"
console.log(arMessage({ count: 1 }));  // "رسالة جديدة واحدة"
console.log(arMessage({ count: 2 }));  // "رسالتان جديدتان"
console.log(arMessage({ count: 5 }));  // "5 رسائل جديدة"
console.log(arMessage({ count: 11 })); // "11 رسالة جديدة"
console.log(arMessage({ count: 100 })); // "100 رسالة جديدة"
```

### Pattern 5 — Number and Currency Formatting Patterns

```javascript
// number-currency-patterns.js

/**
 * Common locale-specific number formatting patterns.
 * Use Intl.NumberFormat for production; these are reference patterns.
 */
const NUMBER_PATTERNS = {
  // Grouping separator, decimal separator
  'en-US': { group: ',', decimal: '.', currency: '$', position: 'before' },
  'en-GB': { group: ',', decimal: '.', currency: '£', position: 'before' },
  'de-DE': { group: '.', decimal: ',', currency: '€', position: 'after' },
  'fr-FR': { group: ' ', decimal: ',', currency: '€', position: 'after' },
  'ja-JP': { group: ',', decimal: '.', currency: '¥', position: 'before' },
  'zh-CN': { group: ',', decimal: '.', currency: '¥', position: 'before' },
  'ko-KR': { group: ',', decimal: '.', currency: '₩', position: 'before' },
  'ar-SA': { group: '٬', decimal: '٫', currency: 'ر.س', position: 'after' },
  'fa-IR': { group: '٬', decimal: '٫', currency: '﷼', position: 'after' },
  'hi-IN': { group: ',', decimal: '.', currency: '₹', position: 'before' },
  'pt-BR': { group: '.', decimal: ',', currency: 'R$', position: 'before' },
  'ru-RU': { group: ' ', decimal: ',', currency: '₽', position: 'after' },
  'th-TH': { group: ',', decimal: '.', currency: '฿', position: 'before' },
  'tr-TR': { group: '.', decimal: ',', currency: '₺', position: 'after' },
};

/**
 * Format currency using the Intl API with locale-appropriate conventions.
 */
function formatMoney(amount, locale, currencyCode) {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currencyCode,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(amount);
}

// Examples
console.log(formatMoney(1234.56, 'en-US', 'USD')); // "$1,234.56"
console.log(formatMoney(1234.56, 'de-DE', 'EUR')); // "1.234,56 €"
console.log(formatMoney(1234.56, 'ja-JP', 'JPY')); // "￥1,234"
console.log(formatMoney(1234.56, 'ar-SA', 'SAR')); // "١٬٢٣٤٫٥٦ ر.س"
console.log(formatMoney(1234.56, 'fa-IR', 'IRR')); // "۱٬۲۳۴٫۵۶﷼"
console.log(formatMoney(1234.56, 'hi-IN', 'INR')); // "₹1,234.56"
```

## Edge Cases & Pitfalls

### 1. Hardcoded Strings in Code
The most common i18n issue: strings embedded directly in source code. Always externalize user-facing text to translation files. Search for common patterns like `= "..."`, `> ... <`, and error messages to find hardcoded strings.

### 2. String Concatenation Breaking Translations
Building sentences by concatenating words breaks because word order varies across languages. English "Page 1 of 10" becomes Arabic "١٠ من ١ صفحة" (completely different order). Always use template variables with placeholders.

### 3. Pluralization Rules Mismatch
English has 2 plural forms (one/other); Arabic has 6 (zero/one/two/few/many/other); Polish has 3 (one/few/many). Using simple `count === 1 ? 'singular' : 'plural'` fails for most languages. Always use CLDR plural rules via `Intl.PluralRules`.

### 4. Date Format Confusion
MM/DD/YYYY (US) vs DD/MM/YYYY (Europe) vs YYYY-MM-DD (ISO 8601). Ambiguous formats like 01/02/2024 are interpreted differently. Use ISO 8601 for storage and `Intl.DateTimeFormat` for display.

### 5. Number Parsing Errors
Parsing "1.234" as 1234 (US) or 1.234 (Germany) depending on locale. Always parse numbers using the user's locale conventions, not hardcoded separators.

### 6. RTL Layout Breaks
Forgetting to flip directional CSS properties (margin-left, padding-right, float, text-align, border-left) when switching to RTL. Use CSS logical properties (`margin-inline-start`) instead of physical ones.

### 7. Mixed LTR/RTL Text
Numbers and English text within Arabic/Hebrew content must remain LTR. Use `unicode-bidi: plaintext` or `dir="auto"` on text containers. The Unicode Bidirectional Algorithm handles most cases, but complex nested text needs explicit direction markers.

### 8. Text Expansion in Translations
German text is typically 30% longer than English; Arabic can be 25% longer; Chinese/Japanese can be 50% shorter. UI layouts must accommodate varying text lengths. Avoid fixed-width containers for text.

### 9. Image Text in Translations
Images containing text (banners, logos, infographics) need locale-specific versions. Don't hardcode text in images; use CSS/HTML overlays or SVG with translatable text elements.

### 10. Translation Key Naming Inconsistencies
Mixing naming conventions (camelCase, snake_case, dot.notation, kebab-case) across translation files makes maintenance difficult. Establish and enforce a naming convention from day one.

### 11. Missing Fallback Translations
If a translation key is missing for a locale, the application should fall back to the base locale (usually English) gracefully. Never show raw key names to users.

### 12. Untranslated Error Messages
Error messages from third-party libraries, APIs, or system errors are often in English. Wrap all error messages through the i18n system, including those from external sources.

### 13. Timezone Ignorance
Formatting dates without considering the user's timezone leads to incorrect displays. Always store dates in UTC and convert to the user's local timezone for display.

### 14. Character Encoding Issues
Mixing UTF-8 and ASCII, or not properly encoding/decoding Unicode, causes mojibake (garbled text). Ensure the entire pipeline (database, API, frontend) uses UTF-8 consistently.

### 15. Translation File Size Bloat
Loading all translations at startup causes slow initial loads. Use lazy loading, code splitting, and namespace-based loading to minimize the initial bundle size.

### 16. Gendered Text in Translations
Many languages (Arabic, French, Hebrew, German) have grammatical gender. "You" changes based on the user's gender. Design translation keys with gender context when needed: `profile.welcome.male`, `profile.welcome.female`.

## Integration with Other Skills

| Skill | When to Combine | How |
|---|---|---|
| regex | Validating locale-specific formats (phone, postal, ID numbers) | Write locale-aware regex patterns for form validation |
| code-review | Reviewing i18n implementations | Check for hardcoded strings, missing fallbacks, RTL issues |
| database-design | Storing multilingual content | Design schema with translation tables, Unicode column types |
| front-end | Implementing i18n in UI components | RTL layouts, locale-aware components, lazy loading |
| testing | Verifying i18n correctness | Pseudo-localization testing, screenshot comparison across locales |
| accessibility | Ensuring i18n works with screen readers | ARIA labels in multiple languages, lang attribute management |
| api-design | Building locale-aware APIs | Content negotiation, locale headers, localized error messages |
| security | Protecting against locale-based attacks | Prevent locale injection, validate Accept-Language headers |

## Output Format Templates

### Template 1 — i18n Implementation Plan

```markdown
## i18n Implementation Plan: {Application Name}

### Target Locales
- Primary: {locale} ({language})
- Secondary: {locale} ({language})
- Future: {locale} ({language})

### Scope
- User-facing strings: {count}
- Translation keys: {count}
- Date formats: {list}
- Number formats: {list}
- RTL languages: {list}

### Implementation Phases
1. **Setup** ({days} days): Configure i18n framework, extract strings
2. **Translation** ({days} days): Translate to target locales
3. **Formatting** ({days} days): Implement locale-aware formatting
4. **RTL** ({days} days): Add bidirectional support
5. **Testing** ({days} days): Pseudo-localization, RTL, format testing
6. **Deployment** ({days} days): Gradual rollout by locale
```

### Template 2 — Translation File Format

```json
{
  "namespace": "{module name}",
  "locale": "{locale code}",
  "keys": {
    "path.to.key": {
      "message": "Translated text",
      "description": "Context for translators",
      "placeholders": {
        "name": { "type": "string", "example": "John" },
        "count": { "type": "number", "example": "5" }
      }
    }
  }
}
```

### Template 3 — i18n Audit Report

```markdown
## i18n Audit: {Application Name}

### Current State
- Hardcoded strings found: {count}
- Existing translations: {count}
- Missing translations: {count}
- RTL support: {Yes/No}
- Locale-aware formatting: {Partial/Complete}

### Recommendations
1. {High priority recommendation}
2. {Medium priority recommendation}
3. {Low priority recommendation}

### Estimated Effort
- String extraction: {hours}
- Translation: {hours}
- Implementation: {hours}
- Testing: {hours}
- Total: {hours}
```

### Template 4 — Agent-Friendly Structured Output

```json
{
  "i18n": {
    "target_locales": ["en", "ar", "zh-CN", "fa"],
    "rtl_locales": ["ar", "fa"],
    "translation_keys": 850,
    "hardcoded_strings": 45,
    "formatting_requirements": {
      "dates": "Intl.DateTimeFormat",
      "numbers": "Intl.NumberFormat",
      "currencies": "Intl.NumberFormat (style: currency)",
      "plurals": "Intl.PluralRules"
    },
    "estimated_effort_hours": 120,
    "priority_issues": [
      "45 hardcoded strings need extraction",
      "RTL layout not implemented",
      "No pluralization support"
    ]
  }
}
```

## Rules

1. **Externalize all user-facing strings** — Never hardcode text that users see. Use translation keys with hierarchical naming (namespace.entity.attribute).
2. **Use the ICU message format** — For pluralization, gender, and complex interpolation, use ICU MessageFormat, not string concatenation or simple conditionals.
3. **Store dates/times in UTC** — Always store in UTC and convert to local timezone only at display time. Use ISO 8601 format for storage.
4. **Use CSS logical properties** — Replace `margin-left`/`margin-right` with `margin-inline-start`/`margin-inline-end` for automatic RTL support.
5. **Test with pseudo-localization** — Before shipping translations, test with pseudo-localized strings to catch hardcoded text, layout issues, and truncation.
6. **Implement fallback chains** — Always fall back to a base locale (typically English) when a translation is missing. Never show raw key names to users.
7. **Lazy-load translation files** — Don't load all locales at startup. Load the user's locale on demand; pre-load only common namespaces.
8. **Validate translation quality** — Run automated checks for missing keys, inconsistent interpolation variables, and untranslated content.
9. **Account for text expansion** — Design UI layouts to accommodate 30-50% text expansion (German, Arabic) and 50% contraction (Chinese, Japanese).
10. **Never trust Accept-Language blindly** — Validate and sanitize the Accept-Language header; it can be spoofed and may contain unsupported locales.
11. **Use Unicode normalization** — Normalize strings to NFC form before comparison to avoid issues with equivalent but differently encoded characters.
12. **Document translation context** — Provide descriptions and screenshots for translation keys so translators understand the context and constraints.
