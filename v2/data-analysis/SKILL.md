---
name: data-analysis
description: >-
  Analyze datasets, compute statistics, draw charts, and extract insights from data.
  Use this skill whenever the user mentions analyzing data, data analysis, extract insights from data,
  draw chart from data, explore dataset, summarize data, find patterns in data, compute correlations,
  statistical analysis, visualize data, create plots, generate charts, compare datasets, find outliers,
  trend analysis, descriptive statistics, exploratory data analysis (EDA), pivot tables, group-by analysis,
  data profiling, data summary, frequency analysis, distribution analysis, hypothesis testing,
  regression analysis, segment analysis, cohort analysis, funnel analysis, retention analysis,
  A/B test analysis, RFM analysis, customer segmentation, market basket analysis,
  time series decomposition, seasonality detection, moving averages, exponential smoothing,
  statistical significance, confidence intervals, p-value interpretation, effect size,
  ANOVA, chi-square test, t-test, Mann-Whitney U test, Kruskal-Wallis test,
  principal component analysis (PCA), factor analysis, clustering interpretation,
  cross-tabulation, contingency tables, data drill-down, slice and dice data,
  KPI dashboard data, metrics analysis, performance analysis, growth analysis,
  or says تحلیل داده، تحلیل آماری، نمودار کشیدن، استخراج بینش از داده،
  بررسی مجموعه داده، رسم نمودار، آمار توصیفی، تحلیل روند، ناهنجاری در داده،
  تحلیل همبستگی، تحلیل توزیع، آزمون فرض، رگرسیون، تحلیل واریانس،
  کشف الگو در داده، تحلیل بخش‌بندی مشتری، تحلیل کوهورت، قیف فروش،
  تحلیل بازگشت مشتری، آزمون A/B، نرخ تبدیل، شاخص‌های کلیدی عملکرد،
  نمودار پراکندگی، هیستوگرام، نمودار جعبه‌ای، نقشه حرارتی، تحلیل سری زمانی،
  فصلی‌بودن داده، میانگین متحرک، تحلیل مولفه‌های اصلی، خوشه‌بندی.
---

# Data Analysis Skill — Dataset Exploration, Statistics & Visualization

## Overview

This skill enables thorough analysis of datasets regardless of format. The goal is to go from raw data to actionable insights: understand what the data contains, compute meaningful statistics, identify patterns and outliers, and produce clear visualizations. Every analysis should answer the user's specific question, not just dump numbers.

## When to Use This Skill

- User wants to understand or summarize a dataset
- User asks for statistics, correlations, distributions, or trends
- User wants charts, plots, or visualizations from their data
- User wants to compare groups, find outliers, or detect anomalies
- User says "analyze this data" or "what can you tell me about this file"
- User needs exploratory data analysis (EDA) before modeling
- User wants business KPIs, cohort analysis, or funnel metrics
- User needs A/B test results interpreted or statistical significance tested
- User wants time-series decomposition, seasonality detection, or forecasting inputs
- User asks for customer segmentation, RFM analysis, or market basket insights

## Analysis Workflow

### Step 1: Identify and Load the Data

1. **Locate the data file** — Ask the user for the file path if not provided. Support CSV, TSV, Excel (.xlsx/.xls), JSON, Parquet, and SQL databases.
2. **Read the data** — Use pandas (Python) or the xlsx skill for spreadsheets. For large files, read a sample first to understand structure.
3. **Confirm basic shape** — Report rows, columns, and file size to the user so they know you've loaded the right thing.

### Step 2: Profile the Dataset

Generate a data profile before any analysis:

| Check | What to Report |
|-------|---------------|
| Column names & types | dtype per column, categorical vs numeric |
| Missing values | Count and percentage per column |
| Unique values | For categorical columns, count of distinct values |
| Numeric ranges | Min, max, mean, median for each numeric column |
| Sample rows | First 5 rows as a preview |

If data quality issues are severe (e.g., >30% missing), suggest the data-cleaning skill first.

### Step 3: Answer the User's Question

Align your analysis with what the user actually asked for:

- **"Summarize" / "Explore"** → Full EDA: distributions (histograms), correlations (heatmap), group-by summaries
- **"Find patterns"** → Correlation matrix, scatter plots, clustering hints
- **"Compare"** → Group-by statistics with significance tests, side-by-side box plots
- **"Find outliers"** → Z-score or IQR method, flag specific rows
- **"Trend"** → Time-series decomposition, rolling averages, line charts
- **"Relationship"** → Scatter plots with regression lines, correlation coefficients
- **"A/B test"** → Proportion tests, t-tests, confidence intervals, practical significance
- **"Segment"** → Clustering, RFM scoring, cohort grouping

