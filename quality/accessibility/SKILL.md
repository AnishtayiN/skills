---
name: accessibility
description: >-
  Make web applications accessible following WCAG 2.2 AA, ARIA patterns, keyboard navigation,
  and screen reader compatibility. TRIGGERS: accessibility, a11y, WCAG, screen reader, ARIA,
  keyboard navigation, color contrast, alt text, semantic HTML, accessible forms, focus management,
  skip navigation, reduced motion, axe testing, WCAG 2.2, ARIA patterns, accessible dialog,
  دسترسی‌پذیری, قابلیت دسترسی, بهینه‌سازی برای معلولین, پشتیبانی از صفحه‌خوان, کنتراست رنگ,
  无障碍, WCAG, 屏幕阅读器, ARIA, 键盘导航, 无障碍测试, 对比度, 焦点管理
priority: P1
dependencies: [testing-e2e]
conflicts: []
---

# Accessibility Skill — WCAG 2.2 AA, ARIA Patterns, Keyboard Navigation & Screen Reader Support

## Overview

Web accessibility (a11y) ensures that applications can be used by everyone, including people with visual, motor, cognitive, or auditory disabilities. Accessibility is not optional — it is a legal requirement under ADA (US), EAA (EU, effective 2025), Section 508 (federal), and AODA (Canada), and it improves UX for all users. This skill covers WCAG 2.2 AA compliance, semantic HTML fundamentals, ARIA widget patterns, keyboard navigation and focus management, screen reader compatibility, color contrast requirements, accessible forms and error handling, motion preferences, and automated testing with axe-core, Lighthouse, and Playwright. The goal is to ship applications that pass automated audits AND work with real assistive technology.

## When to Use This Skill

- Making an existing web application accessible (audit → fix → verify)
- Building new components that must be accessible from the start (dialogs, tabs, menus, carousels)
- Implementing WCAG 2.2 AA compliance for legal or regulatory requirements
- Adding keyboard navigation to custom interactive components
- Ensuring screen reader compatibility (NVDA, VoiceOver, JAWS, TalkBack)
- Setting up automated accessibility testing in CI pipelines (axe-core, Lighthouse)
- Fixing color contrast issues or adding focus indicators
- Implementing accessible form validation with live error announcements
- Adding skip navigation, landmark regions, and heading hierarchy

## When NOT to Use This Skill

- Writing application business logic (→ application code)
- Setting up CI/CD pipelines (→ ci-cd)
- Designing visual UI/UX without accessibility considerations (→ design)
- Writing E2E tests without accessibility assertions (→ testing-e2e)
- Configuring server-side accessibility (→ backend code)
- Setting up monitoring or alerting (→ monitoring-observability)
- Building mobile-native accessibility (→ mobile development)

## Workflow

### Step 1: Audit Current State

```
1. Run automated audit (axe-core, Lighthouse)
2. Manual keyboard navigation test (Tab through entire page)
3. Screen reader test (VoiceOver or NVDA)
4. Color contrast check (all text and interactive elements)
5. Document violations and prioritize by severity
```

### Step 2: Fix Foundational Issues

```
1. Replace div soup with semantic HTML (header, nav, main, article, footer)
2. Add alt text to all informative images
3. Ensure all interactive elements are keyboard accessible
4. Add visible focus indicators to all focusable elements
5. Fix heading hierarchy (no skipped levels)
```

### Step 3: Implement ARIA Patterns

```
1. Add ARIA roles, states, and properties to custom widgets
2. Implement focus management for modals and dialogs
3. Add aria-live regions for dynamic content updates
4. Ensure all form inputs have associated labels
5. Implement error announcements for form validation
```

### Step 4: Test and Verify

```
1. Run axe-core automated tests (catches ~30-40% of issues)
2. Keyboard-only navigation test (Tab, Arrow, Escape, Enter)
3. Screen reader test (all major platforms)
4. 200% zoom test (no horizontal scrolling)
5. prefers-reduced-motion test
```

## Advanced Techniques

### 1. Semantic HTML Foundation

