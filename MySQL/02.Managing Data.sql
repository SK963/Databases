--MANAGING DATA
/*
INSERT 
UPDATE
DELETE
*/




---------------------------------####### MANAGING DATA ###### ------------------------------------


-------------------------------------- INSERT DATA ----------------------------------------
DROP TABLE Employees;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);


select * from Employees;

--BASIC INSERT (SINGLE ROW)
INSERT INTO employees (name, department, salary) VALUES ('John Doe', 'Sales', 50000);


-- MULTIPLE ROW INSERTION
INSERT INTO employees (name, department, salary) VALUES 
('Jane Smith', 'Marketing', 60000),
('Sam Brown', 'Sales', 55000),
('Nancy White', 'IT', 70000);



--- INSERTION USING SELECT (FROM ANTOHER TABLE)
CREATE TABLE new_employees (
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO new_employees (name, department, salary) VALUES 
('Alice Green', 'HR', 45000),
('Bob Yellow', 'Finance', 65000);

INSERT INTO employees (name, department, salary)
SELECT name, department, salary FROM new_employees;


-- INSETION WITHOUT SPECIFYING COLUMNS
INSERT INTO employees VALUES (NULL, 'Eve Blue', 'Management', 80000);


-- Handling Duplicate Key Errors
INSERT INTO employees (id, name, department, salary) VALUES (1, 'John Doe', 'Sales', 55000)
ON DUPLICATE KEY UPDATE salary = VALUES(salary);


-- On Duplicate Key Update
INSERT IGNORE INTO employees (name, department, salary) VALUES ('John Doe', 'Sales', 50000);


drop table employees;
------------------------------------   UPDATE DATA   --------------------------------------------



CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (name, department, salary) VALUES
('John Doe', 'Sales', 50000),
('Jane Smith', 'Marketing', 60000),
('Sam Brown', 'Sales', 55000),
('Nancy White', 'IT', 70000);

SELECT * FROM employees;


-- single column value updation
UPDATE employees
SET salary = 52000
WHERE name = 'John Doe';



-- multiple column value updation
UPDATE employees
SET department = 'Marketing', salary = 58000
WHERE name = 'Sam Brown';


-- All row updation 
UPDATE employees
set department = NULL , salary = salary-5000;


-- update with join (updating on a conditoin based on another table)
--update the department of employees based on a condition involving another table departments:

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments (name, location) VALUES
('Sales', 'Building A'),
('Marketing', 'Building B'),
('IT', 'Building C');


UPDATE employees e
JOIN departments d ON e.department = d.name
SET e.department = CONCAT('Updated ', d.name)
WHERE d.location = 'Building A';


-- Using ORDER BY and LIMIT in an Update Statement
UPDATE employees
SET salary = salary + 5000
ORDER BY salary ASC
LIMIT 1;


-- Using a Subquery in an Update Statement
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    supplier_address VARCHAR(100)
);

INSERT INTO suppliers (supplier_id, supplier_name, supplier_address) VALUES
(1, 'ABC Corp', 'New York'),
(2, 'XYZ Ltd', 'Los Angeles'),
(3, 'Bata shoes', 'Chicago');


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

INSERT INTO customers (customer_id, name, age) VALUES
(1, 'John Doe', 24),
(2, 'Jane Smith', 30),
(3, 'Bata shoes', 22);

SELECT * FROM CUSTOMERS;

UPDATE customers  
SET name = (SELECT supplier_name  
            FROM suppliers  
            WHERE suppliers.supplier_name = customers.name)  
WHERE age < 25;


SELECT supplier_name  
            FROM suppliers  
            WHERE suppliers.supplier_name = customers.name;

DROP TABLE CUSTOMERS;

------------------------------------  DELETE DATA ------------------------------------------


------------------------DELETING SPECIFIC ROWS : DELETE---------------------------------------------
DROP TABLE Employees;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, department, salary) VALUES
(1, 'John Doe', 'Sales', 50000),
(2, 'Jane Smith', 'Marketing', 60000),
(3, 'Sam Brown', 'Sales', 55000);


Select * From Employees;


-- DELETE SPECIFIC ROWS WITH SINGLE CONDITION 
DELETE FROM employees WHERE department = 'Sales';

-- DELETE ALL ROWS
DELETE FROM employees;

-- DELETE WITH MULTIPLE CONDITIONS 
DELETE FROM employees WHERE department = 'Marketing' AND salary <= 60000;


--Deleting with JOIN
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Sales'),
(2, 'Marketing');


DELETE e
FROM employees e
JOIN departments d ON e.department = d.dept_name
WHERE d.dept_name = 'Sales';

SELECT * FROM Employees;


-- DLETE WITH ORDERBY AND LIMIT
DELETE FROM employees ORDER BY salary DESC LIMIT 1;

-- Deleting Duplicate Rows
CREATE TABLE my_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255)
);

INSERT INTO my_table (data) VALUES ('row1'), ('row1'), ('row2'), ('row3'), ('row3');

SELECT * FROM my_table;


DELETE t1
FROM my_table t1
INNER JOIN my_table t2
WHERE t1.id < t2.id AND t1.data = t2.data;


DROP TABLE departments;
DROP TABLE Employees;
DROP TABLE my_table;



------------------------------DELETING ALL DATA : TRUNCATE ------------------------
TRUNCATE TABLE Employees;


select * from Employees;

