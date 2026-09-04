-- CASE STATEMMENTS

SELECT CASE
    WHEN birth_date BETWEEN "1964-01-01" AND "1964-12-31"
    THEN "BOOMER"
    WHEN birth_date BETWEEN "1965-01-01" AND "1980-12-31"
    THEN "GEN X"
    ELSE "OTHER"
    END AS gen_cat
    FROM `nod-sql-copy.emp.employees`;


-- Label if they are currently employed 

SELECT emp_no,
    CASE
    WHEN to_date = "1900-01-01"
    THEN "STILL WORKING"
    ELSE "FORMER"
    END AS status
    FROM `nod-sql-copy.emp.titles` ;


SELECT gen_cat,
COUNT(gen_cat) 
FROM(
  SELECT CASE
    WHEN birth_date BETWEEN "1964-01-01" AND "1964-12-31"
    THEN "BOOMER"
    WHEN birth_date BETWEEN "1965-01-01" AND "1980-12-31"
    THEN "GEN X"
    ELSE "OTHER"
    END AS gen_cat
    FROM `nod-sql-copy.emp.employees`
)
GROUP BY gen_cat;

SELECT CASE
    WHEN salary >(
      SELECT AVG(salary)
      FROM `nod-sql-copy.emp.salaries`
)
      THEN "Y"
      ELSE "N"
      END AS sal_above_avg,
      COUNT (*) AS sal_count
      FROM `nod-sql-copy.emp.salaries`
      GROUP BY sal_above_avg