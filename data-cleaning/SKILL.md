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
  KNN imputation, MICE imputation, text cleaning, regex cleaning, datetime parsing,
  categorical cleaning, data validation, Great Expectations, pandera, data quality monitoring,
  or says پاکسازی داده، پیش‌پردازش داده، حذف مقادیر خالی، نرمال‌سازی داده،
  حذف تکراری‌ها، اصلاح نوع داده، مدیریت داده‌های گمشده، تبدیل داده،
  استانداردسازی ستون‌ها، ادغام داده‌ها، کیفیت داده.
---

# Data Cleaning Skill — Raw Data Preprocessing & Quality Assurance

## Overview

This skill handles the messy reality of real-world data. Raw data is almost never analysis-ready: it has missing values, inconsistent formats, wrong types, duplicates, encoding problems, and structural issues. This skill provides a systematic pipeline to detect, diagnose, and fix data quality issues so the dataset is clean, consistent, and ready for analysis, visualization, or machine learning. Covers advanced imputation, text cleaning, datetime parsing, data validation frameworks, and production-grade cleaning pipelines.

## When to Use This Skill

- User has a raw dataset that needs preparation before analysis
- User mentions missing values, nulls, or empty fields
- User wants to normalize, standardize, or scale their data
- User needs to remove duplicates, fix types, or parse dates
- User wants to merge, reshape, or restructure datasets
- User says "clean this data" or "prepare this for analysis"
- Data has encoding issues, special characters, or inconsistent formatting
- User needs text data cleaning (regex, NLP preprocessing)
- User wants data validation or quality monitoring
- User mentions پاکسازی داده، پیش‌پردازش داده, or کیفیت داده

---

## Part 1: Data Quality Assessment

### Step 1: Load and Inspect

1. **Load the data** — Read the file (CSV, Excel, JSON, TSV, Parquet) into a pandas DataFrame.
2. **Initial inspection** — Print shape, dtypes, first rows, and basic info.
3. **Missing value audit** — Count nulls per column (absolute and percentage).
4. **Duplicate check** — Count exact duplicate rows and near-duplicates.
5. **Type check** — Identify columns where the dtype doesn't match expected content.
6. **Range check** — Verify numeric values are within expected ranges.
7. **Uniqueness check** — Identify columns that should be unique but aren't.

```python
import pandas as pd
import numpy as np

def data_quality_report(df: pd.DataFrame) -> dict:
    """Generate a comprehensive data quality report."""
    report = {
        "shape": df.shape,
        "dtypes": df.dtypes.to_dict(),
        "missing": {
            col: {"count": df[col].isna().sum(), "pct": round(df[col].isna().mean() * 100, 2)}
            for col in df.columns if df[col].isna().any()
        },
        "duplicates": df.duplicated().sum(),
        "numeric_stats": df.describe().to_dict() if len(df.select_dtypes(include=[np.number]).columns) > 0 else {},
        "categorical_stats": {
            col: {"unique": df[col].nunique(), "top": df[col].mode().iloc[0] if not df[col].mode().empty else None}
            for col in df.select_dtypes(include=["object", "category"]).columns
        }
    }
    return report
```

### Missingness Patterns

| Pattern | Abbreviation | Description | Handling |
|---------|-------------|-------------|----------|
| Missing Completely at Random | MCAR | Missingness unrelated to any data | Safe to drop or impute |
| Missing at Random | MAR | Missingness related to observed data | Impute using other columns |
| Missing Not at Random | MNAR | Missingness related to the missing value itself | Need domain knowledge |

```python
# Test for MCAR using Little's test (simplified)
# If missing values are randomly distributed across rows, MCAR is plausible
missing_pattern = df.isnull().sum() / len(df)
print(missing_pattern.sort_values(ascending=False))
```

---

## Part 2: Missing Value Strategies

### Strategy Selection Matrix

