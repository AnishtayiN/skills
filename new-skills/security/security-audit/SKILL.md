---
name: security-audit
description: >-
  Security review: secrets, injection, auth, dependencies, OWASP Top 10.
  TRIGGERS: security, vulnerability, secret, hardcode, api key, password, injection, sql injection,
  xss, csrf, ssrf, authentication, authorization, owasp, security audit, penetration,
  taint analysis, toctou, supply chain, cryptographic review, container security, compliance,
  امنیت, آسیب‌پذیری, رمز عبور, تزریق, احراز هویت, مجوز,
  安全, 漏洞, 注入, 认证, 加密
priority: P0
dependencies: [project-analysis]
conflicts: []
---

# Security Audit Skill

## Purpose

Comprehensive security review and vulnerability assessment. Identify, analyze, and remediate security vulnerabilities across the entire application stack including code, infrastructure, dependencies, and configurations.

## When to Activate

- User asks for security review
- Before deployment to production
- After adding authentication or authorization
- Handling user input or external data
- User says "is this secure?" or "check for vulnerabilities"
- New dependency added to project
- Infrastructure changes or container deployments
- Compliance audit required

## Workflow

### Step 1: Reconnaissance & Attack Surface Mapping

```
1. Identify application entry points
2. Map data flow (external input → processing → storage → output)
3. Catalog all authentication/authorization boundaries
4. Document API endpoints and their access controls
5. Identify trust boundaries between components
6. List all third-party integrations and dependencies
```

### Step 2: Secrets & Credential Management

```
1. Search for hardcoded credentials (API keys, tokens, passwords)
2. Check .env files are in .gitignore
3. Verify secrets are not in version control history
4. Check for sensitive data in logs or error messages
5. Validate secret rotation policies
6. Verify secrets are stored in secure vaults (not plain text)
7. Check for weak default credentials
```

### Step 3: OWASP Top 10 Deep Dive

#### A01: Broken Access Control
```
- Missing function-level access control
- IDOR (Insecure Direct Object References)
- Missing authorization on API endpoints
- CORS misconfigurations
- Privilege escalation paths
- JWT validation flaws
- Directory traversal vulnerabilities
```

#### A02: Cryptographic Failures
```
- Weak algorithms (MD5, SHA1, DES)
- Hardcoded encryption keys
- Insufficient key length
- Missing encryption for sensitive data at rest
- Improper TLS/SSL configuration
- Certificate validation bypasses
- Insecure random number generation
```

#### A03: Injection
```
- SQL injection (classic, blind, time-based)
- NoSQL injection (MongoDB, CouchDB)
- Command injection (OS commands)
- LDAP injection
- XPath injection
- Template injection (SSTI)
- Header injection (CRLF)
```

#### A04: Insecure Design
```
- Missing threat modeling
- Insufficient business logic validation
- Missing rate limiting
- Insecure session management
- Missing CSRF protection
- Insufficient input validation
```

#### A05: Security Misconfiguration
```
- Default credentials enabled
- Unnecessary features enabled
- Missing security headers
- Verbose error messages exposing internals
- Directory listing enabled
- Unnecessary ports/services open
```

#### A06: Vulnerable Components
```
- Outdated dependencies with known CVEs
- Unused dependencies increasing attack surface
- Components with end-of-life status
- Missing dependency pinning
- Supply chain vulnerabilities
```

#### A07: Authentication Failures
```
- Weak password policies
- Missing multi-factor authentication
- Session fixation vulnerabilities
- Insecure credential storage
- Brute force protection missing
- Session timeout misconfiguration
```

#### A08: Software & Data Integrity
```
- Insecure deserialization
- Unsigned updates
- Missing integrity checks
- Insecure CI/CD pipelines
- Auto-update without verification
```

#### A09: Logging & Monitoring
```
- Insufficient logging of security events
- Logs containing sensitive data
- Missing alerting for suspicious activity
- Logs not centralized or tamper-proof
```

#### A10: SSRF
```
- Unvalidated URLs from user input
- Access to internal services
- Cloud metadata endpoint access
- Port scanning via SSRF
```

### Step 4: Taint Analysis

