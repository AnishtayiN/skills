---
name: data-analysis
description: >-
  Perform rigorous data analysis and statistical reasoning on datasets.
  English: data analysis, EDA, exploratory data analysis, statistical tests, hypothesis testing,
    time series analysis, cohort analysis, A/B testing, PCA, clustering, RFM segmentation,
    correlation analysis, regression, causal inference, Simpson's paradox, p-hacking prevention,
    multiple testing correction, ANOVA, chi-square, Mann-Whitney, Wilcoxon, Kruskal-Wallis.
  فارسی: تحلیل داده، تحلیل اکتشافی، آزمون‌های آماری، آزمون فرضیه، تحلیل سری زمانی،
    تحلیل کوهورت، آزمون A/B، تجزیه مولفه‌های اصلی، خوشه‌بندی، تفکیک RFM،
    پارادوکس سیمپسون، جلوگیری از p-hacking.
  中文: 数据分析，探索性数据分析，统计检验，假设检验，时间序列分析，队列分析，A/B测试，
    主成分分析，聚类分析，RFM分析，辛普森悖论，p值操纵预防，多重检验校正。
priority: P2
dependencies: []
conflicts: []
---

# Data Analysis and Statistical Reasoning

## Overview

Data analysis is the systematic process of inspecting, cleaning, transforming, and modeling data to discover useful information, draw conclusions, and support decision-making. This skill covers the complete analytical workflow — from initial exploration through rigorous statistical testing to actionable insights — with emphasis on avoiding common analytical pitfalls that lead to wrong conclusions.

The critical distinction between novice and expert analysis is **skepticism**: questioning whether observed patterns are real artifacts, understanding confounders, and recognizing when statistical methods are misapplied. A technically correct analysis with a flawed research design produces confidently wrong answers.

This skill covers: exploratory data analysis (EDA), statistical hypothesis testing, time series decomposition, cohort analysis, A/B testing with proper power analysis, dimensionality reduction (PCA), clustering, RFM segmentation, and the critical meta-issues of Simpson's paradox, p-hacking, and multiple testing correction.

## When to Use This Skill

- Exploring a new dataset to understand its structure, distributions, and relationships
- Testing whether observed differences are statistically significant
- Analyzing A/B test results with proper statistical rigor
- Decomposing time series into trend, seasonality, and residual components
- Performing cohort analysis for retention, revenue, or behavior tracking
- Applying PCA for dimensionality reduction before modeling
- Segmenting customers using clustering or RFM analysis
- Identifying and correcting for Simpson's paradox in aggregated data
- Performing multiple hypothesis tests with proper correction

## When NOT to Use This Skill

- Simple data retrieval or filtering (use SQL/basic pandas)
- Machine learning model training (use ML-specific skills)
- Real-time data streaming analysis (use stream processing patterns)
- Data visualization design (use visualization-specific skills)
- When sample sizes are too small for meaningful statistical inference
- When the data generation process is unknown and cannot be characterized

---

## Workflow

### Phase 1: Exploratory Data Analysis (EDA)

**Objective:** Understand the dataset's structure, quality, distributions, and relationships before any formal analysis.

```
Raw Data → Schema Inspection → Univariate Analysis → Bivariate Analysis → Multivariate Exploration → Hypotheses
```

**Step 1.1 — Schema Inspection**
Examine column names, data types, non-null counts, and memory usage. Identify identifier columns, target variables, and feature types (continuous, categorical, ordinal, temporal).

**Step 1.2 — Univariate Analysis**
For continuous variables: compute mean, median, std, skewness, kurtosis, and plot histograms/KDE. For categorical variables: compute value counts, mode, and plot bar charts. Check for impossible values (negative ages, future dates in historical data).

