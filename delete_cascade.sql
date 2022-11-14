-- You learned how to delete data from multiple related tables using a single DELETE statement. more effective way called ON DELETE CASCADE referential action for a foreign key that allows you to delete data from child tables automatically when you delete the data from the parent table.

-- Notice that ON DELETE CASCADE  works only with tables with the storage engines that support foreign keys e.g., InnoDB.

CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

INSERT INTO buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');


INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);

-- IN DEMO DB

-- We have three rooms that belong to building no 1 and two rooms that belong to the building no 2.

DELETE FROM buildings 
WHERE building_no = 2;


-- TIP check tables affected by DELETE CASCADE
USE information_schema;

SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'classicmodels'
        AND referenced_table_name = 'buildings'
        AND delete_rule = 'CASCADE'