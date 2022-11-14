-- 01  Let’s take a look at the orders table in the sample database.

SELECT 
    status
FROM
    orders
GROUP BY status;

-- OR GROUP BY clause sorts the result set, whereas the DISTINCT clause does not.

SELECT DISTINCT -- best to avoid SELECT DISTINCT in large tables!
    status
FROM
    orders;


-- 02 The aggregate functions allow you to perform the calculation of a set of rows and return a single value. The GROUP BY clause is often used with an aggregate function to perform calculations and return a single value for each subgroup.

SELECT 
    status, COUNT(*) Total
FROM
    orders
GROUP BY status;

-- To get the total amount of all orders by status, you join the orders table with the orderDetails table and use the SUM function to calculate the total amount.

SELECT 
    status, 
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
INNER JOIN orderDetails 
    USING (orderNumber)
GROUP BY 
    status;

-- invite class to create query that returns the order numbers and the total amount of each order.

SELECT 
    orderNumber,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orderDetails
GROUP BY 
    orderNumber;

-- 03 MySQL GROUP BY with expression example. In addition to columns, you can group rows by expressions. The following query gets the total sales for each year.
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
    -- or
    -- FLOOR(SUM(quantityOrdered * priceEach)) AS total
    -- TRUNCATE(SUM(quantityOrdered * priceEach), 2) AS total
FROM
    orders
INNER JOIN orderDetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    YEAR(orderDate);

-- 04 Filter with HAVING clause -- HAVING filters groups , WHERE filters each individual row
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
INNER JOIN orderDetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    year 
HAVING 
    year > 2003;

-- ASC or DESC
SELECT 
    status, 
    COUNT(*)
FROM
    orders
GROUP BY 
    status
ORDER BY COUNT(*) ASC

--  more HAVING examples
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderDetails
GROUP BY 
   ordernumber
HAVING 
   total > 1000;

-- possible to form a complex condition in the HAVING clause using logical operators such as OR and AND
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderDetails
GROUP BY ordernumber
HAVING 
    total > 1000 AND 
    itemsCount > 600;

--  Suppose that you want to find all orders that already shipped and have a total amount greater than 1500, you can join the orderDetails table with the orders table using the INNER JOIN clause and apply a condition on status column and total aggregate

SELECT 
    a.ordernumber, 
    status, 
    SUM(priceeach*quantityOrdered) total
FROM
    orderDetails a
INNER JOIN orders b 
    ON b.ordernumber = a.ordernumber
GROUP BY  
    ordernumber, 
    status
HAVING 
    status = 'Shipped' AND 
    total > 1500;


-- 05 ROLLUP
-- The following statement creates a new table named sales that stores the order values summarized by product lines and years. The data comes from the products, orders, and orderDetails tables in the sample database.
CREATE TABLE IF NOT EXISTS sales
SELECT
    productLine,
    YEAR(orderDate) orderYear,
    SUM(quantityOrdered * priceEach) orderValue
FROM
    orderDetails
        INNER JOIN
    orders USING (orderNumber)
        INNER JOIN
    products USING (productCode)
GROUP BY
    productLine ,
    YEAR(orderDate);

-- then check
SELECT * from sales

-- then - A grouping set is a set of columns to which you want to group. For example, the following query creates a grouping set denoted by (productline)
SELECT 
    productline, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline;

--If you want to generate two or more grouping sets together in one query, you may use the UNION ALL operator as follows:
-- demo UNION ALL but say lengthy query and not good for performance since the database engine has to internally execute two separate queries and combine the result sets into one.

SELECT 
    productline, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline 
UNION ALL
SELECT 
    NULL, -- Because the UNION ALL requires all queries to have the same number of columns, we added NULL in the select list of the second query to fulfill this requirement.
    SUM(orderValue) totalOrderValue
FROM
    sales;

-- The NULL in the productLine column identifies the grand total super-aggregate line.
-- This query is able to generate the total order values by product lines and also the grand total row. However, it has two problems:
-- The query is quite lengthy.
-- The performance of the query may not be good since the database engine has to internally execute two separate queries and combine the result sets into one.

-- now do the same with ROLLUP
--The ROLLUP clause is an extension of the GROUP BY clause
SELECT 
    productLine, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline WITH ROLLUP;

-- GROUP BY c1, c2, c3 WITH ROLLUP
-- (c1, c2, c3)
-- (c1, c2)
-- (c1)
-- ()

-- slightly more complex example
SELECT 
    productLine, 
    orderYear,
    ROUND(SUM(orderValue)) totalOrderValue
FROM
    sales
GROUP BY 
    productline, 
    orderYear 
WITH ROLLUP;
-- The ROLLUP above generates the subtotal row every time the product line changes and the grand total at the end of the result.

-- If you reverse the hierarchy, for example:
-- The ROLLUP generates the subtotal every time the year changes and the grand total at the end of the result set.
SELECT 
    orderYear,
    productLine, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;

-- use GROUPING() function to check for NULL -- We often use GROUPING() function to substitute meaningful labels for super-aggregate NULL values instead of displaying it directly.
-- Helps to Identify the current grouping stage of the ROLLUP
SELECT 
    orderYear,
    productLine, 
    SUM(orderValue) totalOrderValue,
    GROUPING(orderYear),
    GROUPING(productLine)
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;
-- GROUPING(orderYear) returns 1 when NULL in the orderYear column occurs in a super-aggregate row, 0 otherwise.
-- GROUPING(productLine) returns 1 when NULL in the productLine column occurs in a super-aggregate row, 0 otherwise.
-- The following example shows how to combine the IF() function with the GROUPING() function to substitute labels for the super-aggregate NULL values in orderYear and productLine columns:
SELECT 
    IF(GROUPING(orderYear),
        'All Years',
        orderYear) orderYear,
    IF(GROUPING(productLine),
        'All Product Lines',
        productLine) productLine,
    -- FLOOR(SUM(orderValue)) totalOrderValue
    TRUNCATE(SUM(orderValue), 2) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear , 
    productline 
WITH ROLLUP;


-- EXERCISES
-- select each office and the number of employees in each office
SELECT 
    CONCAT(city, ', ' ,country) as 'Office Location',
    COUNT(employeeNumber) as 'Number of Employees'
FROM
    employees
INNER JOIN offices 
    USING (officeCode)
group by officeCode

-- or 

SELECT 
    CONCAT(city, ', ' ,country) as 'Office Location',
    COUNT(employeeNumber) as 'Number of Employees'
FROM
    offices
INNER JOIN employees 
    USING (officeCode)
group by officeCode