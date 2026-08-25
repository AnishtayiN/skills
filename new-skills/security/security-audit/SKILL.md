---
name: security-audit
description: >-
  Security review: secrets, injection, auth, dependencies, OWASP Top 10.
  TRIGGERS: security, vulnerability, secret, hardcode, api key, password, injection, sql injection,
  xss, csrf, ssrf, authentication, authorization, owasp, security audit, penetration,
  امنیت, آسیب‌پذیری, رمز عبور, تزریق, احراز هویت, مجوز
priority: P0
dependencies: [project-analysis]
conflicts: []
---

# Security Audit Skill

## Purpose

Identify and fix security vulnerabilities. Apply security by default.

## When to Activate

- User asks for security review
- Before deployment
- After adding authentication
- Handling user input
- User says "is this secure?"

## Workflow

### Step 1: Check for Secrets

```
1. Search for hardcoded credentials
2. Check .env files are in .gitignore
3. Check API keys in code
4. Check for sensitive data in logs
```

### Step 2: Check OWASP Top 10

```
1. Injection (SQL, Command, LDAP)
2. Broken Authentication
3. Sensitive Data Exposure
4. XML External Entities
5. Broken Access Control
6. Security Misconfiguration
7. Cross-Site Scripting (XSS)
8. Insecure Deserialization
9. Using Components with Known Vulnerabilities
10. Insufficient Logging
```

### Step 3: Check Dependencies

```
1. Run npm audit / pip audit
2. Check for known vulnerabilities
3. Update vulnerable packages
```

### Step 4: Fix Issues

```
1. Prioritize by severity (Critical → High → Medium → Low)
2. Apply minimal fix
3. Verify fix
```

## Execution Rules

- Check security by default on sensitive code
- Don't skip checks because "it's internal"
- Always validate user input
- Never store secrets in code

## Anti-Patterns

- ❌ Storing secrets in code
- ❌ Not validating user input
- ❌ Using eval() or exec()
- ❌ Disabling CSRF protection
- ❌ Logging sensitive data

## Skill Interactions

- ← project-analysis: Understand attack surface
- → debugging: Fix security issues
- → code-review: Security is part of review
