---
name: email-template
description: >-
  Build production HTML emails with table layouts, inline CSS, and multi-client compatibility.
  TRIGGERS: email template, HTML email, email design, email development, email layout, email coding, email responsive, email newsletter, email campaign,
  قالب ایمیل, طراحی ایمیل, ایمیل اچ‌تی‌ام‌ال, ایمیل ریسپانسیو, ایمیل خبرنامه, ایمیل مارکتینگ,
  邮件模板, 邮件设计, HTML邮件, 邮件开发, 邮件布局, 邮件响应式
priority: P1
dependencies: [performance-optimization]
conflicts: []
---

# Email Template Skill

## Overview

Email development is a uniquely constrained discipline within web engineering. Unlike browser-based pages, HTML emails must render predictably across dozens of email clients—each with its own rendering engine, CSS support limitations, and quirks. This skill covers the complete lifecycle of building production-grade HTML emails: from foundational table-based layouts and inline CSS strategies to advanced techniques like dark mode support, interactive AMP emails, MJML templating, and automated rendering tests. Mastering email development means mastering compatibility, deliverability, and user experience simultaneously.

## When to Use This Skill (6-9 bullets)

- **Building marketing email templates** that must render correctly across Outlook, Gmail, Apple Mail, Yahoo, and Samsung Mail
- **Designing transactional emails** (password resets, receipts, notifications) requiring maximum compatibility and accessibility
- **Creating responsive email newsletters** that adapt cleanly from desktop to mobile viewports
- **Implementing dark mode email support** to match user OS preferences across supporting clients
- **Migrating from design tools to production HTML** — converting Figma/Pixie designs into inbox-ready code
- **Setting up MJML or similar template pipelines** for maintainable, component-based email development
- **Building AMP emails** for interactive, in-email experiences (forms, carousels, live content)
- **Debugging email rendering issues** in specific clients like Outlook 2016 or Gmail's CSS stripping
- **Integrating email templates with ESP platforms** (Mailchimp, SendGrid, Brevo, Amazon SES)

## When NOT to Use This Skill (5-7 bullets)

- **Building web pages or web apps** — standard HTML/CSS applies; email constraints do not
- **Designing in Figma/Sketch without coding** — this skill covers implementation, not visual design
- **Sending emails via API only** — if you only need SMTP/API integration without custom templates, use an ESP's built-in editor
- **Creating PDF documents** — PDF rendering uses different engines (not email clients)
- **Building SMS or push notification content** — different medium, different constraints
- **Working with plain-text emails only** — no HTML/CSS needed, just formatting conventions
- **Developing email client software** — this is about building emails, not email applications

## Workflow

### Step 1: Project Setup and Boilerplate

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!--[if mso]>
  <noscript>
    <xml>
      <o:OfficeDocumentSettings>
        <o:PixelsPerInch>96</o:PixelsPerInch>
      </o:OfficeDocumentSettings>
    </xml>
  </noscript>
  <![endif]-->
  <title>Email Subject Line Here</title>
  <style>
    /* Reset styles */
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { margin: 0; padding: 0; width: 100% !important; height: 100% !important; }
    /* Responsive styles */
    @media only screen and (max-width: 600px) {
      .email-container { width: 100% !important; max-width: 100% !important; }
      .fluid { max-width: 100% !important; height: auto !important; margin-left: auto !important; margin-right: auto !important; }
      .stack-column { display: block !important; width: 100% !important; max-width: 100% !important; direction: ltr !important; }
      .stack-column-center { text-align: center !important; }
      .center-on-narrow { text-align: center !important; display: block !important; margin-left: auto !important; margin-right: auto !important; float: none !important; }
      table.center-on-narrow { display: inline-block !important; }
    }
  </style>
</head>
<body style="margin:0; padding:0; background-color:#f4f4f4; font-family:Arial, Helvetica, sans-serif;">
  <!-- Preheader text (hidden) -->
  <div style="display:none; font-size:1px; line-height:1px; max-height:0px; max-width:0px; opacity:0; overflow:hidden; mso-hide:all;">
    Preview text that appears after the subject line in inbox...
  </div>

  <!-- Email wrapper -->
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#f4f4f4;">
    <tr>
      <td align="center" style="padding:20px 0;">
        <!--[if mso]>
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" align="center">
        <tr>
        <td>
        <![endif]-->
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="max-width:600px;" class="email-container">
          <!-- HEADER -->
          <tr>
            <td style="background-color:#ffffff; padding:20px; text-align:center;">
              <img src="https://example.com/logo.png" width="200" alt="Company Name" style="display:block; margin:0 auto;">
            </td>
          </tr>
          <!-- BODY -->
          <tr>
            <td style="background-color:#ffffff; padding:20px 40px; font-size:16px; line-height:24px; color:#333333;">
              <h1 style="margin:0 0 20px; font-size:24px; line-height:30px; color:#1a1a1a;">Heading Here</h1>
              <p style="margin:0 0 20px;">Body content goes here.</p>
            </td>
          </tr>
          <!-- FOOTER -->
          <tr>
            <td style="background-color:#333333; padding:20px; font-size:12px; line-height:18px; color:#999999; text-align:center;">
              <p style="margin:0 0 10px;">Company Name · 123 Street, City, Country</p>
              <p style="margin:0;"><a href="https://example.com/unsubscribe" style="color:#ffffff; text-decoration:underline;">Unsubscribe</a></p>
            </td>
          </tr>
        </table>
        <!--[if mso]>
        </td>
        </tr>
        </table>
        <![endif]-->
      </td>
    </tr>
  </table>
</body>
</html>
```

### Step 2: Responsive Column Layout System

```html
<!-- Two-column responsive layout -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr>
    <td align="center" style="padding:10px;">
      <!--[if mso]>
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="560" align="center">
      <tr>
      <td valign="top" width="270">
      <![endif]-->
      <div style="display:inline-block; margin:0 -2px; max-width:270px; min-width:270px; vertical-align:top; width:100%;" class="stack-column">
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
          <tr>
            <td style="padding:10px;">
              <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                  <td style="background-color:#e8f5e9; padding:20px; font-family:Arial, sans-serif;">
                    <img src="https://example.com/icon1.png" width="60" alt="Feature 1" style="display:block; margin:0 auto 10px;">
                    <h2 style="margin:0 0 10px; font-size:18px; text-align:center; color:#2e7d32;">Feature One</h2>
                    <p style="margin:0; font-size:14px; line-height:20px; text-align:center; color:#555555;">
                      Description of feature one goes here with compelling copy.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
      <!--[if mso]>
      </td>
      <td valign="top" width="270">
      <![endif]-->
      <div style="display:inline-block; margin:0 -2px; max-width:270px; min-width:270px; vertical-align:top; width:100%;" class="stack-column">
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
          <tr>
            <td style="padding:10px;">
              <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                  <td style="background-color:#e3f2fd; padding:20px; font-family:Arial, sans-serif;">
                    <img src="https://example.com/icon2.png" width="60" alt="Feature 2" style="display:block; margin:0 auto 10px;">
                    <h2 style="margin:0 0 10px; font-size:18px; text-align:center; color:#1565c0;">Feature Two</h2>
                    <p style="margin:0; font-size:14px; line-height:20px; text-align:center; color:#555555;">
                      Description of feature two goes here with compelling copy.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
      <!--[if mso]>
      </td>
      </tr>
      </table>
      <![endif]-->
    </td>
  </tr>
