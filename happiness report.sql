-- DATA CLEANING

-- Checking for duplicates 
SELECT happiness_rank, COUNT(*) AS duplicate_count
FROM dbo.[2015]
GROUP BY happiness_rank
HAVING COUNT(*) > 1 

SELECT gdp, COUNT(*) AS duplicate_count
FROM dbo.[2015]
GROUP BY gdp
HAVING COUNT(*) > 1 

SELECT happiness_score, COUNT(*) AS duplicate_count
FROM dbo.[2015]
GROUP BY happiness_score
HAVING COUNT(*) > 1 

-- It was found that two countries have tied for happiness rank 82 by having the same happiness score of 5.192. No duplicates were found.

-- Checking for missing data

SELECT *
FROM dbo.[2015]
WHERE happiness_rank IS NULL

-- No null values were found 

-- Deleting unnecessary columns 
ALTER TABLE dbo.[2015]
DROP COLUMN standard_error

ALTER TABLE dbo.[2015]
DROP COLUMN dystopia_residual

-- Confirm alterations

SELECT *
FROM dbo.[2015]

--Converting the happiness measures from varchar to float 
ALTER TABLE dbo.[2015]
ALTER COLUMN happiness_rank float;

ALTER TABLE dbo.[2015]
ALTER COLUMN happiness_score float;

ALTER TABLE dbo.[2015]
ALTER COLUMN gdp float;

ALTER TABLE dbo.[2015]
ALTER COLUMN family float;

ALTER TABLE dbo.[2015]
ALTER COLUMN life_expectancy float;

ALTER TABLE dbo.[2015]
ALTER COLUMN freedom float;

ALTER TABLE dbo.[2015]
ALTER COLUMN absence_of_corruption float;

ALTER TABLE dbo.[2015]
ALTER COLUMN generosity float;


--DATA ANALYSIS

--Top 10 happiest countries 
SELECT TOP 10 *
FROM DBO.[2015]

/*
1. Switzerland
2. Iceland
3. Denmark
4. Norway
5. Canada
6. Finland
7. Netherlands
8. Sweden
9. New Zealand
10.Australia */
 
-- 7 out of the top 10 happiest countries come are Western European.

-- Mean Happiness metrics for Top 10 happiest countries
WITH top_10_happiest AS
(
SELECT TOP 10 *
FROM DBO.[2015]
)
SELECT ROUND(AVG(happiness_score),2) AS avg_happiness, ROUND(AVG(gdp),2) AS avg_gdp, ROUND(AVG(family),2) AS avg_family, ROUND(AVG(life_expectancy),2) AS avg_life_expectancy, ROUND(AVG(freedom),2) AS avg_freedom, ROUND(AVG(absence_of_corruption),2) AS avg_gov_corruption, ROUND(AVG(generosity),2) AS avg_generosity
FROM top_10_happiest

-- Top 10 least happiest countries 
SELECT TOP 10*
FROM dbo.[2015]
ORDER BY happiness_score 

/* 
1. Togo
2. Burundi
3. Syria
4. Benin
5. Rwanda
6. Afghanistan
7. Burkina Faso
8. Ivory Coast
9. Guinea
10 Chad */

-- 8 out of 10 of the countries are Sub-Saharan countries,  including the top 2; Togo and Burundi.The other two countries are Syria and Afghanistan. 

-- Mean Happiness metrics for Top 10 unhappiest countries
WITH top_10_unhappiest AS
(
SELECT TOP 10 *
FROM DBO.[2015]
ORDER BY happiness_score 
)
SELECT ROUND(AVG(happiness_score),2) AS avg_happiness, ROUND(AVG(gdp),2) AS avg_gdp, ROUND(AVG(family),2) AS avg_family, ROUND(AVG(life_expectancy),2) AS avg_life_expectancy, ROUND(AVG(freedom),2) AS avg_freedom, ROUND(AVG(absence_of_corruption),2) AS avg_gov_corruption, ROUND(AVG(generosity),2) AS avg_generosity
FROM top_10_unhappiest

-- Mean Happiness score and ratings per region
SELECT region, ROUND(AVG(happiness_score),2) AS avg_happiness_score, ROUND(AVG(gdp),2) AS avg_gdp, ROUND(AVG(life_expectancy),2) AS avg_life_expectancy, ROUND(AVG(freedom),2) AS avg_freedom, ROUND(AVG(absence_of_corruption),2) AS avg_corruption, ROUND(AVG(generosity),2) AS avg_generosity
FROM dbo.[2015]
GROUP BY region
ORDER BY avg_happiness_score DESC

-- Based on the Averages Australia & New Zealand is the region with the highest happiest score and highest values for all other metrics and Sub-Saharan Africa the lowest 
--Australia and New Zealand and Sub-Saharan Africa the least happiest.


