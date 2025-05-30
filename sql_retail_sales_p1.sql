create database project_1;

use  project_1;

create table retail_sales
(transactions_id int,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age	int,
category varchar(15),	
quantiy	int,
price_per_unit float,
cogs float,
total_sale float);

select * from retail_sales;

select * from retail_sales
where sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

delete from retail_sales
where sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

select count(*) from retail_sales;






-- Q.1 retrive all columns for sales made on 2022-11-05

select * from retail_sales 
where sale_date ='2022-11-05';

-- retive all transactions where the category is 'clothing' and the quantity sold is atleast 4 in the month nov-2022

select * from retail_sales
where category = 'clothing'
and quantiy >=4
and date_format(sale_date,'%y-%b') = '22-nov';

-- Q.3 calculate the total sales for each category.

select category,sum(total_sale)as total
from retail_sales
group by category;

-- Q.4 find the average age of customers who purchased items from the 'beauty' category.

select round(avg(age),2) from retail_sales
where category='beauty';

-- Q.5 find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- find the total number of transactions made by each gender in each category.

select category,gender,count(transactions_id)
from retail_sales
group by category,gender
order by category;

-- calculate the average sale for each month.find out best selling month in each year

with avg_sale as(
select year(sale_date) as year,
month(sale_date) as month,
round(avg(total_sale),2) as avg_sale,
rank()over (partition by year(sale_date) order by avg(total_sale) desc)top
 from retail_sales
 group by 1,2
 order by avg_sale desc)
 select year,month,avg_sale from avg_sale
 where top =1;

select year,month,avg_sale from(
select year(sale_date) as year,
month(sale_date) as month,
round(avg(total_sale),2) as avg_sale,
rank()over (partition by year(sale_date) order by avg(total_sale) desc)top
 from retail_sales
 group by 1,2
 order by avg_sale desc)as t1
 where top =1;

-- Q.8 find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale)as total from retail_sales
group by customer_id
order by total desc
limit 5;

-- Q.9 find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id)as unique_customer from retail_sales
group by category;

-- Q.10 create each shift and number of orders(example morning<=12,afternoon between 12 & 17, evening >17).

with shift as(
select *,
case when hour(sale_time) < 12 then 'morning' 
     when hour(sale_time) between 12 and 17 then 'afternoon'
     else 'evening' end as shift
     from retail_sales)
     select shift,count(transactions_id)
     from shift
     group by shift;