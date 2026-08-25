---
name: data-cleaning
description: >-
  Clean, preprocess, and validate datasets for analysis and machine learning.
  English: data cleaning, data preprocessing, missing value imputation, outlier detection,
    deduplication, schema validation, type inference, encoding normalization, text normalization,
    Winsorization, data quality, ETL, data wrangling, data munging, data profiling,
    MCAR MAR MNAR, multiple imputation, data validation, anomaly detection.
  فارسی: پاکسازی داده، پیش‌پردازش داده، جایگزینی مقادیر گمشده، تشخیص داده‌های پرت،
    حذف تکراری، اعتبارسنجی طرحواره، نرمال‌سازی رمزگذاری، نرمال‌سازی متن، ادغام چند منبعه.
  中文: 数据清洗，数据预处理，缺失值插补，异常值检测，去重，模式验证，类型推断，
    编码规范化，文本规范化，数据质量，ETL，数据整理，MCAR/MAR/MNAR分析。
priority: P2
dependencies: []
conflicts: []
---

# Data Cleaning and Preprocessing

## Overview

Data cleaning is the process of detecting and correcting (or removing) corrupt, inaccurate, incomplete, or irrelevant records from a dataset. It is the most time-consuming phase of data analysis (typically 60-80% of project time) and the most impactful: garbage in, garbage out (GIGO). A model trained on dirty data will produce unreliable predictions, and an analysis built on flawed data will lead to wrong decisions.

This skill covers the complete data cleaning lifecycle: profiling to understand what's wrong, diagnosing why it's wrong (MCAR/MAR/MNAR), choosing the right remediation strategy, executing the cleaning pipeline, and validating the results. Every technique includes production-grade code, not just conceptual descriptions.

The key insight is that data cleaning is not a one-size-fits-all process — it requires understanding the data generation process, the analytical goals, and the trade-offs between different cleaning strategies.

## When to Use This Skill

- Ingesting data from multiple heterogeneous sources (APIs, databases, files, scraping)
- Preparing data for statistical analysis or machine learning
- Handling datasets with missing values, outliers, duplicates, or inconsistencies
- Merging datasets with different schemas, encodings, or naming conventions
- Validating data quality before critical business decisions
- Building production data pipelines that must handle messy real-world data
- Standardizing text fields (addresses, names, categories) across datasets
- Converting data types, normalizing encodings, or restructuring data formats

## When NOT to Use This Skill

- Data is already clean and validated (proceed directly to analysis)
- Working with synthetic or simulated data that follows known distributions
- Real-time streaming data (use stream processing patterns instead)
- Tasks focused on data visualization design rather than data quality
- When the data quality issues are symptoms of a broken data collection system (fix the source)

---

## Workflow

### Phase 1: Data Profiling

**Objective:** Understand the current state of the data — what's present, what's missing, what's wrong.

```
Raw Data → Schema Inspection → Statistical Profiling → Quality Assessment → Issue Catalog
```

**Step 1.1 — Schema Inspection**
Examine column names, data types, non-null counts, unique values, and memory usage. Identify columns with mixed types, suspicious constant values, or unexpectedly high cardinality.

**Step 1.2 — Statistical Profiling**
For each column: compute distributions, detect impossible values (negative ages, future dates), identify high-cardinality columns that may need special handling, and flag columns where >50% of values are null.

**Step 1.3 — Quality Assessment**
Score the dataset on completeness (non-null ratio), uniqueness (duplicate rate), consistency (format compliance), and accuracy (value range compliance). Create a data quality report.

**Step 1.4 — Issue Catalog**
Document every identified issue with: column name, issue type, severity (critical/warning/info), count of affected rows, and recommended remediation.

### Phase 2: Missing Value Analysis

**Objective:** Understand the pattern and mechanism of missingness to choose the right imputation strategy.

```
Missing Patterns → MCAR/MAR/MNAR Classification → Mechanism Tests → Strategy Selection
```

**Step 2.1 — Quantify Missingness**
Count missing values per column and per row. Compute missingness rates. Visualize patterns with missing data matrices (missingno library).

**Step 2.2 — Classify Missingness Mechanism**

| Mechanism | Description | Example | Imputation Strategy |
|---|---|---|---|
| MCAR | Missing Completely At Random — no systematic pattern | Data entry errors, random sensor failures | Listwise deletion, mean/median imputation |
| MAR | Missing At Random — missingness depends on observed variables | Age missing more for younger users (but age is observed for others) | Multiple imputation, model-based imputation |
| MNAR | Missing Not At Random — missingness depends on unobserved values | High-income earners refuse to report income | Selection models, pattern-mixture models |

**Step 2.3 — Test for MCAR**
Use Little's MCAR test. If MCAR holds, listwise deletion is unbiased (though less powerful). If MAR or MNAR, deletion introduces bias.

**Step 2.4 — Select Imputation Strategy**
Based on mechanism, proportion of missingness, and analytical goals, choose: deletion, simple imputation (mean/median/mode), model-based imputation (KNN, MICE, iterative), or multiple imputation.

### Phase 3: Outlier Detection and Treatment

**Objective:** Identify extreme values that may distort analysis and decide whether to keep, cap, transform, or remove them.

```
Distribution Analysis → Detection Methods → Classification → Treatment Strategy
```

**Step 3.1 — Detection Methods**
Apply multiple detection methods and cross-validate:
- **Statistical:** Z-score (|z| > 3), IQR method (Q1 - 1.5*IQR, Q3 + 1.5*IQR)
- **Model-based:** Isolation Forest, Local Outlier Factor (LOF)
- **Domain-specific:** Impossible values (e.g., negative prices, age > 150)

**Step 3.2 — Classification**
Distinguish between:
- **Errors:** Data entry mistakes, sensor malfunctions (remove or correct)
- **Natural extremes:** Rare but valid observations (keep, but consider Winsorization)
- **Anomalies:** Interesting patterns worth investigating (keep and flag)

**Step 3.3 — Treatment**
Choose: removal (for errors), Winsorization/capping (for natural extremes), transformation (log, Box-Cox for skewed data), or separate analysis (for anomalies).

### Phase 4: Deduplication

**Objective:** Identify and remove duplicate records that would skew analysis.

```
Exact Matching → Fuzzy Matching → Blocking → Merge → Deduplication
```

**Step 4.1 — Exact Duplicates**
Identify rows where all (or key) columns are identical. Decide: keep first, keep last, or keep the most complete row.

**Step 4.2 — Fuzzy Duplicates**
For records that are similar but not identical (e.g., "John Smith" vs "Jon Smith"), use fuzzy matching (Levenshtein distance, Jaro-Winkler, token-based similarity) with blocking to reduce the search space.

**Step 4.3 — Merge and Deduplicate**
For detected duplicates, merge records: keep the most complete version, or combine non-conflicting values.

### Phase 5: Type Inference and Schema Validation

**Objective:** Ensure all columns have correct data types and values conform to expected schemas.

