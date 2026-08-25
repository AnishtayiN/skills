---
name: data-analysis
description: >-
  Analyze datasets, compute statistics, draw charts, and extract insights from data. Use this skill whenever the user mentions analyzing data, data analysis, extract insights from data, draw chart from data, explore dataset, summarize data, find patterns in data, compute correlations, statistical analysis, visualize data, create plots, generate charts, compare datasets, find outliers, trend analysis, descriptive statistics, exploratory data analysis (EDA), pivot tables, group-by analysis, data profiling, data summary, frequency analysis, distribution analysis, hypothesis testing, regression analysis, time series analysis, clustering analysis, anomaly detection, A/B testing, statistical tests, interactive plots, geospatial analysis, automated reporting, or says تحلیل داده، تحلیل آماری، نمودار کشیدن، استخراج بینش از داده، بررسی مجموعه داده، رسم نمودار، آمار توصیفی، تحلیل روند، ناهنجاری در داده.
---

# Data Analysis Skill — Comprehensive Dataset Exploration, Statistics & Visualization

## Overview

This skill enables thorough analysis of datasets regardless of format. The goal is to go from raw data to actionable insights: understand what the data contains, compute meaningful statistics, identify patterns and outliers, and produce clear visualizations. This guide covers descriptive statistics, hypothesis testing, regression analysis, time series analysis, clustering, anomaly detection, A/B testing, advanced visualization, and automated reporting.

## When to Use This Skill

- User wants to understand or summarize a dataset
- User asks for statistics, correlations, distributions, or trends
- User wants charts, plots, or visualizations from their data
- User wants to compare groups, find outliers, or detect anomalies
- User says "analyze this data" or "what can you tell me about this file"
- User needs exploratory data analysis (EDA) before modeling
- User mentions time series, forecasting, decomposition, stationarity
- User asks about clustering, classification, or segmentation
- User wants A/B testing analysis or statistical significance
- User needs interactive or geospatial visualizations
- User mentions تحلیل داده or آمار توصیفی

## Analysis Workflow

### Step 1: Identify and Load the Data

1. **Locate the data file** — Ask the user for the file path if not provided. Support CSV, TSV, Excel (.xlsx/.xls), JSON, Parquet, SQL databases.
2. **Read the data** — Use pandas (Python) or the xlsx skill for spreadsheets. For large files, read a sample first to understand structure.
3. **Confirm basic shape** — Report rows, columns, and file size to the user so they know you've loaded the right thing.

```python
import pandas as pd
import numpy as np

# Load data
df = pd.read_csv("data.csv")  # or pd.read_excel, pd.read_json, etc.

# Basic shape
print(f"Shape: {df.shape}")
print(f"File size: {df.memory_usage(deep=True).sum() / 1024:.2f} KB")
```

### Step 2: Profile the Dataset

Generate a comprehensive data profile before any analysis:

| Check | What to Report |
|-------|---------------|
| Column names & types | dtype per column, categorical vs numeric |
| Missing values | Count and percentage per column |
| Unique values | For categorical columns, count of distinct values |
| Numeric ranges | Min, max, mean, median, std for each numeric column |
| Sample rows | First 5 rows as a preview |
| Correlations | Pearson/Spearman correlation matrix |
| Distributions | Skewness, kurtosis for numeric columns |
| Memory usage | Memory footprint per column |

```python
def comprehensive_profile(df):
    """Generate a comprehensive data profile."""
    print("=" * 60)
    print("DATA PROFILE")
    print("=" * 60)
    
    # Basic info
    print(f"\nShape: {df.shape}")
    print(f"Memory usage: {df.memory_usage(deep=True).sum() / 1024:.2f} KB")
    
    # Data types
    print("\nData Types:")
    print(df.dtypes.value_counts())
    
    # Missing values
    missing = df.isnull().sum()
    missing_pct = (missing / len(df) * 100).round(2)
    missing_df = pd.DataFrame({
        'Missing Count': missing,
        'Missing %': missing_pct
    })
    print("\nMissing Values:")
    print(missing_df[missing_df['Missing Count'] > 0])
    
    # Numeric statistics
    print("\nNumeric Statistics:")
    print(df.describe())
    
    # Categorical summary
    cat_cols = df.select_dtypes(include=['object', 'category']).columns
    print(f"\nCategorical Columns: {len(cat_cols)}")
    for col in cat_cols[:5]:  # Show first 5
        print(f"  {col}: {df[col].nunique()} unique values")
    
    # Correlations
    numeric_df = df.select_dtypes(include=[np.number])
    if len(numeric_df.columns) > 1:
        print("\nCorrelation Matrix:")
        print(numeric_df.corr().round(2))
```

