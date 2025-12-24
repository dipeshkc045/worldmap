-- Metabase Queries for Users by Country Visualization

-- ==========================================
-- 1. SIMPLE USER COUNT BY COUNTRY
-- ==========================================

-- Total users_meta per country (for Region Map)
SELECT 
    country,
    COUNT(*) as user_count
FROM users_meta
GROUP BY country
ORDER BY user_count DESC;


-- ==========================================
-- 2. USERS BY COUNTRY WITH COORDINATES
-- ==========================================

-- User count with geographic coordinates (for Pin Map)
SELECT 
    c.name as country,
    c.centroid_lat as latitude,
    c.centroid_lon as longitude,
    COUNT(u.id) as user_count
FROM users_meta u
JOIN country_meta c ON u.country = c.name
GROUP BY c.name, c.centroid_lat, c.centroid_lon
ORDER BY user_count DESC;


-- ==========================================
-- 3. ACTIVE USERS BY COUNTRY
-- ==========================================

-- Active users_meta per country
SELECT 
    u.country,
    COUNT(*) as total_users,
    SUM(CASE WHEN u.is_active THEN 1 ELSE 0 END) as active_users,
    SUM(CASE WHEN NOT u.is_active THEN 1 ELSE 0 END) as inactive_users,
    ROUND(100.0 * SUM(CASE WHEN u.is_active THEN 1 ELSE 0 END) / COUNT(*), 2) as active_percentage
FROM users_meta u
GROUP BY u.country
ORDER BY total_users DESC;


-- ==========================================
-- 4. USER GROWTH OVER TIME BY COUNTRY
-- ==========================================

-- New registrations per month by country
SELECT 
    u.country,
    DATE_TRUNC('month', u.registration_date) as month,
    COUNT(*) as new_users
FROM users_meta u
GROUP BY u.country, DATE_TRUNC('month', u.registration_date)
ORDER BY month DESC, new_users DESC;

-- Top 10 country_meta growth
SELECT 
    u.country,
    DATE_TRUNC('month', u.registration_date) as month,
    COUNT(*) as new_users
FROM users_meta u
WHERE u.country IN (
    SELECT country 
    FROM users_meta 
    GROUP BY country 
    ORDER BY COUNT(*) DESC 
    LIMIT 10
)
GROUP BY u.country, DATE_TRUNC('month', u.registration_date)
ORDER BY month DESC, new_users DESC;


-- ==========================================
-- 5. TOP COUNTRIES ANALYSIS
-- ==========================================

-- Top 20 country_meta by user count
SELECT 
    c.name as country,
    COUNT(u.id) as user_count,
    c.centroid_lat as latitude,
    c.centroid_lon as longitude
FROM users_meta u
JOIN country_meta c ON u.country = c.name
GROUP BY c.name, c.centroid_lat, c.centroid_lon
ORDER BY user_count DESC
LIMIT 20;

-- Countries with at least 10 users_meta
SELECT 
    u.country,
    COUNT(*) as user_count
FROM users_meta u
GROUP BY u.country
HAVING COUNT(*) >= 10
ORDER BY user_count DESC;


-- ==========================================
-- 6. GEOGRAPHIC DISTRIBUTION
-- ==========================================

-- Users by hemisphere
SELECT 
    CASE 
        WHEN c.centroid_lat > 0 THEN 'Northern Hemisphere'
        ELSE 'Southern Hemisphere'
    END as hemisphere,
    COUNT(u.id) as user_count
FROM users_meta u
JOIN country_meta c ON u.country = c.name
WHERE c.centroid_lat IS NOT NULL
GROUP BY hemisphere;

-- Users by continent (approximation based on coordinates)
SELECT 
    CASE 
        WHEN c.centroid_lon BETWEEN -170 AND -30 THEN 'Americas'
        WHEN c.centroid_lon BETWEEN -30 AND 60 THEN 'Europe/Africa'
        WHEN c.centroid_lon BETWEEN 60 AND 180 THEN 'Asia/Oceania'
        ELSE 'Other'
    END as region,
    COUNT(u.id) as user_count
FROM users_meta u
JOIN country_meta c ON u.country = c.name
WHERE c.centroid_lon IS NOT NULL
GROUP BY region
ORDER BY user_count DESC;


-- ==========================================
-- 7. METABASE MAP VISUALIZATION QUERY
-- ==========================================

-- Perfect query for Metabase Region Map
-- Use this in Metabase with:
-- - Visualization: Map
-- - Map Type: Region Map
-- - Region Map: World Map (your custom GeoJSON)
-- - Region Key: country
-- - Metric: user_count

SELECT 
    u.country as country,
    COUNT(*) as user_count
FROM users_meta u
GROUP BY u.country;


-- ==========================================
-- 8. RECENT ACTIVITY BY COUNTRY
-- ==========================================

-- Users who logged in the past 30 days by country
SELECT 
    u.country,
    COUNT(*) as active_users_30d
FROM users_meta u
WHERE u.last_login > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.country
ORDER BY active_users_30d DESC;


-- ==========================================
-- 9. USER DENSITY ANALYSIS
-- ==========================================

-- Countries with highest user density (users_meta per country)
SELECT 
    u.country,
    COUNT(*) as user_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) as rank
FROM users_meta u
GROUP BY u.country
ORDER BY user_count DESC;


-- ==========================================
-- 10. COMPLETE DASHBOARD QUERY
-- ==========================================

-- All-in-one query for comprehensive dashboard
SELECT 
    c.name as country,
    c.centroid_lat as latitude,
    c.centroid_lon as longitude,
    COUNT(u.id) as total_users,
    SUM(CASE WHEN u.is_active THEN 1 ELSE 0 END) as active_users,
    COUNT(CASE WHEN u.last_login > CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as users_7d,
    COUNT(CASE WHEN u.last_login > CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as users_30d,
    MIN(u.registration_date) as first_user_date,
    MAX(u.registration_date) as latest_user_date
FROM country_meta c
LEFT JOIN users_meta u ON c.name = u.country
GROUP BY c.name, c.centroid_lat, c.centroid_lon
HAVING COUNT(u.id) > 0
ORDER BY total_users DESC;


-- ==========================================
-- 11. SUMMARY STATISTICS
-- ==========================================

-- Overall statistics
SELECT 
    COUNT(*) as total_users,
    COUNT(DISTINCT country) as countries_represented,
    SUM(CASE WHEN is_active THEN 1 ELSE 0 END) as active_users,
    MIN(registration_date) as first_registration,
    MAX(registration_date) as latest_registration
FROM users_meta;

-- Top 5 country_meta summary
SELECT 
    country,
    COUNT(*) as users_meta,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users_meta), 2) as percentage
FROM users_meta
GROUP BY country
ORDER BY users_meta DESC
LIMIT 5;
