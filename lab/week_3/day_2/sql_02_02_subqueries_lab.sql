-------------------------------------------------------------------------------
---------------------------------- Subqueries ---------------------------------
-------------------------------------------------------------------------------
-- Some of these questions you could answer with JOINs as well.
-- Try to solve them with subqueries instead.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXERCISE 1: 
-- Select first_name, last_name, gender, birth_date and hire date
-- on all managers
-- 23 rows
-------------------------------------------------------------------------------

SELECT first_name,
        last_name,
        gender,
        hire_date
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN (
  SELECT emp_no
  FROM `nod-sql-copy.emp.dept_manager`
);


-------------------------------------------------------------------------------
-- EXERCISE 2: 
-- select all department names that currently have a female manager
-- Answer:  Development, Finance, Human Resources, Research
-------------------------------------------------------------------------------


SELECT dept_name
FROM `nod-sql-copy.emp.departments`
WHERE dept_no IN (
  SELECT dept_no
  FROM `nod-sql-copy.emp.dept_manager`
  WHERE emp_no IN (  
      SELECT emp_no
      FROM `nod-sql-copy.emp.employees`
      WHERE gender = "F"

  ) AND to_date = "9999-01-01"
);


-------------------------------------------------------------------------------
-- EXERCISE 3: 
-- Calculate the average number of employees working in a department.
-- Also show the min and max number of employees working in a department.
-- Answer: 
-- avg_emps	min_emps	max_emps
-- 36845.0      17346.0         85707.0
-------------------------------------------------------------------------------


SELECT
  AVG(emp_count) AS avg_emps,
  MIN(emp_count) AS min_emps,
  MAX(emp_count) AS max_emps
  FROM (
    SELECT
     dept_no,
      COUNT(emp_no) AS emp_count
   FROM `nod-sql-copy.emp.dept_emp`
    WHERE to_date = "9999-01-01"
    GROUP BY dept_no
);

-------------------------------------------------------------------------------
-- EXERCISE 4:
-- Calculate per year how many people hired in that year are still working
-- in the company to date.
-- Answer:
-- Row	year_hired	still_workinga
/* 
1   1985 28291
2   1986 28840
3   1987 26684
...
15 1999 1204
16 2000 9
*/
-------------------------------------------------------------------------------


SELECT EXTRACT(YEAR FROM hire_date) AS year_hired, COUNT(*) AS still_working
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN(
  SELECT emp_no
FROM `nod-sql-copy.emp.dept_emp`
WHERE to_date = "9999-01-01")
GROUP BY year_hired
ORDER BY year_hired;

-------------------------------------------------------------------------------
-- EXERCISE 5:
-- Calculate the average promotion time from Staff to Senior Staff
-- Answer: 2483.9 days
-------------------------------------------------------------------------------

--discover hire date as staff

SELECT AVG(DATE_DIFF(staff_senior_start_date, staff_start_date, DAY))
FROM(
SELECT emp_no, staff_start_date, staff_senior_start_date
FROM (SELECT emp_no, from_date as staff_start_date
  FROM `nod-sql-copy.emp.titles`
  WHERE title = "Staff")
  INNER JOIN (SELECT emp_no, from_date as staff_senior_start_date
  FROM `nod-sql-copy.emp.titles`
  WHERE title = "Senior Staff") USING(emp_no)
);




#SELECT emp_no, from_date as staff_start_date, to_date as staff_last_date
#FROM `nod-sql-copy.emp.titles`
#WHERE title = "Staff" AND to_date != "9999-01-01";
#SELECT emp_no, from_date as staff_senior_start_date, to_date as staff_senior_last_date
#FROM `nod-sql-copy.emp.titles`
#WHERE title = "Senior Staff"
--------------------------- Lab finished, good job ----------------------------



-------------------------------------------------------------------------------
---------------------------------- BONUS Qs -----------------------------------
-------------------------------------------------------------------------------

-- NOTE! Use a combination of JOINs and SubQueries to solve the bonus questions!

