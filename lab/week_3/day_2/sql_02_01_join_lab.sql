-------------------------------------------------------------------------------
------------------------------------- JOINs -----------------------------------
-------------------------------------------------------------------------------
-- EXERCISE 1:
-- Get the name, hire date and date they started the position for all managers
-- ANSWER 25 rows
-------------------------------------------------------------------------------

SELECT first_name,last_name,hire_date,from_date
FROM `nod-sql-copy.emp.employees` as e  
JOIN `nod-sql-copy.emp.titles` as t USING(emp_no)
WHERE t.title = "Manager"

-------------------------------------------------------------------------------
-- EXERCISE 2:
-- get name, gender, birth_date, gender and hire date for all Assistant Engineers
-- 15128 rows
-------------------------------------------------------------------------------

SELECT first_name, last_name, gender, birth_date
FROM `nod-sql-copy.emp.employees` as e  
JOIN `nod-sql-copy.emp.titles` as t USING(emp_no)
WHERE t.title = "Assistant Engineer"

-------------------------------------------------------------------------------
-- EXERCISE 3:
-- Get the from date, to date, and the job titles of all
-- employees whose first name is “Arie” and have the last name “Staelin”.
-- Answer: 
-- --Row	from_date	  to_date	  title
--1	        1991-04-08	  9999-01-01  Staff
--2 	    1985-01-01    1991-04-08  Manager
-------------------------------------------------------------------------------

SELECT from_date, to_date, title
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.titles` AS t USING(emp_no)
WHERE e.first_name = "Arie" AND e.last_name = "Staelin"

-------------------------------------------------------------------------------
-- EXERCISE 4:
-- How CURRENT many Senior Engineers have Fai as first name
-- Answer: 57
-------------------------------------------------------------------------------

SELECT title, COUNT(*) as no_of
FROM `nod-sql-copy.emp.employees` AS e
INNER JOIN `nod-sql-copy.emp.titles` AS t USING(emp_no)
WHERE e.first_name = "Fai" AND title = "Senior Engineer" AND to_date = "9999-01-01"
GROUP BY title

-------------------------------------------------------------------------------
-- EXERCISE 5:
-- How many male and how many female managers do we have in the company?
-- Answer:
-- --Row	gender	num_managers
--1	F       13
--2	M       12

-------------------------------------------------------------------------------

SELECT gender, COUNT(*) as no_of
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.titles` AS t USING(emp_no)
WHERE title = "Manager"
GROUP BY gender


-------------------------------------------------------------------------------
-- EXCERCISE 6:
-- Calculate the average salary by gender for all employees
-- Answer: 
-- Row	gender	avg_salary
--1	F       63769.0
--2	M       63756.0
-------------------------------------------------------------------------------

