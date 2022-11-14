-- 01 SUBQUERY in WHERE clause

-- query returns the customer who has the highest payment.
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT MAX(amount) FROM payments);


-- subquery to return the employees who work in the offices located in the USA.
SELECT 
    lastName, firstName
FROM
    employees
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            country = 'USA');

-- you can find customers whose payments are greater than the average payment 
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount > (SELECT 
                AVG(amount)
            FROM
                payments);

-- subquery with NOT IN operator to find the customers who have not placed any orders as follows:
SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT DISTINCT
                            customerNumber
                           FROM
                            orders);

-- 02 SUBQUERY in FROM clause
-- When you use a subquery in the FROM clause, the result set returned from a subquery is used as a temporary table. This table is referred to as a derived table or materialized subquery.
-- Run the subquery standalone first 
SELECT 
    MAX(items) 'Maximum Number of Items in an Order', 
    MIN(items) 'Minimum Number of Items in an Order', 
    FLOOR(AVG(items)) 'Average Number of Items in an Order'
FROM
    (SELECT 
        orderNumber, COUNT(orderNumber) AS items
    FROM
        orderDetails
    GROUP BY orderNumber) AS lineitems;

-- 03 MySQL correlated subquery
-- In the previous examples, you notice that a subquery is independent. It means that you can execute the subquery as a standalone query, for example:
-- a correlated subquery is a subquery that uses the data from the outer query
-- correlated subquery to select products whose buy prices are greater than the average buy price of all products in each product line
SELECT 
    productname, 
    buyprice
FROM
    products p1
WHERE
    buyprice > (SELECT 
            AVG(buyprice)
        FROM
            products
        WHERE
            productline = p1.productline)

-- 04 MySQL subquery with EXISTS and NOT EXISTS
-- find customers who placed at least one sales order with the total value greater than 60K by using the EXISTS operator
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( SELECT 
            orderNumber, SUM(priceEach * quantityOrdered)
        FROM
            orderDetails
                INNER JOIN
            orders USING (orderNumber)
        WHERE
            customerNumber = customers.customerNumber
        GROUP BY orderNumber
        HAVING SUM(priceEach * quantityOrdered) > 60000);