CREATE TABLE t1(
	id int auto_increment primary key,
    title varchar(255)	
);

CREATE TABLE t2(
	id int auto_increment primary key,
    title varchar(255),
    note varchar(255)
);

-- then

SELECT id,title
FROM (
        SELECT id, title FROM t1
        UNION ALL
        SELECT id,title FROM t2
    ) tbl
GROUP BY id, title
HAVING count(*) = 1
ORDER BY id;

-- no rows returned because all rows match

-- then
INSERT INTO t2(title,note)
VALUES('new row 4','new');