```
Type Detection → Type Conversion → Schema Definition → Validation → Error Handling
```

**Step 5.1 — Type Inference**
Detect actual data types: dates stored as strings, numbers stored as text, categories stored as free text. Use heuristics and parsing attempts to infer correct types.

**Step 5.2 — Schema Validation**
Define expected schemas with: column names, data types, allowed values (enums), value ranges (min/max), format patterns (regex for emails, phones), and uniqueness constraints.

**Step 5.3 — Validation and Error Handling**
Validate data against schema. For violations: log errors, quarantine invalid rows, apply defaults, or raise alerts depending on severity.

### Phase 6: Encoding and Normalization

**Objective:** Standardize text fields, fix encoding issues, and normalize formats across the dataset.

```
Encoding Detection → Character Normalization → Text Standardization → Format Validation
```

**Step 6.1 — Character Encoding**
Detect and fix encoding issues (UTF-8 vs Latin-1 vs Windows-1252). Handle mojibake (garbled text from wrong encoding), normalize Unicode (NFC/NFD), and remove invisible characters.

**Step 6.2 — Text Normalization**
Standardize text fields: lowercase, trim whitespace, remove extra spaces, normalize case (title case for names, lowercase for emails), expand abbreviations, and standardize number formats.

**Step 6.3 — Category Normalization**
For categorical fields: merge similar categories ("NY" = "New York" = "N.Y."), handle typos (fuzzy matching for category correction), and standardize category names.

### Phase 7: Multi-Source Merge

**Objective:** Combine data from multiple sources into a unified, consistent dataset.

```
Source Analysis → Schema Mapping → Conflict Resolution → Merge Strategy → Validation
```

**Step 7.1 — Source Analysis**
Compare schemas across sources: overlapping columns, unique columns, type mismatches, and value range differences.

**Step 7.2 — Schema Mapping**
Map source columns to a unified schema. Handle: different names for same concept, different formats for same data type, different granularities.

**Step 7.3 — Conflict Resolution**
When sources disagree: apply priority rules (most recent wins, most authoritative source wins), flag conflicts for manual review, or combine values with metadata.

**Step 7.4 — Merge Execution**
Choose: inner join (keep only matching records), left join (keep all from primary), or outer join (keep everything). Handle key mismatches, duplicates, and referential integrity.

### Phase 8: Validation and Documentation

**Objective:** Verify that cleaning achieved its goals and document all changes for reproducibility.

```
Post-Cleaning Profile → Quality Comparison → Regression Tests → Documentation
```

**Step 8.1 — Post-Cleaning Profile**
Re-run the data profiling pipeline. Compare before/after metrics: completeness, uniqueness, consistency, accuracy.

**Step 8.2 — Regression Tests**
Verify that cleaning didn't destroy valid data: check that row counts are reasonable, distributions haven't shifted dramatically, and key relationships are preserved.

**Step 8.3 — Documentation**
Record every cleaning operation: what was changed, why, how many rows were affected, and what assumptions were made. Create an audit trail.

---

## Advanced Techniques

### 1. MCAR/MAR/MNAR Diagnosis

Determining the missingness mechanism is critical — it dictates whether deletion is biased and which imputation method is appropriate.

```python
import pandas as pd
import numpy as np
from scipy import stats

def diagnose_missingness_mechanism(df, target_col, alpha=0.05):
    """
    Diagnose whether missingness in target_col is MCAR, MAR, or MNAR.
    
    Uses logistic regression approach: predict missingness from other variables.
    If other variables predict missingness, it's likely MAR.
    """
    results = {}
    
    # Create missingness indicator
    missing_indicator = df[target_col].isnull().astype(int)
    
    # Test 1: Little's MCAR test (simplified)
    # Compare means of other variables between missing and non-missing groups
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    mcar_tests = {}
    
    for col in numeric_cols:
        if col == target_col:
            continue
        group_missing = df.loc[missing_indicator == 1, col].dropna()
        group_present = df.loc[missing_indicator == 0, col].dropna()
        
        if len(group_missing) > 5 and len(group_present) > 5:
            stat, p = stats.mannwhitneyu(group_missing, group_present, alternative='two-sided')
            mcar_tests[col] = {
                'test': 'Mann-Whitney U',
                'statistic': stat,
                'p_value': p,
                'significant_diff': p < alpha,
                'mean_when_missing': group_missing.mean(),
                'mean_when_present': group_present.mean()
            }
    
    # If none of the other variables differ significantly between 
    # missing/non-missing groups, evidence for MCAR
    n_significant = sum(1 for t in mcar_tests.values() if t['significant_diff'])
    
    results['mcar_tests'] = mcar_tests
    results['n_significant_predictors'] = n_significant
    results['total_predictors'] = len(mcar_tests)
    
    # Classification
    if n_significant == 0:
        results['mechanism'] = 'MCAR'
        results['confidence'] = 'moderate'
        results['recommendation'] = 'Listwise deletion is unbiased. Mean/median imputation is acceptable.'
    elif n_significant <= len(mcar_tests) * 0.3:
        results['mechanism'] = 'MAR (weak evidence)'
        results['confidence'] = 'low'
        results['recommendation'] = 'Use multiple imputation (MICE) to be safe.'
    else:
        results['mechanism'] = 'MAR (strong evidence)'
        results['confidence'] = 'high'
        results['recommendation'] = 'Use model-based imputation that conditions on observed predictors.'
    
    # Test for MNAR (requires domain knowledge)
    # Check if missingness correlates with the target's own distribution
    # This is heuristic — true MNAR testing requires sensitivity analysis
    results['mnar_warning'] = (
        "Cannot definitively distinguish MAR from MNAR without domain knowledge. "
        "If there's a reason values are missing that relates to their unobserved "
        "values (e.g., high earners not reporting income), assume MNAR and use "
        "selection models or pattern-mixture models."
    )
    
    return results
```

### 2. MICE (Multiple Imputation by Chained Equations)

MICE is the gold standard for MAR missingness — it iteratively imputes each variable using all other variables as predictors.

