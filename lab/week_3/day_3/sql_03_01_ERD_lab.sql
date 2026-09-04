-------------------------------------------------------------------------------
------------------------- Entity Relations Diagrams ---------------------------
-------------------------------------------------------------------------------
-- Use the Bike Store database for these excercises
-- Strive for solving the problem using code!
-- (not through looking around in the output table)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- How many different stores are there and what are the names of the stores?
-- Answer:
-- Row	store_name
--1	 Santa Cruz Bikes
--2	 Baldwin Bikes
--3	 Rowlett Bikes
-------------------------------------------------------------------------------

SELECT store_name
FROM `nod-sql-copy.bike_stores.stores`;

-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- How many employees are working in each store?
-- Answer
-- Row	store_id	number_of_employees
-- 1	 1 		4
-- 2	 2 		3
-- 3	 3 		3
-------------------------------------------------------------------------------

SELECT store_id, COUNT(staff_id) AS number_of_employees
FROM `nod-sql-copy.bike_stores.stores`
JOIN `nod-sql-copy.bike_stores.staff` USING (store_id)
GROUP BY store_id;

-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- When was the first order made?
-- When was the last order made?
-- Answer:
-- first_order_date	last_order_date
-- 2016-01-01            2018-04-30
-------------------------------------------------------------------------------

SELECT MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date
FROM `nod-sql-copy.bike_stores.orders`;

-------------------------------------------------------------------------------
-- EXCERCISE 4:
-- Calculate the total number of orders
-- Correct answer: 1603
-------------------------------------------------------------------------------

SELECT COUNT(*)
FROM `nod-sql-copy.bike_stores.orders`;

-------------------------------------------------------------------------------
-- EXCERCISE 5:
-- Calculate the number of orders per year
/*
Row	order_count	year
1	635	2016-01-01
2	688	2017-01-01
3	280	2018-01-01
*/
-------------------------------------------------------------------------------

SELECT COUNT(order_id) AS order_count, EXTRACT(YEAR FROM order_date) AS year
FROM `nod-sql-copy.bike_stores.orders`
GROUP BY year
ORDER BY year;

-------------------------------------------------------------------------------
-- EXCERCISE 6:
-- Calculate the number of orders for each month in 2018
/*
Row	order_count	month
1	52	2018-01-01
2	35	2018-02-01
3	68	2018-03-01
4	125	2018-04-01
*/
-------------------------------------------------------------------------------

SELECT COUNT(order_id) AS order_count, EXTRACT(MONTH FROM order_date) AS month
FROM `nod-sql-copy.bike_stores.orders`
WHERE EXTRACT(YEAR FROM order_date) = 2018
GROUP BY month
ORDER BY month;

-------------------------------------------------------------------------------
-- EXCERCISE 7:
-- What was the total revenue of order_id 1?
-- Correct answer ~ 10231.05
-------------------------------------------------------------------------------
SELECT SUM(sum_per_id)
FROM(
    SELECT product_id, (quantity * list_price) * (1 - discount) AS sum_per_id
    FROM `nod-sql-copy.bike_stores.order_items`
    WHERE order_id = 1
    ORDER BY product_id
);

-- CHAT ANSWER

SELECT order_id, SUM(quantity * list_price * (1 - discount)) AS total
FROM `nod-sql-copy.bike_stores.order_items`
WHERE order_id = 1
GROUP BY order_id
ORDER BY order_id;

-- (quant x list price) x (1 - discount) = total price per item
-----------------------------------------------------------
--------------------
-- EXCERCISE 8:
-- What is the average revenue per order?
-- correct answer ~ 4765
-------------------------------------------------------------------------------
SELECT AVG(total_per_order) as order_avg
FROM(
    SELECT order_id, SUM(quantity * list_price * (1 - discount)) AS total_per_order
    FROM `nod-sql-copy.bike_stores.order_items`
    GROUP BY order_id
    ORDER BY order_id
);
-------------------------------------------------------------------------------
-- EXCERCISE 9:
-- Show the average list price per category (display the category name)
/*
Row	category_name		avg_list_price
1	Children Bicycles	288
2	Comfort Bicycles	682
3	Cruisers Bicycles	730
4	Cyclocross Bicycles	2543
5	Electric Bikes		3282
6	Mountain Bikes		1650
7	Road Bikes		3175
*/
-------------------------------------------------------------------------------

