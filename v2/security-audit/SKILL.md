---
name: security-audit
description: >-
  Perform code security reviews, vulnerability scanning, and security best-practice audits for any codebase.
  Trigger this skill when the user wants a security audit, security review, vulnerability scan, security check,
  find security issues, identify vulnerabilities, check for security best practices, or assess code safety.
  Also activate for: security audit, بررسی امنیتی, امنیت کد, security review, vulnerability scan,
  find security issues, security best practices, OWASP, SQL injection check, XSS check,
  authentication security, authorization review, dependency vulnerability, CVE scan,
  security assessment, penetration testing prep, secure code review, secret detection,
  hardcoded credentials, insecure API, input validation, CSRF protection, security headers,
  code vulnerability, dependency audit, supply chain security, SBOM, security linting,
  SAST, DAST, SCA, IAST, RASP, static analysis, dynamic analysis, software composition analysis,
  OWASP Top 10, OWASP API Security Top 10, CWE, CVSS, CVE, CISA KEV, EPSS,
  SQL injection, XSS, CSRF, SSRF, XXE, deserialization, path traversal, command injection,
  LDAP injection, NoSQL injection, template injection, SSTI, prototype pollution,
  mass assignment, IDOR, broken access control, authentication bypass, session fixation,
  insecure direct object reference, privilege escalation, race condition, TOCTOU,
  JWT vulnerability, OAuth misconfiguration, OIDC security, SAML security,
  CORS misconfiguration, clickjacking, open redirect, subdomain takeover,
  HTTPS stripping, mixed content, certificate pinning, HSTS,
  content security policy, XSS filter bypass, polyglot attack, HTTP request smuggling,
  CRLF injection, host header injection, HTTP response splitting,
  password hashing, bcrypt, argon2, scrypt, PBKDF2, salt, pepper,
  secret rotation, key management, HSM, KMS, envelope encryption,
  رفع آسیب‌پذیری, بررسی کد, تست نفوذ, هک اخلاقی, امنیت وب,
  امنیت API, احراز هویت, نشت اطلاعات,
 供应链安全, 依赖漏洞, 代码审计, 安全扫描,
  dependency confusion, typosquatting, protestware, namespace confusion,
  lockfile integrity, npm audit, pip audit, cargo audit, go mod verify,
  container security, image scanning, Trivy, Grype, Snyk,
  SLSA framework, provenance, sigstore, in-toto, supply chain transparency,
  security logging, audit trail, SIEM, SOC2, ISO 27001, GDPR compliance,
  data classification, PII detection, PCI DSS, HIPAA, FedRAMP,
  security headers scanner, security middleware, helmet, cors middleware,
  rate limiting, brute force protection, account lockout, MFA, TOTP,
  OWASP ZAP, Burp Suite, Nmap, Nikto, security checklist, hardening guide,
  بررسی امنیتی پروژه, آسیب‌پذیری وب, پیدا کردن باگ امنیتی,
  تست نفوذ خودکار, اسکن امنیتی, بررسی تنظیمات امنیتی,
  security misconfiguration, insecure design, security logging failure,
  server-side request forgery, XML external entity,
  cross-site request forgery, broken authentication,
  sensitive data exposure, security misconfiguration,
  cryptographic failure, security headers missing,
  software integrity failure, security logging monitoring failure,
  security anti-pattern, code smell security, defense in depth.
---

# Security Audit Skill — Code Review & Vulnerability Assessment

## Overview

This skill performs structured security audits on codebases. It identifies vulnerabilities, misconfigurations, and deviations from security best practices. It does NOT replace professional penetration testing — it provides a thorough automated-style review catching the most common and dangerous issues.

## When to Use This Skill

- User asks for a security audit or review of their code
- User wants to find vulnerabilities or security issues
- User asks about security best practices for their stack
- User wants to check dependencies for known CVEs
- User mentions OWASP, injection, XSS, CSRF, or specific vulnerability types
- User wants to verify authentication/authorization implementation
- User needs a SBOM (Software Bill of Materials)
- User needs supply chain security assessment
- User wants container image security scanning
- User asks about compliance (GDPR, HIPAA, SOC2, PCI DSS)
- User needs help hardening a deployment or configuration
- User wants to add security headers or middleware
- User suspects a specific vulnerability and wants confirmation

## Workflow

### Step 1: Scope the Audit

1. **Identify the project** — Read structure, language, framework.
2. **Determine threat model** — Public web app? Internal API? CLI tool? This determines priority.
3. **Identify auth and data sensitivity** — User auth? PII? Payment data? File uploads?
4. **Map the attack surface** — HTTP endpoints, WebSocket connections, API routes, file uploads, webhooks.

