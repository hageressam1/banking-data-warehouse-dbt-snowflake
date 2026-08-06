{% snapshot customer_snapshot %}
--When using strategy='check', dbt automatically creates time-tracking columns:
    {{
        config(
            target_schema='snapshots',
            unique_key='ACCOUNT_NUMBER',
            strategy='check',         
            check_cols=['ACCOUNT_BALANCE', 'CUSTOMER_INCOME', 'CUSTOMER_OCCUPATION']
        )
    }}

SELECT
    ACCOUNT_NUMBER,
    CUSTOMER_AGE,
    CUSTOMER_GENDER,
    CUSTOMER_OCCUPATION,
    CUSTOMER_INCOME,
    ACCOUNT_BALANCE
FROM {{ ref('STG_BANKING_TRANSACTIONS') }}

{% endsnapshot %}
