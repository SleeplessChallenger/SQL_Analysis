-- pull sales data since '2014-12-05' and show how well each product cross-sells
-- from one another


-- table with all desired data about product for further analysis

DROP TEMPORARY TABLE IF EXISTS products_tab;

create temporary table products_tab
select
	primary_product_id,
	order_id,
	created_at
from orders
where created_at > '2014-12-05'
	and created_at <= '2015-03-20';


-- final

select
	primary_product_id,
	count(order_id) as total_orders,

	count(case when item = 1 then order_id else NULL end) as p1_cross_sold,
	count(case when item = 1 then order_id else NULL end)/
	count(order_id) as p1_cross_sold_rate,

	count(case when item = 2 then order_id else NULL end) as p2_cross_sold,
	count(case when item = 2 then order_id else NULL end)/
	count(order_id) as p2_cross_sold_rate,

	count(case when item = 3 then order_id else NULL end) as p3_cross_sold,
	count(case when item = 3 then order_id else NULL end)/
	count(order_id) as p3_cross_sold_rate,

	count(case when item = 4 then order_id else NULL end) as p4_cross_sold,
	count(case when item = 4 then order_id else NULL end)/
	count(order_id) as p4_cross_sold_rate
from

	(
	select
		products_tab.*,
		order_items.product_id as item
	from products_tab
		left join order_items
			on order_items.order_id=products_tab.order_id
			and order_items.is_primary_item = 0 -- cross sell stuff only
	) as cross_products
group by 1
order by 2 desc;
