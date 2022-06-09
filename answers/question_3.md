# Question 3

> Find `total order value` for each `customer segments` and `product categories` from `August, 2021` till now.

```sql
WITH m AS
	(SELECT *
	FROM order_table o
	LEFT JOIN product_table p USING(product_cate_id)
	LEFT JOIN user_table u USING(user_id))

SELECT
	m.product_cate_name, m.user_segment,
	SUM(m.order_value) as total_order_value
FROM m
WHERE m.order_date > "2021-08-01"
GROUP BY m.product_cate_name, m.user_segment;
```
<br>

### WITH clause
> `LEFT JOIN` three tables, with `order_table` on the most left.
<br>

### WHERE clause
> Filter data from August, 2021 till now.

### GROUP BY clause
> Group by product categories and customer segments.