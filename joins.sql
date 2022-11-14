-- INNER JOIN

-- create tables in Playground
CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);
--insert some data
INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

--The following statement uses an inner join clause to find members who are also the committee members:
SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c ON c.name = m.name;
--because both tables use the same column name we can use the USING keyword
SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c USING(name);

-- BACK TO SLIDES

-- LEFT JOIN
SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
LEFT JOIN committees c USING(name);

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
LEFT JOIN committees c USING(name)
WHERE c.committee_id IS NULL;

-- RIGHT JOIN
SELECT
    m.member_id,  
    m.name AS member,  
    c.committee_id,  
    c.name AS committee
FROM
    members m
RIGHT JOIN committees c USING(name)
WHERE m.member_id IS NULL;

--REPEAT IN CLASSIC MODELS

-- 1 *** inner join *********************** Suppose you want to get:
-- The productCode and productName from the products table.
-- The textDescription of product lines from the productLines table.
SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
INNER JOIN productLines t2 
    ON t1.productline = t2.productline;
    -- or USING (productline)

-- compare with WHERE clause
SELECT 
    t1.productCode, 
    t1.productName, 
    t2.textDescription
FROM
    products t1, productLines t2
WHERE t1.productline = t2.productline;

-- 2 ***** group by ************************
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders t1
INNER JOIN orderDetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;

-- add customer name from 3rd table
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total,
    customerName
FROM
    orders t1
INNER JOIN orderDetails t2 
    ON t1.orderNumber = t2.orderNumber
INNER JOIN customers 
    USING (customerNumber)
GROUP BY orderNumber;


-- 3 ***** inner join 3 tables ************************
SELECT 
    orderNumber,
    orderDate,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN
    orderDetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;

-- OR - BETTER TO READ TABLE ORIGIN
SELECT 
    orders.orderNumber as 'Order Number',
    orders.orderDate 'Order Date',
    orderDetails.orderLineNumber,
    products.productName,
    orderDetails.quantityOrdered,
    orderDetails.priceEach
FROM
    orders
INNER JOIN
    orderDetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;

-- 4 ******* inner join 4 tables *********************
SELECT 
    orderNumber,
    orderDate,
    customerName,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN orderDetails 
    USING (orderNumber)
INNER JOIN products 
    USING (productCode)
INNER JOIN customers 
    USING (customerNumber)
ORDER BY 
    orderNumber, 
    orderLineNumber;

-- 5 ******* add operators *************************
SELECT 
    orderNumber, 
    productName, 
    msrp, 
    priceEach
FROM
    products p
INNER JOIN orderDetails o 
   ON p.productcode = o.productcode
      AND p.msrp > o.priceEach
WHERE
    p.productcode = 'S10_1678';


-- 6 ********* left join **********************************
-- This query uses the LEFT JOIN clause to find all customers and their orders:
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber;

-- 7 ********* LEFT JOIN clause is very useful when you want to find rows in a table that doesn’t have a matching row from another table ******************
-- The following example uses the LEFT JOIN to find customers who have no order:
SELECT 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    o.status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
    -- OR
    -- USING (customerNumber)
WHERE
    orderNumber IS NULL;

    -- OR for just name and id num

SELECT 
    c.customerNumber, 
    c.customerName
FROM
    customers c
LEFT JOIN orders o 
    USING (customerNumber)
WHERE
    orderNumber IS NULL;

-- 8 ****** Condition in WHERE clause vs. ON clause *******************
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;

-- COMPARE ABOVE AND BELOW - In this case, the query returns all orders but only the order 10123 will have line items associated with it as in the following picture:

SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;

-- 9 ****** right join examples ******************************************

-- The column salesRepEmployeeNumber in the table customers links to the column employeeNumber in the employees table.

-- A sales representative, or an employee, may be in charge of zero or more customers. And each customer is taken care of by zero or one sales representative.

