---
name: regex
description: >-
  Write, debug, and optimize regular expressions for text matching, extraction, and transformation.
  Use this skill when the user mentions regex, regular expression, pattern matching, text extraction,
  string parsing, find and replace, pattern match, string pattern, regex pattern, regex help,
  write a regex, explain this regex, or says عبارت باقاعده، الگوی متنی، استخراج متن، جستجوی الگو،
  پترن باقاعده، بازنویسی عبارت باقاعده.
---

# Regular Expressions Skill — Pattern Matching, Extraction & Text Transformation

## Overview

This skill covers writing, debugging, and optimizing regular expressions for text processing tasks. Regex is a powerful tool for pattern matching, extraction, validation, and transformation of text data. This skill provides a comprehensive reference of common patterns, an explanation of regex syntax, debugging techniques, and performance optimization tips.

## When to Use This Skill

- User wants to write a regex pattern
- User has a regex that doesn't work and needs debugging
- User wants to extract data from text
- User needs to validate input (email, phone, URL, etc.)
- User wants to find and replace text patterns
- User asks "how do I match X in text?"
- User mentions regex, pattern matching, or string parsing

---

## Part 1: Regex Syntax Reference

### Core Syntax

| Pattern | Meaning | Example |
|---------|---------|---------|
| `.` | Any character except newline | `a.c` matches "abc", "a1c" |
| `^` | Start of string | `^Hello` matches "Hello world" |
| `$` | End of string | `world$` matches "Hello world" |
| `\d` | Digit [0-9] | `\d+` matches "123" |
| `\D` | Non-digit | `\D+` matches "abc" |
| `\w` | Word char [a-zA-Z0-9_] | `\w+` matches "hello_123" |
| `\W` | Non-word char | `\W+` matches " @#$" |
| `\s` | Whitespace | `\s+` matches "   " |
| `\S` | Non-whitespace | `\S+` matches "hello" |
| `\b` | Word boundary | `\bcat\b` matches "cat" not "catch" |

### Quantifiers

| Pattern | Meaning | Example |
|---------|---------|---------|
| `*` | 0 or more | `ab*c` matches "ac", "abc", "abbc" |
| `+` | 1 or more | `ab+c` matches "abc", "abbc" not "ac" |
| `?` | 0 or 1 | `colou?r` matches "color" and "colour" |
| `{n}` | Exactly n | `\d{3}` matches "123" |
| `{n,}` | n or more | `\d{2,}` matches "12", "123" |
| `{n,m}` | Between n and m | `\d{2,4}` matches "12", "123", "1234" |
| `*?` | Lazy (0 or more) | `a.*?b` matches "aab" in "aabab" |

### Character Classes

| Pattern | Meaning |
|---------|---------|
| `[abc]` | a, b, or c |
| `[^abc]` | Not a, b, or c |
| `[a-z]` | a through z |
| `[A-Za-z]` | Any letter |
| `[0-9]` | Any digit |
| `[a-zA-Z0-9_]` | Same as `\w` |

### Groups & References

| Pattern | Meaning | Example |
|---------|---------|---------|
| `(abc)` | Capturing group | `(go)+` matches "gogogo" |
| `(?:abc)` | Non-capturing group | `(?:go)+` (no backreference) |
| `(?<name>abc)` | Named group | `(?P<year>\d{4})` |
| `\1` | Backreference to group 1 | `(.)\1` matches "aa", "bb" |
| `a\|b` | Either a or b | `cat\|dog` matches "cat" or "dog" |

### Lookahead & Lookbehind

| Pattern | Meaning | Example |
|---------|---------|---------|
| `(?=abc)` | Positive lookahead | `a(?=b)` matches "a" in "ab" |
| `(?!abc)` | Negative lookahead | `a(?!b)` matches "a" in "ac" |
| `(?<=abc)` | Positive lookbehind | `(?<=a)b` matches "b" in "ab" |
| `(?<!abc)` | Negative lookbehind | `(?<!a)b` matches "b" in "cb" |

---

## Part 2: Common Patterns

### Email Validation

```regex
# Basic email pattern
^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$

# More comprehensive
^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$
```

### Phone Numbers

```regex
# US phone: (123) 456-7890, 123-456-7890, 1234567890
^(\+1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$

# International: +1234567890, +12 3456 7890
^\+?\d{1,3}[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}$
```

### URLs

```regex
# Basic URL
https?:\/\/[^\s/$.?#].[^\s]*

# More comprehensive
https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)
```

### Dates

```regex
# YYYY-MM-DD
\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])

# MM/DD/YYYY
(?:0[1-9]|1[0-2])\/(?:0[1-9]|[12]\d|3[01])\/\d{4}

# DD Month YYYY
\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*\s\d{4}
```

### IP Addresses

```regex
# IPv4
\b(?:\d{1,3}\.){3}\d{1,3}\b

# IPv6
(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}
```

### HTML Tags

```regex
# Match opening tag
<([a-z]+)([^<]*?)(?:\/?>|>.*?<\/\1>)

# Extract tag content
<([a-z]+)[^>]*>(.*?)<\/\1>

# Remove HTML tags
<[^>]+>
```

### CSV Fields

```regex
# Match CSV field (handles quoted fields with commas)
(?:"([^"]*(?:""[^"]*)*)"|([^,]*))(?:,|$)
```

---

## Part 3: Extraction Patterns

### Extract Data from Text

```python
import re

# Extract all emails from text
emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', text)

# Extract phone numbers
phones = re.findall(r'(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}', text)

# Extract URLs
urls = re.findall(r'https?://[^\s<>"]+', text)

# Extract dates
dates = re.findall(r'\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])', text)

# Extract prices
prices = re.findall(r'\$[\d,]+(?:\.\d{2})?', text)

# Extract hashtags
hashtags = re.findall(r'#(\w+)', text)

# Extract mentions
mentions = re.findall(r'@(\w+)', text)
```

