-- Get number of monthly active customers.

use sakila;
create or replace view monthly_active_customers as
select count(distinct customer_id) active_customers, 
		date_format(convert(rental_date, date), '%M') as activity_month,
        date_format(convert(rental_date, date), '%Y') as activity_year
from rental
group by activity_month, activity_year
order by activity_year;

select * from monthly_active_customers;

-- Active users in the previous month.
create view active_users_last_month AS
select
lag(active_customers) over(partition by activity_year order by activity_month) as previous_month
from monthly_active_customers;
select * from active_users_last_month;

-- Percentage change in the number of active customers.
select active_customers, previous_month, round(active_customers/previous_month*100, 2) as 'increment(%)', activity_month, activity_year
from active_users_last_month;
-- Retained customers every month.