-- If the value in the column salesRepEmployeeNumber is NULL, which means the customer does not have any sales representative.
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees 
    ON salesRepEmployeeNumber = employeeNumber
ORDER BY employeeNumber;

-- COMPARE - the right join returns all employees even if customers.salesRepEmployeeNumber
-- the left join returns all customers even if employee.customerNumber is null
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
LEFT JOIN employees ON 
	salesRepEmployeeNumber = employeeNumber
ORDER BY employeeNumber;

-- The RIGHT JOIN returns all rows from the table employees whether rows in the table employees have matching values in the column salesRepEmployeeNumber of the table customers.
-- If a row from the table employees has no matching row from the table customers , the RIGHT JOIN uses NULL for the customerNumber column.

-- *********** The following statement uses the RIGHT JOIN clause to find employees who are not in charge of any customers:
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees ON 
	salesRepEmployeeNumber = employeeNumber
WHERE customerNumber is NULL
ORDER BY employeeNumber;
-- OR
SELECT 
    employeeNumber, 
    customerNumber
FROM
    employees
LEFT JOIN customers ON 
	salesRepEmployeeNumber = employeeNumber
WHERE salesRepEmployeeNumber is NULL
ORDER BY employeeNumber;

-- total number of emloyees not in charge of customers

SELECT count(employeeNumber) 'Total needing a customer' from employees left join customers on salesRepEmployeeNumber = employeeNumber where salesRepEmployeeNumber is null

-- or
SELECT count(employeeNumber) 'Total needing a customer' from customers right join employees on salesRepEmployeeNumber = employeeNumber where salesRepEmployeeNumber is  null

-- BACK TO SLIDES Self Join

-- 10 ****** self join examples ******************************************
-- The table employees stores not only employees data but also the organization structure data. The reportsTo column is used to determine the manager id of an employee.
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Employee'
FROM
    employees e
JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
-- The output only shows the employees who have a manager. However, you don’t see the President because her name is filtered out due to the INNER JOIN clause.

-- VS 

SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname), 'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Employee'
FROM
    employees e
LEFT JOIN employees m ON m.employeeNumber = e.reportsto
ORDER BY manager DESC;

-- BACK TO SLIDES 


-- 10 ******* why use a cross join example ******************************************
CREATE DATABASE IF NOT EXISTS salesdb;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);

CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13 , 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    -- PRIMARY KEY (product_id , store_id),
    -- FOREIGN KEY (product_id)
    --     REFERENCES products (id)
    --     ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (store_id)
    --     REFERENCES stores (id)
    --     ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);

INSERT INTO stores(store_name)
VALUES('North'),
      ('South');

INSERT INTO sales(store_id,product_id,quantity,sales_date)
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');

-- query 1 (inner joins)  - Now, what if you want to know also which store had no sales of a specific product. The query above could not answer this question.
SELECT 
    store_name,
    product_name,
    SUM(quantity * price) AS revenue
FROM
    sales
INNER JOIN
    products ON products.id = sales.product_id
INNER JOIN
    stores ON stores.id = sales.store_id
GROUP BY store_name , product_name; 

-- query 2 (cross join and sub query) - Now, what if you want to know also which store had no sales of a specific product. The query above could not answer this question.
SELECT 
    b.store_name,
    a.product_name,
    IFNULL(c.revenue, 0) AS revenue
FROM
    products AS a
CROSS JOIN
    stores AS b
LEFT JOIN
    (SELECT 
        stores.id AS store_id,
        products.id AS product_id,
        store_name,
        product_name,
        ROUND(SUM(quantity * price), 0) AS revenue
    FROM
        sales
    INNER JOIN products ON products.id = sales.product_id
    INNER JOIN stores ON stores.id = sales.store_id
    GROUP BY stores.id, products.id, store_name , product_name) AS c 
ON c.store_id = b.id AND c.product_id= a.id
ORDER BY b.store_name;


