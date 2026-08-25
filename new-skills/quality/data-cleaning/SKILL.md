---
name: data-cleaning
description: >-
  Data cleaning, preprocessing, and quality assurance. Handles missing value analysis (MCAR/MAR/MNAR),
  imputation strategies, outlier detection (IQR, Z-score, Isolation Forest), deduplication with blocking,
  schema validation, type inference, encoding normalization (UTF-8 BOM), Persian/Arabic text normalization
  (ZWNJ, Arabic/Persian Ye/Kaf), multi-source merge conflict resolution, Winsorization, scientific notation
  in CSVs, Excel truncation handling, mixed-type columns. پاکسازی داده‌ها، پیش‌پردازش، تحلیل مقادیر گمشده،
  حذف داده‌های تکراری، اعتبارسنجی طرحواره، نرمال‌سازی کدگذاری. 数据清洗，预处理，缺失值分析，
  异常值检测，去重，编码标准化，波斯语/阿拉伯语文本规范化
---

# Data Cleaning & Preprocessing

## Overview

Data cleaning is the process of detecting and correcting (or removing) corrupt, inaccurate, incomplete, or irrelevant records from a dataset. It is widely recognized as the most time-consuming phase of data work—typically consuming 60–80% of a data project's effort. This skill provides a systematic, reproducible approach to data cleaning that transforms raw, messy data into analysis-ready datasets.

The skill covers the full spectrum of cleaning challenges: from structural issues (schema mismatches, encoding problems, type inconsistencies) to statistical concerns (missing data mechanisms, outlier treatment, deduplication). It is designed for data engineers, analysts, and scientists who need production-quality pipelines, not one-off scripts.

**Core Philosophy:** Clean data is not about perfection—it is about fitness for purpose. Every cleaning decision should be documented, reversible, and aligned with the downstream use case.

**Key Metrics:**
- **Completeness:** % of non-null values per column
- **Consistency:** % of values conforming to expected patterns
- **Uniqueness:** Ratio of distinct to total records
- **Accuracy:** % of values matching a known ground truth
- **Timeliness:** How current the data is relative to requirements

## When to Use This Skill

- Ingesting data from multiple sources with different schemas, encodings, or conventions
- Preparing data for machine learning pipelines where missing values and outliers degrade model performance
- Building ETL/ELT pipelines that must handle evolving source schemas gracefully
- Normalizing Persian (Farsi), Arabic, or mixed-script text fields for consistent search and comparison
- Deduplicating records across systems that lack unique identifiers
- Validating data contracts before loading into a data warehouse or lake
- Debugging mysterious data quality issues (silent type coercion, scientific notation in CSVs, Excel truncation)
- Preparing datasets for statistical analysis where missing data mechanisms (MCAR/MAR/MNAR) affect method selection
- Merging datasets from sources with conflicting records, overlapping keys, or different granularity

## When NOT to Use This Skill

- When data is already clean and validated—do not over-clean or introduce unnecessary transformations
- When working with real-time streaming data that requires in-line validation rather than batch cleaning
- When the task is purely about data exploration or visualization without transformation needs
- When the source system can be fixed at the origin (fix upstream, not downstream)
- When dealing with unstructured data (free text, images, audio) that requires NLP or computer vision pipelines
- When regulatory requirements prohibit data modification (e.g., audit trails that must preserve originals)

## Workflow

### Phase 1: Discovery & Profiling

Before writing any cleaning code, understand what you have.

```python
import pandas as pd
import numpy as np

def profile_dataframe(df: pd.DataFrame) -> dict:
    """Generate a comprehensive data profile."""
    profile = {
        "shape": df.shape,
        "dtypes": df.dtypes.to_dict(),
        "memory_usage_mb": df.memory_usage(deep=True).sum() / 1e6,
        "missing_by_column": df.isnull().sum().to_dict(),
        "missing_pct_by_column": (df.isnull().sum() / len(df) * 100).to_dict(),
        "total_missing_pct": df.isnull().sum().sum() / df.size * 100,
        "duplicated_rows": df.duplicated().sum(),
        "unique_by_column": df.nunique().to_dict(),
    }
    # Numeric summary
    numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
    if numeric_cols:
        profile["numeric_summary"] = df[numeric_cols].describe().to_dict()
    # Categorical summary
    cat_cols = df.select_dtypes(include=["object", "category"]).columns.tolist()
    if cat_cols:
        profile["categorical_summary"] = {
            col: {
                "unique_count": df[col].nunique(),
                "top_values": df[col].value_counts().head(5).to_dict(),
                "max_length": df[col].astype(str).str.len().max() if df[col].notna().any() else 0,
            }
            for col in cat_cols
        }
    return profile

# Usage
profile = profile_dataframe(raw_df)
print(f"Shape: {profile['shape']}")
print(f"Missing: {profile['total_missing_pct']:.1f}%")
print(f"Duplicates: {profile['duplicated_rows']}")
```

### Phase 2: Missing Value Analysis

Classify missing data mechanisms before choosing imputation:

```python
import scipy.stats as stats

def classify_missing_mechanism(df: pd.DataFrame, target_col: str) -> dict:
    """Classify missing data mechanism using Little's MCAR test approximation."""
    missing_mask = df[target_col].isnull()
    result = {"mechanism": "unknown", "tests": {}}

    # Test MCAR: Are missing values independent of all other columns?
    for col in df.columns:
        if col == target_col:
            continue
        if df[col].dtype in ["float64", "int64"]:
            groups = [df.loc[~missing_mask, col].dropna(),
                      df.loc[missing_mask, col].dropna()]
            if len(groups[0]) > 1 and len(groups[1]) > 1:
                stat, pval = stats.mannwhitneyu(groups[0], groups[1], alternative="two-sided")
                result["tests"][col] = {"test": "mannwhitneyu", "p_value": pval}
        else:
            contingency = pd.crosstab(missing_mask, df[col].dropna())
            if contingency.shape[0] > 1 and contingency.shape[1] > 1:
                stat, pval, _, _ = stats.chi2_contingency(contingency)
                result["tests"][col] = {"test": "chi2", "p_value": pval}

    # Heuristic classification
    significant = [c for c, t in result["tests"].items() if t["p_value"] < 0.05]
    if len(significant) == 0:
        result["mechanism"] = "MCAR"  # Missing Completely At Random
    elif target_col in significant or any(c in significant for c in df.columns):
        result["mechanism"] = "MAR"  # Missing At Random
    else:
        result["mechanism"] = "MNAR"  # Missing Not At Random
    return result

# MCAR: Listwise deletion or simple imputation is acceptable
# MAR: Multiple imputation, MICE, or model-based imputation recommended
# MNAR: Requires domain-specific modeling; selection models or pattern-mixture models
```