```html
<!-- ❌ BAD: Div soup — no semantics, no accessibility -->
<div class="header">
  <div class="nav">
    <div class="nav-item" onclick="navigate('/')">Home</div>
    <div class="nav-item" onclick="navigate('/about')">About</div>
  </div>
</div>
<div class="main">
  <div class="card">
    <div class="card-title">Card Title</div>
    <div class="card-text">Card content goes here</div>
    <div class="card-action" onclick="handleAction()">Click me</div>
  </div>
  <div class="sidebar">
    <div class="widget">
      <div class="widget-title">Related</div>
    </div>
  </div>
</div>
<div class="footer">© 2025</div>

<!-- ✅ GOOD: Semantic HTML — meaningful structure, accessible by default -->
<header>
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h1>Card Title</h1>
    <p>Card content goes here</p>
    <button type="button" onclick="handleAction()">Click me</button>
  </article>

  <aside aria-label="Related content">
    <section>
      <h2>Related</h2>
      <!-- Widget content -->
    </section>
  </aside>
</main>

<footer>
  <p>© 2025</p>
</footer>

<!-- ── Landmark regions ── -->
<!-- <header>    → banner landmark -->
<!-- <nav>       → navigation landmark -->
<!-- <main>      → main landmark (only one per page) -->
<!-- <aside>     → complementary landmark -->
<!-- <footer>    → contentinfo landmark -->
<!-- <form>      → form landmark -->
<!-- <section>   → region landmark (needs accessible name) -->

<!-- ── Heading hierarchy (never skip levels) ── -->
<h1>Page Title</h1>          <!-- One h1 per page -->
  <h2>Section</h2>            <!-- Major sections -->
    <h3>Subsection</h3>       <!-- Sub-sections -->
    <h3>Subsection</h3>
  <h2>Another Section</h2>
    <h3>Detail</h3>
```

### 2. Focus Management and Keyboard Navigation

```html
<!-- ── Skip Navigation Link ── -->
<body>
  <a href="#main-content" class="skip-link">Skip to main content</a>
  <header>...</header>
  <main id="main-content" tabindex="-1">...</main>
</body>

<style>
.skip-link {
  position: absolute;
  top: -100%;
  left: 50%;
  transform: translateX(-50%);
  background: #000;
  color: #fff;
  padding: 12px 24px;
  border-radius: 0 0 8px 8px;
  z-index: 10000;
  font-size: 1rem;
  text-decoration: none;
  transition: top 0.2s;
}

.skip-link:focus {
  top: 0;
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}
</style>

<!-- ── Focus order must follow visual order ── -->
<!-- tabindex="0"  → adds to natural tab order -->
<!-- tabindex="-1" → focusable programmatically only -->
<!-- tabindex=">0" → AVOID: creates unpredictable tab order -->

<!-- ── Focus trap for modal dialogs ── -->
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
  aria-describedby="dialog-desc"
>
  <h2 id="dialog-title">Confirm Deletion</h2>
  <p id="dialog-desc">This action cannot be undone.</p>
  <button type="button">Cancel</button>
  <button type="button" class="danger">Delete</button>
</div>

<!-- ── Focus indicator requirements (WCAG 2.2) ── -->
<style>
/* Visible focus indicator for all focusable elements */
:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
  border-radius: 2px;
}

/* Never remove focus outlines without replacement */
:focus { outline: none; } /* ❌ BAD — removes all focus visibility */
</style>
```

```javascript
// ── Focus Trap Implementation ──

function createFocusTrap(container) {
  const FOCUSABLE_SELECTORS = [
    'a[href]:not([disabled]):not([tabindex="-1"])',
    'button:not([disabled]):not([tabindex="-1"])',
    'textarea:not([disabled]):not([tabindex="-1"])',
    'input:not([disabled]):not([tabindex="-1"])',
    'select:not([disabled]):not([tabindex="-1"])',
    '[tabindex="0"]',
  ].join(', ');

  let previouslyFocusedElement = null;

  function getFocusableElements() {
    return Array.from(container.querySelectorAll(FOCUSABLE_SELECTORS))
      .filter(el => el.offsetParent !== null); // Filter hidden elements
  }

  function activate() {
    previouslyFocusedElement = document.activeElement;

    const focusable = getFocusableElements();
    if (focusable.length > 0) {
      focusable[0].focus();
    }

    container.addEventListener('keydown', handleKeyDown);
  }

  function deactivate() {
    container.removeEventListener('keydown', handleKeyDown);
    if (previouslyFocusedElement) {
      previouslyFocusedElement.focus();
    }
  }

  function handleKeyDown(e) {
    if (e.key !== 'Tab') {
      // Handle Escape key
      if (e.key === 'Escape') {
        deactivate();
        return;
      }
      return;
    }

    const focusable = getFocusableElements();
    const firstElement = focusable[0];
    const lastElement = focusable[focusable.length - 1];

    if (e.shiftKey) {
      // Shift+Tab: wrap from first to last
      if (document.activeElement === firstElement) {
        e.preventDefault();
        lastElement.focus();
      }
    } else {
      // Tab: wrap from last to first
      if (document.activeElement === lastElement) {
        e.preventDefault();
        firstElement.focus();
      }
    }
  }

  return { activate, deactivate };
}

// ── Arrow Key Navigation for Menus/Tabs ──

function initArrowKeyNavigation(container, itemSelector) {
  container.addEventListener('keydown', (e) => {
    const items = Array.from(container.querySelectorAll(itemSelector));
    const currentIndex = items.indexOf(document.activeElement);

    if (currentIndex === -1) return;

    switch (e.key) {
      case 'ArrowDown':
      case 'ArrowRight':
        e.preventDefault();
        items[(currentIndex + 1) % items.length].focus();
        break;

      case 'ArrowUp':
      case 'ArrowLeft':
        e.preventDefault();
        items[(currentIndex - 1 + items.length) % items.length].focus();
        break;

      case 'Home':
        e.preventDefault();
        items[0].focus();
        break;

      case 'End':
        e.preventDefault();
        items[items.length - 1].focus();
        break;
    }
  });
}
```

