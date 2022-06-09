# Question 6

> Calculate `incremental` `order counts` for every customer segments.

```sql
WITH m AS
	(SELECT *
	FROM order_table_ext
	LEFT JOIN user_table USING(user_id))

SELECT
	order_date, user_segment,
	COUNT(user_id) OVER(PARTITION BY user_segment ORDER BY order_date) AS running_total_orders
FROM m;
```
<br>

### WITH clause
> `LEFT JOIN` `order_table` and `user_table`, with `order_table` on the most left.

### SELECT clause
* `COUNT()` windows function counts `user_id` as the order counts.

* `PARTITION BY` divides rows into customer segments; `ORDER BY` order_date sorts dates from oldest to newest.

| order_date | user_segment | running_total_order |
| :---: | :---: | :---: |
| 2021-05-27 | Dolphin | 1 |
| 2021-07-01 | Dolphin | 2 |
| 2021-05-06 | Salon | 1 |
| 2021-08-10 | Salon | 2 |
| 2021-05-01 | Whale | 1 |
| 2021-07-06 | Whale | 2 |