-- Creating a new table for my tuberculosis analysis
CREATE TABLE tuberculosis_data (
    country_name VARCHAR(150),
    iso2_code CHAR(2),
    iso3_code CHAR(3),
    iso_numeric_code INTEGER,
    region VARCHAR(100),
    year INTEGER,

    estimated_population BIGINT,

    prevalence_per_100k NUMERIC(10,2),
    prevalence_per_100k_low NUMERIC(10,2),
    prevalence_per_100k_high NUMERIC(10,2),

    prevalence_cases NUMERIC(10,2),
    prevalence_cases_low NUMERIC(10,2),
    prevalence_cases_high NUMERIC(10,2),

    prevalence_estimation_method VARCHAR(100),

    mortality_per_100k NUMERIC(10,2),
    mortality_per_100k_low NUMERIC(10,2),
    mortality_per_100k_high NUMERIC(10,2),

    mortality_deaths NUMERIC(10,2),
    mortality_deaths_low NUMERIC(10,2),
    mortality_deaths_high NUMERIC(10,2),

    hiv_tb_mortality_per_100k NUMERIC(10,2),
    hiv_tb_mortality_per_100k_low NUMERIC(10,2),
    hiv_tb_mortality_per_100k_high NUMERIC(10,2),

    hiv_tb_deaths NUMERIC(10,2),
    hiv_tb_deaths_low NUMERIC(10,2),
    hiv_tb_deaths_high NUMERIC(10,2),

    mortality_estimation_method VARCHAR(100),

    incidence_per_100k NUMERIC(10,2),
    incidence_per_100k_low NUMERIC(10,2),
    incidence_per_100k_high NUMERIC(10,2),

    incident_cases NUMERIC(10,2),
    incident_cases_low NUMERIC(10,2),
    incident_cases_high NUMERIC(10,2),

    incidence_estimation_method VARCHAR(100),

    hiv_in_incident_tb_percent NUMERIC(5,2),
    hiv_in_incident_tb_percent_low NUMERIC(5,2),
    hiv_in_incident_tb_percent_high NUMERIC(5,2),

    hiv_tb_incidence_per_100k NUMERIC(10,2),
    hiv_tb_incidence_per_100k_low NUMERIC(10,2),
    hiv_tb_incidence_per_100k_high NUMERIC(10,2),

    hiv_tb_incident_cases NUMERIC(10,2),
    hiv_tb_incident_cases_low NUMERIC(10,2),
    hiv_tb_incident_cases_high NUMERIC(10,2),

    tbhiv_estimation_method VARCHAR(100),

    case_detection_rate_percent NUMERIC(5,2),
    case_detection_rate_percent_low NUMERIC(5,2),
    case_detection_rate_percent_high NUMERIC(5,2)
);

-- DROP TABLE tuberculosis_data;
copy tuberculosis_data FROM 'C:/Users/HP/Downloads/TB_Burden_Country.csv' WITH (FORMAT CSV, HEADER TRUE);

-- DATA CLEANING SECTION
-- REMOVE DUPLICATE VALUES
-- DATA STANDARDIZATION
-- FILLING OR REMOVING NULL VALUES
-- EXPLORATORY DATA ANALYSIS


-- SEARCH FOR DUPLICATE VALUES
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY country_name,
    iso2_code ,
    iso3_code,
    iso_numeric_code,
    region,
    year,
    estimated_population,
    prevalence_per_100k,
    prevalence_per_100k_low,
    prevalence_per_100k_high,
    prevalence_cases,
    prevalence_cases_low,
    prevalence_cases_high,
    prevalence_estimation_method,
    mortality_per_100k,
    mortality_per_100k_low,
    mortality_per_100k_high,
    mortality_deaths,
    mortality_deaths_low,
    mortality_deaths_high,
    hiv_tb_mortality_per_100k,
    hiv_tb_mortality_per_100k_low,
    hiv_tb_mortality_per_100k_high,
    hiv_tb_deaths,
    hiv_tb_deaths_low,
    hiv_tb_deaths_high,
    mortality_estimation_method,
    incidence_per_100k,
    incidence_per_100k_low,
    incidence_per_100k_high,
    incident_cases,
    incident_cases_low,
    incident_cases_high,
    incidence_estimation_method,
    hiv_in_incident_tb_percent,
    hiv_in_incident_tb_percent_low,
    hiv_in_incident_tb_percent_high,
    hiv_tb_incidence_per_100k,
    hiv_tb_incidence_per_100k_low,
    hiv_tb_incidence_per_100k_high,
    hiv_tb_incident_cases,
    hiv_tb_incident_cases_low,
    hiv_tb_incident_cases_high,
    tbhiv_estimation_method,
    case_detection_rate_percent,
    case_detection_rate_percent_low,
    case_detection_rate_percent_high 
	ORDER BY country_name) AS row_num