```python
import numpy as np
import pandas as pd
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier

def mice_imputation(df, categorical_cols=None, n_imputations=5, random_state=42):
    """
    Perform MICE imputation with automatic type handling.
    
    Parameters:
    - df: DataFrame with missing values
    - categorical_cols: list of categorical column names
    - n_imputations: number of imputed datasets (for uncertainty estimation)
    """
    if categorical_cols is None:
        categorical_cols = df.select_dtypes(include=['object', 'category']).columns.tolist()
    
    # Separate numeric and categorical
    numeric_cols = [c for c in df.columns if c not in categorical_cols]
    
    # Encode categoricals as integers for imputation
    label_encoders = {}
    df_encoded = df.copy()
    for col in categorical_cols:
        df_encoded[col] = df[col].astype('category').cat.codes
        df_encoded[col] = df_encoded[col].replace(-1, np.nan)  # -1 was NaN
        label_encoders[col] = df[col].astype('category').cat.categories
    
    # Run MICE
    imputed_datasets = []
    for i in range(n_imputations):
        imputer = IterativeImputer(
            estimator=RandomForestRegressor(n_estimators=100, random_state=random_state + i),
            max_iter=20,
            random_state=random_state + i,
            sample_posterior=True  # For proper uncertainty
        )
        
        imputed_array = imputer.fit_transform(df_encoded)
        imputed_df = pd.DataFrame(imputed_array, columns=df.columns, index=df.index)
        
        # Decode categoricals
        for col in categorical_cols:
            imputed_df[col] = imputed_df[col].round().astype(int)
            imputed_df[col] = imputed_df[col].map(
                dict(enumerate(label_encoders[col]))
            )
        
        imputed_datasets.append(imputed_df)
    
    # Pool results (Rubin's rules for numeric)
    pooled = {}
    for col in numeric_cols:
        values = np.array([ds[col].values for ds in imputed_datasets])
        pooled_mean = values.mean(axis=0)
        within_var = values.var(axis=0).mean()
        between_var = values.mean(axis=0).var()
        total_var = within_var + (1 + 1/n_imputations) * between_var
        
        pooled[col] = {
            'mean': pooled_mean,
            'variance': total_var,
            'imputed_values': [ds[col].values for ds in imputed_datasets]
        }
    
    return {
        'imputed_datasets': imputed_datasets,
        'pooled_results': pooled,
        'n_imputations': n_imputations
    }
```

### 3. Winsorization and Robust Treatment of Outliers

Winsorization caps extreme values at a specified percentile, preserving the data point while limiting its influence.

```python
import numpy as np
import pandas as pd
from scipy import stats

def winsorize_column(series, lower_percentile=0.01, upper_percentile=0.99):
    """Winsorize a single column at specified percentiles."""
    lower_bound = series.quantile(lower_percentile)
    upper_bound = series.quantile(upper_percentile)
    return series.clip(lower=lower_bound, upper=upper_bound)

def winsorize_dataframe(df, columns=None, lower=0.01, upper=0.99, method='column'):
    """
    Winsorize multiple columns with different strategies.
    
    Methods:
    - 'column': Winsorize each column independently
    - 'row': Winsorize based on Mahalanobis distance (multivariate)
    - 'mad': Use Median Absolute Deviation (robust to skewness)
    """
    df_result = df.copy()
    
    if columns is None:
        columns = df.select_dtypes(include=[np.number]).columns
    
    if method == 'column':
        for col in columns:
            df_result[col] = winsorize_column(df[col], lower, upper)
    
    elif method == 'mad':
        for col in columns:
            median = df[col].median()
            mad = np.median(np.abs(df[col] - median))
            if mad == 0:
                continue
            # MAD-based bounds (equivalent to ~3 standard deviations)
            lower_bound = median - 3 * 1.4826 * mad
            upper_bound = median + 3 * 1.4826 * mad
            df_result[col] = df[col].clip(lower=lower_bound, upper=upper_bound)
    
    elif method == 'row':
        # Mahalanobis distance for multivariate outlier detection
        clean_data = df[columns].dropna()
        if len(clean_data) < len(columns) + 1:
            return df_result
        
        mean = clean_data.mean().values
        cov = clean_data.cov().values
        
        try:
            cov_inv = np.linalg.inv(cov)
        except np.linalg.LinAlgError:
            return df_result
        
        distances = []
        for _, row in clean_data.iterrows():
            diff = row.values - mean
            dist = np.sqrt(diff @ cov_inv @ diff)
            distances.append(dist)
        
        # Cap at 99th percentile of Mahalanobis distances
        threshold = np.percentile(distances, upper * 100)
        outlier_mask = np.array(distances) > threshold
        
        for col in columns:
            col_values = df_result[col].copy()
            col_values[clean_data.index[outlier_mask]] = np.nan
            # Re-impute with median for multivariate outliers
            col_values.fillna(col.median(), inplace=True)
            df_result[col] = col_values
    
    return df_result

def detect_outliers_comprehensive(df, columns=None):
    """Detect outliers using multiple methods and cross-validate."""
    if columns is None:
        columns = df.select_dtypes(include=[np.number]).columns
    
    outlier_report = {}
    
    for col in columns:
        series = df[col].dropna()
        methods = {}
        
        # IQR method
        q1, q3 = series.quantile(0.25), series.quantile(0.75)
        iqr = q3 - q1
        iqr_outliers = ((series < q1 - 1.5 * iqr) | (series > q3 + 1.5 * iqr))
        methods['IQR'] = iqr_outliers.sum()
        
        # Z-score method
        z_scores = np.abs(stats.zscore(series))
        methods['Z-score_3'] = (z_scores > 3).sum()
        methods['Z-score_2.5'] = (z_scores > 2.5).sum()
        
        # MAD method
        median = series.median()
        mad = np.median(np.abs(series - median))
        if mad > 0:
            modified_z = 0.6745 * (series - median) / mad
            methods['MAD'] = (np.abs(modified_z) > 3.5).sum()
        
        # Percentile-based
        methods['P01_P99'] = (
            (series < series.quantile(0.01)) | 
            (series > series.quantile(0.99))
        ).sum()
        
        # Consensus: flagged by 3+ methods
        outlier_flags = pd.DataFrame({
            method: (series.index.isin(series[flagged].index)) 
            for method, flagged in [('IQR', iqr_outliers)].items()
        })
        
        outlier_report[col] = {
            'counts_by_method': methods,
            'n_rows': len(series),
            'pct_outliers': {k: round(v / len(series) * 100, 2) for k, v in methods.items()}
        }
    
    return outlier_report
```

### 4. Fuzzy Deduplication with Blocking

For large datasets, comparing every pair of records is O(n²). Blocking reduces the search space by only comparing records within the same block.

