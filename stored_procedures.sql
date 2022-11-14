-- 01 
DELIMITER $$

CREATE PROCEDURE GetCustomers()
BEGIN
	SELECT 
		customerName, 
		city, 
		state, 
		postalCode, 
		country
	FROM
		customers
	ORDER BY customerName;    
END$$
DELIMITER ;


CALL GetCustomers();

DROP PROCEDURE IF EXISTS GetCustomers;

-- 02 Pass in parameters
DELIMITER $$

CREATE PROCEDURE GetOfficeByCountry(
	IN countryName VARCHAR(255)
)
BEGIN
	SELECT * 
 	FROM offices
	WHERE country = countryName;
END$$

DELIMITER ;


CALL GetOfficeByCountry('USA');


-- 03 Return a value

DELIMITER $$

CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END$$

DELIMITER ;

CALL GetOrderCountByStatus('Shipped',@total);
SELECT @total;


-- 04 Return multiple values - The following stored procedure accepts customer number and returns the total number of orders that were shipped, canceled, resolved, and disputed.

DELIMITER $$

CREATE PROCEDURE get_order_by_cust(
	IN cust_no INT,
	OUT shipped INT,
	OUT canceled INT,
	OUT resolved INT,
	OUT disputed INT)
BEGIN
		-- shipped
		SELECT
            count(*) INTO shipped
        FROM
            orders
        WHERE
            customerNumber = cust_no
                AND status = 'Shipped';

		-- canceled
		SELECT
            count(*) INTO canceled
        FROM
            orders
        WHERE
            customerNumber = cust_no
                AND status = 'Canceled';

		-- resolved
		SELECT
            count(*) INTO resolved
        FROM
            orders
        WHERE
            customerNumber = cust_no
                AND status = 'Resolved';

		-- disputed
		SELECT
            count(*) INTO disputed
        FROM
            orders
        WHERE
            customerNumber = cust_no
                AND status = 'Disputed';

END


-- then

CALL get_order_by_cust(141,@shipped,@canceled,@resolved,@disputed);
SELECT @shipped,@canceled,@resolved,@disputed;

