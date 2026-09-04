-------------------------------------------------------------------------------
-- EXERCISE 1: 
-- Select all data from the “departments” table.
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.departments`;

-------------------------------------------------------------------------------
-- EXERCISE 2: 
-- Select the information from the “dept_no” column of the “departments” table.
-------------------------------------------------------------------------------

SELECT dept_no
FROM `nod-sql-copy.emp.departments`;
-------------------------------------------------------------------------------
-- EXERCISE 3: 
-- Select first name and gender from the “employees” table of people whose
-- first name is “Mary”. 
-- 224 rows
-------------------------------------------------------------------------------
SELECT first_name, gender
FROM `nod-sql-copy.emp.employees`
WHERE first_name = "Mary";

-------------------------------------------------------------------------------
-- EXERCISE 4: 
-- Select emp_no and from_date from the “titles” table for people with the title
-- 'Engineer' and where the hire date is before 18th July 2002
-- 114967 rows
-------------------------------------------------------------------------------

SELECT emp_no, from_date
FROM `nod-sql-copy.emp.titles`
WHERE title = "Engineer" AND from_date < "2002-07-18";

-------------------------------------------------------------------------------
-- EXERCISE 5: 
-- Retrieve first_name and birth date of all male employees whose last name is
-- Swan.
-- 126 rows
-------------------------------------------------------------------------------

SELECT first_name, birth_date
FROM `nod-sql-copy.emp.employees`
WHERE last_name = "Swan" AND gender = "M";


-------------------------------------------------------------------------------
-- EXERCISE 6:
-- Retrieve all data of employees whose 
-- first name is Aruna or whose last name is Swan.
-- 402 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE last_name = "Swan" OR first_name = "Aruna"

-------------------------------------------------------------------------------
-- EXERCISE 7:
-- Retrieve all data of male employees whose 
-- first name is Aruna or whose last name is Swan.
-- 251 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE (last_name = "Swan" OR first_name = "Aruna") AND gender = "M";

-------------------------------------------------------------------------------
-- EXERCISE 8:
-- Retrieve a table last_name all of employees whose first name is Gao or
-- Herbert. Don't use the OR operator
-- 497 rows
-------------------------------------------------------------------------------

SELECT last_name
FROM `nod-sql-copy.emp.employees`
WHERE first_name IN ('Gao', 'Herbert');

-------------------------------------------------------------------------------
-- EXERCISE 9:
-- Extract all records from the ‘employees’ table, except for those with 
-- employees named John, Mark, Elvis, Gao or Jacob
-- 299304rows
-------------------------------------------------------------------------------

SELECT last_name
FROM `nod-sql-copy.emp.employees`
WHERE first_name NOT IN ("John", "Mark", "Elvis", "Gao", "Jacob");


-------------------------------------------------------------------------------
-- EXERCISE 10: 
-- Working with the “employees” table, use the LIKE operator to select the data
-- about all individuals, whose first name starts with “Anne”, 
-- specify that the name can be succeeded by any sequence of characters.
-- 679 rows
-------------------------------------------------------------------------------

SELECT last_name
FROM `nod-sql-copy.emp.employees`
WHERE first_name LIKE ("Anne%");


-------------------------------------------------------------------------------
-- EXERCISE 11:
-- Retrieve a table with all employees who have been hired in the year 2000
-- 13 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE hire_date BETWEEN "2000-01-01" AND "2000-12-31";


-------------------------------------------------------------------------------
-- EXERCISE 12:
-- Select all the information from the “salaries” table regarding contracts 
-- from 68,000 to 72,000 dollars per year
-- 69245 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.salaries`
WHERE salary BETWEEN 68000 AND 72000;



-------------------------------------------------------------------------------
-- EXERCISE 13: Retrieve a table with all individuals whose employee number
-- is not between ‘10005’ and ‘10012’
-- 300016 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE emp_no NOT BETWEEN 10005 AND 10012;

-------------------------------------------------------------------------------
-- EXERCISE 14:
-- Get data for all female employees born between 1952 and 1954
-- or born between 1962 and 1964
-- 54446 rows
-------------------------------------------------------------------------------
SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE gender = "F" AND (birth_date BETWEEN "1952-01-01" AND "1954-12-31" OR birth_date BETWEEN "1962-01-01" AND "1964-12-31");

------------------------------------------------------------    -------------------
-- EXERCISE 15: 
-- Retrieve a table with all the distinct titles
-- 7 rows
-------------------------------------------------------------------------------

SELECT DISTINCT(title)
FROM `nod-sql-copy.emp.titles`;

-------------------------------------------------------------------------------
-- EXERCISE 17:
-- Which is the lowest employee number in the database?
-------------------------------------------------------------------------------

SELECT MIN(emp_no)
FROM `nod-sql-copy.emp.employees`

-------------------------------------------------------------------------------
-- EXERCISE 18:
-- Which is the highest employee number in the database?
-------------------------------------------------------------------------------

SELECT MAX(emp_no)
FROM `nod-sql-copy.emp.employees`

-------------------------------------------------------------------------------
-- EXERCISE 19: 
-- What is the average annual salary paid to employees who started after the
-- 1st of January 1997?
-- 67717.74
-------------------------------------------------------------------------------

