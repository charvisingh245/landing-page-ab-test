# Landing Page A/B Test Analysis

## Project Overview
This project simulates and analyzes an A/B test conducted by a fictional e-commerce company to evaluate whether a redesigned landing page drives higher conversion rates than the existing design. The analysis covers the full experiment lifecycle from hypothesis formulation and power analysis through statistical testing, segment analysis, and guardrail metric validation, using Python, SQL, and Tableau.

## Business Question
> *Does the new landing page design significantly increase the rate at which visitors convert (sign up or make a purchase), compared to the existing page?*

## Experiment Design

| Parameter | Value | Rationale |
|---|---|---|
| Metric | Landing page visit → Conversion | Isolates the effect of the page redesign on top-of-funnel behavior |
| Baseline conversion rate | 8% | Realistic benchmark for e-commerce landing page conversion |
| Minimum Detectable Effect (MDE) | 2 percentage points (8% → 10%) | Smallest lift considered business-meaningful |
| Significance level (α) | 0.05 | Industry standard |
| Statistical power (1-β) | 0.80 | Industry standard |
| Required sample size | 3,205 per group (6,410 total) | Calculated via two-proportion power analysis |
| Random seed | 42 | Ensures reproducibility |

**Hypotheses:**
- **H₀ (Null):** The new landing page has no effect on conversion rate (control rate = treatment rate)
- **H₁ (Alternative):** The new landing page changes conversion rate (control rate ≠ treatment rate)

## Dataset
The dataset was simulated using Python (`numpy`, `scipy`) to reflect realistic experiment parameters. Simulation was chosen over a pre-existing dataset; visitors were randomly assigned to the control and treatment groups in a 1:1 ratio to minimize selection bias and support valid statistical inference, demonstrating end-to-end experiment design thinking, including power analysis prior to data generation.

| Metric | Value |
|--------|------|
| Total Visitors | 6,410 |
| Control Group | 3,205 |
| Treatment Group | 3,205 |

| Column | Type | Description |
|---|---|---|
| `user_id` | Integer | Unique identifier per visitor |
| `group` | String | Experiment group: `control` or `treatment` |
| `converted` | Integer | Conversion outcome: `1` (converted) or `0` (did not convert) |
| `device_type` | String | Device used: `mobile`, `desktop`, or `tablet` |
| `traffic_source` | String | Acquisition channel: `organic`, `paid`, or `social` |
| `order_value` | Float | Order value in USD (non-null only for converted users) |

## Tools Used

| Tool | Purpose |
|---|---|
| Python (Jupyter Notebook) | Data simulation, statistical testing, visualization |
| pandas, numpy | Data manipulation and simulation |
| scipy, statsmodels | Power analysis, z-test, t-test, confidence intervals |
| matplotlib, seaborn | Exploratory and results visualizations |
| PostgreSQL (DBeaver) | SQL-based analysis and segment aggregations |
| Tableau Public | Interactive results dashboard |

## Project Structure

landing-page-ab-test/
│
├── notebooks/
│   └── ab_test_landing_page.ipynb    # Main analysis: simulation, testing, segments
│
├── data/
│   ├── ab_test_data.csv              # Simulated experiment dataset
│   ├── ab_test_summary_stats.csv     # Test statistics summary
│   ├── ab_test_device_segment.csv    # Device-level conversion breakdown
│   └── ab_test_traffic_segment.csv   # Traffic source conversion breakdown
│
├── sql/
│   └── ab-testing.sql                # SQL analysis queries
│
└── README.md

## Key Results

| Metric | Value |
|---|---|
| Control conversion rate | 8.17% |
| Treatment conversion rate | 9.58% |
| Absolute lift | +1.40 percentage points |
| Relative lift | **+17.18%** |
| Z-statistic | -1.98 |
| P-value | **0.0481** |
| 95% Confidence Interval | (0.01pp, 2.80pp) |