| Strategy | When to Use | Code | Risk |
|----------|-------------|------|------|
| **Drop rows** | Missing <5% and MCAR | `df.dropna(subset=[col])` | Loses data |
| **Drop columns** | Missing >50% and not essential | `df.drop(columns=[col])` | Loses features |
| **Mean impute** | Numeric, MCAR, no outliers | `df[col].fillna(df[col].mean())` | Reduces variance |
| **Median impute** | Numeric, MCAR, has outliers | `df[col].fillna(df[col].median())` | Biased toward center |
| **Mode impute** | Categorical, few missing | `df[col].fillna(df[col].mode()[0])` | Biased toward most common |
| **Forward fill** | Time-series, chronological | `df[col].ffill()` | Propagates last value |
| **Back fill** | Time-series, reverse chronological | `df[col].bfill()` | Uses next value |
| **Interpolation** | Numeric time-series | `df[col].interpolate(method='linear')` | Assumes linearity |
| **Constant fill** | Missing has meaning | `df[col].fillna('Unknown')` | May introduce bias |
| **KNN impute** | Related features exist | `KNNImputer().fit_transform(df)` | Computationally expensive |
| **MICE** | Complex missingness patterns | `IterativeImputer().fit_transform(df)` | Most accurate but slow |
| **Regression impute** | Strong correlations exist | `df[col].fillna(df[other_cols].predict())` | Overfitting risk |

### Advanced Imputation: KNN

```python
from sklearn.impute import KNNImputer

# KNN imputation uses K nearest neighbors to estimate missing values
# Based on similarity of other columns
imputer = KNNImputer(n_neighbors=5, weights='distance')
df_imputed = pd.DataFrame(
    imputer.fit_transform(df),
    columns=df.columns,
    index=df.index
)
```

### Advanced Imputation: MICE (Multiple Imputation by Chained Equations)

```python
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer

# MICE iteratively models each feature with missing values
# as a function of other features
imputer = IterativeImputer(
    max_iter=10,
    random_state=42,
    sample_posterior=True  # Adds randomness for better uncertainty estimation
)
df_imputed = pd.DataFrame(
    imputer.fit_transform(df),
    columns=df.columns,
    index=df.index
)
```

### Always Explain Your Choice

```python
# Example: explain the imputation strategy
print(f"Column '{col}' has {missing_pct}% missing values.")
print(f"Strategy: Median imputation (chosen because data has outliers).")
print(f"Before: mean={df[col].mean():.2f}, median={df[col].median():.2f}")
```

---

## Part 3: Text Data Cleaning

### Common Text Cleaning Patterns

```python
import re

def clean_text(text):
    """Comprehensive text cleaning pipeline."""
    if pd.isna(text):
        return text
    
    # 1. Remove HTML tags
    text = re.sub(r'<[^>]+>', '', text)
    
    # 2. Remove URLs
    text = re.sub(r'https?://\S+|www\.\S+', '', text)
    
    # 3. Remove email addresses
    text = re.sub(r'\S+@\S+', '', text)
    
    # 4. Normalize Unicode (fix encoding artifacts)
    text = unicodedata.normalize('NFKC', text)
    
    # 5. Remove special characters (keep alphanumeric and basic punctuation)
    text = re.sub(r'[^\w\s.,!?;:\'-]', '', text)
    
    # 6. Normalize whitespace
    text = re.sub(r'\s+', ' ', text).strip()
    
    # 7. Fix common encoding issues
    text = text.replace('â€™', "'").replace('â€œ', '"').replace('â€\x9d', '"')
    
    return text
```

### Column Name Cleaning

```python
def clean_column_names(df):
    """Standardize column names."""
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(r'[^\w]+', '_', regex=True)  # Replace non-alphanumeric with _
        .str.replace(r'_+', '_', regex=True)       # Collapse multiple _
        .str.strip('_')                             # Remove leading/trailing _
    )
    return df
```

### String Value Cleaning

