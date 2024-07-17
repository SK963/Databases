
-- BASIC QUERIES 
/*
SELECT QUERIES & CLAUSES : 
star operator(*) , 
DISTINCT clause ,
WHERE clause.
ORDER BY clause ,
GROUP BY clause , 
HAVING clause , 
Special Operators : IN , ANY , ALL , LIKE , NOT , BETWEEN , IS NULL , EXISTS
Set Operators & Set Operations : Union , Union ALL , Except 

*/








---------------------------------------------BASIC QUERIES -----------------------

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

-- Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert data into departments
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Sales', 'New York'),
(2, 'Engineering', 'San Francisco'),
(3, 'HR', 'Los Angeles'),
(4, 'Marketing', 'Chicago');

-- Insert data into employees
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary) VALUES
(1, 'John', 'Doe', 1, 60000),
(2, 'Jane', 'Smith', 2, 80000),
(3, 'Jim', 'Brown', 1, 55000),
(4, 'Jake', 'White', 3, 50000),
(5, 'Jill', 'Black', 4, 70000);

-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name FROM employees;

-- WHERE CLAUSE :  filter rows on column(S) conditions
--single value (column and row) filtering
SELECT first_name, last_name FROM employees WHERE department_id = 1;
--single row multiple columns (in or = operators)
SELECT first_name , last_name from employees where ( employee_id , department_id ) = (3,1);
SELECT first_name , last_name from employees where ( employee_id , department_id ) in ((3,1));
-- multiple columns (or)
SELECT first_name , last_name from employees where ( employee_id , department_id ) in ((2,2) , (3,1));
-- multiple columns (and)
SELECT first_name , last_name from employees where employee_id in (2,3) and department_id in (2,1) ;




-- ORDER BY CLAUSE
SELECT first_name, last_name FROM employees ORDER BY last_name ASC, first_name DESC;

-- LIMIT CLAUSE
SELECT first_name, last_name FROM employees LIMIT 3 OFFSET 2;

-- GROUP BY CLAUSE
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id;

-- HAVING CLAUSE
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id HAVING COUNT(*) > 1;

-- DISTINCT KEYWORD
SELECT DISTINCT department_id FROM employees;


-----------------------------SPECIAL OPERATORS-----------------------------------------
-- Create the table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    quantity INT
);


-- Insert the values
INSERT INTO products (name, category, price, quantity) VALUES
('Laptop', 'Electronics', 1200.00, 10),
('Smartphone', 'Electronics', 800.00, 20),
('Tablet', 'Electronics', 400.00, 15),
('Headphones', 'Accessories', 100.00, 50),
('Charger', 'Accessories', 20.00, 100),
('Keyboard', 'Accessories', 50.00, 30),
('Desk', 'Furniture', 150.00, 5),
('Chair', 'Furniture', 85.00, 8),
('Unknown', 'Unknown', 0.00, NULL);



select * from products;


-- IN operator
SELECT * FROM products WHERE category IN ('Electronics', 'Furniture');

-- BETWEEN operator (the values are included in the between range)
SELECT * FROM products WHERE price BETWEEN 50 AND 100;

-- LIKE operator
SELECT * FROM products WHERE name LIKE 'Ch%';

-- IS NULL/ IS NOT NULL operator
SELECT * FROM products WHERE quantity IS NULL;
SELECT * FROM products WHERE quantity IS NOT NULL;
-- EXISTS operator
SELECT * FROM products p WHERE EXISTS (
    SELECT 1 FROM products WHERE category = 'Accessories' AND p.id = id
);

-- ANY operator
SELECT * FROM products WHERE price > ANY (
    SELECT price FROM products WHERE category = 'Accessories'
);

-- ALL operator
SELECT * FROM products WHERE price < ALL (
    SELECT price FROM products WHERE category = 'Electronics'
);


DROP table products;
-------------------------------------------------- SET OPERATORS IN MYSQL -------------------------------------------

-- Create tables
CREATE TABLE table1 (
    id INT,
    name VARCHAR(50)
);

CREATE TABLE table2 (
    id INT,
    name VARCHAR(50)
);

-- Insert data into the tables
INSERT INTO table1 (id, name) VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');
INSERT INTO table2 (id, name) VALUES (2, 'Bob'), (3, 'David'), (4, 'Eve');

-- UNION Example (removes duplicates)
SELECT id, name FROM table1
UNION
SELECT id, name FROM table2;

-- UNION ALL Example (Contains duplicates)
SELECT id, name FROM table1
UNION ALL
SELECT id, name FROM table2;


-------------  INTERSECTION 

-- INTERSECT Example (Simulated with INNER JOIN)
SELECT t1.id, t1.name
FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id AND t1.name = t2.name;

-- INTERSECT Example (Simulated with Subquery)
SELECT id, name FROM table1
WHERE (id, name) IN (SELECT id, name FROM table2);





--------------------------EXCEPT

-- EXCEPT Example (Simulated with LEFT JOIN)
SELECT t1.id, t1.name 
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id AND t1.name = t2.name
WHERE t2.id IS NULL;

--explanation
SELECT t1.id, t1.name , t2.id , t2.name
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id AND t1.name = t2.name;




-- EXCEPT Example (Simulated with Subquery)
SELECT id, name FROM table1
WHERE (id, name) NOT IN (SELECT id, name FROM table2);




----------------------------------


CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments (name, location) VALUES
('Sales', 'Building A'),
('Marketing', 'Building B'),
('IT', 'Building C');

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO employees (name, salary, department_id) VALUES
('John Doe', 45000, 1),
('Jane Smith', 55000, 2),
('Alice Johnson', 70000, 3),
('Bob Brown', 30000, 1),
('Charlie Black', 40000, 2);

SELECT * FROM DEPARTMENTS;

SELECT * FROM EMPLOYEES;

--IN OPERATOR
SELECT name, salary FROM employees WHERE department_id IN (1, 2, 3);
--BETWEEN
SELECT name, salary FROM employees WHERE salary BETWEEN 40000 AND 60000;
--LIKE OPERATOR
SELECT name FROM employees WHERE name LIKE 'J%';

-- IS NULL and IS NOT NULL OPERATOR
SELECT name FROM employees WHERE department_id IS NULL;

SELECT name FROM employees WHERE department_id IS NOT NULL;

--EXISTS
SELECT name FROM employees WHERE EXISTS (SELECT 1 FROM departments WHERE departments.id = employees.department_id AND departments.location = 'Building A');

SELECT 1 FROM departments WHERE departments.id = employees.department_id AND departments.location = 'Building A';

-- ANY
SELECT name FROM employees WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 2);

-- ALL
SELECT name FROM employees WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 2);


--CASE
SELECT name, 
       CASE
           WHEN salary > 50000 THEN 'High'
           WHEN salary BETWEEN 30000 AND 50000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_grade
FROM employees;


-- UNION
SELECT name FROM employees UNION SELECT name FROM departments;
-- INTERSECT LIKE BEHAVIOUR
SELECT name FROM employees WHERE name IN (SELECT name FROM departments);
-- MINUS LIKE BEHAVIOUR
SELECT name FROM employees WHERE name NOT IN (SELECT name FROM departments);


