SELECT * -- * means all collumns
FROM `nod-sql-copy.emp.employees`;

-- ctrl + enter to execute
-- should mark the quary before running wiht ( selecting // highlighting)

SELECT first_name, last_name -- only this 2 commouns show 
FROM `nod-sql-copy.emp.employees`;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------------ ORDER BY and DESC ------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

SELECT first_name, last_name
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name;

SELECT first_name, last_name
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name DESC;

SELECT first_name, last_name
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name DESC, last_name DESC;

SELECT first_name, last_name
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name, last_name DESC;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--------------------- The importance of SQL readability -----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Code is read 10x more than it is written

-- You can run the code below.
select first_name, last_name from `nod-sql-copy.emp.employees` order by first_name DESC, last_name DESC;
-- But it is not nice nor efficient to read

-------------------------------------------------------------------------------
-- Quick introduction to SQL formater
-- https://poorsql.com/
-- indent string: \s\s\s\s
-- max line width: 79
-------------------------------------------------------------------------------


-- Copy & paste query above into formatter ^

-- Will give you the structure shown below. Much more readable

SELECT first_name,
         last_name
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name DESC, 
        last_name DESC;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------------------- WHERE Statement ---------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE first_name = "Maria";

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE birth_date > "1964-01-01";

-------------------------------------------------------------------------------
------------------------------------   AND   ----------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introducing AND
-- To require two boolean expressions to be True
-------------------------------------------------------------------------------
SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE first_name = "Elvis" 
    AND gender = "M"
    AND birth_date >= "1964-01-01" 
    AND emp_no < 100000;

    -- Syntax (grammer)
    -- Text data: inside of quotation marks
    -- Date data: inside of quotation marks
    -- Numerical data: no quotation marks


-------------------------------------------------------------------------------
------------------------------------   OR   -----------------------------------
-------------------------------------------------------------------------------


-- OR
-- To require AT LEAST ONE of the boolean expressions to be True
-------------------------------------------------------------------------------
    
SELECT first_name,
         last_name
FROM `nod-sql-copy.emp.employees`
WHERE (first_name = "Elvis"
    OR first_name = "Maria")
    AND birth_date > "1964-12-31";


-------------------------------------------------------------------------------
--------------------------------   IN / NOT IN   ------------------------------
-------------------------------------------------------------------------------

SELECT first_name,
         last_name
FROM `nod-sql-copy.emp.employees`
    WHERE first_name IN ("Elvis","Maria", "Aemer");

SELECT first_name,
         last_name
FROM `nod-sql-copy.emp.employees`
    WHERE first_name NOT IN ("Elvis","Maria", "Aemer");


SELECT *
FROM `nod-sql-copy.emp.employees`
    WHERE hire_date BETWEEN "1991-01-01" AND "2000-12-31";


-------------------------------------------------------------------------------
------------------------------------   LIKE   ---------------------------------
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
    WHERE first_name LIKE ("Mar%"); -- followed by any nr of characters

SELECT *
FROM `nod-sql-copy.emp.employees`
    WHERE first_name LIKE ("Mar_"); -- Strating with Mar +1 character

    SELECT *
FROM `nod-sql-copy.emp.employees`
    WHERE first_name LIKE ("Mar__"); -- Strating with Mar +2 character

SELECT *
FROM `nod-sql-copy.emp.employees`
    WHERE first_name LIKE ("_ar%"); -- just cmbine like %x__ or %x% idk make some shit up

-------------------------------------------------------------------------------
------------------------------- SUMMARY WHERE  --------------------------------
-------------------------------------------------------------------------------
/*
We have now looked at a bunch of Keywords we can use in the WHERE STATEMENT:

    - AND
    - OR
    - IN / NOT IN
    - BETWEEN
    - LIKE

The Where statement is used to filter rows of data!

*/
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
----------------------------------- DISTINCT ----------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Returns the unique values for a column
-------------------------------------------------------------------------------


    SELECT DISTINCT(gender)
FROM `nod-sql-copy.emp.employees`;

SELECT DISTINCT(first_name)
FROM `nod-sql-copy.emp.employees`
ORDER BY first_name;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------- AGGREGATE FUNCTIONS ------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Introducing AGGREGATE FUNCTIONS
-- COUNT, MIN, MAX, AVG, SUM
-------------------------------------------------------------------------------


SELECT COUNT(*)
FROM `nod-sql-copy.emp.salaries`;

SELECT COUNT(*)
FROM `nod-sql-copy.emp.salaries`
WHERE salary >= 100000;


-- MAX
SELECT MAX(salary)
FROM `nod-sql-copy.emp.salaries`;


-- MIN
SELECT MIN(salary)
FROM `nod-sql-copy.emp.salaries`;


-- AVG
SELECT AVG(salary)
FROM `nod-sql-copy.emp.salaries`;


-- SUM
SELECT SUM(salary)
FROM `nod-sql-copy.emp.salaries`;


-- AVG renamed
SELECT AVG(salary) AS avg_salary
FROM `nod-sql-copy.emp.salaries`;

-- GROUP BY
SELECT gender, -- ordinal column
    COUNT(*) AS nr_of -- nominal column
FROM `nod-sql-copy.emp.employees`
GROUP BY gender;

SELECT COUNT(title) AS no_of,
    title
FROM `nod-sql-copy.emp.titles`
GROUP BY title;

SELECT t.title,
    ROUND(AVG(s.salary)) avg_salary,
    MIN(s.salary) min_salary,
    MAX(s.salary) max_salary,
    COUNT(s.salary) title_count,
FROM `nod-sql-copy.emp.salaries` t
RIGHT JOIN `nod-sql-copy.emp.salaries` as s using(emp_no)
GROUP BY t.title;


-- Can we group by more than one column?
-- Yes we can! To do that I will join in one more table so that we can group by job title and gender.
-- So for example: we will be able to see what is the avg salary for senior engineers compared
SELECT t.title,
    e.gender,
    ROUND(AVG(s.salary)) avg_salary,
    MIN(s.salary) min_salary,
    MAX(s.salary) max_salary,
    COUNT(s.salary) title_count,
FROM `nod-sql-copy.emp.salaries` t
RIGHT JOIN `nod-sql-copy.emp.salaries` as s using(emp_no)
LEFT JOIN `nod-sql-copy.emp.salaries` as e using(emp_no)
GROUP BY t.title, e.gender
ORDER BY t.title;


-- When using GROUP BY with WHERE statement, we are filtering out rows before we do the aggregation.
-- If I specify to_date = "9999-01-01", I will get the avg salary based on people who currently work here.
SELECT t.title,
    e.gender,
    ROUND(AVG(s.salary)) avg_salary,
    MIN(s.salary) min_salary,
    MAX(s.salary) max_salary,
    COUNT(s.salary) title_count,
FROM emp.titles t
RIGHT JOIN emp.salaries as s using(emp_no)
LEFT JOIN emp.employees as e using(emp_no)
WHERE t.to_date = "9999-01-01"
GROUP BY t.title, e.gender
ORDER BY t.title;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------- HAVING  ------------------------------------
------------ But what if we want to filter row after the GROUP BY? ------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- HAVING requires a GROUP BY clause.
-- HAVING is like WHERE are bot used to filter rows.
-- But one is used to filter rows before aggregating the values with GROUP BY and
-- one is used to filter rows after the GROUP BY operation.
-- Which one is which?
-------------------------------------------------------------------------------

SELECT t.title,
    e.gender,
    ROUND(AVG(s.salary)) avg_salary,
    MIN(s.salary) min_salary,
    MAX(s.salary) max_salary,
    COUNT(s.salary) title_count,
FROM emp.titles t
RIGHT JOIN emp.salaries as s using(emp_no)
LEFT JOIN emp.employees as e using(emp_no)
WHERE t.to_date = "9999-01-01"
GROUP BY t.title, e.gender
ORDER BY t.title;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------- DATE FUNCTIONS -------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Introducing date functions
-- often we have date data in our datasets. To work with them properly and
-- efficiently, we can make use of date functions.


-------------------------------------------------------------------------------
-- Introducing EXTRACT()
-- syntax: EXTRACT(part FROM date_expression)
-- We use this to "extract" a part of a date
-- Year, month, week or day for example
-------------------------------------------------------------------------------

-- Starting with the hire date
SELECT hire_date
FROM emp.employees;

-- Then "extracting" the year when they were hired
-- The returned output is a number, not a date
SELECT EXTRACT(year FROM hire_date) AS year_hired
FROM emp.employees;

-- Now "extracting" only the month when they were hired
SELECT EXTRACT(month FROM hire_date) AS month_hired
FROM emp.employees;

-- Let's say we want the year and the month...

-------------------------------------------------------------------------------
-- introducing DATE_TRUNC()
-- syntax: DATE_TRUNC(date_expression, date_part)
-- You can think of it as "rounding" a date
-- Returns a date (compared to EXTRACT() that returns a number)
-------------------------------------------------------------------------------

-- Year, month when they were hired. Leaving YYYY-MM-01
SELECT DATE_TRUNC(hire_date, month) AS year_month_hired
FROM emp.employees
ORDER BY year_month_hired;

-------------------------------------------------------------------------------
-- introducing DATE_DIFF()
-- Calculate difference between two date
-- DATE_DIFF(date_expression_a, date_expression_b, date_part)

SELECT DATE_DIFF(hire_date, birth_date, YEAR)
FROM emp.employees;

SELECT DATE_DIFF(hire_date, birth_date, YEAR)
    ,DATE_DIFF(hire_date, birth_date, DAY)
FROM emp.employees;
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- finishing date functions intro with some documentation
-- google: SQL Date Functions (look at results)
-- Then google: SQL Date functions BigQuery
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions
-------------------------------------------------------------------------------