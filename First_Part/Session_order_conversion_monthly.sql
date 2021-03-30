use mavenfuzzyfactory;

select
	min(date(website_sessions.created_at)) as month_date,
	count(distinct website_sessions.website_session_id) as sessions,
	count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/
	count(distinct website_sessions.website_session_id) as session_order_ratio
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
group by month(website_sessions.created_at);
