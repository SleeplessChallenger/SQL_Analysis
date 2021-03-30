use mavenfuzzyfactory;

-- see what is the first website pageview id
select
	min(website_pageview_id)
from website_pageviews
where pageview_url = '/lander-1';

/* => 23505 & the span of the test: 2012-06-19 to 2012-07-28 */

-- first pageview id and concurrent session 
DROP TEMPORARY TABLE IF EXISTS pageview_sessions;

create temporary table pageview_sessions
select
	website_pageviews.website_session_id,
	min(website_pageviews.website_pageview_id) as min_pageview_id
from website_sessions
	inner join website_pageviews
		on website_pageviews.website_session_id=website_sessions.website_session_id
	and website_pageviews.created_at > '2012-06-19' and website_pageviews.created_at < '2012-07-28'
	and website_pageviews.website_pageview_id >= 23505
	and website_sessions.utm_source = 'gsearch'
	and website_sessions.utm_campaign = 'nonbrand'
group by
	website_pageviews.website_session_id;


-- show landing pages. 2 options: /home or /lander-1 + add orders if exits else NULL
DROP TEMPORARY TABLE IF EXISTS sessions_landing_pages;

create temporary table sessions_landing_pages

select
	website_pageviews.pageview_url as landing_url,
	pageview_sessions.website_session_id,
	orders.order_id
from pageview_sessions
	left join website_pageviews
		on website_pageviews.website_pageview_id=pageview_sessions.min_pageview_id
	left join orders
		on orders.website_session_id=pageview_sessions.website_session_id
where website_pageviews.pageview_url in ('/home', '/lander-1');

-- find conversion on two pages
select
	landing_url,
	count(distinct website_session_id) as sessions,
	count(distinct order_id) as orders,
	count(distinct order_id)/count(distinct website_session_id) as order_session_ratio
from sessions_landing_pages
group by 1;



-- then last (aka max) session_id should be found with url = '/home'
select
	max(website_sessions.website_session_id) as latest_gsearch_home_view
from website_sessions
	left join website_pageviews
		on website_pageviews.website_session_id=website_sessions.website_session_id
where utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
	and pageview_url = '/home'
	and website_sessions.created_at < '2012-11-27';
/* 17145: after the received value all other id's went elsewhere than /home */


select
	count(distinct website_session_id) as sessions
from website_sessions
where created_at < '2012-11-27'
	and website_session_id > 17145
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand';

/* result will be amount of sessions after the test has been launched: 23040 */

from the conversion of two pages
=> abs(0.031 - 0.041) = 0.01 increase in conversion rate from ordinary /home to /lander

=> 0.01 * 23040 = 230
It means 230 increase of orders overall
