with daily as(
SELECT 
    o.city,
    d.date_day,
    count(*) as total_orders,
    sum(o.sales_amount) as gmv,
    COUNTIF(NOT o.is_delivered) as cancelled_orders
FROM {{ref('fct_orders')}}  o join {{ref('dim_date')}}  d on o.order_date = d.date_day
GROUP BY o.city, d.date_day
)
select 
    city,
    date_day,
    total_orders,
    gmv,
    gmv/total_orders as aov,
    cancelled_orders,
    cancelled_orders/total_orders as cancellation_rate
from daily
