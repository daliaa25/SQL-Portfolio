-- Data Cleaning

# Select data from layoffs
SELECT * FROM layoffs;

# Create a staging database
CREATE TABLE layoffs_staging
LIKE layoffs;

# Inserting data from layoffs to layoffs_staging
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

# Select data from layoffs_staging
SELECT * FROM layoffs_staging;

# Identifying and Selecting Duplicates
WITH dup_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT * FROM dup_cte WHERE row_num > 1;

# Creating a second staging table for duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Inserting data into the layoffs_staging2
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

# Selecting duplicate values
SELECT * FROM layoffs_staging2
WHERE row_num > 1;

# Deleting duplicate values
DELETE FROM layoffs_staging2
WHERE row_num > 1;


-- Standardizind Data

# Removing spaces in the company column by using TRIM
UPDATE layoffs_staging2
SET company = TRIM(company);

# Updating rows in industry column
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# Updating rows in country column
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

# Updating date column format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

# Changing the date column datatype 
ALTER TABLE layoffs_staging2
MODIFY `date` DATE;


-- Replacing Nulls & Blank Values

# Selecting Null and Blank Values in the industry column
SELECT * FROM layoffs_staging2 
WHERE industry IS NULL
OR industry = '';

# Updating blank values to null in industry column
UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

# Checking if the values are present in other rows
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
AND t1.location = t2.location
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

# Updating null values in the industry column
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- Deleting Unimportant rows

# Deleting rows where total_laid_off and percentage_laid_off is null
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# Dropping row_num Column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2

