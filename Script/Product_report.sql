-- 7. product report
-- purpose: this report consolidates key product metrics and behaviors.
-- highlights: 1. gathers essential fields such as product name, category, subcategory, and cost.
-- 2. segments products by revenue to identify high-performers, mid-range, or low-performers.
-- 3. aggregates product-level metrics: (- total orders- total sales - total quantity sold- total customers (unique)- lifespan (in months))
-- 4. calculates valuable kpis:(- recency (months since last sale) - average order revenue (aor) - average monthly revenue))


create view gold_report_products as
with base_query as 
(
select
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	s.order_number,
	s.sales_amount,
	s.quantity,
	s.customer_key,
	s.order_date
from
	gold_fact_sales s
left join gold_dim_products p on
	s.product_key = p.product_key
where
	s.order_date is not null),
product_aggregation as (
select
	product_key ,
	product_name,
	category,
	subcategory,
	cost,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	max(order_date) as last_sale_date,
	round(avg(cast(sales_amount as float) / nullif(quantity, 0)), 1) as avg_selling_price ,
	timestampdiff( month, min(order_date), max(order_date) ) as lifespan
from
	base_query
group by
	product_key,
	product_name,
	category,
	subcategory,
	cost)
select
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	timestampdiff(month , last_sale_date , current_date()) as recency_in_months,
	case
		when total_sales > 50000 then 'high-performer'
		when total_sales >= 10000 then 'mid-range'
		else 'low-performer'
	end as product_segment,
	lifespan, 
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- avg order revenie aor
	case
		when total_orders = 0 then 0
		else total_sales / total_orders
	end as avg_order_revenue,
	-- avg monthly revenue
	case
		when lifespan = 0 then total_sales
		else total_sales / lifespan
	end as avg_monthy_revenue
from
	product_aggregation
