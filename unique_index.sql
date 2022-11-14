-- 01 

CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    UNIQUE KEY unique_email (email)
);


SHOW INDEXES FROM contacts;


-- 02
INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('John','Doe','(408)-999-9765','john.doe@mysqltutorial.org');

--  and then this throws an error

INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('Johny','Doe','(408)-999-4321','john.doe@mysqltutorial.org');

-- 03 Suppose you want the combination of first_name, last_name, and  phone is also unique among contacts. In this case, you use the CREATE INDEX statement to create a UNIQUE index for those columns as follows:

CREATE UNIQUE INDEX idx_name_phone
ON contacts(first_name,last_name,phone);

--  and then this throws an error

INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('john','doe','(408)-999-9765','john.d@mysqltutorial.org');


-- back to slides to discuss INVISIBLE indexes




