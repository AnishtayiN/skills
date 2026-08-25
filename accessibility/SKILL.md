---
name: accessibility
description: >-
  Make web applications accessible following WCAG guidelines, ARIA patterns, and screen reader
  compatibility. Use this skill when the user mentions accessibility, a11y, WCAG, screen reader,
  ARIA, keyboard navigation, color contrast, alt text, semantic HTML, accessible forms,
  focus management, skip navigation, reduced motion, or says دسترسی‌پذیری, قابلیت دسترسی,
  بهینه‌سازی برای معلولین, پشتیبانی از صفحه‌خوان.
---

# Accessibility Skill — WCAG Compliance, ARIA & Screen Reader Support

## Overview

This skill makes web applications accessible to all users, including those with visual, motor, cognitive, or auditory disabilities. Accessibility is not optional — it's a legal requirement in many jurisdictions (ADA, EAA, Section 508) and a moral imperative. This skill covers WCAG 2.1/2.2 compliance, ARIA patterns, keyboard navigation, screen reader support, color contrast, semantic HTML, and automated testing tools.

## When to Use This Skill

- User wants to make their website accessible
- User asks about WCAG compliance
- User needs to add screen reader support
- User mentions ARIA, keyboard navigation, or focus management
- User asks about color contrast or alt text
- User mentions دسترسی‌پذیری or قابلیت دسترسی

---

## Part 1: WCAG 2.1 Quick Reference

### The Four Principles (POUR)

| Principle | Meaning | Example |
|-----------|---------|---------|
| **Perceivable** | Information must be presentable | Alt text, captions, color contrast |
| **Operable** | UI must be operable | Keyboard navigation, no time traps |
| **Understandable** | Content must be understandable | Clear labels, error messages |
| **Robust** | Content must work with assistive tech | Valid HTML, ARIA attributes |

### WCAG 2.1 Levels

| Level | Requirement | Who |
|-------|------------|-----|
| **A** | Minimum accessibility | All public websites |
| **AA** | Recommended standard | Most organizations (legal minimum in EU) |
| **AAA** | Highest level | Government, healthcare (aspirational) |

### Key Success Criteria

| Criterion | Level | Description |
|-----------|-------|-------------|
| 1.1.1 Non-text Content | A | Alt text for images |
| 1.3.1 Info and Relationships | A | Semantic HTML structure |
| 1.4.3 Contrast (Minimum) | AA | 4.5:1 contrast ratio for text |
| 1.4.11 Non-text Contrast | AA | 3:1 for UI components |
| 2.1.1 Keyboard | A | All functionality via keyboard |
| 2.4.1 Bypass Blocks | A | Skip navigation link |
| 2.4.3 Focus Order | A | Logical tab order |
| 2.4.6 Headings and Labels | AA | Descriptive headings |
| 3.3.1 Error Identification | A | Clear error messages |
| 3.3.2 Labels or Instructions | A | Form labels |

---

## Part 2: Semantic HTML

### Correct Element Usage

```html
<!-- ❌ BAD: Div soup -->
<div class="header">
  <div class="nav">
    <div class="nav-item" onclick="navigate()">Home</div>
  </div>
</div>
<div class="main">
  <div class="card">
    <div class="card-title">Title</div>
    <div class="card-text">Content</div>
  </div>
</div>
<div class="footer">© 2024</div>

<!-- ✅ GOOD: Semantic HTML -->
<header>
  <nav aria-label="Main navigation">
    <a href="/">Home</a>
  </nav>
</header>
<main>
  <article>
    <h2>Title</h2>
    <p>Content</p>
  </article>
</main>
<footer>© 2024</footer>
```

### Landmarks

```html
<header>        <!-- Banner landmark -->
<nav>           <!-- Navigation landmark -->
<main>          <!-- Main content landmark -->
<aside>         <!-- Complementary landmark -->
<footer>        <!-- Contentinfo landmark -->
<form>          <!-- Form landmark -->
<section>       <!-- Region landmark (with accessible name) -->
```

### Headings Hierarchy

```html
<!-- ❌ BAD: Skipped heading levels -->
<h1>Page Title</h1>
<h4>Section</h4>

<!-- ✅ GOOD: Proper hierarchy -->
<h1>Page Title</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>
    <h3>Subsection</h3>
  <h2>Section</h2>
```

---

## Part 3: Keyboard Navigation

### Focus Management

