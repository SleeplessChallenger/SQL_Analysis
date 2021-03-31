-- pull overall session & order volume, trended by quarter for the life of the business

select
	year(website_sessions.created_at) as year,
    quarter(website_sessions.created_at) as quarter,
	count(website_sessions.website_session_id) as sessions,
	count(orders.order_id) as orders
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at <= '2015-03-20'
group by 
	1,2
order by 1,2;
