/* 1. Basic Dataset Overview */
SELECT COUNT(*) AS total_records 
FROM global_house_purchase_dataset;

SELECT COUNT(DISTINCT country) AS total_countries 
FROM global_house_purchase_dataset;

SELECT COUNT(DISTINCT city) AS total_cities 
FROM global_house_purchase_dataset;


/* 2. Purchase Decision Distribution */
SELECT decision, 
       COUNT(*) AS total_customers,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM global_house_purchase_dataset), 2) AS percentage
FROM global_house_purchase_dataset
GROUP BY decision;


/* 3. Average House Price by Country */
SELECT country, 
       AVG(CAST(price AS DECIMAL(18,2))) AS avg_price, 
       MAX(CAST(price AS DECIMAL(18,2))) AS max_price, 
       MIN(CAST(price AS DECIMAL(18,2))) AS min_price
FROM global_house_purchase_dataset
GROUP BY country
ORDER BY avg_price DESC;


/* 4. Average Price by Property Type */
SELECT property_type, 
       AVG(CAST(price AS DECIMAL(18,2))) AS avg_price, 
       COUNT(*) AS total_properties
FROM global_house_purchase_dataset
GROUP BY property_type
ORDER BY avg_price DESC;


/* 5. Affordability Index: Price-to-Salary Ratio by Country */
SELECT country, 
       ROUND(AVG(CAST(price AS DECIMAL(18,2))) / NULLIF(AVG(CAST(customer_salary AS DECIMAL(18,2))),0), 2) AS affordability_index,
       AVG(CAST(price AS DECIMAL(18,2))) AS avg_price, 
       AVG(CAST(customer_salary AS DECIMAL(18,2))) AS avg_income
FROM global_house_purchase_dataset
GROUP BY country
ORDER BY affordability_index;


/* 6. Effect of Furnishing Status on Purchase Decision */
SELECT furnishing_status, 
       AVG(CAST(decision AS DECIMAL(5,2))) AS purchase_probability, 
       COUNT(*) AS total_properties
FROM global_house_purchase_dataset
GROUP BY furnishing_status
ORDER BY purchase_probability DESC;


/* 7. EMI-to-Income Ratio Impact on Purchase */
SELECT CAST(emi_to_income_ratio AS DECIMAL(10,2)) AS emi_to_income_ratio, 
       ROUND(AVG(CAST(decision AS DECIMAL(5,2))), 2) AS purchase_probability, 
       COUNT(*) AS customers
FROM global_house_purchase_dataset
GROUP BY CAST(emi_to_income_ratio AS DECIMAL(10,2))
ORDER BY emi_to_income_ratio;


/* 8. Customer Salary vs Decision */
SELECT 
    CASE 
        WHEN customer_salary < 20000 THEN 'Low Income (<20K)'
        WHEN customer_salary BETWEEN 20000 AND 50000 THEN 'Middle Income (20K-50K)'
        WHEN customer_salary BETWEEN 50000 AND 100000 THEN 'Upper Middle Income (50K-100K)'
        ELSE 'High Income (>100K)'
    END AS income_group,
    AVG(CAST(decision AS DECIMAL(5,2))) AS purchase_probability,
    COUNT(*) AS customers
FROM global_house_purchase_dataset
GROUP BY 
    CASE 
        WHEN customer_salary < 20000 THEN 'Low Income (<20K)'
        WHEN customer_salary BETWEEN 20000 AND 50000 THEN 'Middle Income (20K-50K)'
        WHEN customer_salary BETWEEN 50000 AND 100000 THEN 'Upper Middle Income (50K-100K)'
        ELSE 'High Income (>100K)'
    END
ORDER BY purchase_probability DESC;


/* 9. Neighbourhood Rating vs Purchase Decision */
SELECT neighbourhood_rating, 
       ROUND(AVG(CAST(decision AS DECIMAL(5,2))),2) AS purchase_probability, 
       COUNT(*) AS customers
