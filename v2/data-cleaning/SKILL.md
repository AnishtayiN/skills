---
name: data-cleaning
description: >-
  Clean and preprocess raw data for analysis, modeling, or storage. Use this skill whenever the user mentions
  clean data, data cleaning, preprocess data, data preprocessing, handle missing values, normalize data,
  remove duplicates, fix data types, encode categorical variables, scale features, transform data,
  handle outliers, data wrangling, data munging, format dates, standardize columns, rename columns,
  merge datasets, reshape data, pivot data, melt data, split columns, parse messy fields,
  fix encoding issues, remove special characters, trim whitespace, deduplicate records,
  impute missing data, drop null rows, fill NA values, convert types, data quality check,
  data validation, data profiling, consistency check, data audit, dirty data, messy data,
  clean CSV, clean Excel, prepare data for ML, feature engineering prep,
  deduplication, fuzzy matching, string normalization, address standardization,
  phone number formatting, email validation, URL normalization, currency conversion,
  unit standardization, coordinate cleaning, geospatial data cleaning,
  multi-language text cleaning, Persian text cleaning, Arabic text normalization,
  or says پاکسازی داده، پیش‌پردازش داده، حذف مقادیر خالی، نرمال‌سازی داده،
  حذف تکراری‌ها، اصلاح نوع داده، مدیریت داده‌های گمشده، تبدیل داده،
  استانداردسازی ستون‌ها، ادغام داده‌ها، کیفیت داده، آماده‌سازی داده برای یادگیری ماشین،
  ویژگی‌سازی، حذف نویز از داده، رفع خطاهای داده، یکپارچه‌سازی داده،
  تمیز کردن CSV، اصلاح اکسل، حذف ردیف‌های تکراری، پر کردن مقادیر خالی،
  تبدیل تاریخ، استانداردسازی آدرس، فرمت شماره تلفن، اعتبارسنجی ایمیل،
  تطبیق فازی، حذف کاراکترهای خاص، نرمال‌سازی متن فارسی، پاکسازی متنی.
---

# Data Cleaning Skill — Raw Data Preprocessing & Quality Assurance

## Overview

This skill handles the messy reality of real-world data. Raw data is almost never analysis-ready: it has missing values, inconsistent formats, wrong types, duplicates, and encoding problems. This skill provides a systematic pipeline to detect, diagnose, and fix data quality issues so the dataset is clean, consistent, and ready for analysis or modeling.

## When to Use This Skill

- User has a raw dataset that needs preparation before analysis
- User mentions missing values, nulls, or empty fields
- User wants to normalize, standardize, or scale their data
- User needs to remove duplicates, fix types, or parse dates
- User wants to merge, reshape, or restructure datasets
- User says "clean this data" or "prepare this for analysis"
- Data has encoding issues, special characters, or inconsistent formatting
- User needs data prepared for machine learning (encoding, scaling, feature prep)
- User wants to validate data against rules or schemas
- User has multi-language data requiring text normalization (Persian/Arabic)

## Cleaning Workflow

### Step 1: Load and Inspect

1. **Load the data** — Read the file (CSV, Excel, JSON, TSV, etc.) into a pandas DataFrame.
2. **Initial inspection** — Print shape, dtypes, first rows, and basic info.
3. **Missing value audit** — Count nulls per column (absolute and percentage).
4. **Duplicate check** — Count exact duplicate rows and near-duplicates.
5. **Type check** — Identify columns where the dtype doesn't match the expected content (e.g., numbers stored as strings, dates stored as objects).

Report all findings to the user before making changes. Show a **Data Quality Report**.

### Step 2: Handle Missing Values

For each column with missing data, choose a strategy based on the column type and missingness pattern:

| Strategy | When to Use | Method |
|----------|-------------|--------|
| **Drop rows** | Missing <5% and rows are not critical | `df.dropna(subset=[col])` |
| **Drop columns** | Missing >50% and column is not essential | `df.drop(columns=[col])` |
| **Mean/Median impute** | Numeric column, data is MCAR | `df[col].fillna(median)` |
| **Mode impute** | Categorical column, few missing | `df[col].fillna(mode)` |
| **Forward/Back fill** | Time-series data | `df[col].ffill()` or `.bfill()` |
| **Constant fill** | Missing has meaning (e.g., "Unknown") | `df[col].fillna('N/A')` |
| **Interpolation** | Numeric time-series | `df[col].interpolate()` |
| **KNN imputation** | Multivariate, MAR pattern | `from sklearn.impute import KNNImputer` |