FROM tuberculosis_data
ORDER BY row_num DESC; -- RESULT SHOW THAT THERE IS NO DUPLICATE VALUE.

-- CREATE A COPY OF THE TUBERCULOSIS TABLE
CREATE TABLE tuberculosis_dataa (
	LIKE tuberculosis_data INCLUDING ALL
)

ALTER TABLE tuberculosis_dataa
ADD COLUMN row_num INTEGER;

-- COPY ALL INFORMATION IN tuberculosis_data INTO tuberculosis_data1 
INSERT INTO tuberculosis_dataa
SELECT *
FROM tuberculosis_data;


-- STANDARDIZING THE country_name COLUMN
SELECT TRIM(country_name)
FROM tuberculosis_dataa
WHERE country_name LIKE 'INDonesia%'

UPDATE tuberculosis_dataa
SET country_name = CASE 
						WHEN country_name LIKE '%Bolivia%' THEN 'Bolivia'
						WHEN country_name LIKE '%Serbia%' THEN 'Serbia' 
						WHEN country_name LIKE '%China%' THEN 'China' 
						WHEN country_name LIKE '%Trinidad%' THEN 'Trinidad' 
						WHEN country_name LIKE '%macedonia%' THEN 'Macedonia' 
						WHEN country_name LIKE '%venezuela%' THEN 'Venezuela' 
						WHEN country_name LIKE '%korea%' THEN 'Republic of Korea' 
						WHEN country_name LIKE '%congo%' THEN 'DRC. Congo' 
						WHEN country_name LIKE '%United Kingdom%' THEN 'United Kingdom' 
						WHEN country_name LIKE '%Iran%' THEN 'Iran' 
						ELSE country_name 
					END;

-- STANDARDIZING THE REGION COLUMN
UPDATE tuberculosis_dataa
SET region = CASE 
					WHEN region = 'SEA' THEN 'South-East Asia'
					WHEN region = 'AFR' THEN 'Africa' 
					WHEN region = 'AMR' THEN 'America'
					WHEN region = 'EUR' THEN 'Europe'
					WHEN region = 'EMR' THEN  'Eastern Mediterranean' 
					WHEN region = 'WPR' THEN 'Western Pacific'
					ELSE region 
			END;     

-- STANDARDIZING THE hiv_tb_mortality_per_100k_low COLUMN

-- TO FIND OUT THE average VALUE OF THE hiv_tb_mortality_per_100k_low

-- NEXT IS TO FILL THE NULL VALUES IN THE hiv_tb_mortality_per_100k_low COLUMN
UPDATE tuberculosis_dataa
SET hiv_tb_mortality_per_100k_low = 
									(SELECT 
										AVG(hiv_tb_mortality_per_100k_low)
									FROM tuberculosis_dataa
									WHERE hiv_tb_mortality_per_100k_low IS NOT NULL)
WHERE hiv_tb_mortality_per_100k_low IS NULL;


-- STANDARDIZING THE hiv_tb_mortality_per_100k_high column

-- TO FIND OUT THE MEDIAN VALUE OF THE hiv_tb_mortality_per_100k_high

UPDATE tuberculosis_dataa
SET hiv_tb_mortality_per_100k_high = 
									(SELECT 
										AVG(hiv_tb_mortality_per_100k_high)
									FROM tuberculosis_dataa
									WHERE hiv_tb_mortality_per_100k_high IS NOT NULL)
WHERE hiv_tb_mortality_per_100k_high IS NULL;

-- STANDARDIZING THE hiv_tb_deaths_low USING THE AVERAGE OF THE COLUMN
UPDATE tuberculosis_dataa
SET hiv_tb_deaths = 
									(SELECT 
										AVG(hiv_tb_deaths)
									FROM tuberculosis_dataa
									WHERE hiv_tb_deaths IS NOT NULL)
WHERE hiv_tb_deaths IS NULL;


