# Retail Orders SQL Analysis

This project involves cleaning and analyzing a real-world retail orders dataset using MySQL.
The project is split into two parts: Data Cleaning and Exploratory Data Analysis (EDA).

---

## Files

| File | Description |
|------|-------------|
| `retail_orders_cleaning.sql` | Cleans the raw retail orders dataset |
| `retail_orders_eda.sql` | Explores and analyzes the cleaned dataset |
| `retail_orders_raw.csv` | Raw dataset used in this project |

---

## Part 1: Data Cleaning

### Steps Performed:

**1. Created Staging Table**
- Created `orders_staging` as a copy of the raw table to preserve original data

**2. Handled Invalid Prices**
- Identified rows where `cost price` or `list price` = 0
- Added a `price_flag` column to label rows as `valid` or `invalid`
- Used throughout EDA to exclude invalid records from analysis

**3. Standardized Ship Mode**
- Found inconsistencies across `Ship Mode` values (`unknown`, `N/A`, `Not Available`)
- Standardized all variants to a single `Unknown` value

**4. Fixed Postal Codes**
- Identified postal codes with fewer than 5 digits
- Changed `Postal Code` column datatype to `VARCHAR(10)`
- Padded short postal codes with leading zeros using `LPAD()` to ensure 5-digit format

---

## Part 2: Exploratory Data Analysis (EDA)

### Key Questions Explored:

**Category & Sub-Category Analysis**
- Which categories generate the highest total and average list price?
- What are the top 3 sub-categories by list price within each category? (using `DENSE_RANK()`)

**Geographic Analysis**
- Which are the top 10 performing states by list price?
- How does total quantity sold vary across regions?

**Time-Based Trends**
- Month-wise list price breakdown across categories (Technology, Office Supplies, Furniture)
- Month-wise list price breakdown across customer segments (Consumer, Corporate, Home Office)
- Year over Year (YoY) comparison of orders, quantity, revenue, and profit

**Shipping & Orders**
- How are orders distributed across ship modes?
- What are total orders and quantity sold by category and segment?

**Pricing & Profitability**
- How does discount percentage impact quantity ordered?
- What is the profit margin by category and segment?

---

## Tools & Technologies

- MySQL

---

## SQL Skills Demonstrated

| Skill | Where Used |
|-------|------------|
| SELECT, WHERE, ORDER BY | Throughout |
| GROUP BY, HAVING | Aggregation queries |
| Window Functions (DENSE_RANK) | Top sub-categories ranking |
| CTEs | Subquery for ranking |
| Aggregations (SUM, COUNT, AVG, ROUND) | Revenue, profit, quantity analysis |
| Data Cleaning (LPAD, ALTER TABLE, CASE) | Cleaning section |
| Time-Based Analysis (DATE_FORMAT, YEAR) | Monthly and YoY trend analysis |
| Conditional Aggregation (CASE inside SUM) | Pivot-style monthly breakdowns |

---

## Purpose

This project showcases the ability to clean messy real-world retail data and extract meaningful
business insights using SQL — covering pricing, profitability, shipping, and time-based trends.
