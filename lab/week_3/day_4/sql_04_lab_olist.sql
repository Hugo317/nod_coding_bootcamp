----------------------------------------------------------------------------------
-- BUSINESS REPORT
-- You are a data analyst at Nod Consulting and it is time for a business report for one of your customres. 
-- Your task is to answer below questions. 
-- Note to have a business mindest, is there anything worth highlighting? Feel free to explore more around the suggested questions

----------------------------------------------------------------------------------
----------------------------------- PART 1----------------------------------------  
-- This first part of the lab is to get familiar with the dataset and the different tables
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- QUESTION 1 
-- What different products are there in the data set?
-- Output
-- 32951
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
-- QUESTION 2 
-- What are the top best-sell 10 product categories in the dataset?
-- OUTPUT	

/*
Row counter product_category_name 
1 cama_mesa_banho     11115
2 beleza_saude      9670
3 esporte_lazer       8641
4 moveis_decoracao    8334
5 informatica_acessorios  7827
6 utilidades_domesticas   6964
7 relogios_presentes    5991
8 telefonia         4545
9 ferramentas_jardim    4347
10  automotivo        4235
*/
----------------------------------------------------------------------------------



----------------------------------------------------------------------------------
-- QUESTION 3 
-- How many purchases where there per month in 2018?

--Row	month				order_number_per_mponth	
--1	2018-01-01 00:00:00 UTC 	7269
--2	2018-02-01 00:00:00 UTC 	6728
--3	2018-03-01 00:00:00 UTC 	7211

----------------------------------------------------------------------------------



----------------------------------------------------------------------------------
-- QUESTION 4
-- What is the order status per order in 2018?
-- 7
/*
Row	order_status		
1 created
2   shipped
3   canceled
4   invoiced
5   delivered
6   processing
7   unavailable 
*/ 

----------------------------------------------------------------------------------



------------------------------------------------------------------------
-- QUESTION 5 
-- Let’s check the order_status in orders. 
-- There are 8 order_status. How many percent of each status in orders?
-- Output:

-- Row	order_status	pct_of_order_status	
/*
Row order_status  pct_of_order_status 
1 delivered       0.9702
2 shipped         0.0111
3 canceled        0.0063
4 unavailable     0.0061
5 invoiced        0.0032
6 processing      0.003
7 created         0.0001
8 approved        0.0
*/

------------------------------------------------------------------------






----------------------------------------------------------------------------------
-- QUESTION 6 
-- what payment type has been used in 2018
-- total per month
-- filter out 'not_defined'
-- output
/*
ow	month						payment_type	count_	
1	2018-01-01 00:00:00 UTC 	boleto 			1518
2	2018-01-01 00:00:00 UTC 	credit_card 	5520
3	2018-01-01 00:00:00 UTC 	debit_card 		109
*/
----------------------------------------------------------------------------------



----------------------------------------------------------------------------------
-- GREAT! NOW YOU ARE WARM IN YOUR FINGERS AND ARE READY FOR SOME TRICKIER QUESTIONS! 
---------------------------------- PART 2----------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- * QUESTION 1 
-- What is the share (%) of each payment_type of the total
-- You can skip payment type = 'not_defined'

-- output 
/*
Row payment_type  pct_of_payment  
1  credit_card    0.739
2  boleto         0.19
3  voucher        0.056
4  debit_card     0.015
*/
----------------------------------------------------------------------------------
-- hints (if you need):
-- calculate total number of each payment (tot_number)
-- get all number of order_payments (all_payment)
-- tot_number/all_payment
----------------------------------------------------------------------------------





----------------------------------------------------------------------------------
--QUESTION 2 
--Monthly order per state
-- Query out rows WHERE values are missing 
----------------------------------------------------------------------------------
-- hints (if you need):
-- using null
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--QUESTION 3 
-- Get the top 3 states with the highest order count and rank it
-- output 
/*
Row customer_state  tot_per_state rank  
1 SP 41746            1
2 RJ 12852            2
3 MG 11635            3
*/
---------------------------------------------------------------------------------
-- hints (if you need):
-- label the rank of states based on the total order using WINDOW function
----------------------------------------------------------------------------------






----------------------------------------------------------------------------------
-- QUESTION 4 
-- Divide customers into buckets depending on how much they have spent per order
-- Count how number of customers and average payment_value for each bucket
-- Use unique customer ids
-- You can decide size and number of buckets on your own (in example 4 buckets are 
-- used at intervals 0-100, 101-200, 201-300, >300)

/*

Row   bucket        counter avg_payment_value 
1     Low           47259   60.25
2     Medium        31533   142.48
3     High          9819    240.15
4     Mega-spender  10829   582.75
*/
----------------------------------------------------------------------------------
-- COMMENT TO TEACHER: In the first part of this (payments) query you get the total payment value per customer (in case there are more payments per order_id)
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
-- * QUESTION  5 
-- PRODUCT
-- What is the most popular product (product_category_name) per state 
-- The output should order by the name of states
-- output 
/*
Row	    customer_state	     product_category_name		
1	      AC 		               moveis_decoracao 		
2	      AL 		               beleza_saude 			
3	      AM 		               beleza_saude 		
...
25     	  SE                       beleza_saude 
26        SP                   	   cama_mesa_banho
27        TO                       beleza_saude
...
*/
----------------------------------------------------------------------------------
-- hints (if you need):
-- first SubQuery: JOIN all tables you need in a right direction
-- second SubQuery: use the WINDOW function to label the ranking of the best-selling product category per state
-- the last step: keep the product whose rank is 1
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
-- QUESTION  6 
-- get the percentage change of order number per month in 2017
-- output
/*
Row month pct_change
1   1     null
2   2     1.23
3   3     0.51
...
11  11    0.63
12  12    -0.25
*/
-----------------------------------------------------------------------------------