-- STANDARDIZING THE hiv_tb_deaths_low USING THE AVERAGE OF THE COLUMN
UPDATE tuberculosis_dataa
SET hiv_tb_deaths = 
									(SELECT 
										AVG(hiv_tb_deaths)
									FROM tuberculosis_dataa
									WHERE hiv_tb_deaths IS NOT NULL)
WHERE hiv_tb_deaths IS NULL;


-- FINDING THE MEDIAN VALUE FOR hiv_tb_deaths_low COLUMN
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY hiv_tb_deaths_low)
FROM tuberculosis_dataa
WHERE hiv_tb_deaths_low IS NOT NULL;-- 69 is the median value

-- UPDATING THE MEDIAN VALUE OF THE COLUMN
UPDATE tuberculosis_dataa 
SET hiv_tb_deaths_low = COALESCE(hiv_tb_deaths_low,69);

-- FINDING THE MEDIAN VALUE FOR hiv_tb_deaths_high COLUMN
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY hiv_tb_deaths_high)
FROM tuberculosis_dataa
WHERE hiv_tb_deaths_high IS NOT NULL; --150 is the median value

-- UPDATING THE MEDIAN VALUE OF THE COLUMN
UPDATE tuberculosis_dataa 
SET hiv_tb_deaths_high = COALESCE(hiv_tb_deaths_high,150);


SELECT *
FROM tuberculosis_dataa
-- WHERE hiv_tb_mortality_per_100k_high is null;

-- UPDATING THE MEDIAN VALUE OF THE hiv_in_incident_tb_percent COLUMN
UPDATE tuberculosis_dataa 
SET hiv_in_incident_tb_percent = (SELECT 
										AVG(hiv_in_incident_tb_percent)
									FROM tuberculosis_dataa
									WHERE hiv_in_incident_tb_percent IS NOT NULL)
WHERE hiv_in_incident_tb_percent IS NULL;

-- DROPPING THE tbhiv_estimation_method COLUMN BECAUSE IT IS ALL NULL
ALTER TABLE tuberculosis_dataa
DROP COLUMN tbhiv_estimation_method


-- dropping the row num column
ALTER TABLE tuberculosis_dataa
DROP COLUMN row_num
WHERE tbhiv_estimation_method IS NULL

-- updating the prevalence_per_100k_high null values with the average of the column
	UPDATE tuberculosis_dataa 
SET prevalence_per_100k_high = (SELECT 
										AVG(prevalence_per_100k_high)
									FROM tuberculosis_dataa
									WHERE prevalence_per_100k_high IS NOT NULL)
WHERE prevalence_per_100k_high IS NULL;


-- updating the prevalence_per_100k_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET prevalence_per_100k_low = (SELECT 
										AVG(prevalence_per_100k_low)
									FROM tuberculosis_dataa
									WHERE prevalence_per_100k_low IS NOT NULL)
WHERE prevalence_per_100k_low IS NULL;

-- updating the prevalence_cases_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET prevalence_cases_high = (SELECT 
									AVG(prevalence_cases_high)
							FROM tuberculosis_dataa
							WHERE prevalence_cases_high IS NOT NULL)
WHERE prevalence_cases_high IS NULL;

-- updating the incidence_per_100k_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET incidence_per_100k_low = (SELECT 
									AVG(incidence_per_100k_low)
							FROM tuberculosis_dataa
							WHERE incidence_per_100k_low IS NOT NULL)
WHERE incidence_per_100k_low IS NULL;

-- updating the incidence_per_100k_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET incidence_per_100k_high = (SELECT 
									AVG(incidence_per_100k_high)
							FROM tuberculosis_dataa
							WHERE incidence_per_100k_high IS NOT NULL)
WHERE incidence_per_100k_high IS NULL;

-- updating the incident_cases_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET incident_cases_low = (SELECT 
									AVG(incident_cases_low)
							FROM tuberculosis_dataa
							WHERE incident_cases_low IS NOT NULL)
WHERE incident_cases_low IS NULL;

-- updating the incident_cases_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET incident_cases_high = (SELECT 
									AVG(incident_cases_high)
							FROM tuberculosis_dataa
							WHERE incident_cases_high IS NOT NULL)
WHERE incident_cases_high IS NULL;

-- updating the hiv_in_incident_tb_percent_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_in_incident_tb_percent_low = (SELECT 
									AVG(hiv_in_incident_tb_percent_low)
							FROM tuberculosis_dataa
							WHERE hiv_in_incident_tb_percent_low IS NOT NULL)
