-- Total Ridership by Year 

SELECT YEAR,
	USER_TYPE,
	COUNT(*) AS USER_COUNT
FROM
	(SELECT '2016' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2019) AS YEAR_COMBINED
GROUP BY YEAR,
	USER_TYPE
ORDER BY YEAR,
	USER_COUNT DESC;
	
-- User type by gender combined 0 - unkown, 1 - male, 2 - female

SELECT YEAR,
	CASE
					WHEN USER_GENDER = 0 THEN 'Unkown'
					WHEN USER_GENDER = 1 THEN 'Male'
					WHEN USER_GENDER = 2 THEN 'Female'
					ELSE 'Other'
	END AS USER_GENDER,
	COUNT(*) AS USER_COUNT
FROM
	(SELECT '2016' AS YEAR,
			USER_GENDER
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_GENDER
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_GENDER
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_GENDER
		FROM BLUEBIKES_2019) AS GENDER_COMBINED
GROUP BY YEAR,
	USER_GENDER
ORDER BY YEAR,
	USER_GENDER;

-- User type by gender

SELECT YEAR,
	CASE
					WHEN USER_GENDER = 0 THEN 'Unkown'
					WHEN USER_GENDER = 1 THEN 'Male'
					WHEN USER_GENDER = 2 THEN 'Female'
					ELSE 'Other'
	END AS USER_GENDER,
	USER_TYPE,
	COUNT(*) AS USER_COUNT
FROM
	(SELECT '2016' AS YEAR,
			USER_GENDER,
			USER_TYPE
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_GENDER,
			USER_TYPE
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_GENDER,
			USER_TYPE
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_GENDER,
			USER_TYPE
		FROM BLUEBIKES_2019) AS GENDER_COMBINED
GROUP BY YEAR,
	USER_GENDER,
	USER_TYPE
ORDER BY YEAR,
	USER_GENDER,
	USER_COUNT DESC;
	
-- Percentage of user types by year

SELECT YEAR,
	USER_TYPE,
	COUNT(*) AS USER_COUNT,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR), 2) AS PERCENTAGE
FROM
	(SELECT '2016' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_TYPE
		FROM BLUEBIKES_2019) AS USER_TYPE_PERCENTAGE
GROUP BY YEAR,
	USER_TYPE
ORDER BY YEAR,
	USER_COUNT DESC,
	USER_TYPE;
	
-- Most used start station by subscriber by total number of rides

SELECT
    S.ID AS START_STATION_ID,
    S.NAME AS START_STATION_NAME,
    S.DISTRICT AS START_STATION_DISTRICT,
    S.LATITUDE AS START_STATION_LATITUDE,
    S.LONGITUDE AS START_STATION_LONGITUDE,
    COUNT(*) AS TOTAL_RIDES_BY_SUBSCRIBERS
FROM
    (SELECT START_STATION_ID
     FROM BLUEBIKES_2016
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2017
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2018
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2019
     WHERE USER_TYPE ILIKE 'Subscriber') AS MOST_SUBSCRIBER_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_SUBSCRIBER_RIDES_START.START_STATION_ID = S.ID
GROUP BY
    S.ID,
    S.NAME,
    S.DISTRICT,
    S.LATITUDE,
    S.LONGITUDE
ORDER BY
    TOTAL_RIDES_BY_SUBSCRIBERS DESC
LIMIT 10;

-- Most used start station by customer by total number of rides

SELECT
    S.ID AS START_STATION_ID,
    S.NAME AS START_STATION_NAME,
    S.DISTRICT AS START_STATION_DISTRICT,
    S.LATITUDE AS START_STATION_LATITUDE,
    S.LONGITUDE AS START_STATION_LONGITUDE,
    COUNT(*) AS TOTAL_RIDES_BY_CUSTOMERS
FROM
    (SELECT START_STATION_ID
     FROM BLUEBIKES_2016
     WHERE USER_TYPE ILIKE 'Customer'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2017
     WHERE USER_TYPE ILIKE 'Customer'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2018
     WHERE USER_TYPE ILIKE 'Customer'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2019
     WHERE USER_TYPE ILIKE 'Customer') AS MOST_CUSTOMER_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_CUSTOMER_RIDES_START.START_STATION_ID = S.ID
GROUP BY
    S.ID,
    S.NAME,
    S.DISTRICT,
    S.LATITUDE,
    S.LONGITUDE
ORDER BY
    TOTAL_RIDES_BY_CUSTOMERS DESC