### Step 2: Scan for Vulnerability Categories

#### Injection Vulnerabilities
- **SQL Injection** — String concatenation in SQL. Raw queries without parameterization.
- **Command Injection** — `exec`, `spawn`, `system`, `os.popen`, `eval` with user input.
- **NoSQL Injection** — Unvalidated input in MongoDB/NoSQL queries.
- **XSS** — `innerHTML`, `dangerouslySetInnerHTML`, unescaped template output.
- **LDAP/XPath/Template Injection** — User input in LDAP queries, XPath, or server-side templates.

#### Authentication & Authorization
- **Password handling** — bcrypt/argon2? Never plaintext, never MD5/SHA1 alone.
- **Session management** — HttpOnly, Secure, SameSite flags? Timeout? Fixation protection?
- **JWT security** — Strong algorithms (RS256, ES256)? Expiration? Strong secrets?
- **Authorization** — IDOR? Route guards? Middleware in place?
- **Multi-factor auth** — Available for sensitive operations?

#### Data Protection
- **Encryption at rest** — Sensitive fields encrypted? DB encryption enabled?
- **Encryption in transit** — TLS enforced? Any HTTP endpoints with sensitive data?
- **Sensitive data exposure** — Secrets, API keys in source? Check .env, configs, hardcoded strings.
- **PII handling** — Personal data logged? Unnecessary data collection?

#### Configuration & Infrastructure
- **Security headers** — CSP, X-Frame-Options, X-Content-Type-Options, HSTS, Referrer-Policy.
- **CORS** — Too permissive (`*` with credentials)?
- **Debug mode** — Enabled in production?
- **Default credentials** — In configs?
- **Error handling** — Stack traces, internal paths, DB details leaked?

#### Dependency Vulnerabilities
- **Outdated packages** — Known CVEs in package.json, requirements.txt, go.mod, Cargo.toml.
- **Suspicious packages** — Typosquatted or unmaintained dependencies.
- **Transitive deps** — Full tree analysis needed.

#### File & Input Handling
- **Path traversal** — `../../../etc/passwd` access?
- **File upload** — Type, size, content validation? Outside web root?
- **Input validation** — Server-side validation? Client-only is insufficient.
- **CSRF** — Tokens for state-changing requests? SameSite cookie policy?
- **Rate limiting** — Login, password reset, API endpoints rate-limited?

### Step 3: Classify Findings

| Severity | Description | Example |
|----------|-------------|----------|
| **Critical** | Exploitable now, high impact | SQL injection, hardcoded production secrets |
| **High** | Exploitable with effort, significant impact | XSS in production, weak JWT secret |
| **Medium** | Specific conditions, moderate impact | Missing headers, verbose errors, no rate limiting |
| **Low** | Minor hardening, low impact | Missing HSTS, long session timeout |
| **Info** | Best practice, no direct risk | Add CSP, enable logging, pin dependencies |

### Step 4: Produce the Report

## Advanced Techniques

### 1. Taint Analysis for Data Flow Tracking

Trace user input from entry point to dangerous sink:

**Entry points:** HTTP params, headers, body, file uploads, WebSocket messages, webhooks.
**Sinks:** SQL/NoSQL constructors, shell execution, file I/O, HTML/template rendering, network requests, logs.

### 2. Dependency Graph Analysis for Supply Chain Risk

Beyond direct deps — examine full tree for:
- No commits in 12+ months (abandonment)
- Single maintainer (bus factor)
- Deps with known CVEs
- Suspicious version spikes or added maintainers

```bash
npm ls --all 2>/dev/null | head -100
pip freeze > requirements-all.txt
go mod graph
cargo tree --depth 3
```

### 3. Authentication Flow State Machine Analysis

Map auth flow as state machine, check for:
- Transition bypass (skip email verification?)
- State fixation (set session to privileged?)
- Token leakage (URLs, referrers, logs?)
- Brute force resistance (progressive delay? lockout?)
- Session invalidation (password change invalidates all?)

### 4. Race Condition Detection (TOCTOU)

```python
# VULNERABLE: TOCTOU
if not os.path.exists(f"uploads/{filename}"):
    with open(f"uploads/{filename}", "w") as f:
        f.write(content)

# SECURE: Atomic operations
import tempfile
with tempfile.NamedTemporaryFile(dir="uploads", delete=False, suffix=".txt") as f:
    f.write(content)
    final_path = f.name
```

### 5. API Security Deep Dive

- **BOLA/IDOR**: Can user A access user B's resources?
- **BFLA**: Can regular user call admin endpoints?
- **Mass Assignment**: Can users set `role`, `isAdmin` via API?
- **GraphQL depth/complexity**: Query depth limiting?

