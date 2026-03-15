-- Layoffs SQL Analysis

This project involves cleaning and analyzing a real-world dataset of global tech layoffs using MySQL.
The project is split into two parts: Data Cleaning and Exploratory Data Analysis (EDA).


-- Files

|          File               |             Description                   |
|-----------------------------|-------------------------------------------|
| `Layoffs_data_cleaning.sql` | Cleans the raw layoffs dataset            |
| `Layoffs_EDA.sql`           | Explores and analyzes the cleaned dataset |
| `Layoffs_raw.csv`           | Raw dataset used in this project          |


-- Part 1: Data Cleaning

1. Created Staging Tables**
- Created `layoffs_staging` as a copy of the raw table to preserve original data
- Created `layoffs_staging2` with an additional `row_num` column for duplicate detection

2. Removed Duplicates**
- Used `ROW_NUMBER()` with `PARTITION BY` across all columns to identify duplicates
- Deleted all rows where `row_num > 1`

3. Standardized Data**
- Trimmed whitespace from the `company` column using `TRIM()`
- Standardized industry values (e.g. `Crypto%` → `Crypto`)
- Standardized country values (e.g. `United States%` → `United States`)
- Converted `date` column from text to proper `DATE` format using `STR_TO_DATE()`
- Changed `date` column datatype using `ALTER TABLE`

4. Handled Null & Blank Values**
- Converted blank `industry` values to `NULL`
- Used a self `JOIN` to fill in missing `industry` values from other rows of the same company
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were `NULL`

5. Final Cleanup**
- Dropped the `row_num` helper column


-- Part 2: Exploratory Data Analysis (EDA)

Key Questions Explored:

**Overall Scale**
- What is the maximum number of employees laid off in a single event?
- Which companies laid off 100% of their workforce, and how much had they raised?

**Layoffs by Dimension**
- Which companies had the highest total layoffs?
- Which industries were hit hardest?
- Which countries had the most layoffs?
- How did layoffs vary by company funding stage?

**Time-Based Trends**
- What were the total layoffs per year?
- What is the rolling monthly total of layoffs over time?

**Rankings**
- Who were the top 5 companies with the most layoffs each year? (using `DENSE_RANK()`)


-- Tools & Technologies
 **MySQL**

-- SQL Skills Demonstrated

- `SELECT`, `WHERE`, `ORDER BY`
- `GROUP BY`, `HAVING`
- Window Functions — `ROW_NUMBER()`, `DENSE_RANK()`
- CTEs (`WITH` clause)
- `JOIN` (self join for null-filling)
- Data Cleaning — `TRIM()`, `STR_TO_DATE()`, `ALTER TABLE`
- Aggregations — `SUM()`, `MAX()`
- Time-Based Analysis — `YEAR()`, `SUBSTRING()` for month extraction
