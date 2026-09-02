-- ============================================================
-- SUPERSTORE SALES & PROFIT ANALYSIS
-- Portfolio Project | SQL / SQLite
-- ============================================================
-- Dataset: Superstore
-- Purpose: Analyze sales, profitability, customers, products,
--          categories, and regional performance.
-- ============================================================


-- ============================================================
-- 1. KPI OVERVIEW
-- ============================================================

-- Total records
SELECT COUNT(*) AS total_records
FROM Superstore;

-- Unique customers
SELECT COUNT(DISTINCT customer_name) AS unique_customers
FROM Superstore;

-- Unique products
SELECT COUNT(DISTINCT product_name) AS unique_products
FROM Superstore;

-- Total sales
SELECT ROUND(
    SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
) AS total_sales
FROM Superstore;

-- Total profit
SELECT ROUND(
    SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
) AS total_profit
FROM Superstore;

-- Overall sales, profit and profit margin by category
SELECT
    category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL))
        / SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)) * 100,
        2
    ) AS profit_margin
FROM Superstore
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 2. SALES ANALYSIS
-- ============================================================

-- Sales by category
SELECT
    category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Sales by region
SELECT
    region,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Sales by customer segment
SELECT
    segment,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- Top 5 customers by total sales
SELECT
    customer_name,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;

-- Top 5 products by total sales
SELECT
    product_name,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;


-- ============================================================
-- 3. PROFITABILITY ANALYSIS
-- ============================================================

-- Profit by region
SELECT
    region,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY region
ORDER BY total_profit DESC;

-- Profit by sub-category
SELECT
    sub_category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY sub_category
ORDER BY total_profit DESC;

-- Loss-making sub-categories
SELECT
    sub_category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY sub_category
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- Top 5 sub-categories by profit
SELECT
    sub_category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 5;

-- Technology sub-categories with profit above 10,000
SELECT
    sub_category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
WHERE category = 'Technology'
GROUP BY sub_category
HAVING total_profit > 10000
ORDER BY total_profit DESC;


-- ============================================================
-- 4. FILTERING & BUSINESS CONDITIONS
-- ============================================================

-- Categories with sales above 500,000
SELECT
    category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY category
HAVING total_sales > 500000
ORDER BY total_sales DESC;

-- Regions with profit above 50,000
SELECT
    region,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY region
HAVING total_profit > 50000
ORDER BY total_profit DESC;

-- West region: categories with sales above 50,000
SELECT
    category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
WHERE region = 'West'
GROUP BY category
HAVING total_sales > 50000
ORDER BY total_sales DESC;


-- ============================================================
-- 5. CASE WHEN — BUSINESS CLASSIFICATION
-- ============================================================

-- Classify each order as Profitable or Loss
SELECT
    order_id,
    profit,
    CASE
        WHEN CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL) > 0
            THEN 'Profitable'
        ELSE 'Loss'
    END AS profit_status
FROM Superstore;

-- Classify sales into Low / Medium / High
SELECT
    category,
    sales,
    CASE
        WHEN CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL) < 100
            THEN 'Low'
        WHEN CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL) <= 500
            THEN 'Medium'
        ELSE 'High'
    END AS sales_status
FROM Superstore;

-- Classify profit performance
SELECT
    category,
    profit,
    CASE
        WHEN CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL) < 0
            THEN 'Loss'
        WHEN CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL) <= 100
            THEN 'Low Profit'
        ELSE 'High Profit'
    END AS profit_status
FROM Superstore;


-- ============================================================
-- 6. JOIN ANALYSIS
-- ============================================================

-- Create a customer-level sales summary
DROP TABLE IF EXISTS customer_sales;

CREATE TABLE customer_sales AS
SELECT
    customer_name,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY customer_name;

-- Create a customer-level profit summary
DROP TABLE IF EXISTS customer_profit;

CREATE TABLE customer_profit AS
SELECT
    customer_name,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY customer_name;

-- Combine customer sales and profit using JOIN
SELECT
    cs.customer_name,
    cs.total_sales,
    cp.total_profit
FROM customer_sales AS cs
JOIN customer_profit AS cp
    ON cs.customer_name = cp.customer_name
ORDER BY cs.total_sales DESC;

-- Top 10 customers with both sales and profit
SELECT
    cs.customer_name,
    cs.total_sales,
    cp.total_profit
FROM customer_sales AS cs
JOIN customer_profit AS cp
    ON cs.customer_name = cp.customer_name
ORDER BY cs.total_sales DESC
LIMIT 10;


-- ============================================================
-- 7. FINAL BUSINESS QUESTIONS
-- ============================================================

-- Which sub-category generates the highest total sales?
SELECT
    sub_category,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '') AS REAL)), 2
    ) AS total_sales
FROM Superstore
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 1;

-- Which region generates the highest total profit?
SELECT
    region,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '') AS REAL)), 2
    ) AS total_profit
FROM Superstore
GROUP BY region
ORDER BY total_profit DESC
LIMIT 1;

-- ============================================================
-- END OF PROJECT
-- ============================================================
