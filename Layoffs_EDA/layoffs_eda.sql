-- Data Exploratory Analysis

# Selecting the data
SELECT * FROM layoffs_staging2;

# Finding max of total_laid_off and percentage_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

# Looking through the funds raised by companies where all the employees are laid off
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# Total Laid off by each company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

# Total Laid off by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

# Total Laid off by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

# Total Laid off by year
SELECT YEAR(`date`)  AS `year`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY `year` DESC;

# Total Laid off by stage of the company
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

# Rolling total by each month
WITH rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month` ,SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` 
)
SELECT `Month`,total_laid, SUM(total_laid) OVER(ORDER BY `Month` ) AS rolling_total
FROM rolling_total;

# Top 5 companies total_laid_off each year
WITH company_laid_off AS(
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY total_laid DESC
),company_year_rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid DESC) AS ranking
FROM company_laid_off
WHERE years IS NOT NULL)
SELECT * FROM company_year_rank 
WHERE ranking <= 5;