**Decision:** Reject H₀. The difference in conversion rates is statistically significant (p = 0.048 < α = 0.05). The new landing page produced a meaningful lift in conversion rate.

**Important caveat:** The result is borderline significant; the p-value sits close to the 0.05 threshold and the lower bound of the 95% CI is near zero. This suggests the true effect could be modest, and a follow-up test with a larger sample size would strengthen confidence before a full production rollout.

## Segment Analysis

| Device Type | Control | Treatment | Lift |
|---|---|---|---|
| Desktop | 8.40% | 9.70% | +1.28pp |
| Mobile | 8.03% | 9.32% | +1.29pp |
| Tablet | 8.23% | 10.68% | **+2.45pp** |

| Traffic Source | Control | Treatment | Lift |
|---|---|---|---|
| Organic | 6.90% | 8.91% | **+2.02pp** |
| Paid | 9.08% | 9.96% | +0.88pp |
| Social | 9.30% | 10.41% | +1.11pp |

The conversion lift was strongest among **tablet users** and **organic traffic**, while desktop and mobile showed similar, more moderate gains. Paid and social channels also improved, though by a smaller margin. The effect holds in the same direction across every segment, no reversals, which supports treating this as a genuine effect rather than one segment driving the whole result.

Segment-level results are exploratory and directional. Individual segments were not independently powered for significance testing; a follow-up device-specific or channel-specific test is recommended before drawing firm conclusions.

## Guardrail Metric: Average Order Value (AOV)

To confirm the conversion lift did not come at the cost of lower-quality conversions, average order value was compared between groups among converted users only.

| Group | Avg. Order Value | Converters |
|---|---|---|
| Control | $49.19 | 262 |
| Treatment | $49.99 | 307 |
| T-test p-value | 0.5371 | |

No statistically significant difference in AOV between groups (p = 0.5371). The new landing page attracted more converting visitors without negatively impacting spend per order.

## Business Recommendations

- Conduct a larger follow-up experiment to increase confidence in the observed conversion lift.
- Prioritize additional testing for tablet users, where the strongest improvement was observed.
- Continue monitoring Average Order Value and other guardrail metrics after deployment.
- If future experiments confirm the results, consider a phased rollout of the redesigned landing page.

## SQL Analysis
Core business metrics were independently reproduced in PostgreSQL to validate the Python analysis under the `ab_testing` schema. Queries cover:
1. Sample ratio check between control and treatment
2. Overall conversion rate by group
3. Conversion rate by device type and group
4. Conversion rate by traffic source and group
5. Average order value guardrail by group (converters only)

## Dashboard
An interactive Tableau dashboard visualizing all key results is available on Tableau Public:

🔗 [View Dashboard](https://public.tableau.com/views/ABTestingAnalysisDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

The dashboard includes KPI summary cards (Control Rate, Treatment Rate, Relative Lift), conversion rate by group with a baseline reference line, segment breakdowns by device type and traffic source, and the AOV guardrail comparison.

## Limitations
- **Simulated data:** Results are based on artificially generated data designed to reflect realistic experiment conditions. Real-world data would introduce additional noise, confounders, and complexity.
- **Borderline significance:** p = 0.048 is close to the threshold. Practical deployment decisions should consider a replication test or a larger sample.
- **No novelty effect control:** In real experiments, users may respond to a new design simply because it is new rather than because it is genuinely better. This is not accounted for in the simulation.
- **Segment tests not independently powered:** Segment-level findings are exploratory only and should not be treated as confirmatory results.

## How to Run
1. Clone this repository
2. Install dependencies: `pip install pandas numpy scipy statsmodels matplotlib seaborn`
3. Open `notebooks/ab_test_landing_page.ipynb` in Jupyter Notebook
4. Run all cells (Kernel → Restart & Run All)
5. For SQL: connect to PostgreSQL, create schema `ab_testing`, import `data/ab_test_data.csv`, and run `sql/ab-testing.sql`


