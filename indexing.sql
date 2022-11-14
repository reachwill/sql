-- 01 
EXPLAIN
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';

-- As you can see, MySQL had to scan the whole table which consists of 23 rows to find the employees with the Sales Rep job title.

-- 02 

CREATE INDEX jobTitle ON employees(jobTitle);

EXPLAIN SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';


-- 03
SHOW INDEXES FROM table_name;
-- cardinality
-- The cardinality returns an estimated number of unique values in the index. Note that the higher the cardinality, the greater the chance that the query optimizer uses the index for lookups.

-- 04
DROP INDEX jobTitle ON employees;

-- go to Cardinality slides


