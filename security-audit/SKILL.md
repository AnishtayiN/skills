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
  code vulnerability, dependency audit, supply chain security, SBOM, security linting.
---

# Security Audit Skill — Complete Code Review & Vulnerability Assessment

## Overview

This skill performs structured security audits on codebases. It identifies vulnerabilities, misconfigurations, and deviations from security best practices across the full OWASP Top 10, SSRF, XXE, deserialization, race conditions, and more. It covers SAST, DAST, IAST, and SCA testing patterns, secure coding per language, compliance frameworks (SOC2, GDPR, HIPAA), security monitoring, and incident response. It does NOT replace penetration testing — it provides a thorough automated-style review that catches the most common and dangerous issues.

## When to Use This Skill

- User asks for a security audit or review of their code
- User wants to find vulnerabilities or security issues
- User asks about security best practices for their stack
- User wants to check dependencies for known CVEs
- User mentions OWASP, injection, XSS, CSRF, or specific vulnerability types
- User wants to verify authentication/authorization implementation
- User asks about SSRF, XXE, deserialization, or race conditions
- User needs compliance guidance (SOC2, GDPR, HIPAA)
- User wants security monitoring and incident response patterns

---

## Part 1: Audit Scoping

### Step 1: Scope the Audit

1. **Identify the project** — Read the project structure, language, and framework.
2. **Determine the threat model:**
   - Public-facing web app? Internal API? CLI tool?
   - What data does it handle? PII? Payment data? Health records?
   - Who are the threat actors? External attackers? Insider threats?
3. **Identify authentication and data sensitivity:**
   - User auth? PII? Payment data? File uploads?
   - These areas need the deepest inspection.
4. **Review architecture diagram** (if available) — Understand data flow, trust boundaries, and external integrations.

---

## Part 2: Vulnerability Categories — Complete Reference

### Injection Vulnerabilities

#### SQL Injection

```python
# VULNERABLE: String concatenation in SQL
query = f"SELECT * FROM users WHERE id = {user_input}"
cursor.execute(query)

# VULNERABLE: String formatting
query = "SELECT * FROM users WHERE id = %s" % user_input

# SECURE: Parameterized query
cursor.execute("SELECT * FROM users WHERE id = %s", (user_input,))

# SECURE: ORM usage (SQLAlchemy)
user = session.query(User).filter(User.id == user_input).first()
```

```javascript
// VULNERABLE
const query = `SELECT * FROM users WHERE id = ${userId}`;
db.query(query);

// SECURE: Parameterized
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

```java
// VULNERABLE
String query = "SELECT * FROM users WHERE id = " + userId;

// SECURE: PreparedStatement
PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
stmt.setInt(1, userId);
```

#### Command Injection

```python
# VULNERABLE
import os
os.system(f"ping {user_input}")
os.popen(f"ls {user_input}")

# SECURE: Use subprocess with list arguments
import subprocess
subprocess.run(["ping", user_input], capture_output=True)

# SECURE: Input validation
import re
if not re.match(r'^[a-zA-Z0-9.-]+$', user_input):
    raise ValueError("Invalid hostname")
```

```javascript
// VULNERABLE
const { exec } = require('child_process');
exec(`ping ${userInput}`);

// SECURE
const { execFile } = require('child_process');
execFile('ping', [userInput]);
```

#### NoSQL Injection

```javascript
// VULNERABLE: User input directly in query
const user = await User.findOne({ username: req.body.username });
// If req.body = { username: { "$ne": "" }, password: { "$ne": "" } }
// This bypasses authentication!

// SECURE: Validate and sanitize input
const username = String(req.body.username);
const user = await User.findOne({ username });
```

#### XSS (Cross-Site Scripting)

```javascript
// VULNERABLE: innerHTML
element.innerHTML = userInput;

// VULNERABLE: dangerouslySetInnerHTML
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// SECURE: textContent
element.textContent = userInput;

// SECURE: React auto-escapes in JSX
<div>{userInput}</div>

