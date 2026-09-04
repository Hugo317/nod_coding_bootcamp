-------------------------------------------------------------------------------
-- BONUS 1: 
-- What's the average age of engineers?
-------------------------------------------------------------------------------

SELECT ROUND(AVG(DATE_DIFF(CURRENT_DATE, e.birth_date, YEAR))) as avg_age,
FROM `nod-sql-copy.emp.titles` as t
RIGHT JOIN `nod-sql-copy.emp.employees` as e using(emp_no)
WHERE t.title = "Engineer";
 -- 68 
-------------------------------------------------------------------------------
-- BONUS 2: 
-- What's the average age of engineers when they get hired?
-------------------------------------------------------------------------------

SELECT ROUND(AVG(DATE_DIFF(e.hire_date, e.birth_date, YEAR))) as avg_age_when_hired,
FROM `nod-sql-copy.emp.titles` as t
RIGHT JOIN `nod-sql-copy.emp.employees` as e using(emp_no)
WHERE t.title = "Engineer";
-- 31

-------------------------------------------------------------------------------
-- BONUS 3: 
-- What's the average duration that currently employed senior engineers ...
-- ... has worked at the company?
-------------------------------------------------------------------------------

SELECT ROUND(AVG(DATE_DIFF(CURRENT_DATE, e.hire_date, YEAR))) as avg_age,
FROM `nod-sql-copy.emp.titles` as t
RIGHT JOIN `nod-sql-copy.emp.employees` as e using(emp_no)
LEFT JOIN `nod-sql-copy.emp.dept_emp` as d using(emp_no)
WHERE t.title = "Senior Engineer" AND d.to_date = "9999-01-01";

--



