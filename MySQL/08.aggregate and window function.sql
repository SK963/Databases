/*
AGGREGATE FUNCTION : 
-COUNT()
-SUM()
-AVG()
-MIN( )
-MAX()


using aggregate function as window function :


WINDOW FUNCTION :

-ROW_NUMBER(),
-RANK() , 
-DENSE_RANK() ,

-LEAD() , (FETCHES PREVIOUS ROW(S) VALUES)
-LAG() ,  (FETCHES NEXT ROW(S) VALUES)



-FIRST_VALUE() ,
-LAST_VALUE() ,
-NTH_VALUE() ,

-NTILE() , (CREATES BUCKET FOR SEGERATION OF DATA INTO CATEGORIES)

-CUME_DIST() ,
-PERCENT_RANK() 


FRAMING IN WINDOWS FUNCTION : 
- USING ROWS/ RANGE
- FRAME BOUNDRIES : UNBOUND PRECEDING ,UNBOUND FOLLOWING , CURRENT ROE , N PRECEDING , N FOLLOWING

*/

---------------------------------------WINDOW FUNCTION --------------------------------------

create table employee
( emp_ID INT 
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
COMMIT;


select * from employee;


------------------------------------Aggregate Fucntions ---------------------------
--without group by clause
select sum(salary) from employee;
select avg(salary) from employee;
select min(salary) from employee;
select max(salary) from employee;
select count(emp_id) from employee;
select count(distinct emp_id) from employee;
select count() from employee;


select dept_name , sum(salary)
from employee
group by dept_name;

select dept_name , avg(salary)
from employee
group by dept_name;

select dept_name , count(salary)
from employee
group by dept_name;


select dept_name , count(distinct salary)
from employee
group by dept_name;


select dept_name , count(*)
from employee
group by dept_name;

select dept_name , min(salary)
from employee
group by dept_name;

select dept_name , max(salary)
from employee
group by dept_name;



----------------- Aggregate function as Window Function-----------------------------------
-- Aggregate function can also be used as a window function 
-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.


select e.* , 
max(salary) over() as max_salary
from employee e;

select e.*,
max(salary) over(partition by dept_name) as max_salary
from employee e;

------------------------------------------  WINDOW FUNCTION ------------------------------------------------
/* SYNTAX

Window_function([expression]) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression [ASC|DESC]]
    [frame_clause]
)

//EXPRESSION : CAN BE ATTRIBUTES OR FUNCTION
// PARTIOION BY ,ORDER BY , AND FRAMING ARE OPTIONAL 
*/

------------------- row_number(), rank() and dense_rank()-----------------------

--ROW_NUMBER :  GIVES NUMBERING IN THE WINDOWS
select   e.* , 
row_number()  over() as row_num 
from employee e;

--numbering employees in each department
select e.*,
row_number() over(partition by dept_name) as rn
from employee e;

-- order by and serial num
select e.*,
row_number() over(partition by dept_name order by emp_id desc) as rn
from employee e;



-- Fetch the first 2 employees from each department to join the company.
select e.*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee e 
    where rn <3;

-- the above query will not work as the new column_name is not known


-- use inside subqueries 
select * from (
	select e.*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee e) x
where x.rn < 3;




-- use in cte
with rn_cte as(
select e.*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee e )
	select * from RN_CTE where rn <3;



-- RANK : Ranks the members on value and skips the ranks in case of multiple common ranks 
-- Fetch the top 3 employees in each department earning the max salary.
select * from (
	select e.*,
	rank() over(partition by dept_name 
                order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;

--Dense Rank : Ranks the members on value but do not skips the ranks in case of multiple common ranks 
select * from (
	select e.*,
	dense_rank() over(partition by dept_name 
                order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;

-- different between rank, dense_rnk and row_number window functions:
select e.*,
rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk,
row_number() over(partition by dept_name order by salary desc) as rn
from employee e;



---------------------------------- lead and lag-----------------------------------
-- lAG : Fetches the previous row(S) value of window elelment if exist otherwise returns NULL

/*
LAG(P_ /*EXPR [ {RESPECT | IGNORE} NULLS ]*/,
    P_ /*OFFSET INTEGER*/,                     -- OFFSET VALUE : 1
    P_ /*DEFAULT [ OVER (ANALYTIC_CLAUSE)]*/)  -- MISSING VALUE  : NULL
*/*/*/
-- OFFSET : HOW MANY ROW BEFORE THE CURRENT TO LOOK FOR
-- MISSING VALUE :  VALUE TO SHOW IN CASE OF NO RESULT 



select e.*,  
lag(salary) over(partition by dept_name  order by emp_id) as prev_empl_sal
from employee e;




-- Q. fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee in the same department and empid .
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
case when e.salary > lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(partition by dept_name order by emp_id) then 'Lower than previous employee'
	 when e.salary = lag(salary) over(partition by dept_name order by emp_id) then 'Same than previous employee' end
	as sal_range
from employee e;

-- using cte
with prev_sal as (
                select e.*,
                lag(salary) over(partition by dept_name order by emp_id) as prev_sal
                from employee e)
select * ,
case when salary > prev_sal then 'Higher than previous employee'
     when salary < prev_sal then 'Lower than previous employee'
	 when salary = prev_sal then 'Same than previous employee' end
	as sal_range
from prev_sal ;



--USING OFFSET AND MISSING VALUES
 select e.*,
                lag(salary, 2,0) over(partition by dept_name order by emp_id) as prev_sal
                from employee e


-- Similarly using lead function to see how it is different from lag.
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary) over(partition by dept_name order by emp_id) as next_empl_sal
from employee e;

-- WITH OFFSET , AND MISSING REPLACEMENT VALUE
select e.*,
lag(salary,2,0) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary,2,0) over(partition by dept_name order by emp_id) as next_empl_sal
from employee e;

-------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

DROP TABLE product;
CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;


select * from product;


-- FIRST_VALUE 
-- Q. Write query to display the most expensive product under each category (corresponding to each record)
select *,
first_value(product_name) 
    over(partition by product_category order by price desc) as most_exp_product
from product ;


-- LAST_VALUE 
-- Q. Write query to display the most expensice and least expensive product under each category (corresponding to each record)

select *,
first_value(product_name) 
    over(partition by product_category order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category order by price desc)
    as least_exp_product
from product;

-- the above query gives wrong output for the least_exp_product 
-- as the PARTION-FRAME size gets reduced  BETWEEN  START OF THE WINDOW TO THE CURRENT ROW 
-- due to its default framing i.e :

select *,
first_value(product_name) 
    over(partition by product_category 
         order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category 
         order by price desc
         RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    as least_exp_product
from product;



---WITH PROPER FRAMING

select *,
first_value(product_name) 
    over(partition by product_category 
         order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category 
         order by price desc
         ROWS between unbounded preceding and UNBOUNDED FOLLOWING) 
    as least_exp_product    
from product;


--------------------------------- FRAMING IN WINDOWS FUNCTION  -------------------------------
/* SYNTAX FOR FRAMING

<window_function>() OVER (
    PARTITION BY <partition_columns>
    ORDER BY <order_columns>
    ROWS/RANGE BETWEEN <frame_start> AND <frame_end>
    
)

*/

-- Cumulative Sum Using ROWS
-- Calculate the cumulative sum of prices within each product category.

SELECT product_category, brand, product_name, price,
       SUM(price) OVER (PARTITION BY product_category ORDER BY price 
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
                         AS cum_sum
FROM product;

-- cumulative Sum Using RANGE 
-- Calculate the cumulative sum of prices within each product category using RANGE.

SELECT product_category, brand, product_name, price,
       SUM(price) OVER (
           PARTITION BY product_category
           ORDER BY price
           RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cum_sum
FROM product;

-- Moving Average Using ROWS
-- Calculate a 3-row moving average of prices within each product category.

SELECT product_category, brand, product_name, price,
       AVG(price) OVER (
           PARTITION BY product_category
           ORDER BY price
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg
FROM product;


-- MOVING AVERAGES WITH RANGE GIVES WRONG OUPUT AS IT CANNOT BE USED WITH N PRECEDING CLAUES 
-- unless it is with a numeric value related to the ordering column directly 

SELECT product_category, brand, product_name, price,
       AVG(price) OVER (
           PARTITION BY product_category
           ORDER BY price
           RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg
FROM product;



--difference b/w rows and range
-- row look for row : in case duplicate value no effect 
-- range look for value : in case of duplicate its range goes upto the last duplicate row


-- Rows
select *,
first_value(product_name) 
    over(partition by product_category 
         order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category 
         order by price desc
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    as least_exp_product
from product
where product_category = "Phone";

-- Range
select *,
first_value(product_name) 
    over(partition by product_category 
         order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category 
         order by price desc
         RANGE between unbounded preceding and CURRENT ROW) 
    as least_exp_product    
from product
WHERE product_category = "Phone";



--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

----------------- Alternate way to write SQL query using Window functions ------------------
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product    
from product
WHERE product_category ='Phone'
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);
            

            
-- NTH_VALUE 
-- Write query to display the Second most expensive product under each category.
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_product,
nth_value(product_name, 5) over w as fifth_most_exp_product
from product
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);



-- NTILE : creates bucket for segragting rows into categories

-- Q. Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.
select x.product_name, 
case when x.buckets = 1 then 'Expensive Phones'
     when x.buckets = 2 then 'Mid Range Phones'
     when x.buckets = 3 then 'Cheaper Phones' END as Phone_Category
from (
    select *,
    ntile(3) over (order by price desc) as buckets
    from product
    where product_category = 'Phone') x;




-- CUME_DIST (cumulative distribution) ; 
/*  Formula = Current Row no (or Row No with value same as current row) / Total no of rows */

-- Query to fetch all products which are constituting the first 30% 
-- of the data in products table based on price.
SELECT product_name,
           CUME_DIST() OVER (ORDER BY price DESC) AS cume_distribution
FROM product;


SELECT product_name, 
       CONCAT(cume_dist_percentage, '%') AS cume_percent
FROM (
    SELECT product_name,
           CUME_DIST() OVER (ORDER BY price DESC) AS cume_distribution,
           ROUND(CUME_DIST() OVER (ORDER BY price DESC) * 100, 2) AS cume_dist_percentage
    FROM product
) x
WHERE x.cume_distribution <= 0.30;




-- PERCENT_RANK (relative rank of the current row / Percentage Ranking)
--VALUE -> 0 <= PERCENT_RANK >= 1
/* Formula = Current Row No - 1 / Total no of rows - 1 */

-- Query to identify how much percentage more expensive is "Galaxy Z Fold 3" when compared to all products.
select product_name, per
from (
    select *,
    percent_rank() over(order by price) ,
    round(percent_rank() over(order by price) * 100, 2) as per
    from product) x
where x.product_name='Galaxy Z Fold 3';