### Step 4: Compute Statistics

Use Python (pandas, scipy, numpy) for computation:

- **Descriptive**: mean, median, mode, std, skewness, kurtosis, percentiles
- **Correlation**: Pearson, Spearman, or Kendall depending on data type
- **Group-by**: agg functions per category (mean, count, sum, etc.)
- **Hypothesis tests**: t-test, chi-squared, ANOVA, Mann-Whitney U — only when the user asks or it's clearly relevant
- **Regression**: simple linear or multiple regression if the user asks for predictions
- **Effect size**: Cohen's d, Cramér's V, or R² alongside p-values

Always report the statistic name, value, and a one-sentence interpretation. Never dump raw numbers without context.

### Step 5: Create Visualizations

Use matplotlib/seaborn for static charts. Generate chart files (PNG) or inline displays.

| Chart Type | Best For |
|-----------|----------|
| Histogram / KDE | Distribution of a single numeric variable |
| Box plot | Distribution comparison across groups, outlier detection |
| Scatter plot | Relationship between two numeric variables |
| Heatmap | Correlation matrix, cross-tabulation |
| Bar chart | Category frequencies, group comparisons |
| Line chart | Trends over time or ordered sequences |
| Pie chart | Proportions (only when <7 categories) |
| Pair plot | Overview of multiple numeric relationships |
| Violin plot | Distribution shape + density comparison |
| Stacked bar | Composition across categories over time |
| Funnel chart | Conversion pipeline analysis |
| Treemap | Hierarchical proportion visualization |

Chart rules:
- Always label axes and add a title
- Use readable font sizes (minimum 10pt)
- Choose colorblind-friendly palettes (e.g., `viridis`, `Set2`)
- If there are too many categories (>15), show only top N and group the rest as "Other"

### Step 6: Synthesize Findings

End with a concise summary section:

```
## Key Findings

1. [Most important insight]
2. [Second most important]
3. [Notable anomaly or surprise]
4. [Recommendation or next step, if applicable]
```

## Advanced Techniques

### 1. Time-Series Decomposition

Break a time series into trend, seasonal, and residual components to understand underlying patterns:

```python
from statsmodels.tsa.seasonal import seasonal_decompose
result = seasonal_decompose(df['value'], model='additive', period=12)
result.plot()
plt.tight_layout()
plt.savefig('decomposition.png', dpi=150)
```

### 2. Cohort Retention Analysis

Track how user behavior changes over time since their first event:

```python
df['cohort'] = df.groupby('user_id')['date'].transform('min').dt.to_period('M')
cohort_table = df.pivot_table(index='cohort', columns='period',
                              values='user_id', aggfunc='nunique')
retention = cohort_table.div(cohort_table.iloc[:, 0], axis=0) * 100
```

### 3. RFM (Recency, Frequency, Monetary) Segmentation

Score customers on three dimensions and create actionable segments:

```python
rfm = df.groupby('customer_id').agg(
    recency=('date', lambda x: (today - x.max()).days),
    frequency=('order_id', 'nunique'),
    monetary=('revenue', 'sum')
)
rfm['segment'] = pd.qcut(rfm['recency'], 4, labels=[4,3,2,1]).astype(str) + \
                  pd.qcut(rfm['frequency'], 4, labels=[1,2,3,4]).astype(str) + \
                  pd.qcut(rfm['monetary'], 4, labels=[1,2,3,4]).astype(str)
```

### 4. Multi-Group Significance Testing with Correction

When running multiple comparisons, apply Bonferroni or FDR correction to avoid false discoveries:

```python
from scipy.stats import ttest_ind
import statsmodels.stats.multitest as smm

p_values = [ttest_ind(group_a[col], group_b[col]).pvalue for col in numeric_cols]
rejected, corrected_p, _, _ = smm.multipletests(p_values, method='fdr_bh')
```

### 5. Automatic EDA Report Generation

Use `ydata-profiling` (formerly pandas-profiling) for a comprehensive one-line EDA:

```python
from ydata_profiling import ProfileReport
profile = ProfileReport(df, title="EDA Report", explorative=True)
profile.to_file("eda_report.html")
```

### 6. Partial Correlation & Confounding Analysis

Control for confounding variables when examining relationships:

