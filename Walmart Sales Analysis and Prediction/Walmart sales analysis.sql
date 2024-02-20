CREATE database IF NOT EXISTS WALMARTSALES;

CREATE TABLE IF NOT EXISTS SALES(
invoice_id varchar(30) NOT NULL PRIMARY KEY,
branch varchar(5) NOT NULL,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12, 4) not null,
date datetime not null,
time TIME not null,
payment_method varchar(15) not null,
cogs decimal (10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
);

-------------------------Feature Engineering-------------------------------------------------------------------------
--time_of_day
select time,
(case
when `time` between "00:00:00" and "12:00:00" then "Morning"
when `time` between "12:00:01" and "16:00:00" then "Afternoon"
else "Evening"
end) as time_of_date
 from sales;
 
 alter table sales add column time_of_date varchar(20);
 
update sales
 set time_of_date = (
case
when `time` between "00:00:00" and "12:00:00" then "Morning"
when `time` between "12:00:01" and "16:00:00" then "Afternoon"
else "Evening"
end
 );
 --------------------------------------------------------------------------------------------------------
 -------------day_name-------------
 select date, dayname(date) as day_name from sales;
 
 alter table sales add column day_name varchar(10);
 
 update sales
 set day_name = dayname(date);
 
 --------------------------------------------------------------------------------------------------------
 ------month_name----------
 select date, monthname(date) as month_name from sales;
 
 alter table sales add column month_name varchar(20);
 
 update sales
 set month_name = monthname(date);
 -------------------------------------------------------------------------------------------------------
 ---------------------------------------------EDA-------------------------------------------------------
 
 -- How many unique cities does the data have ?
 select distinct(city) from sales;
 
 --  In Which city is each branch ?
 select distinct city,branch from sales;
 
 -- How many unique product lines does the data have?
 select count(distinct product_line) from sales;
 
 -- what is the common paymnt method ?
 select payment_method, count(payment_method) from sales
 group by payment_method
 order by 1 desc
 limit 1;
 
 -- What is the most selling product line?
select product_line, count(product_line) from sales
group by 1
order by 1 desc
limit 1;

-- What is the total revenue by month?
select sum(total) as revenue, month_name from salesgoldusers_signupgoldusers_signup
group by 2
order by 1 desc;

-- What month had the largest COGS?
select month_name, sum(cogs) from sales
group by 1
order by 2 desc
limit 1;

-- What product line and city had the largest revenue?
select sum(total) as revenue, product_line from sales
group by 2
order by 1 desc
limit 1;
select sum(total) as revenue, city from sales
group by 2
order by 1 desc
limit 1;

-- which branch sold more products then the average product sold?
select branch, sum(quantity) as qty from sales
group by 1
having qty > (select avg(quantity) from sales);

-- what is the most common product line by gender?
select gender, product_line, count(gender) as cnt from sales
group by 1, 2
order by 3 desc;

-- what is the average rating of each product line?
select product_line, avg(rating) as rating from sales
group by 1
order by 2 desc;

--------------------------------------------------------------------------------------------------------------------------------------------------

-- number of sales made in each time of the day per week?
select time_of_date, count(total) from sales
group by 1
order by 2 desc;

-- which customer type brings most revenue?
select customer_type, sum(total) as revenue from sales
group by 1
order by 2 desc
limit 1;

-- which gender have the most customer ?
select gender,count(gender) from sales
group by 1
order by 2 desc;

-- which time of the day customer give most rating?
select time_of_date, avg(rating) from sales
group by 1
order by 2 desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select product_line,
case
when total > (select avg(total) from sales) then 'Good'
else 'Bad' 
end as sales_category
from sales;