**Step 1.3 — Bivariate Analysis**
Compute correlation matrices (Pearson for linear, Spearman for monotonic, Cramér's V for categorical-categorical). Create scatter plots for continuous pairs. Use grouped box plots for categorical-continuous relationships.

**Step 1.4 — Missing Value Analysis**
Quantify missingness by column and by row. Visualize patterns with missingno matrix. Classify as MCAR, MAR, or MNAR to guide imputation strategy.

**Step 1.5 — Formulate Hypotheses**
Based on EDA, formulate specific, testable hypotheses. Distinguish between confirmatory (pre-specified) and exploratory (data-driven) hypotheses — they require different statistical approaches.

### Phase 2: Statistical Testing

**Objective:** Determine whether observed patterns reflect real effects or are attributable to random variation.

```
Hypothesis → Test Selection → Assumption Verification → Test Execution → Effect Size → Decision
```

**Step 2.1 — Select Appropriate Test**

| Comparison | Parametric | Non-parametric |
|---|---|---|
| Two independent groups | Student's t-test | Mann-Whitney U |
| Two paired groups | Paired t-test | Wilcoxon signed-rank |
| Three+ independent groups | One-way ANOVA | Kruskal-Wallis |
| Three+ paired groups | Repeated measures ANOVA | Friedman test |
| Two categorical variables | Chi-square test | Fisher's exact test |
| Correlation | Pearson r | Spearman ρ / Kendall τ |

**Step 2.2 — Verify Assumptions**
Before running parametric tests, check: normality (Shapiro-Wilk, Q-Q plots), homogeneity of variances (Levene's test), independence of observations, and absence of significant outliers.

**Step 2.3 — Execute and Interpret**
Run the test, extract the test statistic and p-value. Compare p-value to significance threshold (typically α = 0.05, but adjusted for multiple comparisons). **Always compute effect size** (Cohen's d, η², odds ratio) — statistical significance without practical significance is meaningless.

### Phase 3: A/B Testing

**Objective:** Rigorously compare two variants to determine which performs better.

```
Hypothesis → Sample Size Calculation → Randomization → Data Collection → Analysis → Decision
```

**Step 3.1 — Define Hypotheses and Metrics**
Primary metric (the one you're optimizing), guardrail metrics (metrics that must not degrade), and secondary metrics. Define minimum detectable effect (MDE).

**Step 3.2 — Power Analysis**
Calculate required sample size based on: significance level (α), statistical power (1-β, typically 0.8), expected effect size, and baseline metric variance.

**Step 3.3 — Randomization and Validation**
Ensure proper randomization at the user level (not request level). Validate that treatment and control groups are balanced on key covariates.

**Step 3.4 — Analysis**
Use the appropriate test for the metric type (t-test for means, chi-square for proportions). Check for novelty effects, carryover effects, and sample ratio mismatch. If running multiple variants, apply multiple testing correction.

### Phase 4: Time Series Analysis

**Objective:** Understand temporal patterns, decompose components, and detect anomalies.

```
Data → Stationarity Test → Decomposition → Seasonality Analysis → Trend Analysis → Forecasting
```

**Step 4.1 — Stationarity Testing**
Apply Augmented Dickey-Fuller (ADF) test or KPSS test to determine if the series is stationary. Non-stationary series require differencing or transformation.

**Step 4.2 — Decomposition**
Separate the time series into components:
- **Trend:** Long-term direction (linear, polynomial, or non-linear)
- **Seasonality:** Periodic fluctuations (daily, weekly, monthly, yearly)
- **Residual:** Unexplained variation after removing trend and seasonality

Use additive decomposition for constant-amplitude seasonality, multiplicative for proportional-amplitude.

**Step 4.3 — Autocorrelation Analysis**
Compute ACF and PACF plots to identify ARIMA model orders. Use Ljung-Box test to check for remaining autocorrelation in residuals.

### Phase 5: Cohort Analysis

**Objective:** Track how groups of users defined by a shared characteristic evolve over time.

```
Define Cohort → Assign Users → Choose Metric → Build Cohort Table → Visualize → Interpret
```

**Step 5.1 — Define Cohort**
Common cohort definitions: acquisition date (monthly/weekly), first purchase category, signup channel, geographic region.

**Step 5.2 — Build Cohort Matrix**
For each cohort, compute the metric (retention, revenue, engagement) at each time period since cohort formation.

**Step 5.3 — Interpret Patterns**
Look for: cohort-over-cohort improvement, seasonal effects, feature launch impacts, and natural cohort decay curves.

### Phase 6: Segmentation and Clustering

**Objective:** Discover natural groupings in the data for targeted strategies.

```
Feature Selection → Scaling → Method Selection → Clustering → Validation → Profiling
```

**Step 6.1 — Feature Engineering for Segmentation**
Select features relevant to the business question. Common RFM features: Recency (days since last purchase), Frequency (number of transactions), Monetary (total spend).

**Step 6.2 — Determine Optimal Clusters**
Use elbow method (inertia vs. k), silhouette analysis, and gap statistic to choose the number of clusters. Don't over-optimize — business interpretability matters more than mathematical optimality.

**Step 6.3 — Profile Clusters**
For each cluster, compute centroid values and describe the segment in business terms. Create actionable labels (e.g., "High-Value Loyalists", "At-Risk Customers", "New Prospects").

---

## Advanced Techniques

### 1. Simpson's Paradox Detection and Resolution

Simpson's paradox occurs when a trend present in aggregated data reverses when the data is disaggregated by a confounding variable. This is one of the most dangerous pitfalls in data analysis.

```python
import pandas as pd
import numpy as np
from scipy.stats import chi2_contingency

def detect_simpsons_paradox(df, outcome_col, treatment_col, confounders):
    """
    Check if aggregated treatment effect reverses when controlling 
    for confounders.
    """
    # Aggregated analysis
    aggregated = df.groupby(treatment_col)[outcome_col].mean()
    aggregated_effect = aggregated[1] - aggregated[0]
    
    results = []
    for confounder in confounders:
        # Stratified analysis
        stratified_effects = []
        for level, group in df.groupby(confounder):
            if len(group) < 30:  # Skip small strata
                continue
            strat_effect = (
                group[group[treatment_col] == 1][outcome_col].mean() -
                group[group[treatment_col] == 0][outcome_col].mean()
            )
            stratified_effects.append({
                "level": level,
                "effect": strat_effect,
                "n": len(group)
            })
        
        # Weighted average of stratified effects
        if stratified_effects:
            weighted_effect = np.average(
                [e["effect"] for e in stratified_effects],
                weights=[e["n"] for e in stratified_effects]
            )
            
            # Check for reversal
            reversed = (aggregated_effect > 0 and weighted_effect < 0) or \
                       (aggregated_effect < 0 and weighted_effect > 0)
            
            results.append({
                "confounder": confounder,
                "aggregated_effect": aggregated_effect,
                "stratified_effect": weighted_effect,
                "reversed": reversed,
                "strata": stratified_effects
            })
    
    return results

# Example: Detect Simpson's paradox in hiring data
# df has columns: hired (0/1), gender (M/F), department
results = detect_simpsons_paradox(
    df, outcome_col="hired", 
    treatment_col="gender", 
    confounders=["department"]
)
for r in results:
    if r["reversed"]:
        print(f"WARNING: Simpson's paradox detected with confounder '{r['confounder']}'")
        print(f"  Aggregated effect: {r['aggregated_effect']:.3f}")
        print(f"  Stratified effect: {r['stratified_effect']:.3f}")
```

### 2. P-Hacking Prevention Framework

P-hacking is the practice of trying multiple analyses until a statistically significant result emerges, inflating false positive rates. Prevention requires pre-registration and structured analysis plans.

```python
import numpy as np
from scipy.stats import ttest_ind, mannwhitneyu, chi2_contingency, fisher_exact
from itertools import combinations

class PHackingPrevention:
    """Framework to prevent and detect p-hacking in analyses."""
    
    def __init__(self, alpha=0.05):
        self.alpha = alpha
        self.analysis_log = []
        self.pre_registered_tests = []
    
    def pre_register(self, test_name, hypotheses, test_func, alpha=None):
        """Register analysis plan before seeing results."""
        self.pre_registered_tests.append({
            "test_name": test_name,
            "hypotheses": hypotheses,
            "test_func": test_func,
            "alpha": alpha or self.alpha,
            "registered_at": pd.Timestamp.now()
        })
    
    def execute_pre_registered(self, data):
        """Execute only pre-registered tests."""
        results = []
        for test in self.pre_registered_tests:
            result = test["test_func"](data)
            result["p_hacking_risk"] = "low"  # Pre-registered
            results.append(result)
        return results
    
    def exploratory_analysis(self, data, test_funcs, variables):
        """Run exploratory analyses with proper correction."""
        all_results = []
        for var_pair in combinations(variables, 2):
            for test_name, test_func in test_funcs.items():
                result = test_func(data, var_pair)
                result["p_hacking_risk"] = "high"  # Exploratory
                all_results.append(result)
        
        # Apply Benjamini-Hochberg correction
        p_values = [r["p_value"] for r in all_results]
        corrected = self.benjamini_hochberg(p_values)
        
        for r, c_alpha in zip(all_results, corrected):
            r["corrected_alpha"] = c_alpha
            r["significant_after_correction"] = r["p_value"] < c_alpha
        
        return all_results
    
    @staticmethod
    def benjamini_hochberg(p_values, alpha=0.05):
        """Benjamini-Hochberg FDR correction."""
        n = len(p_values)
        ranked = np.argsort(p_values)
        corrected = np.zeros(n)
        
        for i, rank in enumerate(ranked):
            corrected[rank] = min(
                p_values[rank] * n / (i + 1), 
                1.0
            )
        
        # Enforce monotonicity
        for i in range(n - 2, -1, -1):
            corrected[ranked[i]] = min(
                corrected[ranked[i]], 
                corrected[ranked[i + 1]]
            )
        
        return corrected

# Usage example
prevention = PHackingPrevention(alpha=0.05)

# Pre-register primary analysis
prevention.pre_register(
    test_name="primary_conversion_test",
    hypotheses="Treatment group has higher conversion than control",
    test_func=lambda data: {
        "test": "t-test",
        "p_value": ttest_ind(
            data[data.group == "treatment"]["conversion"],
            data[data.group == "control"]["conversion"]
        )[1]
    }
)
```

### 3. Power Analysis and Sample Size Calculation

Before running any experiment, calculate the required sample size to detect a meaningful effect with adequate statistical power.

```python
from scipy.stats import norm
import numpy as np

def power_analysis_two_proportions(
    baseline_rate: float,
    mde: float,
    alpha: float = 0.05,
    power: float = 0.80
) -> int:
    """Calculate sample size for two-proportion Z-test."""
    p1 = baseline_rate
    p2 = baseline_rate + mde
    
    # Pooled proportion
    p_pooled = (p1 + p2) / 2
    
    # Effect size (Cohen's h)
    h = 2 * (np.arcsin(np.sqrt(p1)) - np.arcsin(np.sqrt(p2)))
    
    # Z-scores
    z_alpha = norm.ppf(1 - alpha / 2)
    z_beta = norm.ppf(power)
    
    # Sample size per group
    n = ((z_alpha + z_beta) ** 2 * 2 * p_pooled * (1 - p_pooled)) / (p1 - p2) ** 2
    
    return int(np.ceil(n))

def power_analysis_continuous(
    effect_size: float,  # Cohen's d
    alpha: float = 0.05,
    power: float = 0.80,
    allocation_ratio: float = 1.0
) -> int:
    """Calculate sample size for two-sample t-test (continuous outcome)."""
    z_alpha = norm.ppf(1 - alpha / 2)
    z_beta = norm.ppf(power)
    
    # Welch's formula
    n1 = ((z_alpha + z_beta) ** 2 * (1 + 1/allocation_ratio)) / (effect_size ** 2)
    n2 = n1 * allocation_ratio
    
    return int(np.ceil(n1)), int(np.ceil(n2))

# Example: How many users needed to detect 2% uplift in 10% baseline conversion?
n_per_group = power_analysis_two_proportions(
    baseline_rate=0.10,
    mde=0.02,
    alpha=0.05,
    power=0.80
)
print(f"Need {n_per_group} users per group ({n_per_group * 2} total)")
# Output: Need 3873 users per group (7746 total)
```

### 4. Time Series Decomposition with STL

STL (Seasonal and Trend decomposition using Loess) is robust to outliers and handles multiple seasonal periods.

```python
from statsmodels.tsa.seasonal import STL
from statsmodels.tsa.stattools import adfuller, kpss
import pandas as pd

def decompose_time_series(series, period=None, seasonal=7):
    """
    Decompose time series using STL with stationarity testing.
    
    Parameters:
    - series: pd.Series with DatetimeIndex
    - period: seasonal period (auto-detected if None)
    - seasonal: seasonal smoother parameter
    """
    # Test stationarity
    adf_result = adfuller(series.dropna())
    kpss_result = kpss(series.dropna(), regression='c', nlags='auto')
    
    stationarity = {
        "adf_statistic": adf_result[0],
        "adf_p_value": adf_result[1],
        "is_stationary_adf": adf_result[1] < 0.05,
        "kpss_statistic": kpss_result[0],
        "kpss_p_value": kpss_result[1],
        "is_stationary_kpss": kpss_result[1] > 0.05,
    }
    
    # Determine if differencing is needed
    needs_diff = not (stationarity["is_stationary_adf"] and 
                     stationarity["is_stationary_kpss"])
    
    if needs_diff:
        differenced = series.diff().dropna()
        series = differenced
    
    # STL decomposition
    stl = STL(
        series, 
        period=period or detect_period(series),
        seasonal=seasonal,
        robust=True  # Robust to outliers
    )
    result = stl.fit()
    
    return {
        "trend": result.trend,
        "seasonal": result.seasonal,
        "residual": result.resid,
        "stationarity": stationarity,
        "needs_differencing": needs_diff,
        "strength_of_trend": 1 - (result.resid.var() / 
                                   (result.trend + result.resid).var()),
        "strength_of_seasonality": 1 - (result.resid.var() / 
                                         (result.seasonal + result.resid).var()),
    }

def detect_period(series):
    """Auto-detect seasonal period from ACF."""
    from statsmodels.tsa.stattools import acf
    acf_values = acf(series.dropna(), nlags=min(100, len(series) // 2))
    # Find first significant peak after lag 1
    peaks = []
    for i in range(2, len(acf_values) - 1):
        if acf_values[i] > acf_values[i-1] and acf_values[i] > acf_values[i+1]:
            peaks.append((i, acf_values[i]))
    
    if peaks:
        return max(peaks, key=lambda x: x[1])[0]
    return 7  # Default to weekly
```

### 5. RFM Segmentation with Automated Profiling

RFM (Recency, Frequency, Monetary) analysis segments customers by their purchasing behavior patterns.

```python
import pandas as pd
import numpy as np

def rfm_segmentation(
    df: pd.DataFrame,
    customer_id_col: str,
    transaction_date_col: str,
    transaction_amount_col: str,
    analysis_date: pd.Timestamp = None,
    n_quantiles: int = 5
) -> pd.DataFrame:
    """
    Perform RFM segmentation with automated profiling.
    
    Returns DataFrame with RFM scores, segment labels, and profiles.
    """
    if analysis_date is None:
        analysis_date = df[transaction_date_col].max() + pd.Timedelta(days=1)
    
    # Calculate RFM metrics
    rfm = df.groupby(customer_id_col).agg({
        transaction_date_col: lambda x: (analysis_date - x.max()).days,  # Recency
        transaction_amount_col: ['count', 'sum']  # Frequency, Monetary
    })
    
    rfm.columns = ['recency', 'frequency', 'monetary']
    rfm = rfm.reset_index()
    
    # Assign RFM scores (1-5, lower recency = higher score)
    rfm['R_score'] = pd.qcut(
        rfm['recency'], n_quantiles, 
        labels=range(n_quantiles, 0, -1),  # Lower recency = higher score
        duplicates='drop'
    )
    rfm['F_score'] = pd.qcut(
        rfm['frequency'].rank(method='first'), n_quantiles,
        labels=range(1, n_quantiles + 1),
        duplicates='drop'
    )
    rfm['M_score'] = pd.qcut(
        rfm['monetary'], n_quantiles,
        labels=range(1, n_quantiles + 1),
        duplicates='drop'
    )
    
    # Composite RFM score
    rfm['RFM_score'] = (
        rfm['R_score'].astype(int) * 100 + 
        rfm['F_score'].astype(int) * 10 + 
        rfm['M_score'].astype(int)
    )
    
    # Segment assignment
    def assign_segment(row):
        r, f, m = int(row['R_score']), int(row['F_score']), int(row['M_score'])
        if r >= 4 and f >= 4 and m >= 4:
            return 'Champions'
        elif r >= 3 and f >= 3:
            return 'Loyal Customers'
        elif r >= 4 and f <= 2:
            return 'New Customers'
        elif r >= 3 and f >= 1 and m >= 3:
            return 'Potential Loyalists'
        elif r <= 2 and f >= 3 and m >= 3:
            return 'At Risk'
        elif r <= 2 and f >= 4 and m >= 4:
            return 'Cant Lose Them'
        elif r <= 2 and f <= 2:
            return 'Lost'
        else:
            return 'Need Attention'
    
    rfm['segment'] = rfm.apply(assign_segment, axis=1)
    
    # Profile each segment
    profiles = rfm.groupby('segment').agg({
        'recency': ['mean', 'median'],
        'frequency': ['mean', 'median'],
        'monetary': ['mean', 'median', 'sum'],
        customer_id_col: 'count'
    }).round(2)
    
    profiles.columns = [
        'avg_recency', 'median_recency',
        'avg_frequency', 'median_frequency',
        'avg_monetary', 'median_monetary', 'total_monetary',
        'customer_count'
    ]
    profiles['pct_of_customers'] = (
        profiles['customer_count'] / profiles['customer_count'].sum() * 100
    ).round(1)
    profiles['pct_of_revenue'] = (
        profiles['total_monetary'] / profiles['total_monetary'].sum() * 100
    ).round(1)
    
    return rfm, profiles
```

### 6. PCA with Variance Interpretation and Loading Analysis

```python
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import numpy as np

def perform_pca_analysis(df, feature_cols, n_components=None, variance_threshold=0.95):
    """
    Perform PCA with comprehensive interpretation.
    """
    # Standardize features
    X = df[feature_cols].dropna()
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # Full PCA to determine components
    pca_full = PCA()
    pca_full.fit(X_scaled)
    
    # Determine number of components
    cumulative_variance = np.cumsum(pca_full.explained_variance_ratio_)
    if n_components is None:
        n_components = np.argmax(cumulative_variance >= variance_threshold) + 1
    
    # Fit with selected components
    pca = PCA(n_components=n_components)
    transformed = pca.fit_transform(X_scaled)
    
    # Analyze loadings
    loadings = pd.DataFrame(
        pca.components_.T,
        columns=[f'PC{i+1}' for i in range(n_components)],
        index=feature_cols
    )
    
    # Identify top contributors per component
    top_contributors = {}
    for pc in loadings.columns:
        top_features = loadings[pc].abs().nlargest(5)
        top_contributors[pc] = [
            (feat, loading) for feat, loading in top_features.items()
        ]
    
    return {
        "n_components": n_components,
        "explained_variance": pca.explained_variance_ratio_.tolist(),
        "cumulative_variance": cumulative_variance[:n_components].tolist(),
        "loadings": loadings,
        "top_contributors": top_contributors,
        "transformed_data": pd.DataFrame(
            transformed, 
            columns=[f'PC{i+1}' for i in range(n_components)],
            index=X.index
        )
    }
```

### 7. Cohort Analysis with Retention Curves

```python
import pandas as pd
import numpy as np

def cohort_retention_analysis(
    df: pd.DataFrame,
    user_col: str,
    date_col: str,
    cohort_period: str = 'M'  # 'W' for weekly, 'M' for monthly
) -> pd.DataFrame:
    """
    Build cohort retention table with period-over-period analysis.
    
    Parameters:
    - df: DataFrame with user interactions
    - user_col: column identifying users
    - date_col: column with interaction timestamps
    - cohort_period: 'W' for weekly, 'M' for monthly, 'Q' for quarterly
    """
    df = df.copy()
    df[date_col] = pd.to_datetime(df[date_col])
    
    # Assign cohort (first interaction period)
    user_cohort = df.groupby(user_col)[date_col].min().reset_index()
    user_cohort.columns = [user_col, 'cohort_date']
    user_cohort['cohort'] = user_cohort['cohort_date'].dt.to_period(cohort_period)
    
    df = df.merge(user_cohort[[user_col, 'cohort']], on=user_col, how='left')
    
    # Assign period number (months since cohort)
    df['period_number'] = (
        df[date_col].dt.to_period(cohort_period) - df['cohort']
    ).apply(lambda x: x.n)
    
    # Build cohort table
    cohort_table = df.groupby(['cohort', 'period_number'])[user_col].nunique().reset_index()
    cohort_table.columns = ['cohort', 'period_number', 'users']
    
    # Pivot to matrix
    cohort_matrix = cohort_table.pivot(
        index='cohort', 
        columns='period_number', 
        values='users'
    )
    
    # Convert to retention rates
    cohort_sizes = cohort_matrix[0]
    retention_matrix = cohort_matrix.divide(cohort_sizes, axis=0) * 100
    
    # Add summary statistics
    retention_matrix['avg_retention_m1'] = retention_matrix[1].mean()
    retention_matrix['avg_retention_m3'] = retention_matrix[3].mean()
    retention_matrix['avg_retention_m6'] = retention_matrix[6].mean()
    
    return retention_matrix.round(2)
```

---

## Common Patterns

### Pattern 1: Complete EDA Pipeline

```python
import pandas as pd
import numpy as np
from scipy import stats
import warnings
warnings.filterwarnings('ignore')

def comprehensive_eda(df: pd.DataFrame) -> dict:
    """Run comprehensive EDA on a dataframe."""
    report = {}
    
    # --- Shape and Types ---
    report['shape'] = df.shape
    report['dtypes'] = df.dtypes.value_counts().to_dict()
    report['memory_mb'] = df.memory_usage(deep=True).sum() / 1024**2
    
    # --- Missing Values ---
    missing = df.isnull().sum()
    missing_pct = (missing / len(df) * 100).round(2)
    report['missing'] = missing[missing > 0].to_dict()
    report['complete_rows_pct'] = (df.dropna().shape[0] / len(df) * 100).round(2)
    
    # --- Numeric Variables ---
    numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
    if numeric_cols:
        stats_df = df[numeric_cols].describe().T
        stats_df['skewness'] = df[numeric_cols].skew()
        stats_df['kurtosis'] = df[numeric_cols].kurtosis()
        stats_df['iqr'] = stats_df['75%'] - stats_df['25%']
        stats_df['outlier_pct'] = (
            (df[numeric_cols] < stats_df['25%'] - 1.5 * stats_df['iqr']) |
            (df[numeric_cols] > stats_df['75%'] + 1.5 * stats_df['iqr'])
        ).mean() * 100
        report['numeric_summary'] = stats_df.round(3)
    
    # --- Categorical Variables ---
    cat_cols = df.select_dtypes(include=['object', 'category']).columns.tolist()
    if cat_cols:
        cat_summary = {}
        for col in cat_cols:
            cat_summary[col] = {
                'unique': df[col].nunique(),
                'top_values': df[col].value_counts().head(5).to_dict(),
                'pct_top': (df[col].value_counts().iloc[0] / len(df) * 100).round(2)
            }
        report['categorical_summary'] = cat_summary
    
    # --- Correlations ---
    if len(numeric_cols) >= 2:
        corr_matrix = df[numeric_cols].corr(method='pearson')
        # Find strong correlations (excluding diagonal)
        strong_corrs = []
        for i in range(len(numeric_cols)):
            for j in range(i+1, len(numeric_cols)):
                if abs(corr_matrix.iloc[i, j]) > 0.5:
                    strong_corrs.append({
                        'var1': numeric_cols[i],
                        'var2': numeric_cols[j],
                        'correlation': corr_matrix.iloc[i, j].round(3)
                    })
        report['strong_correlations'] = sorted(
            strong_corrs, key=lambda x: abs(x['correlation']), reverse=True
        )
    
    # --- Statistical Tests for Normality ---
    if numeric_cols:
        normality = {}
        for col in numeric_cols[:10]:  # Limit to first 10
            sample = df[col].dropna()
            if len(sample) > 8:  # Shapiro needs at least 3
                stat, p = stats.shapiro(sample[:5000])  # Shapiro limited to 5000
                normality[col] = {
                    'shapiro_stat': stat.round(4),
                    'shapiro_p': p.round(4),
                    'is_normal': p > 0.05
                }
        report['normality_tests'] = normality
    
    return report

# Usage
# eda_report = comprehensive_eda(df)
# print(f"Shape: {eda_report['shape']}")
# print(f"Missing columns: {len(eda_report['missing'])}")
```

### Pattern 2: A/B Test Analysis with Confidence Intervals

```python
import numpy as np
from scipy import stats

def analyze_ab_test(
    control_data, treatment_data,
    alpha=0.05, metric_type='continuous'
):
    """
    Complete A/B test analysis with confidence intervals and effect sizes.
    """
    results = {}
    
    # Basic statistics
    results['control'] = {
        'n': len(control_data),
        'mean': np.mean(control_data),
        'std': np.std(control_data, ddof=1),
        'se': np.std(control_data, ddof=1) / np.sqrt(len(control_data))
    }
    results['treatment'] = {
        'n': len(treatment_data),
        'mean': np.mean(treatment_data),
        'std': np.std(treatment_data, ddof=1),
        'se': np.std(treatment_data, ddof=1) / np.sqrt(len(treatment_data))
    }
    
    # Absolute and relative lift
    results['absolute_diff'] = results['treatment']['mean'] - results['control']['mean']
    results['relative_lift'] = results['absolute_diff'] / results['control']['mean']
    
    # Statistical test
    if metric_type == 'continuous':
        stat, p_value = stats.ttest_ind(treatment_data, control_data, equal_var=False)
        results['test'] = "Welch's t-test"
    elif metric_type == 'proportion':
        # Z-test for proportions
        n1, n2 = len(control_data), len(treatment_data)
        p1, p2 = np.mean(control_data), np.mean(treatment_data)
        p_pool = (np.sum(control_data) + np.sum(treatment_data)) / (n1 + n2)
        se = np.sqrt(p_pool * (1 - p_pool) * (1/n1 + 1/n2))
        stat = (p2 - p1) / se
        p_value = 2 * (1 - stats.norm.cdf(abs(stat)))
        results['test'] = "Two-proportion Z-test"
    
    results['test_statistic'] = stat
    results['p_value'] = p_value
    results['is_significant'] = p_value < alpha
    
    # Effect size (Cohen's d)
    if metric_type == 'continuous':
        pooled_std = np.sqrt(
            (results['control']['std']**2 + results['treatment']['std']**2) / 2
        )
        cohens_d = results['absolute_diff'] / pooled_std
        results['effect_size'] = {
            'cohens_d': cohens_d,
            'interpretation': (
                'negligible' if abs(cohens_d) < 0.2 else
                'small' if abs(cohens_d) < 0.5 else
                'medium' if abs(cohens_d) < 0.8 else
                'large'
            )
        }
    
    # Confidence interval for difference
    se_diff = np.sqrt(results['control']['se']**2 + results['treatment']['se']**2)
    z_crit = stats.norm.ppf(1 - alpha/2)
    results['ci'] = {
        'lower': results['absolute_diff'] - z_crit * se_diff,
        'upper': results['absolute_diff'] + z_crit * se_diff,
        'confidence_level': 1 - alpha
    }
    
    # Power achieved
    achieved_power = 1 - stats.norm.cdf(
        abs(stat) - z_crit
    )
    results['achieved_power'] = achieved_power
    
    return results
```

### Pattern 3: Chi-Square Test for Categorical Associations

```python
from scipy.stats import chi2_contingency, fisher_exact
import pandas as pd

def test_categorical_association(df, col1, col2, alpha=0.05):
    """
    Test association between two categorical variables.
    Uses Fisher's exact test for small expected counts.
    """
    # Build contingency table
    contingency = pd.crosstab(df[col1], df[col2])
    
    # Check expected counts
    chi2, p_value, dof, expected = chi2_contingency(contingency)
    min_expected = expected.min()
    
    # Choose appropriate test
    if min_expected < 5:
        # Use Fisher's exact test (for 2x2 tables)
        if contingency.shape == (2, 2):
            odds_ratio, fisher_p = fisher_exact(contingency)
            test_name = "Fisher's exact test"
            p_value = fisher_p
        else:
            # For larger tables with small cells, warn
            test_name = "Chi-square (WARNING: low expected counts)"
    else:
        test_name = "Chi-square test"
        odds_ratio = None
    
    # Cramér's V for effect size
    n = contingency.sum().sum()
    min_dim = min(contingency.shape) - 1
    cramers_v = np.sqrt(chi2 / (n * min_dim)) if min_dim > 0 else 0
    
    return {
        'test': test_name,
        'chi2_statistic': chi2,
        'p_value': p_value,
        'dof': dof,
        'is_significant': p_value < alpha,
        'cramers_v': cramers_v,
        'effect_size': (
            'negligible' if cramers_v < 0.1 else
            'small' if cramers_v < 0.3 else
            'medium' if cramers_v < 0.5 else
            'large'
        ),
        'contingency_table': contingency,
        'expected_counts': pd.DataFrame(expected, index=contingency.index, columns=contingency.columns),
        'min_expected_count': min_expected
    }
```

### Pattern 4: Mann-Whitney U Test (Non-parametric)

```python
from scipy.stats import mannwhitneyu, wilcoxon, kruskal
import numpy as np

def nonparametric_group_comparison(groups, alpha=0.05):
    """
    Compare multiple groups using non-parametric tests.
    Automatically selects appropriate test based on number of groups.
    """
    results = {}
    
    if len(groups) == 2:
        # Two groups: Mann-Whitney U
        stat, p_value = mannwhitneyu(
            groups[0], groups[1], 
            alternative='two-sided'
        )
        
        # Effect size (rank-biserial correlation)
        n1, n2 = len(groups[0]), len(groups[1])
        r = 1 - (2 * stat) / (n1 * n2)
        
        results = {
            'test': 'Mann-Whitney U',
            'statistic': stat,
            'p_value': p_value,
            'is_significant': p_value < alpha,
            'effect_size': r,
            'effect_interpretation': (
                'negligible' if abs(r) < 0.1 else
                'small' if abs(r) < 0.3 else
                'medium' if abs(r) < 0.5 else
                'large'
            ),
            'group_medians': [np.median(g) for g in groups],
            'group_sizes': [len(g) for g in groups]
        }
        
    elif len(groups) > 2:
        # Multiple groups: Kruskal-Wallis
        stat, p_value = kruskal(*groups)
        
        # Effect size (epsilon-squared)
        k = len(groups)
        n = sum(len(g) for g in groups)
        epsilon_sq = (stat - k + 1) / (n - k)
        
        results = {
            'test': 'Kruskal-Wallis H',
            'statistic': stat,
            'p_value': p_value,
            'is_significant': p_value < alpha,
            'effect_size': epsilon_sq,
            'group_medians': [np.median(g) for g in groups],
            'group_sizes': [len(g) for g in groups]
        }
        
        # Post-hoc pairwise comparisons if significant
        if p_value < alpha:
            from itertools import combinations
            pairwise = []
            for i, j in combinations(range(k), 2):
                u_stat, u_p = mannwhitneyu(groups[i], groups[j], alternative='two-sided')
                # Bonferroni correction
                n_comparisons = k * (k - 1) / 2
                pairwise.append({
                    'groups': (i, j),
                    'u_statistic': u_stat,
                    'p_value': u_p,
                    'p_corrected': min(u_p * n_comparisons, 1.0),
                    'significant': u_p * n_comparisons < alpha
                })
            results['pairwise_comparisons'] = pairwise
    
    return results
```

### Pattern 5: Correlation Analysis with Significance Testing

```python
import numpy as np
import pandas as pd
from scipy import stats

def correlation_analysis(df, method='pearson', threshold=0.3):
    """
    Comprehensive correlation analysis with significance testing.
    """
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    n = len(numeric_cols)
    
    # Compute correlation matrix
    corr_matrix = df[numeric_cols].corr(method=method)
    
    # Compute p-values for each pair
    p_values = pd.DataFrame(np.ones((n, n)), index=numeric_cols, columns=numeric_cols)
    
    for i in range(n):
        for j in range(i+1, n):
            col_i, col_j = numeric_cols[i], numeric_cols[j]
            valid = df[[col_i, col_j]].dropna()
            
            if method == 'pearson':
                _, p = stats.pearsonr(valid[col_i], valid[col_j])
            elif method == 'spearman':
                _, p = stats.spearmanr(valid[col_i], valid[col_j])
            else:
                _, p = stats.kendalltau(valid[col_i], valid[col_j])
            
            p_values.iloc[i, j] = p
            p_values.iloc[j, i] = p
    
    # Extract significant correlations
    sig_correlations = []
    for i in range(n):
        for j in range(i+1, n):
            r = corr_matrix.iloc[i, j]
            p = p_values.iloc[i, j]
            if abs(r) >= threshold:
                sig_correlations.append({
                    'var1': numeric_cols[i],
                    'var2': numeric_cols[j],
                    'correlation': round(r, 4),
                    'p_value': round(p, 6),
                    'significant': p < 0.05,
                    'strength': (
                        'weak' if abs(r) < 0.3 else
                        'moderate' if abs(r) < 0.7 else
                        'strong'
                    )
                })
    
    sig_correlations.sort(key=lambda x: abs(x['correlation']), reverse=True)
    
    return {
        'correlation_matrix': corr_matrix,
        'p_values': p_values,
        'significant_correlations': sig_correlations,
        'method': method
    }
```

---

## Edge Cases & Pitfalls

### 1. Simpson's Paradox in Aggregated Data
**Problem:** A treatment appears beneficial overall but harmful in every subgroup.
**Solution:** Always stratify by known confounders before drawing causal conclusions. Visualize disaggregated data.

### 2. P-Hacking and Cherry-Picking
**Problem:** Trying multiple tests or subgroups until one shows p < 0.05, inflating false positive rates.
**Solution:** Pre-register hypotheses and analysis plans. Use Bonferroni or Benjamini-Hochberg correction for multiple comparisons.

### 3. Correlation Does Not Imply Causation
**Problem:** Assuming a statistically significant correlation implies a causal relationship.
**Solution:** Use causal inference methods (instrumental variables, difference-in-differences, propensity score matching) when causal claims are needed.

### 4. Multiple Testing Without Correction
**Problem:** Running 20 tests at α=0.05 produces ~1 false positive by chance.
**Solution:** Apply multiple testing correction: Bonferroni (conservative), Benjamini-Hochberg (FDR control), or Holm-Bonferroni (step-down).

### 5. Small Sample Size Illusions
**Problem:** With very small samples, outliers dominate, confidence intervals are enormous, and tests have virtually no power.
**Solution:** Always report sample sizes alongside p-values. Use exact tests (Fisher's) for small samples. Consider whether the analysis is even feasible.

### 6. Temporal Confounding in Time Series
**Problem:** Observing a correlation between two time series that are both trending, creating spurious correlation.
**Solution:** Detrend before correlating. Use differencing or compute correlations on residuals after removing trend and seasonality.

### 7. Survivorship Bias
**Problem:** Analyzing only entities that survived (e.g., successful companies, patients who completed treatment) and drawing biased conclusions.
**Solution:** Account for all entities that entered the cohort, including those that dropped out or failed.

### 8. Overfitting in Segmentation
**Problem:** Creating too many segments with too few users per segment, making each segment statistically unreliable.
**Solution:** Set minimum segment sizes. Use domain knowledge to limit the number of segments. Validate segments on holdout data.

### 9. Selection Bias in A/B Tests
**Problem:** Users self-select into treatment/control groups (e.g., opt-in experiments), breaking randomization.
**Solution:** Use intent-to-treat analysis. Verify randomization with balance checks on covariates.

### 10. Ignoring Non-normality When Using Parametric Tests
**Problem:** Applying t-tests or ANOVA to heavily skewed data without checking assumptions.
**Solution:** Check normality with Q-Q plots and Shapiro-Wilk tests. Use non-parametric alternatives (Mann-Whitney, Kruskal-Wallis) when assumptions are violated.

### 11. Ecological Fallacy
**Problem:** Drawing individual-level conclusions from aggregate-level data.
**Solution:** Analyze at the appropriate level of aggregation. Use multilevel/hierarchical models when data has nested structure.

### 12. Base Rate Neglect
**Problem:** Focusing on conditional probabilities while ignoring prior probabilities (e.g., interpreting test accuracy without considering disease prevalence).
**Solution:** Always report and consider base rates. Use Bayesian reasoning for diagnostic tests.

### 13. Multicollinearity in Regression
**Problem:** Highly correlated predictor variables inflate standard errors and make coefficients unstable.
**Solution:** Check VIF (Variance Inflation Factor). Remove or combine highly correlated features. Use PCA or regularization.

### 14. Over-interpreting R-squared
**Problem:** Assuming a high R² means the model is good or that all predictors are important.
**Solution:** Report adjusted R², check residual plots, and validate on test data. R² is descriptive, not causal.

### 15. Ignoring Effect Sizes
**Problem:** Reporting only p-values without effect sizes, making it impossible to judge practical significance.
**Solution:** Always report effect sizes alongside p-values: Cohen's d for means, η² for ANOVA, odds ratios for proportions, correlation coefficients for relationships.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **Data Cleaning** | Prerequisite | Data must be clean before analysis — handle missing values, outliers, duplicates |
| **Data Visualization** | Complement | Visualize distributions, correlations, and test results for interpretation |
| **Statistical Modeling** | Follow-up | Use EDA insights to inform model selection and feature engineering |
| **RAG Implementation** | Enhancement | Analyze retrieval quality metrics to optimize RAG pipeline parameters |
| **Technical Writing** | Output | Document analysis findings, methodology, and conclusions clearly |
| **Summarization** | Companion | Summarize complex statistical findings for non-technical stakeholders |
| **Machine Learning** | Downstream | Statistical analysis informs feature selection, model validation, and performance evaluation |
| **A/B Testing Platforms** | Integration | Connect with experimentation platforms for automated experiment analysis |

---

## Output Format Templates

### Standard Analysis Report

```markdown
## Data Analysis Report: {Analysis Title}

### Executive Summary
- **Key Finding:** {one_sentence_summary}
- **Confidence Level:** {high/medium/low}
- **Recommendation:** {actionable_recommendation}

### Dataset Overview
- **Source:** {data_source}
- **Period:** {date_range}
- **Sample Size:** {n} observations, {p} variables
- **Quality Score:** {completeness_pct}% complete

### Methodology
- **Analyses Performed:** {list_of_methods}
- **Significance Level:** α = {alpha}
- **Multiple Testing Correction:** {method if applicable}

### Key Results

| Metric | Value | 95% CI | p-value | Effect Size |
|--------|-------|--------|---------|-------------|
| {metric_1} | {value} | [{lower}, {upper}] | {p} | {d=0.X} |
| {metric_2} | {value} | [{lower}, {upper}] | {p} | {d=0.X} |

### Visualizations
- {figure_1_description}
- {figure_2_description}

### Limitations
- {limitation_1}
- {limitation_2}

### Recommendations
1. {recommendation_1}
2. {recommendation_2}
3. {recommendation_3}
```

### Quick Analysis Response

```markdown
## {Analysis Name}

**Result:** {concise_result_with_statistic}
**Significance:** {p_value} ({significant/not significant} at α={alpha})
**Effect Size:** {effect_size} ({interpretation})
**Sample:** n={sample_size}
**Caveat:** {one_line_limitation}
```

### Deep Dive Analysis

```markdown
## Deep Dive: {Topic}

### 1. Background and Hypotheses
- **H₀:** {null_hypothesis}
- **H₁:** {alternative_hypothesis}
- **Rationale:** {why_this_matters}

### 2. Data Description
{data_dictionary_and_summary_stats}

### 3. Exploratory Analysis
{EDA_findings_with_visualizations}

### 4. Statistical Tests
{test_results_with_assumptions_check}

### 5. Effect Sizes and Confidence Intervals
{effect_size_interpretation}

### 6. Sensitivity Analysis
{robustness_checks}

### 7. Conclusions
{conclusions_with_caveats}

### Appendix
{additional_results_and_code}
```

### Agent-Friendly Structured Output

```json
{
  "analysis_type": "{eda|ab_test|cohort|clustering|time_series}",
  "dataset": {
    "n_rows": 10000,
    "n_columns": 15,
    "date_range": ["2024-01-01", "2024-06-30"],
    "completeness_pct": 94.5
  },
  "results": {
    "primary_metric": {
      "name": "conversion_rate",
      "control": 0.102,
      "treatment": 0.118,
      "absolute_lift": 0.016,
      "relative_lift": 0.157,
      "p_value": 0.003,
      "ci_95": [0.005, 0.027],
      "cohens_d": 0.12,
      "power": 0.89
    }
  },
  "warnings": [
    "Small effect size despite statistical significance",
    "Novelty effect possible in first 7 days"
  ],
  "recommendations": [
    "Ship treatment variant to 100% of traffic",
    "Monitor for novelty effect decay over 30 days"
  ]
}
```

---

## Rules

1. **Always check assumptions before running parametric tests** — Verify normality, homogeneity of variances, and independence. Use non-parametric alternatives when assumptions are violated.
2. **Report effect sizes, not just p-values** — Statistical significance is meaningless without practical significance. Always include Cohen's d, η², odds ratios, or correlation coefficients.
3. **Pre-register hypotheses before exploratory analysis** — Separate confirmatory from exploratory analysis. Apply multiple testing correction to exploratory results.
4. **Never claim causation from observational data without causal methods** — Correlation is not causation. Use RCTs, instrumental variables, or difference-in-differences for causal claims.
5. **Always report sample sizes** — A p-value from n=10 is vastly less reliable than from n=10,000. Sample size is essential context for interpreting results.
6. **Check for Simpson's paradox** — Before aggregating data, verify that trends don't reverse when disaggregated by confounders.
7. **Use appropriate sample sizes for A/B tests** — Run power analysis before starting experiments. Underpowered experiments waste resources; overpowered experiments detect trivial effects.
8. **Validate A/B test randomization** — Check that treatment and control groups are balanced on key covariates before analyzing results.
9. **Account for multiple comparisons** — When running multiple tests, apply Benjamini-Hochberg or Bonferroni correction to control family-wise error rate or FDR.
10. **Visualize before computing** — Always plot distributions, scatter plots, and time series before running statistical tests. Many insights come from visualization alone.
11. **Use robust methods when outliers are present** — Median is more robust than mean. Mann-Whitney is more robust than t-test. Winsorize or trim extreme values when appropriate.
12. **Document your analytical decisions** — Record every test run, every transformation applied, and every hypothesis tested (including those that didn't reach significance).
13. **Validate clustering stability** — Run clustering multiple times with different initializations. Check silhouette scores. Validate that clusters are interpretable and actionable.
14. **Don't over-interpret R²** — High R² doesn't mean the model is causal or that all predictors matter. Check residuals, test for multicollinearity, and validate on holdout data.
15. **Always consider practical significance alongside statistical significance** — A statistically significant result with a tiny effect size may not warrant action. Cost-benefit analysis should inform decisions.
