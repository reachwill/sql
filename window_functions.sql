CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT * FROM sales;

-- 01 Lets start with an aggregate function - Aggregate functions summarize data from multiple rows into a single result row
SELECT 
    SUM(sale)
FROM
    sales;

-- 02 The GROUP BY clause allows you to apply aggregate functions to a subset of rows. For example, you may want to calculate the total sales by fiscal years
SELECT 
    fiscal_year, 
    SUM(sale)
FROM
    sales
GROUP BY 
    fiscal_year;

-- 03 In both examples, the aggregate functions reduce the number of rows returned by the query.

-- Like the aggregate functions with the GROUP BY clause, window functions also operate on a subset of rows but they do not reduce the number of rows returned by the query.

-- For example, the following query returns the sales for each employee, along with total sales of the employees by fiscal year:

SELECT 
    fiscal_year, 
    sales_employee,
    sale,
    SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
FROM
    sales;

-- In this example, the SUM() function works as a window function that operates on a set of rows defined by the contents of the OVER clause. A set of rows to which the SUM() function applies is referred to as a window.

-- The SUM() window function reports not only the total sales by fiscal year as it does in the query with the GROUP BY clause, but also the result in each row, rather than the total number of rows returned.

-- Note that window functions are performed on the result set after all JOIN, WHERE, GROUP BY, and HAVING clauses and before the ORDER BY, LIMIT and SELECT DISTINCT.

-- 04 BACK TO DELETING DUPLICATES

-- first demo ROW_NUMBER partitioning - ROW_NUMBER	Assigns a sequential integer to every row within its partition
SELECT 
    id,
    email, 
    ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS row_num
FROM 
contacts

-- then
SELECT 
    id, email, row_num 
FROM (
        SELECT 
            id,
            email, 
            ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS row_num
        FROM 
        contacts
    
    ) t
WHERE row_num > 1

-- then DELETE

DELETE FROM contacts 
WHERE 
	id IN (
            SELECT 
                id 
            FROM (
                    SELECT 
                        id, 
                        ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS row_num
                    FROM 
                    contacts
                
                ) t
            WHERE row_num > 1
        );

