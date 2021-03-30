use mavenfuzzyfactory;

-- full conversion funnel from each of the two pages to orders
DROP TEMPORARY TABLE IF EXISTS conversion_temp;

create temporary table conversion_temp

select
	Move.website_session_id,
	max(home) as home_page,
	max(custom_home) as custom_home_page,
	max(products_page) as products_page,
	max(mr_fuzzy) as fuzzy_page,
	max(cart) as cart_page,
	max(shipping) as shipping_page,
	max(billing) as billing_page,
	max(thanks) as thanks_page
from
	(
	select
		website_sessions.website_session_id,
		website_pageviews.pageview_url,
		(case when pageview_url = '/home' then 1 else 0 end) as home,
		(case when pageview_url = '/lander-1' then 1 else 0 end) as custom_home,
		(case when pageview_url = '/products' then 1 else 0 end) as products_page,
		(case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end) as mr_fuzzy,
		(case when pageview_url = '/cart' then 1 else 0 end) as cart,
		(case when pageview_url = '/shipping' then 1 else 0 end) as shipping,
		(case when pageview_url = '/billing' then 1 else 0 end) as billing,
		(case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end) as thanks
	from website_sessions
		inner join website_pageviews
			on website_pageviews.website_session_id=website_sessions.website_session_id
	where website_sessions.created_at > '2012-06-19' and website_sessions.created_at < '2012-07-28'
		and utm_source = 'gsearch'
		and utm_campaign = 'nonbrand'
	order by
		website_sessions.website_session_id,
		website_pageviews.created_at
	) as Move
group by 1;


-- 1: exact conversion; 2: exact conversion rate

select
	count(distinct website_session_id) as sessions,
	case
		when home_page = 1 then 'home_page_seen'
		when custom_home_page = 1 then 'custom_home_page_seen'
		else 'without home page'
	end as Start_Page,
	count(distinct case when products_page = 1 then website_session_id else NULL end) as to_products_page,
	count(distinct case when fuzzy_page = 1 then website_session_id else NULL end) as to_fuzzy_page,
	count(distinct case when cart_page = 1 then website_session_id else NULL end) as to_cart_page,
	count(distinct case when shipping_page = 1 then website_session_id else NULL end) as to_shipping_page,
	count(distinct case when billing_page = 1 then website_session_id else NULL end) as to_billing_page,
	count(distinct case when thanks_page = 1 then website_session_id else NULL end) as to_thank_you_page

from conversion_temp
group by 2;



select
	count(distinct website_session_id) as sessions,
	case
		when home_page = 1 then 'home_page_seen'
		when custom_home_page = 1 then 'custom_home_page_seen'
		else 'without home page'
	end as Start_Page,

	count(distinct case when products_page = 1 then website_session_id else NULL end)/
	count(distinct website_session_id) as start_page_clickthrough,

	count(distinct case when fuzzy_page = 1 then website_session_id else NULL end)/
	count(distinct case when products_page = 1 then website_session_id else NULL end) as products_clickthrough_rate,

	count(distinct case when cart_page = 1 then website_session_id else NULL end)/
	count(distinct case when fuzzy_page = 1 then website_session_id else NULL end) as fuzzy_clickthrough_rate,

	count(distinct case when shipping_page = 1 then website_session_id else NULL end)/
	count(distinct case when cart_page = 1 then website_session_id else NULL end) as cart_clickthrough_rate,

	count(distinct case when billing_page = 1 then website_session_id else NULL end)/
	count(distinct case when shipping_page = 1 then website_session_id else NULL end) as shipping_clickthrough_rate,

	count(distinct case when thanks_page = 1 then website_session_id else NULL end)/
	count(distinct case when billing_page = 1 then website_session_id else NULL end) as billing_clickthrough_rate

from conversion_temp
group by 2;