// SECURE: Template engines auto-escape
// EJS: <%= userInput %> (auto-escapes)
// Jinja2: {{ userInput }} (auto-escapes)
```

#### LDAP Injection

```python
# VULNERABLE
filter_str = f"(uid={user_input})"
ldap_search(conn, base_dn, filter_str)

# SECURE: Escape special characters
import ldap.filter
safe_input = ldap.filter.escape_filter_chars(user_input)
filter_str = f"(uid={safe_input})"
```

#### XPath Injection

```python
# VULNERABLE
xpath = f"//user[username='{username}' and password='{password}']"

# SECURE: Use parameterized XPath
from lxml import etree
tree = etree.parse('users.xml')
# Use proper XPath APIs with parameterization
```

### SSRF (Server-Side Request Forgery)

```python
# VULNERABLE: User-controlled URL
import requests
response = requests.get(user_input_url)

# VULNERABLE: Even with validation, internal IPs can be accessed
if user_input_url.startswith('http'):
    response = requests.get(user_input_url)

# SECURE: Validate URL, block internal IPs
from urllib.parse import urlparse
import ipaddress

def is_safe_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ('http', 'https'):
        return False
    try:
        ip = ipaddress.ip_address(parsed.hostname)
        if ip.is_private or ip.is_loopback or ip.is_reserved:
            return False
    except ValueError:
        pass
    return True

if is_safe_url(user_input_url):
    response = requests.get(user_input_url, timeout=5)
```

```python
# SSRF with cloud metadata exploitation
# VULNERABLE
response = requests.get("http://169.254.169.254/latest/meta-data/iam/security-credentials/")

# SECURE: Block link-local addresses
BLOCKED_RANGES = [
    ipaddress.ip_network('169.254.0.0/16'),  # AWS metadata
    ipaddress.ip_network('10.0.0.0/8'),
    ipaddress.ip_network('172.16.0.0/12'),
    ipaddress.ip_network('192.168.0.0/16'),
    ipaddress.ip_network('127.0.0.0/8'),
]
```

### XXE (XML External Entity)

```python
# VULNERABLE: Parsing XML without disabling external entities
import xml.etree.ElementTree as ET
tree = ET.parse(user_uploaded_file)

# SECURE: Use defusedxml
import defusedxml.ElementTree as ET
tree = ET.parse(user_uploaded_file)
```

```java
// VULNERABLE
DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
DocumentBuilder db = dbf.newDocumentBuilder();
Document doc = db.parse(inputStream);

// SECURE
DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
```

### Deserialization Vulnerabilities

```python
# VULNERABLE: Pickle deserialization
import pickle
data = pickle.loads(user_input)  # Can execute arbitrary code!

# VULNERABLE: yaml.load without safe_load
import yaml
config = yaml.load(user_input)

# SECURE: Use safe alternatives
import json
data = json.loads(user_input)

# SECURE: Use yaml.safe_load
config = yaml.safe_load(user_input)
```

```java
// VULNERABLE: Java deserialization
ObjectInputStream ois = new ObjectInputStream(inputStream);
Object obj = ois.readObject();

// SECURE: Use whitelisting
ObjectInputStream ois = new ObjectInputStream(inputStream) {
    @Override
    protected Class<?> resolveClass(ObjectStreamClass desc) throws IOException, ClassNotFoundException {
        if (!ALLOWED_CLASSES.contains(desc.getName())) {
            throw new InvalidClassException("Unauthorized class: " + desc.getName());
        }
        return super.resolveClass(desc);
    }
};
```

### Race Conditions

```python
# VULNERABLE: TOCTOU (Time-of-Check-Time-of-Use)
if os.path.exists(filename):
    with open(filename) as f:
        content = f.read()

# SECURE: Use atomic operations
try:
    with open(filename, 'x') as f:
        f.write(content)
except FileExistsError:
    pass
```

```python
# VULNERABLE: Race condition in balance check
balance = get_balance(user_id)
if balance >= amount:
    withdraw(user_id, amount)