WHERE hiv_in_incident_tb_percent_low IS NULL;

-- updating the hiv_in_incident_tb_percent_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_in_incident_tb_percent_high = (SELECT 
									AVG(hiv_in_incident_tb_percent_high)
							FROM tuberculosis_dataa
							WHERE hiv_in_incident_tb_percent_high IS NOT NULL)
WHERE hiv_in_incident_tb_percent_high IS NULL;


-- updating the hiv_tb-incidence_per_100k null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incidence_per_100k = (SELECT 
									AVG(hiv_tb_incidence_per_100k)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incidence_per_100k IS NOT NULL)
WHERE hiv_tb_incidence_per_100k IS NULL;

-- updating the hiv_tb_incidence_per_100k_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incidence_per_100k_low = (SELECT 
									AVG(hiv_tb_incidence_per_100k_low)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incidence_per_100k_low IS NOT NULL)
WHERE hiv_tb_incidence_per_100k_low IS NULL;

-- updating the hiv_tb_incidence_per_100k_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incidence_per_100k_high = (SELECT 
									AVG(hiv_tb_incidence_per_100k_high)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incidence_per_100k_high IS NOT NULL)
WHERE hiv_tb_incidence_per_100k_high IS NULL;


-- updating the hiv_tb_incident_cases null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incident_cases = (SELECT 
									AVG(hiv_tb_incident_cases)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incident_cases IS NOT NULL)
WHERE hiv_tb_incident_cases IS NULL;


-- updating the hiv_tb_incident_cases_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incident_cases_low = (SELECT 
									AVG(hiv_tb_incident_cases_low)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incident_cases_low IS NOT NULL)
WHERE hiv_tb_incident_cases_low IS NULL;


-- updating the hiv_tb_incident_cases_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET hiv_tb_incident_cases_high = (SELECT 
									AVG(hiv_tb_incident_cases_high)
							FROM tuberculosis_dataa
							WHERE hiv_tb_incident_cases_high IS NOT NULL)
WHERE hiv_tb_incident_cases_high IS NULL;

-- FINDING THE MEDIAN VALUE FOR hiv_tb_deaths_high COLUMN
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY case_detection_rate_percent_high)
FROM tuberculosis_dataa
WHERE case_detection_rate_percent_high IS NOT NULL

-- updating the case_detection_rate_percent null values with the average of the column
UPDATE tuberculosis_dataa 
SET case_detection_rate_percent = (SELECT 
									AVG(case_detection_rate_percent)
							FROM tuberculosis_dataa
							WHERE case_detection_rate_percent IS NOT NULL)
WHERE case_detection_rate_percent IS NULL;


-- updating the case_detection_rate_percent_low null values with the average of the column
UPDATE tuberculosis_dataa 
SET case_detection_rate_percent_low = (SELECT 
									AVG(case_detection_rate_percent_low)
							FROM tuberculosis_dataa
							WHERE case_detection_rate_percent_low IS NOT NULL)
WHERE case_detection_rate_percent_low IS NULL;


-- updating the case_detection_rate_percent_high null values with the average of the column
UPDATE tuberculosis_dataa 
SET case_detection_rate_percent_high = (SELECT 
									AVG(case_detection_rate_percent_high)
							FROM tuberculosis_dataa
							WHERE case_detection_rate_percent_high IS NOT NULL)
WHERE case_detection_rate_percent_high IS NULL;


-- EXPLORATORY DATA ANALYSIS

-- Disease burden
-- Which countries have the highest TB prevalence?
-- Which countries have the lowest TB prevalence?
-- Which regions carry the highest TB burden?
-- How has TB prevalence changed over time?
-- Which countries have experienced the greatest decline in TB prevalence?

-- Which countries have the highest TB prevalence?
SELECT country_name, 
	ROUND(AVG(prevalence_cases),0) AS avg_tb_cases
FROM tuberculosis_dataa
GROUP BY country_name 
ORDER BY avg_tb_cases DESC
LIMIT 100; -- INDIA HAS THE HIGHEST TB PREVALENCE ACCORDING TO THE DATA
-- with more over 4m cases.

-- Which countries have the lowest TB prevalence?
SELECT country_name, 
	ROUND(AVG(prevalence_cases),0) AS avg_tb_cases
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_tb_cases 
LIMIT 2; -- Bonaire, Saint Eustatius and Saba, and tokelau has zero 
-- incidence of tb prevalence