Always explain to the user which strategy was chosen and why. If unsure, ask.

### Step 3: Fix Data Types

Common type fixes:
- **String to numeric**: `pd.to_numeric(col, errors='coerce')` — strips non-numeric characters
- **String to datetime**: `pd.to_datetime(col, format=...)` — specify format if non-standard
- **Numeric to category**: `df[col].astype('category')` — for low-cardinality columns
- **Object to bool**: Map yes/no, true/false, 1/0 to boolean

### Step 4: Standardize & Normalize

- **Column names**: Strip whitespace, convert to lowercase/snake_case, remove special characters
- **String values**: Trim whitespace, standardize case, fix encoding artifacts (e.g., `\u200c`, `\xa0`)
- **Numeric values**: Check for units in column names (e.g., "Revenue ($K)"), normalize if needed
- **Dates**: Ensure consistent format (ISO 8601 preferred: `YYYY-MM-DD`)
- **Categorical values**: Fix typos and inconsistencies (e.g., "USA", "U.S.A.", "United States" → one canonical value)

### Step 5: Remove Duplicates

1. **Exact duplicates**: `df.drop_duplicates()`
2. **Subset duplicates**: `df.drop_duplicates(subset=[key_cols])` — keep first/last based on context
3. **Near-duplicates**: Use fuzzy matching (`rapidfuzz`) for string columns if the user suspects near-duplicates

### Step 6: Handle Outliers (if requested)

- **IQR method**: Flag values below Q1-1.5*IQR or above Q3+1.5*IQR
- **Z-score method**: Flag values with |z| > 3
- **Options**: Remove, cap (winsorize), or leave as-is depending on domain context
- Always ask the user before removing outliers — they may be valid data points

### Step 7: Encode & Transform (for ML preparation)

Only if the user is preparing data for machine learning:
- **Label encoding**: Ordinal categories
- **One-hot encoding**: Nominal categories with <10 unique values
- **Scaling**: `StandardScaler` (z-score) or `MinMaxScaler` (0-1) — ask which the user prefers
- **Log transform**: Right-skewed numeric distributions

### Step 8: Validate and Export

1. Re-run the quality checks from Step 1 to confirm issues are resolved
2. Print a before/after summary showing what changed
3. Export the cleaned data to the user's preferred format (default: same as input)

## Advanced Techniques

### 1. Missingness Pattern Analysis (Little's MCAR Test)

Determine whether data is Missing Completely At Random (MCAR), Missing At Random (MAR), or Missing Not At Random (MNAR) to choose the right imputation strategy:

```python
import missingno as msno
import matplotlib.pyplot as plt

# Visualize missingness patterns
msno.matrix(df)
plt.savefig('missingness_matrix.png', dpi=150)
msno.heatmap(df)  # Correlation of missingness between columns
plt.savefig('missingness_heatmap.png', dpi=150)

# Statistical test for MCAR
from pyampute.exploration.mcar import MCARTest
mt = MCARTest(method='Little')
print(mt.test(df))  # p > 0.05 suggests MCAR
```

### 2. Persian/Arabic Text Normalization

Standardize Persian and Arabic text which commonly contains mixed character sets:

```python
import re

def normalize_persian(text):
    if pd.isna(text):
        return text
    text = str(text)
    # Replace Arabic Ye with Persian Ye
    text = text.replace('ي', 'ی').replace('ك', 'ک')
    # Remove ZWNJ variations, keep standard
    text = re.sub(r'[\u200c\u200d]+', '\u200c', text)
    # Normalize multiple spaces
    text = re.sub(r'\s+', ' ', text).strip()
    # Remove non-breaking spaces
    text = text.replace('\xa0', ' ')
    # Remove zero-width characters
    text = re.sub(r'[\u200b\u200e\u200f\ufeff]', '', text)
    return text

df['name'] = df['name'].apply(normalize_persian)
```

### 3. Smart Deduplication with Blocking

For large datasets, full pairwise fuzzy matching is O(n²). Use blocking to reduce comparisons:

```python
from rapidfuzz import process, fuzz

def find_near_duplicates(df, col, threshold=85, block_cols=None):
    """Block on a key column to avoid O(n²) comparisons."""
    if block_cols:
        blocks = df.groupby(block_cols)
    else:
        blocks = [(None, df)]
    
    dupes = []
    for key, group in blocks:
        names = group[col].tolist()
        for i, name in enumerate(names):
            matches = process.extract(name, names[i+1:], limit=3,
                                       scorer=fuzz.token_sort_ratio)
            for match_name, score, idx in matches:
                if score >= threshold:
                    dupes.append((group.index[i], group.index[i+1+idx], score, name, match_name))
    return pd.DataFrame(dupes, columns=['idx1', 'idx2', 'score', 'val1', 'val2'])
```

### 4. Multi-Source Merge with Conflict Resolution

When merging data from multiple sources with overlapping columns:

```python
def merge_with_priority(left, right, on, how='outer', priority='left'):
    """Merge two DataFrames, resolving column conflicts using priority."""
    merged = left.merge(right, on=on, how=how, suffixes=('_left', '_right'))
    conflict_cols = [c for c in merged.columns if c.endswith('_left')]
    
    for col_left in conflict_cols:
        base = col_left[:-5]
        col_right = f"{base}_right"
        if priority == 'left':
            merged[base] = merged[col_left].fillna(merged[col_right])
        else:
            merged[base] = merged[col_right].fillna(merged[col_left])
        merged.drop(columns=[col_left, col_right], inplace=True)
    return merged
```

### 5. Schema Validation with Great Expectations

Validate cleaned data against a schema to catch remaining issues:

```python
import pandas as pd

def validate_schema(df, rules):
    """Validate DataFrame against a dict of column rules."""
    results = []
    for col, rule in rules.items():
        if col not in df.columns:
            results.append((col, 'MISSING', f'Column not found'))
            continue
        if rule.get('not_null') and df[col].isna().any():
            n = df[col].isna().sum()
            results.append((col, 'FAIL', f'{n} null values'))
        if rule.get('unique') and df[col].duplicated().any():
            n = df[col].duplicated().sum()
            results.append((col, 'FAIL', f'{n} duplicates'))
        if 'dtype' in rule and str(df[col].dtype) != rule['dtype']:
            results.append((col, 'WARN', f'Expected {rule["dtype"]}, got {df[col].dtype}'))
        if 'min' in rule and df[col].min() < rule['min']:
            results.append((col, 'FAIL', f'Min {df[col].min()} < {rule["min"]}'))
        if 'max' in rule and df[col].max() > rule['max']:
            results.append((col, 'FAIL', f'Max {df[col].max()} > {rule["max"]}'))
    return pd.DataFrame(results, columns=['Column', 'Status', 'Detail'])
```

### 6. Automated Type Inference

Detect and fix types heuristically when schema is unknown:

```python
def auto_fix_types(df):
    for col in df.columns:
        # Try datetime
        if df[col].dtype == 'object':
            try:
                dt = pd.to_datetime(df[col], infer_datetime_format=True)
                if dt.notna().sum() > len(df) * 0.8:
                    df[col] = dt
                    continue
            except: pass
            # Try numeric
            try:
                num = pd.to_numeric(df[col].str.replace(r'[^\d.-]', '', regex=True))
                if num.notna().sum() > len(df) * 0.8:
                    df[col] = num
                    continue
            except: pass
            # Check if low-cardinality category
            if df[col].nunique() / len(df) < 0.05 and df[col].nunique() < 50:
                df[col] = df[col].astype('category')
    return df
```

### 7. Winsorization for Outlier Handling

Cap extreme values without removing them, preserving row count:

```python
from scipy.stats import mstats

def winsorize_column(series, limits=(0.01, 0.01)):
    """Winsorize a series, capping bottom/top 1% by default."""
    return pd.Series(
        mstats.winsorize(series.dropna(), limits=limits),
        index=series.dropna().index
    )

df['income'] = winsorize_column(df['income'], limits=(0.05, 0.05))
```

## Common Patterns

### Pattern 1: Sales Data with Mixed Currencies

```python
# Normalize prices to a single currency
currency_rates = {'USD': 1.0, 'EUR': 1.08, 'GBP': 1.27, 'IRR': 0.000024}
df['amount_usd'] = df.apply(
    lambda r: r['amount'] * currency_rates.get(r['currency'], 1.0), axis=1
)
```

### Pattern 2: Messy Address Standardization

