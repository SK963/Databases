-- 570. Managers with at Least 5 Direct Reports (M)
-- PROBLEM :  https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description

-- SCHEMA
Create table If Not Exists Employee (id int, name varchar(255), department varchar(255), managerId int);
Truncate table Employee;
insert into Employee (id, name, department, managerId) values ('101', 'John', 'A', NULL);
insert into Employee (id, name, department, managerId) values ('102', 'Dan', 'A', '101');
insert into Employee (id, name, department, managerId) values ('103', 'James', 'A', '101');
insert into Employee (id, name, department, managerId) values ('104', 'Amy', 'A', '101');
insert into Employee (id, name, department, managerId) values ('105', 'Anne', 'A', '101');
insert into Employee (id, name, department, managerId) values ('106', 'Ron', 'B', '101');


-- CODE
select employee.name from employee 
where id in (select managerid from employee 
            group by managerid  
            having count(managerid) >= 5);