SELECT gender, AVG(salary) as avg_salary
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.salaries` AS t USING(emp_no)
GROUP BY gender



-------------------------------------------------------------------------------
-- EXCERCISE 7:
-- Get the highest salary by department. Order from high to low.
-- Answer: 
-- Row	dept_no	highest_salary
--1	d007    158220
--2	d009    144866
--3	d005    144434
--4	d001    143644
--5	d002    134662
--6	d004    132552
--7	d008    124181
--8	d003    123674
--9	d006    122376

-------------------------------------------------------------------------------

SELECT dept_no, max(salary) as max_salary
FROM `nod-sql-copy.emp.salaries` AS e
JOIN `nod-sql-copy.emp.dept_emp` AS t USING(emp_no)
GROUP BY dept_no
ORDER BY max_salary DESC

-------------------------------------------------------------------------------
-- EXCERCISE 8:
-- For eveery depertment get the total number employees that have worked there
-- dept_name        	total_employees
-- Development      	85707
-- Production       	73485
-- Sales            	52245
-- Customer Service 	23580
-- Research         	21126
-- Marketing        	20211
-- Quality Management	20117
-- Human Resources  	17786
-- Finance          	17346
-------------------------------------------------------------------------------

SELECT dept_name, COUNT(*) as no_of
FROM `nod-sql-copy.emp.departments` AS s
JOIN `nod-sql-copy.emp.dept_emp` AS de USING(dept_no)
GROUP BY dept_name
ORDER BY no_of DESC

-------------------------------------------------------------------------------
-- EXCERCISE 9:
-- Get the name and department for every employee with a current salary over 150 000
-- first_name	last_name	dept_name	salary
-- Tokuyasu	Pesch   	Sales	158220
-- Xiahua	Whitcomb	Sales	155709
-- Tsutomu	Alameldin	Sales	155190
-- Willard	Baca    	Sales	154459
-- Ibibia	Junet   	Sales	150345
-- Lansing	Kambil  	Sales	150052
-------------------------------------------------------------------------------

SELECT first_name, last_name, dept_name, salary
FROM `nod-sql-copy.emp.departments` AS depts
JOIN `nod-sql-copy.emp.dept_emp` AS dept_em USING(dept_no)
JOIN `nod-sql-copy.emp.employees` AS emp USING(emp_no) 
JOIN `nod-sql-copy.emp.salaries` AS sal USING(emp_no)
WHERE salary > 150000
ORDER BY salary DESC

--------------------------- Lab finished, good job ----------------------------



-------------------------------------------------------------------------------
---------------------------------- BONUS Qs -----------------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- BONUS 1:
-- We want to get the average management salary per department from high to low
-- (and we want the name of the department)
-- Answer: 
-- Row	dept_name		      avg_salary	
--  1 Marketing		          88372.0
--  2	Sales			      85739.0
--  3	Research		      77535.0
--  4	Quality Management	  70900.0
--  5	Finance			      70816.0
--  6	Customer Service	  64812.0
--  7	Development		      59658.0
--  8	Production		      56233.0
--  9	Human Resources		  55919.0
-------------------------------------------------------------------------------

SELECT dept_name, AVG(salary) as avg_salary
FROM `nod-sql-copy.emp.departments` AS depts
JOIN `nod-sql-copy.emp.dept_manager` AS dept_em USING(dept_no)
JOIN `nod-sql-copy.emp.salaries` AS sal USING(emp_no)
GROUP BY dept_name
ORDER BY avg_salary DESC

-------------------------------------------------------------------------------
-- BONUS 2:
-- Which three departments have the highest average salary?
-- Specifications:
    -- Only include employees who are currently working. 
        -- (where dept_emp.to_date = '9999-01-01')
    -- and only count their current salary 
        -- (where salary.to_date = '9999-01-01')
-- Answer: 
-- row	avg_salary dept_no	dept_name
--1	 89005.8   d007    Sales
--2	 79879.2   d001    Marketing
--3	 78075.5   d002    Finance
--4	 68134.7   d008    Research
--5	 67772.5   d004    Production
--6	 67729.8   d005    Development
--7	 67199.3   d009    Customer Service
--8	 65517.0   d006    Quality Management
--9	 63643.3   d003    Human Resources
-------------------------------------------------------------------------------

SELECT ROUND(AVG(salary),1) as avg_salary, dept_no, dept_name
FROM `nod-sql-copy.emp.departments` AS depts
JOIN `nod-sql-copy.emp.dept_emp` AS dept_em USING(dept_no)
JOIN`nod-sql-copy.emp.salaries` AS sal USING(emp_no)
WHERE sal.to_date = "9999-01-01" AND dept_em.to_date = '9999-01-01'
GROUP BY dept_name,dept_no
ORDER BY avg_salary DESC

-------------------------------------------------------------------------------
-- BONUS 3:
-- This questions builds on the previous question. 
-- Add in gender, so you have the following two questions: 
-- Which three departments have the highest paying salaries for men?
-- Which three departments have the highest paying salaries for women?

-- Answer: 
/*
	 d002   Finance             F 		77776.0
	 d001   Marketing           F 		79538.0
	 d007   Sales               F 		88952.0

	 d002   Finance             M 		78281.0
	 d001   Marketing           M       80118.0
	 d007   Sales               M       89042.0
*/
-------------------------------------------------------------------------------

SELECT  dept_no, dept_name, gender, ROUND(AVG(salary),1) as avg_salary
FROM `nod-sql-copy.emp.departments` AS depts
JOIN `nod-sql-copy.emp.dept_emp` AS dept_em USING(dept_no)
JOIN`nod-sql-copy.emp.salaries` AS sal USING(emp_no)
JOIN`nod-sql-copy.emp.employees` AS e USING(emp_no)
WHERE sal.to_date = "9999-01-01" AND dept_em.to_date = '9999-01-01'
GROUP BY gender,dept_name,dept_no
ORDER BY avg_salary DESC

-------------------------------------------------------------------------------
-- BONUS 4:
-- What is the Average Salary for senior engineers after 5 years in that role?
    -- Assume you are making this calculation in 2002
    -- meaning that we are interested in senior engineers hired in 1997 
-- Answer: 69067
-------------------------------------------------------------------------------

SELECT  dept_no, dept_name, gender, ROUND(AVG(salary),1) as avg_salary
FROM `nod-sql-copy.emp.departments` AS depts
JOIN `nod-sql-copy.emp.dept_emp` AS dept_em USING(dept_no)
JOIN`nod-sql-copy.emp.salaries` AS sal USING(emp_no)
JOIN`nod-sql-copy.emp.employees` AS e USING(emp_no)
WHERE EXTRACT(YEAR from sal.from_date) + 5 <  EXTRACT(YEAR from sal.to_date)
GROUP BY gender,dept_name,dept_no
ORDER BY avg_salary DESC

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------- Subquery in the SELECT statement  -----------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- get avg. salary per employee
-- get max salary per employee

SELECT e.emp_no,
        first