### 3. ARIA Widget Patterns

```html
<!-- ── Tab Panel ── -->
<div role="tablist" aria-label="Settings" aria-orientation="horizontal">
  <button
    role="tab"
    id="tab-general"
    aria-selected="true"
    aria-controls="panel-general"
    tabindex="0"
  >
    General
  </button>
  <button
    role="tab"
    id="tab-security"
    aria-selected="false"
    aria-controls="panel-security"
    tabindex="-1"
  >
    Security
  </button>
  <button
    role="tab"
    id="tab-notifications"
    aria-selected="false"
    aria-controls="panel-notifications"
    tabindex="-1"
  >
    Notifications
  </button>
</div>

<div
  role="tabpanel"
  id="panel-general"
  aria-labelledby="tab-general"
  tabindex="0"
>
  <h3>General Settings</h3>
  <p>Configure your general preferences here.</p>
</div>

<div
  role="tabpanel"
  id="panel-security"
  aria-labelledby="tab-security"
  tabindex="0"
  hidden
>
  <h3>Security Settings</h3>
  <p>Manage your security preferences.</p>
</div>

<div
  role="tabpanel"
  id="panel-notifications"
  aria-labelledby="tab-notifications"
  tabindex="0"
  hidden
>
  <h3>Notification Settings</h3>
  <p>Control your notification preferences.</p>
</div>

<!-- ── Disclosure (Accordion) ── -->
<button
  aria-expanded="false"
  aria-controls="faq-1-content"
  id="faq-1-button"
>
  What is accessibility?
</button>
<div
  id="faq-1-content"
  role="region"
  aria-labelledby="faq-1-button"
  hidden
>
  <p>Accessibility (a11y) ensures that web applications can be used by everyone,
     including people with disabilities.</p>
</div>

<!-- ── Alert (Live Region) ── -->
<!-- Use for important, time-sensitive messages -->
<div role="alert" aria-live="assertive" aria-atomic="true">
  Your session will expire in 2 minutes.
</div>

<!-- ── Status (Polite Live Region) ── -->
<!-- Use for non-urgent status updates -->
<div role="status" aria-live="polite" aria-atomic="true">
  3 items in your cart
</div>

<!-- ── Progress Bar ── -->
<div
  role="progressbar"
  aria-valuenow="65"
  aria-valuemin="0"
  aria-valuemax="100"
  aria-label="File upload progress"
>
  65% complete
</div>

<!-- ── Modal Dialog ── -->
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-desc"
>
  <h2 id="modal-title">Confirm Action</h2>
  <p id="modal-desc">Are you sure you want to proceed?</p>
  <div>
    <button type="button" data-action="cancel">Cancel</button>
    <button type="button" data-action="confirm">Confirm</button>
  </div>
</div>

<!-- ── Combobox (Autocomplete) ── -->
<label for="country-input">Country</label>
<input
  id="country-input"
  role="combobox"
  aria-expanded="false"
  aria-controls="country-listbox"
  aria-autocomplete="list"
  aria-activedescendant=""
/>
<ul
  id="country-listbox"
  role="listbox"
  aria-label="Countries"
  hidden
>
  <li role="option" id="country-us" aria-selected="false">United States</li>
  <li role="option" id="country-uk" aria-selected="false">United Kingdom</li>
  <li role="option" id="country-ca" aria-selected="false">Canada</li>
</ul>
```

### 4. Accessible Forms

