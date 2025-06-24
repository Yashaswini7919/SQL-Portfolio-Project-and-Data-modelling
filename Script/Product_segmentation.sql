-- 5. data segmentation (question:1 segment products into cost ranges and count how many products fall into each segment.)

with product_segemets as (
select
	product_key,
	product_name,
	cost,
	case
		when cost < 100 then 'below 100'
		when cost between 100 and 500 then '100-500'
		when cost between 500 and 1000 then '500-1000'
		else 'above 1000'
	end as cost_range
from
	gold_dim_products )
select
	cost_range,
	count(product_key) as total_products
from
	product_segemets
group by
	cost_range
order by
	2 desc
	
	
	-- question 2 : group customers into three segments based on their spending behaviour: 
	-- 1. vip : at least 12 months of history and spending more than €5000. 
	-- 2. regular : at least 12 months of history but spending €5000 or less.
	-- 3. new : lifespan less than 12 months.
	-- and find the total number of customers by each group. 


select
	*
from
	gold_dim_customers
limit 100;

with customer_spending as (
select
	c.customer_key,
	sum(s.sales_amount) as total_spending,
	min(s.order_date) as first_order,
	max(s.order_date) as last_order,
	timestampdiff(month , min(s.order_date), max(s.order_date) ) as lifespan
from
	gold_fact_sales s
left join gold_dim_customers c on
	s.customer_key = c.customer_key
group by
	1 )
select
	customer_segment as total_customers,
	count(customer_key)
from
	(
	select
		customer_key,
		case
			when lifespan >= 12
				and total_spending > 5000 then 'vip'
				when lifespan >= 12
				and total_spending <= 5000 then 'regular'
				else 'new'
			end as customer_segment
		from
			customer_spending ) t
group by
	customer_segment
order by
	total_customers
	