### Phase 3: Missing Value Imputation

```python
from sklearn.impute import KNNImputer, IterativeImputer
from sklearn.experimental import enable_iterative_imputer  # noqa

def impute_missing_values(df: pd.DataFrame, strategy: dict) -> pd.DataFrame:
    """
    Apply imputation strategies per column.

    strategy: dict mapping column names to imputation methods
      - "mean": for numeric, roughly normal distributions
      - "median": for numeric, skewed distributions
      - "mode": for categorical
      - "knn": KNN imputer (numeric only)
      - "mice": Multiple Imputation by Chained Equations (numeric only)
      - "constant": fill with a specific value (use "fill_value" key)
      - "forward_fill" / "backward_fill": for time series
      - "interpolate": linear interpolation for ordered data
    """
    df = df.copy()
    for col, method in strategy.items():
        if col not in df.columns:
            continue
        missing_count = df[col].isnull().sum()
        if missing_count == 0:
            continue
        if method == "mean":
            df[col].fillna(df[col].mean(), inplace=True)
        elif method == "median":
            df[col].fillna(df[col].median(), inplace=True)
        elif method == "mode":
            df[col].fillna(df[col].mode()[0], inplace=True)
        elif method == "knn":
            imputer = KNNImputer(n_neighbors=5)
            df[[col]] = imputer.fit_transform(df[[col]])
        elif method == "mice":
            imputer = IterativeImputer(max_iter=10, random_state=42)
            df[[col]] = imputer.fit_transform(df[[col]])
        elif method == "constant":
            fill_value = strategy.get("fill_value", 0)
            df[col].fillna(fill_value, inplace=True)
        elif method == "forward_fill":
            df[col].fillna(method="ffill", inplace=True)
        elif method == "backward_fill":
            df[col].fillna(method="bfill", inplace=True)
        elif method == "interpolate":
            df[col].interpolate(method="linear", inplace=True)
        print(f"  Imputed '{col}': {missing_count} nulls using {method}")
    return df

# Strategy selection guide:
# <5% missing, MCAR: Mean/Median/Mode is fine
# 5-25% missing, MAR: Use MICE or KNN
# >25% missing: Consider dropping column or creating indicator flag
# Time series: Always prefer forward_fill or interpolate
# MNAR: Document the limitation; do not impute blindly
```

### Phase 4: Outlier Detection & Treatment

```python
def detect_outliers_iqr(series: pd.Series, factor: float = 1.5) -> pd.Series:
    """Detect outliers using IQR method. Returns boolean mask."""
    q1 = series.quantile(0.25)
    q3 = series.quantile(0.75)
    iqr = q3 - q1
    lower = q1 - factor * iqr
    upper = q3 + factor * iqr
    return (series < lower) | (series > upper)

def detect_outliers_zscore(series: pd.Series, threshold: float = 3.0) -> pd.Series:
    """Detect outliers using Z-score method."""
    mean = series.mean()
    std = series.std()
    if std == 0:
        return pd.Series(False, index=series.index)
    z_scores = (series - mean).abs() / std
    return z_scores > threshold

def winsorize(series: pd.Series, lower_pct: float = 0.01, upper_pct: float = 0.99) -> pd.Series:
    """Winsorize: cap values at percentile boundaries instead of removing."""
    lower = series.quantile(lower_pct)
    upper = series.quantile(upper_pct)
    return series.clip(lower=lower, upper=upper)

def treat_outliers(df: pd.DataFrame, columns: list, method: str = "winsorize") -> pd.DataFrame:
    """
    Treat outliers in specified columns.
    method: "winsorize" | "clip_iqr" | "remove" | "flag"
    """
    df = df.copy()
    for col in columns:
        if df[col].dtype not in ["float64", "int64"]:
            continue
        outlier_mask = detect_outliers_iqr(df[col])
        n_outliers = outlier_mask.sum()
        print(f"  {col}: {n_outliers} outliers detected ({n_outliers/len(df)*100:.1f}%)")

        if method == "winsorize":
            df[col] = winsorize(df[col])
        elif method == "clip_iqr":
            q1, q3 = df[col].quantile(0.25), df[col].quantile(0.75)
            iqr = q3 - q1
            df[col] = df[col].clip(lower=q1 - 1.5 * iqr, upper=q3 + 1.5 * iqr)
        elif method == "remove":
            df = df[~outlier_mask]
        elif method == "flag":
            df[f"{col}_is_outlier"] = outlier_mask.astype(int)
    return df
```

### Phase 5: Deduplication with Blocking