```html
<form novalidate aria-label="Create account">
  <!-- ── Text Input with Label, Hint, and Error ── -->
  <div class="form-field">
    <label for="email">
      Email address <span aria-hidden="true">*</span>
      <span class="visually-hidden">(required)</span>
    </label>
    <input
      type="email"
      id="email"
      name="email"
      required
      aria-required="true"
      aria-describedby="email-hint email-error"
      autocomplete="email"
    />
    <span id="email-hint" class="hint">
      We'll never share your email with anyone.
    </span>
    <span id="email-error" class="error" role="alert" aria-live="polite">
      <!-- Populated by JavaScript on validation failure -->
    </span>
  </div>

  <!-- ── Password with Show/Hide Toggle ── -->
  <div class="form-field">
    <label for="password">
      Password <span aria-hidden="true">*</span>
      <span class="visually-hidden">(required)</span>
    </label>
    <div class="password-input-wrapper">
      <input
        type="password"
        id="password"
        name="password"
        required
        aria-required="true"
        aria-describedby="password-requirements"
        autocomplete="new-password"
      />
      <button
        type="button"
        aria-label="Show password"
        aria-pressed="false"
        onclick="togglePasswordVisibility(this)"
      >
        👁
      </button>
    </div>
    <ul id="password-requirements" class="hint">
      <li>At least 8 characters</li>
      <li>At least one uppercase letter</li>
      <li>At least one number</li>
    </ul>
  </div>

  <!-- ── Radio Group ── -->
  <fieldset>
    <legend>Preferred contact method <span aria-hidden="true">*</span></legend>
    <div class="radio-group">
      <input type="radio" id="contact-email" name="contact" value="email" required />
      <label for="contact-email">Email</label>
    </div>
    <div class="radio-group">
      <input type="radio" id="contact-phone" name="contact" value="phone" />
      <label for="contact-phone">Phone</label>
    </div>
    <div class="radio-group">
      <input type="radio" id="contact-sms" name="contact" value="sms" />
      <label for="contact-sms">SMS</label>
    </div>
  </fieldset>

  <!-- ── Checkbox Group ── -->
  <fieldset>
    <legend>Notification preferences</legend>
    <div class="checkbox-group">
      <input type="checkbox" id="notify-updates" name="notifications" value="updates" />
      <label for="notify-updates">Product updates</label>
    </div>
    <div class="checkbox-group">
      <input type="checkbox" id="notify-marketing" name="notifications" value="marketing" />
      <label for="notify-marketing">Marketing emails</label>
    </div>
  </fieldset>

  <!-- ── Error Summary (shown on form submission) ── -->
  <div
    role="alert"
    aria-live="assertive"
    tabindex="-1"
    id="error-summary"
    class="error-summary"
    hidden
  >
    <h2>Please fix the following errors:</h2>
    <ul>
      <li><a href="#email">Email address is required</a></li>
      <li><a href="#password">Password must be at least 8 characters</a></li>
    </ul>
  </div>

  <button type="submit">Create Account</button>
</form>

<!-- ── Visually Hidden (screen reader only) ── -->
<style>
.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
</style>
```

```javascript
// ── Accessible Form Validation ──

function validateForm(form) {
  const errors = [];
  const errorSummary = document.getElementById('error-summary');

  // Clear previous errors
  form.querySelectorAll('[aria-invalid]').forEach(el => {
    el.removeAttribute('aria-invalid');
  });
  form.querySelectorAll('.error').forEach(el => {
    el.textContent = '';
  });

  // Validate each required field
  const requiredFields = form.querySelectorAll('[required]');
  requiredFields.forEach(field => {
    const errorEl = document.getElementById(`${field.id}-error`);
    let errorMessage = '';

    if (!field.value.trim()) {
      errorMessage = `${getFieldLabel(field)} is required`;
    } else if (field.type === 'email' && !isValidEmail(field.value)) {
      errorMessage = 'Please enter a valid email address';
    } else if (field.minLength > 0 && field.value.length < field.minLength) {
      errorMessage = `Must be at least ${field.minLength} characters`;
    }

    if (errorMessage) {
      field.setAttribute('aria-invalid', 'true');
      if (errorEl) {
        errorEl.textContent = errorMessage;
      }
      errors.push({ field: field.id, message: errorMessage });
    }
  });

  // Show/hide error summary
  if (errors.length > 0) {
    errorSummary.hidden = false;
    errorSummary.focus(); // Move focus to error summary for screen readers
    return false;
  }

  errorSummary.hidden = true;
  return true;
}

function getFieldLabel(field) {
  const label = document.querySelector(`label[for="${field.id}"]`);
  return label ? label.textContent.replace('*', '').trim() : field.name;
}

function togglePasswordVisibility(button) {
  const input = button.previousElementSibling;
  const isPassword = input.type === 'password';
  input.type = isPassword ? 'text' : 'password';
  button.setAttribute('aria-pressed', isPassword ? 'true' : 'false');
  button.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
}
```

### 5. Color Contrast and Visual Design

