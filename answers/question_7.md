# Question 7

> Calculate `average time` between `first` and `second order` for every customers and segments.

```sql
WITH m AS
	(SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY o.order_date) AS order_rnk,
		LAG(order_date) OVER(PARTITION BY u.user_id) AS snd_order_date
	FROM order_table_ext o
	LEFT JOIN user_table u USING(user_id))
, t AS
	(SELECT
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
```
<br>

### WITH clause
* `ROW_NUMBER` windows function groups rows by `user_id` and adds numbers to select `first` and `second` later on.
* `LAG()` windows function also groups rows by `user_id` and displays current value with its previous value.

	| user_id | order_date | order_rnk | snd_order_date
	| :---: | :---: | :---: | :---: |
	| 101 | 2021-05-01 | 1 | NULL |
	| 101 | 2021-07-05 | 2 | 2021-05-01 |
	| 102 | 2021-05-06 | 1 | NULL |
	| 102 | 2021-08-10 | 2 | 2021-05-06 |
	| 103 | 2021-05-27 | 1 | NULL |
	| 103 | 2021-07-01 | 2 | 2021-05-27 |

### Second WITH clause
> Filter out NULL rows and calculate `date_diff`.

### Final SELECT clause
> Calculate `avg_date_diff`.