### Named Groups for Structured Extraction

```python
# Extract structured data from a log line
pattern = r'(?P<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\s+(?P<level>\w+)\s+(?P<message>.+)'

log_line = "2024-01-15 10:30:00 ERROR Failed to connect to database"
match = re.search(pattern, log_line)

if match:
    print(match.group("timestamp"))  # 2024-01-15 10:30:00
    print(match.group("level"))      # ERROR
    print(match.group("message"))    # Failed to connect to database
```

---

## Part 4: Find & Replace

### Basic Replacement

```python
# Simple replacement
text = re.sub(r'\d+', 'NUM', 'I have 3 cats and 5 dogs')
# Result: "I have NUM cats and NUM dogs"

# Replace with function
def double_number(match):
    return str(int(match.group()) * 2)

text = re.sub(r'\d+', double_number, 'I have 3 cats and 5 dogs')
# Result: "I have 6 cats and 10 dogs"
```

### Common Replacements

```python
# Normalize whitespace
text = re.sub(r'\s+', ' ', text).strip()

# Remove non-alphanumeric characters
text = re.sub(r'[^a-zA-Z0-9\s]', '', text)

# Convert to snake_case
text = re.sub(r'(?<!^)(?=[A-Z])', '_', text).lower()

# Mask sensitive data
text = re.sub(r'(\d{3})\d{4}(\d{4})', r'\1****\2', card_number)  # 1234****5678

# Extract and reformat
text = re.sub(r'(\d{3})-(\d{3})-(\d{4})', r'(\1) \2-\3', phone)
```

---

## Part 5: Debugging Regex

### Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| `.*` (greedy) | Matches too much | Use `.*?` (lazy) |
| Missing `^` or `$` | Matches anywhere | Anchor the pattern |
| Not escaping `.` | Matches any char | Use `\.` for literal dot |
| `\d` vs `[0-9]` | Different in some engines | Use `[0-9]` for portability |
| Forgetting `re.DOTALL` | `.` doesn't match newlines | Add flag or use `[\s\S]` |

### Debugging Steps

```python
import re

# Test your regex step by step
pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

# 1. Test with known matches
assert re.match(pattern, 'user@example.com')
assert re.match(pattern, 'first.last@domain.co.uk')

# 2. Test with known non-matches
assert not re.match(pattern, 'invalid-email')
assert not re.match(pattern, '@domain.com')

# 3. Use re.VERBOSE for readable patterns
pattern = re.compile(r'''
    ^                       # Start of string
    [a-zA-Z0-9._%+-]+      # Username
    @                       # @ symbol
    [a-zA-Z0-9.-]+         # Domain name
    \.                      # Dot
    [a-zA-Z]{2,}            # TLD (2+ letters)
    $                       # End of string
''', re.VERBOSE)

# 4. Use regex101.com for visual debugging
```

### Regex Tester Tools

| Tool | URL | Features |
|------|-----|----------|
| **regex101.com** | https://regex101.com | Debug, explain, test |
| **regexr.com** | https://regexr.com | Visual, learn |
| **Debuggex** | https://www.debuggex.com | Visual diagram |

---

## Part 6: Performance

### Performance Tips

```python
# ❌ BAD: Catastrophic backtracking
re.match(r'(a+)+b', 'a' * 20)  # Hangs!

# ✅ GOOD: Avoid nested quantifiers
re.match(r'a+b', 'a' * 20)  # Fast

# ❌ BAD: Using .* (greedy) for everything
re.match(r'<.*>', '<div>content</div>')  # Matches entire string

# ✅ GOOD: Use specific character classes
re.match(r'<[^>]+>', '<div>content</div>')  # Matches just <div>

# ✅ GOOD: Compile frequently used patterns
email_pattern = re.compile(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
# Reuse compiled pattern
for line in lines:
    if email_pattern.match(line):
        process_email(line)
```

### Precompilation

```python
# ❌ BAD: Recompile every time
for line in lines:
    re.match(r'\d{4}-\d{2}-\d{2}', line)

# ✅ GOOD: Compile once
date_pattern = re.compile(r'\d{4}-\d{2}-\d{2}')
for line in lines:
    date_pattern.match(line)
```

---

## Part 7: Language-Specific Regex

### Python Flags

```python
re.IGNORECASE  # Case-insensitive matching
re.MULTILINE   # ^ and $ match line boundaries
re.DOTALL      # . matches newlines
re.VERBOSE     # Allow comments and whitespace in pattern
re.ASCII       # Use ASCII-only character classes
```

### JavaScript Regex

```javascript
// Global matching
const emails = text.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g);

// Case-insensitive
const match = text.match(/hello/i);

// Replace all
const cleaned = text.replace(/\s+/g, ' ').trim();

// Named groups
const match = text.match(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/);
console.log(match.groups.year);
```

---

## Output Format

```
## Regex Solution

### Pattern
`[regex pattern]`

### Explanation
- `[part 1]` — [what it matches]
- `[part 2]` — [what it matches]

### Test Cases
| Input | Match | Groups |
|-------|-------|--------|
| [test input] | [result] | [groups] |

### Usage
[code example]
```

## Rules

- **Test thoroughly** — Always test with both matching and non-matching inputs
- **Use tools** — regex101.com is your best friend
- **Compile frequently used patterns** — Performance matters in loops
- **Keep patterns readable** — Use `re.VERBOSE` for complex patterns
- **Don't over-complicate** — If regex is too complex, consider string methods
- **Anchor when needed** — Use `^` and `$` to avoid partial matches
- **Be careful with user input** — Regex injection is possible
- **Document complex patterns** — Future you won't remember what `(?<=...)` does