# SECURE: Use database transaction with row locking
with db.transaction():
    row = db.execute(
        "SELECT balance FROM accounts WHERE id = %s FOR UPDATE",
        (user_id,)
    )
    if row['balance'] >= amount:
        db.execute(
            "UPDATE accounts SET balance = balance - %s WHERE id = %s",
            (amount, user_id)
        )
```

### Authentication & Authorization

```python
# VULNERABLE: Weak password hashing
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# SECURE: Use bcrypt or argon2
from passlib.hash import bcrypt
hashed = bcrypt.hash(password)
if bcrypt.verify(password, hashed):
    pass
```

```javascript
// VULNERABLE: JWT with none algorithm
// jwt.verify(token, secret, { algorithm: 'none' })

// SECURE: Enforce algorithm
const jwt = require('jsonwebtoken');
const decoded = jwt.verify(token, secret, { algorithms: ['HS256', 'RS256'] });
```

#### IDOR (Insecure Direct Object Reference)

```python
# VULNERABLE: User can access any document by ID
@app.route('/documents/<int:doc_id>')
def get_document(doc_id):
    doc = Document.query.get(doc_id)  # No ownership check!
    return jsonify(doc)

# SECURE: Check ownership
@app.route('/documents/<int:doc_id>')
@login_required
def get_document(doc_id):
    doc = Document.query.filter_by(id=doc_id, owner_id=current_user.id).first_or_404()
    return jsonify(doc)
```

### Configuration & Infrastructure

```yaml
# VULNERABLE: CORS misconfiguration
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true

# SECURE: Specific origin
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Credentials: true
```

```yaml
# Security headers to check
Content-Security-Policy: default-src 'self'; script-src 'self'
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000; includeSubDomains
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

### File & Input Handling

```python
# VULNERABLE: Path traversal
@app.route('/files/<filename>')
def get_file(filename):
    path = os.path.join('/data', filename)
    return send_file(path)

# SECURE: Validate path
@app.route('/files/<filename>')
def get_file(filename):
    safe_name = os.path.basename(filename)
    path = os.path.join('/data', safe_name)
    if not path.startswith('/data/'):
        abort(403)
    return send_file(path)
```

```python
# VULNERABLE: Unsafe file upload
@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    file.save(f'/uploads/{file.filename}')

# SECURE: Validate and rename
import uuid
ALLOWED_EXTENSIONS = {'png', 'jpg', 'pdf'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['file']
    if not allowed_file(file.filename):
        abort(400)
    ext = file.filename.rsplit('.', 1)[1].lower()
    safe_filename = f"{uuid.uuid4()}.{ext}"
    file.save(os.path.join('/uploads', safe_filename))
```

---

## Part 3: Security Testing Patterns

### SAST (Static Application Security Testing)

| Tool | Language | Command |
|------|----------|---------|
| Bandit | Python | `bandit -r src/` |
| ESLint Security | JavaScript | `eslint --plugin security src/` |
| Semgrep | Multi-language | `semgrep --config auto src/` |
| SonarQube | Multi-language | `sonar-scanner -Dsonar.projectKey=myapp` |
| CodeQL | Multi-language | GitHub Actions integration |

### DAST (Dynamic Application Security Testing)

| Tool | Use Case | Command |
|------|----------|---------|
| OWASP ZAP | Web app scanning | `zap-full-scan.py -t https://example.com` |
| Nuclei | Template-based scanning | `nuclei -u https://example.com` |
| Nikto | Web server scanning | `nikto -h https://example.com` |

### IAST (Interactive Application Security Testing)

```python
# IAST tools run alongside your application
# Examples: Contrast Security, Checkmarx IAST
# They monitor runtime behavior and detect vulnerabilities in real-time
```

### SCA (Software Composition Analysis)

