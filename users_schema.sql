-- Create Users Table with Country Data
-- For visualizing user distribution by country in Metabase

CREATE TABLE IF NOT EXISTS users_meta (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    registration_date DATE DEFAULT CURRENT_DATE,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for country-based queries
CREATE INDEX idx_users_meta_country ON users_meta(country);
CREATE INDEX idx_users_meta_registration_date ON users_meta(registration_date);
CREATE INDEX idx_users_meta_is_active ON users_meta(is_active);

-- Add foreign key constraint to country_meta table (optional but recommended)
-- Note: This assumes you've already created the country_meta table
-- ALTER TABLE users_meta 
-- ADD CONSTRAINT fk_users_meta_country 
-- FOREIGN KEY (country) REFERENCES country_meta(name);

COMMENT ON TABLE users_meta IS 'User accounts with country information for geographic analysis';
COMMENT ON COLUMN users_meta.country IS 'Country name (must match country_meta.name for Metabase mapping)';