```javascript
// VULNERABLE: Mass assignment
app.put('/users/me', (req, res) => {
  Object.assign(currentUser, req.body);  // { role: 'admin' }
  currentUser.save();
});

// SECURE: Explicit allowlist
const ALLOWED = ['name', 'email', 'bio'];
app.put('/users/me', (req, res) => {
  ALLOWED.forEach(f => { if (req.body[f] !== undefined) currentUser[f] = req.body[f]; });
  currentUser.save();
});
```

### 6. Container & Infrastructure Security

- Base image CVEs? Up to date?
- Container as root? No `USER` directive?
- Secrets in env vars? Use Docker secrets / cloud secret managers.
- Debug ports exposed (9229, 5678)?
- IAM roles overly permissive?

### 7. Cryptographic Implementation Review

Check for: weak algorithms (DES, MD5, SHA1), hardcoded keys/IVs, ECB mode, encryption without MAC, RSA < 2048.

```python
# VULNERABLE: Hardcoded key, ECB mode
from Crypto.Cipher import AES
cipher = AES.new(b'secretkey123456', AES.MODE_ECB)

# SECURE: Random key, GCM mode
import os
from Crypto.Cipher import AES
cipher = AES.new(os.urandom(32), AES.MODE_GCM)
```

## Common Patterns

### Pattern 1: Parameterized Query Fix (SQL Injection)

```javascript
// VULNERABLE
app.get('/users', (req, res) => {
  db.query(`SELECT * FROM users WHERE id = ${req.query.id}`);
});

// SECURE
app.get('/users', (req, res) => {
  db.query('SELECT * FROM users WHERE id = $1', [req.query.id]);
});
```

### Pattern 2: Output Encoding Fix (XSS)

```javascript
// VULNERABLE
app.get('/search', (req, res) => {
  res.send(`<div>Results: ${req.query.q}</div>`);
});

// SECURE
import { escape } from 'validator';
app.get('/search', (req, res) => {
  res.send(`<div>Results: ${escape(req.query.q)}</div>`);
});
```

### Pattern 3: Secure File Upload

```python
# VULNERABLE
@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    file.save(f"uploads/{file.filename}")

# SECURE
import uuid, os, magic
from werkzeug.utils import secure_filename

ALLOWED = {'image/jpeg', 'image/png', 'application/pdf'}
MAX_SIZE = 10 * 1024 * 1024

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    content = file.read()
    if len(content) > MAX_SIZE: return 'Too large', 413
    if magic.from_buffer(content, mime=True) not in ALLOWED: return 'Invalid type', 415
    safe_name = f"{uuid.uuid4().hex}{os.path.splitext(file.filename)[1]}"
    file.seek(0)
    file.save(os.path.join('/var/uploads', safe_name))
```

### Pattern 4: Secure JWT Middleware

```typescript
// VULNERABLE: No expiry, weak secret
const token = jwt.sign({ userId: user.id }, 'mysecret');

// SECURE: Strong secret, expiration, RS256
const token = jwt.sign(
  { userId: user.id, role: user.role },
  process.env.JWT_SECRET!,
  { expiresIn: '15m', algorithm: 'RS256' }
);

function authMiddleware(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Missing token' });
  try {
    req.user = jwt.verify(token, process.env.JWT_PUBLIC_KEY!, { algorithms: ['RS256'] });
    next();
  } catch { return res.status(401).json({ error: 'Invalid token' }); }
}
```

### Pattern 5: Security Headers with Helmet + CORS

```javascript
import helmet from 'helmet';
import cors from 'cors';
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"], scriptSrc: ["'self'", "https://cdn.example.com"],
      styleSrc: ["'self'", "'unsafe-inline'"], imgSrc: ["'self'", "data:", "https:"],
      objectSrc: ["'none'"], frameAncestors: ["'none'"],
    }
  },
  hsts: { maxAge: 31536000, includeSubDomains: true, preload: true },
}));
app.use(cors({
  origin: ['https://example.com'],
  credentials: true, methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
```

## Edge Cases & Pitfalls

1. **False positives from pattern matching** — `"password"` in a password change API is not a vulnerability. Consider context.

2. **Security through obscurity** — Hiding admin at `/admin-secret-4829` is not security. Use auth + authorization.

3. **Environment variable leakage** — Django `DEBUG=True`, Express `NODE_ENV=development` dumps env vars including secrets on error pages.

4. **JWT `none` algorithm attack** — Library accepts `alg: none` → attacker forges tokens. Always specify allowed algorithms.

5. **Prototype pollution** — `Object.assign`/spread with user input can pollute `__proto__`. Sanitize or `Object.freeze`.

