/*
Subqueries : 
-TYPES : Scalar , Row , Column , Table , Correlated and Nested 
-WITH DIFFERENT CLAUSES IN SELECT STATMENTS :FROM , HAVING , JOIN , WHERE 
-WITH DIFFERENT STATEMENTS : SELECT , INSERT , UPDATA , DELETE

*/

show tables;
drop table if EXISTS department;
drop table if EXISTS employee;
drop table if exists sales;

create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO department (Dept_id, dept_name, location) VALUES
(1, 'Admin', 'New York'),
(2, 'HR', 'San Francisco'),
(3, 'IT', 'Los Angeles'),
(4, 'Finance', 'Chicago'),
(5, 'Marketing' , "Los Angeles"),
(6, 'Design' ,'New York' );

select * from department;


--  Sales table 

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    store_name VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Insert sample data into sales table
INSERT INTO sales (sale_id, store_name, price) VALUES
(1, 'Store A', 100.00),
(2, 'Store B', 150.00),
(3, 'Store A', 200.00),
(4, 'Store C', 300.00),
(5, 'Store B', 250.00),
(6, 'Store A', 400.00),
(7, 'Store C', 350.00),
(8, 'Store B', 450.00),
(9, 'Store A', 500.00),
(10, 'Store C', 550.00);

-- Display all records from sales table
SELECT * FROM sales;
-----------------------------------------------------------------------------------
-- Scalar subquery :  return single row and single column (i.e 1 value)
-- Q. find all the details of the employees whose salary is more than the average salary of the employee

select avg(salary) from employee;
select * from employee where salary > (select avg(salary) from employee);
									----------------------------------
-- Single-Row Subquery / Row Subquery : return 1 row and mutiple col 
-- Q.select employees name whose department is HR
select emp_name from(select * from employee 
                        where dept_name = "HR")e;


-------------------------------------------------------------------------------------------------
--multiple row subquery
-- with mulitple column (table Subquery)
-- with single column (column Subquery)



											------------------------------------
-- multiple rows  single column (column subquery)
-- Q. Finding all the detail from the department table  which there is no employee in the employee table
select * from 
departments
where dept_name not in (select DISTINCT dept_name from employees);

												-------------------------------
--multiple row and multiple columns (table subquery)
--Q. finding employees with max salary in their department 


select * 
from employee 
where (dept_name, salary)  in (select dept_name , max(salary)
                                from employee
                                group by dept_name);


-------------------------------------------------------------------------------------
-- Correlated Subquery : the subquery in which the inner query is related to outer query
-- Correlated subqueries depend on the outer query for their values and are evaluated row by row.
--  the inner query cannot run independently


-- Q1.finding the employees in each departmemt who earns more than the average salary in that department
SELECT * from employee e1
where salary > (select avg(salary)
                 from employee e2
                 where e2.dept_name = e1.dept_name);


-- Q2. select all the info from departments which is not in employee table
select * 
from department d
where not exists (select 1 
                    from employee e 
                    where e.dept_name = d.dept_name);

------------------------------------------------------------------------------
-- nested Subquery
--Q. find the stores from the sales table who's sale is better than the average sales accross all stores
-- soln 
-- a) finding total sales for each store
-- b)finding average sales of all stores 
-- c) comparing a and b

select * from sales;

select * 
from (select store_name , sum(price) as total_sales 
                from sales
                group by store_name)  sale_sum
join (select avg(total_sales) as avg_sal
        from (select store_name , sum(price) as total_sales
        from sales 
        group by store_name)sales_sum) average_sales
on sale_sum.total_sales > average_sales.avg_sal;


--  with cte
with sales as (select store_name , sum(price) as total_sales 
                from sales
                group by store_name)
select *
from sales
join (select avg(total_sales) as Sales
    from sales x) avg_sales 
    on sales.total_sales > avg_sales.sales;


-- With Select  : avoid using subquery with select clause
-- Q. select all employee detail and add remarks to those employee who earn more than the average pay
select * , (case when salary > (select avg(salary) from employee) then "Higher than average"
            else null end) as remarks