```python
def clean_string_column(df, col):
    """Clean a string column."""
    df[col] = (
        df[col]
        .str.strip()                    # Remove leading/trailing whitespace
        .str.lower()                    # Normalize to lowercase
        .str.replace(r'\s+', ' ', regex=True)  # Normalize internal whitespace
        .str.replace(r'[^\w\s]', '', regex=True)  # Remove special chars
    )
    return df
```

### Fuzzy Matching for Categorical Cleanup

```python
from rapidfuzz import fuzz, process

# Find near-duplicates in a categorical column
categories = df['category'].unique()
threshold = 85  # Similarity threshold

# Find clusters of similar values
for i, cat in enumerate(categories):
    matches = process.extract(cat, categories, scorer=fuzz.token_sort_ratio)
    similar = [m for m in matches if m[1] > threshold and m[0] != cat]
    if similar:
        print(f"'{cat}' is similar to: {similar}")
```

---

## Part 4: Datetime Cleaning

### Common Datetime Issues and Fixes

```python
def clean_datetime_column(df, col, expected_format=None):
    """Parse and clean a datetime column."""
    
    # 1. Try standard parsing first
    df[col] = pd.to_datetime(df[col], errors='coerce', infer_datetime_format=True)
    
    # 2. For remaining NaT values, try custom formats
    if df[col].isna().any():
        formats = [
            '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d',
            '%Y-%m-%d %H:%M:%S', '%m-%d-%Y %H:%M',
            '%d %b %Y', '%B %d, %Y', '%b %d, %Y',
            '%Y%m%d', '%d%m%Y',
        ]
        for fmt in formats:
            mask = df[col].isna()
            if not mask.any():
                break
            df.loc[mask, col] = pd.to_datetime(
                df.loc[mask, col_backup], format=fmt, errors='coerce'
            )
    
    # 3. Standardize to ISO 8601
    df[col] = df[col].dt.strftime('%Y-%m-%d %H:%M:%S')
    
    return df
```

### Timezone Handling

```python
# Standardize all datetimes to UTC
df['created_at'] = pd.to_datetime(df['created_at'], utc=True)

# Convert to specific timezone
df['created_at_local'] = df['created_at'].dt.tz_convert('Asia/Tehran')
```

### Extract Date Components

```python
# Useful for feature engineering
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day_of_week'] = df['date'].dt.day_name()
df['quarter'] = df['date'].dt.quarter
df['is_weekend'] = df['date'].dt.dayofweek >= 5
```

---

## Part 5: Categorical Data Cleaning

### Standardize Categories

```python
# Map inconsistent values to canonical form
category_mapping = {
    'usa': 'United States',
    'u.s.a.': 'United States',
    'us': 'United States',
    'united states of america': 'United States',
    'uk': 'United Kingdom',
    'great britain': 'United Kingdom',
    'england': 'United Kingdom',
}

df['country'] = df['country'].str.lower().map(category_mapping).fillna(df['country'])
```

### Fix Typos with Fuzzy Matching

```python
from rapidfuzz import process

# Define canonical categories
valid_categories = ['Electronics', 'Clothing', 'Food', 'Books', 'Home']

# Fix typos in each row
def fix_category(value, valid, threshold=80):
    match = process.extractOne(value, valid, score_cutoff=threshold)
    return match[0] if match else value

df['category'] = df['category'].apply(lambda x: fix_category(x, valid_categories))
```

### Reduce Cardinality

```python
# Group rare categories into "Other"
value_counts = df['category'].value_counts()
rare_categories = value_counts[value_counts < 10].index
df['category'] = df['category'].replace(rare_categories, 'Other')
```

---

## Part 6: Advanced Duplicate Detection

### Exact Duplicates

```python
# Full row duplicates
exact_dupes = df.duplicated().sum()
print(f"Exact duplicates: {exact_dupes}")

# Subset duplicates (same key columns)
subset_dupes = df.duplicated(subset=['email', 'name']).sum()
print(f"Duplicate emails: {subset_dupes}")
```

