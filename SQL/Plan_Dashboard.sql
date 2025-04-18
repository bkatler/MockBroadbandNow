-- Query to create dashboard for plans
-- There's only 284 rows so it isn't a big deal to have all the queries be in one data source
SELECT 
	us.session_id,
	us.session_start, 
	us.device_type,
	us.referral_source,
	us.bounce::TEXT AS bounce, -- Again DATA craft GPT messed up the DATA TYPES IN the CSV 
    us.converted::TEXT AS converted,
    us.zip_code::TEXT,
    pm.monthly_price,
	pm.plan_name
FROM 
	plan_metadata pm 
	JOIN page_events pe ON pe.plan_id = pm.plan_id 
	JOIN user_sessions us ON pe.session_id = us.session_id 
ORDER BY 
	us.converted DESC;