---
name: regex
description: >-
  Expert regular expression authoring, debugging, and optimization for text
  matching, extraction, and transformation across all major regex flavors.
  TRIGGERS: regex, regular expression, pattern matching, text extraction,
  string parsing, find and replace, pattern match, regex pattern, regex help,
  write a regex, explain this regex, validate regex, capture group, lookaround,
  عبارت باقاعده, الگوی متنی, استخراج متن, جستجوی الگو, پترن باقاعده,
  بازنویسی عبارت باقاعده, اعتبارسنجی الگو, گروه‌بندی, 正则表达式, 正则,
  模式匹配, 文本提取, 字符串解析, 查找替换, 验证正则, 捕获组
priority: P1
dependencies: [algorithm-design, testing]
conflicts: []
---

# Regular Expressions Skill

## Overview

This skill provides expert-level guidance on writing, debugging, and optimizing regular expressions across all major regex flavors (PCRE, JavaScript, Python `re`, .NET, Java, Go, Rust). It covers fundamental syntax through advanced techniques like lookaheads, backreferences, atomic groups, and recursive patterns. The emphasis is on writing correct, readable, and performant regexes — avoiding catastrophic backtracking, ReDoS vulnerabilities, and common pitfalls that cause subtle bugs in production systems.

## When to Use This Skill