```python
import pandas as pd
from collections import defaultdict
from difflib import SequenceMatcher

def fuzzy_deduplicate(
    df, 
    key_columns, 
    similarity_threshold=0.85,
    blocking_column=None
):
    """
    Fuzzy deduplication with optional blocking.
    
    Parameters:
    - df: DataFrame to deduplicate
    - key_columns: columns to compare for similarity
    - similarity_threshold: minimum similarity to consider a match
    - blocking_column: optional column to block on (e.g., first letter of name)
    """
    
    def compute_similarity(row1, row2):
        """Compute average similarity across key columns."""
        similarities = []
        for col in key_columns:
            val1 = str(row1[col]).lower() if pd.notna(row1[col]) else ""
            val2 = str(row2[col]).lower() if pd.notna(row2[col]) else ""
            sim = SequenceMatcher(None, val1, val2).ratio()
            similarities.append(sim)
        return np.mean(similarities)
    
    # Build blocks
    if blocking_column:
        blocks = defaultdict(list)
        for idx, row in df.iterrows():
            block_key = str(row[blocking_column]).lower()[:1] if pd.notna(row[blocking_column]) else ""
            blocks[block_key].append(idx)
    else:
        blocks = {"all": list(df.index)}
    
    # Find duplicates within blocks
    duplicates = []
    for block_key, indices in blocks.items():
        for i in range(len(indices)):
            for j in range(i + 1, len(indices)):
                idx1, idx2 = indices[i], indices[j]
                sim = compute_similarity(df.loc[idx1], df.loc[idx2])
                
                if sim >= similarity_threshold:
                    duplicates.append({
                        'idx1': idx1,
                        'idx2': idx2,
                        'similarity': sim,
                        'block': block_key
                    })
    
    # Merge duplicates (keep first, flag others)
    duplicate_indices = set()
    merge_map = {}
    
    for dup in duplicates:
        idx1, idx2 = dup['idx1'], dup['idx2']
        if idx2 not in merge_map:
            merge_map[idx2] = idx1
            duplicate_indices.add(idx2)
    
    return {
        'n_duplicates_found': len(duplicate_indices),
        'duplicate_indices': duplicate_indices,
        'merge_map': merge_map,
        'duplicates_detail': duplicates
    }
```

### 5. Schema Validation Pipeline

```python
import pandas as pd
import re
from datetime import datetime

class SchemaValidator:
    """Validate DataFrame against a defined schema."""
    
    def __init__(self):
        self.schema = {}
        self.errors = []
        self.warnings = []
    
    def define_column(self, name, dtype=None, nullable=True, 
                      min_value=None, max_value=None, 
                      allowed_values=None, pattern=None,
                      unique=False, min_length=None, max_length=None):
        """Define expected schema for a column."""
        self.schema[name] = {
            'dtype': dtype,
            'nullable': nullable,
            'min_value': min_value,
            'max_value': max_value,
            'allowed_values': allowed_values,
            'pattern': pattern,
            'unique': unique,
            'min_length': min_length,
            'max_length': max_length
        }
        return self
    
    def validate(self, df):
        """Run full schema validation."""
        self.errors = []
        self.warnings = []
        
        # Check for missing columns
        for col_name in self.schema:
            if col_name not in df.columns:
                self.errors.append({
                    'column': col_name,
                    'issue': 'MISSING_COLUMN',
                    'severity': 'critical',
                    'message': f"Required column '{col_name}' not found in DataFrame"
                })
        
        # Validate each column
        for col_name, rules in self.schema.items():
            if col_name not in df.columns:
                continue
            
            series = df[col_name]
            
            # Check nullability
            if not rules['nullable'] and series.isnull().any():
                n_nulls = series.isnull().sum()
                self.errors.append({
                    'column': col_name,
                    'issue': 'NULL_VALUES',
                    'severity': 'critical',
                    'count': n_nulls,
                    'message': f"Column '{col_name}' has {n_nulls} null values but is required"
                })
            
            # Check data type
            if rules['dtype']:
                if rules['dtype'] == 'datetime':
                    try:
                        pd.to_datetime(series.dropna())
                    except Exception:
                        self.errors.append({
                            'column': col_name,
                            'issue': 'TYPE_MISMATCH',
                            'severity': 'critical',
                            'message': f"Column '{col_name}' cannot be parsed as datetime"
                        })
                elif rules['dtype'] == 'numeric':
                    if not pd.api.types.is_numeric_dtype(series):
                        self.errors.append({
                            'column': col_name,
                            'issue': 'TYPE_MISMATCH',
                            'severity': 'critical',
                            'message': f"Column '{col_name}' is not numeric"
                        })
            
            # Check value ranges
            if rules['min_value'] is not None:
                violations = (series.dropna() < rules['min_value']).sum()
                if violations > 0:
                    self.errors.append({
                        'column': col_name,
                        'issue': 'VALUE_BELOW_MIN',
                        'severity': 'warning',
                        'count': violations,
                        'message': f"Column '{col_name}' has {violations} values below {rules['min_value']}"
                    })
            
            if rules['max_value'] is not None:
                violations = (series.dropna() > rules['max_value']).sum()
                if violations > 0:
                    self.errors.append({
                        'column': col_name,
                        'issue': 'VALUE_ABOVE_MAX',
                        'severity': 'warning',
                        'count': violations,
                        'message': f"Column '{col_name}' has {violations} values above {rules['max_value']}"
                    })
            
            # Check allowed values
            if rules['allowed_values'] is not None:
                invalid = ~series.dropna().isin(rules['allowed_values'])
                if invalid.any():
                    self.errors.append({
                        'column': col_name,
                        'issue': 'INVALID_VALUES',
                        'severity': 'warning',
                        'count': invalid.sum(),
                        'message': f"Column '{col_name}' has {invalid.sum()} values not in allowed set"
                    })
            
            # Check pattern (regex)
            if rules['pattern'] is not None:
                non_null = series.dropna().astype(str)
                pattern_violations = ~non_null.str.match(rules['pattern'])
                if pattern_violations.any():
                    self.errors.append({
                        'column': col_name,
                        'issue': 'PATTERN_MISMATCH',
                        'severity': 'warning',
                        'count': pattern_violations.sum(),
                        'message': f"Column '{col_name}' has {pattern_violations.sum()} values not matching pattern"
                    })
            
            # Check uniqueness
            if rules['unique']:
                duplicates = series.duplicated().sum()
                if duplicates > 0:
                    self.errors.append({
                        'column': col_name,
                        'issue': 'DUPLICATE_VALUES',
                        'severity': 'critical',
                        'count': duplicates,
                        'message': f"Column '{col_name}' has {duplicates} duplicate values"
                    })
        
        return {
            'is_valid': len([e for e in self.errors if e['severity'] == 'critical']) == 0,
            'errors': self.errors,
            'warnings': [e for e in self.errors if e['severity'] == 'warning'],
            'n_critical': len([e for e in self.errors if e['severity'] == 'critical']),
            'n_warnings': len([e for e in self.errors if e['severity'] == 'warning'])
        }
```

### 6. Text Normalization Pipeline

