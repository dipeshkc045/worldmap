# World Map GeoJSON for Metabase

This repository contains a GeoJSON file for world map visualization in Metabase.

## 📁 Files

- `world-map.geojson` - Complete GeoJSON data for all countries (2.6 MB, 246 countries)
- `extract-geojson.js` - Script to extract GeoJSON from npm package
- `package.json` - Project dependencies

## 🚀 Quick Start for Metabase

### Step 1: Upload to GitHub

```bash
git add world-map.geojson
git commit -m "Add world map GeoJSON"
git push
```

### Step 2: Get the Raw URL

1. Navigate to `world-map.geojson` on GitHub
2. Click the "Raw" button
3. Copy the URL (format: `https://raw.githubusercontent.com/USERNAME/REPO/main/world-map.geojson`)

### Step 3: Configure Metabase

1. Go to Metabase Admin → Settings → Maps
2. Click "Add a map"
3. Fill in:
   - **Name:** World Map
   - **URL:** [Your GitHub raw URL]
   - **Region Key:** `name`
   - **Region Name:** Country

### Step 4: Use in Visualizations

1. Create a question with country data
2. Choose "Map" visualization
3. Select "World Map" as the map type
4. Map your data column to "Country"

## 🌟 Better Alternatives

### 1. Natural Earth Data (RECOMMENDED for Production)

**Advantages:**
- Smaller file size (110m: 200 KB, 50m: 1 MB)
- Includes ISO country codes (ISO_A2, ISO_A3)
- Rich metadata (population, GDP, regions)
- Multiple detail levels

**Download:**
```bash
# Low resolution (200 KB) - Best for web
wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip
unzip ne_110m_admin_0_countries.zip

# Convert to GeoJSON (requires GDAL)
ogr2ogr -f GeoJSON countries.geojson ne_110m_admin_0_countries.shp
```

### 2. Metabase Built-in Maps (EASIEST)

Just enable in Metabase Settings → Maps. No file upload needed!

### 3. DataHub.io (Quick URL)

Direct GeoJSON URL:
```
https://datahub.io/core/geo-countries/r/countries.geojson
```

## 📊 Comparison

| Source | Size | ISO Codes | Best For |
|--------|------|-----------|----------|
| This file | 2.6 MB | ❌ | Quick start |
| Natural Earth 110m | 200 KB | ✅ | Production |
| Metabase built-in | N/A | ✅ | Simplest |
| DataHub.io | 1.5 MB | ✅ | Quick URL |

## 🔧 Regenerate the File

```bash
npm install geojson-world-map
node extract-geojson.js
```

## 📝 License

The GeoJSON data is from the `geojson-world-map` npm package.
# worldmap