```
1. Identify all external input sources (user input, HTTP requests, files, env vars)
2. Trace data flow through the application
3. Check where tainted data reaches dangerous sinks
   - SQL queries (SQL injection)
   - System commands (command injection)
   - HTML output (XSS)
   - File operations (path traversal)
   - LDAP queries (LDAP injection)
4. Verify sanitization/escaping at each boundary
5. Document taint flow paths
```

### Step 5: Authentication Flow Analysis

```
1. Map complete authentication flow (login, logout, session management)
2. Verify password hashing (bcrypt, scrypt, Argon2 - NOT MD5/SHA1)
3. Check session token generation (cryptographically secure random)
4. Validate session lifecycle (creation, renewal, destruction)
5. Check for session fixation vulnerabilities
6. Verify MFA implementation if present
7. Test password reset flow for vulnerabilities
8. Check OAuth/OIDC implementation for proper token validation
9. Verify account lockout mechanisms
10. Test for timing attacks on authentication
```

### Step 6: TOCTOU Detection

```
1. Identify file access patterns (open → check → use)
2. Check for race conditions in file operations
3. Verify atomic operations for critical sections
4. Check for symlink attacks
5. Validate file permission checks are performed atomically
6. Test concurrent access patterns
7. Check database transactions for isolation issues
```

### Step 7: Supply Chain Security

```
1. Audit all dependencies for known vulnerabilities
2. Check dependency integrity (checksums, signatures)
3. Verify package sources (npmjs, pypi, official registries)
4. Review dependency maintenance status
5. Check for typosquatting in package names
6. Verify lockfile integrity
7. Check for malicious packages (postinstall scripts)
8. Validate CI/CD pipeline integrity
9. Check for dependency confusion attacks
```

### Step 8: Cryptographic Review

```
1. Identify all cryptographic operations
2. Verify algorithm selection (AES-256-GCM, RSA-2048+)
3. Check key management (generation, storage, rotation)
4. Validate IV/nonce generation (random, unique)
5. Check for proper padding (OAEP, PKCS7)
6. Verify TLS configuration (1.2+, strong cipher suites)
7. Test for padding oracle attacks
8. Check for hardcoded keys
9. Validate certificate chain verification
```

### Step 9: Container Security

```
1. Verify base image security (minimal, updated)
2. Check for running as root
3. Validate container isolation
4. Check for secrets in Dockerfile or image layers
5. Verify network policies
6. Check for vulnerability scanning in CI/CD
7. Validate resource limits
8. Check for read-only filesystems where possible
9. Verify image signing and verification
```

### Step 10: Compliance Framework Assessment

```
1. GDPR: Data protection, consent, right to deletion
2. HIPAA: PHI protection, access controls, audit trails
3. PCI DSS: Cardholder data protection, network segmentation
4. SOC 2: Security controls, availability, confidentiality
5. ISO 27001: Information security management
6. NIST CSF: Identify, Protect, Detect, Respond, Recover
7. OWASP ASVS: Application Security Verification Standard
```

### Step 11: Fix & Remediate

```
1. Prioritize by severity (Critical → High → Medium → Low)
2. Apply minimal, targeted fixes
3. Verify fixes don't introduce new vulnerabilities
4. Document findings and remediation
5. Update security policies if needed
```

## Advanced Techniques

### 1. Static Application Security Testing (SAST)
```python
# Example: Using bandit for Python security scanning
# Install: pip install bandit
# Run: bandit -r src/ -f json -o report.json

# Manual taint tracking pattern
TAINT_SOURCES = ['request.args', 'request.form', 'request.json']
DANGEROUS_SINKS = ['execute()', 'subprocess.call()', 'render_template_string']

def trace_taint(code_flow):
    """Trace tainted data from source to sink"""
    for line in code_flow:
        if any(source in line for source in TAINT_SOURCES):
            return True
        if any(sink in line for sink in DANGEROUS_SINKS):
            return "DANGEROUS_SINK_REACHED"
    return False
```

### 2. Dynamic Application Security Testing (DAST)
```bash
# OWASP ZAP scanning
zap-cli quick-scan -s all -r https://target.com

# SQLMap for SQL injection testing
sqlmap -u "https://target.com/page?id=1" --batch --dbms=mysql

# Nikto for web server scanning
nikto -h https://target.com
```

