-- Create Countries Table for Metabase
-- This schema supports storing world map data for use with Metabase visualizations

CREATE TABLE IF NOT EXISTS country_meta (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    iso_code_2 VARCHAR(2),
    iso_code_3 VARCHAR(3),
    geometry JSONB NOT NULL,
    coordinates_type VARCHAR(50),
    centroid_lat DECIMAL(10, 8),
    centroid_lon DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_country_meta_name ON country_meta(name);
CREATE INDEX idx_country_meta_iso2 ON country_meta(iso_code_2);
CREATE INDEX idx_country_meta_iso3 ON country_meta(iso_code_3);
CREATE INDEX idx_country_meta_geometry ON country_meta USING GIN(geometry);

-- Add comments for documentation
COMMENT ON TABLE country_meta IS 'World countries with geographic data for Metabase visualizations';
COMMENT ON COLUMN country_meta.name IS 'Country name (used for Metabase region mapping)';
COMMENT ON COLUMN country_meta.geometry IS 'GeoJSON geometry data (Polygon or MultiPolygon)';
COMMENT ON COLUMN country_meta.coordinates_type IS 'Type: Polygon or MultiPolygon';
