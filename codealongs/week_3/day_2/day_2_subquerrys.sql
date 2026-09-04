------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--------------------------- SUBQUERIES / NESTED QUERIES ----------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Everything is a table
-- A subquery should acheive one thing, and one thing only




------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--------------------------- Subquery in the FROM statement -------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------


-- When we want to create a new column and then make calculations on said column, it is useful to
-- query that column from the outer query.

-- INNER QUERRY
--create a new column with a hire date as a quarterly data

SELECT *, DATE_TRUNC(hire_date,quarter) AS quarters
FROM `nod-sql-copy.emp.employees`;

--OUTER QUERRY
SELECT quarters,
        COUNT(quarters) AS new_employees
FROM(
  SELECT *, DATE_TRUNC(hire_date,quarter) AS quarters
FROM `nod-sql-copy.emp.employees`
)
GROUP BY quarters
ORDER BY quarters;


-- JOINING TWO SUBQUERIES IN THE FROM STATEMENT (WOOP WOOP)
-- We want to get the average salary per department (with the department name)

-- INNER QUERY
-- We want emp-no and salary from salaries and join it with emp-no and dept-no from the dept-emp table.


SELECT *
FROM (SELECT emp_no, salary
      FROM `nod-sql-copy.emp.salaries`) AS s
  JOIN(SELECT emp_no, dept_no
      FROM `nod-sql-copy.emp.dept_emp`) AS d
    USING(emp_no)
LEFT JOIN `nod-sql-copy.emp.departments` 
    USING(dept_no);


-- OUTER QUERY
--SELECT dept_name , AVG(salary) AS avg_salary
--FROM
  -- inner querry

--GROUP BY dept_name
--ORDER BY avg_salary DESC;


-- TOGETHER
SELECT dept_name , AVG(salary) AS avg_salary
FROM(
  SELECT *
FROM (SELECT emp_no, salary
      FROM `nod-sql-copy.emp.salaries`) AS s
  JOIN(SELECT emp_no, dept_no
      FROM `nod-sql-copy.emp.dept_emp`) AS d
    USING(emp_no)
LEFT JOIN `nod-sql-copy.emp.departments` 
    USING(dept_no)

)
GROUP BY dept_name
ORDER BY avg_salary DESC;


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--------------------------- Subquery in the WHERE statement -------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- We want all information from the employees table about the Assistant Engineers

-- INNER QUERY: Get all employee numbers for Assistant Engineers
-- We need to select emp_no from titles becuase it is the linking column between the employees table and the titles table

-- INNER
SELECT emp_no
FROM `nod-sql-copy.emp.titles`
WHERE title = "Assistand Engineer";
-- OUTER + WHOLE
SELECT * 
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN (
  SELECT emp_no
  FROM `nod-sql-copy.emp.titles`
  WHERE title = "Assistant Engineer"
);

-------------------------------------------------------------------------------
-- More examples of SubQueries inside WHERE
    -- We filter in the WHERE clause and can use SubQueries
    -- to create conditions we want to filter on
-------------------------------------------------------------------------------

-- Let's get all information from the employees table
    -- about each of the current department managers

-- INNER QUERY:
    -- Getting the employee number of all current department managers
-- INNER
SELECT emp_no
FROM `nod-sql-copy.emp.dept_manager`
WHERE to_date = "9999-01-01";

--OUTER + WHOLE

SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN (
  SELECT emp_no
  FROM `nod-sql-copy.emp.dept_manager`
  WHERE to_date = "9999-01-01"
);




SELECT *
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN (
  SELECT emp_no
  FROM `nod-sql-copy.emp.salaries`
  WHERE salary > 100000
);

------------------------------------------------------------------------------
-- EXAMPLE: SUBQUERY IN A SUBQUERY IN A QUERY... IT IS SOOO META, I KNOW
-- Get all info from the employees table ...
    -- ... for employees with an above average salary
    --
    -- Should return 60453 rows
-------------------------------------------------------------------------------


-- 1 select average salary

SELECT AVG(salary)
FROM `nod-sql-copy.emp.salaries`
WHERE to_date = "9999-01-01";


-- 2 select emp_no using the querry above

SELECT emp_no
FROM `nod-sql-copy.emp.salaries`
WHERE salary >(
  SELECT AVG(salary)
FROM `nod-sql-copy.emp.salaries`
WHERE to_date = "9999-01-01"
);

-- 3 out is just get all info after cleaning up

SELECT * 
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN (
    
    SELECT emp_no
    FROM `nod-sql-copy.emp.salaries`
    WHERE salary >(
        
        SELECT AVG(salary)
        FROM `nod-sql-copy.emp.salaries`
        WHERE to_date = "9999-01-01"
  )
);


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------- Subquery in the SELECT statement  -----------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- get avg. salary per employee
-- get max salary per employee

SELECT emp_no,
        first_name,
        last_name,
        hire_date,
        (SELECT AVG(salary)
        FROM `nod-sql-copy.emp.salaries` as s
        WHERE e.emp_no = s.emp_no) as avg_salary,
        (SELECT MAX(salary)
        FROM `nod-sql-copy.emp.salaries` as s
        WHERE e.emp_no = s.emp_no) as max_salary,
FROM `nod-sql-copy.emp.employees` as e
ORDER BY max_salary DESC;