```python
from collections import defaultdict
import hashlib

def compute_blocking_key(record: dict, blocking_cols: list) -> str:
    """Compute a blocking key for near-duplicate detection."""
    parts = [str(record.get(col, "")).lower().strip() for col in blocking_cols]
    return "|".join(parts)

def deduplicate_with_blocking(df: pd.DataFrame, blocking_cols: list,
                               comparison_cols: list, similarity_threshold: float = 0.85) -> pd.DataFrame:
    """
    Deduplicate using blocking to reduce comparison space.

    blocking_cols: columns used to create blocks (e.g., ["last_name_first_letter", "zip_code"])
    comparison_cols: columns to compare within blocks
    similarity_threshold: Jaccard similarity threshold for match (0-1)
    """
    blocks = defaultdict(list)

    # Build blocks
    for idx, row in df.iterrows():
        key = compute_blocking_key(row.to_dict(), blocking_cols)
        blocks[key].append(idx)

    # Find duplicates within blocks
    duplicates_to_drop = set()
    for block_key, indices in blocks.items():
        if len(indices) < 2:
            continue
        for i in range(len(indices)):
            for j in range(i + 1, len(indices)):
                idx_a, idx_b = indices[i], indices[j]
                if idx_a in duplicates_to_drop or idx_b in duplicates_to_drop:
                    continue
                # Simple Jaccard similarity on comparison columns
                set_a = set()
                set_b = set()
                for col in comparison_cols:
                    val_a = str(df.loc[idx_a, col]).lower().strip() if pd.notna(df.loc[idx_a, col]) else ""
                    val_b = str(df.loc[idx_b, col]).lower().strip() if pd.notna(df.loc[idx_b, col]) else ""
                    set_a.update(val_a.split())
                    set_b.update(val_b.split())
                if len(set_a) == 0 and len(set_b) == 0:
                    continue
                jaccard = len(set_a & set_b) / len(set_a | set_b)
                if jaccard >= similarity_threshold:
                    # Keep the record with fewer missing values
                    missing_a = df.loc[idx_a].isnull().sum()
                    missing_b = df.loc[idx_b].isnull().sum()
                    dup = idx_a if missing_a >= missing_b else idx_b
                    duplicates_to_drop.add(dup)

    print(f"  Removed {len(duplicates_to_drop)} duplicates from {len(df)} records")
    return df.drop(index=list(duplicates_to_drop)).reset_index(drop=True)
```

### Phase 6: Schema Validation & Type Inference

```python
import re

def validate_and_infer_types(df: pd.DataFrame, schema: dict) -> tuple[pd.DataFrame, list]:
    """
    Validate columns against expected schema and infer/convert types.

    schema format:
    {
        "column_name": {
            "dtype": "int64" | "float64" | "string" | "datetime" | "category",
            "nullable": True/False,
            "pattern": "regex for validation",  # optional
            "min": value,  # optional, for numeric
            "max": value,  # optional, for numeric
            "allowed_values": [list],  # optional
        }
    }
    """
    df = df.copy()
    issues = []
    for col, spec in schema.items():
        if col not in df.columns:
            issues.append(f"MISSING COLUMN: '{col}' not found in dataframe")
            continue
        # Check nullability
        if not spec.get("nullable", True) and df[col].isnull().any():
            null_count = df[col].isnull().sum()
            issues.append(f"NULLABILITY VIOLATION: '{col}' has {null_count} nulls but nullable=False")
        # Type conversion
        dtype = spec.get("dtype")
        if dtype == "datetime":
            df[col] = pd.to_datetime(df[col], errors="coerce")
        elif dtype in ["int64", "int32"]:
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")
        elif dtype in ["float64", "float32"]:
            df[col] = pd.to_numeric(df[col], errors="coerce")
        elif dtype == "string":
            df[col] = df[col].astype(str).str.strip()
        elif dtype == "category":
            df[col] = df[col].astype("category")
        # Pattern validation
        if "pattern" in spec:
            pattern = re.compile(spec["pattern"])
            non_null = df[col].dropna()
            invalid = non_null[~non_null.astype(str).str.match(pattern)]
            if len(invalid) > 0:
                issues.append(f"PATTERN VIOLATION: '{col}' has {len(invalid)} values not matching {spec['pattern']}")
        # Range validation
        if "min" in spec:
            violations = df[col].dropna()[df[col].dropna() < spec["min"]]
            if len(violations) > 0:
                issues.append(f"RANGE VIOLATION: '{col}' has {len(violations)} values below min={spec['min']}")
        if "max" in spec:
            violations = df[col].dropna()[df[col].dropna() > spec["max"]]
            if len(violations) > 0:
                issues.append(f"RANGE VIOLATION: '{col}' has {len(violations)} values above max={spec['max']}")
        # Allowed values
        if "allowed_values" in spec:
            invalid = df[col].dropna()[~df[col].dropna().isin(spec["allowed_values"])]
            if len(invalid) > 0:
                issues.append(f"VALUE VIOLATION: '{col}' has {len(invalid)} values not in allowed set")
    for issue in issues:
        print(f"  ⚠ {issue}")
    return df, issues
```

### Phase 7: Encoding Normalization & Persian/Arabic Text Processing

```python
import unicodedata

def normalize_encoding(text: str) -> str:
    """Normalize encoding: strip BOM, normalize Unicode, handle Persian/Arabic text."""
    if not isinstance(text, str):
        return text
    # Strip BOM
    text = text.lstrip("\ufeff")
    # Unicode normalization (NFKC handles compatibility characters)
    text = unicodedata.normalize("NFKC", text)
    return text

def normalize_persian_arabic(text: str) -> str:
    """
    Normalize Persian (Farsi) and Arabic text for consistent storage and comparison.

    Handles:
    - Arabic Ye (ي → ی) to Persian Ye
    - Arabic Kaf (ك → ک) to Persian Kaf
    - ZWNJ (Zero-Width Non-Joiner) normalization for Persian compound words
    - Arabic Teh Marbuta (ة → ه) to Heh
    - Normalizing different forms of Hamzeh
    - Stripping extra whitespace and normalizing dashes
    """
    if not isinstance(text, str):
        return text
    # Arabic Ye → Persian Ye
    text = text.replace("\u064a", "\u06cc")  # ي → ی
    text = text.replace("\u0649", "\u06cc")  # ى → ی (Alef Maqsura)
    # Arabic Kaf → Persian Kaf
    text = text.replace("\u0643", "\u06a9")  # ك → ک
    # Arabic Teh Marbuta → Heh
    text = text.replace("\u0629", "\u0647")  # ة → ه
    # Normalize Hamzeh forms to ساده (-seat)
    text = text.replace("\u0623", "\u0627")  # أ → ا (Alef with Hamza above)
    text = text.replace("\u0625", "\u0627")  # إ → ا (Alef with Hamza below)
    text = text.replace("\u0621", "\u0627")  # ء → ا (Lone Hamzeh, simplified)
    # Normalize ZWNJ: ensure consistent usage (strip and re-add only where needed)
    text = text.replace("\u200c", "\u200c")  # Normalize ZWNJ character
    # Strip multiple ZWNJs
    while "\u200c\u200c" in text:
        text = text.replace("\u200c\u200c", "\u200c")
    # Normalize whitespace
    text = re.sub(r"\s+", " ", text).strip()
    # Normalize different dash types to standard dash
    text = text.replace("\u2013", "-").replace("\u2014", "-")
    return text

def normalize_column_text(df: pd.DataFrame, text_columns: list) -> pd.DataFrame:
    """Apply encoding and text normalization to specified columns."""
    df = df.copy()
    for col in text_columns:
        if col not in df.columns:
            continue
        df[col] = df[col].apply(normalize_encoding)
        df[col] = df[col].apply(normalize_persian_arabic)
    return df

# ZWNJ Reference for Persian Compound Words:
# ❌ نمیشود (wrong)  ✅ نمی‌شود (correct, ZWNJ after نمی)
# ❌ پردازش (wrong)   ✅ پردازش (correct, ZWNJ after پردا)
# Common ZWNJ patterns: نمی|می|باز|در|بر|نا|فرا| prefix+ZWNJ+stem
```

