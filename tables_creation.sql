CREATE TABLE order_table (
    order_id BIGINT,
    order_date DATE,
    user_id BIGINT,
    product_cate_id INT,
    order_value FLOAT,
    PRIMARY KEY (order_id)
);

CREATE TABLE product_table (
    product_cate_id INT,
    product_cate_name VARCHAR(100),
    PRIMARY KEY (product_cate_id)
);

CREATE TABLE user_table (
    user_id BIGINT,
    user_name VARCHAR(10),
    location VARCHAR(10),
    user_segment VARCHAR(50),
    PRIMARY KEY (user_id)
);

ALTER TABLE order_table
	ADD FOREIGN KEY (product_cate_id) REFERENCES product_table(product_cate_id),
	ADD FOREIGN KEY (user_id) REFERENCES user_table(user_id)
ON DELETE SET NULL;

INSERT INTO product_table VALUES
(1, "bookks"), (2, "home_decor"), (3, "ultilities"), 
(4, "food"), (5, "mom_and_baby"), (6, "electronics");

INSERT INTO user_table VALUES
(101, 'A', 'HCM', 'Whale'),
(102, 'B', 'HN', 'Salon'),
(103, 'C', 'DN', 'Dolphin'),
(104, 'D', 'HCM', 'Whale'),
(105, 'E', 'HN', 'Dolphin');

INSERT INTO order_table VALUES
(150151, '2021-05-01', 101, 1, 150000),
(178151, '2021-05-06', 102, 5, 300000),
(178629, '2021-07-06', 101, 2, 250000),
(180053, '2021-07-01', 103, 3, 89000),
(184235, '2021-08-10', 102, 5, 50000),
(196325, '2021-05-27', 103, 4, 140000);