| Tool | Command |
|------|---------|
| npm audit | `npm audit --production` |
| Snyk | `npx snyk test` |
| OWASP Dependency-Check | `dependency-check --scan .` |
| Trivy (containers) | `trivy image myapp:latest` |
| pip-audit | `pip-audit` |
| cargo audit | `cargo audit` |

### Secret Detection

| Tool | Command |
|------|---------|
| GitLeaks | `gitleaks detect --source .` |
| TruffleHog | `trufflehog filesystem .` |
| detect-secrets | `detect-secrets scan --all-files` |

---

## Part 4: Secure Coding Patterns by Language

### Python

```python
# Input validation with Pydantic
from pydantic import BaseModel, validator

class UserInput(BaseModel):
    username: str
    age: int

    @validator('username')
    def username_alphanumeric(cls, v):
        if not v.isalnum():
            raise ValueError('Username must be alphanumeric')
        return v

# SQL injection prevention
# Use SQLAlchemy ORM or parameterized queries
# Never use f-strings in SQL

# XSS prevention
# Use Jinja2 auto-escaping (default)
# Never mark content as safe with |safe filter without sanitization

# File handling
# Always validate file types and sizes
# Store uploads outside web root
# Use unique filenames

# CSRF prevention
from flask_wtf.csrf import CSRFProtect
csrf = CSRFProtect(app)

# Rate limiting
from flask_limiter import Limiter
limiter = Limiter(app, key_func=get_remote_address)

@app.route('/login', methods=['POST'])
@limiter.limit("5/minute")
def login():
    pass
```

### JavaScript/TypeScript

```javascript
// Input validation with Zod
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(128),
});

const result = schema.safeParse(req.body);
if (!result.success) {
  return res.status(400).json({ errors: result.error.issues });
}

// SQL injection prevention
// Use parameterized queries or ORM (Prisma, TypeORM)

// XSS prevention
// React: Auto-escapes in JSX, avoid dangerouslySetInnerHTML
// Express: Use helmet middleware
const helmet = require('helmet');
app.use(helmet());

// CSRF prevention
const csrf = require('csurf');
app.use(csrf({ cookie: true }));

// Rate limiting
const rateLimit = require('express-rate-limit');
app.use('/api/', rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));

// Secure cookies
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 3600000
  }
}));
```

### Go

```go
// Input validation
import "github.com/go-playground/validator/v10"

type UserInput struct {
    Email string `validate:"required,email"`
    Age   int    `validate:"gte=0,lte=130"`
}

var validate = validator.New()

func Handler(w http.ResponseWriter, r *http.Request) {
    var input UserInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        http.Error(w, "Invalid input", http.StatusBadRequest)
        return
    }
    if err := validate.Struct(input); err != nil {
        http.Error(w, "Validation failed", http.StatusBadRequest)
        return
    }
}

// SQL injection prevention
// Use database/sql with parameterized queries
row := db.QueryRow("SELECT * FROM users WHERE id = $1", userID)

// XSS prevention
import "html/template"
t, _ := template.New("page").Parse(userTemplate)
// template.HTML() bypasses escaping - avoid unless content is trusted
```

### Java

```java
// Input validation
import javax.validation.constraints.*;

public class UserInput {
    @NotNull
    @Email
    private String email;

    @Min(0) @Max(130)
    private int age;
}

// SQL injection prevention
// Always use PreparedStatement
PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
stmt.setInt(1, userId);

// XSS prevention
// Use OWASP Java Encoder
import org.owasp.encoder.Encode;
String safe = Encode.forHtml(userInput);

// CSRF prevention
// Spring Security provides CSRF protection by default
```

---

## Part 5: Security Architecture Review

### Authentication Architecture Checklist

| Check | Description | Priority |
|-------|-------------|----------|
| Password hashing | bcrypt/argon2 with sufficient work factor | Critical |
| MFA support | Available for sensitive operations | High |
| Session management | Secure cookie flags, timeout, fixation protection | High |
| JWT security | Strong algorithm, expiration, strong secret | High |
| Rate limiting | Login, password reset, API endpoints | High |
| Account lockout | After N failed attempts | Medium |
| Password policy | Minimum length, complexity requirements | Medium |
| Recovery flow | Secure password reset, email verification | High |

