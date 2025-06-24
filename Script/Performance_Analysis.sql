
	-- 3. performance analysis (analyse the yearly performance of products by comparing their sales to both the avg sales performance of the product and the previous year sales)
	-- yoy analysis 
with yearly_product_sales as (
	select
		year(s.order_date) as order_year,
		p.product_name,
		sum(s.sales_amount) as current_sales
	from
		gold_dim_products p
	left join gold_fact_sales s on
		p.product_key = s.product_key
	where
		s.order_date is not null
	group by
		1,
		2 
)
select
	order_year,
	product_name,
	current_sales,
	avg(current_sales) over(partition by product_name ) avg_sales,
	current_sales - avg(current_sales) over(partition by product_name ) as avg_diff,
	case
		when current_sales - avg(current_sales) over(partition by product_name ) > 0 then 'above avg'
		when current_sales - avg(current_sales) over(partition by product_name ) < 0 then 'below avg'
		else 'avg'
	end as avg_change,
	lag(current_sales) over (partition by product_name
order by
	order_year) as previous_sales,
	current_sales - lag(current_sales) over (partition by product_name
order by
	order_year) as previous_diff,
	case
		when current_sales - lag(current_sales) over (partition by product_name
	order by
		order_year) > 0 then 'increase'
		when current_sales - lag(current_sales) over (partition by product_name
	order by
		order_year) < 0 then 'decrease'
		else 'no change '
	end as previous_change
from
	yearly_product_sales
	
	
	
	-- mom analysis 
with yearly_product_sales as (
	select
		month(s.order_date) as order_year,
		p.product_name,
		sum(s.sales_amount) as current_sales
	from
		gold_dim_products p
	left join gold_fact_sales s on
		p.product_key = s.product_key
	where
		s.order_date is not null
	group by
		1,
		2 
)
select
	order_year,
	product_name,
	current_sales,
	avg(current_sales) over(partition by product_name ) avg_sales,
	current_sales - avg(current_sales) over(partition by product_name ) as avg_diff,
	case
		when current_sales - avg(current_sales) over(partition by product_name ) > 0 then 'above avg'
		when current_sales - avg(current_sales) over(partition by product_name ) < 0 then 'below avg'
		else 'avg'
	end as avg_change,
	lag(current_sales) over (partition by product_name
order by
	order_year) as previous_sales,
	current_sales - lag(current_sales) over (partition by product_name
order by
	order_year) as previous_diff,
	case
		when current_sales - lag(current_sales) over (partition by product_name
	order by
		order_year) > 0 then 'increase'
		when current_sales - lag(current_sales) over (partition by product_name
	order by
		order_year) < 0 then 'decrease'
		else 'no change '
	end as previous_change
from
	yearly_product_sales