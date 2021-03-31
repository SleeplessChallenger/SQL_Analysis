-- pull a quarterly view of orders from Gsearch nonbrand, Bsearch nonbrand,
-- brand search overall, organic search, direct type-in

select
	year(website_sessions.created_at) as year,
	quarter(website_sessions.created_at) as quarter,
	count(case when utm_campaign = 'nonbrand' and utm_source = 'gsearch' 
		  then orders.order_id else NULL end) as nonbrand_gsearch,
	count(case when utm_campaign = 'nonbrand' and utm_source = 'bsearch'
		  then orders.order_id else NULL end) as nonbrand_bsearch,
	count(case when utm_campaign = 'brand' then orders.order_id else NULL end) as branded_search,
	count(case when http_referer is not NULL and utm_source is NULL
		  then orders.order_id else NULL end) as organic_search,
	count(case when http_referer is NULL and utm_source is NULL
		  then orders.order_id else NULL end) as direct_type_in
from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2015-03-20'
group by 1,2
order by 1,2;
