/*

CTEs : Common Table Expressions ,  Nested CTEs 
Recurssive SQL

*/
---------------------------------COMMON TABLE EXPRESSION (CTEs) -------------------------------

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, department, salary) VALUES
(1, 'Alice', 'Engineering', 75000),
(2, 'Bob', 'Engineering', 60000),
(3, 'Charlie', 'HR', 45000),
(4, 'David', 'HR', 55000),
(5, 'Eve', 'Marketing', 50000);


select AVG(salary) from employees;

-- Basic CTE

WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT e.name, e.salary
FROM employees e
JOIN avg_salary a ON e.salary > a.avg_sal;


-- Nested/ Multiple CTE
CREATE TABLE sales (
    salesperson_id INT,
    year INT,
    amount DECIMAL(10, 2)
);

INSERT INTO sales (salesperson_id, year, amount) VALUES
(1, 2023, 100000),
(2, 2023, 150000),
(1, 2022, 120000),
(2, 2022, 130000);

SELECT salesperson_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY salesperson_id;


WITH total_sales_per_person AS (
    SELECT salesperson_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY salesperson_id
),
total_sales_all AS (
    SELECT SUM(total_sales) AS grand_total
    FROM total_sales_per_person
)
SELECT sp.salesperson_id, sp.total_sales, ts.grand_total
FROM total_sales_per_person sp, total_sales_all ts;


----------------------------------------- Recursive SQL (CTEs)-----------------------------------

-- - Q1: Display number from 1 to 10 without using any in built functions.

with recursive number as(
    select 1 as n
    union
    select n + 1
    from number 
    where n < 10
)
select * from number;

drop table if EXISTS employees;
CREATE TABLE if not exists employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);

INSERT INTO employees (id, name, manager_id) VALUES
(1, 'CEO', NULL),
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'Dev1', 2),
(5, 'Dev2', 2),
(6, 'Accountant', 3);



-- - Q2: Find the hierarchy of employees under a given manager.
WITH RECURSIVE emp_hierarchy AS (
    SELECT id, 
           name, 
           manager_id, 
           1 AS lvl
    FROM employees 
    WHERE name = 'CTO'
    UNION ALL
    SELECT E.id, 
           E.name, 
           E.manager_id, 
           H.lvl + 1 AS lvl
    FROM employees E
    JOIN emp_hierarchy H ON H.id = E.manager_id
)
SELECT H2.id AS emp_id,
       H2.name AS emp_desig, 
       E2.name AS manager,
       H2.lvl AS lvl
FROM emp_hierarchy H2
LEFT JOIN employees E2 ON E2.id = H2.manager_id;

-----------





-- Q3: Find the hierarchy of managers for a given employee (all the managers which are above it).
with recursive emp_hierarchy AS(
    select id , name , 1 as LEVEL 
    FROM employees where name = 'Dev2'
    union
    select id , name , h.lvl+1 as lvl
    from emp_hierarchy h
    join employees on 
    h.manager
)
