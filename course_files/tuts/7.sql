-- Query 7: https://techtfq.com/blog/learn-how-to-write-sql-queries-practice-complex-sql-queries

-- From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

-- Note: Weather is considered to be extremely cold then its temperature is less than zero.

--Table Structure:

drop table if exists weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);

insert into weather values
(1, 'London', -1, STR_TO_DATE('1-01-2012', '%d-%m-%Y')),
(2, 'London', -2, str_to_date('2-01-2012','%d-%m-%Y')),
(3, 'London', 4, str_to_date('3-01-2012','%d-%m-%Y')),
(4, 'London', 1, str_to_date('4-01-2012','%d-%m-%Y')),
(5, 'London', -2, str_to_date('5-01-2012','%d-%m-%Y')),
(6, 'London', -5, str_to_date('6-01-2012','%d-%m-%Y')),
(7, 'London', -7, str_to_date('7-01-2012','%d-%m-%Y')),
(8, 'London', 5, str_to_date('8-01-2012','%d-%m-%Y'));

select * from weather;

--Solution:

select id, city, temperature, day
from (
    select *,
        case when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lead(temperature,2) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lag(temperature) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lag(temperature) over(order by day) < 0
              and lag(temperature,2) over(order by day) < 0
        then 'Y'
        end as flag
    from weather) x
where x.flag = 'Y';