- Writing regex patterns for input validation (emails, URLs, phone numbers, dates, IDs).
- Extracting structured data from unstructured text (log files, HTML, CSV, freeform text).
- Implementing search-and-replace with complex transformation logic.
- Parsing configuration files, DSLs, or custom data formats.
- Building lexers, tokenizers, or syntax highlighters.
- Refactoring existing regex patterns for correctness, readability, or performance.
- Debugging failing regex matches (why doesn't my pattern match?).
- Defending against ReDoS (Regular Expression Denial of Service) attacks.
- Converting regex between flavors (PCRE ↔ JS ↔ Python ↔ .NET).

## When NOT to Use This Skill

- Simple substring searches — use `str.includes()` or `str.indexOf()`.
- HTML parsing — use a proper DOM parser (Cheerio, BeautifulSoup, lxml).
- JSON/YAML/TOML parsing — use dedicated parsers.
- Complex language parsing — use a proper parser generator (ANTLR, tree-sitter).
- Image/binary data processing — regex works on text only.
- Task scheduling or workflow management (use the relevant skill).

## Workflow

### Step 1 — Understand the Problem

Before writing any regex, clearly define:

```markdown
## Regex Problem Definition

1. **Input**: What text will the regex operate on?
   - Character encoding (ASCII, UTF-8, mixed?)
   - Expected input length (short strings vs large documents?)
   - User-controlled input (security concerns)?

2. **Output**: What should the regex produce?
   - Match/no-match boolean
   - Extracted substrings (capture groups)
   - Transformed text (replacement)
   - Position information (start, end, line number)

3. **Constraints**:
   - Target regex flavor (PCRE, JS, Python, .NET, Go, Rust)
   - Performance requirements (per-call latency, throughput)
   - Security requirements (immune to ReDoS?)

4. **Edge cases**:
   - Empty input
   - Unicode content (emoji, CJK, Arabic, accented characters)
   - Adversarial input (intentionally crafted to cause backtracking)
```

### Step 2 — Draft the Pattern

Build the regex incrementally, testing each component:

```python
# Example: Validate a strong password
# Requirements: 8+ chars, uppercase, lowercase, digit, special char

# Step 1: At least one uppercase letter
step1 = r'[A-Z]'

# Step 2: At least one lowercase letter
step2 = r'[a-z]'

# Step 3: At least one digit
step3 = r'\d'

# Step 4: At least one special character
step4 = r'[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]'

# Step 5: Minimum 8 characters total
step5 = r'.{8,}'

# Step 6: Combine using positive lookaheads
password_regex = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};\'"\\|,.<>\/?]).{8,}$'

import re
assert re.match(password_regex, 'MyP@ss1!') is not None
assert re.match(password_regex, 'weak') is None
assert re.match(password_regex, 'nouppercase1!') is None
assert re.match(password_regex, 'NOLOWERCASE1!') is None
```

### Step 3 — Test Thoroughly

Always test with positive, negative, and edge cases:

```python
import re

def test_regex(pattern, should_match, should_not_match, description=""):
    """Test a regex pattern against expected matches and non-matches."""
    print(f"\n{'='*60}")
    print(f"Testing: {description or pattern}")
    print(f"{'='*60}")
    
    for text in should_match:
        match = re.search(pattern, text)
        status = "PASS" if match else "FAIL"
        print(f"  [{status}] MATCH:    '{text}'")
        if match:
            print(f"         Groups: {match.groups()}")
    
    for text in should_not_match:
        match = re.search(pattern, text)
        status = "PASS" if not match else "FAIL"
        print(f"  [{status}] NO MATCH: '{text}'")


# Test email validation regex
email_regex = r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$'

test_regex(
    email_regex,
    should_match=[
        'user@example.com',
        'first.last@domain.org',
        'user+tag@example.com',
        'user123@test.co.uk',
    ],
    should_not_match=[
        'user@',           # Missing domain
        '@example.com',    # Missing local part
        'user@example',    # Missing TLD
        'user @example.com',  # Space in local part
        'user@exam ple.com',  # Space in domain
    ],
    description="Email validation"
)
```

### Step 4 — Optimize for Performance

Avoid catastrophic backtracking and ReDoS vulnerabilities:

```python
import re
import time

# BAD: Catastrophic backtracking potential
bad_pattern = r'^([a-zA-Z]+)+$'  # Nested quantifiers

# GOOD: No nested quantifiers
good_pattern = r'^[a-zA-Z]+$'

# Test catastrophic backtracking
test_input = 'a' * 25 + '!'  # 25 'a's followed by '!' (no match)

start = time.time()
try:
    # This should complete quickly with the good pattern
    result = re.match(good_pattern, test_input)
    elapsed = time.time() - start
    print(f"Good pattern: {elapsed:.6f}s — {'safe' if elapsed < 0.001 else 'SLOW'}")
except re.error:
    print("Pattern error")

# Measure the bad pattern (may hang on some inputs)
start = time.time()
try:
    # Set a timeout or use re.compile with a limit
    result = re.match(bad_pattern, test_input)
    elapsed = time.time() - start
    print(f"Bad pattern:  {elapsed:.6f}s — {'safe' if elapsed < 0.001 else 'SLOW (ReDoS!)'}")
except Exception:
    print("Bad pattern caused an error (expected)")
```

### Step 5 — Document and Annotate

Use verbose mode (`re.VERBOSE`) for complex patterns:

```python
import re

# Documented email regex using verbose mode
EMAIL_REGEX = re.compile(r"""
    ^                       # Start of string
    [a-zA-Z0-9._%+\-]+     # Local part: alphanumeric + allowed specials
    @                       # @ separator
    [a-zA-Z0-9.\-]+        # Domain: alphanumeric + dots + hyphens
    \.                      # Dot before TLD
    [a-zA-Z]{2,}            # TLD: at least 2 letters
    $                       # End of string
""", re.VERBOSE)

# Documented ISO 8601 date regex
ISO_DATE_REGEX = re.compile(r"""
    ^                           # Start of string
    (?P<year>\d{4})             # 4-digit year
    -                           # Separator
    (?P<month>0[1-9]|1[0-2])   # Month: 01-12
    -                           # Separator
    (?P<day>0[1-9]|[12]\d|3[01]) # Day: 01-31
    (?:                         # Optional time component
        [T ]                    # T or space separator
        (?P<hour>[01]\d|2[0-3]) # Hour: 00-23
        :                       # Separator
        (?P<minute>[0-5]\d)     # Minute: 00-59
        :                       # Separator
        (?P<second>[0-5]\d)     # Second: 00-59
        (?:                     # Optional fractional seconds
            \.(\d{1,6})         # Fractional: 1-6 digits
        )?
        (?:                     # Optional timezone
            Z                   # UTC
            | [+\-][01]\d:\d{2} # Offset: +HH:MM or -HH:MM
        )?
    )?
    $                           # End of string
""", re.VERBOSE)


# Usage
match = EMAIL_REGEX.match('user@example.com')
print(f"Email valid: {match is not None}")  # True

match = ISO_DATE_REGEX.match('2024-12-31T23:59:59.123456+05:30')
if match:
    print(f"Date: {match.group('year')}-{match.group('month')}-{match.group('day')}")
    print(f"Time: {match.group('hour')}:{match.group('minute')}:{match.group('second')}")
```

## Advanced Techniques (7 Techniques)

### 1. Lookahead and Lookbehind Assertions

Lookarounds match positions without consuming characters — essential for complex validation and extraction.

```python
import re

# Positive lookahead: match X only if followed by Y
# "password" followed by a digit
result = re.findall(r'\w+(?=\d)', 'abc123 def456 ghi')
print(result)  # ['abc', 'def']

# Negative lookahead: match X only if NOT followed by Y
# Words NOT followed by "ing"
result = re.findall(r'\b\w+(?!ing\b)\b', 'running jumping walking')
print(result)  # ['running', 'jumping', 'walking'] (whole words only)

# Positive lookbehind: match X only if preceded by Y
# Digits preceded by $
result = re.findall(r'(?<=\$)\d+', 'Price: $100, Qty: 5')
print(result)  # ['100']

# Negative lookbehind: match X only if NOT preceded by Y
# Words NOT preceded by #
result = re.findall(r'(?<!#)\w+', '#comment word1 word2')
print(result)  # ['comment', 'word1', 'word2']

# Practical example: Extract quoted strings without the quotes
text = 'She said "hello" and whispered \'goodbye\''
# Match content inside double quotes
result = re.findall(r'(?<=")[^"]+(?=")', text)
print(result)  # ['hello']

# Practical example: Find words at the start of sentences
text = 'Hello world. Goodbye world. Hello again.'
result = re.findall(r'(?<=^|\. )\w+', text)
print(result)  # ['Hello', 'Goodbye', 'Hello']

# Variable-length lookbehind (Python 3.11+ and PCRE)
# Match digits after the last # sign
text = 'a#b12#345'
result = re.findall(r'(?<=#)\d+', text)
# Python 3.11+: supports variable-length lookbehind
# Older Python: use alternative approaches
```

### 2. Named Capture Groups for Readable Extractions

Named groups make complex patterns self-documenting:

```python
import re

# Parse a URL into components
URL_PATTERN = re.compile(r"""
    ^
    (?:(?P<scheme>https?|ftp)://)?  # Optional scheme
    (?:
        (?P<username>[^:@]+)         # Optional username
        (?::(?P<password>[^@]+))?     # Optional password
        @                            # @ separator
    )?
    (?P<hostname>[a-zA-Z0-9.\-]+)    # Hostname
    (?::(?P<port>\d+))?              # Optional port
    (?P<path>/[^?#]*)?               # Optional path
    (?:\?(?P<query>[^#]*))?          # Optional query string
    (?:\#(?P<fragment>.*))?          # Optional fragment
    $
""", re.VERBOSE)

# Test URL parsing
url = 'https://user:pass@example.com:8080/path/page?name=value#section'
match = URL_PATTERN.match(url)
if match:
    print(f"Scheme:   {match.group('scheme')}")
    print(f"User:     {match.group('username')}")
    print(f"Password: {match.group('password')}")
    print(f"Host:     {match.group('hostname')}")
    print(f"Port:     {match.group('port')}")
    print(f"Path:     {match.group('path')}")
    print(f"Query:    {match.group('query')}")
    print(f"Fragment: {match.group('fragment')}")

# Parse log lines
LOG_PATTERN = re.compile(r"""
    \[(?P<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\]
    \s+
    \[(?P<level>DEBUG|INFO|WARN|ERROR|FATAL)\]
    \s+
    \[(?P<module>[\w.]+)\]
    \s+
    (?P<message>.+)
""", re.VERBOSE)

log_line = '[2024-12-31T23:59:59] [ERROR] [auth.service] Failed login attempt from 192.168.1.1'
match = LOG_PATTERN.match(log_line)
if match:
    print(f"Timestamp: {match.group('timestamp')}")
    print(f"Level:     {match.group('level')}")
    print(f"Module:    {match.group('module')}")
    print(f"Message:   {match.group('message')}")
```

### 3. Atomic Groups and Possessive Quantifiers

Prevent backtracking in performance-critical patterns:

```python
import re

# Atomic group (PCRE): (?>...) — once matched, never backtrack
# Python doesn't support atomic groups natively, but we can simulate
# with a non-backtracking approach or use the regex module.

# Possessive quantifier equivalent: ++ *+ {n}+
# In Python, use atomic grouping workaround or regex module

# PCRE example (for reference):
# (?>\d+\.)\d+ — atomic group prevents backtracking on \d+\.

# Python equivalent using regex module (pip install regex)
try:
    import regex
    
    # Atomic group syntax in the regex module
    atomic_pattern = regex.compile(r'(?>\d+\.)\d+')
    
    # Compare with non-atomic
    non_atomic = re.compile(r'\d+\.\d+')
    
    # Adversarial input that causes backtracking in non-atomic
    test = '1' * 25 + '.' + '2' * 25 + '!'
    
    import time
    
    start = time.time()
    non_atomic.search(test)
    non_atomic_time = time.time() - start
    
    start = time.time()
    atomic_pattern.search(test)
    atomic_time = time.time() - start
    
    print(f"Non-atomic: {non_atomic_time:.6f}s")
    print(f"Atomic:     {atomic_time:.6f}s")
except ImportError:
    print("Install 'regex' module for atomic group support: pip install regex")
```

### 4. Recursive Patterns for Nested Structures

PCRE and the `regex` module support recursive patterns for matching nested brackets, HTML-like structures, or balanced parentheses:

```python
import regex  # pip install regex

# Match balanced parentheses (recursive pattern)
# This matches: (()), (), (a(b)c), etc.
BALANCED_PARENS = regex.compile(r'\(((?:[^()]|(?R))*)\)')

text = 'func((a + b) * (c - d)) nested((x))'
matches = BALANCED_PARENS.findall(text)
print("Balanced parentheses found:")
for m in matches:
    print(f"  ({m})")

# Match balanced HTML-like tags (simplified)
BALANCED_TAGS = regex.compile(r'<(\w+)>((?:[^<>]|<\1>.*?</\1>)*)</\1>')

html = '<div>content <span>inner</span> more</div>'
match = BALANCED_TAGS.search(html)
if match:
    print(f"\nTag: {match.group(1)}")
    print(f"Content: {match.group(2)}")

# Match nested JSON-like structures (simplified)
NESTED_BRACES = regex.compile(r'\{(?:[^{}]|\{(?:[^{}]|\{[^{}]*\})*\})*\}')

json_like = 'outer {level1 {level2 {level3}}} done'
match = NESTED_BRACES.search(json_like)
if match:
    print(f"\nNested structure: {match.group(0)}")
```

### 5. Unicode-Aware Pattern Matching

Handle Unicode correctly for internationalized text:

```python
import re

# Unicode property escapes (Python 3.7+)
# \p{L}   — any letter
# \p{N}   — any number
# \p{Arabic} — Arabic script
# \p{Han} — Chinese characters (Han script)
# \p{Emoji} — emoji characters

# Note: Python's re module has limited Unicode property support.
# Use the regex module for full Unicode property support.

try:
    import regex
    
    # Match any Arabic text
    arabic_text = 'مرحبا بالعالم Hello 世界'
    arabic_words = regex.findall(r'\p{Arabic}+', arabic_text)
    print(f"Arabic: {arabic_words}")  # ['مرحبا', 'بالعالم']
    
    # Match any CJK characters
    cjk_words = regex.findall(r'\p{Han}+', arabic_text)
    print(f"CJK: {cjk_words}")  # ['世界']
    
    # Match any letter from any script
    all_letters = regex.findall(r'\p{L}+', arabic_text)
    print(f"All letters: {all_letters}")
    
    # Match emoji
    emoji_text = 'Hello 🌍! Welcome 🎉🎊🎈'
    emojis = regex.findall(r'\p{Emoji_Presentation}+', emoji_text)
    print(f"Emoji: {emojis}")
    
    # Unicode-aware word boundaries
    # \b in Unicode matches word boundaries for all scripts
    persian = 'سلام دنیا'
    words = regex.findall(r'\b\p{L}+\b', persian)
    print(f"Persian words: {words}")
    
except ImportError:
    print("Install 'regex' module for full Unicode support: pip install regex")
```

### 6. ReDoS Detection and Prevention

Regular Expression Denial of Service (ReDoS) occurs when crafted input causes exponential backtracking:

```python
import re
import time

class ReDoSDetector:
    """
    Detect potentially vulnerable regex patterns.
    Checks for common ReDoS patterns:
    - Nested quantifiers: (a+)+
    - Overlapping alternatives: (a|a)+
    - Adjacent quantifiers with overlap: a+a+
    """
    
    VULNERABLE_PATTERNS = [
        (r'\([^)]*\+\)[\+*]', "Nested quantifier: (X+)+ or (X+)*"),
        (r'\([^)]*\*\)[\+*]', "Nested quantifier: (X*)+ or (X*)*"),
        (r'\([^)]*\{[\d,]+\}\)[\+*]', "Nested quantifier: (X{n,})+"),
        (r'(\w+|\d+)+', "Overlapping alternatives"),
        (r'\[\^?\][\+*]\[\^?\][\+*]', "Adjacent character classes: [a]+[b]+"),
    ]
    
    @classmethod
    def analyze(cls, pattern_str):
        """Analyze a regex pattern for ReDoS vulnerabilities."""
        warnings = []
        
        for vuln_pattern, description in cls.VULNERABLE_PATTERNS:
            if re.search(vuln_pattern, pattern_str):
                warnings.append(description)
        
        # Check for backtracking-heavy patterns
        if re.search(r'(\.\*){2,}', pattern_str):
            warnings.append("Multiple .* can cause excessive backtracking")
        
        return warnings
    
    @classmethod
    def benchmark(cls, pattern_str, test_input, max_time=1.0):
        """Benchmark a regex against adversarial input."""
        compiled = re.compile(pattern_str)
        
        start = time.time()
        try:
            compiled.search(test_input)
            elapsed = time.time() - start
            return {
                'safe': elapsed < max_time,
                'time': elapsed,
                'input_length': len(test_input),
            }
        except re.error as e:
            return {'safe': True, 'error': str(e)}


# Test ReDoS detection
detector = ReDoSDetector()

# Vulnerable patterns
test_patterns = [
    r'^(a+)+$',              # Nested quantifiers — VULNERABLE
    r'^(a|a)+$',             # Overlapping alternatives — VULNERABLE
    r'^[a-z]+@[a-z]+\.[a-z]+$',  # Safe
    r'^(?=.*[A-Z])(?=.*[a-z]).{8,}$',  # Safe (lookaheads)
]

for pattern in test_patterns:
    warnings = detector.analyze(pattern)
    if warnings:
        print(f"WARNING: {pattern}")
        for w in warnings:
            print(f"  - {w}")
    else:
        print(f"OK: {pattern}")

# Benchmark vulnerable pattern
result = detector.benchmark(r'^(a+)+$', 'a' * 25 + '!')
print(f"\nReDoS benchmark: {result}")
```

### 7. Cross-Flavor Regex Translation

Convert regex patterns between different flavors:

```python
# Cross-flavor regex translation

FLAVOR_MAP = {
    # Python re → JavaScript
    'py_to_js': {
        'r\'': "'",
        r'(?P<name)': '(?<name>',
        r'(?P=name)': '\\k<name>',
        r'(?#...)': '',  # Python comments not supported in JS
        r'\A': '^',
        r'\Z': '$',
        r'(?s)': '',  # Python DOTALL — use /s flag in JS
        r'(?m)': '',  # Python MULTILINE — use /m flag in JS
        r'(?i)': '',  # Python IGNORECASE — use /i flag in JS
        r'(?x)': '',  # Python VERBOSE — use /x flag in JS (ES2024+)
    },
    # JavaScript → Python re
    'js_to_py': {
        r'(?<name>': '(?P<name>',
        r'\\k<name>': '(?P=name)',
        r'\A': '\\A',
        r'\Z': '\\Z',
    },
    # PCRE → Python
    'pcre_to_py': {
        r'(?>': '(?:',  # Atomic groups → non-capturing (approximate)
        r'(*SKIP:...)': '',  # No direct equivalent
        r'(*PRUNE:...)': '',  # No direct equivalent
        r'(?R)': '',  # Recursive → use regex module
    },
}


def translate_regex(pattern, source_flavor, target_flavor):
    """
    Basic regex flavor translation.
    Note: This is a simplified translator. Full translation requires
    understanding of semantic differences between flavors.
    """
    key = f"{source_flavor}_to_{target_flavor}"
    if key not in FLAVOR_MAP:
        return pattern
    
    result = pattern
    for old, new in FLAVOR_MAP[key].items():
        result = result.replace(old, new)
    
    return result


# Examples
py_pattern = r"(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})"
js_pattern = translate_regex(py_pattern, 'py', 'js')
print(f"Python: {py_pattern}")
print(f"JS:     {js_pattern}")

js_pattern = r"(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})"
py_pattern = translate_regex(js_pattern, 'js', 'py')
print(f"JS:     {js_pattern}")
print(f"Python: {py_pattern}")
```

## Common Patterns

### Pattern 1 — Email Validation (Comprehensive)

```python
import re

# RFC 5322 simplified email validation
# Balances correctness with practical usability
EMAIL_REGEX = re.compile(r"""
    ^
    # Local part
    [a-zA-Z0-9]                    # Start with alphanumeric
    [a-zA-Z0-9._%+\-]*            # Allow dots, underscores, etc.
    
    @                               # @ separator
    
    # Domain
    [a-zA-Z0-9]                    # Start with alphanumeric
    [a-zA-Z0-9.\-]*               # Allow dots and hyphens
    \.                             # Final dot
    [a-zA-Z]{2,}                   # TLD: 2+ letters
    $
""", re.VERBOSE)

# Test cases
assert EMAIL_REGEX.match('user@example.com') is not None
assert EMAIL_REGEX.match('user.name+tag@domain.co.uk') is not None
assert EMAIL_REGEX.match('user@sub.domain.example.com') is not None
assert EMAIL_REGEX.match('user@-invalid.com') is None  # Domain starts with hyphen
assert EMAIL_REGEX.match('user@.invalid.com') is None   # Domain starts with dot
assert EMAIL_REGEX.match('user@invalid.c') is None      # TLD too short
assert EMAIL_REGEX.match('@example.com') is None         # No local part
assert EMAIL_REGEX.match('user@') is None               # No domain
assert EMAIL_REGEX.match('user@@example.com') is None   # Double @@
assert EMAIL_REGEX.match('user @example.com') is None   # Space in local part
```

### Pattern 2 — Phone Number Extraction (International)

```python
import re

# International phone number extraction
# Supports: US, UK, Germany, France, Japan, China, India, etc.
PHONE_REGEX = re.compile(r"""
    (?:
        # International format with country code
        (?:\+|00)                    # + or 00 prefix
        \d{1,3}                      # Country code (1-3 digits)
        [\s\-.]?                     # Optional separator
        \(?                          # Optional opening paren
        \d{1,4}                      # Area code
        \)?                         # Optional closing paren
        [\s\-.]?                    # Optional separator
        \d{1,4}                     # First part
        [\s\-.]?                    # Optional separator
        \d{1,4}                     # Second part
        (?:[\s\-.]?\d{1,4})?       # Optional extension
    )
    |
    (?:
        # National format (US/Canada)
        \(?\d{3}\)?                 # Area code with optional parens
        [\s\-.]?                    # Optional separator
        \d{3}                       # Exchange
        [\s\-.]?                    # Optional separator
        \d{4}                       # Subscriber number
    )
""", re.VERBOSE)

# Test phone extraction
text = """
Call us at +1 (555) 123-4567 or 0044 20 7946 0958.
German: +49 30 12345678, French: +33 1 23 45 67 89
Japanese: 03-1234-5678, Chinese: +86 10 1234 5678
Indian: +91 98765 43210
"""

matches = PHONE_REGEX.findall(text)
print("Phone numbers found:")
for match in matches:
    cleaned = re.sub(r'[^\d+]', '', match)
    print(f"  {match.strip()} → {cleaned}")
```

### Pattern 3 — Log Line Parser

```python
import re
from datetime import datetime

# Parse common log formats

# Apache/Nginx combined log format
APACHE_LOG = re.compile(r"""
    (?P<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})  # Client IP
    \s+-\s+                                         # Identity (usually -)
    \s+(?P<user>\S+)                                # Username
    \s+\[(?P<timestamp>[^\]]+)\]                     # Timestamp
    \s+"(?P<method>\w+)                              # HTTP method
    \s+(?P<path>\S+)                                # Request path
    \s+(?P<protocol>\S+)"                           # Protocol
    \s+(?P<status>\d{3})                            # Status code
    \s+(?P<size>\d+|-)                              # Response size
    \s+"(?P<referer>[^"]*)"                         # Referer
    \s+"(?P<useragent>[^"]*)"`                      # User agent
""", re.VERBOSE)

# ISO 8601 timestamp
ISO_TIMESTAMP = re.compile(r"""
    (?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})
    [T ]
    (?P<hour>\d{2}):(?P<minute>\d{2}):(?P<second>\d{2})
    (?P<fraction>\.\d+)?
    (?P<tz>[+-]\d{2}:\d{2}|Z)?
