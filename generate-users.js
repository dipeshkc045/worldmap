const fs = require('fs');

// Read countries from the GeoJSON
const geojson = JSON.parse(fs.readFileSync('world-map.geojson', 'utf8'));
const countries = geojson.features.map(f => f.properties.name);

// Common first names and last names for realistic data
const firstNames = ['John', 'Jane', 'Michael', 'Sarah', 'David', 'Emily', 'James', 'Emma',
    'Robert', 'Olivia', 'William', 'Ava', 'Richard', 'Sophia', 'Joseph',
    'Isabella', 'Thomas', 'Mia', 'Charles', 'Charlotte'];

const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez',
    'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'];

const cities = ['Capital City', 'New Town', 'Old City', 'Central District', 'North Point',
    'South Bay', 'East Side', 'West End', 'Metro City', 'Downtown'];

// Function to generate random date in the past year
function randomDate() {
    const start = new Date(2023, 0, 1);
    const end = new Date(2024, 11, 31);
    const date = new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
    return date.toISOString().split('T')[0];
}

// Function to generate random timestamp
function randomTimestamp() {
    const date = new Date(2024, 0, 1 + Math.floor(Math.random() * 350));
    return date.toISOString();
}

// Weight distribution for countries (some countries get more users)
const popularCountries = [
    'United States', 'China', 'India', 'Brazil', 'United Kingdom',
    'Germany', 'France', 'Japan', 'Canada', 'Australia',
    'Mexico', 'South Korea', 'Italy', 'Spain', 'Netherlands'
];

function getRandomCountry() {
    // 70% chance of popular country, 30% chance of any country
    if (Math.random() < 0.7 && popularCountries.filter(c => countries.includes(c)).length > 0) {
        const popular = popularCountries.filter(c => countries.includes(c));
        return popular[Math.floor(Math.random() * popular.length)];
    }
    return countries[Math.floor(Math.random() * countries.length)];
}

function escapeSql(str) {
    return str.replace(/'/g, "''");
}

// Generate users
const totalUsers = 5000; // Generate 5000 users
const sqlStatements = [];

sqlStatements.push('-- Insert Sample Users Data');
sqlStatements.push(`-- Generated ${new Date().toISOString()}`);
sqlStatements.push(`-- Total Users: ${totalUsers}\n`);
sqlStatements.push('BEGIN;\n');

console.log(`Generating ${totalUsers} sample users...`);

for (let i = 1; i <= totalUsers; i++) {
    const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
    const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
    const username = `${firstName.toLowerCase()}.${lastName.toLowerCase()}${i}`;
    const email = `${username}@example.com`;
    const country = escapeSql(getRandomCountry());
    const city = cities[Math.floor(Math.random() * cities.length)];
    const registrationDate = randomDate();
    const lastLogin = randomTimestamp();
    const isActive = Math.random() > 0.1; // 90% active users

    const sql = `INSERT INTO users_meta (username, email, country, city, registration_date, last_login, is_active) 
VALUES ('${username}', '${email}', '${country}', '${city}', '${registrationDate}', '${lastLogin}', ${isActive});`;

    sqlStatements.push(sql);

    if (i % 500 === 0) {
        console.log(`Generated ${i}/${totalUsers} users...`);
    }
}

sqlStatements.push('\nCOMMIT;\n');

// Add verification queries
sqlStatements.push('-- Verification Queries\n');
sqlStatements.push('SELECT COUNT(*) as total_users FROM users;\n');
sqlStatements.push('SELECT country, COUNT(*) as user_count FROM users GROUP BY country ORDER BY user_count DESC LIMIT 20;\n');
sqlStatements.push('SELECT is_active, COUNT(*) as count FROM users GROUP BY is_active;\n');

// Write to file
const outputFile = 'insert_users.sql';
fs.writeFileSync(outputFile, sqlStatements.join('\n'));

console.log(`\n✅ SQL file generated: ${outputFile}`);
console.log(`📊 Total users: ${totalUsers}`);
console.log(`💾 File size: ${(fs.statSync(outputFile).size / 1024).toFixed(2)} KB`);

// Generate country distribution summary
const countryCount = {};
sqlStatements.forEach(line => {
    const match = line.match(/VALUES \('[^']+', '[^']+', '([^']+)',/);
    if (match) {
        const country = match[1].replace(/''/g, "'");
        countryCount[country] = (countryCount[country] || 0) + 1;
    }
});

console.log(`\n📍 Countries represented: ${Object.keys(countryCount).length}`);
console.log('\nTop 10 countries by user count:');
Object.entries(countryCount)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 10)
    .forEach(([country, count], i) => {
        console.log(`${i + 1}. ${country}: ${count} users`);
    });

console.log('\nTo import into your database:');
console.log('psql -U username -d database_name -f users_schema.sql');
console.log('psql -U username -d database_name -f insert_users.sql');