### Phase 8: Multi-Source Merge with Conflict Resolution

```python
def merge_multi_source(sources: list, key_cols: list,
                       strategy: str = "most_complete") -> pd.DataFrame:
    """
    Merge multiple data sources with conflict resolution.

    strategy:
    - "most_complete": Prefer the source with the fewest nulls per row
    - "most_recent": Prefer the source with the latest timestamp (requires 'source_timestamp' column)
    - "priority": Prefer sources in list order (first source has highest priority)
    - "voting": Use majority vote for each cell (requires ≥3 sources)
    """
    # Standardize column names and add source identifier
    merged = pd.DataFrame()
    for i, src in enumerate(sources):
        src = src.copy()
        src["_source_priority"] = i
        src["_source_id"] = f"source_{i}"
        merged = pd.concat([merged, src], ignore_index=True)

    # Group by key columns
    grouped = merged.groupby(key_cols, sort=False)
    result_rows = []

    for group_key, group in grouped:
        if strategy == "most_complete":
            # Rank by fewest nulls
            null_counts = group.isnull().sum(axis=1)
            best_idx = null_counts.idxmin()
            result_rows.append(group.loc[best_idx])
        elif strategy == "priority":
            # Lowest priority number wins
            result_rows.append(group.loc[group["_source_priority"].idxmin()])
        elif strategy == "most_recent" and "source_timestamp" in group.columns:
            result_rows.append(group.loc[group["source_timestamp"].idxmax()])
        elif strategy == "voting":
            # For each column, take the mode
            row = {}
            for col in group.columns:
                if col.startswith("_source"):
                    continue
                non_null = group[col].dropna()
                if len(non_null) == 0:
                    row[col] = np.nan
                else:
                    row[col] = non_null.mode().iloc[0] if len(non_null.mode()) > 0 else non_null.iloc[0]
            result_rows.append(pd.Series(row))

    result = pd.DataFrame(result_rows)
    print(f"  Merged {len(sources)} sources: {sum(len(s) for s in sources)} → {len(result)} records")
    return result
```

### Phase 9: Handling Edge Cases in CSVs and Excel

```python
def handle_csv_edge_cases(filepath: str) -> pd.DataFrame:
    """Handle common CSV edge cases: scientific notation, mixed types, encoding issues."""
    # Try multiple encodings
    encodings = ["utf-8", "utf-8-sig", "latin-1", "cp1252", "iso-8859-1"]
    df = None
    for enc in encodings:
        try:
            df = pd.read_csv(filepath, encoding=enc, low_memory=False)
            print(f"  Read with encoding: {enc}")
            break
        except (UnicodeDecodeError, UnicodeError):
            continue
    if df is None:
        raise ValueError(f"Could not read {filepath} with any supported encoding")

    # Handle scientific notation in columns (e.g., "1.23E+04" for IDs)
    for col in df.columns:
        if df[col].dtype == "object":
            sample = df[col].dropna().head(100).astype(str)
            sci_pattern = r"^-?\d+\.?\d*[eE][+-]?\d+$"
            if sample.str.match(sci_pattern).any():
                try:
                    df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")
                    print(f"  Converted '{col}' from scientific notation to integer")
                except (ValueError, TypeError):
                    pass

    # Handle mixed-type columns
    for col in df.columns:
        if df[col].dtype == "object":
            non_null = df[col].dropna()
            if len(non_null) == 0:
                continue
            numeric = pd.to_numeric(non_null, errors="coerce")
            if numeric.notna().sum() / len(non_null) > 0.9:
                print(f"  WARNING: '{col}' is mixed-type ({numeric.notna().sum()}/{len(non_null)} numeric)")
    return df

def handle_excel_truncation(df: pd.DataFrame, max_str_length: int = 32767) -> pd.DataFrame:
    """Handle Excel string truncation: flag and fix values that may have been truncated."""
    df = df.copy()
    for col in df.select_dtypes(include=["object"]).columns:
        long_mask = df[col].astype(str).str.len() > max_str_length
        if long_mask.any():
            print(f"  WARNING: '{col}' has {long_mask.sum()} strings exceeding Excel limit")
            df.loc[long_mask, col] = df.loc[long_mask, col].astype(str).str[:max_str_length]
    return df
```

### Phase 10: Validation & Documentation

