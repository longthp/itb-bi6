# Question 5

> Find `first order value` for each customers in `May, 2021`.

```sql
WITH m AS
	(SELECT
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
```
<br>

### WITH clause
> `ROW_NUMBER()` windows function:
* `ORDER BY` order_date.
* Add numbers to every `customer` partitions.

	| user_id | user_name | order_value | rnk |
	| :---: | :---: | :---: | :---: | 
	| 101 | A | 150000 | 1 |
	| 101 | A | 100000 | 2 |
	| 101 | A | 15000 | 3 |
	| 102 | B | 300000 | 1 |
	| 102 | B | 20000 | 2 |
	| 102 | B | 20000 | 3 |
	| 103 | C | 140000 | 1 |
	| 104 | D | 30000 | 1 |
	| 104 | D | 13000 | 2 |
	| 105 | E | 20000 | 1 |
	| 105 | E | 90000 | 2 |
	| 105 | E | 20000 | 3 |	

### Final WHERE clause
> Select customers with `rnk = 1`.
