const fs = require('fs');

// Read the GeoJSON file
const geojson = JSON.parse(fs.readFileSync('world-map.geojson', 'utf8'));

// Function to escape single quotes for SQL
function escapeSql(str) {
    return str ? str.replace(/'/g, "''") : '';
}

// Generate SQL INSERT statements
const sqlStatements = [];

sqlStatements.push('-- Insert World Map Data');
sqlStatements.push('-- Generated from world-map.geojson\n');
sqlStatements.push('BEGIN;');
sqlStatements.push('');

geojson.features.forEach((feature, index) => {
    const name = escapeSql(feature.properties.name);
    const geometryType = feature.geometry.type;
    const geometry = JSON.stringify(feature.geometry).replace(/'/g, "''");

    // Calculate approximate centroid (simple average of coordinates)
    let centroidLat = null;
    let centroidLon = null;

    try {
        const coords = feature.geometry.coordinates;
        if (geometryType === 'Polygon' && coords[0]) {
            const firstRing = coords[0];
            const sumLat = firstRing.reduce((sum, c) => sum + c[1], 0);
            const sumLon = firstRing.reduce((sum, c) => sum + c[0], 0);
            centroidLat = (sumLat / firstRing.length).toFixed(6);
            centroidLon = (sumLon / firstRing.length).toFixed(6);
        } else if (geometryType === 'MultiPolygon' && coords[0] && coords[0][0]) {
            const firstRing = coords[0][0];
            const sumLat = firstRing.reduce((sum, c) => sum + c[1], 0);
            const sumLon = firstRing.reduce((sum, c) => sum + c[0], 0);
            centroidLat = (sumLat / firstRing.length).toFixed(6);
            centroidLon = (sumLon / firstRing.length).toFixed(6);
        }
    } catch (e) {
        console.error(`Error calculating centroid for ${name}:`, e.message);
    }

    const sql = `INSERT INTO country_meta (name, geometry, coordinates_type, centroid_lat, centroid_lon) 
VALUES ('${name}', '${geometry}'::jsonb, '${geometryType}', ${centroidLat}, ${centroidLon});`;

    sqlStatements.push(sql);

    if ((index + 1) % 50 === 0) {
        console.log(`Processed ${index + 1}/${geojson.features.length} countries...`);
    }
});

sqlStatements.push('');
sqlStatements.push('COMMIT;');
sqlStatements.push('');
sqlStatements.push('-- Verify data');
sqlStatements.push('SELECT COUNT(*) as total_countries FROM countries;');
sqlStatements.push('SELECT name, coordinates_type, centroid_lat, centroid_lon FROM countries LIMIT 10;');

// Write to file
const outputFile = 'insert_data.sql';
fs.writeFileSync(outputFile, sqlStatements.join('\n'));

console.log(`\n✅ SQL file generated: ${outputFile}`);
console.log(`📊 Total countries: ${geojson.features.length}`);
console.log(`💾 File size: ${(fs.statSync(outputFile).size / 1024 / 1024).toFixed(2)} MB`);
console.log('\nTo import into your database:');
console.log('psql -U username -d database_name -f insert_data.sql');