```python
def generate_cleaning_report(original: pd.DataFrame, cleaned: pd.DataFrame, operations: list) -> str:
    """Generate a human-readable cleaning report."""
    report_lines = [
        "# Data Cleaning Report",
        f"**Original shape:** {original.shape[0]} rows × {original.shape[1]} columns",
        f"**Cleaned shape:** {cleaned.shape[0]} rows × {cleaned.shape[1]} columns",
        f"**Records removed:** {original.shape[0] - cleaned.shape[0]}",
        "",
        "## Operations Performed",
    ]
    for i, op in enumerate(operations, 1):
        report_lines.append(f"{i}. {op}")

    report_lines.extend([
        "",
        "## Missing Values Comparison",
        "| Column | Before | After |",
        "|--------|--------|-------|",
    ])
    for col in original.columns:
        before = original[col].isnull().sum()
        after = cleaned[col].isnull().sum() if col in cleaned.columns else "N/A"
        if before > 0 or after != "N/A":
            report_lines.append(f"| {col} | {before} ({before/len(original)*100:.1f}%) | {after} |")

    report_lines.extend([
        "",
        "## Data Quality Metrics",
        f"- Completeness: {(1 - cleaned.isnull().sum().sum() / cleaned.size) * 100:.1f}%",
        f"- Uniqueness: {(1 - cleaned.duplicated().sum() / len(cleaned)) * 100:.1f}%",
    ])
    return "\n".join(report_lines)
```

## Advanced Techniques

### Technique 1: Automated Type Inference Engine

Go beyond pandas defaults to detect logical types:

```python
def infer_logical_type(series: pd.Series) -> str:
    """Infer the logical type of a series beyond basic dtype."""
    non_null = series.dropna()
    if len(non_null) == 0:
        return "unknown"
    sample = non_null.head(1000).astype(str)

    # Check for boolean
    if set(non_null.unique()).issubset({True, False, "True", "False", "0", "1", "yes", "no"}):
        return "boolean"

    # Check for datetime
    try:
        pd.to_datetime(non_null, infer_datetime_format=True)
        return "datetime"
    except (ValueError, TypeError):
        pass

    # Check for numeric
    numeric = pd.to_numeric(non_null, errors="coerce")
    if numeric.notna().sum() / len(non_null) > 0.95:
        if (numeric.dropna() == numeric.dropna().astype(int)).all():
            if non_null.nunique() / len(non_null) > 0.9:
                return "identifier"
            return "integer"
        return "float"

    # Check for categorical (low cardinality)
    if non_null.nunique() / len(non_null) < 0.05:
        return "categorical"

    # Check for email, URL, phone
    email_pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    if sample.str.match(email_pattern).mean() > 0.8:
        return "email"
    url_pattern = r"^https?://"
    if sample.str.match(url_pattern).mean() > 0.8:
        return "url"

    return "text"
```

### Technique 2: Cross-Field Validation

Detect logical inconsistencies across related columns:

```python
def validate_cross_field(df: pd.DataFrame) -> list:
    """Validate logical consistency across related fields."""
    issues = []
    # Date range: start_date should be before end_date
    if "start_date" in df.columns and "end_date" in df.columns:
        mask = df["start_date"] > df["end_date"]
        issues.append(f"start_date > end_date: {mask.sum()} records")

    # Age consistency with birth_date
    if "birth_date" in df.columns and "age" in df.columns:
        expected_age = (pd.Timestamp.now() - pd.to_datetime(df["birth_date"])).dt.days / 365.25
        mismatch = (df["age"] - expected_age).abs() > 1
        issues.append(f"Age/birth_date mismatch: {mismatch.sum()} records")

    # Email domain matches company domain
    if "email" in df.columns and "company_domain" in df.columns:
        email_domain = df["email"].str.split("@").str[1]
        mismatch = email_domain != df["company_domain"]
        issues.append(f"Email domain mismatch: {mismatch.sum()} records")

    # Numeric sanity checks
    if "quantity" in df.columns and (df["quantity"] < 0).any():
        issues.append(f"Negative quantity: {(df['quantity'] < 0).sum()} records")
    if "percentage" in df.columns:
        out_of_range = (df["percentage"] < 0) | (df["percentage"] > 100)
        issues.append(f"Percentage out of [0,100]: {out_of_range.sum()} records")

    for issue in issues:
        print(f"  ⚠ {issue}")
    return issues
```

### Technique 3: Incremental Cleaning Pipeline

Build pipelines that can be run repeatedly on new data:

```python
class DataCleaningPipeline:
    """Reusable, serializable cleaning pipeline."""

    def __init__(self, name: str):
        self.name = name
        self.steps = []
        self.fitted_params = {}

    def add_step(self, name: str, func, **kwargs):
        self.steps.append({"name": name, "func": func, "kwargs": kwargs})
        return self

    def fit(self, df: pd.DataFrame):
        """Fit parameters on training data (e.g., imputation values, thresholds)."""
        for step in self.steps:
            if step["name"] in ["impute", "outlier_detection"]:
                self.fitted_params[step["name"]] = {
                    "imputation_values": df.median().to_dict(),
                    "iqr_bounds": {
                        col: (df[col].quantile(0.25), df[col].quantile(0.75))
                        for col in df.select_dtypes(include=[np.number]).columns
                    },
                }
        return self

    def transform(self, df: pd.DataFrame) -> pd.DataFrame:
        """Apply all steps sequentially."""
        for step in self.steps:
            print(f"Running step: {step['name']}")
            df = step["func"](df, **step["kwargs"])
        return df

    def fit_transform(self, df: pd.DataFrame) -> pd.DataFrame:
        return self.fit(df).transform(df)

# Usage
pipeline = DataCleaningPipeline("customer_data_v1")
pipeline.add_step("normalize_text", normalize_column_text, text_columns=["name", "address"])
pipeline.add_step("impute", impute_missing_values, strategy={"age": "median", "city": "mode"})
pipeline.add_step("outliers", treat_outliers, columns=["age", "income"], method="winsorize")
pipeline.add_step("dedup", deduplicate_with_blocking, blocking_cols=["email"], comparison_cols=["name", "phone"])

cleaned_df = pipeline.fit_transform(raw_df)
```

### Technique 4: Anomaly Detection with Isolation Forest