### Authorization Architecture Checklist

| Check | Description | Priority |
|-------|-------------|----------|
| RBAC/ABAC | Role-based or attribute-based access control | Critical |
| Principle of least privilege | Users get minimum required permissions | Critical |
| IDOR prevention | Ownership checks on all resource access | Critical |
| API authorization | Every endpoint requires authorization check | Critical |
| Admin separation | Admin functions behind separate auth | High |
| Multi-tenancy isolation | Data isolation between tenants | Critical |

### Data Protection Architecture Checklist

| Check | Description | Priority |
|-------|-------------|----------|
| Encryption at rest | Database and file encryption | High |
| Encryption in transit | TLS for all connections | Critical |
| Key management | Proper key rotation and storage | High |
| Data classification | PII, financial, health data identified | High |
| Data retention | Policies for data lifecycle | Medium |
| Right to deletion | GDPR/CCPA compliance | Medium |

---

## Part 6: Compliance Frameworks

### SOC 2 Compliance

```
Trust Service Criteria:
1. Security — Protection against unauthorized access
2. Availability — System uptime and performance
3. Processing Integrity — System processing is complete, accurate
4. Confidentiality — Information designated as confidential is protected
5. Privacy — Personal information is collected, used, retained, disclosed

Key Controls:
- Access controls (RBAC, MFA, least privilege)
- Change management (code review, deployment approvals)
- Monitoring and logging (audit trails, alerting)
- Incident response (documented procedures)
- Data encryption (at rest and in transit)
- Vulnerability management (regular scanning, patching)
```

### GDPR Compliance

```
Key Requirements:
1. Lawful basis for processing (consent, contract, legitimate interest)
2. Data minimization (collect only what's needed)
3. Purpose limitation (use data only for stated purpose)
4. Storage limitation (don't keep data longer than needed)
5. Right to access (users can request their data)
6. Right to erasure (users can request deletion)
7. Data portability (users can export their data)
8. Breach notification (72-hour reporting requirement)
9. Privacy by design (build privacy into systems)
10. Data Protection Officer (for large-scale processing)

Technical Controls:
- Consent management system
- Data encryption and pseudonymization
- Access logging and auditing
- Automated data retention and deletion
- Cookie consent management
- Privacy policy and terms of service
```

### HIPAA Compliance

```
Key Requirements:
1. Administrative safeguards (policies and procedures)
2. Physical safeguards (facility access, workstation use)
3. Technical safeguards (access control, audit controls, integrity, transmission security)
4. Business Associate Agreements (BAAs) with vendors
5. Breach notification (60-day reporting requirement)
6. Risk assessment (annual evaluation)

Technical Controls:
- Encryption of PHI (at rest and in transit)
- Access controls (role-based, minimum necessary)
- Audit logging (all access to PHI)
- Automatic logoff
- Integrity controls (verify data hasn't been altered)
- Emergency access procedures
```

### Compliance Checklist Template

```yaml
# compliance-checklist.yml
soc2:
  access_controls:
    - [ ] RBAC implemented
    - [ ] MFA enabled for all users
    - [ ] Least privilege enforced
    - [ ] Regular access reviews
  change_management:
    - [ ] Code review required
    - [ ] Deployment approvals
    - [ ] Change logging
  monitoring:
    - [ ] Audit trails enabled
    - [ ] Alerting configured
    - [ ] Log retention policy

gdpr:
  data_protection:
    - [ ] Consent management
    - [ ] Data encryption
    - [ ] Pseudonymization
    - [ ] Access logging
  user_rights:
    - [ ] Data export capability
    - [ ] Data deletion capability
    - [ ] Consent withdrawal
  breach_notification:
    - [ ] Detection mechanisms
    - [ ] 72-hour notification process
    - [ ] Documentation procedures
```

