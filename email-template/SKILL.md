---
name: email-template
description: >-
  Design and code responsive HTML email templates that work across all email clients.
  Use this skill when the user mentions email template, email design, HTML email, responsive email,
  email layout, newsletter template, transactional email, marketing email, email header,
  email footer, email CTA, email branding, dark mode email, email accessibility,
  or says قالب ایمیل، طراحی ایمیل، ایمیل HTML، قالب خبرنامه.
---

# Email Template Skill — Responsive HTML Email Design

## Overview

This skill creates HTML email templates that work across all major email clients (Gmail, Outlook, Apple Mail, Yahoo, etc.). Email HTML is NOT web HTML — email clients have limited CSS support, inconsistent rendering, and unique quirks. This skill uses table-based layouts, inline styles, and battle-tested patterns to ensure emails look great everywhere.

## When to Use This Skill

- User wants to create an HTML email template
- User needs a newsletter, transactional, or marketing email
- User asks about responsive email design
- User mentions email template, HTML email, or email layout
- User says قالب ایمیل or طراحی ایمیل

---

## Part 1: Email Client Quirks

### CSS Support by Client

| Feature | Gmail | Outlook | Apple Mail | Yahoo |
|---------|-------|---------|------------|-------|
| `<style>` block | ✅ | ❌ (uses Word) | ✅ | ✅ |
| Inline styles | ✅ | ✅ | ✅ | ✅ |
| Flexbox | ✅ | ❌ | ✅ | ✅ |
| Grid | ❌ | ❌ | ✅ | ❌ |
| Media queries | ✅ | ❌ | ✅ | ✅ |
| Background images | ✅ | ⚠️ (VML) | ✅ | ✅ |
| Web fonts | ✅ | ❌ | ✅ | ✅ |
| SVG | ❌ | ❌ | ✅ | ❌ |

### Golden Rules

1. **Use table-based layout** — Divs are unreliable in Outlook
2. **Inline all styles** — `<style>` blocks are stripped by some clients
3. **Use web-safe fonts** — Arial, Helvetica, Georgia, Times New Roman
4. **Keep width ≤ 600px** — Standard email width
5. **Test in Litmus or Email on Acid** — Never trust just one client

---