-- Which regions carry the highest TB burden on average?
SELECT region, 
	 ROUND(AVG(prevalence_per_100k),0) AS Avg_tb_burden
FROM tuberculosis_dataa
GROUP BY region
ORDER BY Avg_tb_burden DESC; -- SOUTH-EAST ASIAN REGION HAVE THE HIGHEST TB BURDEN ON AVERAGE

-- How has TB prevalence changed over time?
SELECT year,
	ROUND(AVG(prevalence_per_100k),0) AS avg_prevalence_per_100k
FROM tuberculosis_dataa
GROUP BY year
ORDER BY year;

SELECT *
FROM tuberculosis_dataa
-- Which TOP 10 countries have experienced the 
-- greatest decline in TB prevalence?

WITH tb_trends AS (
    SELECT
        country_name,
        MAX(CASE WHEN year = (SELECT MIN(year) FROM tuberculosis_dataa) 
		THEN prevalence_per_100k END) AS start_prevalence,
        MAX(CASE WHEN year = (SELECT MAX(year) FROM tuberculosis_dataa) 
		THEN prevalence_per_100k END) AS end_prevalence
    FROM tuberculosis_dataa
    GROUP BY country_name
)

SELECT
    country_name,
    start_prevalence,
    end_prevalence,
    ROUND(start_prevalence - end_prevalence, 2) AS decline,
    ROUND(
        ((start_prevalence - end_prevalence) / start_prevalence) * 100,
        2
    ) AS percent_decline
FROM tb_trends
WHERE start_prevalence IS NOT NULL
  AND end_prevalence IS NOT NULL
  AND end_prevalence < start_prevalence
ORDER BY percent_decline DESC
LIMIT 10; 

-- Incidence analysis
-- Which countries report the highest incidence rates?
-- Which regions have the greatest number of new TB cases?
-- Is TB incidence increasing or decreasing over time?
-- Which countries consistently record high incidence rates?

-- Which countries report the highest incidence rates?
SELECT country_name,
	ROUND(AVG(incidence_per_100k),2) AS avg_rate_of_incidence
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_rate_of_incidence DESC;-- Namibia recorded the highest incidence rate 

-- What year report the highest incidence rates on average?
SELECT year,
	ROUND(AVG(incidence_per_100k),2) AS avg_rate_of_incidence
FROM tuberculosis_dataa
GROUP BY year
ORDER BY avg_rate_of_incidence DESC; -- 2002 HAS THE HIGHEST AVERAGE INCIDENCE RATE


-- Which regions have the greatest number of new TB cases?
SELECT region,
	ROUND(AVG(incident_cases),0) AS avg_incident_cases
FROM tuberculosis_dataa
GROUP BY region
ORDER BY avg_incident_cases DESC; -- SOUTH-EAST ASIA HAS THE HIGHEST INCIDENT CASES OF NEW TB CASES

-- Is TB incidence increasing or decreasing over time?
SELECT 
	year,
	ROUND(AVG(incidence_per_100k),0) AS avg_incident_rate,
	CASE 
		WHEN ROUND(AVG(incidence_per_100k),0) > LAG(ROUND(AVG(incidence_per_100k),0)) OVER(ORDER BY year) THEN 'Increasing'
		WHEN ROUND(AVG(incidence_per_100k),0) < LAG(ROUND(AVG(incidence_per_100k),0)) OVER(ORDER BY year) THEN 'Decreasing'
	ELSE 'No Change'
	END AS trend_change
FROM tuberculosis_dataa
GROUP BY year
ORDER BY year;

-- Which countries consistently record high incidence rates?
WITH trend_analysis AS (
	SELECT 
	country_name,
	ROUND(AVG(incidence_per_100k),0) AS avg_incident_rate,
	CASE 
		WHEN ROUND(AVG(incidence_per_100k),0) > LAG(ROUND(AVG(incidence_per_100k),0)) OVER(ORDER BY year) THEN 'Increasing'
		WHEN ROUND(AVG(incidence_per_100k),0) < LAG(ROUND(AVG(incidence_per_100k),0)) OVER(ORDER BY year) THEN 'Decreasing'
	ELSE 'No Change'
	END AS trend_change
FROM tuberculosis_dataa
-- WHERE trend_change IN ('Increasing')
GROUP BY country_name, year
	)
