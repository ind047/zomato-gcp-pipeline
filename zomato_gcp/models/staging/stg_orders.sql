{{ config(
    materialized='view',
    schema='staging'
) }}

select 
    SAFE_CAST(order_id as int64) as order_id,
    SAFE_CAST(order_timestamp as timestamp) as order_timestamp,
    SAFE_CAST(order_date as date) as order_date,
    SAFE_CAST(user_id as int64) as customer_id,
    SAFE_CAST(r_id as int64) as restaurant_id,
    REGEXP_EXTRACT(restaurant_city, r'[^,]+$') as city,
    cuisine,
    SAFE_CAST(items_count as int64) as items_count,
    SAFE_CAST(sales_qty as int64) as sales_qty,
    SAFE_CAST(subtotal as float64) as subtotal,
    SAFE_CAST(discount as float64) as discount,
    SAFE_CAST(delivery_fee as float64) as delivery_fee,
    SAFE_CAST(gst as float64) as gst,
    SAFE_CAST(sales_amount as float64) as sales_amount,
    currency,
    payment_method,
    order_status,
    (order_status = 'delivered') as is_delivered,
    SAFE_CAST(customer_rating as float64) as customer_rating,
    SAFE_CAST(delivery_time_min as int64) as delivery_time_min
    from {{source('raw', 'orders_raw')}}