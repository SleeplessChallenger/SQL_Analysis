use mavenfuzzyfactory;

-- revenue per billing page session

select
	count(distinct website_session_id) as sessions,
	page_url,
	sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page
from
	(
	select
		website_pageviews.website_session_id,
		website_pageviews.pageview_url as page_url,
		orders.order_id,
		orders.price_usd
	from website_pageviews
		left join orders
			on orders.website_session_id=website_pageviews.website_session_id
	where website_pageviews.created_at > '2012-09-10'
		and website_pageviews.created_at < '2012-11-10'
		and website_pageviews.pageview_url in ('/billing', '/billing-2')
	) as first
group by page_url;


-- number of billing sessions per month
select
	count(distinct website_session_id) as session
from website_pageviews
where created_at > '2012-10-27' and created_at < '2012-11-27'
	and pageview_url in ('/billing', '/billing-2');

/* 1191 is the total amount of billed sessions */
