{{ config(
    materialized='table',
    unique_key='MERCHANT_NAME'
) }}

with distinct_merchants as (
    select distinct
        MERCHANT_NAME
    from {{ ref('STG_BANKING_TRANSACTIONS') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['MERCHANT_NAME']) }} as MERCHANT_KEY,
    MERCHANT_NAME
from distinct_merchants


