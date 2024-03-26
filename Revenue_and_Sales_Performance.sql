-- ========================================================================================================
## Total Number of Orders
-- yearly

SELECT
  EXTRACT(YEAR FROM created_at) AS order_year,
  COUNT(*) AS total_orders
FROM
  `bigquery-public-data.thelook_ecommerce.orders` oi
GROUP BY
  order_year
ORDER BY
  order_year;

-- ========================================================================================================
-- ========================================================================================================
## Total Revenue
--yearly

WITH OrderItemRevenue AS (
  SELECT
    oi.order_id,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id
)

SELECT
  EXTRACT(YEAR FROM o.created_at) AS order_year,
  SUM(orr.total_revenue) AS total_revenue
FROM
  OrderItemRevenue orr
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  orr.order_id = o.order_id
GROUP BY
  order_year
ORDER BY
  order_year;

--Total

WITH OrderItemRevenue AS (
  SELECT
    oi.order_id,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id
)

SELECT
  SUM(orr.total_revenue) AS total_revenue
FROM
  OrderItemRevenue orr;



-- ========================================================================================================
-- ========================================================================================================
## Cost of Goods Sold 
--yearly

WITH OrderItemCost AS (
  SELECT
    oi.order_id,
    SUM(p.cost) AS total_cost_of_goods_sold
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
  ON
    oi.product_id = p.id
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id
)

SELECT
  EXTRACT(YEAR FROM o.created_at) AS order_year,
  SUM(oci.total_cost_of_goods_sold) AS total_cost_of_goods_sold
FROM
  OrderItemCost oci
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  oci.order_id = o.order_id
GROUP BY
  order_year
ORDER BY
  order_year;


-- ========================================================================================================
-- ========================================================================================================
## Gross Profit

WITH OrderItemRevenue AS (
  SELECT
    oi.order_id,
    EXTRACT(YEAR FROM o.created_at) AS order_year,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id, order_year
),
OrderItemCost AS (
  SELECT
    oi.order_id,
    EXTRACT(YEAR FROM o.created_at) AS order_year,
    SUM(p.cost) AS total_cost_of_goods_sold
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
  ON
    oi.product_id = p.id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id, order_year
)

SELECT
  orr.order_year,
  SUM(orr.total_revenue - oic.total_cost_of_goods_sold) AS gross_profit
FROM
  OrderItemRevenue orr
JOIN
  OrderItemCost oic
ON
  orr.order_id = oic.order_id
  AND orr.order_year = oic.order_year
GROUP BY
  orr.order_year
ORDER BY
  orr.order_year;


-- ========================================================================================================
-- ========================================================================================================
## Return Rate

--Yearly

WITH ReturnedOrders AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    COUNT(*) AS returned_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status = 'Returned'
  GROUP BY
    order_year
),
TotalOrders AS (
  SELECT
    EXTRACT(YEAR FROM created_at) AS order_year,
    COUNT(*) AS total_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  GROUP BY
    order_year
)

SELECT
  r.order_year,
  (r.returned_orders / t.total_orders) * 100 AS return_rate
FROM
  ReturnedOrders r
JOIN
  TotalOrders t
ON
  r.order_year = t.order_year
ORDER BY
  r.order_year;

--Total

WITH ReturnedOrders AS (
  SELECT
    COUNT(*) AS returned_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
  WHERE
    status = 'Returned'
),
TotalOrders AS (
  SELECT
    COUNT(*) AS total_orders
  FROM
    `bigquery-public-data.thelook_ecommerce.orders`
)

SELECT
  (returned_orders / total_orders) * 100 AS return_rate
FROM
  ReturnedOrders, TotalOrders;


-- ========================================================================================================
-- ========================================================================================================
## Sales Performance by Product Brand 
--Yearly

SELECT
    EXTRACT(YEAR FROM o.created_at) AS order_year,
    p.brand,
    SUM(oi.sale_price - p.cost) AS profit
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
ON
    oi.product_id = p.id
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
ON
    oi.order_id = o.order_id
WHERE
    o.status IN ('Complete', 'Shipped')
GROUP BY
    order_year, p.brand
ORDER BY
    order_year, profit DESC;

--Overall

SELECT
    p.brand,
    SUM(oi.sale_price - p.cost) AS profit
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
ON
    oi.product_id = p.id
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
ON
    oi.order_id = o.order_id
WHERE
    o.status IN ('Complete', 'Shipped')
GROUP BY
    p.brand
ORDER BY
    profit DESC;

-- ========================================================================================================
-- ========================================================================================================
## Sales Performance by Product category 

--Yearly

SELECT
    EXTRACT(YEAR FROM o.created_at) AS order_year,
    p.category,
    SUM(oi.sale_price - p.cost) AS profit
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
ON
    oi.product_id = p.id
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
ON
    oi.order_id = o.order_id
WHERE
    o.status IN ('Complete', 'Shipped')
GROUP BY
    order_year, p.category
ORDER BY
    order_year, profit DESC;

--Overall

SELECT
    p.category,
    SUM(oi.sale_price - p.cost) AS profit
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
ON
    oi.product_id = p.id
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
ON
    oi.order_id = o.order_id
WHERE
    o.status IN ('Complete', 'Shipped')
GROUP BY
    p.category
ORDER BY
    profit DESC;

-- ========================================================================================================
-- ========================================================================================================
## Revenue summary (Success, Potential,Failed)

--Yearly

WITH OrderItemRevenue AS (
  SELECT
    oi.order_id,
    SUM(oi.sale_price) AS total_revenue,
    CASE
      WHEN o.status IN ('Cancelled', 'Returned') THEN 'Failed'
      WHEN o.status IN ('Complete', 'Shipped') THEN 'Success'
      ELSE 'Potential'
    END AS order_status,
    EXTRACT(YEAR FROM o.created_at) AS order_year
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  GROUP BY
    oi.order_id, order_status, order_year
)

SELECT
  order_year,
  order_status,
  SUM(total_revenue) AS total_revenue
FROM
  OrderItemRevenue
GROUP BY
  order_year, order_status
ORDER BY
  order_year, order_status;

-- ========================================================================================================
-- ========================================================================================================
## Revenue Trend 
--Yearly

WITH OrderItemRevenue AS (
  SELECT
    oi.order_id,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
  ON
    oi.order_id = o.order_id
  WHERE
    o.status IN ('Complete', 'Shipped')
  GROUP BY
    oi.order_id
)

SELECT
  EXTRACT(YEAR FROM o.created_at) AS order_year,
  SUM(orr.total_revenue) AS total_revenue
FROM
  OrderItemRevenue orr
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  orr.order_id = o.order_id
GROUP BY
  order_year
ORDER BY
  order_year;

-- ========================================================================================================
-- ========================================================================================================
## Avg Order Value 

--Yearly

SELECT 
  EXTRACT(YEAR FROM o.created_at) AS order_year,
  AVG(oi.sale_price) AS average_order_value
FROM 
  `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN
  `bigquery-public-data.thelook_ecommerce.orders` o
ON
  oi.order_id = o.order_id
WHERE
  o.status IN ('Complete', 'Shipped')
GROUP BY
  order_year
ORDER BY
  order_year;

-- ========================================================================================================
