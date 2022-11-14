SELECT 1 + 1; 
--------------
SELECT NOW();
--------------
SELECT CONCAT('John',' ','Doe') as 'Full Name';
--------------
SELECT 
    contactLastname, 
    contactFirstname
FROM
    customers
ORDER BY 
	contactLastname DESC , 
	contactFirstname ASC;
--------------
SELECT 
    orderNumber, 
    orderlinenumber, 
    ROUND(quantityOrdered * priceEach, 2) 'Total'
FROM
    orderDetails
ORDER BY 
   quantityOrdered * priceEach DESC;
--------------
SELECT 
    orderNumber, status
FROM
    orders
ORDER BY FIELD(status,
        'In Process',
        'On Hold',
        'Cancelled',
        'Resolved',
        'Disputed',
        'Shipped');
---------------
SELECT 
    lastname, 
    firstname, 
    jobtitle
FROM
    employees
WHERE
    jobtitle = 'Sales Rep';
----------------
SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode BETWEEN 1 AND 3
ORDER BY officeCode;
----------------
SELECT 
    firstName, 
    lastName
FROM
    employees
WHERE
    lastName LIKE '%son'
ORDER BY firstName;
-------------------
SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    offices
WHERE
    country IN ('USA' , 'France');
    country NOT IN ('USA' , 'France');
------------------
SELECT 
    lastname, 
    firstname, 
    jobtitle
FROM
    employees
WHERE
    jobtitle <> 'Sales Rep';
--------------------
SELECT 
    table_name, 
    table_rows
FROM
    information_schema.tables
WHERE
    table_schema = 'ClassicModels'
ORDER BY table_name;