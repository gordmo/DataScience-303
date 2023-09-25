/*
Lab 3 - Uver ERD SQL script
Name: Gordon Moore
*/

-- windows psql needs the following line uncommented
-- \encoding utf-8
-- add other environment changes here (pager, etc.)
-- add the SQL for each step that needs SQL below that step here.
-- use the 8 steps defined in class (step 8 was covered only in class!)

-- Drop tables if they exist to start with a clean slate
DROP TABLE IF EXISTS ride_review CASCADE;
DROP TABLE IF EXISTS favorite_destinations CASCADE;
DROP TABLE IF EXISTS car_features CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS ride CASCADE;
DROP TABLE IF EXISTS car CASCADE;
DROP TABLE IF EXISTS driver CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

-- Step 1: Regular entities
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(11),
    address VARCHAR(50),
    coordinates POINT
);

CREATE TABLE driver (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(11),
    registration_number VARCHAR(10),
    rating DECIMAL(2,1)
);

CREATE TABLE car (
    id SERIAL PRIMARY KEY,
    licenseplate_number VARCHAR(20) NOT NULL,
    licenseplate_state VARCHAR(2) NOT NULL,
    seats INT NOT NULL,
);

CREATE TABLE ride (
    ride_id SERIAL PRIMARY KEY,
    ride_type VARCHAR(10),
    fare DECIMAL(5,2),
    number_of_rider INT,
    destination_address VARCHAR(50),
    destination_coordinates POINT,
    payment_confirmation VARCHAR(10),
    payment_method VARCHAR(10),
    pickup_time TIMESTAMP,
);

-- Step 2: Weak entities
-- Ride_review is categorized as a weak entity because it cannot exist without a ride, its keys depend on rides keys as well
CREATE TABLE ride_review (
    ride_id INT REFERENCES ride(ride_id),
    review_id SERIAL PRIMARY KEY,
    review_text TEXT,
    review_rating DECIMAL(2,1)
);

-- Step 3: 1:1 Relationships
ALTER TABLE car ADD COLUMN driver_id INTEGER REFERENCES driver(id);

ALTER TABLE ride
    ADD COLUMN customer_id INT REFERENCES customer(id),
    ADD COLUMN driver_id INT REFERENCES driver(id);

-- Step 4: 1:N Relationships


-- Step 5: N:M Relationships
CREATE TABLE features (
    id SERIAL PRIMARY KEY,
    feature_name VARCHAR(50) NOT NULL
);

CREATE TABLE car_features (
    car_id INTEGER REFERENCES car(id),
    feature_id INTEGER REFERENCES features(id),
    PRIMARY KEY (car_id, feature_id)
);


-- Step 6: Multi-valued attributes
CREATE TABLE favorite_destinations (
    customer_id INT REFERENCES customer(id),
    destination VARCHAR(50),
    PRIMARY KEY (customer_id, destination)
);

-- Step 7: N-ary relationships

-- Step 8: Derived attributes (Distance is calculated based on coordinates and is not stored)
CREATE OR REPLACE VIEW ride_plus AS
    SELECT r.*, 
           earth_distance(ll_to_earth(
               r.destination_coordinates[0],
               r.destination_coordinates[1]
           ), ll_to_earth(
               c.coordinates[0],
               c.coordinates[1]
           )) AS distance
    FROM ride r
    JOIN customer c ON r.customer_id = c.id;

-- Example data insertion
-- Insert a car
INSERT INTO car (licenseplate_number, licenseplate_state, seats, driver_id) VALUES ('XYZ 123', 'CA', 4, NULL);

-- Insert features
INSERT INTO features (feature_name) VALUES ('wifi'), ('heated seats'), ('ac');

-- Link the car to its features
INSERT INTO car_features (car_id, feature_id) VALUES (1, 1), (1, 2), (1, 3);