### Step 3: Answer the User's Question

Align your analysis with what the user actually asked for:

- **"Summarize" / "Explore"** → Full EDA: distributions (histograms), correlations (heatmap), group-by summaries
- **"Find patterns"** → Correlation matrix, scatter plots, clustering hints
- **"Compare"** → Group-by statistics with significance tests, side-by-side box plots
- **"Find outliers"** → Z-score or IQR method, flag specific rows
- **"Trend"** → Time-series decomposition, rolling averages, line charts
- **"Relationship"** → Scatter plots with regression lines, correlation coefficients
- **"Forecast"** → ARIMA, exponential smoothing, Prophet
- **"Segment"** → Clustering analysis (K-means, DBSCAN, hierarchical)
- **"A/B test"** → Statistical significance, confidence intervals, power analysis

### Step 4: Compute Statistics

#### Descriptive Statistics

```python
def descriptive_statistics(df, numeric_cols=None):
    """Compute comprehensive descriptive statistics."""
    if numeric_cols is None:
        numeric_cols = df.select_dtypes(include=[np.number]).columns
    
    results = {}
    for col in numeric_cols:
        results[col] = {
            'mean': df[col].mean(),
            'median': df[col].median(),
            'mode': df[col].mode().iloc[0] if not df[col].mode().empty else None,
            'std': df[col].std(),
            'variance': df[col].var(),
            'skewness': df[col].skew(),
            'kurtosis': df[col].kurtosis(),
            'min': df[col].min(),
            'max': df[col].max(),
            'range': df[col].max() - df[col].min(),
            'iqr': df[col].quantile(0.75) - df[col].quantile(0.25),
            'cv': df[col].std() / df[col].mean() if df[col].mean() != 0 else np.nan,
            'q25': df[col].quantile(0.25),
            'q75': df[col].quantile(0.75),
            'skew_interpretation': 'symmetric' if abs(df[col].skew()) < 0.5 else 
                                   'right-skewed' if df[col].skew() > 0 else 'left-skewed'
        }
    
    return pd.DataFrame(results).T
```

#### Hypothesis Testing

| Test | When to Use | Assumptions | Python Function |
|------|-------------|-------------|-----------------|
| **t-test (independent)** | Compare means of 2 independent groups | Normal distribution, equal variances | `scipy.stats.ttest_ind()` |
| **t-test (paired)** | Compare means of same group at different times | Normal distribution of differences | `scipy.stats.ttest_rel()` |
| **Mann-Whitney U** | Compare distributions of 2 independent groups (non-parametric) | Ordinal data, no normality assumption | `scipy.stats.mannwhitneyu()` |
| **Wilcoxon signed-rank** | Compare distributions of paired samples (non-parametric) | Symmetric distribution of differences | `scipy.stats.wilcoxon()` |
| **ANOVA** | Compare means of 3+ independent groups | Normal distribution, equal variances | `scipy.stats.f_oneway()` |
| **Kruskal-Wallis** | Compare distributions of 3+ independent groups (non-parametric) | Ordinal data, no normality assumption | `scipy.stats.kruskal()` |
| **Chi-squared** | Test association between 2 categorical variables | Expected frequency ≥ 5 | `scipy.stats.chi2_contingency()` |
| **Fisher's Exact** | Test association in 2x2 contingency table (small samples) | 2x2 table, small sample size | `scipy.stats.fisher_exact()` |
| **Pearson correlation** | Linear relationship between 2 continuous variables | Linear relationship, normal distribution | `scipy.stats.pearsonr()` |
| **Spearman correlation** | Monotonic relationship between 2 variables | Ordinal data, monotonic relationship | `scipy.stats.spearmanr()` |

