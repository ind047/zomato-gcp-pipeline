{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT 
    menu_id,
    SAFE_CAST(r_id as int64) as restaurant_id,
    f_id  as food_id,
    cuisine,
    SAFE_CAST(REGEXP_EXTRACT(price, r'(\d+\.?\d*)') as float64) as price
from {{source('raw', 'menu_raw')}}