```python
def clean_address(addr):
    if pd.isna(addr): return addr
    addr = str(addr).strip()
    # Common abbreviations
    replacements = {'St.':'Street', 'Ave':'Avenue', 'Rd':'Road', 'Blvd':'Boulevard'}
    for abbr, full in replacements.items():
        addr = re.sub(rf'\b{abbr}\.?\b', full, addr, flags=re.IGNORECASE)
    # Remove extra spaces
    addr = re.sub(r'\s+', ' ', addr)
    return addr.title()
```

### Pattern 3: Date Parsing from Multiple Formats

```python
from dateutil.parser import parse

def flexible_date_parser(series):
    """Parse dates from mixed formats."""
    return pd.to_datetime(series.apply(lambda x: parse(str(x), fuzzy=True, dayfirst=True) if pd.notna(x) else None))

df['clean_date'] = flexible_date_parser(df['date_messy'])
```

### Pattern 4: Splitting Composite Fields

```python
# "John A. Smith Jr." → first, middle, last, suffix
name_parts = df['full_name'].str.extract(
    r'^(?P<first>\w+)\s+(?P<middle>[A-Z]\.?\s+)?(?P<last>\w+)(?:\s+(?P<suffix>Jr\.?|Sr\.?|III?|IV))?$'
)
df = pd.concat([df, name_parts], axis=1)
```

### Pattern 5: Phone Number Normalization

```python
import re

def normalize_phone(phone):
    if pd.isna(phone): return phone
    digits = re.sub(r'\D', '', str(phone))
    if len(digits) == 10:
        return f"({digits[:3]}) {digits[3:6]}-{digits[6:]}"
    elif len(digits) == 11 and digits[0] == '1':
        digits = digits[1:]
        return f"({digits[:3]}) {digits[3:6]}-{digits[6:]}"
    return str(phone)  # Return original if can't parse

df['phone_clean'] = df['phone'].apply(normalize_phone)
```

## Edge Cases & Pitfalls

1. **Silent Data Loss on Coercion** — `pd.to_numeric(errors='coerce')` converts unparseable values to NaN without warning. Always count how many values become NaN after coercion and report it.
2. **Encoding Mismatch on Read** — Opening a UTF-8 file as latin-1 or vice versa causes mojibake (e.g., `Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©`). Always try `encoding='utf-8'` first, fall back to `'latin-1'`, then `'utf-8-sig'`.
3. **Datetime Ambiguity** — "01/02/2024" is Jan 2 in the US but Feb 1 in Europe. Always specify `dayfirst=True/False` explicitly and confirm with the user.
4. **Categorical Collapse After Drop** — Dropping rows with missing values in one column can eliminate all instances of a rare category in another column. Check value counts after dropping.
5. **Forward-Fill Leakage in Time Series** — Using `ffill()` across non-chronological data (unsorted) propagates values incorrectly. Sort by time before filling.
6. **Median vs Mean Impute Skew** — Mean imputation on skewed data pulls the distribution toward center, reducing variance and masking the true shape. Prefer median for skewed data.
7. **Duplicate Key Ambiguity** — `drop_duplicates(subset=['email'])` silently keeps the first occurrence. If the "wrong" row is first, you lose important data. Sort by recency or completeness first.
8. **One-Hot Explosion** — One-hot encoding a column with 500 unique values creates 500 new columns. Use target encoding or frequency encoding for high-cardinality features.
9. **Mixed-Type Columns** — A column with values like `["10", "N/A", 5.5, None]` gets loaded as `object` type. `pd.to_numeric` fixes it but may lose the "N/A" information. Create an explicit "is_valid" flag column first.
10. **BOM Characters (\ufeff)** — Files saved by some tools include a Byte Order Mark at the start. This appears as `\ufeff` in the first column name. Strip it: `df.columns = [c.lstrip('\ufeff') for c in df.columns]`.
11. **Line Ending Differences** — CSVs from Windows (`\r\n`) vs Unix (`\n`) can cause rows to be misread if the parser is misconfigured. Let pandas handle it (it does by default), but be aware.
12. **Scientific Notation in CSVs** — Large numbers may be written as `1.5E+10` in CSVs and read as floats instead of integers. Use `dtype` parameter on read to force integer columns.
13. **Commas Inside Quoted Fields** — `"New York, NY"` in a CSV should be one field. If `quoting` is not set correctly, it splits into two fields. Use `pd.read_csv(quotechar='"')`.
14. **Timezone Naive vs Aware Mixing** — Comparing timezone-naive and timezone-aware timestamps raises `TypeError`. Standardize all to one form before merging or comparing.
15. **Multi-Index Reset Loss** — After a `groupby` or `pivot_table`, resetting the index can create column name conflicts. Always check for duplicates after `.reset_index()`.
16. **String Truncation in Excel** — Excel has a 32,767 character limit per cell. Long text fields get truncated when saved as .xlsx. Warn the user if any string column has values >30,000 characters.