-------------------------------------------------------------------------------
-- BONUS 1:
-- Retrieve a table of every employees name, the department they are working in
-- and who their manager is.
-- Order by Department
-- Answer
-- Row	emp_first_name	emp_last_name	dept_name	mngr_first_name	mngr_last_name	
-- 1	Gill		Spataro		Customer ServiceHauke	Zhang
-- 2	Steen		Dechter		Customer ServiceHauke	Zhang
-- 3	Arra		Bratsberg	Customer ServiceHauke	Zhang
-- 4	Mantis		Birdsall	Customer ServiceHauke	Zhang
-- ...
-- 253,022 rows
-------------------------------------------------------------------------------
SELECT
    e.first_name AS emp_first_name,
    e.last_name AS emp_last_name,
    d.dept_name,
    m.first_name AS mngr_first_name,
    m.last_name AS mngr_last_name
FROM `nod-sql-copy.emp.employees` AS e
JOIN `nod-sql-copy.emp.dept_emp` AS de
    USING(emp_no)
JOIN `nod-sql-copy.emp.departments` AS d
    USING(dept_no)
JOIN `nod-sql-copy.emp.dept_manager` AS dm
    USING(dept_no)
JOIN `nod-sql-copy.emp.employees` AS m
    ON dm.emp_no = m.emp_no
WHERE dm.to_date = '9999-01-01'
ORDER BY d.dept_name;
-------------------------------------------------------------------------------
-- BONUS for BONUS 1
-- If you DISTINCT enp_no you will get a different answer.
-- Why?
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- BONUS 2:
-- Now rewrite the query from EXCERCISE 4 so that it also includes the number 
-- of people hired per year as well. Calculate the fraction of people still 
-- working. Order by year.
-- Answer:
-- Row	year_hired	still_working	people_hired	fraction
-- 1	 1985 	        9723 	      	35316 	    	28.0
-- 2	 1986 	        9710 	      	36150 	    	27.0
-- 3	 1987 	        8939 	      	33501 	    	27.0
-- 4	 1988 	        8631 	      	31436 	    	27.0
-- 5	 1989 	        7692 	      	28394 	    	27.0
-- 6	 1990 	        6923 	      	25610 	    	27.0
-- 7	 1991 	        6226 	      	22568 	    	28.0
-- 8	 1992 	        5605 	      	20402 	    	27.0
-- 9	 1993 	        4934 	      	17772 	    	28.0
-- 10	 1994 	        3960 	      	14835 	    	27.0
-- 11	 1995 	        3408 	      	12115 	    	28.0
-- 12	 1996 	        2556 	      	9574 		    27.0
-- 13	 1997 	        1751 	      	6669 		    26.0
-- 14	 1998 	        1163 	      	4155 		    28.0
-- 15	 1999 	        411 	      	1514 		    27.0
-- 16	 2000 	        3 		13 		23.0
-------------------------------------------------------------------------------

(EXTRACT(YEAR FROM hire_date) AS year_hired, COUNT(*) AS people_hired
              FROM `nod-sql-copy.emp.employees`
              GROUP BY year_hired
              ORDER BY year_hired;
              )
(EXTRACT(YEAR FROM to_date) AS year_hired, COUNT(*) AS still_working
              FROM `nod-sql-copy.emp.salaries`
              GROUP BY year_hired
              ORDER BY year_hired;
              )
SELECT EXTRACT(YEAR FROM hire_date) AS year_hired, COUNT(*) AS still_working
FROM `nod-sql-copy.emp.employees`
WHERE emp_no IN(
  SELECT emp_no
FROM `nod-sql-copy.emp.dept_emp`
WHERE to_date = "9999-01-01")
GROUP BY year_hired
ORDER BY year_hired;


-------------------------------------------------------------------------------
-- BONUS 3:
-- Who is the current manager of the employees no 54319 and 294238?
-- Include the employees and manager names, dept_no and department name
-- Answer
-- 1
--  Chaoyi   Butner   d005   Development  Leon   DasSarma
-- 2
--  Xuedong   Llado   d008   Research   Hilary   Kambil
-------------------------------------------------------------------------------