SELECT category_name, ROUND(AVG(list_price))
FROM `nod-sql-copy.bike_stores.production_products`
JOIN `nod-sql-copy.bike_stores.production_categories` USING(category_id)
GROUP BY category_name;
-------------------------------------------------------------------------------
-- EXCERCISE 10:
-- Create a table with the top 3 products in terms of quantity sold
-- Correct answer:
    -- 1 | Surly Ice Cream Truck Frameset - 2016 	| 167
    -- 2 | Electra Cruiser 1 (24-Inch) - 2016 		| 157
    -- 3 | Electra Townie Original 7D EQ - 2016 	| 156
-------------------------------------------------------------------------------

SELECT product_name, SUM(quantity) AS quant_sold
FROM `nod-sql-copy.bike_stores.production_products`
JOIN `nod-sql-copy.bike_stores.order_items` USING(product_id)
GROUP BY product_id, product_name
ORDER BY quant_sold DESC
LIMIT 3;

--1603
SELECT COUNT(*)
FROM `nod-sql-copy.bike_stores.orders`
WHERE order_status = 4;

-------------------------------------------------------------------------------
-- EXCERCISE 11:
-- Create a table with the top 3 products in terms of revenue
/*
Row	product_id	name				tot_product_revenue
1	7		Trek Slash 8 27.5 - 2016	555559
2	9		Trek Conduit+ - 2016		389249
3	4		Trek Fuel EX 8 29 - 2016	368473
*/
-------------------------------------------------------------------------------

SELECT product_id, p.product_name, SUM(nt.price_per_id_per_order) AS tot_rev_per_id
FROM `nod-sql-copy.bike_stores.production_products` AS p
JOIN (
    SELECT product_id, SUM(quantity * oi.list_price * (1 - discount)) as price_per_id_per_order
    FROM `nod-sql-copy.bike_stores.production_products` AS p
    JOIN `nod-sql-copy.bike_stores.order_items` AS oi USING(product_id) 
    GROUP BY oi.list_price,discount,product_id
    ORDER BY product_id
)AS nt USING (product_id)
GROUP BY product_id,p.product_name
ORDER BY tot_rev_per_id DESC
LIMIT 3;


-------------------------------------------------------------------------------
-- EXCERCISE 12:
-- You want to send out a marketing campaign targeted at customers ...
-- ... that has made a purchase in the last month.
-- Get a list of all email addresses for those customers

-- NOTE! Assume that today is the 30th of april in 2018 (2018-04-30)
-- Your query should return 125 rows
-------------------------------------------------------------------------------

SELECT DISTINCT(email)
FROM `nod-sql-copy.bike_stores.customers`
WHERE customer_id IN (
    SELECT customer_id
    FROM `nod-sql-copy.bike_stores.orders`
    WHERE DATE_DIFF("2018-04-30", order_date, MONTH) < 1
)
ORDER BY email;

-------------------------------------------------------------------------------
-- EXERCISE 13: Answer the questions below with three separate queries
-- 13.1: How many unique customers are there?
    -- 1445
-- 13.2: How many unique customers have made an order in 2018?
    -- 267
-- 13.3: How many new unique customers have made an order in 2018?
    -- 149
-------------------------------------------------------------------------------

SELECT COUNT(*) as no_customers
FROM `nod-sql-copy.bike_stores.customers`;

SELECT COUNT(DISTINCT(customer_id))
FROM `nod-sql-copy.bike_stores.orders`
WHERE DATE_DIFF("2018-12-31", order_date, YEAR) < 1;

SELECT COUNT(DISTINCT(customer_id))
FROM `nod-sql-copy.bike_stores.orders`
WHERE DATE_DIFF("2018-12-31", order_date, YEAR) < 1 
    AND customer_id NOT IN(
        SELECT customer_id
        FROM `nod-sql-copy.bike_stores.customers` AS c
        JOIN `nod-sql-copy.bike_stores.orders` AS o USING(customer_id)
        WHERE order_date < "2018-01-01"
        GROUP BY customer_id
    );