```python
import pingouin as pg
pg.partial_corr(data=df, x='sleep_hours', y='productivity',
                 covar=['age', 'exercise'])
```

### 7. Bayesian Quick Analysis

Use prior knowledge to compute posterior distributions for small-sample scenarios:

```python
import scipy.stats as stats
prior_mu, prior_std = 50, 10
data = df['measurement'].values
posterior_std = 1 / (1/prior_std**2 + len(data)/stats.sem(data)**2)
posterior_mu = posterior_std * (prior_mu/prior_std**2 + data.mean()*len(data)/stats.sem(data)**2)
```

## Common Patterns

### Pattern 1: Sales Performance Dashboard Data

```python
# Monthly revenue by region with YoY growth
monthly = df.groupby([df['date'].dt.to_period('M'), 'region'])['revenue'].sum().unstack()
yoy_growth = monthly.pct_change(periods=12) * 100
print(yoy_growth.round(1).to_string())
```

### Pattern 2: Survey / Questionnaire Analysis

```python
# Likert scale summary with median and IQR
likert_cols = [c for c in df.columns if c.startswith('q_')]
summary = df[likert_cols].agg(['median', 'mean', 'std',
    lambda x: x.quantile(0.75) - x.quantile(0.25)])
summary.index = ['Median', 'Mean', 'StdDev', 'IQR']
```

### Pattern 3: Funnel / Conversion Analysis

```python
stages = ['visit', 'add_to_cart', 'checkout', 'purchase']
funnel = [df[s].notna().sum() for s in stages]
conversion = [funnel[i]/funnel[0]*100 for i in range(len(stages))]
drop_off = [100 - funnel[i]/funnel[i-1]*100 for i in range(1, len(stages))]
```

### Pattern 4: A/B Test Interpretation

```python
from scipy.stats import chi2_contingency
table = pd.crosstab(df['group'], df['converted'])
chi2, p, dof, expected = chi2_contingency(table)
lift = (df[df['group']=='B']['converted'].mean() / 
        df[df['group']=='A']['converted'].mean() - 1) * 100
print(f"Chi-squared={chi2:.2f}, p={p:.4f}, Lift={lift:+.1f}%")
```

### Pattern 5: Geographic / Regional Comparison

```python
# Top N regions by metric with confidence intervals
regional = df.groupby('region')['score'].agg(['mean', 'std', 'count'])
regional['ci_95'] = 1.96 * regional['std'] / np.sqrt(regional['count'])
regional = regional.sort_values('mean', ascending=False).head(10)
```

## Edge Cases & Pitfalls

1. **Simpson's Paradox** — A trend appears in different groups but disappears or reverses when combined. Always check group-level patterns before aggregating.
2. **Survivorship Bias** — Analyzing only data that "survived" a selection process (e.g., only successful customers). Ask whether the dataset excludes failures.
3. **Small Sample Sizes** — With n < 30 per group, parametric tests (t-test, ANOVA) become unreliable. Use non-parametric alternatives (Mann-Whitney, Kruskal-Wallis).
4. **P-hacking** — Running many tests and reporting only significant ones. If testing >5 hypotheses, apply multiple testing correction (Bonferroni, FDR).
5. **Correlation ≠ Causation** — High correlation does not imply one variable causes the other. Always state this caveat. Use domain knowledge to suggest causality.
6. **Outlier Influence on Mean** — A single extreme value can skew the mean dramatically. Always report median alongside mean for skewed data.
7. **Leaky Data in Time Series** — Using future data to compute past metrics (e.g., mean imputation across time). Ensure temporal ordering is respected.
8. **Unequal Group Sizes** — When comparing groups with vastly different sizes, statistical power differs. Report group sizes alongside p-values.
9. **Multicollinearity** — In regression, highly correlated predictors make coefficient interpretation unreliable. Check VIF (Variance Inflation Factor) before interpreting coefficients.
10. **Datetime Timezone Issues** — Mixing timezone-aware and timezone-naive datetimes causes silent bugs. Standardize to UTC or a single timezone early.
11. **Categorical Encoding Pitfalls** — Treating ordinal categories as nominal (or vice versa) leads to wrong statistical tests. Verify the nature of each categorical variable.
12. **Selection Bias in Non-Random Samples** — If data was collected non-randomly (e.g., survey respondents self-selected), statistical tests assume random sampling and may give misleading p-values.
13. **Over-aggregation** — Grouping data too coarsely (e.g., monthly instead of daily) can hide important patterns like day-of-week effects or intra-month spikes.
14. **Ignoring Data Collection Context** — Not knowing how data was collected (instrument, timing, population) leads to misinterpreting what the numbers mean.
15. **Cherry-picking Charts** — Showing only charts that support a narrative while hiding contradictory evidence. Present a balanced view, including null or unexpected results.