SELECT *
FROM trend_analysis
WHERE trend_change = 'Increasing'
ORDER BY avg_incident_rate
ORDER BY country_name;

-- Mortality analysis
-- Which countries have the highest TB mortality?
-- Which regions account for the largest number of TB deaths?
-- How has TB mortality changed over time?
-- Are mortality rates declining in high-burden countries?

-- Which countries have the highest TB mortality?
SELECT country_name,
	ROUND(AVG(mortality_per_100k),2) AS avg_mortality
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_mortality DESC
LIMIT 100; -- CENTRAL AFRICAN REPUBLIC HAS THE HIGHEST TB MORTALITY ON AVERAGE

-- Which regions account for the largest number of TB deaths?
SELECT region,
	ROUND(AVG(mortality_deaths), 2) AS avg_mortality
FROM tuberculosis_dataa
GROUP BY region
ORDER BY avg_mortality DESC; -- SOUTH-EAST ASIA IS THE ONLY REGION WITH THE HIGHEST NUMBER OF TB DEATHS

-- How has TB mortality changed over time?
SELECT year,
		ROUND(AVG(mortality_deaths),1) AS avg_mortality 
FROM tuberculosis_dataa
GROUP BY year
ORDER BY year;

-- Are mortality rates declining in high-burden countries?
WITH country_stats AS (
    SELECT
        country_name,
        AVG(incidence_per_100k) OVER (PARTITION BY country_name) AS avg_incidence,

        FIRST_VALUE(mortality_deaths) OVER (
            PARTITION BY country_name
            ORDER BY year
        ) AS first_mortality,

        FIRST_VALUE(mortality_deaths) OVER (
            PARTITION BY country_name
            ORDER BY year DESC
        ) AS last_mortality
    FROM tuberculosis_dataa
)

SELECT DISTINCT
    country_name,
    ROUND(avg_incidence,2) AS avg_incidence,
    first_mortality,
    last_mortality,
    CASE
        WHEN last_mortality < first_mortality THEN 'Declining'
        WHEN last_mortality > first_mortality THEN 'Increasing'
        ELSE 'No Change'
    END AS mortality_trend
FROM country_stats
ORDER BY avg_incidence DESC
LIMIT 20;

-- WITH high_burden AS (
-- SELECT 
--  	country_name,
-- 	AVG(incidence_per_100k) AS avg_incidence
-- FROM tuberculosis_dataa
-- GROUP BY country_name
-- ),
-- mortality_trend AS (
-- SELECT 
-- 		country_name,
-- 		mortality_deaths,
-- 		LAG(mortality_deaths) OVER(PARTITION BY country_name ORDER BY year) AS previous_year
-- FROM tuberculosis_dataa
-- 	)
-- SELECT 
-- 	h.country_name,
-- 	m.mortality_deaths,
-- 	ROUND(h.avg_incidence,2) AS avg_incidence,
-- 	CASE 
-- 		WHEN m.mortality_deaths < m.previous_year THEN 'decreasing'
-- 		WHEN m.mortality_deaths > m.previous_year THEN 'increasing'
-- 	ELSE 'No Change'
-- 	END AS death_trend
-- FROM mortality_trend m
-- JOIN high_burden h
-- ON m.country_name = h.country_name
-- ORDER BY avg_incidence DESC
-- LIMIT 100;

-- HIV and TB relationship
-- Which countries have the highest percentage of HIV among incident TB cases?
-- How many TB deaths occur among people living with HIV?
-- Which regions have the greatest TB/HIV burden?
-- Is HIV strongly associated with higher TB mortality?

-- Which countries have the highest percentage of HIV among incident TB cases?
SELECT 
	country_name, 
	ROUND(AVG(hiv_in_incident_tb_percent), 2) AS avg_hiv_in_incident_tbPercent
FROM tuberculosis_dataa
GROUP BY 1
ORDER BY 2 DESC; -- ZIMBABWE HAS THE HIGHEST PERCENTAGE OF HIV AMONG INCIDENT TB CASES

-- How many TB deaths occur among people living with HIV per country?
SELECT 
	country_name, 
	ROUND(SUM(hiv_tb_deaths),0) AS total_tbDeaths
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY total_tbDeaths DESC;
-- 1.3m+ TB deaths occur among people living with HIV in Nigeria which registers as the highest, followed by SA with 1.2m