```python
import re
import unicodedata
import pandas as pd

class TextNormalizer:
    """Comprehensive text normalization for data cleaning."""
    
    def __init__(self):
        self.corrections = {}
    
    def normalize(self, series, steps=None):
        """Apply normalization pipeline to a text series."""
        if steps is None:
            steps = ['unicode', 'whitespace', 'case', 'strip']
        
        result = series.copy()
        
        for step in steps:
            if step == 'unicode':
                result = result.apply(self._normalize_unicode)
            elif step == 'whitespace':
                result = result.apply(self._normalize_whitespace)
            elif step == 'case':
                result = result.str.lower()
            elif step == 'strip':
                result = result.str.strip()
            elif step == 'numbers':
                result = result.apply(self._normalize_numbers)
            elif step == 'corrections':
                result = result.apply(self._apply_corrections)
        
        return result
    
    def _normalize_unicode(self, text):
        if pd.isna(text):
            return text
        # Normalize to NFC (canonical decomposition + composition)
        text = unicodedata.normalize('NFC', str(text))
        # Remove control characters
        text = ''.join(c for c in text if unicodedata.category(c) != 'Cc')
        return text
    
    def _normalize_whitespace(self, text):
        if pd.isna(text):
            return text
        # Replace multiple whitespace with single space
        text = re.sub(r'\s+', ' ', str(text))
        # Remove zero-width characters
        text = re.sub(r'[\u200b\u200c\u200d\ufeff]', '', text)
        return text
    
    def _normalize_numbers(self, text):
        if pd.isna(text):
            return text
        text = str(text)
        # Standardize thousand separators
        text = re.sub(r'(\d)[,.](\d{3})', r'\1\2', text)
        # Standardize decimal points
        text = text.replace(',', '.')
        return text
    
    def _apply_corrections(self, text):
        if pd.isna(text):
            return text
        text = str(text)
        for wrong, right in self.corrections.items():
            text = text.replace(wrong, right)
        return text
    
    def add_correction(self, wrong, right):
        self.corrections[wrong] = right
    
    def add_corrections_from_mapping(self, mapping: dict):
        self.corrections.update(mapping)

# Usage example
normalizer = TextNormalizer()
normalizer.add_corrections_from_mapping({
    'NY': 'New York',
    'SF': 'San Francisco',
    'LA': 'Los Angeles',
    'NYC': 'New York',
})

# Apply to DataFrame
df['city_normalized'] = normalizer.normalize(df['city'], steps=['unicode', 'whitespace', 'case', 'corrections'])
```

### 7. Multi-Source Merge with Conflict Resolution

```python
import pandas as pd
import numpy as np

def merge_datasets_with_conflicts(
    datasets: list,
    key_columns: list,
    priority_order: list = None,
    conflict_strategy: str = 'priority'  # 'priority', 'flag', 'combine'
):
    """
    Merge multiple datasets with conflict resolution.
    
    Parameters:
    - datasets: list of (name, DataFrame) tuples
    - key_columns: columns to join on
    - priority_order: list of dataset names in priority order (most authoritative first)
    - conflict_strategy: how to handle conflicts
    """
    if priority_order is None:
        priority_order = [name for name, _ in datasets]
    
    # Rename columns with source prefix for tracking
    renamed_datasets = []
    for name, df in datasets:
        df_renamed = df.copy()
        non_key_cols = [c for c in df.columns if c not in key_columns]
        rename_map = {col: f"{col}__{name}" for col in non_key_cols}
        df_renamed = df_renamed.rename(columns=rename_map)
        renamed_datasets.append((name, df_renamed))
    
    # Progressive merge
    result = renamed_datasets[0][1].copy()
    
    for name, df in renamed_datasets[1:]:
        # Outer merge to keep all records
        result = result.merge(
            df, on=key_columns, how='outer', suffixes=('', f'__{name}')
        )
    
    # Resolve conflicts
    original_columns = [c for c in result.columns if '__' not in c]
    all_source_cols = {}
    
    for col in original_columns:
        source_cols = [c for c in result.columns if c.startswith(f"{col}__")]
        if source_cols:
            all_source_cols[col] = source_cols
    
    conflict_log = []
    
    for col, sources in all_source_cols.items():
        for idx in result.index:
            values = {}
            for source_col in sources:
                val = result.at[idx, source_col]
                if pd.notna(val):
                    source_name = source_col.split('__')[1]
                    values[source_name] = val
            
            if len(values) > 1:
                # Conflict detected
                if conflict_strategy == 'priority':
                    for pname in priority_order:
                        if pname in values:
                            result.at[idx, col] = values[pname]
                            break
                elif conflict_strategy == 'flag':
                    result.at[idx, col] = f"CONFLICT: {values}"
                elif conflict_strategy == 'combine':
                    result.at[idx, col] = '|'.join(str(v) for v in values.values())
                
                conflict_log.append({
                    'row': idx,
                    'column': col,
                    'conflicting_values': values
                })
            elif len(values) == 1:
                result.at[idx, col] = list(values.values())[0]
    
    # Drop source-prefixed columns
    cols_to_drop = [c for c in result.columns if '__' in c]
    result = result.drop(columns=cols_to_drop)
    
    return {
        'merged_data': result,
        'n_conflicts': len(conflict_log),
        'conflict_log': conflict_log
    }
```

---

## Common Patterns

### Pattern 1: Complete Data Cleaning Pipeline

```python
import pandas as pd
import numpy as np

def cleaning_pipeline(df, config=None):
    """
    End-to-end data cleaning pipeline.
    
    config dict keys:
    - drop_duplicates: bool
    - duplicate_subset: list of columns
    - missing_threshold: float (drop columns with > threshold missing)
    - impute_numeric: 'mean' | 'median' | 'model'
    - impute_categorical: 'mode' | 'unknown'
    - outlier_method: 'iqr' | 'zscore' | 'mad' | None
    - outlier_action: 'remove' | 'winsorize' | 'flag'
    """
    if config is None:
        config = {
            'drop_duplicates': True,
            'duplicate_subset': None,
            'missing_threshold': 0.5,
            'impute_numeric': 'median',
            'impute_categorical': 'mode',
            'outlier_method': 'iqr',
            'outlier_action': 'winsorize'
        }
    
    report = {'original_shape': df.shape, 'steps': []}
    result = df.copy()
    
    # Step 1: Drop columns with too many missing values
    missing_pct = result.isnull().mean()
    cols_to_drop = missing_pct[missing_pct > config['missing_threshold']].index.tolist()
    if cols_to_drop:
        result = result.drop(columns=cols_to_drop)
        report['steps'].append(f"Dropped {len(cols_to_drop)} columns with >{config['missing_threshold']*100}% missing")
    
    # Step 2: Drop exact duplicates
    if config['drop_duplicates']:
        n_before = len(result)
        result = result.drop_duplicates(subset=config['duplicate_subset'])
        n_dropped = n_before - len(result)
        report['steps'].append(f"Dropped {n_dropped} duplicate rows")
    
    # Step 3: Handle missing values
    numeric_cols = result.select_dtypes(include=[np.number]).columns
    categorical_cols = result.select_dtypes(include=['object', 'category']).columns
    
    for col in numeric_cols:
        if result[col].isnull().any():
            if config['impute_numeric'] == 'mean':
                result[col].fillna(result[col].mean(), inplace=True)
            elif config['impute_numeric'] == 'median':
                result[col].fillna(result[col].median(), inplace=True)
    
    for col in categorical_cols:
        if result[col].isnull().any():
            if config['impute_categorical'] == 'mode':
                result[col].fillna(result[col].mode()[0] if not result[col].mode().empty else 'Unknown', inplace=True)
            elif config['impute_categorical'] == 'unknown':
                result[col].fillna('Unknown', inplace=True)
    
    report['steps'].append(f"Imputed missing values: numeric={config['impute_numeric']}, categorical={config['impute_categorical']}")
    
    # Step 4: Handle outliers
    if config['outlier_method'] and config['outlier_action']:
        for col in numeric_cols:
            if col not in result.columns:
                continue
            
            if config['outlier_method'] == 'iqr':
                q1, q3 = result[col].quantile(0.25), result[col].quantile(0.75)
                iqr = q3 - q1
                lower, upper = q1 - 1.5 * iqr, q3 + 1.5 * iqr
                
                if config['outlier_action'] == 'winsorize':
                    result[col] = result[col].clip(lower=lower, upper=upper)
                elif config['outlier_action'] == 'remove':
                    result = result[(result[col] >= lower) & (result[col] <= upper)]
                elif config['outlier_action'] == 'flag':
                    result[f'{col}_outlier'] = (result[col] < lower) | (result[col] > upper)
    
    report['steps'].append(f"Outlier treatment: method={config['outlier_method']}, action={config['outlier_action']}")
    report['final_shape'] = result.shape
    report['rows_removed'] = report['original_shape'][0] - report['final_shape'][0]
    
    return result, report
```

