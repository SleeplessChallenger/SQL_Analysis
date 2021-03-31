-- pull monthly sessions to the '/products' page and show how the % of those sessions
-- clicking through another page has changed over time along with a view of how
-- conversion from '/products' to placing an order has imrpoved



-- find sessions that were in '/products' url

DROP TEMPORARY TABLE IF EXISTS products_url;

create temporary table products_url

select
	website_sessions.website_session_id,
	website_pageviews.website_pageview_id,
	website_pageviews.pageview_url,
	website_sessions.created_at
from website_sessions
	inner join website_pageviews
		on website_pageviews.website_session_id=website_sessions.website_session_id
where website_sessions.created_at <= '2015-03-20'
	and website_pageviews.pageview_url = '/products';



-- extract pageviews & urls which were after '/products' page
-- + count orders

select
	min(date(products_url.created_at)) as month_date,
	count(products_url.website_session_id) as on_product_sessions,
	count(website_pageviews.website_session_id) as next_to_product_sessions,
	count(website_pageviews.website_session_id)/
	count(products_url.website_session_id) as products_clickthrough_rate,
	count(orders.order_id) as orders,
	count(orders.order_id)/
	count(products_url.website_session_id) as products_order_cvr
from products_url
	left join website_pageviews
		on website_pageviews.website_session_id = products_url.website_session_id 
		and website_pageviews.website_pageview_id > products_url.website_pageview_id
	left join orders
		on orders.website_session_id = products_url.website_session_id
group by
	year(products_url.created_at),
	month(products_url.created_at);
