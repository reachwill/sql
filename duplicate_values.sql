DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO contacts (first_name,last_name,email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
       ('Jean','King','jean.king@me.com'),
       ('Peter','Ferguson','peter.ferguson@google.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com'),
       ('Julie','Murphy','julie.murphy@yahoo.com'),
       ('Kwai','Lee','kwai.lee@google.com'),
       ('Jean','King','jean.king@me.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com');

-- 01 Find duplicate values in one column

SELECT 
    email, 
    COUNT(email)
FROM
    contacts
GROUP BY email
HAVING COUNT(email) > 1;

-- Find duplicates in multiple columns

SELECT 
    first_name, COUNT(first_name),
    last_name,  COUNT(last_name),
    email,      COUNT(email)
FROM
    contacts
GROUP BY 
    first_name , 
    last_name , 
    email
HAVING  COUNT(first_name) > 1
    AND COUNT(last_name) > 1
    AND COUNT(email) > 1;


-- 02 DELETE duplicates -- This query references the contacts table twice, therefore, it uses the table alias t1 and t2
DELETE t1 FROM contacts t1
INNER JOIN contacts t2 
WHERE 
    t1.id < t2.id AND 
    t1.email = t2.email;


-- 03 Delete duplicate rows using an intermediate table
 -- CREATE TABLE contacts_temp LIKE contacts; -- demo this for copying structure
CREATE TABLE contacts_temp LIKE contacts; 
INSERT INTO contacts_temp SELECT * FROM contacts;



DELETE t1 FROM contacts_temp t1
INNER JOIN contacts_temp t2 
WHERE 
    t1.id < t2.id AND 
    t1.email = t2.email;

-- DROP TABLE contacts;
ALTER TABLE contacts 
RENAME TO contacts_OLD;

ALTER TABLE contacts_temp 
RENAME TO contacts;