from employee;




-------------------subquery with  different statements ---------------
-------------------------------------------------------------------
-- SELECT 
-- INSERT
-- UPDATE
-- DELETE

drop table if exists employees;
drop table if exists departments;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

-- Insert sample data into departments table
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'HR', 'New York'),
(2, 'Sales', 'New York'),
(3, 'Engineering', 'San Francisco'),
(4, 'Marketing', 'Chicago');

-- Create the employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert sample data into employees table
INSERT INTO employees (employee_id, name, salary, department_id) VALUES
(1, 'John Doe', 60000, 2),
(2, 'Jane Smith', 75000, 3),
(3, 'Sam Brown', 50000, 1),
(4, 'Emily Davis', 45000, 1),
(5, 'Michael Johnson', 80000, 3),
(6, 'Chris Lee', 65000, 2),
(7, 'Patricia Wilson', 55000, 4);

--SUBQUERIES IN SELECT : 
-- even in select statement subqueries can used with various clause 

SELECT *,
       (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS dept_avg_salary
FROM employees e;



-- SUBQUERY IN INSERT
drop table if EXISTS training_employees;
CREATE TABLE if not EXISTS training_employees (
    employee_id INT,
    name VARCHAR(100)
);


-- Insert into training_employees based on subquery
INSERT INTO training_employees (employee_id, name)
SELECT employee_id, name
FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Sales');


select * from employees;

--SUBQUERY IN UPDATE
-- Update salaries to the average salary of the department if below average
UPDATE employees e1
SET salary = (SELECT AVG(salary) 
                FROM employees e2 
                WHERE e2.department_id = e1.department_id)
WHERE salary < (SELECT AVG(salary) 
                FROM employees e2 
                WHERE e2.department_id = e1.department_id);


/* errors : In SQL, when using a subquery in an UPDATE statement,
 especially when the subquery references the table being updated,
  it often leads to errors due to the ambiguity and the restrictions
   imposed by SQL syntax. */

--correct approach
UPDATE employees e1
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS da ON e1.department_id = da.department_id
SET e1.salary = da.avg_salary
WHERE e1.salary < da.avg_salary;

select * from employees;

--SUBQUERY IN DELETE
-- Delete employees from departments with average salaries less than $40,000
DELETE FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        GROUP BY department_id
                        HAVING AVG(salary) < 40000);

-- the above query will throw error for the same reason 

--correct approach
DELETE e1
FROM employees e1
JOIN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) < 50000
) AS subq ON e1.department_id = subq.department_id;

select * from employees;

drop table if EXISTS employees;
drop table if EXISTS departmemts;


-----------------------------------------------------------------------
-------------------------------------------------------------------------

-- subqueries with different clauses  :
-- select : derived values
-- from : derived table
-- where : filter list , table for rows
-- having : filter list , table for groups after aggreagation
-- join : derived table 


drop table if exists departments;
drop table if exists employees;

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location_id INT
);

-- Insert sample data into departments table
INSERT INTO departments (department_id, department_name, location_id) VALUES
(1, 'Sales', 1700),
(2, 'Marketing', 1800),
(3, 'HR', 1700),
(4, 'IT', 1900);

-- Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert sample data into employees table
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary) VALUES
(1, 'John', 'Doe', 1, 50000),
(2, 'Jane', 'Smith', 2, 60000),
(3, 'Bob', 'Johnson', 1, 40000),
(4, 'Alice', 'Williams', 3, 70000),
(5, 'Chris', 'Jones', 4, 80000);


-- with select clause
SELECT employee_id, 
       (SELECT department_name FROM departments WHERE departments.department_id = employees.department_id) AS department_name
FROM employees;


--with where clause
SELECT * 
FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Sales');

--with having clause
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- with from clause
SELECT sub.department_id, sub.avg_salary
FROM (SELECT department_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id) sub
WHERE sub.avg_salary > 50000;


-- with join clause
SELECT e.employee_id, e.first_name
FROM employees e
JOIN (SELECT department_id FROM departments WHERE location_id = 1700) d
ON e.department_id = d.department_id;



