-- pull overall session-to-order conversion rate trends for the channels
-- by quarter + notes of periods with surge-like improvement

select
	year(website_sessions.created_at) as year,
	quarter(website_sessions.created_at) as quarter,

	count(case when utm_campaign = 'nonbrand' and utm_source = 'gsearch' 
		  then orders.order_id else NULL end)/
	count(case when utm_campaign = 'nonbrand' and utm_source = 'gsearch' 
		  then website_sessions.website_session_id else NULL end) as nonbr_gs_cvr,

	count(case when utm_campaign = 'nonbrand' and utm_source = 'bsearch'
		  then orders.order_id else NULL end)/
	count(case when utm_campaign = 'nonbrand' and utm_source = 'bsearch'
		  then website_sessions.website_session_id else NULL end) as nonbr_bs_cvr,

	count(case when utm_campaign = 'brand' then orders.order_id else NULL end)/
	count(case when utm_campaign = 'brand' then
		  website_sessions.website_session_id else NULL end) as branded_cvr,

	count(case when http_referer is not NULL and utm_source is NULL
		  then orders.order_id else NULL end)/
	count(case when http_referer is not NULL and utm_source is NULL then
		  website_sessions.website_session_id else NULL end) as organic_cvr,

	count(case when http_referer is NULL and utm_source is NULL
		  then orders.order_id else NULL end)/
	count(case when http_referer is NULL and utm_source is NULL then
		  website_sessions.website_session_id else NULL end) as direct_in_cvr

from website_sessions
	left join orders
		on orders.website_session_id=website_sessions.website_session_id
where website_sessions.created_at < '2015-03-20'
group by 1,2
order by 1,2;