```python
from scipy import stats

def comprehensive_hypothesis_tests(df, group_col, value_col):
    """Run comprehensive hypothesis tests."""
    groups = df[group_col].unique()
    results = {}
    
    # Check normality first
    for group in groups:
        group_data = df[df[group_col] == group][value_col].dropna()
        stat, p_value = stats.shapiro(group_data[:5000])  # Shapiro limited to 5000
        results[f'{group}_normality'] = {
            'test': 'Shapiro-Wilk',
            'statistic': stat,
            'p_value': p_value,
            'normal': p_value > 0.05
        }
    
    # Choose appropriate test based on normality
    all_normal = all(r['normal'] for r in results.values() 
                     if 'normality' in str(r))
    
    if len(groups) == 2:
        if all_normal:
            # Independent t-test
            group1 = df[df[group_col] == groups[0]][value_col].dropna()
            group2 = df[df[group_col] == groups[1]][value_col].dropna()
            stat, p_value = stats.ttest_ind(group1, group2)
            results['main_test'] = {
                'test': 'Independent t-test',
                'statistic': stat,
                'p_value': p_value,
                'significant': p_value < 0.05
            }
        else:
            # Mann-Whitney U
            group1 = df[df[group_col] == groups[0]][value_col].dropna()
            group2 = df[df[group_col] == groups[1]][value_col].dropna()
            stat, p_value = stats.mannwhitneyu(group1, group2)
            results['main_test'] = {
                'test': 'Mann-Whitney U',
                'statistic': stat,
                'p_value': p_value,
                'significant': p_value < 0.05
            }
    else:
        if all_normal:
            # One-way ANOVA
            group_data = [df[df[group_col] == g][value_col].dropna() for g in groups]
            stat, p_value = stats.f_oneway(*group_data)
            results['main_test'] = {
                'test': 'One-way ANOVA',
                'statistic': stat,
                'p_value': p_value,
                'significant': p_value < 0.05
            }
        else:
            # Kruskal-Wallis
            group_data = [df[df[group_col] == g][value_col].dropna() for g in groups]
            stat, p_value = stats.kruskal(*group_data)
            results['main_test'] = {
                'test': 'Kruskal-Wallis',
                'statistic': stat,
                'p_value': p_value,
                'significant': p_value < 0.05
            }
    
    return results
```

#### Regression Analysis

```python
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression

def linear_regression_analysis(df, x_cols, y_col):
    """Comprehensive linear regression analysis."""
    X = df[x_cols].dropna()
    y = df.loc[X.index, y_col]
    
    # Add constant for intercept
    X_with_const = sm.add_constant(X)
    
    # Fit model
    model = sm.OLS(y, X_with_const).fit()
    
    results = {
        'r_squared': model.rsquared,
        'adj_r_squared': model.rsquared_adj,
        'f_statistic': model.fvalue,
        'f_p_value': model.f_pvalue,
        'coefficients': model.params.to_dict(),
        'p_values': model.pvalues.to_dict(),
        'confidence_intervals': model.conf_int().to_dict(),
        'residuals': model.resid,
        'predictions': model.fittedvalues
    }
    
    return results, model
```

### Step 5: Time Series Analysis

#### Decomposition

```python
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller, acf, pacf

def time_series_analysis(series, period=None):
    """Comprehensive time series analysis."""
    results = {}
    
    # Stationarity test (ADF)
    adf_result = adfuller(series.dropna())
    results['stationarity'] = {
        'test': 'Augmented Dickey-Fuller',
        'statistic': adf_result[0],
        'p_value': adf_result[1],
        'critical_values': adf_result[4],
        'stationary': adf_result[1] < 0.05
    }
    
    # Decomposition
    if period is None:
        # Try to detect period
        period = detect_seasonal_period(series)
    
    if period and len(series) >= 2 * period:
        decomposition = seasonal_decompose(series, model='additive', period=period)
        results['decomposition'] = {
            'trend': decomposition.trend,
            'seasonal': decomposition.seasonal,
            'residual': decomposition.resid
        }
    
    # Autocorrelation
    acf_values = acf(series.dropna(), nlags=min(40, len(series)//2 - 1))
    pacf_values = pacf(series.dropna(), nlags=min(40, len(series)//2 - 1))
    results['acf'] = acf_values
    results['pacf'] = pacf_values
    
    # Basic statistics
    results['stats'] = {
        'mean': series.mean(),
        'std': series.std(),
        'min': series.min(),
        'max': series.max(),
        'trend': 'increasing' if series.iloc[-1] > series.iloc[0] else 'decreasing'
    }
    
    return results

def detect_seasonal_period(series):
    """Detect seasonal period from autocorrelation."""
    from scipy.signal import find_peaks
    acf_values = acf(series.dropna(), nlags=min(100, len(series)//2 - 1))
    peaks, _ = find_peaks(acf_values[1:], distance=5)
    if len(peaks) > 0:
        return peaks[0] + 1  # +1 because we skipped lag 0
    return None
```

