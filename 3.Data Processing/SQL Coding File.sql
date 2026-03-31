-- I want to see my table in the coding environment to start exploryting each column
SELECT *
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1` 
LIMIT 10;
-----------------------------------------------------------------------------
-- 1. CHECKING THE DATE RANGE
-----------------------------------------------------------------------------
--They started collecting the data 2023-01-01
SELECT MIN(transaction_date) AS min_date
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;
--The duration of the data is 6 months
--They last collected the data 2023-06-30
SELECT MAX(transaction_date) AS latest_date
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;
--------------------------------------------------------------------------------
--2. CHECKING THE NAMES OF THE DIFFERENT STORES
--------------------------------------------------------------------------------
--We have 3 stores and their names are Lower Manhattan, Hell's Kitchen, Astoria
SELECT DISTINCT store_location
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;
--------------------------------------------------------------------------------
--3. CHECKING PRODUCTS SOLD AT OUR STORES
--------------------------------------------------------------------------------
SELECT DISTINCT Product_category
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_detail
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_type
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_category AS category,
                product_detail AS product_name
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;
--------------------------------------------------------------------------------
--4. CHECKING PRODUCT PRICES
--------------------------------------------------------------------------------
SELECT MIN(unit_price) AS cheapest_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT MAX(unit_price) AS expensive_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;
--------------------------------------------------------------------------------
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_sales,
       COUNT(DISTINCT product_id) AS number_of_products,
       COUNT(DISTINCT store_id) AS number_of_stores
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT transaction_date,
--Dates
        transaction_date AS purchase_date,
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name,
        Dayofmonth(transaction_date) AS day_of_month,

    CASE
        WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,

    --date_format(transaction_time, 'HH:mm:ss') AS purchase_time,
          CASE
            WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
            WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
            WHEN date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
      END AS time_buckets,

 --Counts of IDs    
        COUNT(DISTINCT transaction_id) AS number_of_sales,
        COUNT(DISTINCT product_id) AS number_of_products,
        COUNT(DISTINCT store_id) AS number_of_stores,
  --Revenue      
        SUM(transaction_qty) AS total_quantity_sold,
        SUM(transaction_qty*unit_price) AS total_revenue,
        SUM(transaction_qty*unit_price) AS revenue_per_tnx,
    CASE
        WHEN Revenue_per_day<=50 THEN '01. Low Spend'
        WHEN Revenue_per_day BETWEEN 51 AND 100 THEN '02. Medium Spend'
        ELSE '03. High Spend'
    END AS spend_buckets,

  --Categorical columns
          store_location,
          Product_category,
          Product_detail
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study_1`
GROUP BY transaction_date,
          Dayname(transaction_date),
          Monthname(transaction_date),
          Dayofmonth(transaction_date),

 CASE 
      WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
      ELSE 'Weekday'
      END,

         CASE
            WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
            WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
            WHEN date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
         END,

          Store_location,
          Product_category,
          Product_detail;


