CREATE DATABASE sales_analytics;

USE sales_analytics;

SELECT DATABASE();

DROP TABLE IF EXISTS sales_raw;


CREATE TABLE sales_raw (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(5,4),
    profit DECIMAL(12,4)
);


SHOW VARIABLES LIKE 'secure_file_priv';

TRUNCATE TABLE sales_raw;

SELECT COUNT(*) AS total_rows
FROM sales_raw;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore_orders.csv'
INTO TABLE sales_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT COUNT(*) AS total_rows
FROM sales_raw;

SELECT
    COUNT(*) AS total_rows,
    SUM(row_id IS NULL) AS missing_row_id,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(ship_date IS NULL) AS missing_ship_date,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(category IS NULL) AS missing_category,
    SUM(sales IS NULL) AS missing_sales,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(discount IS NULL) AS missing_discount,
    SUM(profit IS NULL) AS missing_profit
FROM sales_raw;

SELECT
    row_id,
    COUNT(*) AS occurrence_count
FROM sales_raw
GROUP BY row_id
HAVING COUNT(*) > 1;

SELECT
    order_date,
    ship_date
FROM sales_raw
LIMIT 10;

SELECT DISTINCT category
FROM sales_raw
ORDER BY category;

SELECT DISTINCT region
FROM sales_raw
ORDER BY region;

SELECT DISTINCT segment
FROM sales_raw
ORDER BY segment;

CREATE TABLE sales AS
SELECT
    row_id,
    TRIM(order_id) AS order_id,

    STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date,
    STR_TO_DATE(ship_date, '%d-%m-%Y') AS ship_date,

    TRIM(ship_mode) AS ship_mode,
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(segment) AS segment,
    TRIM(country) AS country,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(postal_code) AS postal_code,
    TRIM(region) AS region,
    TRIM(product_id) AS product_id,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    TRIM(product_name) AS product_name,

    sales,
    quantity,
    discount,
    profit

FROM sales_raw;

SELECT COUNT(*) AS total_rows
FROM sales;

SELECT *
FROM sales
LIMIT 10;

SELECT
    order_date,
    ship_date
FROM sales
LIMIT 10;

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM sales;



SELECT
    MIN(ship_date) AS first_ship_date,
    MAX(ship_date) AS last_ship_date
FROM sales;


DESCRIBE sales;


# updating the columns 

ALTER TABLE sales
ADD COLUMN shipping_days INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET shipping_days = DATEDIFF(ship_date, order_date);

ALTER TABLE sales
ADD COLUMN order_year INT;

UPDATE sales
SET order_year = YEAR(order_date);

ALTER TABLE sales
ADD COLUMN order_month INT;

UPDATE sales
SET order_month = MONTH(order_date);

ALTER TABLE sales
MODIFY COLUMN profit_margin DECIMAL(12,6);


UPDATE sales
SET profit_margin =
    CASE
        WHEN sales = 0 THEN 0
        ELSE profit / sales
    END;

SET SQL_SAFE_UPDATES = 1;


	SELECT
		row_id,
		sales,
		profit,
		profit_margin
	FROM sales
	LIMIT 10;


SELECT COUNT(*) AS null_profit_margin
FROM sales
WHERE profit_margin IS NULL;


SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM sales;


SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM sales
GROUP BY category
ORDER BY total_sales DESC;


SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM sales
GROUP BY region
ORDER BY total_sales DESC;


SELECT
    order_year,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales
GROUP BY order_year
ORDER BY order_year;


SELECT
    order_year,
    order_month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;


SELECT
    customer_id,
    customer_name,
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY customer_id, customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    MIN(shipping_days) AS min_shipping_days,
    MAX(shipping_days) AS max_shipping_days
FROM sales
GROUP BY ship_mode
ORDER BY avg_shipping_days;



# views -----------------------------------------------------------------------------------------------------

USE sales_analytics;

CREATE VIEW vw_monthly_performance AS
SELECT
    order_year,
    order_month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY order_year, order_month;


SELECT *
FROM vw_monthly_performance
ORDER BY order_year, order_month;


CREATE VIEW vw_category_performance AS
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    AVG(discount) AS average_discount
FROM sales
GROUP BY category;


SELECT *
FROM vw_category_performance
ORDER BY total_sales DESC;


CREATE VIEW vw_regional_performance AS
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales
GROUP BY region;


SELECT *
FROM vw_regional_performance
ORDER BY total_sales DESC;


CREATE VIEW vw_customer_performance AS
SELECT
    customer_id,
    customer_name,
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY customer_id, customer_name, segment;