### Near-Duplicates with Fuzzy Matching

```python
from rapidfuzz import fuzz

def find_near_duplicates(df, col, threshold=85):
    """Find pairs of rows with similar values in a column."""
    values = df[col].unique()
    duplicates = []
    
    for i, v1 in enumerate(values):
        for v2 in values[i+1:]:
            ratio = fuzz.ratio(str(v1), str(v2))
            if ratio > threshold:
                duplicates.append((v1, v2, ratio))
    
    return duplicates

# Usage
near_dupes = find_near_duplicates(df, 'company_name', threshold=80)
for v1, v2, score in near_dupes:
    print(f"'{v1}' ≈ '{v2}' (similarity: {score}%)")
```

### Deduplication Strategy

```python
# Keep the most complete row (fewest missing values)
df['_completeness'] = df.notna().sum(axis=1)
df = df.sort_values('_completeness', ascending=False).drop_duplicates(
    subset=['email'], keep='first'
).drop(columns=['_completeness'])

# Or keep the most recent
df['parsed_date'] = pd.to_datetime(df['created_at'])
df = df.sort_values('parsed_date', ascending=False).drop_duplicates(
    subset=['user_id'], keep='first'
)
```

---

## Part 7: Outlier Detection and Handling

### Detection Methods

```python
# IQR Method
Q1 = df['value'].quantile(0.25)
Q3 = df['value'].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
outliers_iqr = df[(df['value'] < lower_bound) | (df['value'] > upper_bound)]

# Z-Score Method
from scipy import stats
z_scores = np.abs(stats.zscore(df['value'].dropna()))
outliers_z = df[z_scores > 3]

# Modified Z-Score (MAD-based, more robust)
median = df['value'].median()
mad = np.median(np.abs(df['value'] - median))
modified_z = 0.6745 * (df['value'] - median) / mad
outliers_mad = df[np.abs(modified_z) > 3.5]
```

### Handling Options

```python
# Option 1: Remove
df_clean = df[(df['value'] >= lower_bound) & (df['value'] <= upper_bound)]

# Option 2: Cap (Winsorize)
df['value'] = df['value'].clip(lower=lower_bound, upper=upper_bound)

# Option 3: Replace with NaN (then impute)
df.loc[(df['value'] < lower_bound) | (df['value'] > upper_bound), 'value'] = np.nan

# Option 4: Log transform (for right-skewed data)
df['value_log'] = np.log1p(df['value'])
```

---

## Part 8: Data Validation Frameworks

### Using pandera

```python
import pandera as pa
from pandera import Column, Check

# Define schema
schema = pa.DataFrameSchema({
    "id": Column(int, Check.greater_than(0), unique=True),
    "name": Column(str, Check.str_length(min_value=1, max_value=100)),
    "email": Column(str, Check.str_matches(r'^[\w.-]+@[\w.-]+\.\w+$')),
    "age": Column(int, Check.in_range(0, 150), nullable=True),
    "salary": Column(float, Check.greater_than(0)),
    "signup_date": Column(pa.DateTime, nullable=False),
})

# Validate
validated_df = schema.validate(df)
```

### Using Great Expectations

```python
import great_expectations as gx

context = gx.get_context()

# Create expectation suite
suite = context.add_expectation_suite("data_quality")

# Add expectations
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToNotBeNull(column="email")
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeUnique(column="id")
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeBetween(
        column="age", min_value=0, max_value=150
    )
)

# Run validation
result = context.run_validation_operator(
    "action_list_operator",
    assets_to_validate=[batch],
    expectation_suite_name="data_quality"
)
```

---

## Part 9: Production Cleaning Pipeline

### Complete Pipeline Template

