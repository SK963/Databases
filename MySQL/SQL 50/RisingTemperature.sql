-- 197. Rising Temperature
-- PROBLEM :https://leetcode.com/problems/rising-temperature


-- SCHEMA
Create table If Not Exists Weather (id int, recordDate date, temperature int);
Truncate table Weather;
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');


-- CODE
WITH diff AS (
    SELECT
        id,
        LAG(temperature, 1) OVER (ORDER BY recordDate) - temperature AS diff,
        DATEDIFF((LAG(recordDate , 1) OVER (ORDER BY recordDate)), recordDate) AS days_diff
    FROM Weather
)
SELECT id FROM diff where diff <0 and days_diff = -1;

