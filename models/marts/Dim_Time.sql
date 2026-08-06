{{ config(materialized='table') }}

WITH times AS (
    SELECT seq4() AS hour
    FROM TABLE(GENERATOR(ROWCOUNT => 24))
), minutes AS (
    SELECT seq4() AS minute
    FROM TABLE(GENERATOR(ROWCOUNT => 60))
)

SELECT
    (hour * 100 + minute) AS TIME_KEY,  -- ثابت لكل ساعة ودقيقة
    hour,
    minute,
    LPAD(hour::VARCHAR,2,'0') || ':' || LPAD(minute::VARCHAR,2,'0') AS FULL_TIME

FROM times
CROSS JOIN minutes
ORDER BY hour, minute
