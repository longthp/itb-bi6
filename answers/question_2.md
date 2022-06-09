# Question 2

> Find customers who are from `"Whale"` and buy `"books"` in `June, 2021`.

```sql
WITH m AS
	(SELECT *
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
```
<br>

### WITH clause
> `LEFT JOIN` three tables, with `order_table` on the most left.
<br>

### WHERE clause
> Filter customers from `"Whale"` and buy `"books"` in June, 2021.
* `DATE_FORMAT()` converts all dates into "yyyy-mm".
* `AND` clause for conditions.