```python
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

def detect_anomalies_isolation_forest(df: pd.DataFrame, numeric_cols: list,
                                       contamination: float = 0.05) -> pd.DataFrame:
    """Detect multivariate anomalies using Isolation Forest."""
    df = df.copy()
    feature_df = df[numeric_cols].dropna()
    if len(feature_df) == 0:
        df["anomaly_score"] = 0
        return df

    scaler = StandardScaler()
    features_scaled = scaler.fit_transform(feature_df)

    iso_forest = IsolationForest(contamination=contamination, random_state=42, n_jobs=-1)
    predictions = iso_forest.fit_predict(features_scaled)
    scores = iso_forest.decision_function(features_scaled)

    df.loc[feature_df.index, "anomaly_score"] = scores
    df.loc[feature_df.index, "is_anomaly"] = predictions == -1
    n_anomalies = (predictions == -1).sum()
    print(f"  Detected {n_anomalies} anomalies out of {len(feature_df)} records ({n_anomalies/len(feature_df)*100:.1f}%)")
    return df
```

### Technique 5: Data Drift Detection

Compare data distributions between training and production:

```python
from scipy.stats import ks_2samp, chi2_contingency

def detect_data_drift(reference_df: pd.DataFrame, current_df: pd.DataFrame,
                      significance: float = 0.05) -> dict:
    """Detect distribution drift between reference and current datasets."""
    drift_report = {"numeric": {}, "categorical": {}}

    # Numeric columns: Kolmogorov-Smirnov test
    for col in reference_df.select_dtypes(include=[np.number]).columns:
        if col not in current_df.columns:
            continue
        ref_data = reference_df[col].dropna()
        cur_data = current_df[col].dropna()
        stat, p_value = ks_2samp(ref_data, cur_data)
        drift_report["numeric"][col] = {
            "ks_statistic": stat,
            "p_value": p_value,
            "drifted": p_value < significance,
            "ref_mean": ref_data.mean(),
            "cur_mean": cur_data.mean(),
        }

    # Categorical columns: Chi-squared test
    for col in reference_df.select_dtypes(include=["object", "category"]).columns:
        if col not in current_df.columns:
            continue
        ref_counts = reference_df[col].value_counts()
        cur_counts = current_df[col].value_counts()
        all_categories = set(ref_counts.index) | set(cur_counts.index)
        ref_aligned = [ref_counts.get(cat, 0) for cat in all_categories]
        cur_aligned = [cur_counts.get(cat, 0) for cat in all_categories]
        if sum(ref_aligned) > 0 and sum(cur_aligned) > 0:
            stat, p_value, _, _ = chi2_contingency([ref_aligned, cur_aligned])
            drift_report["categorical"][col] = {
                "chi2_statistic": stat,
                "p_value": p_value,
                "drifted": p_value < significance,
            }

    drifted_cols = [c for c, v in drift_report["numeric"].items() if v["drifted"]]
    drifted_cols += [c for c, v in drift_report["categorical"].items() if v["drifted"]]
    print(f"  Drift detected in {len(drifted_cols)} columns: {drifted_cols}")
    return drift_report
```

### Technique 6: Parallel Cleaning for Large Datasets

```python
import multiprocessing as mp

def clean_partition(partition: pd.DataFrame, operations: list) -> pd.DataFrame:
    """Apply cleaning operations to a single partition."""
    for op_name, op_func, op_kwargs in operations:
        partition = op_func(partition, **op_kwargs)
    return partition

def parallel_clean(df: pd.DataFrame, operations: list, n_workers: int = None) -> pd.DataFrame:
    """Clean large datasets in parallel using partitioning."""
    if n_workers is None:
        n_workers = mp.cpu_count()

    partition_size = max(1, len(df) // n_workers)
    partitions = [df.iloc[i:i + partition_size].copy()
                  for i in range(0, len(df), partition_size)]

    print(f"  Cleaning {len(df)} rows across {len(partitions)} partitions...")

    with mp.Pool(n_workers) as pool:
        results = pool.starmap(clean_partition,
                               [(p, operations) for p in partitions])

    result = pd.concat(results, ignore_index=True)
    print(f"  Completed: {len(result)} rows")
    return result
```

### Technique 7: Schema Evolution Detection

```python
def detect_schema_evolution(old_schema: dict, new_schema: dict) -> dict:
    """
    Detect changes between two schema versions.

    old_schema/new_schema: {column_name: {"dtype": ..., "nullable": ...}}
    """
    changes = {
        "added_columns": [],
        "removed_columns": [],
        "type_changes": [],
        "nullable_changes": [],
    }

    old_cols = set(old_schema.keys())
    new_cols = set(new_schema.keys())

    changes["added_columns"] = list(new_cols - old_cols)
    changes["removed_columns"] = list(old_cols - new_cols)

    for col in old_cols & new_cols:
        old_dtype = old_schema[col].get("dtype")
        new_dtype = new_schema[col].get("dtype")
        if old_dtype != new_dtype:
            changes["type_changes"].append({
                "column": col, "from": old_dtype, "to": new_dtype
            })
        old_nullable = old_schema[col].get("nullable")
        new_nullable = new_schema[col].get("nullable")
        if old_nullable != new_nullable:
            changes["nullable_changes"].append({
                "column": col, "from": old_nullable, "to": new_nullable
            })

    if any(changes.values()):
        print("  Schema evolution detected:")
        for change_type, items in changes.items():
            if items:
                print(f"    {change_type}: {items}")
    return changes
```

## Common Patterns

### Pattern 1: The Cleaning Audit Trail

Always maintain a log of what was changed:

```python
class CleaningAuditor:
    """Track every transformation applied to a dataframe."""

    def __init__(self):
        self.log = []
        self.original_shape = None

    def record(self, operation: str, details: dict):
        self.log.append({
            "operation": operation,
            "details": details,
            "timestamp": pd.Timestamp.now().isoformat(),
        })

    def start(self, df: pd.DataFrame):
        self.original_shape = df.shape
        self.record("start", {"shape": df.shape, "missing_pct": df.isnull().sum().sum() / df.size * 100})

    def summary(self) -> str:
        lines = ["Cleaning Audit Trail", "=" * 40]
        for entry in self.log:
            lines.append(f"[{entry['timestamp']}] {entry['operation']}: {entry['details']}")
        return "\n".join(lines)
```

