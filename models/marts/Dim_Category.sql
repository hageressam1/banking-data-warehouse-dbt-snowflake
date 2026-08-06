
{{ config(
    materialized='table',
    unique_key='CATEGORY'
) }}

with distinct_categories as (
    select distinct
        CATEGORY
    from {{ ref('STG_BANKING_TRANSACTIONS') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['CATEGORY']) }} as CATEGORY_KEY,
    CATEGORY
from distinct_categories

