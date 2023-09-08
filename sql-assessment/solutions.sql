/* NOTE: All SQL I have written here is in the MS SQL dialect. I am also proficient in SQLite, MySQL, PostgreSQL, and all other dialects*/

/* Question 1:*/

SELECT date, sum(impressions) as impressions_by_date FROM marketing_performance group by date order by date;

/* Question 2:*/

SELECT TOP 3 state, sum(revenue) as revenue_by_state from website_revenue group by state ORDER by revenue_by_state desc;

/* The state that had the third-highest revenue was Ohio, which generated $37577. */
/* The equivalent query in SQLite for the above question is: SELECT state, sum(revenue) as revenue_by_state from website_revenue group by state ORDER by revenue_by_state desc limit 3;*/

/* Question 3:*/

SELECT b.name, sum(a.cost) as total_cost, sum(a.impressions) as total_impressions, sum(a.clicks) as total_clicks, sum(c.revenue) as total_revenue from marketing_performance a join campaign_info b on a.campaign_id = b.id JOIN website_revenue c on a.campaign_id = c.campaign_id group by b.name;

/* Question 4:*/

SELECT c.state, sum(a.conversions) as campaign5_conversions_by_state
from marketing_performance a join campaign_info b on a.campaign_id = b.id JOIN website_revenue c on a.campaign_id = c.campaign_id
where b.name = 'Campaign5' group by c.state order by campaign5_conversions_by_state desc;

/* As we see below, Georgia (GA) had the most conversions of any state for Campaign5 */

/* Question 5:*/

SELECT b.name, sum(c.revenue)/sum(a.cost) as total_revenue_over_total_cost_of_campaign
from marketing_performance a join campaign_info b on a.campaign_id = b.id JOIN website_revenue c on a.campaign_id = c.campaign_id
group by b.name order by total_revenue_over_total_cost_of_campaign desc;

/* Since Campaign4 generated the highest ratio of revenue relative to total cost, I believe this is the most efficient campaign */

/* Question 6:*/

with ungrouped as (SELECT
case datepart(dw,cast(a.date as datetime))
    when 1 then 'Sunday'
    when 2 then 'Monday'
    when 3 then 'Tuesday'
    when 4 then 'Wednesday'
    when 5 then 'Thursday'
    when 6 then 'Friday'
    else 'Saturday' end as day_of_week,
cast(a.impressions as real) as impressions, a.clicks, a.conversions, a.cost
from marketing_performance a)
SELECT day_of_week,
/*avg(impressions) as mean_impressions, avg(clicks) as mean_clicks,*/
ROUND(avg(conversions)/avg(impressions),2) as conversion_rate,
ROUND(avg(clicks)/avg(impressions),2) as click_through_rate, ROUND(avg(conversions)/avg(cost),2) as conversions_per_dollar_spent
from ungrouped group by day_of_week order by conversions_per_dollar_spent desc;

/* Ads on Wednesday have the highest conversion rate, click through rate, and conversions per dolar spent.*/
