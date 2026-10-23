{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    SAFE_CAST(r.review_id as int64) as review_id,
    SAFE_CAST(r.order_id as int64) as order_id,
    SAFE_CAST(r.user_id as int64) as customer_id,
    SAFE_CAST(r.restaurant_id as int64) as restaurant_id,
    SAFE_CAST(r.rating as float64) as rating,
    comment,
    SAFE_CAST(r.review_date as date) as review_date,
    SAFE_CAST(res.city as string) as city
from {{source('raw', 'reviews_raw')}} r
left join {{ref('stg_restaurants')}} res
on SAFE_CAST(r.restaurant_id as int64) = res.restaurant_id
WHERE r.comment IS NOT NULL AND r.comment != ''