#### Forecasting

```python
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.holtwinters import ExponentialSmoothing

def forecast_time_series(series, method='arima', steps=30, **kwargs):
    """Forecast time series using specified method."""
    if method == 'arima':
        order = kwargs.get('order', (1, 1, 1))
        model = ARIMA(series, order=order)
        fitted = model.fit()
        forecast = fitted.forecast(steps=steps)
        return forecast, fitted
    
    elif method == 'exponential_smoothing':
        model = ExponentialSmoothing(
            series,
            trend=kwargs.get('trend', 'add'),
            seasonal=kwargs.get('seasonal', None),
            seasonal_periods=kwargs.get('seasonal_periods', None)
        )
        fitted = model.fit()
        forecast = fitted.forecast(steps=steps)
        return forecast, fitted
```

### Step 6: Clustering Analysis

```python
from sklearn.cluster import KMeans, DBSCAN, AgglomerativeClustering
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score
from sklearn.decomposition import PCA

def clustering_analysis(df, n_clusters_range=(2, 10), method='kmeans'):
    """Comprehensive clustering analysis."""
    # Prepare data
    numeric_df = df.select_dtypes(include=[np.number]).dropna()
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(numeric_df)
    
    results = {}
    
    if method == 'kmeans':
        # Find optimal K using elbow method and silhouette
        inertias = []
        silhouette_scores = []
        
        for k in range(n_clusters_range[0], n_clusters_range[1] + 1):
            kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
            labels = kmeans.fit_predict(scaled_data)
            inertias.append(kmeans.inertia_)
            silhouette_scores.append(silhouette_score(scaled_data, labels))
        
        # Find optimal K (highest silhouette score)
        optimal_k = range(n_clusters_range[0], n_clusters_range[1] + 1)[
            np.argmax(silhouette_scores)
        ]
        
        # Final clustering with optimal K
        final_kmeans = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
        final_labels = final_kmeans.fit_predict(scaled_data)
        
        results = {
            'optimal_k': optimal_k,
            'inertias': inertias,
            'silhouette_scores': silhouette_scores,
            'labels': final_labels,
            'centers': final_kmeans.cluster_centers_,
            'silhouette': silhouette_score(scaled_data, final_labels)
        }
    
    elif method == 'dbscan':
        # DBSCAN with automatic eps estimation
        from sklearn.neighbors import NearestNeighbors
        nn = NearestNeighbors(n_neighbors=5)
        nn.fit(scaled_data)
        distances, _ = nn.kneighbors(scaled_data)
        eps = np.percentile(distances[:, -1], 90)
        
        dbscan = DBSCAN(eps=eps, min_samples=5)
        labels = dbscan.fit_predict(scaled_data)
        
        results = {
            'labels': labels,
            'n_clusters': len(set(labels)) - (1 if -1 in labels else 0),
            'n_noise': list(labels).count(-1),
            'eps': eps
        }
    
    # PCA for visualization
    pca = PCA(n_components=2)
    pca_result = pca.fit_transform(scaled_data)
    results['pca'] = pca_result
    results['pca_explained_variance'] = pca.explained_variance_ratio_
    
    return results
```

### Step 7: Anomaly Detection