### Pattern 2: Missing Value Analysis and Strategy Selection

```python
import pandas as pd
import numpy as np
import missingno as msno

def analyze_missing_values(df):
    """
    Comprehensive missing value analysis with strategy recommendations.
    """
    # Quantify missingness
    total_cells = np.prod(df.shape)
    total_missing = df.isnull().sum().sum()
    
    missing_by_col = df.isnull().sum().sort_values(ascending=False)
    missing_pct = (missing_by_col / len(df) * 100).round(2)
    
    # Missing patterns
    missing_matrix = df.isnull().astype(int)
    missing_patterns = missing_matrix.drop_duplicates()
    
    # Correlation of missingness between columns
    missing_corr = missing_matrix.corr()
    
    # Row-level completeness
    row_completeness = (1 - df.isnull().mean(axis=1)) * 100
    
    # Recommendations
    recommendations = []
    for col, pct in missing_pct.items():
        if pct == 0:
            continue
        elif pct < 5:
            recommendations.append({
                'column': col,
                'missing_pct': pct,
                'strategy': 'median/mode imputation (low missingness)',
                'rationale': 'Small percentage of missing values — simple imputation has minimal bias'
            })
        elif pct < 20:
            recommendations.append({
                'column': col,
                'missing_pct': pct,
                'strategy': 'MICE or KNN imputation (moderate missingness)',
                'rationale': 'Moderate missingness — model-based imputation preserves relationships'
            })
        elif pct < 50:
            recommendations.append({
                'column': col,
                'missing_pct': pct,
                'strategy': 'Multiple imputation + sensitivity analysis',
                'rationale': 'Significant missingness — need to quantify imputation uncertainty'
            })
        else:
            recommendations.append({
                'column': col,
                'missing_pct': pct,
                'strategy': 'Consider dropping column or using as binary indicator',
                'rationale': 'High missingness — imputation may introduce substantial bias'
            })
    
    return {
        'total_missing_cells': total_missing,
        'total_cells': total_cells,
        'overall_missing_pct': (total_missing / total_cells * 100).round(2),
        'missing_by_column': missing_pct[missing_pct > 0].to_dict(),
        'n_patterns': len(missing_patterns),
        'row_completeness': {
            'mean': row_completeness.mean().round(2),
            'median': row_completeness.median().round(2),
            'min': row_completeness.min().round(2),
            'pct_complete_rows': (row_completeness == 100).mean() * 100
        },
        'recommendations': recommendations
    }
```

### Pattern 3: Data Type Inference and Conversion

```python
import pandas as pd
import numpy as np

def infer_and_convert_types(df, strict=False):
    """
    Automatically infer and convert data types for all columns.
    """
    result = df.copy()
    conversions = {}
    
    for col in df.columns:
        original_dtype = df[col].dtype
        series = df[col].dropna()
        
        if len(series) == 0:
            continue
        
        # Try datetime
        try:
            parsed = pd.to_datetime(series, infer_datetime_format=True)
            result[col] = pd.to_datetime(result[col], errors='coerce')
            conversions[col] = {'from': str(original_dtype), 'to': 'datetime64'}
            continue
        except (ValueError, TypeError):
            pass
        
        # Try numeric
        if series.dtype == 'object':
            try:
                numeric = pd.to_numeric(series.str.replace(',', '').str.replace('$', '').str.replace('%', ''))
                result[col] = pd.to_numeric(result[col].str.replace(',', '').str.replace('$', '').str.replace('%', ''), errors='coerce')
                conversions[col] = {'from': str(original_dtype), 'to': 'float64'}
                continue
            except (ValueError, AttributeError):
                pass
        
        # Try boolean
        if series.dtype == 'object':
            bool_values = {'true', 'false', 'yes', 'no', '1', '0', 't', 'f', 'y', 'n'}
            if series.str.lower().isin(bool_values).mean() > 0.9:
                bool_map = {'true': True, 'false': False, 'yes': True, 'no': False, 
                           '1': True, '0': False, 't': True, 'f': False, 'y': True, 'n': False}
                result[col] = result[col].str.lower().map(bool_map)
                conversions[col] = {'from': str(original_dtype), 'to': 'bool'}
                continue
        
        # Try category (if low cardinality)
        if series.dtype == 'object' and series.nunique() / len(series) < 0.05:
            result[col] = result[col].astype('category')
            conversions[col] = {'from': str(original_dtype), 'to': 'category'}
    
    return result, conversions
```

### Pattern 4: Encoding Detection and Normalization

```python
import chardet
import pandas as pd

def detect_and_fix_encoding(df, text_columns=None, sample_size=10000):
    """
    Detect encoding issues in text columns and normalize.
    """
    if text_columns is None:
        text_columns = df.select_dtypes(include=['object']).columns
    
    encoding_report = {}
    
    for col in text_columns:
        # Sample for encoding detection
        sample = df[col].dropna().head(sample_size).str.cat()
        raw_bytes = sample.encode('raw_unicode_escape')
        
        # Detect encoding
        detection = chardet.detect(raw_bytes)
        detected_encoding = detection['encoding']
        confidence = detection['confidence']
        
        encoding_report[col] = {
            'detected_encoding': detected_encoding,
            'confidence': confidence
        }
        
        # Common fixes
        if detected_encoding and confidence > 0.7:
            try:
                df[col] = df[col].apply(
                    lambda x: x.encode(detected_encoding).decode('utf-8') 
                    if pd.notna(x) else x
                )
                encoding_report[col]['action'] = 'converted_to_utf8'
            except (UnicodeDecodeError, UnicodeEncodeError):
                encoding_report[col]['action'] = 'conversion_failed'
        
        # Normalize Unicode
        df[col] = df[col].apply(
            lambda x: unicodedata.normalize('NFC', str(x)) if pd.notna(x) else x
        )
        
        # Remove invisible characters
        df[col] = df[col].apply(
            lambda x: re.sub(r'[\u200b\u200c\u200d\ufeff\u00a0]', ' ', str(x)) 
            if pd.notna(x) else x
        )
    
    return df, encoding_report
```