LIMIT 10;

-- Most used end station by subscriber by total number of rides

SELECT S.ID AS END_STATION_ID,
	S.NAME AS END_STATION_NAME,
	S.DISTRICT AS END_STATION_DISTRICT,
	COUNT(*) AS TOTAL_RIDES_BY_SUBSCRIBERS
FROM
	(SELECT END_STATION_ID
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Subscriber' ) AS MOST_SUBSCRIBER_RIDES_END
JOIN BLUEBIKES_STATIONS AS S ON MOST_SUBSCRIBER_RIDES_END.END_STATION_ID = S.ID
GROUP BY S.ID,
	S.NAME,
	S.DISTRICT
ORDER BY TOTAL_RIDES_BY_SUBSCRIBERS DESC;

-- Most used end station by customer by total number of rides

SELECT S.ID AS END_STATION_NUMBER,
	S.NAME AS END_STATION_NAME,
	S.DISTRICT AS END_STATION_DISTRICT,
	COUNT(*) AS TOTAL_RIDES_BY_CUSTOMERS
FROM
	(SELECT END_STATION_ID
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Customer' ) AS MOST_CUSTOMER_RIDES_END
JOIN BLUEBIKES_STATIONS AS S ON MOST_CUSTOMER_RIDES_END.END_STATION_ID = S.ID
GROUP BY S.ID,
	S.NAME,
	S.DISTRICT
ORDER BY TOTAL_RIDES_BY_CUSTOMERS DESC;

-- When do the subscribers ride? 

SELECT YEAR,
	USER_TYPE,
	CASE
		WHEN EXTRACT(HOUR FROM START_TIME) >= 5 AND EXTRACT(HOUR FROM START_TIME) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM START_TIME) >= 12 AND EXTRACT(HOUR FROM START_TIME) < 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM START_TIME) >= 17 AND EXTRACT(HOUR FROM START_TIME) < 21 THEN 'Evening'
		ELSE 'Night'
	END AS RIDE_HOURS,
	COUNT(*) AS RIDE_COUNT
FROM
	(SELECT '2016' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2019) AS ALL_RIDES
WHERE USER_TYPE ilike 'Subscriber'
GROUP BY YEAR,
	USER_TYPE,
	RIDE_HOURS
ORDER BY YEAR,
	USER_TYPE,
	RIDE_HOURS;
	
-- When do the customers ride? 

SELECT YEAR,
	USER_TYPE,
	CASE
		WHEN EXTRACT(HOUR FROM START_TIME) >= 5 AND EXTRACT(HOUR FROM START_TIME) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM START_TIME) >= 12 AND EXTRACT(HOUR FROM START_TIME) < 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM START_TIME) >= 17 AND EXTRACT(HOUR FROM START_TIME) < 21 THEN 'Evening'
		ELSE 'Night'
	END AS RIDE_HOURS,
	COUNT(*) AS RIDE_COUNT
FROM
	(SELECT '2016' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' AS YEAR,
			USER_TYPE,
			START_TIME
		FROM BLUEBIKES_2019) AS ALL_RIDES
WHERE USER_TYPE ilike 'Customer'
GROUP BY YEAR,
	USER_TYPE,
	RIDE_HOURS
ORDER BY YEAR,
	USER_TYPE,
	RIDE_HOURS;

-- When do subscribers and customers ride? Morning, Afternoon, Evening and Night. 

SELECT 
  YEAR,
  USER_TYPE,
  CASE
    WHEN EXTRACT(HOUR FROM START_TIME) >= 5 AND EXTRACT(HOUR FROM START_TIME) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM START_TIME) >= 12 AND EXTRACT(HOUR FROM START_TIME) < 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM START_TIME) >= 17 AND EXTRACT(HOUR FROM START_TIME) < 21 THEN 'Evening'
    ELSE 'Night'
  END AS RIDE_HOURS,
  COUNT(*) AS RIDE_COUNT
FROM (
  SELECT '2016' AS YEAR, USER_TYPE, START_TIME FROM BLUEBIKES_2016
  UNION ALL SELECT '2017' AS YEAR, USER_TYPE, START_TIME FROM BLUEBIKES_2017
  UNION ALL SELECT '2018' AS YEAR, USER_TYPE, START_TIME FROM BLUEBIKES_2018
  UNION ALL SELECT '2019' AS YEAR, USER_TYPE, START_TIME FROM BLUEBIKES_2019
) AS ALL_RIDES
WHERE USER_TYPE ILIKE 'Subscriber' OR USER_TYPE ILIKE 'Customer'
GROUP BY YEAR, USER_TYPE, RIDE_HOURS
ORDER BY YEAR, USER_TYPE, RIDE_HOURS;

