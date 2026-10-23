{{ config(
    materialized='view',
    schema='staging'
) }}


SELECT 
    SAFE_CAST(id as int64) as restaurant_id,
    name as restaurant_name,
    REGEXP_EXTRACT(city, r'[^,]+$') as city,
    SAFE_CAST(NULLIF(rating, '') as float64) as rating,
    SAFE_CAST(REGEXP_EXTRACT(rating_count, r'(\d+)') as int64) as rating_count,
    SAFE_CAST(REGEXP_EXTRACT(cost, r'(\d+)') as float64) as cost_for_two,
    cuisine,
    lic_no as license_number
from {{source('raw', 'restaurants_raw')}}