```html
<!-- Skip navigation link -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px;
  z-index: 100;
}
.skip-link:focus {
  top: 0;
}
</style>

<!-- Logical tab order -->
<div tabindex="0" role="button" onclick="handleClick()">
  Custom Button
</div>

<!-- Focus trap for modals -->
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Dialog</h2>
  <input type="text" />
  <button>Cancel</button>
  <button>Confirm</button>
</div>
```

### Focus Trap Implementation

```javascript
function trapFocus(element) {
  const focusableElements = element.querySelectorAll(
    'a[href], button:not([disabled]), textarea:not([disabled]), ' +
    'input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
  );
  
  const firstElement = focusableElements[0];
  const lastElement = focusableElements[focusableElements.length - 1];
  
  element.addEventListener('keydown', (e) => {
    if (e.key !== 'Tab') return;
    
    if (e.shiftKey) {
      if (document.activeElement === firstElement) {
        lastElement.focus();
        e.preventDefault();
      }
    } else {
      if (document.activeElement === lastElement) {
        firstElement.focus();
        e.preventDefault();
      }
    }
  });
  
  firstElement.focus();
}
```

### Keyboard Shortcuts

```javascript
// Arrow key navigation for lists/menus
element.addEventListener('keydown', (e) => {
  const items = Array.from(element.querySelectorAll('[role="menuitem"]'));
  const currentIndex = items.indexOf(document.activeElement);
  
  switch (e.key) {
    case 'ArrowDown':
      e.preventDefault();
      items[(currentIndex + 1) % items.length].focus();
      break;
    case 'ArrowUp':
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
```

---

## Part 4: ARIA Patterns

### Common ARIA Patterns

```html
<!-- Tab Panel -->
<div role="tablist" aria-label="Settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1">
    General
  </button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2">
    Security
  </button>
</div>

<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">
  General settings content
</div>

<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>
  Security settings content
</div>

<!-- Alert -->
<div role="alert" aria-live="assertive">
  Your changes have been saved.
</div>

<!-- Progress Bar -->
<div role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"
     aria-label="Upload progress">
  75%
</div>

<!-- Modal Dialog -->
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Confirm Delete</h2>
  <p id="dialog-desc">Are you sure you want to delete this item?</p>
  <button>Cancel</button>
  <button>Delete</button>
</div>
```

### Live Regions

```html
<!-- Announce changes to screen readers -->
<div aria-live="polite" aria-atomic="true">
  <!-- Content updated dynamically -->
  3 items in cart
</div>

<!-- Assertive (interrupts screen reader) -->
<div aria-live="assertive">
  Error: Form submission failed
</div>

<!-- Status messages -->
<div role="status">
  Search results loaded: 42 items found
</div>
```

---

## Part 5: Forms

### Accessible Form Structure

```html
<form>
  <!-- Each input must have a label -->
  <div>
    <label for="email">Email Address <span aria-hidden="true">*</span></label>
    <input type="email" id="email" name="email" required
           aria-required="true"
           aria-describedby="email-hint email-error" />
    <span id="email-hint">We'll never share your email.</span>
    <span id="email-error" role="alert" aria-live="polite"></span>
  </div>

  <!-- Grouped inputs -->
  <fieldset>
    <legend>Preferred Contact Method</legend>
    <input type="radio" id="contact-email" name="contact" value="email" />
    <label for="contact-email">Email</label>
    
    <input type="radio" id="contact-phone" name="contact" value="phone" />
    <label for="contact-phone">Phone</label>
  </fieldset>

  <!-- Error handling -->
  <div>
    <label for="password">Password</label>
    <input type="password" id="password" name="password"
           aria-invalid="true"
           aria-describedby="password-error" />
    <span id="password-error" role="alert">
      Password must be at least 8 characters
    </span>
  </div>
</form>
```

### Error Announcement

```javascript
// Announce errors to screen readers
function announceError(fieldId, message) {
  const errorElement = document.getElementById(`${fieldId}-error`);
  const inputElement = document.getElementById(fieldId);
  
  errorElement.textContent = message;
  inputElement.setAttribute('aria-invalid', 'true');
  inputElement.focus();
}

// Clear error
function clearError(fieldId) {
  const errorElement = document.getElementById(`${fieldId}-error`);
  const inputElement = document.getElementById(fieldId);
  
  errorElement.textContent = '';
  inputElement.removeAttribute('aria-invalid');
}
```

