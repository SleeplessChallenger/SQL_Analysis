use mavenfuzzyfactory;

select
	min(date(website_sessions.created_at)) as month_date,
	count(distinct case when website_sessions.utm_campaign = 'brand' then website_sessions.website_session_id else NULL end) as brand_sessions,
	count(distinct case when website_sessions.utm_campaign = 'nonbrand' then website_sessions.website_session_id else NULL end) as non_brand_sessions,
	count(distinct case when website_sessions.utm_campaign = 'brand' then orders.order_id else NULL end) as brand_orders,
	count(distinct case when website_sessions.utm_campaign = 'nonbrand' then orders.order_id else NULL end) as non_brand_orders
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2012-11-27'
	and website_sessions.utm_source = 'gsearch'
group by
	month(website_sessions.created_at);
