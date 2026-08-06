

{{ config(
    materialized='table',
    unique_key='CITY'
) }}

with distinct_locations as (
    select distinct
        CITY
    from {{ ref('STG_BANKING_TRANSACTIONS') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['CITY']) }} as LOCATION_KEY,
    CITY
from distinct_locations
