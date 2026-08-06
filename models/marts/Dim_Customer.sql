{{ config(materialized='table', unique_key='customer_key') }}

-- This CTE selects only the current versions from the snapshot (dbt_valid_to IS NULL),
-- but it's currently not used in the dimension query, so it has no effect.
-- Can be removed if not needed.
WITH latest_snapshot AS (
    SELECT *
    FROM {{ ref('customer_snapshot') }}  
    WHERE dbt_valid_to IS NULL
),

dim_with_key AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['ACCOUNT_NUMBER', 'dbt_valid_from']) }} AS customer_key,
        ACCOUNT_NUMBER,
        CUSTOMER_AGE,
        CUSTOMER_GENDER,
        CUSTOMER_OCCUPATION,
        CUSTOMER_INCOME,
        ACCOUNT_BALANCE,
        dbt_valid_from,
        dbt_valid_to,
        CASE WHEN dbt_valid_to IS NULL THEN 1 ELSE 0 END AS is_current
    FROM {{ ref('customer_snapshot') }}  
)

SELECT *
FROM dim_with_key
