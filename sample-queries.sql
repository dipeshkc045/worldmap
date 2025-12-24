-- Sample Queries for Metabase with Countries Data

-- ==========================================
-- 1. BASIC QUERIES
-- ==========================================

-- Get all country_meta
SELECT id, name, coordinates_type, centroid_lat, centroid_lon 
FROM country_meta
ORDER BY name;

-- Count total country_meta
SELECT COUNT(*) as total_countries FROM country_meta;

-- Countries by geometry type
SELECT 
    coordinates_type,
    COUNT(*) as count
FROM country_meta
GROUP BY coordinates_type;


-- ==========================================
-- 2. GEOGRAPHIC QUERIES
-- ==========================================

-- Countries in Northern Hemisphere
SELECT name, centroid_lat, centroid_lon
FROM country_meta
WHERE centroid_lat > 0
ORDER BY centroid_lat DESC;

-- Countries in Western Hemisphere
SELECT name, centroid_lat, centroid_lon
FROM country_meta
WHERE centroid_lon < 0
ORDER BY centroid_lon;

-- Countries near equator (±10 degrees)
SELECT name, centroid_lat, centroid_lon
FROM country_meta
WHERE centroid_lat BETWEEN -10 AND 10
ORDER BY ABS(centroid_lat);


-- ==========================================
-- 3. JOIN WITH YOUR BUSINESS DATA
-- ==========================================

-- Example: Sales by Country
-- (Replace 'your_sales_table' with your actual table)
/*
SELECT 
    c.name as country,
    COUNT(s.id) as total_sales,
    SUM(s.amount) as revenue,
    c.centroid_lat,
    c.centroid_lon
FROM your_sales_table s
JOIN country_meta c ON s.country_name = c.name
GROUP BY c.name, c.centroid_lat, c.centroid_lon
ORDER BY revenue DESC;
*/

-- Example: Customer Distribution
/*
SELECT 
    c.name as country,
    COUNT(cu.id) as customer_count,
    c.centroid_lat as latitude,
    c.centroid_lon as longitude
FROM customers cu
JOIN country_meta c ON cu.country = c.name
GROUP BY c.name, c.centroid_lat, c.centroid_lon
ORDER BY customer_count DESC;
*/


-- ==========================================
-- 4. METABASE MAP VISUALIZATION QUERIES
-- ==========================================

-- For Pin Map (with coordinates)
SELECT 
    name as country,
    centroid_lat as latitude,
    centroid_lon as longitude,
    100 as value  -- Replace with your metric
FROM country_meta
WHERE centroid_lat IS NOT NULL 
  AND centroid_lon IS NOT NULL;

-- For Region Map (with country names)
SELECT 
    name as country,
    1000 as metric_value  -- Replace with your actual metric
FROM country_meta
ORDER BY name;


-- ==========================================
-- 5. DATA QUALITY CHECKS
-- ==========================================

-- Find country_meta without centroids
SELECT name 
FROM country_meta 
WHERE centroid_lat IS NULL OR centroid_lon IS NULL;

-- Check for duplicate country names
SELECT name, COUNT(*) as count
FROM country_meta
GROUP BY name
HAVING COUNT(*) > 1;

-- View geometry size (in characters)
SELECT 
    name,
    LENGTH(geometry::text) as geometry_size,
    coordinates_type
FROM country_meta
ORDER BY geometry_size DESC
LIMIT 10;


-- ==========================================
-- 6. SEARCH AND FILTER
-- ==========================================

-- Search by country name
SELECT * FROM country_meta 
WHERE name ILIKE '%united%';

-- Get specific country_meta
SELECT * FROM country_meta 
WHERE name IN ('United States', 'China', 'India', 'Brazil');

-- Countries with complex geometries (MultiPolygon)
SELECT name, coordinates_type
FROM country_meta
WHERE coordinates_type = 'MultiPolygon'
ORDER BY name;


-- ==========================================
-- 7. USEFUL VIEWS FOR METABASE
-- ==========================================

-- Create a simple country reference view
CREATE OR REPLACE VIEW country_reference AS
SELECT 
    id,
    name,
    centroid_lat as latitude,
    centroid_lon as longitude
FROM country_meta
WHERE centroid_lat IS NOT NULL;

-- Create a view for map visualization
CREATE OR REPLACE VIEW country_map_data AS
SELECT 
    name as region,
    centroid_lat as lat,
    centroid_lon as lon,
    coordinates_type as geometry_type
FROM country_meta;


-- ==========================================
-- 8. METABASE DASHBOARD QUERIES
-- ==========================================

-- Top 10 template (for your metrics)
/*
SELECT 
    c.name,
    SUM(your_metric) as total
FROM your_table t
JOIN country_meta c ON t.country = c.name
GROUP BY c.name
ORDER BY total DESC
LIMIT 10;
*/

-- Regional aggregation template
/*
SELECT 
    CASE 
        WHEN c.centroid_lat > 23.5 THEN 'Northern'
        WHEN c.centroid_lat < -23.5 THEN 'Southern'
        ELSE 'Tropical'
    END as region,
    COUNT(*) as count
FROM your_table t
JOIN country_meta c ON t.country = c.name
GROUP BY region;
*/


-- ==========================================
-- 9. EXPORT QUERIES
-- ==========================================

-- Export country list as CSV-ready format
SELECT 
    name as "Country Name",
    centroid_lat as "Latitude",
    centroid_lon as "Longitude",
    coordinates_type as "Geometry Type"
FROM country_meta
ORDER BY name;

-- Export for geocoding reference
SELECT 
    name,
    centroid_lat,
    centroid_lon
FROM country_meta
WHERE centroid_lat IS NOT NULL
ORDER BY name;


-- ==========================================
-- 10. MAINTENANCE QUERIES
-- ==========================================

-- Add updated timestamp trigger (optional)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_countries_updated_at 
    BEFORE UPDATE ON country_meta 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Vacuum and analyze for performance
VACUUM ANALYZE country_meta;
