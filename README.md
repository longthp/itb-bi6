# Business Intelligence Season 6 - Round 1

# Table of Contents
| [Question 1](#question-1) | [Question 2](#question-2) | [Question 3](#question-3) | [Question 4](#question-4) | [Question 5](#question-5) | [Question 6](#question-6) | [Question 7](#question-7) |

> Tables
<details>
	<summary>order_table</summary>

| order_id | order_date | user_id | product_cate_id | order_value |
| ---: | ---: | ---: | ---: | ---: |
| 150151 | 01/05/2021 | 101 | 1 | 150000 |
| 178151 | 06/05/2021 | 102 | 5 | 300000 |
| 178629 | 06/07/2021 | 101 | 2 | 250000 |
| 180053 | 01/07/2021 | 103 | 3 | 89000 |
| 184235 | 10/08/2021 | 102 | 5 | 50000 |
| 196325 | 27/05/2021 | 103 | 4 | 140000 |

</details>
<br>

<details>
	<summary>product_table</summary>

| product_cate_id | product_cate_name |
| ---: | :--- |
| 1 | books |
| 2 | home_decor |
| 3 | ultilities |
| 4 | food |
| 5 | mom_and_baby |
| 6 | electronics |

</details>
<br>

<details>
	<summary>user_table</summary>

| user_id | user_name | location | user_segment |
| ---: | :--- | :--- | :--- |
| 101 | A | HCM | Whale |
| 102 | B | HN | Salon |
| 103 | C | DN | Dolphin |
| 104 | D | HCM | Whale |
| 105 | E | HN | Dolphin |

</details>
<hr>

## Question 1
> EER Diagram | Database: MySQL

<p align="center">
	<img width="700" src="assets/db_diagram.png">
<p>
<br>

## Question 2
> Find customers who are from `"Whale"` and buy `"books"` in `June, 2021`.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
> `LEFT JOIN` three tables, with `order_table` on the most left.

#### WHERE clause
> Filter customers from `"Whale"` and buy `"books"` in June, 2021.
* `DATE_FORMAT()` converts all dates into "yyyy-mm".
* `AND` clause for conditions.

</details>

---
## Question 3
> Find `total order value` for each `customer segments` and `product categories` from `August, 2021` till now.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
> `LEFT JOIN` three tables, with `order_table` on the most left.

#### WHERE clause
> Filter data from August, 2021 till now.

#### GROUP BY clause
> Group by product categories and customer segments.

</details>

---
## Question 4
> Find customers with `second highest` `order counts` within their segments in `July, 2021`.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
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

#### Final WHERE clause
> Select customers with `rnk = 2`.
</details>

---
## Question 5
> Find `first order value` for each customers in `May, 2021`.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
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

#### Final WHERE clause
> Select customers with `rnk = 1`.

</details>

---
## Question 6
> Calculate `incremental` `order counts` for every customer segments.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
> `LEFT JOIN` `order_table` and `user_table`, with `order_table` on the most left.

#### SELECT clause
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

</details>

---
## Question 7
> Calculate `average time` between `first` and `second order` for every customers and segments.

<details>
	<summary>Answer:</summary>

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

#### WITH clause
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

#### Second WITH clause
> Filter out NULL rows and calculate `date_diff`.

#### Final SELECT clause
> Calculate `avg_date_diff`.

</details>