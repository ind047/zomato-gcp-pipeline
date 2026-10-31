{{
    config(
        materialized='incremental',
        unique_key='order_item_id',
        incremental_strategy='merge',
        partition_by={'field': 'order_date', 'data_type': 'date'},
        incremental_predicates=["
        DBT_INTERNAL_DEST.order_date >= date_sub(date '{{run_started_at}}', interval 3 day)"]
    )
}}

SELECT 
    oi.order_item_id,
    oi.order_id,
    o.order_date,
    o.restaurant_id,
    oi.food_id,
    oi.quantity,
    oi.price,
    oi.line_amount
from {{ref('stg_order_items')}} oi 
join {{ref('stg_orders')}} o on oi.order_id = o.order_id

{% if is_incremental() %}
where o.order_date > (select max(order_date)from {{this}})
{% endif %}