-------------------------------------------------------------------------------
-- EXCERCISE 14:
-- Create a list of brand names for all brands ...
-- ... that have 10 or more different products
-- Answer:
-- Row	no_of_products	brand
--1	10	Haro
--2	23	Sun Bicycles
--3	25	Surly
--4	118	Electra
--5	135	Trek
---------------------
-------------------------------------------------------------------------------

SELECT COUNT(product_id) as prod_count, brand_name
FROM `nod-sql-copy.bike_stores.production_products`
JOIN `nod-sql-copy.bike_stores.production_brands` USING(brand_id)
GROUP BY brand_name
HAVING prod_count > 9
ORDER BY prod_count;


-------------------------------------------------------------------------------
-- EXERCISE 15:
-- Create a table with the total revenue per brand
-- Which are the top three brands?
-- Row	Brand	 	total_sales
-- 1	 Trek 	 	4568708.0
-- 2	 Electra 	1193396.0
-- 3	 Surly 	 	947338.0
-- 4	 Sun Bicycles   339606.0
-- 5	 Haro 		185385.0
-- 6	 Heller 	171459.0
-- 7	 Pure Cycle 	149476.0
-- 8	 Ritchey 	78899.0
-- 9	 Strider 	4320.0
-------------------------------------------------------------------------------

SELECT brand_name, SUM(quantity * oi.list_price * (1 - discount)) AS total_sales
FROM `nod-sql-copy.bike_stores.order_items` as oi
JOIN `nod-sql-copy.bike_stores.production_products` as p USING(product_id)
JOIN `nod-sql-copy.bike_stores.production_brands` as b USING(brand_id)
GROUP BY brand_name;

-------------------------------------------------------------------------------
-- EXCERCISE 16:
-- What is the total revenue for each store in 2018?
/*
Row	store_id	total_revenue	store_name
1	1		471683		Santa Cruz Bikes
2	2		1122675		Baldwin Bikes
3	3		169643		Rowlett Bikes
*/
-------------------------------------------------------------------------------
SELECT store_id, ROUND(SUM(total_sales)) as sales_per_store
FROM(
    SELECT s.store_id, o.order_id, SUM(quantity * oi.list_price * (1 - discount)) AS total_sales
    FROM `nod-sql-copy.bike_stores.stores` AS s
    JOIN `nod-sql-copy.bike_stores.orders` AS o USING(store_id)
    JOIN `nod-sql-copy.bike_stores.order_items` AS oi USING(order_id)
    GROUP BY s.store_id,o.order_id
)
WHERE order_id IN (
    SELECT order_id
    FROM `nod-sql-copy.bike_stores.orders`
    WHERE order_date > "2017-12-31" AND order_date < "2019-01-01"
)
GROUP BY store_id;

-------------------------------------------------------------------------------
-------------------------- DATA CLEANING Questions ----------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- Who is the manager of Kali Vargas (staff_id = 8)
-- Row		staff_id 	first_name 	last_name		
-- 1		1	 	Fabiola    	Jackson	
-------------------------------------------------------------------------------

SELECT staff_id, first_name, last_name
FROM `nod-sql-copy.bike_stores.staff`
WHERE staff_id IN(
    SELECT CAST(manager_id AS int64)
    FROM `nod-sql-copy.bike_stores.staff`
    WHERE staff_id = 8);
-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- What percentage of time is the delivery on time?
-- Definition of deliviery on time: 
    -- shipped date <= required date
-- 0.68
-------------------------------------------------------------------------------

SELECT order_id, required_date, shipped_date
FROM `nod-sql-copy.bike_stores.orders`
WHERE shipped_date IS NOT NULL;

SELECT ROUND(AVG(CASE
  WHEN required_date >= shipped_date_int THEN 1
  ELSE 0
END)) AS avg_shipped_in_time
FROM(
    SELECT order_id, required_date, CAST(shipped_date AS DATE) AS shipped_date_int
    FROM `nod-sql-copy.bike_stores.orders`
    WHERE shipped_date IS NOT NULL
);