### Pattern 5: Data Quality Scoring

```python
import pandas as pd
import numpy as np

def compute_data_quality_score(df, weights=None):
    """
    Compute a composite data quality score for the dataset.
    
    Dimensions:
    - Completeness: % of non-null values
    - Uniqueness: % of non-duplicate rows
    - Consistency: % of values conforming to expected patterns
    - Accuracy: % of values within valid ranges
    - Timeliness: % of dates within acceptable range
    """
    if weights is None:
        weights = {
            'completeness': 0.3,
            'uniqueness': 0.2,
            'consistency': 0.2,
            'accuracy': 0.2,
            'timeliness': 0.1
        }
    
    scores = {}
    
    # Completeness
    scores['completeness'] = (1 - df.isnull().mean().mean()) * 100
    
    # Uniqueness
    scores['uniqueness'] = (1 - df.duplicated().mean()) * 100
    
    # Consistency (check string columns for consistent formatting)
    consistency_scores = []
    for col in df.select_dtypes(include=['object']).columns:
        non_null = df[col].dropna()
        if len(non_null) == 0:
            continue
        # Check if values have consistent case
        lower_ratio = (non_null.str.lower() == non_null).mean()
        upper_ratio = (non_null.str.upper() == non_null).mean()
        consistency_scores.append(max(lower_ratio, upper_ratio))
    scores['consistency'] = np.mean(consistency_scores) * 100 if consistency_scores else 100
    
    # Accuracy (check numeric columns for reasonable ranges)
    accuracy_scores = []
    for col in df.select_dtypes(include=[np.number]).columns:
        series = df[col].dropna()
        if len(series) == 0:
            continue
        q1, q3 = series.quantile(0.25), series.quantile(0.75)
        iqr = q3 - q1
        in_range = ((series >= q1 - 3*iqr) & (series <= q3 + 3*iqr)).mean()
        accuracy_scores.append(in_range)
    scores['accuracy'] = np.mean(accuracy_scores) * 100 if accuracy_scores else 100
    
    # Timeliness (check date columns)
    timeliness_scores = []
    for col in df.columns:
        if df[col].dtype == 'datetime64[ns]':
            dates = df[col].dropna()
            if len(dates) == 0:
                continue
            recent_pct = (dates > dates.max() - pd.Timedelta(days=365)).mean()
            timeliness_scores.append(recent_pct)
    scores['timeliness'] = np.mean(timeliness_scores) * 100 if timeliness_scores else 100
    
    # Composite score
    composite = sum(scores[dim] * weights[dim] for dim in weights)
    
    return {
        'dimension_scores': scores,
        'composite_score': round(composite, 2),
        'grade': (
            'A' if composite >= 90 else
            'B' if composite >= 80 else
            'C' if composite >= 70 else
            'D' if composite >= 60 else 'F'
        )
    }
```

---

## Edge Cases & Pitfalls

### 1. Silent Type Coercion
**Problem:** Pandas silently converts mixed-type columns to object/string, hiding type inconsistencies.
**Solution:** Inspect dtypes explicitly. Use `infer_objects()` or manual type inference to detect and fix mixed types.

### 2. Timezone-unaware Datetime Merging
**Problem:** Merging datasets with timezone-aware and timezone-unaware datetime columns causes silent errors or incorrect matches.
**Solution:** Normalize all datetime columns to UTC before merging. Use `pd.to_datetime(series, utc=True)`.

### 3. Leading/Trailing Whitespace in Keys
**Problem:** "New York" and "New York " are treated as different values, breaking joins and groupbys.
**Solution:** Always `.str.strip()` string columns before joining or grouping. Apply to both datasets being merged.

### 4. Duplicate Column Names After Merge
**Problem:** Merging datasets with overlapping non-key column names creates suffixed duplicates (e.g., `value_x`, `value_y`).
**Solution:** Rename columns with source prefixes before merging. Explicitly handle suffix resolution.

### 5. Categorical Order Loss After Imputation
**Problem:** Imputing a categorical column with the mode destroys the categorical dtype and its inherent ordering.
**Solution:** Re-apply categorical dtype with correct ordering after imputation. Use `pd.Categorical()` with explicit categories and order.

### 6. Memory Explosion from Object Columns
**Problem:** A column with millions of unique strings stored as object dtype consumes 5-10x more memory than category dtype.
**Solution:** Convert low-cardinality string columns to category dtype. Monitor memory usage with `df.info(memory_usage='deep')`.

### 7. Inf Values Masquerading as Missing
**Problem:** `np.inf` and `-np.inf` are not caught by `.isnull()` but break statistical computations and model training.
**Solution:** Replace inf values explicitly: `df.replace([np.inf, -np.inf], np.nan)`. Check for them in profiling.

### 8. Date Parsing Ambiguity
**Problem:** "01/02/2024" is January 2 (US) or February 1 (EU) depending on locale. Different date formats in the same column cause parsing errors.
**Solution:** Standardize date formats during ingestion. Use ISO 8601 (`YYYY-MM-DD`) as the canonical format.

### 9. DataFrame Chaining Modifies Original
**Problem:** Operations like `df[col].fillna(0)` may or may not modify the original DataFrame depending on whether chained assignment is used.
**Solution:** Use `.copy()` when creating working copies. Use `.loc[]` for assignments: `df.loc[mask, col] = value`.

### 10. Index Misalignment During Merge
**Problem:** After merge, the index may be reset or duplicated, causing misalignment in subsequent operations.
**Solution:** Explicitly manage index: reset before merge, set meaningful index after merge.

### 11. Numeric Columns Stored as Strings
**Problem:** Columns that look numeric but contain non-numeric characters (currency symbols, commas, "N/A" text) fail numeric conversion.
**Solution:** Use regex to strip non-numeric characters before conversion. Handle edge cases like "(123)" for negative numbers.

### 12. Small Sample Size Distorts Imputation
**Problem:** Mean/median imputation on small datasets (<30 rows) can introduce severe bias, especially with skewed distributions.
**Solution:** For small samples, prefer domain-expert imputation or flag imputed values explicitly. Consider whether the sample is sufficient for analysis.

### 13. Drop Na Removes Too Much
**Problem:** `df.dropna()` with many columns removes most rows, even if missingness is in different columns per row.
**Solution:** Use `df.dropna(thresh=len(df.columns) * 0.7)` to keep rows with at least 70% non-null values. Or impute before dropping.

### 14. Over-normalization Destroys Information
**Problem:** Aggressive text normalization (lowercasing, removing punctuation) can destroy meaningful distinctions (e.g., "US" vs "us", "Apple" the company vs "apple" the fruit).
**Solution:** Apply normalization selectively. Preserve case for proper nouns. Use context-aware normalization.

