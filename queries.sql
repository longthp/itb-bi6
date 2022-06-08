-- Question 2
WITH m AS (
SELECT *
FROM order_table o
LEFT JOIN product_table p USING(product_cate_id)
LEFT JOIN user_table u USING(user_id))

SELECT
	user_id, user_name, location
FROM m
WHERE
	DATE_FORMAT(m.order_date, "%Y-%m") = "2021-05"
    AND m.product_cate_name = "books"
    AND m.user_segment = "Whale";
    
-- Question 3
WITH m AS (
SELECT *
FROM order_table o
LEFT JOIN product_table p USING(product_cate_id)
LEFT JOIN user_table u USING(user_id))

SELECT
	m.product_cate_name, m.user_segment,
    SUM(m.order_value) as total_order_value
FROM m
WHERE m.order_date > "2021-08-01"
GROUP BY m.product_cate_name, m.user_segment;

-- Question 4
WITH m AS (
SELECT
	user_id, user_name, location, 
    COUNT(user_id) AS order_counts
FROM order_table_ext o
LEFT JOIN user_table u USING(user_id)
WHERE DATE_FORMAT(o.order_date, "%Y-%m") = "2021-07"
GROUP BY user_id)
, t AS (
SELECT
	*,
    DENSE_RANK() OVER(PARTITION BY location ORDER BY order_counts DESC) AS rnk
FROM m)

SELECT user_id, user_name, location
FROM t
WHERE rnk = 2;

-- Question 5
WITH m AS (
SELECT
	u.user_id, u.user_name, o.order_value,
    ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY order_date ASC) as rnk
FROM order_table_ext o
LEFT JOIN user_table u USING(user_id)
WHERE DATE_FORMAT(o.order_date, "%Y-%m") = "2021-05")

SELECT
	user_id, user_name,
    order_value AS first_order_value
FROM m
WHERE m.rnk = 1;

-- Question 6
WITH m AS (
SELECT *
FROM order_table_ext
LEFT JOIN user_table USING(user_id))

SELECT
	order_date, user_segment, 
    COUNT(user_id) OVER(PARTITION BY user_segment ORDER BY order_date) AS running_total_orders
FROM m;

-- Question 7
WITH m AS (
SELECT
	*,
    ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY o.order_date) AS order_rnk,
    LAG(order_date) OVER(PARTITION BY u.user_id) AS snd_order_date
FROM order_table_ext o
LEFT JOIN user_table u USING(user_id))
, t AS (
SELECT
	*,
    order_date - snd_order_date AS date_diff
FROM m
WHERE order_rnk <=2 
	AND snd_order_date IS NOT NULL)
    
SELECT
	user_segment,
    AVG(date_diff) AS avg_date_diff
FROM t
GROUP BY user_segment;