```css
/* ── Contrast Requirements (WCAG 2.2 AA) ── */

/* Normal text (< 18pt): 4.5:1 minimum */
body {
  color: #1a1a1a;          /* On white: 16.75:1 ✅ */
  background-color: #ffffff;
}

/* Large text (≥ 18pt or ≥ 14pt bold): 3:1 minimum */
h1 { font-size: 2rem; }     /* 32px = large text */
h2 { font-size: 1.5rem; }   /* 24px = large text */

/* UI components and focus indicators: 3:1 minimum */
.button {
  background-color: #005fcc;
  color: #ffffff;
  /* Blue on white: 5.67:1 ✅ */
}

/* ── Focus Indicators (WCAG 2.2 — Required) ── */
:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

/* Don't use only color to convey meaning */
.status-error {
  color: #d32f2f;
  border-left: 4px solid #d32f2f;  /* ✅ Color + border */
  padding-left: 8px;
}
.status-error::before {
  content: "⚠ ";  /* ✅ Color + icon */
}

/* ── Reduced Motion ── */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* ── High Contrast Mode ── */
@media (forced-colors: active) {
  .button {
    border: 1px solid ButtonText;
  }
  .error {
    border-left: 4px solid LinkText;
  }
}

/* ── Touch Targets (WCAG 2.2 — Minimum 24x24 CSS pixels) ── */
.button,
a,
input,
select,
textarea {
  min-height: 44px;  /* Apple recommends 44px; WCAG minimum is 24px */
  min-width: 44px;
}
```

```javascript
// ── Contrast Checker Utility ──

function getContrastRatio(rgb1, rgb2) {
  function getLuminance([r, g, b]) {
    const [rs, gs, bs] = [r, g, b].map(c => {
      c = c / 255;
      return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
    });
    return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
  }

  const l1 = getLuminance(rgb1);
  const l2 = getLuminance(rgb2);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);

  return (lighter + 0.05) / (darker + 0.05);
}

// Check if contrast meets WCAG AA
function meetsWCAG_AA(rgb1, rgb2, isLargeText = false) {
  const ratio = getContrastRatio(rgb1, rgb2);
  return isLargeText ? ratio >= 3 : ratio >= 4.5;
}
```

### 6. Screen Reader Testing Guide

```markdown
## Screen Reader Testing Protocol

### VoiceOver (macOS/iOS)
1. Enable: Cmd + F5 (macOS) or Settings > Accessibility > VoiceOver (iOS)
2. Navigate: VO + Arrow keys (VO = Ctrl + Option)
3. Interact: VO + Shift + Down Arrow (enter group), VO + Space (activate)
4. Rotor: VO + U (heading/landmark/link navigation)

### NVDA (Windows)
1. Download: https://www.nvaccess.org/download/
2. Navigate: Arrow keys, H (next heading), D (next landmark)
3. Elements list: NVDA + F7
4. Toggle focus/browse mode: NVDA + Space

### Test Checklist
- [ ] All images have descriptive alt text
- [ ] All form inputs have visible labels
- [ ] Heading hierarchy is logical (no skipped levels)
- [ ] All landmarks are present (header, nav, main, footer)
- [ ] Dynamic content is announced (aria-live regions)
- [ ] Modals trap focus correctly
- [ ] Escape key closes modals and dropdowns
- [ ] Skip navigation link works
- [ ] Tab order follows visual order
- [ ] No keyboard traps (can always Tab away)
- [ ] Color is not the only way to convey information
- [ ] Time limits can be extended or disabled
```

### 7. Automated Testing with axe-core

```javascript
// ── Playwright + axe-core Integration ──

import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility', () => {
  test('homepage has no accessibility violations', async ({ page }) => {
    await page.goto('/');
    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag22aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });

  test('login form has no accessibility violations', async ({ page }) => {
    await page.goto('/login');
    const results = await new AxeBuilder({ page })
      .include('#login-form')
      .withTags(['wcag2a', 'wcag2aa', 'wcag22aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });

  test('all pages pass axe audit', async ({ page }) => {
    const pages = ['/', '/login', '/about', '/contact'];

    for (const url of pages) {
      await page.goto(url);
      const results = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag22aa'])
        .analyze();

      expect(results.violations).toEqual([]);
    }
  });

  test('dialog is accessible when open', async ({ page }) => {
    await page.goto('/');
    await page.click('[data-testid="open-dialog"]');

    const dialog = page.locator('[role="dialog"]');
    await expect(dialog).toBeVisible();

    const results = await new AxeBuilder({ page })
      .include('[role="dialog"]')
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });
});

// ── React Testing Library + jest-axe ──

import { render, screen } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';
import { LoginForm } from './LoginForm';

expect.extend(toHaveNoViolations);

describe('LoginForm Accessibility', () => {
  it('should have no accessibility violations', async () => {
    const { container } = render(<LoginForm />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('all inputs have associated labels', () => {
    render(<LoginForm />);
    const emailInput = screen.getByLabelText(/email/i);
    const passwordInput = screen.getByLabelText(/password/i);
    expect(emailInput).toBeInTheDocument();
    expect(passwordInput).toBeInTheDocument();
  });

  it('error messages are announced to screen readers', async () => {
    render(<LoginForm />);
    const submitButton = screen.getByRole('button', { name: /sign in/i });
    fireEvent.click(submitButton);

    const errorAlert = screen.getByRole('alert');
    expect(errorAlert).toBeInTheDocument();
  });
});
```

