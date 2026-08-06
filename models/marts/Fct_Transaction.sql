{{ config(
    materialized='incremental',
    unique_key='transaction_id'
) }}

SELECT
    t.TRANSACTION_ID,
    
    -- Linking to the Date Dimension
    d.DATE_KEY AS transaction_date_key,  

    -- Linking to the Time Dimension
    tm.TIME_KEY AS transaction_time_key,

    -- Linking to other Dimensions
    c.CUSTOMER_KEY AS customer_key,
    cat.CATEGORY_KEY AS category_key,
    m.MERCHANT_KEY AS merchant_key,
    pm.PAYMENT_METHOD_KEY AS payment_method_key,
    tt.TRANSACTION_TYPE_KEY AS transaction_type_key,
    l.LOCATION_KEY AS location_key,
    
    -- Measures
    t.TRANSACTION_AMOUNT,
    t.DISCOUNT_APPLIED,
    t.LOYALTY_POINTS_EARNED,
    t.FRAUD_FLAG,
    t.TRANSACTION_STATUS
FROM {{ ref('STG_BANKING_TRANSACTIONS') }} t


-- Date Dimension
LEFT JOIN {{ ref('Dim_Date') }} d
  ON TO_NUMBER(TO_CHAR(t.TRANSACTION_DATE, 'YYYYMMDD')) = d.DATE_KEY

-- Time Dimension
LEFT JOIN {{ ref('Dim_Time') }} tm
  ON (
       EXTRACT(HOUR   FROM t.TRANSACTION_DATE) * 100
     + EXTRACT(MINUTE FROM t.TRANSACTION_DATE)
     ) = tm.TIME_KEY

-- Customer Dimension (SCD Type 2)
LEFT JOIN {{ ref('Dim_Customer') }} c
    ON t.ACCOUNT_NUMBER = c.ACCOUNT_NUMBER
       AND C.is_current =1
    -- AND t.TRANSACTION_DATE >= c.dbt_valid_from
    -- AND t.TRANSACTION_DATE < COALESCE(c.dbt_valid_to, CURRENT_TIMESTAMP())

-- Category Dimension
LEFT JOIN {{ ref('Dim_Category') }} cat
    ON t.CATEGORY = cat.CATEGORY

-- Merchant Dimension
LEFT JOIN {{ ref('Dim_Merchant') }} m
    ON t.MERCHANT_NAME = m.MERCHANT_NAME

-- Payment Method Dimension
LEFT JOIN {{ ref('Dim_PaymentMethod') }} pm
    ON t.PAYMENT_METHOD = pm.PAYMENT_METHOD

-- Transaction Type Dimension
LEFT JOIN {{ ref('Dim_Transaction_Type') }} tt
    ON t.TRANSACTION_TYPE = tt.TRANSACTION_TYPE

-- Location Dimension
LEFT JOIN {{ ref('Dim_Location') }} l
    ON t.CITY = l.CITY

{% if is_incremental() %}
WHERE t.TRANSACTION_ID NOT IN (SELECT TRANSACTION_ID FROM {{ this }})
{% endif %}