### 15. Inconsistent Category Labels Across Sources
**Problem:** Different data sources use different labels for the same category ("M" vs "Male" vs "1" vs "male").
**Solution:** Create a mapping table (dictionary) for each categorical field. Apply the mapping during merge. Validate completeness of the mapping.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **Data Analysis** | Prerequisite | Clean data is the foundation of reliable analysis — always clean before analyzing |
| **Statistical Testing** | Dependency | Missing values and outliers directly impact test validity and power |
| **Data Visualization** | Downstream | Clean data produces accurate visualizations; dirty data creates misleading charts |
| **Machine Learning** | Prerequisite | Model performance depends heavily on data quality — preprocessing pipelines are critical |
| **RAG Implementation** | Upstream | Document quality impacts chunking and retrieval — clean documents retrieve better |
| **Technical Writing** | Companion | Document cleaning procedures for reproducibility and audit trails |
| **Database Management** | Integration | Data cleaning often involves SQL transformations before pandas processing |
| **ETL Pipelines** | Core Component | Data cleaning is a central stage in ETL workflows |

---

## Output Format Templates

### Standard Cleaning Report

```markdown
## Data Cleaning Report: {Dataset Name}

### Overview
- **Original Shape:** {rows} rows × {cols} columns
- **Final Shape:** {rows} rows × {cols} columns
- **Rows Removed:** {n} ({pct}%)
- **Columns Removed:** {n} ({pct}%)
- **Data Quality Score:** {score}/100 (Grade: {grade})

### Issues Found and Resolved

| Issue Type | Column(s) | Count | Action Taken | Impact |
|---|---|---|---|---|
| Missing values | {col} | {n} ({pct}%) | {imputation_method} | {impact} |
| Duplicates | {col} | {n} ({pct}%) | {action} | {impact} |
| Outliers | {col} | {n} ({pct}%) | {method} | {impact} |
| Type mismatch | {col} | {n} ({pct}%) | {conversion} | {impact} |

### Before vs After Comparison
{table_with_key_metrics_before_and_after}

### Remaining Issues
- {issue_1}
- {issue_2}

### Recommendations for Source Systems
1. {recommendation_1}
2. {recommendation_2}
```

### Quick Data Profile

```markdown
## Quick Data Profile

**Shape:** {rows} × {cols} | **Memory:** {mb}MB
**Completeness:** {pct}% | **Duplicates:** {n} rows
**Numeric Columns:** {n} | **Categorical Columns:** {n} | **Datetime Columns:** {n}

### Top Issues
1. {issue_1} — {severity}
2. {issue_2} — {severity}
3. {issue_3} — {severity}
```

### Deep Cleaning Pipeline Report

```markdown
## Deep Cleaning Pipeline Report

### Configuration
```yaml
drop_duplicates: true
duplicate_subset: [customer_id, transaction_date]
missing_threshold: 0.5
impute_numeric: median
impute_categorical: mode
outlier_method: iqr
outlier_action: winsorize
```

### Step-by-Step Log
| Step | Operation | Rows Before | Rows After | Cols Before | Cols After | Notes |
|---|---|---|---|---|---|---|
| 1 | Column drops | 10000 | 10000 | 25 | 22 | Dropped 3 cols with >50% missing |
| 2 | Duplicate removal | 10000 | 9847 | 22 | 22 | Removed 153 exact duplicates |
| 3 | Missing value imputation | 9847 | 9847 | 22 | 22 | Filled: age(median), city(mode) |
| 4 | Outlier winsorization | 9847 | 9847 | 22 | 24 | Winsorized: income, age; Flagged: 2 outlier cols |

### Quality Metrics
| Metric | Before | After | Change |
|---|---|---|---|
| Completeness | 87.3% | 100.0% | +12.7% |
| Uniqueness | 98.5% | 100.0% | +1.5% |
| Consistency | 91.2% | 95.8% | +4.6% |
| Composite Score | 72.1 | 89.4 | +17.3 |
```

### Agent-Friendly Structured Output

```json
{
  "cleaning_report": {
    "input_shape": [10000, 25],
    "output_shape": [9847, 24],
    "rows_dropped": 153,
    "columns_dropped": 1,
    "operations": [
      {"step": 1, "type": "column_drop", "columns": ["notes"], "reason": "95.3% missing"},
      {"step": 2, "type": "dedup", "method": "exact", "columns": ["id"], "removed": 153},
      {"step": 3, "type": "impute", "column": "age", "method": "median", "fill_value": 34.0},
      {"step": 4, "type": "winsorize", "column": "income", "lower": 15000, "upper": 200000}
    ],
    "quality_score": {"before": 72.1, "after": 89.4},
    "warnings": ["Column 'phone' has inconsistent format across sources"],
    "remaining_issues": ["Column 'email' still has 3.2% invalid formats"]
  }
}
```

---

## Rules

1. **Profile before cleaning** — Never start cleaning without understanding the data. Run comprehensive profiling to identify all issues before writing any cleaning code.
2. **Understand the missingness mechanism** — MCAR, MAR, and MNAR require fundamentally different strategies. Test for MCAR before defaulting to mean imputation.
3. **Preserve raw data** — Always keep the original data untouched. Work on copies. Document every transformation for reproducibility.
4. **Clean incrementally, validate frequently** — Apply one cleaning step at a time and verify the result before proceeding. Batch cleaning makes debugging impossible.
5. **Don't over-impute** — Imputation introduces artificial information. If a column has >50% missing values, consider whether imputation is appropriate or whether the column should be dropped.
6. **Handle outliers based on context** — Not all outliers are errors. Natural extremes (e.g., high-value customers) should be preserved. Remove only data entry errors and sensor malfunctions.
7. **Standardize before merging** — Ensure consistent encodings, formats, category labels, and case across datasets before attempting joins.
8. **Validate schema before processing** — Define expected schemas with types, ranges, patterns, and constraints. Validate incoming data against the schema early.
9. **Document every decision** — Record why each cleaning choice was made, what alternatives were considered, and how many rows were affected. Future you will thank present you.
10. **Measure data quality quantitatively** — Compute completeness, uniqueness, consistency, and accuracy scores before and after cleaning. Track improvement.
11. **Use appropriate imputation for the data type** — Mean/median for continuous numeric, mode for categorical, forward-fill for time series, model-based for complex relationships.
12. **Don't silently drop rows** — Every row removal should be logged with a reason. Silent data loss makes debugging impossible and can introduce bias.
13. **Test edge cases explicitly** — Verify that cleaning handles empty DataFrames, single-row DataFrames, all-null columns, and columns with mixed types.
14. **Automate where possible** — Convert manual cleaning steps into repeatable functions or pipelines. Manual cleaning doesn't scale and isn't reproducible.
15. **Audit after cleaning** — Re-run profiling after cleaning to verify that the expected improvements occurred and no new issues were introduced.
