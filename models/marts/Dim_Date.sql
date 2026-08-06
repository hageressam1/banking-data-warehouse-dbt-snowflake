{{ config(materialized='table') }}

WITH date_range AS (
    SELECT 
        DATEADD(day, seq4(), (SELECT MIN(CAST(TRANSACTION_DATE AS date)) 
                               FROM {{ ref('STG_BANKING_TRANSACTIONS') }})) AS FULL_DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 365*3))  
)

SELECT
    TO_NUMBER(TO_CHAR(FULL_DATE,'YYYYMMDD')) AS DATE_KEY,
    FULL_DATE,
    EXTRACT(year FROM FULL_DATE) AS YEAR,
    EXTRACT(day FROM FULL_DATE) AS DAY,
    TO_CHAR(FULL_DATE,'Month') AS MONTH_NAME,
    EXTRACT(quarter FROM FULL_DATE) AS QUARTER,
    CASE EXTRACT(DAYOFWEEK_ISO FROM FULL_DATE)
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS WEEKDAY
FROM date_range