-- Insert sample data for Afghan cities with active users
-- Coordinates and population data for major cities

INSERT INTO afghan_cities (city_name, province, latitude, longitude, active_users, population) VALUES
('Kabul', 'Kabul', 34.5553, 69.2077, 1250, 4273156),
('Kandahar', 'Kandahar', 31.6133, 65.7101, 890, 614254),
('Herat', 'Herat', 34.3529, 62.2040, 675, 539800),
('Mazar-i-Sharif', 'Balkh', 36.7090, 67.1109, 720, 469247),
('Jalalabad', 'Nangarhar', 34.4265, 70.4515, 580, 263312),
('Kunduz', 'Kunduz', 36.7286, 68.8681, 450, 304600),
('Ghazni', 'Ghazni', 33.5450, 68.4174, 380, 157868),
('Bamyan', 'Bamyan', 34.8214, 67.8272, 290, 61863),
('Farah', 'Farah', 32.3745, 62.1164, 220, 58640),
('Zaranj', 'Nimruz', 30.9630, 61.8604, 180, 49851),
('Taloqan', 'Takhar', 36.7360, 69.5345, 320, 64245),
('Puli Khumri', 'Baghlan', 35.9446, 68.7151, 260, 87345),
('Charikar', 'Parwan', 35.0136, 69.1714, 340, 53676),
('Lashkargah', 'Helmand', 31.5833, 64.3667, 410, 201546),
('Sheberghan', 'Jowzjan', 36.6676, 65.7383, 280, 175599),
('Mihtarlam', 'Laghman', 34.6714, 70.2094, 190, 18400),
('Khost', 'Khost', 33.3395, 69.9204, 350, 160214),
('Sar-e Pol', 'Sar-e Pol', 36.2167, 65.9333, 150, 52279),
('Aybak', 'Samangan', 36.2647, 68.0155, 200, 49777),
('Maymana', 'Faryab', 35.9214, 64.7836, 240, 75900),
('Andkhoy', 'Faryab', 36.9529, 65.1238, 170, 42630),
('Qalat', 'Zabul', 32.1058, 66.9083, 130, 12219),
('Gardez', 'Paktia', 33.5973, 69.2263, 300, 103601),
('Asadabad', 'Kunar', 34.8731, 71.1469, 220, 48424),
('Faizabad', 'Badakhshan', 37.1298, 70.5800, 180, 32683),
('Tirin Kot', 'Uruzgan', 32.6140, 65.8521, 160, 61528),
('Chaghcharan', 'Ghor', 34.5167, 65.2500, 140, 15000),
('Nili', 'Daykundi', 33.7218, 66.1292, 100, 20000),
('Lashkar Gah', 'Helmand', 31.5833, 64.3667, 410, 201546),
('Kushk', 'Herat', 33.2833, 61.1333, 120, 17000)
ON CONFLICT (city_name) DO UPDATE SET
    active_users = EXCLUDED.active_users,
    population = EXCLUDED.population,
    updated_at = CURRENT_TIMESTAMP;