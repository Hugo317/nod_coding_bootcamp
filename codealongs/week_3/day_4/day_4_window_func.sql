-- core syntax for window function

--Over()

SELECT *, AVG(meal_price) OVER() as avg_meal_price
FROM `nod-sql-copy.data_cleaning.meals`;


-- OVER() Partition BY

SELECT *, AVG(meal_price) OVER(PARTITION BY eatery) as avg_meal_price
FROM `nod-sql-copy.data_cleaning.meals`;

-- RANK () + OVER(ORDER BY)

SELECT *, RANK() OVER(ORDER BY meal_price) as meal_rank
FROM `nod-sql-copy.data_cleaning.meals`;

-- RANK() OVER(PARTITION BY ORDER BY)

SELECT *, RANK() OVER(PARTITION BY eatery ORDER BY meal_price) as meal_rank_per_eatery
FROM `nod-sql-copy.data_cleaning.meals`;

-- SUMMARY 

SELECT *, AVG(meal_price) OVER() AS avg_price, 
    AVG(meal_price) OVER (PARTITION BY eatery) as avg_price_eatery, 
    RANK() OVER(ORDER BY meal_price ) AS meal_rank,
    RANK() OVER(PARTITION BY eatery ORDER BY meal_price) as meal_rank_eatery
FROM `nod-sql-copy.data_cleaning.meals`;


-- MOVING AVERAGE

SELECT *,
FROM `nod-sql-copy.data_cleaning.orders`;

-- COUNT NO orders per id

SELECT COUNT(*) AS order_count,
    order_date
FROM `nod-sql-copy.data_cleaning.orders`
GROUP BY order_date
ORDER BY order_date;

-- MOVING AVG

SELECT *,
  AVG(order_count) 
  OVER(
    ORDER BY order_count
  ) as moving_avg
FROM(
  SELECT COUNT(*) AS order_count,
    order_date
  FROM `nod-sql-copy.data_cleaning.orders`
  GROUP BY order_date
  ORDER BY order_date
)
ORDER BY moving_avg;

-- COMULATIVE SUM

-- ORDER_COUNT PER MONTH 
-- INNER QUERRY
SELECT COUNT(*) AS corder_count,
    DATE_TRUNC(order_date, month) AS year_month
FROM `nod-sql-copy.data_cleaning.orders`
GROUP BY year_month;

--FINAL QUERRY


SELECT *,
  sum(order_count) OVER(ORDER BY year_month) AS order_count_comulative_sum
FROM(
  SELECT COUNT(*) AS order_count,
  DATE_TRUNC(order_date, month) AS year_month
  FROM `nod-sql-copy.data_cleaning.orders`
  GROUP BY year_month
);






