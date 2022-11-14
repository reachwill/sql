CREATE DATABASE IF NOT EXISTS empdb;

USE empdb;

-- create tables
CREATE TABLE merits (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);

CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);
-- insert data for merits table
INSERT INTO merits(performance,percentage)
VALUES(1,0),
      (2,0.01),
      (3,0.03),
      (4,0.05),
      (5,0.08);
-- insert data for employees table
INSERT INTO employees(emp_name,performance,salary)      
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);



-- 01 Suppose you want to adjust the salary of employees based on their performance.
-- We specify only the employees table after UPDATE clause because we want to update data in the  employees table only.

-- For each row in the employees table, the query checks the value in the performance column against the value in the performance column in the merits table. If it finds a match, it gets the percentage in the merits  table and updates the salary column in the employees  table.

-- Because we omit the WHERE clause in the UPDATE  statement, all the records in the employees  table get updated.

UPDATE employees
        INNER JOIN
    merits ON employees.performance = merits.performance 
SET 
    salary = salary + salary * percentage;

-- 02 Suppose the company hires two more employees:
INSERT INTO employees(emp_name,performance,salary)
VALUES('Jack William',NULL,43000),
      ('Ricky Bond',NULL,52000);

--   Because these employees are new hires so their performance data is not available or NULL
--     To increase the salary for new hires, you cannot use the UPDATE INNER JOIN  statement because their performance data is not available in the merit  table. This is why the UPDATE LEFT JOIN  comes to the rescue.

-- The UPDATE LEFT JOIN  statement basically updates a row in a table when it does not have a corresponding row in another table.

-- For example, you can increase the salary for a new hire by 1.5%  using the following statement:

UPDATE employees
        LEFT JOIN
    merits ON employees.performance = merits.performance 
SET 
    salary = salary + salary * 0.015
WHERE
    merits.percentage IS NULL;

-- NOW GOT TO DELETE_JOIN.SQL