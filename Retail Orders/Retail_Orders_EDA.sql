# Retail Orders - Exploratory Data Analysis

SELECT * FROM orders_staging;

# Comparing categories by total and average list price (excluding invalid prices)
SELECT Category,
SUM(`List Price`) AS total_list_price,
AVG(`List Price`) AS avg_list_price
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY Category
ORDER BY total_list_price DESC;

# Retrieving top 3 sub-categories by list price within each category
SELECT *
FROM(
SELECT Category, `Sub Category`, SUM(`List Price`) AS total_price,
DENSE_RANK() OVER(PARTITION BY Category ORDER BY SUM(`List Price`) DESC) as price_rank
FROM orders_staging
where price_flag = 'valid'
GROUP BY Category,`Sub Category`) table2
WHERE price_rank <=3;

# Retrieving top 10 performing states by list price
SELECT state, SUM(`List Price`) as total_price
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY state
ORDER BY total_price DESC
LIMIT 10;

# Month-wise list price comparison across categories 
SELECT 
DATE_FORMAT(`Order Date`,'%Y-%m') AS order_date,
SUM(CASE WHEN Category = 'Technology' THEN `List Price` ELSE 0 END) AS Technology,
SUM(CASE WHEN Category = 'Office Supplies' THEN `List Price` ELSE 0 END) AS Office_Supplies,
SUM(CASE WHEN Category = 'Furniture' THEN `List Price` ELSE 0 END) AS Furniture,
SUM(`List Price`) AS total_price
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY DATE_FORMAT(`Order Date`,'%Y-%m')
Order BY order_date;

# Month-wise list price comparison across segments 
SELECT 
DATE_FORMAT(`Order Date`,'%Y-%m') AS order_date,
SUM(CASE WHEN Segment = 'Consumer' THEN `List Price` ELSE 0 END) AS Consumer,
SUM(CASE WHEN Segment = 'Corporate' THEN `List Price` ELSE 0 END) AS Corporate,
SUM(CASE WHEN Segment = 'Home Office' THEN `List Price` ELSE 0 END) AS Home_Office,
SUM(`List Price`) AS total_price
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY DATE_FORMAT(`Order Date`,'%Y-%m')
Order BY order_date;

# Total quantity sold across regions
SELECT Region,
SUM(Quantity) as total_quantity_sold
FROM orders_staging
GROUP BY Region
ORDER BY total_quantity_sold DESC;

# Total orders by ship mode (excluding unknown)
SELECT 
`Ship Mode`,
COUNT(`Order Id`) as total_orders
FROM orders_staging
WHERE `Ship Mode` <> 'Unknown'
GROUP BY `Ship Mode`
ORDER BY total_orders DESC;

# Total orders and quantity by category
SELECT 
Category,SUM(Quantity) as total_quantity,
COUNT(`Order Id`) as total_orders
FROM orders_staging
GROUP BY Category
ORDER BY total_orders DESC;

# Total orders and quantity by Segment
SELECT 
Segment,SUM(Quantity) as total_quantity,
COUNT(`Order Id`) as total_orders
FROM orders_staging
GROUP BY Segment
ORDER BY total_orders DESC;

# Discount impact on quantity ordered
SELECT 
`Discount Percent`,
SUM(Quantity) AS quantity_ordered
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY `Discount Percent`
ORDER BY `Discount Percent`;

# Profit margin analysis by category (excluding invalid prices)
SELECT
Category,
SUM(`List Price` - `cost price`) AS total_profit,
ROUND(SUM(`List Price` - `cost price`)/SUM(`List Price`)*100,2) AS profit_margin
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY Category
ORDER BY profit_margin DESC;

# Profit margin analysis by segment (excluding invalid prices)
SELECT
Segment,
SUM(`List Price` - `cost price`) AS total_profit,
ROUND(SUM(`List Price` - `cost price`)/SUM(`List Price`)*100,2) AS profit_margin
FROM orders_staging
WHERE price_flag = 'valid'
GROUP BY Segment
ORDER BY profit_margin DESC;

# Year over Year (YoY) comparison of orders, quantity, revenue and profit
SELECT
YEAR(`Order Date`) as `year`,
COUNT(`Order Id`) as total_orders,
SUM(Quantity) AS total_quantity,
SUM(CASE WHEN price_flag = 'valid' THEN `List Price` ELSE 0 END) as total_revenue,
SUM(CASE WHEN price_flag = 'valid' THEN`List Price` - `cost price` ELSE 0 END) AS total_profit
FROM orders_staging
GROUP BY YEAR(`Order Date`)
ORDER BY `year`;
