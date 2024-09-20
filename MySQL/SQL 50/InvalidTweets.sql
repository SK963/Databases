-- 1683. Invalid Tweets
--  problems : https://leetcode.com/problems/invalid-tweets

-- SCHEMA
Create table If Not Exists Tweets(tweet_id int, content varchar(50));
Truncate table Tweets;
insert into Tweets (tweet_id, content) values ('1', 'Let us Code');
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!');

-- CODE
SELECT tweet_id  FROM tweets
where CHAR_LENGTH(content) > 15 ;
