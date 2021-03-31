-- pull monthly trending for revenue and margin by product, along with
-- total sales and revenue + notes about seasonality

select
	year(orders.created_at) as year,
	month(orders.created_at) as month,

	sum(order_items.price_usd - order_items.cogs_usd) as total_margin,
	sum(order_items.price_usd) as total_revenue,
	count(orders.order_id) as total_sales,

	sum(case when order_items.product_id = 1 then order_items.price_usd else NULL end) as first_product_rev,
	sum(case when order_items.product_id = 2 then order_items.price_usd else NULL end) as second_product_rev,
	sum(case when order_items.product_id = 3 then order_items.price_usd else NULL end) as third_product_rev,
	sum(case when order_items.product_id = 4 then order_items.price_usd else NULL end) as fourth_product_rev,

	sum(case when order_items.product_id = 1 then order_items.price_usd - order_items.cogs_usd
		else NULL end) as first_product_margin,
	sum(case when order_items.product_id = 2 then order_items.price_usd - order_items.cogs_usd
		else NULL end) as second_product_margin,
	sum(case when order_items.product_id = 3 then order_items.price_usd - order_items.cogs_usd
		else NULL end) as third_product_margin,
	sum(case when order_items.product_id = 4 then order_items.price_usd - order_items.cogs_usd
		else NULL end) as fourth_product_margin,

	count(case when orders.primary_product_id = 1 then orders.order_id else NULL end) as product_one_orders,
	count(case when orders.primary_product_id = 2 then orders.order_id else NULL end) as product_two_orders,
	count(case when orders.primary_product_id = 3 then orders.order_id else NULL end) as product_three_orders,
	count(case when orders.primary_product_id = 4 then orders.order_id else NULL end) as product_four_orders

from order_items
	inner join orders
		on orders.order_id=order_items.order_id
where orders.created_at < '2015-03-20'
group by 1,2
order by 1,2;
