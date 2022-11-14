CREATE DATABASE fkdemo;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
) ENGINE=INNODB;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=INNODB;

-- Because we don’t specify any ON UPDATE and ON DELETE clauses, the default action is RESTRICT for both update and delete operation.

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');

INSERT INTO products(productName, categoryId)
VALUES('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

-- this one throws error because id 3 doesn't exist in parent table
INSERT INTO products(productName, categoryId)
VALUES('iPhone',3);

-- and another error
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

-- Because of the RESTRICT option, you cannot delete or update categoryId 1 since it is referenced by the productId 1 in the products table.

DROP TABLE products;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        -- ON DELETE CASCADE -- coming next (go to slides)
) ENGINE=INNODB;

INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

-- view it
SELECT * FROM products;

--update a column in parent
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

-- view it again
SELECT * FROM products;

--TIP
USE information_schema;

SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'fkdemo'
        AND referenced_table_name = 'categories'
        AND delete_rule = 'CASCADE'

-- Disabling foreign key checks
-- Sometimes, it is very useful to disable foreign key checks e.g., when you import data from a CSV file into a table. If you don’t disable foreign key checks, you have to load data into a proper order i.e., you have to load data into parent tables first and then child tables, which can be tedious. However, if you disable the foreign key checks, you can load data into tables in any order.

SET foreign_key_checks = 0;

SET foreign_key_checks = 1;