### Pattern 2: Null Indicator Flags

Preserve information about missingness before imputation:

```python
def add_null_indicators(df: pd.DataFrame, columns: list) -> pd.DataFrame:
    """Add binary columns indicating which values were originally null."""
    df = df.copy()
    for col in columns:
        if col in df.columns and df[col].isnull().any():
            df[f"{col}_was_null"] = df[col].isnull().astype(int)
    return df
```

### Pattern 3: Chunked Processing for Memory Efficiency

```python
def clean_large_csv(filepath: str, operations: list, chunksize: int = 100000) -> pd.DataFrame:
    """Process large CSV files in chunks to avoid memory issues."""
    chunks = []
    for i, chunk in enumerate(pd.read_csv(filepath, chunksize=chunksize, low_memory=False)):
        for op_name, op_func, op_kwargs in operations:
            chunk = op_func(chunk, **op_kwargs)
        chunks.append(chunk)
        print(f"  Processed chunk {i + 1}: {len(chunk)} rows")
    result = pd.concat(chunks, ignore_index=True)
    print(f"  Total: {len(result)} rows")
    return result
```

### Pattern 4: Column-Specific Cleaning Rules

```python
CLEANING_RULES = {
    "email": {
        "normalize": lambda s: s.str.lower().str.strip(),
        "validate": lambda s: s.str.match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"),
        "fix": lambda s: s.str.replace(r"\s+", "", regex=True),
    },
    "phone": {
        "normalize": lambda s: s.str.replace(r"[^\d+]", "", regex=True),
        "validate": lambda s: s.str.match(r"^\+?\d{7,15}$"),
    },
    "url": {
        "normalize": lambda s: s.str.lower().str.strip(),
        "fix": lambda s: s.str.replace(r"(?<!https?://)", "http://", regex=True)
                         .str.replace(r"\/+$", "", regex=True),
    },
    "name": {
        "normalize": lambda s: s.str.strip().str.title(),
        "fix": lambda s: s.str.replace(r"\s+", " ", regex=True),
    },
}

def apply_column_rules(df: pd.DataFrame) -> pd.DataFrame:
    """Apply predefined cleaning rules per column type."""
    df = df.copy()
    for col, rules in CLEANING_RULES.items():
        if col not in df.columns:
            continue
        if "normalize" in rules:
            df[col] = rules["normalize"](df[col])
        if "fix" in rules:
            df[col] = rules["fix"](df[col])
        if "validate" in rules:
            valid_mask = rules["validate"](df[col])
            n_invalid = (~valid_mask & df[col].notna()).sum()
            if n_invalid > 0:
                print(f"  WARNING: {col} has {n_invalid} invalid values after cleaning")
    return df
```

### Pattern 5: Reversible Cleaning with Backup Columns

```python
def reversible_clean(df: pd.DataFrame, column: str, clean_func) -> pd.DataFrame:
    """Always preserve the original before cleaning."""
    df = df.copy()
    backup_name = f"{column}_original"
    if backup_name not in df.columns:
        df[backup_name] = df[column].copy()
    df[column] = clean_func(df[column])
    return df
```

## Edge Cases & Pitfalls

1. **Silent Type Coercion:** `pd.read_csv` silently converts mixed-type columns to `object` dtype. Always check dtypes after loading and use the `dtype` parameter to force expected types.

2. **Scientific Notation in IDs:** IDs like `1.23E+04` are silently converted to floats, losing leading zeros. Read as string first: `dtype={"id": str}`.

3. **Excel's 32,767 Character Limit:** Long text fields may be silently truncated by Excel. Validate string lengths against expected maximums when importing from Excel.

4. **Date Format Ambiguity:** `01/02/2024` can mean January 2 or February 1 depending on locale. Always specify the `dayfirst` parameter and use ISO 8601 formats in storage.

5. **UTF-8 BOM in CSVs:** Some tools export CSVs with a Byte Order Mark that causes the first column name to be prefixed with `\ufeff`. Use `encoding="utf-8-sig"` to handle this transparently.

6. **NaN vs None vs "" vs "NULL":** These are four different representations of missing data. Standardize to `pd.NA` or `np.nan` early in the pipeline to avoid downstream logic errors.

7. **Pandas `.copy()` Always:** Every cleaning function should work on a copy. Modifications to views cause `SettingWithCopyWarning` and can silently fail, leaving the original data unchanged.

8. **Deduplication Fuzzy Matching at Scale:** String similarity comparisons are O(n²). Use blocking (as shown above) or locality-sensitive hashing (MinHash) for datasets with millions of rows.

9. **Persian/Arabic ZWNJ Forgetting:** Persian compound words require ZWNJ between prefix and stem (e.g., `نمی‌شود`). Stripping all ZWNJs during cleaning destroys word boundaries and breaks search functionality.

10. **Mixed Locale Numeric Formats:** `1,234.56` vs `1.234,56` — European vs US decimal/thousands separators. Use `thousands_sep` and `decimal` parameters in `pd.read_csv` or apply pre-processing.

11. **Column Name Collisions on Merge:** Merging datasets with overlapping non-key column names creates `_x` and `_y` suffixes. Explicitly handle suffixes with the `suffixes` parameter to avoid ambiguity.

12. **Index Reset Forgetting:** After filtering or deduplication, the DataFrame index may have gaps. Always call `.reset_index(drop=True)` before further processing to avoid misalignment.

13. **Categorical Memory Trap:** Converting high-cardinality string columns to `category` dtype saves memory but makes string operations slower. Profile before converting.

14. **Chunked Processing State Loss:** When processing CSVs in chunks, aggregations like "most frequent value" require accumulating state across chunks, not processing each independently.

15. **Over-Imputation Risk:** Imputing >30% of values in a column can create misleading distributions that fool models. Consider dropping the column or creating an explicit missing indicator instead.

## Integration with Other Skills

