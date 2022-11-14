SELECT Employees.lastName, Offices.city FROM Employees JOIN Offices where Employees.officeCode = Offices.officeCode

SELECT Customers.CustomerName, Orders.OrderNumber FROM Customers LEFT JOIN Orders ON Customers.CustomerNumber = Orders.CustomerNumber ORDER BY Customers.CustomerName

SELECT Customers.CustomerName, Orders.OrderNumber FROM Customers LEFT JOIN Orders ON Customers.CustomerNumber = Orders.CustomerNumber ORDER BY Customers.CustomerName

-- Self Join

SELECT
 e.FName AS "Employee",
 m.FName AS "Manager"
FROM
 Employees e
JOIN
 Employees m
 ON e.ManagerId = m.Id



 SELECT d.Name, e.FName FROM Departments d JOIN Employees e on d.Id = e.DepartmentId


SELECT Employees.FName, Departments.Name
FROM Employees
JOIN Departments
ON Employees.DepartmentId = Departments.Id


-- duplicate table
CREATE TABLE newtable LIKE oldtable;
INSERT newtable SELECT * FROM oldtable;



-- count orders
SELECT c.customerNumber, 
       c.customerName,
       o.orderNumber
FROM customers c
left JOIN orders o ON o.customerNumber = c.customerNumber
ORDER BY c.customerName

SELECT c.customerNumber, 
       c.customerName,
       o.orderNumber,
       COUNT(o.orderNumber) AS totalOrders,
    --    SUM(OrderAmounts.DollarAmount) AS TotalDollarAmount
FROM customers c
left JOIN orders o ON o.customerNumber = c.customerNumber
ORDER BY c.customerName



SELECT CID,
       COUNT(Orders.OrderID) AS TotalOrders,
       SUM(OrderAmounts.DollarAmount) AS TotalDollarAmount
FROM [Orders]
INNER JOIN (SELECT OrderID, Sum(Quantity*SalePrice) AS DollarAmount 
      FROM OrderItems GROUP BY OrderID) AS OrderAmounts
  ON Orders.OrderID = OrderAmounts.OrderID
GROUP BY CID
ORDER BY Count(Orders.OrderID) DESC