-- Which regions have the greatest TB/HIV burden?
SELECT 
	region, 
	ROUND(AVG(hiv_tb_incidence_per_100k),1) AS avg_hiv_tb_incidence
FROM tuberculosis_dataa
GROUP BY region
ORDER BY avg_hiv_tb_incidence DESC; 
-- Africa has the highest TB/HIV burden of 124.1 on average.

-- Is HIV strongly associated with higher TB mortality? 
-- TO ANSWER THIS QUESTION, WE ARE GOING TO CHECK THE CORRELATION between HIV prevalence among TB cases and TB mortality rate
SELECT 
	CORR(hiv_in_incident_tb_percent, mortality_per_100k) AS correlation_coeff_
FROM tuberculosis_dataa
WHERE hiv_in_incident_tb_percent IS NOT NULL
AND mortality_per_100k IS NOT NULL; -- Result is 0.22 which shows a weak positive relationship dictating 
-- the fact that there is a little relationship between HIV prevalence among TB cases and TB mortality rate. thus, HIV is not strongly associated
-- with TB deaths

-- Case detection
-- Which countries have the highest case detection rates?
-- Which countries have poor TB detection?
-- Has case detection improved over time?
-- Is higher case detection associated with lower mortality?

-- Which countries have the highest case detection rates?
SELECT 
		country_name,
		ROUND(AVG(case_detection_rate_percent),1) AS avg_case_detection_rate 
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_case_detection_rate DESC
LIMIT 100;

-- Which countries have poor TB detection
SELECT 
		country_name,
		ROUND(AVG(case_detection_rate_percent),1) AS avg_case_detection_rate 
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_case_detection_rate 
LIMIT 100; -- Nigeria has the poorest TB detection rate in the world

-- Has case detection improved over time?
SELECT 
	year, 
	ROUND(AVG(case_detection_rate_percent),1) AS avg_case_detection_rate
FROM tuberculosis_dataa
GROUP BY year
ORDER BY year;-- THE AVERAGE DETECTION RATE INCREASED OVER THE YEARS SIGNIFYING THAT IT ACTUALLY IMPROVED OVER THE YEARS

-- Is higher case detection associated with lower mortality?
SELECT 
	CORR(case_detection_rate_percent, mortality_per_100k) AS corr_analysis
FROM tuberculosis_dataa; -- the result is -0.54 which signifies that there's no relationship between higher case detection and lower mortality. 
-- in other words, it shows that higher case detection only support higher mortality

-- Population-adjusted analysis

-- Which countries have the highest TB burden relative to population?
-- Which countries contribute the most TB cases globally?
-- Which large-population countries have unusually low TB rates?

-- Which countries have the highest TB burden relative to population?
SELECT 
	country_name, 
	ROUND(AVG(prevalence_per_100k),1) AS avg_prevalence
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY avg_prevalence DESC; -- cambodia have the highest TB burden relative to population with over 1360.4 on average.

-- Which countries contribute the most TB cases globally?
SELECT 
	country_name, 
	ROUND(AVG((incidence_per_100k * estimated_population) / 100000),0) AS estimated_tb_cases 
FROM tuberculosis_dataa
GROUP BY country_name
ORDER BY estimated_tb_cases DESC
LIMIT 10; -- India is the country with the one that contributed the most to TB cases globally with over 2.1m cases.

-- Which large-population countries have unusually low TB rates?
WITH large_population AS (
SELECT country_name AS country,
	ROUND(AVG(estimated_population),0) AS total_population
FROM tuberculosis_dataa
WHERE estimated_population >= 10000000 
GROUP BY country_name -- the average population in the dataset is 2.9m, so i estimate a large population as population >= 10m
),
low_tb AS (
SELECT 
	country_name AS country,
	ROUND(AVG(incidence_per_100k),0) AS avg_tb_rates
FROM tuberculosis_dataa -- unusually low TB rate would be rates below the average which is 134.7 approximately
WHERE incidence_per_100k <= 134.7
GROUP BY country_name
	)

SELECT 
	lp.country,
	lp.total_population,
	lt.avg_tb_rates
FROM large_population lp
JOIN low_tb lt
ON lp.country = lt.country
ORDER BY lt.avg_tb_rates
LIMIT 20; -- Australia, and Canada has the lowest tb rates among countries with the most unusally low tb rates at 6% each, 
-- followed by US, at 7%, Italy and Greece at 8% respectively, amongst others, etc 
	
