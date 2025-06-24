-- 1. change over time ( question : to analyse the sales performance over time )
-- a. yearly overview 
select
	year(order_date) as order_year,
	sum(sales_amount) as total_sales ,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customer
from
	gold_fact_sales
where
	order_date is not null
group by
	1
order by
	1
	-- b. month is used for seasonality 

select
	year(order_date) as order_year,
	month(order_date) as order_month ,
	sum(sales_amount) as total_sales ,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customer
from
	gold_fact_sales
where
	order_date is not null
group by
	1,
	2
order by
	1,
	2
	-- c. using date functions 

select
	date_format( order_date, '%y-%m') as order_month,
	sum(sales_amount) as total_sales ,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customer
from
	gold_fact_sales
where
	order_date is not null
group by
	1
order by
	1