## Common Patterns

### Pattern 1: Accessible Modal Dialog

```javascript
class AccessibleModal {
  constructor(modalElement) {
    this.modal = modalElement;
    this.focusTrap = createFocusTrap(modalElement);
    this.previouslyFocused = null;
  }

  open() {
    this.previouslyFocused = document.activeElement;
    this.modal.hidden = false;
    this.modal.setAttribute('aria-hidden', 'false');
    document.body.setAttribute('aria-hidden', 'true');
    this.focusTrap.activate();

    // Announce to screen readers
    this.modal.focus();
  }

  close() {
    this.modal.hidden = true;
    this.modal.setAttribute('aria-hidden', 'true');
    document.body.removeAttribute('aria-hidden');
    this.focusTrap.deactivate();

    // Return focus to trigger
    if (this.previouslyFocused) {
      this.previouslyFocused.focus();
    }
  }
}
```

### Pattern 2: Accessible Toast Notifications

```html
<div
  aria-live="polite"
  aria-atomic="true"
  class="toast-container"
  id="toast-region"
  role="status"
>
  <!-- Toasts are dynamically inserted here -->
</div>

<script>
function showToast(message, type = 'info') {
  const container = document.getElementById('toast-region');
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.setAttribute('role', 'status');

  const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
  toast.innerHTML = `
    <span aria-hidden="true">${icons[type]}</span>
    <span>${message}</span>
    <button aria-label="Dismiss notification" onclick="this.parentElement.remove()">×</button>
  `;

  container.appendChild(toast);

  // Auto-remove after 5 seconds
  setTimeout(() => toast.remove(), 5000);
}
</script>
```

### Pattern 3: Accessible Data Table

```html
<div class="table-container" tabindex="0" role="region" aria-label="User data">
  <table>
    <caption>User Management</caption>
    <thead>
      <tr>
        <th scope="col" aria-sort="ascending">
          <button aria-label="Sort by Name, currently ascending">
            Name <span aria-hidden="true">↑</span>
          </button>
        </th>
        <th scope="col">Email</th>
        <th scope="col">Role</th>
        <th scope="col">
          <span class="visually-hidden">Actions</span>
        </th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Alice Johnson</td>
        <td>alice@example.com</td>
        <td>Admin</td>
        <td>
          <button aria-label="Edit Alice Johnson">Edit</button>
          <button aria-label="Delete Alice Johnson">Delete</button>
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

### Pattern 4: Accessible Loading States

```html
<!-- Loading spinner with screen reader announcement -->
<div aria-live="polite" aria-busy="true">
  <div class="spinner" aria-hidden="true"></div>
  <span class="visually-hidden">Loading products...</span>
</div>

<!-- After loading completes -->
<div aria-live="polite" aria-busy="false">
  <span>42 products loaded</span>
</div>
```

### Pattern 5: Reduced Motion Support

```javascript
// Check user's motion preference
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

function animate(element, animation) {
  if (prefersReducedMotion.matches) {
    // Skip animation, show final state immediately
    element.style.opacity = '1';
    element.style.transform = 'none';
    return;
  }

  element.animate(animation.keyframes, animation.options);
}