---

## Part 7: Security Monitoring and Alerting

### Security Event Logging

```python
# Security event logging
import logging
import json
from datetime import datetime

security_logger = logging.getLogger('security')

def log_security_event(event_type, user_id, details, severity='INFO'):
    event = {
        'timestamp': datetime.utcnow().isoformat(),
        'event_type': event_type,
        'user_id': user_id,
        'details': details,
        'severity': severity,
        'source_ip': request.remote_addr,
        'user_agent': request.user_agent.string
    }
    security_logger.info(json.dumps(event))

# Log authentication events
log_security_event('login_success', user_id, {'method': 'password'})
log_security_event('login_failure', user_id, {'reason': 'invalid_password'}, 'WARNING')
log_security_event('password_reset', user_id, {'method': 'email'})

# Log authorization events
log_security_event('access_denied', user_id, {'resource': '/admin', 'reason': 'insufficient_role'}, 'WARNING')

# Log data access events
log_security_event('data_access', user_id, {'resource': 'user_pii', 'action': 'read'})
```

### Alert Rules

```yaml
# Security alert rules (Prometheus/Alertmanager format)
groups:
  - name: security
    rules:
      - alert: HighFailedLoginRate
        expr: rate(failed_logins_total[5m]) > 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High failed login rate detected"

      - alert: BruteForceAttempt
        expr: rate(failed_logins_total{user_id!=""}[5m]) > 5
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Possible brute force attack on account"

      - alert: UnauthorizedAccessAttempt
        expr: rate(access_denied_total[5m]) > 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High rate of unauthorized access attempts"

      - alert: SQLInjectionAttempt
        expr: rate(sql_injection_attempts_total[5m]) > 0
        labels:
          severity: critical
        annotations:
          summary: "SQL injection attempt detected"
```

### SIEM Integration Pattern

```python
# Structured logging for SIEM (Splunk, ELK, etc.)
import structlog

logger = structlog.get_logger()

# Log with structured data for easy querying
logger.info(
    "user_login",
    user_id=user.id,
    user_email=user.email,
    ip_address=request.remote_addr,
    user_agent=request.user_agent.string,
    success=True,
    login_method="password",
    mfa_used=True
)

# Log with threat intelligence context
logger.warning(
    "suspicious_request",
    ip_address=request.remote_addr,
    geo_country=get_geo_ip(request.remote_addr),
    threat_score=calculate_threat_score(request.remote_addr),
    request_path=request.path,
    request_method=request.method,
    blocked=False
)
```

---

## Part 8: Incident Response Patterns

### Incident Response Plan

```
Phase 1: Preparation
- Document incident response procedures
- Define escalation paths
- Set up communication channels
- Maintain contact lists

Phase 2: Detection & Analysis
- Monitor alerts and logs
- Classify incident severity
- Identify affected systems and data
- Document timeline

Phase 3: Containment
- Short-term: Isolate affected systems
- Long-term: Apply patches, update rules
- Preserve evidence

Phase 4: Eradication
- Remove malware/unauthorized access
- Patch vulnerabilities
- Reset compromised credentials

Phase 5: Recovery
- Restore systems from clean backups
- Verify system integrity
- Monitor for recurrence

Phase 6: Lessons Learned
- Post-incident review
- Update procedures
- Improve detection rules
```

### Incident Response Playbook Template

```markdown
# Incident Response Playbook

## Incident Type: [SQL Injection / Data Breach / DDoS / etc.]

### Detection
- Alert source: [SIEM / WAF / Manual report]
- Indicators: [What triggered the alert]

### Immediate Actions (First 15 minutes)
1. [ ] Acknowledge the alert
2. [ ] Assess severity (Critical/High/Medium/Low)
3. [ ] Notify security team lead
4. [ ] Begin documentation

### Containment
1. [ ] Isolate affected systems
2. [ ] Block malicious IPs/accounts
3. [ ] Preserve logs and evidence

### Investigation
1. [ ] Determine scope of compromise
2. [ ] Identify affected data/users
3. [ ] Timeline reconstruction

### Eradication
1. [ ] Remove malicious code/access
2. [ ] Patch vulnerability
3. [ ] Reset compromised credentials

### Recovery
1. [ ] Restore from clean backups
2. [ ] Verify system integrity
3. [ ] Resume normal operations

### Post-Incident
1. [ ] Conduct post-mortem
2. [ ] Update detection rules
3. [ ] Improve procedures
```

