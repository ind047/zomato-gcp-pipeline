SELECT 
    r.restaurant_name,
    r.city,
    r.cuisine,
    r.rating as restaurant_rating,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN is_delivered THEN o.sales_amount ELSE 0 END) AS delivered_sales,
    AVG(CASE WHEN is_delivered THEN o.customer_rating ELSE NULL END) AS avg_customer_rating,
    AVG(CASE WHEN is_delivered THEN o.delivery_time_min ELSE NULL END) AS avg_delivery_time,
    COUNTIF(NOT o.is_delivered) AS cancelled_orders
    FROM {{ref('fct_orders')}} o join {{ref('dim_restaurants')}} r on o.restaurant_id = r.restaurant_id
    Group by r.restaurant_id,r.restaurant_name,r.city, r.cuisine, r.rating