// Listen for changes
prefersReducedMotion.addEventListener('change', (e) => {
  if (e.matches) {
    // Stop all running animations
    document.getAnimations().forEach(anim => anim.cancel());
  }
});
```

## Edge Cases & Pitfalls

1. **ARIA used on non-semantic HTML instead of native elements** — `role="button"` on a `<div>` is less accessible than a `<button>`. Always prefer native HTML elements over ARIA roles; use ARIA only when native semantics are insufficient.

2. **Focus trapped in carousel or infinite scroll** — Users cannot Tab out of a carousel or reach content after an infinite scroll. Provide escape mechanisms and ensure all content is reachable via keyboard.

3. **Dynamic content not announced** — Content loaded via AJAX, React state changes, or WebSocket updates is invisible to screen readers without `aria-live` regions. Add live regions for all meaningful dynamic updates.

4. **Color contrast failures in dark mode** — Colors that pass contrast in light mode often fail in dark mode. Test both modes and use CSS custom properties with pre-calculated contrast-safe values.

5. **Modal without focus trap** — Opening a modal without trapping focus allows Tab to move to content behind the modal. Screen readers will read hidden content. Always implement focus trapping for modals.

6. **Missing alt text on functional images** — Images that perform actions (like icons in buttons) need alt text describing the action, not the image. A magnifying glass icon in a search button should have `alt="Search"`.

7. **Headings used for styling, not structure** — Using `<h3>` because it looks right visually (skipping `<h2>`) breaks document outline for screen reader users. Headings must follow strict hierarchy.

8. **Autoplay video/audio** — Autoplaying media is disorienting for screen reader users and violates WCAG 2.2 success criterion 1.4.2. Always provide controls and don't autoplay.

9. **Touch target too small on mobile** — WCAG 2.2 requires minimum 24x24 CSS pixel touch targets. On mobile, use at least 44x44 pixels for comfortable interaction.

10. **Form placeholder as label** — Placeholder text disappears on input and is often low contrast. Always use a visible `<label>` element; placeholder is supplementary only.

11. **Link text says "click here" or "read more"** — Screen reader users navigate by links; "click here" is meaningless out of context. Use descriptive link text: "Read our accessibility documentation".

12. **Data tables without proper headers** — Complex tables need `<th scope="col">` and `<th scope="row">` for screen readers to associate data with headers. Use `aria-describedby` for complex tables.

13. **Missing language attribute** — `<html lang="en">` is required for screen readers to use correct pronunciation. Missing it causes all content to be read with the default voice.

14. **Automated testing catches only 30-40% of issues** — axe-core and Lighthouse catch missing alt text and contrast issues but cannot test keyboard navigation flow, screen reader experience, or cognitive load. Manual testing is essential.

15. **Accessibility regressions in PR reviews** — Without automated CI checks, accessibility violations slip into production. Add axe-core tests to CI pipelines and require them to pass before merge.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| testing-e2e | axe-core integration, screen reader testing | ↔ | E2E tests include accessibility assertions; accessibility is part of quality |
| ci-cd | Automated a11y checks in pipeline | → | CI blocks PRs with accessibility violations |
| api-design | Accessible API responses (error messages) | ← | API error messages should be clear enough for accessible UI display |
| monitoring-observability | Accessibility error tracking | → | Track accessibility violations as metrics in dashboards |
| feature-flag | A/B test accessibility variants | ← | Accessibility improvements should be tested with users |
| deployment | Accessibility audit before release | → | Pre-release accessibility checklist |

## Output Format Templates

### Template 1: Accessibility Audit Report

```markdown
## Accessibility Audit Report — {Page/Component}

**Date:** YYYY-MM-DD
**Standard:** WCAG 2.2 AA
**Tool:** axe-core + manual testing

### Summary
| Category | Passed | Failed | Needs Review |
|----------|--------|--------|-------------|
| Automated (axe-core) | X | Y | Z |
| Keyboard Navigation | X | Y | Z |
| Screen Reader | X | Y | Z |
| Color Contrast | X | Y | Z |

### Violations Found
| # | Criterion | Element | Issue | Severity | Fix |
|---|-----------|---------|-------|----------|-----|
| 1 | 1.1.1 Non-text Content | `<img src="chart.png">` | Missing alt text | Critical | Add descriptive alt |
| 2 | 4.1.2 Name, Role, Value | `<div onclick="...">` | Not keyboard accessible | Serious | Use `<button>` |
| 3 | 1.4.3 Contrast | `.text-muted` | Ratio 3.2:1 | Serious | Darken color |

### Passed Criteria
- 1.3.1 Info and Relationships
- 2.1.1 Keyboard
- 2.4.1 Bypass Blocks
- ...

### Recommendations
1. [Highest priority fix]
2. [Second priority fix]
3. [Third priority fix]
```

### Template 2: Component Accessibility Checklist

```markdown
## Component: {Component Name}

### Semantic HTML
- [ ] Uses appropriate HTML elements
- [ ] Heading hierarchy is correct
- [ ] Landmark regions are present

### Keyboard
- [ ] All interactive elements focusable
- [ ] Tab order follows visual order
- [ ] Focus indicator is visible
- [ ] Escape key closes overlays
- [ ] No keyboard traps

### ARIA
- [ ] Roles, states, properties correct
- [ ] Labels and descriptions provided
- [ ] Live regions for dynamic content

### Color/Visual
- [ ] Contrast ratio ≥ 4.5:1 (normal text)
- [ ] Contrast ratio ≥ 3:1 (large text/UI)
- [ ] Color not sole indicator
- [ ] prefers-reduced-motion respected

