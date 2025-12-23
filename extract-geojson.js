const fs = require('fs');
const WorldData = require('geojson-world-map');

// Write the world map GeoJSON data to a file
const geojsonData = JSON.stringify(WorldData, null, 2);
fs.writeFileSync('world-map.geojson', geojsonData);

console.log('✅ world-map.geojson file created successfully!');
console.log('📊 Total features:', WorldData.features.length);
console.log('📝 File size:', (geojsonData.length / 1024 / 1024).toFixed(2), 'MB');
