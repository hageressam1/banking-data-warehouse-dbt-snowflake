{{ config(
    materialized='table',
    unique_key='PAYMENT_METHOD'
) }}

with distinct_payment_methods as (

    select distinct PAYMENT_METHOD
    from {{ ref('STG_BANKING_TRANSACTIONS') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['PAYMENT_METHOD']) }} as PAYMENT_METHOD_KEY,
    PAYMENT_METHOD
from distinct_payment_methods
