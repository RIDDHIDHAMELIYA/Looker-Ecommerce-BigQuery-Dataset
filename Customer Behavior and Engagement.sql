-- Total Number of Users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM `bigquery-public-data.thelook_ecommerce.orders`;
--yearly
SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  COUNT(DISTINCT user_id) AS total_users
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY
  order_year
ORDER BY
  order_year;


-- Total Number of Purchases
SELECT COUNT(*) AS total_purchases
FROM `bigquery-public-data.thelook_ecommerce.orders`
WHERE status IN ('Complete', 'Shipped');

--yearly
SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  COUNT(*) AS total_purchases
FROM
  `bigquery-public-data.thelook_ecommerce.orders`
WHERE
  status IN ('Complete', 'Shipped')
GROUP BY
  order_year
ORDER BY
  order_year;

-- Monthly Active Users (MAU)
SELECT
  EXTRACT(YEAR FROM created_at) AS year,
  EXTRACT(MONTH FROM created_at) AS month,
  COUNT(DISTINCT user_id) AS monthly_active_users
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY year, month
ORDER BY year, month;

-- Average Order Value by Gender
SELECT
  gender,
  AVG(sale_price) AS average_order_value
FROM
  `bigquery-public-data.thelook_ecommerce.orders` o
JOIN
  `bigquery-public-data.thelook_ecommerce.order_items` oi
ON
  o.order_id = oi.order_id
GROUP BY
  gender;

--yearly
SELECT
  EXTRACT(YEAR FROM o.created_at) AS order_year,
  gender,
  AVG(oi.sale_price) AS average_order_value
FROM
  `bigquery-public-data.thelook_ecommerce.orders` o
JOIN
  `bigquery-public-data.thelook_ecommerce.order_items` oi
ON
  o.order_id = oi.order_id
GROUP BY
  order_year, gender
ORDER BY
  order_year, gender;


-- Revenue Distribution by Traffic Source - yearly

WITH RevenueByTrafficSource AS (
  SELECT
    EXTRACT(YEAR FROM e.created_at) AS order_year,
    e.traffic_source,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.events` e
  JOIN
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON
    e.user_id = oi.user_id
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    order_year, e.traffic_source
)

SELECT
  order_year,
  traffic_source,
  COALESCE(total_revenue, 0) AS total_revenue
FROM
  RevenueByTrafficSource
ORDER BY
  order_year, total_revenue DESC;

-- Customer Returning Rate
WITH ReturningCustomers AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS total_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status IN ('Complete', 'Shipped')
  GROUP BY
    user_id
  HAVING
    total_orders > 1
)
SELECT
  COUNT(DISTINCT user_id) AS returning_customers,
  COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM `bigquery-public-data.thelook_ecommerce.orders`) AS returning_customer_rate
FROM
  ReturningCustomers;


-- years
WITH ReturningCustomers AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    user_id,
    COUNT(DISTINCT order_id) AS total_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status IN ('Complete', 'Shipped')
  GROUP BY
    order_year, user_id
  HAVING
    total_orders > 1
),
TotalCustomers AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    COUNT(DISTINCT user_id) AS total_customers
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status IN ('Complete', 'Shipped')
  GROUP BY
    order_year
)
SELECT
  rc.order_year,
  COUNT(DISTINCT rc.user_id) AS returning_customers,
  COUNT(DISTINCT rc.user_id) / tc.total_customers AS returning_customer_rate
FROM
  ReturningCustomers rc
JOIN
  TotalCustomers tc
ON
  rc.order_year = tc.order_year
GROUP BY
  rc.order_year, tc.total_customers
ORDER BY
  rc.order_year;

-- Customer Distribution by Age Group (Assuming age is available in user profile)
SELECT
  CASE
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group,
  COUNT(DISTINCT id) AS users_in_age_group
FROM
  `bigquery-public-data.thelook_ecommerce.users` 
GROUP BY
  age_group;


-- Customer Distribution by Age Group (Assuming age is available in user profile) - yearly

WITH UserOrders AS (
  SELECT
    u.id AS user_id,
    u.age,
    EXTRACT(YEAR FROM o.created_at) AS order_year
  FROM
    `bigquery-public-data.thelook_ecommerce.users` u
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    u.id = o.user_id
)

SELECT
  order_year,
  CASE
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group,
  COUNT(DISTINCT user_id) AS users_in_age_group
FROM
  UserOrders
GROUP BY
  order_year, age_group
ORDER BY
  order_year, age_group;