## Output Format Templates

### Template A: Executive Summary (for business users)

```
## Data Analysis Report

### At a Glance
- **Dataset:** [name] — [rows] rows, [columns] columns
- **Time Period:** [date range]  
- **Key Metric:** [primary metric] = [value] ([change]% vs [comparison period])

### Top 3 Insights
1. **[Finding title]** — [One sentence with the number]
2. **[Finding title]** — [One sentence with the number]  
3. **[Finding title]** — [One sentence with the number]

### Recommendation
[One actionable recommendation based on findings]

### Appendix: Charts
- [chart1.png] — [description]
- [chart2.png] — [description]
```

### Template B: Technical EDA (for data scientists)

```
## Exploratory Data Analysis

### Data Profile
| Column | Type | Non-Null | Unique | Min | Max | Mean | Skew |
|--------|------|----------|--------|-----|-----|------|------|
| ... | ... | ... | ... | ... | ... | ... | ... |

### Distributions
[Histograms saved as distribution_*.png]

### Correlation Analysis
- Strongest positive: [var1] ↔ [var2] (r = X.XX)
- Strongest negative: [var3] ↔ [var4] (r = -X.XX)
- [heatmap.png]

### Statistical Tests
| Test | Groups | Statistic | p-value | Significant? |
|------|--------|-----------|---------|-------------|
| ... | ... | ... | ... | ... |

### Notes for Modeling
- [Skewed features to transform]
- [High-cardinality categoricals to handle]
- [Potential feature engineering ideas]
```

### Template C: Quick Single-Question (for ad-hoc queries)

```
## Answer: [Question]

**Result:** [Direct answer with the key number]

**Context:** [1-2 sentences of supporting detail]

**Chart:** [single_chart.png]

**Data:** [small summary table if relevant]
```

### Template D: Comparative Analysis (A/B tests, group comparisons)

```
## Comparison Report: [Group A] vs [Group B]

### Summary
| Metric | Group A | Group B | Difference | p-value | Significant |
|--------|---------|---------|------------|---------|-------------|
| ... | ... | ... | ... | ... | ... |

### Effect Size
- Cohen's d: [value] — [interpretation: small/medium/large]
- Practical significance: [is the difference meaningful in business terms?]

### Visual Comparison
- [comparison_chart.png]

### Conclusion
[Clear recommendation: adopt B / no significant difference / needs more data]
```

## Tools & Libraries

- **pandas** — data loading, manipulation, group-by, aggregation
- **numpy** — numeric operations
- **scipy.stats** — statistical tests
- **statsmodels** — regression, ANOVA, time-series decomposition
- **pingouin** — partial correlation, effect sizes, advanced tests
- **matplotlib / seaborn** — chart generation
- **ydata-profiling** — automated EDA reports
- **json / csv** — built-in file readers
- Use the **xlsx** skill for Excel file inputs
- Use the **charts** skill if the user needs publication-quality or interactive visualizations
- Use the **data-cleaning** skill when data quality issues prevent meaningful analysis

## Integration with Other Skills

- **data-cleaning** — Always invoke first if data has quality issues (>10% missing, wrong types, duplicates). Clean data before analyzing.
- **charts** — Use for publication-quality, interactive, or dashboard-style visualizations beyond basic matplotlib charts.
- **xlsx** — Use for reading/writing Excel files with multiple sheets, formatting, or when the user expects an Excel deliverable.
- **web-scraping** — Use when the data to analyze needs to be collected from websites first.
- **web-reader** — Use when you need to extract article content from a URL as context for analysis.
- **web-search** — Use when analysis requires external benchmark data, industry statistics, or context not in the dataset.
- **pdf** — Use for generating a formatted PDF report of the analysis results.

## Language Handling

- Write all narrative text, insight descriptions, and recommendations in the user's language
- Keep code, column names, function names, and technical terms in English
- For Persian/Farsi users: use RTL-appropriate formatting, Persian numerals where culturally appropriate, and common Persian statistical terminology (e.g., میانگین, انحراف معیار, همبستگی)
- If the user switches languages mid-conversation, follow their last language choice
