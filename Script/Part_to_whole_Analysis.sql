-- 4. part to whole analysis (question: which categories contribute the most to overall sales) 
	

with category_sales as (
select
	category,
	sum(sales_amount) as total_sales
from
	gold_fact_sales s
left join gold_dim_products p on
	s.product_key = p.product_key
group by
	1)
select
	category,
	total_sales,
	sum(total_sales) over() as overall_sales,
	concat(round((total_sales / sum(total_sales) over()) * 100 , 2 ), '%') as percentage_of_total
from
	category_sales
order by
	total_sales desc;