SELECT *
FROM vw_customer_performance
ORDER BY total_sales DESC
LIMIT 10;


SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';


SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';


# star schema -------------------------------------------------------------------------------------------------------------
 
CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM sales;

SELECT COUNT(*) AS customer_count
FROM dim_customer;

CREATE TABLE dim_product AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM sales;

SELECT COUNT(*) AS product_count
FROM dim_product;

CREATE TABLE dim_location AS
SELECT DISTINCT
    country,
    city,
    state,
    postal_code,
    region
FROM sales;

SELECT COUNT(*) AS location_count
FROM dim_location;


CREATE TABLE dim_ship_mode AS
SELECT DISTINCT
    ship_mode
FROM sales;

SELECT *
FROM dim_ship_mode;



CREATE TABLE dim_date (
    date DATE PRIMARY KEY,
    year INT,
    quarter INT,
    month_number INT,
    month_name VARCHAR(20),
    year_month_label VARCHAR(7)
);

INSERT INTO dim_date
SELECT
    d.date,
    YEAR(d.date) AS year,
    QUARTER(d.date) AS quarter,
    MONTH(d.date) AS month_number,
    MONTHNAME(d.date) AS month_name,
    DATE_FORMAT(d.date, '%Y-%m') AS year_month_label
FROM (
    SELECT DISTINCT order_date AS date
    FROM sales
) d;


SELECT COUNT(*) AS date_count
FROM dim_date;

SELECT *
FROM dim_date
ORDER BY date
LIMIT 10;



# facts table ------------------------------------------------------------------------------------------------------------------------

CREATE TABLE fact_sales AS
SELECT
    row_id,
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    country,
    city,
    state,
    postal_code,
    ship_mode,
    sales,
    quantity,
    discount,
    profit,
    shipping_days
FROM sales;

 
 
 SELECT COUNT(*) AS fact_sales_count
FROM fact_sales;


SELECT
    customer_id,
    COUNT(*) AS count_rows
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;


ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_id);


DESCRIBE dim_customer;
 
 SELECT
    product_id,
    COUNT(*) AS count_rows
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;
 
 
 DROP TABLE dim_product;
 
 CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);



INSERT INTO dim_product (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM sales;


SELECT COUNT(*) AS product_count
FROM dim_product;

SELECT *
FROM dim_product
ORDER BY product_key
LIMIT 10;

DROP TABLE dim_location;


CREATE TABLE dim_location (
    location_key INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);



INSERT INTO dim_location (
    country,
    city,
    state,
    postal_code,
    region
)
SELECT DISTINCT
    country,
    city,
    state,
    postal_code,
    region
FROM sales;


SELECT COUNT(*) AS location_count
FROM dim_location;

SELECT *
FROM dim_location
ORDER BY location_key
LIMIT 10;
 
 
 
 SELECT
    ship_mode,
    COUNT(*) AS count_rows
FROM dim_ship_mode
GROUP BY ship_mode
HAVING COUNT(*) > 1;

ALTER TABLE dim_ship_mode
ADD PRIMARY KEY (ship_mode);


SELECT *
FROM dim_ship_mode;

DESCRIBE dim_ship_mode;



SELECT
    customer_id,
    COUNT(*) AS count_rows
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;



DESCRIBE dim_customer;

SELECT COUNT(*) AS unmatched_products
FROM fact_sales f
LEFT JOIN dim_product p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT COUNT(*) AS unmatched_locations
FROM fact_sales f
LEFT JOIN dim_location l
    ON f.country = l.country
    AND f.city = l.city
    AND f.state = l.state
    AND f.postal_code = l.postal_code
WHERE l.location_key IS NULL;



SELECT COUNT(*) AS unmatched_customers
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*) AS unmatched_ship_modes
FROM fact_sales f
LEFT JOIN dim_ship_mode s
    ON f.ship_mode = s.ship_mode
WHERE s.ship_mode IS NULL;


SELECT COUNT(*) AS unmatched_dates
FROM fact_sales f
LEFT JOIN dim_date d
    ON f.order_date = d.date
WHERE d.date IS NULL;


RENAME TABLE fact_sales TO fact_sales_old;

CREATE TABLE fact_sales (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    product_key INT,
    location_key INT,
    ship_mode VARCHAR(50),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),
    shipping_days INT
);


DESCRIBE fact_sales;

DESCRIBE sales;


ALTER TABLE fact_sales
MODIFY COLUMN sales DECIMAL(12,4);

