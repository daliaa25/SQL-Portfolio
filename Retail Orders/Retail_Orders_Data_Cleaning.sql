# Retail Orders - Data Cleaning

# Creating a staging table for cleaning
CREATE TABLE orders_staging
SELECT * FROM orders;

# Retrieving data from the table 
SELECT * FROM orders_staging;

# Retrieving rows where cost and list price = 0
SELECT *
FROM orders_staging where `cost price`= 0 or `list price` = 0;

# Creating a flag column to identify the prices
ALTER TABLE orders_staging
ADD COLUMN price_flag varchar(10);

# Updating price_flag column
UPDATE orders_staging
SET price_flag = CASE 
WHEN `cost price` = 0 THEN 'invalid'
ELSE 'valid'
END;

# Retrieving distinct rows from Ship Mode to analyze
SELECT DISTINCT `Ship Mode` FROM orders_staging;
-- Some rows have inconsistencies(having 'unknown','N/A','Not Available')

# Standardizing the data across Ship Mode 
UPDATE orders_staging
SET `Ship Mode` =  'Unknown'
WHERE `Ship Mode` IN('unknown','N/A','Not Available');

# Analyzing distinct length of postal codes
SELECT DISTINCT LENGTH(`postal code`) FROM orders_staging;

# Retrieving rows whre postal code is less than 5
SELECT * FROM orders_staging
WHERE LENGTH(`postal code`) < 5 ;

# Updating the datatype of postal code 
ALTER TABLE orders_staging
MODIFY COLUMN `Postal Code`varchar(10);

# Padding postal codes with leading zero to ensure 5-digit format
UPDATE orders_staging
SET `Postal Code` = LPAD(`Postal Code`,5,0);



