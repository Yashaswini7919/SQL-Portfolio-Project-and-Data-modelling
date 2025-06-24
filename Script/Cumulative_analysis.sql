-- 2. calculate the total sales per month and running total of sales over time. 
	-- 2.1 : a. running months 
select
	order_date,
	total_sales,
	sum(total_sales) over(partition by order_date order by order_date) as running_total_sales
from
	(
	select
		date_format(order_date, '%y-%m') as order_date,
		sum(sales_amount) as total_sales
	from
		gold_fact_sales
	where
		order_date is not null
	group by
		1
) as monthly_sales

	-- b. running yearly 

select
	order_date,
	total_sales,
	sum(total_sales) over( order by order_date) as running_total_sales
from
	(
	select
		date_format(order_date, '%y') as order_date,
		sum(sales_amount) as total_sales
	from
		gold_fact_sales
	where
		order_date is not null
	group by
		1
) as monthly_sales

	-- 2.2 : a. moving average of sales by month 

select
	order_date,
	total_sales,
	sum(total_sales) over( order by order_date) as running_total_sales,
	avg(avg_price) over(order by order_date) as moving_avg
from
	(
	select
		date_format(order_date, '%y') as order_date,
		sum(sales_amount) as total_sales,
		avg(price) as avg_price
	from
		gold_fact_sales
	where
		order_date is not null
	group by
		1
) as monthly_sales