ALTER TABLE fact_sales
MODIFY COLUMN discount DECIMAL(5,4);

ALTER TABLE fact_sales
MODIFY COLUMN profit DECIMAL(12,4);

TRUNCATE TABLE fact_sales;


INSERT INTO fact_sales (
    row_id,
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_key,
    location_key,
    ship_mode,
    sales,
    quantity,
    discount,
    profit,
    shipping_days
)
SELECT
    s.row_id,
    s.order_id,
    s.order_date,
    s.ship_date,
    s.customer_id,
    p.product_key,
    l.location_key,
    s.ship_mode,
    s.sales,
    s.quantity,
    s.discount,
    s.profit,
    s.shipping_days
FROM sales s
JOIN dim_product p
    ON s.product_id = p.product_id
    AND s.product_name = p.product_name
    AND s.category = p.category
    AND s.sub_category = p.sub_category
JOIN dim_location l
    ON s.country = l.country
    AND s.city = l.city
    AND s.state = l.state
    AND s.postal_code = l.postal_code;
    
    
SELECT COUNT(*) AS fact_rows
FROM fact_sales;


SELECT
    row_id,
    sales,
    profit,
    discount
FROM fact_sales
LIMIT 10;


SELECT
    (SELECT COUNT(*) FROM sales) AS sales_rows,
    (SELECT COUNT(*) FROM fact_sales) AS fact_rows,
    (SELECT SUM(sales) FROM sales) AS sales_total,
    (SELECT SUM(sales) FROM fact_sales) AS fact_sales_total,
    (SELECT SUM(profit) FROM sales) AS profit_total,
    (SELECT SUM(profit) FROM fact_sales) AS fact_profit_total;
    
    
SELECT COUNT(*) AS unmatched_customers
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*) AS unmatched_products
FROM fact_sales f
LEFT JOIN dim_product p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

SELECT COUNT(*) AS unmatched_locations
FROM fact_sales f
LEFT JOIN dim_location l
    ON f.location_key = l.location_key
WHERE l.location_key IS NULL;


SELECT COUNT(*) AS unmatched_ship_modes
FROM fact_sales f
LEFT JOIN dim_ship_mode s
    ON f.ship_mode = s.ship_mode
WHERE s.ship_mode IS NULL;

SELECT COUNT(*) AS unmatched_dates
FROM fact_sales f
LEFT JOIN dim_date d
    ON f.order_date = d.date
WHERE d.date IS NULL;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT row_id) AS unique_row_ids
FROM fact_sales;

SELECT
    (SELECT COUNT(*) FROM sales) AS sales_rows,
    (SELECT COUNT(*) FROM fact_sales) AS fact_rows,
    (SELECT COUNT(*) FROM dim_customer) AS customers,
    (SELECT COUNT(*) FROM dim_product) AS products,
    (SELECT COUNT(*) FROM dim_location) AS locations,
    (SELECT COUNT(*) FROM dim_ship_mode) AS ship_modes,
    (SELECT COUNT(*) FROM dim_date) AS dates;
    
    
SELECT MIN(order_date) AS min_date,
       MAX(order_date) AS max_date,
       DATEDIFF(MAX(order_date), MIN(order_date)) + 1 AS expected_dates
FROM sales;

TRUNCATE TABLE dim_date;

INSERT INTO dim_date (
    `date`,
    `year`,
    `quarter`,
    `month_number`,
    `month_name`,
    `year_month_label`
)
SELECT
    DATE_ADD('2014-01-03', INTERVAL n DAY) AS `date`,
    YEAR(DATE_ADD('2014-01-03', INTERVAL n DAY)) AS `year`,
    QUARTER(DATE_ADD('2014-01-03', INTERVAL n DAY)) AS `quarter`,
    MONTH(DATE_ADD('2014-01-03', INTERVAL n DAY)) AS `month_number`,
    MONTHNAME(DATE_ADD('2014-01-03', INTERVAL n DAY)) AS `month_name`,
    DATE_FORMAT(DATE_ADD('2014-01-03', INTERVAL n DAY), '%Y-%m') AS `year_month_label`
FROM (
    SELECT
        a.n + b.n * 10 + c.n * 100 + d.n * 1000 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
         UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
         UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
) numbers
WHERE n <= 1457;

SELECT
    COUNT(*) AS total_dates,
    MIN(`date`) AS first_date,
    MAX(`date`) AS last_date
FROM dim_date;


SELECT
    `date`,
    COUNT(*) AS occurrences
FROM dim_date
GROUP BY `date`
HAVING COUNT(*) > 1;


SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM fact_sales;