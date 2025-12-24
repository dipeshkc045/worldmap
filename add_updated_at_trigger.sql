-- Trigger to automatically update the `updated_at` timestamp on row modifications for `country_meta`

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_country_meta_updated_at
BEFORE UPDATE ON country_meta
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