---

## Part 6: Images & Media

### Alt Text Guidelines

```html
<!-- Informative image: describe the content -->
<img src="chart.png" alt="Sales increased from $1M in January to $3M in December 2024" />

<!-- Decorative image: empty alt -->
<img src="decorative-border.png" alt="" />

<!-- Complex image (chart, diagram): provide full description -->
<figure>
  <img src="flowchart.png" alt="User registration flow" aria-describedby="flowchart-desc" />
  <figcaption id="flowchart-desc">
    The registration flow has 4 steps: 1) Enter email, 2) Verify email,
    3) Set password, 4) Complete profile.
  </figcaption>
</figure>

<!-- Image with text (logo): describe the brand -->
<img src="logo.png" alt="Acme Corporation - Home" />
```

### Video & Audio

```html
<!-- Video with captions -->
<video controls>
  <source src="tutorial.mp4" type="video/mp4" />
  <track kind="captions" src="captions.vtt" srclang="en" label="English" default />
  <track kind="descriptions" src="descriptions.vtt" srclang="en" label="Audio Descriptions" />
</video>

<!-- Audio with transcript -->
<audio controls>
  <source src="podcast.mp3" type="audio/mpeg" />
</audio>
<div>
  <details>
    <summary>Transcript</summary>
    <p>[Full transcript content here]</p>
  </details>
</div>
```

---

## Part 7: Color & Contrast

### Contrast Requirements

| Element | Minimum Ratio | Example |
|---------|--------------|---------|
| Normal text (< 18pt) | 4.5:1 | Body text, labels |
| Large text (≥ 18pt or 14pt bold) | 3:1 | Headings, buttons |
| UI components | 3:1 | Icons, borders, focus rings |
| Decorative elements | None | Background patterns |

### Color Independence

```css
/* ❌ BAD: Color-only indicator */
.error { color: red; }

/* ✅ GOOD: Color + icon + text */
.error {
  color: #d32f2f;
  border-left: 4px solid #d32f2f;
}
.error::before {
  content: "⚠️ ";
}

/* Focus indicators */
:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

/* Don't remove focus outlines */
:focus { outline: none; } /* ❌ BAD */
```

### Tools

- **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **Colour Contrast Analyser**: Desktop app
- **Chrome DevTools**: Rendering panel → Contrast ratio

---

## Part 8: Testing

### Automated Testing

```javascript
// axe-core integration (Jest/Playwright)
import { axe } from 'jest-axe';

test('form is accessible', async () => {
  const { container } = render(<LoginForm />);
  const results = await axe(container);
  expect(results.violations).toHaveLength(0);
});

// Playwright accessibility testing
test('page has no accessibility violations', async ({ page }) => {
  await page.goto('/');
  const results = await page.evaluate(async () => {
    const axe = await import('axe-core');
    return axe.run();
  });
  expect(results.violations).toHaveLength(0);
});
```

### Manual Testing Checklist

| Test | How |
|------|-----|
| Keyboard navigation | Tab through entire page |
| Screen reader | Use NVDA (Windows), VoiceOver (Mac), TalkBack (Android) |
| Zoom | 200% zoom without horizontal scrolling |
| Color contrast | Use contrast checker tool |
| Focus visibility | Check focus ring is visible on all interactive elements |
| Form errors | Submit empty form, check error announcements |
| Motion | Check `prefers-reduced-motion` media query |

---

## Output Format

```
## Accessibility Audit Report

### WCAG Level Target: [A / AA / AAA]

### Violations Found: X

| # | Element | Criterion | Severity | Fix |
|---|---------|-----------|----------|-----|
| 1 | [element] | [criterion] | [severity] | [fix] |

### Passed: X criteria
### Needs Review: X criteria
### Not Applicable: X criteria

### Recommendations
1. [Recommendation 1]
2. [Recommendation 2]
```

## Rules

- **Use semantic HTML first** — ARIA is a supplement, not a replacement
- **All interactive elements must be keyboard accessible** — No mouse-only interactions
- **Every image needs alt text** — Empty alt (`alt=""`) for decorative images
- **Never rely on color alone** — Use icons, text, or patterns too
- **Test with a screen reader** — Automated tools catch only 30-40% of issues
- **Maintain focus order** — Tab order should follow visual order
- **Announce dynamic changes** — Use `aria-live` regions for updates
- **Provide error recovery** — Clear error messages and easy correction