### 3. Secret Detection Patterns
```regex
# Common secret patterns to search for
AWS_KEY: (?:A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}
PRIVATE_KEY: -----BEGIN (RSA |EC )?PRIVATE KEY-----
JWT_TOKEN: eyJ[A-Za-z0-9-_=]+\.eyJ[A-Za-z0-9-_=]+\.[A-Za-z0-9-_.+/=]*
GENERIC_SECRET: (?i)(secret|token|api_key|apikey|password)[=:]\s*['\"][^'\"]+['\"]
```

### 4. Authentication Bypass Testing
```python
# Common authentication bypass patterns to test
bypass_tests = [
    "SQL injection in login: ' OR '1'='1",
    "Null byte injection: admin%00",
    "Case sensitivity bypass: ADMIN vs admin",
    "Header manipulation: X-Forwarded-For spoofing",
    "JWT none algorithm: alg: none",
    "Parameter pollution: username=admin&username=user"
]
```

### 5. Container Security Hardening
```dockerfile
# Secure Dockerfile example
FROM alpine:3.18
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
RUN chown -R appuser:appgroup /app
COPY --chown=appuser:appgroup . /app
EXPOSE 8080
HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1
```

### 6. Supply Chain Verification
```bash
# Verify npm package integrity
npm audit --json
npm ls --all --json > dependency-tree.json

# Check for known vulnerabilities
npm audit signatures

# Verify lockfile integrity
npm ci --ignore-scripts
shasum -a 256 package-lock.json
```

### 7. Cryptographic Operations Review
```python
# Secure cryptographic operations example
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

def secure_encrypt(key: bytes, plaintext: bytes) -> bytes:
    """Encrypt with AES-256-GCM (authenticated encryption)"""
    nonce = os.urandom(12)  # 96-bit nonce
    aesgcm = AESGCM(key)
    ciphertext = aesgcm.encrypt(nonce, plaintext, None)
    return nonce + ciphertext

def secure_hash(password: str) -> str:
    """Hash password with Argon2id"""
    from argon2 import PasswordHasher
    ph = PasswordHasher(
        time_cost=3,
        memory_cost=65536,
        parallelism=4,
        hash_len=32,
        salt_len=16
    )
    return ph.hash(password)
```

## Common Patterns

### Pattern 1: Input Validation Pipeline
```python
from typing import Any, Callable, List

class InputValidator:
    def __init__(self):
        self.rules: List[Callable] = []
    
    def add_rule(self, rule: Callable):
        self.rules.append(rule)
        return self
    
    def validate(self, value: Any) -> tuple[bool, str]:
        for rule in self.rules:
            valid, error = rule(value)
            if not valid:
                return False, error
        return True, ""

# Usage
validator = InputValidator()
validator.add_rule(lambda v: (len(v) > 0, "Cannot be empty"))
validator.add_rule(lambda v: (len(v) <= 100, "Too long"))
validator.add_rule(lambda v: ("<" not in v, "Invalid characters"))

is_valid, error = validator.validate(user_input)
if not is_valid:
    return 400, {"error": error}
```

### Pattern 2: Rate Limiting with Redis
```python
import redis
import time

class RateLimiter:
    def __init__(self, redis_client, max_requests: int, window: int):
        self.redis = redis_client
        self.max_requests = max_requests
        self.window = window
    
    def is_allowed(self, key: str) -> bool:
        current = self.redis.incr(key)
        if current == 1:
            self.redis.expire(key, self.window)
        return current <= self.max_requests

# Usage
limiter = RateLimiter(redis_client, max_requests=100, window=60)
if not limiter.is_allowed(f"rate:{user_ip}"):
    return 429, {"error": "Too many requests"}
```

### Pattern 3: Secure Session Management
```python
import secrets
from datetime import datetime, timedelta

class SessionManager:
    def __init__(self, db):
        self.db = db
    
    def create_session(self, user_id: str) -> str:
        session_token = secrets.token_urlsafe(32)
        self.db.store_session(
            token=session_token,
            user_id=user_id,
            created_at=datetime.utcnow(),
            expires_at=datetime.utcnow() + timedelta(hours=1),
            ip_address=request.remote_addr,
            user_agent=request.user_agent.string
        )
        return session_token
    
    def validate_session(self, token: str) -> bool:
        session = self.db.get_session(token)
        if not session:
            return False
        if session.expires_at < datetime.utcnow():
            self.db.delete_session(token)
            return False
        if session.ip_address != request.remote_addr:
            return False  # Session hijacking attempt
        return True
```