SELECT AVG(salary)
from `nod-sql-copy.emp.salaries`
WHERE from_date > "1997-01-01";

-------------------------------------------------------------------------------
-- EXERCISE 20: 
-- What are the most common titles? Order from most to least common
-------------------------------------------------------------------------------

SELECT title,
    COUNT(*) AS no_ppl
FROM `nod-sql-copy.emp.titles`
GROUP BY title
ORDER BY no_ppl DESC;

-------------------------------------------------------------------------------
-- EXERCISE 21:
-- How many current contracts with a value higher than or equal to $100,000
-- have been registered in the salaries table?
-- Definition of current contract in this dataset: to_date = "9999-01-01"
-- Answer: 5929
-------------------------------------------------------------------------------
SELECT COUNT(*) AS big_salary
FROM `nod-sql-copy.emp.salaries`
WHERE salary >= 100000 and to_date = "9999-01-01";

-------------------------------------------------------------------------------
-- EXERCISE 22:
-- How many people have been hired per year?
-- Row	hire_year num_hired
-- 1	1993      17772
-- 2	1990      25610
-- 3	1985      35316
-- 4	1991      22568
-- 5	1988      31436
-- 6	1987      33501
-- 7	1986      36150
-- 8	1989      28394
-- 9	1994      14835
-- 10	1997      6669
-- 11	1995      12115
-- 12	1996      9574
-- 13	1998      4155
-- 14	1992      20402
-- 15	1999      1514
-- 16	2000      13
-------------------------------------------------------------------------------


SELECT 
    EXTRACT(YEAR FROM hire_date) AS hire_year, 
    COUNT(*) AS num_hired
FROM `nod-sql-copy.emp.employees`
GROUP BY hire_year
ORDER BY hire_year;

-------------------------------------------------------------------------------
---------------------------------BONUS Questions-------------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- BONUS 1: 
-- How many currently employed people earn more than 80000?
-- 23635 rows
-------------------------------------------------------------------------------

SELECT *
FROM `nod-sql-copy.emp.salaries`
WHERE to_date = "9999-01-01" and salary > 80000;

-------------------------------------------------------------------------------
-- BONUS 2: 
-- What's the average current salaries for men/women?
-- You need to use JOIN to solve this one
--Row	gender	avg_salary
/*
1	F       71926.401920019809
2	M       71990.4692296683
*/
-------------------------------------------------------------------------------
SELECT e.gender,
    AVG(s.salary)
FROM `nod-sql-copy.emp.employees` e
RIGHT JOIN `nod-sql-copy.emp.salaries` s using (emp_no)
GROUP BY e.gender
-------------------------------------------------------------------------------
-- BONUS 3: 
-- What titles have the highest paying average salaries currently?
-- You need to use JOIN 
-- Row	title	           avg_salary
-- 1	Senior Staff       80582
-- 2	Manager            79546
-- 3	Staff              77443
-- ...
-------------------------------------------------------------------------------
SELECT t.title,
    AVG(s.salary) as avg_sal
FROM `nod-sql-copy.emp.titles` t
RIGHT JOIN `nod-sql-copy.emp.salaries` s using (emp_no)
WHERE s.to_date = "9999-01-01"
GROUP BY t.title
ORDER BY avg_sal DESC



-------------------------------------------------------------------------------
-- BONUS 4: 
-- How many employees are there in each of the following 4 categories?
    -- Male Staff
    -- Female Staff
    -- Male Manager
    -- Female Manager
    
-- You need to use JOIN
/*
1   F Staff     42854
2   F Manager   13
3   M Staff     64537
4   M Manager   11
*/

-------------------------------------------------------------------------------

SELECT e.gender, 
    t.title as tit,
    COUNT(*)
FROM  `nod-sql-copy.emp.salaries` s
RIGHT JOIN `nod-sql-copy.emp.titles` t using (emp_no)
LEFT JOIN `nod-sql-copy.emp.employees` e using (emp_no)
WHERE t.title = "Staff" OR t.title = "Manager"
GROUP BY e.gender, tit

-------------------------------------------------------------------------------
-- BONUS 5: 
-- What's the current average salaries for each of the following 4 categories:
 	-- Female Engineer
	-- Male Engineer
	-- Female Assistant Engineer
	-- Male Assistant Engineer
-- You need to use multiple JOINs

--Row   gender  avg_salary  title
-- 1    F   59424.0     Engineer
-- 2    M   59699.0     Engineer
-- 3    F   57238.0     Assistant Engineer  
-- 4    M   57676.0     Assistant Engineer
-------------------------------------------------------------------------------

SELECT e.gender, 
    ROUND(AVG(s.salary)),
    t.title as tit,
FROM  `nod-sql-copy.emp.salaries` s
RIGHT JOIN `nod-sql-copy.emp.titles` t using (emp_no)
LEFT JOIN `nod-sql-copy.emp.employees` e using (emp_no)
WHERE t.title = "Engineer" OR t.title = "Assistant Engineer"
GROUP BY e.gender, tit

-------------------------------------------------------------------------------
-- THE END
-- GOOD JOB
-------------------------------------------------------------------------------