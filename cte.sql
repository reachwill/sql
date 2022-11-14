-- 01 Note that this example is only for the demonstration purpose to make it easy for you to understand the CTE concept.
WITH customers_in_usa AS (
    SELECT 
        customerName, state
    FROM
        customers
    WHERE
        country = 'USA'
) 

SELECT 
    customerName
 FROM
    customers_in_usa
 WHERE
    state = 'CA'
 ORDER BY customerName;

 -- 02 In this example, the CTE returns the top 5 sales reps in 2003. After that, we reference the topsales2003 CTE to get additional information about the sales rep including first name and last name. IN CLASS run the query inside CTE independently first to see its return result.
 WITH topsales2003 AS (
    SELECT 
        salesRepEmployeeNumber employeeNumber,
        SUM(quantityOrdered * priceEach) sales
    FROM
        orders
            INNER JOIN
        orderDetails USING (orderNumber)
            INNER JOIN
        customers USING (customerNumber)
    WHERE
        YEAR(shippedDate) = 2003
            AND status = 'Shipped'
    GROUP BY salesRepEmployeeNumber
    ORDER BY sales DESC
    LIMIT 5
)
SELECT 
    employeeNumber, 
    firstName, 
    lastName, 
    sales
FROM
    employees
        JOIN
    topsales2003 USING (employeeNumber);


--03 In this example, we have two CTEs in the same query. The first CTE ( salesrep) gets the employees whose job titles are the sales representative. The second CTE ( customer_salesrep ) references the first CTE in the INNER JOIN clause to get the sales rep and customers of whom each sales rep is in charge.

WITH salesrep AS (
    SELECT 
        employeeNumber,
        CONCAT(firstName, ' ', lastName) AS salesrepName
    FROM
        employees
    WHERE
        jobTitle = 'Sales Rep'
),
customer_salesrep AS (
    SELECT 
        customerName, salesrepName
    FROM
        customers
            INNER JOIN
        salesrep ON employeeNumber = salesrepEmployeeNumber
)
SELECT 
    *
FROM
    customer_salesrep
ORDER BY customerName;

-- this returns the same - ask class to recreate based on understanding of JOIN exercises
SELECT 
    CONCAT(firstname, ' ', lastname) as Rep, 
    customerName as Customer
FROM employees 
LEFT JOIN customers ON salesRepEmployeeNumber = employeeNumber
WHERE customerName IS NOT NULL
-- WHERE customerName IS NOT NULL AND jobTitle = 'Sales Rep' 
ORDER BY customerName;

-- WHY USE CTE then? -- next recursive 