-- Question 2
-- WITH m AS (
-- SELECT *
-- FROM order_table o
-- LEFT JOIN product_table p USING(product_cate_id)
-- LEFT JOIN user_table u USING(user_id))

-- SELECT
-- 	user_id, user_name, location
-- FROM m
-- WHERE
-- 	DATE_FORMAT(m.order_date, "%Y-%m") = "2021-05"
--     AND m.product_cate_name = "books"
--     AND m.user_segment = "Whale"
    
-- Question 3
-- WITH m AS (
-- SELECT *
-- FROM order_table o
-- LEFT JOIN product_table p USING(product_cate_id)
-- LEFT JOIN user_table u USING(user_id))

-- SELECT
-- 	m.product_cate_name, m.user_segment,
--     SUM(m.order_value) as total_order_value
-- FROM m
-- WHERE m.order_date > "2021-08-01"
-- GROUP BY m.product_cate_name, m.user_segment;

-- Question 4
WITH m AS (
SELECT
	*,
	COUNT(user_id) OVER(PARTITION BY location) order_counts
FROM order_table o
LEFT JOIN user_table u USING(user_id)
WHERE DATE_FORMAT(o.order_date, "%Y-%m") = "2021-07")
,
t AS (
SELECT
	user_name, location,
    DENSE_RANK() OVER(ORDER BY order_counts DESC) rnk
FROM m)

SELECT *
FROM t
-- WHERE t.rnk = 2




