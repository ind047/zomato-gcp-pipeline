{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    SAFE_CAST(order_item_id as int64) as order_item_id,
    SAFE_CAST(order_id as int64) as order_id,
    SAFE_CAST(r_id as int64) as restaurant_id,
    SAFE_CAST(f_id as int64) as food_id,
    SAFE_CAST(REGEXP_EXTRACT(price, r'(\d+\.?\d*)') as float64) as price,
    SAFE_CAST(REGEXP_EXTRACT(quantity, r'(\d+)') as int64) as quantity,
    SAFE_CAST(REGEXP_EXTRACT(line_amount, r'(\d+\.?\d*)')   as float64) as line_amount
from {{source('raw', 'order_items_raw')}}