-- On what days of the week are most rides taken by subscribers?

SELECT TO_CHAR(START_TIME, 'Day') AS DAY_OF_THE_WEEK,
	COUNT(*) AS RIDE_COUNT
FROM
	(SELECT START_TIME
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Subscriber' ) AS SUBSCRIBER_DAY_OF_THE_WEEK
GROUP BY DAY_OF_THE_WEEK
ORDER BY RIDE_COUNT;

-- On what days of the week are most rides taken by customers?

SELECT TO_CHAR(START_TIME, 'Day') AS DAY_OF_THE_WEEK,
	COUNT(*) AS RIDE_COUNT
FROM
	(SELECT START_TIME
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT START_TIME
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Customer' ) AS SUBSCRIBER_DAY_OF_THE_WEEK
GROUP BY DAY_OF_THE_WEEK
ORDER BY RIDE_COUNT;

-- On what days of the week are the most rides taken by Subscriber and Customers?

WITH CombinedRides AS (
  SELECT TO_CHAR(START_TIME, 'Day') AS DAY_OF_THE_WEEK,
         USER_TYPE,
         COUNT(*) AS RIDE_COUNT
  FROM (
    SELECT START_TIME, USER_TYPE FROM BLUEBIKES_2016
    UNION ALL
    SELECT START_TIME, USER_TYPE FROM BLUEBIKES_2017
    UNION ALL
    SELECT START_TIME, USER_TYPE FROM BLUEBIKES_2018
    UNION ALL
    SELECT START_TIME, USER_TYPE FROM BLUEBIKES_2019
  ) AS ALL_RIDES
  GROUP BY DAY_OF_THE_WEEK, USER_TYPE
)

SELECT * FROM CombinedRides
ORDER BY USER_TYPE, RIDE_COUNT DESC;

-- Popular start station for subscribers

SELECT
    S.ID AS START_STATION_ID,
    S.NAME AS START_STATION_NAME,
    S.DISTRICT AS START_STATION_DISTRICT,
    S.LATITUDE AS START_STATION_LATITUDE,
    S.LONGITUDE AS START_STATION_LONGITUDE,
    COUNT(*) AS TOTAL_RIDES_BY_SUBSCRIBERS
FROM
    (SELECT START_STATION_ID
     FROM BLUEBIKES_2016
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2017
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2018
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2019
     WHERE USER_TYPE ILIKE 'Subscriber') AS MOST_SUBSCRIBER_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_SUBSCRIBER_RIDES_START.START_STATION_ID = S.ID
GROUP BY
    S.ID,
    S.NAME,
    S.DISTRICT,
    S.LATITUDE,
    S.LONGITUDE
ORDER BY
    TOTAL_RIDES_BY_SUBSCRIBERS DESC
LIMIT 10;

-- Popular end station for subscribers

SELECT S.ID AS END_STATION_ID,
	S.NAME AS END_STATION_NAME,
	S.DISTRICT AS END_STATION_DISTRICT,
	S.LATITUDE AS END_STATION_LATITUDE,
	S.LONGITUDE AS END_STATION_LONGITUDE,
	COUNT(*) AS TOTAL_RIDES_BY_SUBSCRIBERS
FROM
	(SELECT END_STATION_ID
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Subscriber'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Subscriber' ) AS MOST_SUBSCRIBER_RIDES_END
JOIN BLUEBIKES_STATIONS AS S ON MOST_SUBSCRIBER_RIDES_END.END_STATION_ID = S.ID
GROUP BY S.ID,
	S.NAME,
	S.DISTRICT,
	S.LATITUDE,
	S.LONGITUDE
ORDER BY TOTAL_RIDES_BY_SUBSCRIBERS DESC
LIMIT 10;

-- Popular start station for customers

SELECT S.ID AS START_STATION_ID,
	S.NAME AS START_STATION_NAME,
	S.DISTRICT AS START_STATION_DISTRICT,
	S.LATITUDE AS START_STATION_LATITUDE,
	S.LONGITUDE AS START_STATION_LONGITUDE,
	COUNT(*) AS TOTAL_RIDES_BY_CUSTOMERS
FROM
	(SELECT START_STATION_ID
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ILIKE 'Customer'
		UNION ALL SELECT START_STATION_ID
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ILIKE 'Customer'
		UNION ALL SELECT START_STATION_ID
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ILIKE 'Customer'
		UNION ALL SELECT START_STATION_ID
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ILIKE 'Customer') AS MOST_CUSTOMER_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_CUSTOMER_RIDES_START.START_STATION_ID = S.ID
GROUP BY S.ID,
	S.NAME,
	S.DISTRICT,
	S.LATITUDE,
	S.LONGITUDE
ORDER BY TOTAL_RIDES_BY_CUSTOMERS DESC
LIMIT 10;

-- Popular end station for customers

SELECT S.ID AS END_STATION_ID,
	S.NAME AS END_STATION_NAME,
	S.DISTRICT AS END_STATION_DISTRICT,
	S.LATITUDE AS END_STATION_LATITUDE,
	S.LONGITUDE AS END_STATION_LONGITUDE,
	COUNT(*) AS TOTAL_RIDES_BY_CUSTOMERS
FROM
	(SELECT END_STATION_ID
		FROM BLUEBIKES_2016
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2017
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2018
		WHERE USER_TYPE ilike 'Customer'
		UNION ALL SELECT END_STATION_ID
		FROM BLUEBIKES_2019
		WHERE USER_TYPE ilike 'Customer' ) AS MOST_CUSTOMERS_RIDES_END
JOIN BLUEBIKES_STATIONS AS S ON MOST_CUSTOMERS_RIDES_END.END_STATION_ID = S.ID
GROUP BY S.ID,
	S.NAME,
	S.DISTRICT,
	S.LATITUDE,
	S.LONGITUDE
ORDER BY TOTAL_RIDES_BY_CUSTOMERS DESC
LIMIT 10;

-- Popular start station for subscribers and customers combined

SELECT
    S.ID AS START_STATION_ID,
    S.NAME AS START_STATION_NAME,
    S.DISTRICT AS START_STATION_DISTRICT,
    S.LATITUDE AS START_STATION_LATITUDE,
    S.LONGITUDE AS START_STATION_LONGITUDE,
    COUNT(*) AS TOTAL_RIDES
FROM
    (SELECT START_STATION_ID
     FROM BLUEBIKES_2016
     WHERE USER_TYPE IN ('Subscriber', 'Customer')
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2017
     WHERE USER_TYPE IN ('Subscriber', 'Customer')
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2018
     WHERE USER_TYPE IN ('Subscriber', 'Customer')
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2019
     WHERE USER_TYPE IN ('Subscriber', 'Customer')) AS MOST_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_RIDES_START.START_STATION_ID = S.ID
GROUP BY
    S.ID,
    S.NAME,
    S.DISTRICT,
    S.LATITUDE,
    S.LONGITUDE
ORDER BY
    TOTAL_RIDES DESC
LIMIT 10;



 /*popular routes for subscribers 
WITH TopStartStations AS (
    SELECT
        start_station_id,
        COUNT(*) AS total_rides
    FROM
        (SELECT start_station_id FROM bluebikes_2016 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2017 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2018 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2019 WHERE user_type ILIKE 'Subscriber') AS subscriber_rides
    GROUP BY
        start_station_id
    ORDER BY
        total_rides DESC
   
)

SELECT
    tss.start_station_id AS start_station_number,
    ss_start.name AS start_station_name,
    ss_start.district AS start_station_district,
    ss_end.id AS end_station_number,
    ss_end.name AS end_station_name,
    ss_end.district AS end_station_district,
    COUNT(*) AS total_rides
FROM
    TopStartStations tss
JOIN
    (SELECT * FROM bluebikes_2016 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2017 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2018 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2019 WHERE user_type ILIKE 'Subscriber') AS subscriber_rides_all
    ON tss.start_station_id = subscriber_rides_all.start_station_id
JOIN
    bluebikes_stations AS ss_start ON subscriber_rides_all.start_station_id = ss_start.id
JOIN
    bluebikes_stations AS ss_end ON subscriber_rides_all.end_station_id = ss_end.id
GROUP BY
    tss.start_station_id, ss_start.name, ss_start.district, ss_end.id, ss_end.name, ss_end.district
ORDER BY
    total_rides DESC;
	
/* WITH TopStartStations AS (
    SELECT
        start_station_id,
        COUNT(*) AS total_rides
    FROM
        (SELECT start_station_id FROM bluebikes_2016 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2017 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2018 WHERE user_type ILIKE 'Subscriber'
         UNION ALL SELECT start_station_id FROM bluebikes_2019 WHERE user_type ILIKE 'Subscriber') AS subscriber_rides
    GROUP BY
        start_station_id
    ORDER BY
        total_rides DESC
)

SELECT
    tss.start_station_id AS start_station_number,
    ss_start.name AS start_station_name,
    ss_start.district AS start_station_district,
    ss_start.latitude AS start_latitude,
    ss_start.longitude AS start_longitude,
    ss_end.id AS end_station_number,
    ss_end.name AS end_station_name,
    ss_end.district AS end_station_district,
    ss_end.latitude AS end_latitude,
    ss_end.longitude AS end_longitude,
    COUNT(*) AS total_rides
FROM
    TopStartStations tss
JOIN
    (SELECT * FROM bluebikes_2016 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2017 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2018 WHERE user_type ILIKE 'Subscriber'
     UNION ALL SELECT * FROM bluebikes_2019 WHERE user_type ILIKE 'Subscriber') AS subscriber_rides_all
    ON tss.start_station_id = subscriber_rides_all.start_station_id
JOIN
    bluebikes_stations AS ss_start ON subscriber_rides_all.start_station_id = ss_start.id
JOIN
    bluebikes_stations AS ss_end ON subscriber_rides_all.end_station_id = ss_end.id
GROUP BY
    tss.start_station_id, ss_start.name, ss_start.district, ss_start.latitude, ss_start.longitude, ss_end.id, ss_end.name, ss_end.district, ss_end.latitude, ss_end.longitude
ORDER BY
    total_rides DESC;

/*
SELECT USER_BIRTH_YEAR,
	COUNT(*) AS USER_COUNT
FROM
	(SELECT USER_BIRTH_YEAR
		FROM BLUEBIKES_2016
		UNION ALL SELECT USER_BIRTH_YEAR
		FROM BLUEBIKES_2017
		UNION ALL SELECT USER_BIRTH_YEAR
		FROM BLUEBIKES_2018
		UNION ALL SELECT USER_BIRTH_YEAR
		FROM BLUEBIKES_2019) AS BIRTH_YEAR_COMBINED
WHERE USER_BIRTH_YEAR IS NOT NULL
GROUP BY USER_BIRTH_YEAR
ORDER BY USER_BIRTH_YEAR;

/* 

-- 

/*
SELECT YEAR,
	ROUND(AVG(EXTRACT(YEAR FROM CURRENT_DATE) - CAST(SPLIT_PART(USER_BIRTH_YEAR, '.', 1) AS integer))) AS AVERAGE_AGE
FROM
	(SELECT '2016' as year, USER_BIRTH_YEAR
		FROM BLUEBIKES_2016
		UNION ALL SELECT '2017' as year, USER_BIRTH_YEAR
		FROM BLUEBIKES_2017
		UNION ALL SELECT '2018' as year, USER_BIRTH_YEAR
		FROM BLUEBIKES_2018
		UNION ALL SELECT '2019' as year, USER_BIRTH_YEAR
		FROM BLUEBIKES_2019) AS AVERAGE_BIRTH_YEAR
WHERE USER_BIRTH_YEAR IS NOT NULL
	AND SPLIT_PART(USER_BIRTH_YEAR, '.', 2) IS NULL
GROUP BY YEAR
ORDER BY YEAR; 


SELECT
    S.ID AS START_STATION_ID,
    S.NAME AS START_STATION_NAME,
    S.DISTRICT AS START_STATION_DISTRICT,
    S.LATITUDE AS START_STATION_LATITUDE,
    S.LONGITUDE AS START_STATION_LONGITUDE,
    COUNT(*) AS TOTAL_RIDES_BY_SUBSCRIBERS
FROM
    (SELECT START_STATION_ID
     FROM BLUEBIKES_2016
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2017
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2018
     WHERE USER_TYPE ILIKE 'Subscriber'
     UNION ALL SELECT START_STATION_ID
     FROM BLUEBIKES_2019
     WHERE USER_TYPE ILIKE 'Subscriber') AS MOST_SUBSCRIBER_RIDES_START
JOIN BLUEBIKES_STATIONS AS S ON MOST_SUBSCRIBER_RIDES_START.START_STATION_ID = S.ID
GROUP BY
    S.ID,
    S.NAME,
    S.DISTRICT,
    S.LATITUDE,
    S.LONGITUDE
ORDER BY
    TOTAL_RIDES_BY_SUBSCRIBERS DESC
LIMIT 10;