| Skill | Integration Point | How |
|-------|-------------------|-----|
| `exploratory-data-analysis` | Input dependency | EDA reveals distributions, outliers, and patterns that inform cleaning decisions |
| `machine-learning-pipelines` | Downstream consumer | Clean data feeds feature engineering; cleaning pipeline must be serializable for reproducibility |
| `database-design` | Schema contracts | Cleaning validates data against database schemas before loading |
| `api-development` | Upstream producer | APIs generate clean data; cleaning handles legacy endpoints that don't follow contracts |
| `natural-language-processing` | Specialized cleaning | NLP requires additional text normalization (tokenization, stopword removal) beyond basic cleaning |
| `time-series-analysis` | Specialized cleaning | Time series need sequential imputation, resampling, and timezone normalization |
| `data-visualization` | Downstream consumer | Charts fail silently on bad data; cleaning ensures visualizations are trustworthy |
| `summarization` | Quality gate | Clean data produces accurate summaries; garbage in = garbage out |
| `technical-writing` | Documentation | Cleaning reports and data quality dashboards are documentation artifacts |
| `etl-pipeline-design` | Orchestration | Cleaning steps are ETL stages; pipeline tools manage scheduling, monitoring, retries |

## Output Format Templates

### Standard Template

```markdown
# Data Cleaning Report — [Dataset Name]

## Summary
- **Input:** [X] rows × [Y] columns
- **Output:** [X'] rows × [Y'] columns
- **Records Removed:** [N] ([%]%)
- **Records Modified:** [N]
- **Data Quality Score:** [%]

## Missing Value Treatment
| Column | Before | Method | After |
|--------|--------|--------|-------|
| [col] | [N] ([%]%) | [method] | [N] |

## Outlier Treatment
| Column | Detected | Method | Action |
|--------|----------|--------|--------|
| [col] | [N] | [IQR/Z-score/IF] | [winsorized/removed/flagged] |

## Deduplication
- Blocking keys: [columns]
- Similarity threshold: [value]
- Duplicates removed: [N]

## Schema Validation
- [Status of each validation check]

## Encoding & Text Normalization
- Original encoding: [detected encoding]
- Normalizations applied: [list]
```

### Quick Template

```markdown
# Quick Cleaning Summary
**Dataset:** [name] | **Rows:** [N→N'] | **Issues Fixed:** [N]

## Changes Made
- [Brief list of operations]

## Remaining Concerns
- [Any unresolved issues]
```

### Deep Template

```markdown
# Comprehensive Data Quality Assessment

## 1. Data Profile
[Full profiling output with distributions, statistics, and patterns]

## 2. Quality Dimensions
### 2.1 Completeness
[Detailed per-column and per-row completeness analysis]

### 2.2 Consistency
[Cross-field validation results]

### 2.3 Accuracy
[Comparison with reference data or business rules]

### 2.4 Timeliness
[Freshness analysis and staleness detection]

### 2.5 Uniqueness
[Deduplication analysis with exact and fuzzy match counts]

## 3. Cleaning Pipeline
[Step-by-step documentation of all transformations]

## 4. Statistical Impact Analysis
[Before/after distribution comparisons, KS tests, correlation changes]

## 5. Recommendations
[Priority-ranked list of remaining data quality improvements]
```

### Agent Template

```markdown
# Cleaning Instructions (for automated agents)

## Pipeline Configuration
```json
{
  "schema": { ... },
  "imputation": { ... },
  "outlier_rules": { ... },
  "dedup_config": { ... },
  "text_normalization": { ... }
}
```

## Validation Rules
- [Rule 1]: [description]
- [Rule 2]: [description]

## Quality Gates
- Minimum completeness: [%]
- Maximum duplicate rate: [%]
- Required columns: [list]
```

## Rules

1. **Always profile first.** Never start cleaning without understanding the data's current state. Run the profiler and review the output before writing any transformation code.

2. **Document every decision.** Each cleaning choice (imputation method, outlier threshold, dedup strategy) must be recorded with its rationale. Future you will not remember why you chose median over mean.

3. **Never delete originals.** Always work on copies. Preserve the raw data in a separate location or column. Cleaning should be reversible.

4. **Validate after every step.** After each transformation, check: shape, dtypes, null counts, value ranges. One bad step can silently corrupt the entire dataset.

5. **Classify missing data before imputing.** MCAR allows simple deletion; MAR requires model-based imputation; MNAR needs domain expertise. Blind imputation is worse than no imputation.

6. **Use blocking for deduplication at scale.** String comparison is O(n²). Blocking reduces the comparison space by orders of magnitude and makes deduplication feasible on millions of rows.

7. **Normalize text before comparison.** Persian/Arabic text has multiple Unicode representations for the same visual character. Normalize to a single canonical form before any string matching, deduplication, or search indexing.

8. **Flag, don't just fix.** When you impute a value or winsorize an outlier, add an indicator column. Downstream models should know which values were estimated, not assumed.

9. **Test on a sample, apply to all.** Validate your cleaning pipeline on a small, manually inspected sample before running it on the full dataset. This catches edge cases that automated validation misses.

10. **Handle encoding defensively.** Always try multiple encodings. Assume the worst: BOM characters, mixed encodings within a single file, and mojibake from double-encoding are all common in production data.

11. **Set up schema validation as a gate.** Data that fails schema validation should be quarantined, not silently coerced. Silent coercion creates data quality issues that surface weeks later in dashboards.

12. **Make pipelines idempotent.** Running the same cleaning pipeline twice should produce the same result. This enables retries, backfills, and incremental processing without double-cleaning artifacts.

13. **Monitor for data drift.** Cleaning rules that work today may break tomorrow as source data evolves. Schedule drift detection runs and alert on significant distribution changes.

14. **Separate cleaning from transformation.** Cleaning makes data correct; transformation makes data useful. Keep these as separate pipeline stages with different quality criteria.

15. **Profile before and after.** Always generate before/after metrics. This proves the cleaning improved data quality and provides a baseline for future runs. Without metrics, cleaning is guesswork.
