-- ========================================================================================================
## Order Status
-- ========================================================================================================
--Overall

SELECT
  oi.status,
  COUNT(*) AS status_count
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
WHERE
  EXTRACT(MONTH FROM oi.created_at) = EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
  AND 
  EXTRACT(YEAR FROM oi.created_at) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
GROUP BY
  oi.status;

--Year by year 

SELECT
  EXTRACT(YEAR FROM oi.created_at) AS order_year,
  oi.status,
  COUNT(*) AS status_count
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
GROUP BY
  order_year,
  oi.status
ORDER BY
  order_year,
  oi.status;

-- ========================================================================================================
## Order Summary
-- ========================================================================================================
--Overall
SELECT
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(MONTH FROM created_at) = EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
  AND 
  EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
GROUP BY
  order_status;

--Yearly 
SELECT
  '2019' AS order_year,
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(YEAR FROM created_at) = 2019
GROUP BY
  order_status

UNION ALL

SELECT
  '2020' AS order_year,
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(YEAR FROM created_at) = 2020
GROUP BY
  order_status

UNION ALL

SELECT
  '2021' AS order_year,
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(YEAR FROM created_at) = 2021
GROUP BY
  order_status

UNION ALL

SELECT
  '2022' AS order_year,
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(YEAR FROM created_at) = 2022
GROUP BY
  order_status

UNION ALL

SELECT
  '2023' AS order_year,
  CASE
    WHEN status = 'Complete' THEN 'Success'
    WHEN status IN ('Cancelled', 'Returned') THEN 'Failed'
    ELSE 'Potential'
  END AS order_status,
  COUNT(id) AS total
FROM
  `bigquery-public-data.thelook_ecommerce.order_items`
WHERE
  EXTRACT(YEAR FROM created_at) = 2023
GROUP BY
  order_status;



-- ========================================================================================================
## Order Trend Over years
-- ========================================================================================================
WITH orders_time AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    EXTRACT(MONTH FROM created_at) AS order_month,
    COUNT(order_id) AS num_orders
  FROM
  `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    order_year,
    order_month
)

SELECT
  CONCAT(CAST(order_year AS STRING), '-', LPAD(CAST(order_month AS STRING), 2, '0')) AS year_month,
  num_orders
FROM
  orders_time
ORDER BY
  order_year,
  order_month;

-- ========================================================================================================
## Order Trend Over month
-- ========================================================================================================
-- Overall

WITH monthly_order_volume AS (
  SELECT
    EXTRACT(MONTH FROM created_at) AS order_month,
    COUNT(order_id) AS order_count
  FROM
  `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    order_month
)

SELECT
  order_month,
  order_count
FROM
  monthly_order_volume
ORDER BY
  order_month;


--monthly order by years

WITH yearly_order_volume AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    EXTRACT(MONTH FROM created_at) AS order_month,
    COUNT(order_id) AS order_count
  FROM
    `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    order_year,
    order_month
)

SELECT
  order_year,
  order_month,
  order_count
FROM
  yearly_order_volume
ORDER BY
  order_year,
  order_month;


-- ========================================================================================================
## Seasonal Order Volume 
-- ========================================================================================================
-- overall

WITH seasonal_order_volume AS (
  SELECT
    CASE 
      WHEN EXTRACT(MONTH FROM created_at) IN (12, 1, 2) THEN 'Winter'
      WHEN EXTRACT(MONTH FROM created_at) IN (3, 4, 5) THEN 'Spring'
      WHEN EXTRACT(MONTH FROM created_at) IN (6, 7, 8) THEN 'Summer'
      ELSE 'Autumn'
    END AS season,
    COUNT(order_id) AS order_count
  FROM
  `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    season
)

SELECT
  season,
  order_count
FROM
  seasonal_order_volume;

-- yearly
  WITH seasonal_order_volume AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    CASE 
      WHEN EXTRACT(MONTH FROM created_at) IN (12, 1, 2) THEN 'Winter'
      WHEN EXTRACT(MONTH FROM created_at) IN (3, 4, 5) THEN 'Spring'
      WHEN EXTRACT(MONTH FROM created_at) IN (6, 7, 8) THEN 'Summer'
      ELSE 'Autumn'
    END AS season,
    COUNT(order_id) AS order_count
  FROM
    `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    order_year,
    season
)

SELECT
  order_year,
  season,
  order_count
FROM
  seasonal_order_volume
ORDER BY
  order_year,
  season;


-- ========================================================================================================
## Avg order processing time
-- ========================================================================================================

SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  AVG(DATE_DIFF(shipped_at, created_at, DAY)) AS avg_processing_time
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
WHERE
  status = 'Shipped'
GROUP BY
  order_year
ORDER BY
  order_year;

-- ========================================================================================================
## total order by year 
-- ========================================================================================================

WITH yearly_order_volume AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    COUNT(order_id) AS order_count
  FROM
    `bigquery-public-data.thelook_ecommerce.orders` oi
  GROUP BY
    order_year
)

SELECT
  order_year,
  SUM(order_count) AS total_order_count
FROM
  yearly_order_volume
GROUP BY
  order_year
ORDER BY
  order_year;
-- ========================================================================================================
## Distribution of number of item per order
-- ========================================================================================================

SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  num_of_item,
  COUNT(*) AS num_orders
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  order_year,
  num_of_item
ORDER BY
  order_year,
  num_of_item;

-- ========================================================================================================
## yearly gender distribution by order
-- ========================================================================================================

--overall

SELECT
  gender,
  COUNT(*) AS num_orders
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  gender;

--yearly
SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  gender,
  COUNT(*) AS num_orders
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  order_year,
  gender
ORDER BY
  order_year,
  gender;
