

/* HANDLING DATABASES AND TABLES

DDL :CREATE , DROP , ALTER , DROP , TRUNCATE , RENAME ,

DML : INSERT , UPDATE , DELETE , 

OTHERS:  SHOW , USE , DESC
*/



-- Database related commands


-- creating databases 
create database customers;



-- View Databases exists in the system
show databases;

-- Selecting a Database 
use world;


-- Viewing Tables of the current selected Database 
show tables;

-- Viewing Tables of Another Database without selecting
show tables from  Sakila;


-- deleting databases
 drop database customers;
 show databases;


-- Copying Database  
-- while selecting the data constrianits and conditions can be putted 

--1.create new database
CREATE DATABASE world_copy;

--2.-- Generate the CREATE TABLE statements
SHOW TABLES FROM world;


-- 3. Copy the tables listed above
CREATE TABLE world_copy.table_name LIKE world.table_name;
INSERT INTO world_copy.table_name SELECT * FROM world.table_name;


-- 
use world_copy;

CREATE TABLE city_copy AS
SELECT * FROM world.city;


CREATE TABLE world_copy.country_copy AS
SELECT * FROM world.country;


show tables;

desc activity;




CREATE DATABASE DBMS;
USE DBMS;

---------------------------------- VIEWING TABLES -----------------------------------
# From the selected Database
Show Tables;

# From another Database
show tables from WORLD;

--------------------------------- VIEWING A TABLE STRUCTURE --------------------------
DESC Employees;
--OR
DESCRIBE Employees;

----------------------------------- CREATING TABLES --------------------------------
CREATE TABLE Employees (
   id INT PRIMARY KEY,
   name VARCHAR (20) ,
   email VARCHAR (25),
   department VARCHAR(20)
);

--------------------------------------- COPYING TABLE ------------------------------------
---- copying structure only & then copy the data

-- same database
CREATE TABLE Employees_Copy LIKE Employees;

-- from another database
CREATE TABLE Employees_Copy LIKE Others.Employees;

-- from one database to another database
CREATE TABLE Staffs.Employees_copy LIKE Others.Employees;

-- Copy the data
INSERT INTO Employees_copy
SELECT * FROM Employees;


-- Copy Structure and Data DELETECREATE TABLE new_table_name AS
CREATE DATABASE world_copy;

-- without selecting the new database
CREATE TABLE world_copy.country_copy AS
SELECT * FROM world.country;

-- Selecting the new_database
use world_copy;

CREATE TABLE city_copy AS
SELECT * FROM world.city;

----------------------------------- RENAMING TABLE -----------------------------------------
ALTER TABLE EMPLOYEES
RENAME TO Employee;


------------------------------------UPDATING TABLE SCHEMA ----------------------------------
DESC Employees;

-- Add Column 
ALTER TABLE employees ADD COLUMN salary DECIMAL(10, 2);

-- Add column with comment 
ALTER TABLE employees 
    ADD COLUMN  hire_date DATE COMMENT "Joining Date";

-- Add column after a specific column 
ALTER TABLE employees 
    ADD COLUMN column_name1 [type] COMMENT 'comment' AFTER `column_name0`;

--Change Data type
ALTER TABLE employees MODIFY COLUMN email VARCHAR(50);

-- Rename a column
ALTER TABLE employees RENAME COLUMN hire_date TO joining_date;


-- Delete Column
ALTER TABLE employees DROP COLUMN hire_date;

-- Adding Comment
-- to Table 
ALTER TABLE employees COMMENT 'This table stores employee details';
-- to Table column for description 
ALTER TABLE employees MODIFY COLUMN email VARCHAR(100) COMMENT 'Employee email address';

----------------------------DELETING TABLE --------------------------------------------

DROP TABLE Employees;

----------------------------------TEMPORARY TABLES --------------------------------------
SHOW TABLES; 

-- Create a permanent table
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    location VARCHAR(50)
);

-- Insert data into the permanent table
INSERT INTO departments (name, location) VALUES
    ('Sales', 'Building A'),
    ('Marketing', 'Building B'),
    ('IT', 'Building C');


-- Create a temporary table
CREATE TEMPORARY TABLE temp_employees (
    id INT,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- Insert data into the temporary table
INSERT INTO temp_employees (id, name, salary) VALUES
    (1, 'John Doe', 50000),
    (2, 'Jane Smith', 60000),
    (3, 'Sam Brown', 55000);

-- Perform a query using the temporary table
SELECT e.id, e.name, e.salary, d.name AS department_name
FROM temp_employees e
JOIN departments d ON e.id = d.id;

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS temp_employees;
