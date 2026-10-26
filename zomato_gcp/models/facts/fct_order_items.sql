{{
    config(
        materialized='incremental',
        unique_key='order_item_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    oi.order_item_id,
    oi.order_id,
    oi.food_id,
    oi.quantity,
    oi.price
from {{ref('stg_order_items')}} oi 
join {{ref('stg_orders')}} o on oi.order_id = o.order_id

{% if is_incremental() %}
where o.order_date > (select max(order_date)from {{this}})
{% endif %}