</table>
```

### Step 3: Dark Mode Implementation

```html
<style>
  /* Dark mode overrides */
  :root { color-scheme: light dark; supported-color-schemes: light dark; }

  @media (prefers-color-scheme: dark) {
    .email-bg { background-color: #1a1a2e !important; }
    .content-bg { background-color: #16213e !important; }
    .text-primary { color: #e0e0e0 !important; }
    .text-secondary { color: #b0b0b0 !important; }
    .btn-primary { background-color: #4fc3f7 !important; }
    .btn-primary a { color: #1a1a2e !important; }
    .footer-bg { background-color: #0f0f23 !important; }
    .footer-text { color: #888888 !important; }
    .border-light { border-color: #333355 !important; }
    /* Gmail dark mode hack */
    u + .email-bg .content-bg { background-color: #16213e !important; }
    u + .email-bg .text-primary { color: #e0e0e0 !important; }
  }

  /* Apple Mail dark mode attributes */
  [data-ogsc] .text-primary { color: #e0e0e0 !important; }
  [data-ogsc] .content-bg { background-color: #16213e !important; }
</style>

<!-- Using dark mode classes in email body -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" class="email-bg" style="background-color:#f4f4f4;">
  <tr>
    <td align="center" style="padding:20px;">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" class="content-bg" style="background-color:#ffffff; border-radius:8px; overflow:hidden;">
        <tr>
          <td style="padding:30px 40px;">
            <h1 class="text-primary" style="margin:0 0 15px; font-size:28px; color:#1a1a1a; font-family:Georgia, serif;">
              Welcome to Our Platform
            </h1>
            <p class="text-secondary" style="margin:0 0 25px; font-size:16px; line-height:26px; color:#555555; font-family:Arial, sans-serif;">
              We're thrilled to have you on board. Here's what you can do next.
            </p>
            <table role="presentation" cellspacing="0" cellpadding="0" border="0">
              <tr>
                <td class="btn-primary" style="background-color:#007bff; border-radius:6px;">
                  <a href="https://example.com/get-started" style="display:inline-block; padding:14px 30px; font-family:Arial, sans-serif; font-size:16px; color:#ffffff; text-decoration:none; font-weight:bold;">
                    Get Started
                  </a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
```

### Step 4: Outlook-Specific Fixes

```html
<!-- Background image with VML fallback for Outlook -->
<!--[if mso]>
<v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="width:600px; height:400px;">
  <v:fill type="tile" src="https://example.com/bg-pattern.png" color="#007bff"/>
  <v:textbox inset="0,0,0,0">
<![endif]-->
<div style="background-image:url('https://example.com/bg-pattern.png'); background-color:#007bff; background-repeat:no-repeat; background-position:center; background-size:cover;">
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
      <td style="padding:40px; text-align:center;">
        <h1 style="margin:0 0 15px; font-size:32px; color:#ffffff; font-family:Arial, sans-serif;">
          Special Offer
        </h1>
        <p style="margin:0; font-size:18px; color:#ffffff; font-family:Arial, sans-serif;">
          50% off all plans — limited time only.
        </p>
      </td>
    </tr>
  </table>
</div>
<!--[if mso]>
  </v:textbox>
</v:rect>
<![endif]-->

<!-- Bulletproof button for Outlook -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin:auto;">
  <tr>
    <td style="border-radius:6px; background-color:#007bff;">
      <!--[if mso]>
      <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="https://example.com/cta" style="height:50px;v-text-anchor:middle;width:250px;" arcsize="12%" strokecolor="#007bff" fillcolor="#007bff">
      <w:anchorlock/>
      <center style="color:#ffffff;font-family:Arial,sans-serif;font-size:16px;font-weight:bold;">Call to Action</center>
      </v:roundrect>
      <![endif]-->
      <!--[if !mso]><!-->
      <a href="https://example.com/cta" style="display:inline-block; padding:14px 40px; font-family:Arial, sans-serif; font-size:16px; font-weight:bold; color:#ffffff; text-decoration:none; border-radius:6px; background-color:#007bff; text-align:center;">
        Call to Action
      </a>
      <!--<![endif]-->
    </td>
  </tr>
</table>
```

### Step 5: ESP Integration and Testing Pipeline

```bash
# MJML CLI compilation
npx mjml templates/welcome.mjml --output dist/welcome.html --config mjmlconfig.json

# Validate HTML email (accessibility, structure)
npx email-validator dist/welcome.html

# Test across clients using Litmus or Email on Acid APIs
node scripts/test-rendering.js --file dist/welcome.html --clients outlook2019,gmail,apple-mail,samsung-mail

# Inline CSS (for ESP compatibility)
npx juice dist/welcome-inline.css dist/welcome.html --output dist/welcome-final.html

# Preheader extraction
node scripts/extract-preheader.js --file dist/welcome-final.html --max-length 150
```

```javascript
// scripts/test-rendering.js — automated rendering test helper
const fs = require('fs');
const path = require('path');

const CLIENTS = {
  outlook2019: { engine: 'Word', cssSupport: 'partial', notes: 'No background-image, limited border-radius' },
  gmail:       { engine: 'WebKit', cssSupport: 'good', notes: 'Strips <style> in some views, supports media queries' },
  appleMail:   { engine: 'WebKit', cssSupport: 'excellent', notes: 'Full CSS support including :root variables' },
  samsungMail: { engine: 'WebKit', cssSupport: 'good', notes: 'Good support but quirks with max-width' },
  yahooMail:   { engine: 'Hybrid', cssSupport: 'moderate', notes: 'Wraps media queries in data attributes' },
};

function validateStructure(html) {
  const issues = [];

  // Check for required elements
  if (!html.includes('role="presentation"')) {
    issues.push('WARNING: Tables missing role="presentation" — screen readers will announce table structure');
  }
  if (!html.includes('lang="en"')) {
    issues.push('WARNING: Missing lang attribute on <html> — impacts accessibility');
  }
  if (!html.includes('max-width:')) {
    issues.push('WARNING: No responsive max-width found — email may not scale on mobile');
  }
  if (!html.includes('mso-hide:all') && !html.includes('display:none')) {
    issues.push('WARNING: No preheader text found — inbox preview will show body content');
  }

  // Check image alt text
  const imgWithoutAlt = html.match(/<img[^>]+(?<!alt="[^"]*")[^>]*>/gi);
  if (imgWithoutAlt) {
    issues.push(`WARNING: ${imgWithoutAlt.length} image(s) may be missing alt attributes`);
  }

  // Check for external stylesheets (not allowed in email)
  if (html.includes('<link') && html.includes('stylesheet')) {
    issues.push('CRITICAL: External stylesheet <link> found — email clients will strip this');
  }

  return issues;
}

function estimateCompatibility(html) {
  const results = {};
  for (const [client, info] of Object.entries(CLIENTS)) {
    results[client] = {
      cssSupport: info.cssSupport,
      notes: info.notes,
      estimatedScore: 'Check manually with rendering service',
    };
  }
  return results;
}

// Main
const filePath = process.argv.find(a => a.startsWith('--file='))?.split('=')[1] || 'dist/welcome-final.html';
const html = fs.readFileSync(path.resolve(filePath), 'utf-8');

console.log('=== Email Validation Report ===\n');
const issues = validateStructure(html);
if (issues.length === 0) {
  console.log('✅ No structural issues found.\n');
} else {
  issues.forEach(i => console.log(`⚠️  ${i}`));
  console.log('');
}

console.log('=== Client Compatibility ===\n');
const compat = estimateCompatibility(html);
for (const [client, info] of Object.entries(compat)) {
  console.log(`  ${client}: ${info.cssSupport} CSS — ${info.notes}`);
}
console.log('\nDone.');
```

## Advanced Techniques

### 1. MJML Component Architecture

MJML is a markup language that abstracts email rendering complexity into semantic components. It compiles to responsive, client-compatible HTML.

```mjml
<!-- templates/partials/_header.mjml -->
<mj-section background-color="#ffffff" padding="20px 0">
  <mj-column>
    <mj-image
      src="https://example.com/logo.png"
      alt="Company Name"
      width="200px"
      href="https://example.com"
    />
  </mj-column>
</mj-section>

<!-- templates/partials/_hero.mjml -->
<mj-section background-color="#007bff" padding="40px 20px">
  <mj-column>
    <mj-text
      font-family="Georgia, serif"
      font-size="32px"
      color="#ffffff"
      align="center"
      line-height="40px"
      padding-bottom="15px"
    >
      Welcome to Our Platform
    </mj-text>
    <mj-text
      font-family="Arial, sans-serif"
      font-size="16px"
      color="#ffffff"
      align="center"
      line-height="26px"
      padding-bottom="25px"
    >
      We're excited to have you. Start exploring what's possible.
    </mj-text>
    <mj-button
      background-color="#ffffff"
      color="#007bff"
      font-family="Arial, sans-serif"
      font-size="16px"
      font-weight="bold"
      href="https://example.com/get-started"
      border-radius="6px"
      inner-padding="14px 30px"
    >
      Get Started →
    </mj-button>
  </mj-column>
</mj-section>

<!-- templates/newsletter.mjml -->
<mjml>
  <mj-head>
    <mj-attributes>
      <mj-all font-family="Arial, Helvetica, sans-serif" />
      <mj-text font-size="16px" line-height="24px" color="#333333" />
      <mj-button background-color="#007bff" color="#ffffff" border-radius="6px" />
    </mj-attributes>
    <mj-style>
      .preheader { display: none !important; }
    </mj-style>
    <mj-preview>Preview text goes here...</mj-preview>
  </mj-head>
  <mj-body background-color="#f4f4f4">

    <mj-include path="./partials/_header.mjml" />

    <mj-include path="./partials/_hero.mjml" />

    <!-- Features section -->
    <mj-section background-color="#ffffff" padding="30px 0">
      <mj-column padding="0 10px">
        <mj-image src="https://example.com/icon-feature1.png" alt="Feature 1" width="60px" padding-bottom="10px" />
        <mj-text font-size="18px" font-weight="bold" align="center" color="#1a1a1a" padding-bottom="8px">
          Lightning Fast
        </mj-text>
        <mj-text font-size="14px" align="center" color="#666666" line-height="20px">
          Optimized performance that keeps your workflow smooth and efficient.
        </mj-text>
      </mj-column>
      <mj-column padding="0 10px">
        <mj-image src="https://example.com/icon-feature2.png" alt="Feature 2" width="60px" padding-bottom="10px" />
        <mj-text font-size="18px" font-weight="bold" align="center" color="#1a1a1a" padding-bottom="8px">
          Rock Solid
        </mj-text>
        <mj-text font-size="14px" align="center" color="#666666" line-height="20px">
          Enterprise-grade reliability with 99.99% uptime guarantee.
        </mj-text>
      </mj-column>
      <mj-column padding="0 10px">
        <mj-image src="https://example.com/icon-feature3.png" alt="Feature 3" width="60px" padding-bottom="10px" />
        <mj-text font-size="18px" font-weight="bold" align="center" color="#1a1a1a" padding-bottom="8px">
          Beautiful Design
        </mj-text>
        <mj-text font-size="14px" align="center" color="#666666" line-height="20px">
          Crafted with attention to every detail and interaction.
        </mj-text>
      </mj-column>
    </mj-section>

    <mj-include path="./partials/_footer.mjml" />

  </mj-body>
</mjml>
```

### 2. Inline CSS Pipeline with CSS Inlining Strategy

```javascript
// scripts/inline-css.js
// Production CSS inlining pipeline for email templates
const juice = require('juice');
const fs = require('fs');
const path = require('path');
const postcss = require('postcss');
const mqpacker = require('css-mqpacker');

const INLINE_CONFIG = {
  preserveMediaQueries: true,
  preserveFontFaces: true,
  preserveImportant: true,
  removeStyleTags: false,
  applyStyleTags: true,
  insertPreservedExtraCss: true,
  preservePseudoElements: false,
  inlineStyleAttribute: 'style',
  // Preserve these selectors as-is (don't inline)
  preserveSelectors: [
    '@media',
    ':hover',
    ':focus',
    '@supports',
    '.dark-mode',
    '[data-ogsc]',
  ],
};

// Custom postcss plugin to extract responsive styles
const extractResponsive = postcss.plugin('extract-responsive', () => (root) => {
  const responsiveRules = [];
  root.walkAtRules('media', (atRule) => {
    if (atRule.params.includes('max-width') || atRule.params.includes('min-width')) {
      responsiveRules.push(atRule.toString());
      atRule.remove();
    }
  });
  return responsiveRules;
});

async function inlineEmailCSS(inputPath, outputPath) {
  let html = fs.readFileSync(inputPath, 'utf-8');

  // Step 1: Pack media queries
  const mqpacked = mqpacker.pack(html.match(/<style[^>]*>([\s\S]*?)<\/style>/gi)?.[0] || '');

  // Step 2: Inline CSS into HTML attributes
  const inlined = juice(html, {
    ...INLINE_CONFIG,
    extraCss: mqpacked.css || '',
  });

  // Step 3: Ensure Outlook conditionals survive
  const protected = inlined
    .replace(/<!--\[if mso\]>/g, '<!--[if mso]>')
    .replace(/<!\[endif\]-->/g, '<![endif]-->');

  // Step 4: Add MSO conditionals for dark mode if not present
  if (!protected.includes('data-ogsc') && !protected.includes('prefers-color-scheme')) {
    console.log('ℹ️  No dark mode support detected — consider adding dark mode CSS');
  }

  fs.writeFileSync(outputPath, protected, 'utf-8');
  console.log(`✅ Inlined CSS: ${outputPath}`);
  return protected;
}

// Run if called directly
if (require.main === module) {
  const input = process.argv[2] || 'dist/email.html';
  const output = process.argv[3] || 'dist/email-inline.html';
  inlineEmailCSS(input, output);
}

module.exports = { inlineEmailCSS, INLINE_CONFIG };
```

### 3. Email Accessibility Best Practices

```html
<!-- Accessible email with ARIA, semantic structure, and readable content -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#f4f4f4;">
  <tr>
    <td align="center" style="padding:20px;">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" style="background-color:#ffffff;">

        <!-- Skip navigation / main landmark -->
        <tr>
          <td role="article" aria-label="Email header" style="padding:20px 30px; border-bottom:2px solid #e0e0e0;">
            <img src="https://example.com/logo.png" width="150" height="45" alt="Company Name — Go to homepage" style="display:block;">
          </td>
        </tr>

        <!-- Main content -->
        <tr>
          <td role="article" aria-label="Email content" style="padding:30px;">
            <h1 style="margin:0 0 15px; font-size:24px; line-height:30px; color:#1a1a1a; font-family:Arial, sans-serif;">
              Your Monthly Report Is Ready
            </h1>
            <p style="margin:0 0 15px; font-size:16px; line-height:26px; color:#333333;">
              Hi Alex, here's a summary of your activity this month. We've highlighted key
              metrics and trends to help you make informed decisions.
            </p>

            <!-- Data table with accessible headers -->
            <table role="presentation" cellspacing="0" cellpadding="12" border="0" width="100%" style="margin:20px 0; border-collapse:collapse; border:1px solid #e0e0e0;">
              <thead>
                <tr style="background-color:#f8f9fa;">
                  <th scope="col" style="text-align:left; padding:12px; font-size:14px; font-weight:bold; color:#1a1a1a; border-bottom:2px solid #dee2e6;">Metric</th>
                  <th scope="col" style="text-align:right; padding:12px; font-size:14px; font-weight:bold; color:#1a1a1a; border-bottom:2px solid #dee2e6;">Last Month</th>
                  <th scope="col" style="text-align:right; padding:12px; font-size:14px; font-weight:bold; color:#1a1a1a; border-bottom:2px solid #dee2e6;">This Month</th>
                  <th scope="col" style="text-align:right; padding:12px; font-size:14px; font-weight:bold; color:#1a1a1a; border-bottom:2px solid #dee2e6;">Change</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td style="padding:12px; font-size:14px; color:#333333; border-bottom:1px solid #eee;">Page Views</td>
                  <td style="padding:12px; font-size:14px; color:#666666; text-align:right; border-bottom:1px solid #eee;">12,450</td>
                  <td style="padding:12px; font-size:14px; color:#333333; text-align:right; border-bottom:1px solid #eee; font-weight:bold;">15,820</td>
                  <td style="padding:12px; font-size:14px; color:#28a745; text-align:right; border-bottom:1px solid #eee; font-weight:bold;">↑ 27%</td>
                </tr>
                <tr>
                  <td style="padding:12px; font-size:14px; color:#333333; border-bottom:1px solid #eee;">Conversions</td>
                  <td style="padding:12px; font-size:14px; color:#666666; text-align:right; border-bottom:1px solid #eee;">342</td>
                  <td style="padding:12px; font-size:14px; color:#333333; text-align:right; border-bottom:1px solid #eee; font-weight:bold;">418</td>
                  <td style="padding:12px; font-size:14px; color:#28a745; text-align:right; border-bottom:1px solid #eee; font-weight:bold;">↑ 22%</td>
                </tr>
              </tbody>
            </table>

            <!-- CTA button with focus state and ARIA -->
            <table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin:25px 0;">
              <tr>
                <td style="background-color:#007bff; border-radius:6px;">
                  <a href="https://example.com/report/full"
                     role="button"
                     aria-label="View your complete monthly report"
                     style="display:inline-block; padding:14px 30px; font-family:Arial, sans-serif; font-size:16px; font-weight:bold; color:#ffffff; text-decoration:none; border-radius:6px;">
                    View Full Report →
                  </a>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <!-- Footer with unsubscribe and contact -->
        <tr>
          <td role="contentinfo" aria-label="Email footer" style="padding:20px 30px; background-color:#f8f9fa; border-top:1px solid #e0e0e0;">
            <p style="margin:0 0 8px; font-size:13px; line-height:20px; color:#666666; text-align:center;">
              Company Inc. · 123 Main Street · Suite 100 · San Francisco, CA 94105
            </p>
            <p style="margin:0; font-size:13px; line-height:20px; color:#666666; text-align:center;">
              You're receiving this because you subscribed to monthly reports.
              <a href="https://example.com/preferences" style="color:#007bff; text-decoration:underline;">Manage preferences</a> ·
              <a href="https://example.com/unsubscribe" style="color:#007bff; text-decoration:underline;">Unsubscribe</a>
            </p>
          </td>
        </tr>

      </table>
    </td>
  </tr>
</table>
```

### 4. AMP Email for Interactive Experiences

```html
<!-- AMP Email with interactive carousel and form -->
<!doctype html>
<html amp4email lang="en">
<head>
  <meta charset="utf-8">
  <script async src="https://cdn.ampproject.org/v0.js"></script>
  <script async custom-element="amp-carousel" src="https://cdn.ampproject.org/v0/amp-carousel-0.1.js"></script>
  <script async custom-element="amp-form" src="https://cdn.ampproject.org/v0/amp-form-0.1.js"></script>
  <script async custom-template="amp-mustache" src="https://cdn.ampproject.org/v0/amp-mustache-0.2.js"></script>
  <style amp4email-boilerplate>
    body { visibility: hidden; }
  </style>
</head>
<body style="margin:0; padding:0; font-family:Arial, sans-serif;">

  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#ffffff;">
    <tr>
      <td style="padding:20px; text-align:center;">
        <h1 style="margin:0 0 15px; font-size:24px; color:#1a1a1a;">Featured Products</h1>
      </td>
    </tr>
    <tr>
      <td style="padding:0 20px;">
        <!-- AMP Carousel -->
        <amp-carousel width="520" height="300" type="slides" layout="responsive">
          <amp-img src="https://example.com/product1.jpg" width="520" height="300" alt="Wireless Headphones — $79.99">
          </amp-img>
          <amp-img src="https://example.com/product2.jpg" width="520" height="300" alt="Smart Watch — $199.99">
          </amp-img>
          <amp-img src="https://example.com/product3.jpg" width="520" height="300" alt="USB-C Hub — $49.99">
          </amp-img>
        </amp-carousel>
      </td>
    </tr>

    <!-- Interactive form -->
    <tr>
      <td style="padding:30px;">
        <h2 style="margin:0 0 15px; font-size:20px; color:#1a1a1a;">Quick Feedback</h2>
        <form method="POST" action-xhr="https://api.example.com/feedback" target="_blank">
          <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr>
              <td>
                <label for="rating" style="display:block; margin-bottom:5px; font-size:14px; color:#333;">How would you rate us?</label>
                <select id="rating" name="rating" style="width:100%; padding:10px; font-size:16px; border:1px solid #ccc; border-radius:4px;">
                  <option value="5">⭐⭐⭐⭐⭐ Excellent</option>
                  <option value="4">⭐⭐⭐⭐ Good</option>
                  <option value="3">⭐⭐⭐ Average</option>
                  <option value="2">⭐⭐ Below Average</option>
                  <option value="1">⭐ Poor</option>
                </select>
              </td>
            </tr>
            <tr>
              <td style="padding-top:15px;">
                <input type="submit" value="Submit Feedback" style="display:inline-block; padding:12px 24px; background-color:#007bff; color:#ffffff; border:none; border-radius:6px; font-size:16px; font-weight:bold; cursor:pointer;">
              </td>
            </tr>
          </table>
          <div submit-success style="display:none; padding:15px; background-color:#d4edda; border-radius:4px; margin-top:15px;">
            <template type="amp-mustache">
              <p style="margin:0; color:#155724;">Thank you! Your feedback has been recorded.</p>
            </template>
          </div>
          <div submit-error style="display:none; padding:15px; background-color:#f8d7da; border-radius:4px; margin-top:15px;">
            <template type="amp-mustache">
              <p style="margin:0; color:#721c24;">Something went wrong. Please try again.</p>
            </template>
          </div>
        </form>
      </td>
    </tr>

    <!-- Fallback for non-AMP clients -->
    <tr>
      <td style="padding:20px; text-align:center; border-top:1px solid #eee;">
        <p style="margin:0; font-size:14px; color:#666666;">
          <a href="https://example.com/products" style="color:#007bff; text-decoration:underline;">View all products on our website →</a>
        </p>
      </td>
    </tr>
  </table>

</body>
</html>
```

### 5. Email Animations and Interactivity (CSS)

```html
<style>
  /* Fade-in animation for email clients that support it */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .animate-fade-in {
    animation: fadeInUp 0.6s ease-out forwards;
  }

  /* Countdown timer styling */
  .countdown-digit {
    display: inline-block;
    width: 50px;
    height: 50px;
    line-height: 50px;
    background-color: #dc3545;
    color: #ffffff;
    font-size: 24px;
    font-weight: bold;
    font-family: 'Courier New', monospace;
    text-align: center;
    border-radius: 6px;
    margin: 0 3px;
  }

  /* Hover effect for links (only where supported) */
  .hover-underline:hover {
    text-decoration: underline !important;
    color: #0056b3 !important;
  }

  /* Progressive enhancement: hide animated content if animations unsupported */
  @supports not (animation: fadeInUp 0.6s) {
    .animate-fade-in { opacity: 1 !important; transform: none !important; }
  }
</style>

<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr>
    <td class="animate-fade-in" style="padding:30px; text-align:center; background-color:#ffffff;">
      <h1 style="margin:0 0 15px; font-size:28px; color:#1a1a1a;">⏰ Sale Ends Soon!</h1>
      <p style="margin:0 0 20px; font-size:16px; color:#555555;">Don't miss out on exclusive savings.</p>

      <!-- Countdown timer display -->
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" align="center" style="margin:0 auto;">
        <tr>
          <td style="padding:0 3px;"><span class="countdown-digit">02</span></td>
          <td style="padding:0 3px; font-size:24px; color:#dc3545; font-weight:bold; vertical-align:middle;">:</td>
          <td style="padding:0 3px;"><span class="countdown-digit">14</span></td>
          <td style="padding:0 3px; font-size:24px; color:#dc3545; font-weight:bold; vertical-align:middle;">:</td>
          <td style="padding:0 3px;"><span class="countdown-digit">37</span></td>
        </tr>
        <tr>
          <td style="text-align:center; font-size:11px; color:#999999; padding-top:5px;">DAYS</td>
          <td></td>
          <td style="text-align:center; font-size:11px; color:#999999; padding-top:5px;">HOURS</td>
          <td></td>
          <td style="text-align:center; font-size:11px; color:#999999; padding-top:5px;">MINS</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
```

### 6. Email Testing and QA Automation

```javascript
// scripts/qa-email.js
// Automated QA checks for email templates
const fs = require('fs');
const path = require('path');

const QA_RULES = [
  {
    name: 'No external stylesheets',
    severity: 'error',
    test: (html) => !/<link[^>]+rel=["']stylesheet["'][^>]*>/i.test(html),
    message: 'External <link> stylesheets are stripped by most email clients',
  },
  {
    name: 'All tables have role="presentation"',
    severity: 'warning',
    test: (html) => {
      const tables = html.match(/<table[^>]*>/gi) || [];
      return tables.every(t => t.includes('role="presentation"'));
    },
    message: 'Layout tables must have role="presentation" for screen readers',
  },
  {
    name: 'All images have alt text',
    severity: 'warning',
    test: (html) => {
      const imgs = html.match(/<img[^>]*>/gi) || [];
      return imgs.every(i => /alt=["'][^"']+["']/i.test(i));
    },
    message: 'All images must have descriptive alt text for accessibility',
  },
  {
    name: 'No JavaScript',
    severity: 'error',
    test: (html) => !/<script(?![^>]*ampproject)[^>]*>/i.test(html),
    message: 'JavaScript is not allowed in standard HTML emails',
  },
  {
    name: 'Preheader text present',
    severity: 'info',
    test: (html) => /display:\s*none/i.test(html) || /max-height:\s*0/i.test(html),
    message: 'Consider adding hidden preheader text for inbox previews',
  },
  {
    name: 'Subject line length check',
    severity: 'info',
    test: (html) => {
      const title = html.match(/<title>([^<]*)<\/title>/i);
      if (!title) return true; // No title is ok, subject comes from ESP
      return title[1].length <= 60;
    },
    message: 'Keep title/subject under 60 characters for mobile preview',
  },
  {
    name: 'Unsubscribe link present',
    severity: 'error',
    test: (html) => /unsubscribe/i.test(html),
    message: 'CAN-SPAM requires an unsubscribe link in marketing emails',
  },
  {
    name: 'Physical address present',
    severity: 'error',
    test: (html) => {
      // Check for address patterns (numbers followed by street-like words)
      return /\d+\s+\w+\s+(street|st|ave|avenue|road|rd|blvd|drive|dr|suite|ste)/i.test(html)
        || /company.*inc|ltd|llc/i.test(html);
    },
    message: 'CAN-SPAM requires a valid physical postal address',
  },
  {
    name: 'Max width under 800px',
    severity: 'info',
    test: (html) => {
      const maxWidths = html.match(/max-width:\s*(\d+)px/gi) || [];
      return maxWidths.every(m => parseInt(m.match(/\d+/)[0]) <= 800);
    },
    message: 'Emails wider than 800px may not display well on mobile',
  },
  {
    name: 'Font size minimum 14px',
    severity: 'info',
    test: (html) => {
      const fontSizes = html.match(/font-size:\s*(\d+)px/gi) || [];
      return fontSizes.every(f => parseInt(f.match(/\d+/)[0]) >= 12);
    },
    message: 'Body text should be at least 14px for readability on mobile',
  },
  {
    name: 'Color contrast (basic check)',
    severity: 'info',
    test: (html) => {
      // Basic check: no light gray text on white background
      const lightColors = ['#ccc', '#ddd', '#eee', '#f0f0f0', '#999'];
      const hasLightOnWhite = lightColors.some(c => {
        const regex = new RegExp(`color:\\s*${c}`, 'i');
        return regex.test(html);
      });
      return !hasLightOnWhite;
    },
    message: 'Avoid very light text colors — may fail WCAG contrast requirements',
  },
];

function runQA(htmlPath) {
  const html = fs.readFileSync(htmlPath, 'utf-8');
  const fileName = path.basename(htmlPath);

  console.log(`\n📧 QA Report: ${fileName}`);
  console.log(`${'='.repeat(50)}\n`);

  let errors = 0;
  let warnings = 0;
  let infos = 0;

  for (const rule of QA_RULES) {
    const passed = rule.test(html);
    const icon = passed ? '✅' : rule.severity === 'error' ? '❌' : rule.severity === 'warning' ? '⚠️' : 'ℹ️';
    const status = passed ? 'PASS' : rule.severity.toUpperCase();

    console.log(`${icon} [${status}] ${rule.name}`);
    if (!passed) {
      console.log(`   → ${rule.message}`);
      if (rule.severity === 'error') errors++;
      else if (rule.severity === 'warning') warnings++;
      else infos++;
    }
  }

  console.log(`\n${'─'.repeat(50)}`);
  console.log(`Results: ${errors} errors, ${warnings} warnings, ${infos} info`);
  console.log(errors === 0 ? '✅ Template passes QA checks' : '❌ Template has critical issues');

  return { errors, warnings, infos, passed: errors === 0 };
}

// Run if called directly
if (require.main === module) {
  const file = process.argv[2] || 'dist/email-final.html';
  runQA(file);
}

module.exports = { runQA, QA_RULES };
```

### 7. Email Deliverability Best Practices

```javascript
// scripts/deliverability-check.js
// Check email template for deliverability red flags
const fs = require('fs');

const SPAM_TRIGGERS = [
  { phrase: /buy now/gi, weight: 3, category: 'sales' },
  { phrase: /limited time only/gi, weight: 2, category: 'urgency' },
  { phrase: /act now/gi, weight: 2, category: 'urgency' },
  { phrase: /free!!!/gi, weight: 4, category: 'spam' },
  { phrase: /click here/gi, weight: 1, category: 'generic' },
  { phrase: /100% free/gi, weight: 3, category: 'spam' },
  { phrase: /no obligation/gi, weight: 2, category: 'sales' },
  { phrase: /risk free/gi, weight: 1, category: 'sales' },
  { phrase: /winner/gi, weight: 3, category: 'prize' },
  { phrase: /congratulations/gi, weight: 2, category: 'prize' },
  { phrase: /dear friend/gi, weight: 3, category: 'generic' },
  { phrase: /you have been selected/gi, weight: 4, category: 'spam' },
  { phrase: /money back guarantee/gi, weight: 2, category: 'sales' },
  { phrase: /!!!{2,}/gi, weight: 3, category: 'emphasis' },
  { phrase: /\${2,}/gi, weight: 2, category: 'emphasis' },
  { phrase: /all caps text/gi, weight: 2, category: 'emphasis' },
];

function checkDeliverability(htmlPath) {
  const html = fs.readFileSync(htmlPath, 'utf-8');
  const textContent = html.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ');

  console.log('\n📬 Deliverability Analysis\n');
  console.log(`${'='.repeat(50)}\n`);

  let spamScore = 0;
  const findings = [];

  for (const trigger of SPAM_TRIGGERS) {
    const matches = textContent.match(trigger.phrase);
    if (matches) {
      spamScore += trigger.weight * matches.length;
      findings.push({
        phrase: matches[0],
        weight: trigger.weight,
        count: matches.length,
        category: trigger.category,
      });
    }
  }

  // Display findings
  if (findings.length === 0) {
    console.log('✅ No spam trigger phrases detected\n');
  } else {
    console.log('⚠️  Potential spam triggers found:\n');
    findings.forEach(f => {
      console.log(`  • "${f.phrase}" (${f.category}) — weight: ${f.weight} × ${f.count} = ${f.weight * f.count}`);
    });
    console.log('');
  }

  // Check text-to-image ratio
  const imageCount = (html.match(/<img/gi) || []).length;
  const textLength = textContent.length;
  const ratio = textLength / Math.max(imageCount, 1);

  console.log(`📊 Content Analysis:`);
  console.log(`  • Text length: ${textLength} characters`);
  console.log(`  • Image count: ${imageCount}`);
  console.log(`  • Text-to-image ratio: ${ratio.toFixed(0)} chars/image`);

  if (ratio < 200) {
    console.log('  ⚠️  Low text-to-image ratio may trigger spam filters');
    spamScore += 2;
  } else {
    console.log('  ✅ Text-to-image ratio is healthy');
  }

  // Overall score
  console.log(`\n${'─'.repeat(50)}`);
  console.log(`Spam Risk Score: ${spamScore}`);

  if (spamScore === 0) {
    console.log('✅ Low risk — template looks clean');
  } else if (spamScore <= 5) {
    console.log('⚠️  Low-Medium risk — review flagged items');
  } else if (spamScore <= 10) {
    console.log('⚠️  Medium risk — rewrite flagged phrases');
  } else {
    console.log('❌ High risk — significant deliverability concerns');
  }

  return { spamScore, findings, imageCount, textLength, ratio };
}

module.exports = { checkDeliverability, SPAM_TRIGGERS };
```

## Common Patterns

### Pattern 1: Hybrid Email Layout (Hybrid Coding Technique)

```html
<!-- Hybrid layout: fluid on mobile, fixed on desktop -->
<!-- No media queries needed for basic fluidity -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr>
    <td align="center" style="padding:20px;">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" style="max-width:600px;">
        <tr>
          <!-- Image column: auto-width, fluid on mobile -->
          <td class="stack-column" valign="top" width="260" style="max-width:260px;">
            <img src="https://example.com/hero.jpg" width="260" alt="Promotional image" class="fluid" style="width:260px; max-width:100%; height:auto; display:block;">
          </td>
          <!-- Spacer for desktop only -->
          <td width="20" style="font-size:0; line-height:0;">&nbsp;</td>
          <!-- Text column: auto-width, fluid on mobile -->
          <td class="stack-column" valign="top" width="320" style="max-width:320px;">
            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
              <tr>
                <td style="padding:10px 0; font-family:Arial, sans-serif;">
                  <h2 style="margin:0 0 10px; font-size:22px; line-height:28px; color:#1a1a1a;">Product Name</h2>
                  <p style="margin:0 0 15px; font-size:15px; line-height:22px; color:#555555;">
                    Compelling product description that drives engagement.
                  </p>
                  <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                    <tr>
                      <td style="background-color:#007bff; border-radius:4px;">
                        <a href="https://example.com/product" style="display:inline-block; padding:10px 24px; font-family:Arial, sans-serif; font-size:14px; color:#ffffff; text-decoration:none; font-weight:bold;">Shop Now</a>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
```

### Pattern 2: Stacked Footer with Unsubscribe Compliance

```html
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#2c2c2c;">
  <tr>
    <td style="padding:30px 40px;">
      <!-- Company info -->
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
          <td style="text-align:center; padding-bottom:20px; border-bottom:1px solid #444444;">
            <img src="https://example.com/logo-white.png" width="120" alt="Company Name" style="display:inline-block;">
          </td>
        </tr>
      </table>

      <!-- Links -->
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
          <td style="padding:20px 0; text-align:center; font-family:Arial, sans-serif;">
            <a href="https://example.com/help" style="display:inline-block; margin:0 10px; font-size:13px; color:#aaaaaa; text-decoration:none;">Help Center</a>
            <span style="color:#555555;">|</span>
            <a href="https://example.com/privacy" style="display:inline-block; margin:0 10px; font-size:13px; color:#aaaaaa; text-decoration:none;">Privacy Policy</a>
            <span style="color:#555555;">|</span>
            <a href="https://example.com/preferences" style="display:inline-block; margin:0 10px; font-size:13px; color:#aaaaaa; text-decoration:none;">Email Preferences</a>
          </td>
        </tr>
      </table>

      <!-- Legal compliance -->
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
          <td style="padding:15px 0 0; text-align:center; border-top:1px solid #444444; font-family:Arial, sans-serif;">
            <p style="margin:0 0 8px; font-size:12px; line-height:18px; color:#888888;">
              Company Inc. · 123 Main Street, Suite 500 · San Francisco, CA 94105 · United States
            </p>
            <p style="margin:0 0 8px; font-size:12px; line-height:18px; color:#888888;">
              You received this email because you signed up at example.com.
            </p>
            <p style="margin:0; font-size:12px; line-height:18px; color:#888888;">
              <a href="https://example.com/unsubscribe?token=abc123" style="color:#6cb4ee; text-decoration:underline;">Unsubscribe</a>
              · <a href="https://example.com/preferences" style="color:#6cb4ee; text-decoration:underline;">Manage Preferences</a>
            </p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
```

### Pattern 3: Single-Column Newsletter Template

```html
<!-- Single-column newsletter — maximum mobile readability -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color:#f7f7f7;">
  <tr>
    <td align="center" style="padding:20px 10px;">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="max-width:600px; background-color:#ffffff; border-radius:8px; overflow:hidden;">

        <!-- Header bar -->
        <tr>
          <td style="padding:20px 30px; background-color:#ffffff; border-bottom:1px solid #eeeeee;">
            <img src="https://example.com/logo.png" width="140" alt="Company" style="display:inline-block; vertical-align:middle;">
            <span style="display:inline-block; vertical-align:middle; margin-left:10px; font-family:Arial, sans-serif; font-size:13px; color:#999999;">Monthly Newsletter · January 2025</span>
          </td>
        </tr>

        <!-- Article 1 -->
        <tr>
          <td style="padding:30px 30px 20px; font-family:Arial, sans-serif;">
            <img src="https://example.com/article1.jpg" width="540" alt="Article 1 header image" style="width:100%; max-width:540px; height:auto; display:block; border-radius:4px;">
            <h2 style="margin:20px 0 10px; font-size:22px; line-height:28px; color:#1a1a1a;">
              <a href="https://example.com/article1" style="color:#1a1a1a; text-decoration:none;">The Future of Web Development in 2025</a>
            </h2>
            <p style="margin:0 0 15px; font-size:15px; line-height:24px; color:#555555;">
              Exploring the trends that will shape how we build for the web this year and beyond.
            </p>
            <a href="https://example.com/article1" style="font-size:14px; color:#007bff; text-decoration:none; font-weight:bold;">Read more →</a>
          </td>
        </tr>

        <tr><td style="padding:0 30px;"><hr style="border:none; border-top:1px solid #eeeeee; margin:0;"></td></tr>

        <!-- Article 2 -->
        <tr>
          <td style="padding:20px 30px 30px; font-family:Arial, sans-serif;">
            <h2 style="margin:0 0 10px; font-size:22px; line-height:28px; color:#1a1a1a;">
              <a href="https://example.com/article2" style="color:#1a1a1a; text-decoration:none;">Building Accessible Email Templates</a>
            </h2>
            <p style="margin:0 0 15px; font-size:15px; line-height:24px; color:#555555;">
              Why email accessibility matters and practical steps to make your emails inclusive for all readers.
            </p>
            <a href="https://example.com/article2" style="font-size:14px; color:#007bff; text-decoration:none; font-weight:bold;">Read more →</a>
          </td>
        </tr>

        <!-- Footer -->
        <tr>
          <td style="padding:20px 30px; background-color:#f8f9fa; text-align:center; font-family:Arial, sans-serif;">
            <p style="margin:0 0 5px; font-size:12px; color:#999999;">
              © 2025 Company Inc. · 123 Main St, San Francisco, CA
            </p>
            <p style="margin:0; font-size:12px; color:#999999;">
              <a href="https://example.com/unsubscribe" style="color:#666666; text-decoration:underline;">Unsubscribe</a>
            </p>
          </td>
        </tr>

      </table>
    </td>
  </tr>
</table>
```

### Pattern 4: Bulletproof Button System

```html
<!-- Cross-client button that renders perfectly in all email clients -->
<!-- Usage: wrap in <td style="padding:X;"> for spacing -->

<style>
  .btn-primary {
    background-color: #007bff;
    border-radius: 6px;
    text-align: center;
  }
  .btn-primary a {
    display: inline-block;
    padding: 14px 32px;
    font-family: Arial, sans-serif;
    font-size: 16px;
    font-weight: bold;
    color: #ffffff;
    text-decoration: none;
    border-radius: 6px;
  }
  .btn-secondary {
    background-color: #ffffff;
    border: 2px solid #007bff;
    border-radius: 6px;
    text-align: center;
  }
  .btn-secondary a {
    display: inline-block;
    padding: 12px 30px;
    font-family: Arial, sans-serif;
    font-size: 16px;
    font-weight: bold;
    color: #007bff;
    text-decoration: none;
    border-radius: 6px;
  }
</style>

<!-- Primary button -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td class="btn-primary" style="background-color:#007bff; border-radius:6px;">
      <!--[if mso]>
      <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="https://example.com/action" style="height:48px;v-text-anchor:middle;width:200px;" arcsize="13%" strokecolor="#007bff" fillcolor="#007bff">
      <w:anchorlock/>
      <center style="color:#ffffff;font-family:Arial,sans-serif;font-size:16px;font-weight:bold;">Get Started</center>
      </v:roundrect>
      <![endif]-->
      <!--[if !mso]><!-->
      <a href="https://example.com/action" style="display:inline-block; padding:14px 32px; font-family:Arial, sans-serif; font-size:16px; font-weight:bold; color:#ffffff; text-decoration:none; border-radius:6px;">Get Started</a>
      <!--<![endif]-->
    </td>
  </tr>
</table>

<!-- Secondary (outline) button -->
<table role="presentation" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td class="btn-secondary" style="background-color:#ffffff; border:2px solid #007bff; border-radius:6px;">
      <a href="https://example.com/learn-more" style="display:inline-block; padding:12px 30px; font-family:Arial, sans-serif; font-size:16px; font-weight:bold; color:#007bff; text-decoration:none; border-radius:6px;">Learn More</a>
    </td>
  </tr>
</table>
```

### Pattern 5: Transactional Receipt Template (Order Confirmation)

```html
<!-- Transactional emails: highest engagement → strictest clarity.
     Fixed 600px, plain tables, order data in text (not images),
     totals block right-aligned, support links duplicated top & bottom. -->
<table role="presentation" width="600" cellspacing="0" cellpadding="0" border="0" style="margin:0 auto;">
  <tr><td style="padding:20px 24px; font-family:Arial,sans-serif; font-size:15px; color:#333333;">
    <h1 style="margin:0 0 8px; font-size:22px;">Order confirmed ✓</h1>
    <p style="margin:0;">Order <strong>#{{order_id}}</strong> — placed {{order_date}}</p>
  </td></tr>

  {{#each items}}
  <tr>
    <td style="padding:12px 24px; border-top:1px solid #eeeeee; font-family:Arial,sans-serif; font-size:14px;">
      {{name}} × {{qty}}
      <span style="float:right;">{{line_total}}</span>
    </td>
  </tr>
  {{/each}}

  <tr>
    <td style="padding:16px 24px; border-top:2px solid #333333; font-family:Arial,sans-serif; font-size:15px;" align="right">
      <strong>Total: {{grand_total}}</strong><br>
      <span style="font-size:12px; color:#777777;">Includes {{tax_total}} tax · {{currency}}</span>
    </td>
  </tr>

  <tr><td style="padding:16px 24px; font-family:Arial,sans-serif; font-size:13px;">
    Questions? Reply to this email or view
    <a href="{{order_url}}" style="color:#007bff;">your order status</a>.
  </td></tr>
</table>
```

**Rules of thumb:** never render prices as images (they break and get flagged), include the order number in the subject line, and always send from a reply-capable address — receipts are the #1 email customers reply to.

## Edge Cases & Pitfalls

### 1. **Gmail Strips `<style>` Tags in Non-WebKit Views**
Gmail's web interface wraps the email in a `data-ogsb` frame and strips `<style>` tags in some rendering modes. **Solution**: Always inline critical CSS with a tool like `juice`. Keep `<style>` for progressive enhancements (dark mode, hover states) but don't rely on them for layout.

### 2. **Outlook 2016–2019 Uses Word Rendering Engine**
Outlook on Windows uses Microsoft Word's HTML engine, not a browser engine. This means no `background-image`, limited `border-radius`, no `max-width`, and broken CSS Grid/Flexbox. **Solution**: Use VML for backgrounds, bulletproof buttons with `v:roundrect`, and `<!--[if mso]>` conditionals for Outlook-specific fixes.

### 3. **Yahoo Mail Wraps Media Queries in `<style>` Data Attributes**
Yahoo strips standard `<style>` blocks but preserves them when wrapped in `data-ogsc` attributes or within specific comment structures. **Solution**: Use `@media (prefers-color-scheme: dark)` for dark mode — Yahoo preserves this — and test with Litmus/Email on Acid.

### 4. **Mobile Clients Add Their Own Styles**
iOS Mail and Gmail Android inject their own styles (link colors, button styling, font sizes) that override your CSS. **Solution**: Use `!important` on critical mobile overrides. Add `-webkit-text-size-adjust: none` to prevent font boosting. Use `max-width` with `!important` on mobile containers.

### 5. **Images Blocked by Default**
Most email clients (Outlook, Gmail, Apple Mail) block images by default. Your email must remain readable and actionable without images. **Solution**: Always provide meaningful `alt` text. Use solid background colors as fallbacks. Structure emails so text content is self-contained.

### 6. **Preheader Text Shows Body Content**
If no preheader text is set, email clients will show the first text content of the email as the inbox preview. This often results in "View in browser" or navigation links appearing as the preview. **Solution**: Add a hidden `<div>` with `display:none; max-height:0; overflow:hidden;` containing your preview text, placed immediately after `<body>`.

### 7. **Dark Mode Inverts Colors Unexpectedly**
Some email clients (Apple Mail, Outlook dark mode) automatically invert light backgrounds to dark, turning your carefully designed light theme into an unreadable mess. **Solution**: Use explicit dark mode CSS with `@media (prefers-color-scheme: dark)` and test both modes. Provide both light and dark background colors.

### 8. **Responsive Images Break in Outlook**
Outlook ignores `max-width` on `<img>` tags and renders them at their native `width` attribute. A 600px image with `max-width:100%` will overflow on a 320px mobile screen in Outlook. **Solution**: Use `width="100%"` with `max-width:600px` — Outlook respects `width="100%"` while browsers use `max-width`. Always set both attributes.

### 9. **Font Fallbacks Change Line Heights**
When a custom font fails to load, the fallback font may have different metrics, causing text to overlap or gaps to appear. **Solution**: Set explicit `line-height` values (in px, not relative units) on all text elements. Test with fonts disabled. Use web-safe fallbacks: `Arial, Helvetica, sans-serif` for body, `Georgia, serif` for headings.

### 10. **Hidden Preheader Text Can Appear**
If the preheader `<div>` has any content after it in the DOM that isn't properly hidden, email clients may pull unintended text into the preview. **Solution**: Place the preheader `<div>` as the very first element inside `<body>`, use `display:none` AND `mso-hide:all` for Outlook. Don't put any visible content before the preheader.

### 11. **CSS `display:none` Doesn't Work in All Clients**
Some email clients (particularly older Outlook versions) ignore `display:none` and show hidden elements. **Solution**: Use the full hiding stack: `display:none !important; mso-hide:all; visibility:hidden; max-height:0; overflow:hidden; font-size:1px; line-height:1px;`.

### 12. **Two-Column Layout Stacks Incorrectly**
Hybrid coding and `<!--[if mso]>` conditionals are complex to get right. If the VML conditional width doesn't match the CSS `max-width`, columns may overlap or stack incorrectly. **Solution**: Keep conditional widths and CSS widths identical. Use `align="center"` on the MSO wrapper. Test with Litmus screenshots.

### 13. **Anchor Links Break in Threaded Conversations**
When an email is replied to or forwarded, anchor links (`#section`) may point to the wrong content or break entirely in threaded views. **Solution**: Don't rely on anchor links for critical navigation. Use full URLs to a hosted web version for complex navigation.

### 14. **Emoji in Subject Lines May Render Differently**
Emoji characters render differently across email clients and operating systems. A 🔥 on Apple looks different from Outlook on Windows, and some clients show the raw Unicode codepoint. **Solution**: Test emoji rendering across major clients. Avoid emoji in critical CTAs. Use well-supported emoji (check Emojipedia for cross-platform status).

### 15. **Email Width Exceeds Mobile Screen**
Desktop-designed emails at 600–700px wide will require horizontal scrolling on 320px mobile screens. Some clients don't support responsive CSS at all. **Solution**: Design mobile-first. Use `max-width:100%` on all containers. Implement fluid hybrid layout with `min-width` fallbacks. Always test at 320px width.

## Integration with Other Skills

| Skill | Relationship | How It Integrates |
|-------|-------------|-------------------|
| **CSS Animations** | Uses animation techniques | Email-safe keyframe animations, transitions where supported |
| **Performance Optimization** | Performance patterns | Image optimization, lazy loading in supported clients, reducing HTML size |
| **Web Accessibility** | Accessibility patterns | WCAG compliance in emails, screen reader compatibility, ARIA roles |
| **SEO** | No direct overlap | Email is not crawlable by search engines |
| **Content Writing** | Content creation | Email copywriting, subject lines, preheader text optimization |
| **Marketing Automation** | Integration target | ESP platform integration, A/B testing, send-time optimization |
| **Analytics** | Tracking integration | Open tracking, click tracking, UTM parameters |

## Output Format Templates

### Template 1: Marketing Email Template

```html
<!-- Structure: Header → Hero → Features → CTA → Footer -->
<!-- Use for: Campaign emails, product launches, announcements -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>EMAIL_SUBJECT</title>
  <style>/* Reset + responsive + dark mode styles */</style>
</head>
<body>
  <div style="display:none; max-height:0; overflow:hidden; mso-hide:all;">
    PREHEADER_TEXT_HERE (max 150 chars)
  </div>
  <!-- Outer wrapper with background color -->
  <table role="presentation" width="100%" style="background:#F4F4F4;">
    <tr><td align="center" style="padding:20px 0;">
      <!-- Email container -->
      <table role="presentation" width="100%" style="max-width:600px;">
        <!-- Header with logo -->
        <tr><td style="background:#FFF; padding:20px; text-align:center;">
          <img src="LOGO_URL" alt="COMPANY_NAME" width="150">
        </td></tr>
        <!-- Hero section -->
        <tr><td style="background:#007BFF; padding:40px; text-align:center;">
          <h1 style="color:#FFF;">HERO_HEADING</h1>
          <p style="color:#FFF;">HERO_SUBTEXT</p>
          <a href="CTA_URL" style="background:#FFF; color:#007BFF; padding:14px 30px;">CTA_TEXT</a>
        </td></tr>
        <!-- Features (2-3 columns) -->
        <tr><td style="background:#FFF; padding:30px;">
          <!-- Column layout here -->
        </td></tr>
        <!-- Footer -->
        <tr><td style="background:#333; padding:20px; text-align:center; color:#999; font-size:12px;">
          <p>COMPANY · ADDRESS</p>
          <p><a href="UNSUB_URL" style="color:#FFF;">Unsubscribe</a></p>
        </td></tr>
      </table>
    </td></tr>
  </table>
</body>
</html>
```

### Template 2: Transactional Email Template

```html
<!-- Structure: Minimal, high deliverability, no marketing -->
<!-- Use for: Password reset, receipts, notifications, confirmations -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>TRANSACTIONAL_SUBJECT</title>
  <style>/* Minimal reset + responsive */</style>
</head>
<body style="margin:0; padding:0; background:#f0f0f0;">
  <table role="presentation" width="100%" style="background:#f0f0f0;">
    <tr><td align="center" style="padding:20px;">
      <table role="presentation" width="100%" style="max-width:500px; background:#fff; border-radius:8px;">
        <tr><td style="padding:30px; text-align:center;">
          <img src="LOGO_URL" alt="COMPANY" width="120" style="margin-bottom:20px;">
          <h1 style="font-size:20px; color:#1a1a1a;">TRANSACTIONAL_HEADING</h1>
          <p style="font-size:15px; color:#555; line-height:24px;">TRANSACTIONAL_BODY</p>
          <!-- Optional CTA -->
          <a href="ACTION_URL" style="display:inline-block; padding:12px 24px; background:#007bff; color:#fff; border-radius:4px; text-decoration:none;">ACTION_TEXT</a>
        </td></tr>
        <tr><td style="padding:15px 30px; border-top:1px solid #eee; text-align:center; font-size:12px; color:#999;">
          <p>COMPANY · ADDRESS</p>
          <p><a href="HELP_URL" style="color:#666;">Need help? Contact us</a></p>
        </td></tr>
      </table>
    </td></tr>
  </table>
</body>
</html>
```

### Template 3: Newsletter Template

```html
<!-- Structure: Header → Multiple articles → Social links → Footer -->
<!-- Use for: Content newsletters, digest emails, roundups -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>NEWSLETTER_TITLE</title>
  <style>/* Reset + responsive + article styles */</style>
</head>
<body style="margin:0; padding:0; background:#f7f7f7;">
  <table role="presentation" width="100%" style="background:#f7f7f7;">
    <tr><td align="center" style="padding:20px;">
      <table role="presentation" width="100%" style="max-width:600px; background:#fff;">
        <!-- Header -->
        <tr><td style="padding:20px 30px; border-bottom:1px solid #eee;">
          <img src="LOGO_URL" alt="NEWSLETTER_NAME" width="130">
          <span style="float:right; font-size:13px; color:#999;">ISSUE_DATE</span>
        </td></tr>
        <!-- Article 1 -->
        <tr><td style="padding:25px 30px; border-bottom:1px solid #eee;">
          <h2 style="margin:0 0 8px; font-size:20px;"><a href="ARTICLE_1_URL" style="color:#1a1a1a; text-decoration:none;">ARTICLE_1_TITLE</a></h2>
          <p style="margin:0; font-size:15px; color:#555;">ARTICLE_1_EXCERPT</p>
          <a href="ARTICLE_1_URL" style="font-size:14px; color:#007bff;">Read more →</a>
        </td></tr>
        <!-- Article 2 -->
        <tr><td style="padding:25px 30px; border-bottom:1px solid #eee;">
          <h2 style="margin:0 0 8px; font-size:20px;"><a href="ARTICLE_2_URL" style="color:#1a1a1a; text-decoration:none;">ARTICLE_2_TITLE</a></h2>
          <p style="margin:0; font-size:15px; color:#555;">ARTICLE_2_EXCERPT</p>
          <a href="ARTICLE_2_URL" style="font-size:14px; color:#007bff;">Read more →</a>
        </td></tr>
        <!-- Footer -->
        <tr><td style="padding:20px 30px; background:#f8f9fa; text-align:center; font-size:12px; color:#999;">
          <p style="margin:0 0 8px;">COMPANY · ADDRESS</p>
          <p style="margin:0;"><a href="UNSUB_URL" style="color:#666;">Unsubscribe</a></p>
        </td></tr>
      </table>
    </td></tr>
  </table>
</body>
</html>
```

### Template 4: MJML Build Configuration

```json
{
  "mjml": {
    "minifyOptions": {
      "collapseWhitespace": true,
      "removeComments": true,
      "removeEmptyAttributes": true
    },
    "beautify": false
  },
  "validation": {
    "level": "soft",
    "fonts": {
      "Arial, Helvetica, sans-serif": "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
    }
  },
  "compilation": {
    "outputDir": "dist/",
    "templateDir": "templates/",
    "partialsDir": "templates/partials/",
    "variablesFile": "config/variables.json"
  }
}
```

## Rules

1. **Always use `role="presentation"` on layout tables** — this tells screen readers the table is for layout, not data
2. **Always provide `alt` text on every image** — many clients block images by default; alt text is your fallback
3. **Always inline critical CSS** — never rely on `<style>` blocks for layout or essential styling
4. **Never use JavaScript** in standard HTML emails — it is stripped by all major email clients (except AMP emails)
5. **Never use external stylesheets** — `<link rel="stylesheet">` is stripped by every email client
6. **Always test at 320px, 600px, and 800px widths** — cover mobile, tablet, and desktop viewports
7. **Always include an unsubscribe link** — CAN-SPAM and GDPR require it for marketing emails
8. **Always include a physical mailing address** — CAN-SPAM legal requirement for commercial emails
9. **Never use CSS Grid or Flexbox** for layout — use `<table>` elements for cross-client compatibility
10. **Always set both `width` and `max-width`** on containers — Outlook needs `width`, modern clients need `max-width`
11. **Keep total email HTML under 102KB** — Gmail clips emails larger than 102KB, hiding content behind a "View entire message" link
12. **Use semantic `<h1>`–`<h3>` headings** — even in table-based layouts, heading hierarchy helps accessibility
13. **Always use HTTPS for all image and link URLs** — HTTP content may be blocked or flagged as insecure
14. **Never rely solely on color to convey meaning** — add icons, text labels, or patterns for color-blind users
15. **Always add MSO conditionals for Outlook** — `<!--[if mso]>` blocks are essential for Windows Outlook compatibility
