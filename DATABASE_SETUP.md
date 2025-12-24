# Database Setup Guide for World Map Data

This guide will help you set up a database table for world map data that works perfectly with Metabase.

## 📋 Files Created

- `schema.sql` - Table structure definition
- `insert_data.sql` - Data for 217 countries (0.98 MB)
- `generate-sql.js` - Script to regenerate SQL from GeoJSON
- `sample-queries.sql` - Example queries for Metabase

## 🚀 Quick Setup (PostgreSQL)

### Step 1: Create the Table

```bash
psql -U your_username -d your_database -f schema.sql
```

### Step 2: Insert the Data

```bash
psql -U your_username -d your_database -f insert_data.sql
```

### Step 3: Verify

```sql
SELECT COUNT(*) as total_countries FROM countries;
-- Should return: 217

SELECT name, coordinates_type, centroid_lat, centroid_lon 
FROM countries 
LIMIT 10;
```

## 🗄️ Table Structure

```sql
countries
├── id (SERIAL PRIMARY KEY)
├── name (VARCHAR 255) - Country name
├── iso_code_2 (VARCHAR 2) - ISO 3166-1 alpha-2 code
├── iso_code_3 (VARCHAR 3) - ISO 3166-1 alpha-3 code
├── geometry (JSONB) - GeoJSON geometry data
├── coordinates_type (VARCHAR 50) - 'Polygon' or 'MultiPolygon'
├── centroid_lat (DECIMAL) - Approximate latitude
├── centroid_lon (DECIMAL) - Approximate longitude
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

## 📊 Sample Data

```json
{
  "name": "United States",
  "coordinates_type": "MultiPolygon",
  "centroid_lat": 39.50,
  "centroid_lon": -98.35,
  "geometry": { "type": "MultiPolygon", "coordinates": [...] }
}
```

## 🔗 Using with Metabase

### Option 1: Reference Table (Simple)

Create a view with just country names:

```sql
CREATE VIEW country_list AS
SELECT id, name FROM countries;
```

Then in Metabase, join your data with this view using country names.

### Option 2: GeoJSON URL (Recommended)

Use the GitHub raw URL we created earlier:
```
https://raw.githubusercontent.com/dipeshkc045/worldmap/main/world-map.geojson
```

Configure in: Admin → Settings → Maps

## 📈 Example Metabase Queries

### 1. Sales by Country

```sql
SELECT 
    c.name as country,
    COUNT(o.id) as total_orders,
    SUM(o.amount) as total_sales
FROM orders o
JOIN countries c ON o.country_name = c.name
GROUP BY c.name
ORDER BY total_sales DESC;
```

### 2. Customer Distribution

```sql
SELECT 
    c.name as country,
    c.centroid_lat as latitude,
    c.centroid_lon as longitude,
    COUNT(cu.id) as customer_count
FROM customers cu
JOIN countries c ON cu.country = c.name
GROUP BY c.name, c.centroid_lat, c.centroid_lon;
```

### 3. Top 10 Countries

```sql
SELECT 
    c.name,
    COUNT(*) as count
FROM your_data_table t
JOIN countries c ON t.country_field = c.name
GROUP BY c.name
ORDER BY count DESC
LIMIT 10;
```

## 🔧 Database Support

### PostgreSQL (Recommended)
✅ Fully supported (with JSONB)
```bash
psql -U username -d database -f schema.sql
psql -U username -d database -f insert_data.sql
```

### MySQL
⚠️ Requires modification (JSON instead of JSONB)
```sql
-- Replace in schema.sql:
geometry JSONB NOT NULL
-- With:
geometry JSON NOT NULL
```

### SQLite
⚠️ Limited support (no JSONB, basic JSON only)

## 📦 Adding ISO Codes

The current data doesn't include ISO codes. To add them:

```sql
-- Example updates:
UPDATE countries SET iso_code_2 = 'US', iso_code_3 = 'USA' WHERE name = 'United States';
UPDATE countries SET iso_code_2 = 'CN', iso_code_3 = 'CHN' WHERE name = 'China';
-- ... and so on
```

Or download Natural Earth data which includes ISO codes.

## 🔄 Regenerate SQL

If you update the GeoJSON file:

```bash
node generate-sql.js
```

This will regenerate `insert_data.sql` with the latest data.

## 💡 Tips

1. **Use country names for joining** - Most reliable for data matching
2. **Add ISO codes** - Better for international standards
3. **Create indexes** - Already included in schema.sql for performance
4. **Backup** - Always backup before importing large datasets
5. **Test queries** - Try sample queries before using in production

## 🐛 Troubleshooting

### "Table already exists"
```sql
DROP TABLE IF EXISTS countries CASCADE;
-- Then run schema.sql again
```

### "Geometry too large"
- This is normal, some countries have complex borders
- PostgreSQL handles it fine with JSONB

### "Character encoding issues"
```bash
psql -U username -d database -f insert_data.sql --set ON_ERROR_STOP=on
```

## 📚 Next Steps

1. ✅ Import schema and data
2. ✅ Verify data with sample queries
3. ✅ Connect Metabase to your database
4. ✅ Create visualizations using the countries table
5. ✅ Join with your business data

---

**Note:** For production use with detailed geographic features, consider using PostGIS extension for true spatial queries.