### Common Incident Scenarios

```yaml
sql_injection:
  detection:
    - WAF alerts
    - Database error logs
    - Anomalous query patterns
  containment:
    - Block source IP
    - Enable WAF strict mode
    - Review database access logs
  investigation:
    - Identify all affected queries
    - Determine data exposure
    - Check for data exfiltration
  eradication:
    - Patch vulnerable code
    - Review all similar patterns
    - Update WAF rules

data_breach:
  detection:
    - Unusual data access patterns
    - Large data exports
    - Third-party notification
  containment:
    - Revoke compromised credentials
    - Isolate affected systems
    - Preserve forensic evidence
  investigation:
    - Determine what data was accessed
    - Identify affected individuals
    - Assess regulatory obligations
  notification:
    - Legal team notification
    - Regulatory notification (72 hours for GDPR)
    - Affected individual notification
```

---

## Part 9: Recommended Scanning Tools

| Language | Scanner | Command |
|----------|---------|--------|
| Node.js | npm audit | `npm audit --production` |
| Node.js | Snyk | `npx snyk test` |
| Python | Bandit | `bandit -r src/` |
| Python | Safety | `safety check` |
| Go | gosec | `gosec ./...` |
| Rust | cargo audit | `cargo audit` |
| Java | OWASP Dependency-Check | `dependency-check --scan .` |
| Generic | Trivy (containers) | `trivy image myapp:latest` |
| Secrets | GitLeaks | `gitleaks detect --source .` |
| Secrets | TruffleHog | `trufflehog filesystem .` |
| Multi-language | Semgrep | `semgrep --config auto src/` |
| Multi-language | CodeQL | GitHub Actions integration |

---

## Part 10: Output Format

```
# Security Audit Report

**Project:** [project name]
**Date:** [date]
**Files Scanned:** [number of files reviewed]
**Language/Framework:** [tech stack]

## Summary
- Critical: X | High: X | Medium: X | Low: X | Info: X

## Findings

### [SEVERITY-1] Finding Title
**Category:** [Injection / Auth / Config / Dependency / Data]
**File:** [path:line]
**Description:** [What the issue is and why it matters]
**Evidence:** [Code snippet showing the vulnerability]
**Recommendation:** [Specific fix with code example]

## Recommended Actions (Priority Order)
1. [Most critical fix]
2. [Next critical fix]
3. ...

## Compliance Status
- SOC 2: [Compliant / Gaps identified]
- GDPR: [Compliant / Gaps identified]
- HIPAA: [Compliant / N/A]

## Tools to Run
- [Language-specific security scanners to run for deeper analysis]
```

---

## Common Pitfalls to Avoid

- **Don't just list issues without explaining impact.** A vulnerability report without context is noise.
- **Don't claim a codebase is "secure."** No code is fully secure. Use language like "no critical issues found in this review."
- **Don't skip the dependency check.** Many real-world breaches come from vulnerable dependencies, not custom code.
- **Don't confuse client-side and server-side validation.** Client-side is UX, server-side is security.
- **Don't recommend complex solutions for simple problems.** A parameterized query beats a custom WAF rule every time.
- **Don't forget to check .env files and config files.** That's where secrets live.
- **Don't ignore race conditions.** They are real vulnerabilities that can lead to financial loss or data corruption.
- **Don't forget about SSRF.** It's increasingly common in applications that fetch URLs or process webhooks.
- **Don't skip compliance requirements.** If the application handles regulated data, compliance is not optional.