### Pattern 4: Content Security Policy Header
```python
def set_csp_header(response):
    csp_directives = {
        "default-src": "'self'",
        "script-src": "'self' 'nonce-{random}'",
        "style-src": "'self' 'unsafe-inline'",
        "img-src": "'self' data: https:",
        "font-src": "'self'",
        "connect-src": "'self' https://api.example.com",
        "frame-ancestors": "'none'",
        "base-uri": "'self'",
        "form-action": "'self'"
    }
    csp = "; ".join([f"{k} {v}" for k, v in csp_directives.items()])
    response.headers["Content-Security-Policy"] = csp
    return response
```

### Pattern 5: SQL Injection Prevention
```python
# Parameterized queries (ALWAYS use this)
def get_user_safe(user_id: str):
    query = "SELECT * FROM users WHERE id = %s"
    cursor.execute(query, (user_id,))
    return cursor.fetchone()

# ORM usage (also safe)
def get_user_orm(user_id: str):
    return User.query.filter_by(id=user_id).first()

# NEVER do this (SQL injection vulnerable)
def get_user_unsafe(user_id: str):
    query = f"SELECT * FROM users WHERE id = '{user_id}'"  # VULNERABLE!
    cursor.execute(query)
    return cursor.fetchone()
```

## Edge Cases & Pitfalls

1. **JWT None Algorithm**: Always verify algorithm in JWT header is not "none"
2. **Case Sensitivity Bypass**: File paths and usernames may be case-sensitive
3. **Null Byte Injection**: PHP and C functions may stop at null bytes
4. **Unicode Normalization**: Unicode equivalence attacks can bypass validation
5. **Time-of-Check Time-of-Use (TOCTOU)**: File permission checks may become stale
6. **Deserialization Attacks**: Untrusted deserialization can lead to RCE
7. **SMTP Header Injection**: Newlines in email headers can inject additional headers
8. **Host Header Injection**: Manipulated Host headers can affect password reset links
9. **CORS Misconfiguration**: Overly permissive CORS allows cross-origin attacks
10. **Incomplete CORS Bypass**: Origin validation may miss edge cases (null origin, subdomains)
11. **Log Injection**: User input in logs can forge log entries
12. **Race Condition in Auth**: Concurrent login attempts may bypass account lockout
13. **XML External Entity (XXE)**: XML parsers may load external entities
14. **Server-Side Template Injection**: User input in templates can execute arbitrary code
15. **Dependency Confusion**: Private package names may be claimed on public registries

## Integration with Other Skills

| Skill | Integration Type | Description |
|-------|-----------------|-------------|
| project-analysis | Input | Understand application architecture and attack surface |
| code-review | Collaboration | Security is a core part of code review |
| debugging | Output | Fix identified security vulnerabilities |
| testing | Collaboration | Write security-focused test cases |
| deployment | Collaboration | Secure deployment configurations |
| api-design | Input | Secure API endpoint design |
| database-design | Input | Secure database schema and queries |
| dockerization | Input | Container security best practices |
| ci-cd | Input | Secure CI/CD pipeline configuration |

## Output Format Templates

### Template 1: Security Audit Report
```markdown
# Security Audit Report

## Executive Summary
- **Scope**: [Application/Component audited]
- **Date**: [Audit date]
- **Auditor**: [Security team/individual]
- **Overall Risk Level**: [Critical/High/Medium/Low]

## Findings Summary
| Severity | Count | Description |
|----------|-------|-------------|
| Critical | X | Immediate action required |
| High | X | Action required within 24 hours |
| Medium | X | Action required within 1 week |
| Low | X | Action required within 1 month |

## Detailed Findings
### [CRITICAL-001] [Vulnerability Name]
- **CVSS Score**: X.X
- **OWASP Category**: A0X:XXXX
- **Description**: [Detailed description]
- **Impact**: [What an attacker could do]
- **Proof of Concept**: [Steps to reproduce]
- **Remediation**: [How to fix]
- **References**: [CWE, OWASP links]
```

