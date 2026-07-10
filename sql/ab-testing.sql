-- ============================================
-- A/B Test Analysis: Landing Page / Checkout Test
-- ============================================

-- Create schema
CREATE SCHEMA ab_testing;

-- Create table
CREATE TABLE ab_testing.ab_test (
    user_id INTEGER PRIMARY KEY,
    group_name VARCHAR(20) NOT NULL,
    converted INTEGER NOT NULL,
    device_type VARCHAR(20) NOT NULL,
    traffic_source VARCHAR(20) NOT NULL,
    order_value NUMERIC(10,2)
);

-- ============================================
-- 1. Sample Ratio Check
-- Q: Are users split roughly evenly between control and treatment?
-- (A skewed split can indicate a bug in randomization/assignment)
-- ============================================


SELECT
    group_name,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM ab_testing.ab_test
GROUP BY group_name
ORDER BY group_name;


-- ============================================
-- 2. Overall A/B Test Summary
-- Q: Does the treatment group have a higher conversion rate than control?
-- ============================================


SELECT
    group_name,
    COUNT(*) AS users,
    SUM(converted) AS conversions,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY group_name
ORDER BY group_name;



-- ============================================
-- 3. Conversion Rate by Device Type
-- Q: Is the treatment effect consistent across device types,
--    or does one group win only on a specific device?
-- ============================================


SELECT
    group_name,
    device_type,
    COUNT(*) AS users,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY
    group_name,
    device_type
ORDER BY
    group_name,
    device_type;



-- ============================================
-- 4. Conversion Rate by Traffic Source
-- Q: Does the treatment effect hold across acquisition channels,
--    or is it driven by one traffic source (Simpson's paradox check)?
-- ============================================


SELECT
    group_name,
    traffic_source,
    COUNT(*) AS users,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY
    group_name,
    traffic_source
ORDER BY
    group_name,
    traffic_source;


-- ============================================
-- 5. Average Order Value (AOV) by Group
-- Q: Among users who converted, does the treatment group spend
--    more per order than control? (guardrail metric)
-- ============================================

SELECT
    group_name,
    COUNT(*) AS converters,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM ab_testing.ab_test
WHERE converted = 1
GROUP BY group_name
ORDER BY group_name;



-- ============================================
-- Note: Statistical significance testing (z-test for proportions,
-- confidence intervals, power analysis) was conducted in Python.
-- See: notebooks/ab-test-landing-page-analysis.ipynb for the full hypothesis testing workflow.
-- ============================================














