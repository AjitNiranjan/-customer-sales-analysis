-- Customer Sales Analysis
-- Complex JOINs, VIEWs and aggregate queries for optimized reporting

-- ============================================================
-- VIEW 1: Complete Order Revenue (core transactional view)
-- Joins 5 tables: orders + order_details + products + customers + employees
-- ============================================================
CREATE VIEW vw_order_revenue AS
SELECT
    o.order_id,
    o.order_date,
    o.status AS order_status,
    c.customer_id,
    c.company_name,
    c.customer_segment,
    c.city AS customer_city,
    r.region_name,
    r.country,
    e.employee_id,
    e.first_name || ' ' || e.last_name AS sales_rep,
    p.product_id,
    p.product_name,
    cat.category_name,
    od.unit_price,
    od.quantity,
    od.discount,
    ROUND(od.unit_price * od.quantity * (1 - od.discount), 2) AS line_revenue,
    o.freight
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
LEFT JOIN employees e ON o.employee_id = e.employee_id;

-- ============================================================
-- VIEW 2: Payment vs Order Reconciliation
-- Joins orders + payments + customers (detects under/over payments)
-- ============================================================
CREATE VIEW vw_payment_reconciliation AS
SELECT
    o.order_id,
    o.order_date,
    c.company_name,
    c.customer_segment,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS order_value,
    o.freight,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)) + o.freight, 2) AS total_due,
    COALESCE(SUM(pay.amount), 0) AS total_paid,
    pay.payment_method,
    pay.status AS payment_status,
    ROUND(
        COALESCE(SUM(pay.amount), 0) - (SUM(od.unit_price * od.quantity * (1 - od.discount)) + o.freight)
    , 2) AS balance
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments pay ON o.order_id = pay.order_id
GROUP BY o.order_id, o.order_date, c.company_name, c.customer_segment,
         o.freight, pay.payment_method, pay.status;

-- ============================================================
-- VIEW 3: Customer Lifetime Value Snapshot
-- Aggregates across orders, details, payments
-- ============================================================
CREATE VIEW vw_customer_ltv AS
SELECT
    c.customer_id,
    c.company_name,
    c.customer_segment,
    r.region_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
    ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount)), 2) AS avg_line_value,
    ROUND(SUM(COALESCE(pay.amount, 0)), 2) AS total_payments_received
FROM customers c
JOIN regions r ON c.region_id = r.region_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN payments pay ON o.order_id = pay.order_id AND pay.status = 'Completed'
GROUP BY c.customer_id, c.company_name, c.customer_segment, r.region_name;

-- ============================================================
-- VIEW 4: Product Performance
-- ============================================================
CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.unit_price AS list_price,
    COUNT(DISTINCT od.order_id) AS times_ordered,
    SUM(od.quantity) AS total_units_sold,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
    ROUND(AVG(od.discount), 3) AS avg_discount_rate,
    p.discontinued
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, cat.category_name, p.unit_price, p.discontinued;

-- ============================================================
-- KEY ANALYSIS QUERIES (ready for reporting / Python consumption)
-- ============================================================

-- 1. Monthly Revenue Trend (optimized aggregate)
-- Useful for time-series visualization
/*
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(line_revenue), 2) AS revenue,
    ROUND(AVG(line_revenue), 2) AS avg_line_revenue
FROM vw_order_revenue
WHERE order_status != 'Cancelled'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;
*/

-- 2. Sales by Region & Segment (multi-dimensional aggregate)
/*
SELECT
    region_name,
    customer_segment,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(line_revenue), 2) AS revenue,
    ROUND(SUM(line_revenue) * 100.0 / SUM(SUM(line_revenue)) OVER (), 2) AS revenue_pct
FROM vw_order_revenue
GROUP BY region_name, customer_segment
ORDER BY revenue DESC;
*/

-- 3. Top Sales Drivers - Category Contribution
/*
SELECT
    category_name,
    ROUND(SUM(line_revenue), 2) AS revenue,
    SUM(quantity) AS units,
    ROUND(SUM(line_revenue) * 100.0 / SUM(SUM(line_revenue)) OVER (), 1) AS pct_of_total
FROM vw_order_revenue
GROUP BY category_name
ORDER BY revenue DESC;
*/

-- 4. Sales Rep Performance Leaderboard
/*
SELECT
    sales_rep,
    region_name,
    COUNT(DISTINCT order_id) AS deals_closed,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    ROUND(AVG(line_revenue), 2) AS avg_deal_size
FROM vw_order_revenue
WHERE sales_rep IS NOT NULL
GROUP BY sales_rep, region_name
ORDER BY total_revenue DESC;
*/

-- 5. Discount Impact Analysis
/*
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.05 THEN '1-5%'
        WHEN discount <= 0.10 THEN '6-10%'
        ELSE '>10%'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(SUM(line_revenue), 2) AS revenue,
    ROUND(AVG(quantity), 1) AS avg_qty
FROM vw_order_revenue
GROUP BY discount_band
ORDER BY MIN(discount);
*/

-- 6. Repeat Customer Analysis (commercial intelligence)
/*
SELECT
    company_name,
    customer_segment,
    region_name,
    total_orders,
    total_revenue,
    ROUND(total_revenue / total_orders, 2) AS revenue_per_order,
    first_order_date,
    last_order_date
FROM vw_customer_ltv
WHERE total_orders >= 2
ORDER BY total_revenue DESC;
*/
