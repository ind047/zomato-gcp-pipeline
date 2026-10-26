{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge',
        filter='order_date > (select min(date_day) from {{this}})'
    )
}}

SELECT 
    order_id,
    order_timestamp,
    order_date,
    customer_id,
    restaurant_id,
    city, cuisine,
    items_count,
    sales_qty,
    subtotal,
    discount,
    delivery_fee,
    gst,
    sales_amount,
    currency,
    payment_method,
    order_status,
    is_delivered,
    customer_rating,
    delivery_time_min
from {{ref('stg_orders')}}

{% if is_incremental() %}
where order_date > (select max(order_date)from {{this}})
{% endif %}