6. **ReDoS** — Malicious input causes catastrophic backtracking. Test regex with adversarial inputs.

7. **Subdomain takeover** — CNAME to deleted external service. Verify all DNS records point to active services.

8. **HTTP request smuggling** — Proxy/server header parsing discrepancy. Use consistent Transfer-Encoding.

9. **Time-based blind SQL injection** — `SLEEP(10)` in MySQL, `pg_sleep(10)` in PostgreSQL. Not caught by simple input checks.

10. **Log injection** — User input with newlines/log format strings forge entries. Sanitize or use structured logging.

11. **WebSocket security gaps** — Bypass CSRF. Authenticate during WebSocket handshake.

12. **CORS preflight caching abuse** — Long `Access-Control-Max-Age` exploits temporarily misconfigured CORS.

13. **Default JWT library behavior** — Some default to HS256 even when you want asymmetric. Always set algorithm.

14. **Missing rate limiting on password reset** — Allows account enumeration and token brute-forcing.

15. **Backup files accessible** — `.bak`, `.old`, `.sql`, `.env.bak` in web root or public S3.

16. **Insecure deserialization** — `pickle.loads()`, `ObjectInputStream`, `unserialize()` with user data. Use JSON.

17. **SSRF via internal services** — User-controlled URLs hitting internal metadata endpoints (`169.254.169.254`). Block private IPs.

18. **GraphQL introspection enabled in production** — Exposes full schema. Disable `introspection` in production.

## Integration

### Related Skills

- **Dockerization** (`dockerization`) — Scan container images for non-root users, base CVEs, exposed secrets.
- **CI/CD Pipeline** (`ci-cd-pipeline`) — Security scanning as CI stage: SAST, dependency scanning, secret detection.
- **Cloud Deployment** (`cloud-deployment`) — Audit cloud infra: IAM policies, security groups, encryption, public exposure.

### Common Integration Points

1. **Security → CI/CD** — Trivy, Bandit, npm audit become pipeline jobs.
2. **Security → Dockerization** — Dockerfile findings (non-root, distroless, no secrets) improve images.
3. **Security → Cloud** — Cloud review finds misconfigurations in Terraform, security groups, IAM.

## Recommended Scanning Tools

| Language | Scanner | Command |
|----------|---------|--------|
| Node.js | npm audit | `npm audit --production` |
| Node.js | Snyk | `npx snyk test` |
| Python | Bandit | `bandit -r src/` |
| Python | Safety | `safety check` |
| Go | gosec | `gosec ./...` |
| Rust | cargo audit | `cargo audit` |
| Java | OWASP Dep-Check | `dependency-check --scan .` |
| Generic | Trivy | `trivy image myapp:latest` |
| Secrets | GitLeaks | `gitleaks detect --source .` |
| Secrets | TruffleHog | `trufflehog filesystem .` |

## Output Format Templates

### Template A: Full Security Audit Report

```markdown
# Security Audit Report

**Project:** [name] | **Date:** [date] | **Files Scanned:** [count]
**Language/Framework:** [stack]

## Summary
- Critical: X | High: X | Medium: X | Low: X | Info: X

## Findings

### [SEVERITY-1] Title
**Category:** [Injection/Auth/Config/Dependency/Data]
**File:** [path:line]
**Description:** [What and why]
**Evidence:** [Code snippet]
**Recommendation:** [Fix with code]

## Recommended Actions (Priority Order)
1. [Most critical fix]
2. ...

## Tools to Run
- [Language-specific scanners]
```

### Template B: Quick Security Check

```markdown
## Security Check: [Topic]

**Scope:** [e.g., SQL injection, auth, secrets]
**Files Checked:** [list]

### Verdict: [PASS / FAIL / WARNING]

### Findings
[Only findings]

### Fixes
[Direct code fixes]
```

### Template C: Dependency Vulnerability Report

```markdown
## Dependency Security Report

**Lock File:** [package-lock.json / requirements.txt]
**Total Dependencies:** X (Y direct + Z transitive)

### Critical/High Vulnerabilities
| Package | Version | CVE | Severity | Fixed In |
|---------|---------|-----|----------|----------|
| [pkg] | [v] | [CVE] | Critical | [version] |

### Update Commands
```bash
[npm update / pip install --upgrade]
```
```

### Template D: Compliance Checklist

```markdown
## Compliance Checklist: [SOC2 / GDPR / HIPAA]

### Status: [X of Y controls satisfied]

| Control | Status | Evidence | Gap |
|---------|--------|----------|-----|
| [Name] | PASS/FAIL | [Checked] | [Missing] |

### Required Actions
1. [Action for failed control]
```