-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- What is the average delay when the delivery is not on time?
-- Answer: 1.33
-------------------------------------------------------------------------------

SELECT ROUND(AVG(DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY)),2)
FROM `nod-sql-copy.bike_stores.orders`
WHERE shipped_date IS NOT NULL AND CAST(shipped_date AS DATE) > required_date;

-------------------------------------------------------------------------------
-------------------------- Lab finished, Well done ------------------------------
----------------------------- BONUS QUESTIONS ---------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Bonus 1:
-- Select the customer_id & mail of all customers ...
-- ... who have made 2 or more orders in 2018
-- 13 rows
-------------------------------------------------------------------------------

SELECT customer_id, email
FROM `nod-sql-copy.bike_stores.customers`
WHERE customer_id IN (
    SELECT customer_id
    FROM `nod-sql-copy.bike_stores.orders`
    WHERE order_date >= "2018-01-01" AND  "2018-12-31" >= order_date
    GROUP BY customer_id
    HAVING COUNT(customer_id) > 1
)
ORDER BY customer_id, email;

-------------------------------------------------------------------------------
-- Bonus 2:
-- Get the email addresses for every customer that has bought an
-- "Electra Cruiser 1 (24-Inch) - 2016" in the last 12 months
-- (today is 2018-04-30)
-- Your query should return 28 rows
-------------------------------------------------------------------------------

SELECT email
FROM `nod-sql-copy.bike_stores.customers`
WHERE customer_id IN (
    SELECT DISTINCT(customer_id)
    FROM `nod-sql-copy.bike_stores.orders`
    JOIN `nod-sql-copy.bike_stores.order_items` as oi USING(order_id)
    JOIN `nod-sql-copy.bike_stores.production_products` as p USING(product_id)
    WHERE product_name = "Electra Cruiser 1 (24-Inch) - 2016" AND DATE_DIFF("2018-04-30",order_date,MONTH) < 12
);

-------------------------------------------------------------------------------
-- Bonus 3:
-- Identify the employee of the month in jan 2018
-- Employee of the month = employee with highest total sum of sales
/*
staff_id	first_name	second_name	tot_sales
6	          Marcelene	  Boyer	     186758
*/

-------------------------------------------------------------------------------
--SUM(quantity * oi.list_price * (1 - discount)) as sales
SELECT staff_id, first_name, last_name, SUM(quantity * oi.list_price * (1 - discount)) as total_sales
FROM `nod-sql-copy.bike_stores.staff`
JOIN `nod-sql-copy.bike_stores.orders` as o USING(staff_id)
JOIN `nod-sql-copy.bike_stores.order_items` as oi USING(order_id)
--JOIN `nod-sql-copy.bike_stores.production_products` as p USING(product_id)
WHERE order_date >= "2018-01-01" AND  "2018-01-31" >= order_date
GROUP BY staff_id, first_name, last_name
ORDER BY total_sales DESC
LIMIT 1;

-------------------------------------------------------------------------------
-- Bonus 4:
-- Create a table that shows the change in total revenue on a monthly basis ...
-- ... for the months in 2018. The change should be expressed in percentages
/*
Row	pct_change	month
1	-47	2018-02-01
2	81	2018-03-01
3	125	2018-04-01
*/
-- Note: The revenue went down by 47% in jan-feb, then up 81% in feb-march, ...
-- .. then up 125% in march-april 
-------------------------------------------------------------------------------
SELECT month_of_sale,total_sales, (total_sales - previous_sales) / previous_sales * 100
FROM(
    SELECT month_of_sale,total_sales,
    LAG(total_sales) OVER (ORDER BY month_of_sale) AS previous_sales
    FROM(
        SELECT DATE_TRUNC(order_date, MONTH) as month_of_sale, SUM(quantity * oi.list_price * (1 - discount)) as total_sales
        FROM `nod-sql-copy.bike_stores.orders`
        JOIN `nod-sql-copy.bike_stores.order_items` as oi USING(order_id)
        GROUP BY month_of_sale
        HAVING month_of_sale > "2017-12-30"
))
ORDER BY month_of_sale
