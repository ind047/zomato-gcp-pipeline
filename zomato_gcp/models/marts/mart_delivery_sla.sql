SELECT 
    o.city,
    EXTRACT(hour from o.order_timestamp) as order_hour,
    COUNT(*) as delivered_orders,
    approx_quantiles(o.delivery_time_min, 100)[OFFSET(50)] as p50_delivery_time,
    approx_quantiles(o.delivery_time_min, 100)[OFFSET(90)] as p90_delivery_time
    FROM {{ref('fct_orders')}} o
    WHERE o.is_delivered = TRUE
    GROUP BY o.city, extract(hour from o.order_timestamp)