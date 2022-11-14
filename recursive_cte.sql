-- 01 simple
WITH RECURSIVE cte_count (n) 
AS (
      SELECT 1
      UNION ALL
      SELECT n + 1 
      FROM cte_count 
      WHERE n < 3
    )
SELECT n 
FROM cte_count;

-- 02 The  employees table has the reportsTo column that references to the employeeNumber column. The reportsTo column stores the ids of managers. The top manager does not report to anyone in the company’s organization structure, therefore, the value in the reportsTo column is NULL.

-- You can apply the recursive CTE to query the whole organization structure in the top-down manner ADDING CUSTOM LEVEL INFORMATION as follows:

WITH RECURSIVE employee_levels AS
  ( -- start by getting the manager
    SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 Level
   FROM employees
   WHERE reportsTo IS NULL
   UNION ALL -- combine the following to this previous SELECT
   SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            Level+1
     FROM employees e -- add alias to create unique recordset
     INNER JOIN employee_levels ep ON ep.employeeNumber = e.reportsTo 
  ) -- when there are no more matches, recursion stops

SELECT employeeNumber,
      -- IFNULL(managerNumber, 'Nobody') as 'Reports to',
       managerNumber,
       Level,
       city
FROM employee_levels
INNER JOIN offices USING (officeCode)
ORDER BY Level, city;

-- explaination ,,  
-- Starts with the Top Manager -- WHERE reportsTo IS NULL
-- 1 lvl is start value for each iteration of the recursive call, increases each loop

	
-- EXERCISE - ask class to modify query to include Emloyees' first and last names and also Managers' first and last names

WITH RECURSIVE employee_levels AS
  ( 
    SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 Level
   FROM employees
   WHERE reportsTo IS NULL
   UNION ALL 
   SELECT 	e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            Level+1
     FROM employees e 
     INNER JOIN employee_levels ep ON ep.employeeNumber = e.reportsTo 
  ) 

SELECT x.employeeNumber,
	     CONCAT(l.lastname, ', ', l.firstname) AS 'Employee Name',
       Level,
       city,
       IFNULL(CONCAT(q.lastname, ', ', q.firstname), 'Top Manager') AS 'Manager'
FROM employee_levels x
INNER JOIN offices USING (officeCode)
INNER JOIN employees l ON l.employeeNumber = x.employeeNumber
LEFT JOIN employees q ON q.employeeNumber = x.managerNumber
ORDER BY Level, city;







----- slight modification - 
WITH RECURSIVE employee_levels AS
  ( 
    SELECT employeeNumber,
           CONCAT(lastname, ', ', firstname) as empname,
           reportsTo managerNumber,
           officeCode, 
           1 Level
   FROM employees
   WHERE reportsTo IS NULL
   UNION ALL 
   SELECT 	e.employeeNumber,
            CONCAT(e.lastname, ', ', e.firstname),
            e.reportsTo,
            e.officeCode,
            Level+1
     FROM employees e 
     INNER JOIN employee_levels ep ON ep.employeeNumber = e.reportsTo 
  ) 

SELECT x.employeeNumber,
	     x.empname AS 'Employee Name',
       Level,
       city,
       IFNULL(CONCAT(q.lastname, ', ', q.firstname), 'Top Manager') AS 'Manager'
FROM employee_levels x
INNER JOIN offices USING (officeCode)
-- INNER JOIN employees l ON l.employeeNumber = x.employeeNumber
LEFT JOIN employees q ON q.employeeNumber = x.managerNumber
ORDER BY Level, city;