""", re.VERBOSE)

# Parse a log line
log_line = '192.168.1.1 - admin [31/Dec/2024:23:59:59 +0000] "GET /api/users HTTP/1.1" 200 1234 "https://example.com" "Mozilla/5.0"'
match = APACHE_LOG.match(log_line)
if match:
    print(f"IP: {match.group('ip')}")
    print(f"User: {match.group('user')}")
    print(f"Method: {match.group('method')}")
    print(f"Path: {match.group('path')}")
    print(f"Status: {match.group('status')}")
    print(f"Size: {match.group('size')}")
```

### Pattern 4 — Data Extraction from Structured Text

```python
import re

# Extract key-value pairs from semi-structured text
KV_PATTERN = re.compile(r"""
    (?P<key>[A-Za-z_][\w\s]*?)     # Key (alphanumeric + spaces)
    \s*[:=]\s*                       # Separator (: or =)
    (?P<value>                       # Value
        "(?:[^"\\]|\\.)*"           # Quoted string
        | '(?:[^'\\]|\\.)*'        # Single-quoted string
        | \d+(?:\.\d+)?            # Number
        | \S+                       # Unquoted word
    )
""", re.VERBOSE | re.MULTILINE)

# Extract structured data from a report
report = """
Report: Q4 2024 Financial Summary
Revenue: $1,234,567.89
Expenses: $987,654.32
Profit Margin: 20.0%
Status: "On Track"
Department: 'Engineering'
Headcount: 150
"""

matches = KV_PATTERN.finditer(report)
data = {}
for match in matches:
    key = match.group('key').strip()
    value = match.group('value')
    # Clean value
    if value.startswith('"') or value.startswith("'"):
        value = value[1:-1]
    elif value.replace('.', '').replace('-', '').isdigit():
        value = float(value) if '.' in value else int(value)
    data[key] = value

print("Extracted data:")
for key, value in data.items():
    print(f"  {key}: {value} ({type(value).__name__})")


# Extract all URLs from text
URL_EXTRACTOR = re.compile(r"""
    (?:
        https?://                     # Protocol
        |www\.                        # Or www prefix
    )
    [a-zA-Z0-9]                      # Domain start
    [a-zA-Z0-9.\-]*                  # Domain
    (?:\.[a-zA-Z]{2,})?              # Optional TLD
    (?:/[^\s<>"{}|\\^`\[\]]*)?       # Optional path
""", re.VERBOSE)

text = 'Visit https://example.com/path?q=1 or www.test.org/page#section'
urls = URL_EXTRACTOR.findall(text)
print(f"\nURLs: {urls}")
```

### Pattern 5 — Template Variable Extraction

```python
import re

# Extract template variables from various template syntaxes

# Mustache/Handlebars: {{variable}}
MUSTACHE_VARS = re.compile(r'\{\{(\w+(?:\.\w+)*)\}\}')

# Jinja2: {{ variable }}, {% block %}, {# comment #}
JINJA_VAR = re.compile(r'\{\{\s*(\w+(?:\.\w+)*)\s*\}\}')
JINJA_BLOCK = re.compile(r'\{%\s*(\w+)\s*(\w+)?\s*%\}')
JINJA_COMMENT = re.compile(r'\{#.*?#\}', re.DOTALL)

# React/JSX: {variable}
JSX_VAR = re.compile(r'\{(\w+(?:\.\w+)*)\}')

# Vue: {{ variable }} or :attr="expr"
VUE_VAR = re.compile(r'\{\{\s*(\w+(?:\.\w+)*)\s*\}\}')
VUE_BINDING = re.compile(r':(\w+)="([^"]+)"')


def extract_template_vars(template, syntax='mustache'):
    """Extract all template variables from a template string."""
    patterns = {
        'mustache': MUSTACHE_VARS,
        'jinja': JINJA_VAR,
        'vue': VUE_VAR,
    }
    
    pattern = patterns.get(syntax, MUSTACHE_VARS)
    return list(set(pattern.findall(template)))


# Example
template = """
<h1>{{title}}</h1>
<p>Hello, {{user.name}}!</p>
{% if user.isAdmin %}
  <span>Admin</span>
{% endif %}
<!-- {# This is a comment #} -->
"""

mustache_vars = extract_template_vars(template, 'mustache')
jinja_vars = extract_template_vars(template, 'jinja')

print(f"Mustache variables: {mustache_vars}")
print(f"Jinja2 variables: {jinja_vars}")
```

## Edge Cases & Pitfalls

### 1. Catastrophic Backtracking (ReDoS)
Patterns with nested quantifiers like `(a+)+` or `(a|a)+` cause exponential backtracking on non-matching input. Always test with adversarial input (long strings ending with a mismatch character). Use atomic groups or possessive quantifiers where available.

### 2. Greedy vs Lazy Quantifiers
`.*` matches as much as possible (greedy); `.*?` matches as little as possible (lazy). When extracting data between delimiters, lazy quantifiers are often correct: `<tag>(.*?)</tag>`. But lazy isn't always right — understand when to use each.

### 3. The Dot Doesn't Match Newlines
By default, `.` matches any character EXCEPT newlines. Use `re.DOTALL` (Python) or `s` flag (PCRE/JS) to make `.` match newlines. This is a common source of "why doesn't my pattern match multi-line text?" bugs.

### 4. Unescaped Special Characters
Characters like `.`, `*`, `+`, `?`, `(`, `)`, `[`, `]`, `{`, `}`, `\`, `^`, `$`, `|` have special meaning. To match them literally, escape with `\`. Common mistake: forgetting to escape dots in domain names (`example.com` matches `exampleXcom`).

### 5. Anchors at Wrong Position
`^` and `$` match start/end of STRING by default, not line. Use `re.MULTILINE` flag to make them match start/end of each line. A common bug: expecting `^` to match the start of each line without the flag.

### 6. Character Class Pitfalls
Inside `[...]`, most special characters lose their meaning. `[.*+]` matches `.`, `*`, or `+` literally. But `^` at the start means negation, `-` between characters means range, and `]` must be escaped or placed first. Hyphen confusion: `[a-z]` is a range, but `[-az]` or `[az-]` puts the hyphen at the edges.

### 7. Unicode Word Boundaries
`\b` behaves differently in Unicode mode. In ASCII mode, it matches between `\w` (alphanumeric + underscore) and `\W`. In Unicode mode, `\w` includes all Unicode letters and digits, so `\b` matches at Unicode word boundaries. This can cause unexpected matches in non-Latin text.

### 8. Lookbehind Length Restrictions
Python's `re` module requires lookbehind assertions to have a fixed length. `(?<=abc)` works, but `(?<=a|bc)` doesn't (Python 3.11+ relaxes this). Use the `regex` module for variable-length lookbehind.

### 9. Backreference Limitations
Backreferences (`\1`, `\2`) only work with captured groups, and they match the exact same text, not the same pattern. `\1` matches whatever group 1 matched, not "the same structure." This limits backreferences for pattern-matching tasks.

### 10. Flag Conflicts
Different regex flags interact in complex ways. `re.IGNORECASE | re.MULTILINE` changes the meaning of both `^`/`$` and character class matching. Always be explicit about which flags you're using and document why.

### 11. Capture Group Numbering
Capture groups are numbered left-to-right by opening parenthesis. Nested groups push the count higher. `(a(b))` has group 1 = full match, group 2 = `b`. Named groups help avoid confusion, but unnamed groups in complex patterns are error-prone.

### 12. Empty Matches
Regexes can match empty strings, which leads to surprising behavior in `findall` or `split`. For example, `r'\b'` matches every word boundary, producing many empty matches. Avoid patterns that can match zero-length strings unless intentionally anchoring.

### 13. Encoding Assumptions
Regex engines operate on strings, not bytes. In Python 3, `re` works on Unicode strings. But if you feed byte strings to `re`, the behavior changes. Always ensure consistent string types.

### 14. Cross-Flavor Incompatibilities
Not all regex flavors support the same features. Python `re` doesn't support atomic groups or possessive quantifiers; JavaScript doesn't support lookbehind in older versions; .NET has unique features like balanced groups. Always test in the target flavor.

### 15. Performance vs Readability Trade-off
Highly optimized regexes are often unreadable. Use `re.VERBOSE` mode with comments to document complex patterns. Consider breaking a complex pattern into named components and composing them. A slightly slower but readable regex is better than a fast but unmaintainable one.

## Integration with Other Skills

| Skill | When to Combine | How |
|---|---|---|
| algorithm-design | Optimizing regex-heavy pipelines | Use Aho-Corasick for multi-pattern matching instead of N regex passes |
| code-migration | Porting regex between flavors | Translate syntax, adjust flags, and test for semantic differences |
| i18n | Matching Unicode content | Use Unicode property escapes (`\p{L}`, `\p{N}`) for script-aware matching |
| testing | Property-based regex testing | Generate random strings to test regex correctness and performance |
| code-review | Reviewing regex patterns | Check for ReDoS vulnerabilities, readability, and edge case handling |
| performance-tuning | Optimizing regex hot paths | Profile regex execution, consider alternatives for simple patterns |
| security | Defending against ReDoS | Audit user-facing regex patterns for catastrophic backtracking |
| data-engineering | Parsing structured data | Use regex for log parsing, CSV cleaning, and data extraction pipelines |

## Output Format Templates

### Template 1 — Regex Pattern Documentation

```markdown
## Pattern: {Pattern Name}

**Purpose**: {What this regex matches}
**Flavor**: {PCRE/JS/Python/.NET/Go}
**Flags**: {i/m/s/x/etc.}

### Pattern
```{language}
{regex pattern}
```

### Explanation
| Component | Meaning |
|---|---|
| `{part}` | {explanation} |

### Test Cases
| Input | Expected | Result |
|---|---|---|
| `{test input}` | {match/no match} | {PASS/FAIL} |

### Performance
- Average case: O({complexity})
- Worst case: O({complexity})
- ReDoS risk: {Low/Medium/High}
```

### Template 2 — Regex Cheat Sheet

```markdown
## {Flavor} Regex Quick Reference

### Character Classes
- `\d` — digit [0-9]
- `\w` — word character [a-zA-Z0-9_]
- `\s` — whitespace
- `.` — any character (except newline by default)

### Quantifiers
- `*` — zero or more (greedy)
- `+` — one or more (greedy)
- `?` — zero or one (greedy)
- `{n,m}` — between n and m times

### Anchors
- `^` — start of string/line
- `$` — end of string/line
- `\b` — word boundary

### Groups
- `(abc)` — capturing group
- `(?:abc)` — non-capturing group
- `(?<name>abc)` — named group
- `\1` — backreference

### Lookaround
- `(?=abc)` — positive lookahead
- `(?!abc)` — negative lookahead
- `(?<=abc)` — positive lookbehind
- `(?<!abc)` — negative lookbehind
```

### Template 3 — Debugging Guide

```markdown
## Regex Debugging: Why Doesn't My Pattern Match?

### Checklist
1. [ ] Is the pattern syntactically correct?
2. [ ] Are special characters properly escaped?
3. [ ] Are the right flags set (case-insensitive, multiline, dotall)?
4. [ ] Does the pattern account for whitespace/line breaks?
5. [ ] Are anchors (^, $) at the right positions?
6. [ ] Is the quantifier greedy or lazy as intended?
7. [ ] Does the pattern handle Unicode correctly?

### Common Fixes
- Pattern doesn't match multi-line text → Add `re.DOTALL`
- Pattern is case-sensitive → Add `re.IGNORECASE`
- `^` only matches start of string → Add `re.MULTILINE`
- Pattern is too greedy → Use lazy quantifiers (`*?`, `+?`)
- Pattern times out → Check for catastrophic backtracking
```

### Template 4 — Agent-Friendly Structured Output

```json
{
  "regex": {
    "pattern": "...",
    "flavor": "PCRE",
    "flags": ["i", "m"],
    "description": "...",
    "components": [
      {"part": "...", "meaning": "..."}
    ],
    "test_cases": [
      {"input": "...", "expected": "match", "result": "PASS"}
    ],
    "performance": {
      "average": "O(n)",
      "worst": "O(n)",
      "redos_risk": "low"
    },
    "alternatives": ["..."]
  }
}
```

## Rules

1. **Always test with adversarial input** — Every regex that processes user input must be tested with long, crafted strings to detect ReDoS vulnerabilities.
2. **Prefer named capture groups** — Use `(?P<name>...)` (Python) or `(?<name>...)` (PCRE/JS) instead of numbered groups for readability.
3. **Use verbose mode for complex patterns** — Enable `re.VERBOSE` and document each component with comments.
4. **Avoid regex for HTML/XML parsing** — Use proper parsers (BeautifulSoup, Cheerio, lxml). Regex for HTML is fragile and security-vulnerable.
5. **Validate at multiple layers** — Don't rely on regex alone for security-critical validation (emails, passwords, input sanitization). Use regex as the first layer, with additional validation.
6. **Escape user input in patterns** — When building regex patterns from user input, use `re.escape()` to prevent injection of regex metacharacters.
7. **Document flavor-specific features** — Note which regex features are supported in your target flavor. Test in the actual runtime environment.
8. **Benchmark before optimizing** — Profile regex performance with realistic data before spending time on optimization. Most regexes are fast enough.
9. **Prefer simple patterns when possible** — If a simple `str.replace()` or `str.split()` works, don't use regex. Regex is powerful but not always necessary.
10. **Keep patterns maintainable** — A regex no one understands is a liability. Favor readability over cleverness. Comment complex patterns.
11. **Version-control regex patterns** — Treat regex patterns as code. They need testing, review, and documentation.
12. **Use word boundaries correctly** — `\b` matches between `\w` and `\W`. Be aware that `\w` includes underscore, which may not be desired.
