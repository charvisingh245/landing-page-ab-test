-- Create schema
CREATE SCHEMA ab_testing;

-- Create table
CREATE TABLE ab_testing.ab_test (
    user_id INTEGER,
    group_name VARCHAR(20),
    converted INTEGER,
    device_type VARCHAR(20),
    traffic_source VARCHAR(20),
    order_value NUMERIC(10,2)
);

-- Preview data
SELECT *
FROM ab_testing.ab_test
LIMIT 2;

-- Overall Conversion Rate by Group
SELECT
    group_name,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY group_name;

-- Conversion Rate by Device Type
SELECT
    group_name,
    device_type,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY
    group_name,
    device_type
ORDER BY
    group_name,
    device_type;

-- Conversion Rate by Traffic Source
SELECT
    group_name,
    traffic_source,
    ROUND(AVG(converted) * 100, 2) AS conversion_rate_pct
FROM ab_testing.ab_test
GROUP BY
    group_name,
    traffic_source
ORDER BY
    group_name,
    traffic_source;

-- Average Order Value (AOV) by Group
SELECT
    group_name,
    COUNT(*) AS converters,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM ab_testing.ab_test
WHERE converted = 1
GROUP BY group_name
ORDER BY group_name;