## Output Format Templates

### Template A: Standard Cleaning Report

```
## Data Quality Report

**File:** [path]
**Shape:** [rows] x [columns]
**Issues Found:**
- Missing values: [summary table]
- Wrong types: [columns]
- Duplicates: [count]
- Encoding issues: [if any]

## Cleaning Actions Applied

1. [What was done and why]
2. [...]

## Before / After Summary

| Metric | Before | After |
|--------|--------|-------|
| Rows   | X      | Y     |
| Missing cells | N  | 0    |
| Duplicates    | M  | 0    |

**Output saved to:** [path]
```

### Template B: ML Preparation Report

```
## Data Preparation for Modeling

### Input Data
- Source: [file], [rows] x [cols]
- Target variable: [column]

### Preprocessing Pipeline
1. **Missing values**: [strategy per column]
2. **Encoding**: [which columns, which method]
3. **Scaling**: [method, which columns]
4. **Feature engineering**: [new columns created]

### Final Dataset
- Shape: [rows] x [features]
- Feature dtypes: [summary]

### Train/Test Split
- Train: [n] rows ([pct]%)
- Test: [n] rows ([pct]%)
- Stratified on: [column] (if applicable)

**Output:** [train.csv] and [test.csv] saved to [path]
```

### Template C: Minimal Fix Report (for quick fixes)

```
## Quick Fix Applied

**File:** [path]
**Changes:** [list of 1-3 fixes]
- Removed [N] duplicate rows
- Fixed [col] from string to datetime
- Filled [N] missing values in [col] with median

**Output:** [path]
```

### Template D: Comprehensive Audit Report (for enterprise data)

```
## Comprehensive Data Quality Audit

### Scope
- **Datasets:** [list of files]
- **Total records:** [sum]
- **Audit date:** [date]

### Quality Dimensions

| Dimension | Score | Details |
|-----------|-------|----------|
| Completeness | [X]% | [N] missing values across [M] columns |
| Uniqueness | [X]% | [N] duplicate records found |
| Validity | [X]% | [N] values outside valid ranges |
| Consistency | [X]% | [N] cross-reference mismatches |
| Timeliness | [X]% | Data as of [date] |

### Critical Issues (Require Immediate Action)
1. [issue description + affected rows]
2. ...

### Warnings (Review Recommended)
1. [issue description]
2. ...

### Recommendations
1. [data governance suggestion]
2. [process improvement suggestion]

**Detailed audit log:** [audit_log.csv]
```

## Tools & Libraries

- **pandas** — primary data manipulation
- **numpy** — numeric operations
- **re** — regex-based string cleaning
- **python-dateutil** — flexible date parsing
- **rapidfuzz** — fast fuzzy string matching (preferred over fuzzywuzzy)
- **scikit-learn** — encoding, scaling, imputation (for ML prep)
- **missingno** — missing data visualization
- **pyampute** — MCAR test for missingness analysis
- **chardet / cchardet** — automatic encoding detection
- Use the **xlsx** skill for Excel-specific cleaning tasks

## Integration with Other Skills

- **data-analysis** — After cleaning, hand off to data-analysis for EDA, statistics, and visualization.
- **xlsx** — Use for reading/writing Excel files with multiple sheets, or when cleaning within a formatted Excel workbook.
- **web-scraping** — Use when raw data needs to be collected from websites before cleaning.
- **charts** — Use to visualize data quality issues (missingness heatmaps, outlier distributions) in the audit report.
- **pdf** — Use to generate a formatted PDF report of the data quality audit.

## Language Handling

- Write all narrative text and explanations in the user's language
- Keep code, column names, and function names in English
- For Persian/Farsi text cleaning: always apply Persian normalization (ی/ي, ک/ك, zero-width characters) before any other text processing
- Explain encoding issues in simple terms the user will understand
