-- 01

CREATE TABLE t (
    a INT,
    b INT,
    INDEX a_asc_b_asc (a ASC , b ASC),
    INDEX a_asc_b_desc (a ASC , b DESC),
    INDEX a_desc_b_asc (a DESC , b ASC),
    INDEX a_desc_b_desc (a DESC , b DESC)
);


-- 02 stored procedure to insert rows
DELIMITER $$
CREATE PROCEDURE insertSampleData(
    IN rowCount INT, 
    IN low INT, 
    IN high INT
)
BEGIN
    DECLARE counter INT DEFAULT 0;
    REPEAT
        SET counter := counter + 1;
        -- insert data
        INSERT INTO t(a,b)
        VALUES(
            ROUND((RAND() * (high-low))+high),
            ROUND((RAND() * (high-low))+high)
        );
    UNTIL counter >= rowCount
    END REPEAT;
END$$  


CALL insertSampleData(10000,1,1000);


-- 03 
EXPLAIN SELECT 
    *
FROM
    t
ORDER BY a , b; -- uses index a_asc_b_asc


-- then

EXPLAIN SELECT 
    *
FROM
    t
ORDER BY a , b DESC; -- use index a_asc_b_desc

-- then

EXPLAIN SELECT 
    *
FROM
    t
ORDER BY a DESC , b; -- use index a_desc_b_asc

-- then

EXPLAIN SELECT 
    *
FROM
    t
ORDER BY a DESC , b DESC; -- use index a_desc_b_desc



