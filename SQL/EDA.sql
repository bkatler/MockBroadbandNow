/*
 * Business Question: Which Device Type has the highest bounce rate?
 * Expected Output: Device_type | bounce_rate
*/
SELECT 
    device_type AS platform,
    SUM(CASE WHEN bounce::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS bounce_rate -- I have TO explicitly CAST it AS Boolean because DATA Craft messed up the values
FROM 
    user_sessions
GROUP BY 
    device_type;

-- Result: Mobile bounce rate is significantly higher than desktop and tablet
-- Future Question(s): How does volume compare across platforms? How does UI/UX compare across platforms?
   
-- Let's actually just test volume real quick
SELECT 
    device_type AS platform,
    COUNT(session_id) AS number_of_sessions,
	SUM(CASE WHEN bounce::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS bounce_rate
FROM 
    user_sessions
GROUP BY 
    device_type;
    
-- Result: Volume is around even on mobile and desktop, dramatically lower on Tablet.
-- Business Recommendation: Invesigate mobile UI differences (particularly with Tablet) that could lead to bounce rate issues
   
   
   
   /*
    * Business Question: Which referral source is performing the best?
    * EO 1: Referral Source? | Session | Pageviews
    * EO 0: Referral Source | Total Unique Pageviews
    */
WITH session_pageviews AS (
    SELECT
        us.session_id,
        us.referral_source,
        COUNT(DISTINCT pe.page_url) AS pageview_count
    FROM 
    	user_sessions us
    	JOIN page_events pe ON us.session_id = pe.session_id
    GROUP BY 
    	us.session_id, us.referral_source
)
SELECT
    referral_source,
    SUM(pageview_count) AS total_unique_pages_viewed
FROM 
	session_pageviews
GROUP BY 
	referral_source;

-- Result: Organic leads, paid ads in the middle and direct by far lowest
-- Future Questions: Are high unique page views leading to conversions?
	
-- Let's test by essentially copying the field from last query and changing it to converted
	
WITH session_pageviews AS (
    SELECT
        us.session_id,
        us.referral_source,
        us.converted,
        COUNT(DISTINCT pe.page_url) AS pageview_count
    FROM 
    	user_sessions us
    	JOIN page_events pe ON us.session_id = pe.session_id
    GROUP BY 
    	us.session_id, 
    	us.referral_source,
    	us.converted
)
SELECT
    referral_source,
    SUM(pageview_count) AS total_unique_pages_viewed,
    SUM(CASE WHEN converted::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CVR
FROM 
	session_pageviews
GROUP BY 
	referral_source;

-- Result: Despite having the highest pageviews, Organic has the second lowest CVR. Direct is by far the highest. Paid search beats out paid social
-- Business Recommendation: Invest more in search ads than social ads, more pageviews and far better conversion
   


/*
 * Business Question: Which plans perform the best
 * Expected Output: Plan | Sessions | Conversions
*/
SELECT 
	pm.plan_name,
	COUNT(us.session_id) AS total_sessions,
	SUM(CASE WHEN converted::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CVR
FROM
	user_sessions us 
	JOIN page_events pe ON us.session_id  = pe.session_id 
	JOIN plan_metadata pm ON pe.plan_id = pm.plan_id 
GROUP BY 
	pm.plan_name;

-- Result: All plans have fairly similar CVR and volume, but ZoomFiber 1000 is way lower in CVR
-- Business Recommendation: Check plan description for misleading or poorly described wording



/*
 * Business Question: How does load time affect product performance?
 * Expected Output: Load_Time (need to create categories?) | Bounce | CVR
 */

-- First need to understand how the data works for avg_load_time
SELECT 
	*
FROM 
	site_performance sp 
LIMIT 10;

-- Forgot there's also avg_tti - I'll do a query for both and unless there's drastic differences just use load_time
SELECT
	CASE
        WHEN sp.avg_load_time < 2 THEN '<2'
        WHEN sp.avg_load_time BETWEEN 2 AND 2.5 THEN '2-2.5'
        WHEN sp.avg_load_time BETWEEN 2.5 AND 3 THEN '2.5-3'
        WHEN sp.avg_load_time BETWEEN 3 AND 3.5 THEN '3-3.5'
        WHEN sp.avg_load_time BETWEEN 3.5 AND 4 THEN '3.5-4'
        WHEN sp.avg_load_time > 4 THEN '4+'
        ELSE 'NULL'
    END AS categorized_load_time,
    SUM(CASE WHEN us.converted::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CVR,
    SUM(CASE WHEN us.bounce::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS bounce_rate
FROM 
	site_performance sp
	JOIN page_events pe ON sp.page_url = pe.page_url
	JOIN user_sessions us ON pe.session_id = us.session_id
GROUP BY 
	categorized_load_time
ORDER BY 
	categorized_load_time ASC;
	
-- Result: CVR/Bounce Rate is fairly consistent across load times, nothing stands out
-- Future Question: Will this be different for tti?

-- Basically the same query, just subbing avg_tti for avg_load_time
SELECT
	CASE
        WHEN sp.avg_tti < 3 THEN '<3'
        WHEN sp.avg_tti BETWEEN 3 AND 3.5 THEN '3-3.5'
        WHEN sp.avg_tti BETWEEN 3.5 AND 4 THEN '3.5-4'
        WHEN sp.avg_tti BETWEEN 4 AND 4.5 THEN '4-4.5'
        WHEN sp.avg_tti BETWEEN 4.5 AND 5 THEN '4.5-5'
        WHEN sp.avg_tti > 5 THEN '5+'
        ELSE 'NULL'
    END AS categorized_tti,
    SUM(CASE WHEN us.converted::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CVR,
    SUM(CASE WHEN us.bounce::boolean = TRUE THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS bounce_rate
FROM 
	site_performance sp
	JOIN page_events pe ON sp.page_url = pe.page_url
	JOIN user_sessions us ON pe.session_id = us.session_id
GROUP BY 
	categorized_tti
ORDER BY 
	categorized_tti ASC;

-- Result: Same as above. I'm shocked load time doesn't seem to have any affect
-- Business Recommendation: It is likely worth adding extra features to a page at the cost of load time



/*
 * Business Question: Which page receives the best customer feedback? 
 * Expected Outcome: page | avg rating (no need to join site_performance)
 * 
*/
SELECT 
	page_url,
	AVG(rating) AS avg_rating
FROM
	user_feedback uf 
GROUP BY 
	page_url;

-- Result: No single page stands out as high/low performing
-- Future Question: What is standing out in very low reviews?
SELECT 
	rating,
	"comments"
FROM 
	user_feedback uf 
WHERE 
	rating <= 3; -- Ratings can ONLY be whole numbers
	
-- I want something more actionable - going to organize by keywords (although the mock data actually did something helpful, I want to do this more realistically)
SELECT 	
	CASE
		WHEN "comments" ILIKE '%load%' OR "comments" ILIKE '%slow%' THEN 'Loading Time'
		WHEN "comments" ILIKE '%plan info%' THEN 'Plan Info Unclear'
		WHEN "comments" ILIKE '%trust%' THEN 'Did not trust Website'
		WHEN "comments" ILIKE '%form%' THEN 'Form Errors'
		WHEN "comments" ILIKE '%mobile%' THEN 'Mobile UI'
		WHEN "comments" ILIKE '%layout%' OR "comments" ILIKE '%organized%' OR "comments" ILIKE '%cluttered%' THEN 'Confusing Layout'
		WHEN "comments" ILIKE '%ZIP%' THEN 'Could not find Zip Code'
		ELSE 'Other'
	END AS categorized_feedback,
	COUNT("comments") AS number_of_reports
FROM 
	user_feedback uf 
WHERE 
	rating <= 3
GROUP BY
	categorized_feedback
ORDER BY 
	number_of_reports DESC;

-- Result: Majority of errors were UI related. Although many Loading Time errors, previous queries proved it had no effect. Should check out zip code though.
-- Business Recommendation: Need to clean up UI, as seen by user complaints. Load time does not need to be addressed for now but should be monitored. Need to isolate zip code issue before recommendation

-- Checking if there is just one zip experiencing issues (likely just missing from form) or if it is an issue with the form itself
SELECT 
	us.zip_code,
	COUNT(us.session_id) AS number_of_reports --obviously overkill but good practice
FROM 
	user_sessions us 
	JOIN user_feedback uf ON us.session_id = uf.session_id 
WHERE 
	"comments" ILIKE '%ZIP%'
GROUP BY 
	us.zip_code; -- Why IS Zip an integer???
	
-- Result: I was hoping it would just be one zip because then you could quickly update the form, but this is clearly an issue with the form itself
-- Business Recommendation: Need to QA form to see what causes users to not be able to see zip code
