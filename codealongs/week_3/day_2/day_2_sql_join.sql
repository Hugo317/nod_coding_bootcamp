-------------------------------------------------------------------------------
-- Introducing JOIN
-- If we want to combine information that is stored accross multiple tables,
-- we have to use JOIN
-------------------------------------------------------------------------------
-- We have to declare with ON what value describes the relationship between
-- both tables. Also called the key.

SELECT *
FROM `nod-sql-copy.emp.employees` AS e
INNER JOIN `nod-sql-copy.emp.salaries` AS s
    ON e.emp_no = s.emp_no;

SELECT e.emp_no, first_name, last_name, salary
FROM `nod-sql-copy.emp.employees` AS e
INNER JOIN `nod-sql-copy.emp.salaries` AS s
    ON e.emp_no = s.emp_no;

SELECT e.emp_no, first_name, last_name, salary
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.salaries` AS s -- We can just write JOIN, no need to write INNER JOIN
    ON e.emp_no = s.emp_no;

-- USING instead of ON
SELECT emp_no, first_name, last_name, salary
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.salaries` AS s -- We can just write JOIN, no need to write INNER JOIN
    USING(emp_no);

-------------------------------------------------------------------------------
-- Introducing LEFT JOIN
-- Everything from A (left) including the intersection with B (right)
-------------------------------------------------------------------------------
-- With the LEFT JOIN we are always including the records from the left table
-- Keys without any info in B will simply have NULL there instead
-- The left table is the first table. So mini_emp in this case


SELECT *
FROM `nod-sql-copy.emp.mini_emp` AS e
LEFT JOIN `nod-sql-copy.emp.salaries` AS s
    ON e.emp_no = s.emp_no;



SELECT *
FROM `nod-sql-copy.emp.employees` AS e
LEFT JOIN `nod-sql-copy.emp.salaries` AS s
    ON e.emp_no = s.emp_no
WHERE salary IS NULL;


SELECT DISTINCT(e.emp_no)
FROM `nod-sql-copy.emp.employees` AS e
LEFT JOIN `nod-sql-copy.emp.salaries` AS s
    ON e.emp_no = s.emp_no
WHERE salary IS NULL;

-- JOINING MULTIPLE TABLES
SELECT *
FROM `nod-sql-copy.emp.salaries` AS s
JOIN `nod-sql-copy.emp.employees` AS e
  USING(emp_no)
JOIN `nod-sql-copy.emp.titles` AS t
  USING(emp_no)
WHERE title = "Senior Engineer";

-- AVG SENIOR ENG SALARY adding AND to date make sure all active

SELECT AVG(s.salary)
FROM `nod-sql-copy.emp.salaries` AS s
JOIN `nod-sql-copy.emp.employees` AS e
  USING(emp_no)
JOIN `nod-sql-copy.emp.titles` AS t
  USING(emp_no)
WHERE title = "Senior Engineer" AND s.to_date = "9999-01-01"