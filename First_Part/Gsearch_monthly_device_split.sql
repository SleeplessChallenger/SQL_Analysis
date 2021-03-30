use mavenfuzzyfactory;

select
	min(date(website_sessions.created_at)) as month_date,
-- 	website_sessions.device_type as device_type,
	count(distinct case when website_sessions.device_type = 'desktop' then website_sessions.website_session_id else NULL end) as desktop_sessions,
	count(distinct case when website_sessions.device_type = 'desktop' then orders.order_id else NULL end) as desktop_orders,
	count(distinct case when website_sessions.device_type = 'mobile' then website_sessions.website_session_id else NULL end) as mobile_sessions,
	count(distinct case when website_sessions.device_type = 'mobile' then orders.order_id else NULL end) as mobile_orders
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.utm_source = 'gsearch'
	and website_sessions.utm_campaign = 'nonbrand'
	and website_sessions.created_at < '2012-11-27'
group by
	month(website_sessions.created_at);
