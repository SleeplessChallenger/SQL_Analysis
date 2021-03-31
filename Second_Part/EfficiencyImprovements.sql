-- quarterly figures for session-to-order CVR, revenue per order, revenue per session

select
	year(website_sessions.created_at),
	quarter(website_sessions.created_at),
	count(orders.order_id)/
	count(website_sessions.website_session_id) as session_order_conv_rate,
	sum(price_usd)/count(orders.order_id) as revenue_per_order,
	sum(price_usd)/
	count(website_sessions.website_session_id) as revenue_per_session
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2015-03-20'
group by
	year(website_sessions.created_at),
	quarter(website_sessions.created_at)
order by 1,2;