### Template 2: Vulnerability Detail
```markdown
## [SEVERITY-NNN] Vulnerability Title

**Status**: Open | Fixed | False Positive
**CVSS**: X.X (Vector: ...)
**CWE**: CWE-XXX
**OWASP**: A0X:XXXX

### Description
[Detailed description of the vulnerability]

### Impact
[Business and technical impact]

### Affected Components
- [ ] Component 1
- [ ] Component 2

### Reproduction Steps
1. Step 1
2. Step 2
3. Step 3

### Remediation
[Detailed fix instructions]

### Verification
[How to verify the fix]
```

### Template 3: Security Checklist
```markdown
# Security Checklist

## Authentication & Authorization
- [ ] Passwords hashed with bcrypt/argon2
- [ ] MFA enabled for admin accounts
- [ ] Session tokens are cryptographically random
- [ ] Session timeout configured appropriately
- [ ] Rate limiting on login attempts
- [ ] Account lockout after failed attempts

## Input Validation
- [ ] All user input validated on server
- [ ] SQL queries use parameterized statements
- [ ] Output encoding for HTML context
- [ ] File upload validation (type, size)
- [ ] URL validation and sanitization

## Configuration
- [ ] Security headers enabled (CSP, HSTS, X-Frame-Options)
- [ ] CORS properly configured
- [ ] Error messages don't expose internals
- [ ] Debug mode disabled in production
- [ ] Default credentials changed

## Dependencies
- [ ] All dependencies up to date
- [ ] No known vulnerabilities (npm audit, pip audit)
- [ ] Dependency signatures verified
```

### Template 4: Compliance Assessment
```markdown
# Compliance Assessment Report

## Framework: [GDPR/HIPAA/PCI DSS/SOC 2]

## Control Assessment
| Control ID | Description | Status | Evidence |
|------------|-------------|--------|----------|
| CC-1.1 | Security policy documented | ✅ Compliant | policy.pdf |
| CC-2.1 | Risk assessment performed | ✅ Compliant | risk-assessment.xlsx |
| CC-3.1 | Access controls implemented | ⚠️ Partial | access-control.md |
| CC-4.1 | Monitoring in place | ❌ Non-Compliant | N/A |

## Gaps Identified
1. [Gap description and remediation plan]

## Evidence Package
- [List of supporting documents]
```

## Rules

1. **NEVER** store secrets in code or version control
2. **ALWAYS** use parameterized queries for database access
3. **ALWAYS** validate and sanitize all user input
4. **ALWAYS** use HTTPS for all communications
5. **ALWAYS** implement proper authentication and authorization
6. **ALWAYS** hash passwords with bcrypt, scrypt, or Argon2
7. **NEVER** use eval() or exec() with untrusted input
8. **ALWAYS** implement rate limiting on sensitive endpoints
9. **ALWAYS** log security-relevant events
10. **ALWAYS** keep dependencies up to date
11. **ALWAYS** apply principle of least privilege
12. **NEVER** disable security features for convenience
13. **ALWAYS** perform security testing before deployment
14. **ALWAYS** have a security incident response plan
15. **ALWAYS** encrypt sensitive data at rest and in transit

## Anti-Patterns

- ❌ Storing secrets in code or environment files committed to git
- ❌ Not validating user input (leading to injection attacks)
- ❌ Using eval() or exec() with untrusted input
- ❌ Disabling CSRF protection
- ❌ Logging sensitive data (passwords, tokens, PII)
- ❌ Using weak cryptographic algorithms (MD5, SHA1, DES)
- ❌ Skipping security checks because "it's internal"
- ❌ Not implementing proper session management
- ❌ Trusting client-side validation alone
- ❌ Not performing security testing before deployment
- ❌ Ignoring dependency vulnerabilities
- ❌ Using default credentials in production
- ❌ Not implementing proper error handling (exposing stack traces)
- ❌ Missing security headers (CSP, HSTS, X-Frame-Options)
- ❌ Not rotating secrets and credentials regularly

## Skill Interactions

- ← project-analysis: Understand attack surface and architecture
- → debugging: Fix identified security issues
- → code-review: Security is a core part of code review
- → testing: Write security-focused test cases
- → deployment: Secure deployment configurations
- → api-design: Secure API endpoint design
- → database-design: Secure database schema and queries
- → dockerization: Container security best practices
- → ci-cd: Secure CI/CD pipeline configuration
