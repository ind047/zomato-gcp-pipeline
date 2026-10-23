{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT 
    f_id as food_id,
    item as food_name,
    INITCAP(veg_or_non_veg) as veg_or_non_veg
from {{source('raw', 'food_raw')}}
WHERE f_id IS NOT NULL