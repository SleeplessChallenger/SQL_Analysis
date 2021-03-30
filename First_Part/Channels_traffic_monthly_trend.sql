use mavenfuzzyfactory;

-- firstly, the unique pairs of utm_campaign & utm_source & http_referer should be seen
select distinct
	utm_source,
	utm_campaign,
	http_referer
from website_sessions
where website_sessions.created_at < '2012-11-27';


-- next, calculations based on above result will be made
select
	min(date(website_sessions.created_at)) as month_date,
	count(distinct case when utm_source = 'gsearch' then website_session_id else NULL end) as Gsearch,
	count(distinct case when utm_source = 'bsearch' then website_session_id else NULL end) as Bsearch,
	-- count(distinct case when utm_source = 'socialbook' then website_session_id else NULL end) as SocialBook
	count(distinct case when utm_source is NULL and http_referer is NULL then website_session_id else NULL end) as Direct_type,
	count(distinct case when utm_source is NULL and http_referer is not NULL then website_session_id else NULL end) as Organic_search
	-- last one isn't tagged with our paid parameters
from website_sessions
where website_sessions.created_at < '2012-11-27'
group by
	month(website_sessions.created_at);