### Testing
- [ ] axe-core: 0 violations
- [ ] Keyboard: full functionality
- [ ] Screen reader: verified
```

### Template 3: WCAG 2.2 AA Compliance Matrix

```markdown
## WCAG 2.2 AA Compliance — {Project}

| Criterion | Level | Status | Notes |
|-----------|-------|--------|-------|
| 1.1.1 Non-text Content | A | ✅ Pass | All images have alt text |
| 1.3.1 Info and Relationships | A | ✅ Pass | Semantic HTML used |
| 1.4.3 Contrast (Minimum) | AA | ⚠️ Partial | 3 elements below 4.5:1 |
| 1.4.11 Non-text Contrast | AA | ✅ Pass | UI components meet 3:1 |
| 2.1.1 Keyboard | A | ✅ Pass | All elements keyboard accessible |
| 2.4.1 Bypass Blocks | A | ✅ Pass | Skip link present |
| 2.4.3 Focus Order | A | ✅ Pass | Logical tab order |
| 2.4.6 Headings and Labels | AA | ✅ Pass | Descriptive headings |
| 2.4.11 Focus Not Obscured | AA | 🆕 Pass | WCAG 2.2 new criterion |
| 2.4.13 Focus Appearance | AA | 🆕 Pass | WCAG 2.2 new criterion |
| 3.3.1 Error Identification | A | ✅ Pass | Errors announced |
| 3.3.2 Labels or Instructions | A | ✅ Pass | All inputs labeled |
| 4.1.2 Name, Role, Value | A | ✅ Pass | Custom widgets accessible |
```

### Template 4: Agent-Friendly Fix Output

```json
{
  "audit_target": "src/components/Checkout.tsx",
  "wcag_version": "2.2",
  "level": "AA",
  "violations": [
    {
      "id": "V-001",
      "criterion": "1.4.3",
      "severity": "serious",
      "element": "button.btn-pay",
      "issue": "Contrast ratio 2.8:1 (white on #4a90d9), requires 4.5:1",
      "fix": { "file": "src/styles/buttons.css", "change": "background: #2b6cb0", "result_ratio": "5.2:1" },
      "tool": "axe-core",
      "verified_by": "automated + manual keyboard pass"
    },
    {
      "id": "V-002",
      "criterion": "2.1.1",
      "severity": "critical",
      "element": "div.card[onclick]",
      "issue": "Clickable div not focusable; no keyboard handler",
      "fix": { "file": "src/components/Checkout.tsx", "change": "<div onclick> → <button type=\"button\">", "note": "removes tabindex=0 hack" }
    }
  ],
  "passes": 41,
  "summary": "2 violations block AA; both have one-file fixes",
  "next_audit": "after fixes applied"
}
```

## Rules

1. **Use semantic HTML first** — ARIA is a supplement, not a replacement. A `<button>` is always more accessible than a `<div role="button">`. Reach for native HTML elements before adding ARIA.

2. **All interactive elements must be keyboard accessible** — Every button, link, input, and custom widget must be operable with Tab, Enter, Space, Arrow keys, and Escape. No mouse-only interactions.

3. **Every image needs alt text** — Informative images get descriptive alt text. Decorative images get `alt=""`. Functional images (icons in buttons) describe the action, not the image.

4. **Never rely on color alone** — Use icons, text, patterns, or underlines to supplement color indicators. Color-blind users (~8% of males) cannot distinguish certain color combinations.

5. **Test with a real screen reader** — Automated tools catch only 30-40% of issues. Test with VoiceOver (Mac), NVDA (Windows), or TalkBack (Android) on every major flow.

6. **Visible focus indicators are mandatory** — WCAG 2.2 requires visible focus indicators on all interactive elements. Never use `outline: none` without a replacement.

7. **Announce dynamic content changes** — Use `aria-live` regions for content that updates without a page reload (carts, notifications, loading states, error messages).

8. **Modal dialogs must trap focus** — When a modal opens, focus moves inside it. Tab cycles within the modal. Escape closes it. Focus returns to the trigger on close.

9. **Touch targets must be at least 24x24 CSS pixels** — WCAG 2.2 minimum; 44x44 pixels recommended for comfortable mobile interaction.

10. **Respect `prefers-reduced-motion`** — Some users experience dizziness or nausea from animations. Check this media query and disable or simplify animations accordingly.

11. **Form inputs must have visible labels** — Placeholder text is not a label. Every `<input>` must have an associated `<label>` element with a `for` attribute.

12. **Add accessibility CI checks** — Run axe-core in your CI pipeline on every PR. Block merges when accessibility violations are detected.
