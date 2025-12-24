-- Afghan Cities Table Schema
-- Table to store Afghan cities with coordinates and active user counts

CREATE TABLE IF NOT EXISTS afghan_cities (
    id SERIAL PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL UNIQUE,
    province VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 6) NOT NULL,
    longitude DECIMAL(10, 6) NOT NULL,
    active_users INTEGER DEFAULT 0,
    population INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_afghan_cities_province ON afghan_cities(province);
CREATE INDEX IF NOT EXISTS idx_afghan_cities_coordinates ON afghan_cities(latitude, longitude);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_afghan_cities_updated_at
    BEFORE UPDATE ON afghan_cities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();