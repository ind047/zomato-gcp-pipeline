{{ config(
    materialized='view',
    schema='staging'
) }}



SELECT 
    SAFE_CAST(user_id as int64) as customer_id,
    name as customer_name,
    LOWER(TRIM(email)) as email,
    SAFE_CAST(age as int64) as age,
    gender as gender,
    SAFE_CAST(family_size as int64) as family_size,
    monthly_income as income_band
from {{source('raw', 'users_raw')}}
where user_id IS NOT NULL