```python
from sklearn.ensemble import IsolationForest
from sklearn.svm import OneClassSVM
from scipy import stats

def anomaly_detection(df, method='isolation_forest', contamination=0.05):
    """Detect anomalies using various methods."""
    numeric_df = df.select_dtypes(include=[np.number]).dropna()
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(numeric_df)
    
    results = {}
    
    if method == 'isolation_forest':
        clf = IsolationForest(contamination=contamination, random_state=42)
        labels = clf.fit_predict(scaled_data)
        scores = clf.decision_function(scaled_data)
        
        results = {
            'method': 'Isolation Forest',
            'anomaly_labels': labels,  # -1 for anomalies, 1 for normal
            'anomaly_scores': scores,
            'n_anomalies': (labels == -1).sum(),
            'anomaly_percentage': (labels == -1).sum() / len(labels) * 100
        }
    
    elif method == 'zscore':
        z_scores = np.abs(stats.zscore(scaled_data))
        anomaly_mask = (z_scores > 3).any(axis=1)
        
        results = {
            'method': 'Z-Score',
            'anomaly_labels': np.where(anomaly_mask, -1, 1),
            'anomaly_scores': z_scores.max(axis=1),
            'n_anomalies': anomaly_mask.sum(),
            'anomaly_percentage': anomaly_mask.sum() / len(anomaly_mask) * 100
        }
    
    elif method == 'iqr':
        Q1 = numeric_df.quantile(0.25)
        Q3 = numeric_df.quantile(0.75)
        IQR = Q3 - Q1
        outlier_mask = ((numeric_df < (Q1 - 1.5 * IQR)) | 
                       (numeric_df > (Q3 + 1.5 * IQR))).any(axis=1)
        
        results = {
            'method': 'IQR',
            'anomaly_labels': np.where(outlier_mask, -1, 1),
            'n_anomalies': outlier_mask.sum(),
            'anomaly_percentage': outlier_mask.sum() / len(outlier_mask) * 100
        }
    
    return results
```

### Step 8: A/B Testing Analysis

```python
def ab_test_analysis(control, treatment, alpha=0.05):
    """Comprehensive A/B test analysis."""
    from scipy import stats
    
    results = {}
    
    # Basic statistics
    results['control'] = {
        'n': len(control),
        'mean': np.mean(control),
        'std': np.std(control),
        'se': np.std(control) / np.sqrt(len(control))
    }
    results['treatment'] = {
        'n': len(treatment),
        'mean': np.mean(treatment),
        'std': np.std(treatment),
        'se': np.std(treatment) / np.sqrt(len(treatment))
    }
    
    # Effect size (Cohen's d)
    pooled_std = np.sqrt(
        ((len(control) - 1) * results['control']['std']**2 + 
         (len(treatment) - 1) * results['treatment']['std']**2) /
        (len(control) + len(treatment) - 2)
    )
    results['effect_size'] = (results['treatment']['mean'] - 
                             results['control']['mean']) / pooled_std
    
    # Statistical test
    t_stat, p_value = stats.ttest_ind(control, treatment)
    results['t_test'] = {
        't_statistic': t_stat,
        'p_value': p_value,
        'significant': p_value < alpha
    }
    
    # Confidence interval for difference in means
    diff = results['treatment']['mean'] - results['control']['mean']
    se_diff = np.sqrt(results['control']['se']**2 + results['treatment']['se']**2)
    ci_lower = diff - stats.t.ppf(1 - alpha/2, len(control) + len(treatment) - 2) * se_diff
    ci_upper = diff + stats.t.ppf(1 - alpha/2, len(control) + len(treatment) - 2) * se_diff
    results['confidence_interval'] = {
        'lower': ci_lower,
        'upper': ci_upper,
        'alpha': alpha
    }
    
    # Power analysis
    from statsmodels.stats.power import TTestIndPower
    power_analysis = TTestIndPower()
    power = power_analysis.power(
        effect_size=results['effect_size'],
        nobs1=len(control),
        ratio=len(treatment)/len(control),
        alpha=alpha
    )
    results['power'] = power
    
    # Interpretation
    if p_value < alpha:
        results['interpretation'] = (
            f"The difference is statistically significant (p={p_value:.4f}). "
            f"The treatment group {'outperformed' if diff > 0 else 'underperformed'} "
            f"the control group by {abs(diff):.4f}."
        )
    else:
        results['interpretation'] = (
            f"The difference is not statistically significant (p={p_value:.4f}). "
            f"No conclusion can be drawn about which group is better."
        )
    
    return results
```

### Step 9: Create Visualizations

#### Basic Visualization Patterns

