-- 01

CREATE VIEW salePerOrder AS
    SELECT 
        orderNumber,
        SUM(quantityOrdered * priceEach) total 
        -- ROUND(SUM(quantityOrdered * priceEach), 2) total
    FROM
        orderDetails
    GROUP by orderNumber
    ORDER BY total DESC;

-- view tables database with...
SHOW TABLES;

-- then
SHOW FULL TABLES;

-- then

SELECT * FROM salePerOrder;

-- 02 Creating a view based on another view example

-- CREATE OR ALTER VIEW bigSalesOrder AS -- SQL SERVER equivilent
CREATE OR REPLACE VIEW bigSalesOrder AS
    SELECT 
        orderNumber, 
        total
        -- ROUND(total,2) as total
    FROM
        salePerOrder
    WHERE
        total > 60000;
-- then
SELECT 
    orderNumber, 
    total
FROM
    bigSalesOrder;


-- 03 Creating a view with join example
CREATE OR REPLACE VIEW customerOrders AS
SELECT 
    orderNumber,
    customerName,
    SUM(quantityOrdered * priceEach) total
FROM
    orderDetails
INNER JOIN orders o USING (orderNumber)
INNER JOIN customers USING (customerNumber)
GROUP BY orderNumber;

-- then

SELECT * FROM customerOrders 
ORDER BY total DESC;

-- 04 Creating a view with a subquery example
CREATE VIEW aboveAvgProducts AS
    SELECT 
        productCode, 
        productName, 
        buyPrice
    FROM
        products
    WHERE
        buyPrice > (
            SELECT 
                AVG(buyPrice)
            FROM
                products)
    ORDER BY buyPrice DESC;
-- then
SELECT * FROM aboveAvgProducts;


-- 05 Creating a view with explicit view columns example
CREATE VIEW customerOrderStats (
   customerName , 
   orderCount
) 
AS
    SELECT 
        customerName, 
        COUNT(orderNumber)
    FROM
        customers
            INNER JOIN
        orders USING (customerNumber)
    GROUP BY customerName;

SELECT 
    customerName Customer,
    orderCount 'Total Orders'
FROM
    customerOrderStats
ORDER BY 
	orderCount, 
    customerName;


-- 06 Renaming a view
RENAME TABLE productLineSales 
TO productLineQtySales;

-- 07 Dropping a view
DROP VIEW IF EXISTS customerPayments;





-- BACK TO SLIDES - Indexed views in SQL SERVER (not poss in mySQL)
