-- 01 Simple

SELECT country,
CASE 
	WHEN country =  'USA' THEN '2-day Shipping'
	WHEN country =  'UK' THEN '5-day Shipping'
    ELSE '5-day Shipping'
END AS Shipping
FROM
    customers

-- ---- Use variable -----------
SELECT 
OrderNumber,
@waitingDay := DATEDIFF(requiredDate, shippedDate) AS DaysLate,
CASE
	WHEN @waitingDay = 0 THEN 'On time'
	WHEN @waitingDay  >= 1 AND @waitingDay < 5  THEN 'Late'
	WHEN @waitingDay  >= 5 THEN 'Very late'
	ELSE 'No information'
END AS DeliveryStatus
FROM orders;

-- ORDER BY
SELECT CustomerName, City, Country
FROM customers
ORDER BY
(CASE
    WHEN City IS NULL THEN Country
    ELSE City
END);





DELIMITER $$

CREATE PROCEDURE GetCustomerShipping(
	IN  pCustomerNUmber INT, 
	OUT pShipping       VARCHAR(50)
)
BEGIN
    DECLARE customerCountry VARCHAR(100);

SELECT 
    country
INTO customerCountry FROM
    customers
WHERE
    customerNumber = pCustomerNUmber;

    CASE customerCountry
		WHEN  'USA' THEN
		   SET pShipping = '2-day Shipping';
		WHEN 'Canada' THEN
		   SET pShipping = '3-day Shipping';
		ELSE
		   SET pShipping = '5-day Shipping';
	END CASE;
END$$

DELIMITER ;

-- then
CALL GetCustomerShipping(112,@shipping);
SELECT @shipping;


-- 02 Searched case statement

DELIMITER $$

CREATE PROCEDURE GetDeliveryStatus(
	IN pOrderNumber INT,
    OUT pDeliveryStatus VARCHAR(100)
)
BEGIN
	DECLARE waitingDay INT DEFAULT 0;
    SELECT 
		DATEDIFF(requiredDate, shippedDate)
	INTO waitingDay
	FROM orders
    WHERE orderNumber = pOrderNumber;
    
    CASE 
		WHEN waitingDay = 0 THEN 
			SET pDeliveryStatus = 'On Time';
        WHEN waitingDay >= 1 AND waitingDay < 5 THEN
			SET pDeliveryStatus = 'Late';
		WHEN waitingDay >= 5 THEN
			SET pDeliveryStatus = 'Very Late';
		ELSE
			SET pDeliveryStatus = 'No Information';
	END CASE;	
END$$
DELIMITER ;



-- then

CALL GetDeliveryStatus(10100,@delivery);
SELECT @delivery