```python
import matplotlib.pyplot as plt
import seaborn as sns

def create_visualizations(df):
    """Create comprehensive visualizations."""
    # Set style
    sns.set_style("whitegrid")
    plt.rcParams['figure.figsize'] = (12, 8)
    plt.rcParams['font.size'] = 12
    
    # 1. Distribution plots
    numeric_cols = df.select_dtypes(include=[np.number]).columns[:4]
    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    for i, col in enumerate(numeric_cols):
        ax = axes[i // 2, i % 2]
        sns.histplot(df[col], kde=True, ax=ax)
        ax.set_title(f'Distribution of {col}')
    plt.tight_layout()
    plt.savefig('distributions.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    # 2. Correlation heatmap
    corr_matrix = df.select_dtypes(include=[np.number]).corr()
    plt.figure(figsize=(10, 8))
    sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', center=0, 
                fmt='.2f', square=True)
    plt.title('Correlation Matrix')
    plt.savefig('correlation_matrix.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    # 3. Box plots
    plt.figure(figsize=(12, 6))
    df.boxplot()
    plt.title('Box Plots')
    plt.xticks(rotation=45)
    plt.savefig('boxplots.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    # 4. Scatter plot matrix
    sns.pairplot(df[numeric_cols].dropna(), diag_kind='kde')
    plt.savefig('pairplot.png', dpi=300, bbox_inches='tight')
    plt.close()
```

#### Advanced Visualization Patterns

##### Faceted Plots

```python
def faceted_analysis(df, cat_col, num_col, facet_col):
    """Create faceted plots for multi-dimensional analysis."""
    g = sns.FacetGrid(df, col=facet_col, col_wrap=3, height=4)
    g.map_dataframe(sns.histplot, x=num_col, hue=cat_col, kde=True)
    g.set_titles(col_template="{col_name}")
    g.set_axis_labels(num_col, "Count")
    plt.savefig('faceted_analysis.png', dpi=300, bbox_inches='tight')
    plt.close()
```

##### Interactive Plots

```python
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

def interactive_scatter(df, x_col, y_col, color_col=None):
    """Create interactive scatter plot."""
    fig = px.scatter(
        df, x=x_col, y=y_col, color=color_col,
        hover_data=df.columns.tolist(),
        title=f"{y_col} vs {x_col}",
        template="plotly_white"
    )
    fig.update_layout(height=600, width=800)
    fig.write_html("interactive_scatter.html")
    return fig

def interactive_time_series(df, date_col, value_col, group_col=None):
    """Create interactive time series plot."""
    fig = px.line(
        df, x=date_col, y=value_col, color=group_col,
        title=f"{value_col} over Time",
        template="plotly_white"
    )
    fig.update_layout(height=500, width=1000)
    fig.write_html("interactive_timeseries.html")
    return fig
```

##### Geospatial Plots

```python
import plotly.express as px

def geospatial_analysis(df, lat_col, lon_col, value_col, color_col=None):
    """Create geospatial visualization."""
    fig = px.scatter_mapbox(
        df, lat=lat_col, lon=lon_col, color=color_col,
        size=value_col if value_col else None,
        hover_name=df.index,
        mapbox_style="open-street-map",
        zoom=3,
        height=600
    )
    fig.update_layout(title="Geospatial Analysis")
    fig.write_html("geospatial_analysis.html")
    return fig
```

#### Visualization Best Practices

| Chart Type | Best For | When to Use |
|-----------|----------|-------------|
| Histogram / KDE | Distribution of a single numeric variable | Understanding data distribution |
| Box plot | Distribution comparison across groups, outlier detection | Comparing multiple groups |
| Violin plot | Distribution shape + density | When you need distribution details |
| Scatter plot | Relationship between two numeric variables | Correlation analysis |
| Heatmap | Correlation matrix, cross-tabulation | Multi-variable relationships |
| Bar chart | Category frequencies, group comparisons | Categorical comparisons |
| Line chart | Trends over time or ordered sequences | Time series, sequential data |
| Pie chart | Proportions (only when <7 categories) | Simple proportions |
| Pair plot | Overview of multiple numeric relationships | Multi-variable EDA |
| Faceted plots | Multi-dimensional analysis | When you have multiple categorical variables |
| Interactive plots | Exploration, presentations | When users need to explore data |
| Geospatial plots | Location-based data | Geographic analysis |

Chart rules:
- Always label axes and add a title
- Use readable font sizes (minimum 10pt)
- Choose colorblind-friendly palettes (e.g., `viridis`, `Set2`, `colorblind`)
- If there are too many categories (>15), show only top N and group the rest as "Other"
- For time series, always use line charts, not bar charts
- Avoid 3D charts unless absolutely necessary

### Step 10: Automated Reporting