## Part 2: Base Template

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="x-apple-disable-message-reformatting">
  <title>Email Title</title>
  
  <!--[if mso]>
  <noscript>
    <xml>
      <o:OfficeDocumentSettings>
        <o:AllowPNG/>
        <o:PixelsPerInch>96</o:PixelsPerInch>
      </o:OfficeDocumentSettings>
    </xml>
  </noscript>
  <![endif]-->
  
  <style>
    /* Reset */
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { margin: 0 !important; padding: 0 !important; width: 100% !important; }
    
    /* Mobile */
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; max-width: 600px !important; }
      .fluid { max-width: 100% !important; height: auto !important; }
      .stack-column { display: block !important; width: 100% !important; }
      .center-on-narrow { text-align: center !important; display: block !important; margin-left: auto !important; margin-right: auto !important; float: none !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f4f4; font-family: Arial, Helvetica, sans-serif;">
  
  <!-- Preview text (hidden) -->
  <div style="display: none; font-size: 1px; color: #f4f4f4; line-height: 1px; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;">
    Preview text goes here...
  </div>
  
  <!-- Email body -->
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f4f4f4;">
    <tr>
      <td align="center" style="padding: 20px 0;">
        
        <!-- 600px container -->
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" class="email-container" style="background-color: #ffffff;">
          
          <!-- HEADER -->
          <tr>
            <td style="padding: 20px; text-align: center; background-color: #333333;">
              <img src="https://example.com/logo.png" alt="Company Name" width="150" style="display: block; margin: 0 auto;">
            </td>
          </tr>
          
          <!-- BODY -->
          <tr>
            <td style="padding: 40px 30px; font-size: 16px; line-height: 1.6; color: #333333;">
              <h1 style="margin: 0 0 20px; font-size: 24px; color: #333333;">Hello!</h1>
              <p style="margin: 0 0 20px;">Your email content goes here.</p>
            </td>
          </tr>
          
          <!-- CTA BUTTON -->
          <tr>
            <td style="padding: 0 30px 40px; text-align: center;">
              <table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin: 0 auto;">
                <tr>
                  <td style="border-radius: 4px; background-color: #007bff;">
                    <a href="https://example.com" target="_blank" style="display: inline-block; padding: 14px 30px; font-size: 16px; color: #ffffff; text-decoration: none; border-radius: 4px;">Call to Action</a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- FOOTER -->
          <tr>
            <td style="padding: 20px 30px; text-align: center; font-size: 12px; color: #999999; background-color: #f8f8f8;">
              <p style="margin: 0 0 10px;">Company Name, 123 Street, City, Country</p>
              <p style="margin: 0;">
                <a href="https://example.com/unsubscribe" style="color: #999999; text-decoration: underline;">Unsubscribe</a> | 
                <a href="https://example.com/preferences" style="color: #999999; text-decoration: underline;">Preferences</a>
              </p>
            </td>
          </tr>
          
        </table>
        
      </td>
    </tr>
  </table>
  
</body>
</html>
```

---

## Part 3: Common Patterns

### Two-Column Layout

```html
<tr>
  <td style="padding: 20px 30px;">
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
      <tr>
        <!-- Column 1 -->
        <td class="stack-column" width="50%" valign="top" style="padding: 0 10px;">
          <img src="https://example.com/image1.jpg" alt="" width="250" style="width: 100%; max-width: 250px;">
          <h2 style="font-size: 18px; color: #333;">Title 1</h2>
          <p style="font-size: 14px; color: #666;">Description 1</p>
        </td>
        <!-- Column 2 -->
        <td class="stack-column" width="50%" valign="top" style="padding: 0 10px;">
          <img src="https://example.com/image2.jpg" alt="" width="250" style="width: 100%; max-width: 250px;">
          <h2 style="font-size: 18px; color: #333;">Title 2</h2>
          <p style="font-size: 14px; color: #666;">Description 2</p>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### Hero Image with Text Overlay

```html
<tr>
  <td style="background-image: url('https://example.com/hero.jpg'); background-size: cover; background-position: center; padding: 60px 30px; text-align: center;">
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
      <tr>
        <td style="font-size: 32px; font-weight: bold; color: #ffffff; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">
          Big Headline
        </td>
      </tr>
      <tr>
        <td style="font-size: 16px; color: #ffffff; padding-top: 10px;">
          Subheadline text goes here
        </td>
      </tr>
      <tr>
        <td style="padding-top: 20px;">
          <a href="https://example.com" style="display: inline-block; padding: 14px 30px; background-color: #ff6b00; color: #ffffff; text-decoration: none; border-radius: 4px; font-weight: bold;">Shop Now</a>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### Social Links

```html
<tr>
  <td style="padding: 20px; text-align: center;">
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin: 0 auto;">
      <tr>
        <td style="padding: 0 8px;">
          <a href="https://twitter.com/company"><img src="https://example.com/twitter.png" alt="Twitter" width="32" height="32"></a>
        </td>
        <td style="padding: 0 8px;">
          <a href="https://linkedin.com/company"><img src="https://example.com/linkedin.png" alt="LinkedIn" width="32" height="32"></a>
        </td>
        <td style="padding: 0 8px;">
          <a href="https://instagram.com/company"><img src="https://example.com/instagram.png" alt="Instagram" width="32" height="32"></a>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

---

## Part 4: Dark Mode Support

```html
<style>
  /* Dark mode */
  @media (prefers-color-scheme: dark) {
    .email-body { background-color: #1a1a1a !important; }
    .email-content { background-color: #2d2d2d !important; }
    .email-text { color: #ffffff !important; }
    .email-heading { color: #ffffff !important; }
    .email-link { color: #6db3f2 !important; }
  }
</style>

<!-- In email body -->
<td class="email-body" style="background-color: #f4f4f4;">
  <table class="email-content" style="background-color: #ffffff;">
    <tr>
      <td class="email-text" style="color: #333333; font-size: 16px;">
        <h1 class="email-heading" style="color: #333333;">Hello!</h1>
        <p>Your content here.</p>
        <a class="email-link" href="https://example.com" style="color: #007bff;">Click here</a>
      </td>
    </tr>
  </table>
</td>
```

---

## Part 5: Transactional Email Patterns

### Welcome Email

```html
<!-- Welcome email structure -->
<tr>
  <td style="padding: 40px 30px; text-align: center;">
    <img src="https://example.com/logo.png" alt="Logo" width="120">
    <h1 style="font-size: 24px; color: #333; margin: 20px 0 10px;">Welcome, {{name}}!</h1>
    <p style="font-size: 16px; color: #666; margin: 0 0 30px;">Thanks for joining us. Here's what you can do next:</p>
  </td>
</tr>

<!-- Steps -->
<tr>
  <td style="padding: 0 30px 40px;">
    <table role="presentation" width="100%">
      <tr>
        <td width="50" valign="top" style="padding-right: 15px;">
          <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #007bff; color: #fff; text-align: center; line-height: 40px; font-weight: bold;">1</div>
        </td>
        <td valign="top" style="padding-bottom: 20px;">
          <strong style="color: #333;">Complete your profile</strong>
          <p style="margin: 5px 0 0; color: #666; font-size: 14px;">Add your photo and bio to get started.</p>
        </td>
      </tr>
      <tr>
        <td width="50" valign="top" style="padding-right: 15px;">
          <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #007bff; color: #fff; text-align: center; line-height: 40px; font-weight: bold;">2</div>
        </td>
        <td valign="top" style="padding-bottom: 20px;">
          <strong style="color: #333;">Explore features</strong>
          <p style="margin: 5px 0 0; color: #666; font-size: 14px;">Discover what our platform can do for you.</p>
        </td>
      </tr>
    </table>
  </td>
</tr>
```

### Password Reset

```html
<tr>
  <td style="padding: 40px 30px; text-align: center;">
    <h1 style="font-size: 24px; color: #333;">Reset Your Password</h1>
    <p style="font-size: 16px; color: #666;">Click the button below to reset your password. This link expires in 24 hours.</p>
    
    <!-- Button -->
    <table role="presentation" style="margin: 30px auto;">
      <tr>
        <td style="border-radius: 4px; background-color: #dc3545;">
          <a href="{{reset_url}}" style="display: inline-block; padding: 14px 30px; font-size: 16px; color: #ffffff; text-decoration: none;">Reset Password</a>
        </td>
      </tr>
    </table>
    
    <p style="font-size: 14px; color: #999;">If you didn't request this, please ignore this email.</p>
  </td>
</tr>
```

---

## Part 6: Testing Checklist

| Client | Platform | Status |
|--------|----------|--------|
| Gmail | Web | ☐ |
| Gmail | Mobile (iOS) | ☐ |
| Gmail | Mobile (Android) | ☐ |
| Outlook | Desktop (Windows) | ☐ |
| Outlook | Web | ☐ |
| Apple Mail | macOS | ☐ |
| Apple Mail | iOS | ☐ |
| Yahoo Mail | Web | ☐ |
| Yahoo Mail | Mobile | ☐ |

### Testing Tools

| Tool | URL | Price |
|------|-----|-------|
| **Litmus** | https://litmus.com | Paid |
| **Email on Acid** | https://www.emailonacid.com | Paid |
| **Mailchimp** | https://mailchimp.com | Free preview |
| **PutsMail** | https://putsmail.com | Free |

---

## Output Format

```
## Email Template

### Type
[Transactional / Marketing / Newsletter]

### Design
- Width: 600px
- Fonts: [fonts used]
- Colors: [brand colors]

### Tested Clients
[List of tested clients]

### Template Code
[HTML code]

### Usage
[How to use with email service]
```

## Rules

- **Use table-based layout** — Divs don't work in Outlook
- **Inline all styles** — Some clients strip `<style>` blocks
- **Keep it simple** — Complex layouts break in different clients
- **600px max width** — Standard email width
- **Always include preview text** — Improves open rates
- **Test in multiple clients** — Never assume it works everywhere
- **Include unsubscribe link** — Legal requirement (CAN-SPAM, GDPR)
- **Optimize images** — Emails should load fast on mobile
