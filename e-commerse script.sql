CREATE DATABASE E_COMMERSE;
DROP TABLE olist_products_dataset;
DROP TABLE olist_order_payments_dataset;
SELECT * 
FROM olist_order_payments_dataset
LIMIT 20;

SELECT customer_id ,COUNT(*)
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) >1;
SELECT*
FROM olist_customers_dataset
WHERE customer_id = " ";

SELECT order_id ,COUNT(*)
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) >1;
SELECT*
FROM olist_orders_dataset
WHERE customer_id = " ";

SELECT*
FROM olist_orders_dataset
WHERE customer_id IS NULL;
SELECT*
FROM olist_orders_dataset;

CREATE TABLE orders_clean AS 
SELECT *
FROM olist_orders_dataset;
DESCRIBE orders_clean;
SELECT order_purchase_timestamp
FROM orders_clean
WHERE order_purchase_timestamp NOT LIKE '____-__-__%';
SELECT order_approved_at
FROM orders_clean
WHERE order_approved_at NOT LIKE '____-___-__%';

UPDATE orders_clean
SET order_purchase_timestamp =null
WHERE order_purchase_timestamp NOT LIKE '___-___-__%';

SET SQL_SAFE_UPDATES=0;
ALTER TABLE orders_clean
MODIFY order_purchase_timestamp
datetime;
SELECT order_id,COUNT(*)
FROM orders_clean
GROUP BY order_id
HAVING COUNT(*)>1;
SELECT *
FROM clean_payments;
SELECT COUNT(C.order_id) AS total_orders,COUNT(customer_id)AS UNIQUE_CUSTOMERS,SUM( payment_value)AS total_revenue
FROM clean_orders C
LEFT JOIN Clean_payments P
		ON C.order_id =P.order_id
;

SELECT *
FROM clean_products;

SELECT
date_format(order_purchase_timestamp,'%y-%m')AS month,
		SUM(payment_value) as revenue
FROM clean_orders O
JOIN clean_payments P 
	ON O.order_id=p.order_id
group by month
ORDER BY month;

SELECT 
    month,
    revenue,
    prev_month_revenue,
    revenue - prev_month_revenue AS growth
FROM (
    SELECT 
        DATE_FORMAT(co.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(cp.payment_value) AS revenue,
        LAG(SUM(cp.payment_value)) OVER (
            ORDER BY DATE_FORMAT(co.order_purchase_timestamp, '%Y-%m')
        ) AS prev_month_revenue
    FROM clean_orders co
    JOIN clean_payments cp
        ON co.order_id = cp.order_id
    GROUP BY month
) t
ORDER BY month;


