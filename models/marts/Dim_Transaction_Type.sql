{{ config(
    materialized='table',
    unique_key='TRANSACTION_TYPE'
) }}

with distinct_transaction_types as (
    select distinct
        TRANSACTION_TYPE
    from {{ ref('STG_BANKING_TRANSACTIONS') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['TRANSACTION_TYPE']) }} as TRANSACTION_TYPE_KEY,
    TRANSACTION_TYPE
from distinct_transaction_types