FROM global_house_purchase_dataset
GROUP BY neighbourhood_rating
ORDER BY neighbourhood_rating;


/* 10. Connectivity Score vs Purchase Decision */
SELECT connectivity_score, 
       ROUND(AVG(CAST(decision AS DECIMAL(5,2))),2) AS purchase_probability, 
       COUNT(*) AS customers
FROM global_house_purchase_dataset
GROUP BY connectivity_score
ORDER BY connectivity_score;


/* 11. Top Cities with Highest Avg Property Prices */
SELECT TOP 10 city, country, 
       AVG(CAST(price AS DECIMAL(18,2))) AS avg_price
FROM global_house_purchase_dataset
GROUP BY city, country
ORDER BY avg_price DESC;


/* 12. Correlation Check: Property Size vs Price (avg grouping) */
SELECT FLOOR(CAST(property_size_sqft AS BIGINT)/500.0)*500 AS size_group, 
       AVG(CAST(price AS DECIMAL(18,2))) AS avg_price, 
       AVG(CAST(decision AS DECIMAL(5,2))) AS purchase_probability
FROM global_house_purchase_dataset
GROUP BY FLOOR(CAST(property_size_sqft AS BIGINT)/500.0)*500
ORDER BY size_group;


/* 13. Crime & Legal Issues Impact on Purchase Decision */
SELECT 
    CASE WHEN crime_cases_reported > 50 THEN 'High Crime'
         WHEN crime_cases_reported BETWEEN 20 AND 50 THEN 'Medium Crime'
         ELSE 'Low Crime' END AS crime_level,
    ROUND(AVG(CAST(decision AS DECIMAL(5,2))),2) AS purchase_probability,
    COUNT(*) AS properties
FROM global_house_purchase_dataset
GROUP BY CASE WHEN crime_cases_reported > 50 THEN 'High Crime'
              WHEN crime_cases_reported BETWEEN 20 AND 50 THEN 'Medium Crime'
              ELSE 'Low Crime' END
ORDER BY purchase_probability;

SELECT 
    CASE WHEN legal_cases_on_property > 0 THEN 'Legal Issues'
         ELSE 'No Legal Issues' END AS legal_status,
    ROUND(AVG(CAST(decision AS DECIMAL(5,2))),2) AS purchase_probability,
    COUNT(*) AS properties
FROM global_house_purchase_dataset
GROUP BY CASE WHEN legal_cases_on_property > 0 THEN 'Legal Issues'
              ELSE 'No Legal Issues' END;


/* 14. Customer Satisfaction Score Impact */
SELECT satisfaction_score, 
       AVG(CAST(decision AS DECIMAL(5,2))) AS purchase_probability, 
       COUNT(*) AS customers
FROM global_house_purchase_dataset
GROUP BY satisfaction_score
ORDER BY satisfaction_score DESC;


/* 15. Final KPI Dashboard View (for visualization tools) */
SELECT country, 
       COUNT(*) AS total_properties,
       ROUND(AVG(CAST(price AS DECIMAL(18,2))),0) AS avg_price,
       ROUND(AVG(CAST(customer_salary AS DECIMAL(18,2))),0) AS avg_income,
       ROUND(AVG(CAST(decision AS DECIMAL(5,2)))*100,2) AS purchase_rate_percent,
       ROUND(AVG(CAST(neighbourhood_rating AS DECIMAL(5,2))),1) AS avg_neighbourhood_rating,
       ROUND(AVG(CAST(connectivity_score AS DECIMAL(5,2))),1) AS avg_connectivity_score
FROM global_house_purchase_dataset
GROUP BY country
ORDER BY purchase_rate_percent DESC;


/* 16. Top 10 Cities with Highest Avg Price */
SELECT TOP 10
    city,
    ROUND(AVG(CAST(price AS DECIMAL(18,2))), 0) AS avg_price
FROM global_house_purchase_dataset
GROUP BY city
ORDER BY avg_price DESC;
