# Question 4

> Find customers with `second highest` `order counts` within their segments in `July, 2021`.

```sql
WITH m AS
	(SELECT
		user_id, user_name, location,
		COUNT(user_id) AS order_counts
	FROM order_table_ext o
	LEFT JOIN user_table u USING(user_id)
	WHERE DATE_FORMAT(o.order_date, "%Y-%m") = "2021-07"
	GROUP BY user_id)
, t AS
	(SELECT
		*,
		DENSE_RANK() OVER(PARTITION BY location ORDER BY order_counts DESC) AS rnk
	FROM m)

SELECT user_id, user_name, location
FROM t
WHERE rnk = 2;
```
<br>

### WITH clause
* `GROUP BY` user_id and calculate total `order_counts` for every customers.

	| user_id | user_name | location | order_counts |
	| :---: | :---: | :---: | :---: | 
	| 104 | D | HCM | 2 |
	| 105 | E | HN | 3 |
	| 101 | A | HCM | 3 |
	| 102 | B | HN | 2 |
	| 103 | C | DN | 1 |

* `DENSE_RANK()` windows function displays "location" as _windows_ and `ranks` every rows within their _windows_.

	| user_id | user_name | location | order_counts | rnk |
	| :---: | :---: | :---: | :---: | :---: |
	| 103 | C | DN | 1 | 1 |
	| 101 | A | HCM | 3 | 1 |
	| 104 | D | HCM | 2 | 2 |
	| 105 | E | HN | 2 | 1 |
	| 102 | B | HN | 1 | 2 |

### Final WHERE clause
> Select customers with `rnk = 2`.