```python
import pandas as pd
import numpy as np
from pathlib import Path

def clean_dataset(input_path: str, output_path: str) -> dict:
    """Complete data cleaning pipeline."""
    
    # 1. Load
    df = pd.read_csv(input_path)
    original_shape = df.shape
    
    # 2. Quality Report
    report = {"original_shape": original_shape}
    
    # 3. Clean Column Names
    df.columns = df.columns.str.strip().str.lower().str.replace(r'[^\w]+', '_', regex=True)
    
    # 4. Remove Exact Duplicates
    df = df.drop_duplicates()
    report["after_dedup"] = df.shape[0]
    
    # 5. Fix Data Types
    for col in df.select_dtypes(include=['object']).columns:
        # Try numeric conversion
        if df[col].str.match(r'^[\d,.\-]+$').any():
            df[col] = pd.to_numeric(df[col].str.replace(',', ''), errors='coerce')
        # Try datetime conversion
        elif df[col].str.match(r'\d{4}[-/]\d{2}[-/]\d{2}').any():
            df[col] = pd.to_datetime(df[col], errors='coerce', infer_datetime_format=True)
    
    # 6. Handle Missing Values
    for col in df.columns:
        missing_pct = df[col].isna().mean() * 100
        
        if missing_pct > 50:
            df = df.drop(columns=[col])
        elif missing_pct > 0:
            if df[col].dtype in ['float64', 'int64']:
                df[col] = df[col].fillna(df[col].median())
            else:
                df[col] = df[col].fillna(df[col].mode()[0] if not df[col].mode().empty else 'Unknown')
    
    # 7. Standardize Strings
    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].str.strip().str.lower()
    
    # 8. Remove Outliers (optional, based on user preference)
    # for col in df.select_dtypes(include=[np.number]).columns:
    #     Q1, Q3 = df[col].quantile([0.25, 0.75])
    #     IQR = Q3 - Q1
    #     df = df[(df[col] >= Q1 - 1.5*IQR) & (df[col] <= Q3 + 1.5*IQR)]
    
    # 9. Export
    df.to_csv(output_path, index=False)
    
    report["final_shape"] = df.shape
    report["output_path"] = output_path
    return report
```

---

## Output Format

```
## Data Quality Report

**File:** [path]
**Shape:** [rows] x [columns]
**Issues Found:**
- Missing values: [summary]
- Wrong types: [columns]
- Duplicates: [count]
- Encoding issues: [if any]
- Outliers detected: [count per column]

## Cleaning Actions Applied

1. [What was done and why]
2. [...]

## Before / After Summary

| Metric | Before | After |
|--------|--------|-------|
| Rows   | X      | Y     |
| Columns| X      | Y     |
| Missing cells | N  | 0    |
| Duplicates    | M  | 0    |
| Memory usage  | X MB | Y MB |

**Output saved to:** [path]
```

## Tools & Libraries

- **pandas** — primary data manipulation
- **numpy** — numeric operations
- **re** — regex-based string cleaning
- **python-dateutil** — flexible date parsing
- **rapidfuzz** — near-duplicate detection (faster than fuzzywuzzy)
- **scikit-learn** — encoding, scaling, KNN/MICE imputation
- **pandera** — data validation with schemas
- **great_expectations** — production data validation
- **unidecode** — Unicode to ASCII transliteration

## Common Pitfalls to Avoid

- **Don't silently drop data.** Always report what was removed and why.
- **Don't impute without justification.** Explain why mean/median/mode/KNN is appropriate.
- **Don't assume the user wants ML-ready data.** Only encode/scale if they mention modeling.
- **Don't modify the original file.** Save cleaned data to a new file.
- **Don't forget to check encoding.** Non-ASCII characters cause mysterious bugs.
- **Don't over-clean.** Removing too much data or imputing too aggressively introduces bias.
- **Don't skip the before/after comparison.** The user needs to see what changed.
- **Don't ignore the missingness pattern.** MCAR, MAR, and MNAR require different strategies.