```python
def generate_analysis_report(df, output_file="analysis_report.html"):
    """Generate automated analysis report."""
    from jinja2 import Template
    
    # Perform analysis
    profile = comprehensive_profile(df)
    
    # Create report
    report_template = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Data Analysis Report</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            h1 { color: #2c3e50; }
            h2 { color: #34495e; border-bottom: 2px solid #3498db; }
            table { border-collapse: collapse; width: 100%; margin: 20px 0; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #3498db; color: white; }
            .metric { background-color: #ecf0f1; padding: 10px; margin: 10px 0; }
            .insight { background-color: #d5f5e3; padding: 10px; margin: 10px 0; }
        </style>
    </head>
    <body>
        <h1>Data Analysis Report</h1>
        
        <h2>Dataset Overview</h2>
        <div class="metric">
            <p><strong>Shape:</strong> {{ shape }}</p>
            <p><strong>Missing Values:</strong> {{ missing_pct }}%</p>
            <p><strong>Columns:</strong> {{ columns }}</p>
        </div>
        
        <h2>Key Statistics</h2>
        {{ stats_table }}
        
        <h2>Insights</h2>
        {{ insights }}
        
        <h2>Visualizations</h2>
        {{ charts }}
    </body>
    </html>
    """
    
    template = Template(report_template)
    
    # Generate HTML
    html = template.render(
        shape=f"{df.shape[0]} rows × {df.shape[1]} columns",
        missing_pct=f"{(df.isnull().sum().sum() / df.size * 100):.2f}",
        columns=", ".join(df.columns.tolist()),
        stats_table=profile.to_html(),
        insights="<ul><li>Sample insight</li></ul>",
        charts="<p>Charts saved as PNG files</p>"
    )
    
    with open(output_file, 'w') as f:
        f.write(html)
    
    return output_file
```

### Step 11: Synthesize Findings

End with a concise summary section:

```
## Key Findings

1. [Most important insight]
2. [Second most important]
3. [Notable anomaly or surprise]
4. [Recommendation or next step, if applicable]
```

Always provide:
- **Statistical significance** — Report p-values and confidence intervals
- **Practical significance** — Report effect sizes, not just p-values
- **Limitations** — Note sample size, missing data, assumptions violated
- **Recommendations** — Actionable next steps based on findings

## Output Format

- Write a Python script that performs the full analysis and saves charts to files
- Run the script using the Bash tool
- Present results in the user's language with:
  - A **Data Profile** section (structure, types, missing values)
  - A **Statistics** section with a summary table
  - **Charts** saved as PNG files, referenced in the response
  - A **Key Findings** section with numbered insights
  - **Statistical Tests** results with interpretations
  - **Recommendations** for next steps
  - If the user's language is not English, write the narrative in their language but keep code, column names, and technical terms in English

## Tools & Libraries

- **pandas** — data loading, manipulation, group-by, aggregation
- **numpy** — numeric operations
- **scipy.stats** — statistical tests (t-test, ANOVA, chi-squared, Mann-Whitney, Kruskal-Wallis, Wilcoxon, Fisher's Exact)
- **statsmodels** — regression, time series analysis, hypothesis testing
- **scikit-learn** — clustering, anomaly detection, scaling, PCA
- **matplotlib / seaborn** — static chart generation
- **plotly** — interactive visualizations
- **jinja2** — automated report generation
- Use the **xlsx** skill for Excel file inputs
- Use the **charts** skill if the user needs publication-quality or interactive visualizations

## Common Pitfalls to Avoid

- **Don't skip the data profile.** Analyzing without understanding structure leads to wrong conclusions.
- **Don't show every possible chart.** Pick the 2-4 charts that directly answer the user's question.
- **Don't ignore missing data.** Report it clearly; let the user decide whether to exclude or impute.
- **Don't over-interpret noise.** Not every correlation is meaningful. Note sample sizes.
- **Don't assume normality.** Check distributions before using parametric tests.
- **Don't use parametric tests on ordinal data.** Use non-parametric alternatives.
- **Don't forget about multiple comparisons.** Apply Bonferroni correction when running many tests.
- **Don't confuse statistical significance with practical significance.** A tiny effect can be statistically significant with large samples.
- **Don't ignore confounding variables.** They can create spurious correlations.
- **Don't forget to validate assumptions.** Check normality, homoscedasticity, independence.
